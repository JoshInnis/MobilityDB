/***********************************************************************
 *
 * This MobilityDB code is provided under The PostgreSQL License.
 * Copyright (c) 2016-2023, Université libre de Bruxelles and MobilityDB
 * contributors
 *
 * MobilityDB includes portions of PostGIS version 3 source code released
 * under the GNU General Public License (GPLv2 or later).
 * Copyright (c) 2001-2023, PostGIS contributors
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without a written
 * agreement is hereby granted, provided that the above copyright notice and
 * this paragraph and the following two paragraphs appear in all copies.
 *
 * IN NO EVENT SHALL UNIVERSITE LIBRE DE BRUXELLES BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING
 * LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION,
 * EVEN IF UNIVERSITE LIBRE DE BRUXELLES HAS BEEN ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 * UNIVERSITE LIBRE DE BRUXELLES SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS ON
 * AN "AS IS" BASIS, AND UNIVERSITE LIBRE DE BRUXELLES HAS NO OBLIGATIONS TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS. 
 *
 *****************************************************************************/

/**
 * @file
 * @brief Spatial restriction functions for temporal points.
 */

#include "point/tpoint_spatialfuncs.h"

/* C */
#include <assert.h>
/* PostgreSQL */
#include <utils/float.h>
/* PostGIS */
#include <liblwgeom.h>
#include <liblwgeom_internal.h>
#include <lwgeodetic.h>
/* MEOS */
#include <meos.h>
#include <meos_internal.h>
#include "general/pg_types.h"
#include "general/lifting.h"
#include "general/temporaltypes.h"
#include "general/tnumber_mathfuncs.h"
#include "general/type_util.h"
#include "point/tpoint_spatialrels.h"

/*****************************************************************************
 * Force a temporal point to be 2D
 *****************************************************************************/

/**
 * @brief For a point to be in 2D
 */
static Datum
point_force2d(Datum point, Datum srid)
{
  const POINT2D *p = DATUM_POINT2D_P(point);
  GSERIALIZED *gs = gspoint_make(p->x, p->y, 0.0, false, false,
    DatumGetInt32(srid));
  return PointerGetDatum(gs);
}

/**
 * @ingroup libmeos_temporal_spatial_transf
 * @brief Force a temporal point to be in 2D.
 * @param[in] temp Temporal point
 * @pre The temporal point has Z dimension
 */
static Temporal *
tpoint_force2d(const Temporal *temp)
{
  assert(tgeo_type(temp->temptype));
  assert(MEOS_FLAGS_GET_Z(temp->flags));
  /* We only need to fill these parameters for tfunc_temporal */
  LiftedFunctionInfo lfinfo;
  memset(&lfinfo, 0, sizeof(LiftedFunctionInfo));
  lfinfo.func = (varfunc) &point_force2d;
  lfinfo.numparam = 1;
  int32 srid = tpoint_srid(temp);
  lfinfo.param[0] = Int32GetDatum(srid);
  lfinfo.restype = T_TGEOMPOINT;
  lfinfo.tpfunc_base = NULL;
  lfinfo.tpfunc = NULL;
  Temporal *result = tfunc_temporal(temp, &lfinfo);
  return result;
}

/*****************************************************************************
 * Functions computing the intersection of two segments derived from PostGIS
 * The seg2d_intersection function is a modified version of the PostGIS
 * lw_segment_intersects function and also returns the intersection point
 * in case the two segments intersect at equal endpoints.
 * The intersection point is required in tpointseq_linear_find_splits
 * only for this intersection type (MEOS_SEG_TOUCH_END).
 *****************************************************************************/

/*
 * The possible ways a pair of segments can interact.
 * Returned by the function seg2d_intersection
 */
enum
{
  MEOS_SEG_NO_INTERSECTION,  /* Segments do not intersect */
  MEOS_SEG_OVERLAP,          /* Segments overlap */
  MEOS_SEG_CROSS,            /* Segments cross */
  MEOS_SEG_TOUCH_END,        /* Segments touch in two equal enpoints */
  MEOS_SEG_TOUCH,            /* Segments touch without equal enpoints */
} MEOS_SEG_INTER_TYPE;

/**
 * @brief Find the UNIQUE point of intersection p between two closed
 * collinear segments ab and cd. Return p and a MEOS_SEG_INTER_TYPE value.
 * @note If the segments overlap no point is returned since they
 * can be an infinite number of them.
 * @pre This function is called after verifying that the points are
 * collinear and that their bounding boxes intersect.
 */
static int
parseg2d_intersection(const POINT2D *a, const POINT2D *b, const POINT2D *c,
  const POINT2D *d, POINT2D *p)
{
  /* Compute the intersection of the bounding boxes */
  double xmin = Max(Min(a->x, b->x), Min(c->x, d->x));
  double xmax = Min(Max(a->x, b->x), Max(c->x, d->x));
  double ymin = Max(Min(a->y, b->y), Min(c->y, d->y));
  double ymax = Min(Max(a->y, b->y), Max(c->y, d->y));
  /* If the intersection of the bounding boxes is not a point */
  if (xmin < xmax || ymin < ymax )
    return MEOS_SEG_OVERLAP;
  /* We are sure that the segments touch each other */
  if ((b->x == c->x && b->y == c->y) ||
      (b->x == d->x && b->y == d->y))
  {
    p->x = b->x;
    p->y = b->y;
    return MEOS_SEG_TOUCH_END;
  }
  if ((a->x == c->x && a->y == c->y) ||
      (a->x == d->x && a->y == d->y))
  {
    p->x = a->x;
    p->y = a->y;
    return MEOS_SEG_TOUCH_END;
  }
  /* We should never arrive here since this function is called after verifying
   * that the bounding boxes of the segments intersect */
  return MEOS_SEG_NO_INTERSECTION;
}

/**
 * @brief Determines the side of segment P where Q lies
 * Return -1  if point Q is left of segment P
 * Return  1  if point Q is right of segment P
 * Return  0  if point Q in on segment P
 * @note adapted from lw_segment_side to take into account precision errors
 */
static int
seg2d_side(const POINT2D *p1, const POINT2D *p2, const POINT2D *q)
{
  double side = ( (q->x - p1->x) * (p2->y - p1->y) -
    (p2->x - p1->x) * (q->y - p1->y) );
  if (fabs(side) < MEOS_EPSILON)
    return 0;
  else
    return SIGNUM(side);
}

/**
 * @brief Function derived from PostGIS file lwalgorithm.c since it is declared
 * static
 */
static bool
lw_seg_interact(const POINT2D *p1, const POINT2D *p2, const POINT2D *q1,
  const POINT2D *q2)
{
  double minq = FP_MIN(q1->x, q2->x);
  double maxq = FP_MAX(q1->x, q2->x);
  double minp = FP_MIN(p1->x, p2->x);
  double maxp = FP_MAX(p1->x, p2->x);

  if (FP_GT(minp, maxq) || FP_LT(maxp, minq))
    return false;

  minq = FP_MIN(q1->y, q2->y);
  maxq = FP_MAX(q1->y, q2->y);
  minp = FP_MIN(p1->y, p2->y);
  maxp = FP_MAX(p1->y, p2->y);

  if (FP_GT(minp,maxq) || FP_LT(maxp,minq))
    return false;

  return true;
}

/**
 * @brief Find the UNIQUE point of intersection p between two closed segments
 * ab and cd. Return p and a MEOS_SEG_INTER_TYPE value.
 * @note Currently, the function only computes p if the result value is
 * MEOS_SEG_TOUCH_END, since the return value is never used in other cases.
 * @note If the segments overlap no point is returned since they can be an
 * infinite number of them.
 */
static int
seg2d_intersection(const POINT2D *a, const POINT2D *b, const POINT2D *c,
  const POINT2D *d, POINT2D *p)
{
  /* assume the following names: p = Segment(a, b), q = Segment(c, d) */
  int pq1, pq2, qp1, qp2;

  /* No envelope interaction => we are done. */
  if (! lw_seg_interact(a, b, c, d))
    return MEOS_SEG_NO_INTERSECTION;

  /* Are the start and end points of q on the same side of p? */
  pq1 = seg2d_side(a, b, c);
  pq2 = seg2d_side(a, b, d);
  if ((pq1 > 0 && pq2 > 0) || (pq1 < 0 && pq2 < 0))
    return MEOS_SEG_NO_INTERSECTION;

  /* Are the start and end points of p on the same side of q? */
  qp1 = seg2d_side(c, d, a);
  qp2 = seg2d_side(c, d, b);
  if ((qp1 > 0 && qp2 > 0) || (qp1 < 0 && qp2 < 0))
    return MEOS_SEG_NO_INTERSECTION;

  /* Nobody is on one side or another? Must be colinear. */
  if (pq1 == 0 && pq2 == 0 && qp1 == 0 && qp2 == 0)
    return parseg2d_intersection(a, b, c, d, p);

  /* Check if the intersection is an endpoint */
  if (pq1 == 0 || pq2 == 0 || qp1 == 0 || qp2 == 0)
  {
    /* Check for two equal endpoints */
    if ((b->x == c->x && b->y == c->y) ||
        (b->x == d->x && b->y == d->y))
    {
      p->x = b->x;
      p->y = b->y;
      return MEOS_SEG_TOUCH_END;
    }
    if ((a->x == c->x && a->y == c->y) ||
        (a->x == d->x && a->y == d->y))
    {
      p->x = a->x;
      p->y = a->y;
      return MEOS_SEG_TOUCH_END;
    }

    /* The intersection is inside one of the segments
     * note: p is not compute for this type of intersection */
    return MEOS_SEG_TOUCH;
  }

  /* Crossing
   * note: p is not compute for this type of intersection */
  return MEOS_SEG_CROSS;
}

/*****************************************************************************
 * Non self-intersecting (a.k.a. simple) functions
 *****************************************************************************/

/**
 * @brief Split a temporal point sequence with discrete or step
 * interpolation into an array of non self-intersecting fragments
 * @param[in] seq Temporal point
 * @param[out] count Number of elements in the resulting array
 * @result Boolean array determining the instant numbers at which the
 * discrete sequence must be split
 * @pre The temporal point has at least 2 instants
 */
static bool *
tpointseq_discstep_find_splits(const TSequence *seq, int *count)
{
  assert(! MEOS_FLAGS_GET_LINEAR(seq->flags));
  assert(seq->count > 1);
  /* bitarr is an array of bool for collecting the splits */
  bool *bitarr = palloc0(sizeof(bool) * seq->count);
  int numsplits = 0;
  int start = 0, end = seq->count - 1;
  while (start < end)
  {
    /* Find intersections in the piece defined by start and end in a
     * breadth-first search */
    int j = start, k = start + 1;
    Datum value1 = tinstant_value(TSEQUENCE_INST_N(seq, j));
    Datum value2 = tinstant_value(TSEQUENCE_INST_N(seq, k));
    while (true)
    {
      if (datum_point_eq(value1, value2))
      {
        /* Set the new start */
        bitarr[k] = true;
        numsplits++;
        start = k;
        break;
      }
      if (j < k - 1)
      {
        j++;
        value1 = tinstant_value(TSEQUENCE_INST_N(seq, j));
      }
      else
      {
        k++;
        if (k > end)
          break;
        j = start;
        value1 = tinstant_value(TSEQUENCE_INST_N(seq, j));
        value2 = tinstant_value(TSEQUENCE_INST_N(seq, k));
      }
    }
    if (k > end)
      break;
  }
  *count = numsplits;
  return bitarr;
}

/**
 * @brief Split a temporal point sequence with linear interpolation into an
 * array of non self-intersecting fragments.
 * @note The function works only on 2D even if the input points are in 3D
 * @param[in] seq Temporal point
 * @param[out] count Number of elements in the resulting array
 * @result Boolean array determining the instant numbers at which the
 * sequence must be split
 * @pre The input sequence has at least 3 instants
 */
static bool *
tpointseq_linear_find_splits(const TSequence *seq, int *count)
{
  assert(seq->count >= 2);
 /* points is an array of points in the sequence */
  POINT2D *points = palloc0(sizeof(POINT2D) * seq->count);
  /* bitarr is an array of bool for collecting the splits */
  bool *bitarr = palloc0(sizeof(bool) * seq->count);
  points[0] = datum_point2d(tinstant_value(TSEQUENCE_INST_N(seq, 0)));
  int numsplits = 0;
  for (int i = 1; i < seq->count; i++)
  {
    points[i] = datum_point2d(tinstant_value(TSEQUENCE_INST_N(seq, i)));
    /* If stationary segment we need to split the sequence */
    if (points[i - 1].x == points[i].x && points[i - 1].y == points[i].y)
    {
      if (i > 1 && ! bitarr[i - 1])
      {
        bitarr[i - 1] = true;
        numsplits++;
      }
      if (i < seq->count - 1)
      {
        bitarr[i] = true;
        numsplits++;
      }
    }
  }

  /* Loop for every split due to stationary segments while adding
   * additional splits due to intersecting segments */
  int start = 0;
  while (start < seq->count - 2)
  {
    int end = start + 1;
    while (end < seq->count - 1 && ! bitarr[end])
      end++;
    if (end == start + 1)
    {
      start = end;
      continue;
    }
    /* Find intersections in the piece defined by start and end in a
     * breadth-first search */
    int i = start, j = start + 1;
    while (j < end)
    {
      /* If the bounding boxes of the segments intersect */
      if (lw_seg_interact(&points[i], &points[i + 1], &points[j],
        &points[j + 1]))
      {
        /* Candidate for intersection */
        POINT2D p = { 0 }; /* make compiler quiet */
        int intertype = seg2d_intersection(&points[i], &points[i + 1],
          &points[j], &points[j + 1], &p);
        if (intertype > 0 &&
          /* Exclude the case when two consecutive segments that
           * necessarily touch each other in their common point */
          (intertype != MEOS_SEG_TOUCH_END || j != i + 1 ||
           p.x != points[j].x || p.y != points[j].y))
        {
          /* Set the new end */
          end = j;
          bitarr[end] = true;
          numsplits++;
          break;
        }
      }
      if (i < j - 1)
        i++;
      else
      {
        j++;
        i = start;
      }
    }
    /* Process the next split */
    start = end;
  }
  pfree(points);
  *count = numsplits;
  return bitarr;
}

/*****************************************************************************
 * Functions for testing whether a temporal point is simple and for spliting
 * a temporal point into an array of temporal points that are simple.
 * A temporal point is simple if all its components are non self-intersecting.
 * - a temporal instant point is simple
 * - a temporal discrete sequence point is simple if it is non self-intersecting
 * - a temporal sequence point is simple if it is non self-intersecting and
 *   do not have stationary segments
 * - a temporal sequence set point is simple if every composing sequence is
 *   simple even if two composing sequences intersect
 *****************************************************************************/

/**
 * @brief Return true if a temporal point does not self-intersect.
 * @param[in] seq Temporal point
 * @pre The temporal point sequence has discrete or step interpolation
 */
static bool
tpointseq_discstep_is_simple(const TSequence *seq)
{
  assert(seq->count > 1);
  Datum *points = palloc(sizeof(Datum) * seq->count);
  for (int i = 0; i < seq->count; i++)
  {
    const TInstant *inst = TSEQUENCE_INST_N(seq, i);
    points[i] = tinstant_value(inst);
  }
  datumarr_sort(points, seq->count, temptype_basetype(seq->temptype));
  bool found = false;
  for (int i = 1; i < seq->count; i++)
  {
    if (datum_point_eq(points[i - 1], points[i]))
    {
      found = true;
      break;
    }
  }
  pfree(points);
  return ! found;
}

/**
 * @ingroup libmeos_internal_temporal_spatial_accessor
 * @brief Return true if a temporal point does not self-intersect.
 * @param[in] seq Temporal point
 * @sqlfunc isSimple();
 */
bool
tpointseq_is_simple(const TSequence *seq)
{
  if (seq->count == 1)
    return true;

  if (! MEOS_FLAGS_GET_LINEAR(seq->flags))
    return tpointseq_discstep_is_simple(seq);

  int numsplits;
  bool *splits = tpointseq_linear_find_splits(seq, &numsplits);
  pfree(splits);
  return (numsplits == 0);
}

/**
 * @ingroup libmeos_internal_temporal_spatial_accessor
 * @brief Return true if a temporal point does not self-intersect.
 * @param[in] ss Temporal point
 * @sqlfunc isSimple()
 */
bool
tpointseqset_is_simple(const TSequenceSet *ss)
{
  bool result = true;
  for (int i = 0; i < ss->count; i++)
  {
    const TSequence *seq = TSEQUENCESET_SEQ_N(ss, i);
    result &= tpointseq_is_simple(seq);
    if (! result)
      break;
  }
  return result;
}

/**
 * @ingroup libmeos_temporal_spatial_accessor
 * @brief Return true if a temporal point does not self-intersect.
 * @sqlfunc isSimple()
 */
bool
tpoint_is_simple(const Temporal *temp)
{
  bool result;
  assert(temptype_subtype(temp->subtype));
  if (temp->subtype == TINSTANT)
    result = true;
  else if (temp->subtype == TSEQUENCE)
    result = tpointseq_is_simple((TSequence *) temp);
  else /* temp->subtype == TSEQUENCESET */
    result = tpointseqset_is_simple((TSequenceSet *) temp);
  return result;
}

/*****************************************************************************/

/**
 * @brief Split a temporal discrete sequence point into an array of non
 * self-intersecting fragments.
 * @param[in] seq Temporal point
 * @param[in] splits Bool array stating the splits
 * @param[in] count Number of elements in the resulting array
 * @pre The discrete sequence has at least two instants
 */
static TSequence **
tpointseq_disc_split(const TSequence *seq, bool *splits, int count)
{
  assert(seq->count > 1);
  const TInstant **instants = palloc(sizeof(TInstant *) * seq->count);
  TSequence **result = palloc(sizeof(TSequence *) * count);
  /* Create the splits */
  int start = 0, k = 0;
  while (start < seq->count)
  {
    int end = start + 1;
    while (end < seq->count && ! splits[end])
      end++;
    /* Construct piece from start to end */
    for (int j = 0; j < end - start; j++)
      instants[j] = TSEQUENCE_INST_N(seq, j + start);
    result[k++] = tsequence_make(instants, end - start, true, true,
      DISCRETE, NORMALIZE_NO);
    /* Continue with the next split */
    start = end;
  }
  pfree(instants);
  return result;
}

/**
 * @brief Split a temporal point into an array of non self-intersecting
 * fragments
 * @param[in] seq Temporal sequence point
 * @param[in] splits Bool array stating the splits
 * @param[in] count Number of elements in the resulting array
 * @note This function is called for each sequence of a sequence set
 */
static TSequence **
tpointseq_cont_split(const TSequence *seq, bool *splits, int count)
{
  assert(seq->count > 2);
  bool linear = MEOS_FLAGS_GET_LINEAR(seq->flags);
  TInstant **instants = palloc(sizeof(TInstant *) * seq->count);
  TSequence **result = palloc(sizeof(TSequence *) * count);
  /* Create the splits */
  int start = 0, k = 0;
  while (start < seq->count - 1)
  {
    int end = start + 1;
    while (end < seq->count - 1 && ! splits[end])
      end++;
    /* Construct fragment from start to end inclusive */
    for (int j = 0; j <= end - start; j++)
      instants[j] = (TInstant *) TSEQUENCE_INST_N(seq, j + start);
    bool lower_inc1 = (start == 0) ? seq->period.lower_inc : true;
    bool upper_inc1 = (end == seq->count - 1) ?
      seq->period.upper_inc && ! splits[seq->count - 1] : false;
    /* The last two values of sequences with step interpolation and
     * exclusive upper bound must be equal */
    bool tofree = false;
    if (! linear && ! upper_inc1 &&
      ! datum_point_eq(tinstant_value(instants[end - start - 1]),
      tinstant_value(instants[end - start])))
    {
      Datum value = tinstant_value(instants[end - start - 1]);
      TimestampTz t = (instants[end - start])->t;
      instants[end - start] = tinstant_make(value, seq->temptype, t);
      tofree = true;
      upper_inc1 = false;
    }
    result[k++] = tsequence_make((const TInstant **) instants, end - start + 1,
      lower_inc1, upper_inc1, linear ? LINEAR : STEP, NORMALIZE_NO);
    if (tofree)
      /* Free the last instant created for the step interpolation */
      pfree(instants[end - start]);
    /* Continue with the next split */
    start = end;
  }
  if (k < count)
  {
    /* Construct last fragment containing the last instant of sequence */
    instants[0] = (TInstant *) TSEQUENCE_INST_N(seq, seq->count - 1);
    result[k++] = tsequence_make((const TInstant **) instants,
      seq->count - start, true, seq->period.upper_inc,
      linear, NORMALIZE_NO);
  }
  pfree(instants);
  return result;
}

/**
 * @ingroup libmeos_internal_temporal_spatial_transf
 * @brief Split a temporal sequence point into an array of non
 * self-intersecting fragments.
 * @param[in] seq Temporal sequence point
 * @param[out] count Number of elements in the resulting array
 * @note This function is called for each sequence of a sequence set
 * @sqlfunc makeSimple()
 */
TSequence **
tpointseq_make_simple(const TSequence *seq, int *count)
{
  interpType interp = MEOS_FLAGS_GET_INTERP(seq->flags);
  TSequence **result;
  /* Special cases when the input sequence has 1 or 2 instants */
  if ((interp == DISCRETE && seq->count == 1) ||
      (interp != DISCRETE && seq->count <= 2))
  {
    result = palloc(sizeof(TSequence *));
    result[0] = tsequence_copy(seq);
    *count = 1;
    return result;
  }

  int numsplits;
  bool *splits = (interp == LINEAR) ?
    tpointseq_linear_find_splits(seq, &numsplits) :
    tpointseq_discstep_find_splits(seq, &numsplits);
  if (numsplits == 0)
  {
    result = palloc(sizeof(TSequence *));
    result[0] = tsequence_copy(seq);
    pfree(splits);
    *count = 1;
    return result;
  }

  result = (interp == DISCRETE) ?
    tpointseq_disc_split(seq, splits, numsplits + 1) :
    tpointseq_cont_split(seq, splits, numsplits + 1);
  pfree(splits);
  *count = numsplits + 1;
  return result;
}

/**
 * @ingroup libmeos_internal_temporal_spatial_transf
 * @brief Split a temporal sequence set point into an array of non
 * self-intersecting fragments.
 * @param[in] ss Temporal sequence set point
 * @param[out] count Number of elements in the output array
 * @sqlfunc makeSimple()
 */
TSequence **
tpointseqset_make_simple(const TSequenceSet *ss, int *count)
{
  /* Singleton sequence set */
  if (ss->count == 1)
    return tpointseq_make_simple(TSEQUENCESET_SEQ_N(ss, 0), count);

  /* General case */
  TSequence ***sequences = palloc0(sizeof(TSequence **) * ss->count);
  int *countseqs = palloc0(sizeof(int) * ss->count);
  int totalcount = 0;
  for (int i = 0; i < ss->count; i++)
  {
    const TSequence *seq = TSEQUENCESET_SEQ_N(ss, i);
    sequences[i] = tpointseq_make_simple(seq, &countseqs[i]);
    totalcount += countseqs[i];
  }
  assert(totalcount > 0);
  *count = totalcount;
  return tseqarr2_to_tseqarr(sequences, countseqs, ss->count, totalcount);
}

/**
 * @ingroup libmeos_temporal_spatial_transf
 * @brief Split a temporal point into an array of non self-intersecting
 * fragments.
 * @param[in] temp Temporal point
 * @param[out] count Number of elements in the output array
 * @see tpointseq_make_simple
 * @see tpointseqset_make_simple
 * @sqlfunc makeSimple()
 */
Temporal **
tpoint_make_simple(const Temporal *temp, int *count)
{
  Temporal **result;
  assert(temptype_subtype(temp->subtype));
  if (temp->subtype == TINSTANT)
  {
    result = palloc0(sizeof(TInstant *));
    result[0] = (Temporal *) tinstant_copy((TInstant *) temp);
    *count = 1;
  }
  else if (temp->subtype == TSEQUENCE)
    result = (Temporal **) tpointseq_make_simple((TSequence *) temp, count);
  else /* temp->subtype == TSEQUENCESET */
    result = (Temporal **) tpointseqset_make_simple((TSequenceSet *) temp, count);
  return result;
}

/*****************************************************************************
 * Restriction functions for geometry and possible a Z span and a time period
 * N.B. In the current PostGIS version there is no true ST_Intersection
 * function for geography, it is implemented as ST_DWithin with tolerance 0
 *****************************************************************************/

/**
 * @brief Restrict a temporal point instant to (the complement of) a
 * spatiotemporal box (iteration function).
 * @pre The arguments have the same SRID, the geometry is 2D and is not empty.
 * This is verified in #tpoint_restrict_geom_time
 */
static bool
tpointinst_restrict_geom_time_iter(const TInstant *inst, const GSERIALIZED *gs,
  const Span *zspan, const Span *period, bool atfunc)
{
  /* Restrict to the T dimension */
  if (period && ! contains_span_value(period, TimestampTzGetDatum(inst->t),
      T_TIMESTAMPTZ))
    return ! atfunc;

  /* Restrict to the Z dimension */
  Datum value = tinstant_value(inst);
  if (zspan)
  {
    const POINT3DZ *p = DATUM_POINT3DZ_P(value);
    if (! contains_span_value(zspan, Float8GetDatum(p->z), T_FLOAT8))
      return ! atfunc;
  }

  /* Restrict to the XY dimension */
  if (! DatumGetBool(geom_intersects2d(value, PointerGetDatum(gs))))
    return ! atfunc;

  /* Point is inside the region */
  return atfunc;
}

/**
 * @ingroup libmeos_internal_temporal_restrict
 * @brief Restrict a temporal point instant to (the complement of) a geometry
 * and possibly a Z span and a period.
 * @param[in] inst Temporal point
 * @param[in] gs Geometry
 * @param[in] zspan Span of values to restrict the Z dimension
 * @param[in] period Period to restrict the T dimension
 * @param[in] atfunc True if the restriction is at, false for minus
 * @sqlfunc atGeometry(), minusGeometry(), atGeometryTime(), minusGeometryTime()
 */
TInstant *
tpointinst_restrict_geom_time(const TInstant *inst, const GSERIALIZED *gs,
  const Span *zspan, const Span *period, bool atfunc)
{
  if (tpointinst_restrict_geom_time_iter(inst, gs, zspan, period, atfunc))
    return tinstant_copy(inst);
  return NULL;
}

/**
 * @ingroup libmeos_internal_temporal_restrict
 * @brief Restrict a temporal point discrete sequence to (the complement of) a
 * geometry and possibly a Z span and a period.
 * @param[in] seq Temporal point
 * @param[in] gs Geometry
 * @param[in] zspan Span of values to restrict the Z dimension
 * @param[in] period Period to restrict the T dimension
 * @param[in] atfunc True if the restriction is at, false for minus
 * @sqlfunc atGeometry(), minusGeometry(), atGeometryTime(), minusGeometryTime()
 */
TSequence *
tpointseq_disc_restrict_geom_time(const TSequence *seq, const GSERIALIZED *gs,
  const Span *zspan, const Span *period, bool atfunc)
{
  assert(MEOS_FLAGS_GET_INTERP(seq->flags) == DISCRETE);
  /* Instantaneous sequence */
  if (seq->count == 1)
  {
    const TInstant *inst = TSEQUENCE_INST_N(seq, 0);
    if (tpointinst_restrict_geom_time_iter(inst, gs, zspan, period, atfunc))
      return tsequence_copy(seq);
    return NULL;
  }

  /* General case */
  const TInstant **instants = palloc(sizeof(TInstant *) * seq->count);
  int k = 0;
  for (int i = 0; i < seq->count; i++)
  {
    const TInstant *inst = TSEQUENCE_INST_N(seq, i);
    if (tpointinst_restrict_geom_time_iter(inst, gs, zspan, period, atfunc))
      instants[k++] = inst;
  }
  TSequence *result = NULL;
  if (k > 0)
    result = tsequence_make(instants, k, true, true, DISCRETE, NORMALIZE_NO);
  pfree(instants);
  return result;
}

/**
 * @brief Restrict a temporal sequence point with step interpolation to a
 * geometry and possibly a Z span and a period.
 */
static TSequence **
tpointseq_step_at_geom_time_iter(const TSequence *seq, const GSERIALIZED *gs,
  const Span *zspan, const Span *period, int *count)
{
  assert(MEOS_FLAGS_GET_INTERP(seq->flags) == STEP);
  /* Compute the time span of the result if period is given */
  Span timespan;
  bool found;
  if (period)
  {
    found = inter_span_span(&seq->period, period, &timespan);
    if (! found)
    {
      *count = 0;
      return NULL;
    }
  }

  bool lower_inc;
  TSequence **result = palloc(sizeof(TSequence *) * seq->count);
  TInstant **instants = palloc(sizeof(TInstant *) * seq->count);
  TimestampTz start = DatumGetTimestampTz(seq->period.lower);
  int k = 0, l = 0; /* k: number of instants, l: number of sequences */
  for (int i = 0; i < seq->count; i++)
  {
    const TInstant *inst = TSEQUENCE_INST_N(seq, i);
    if (tpointinst_restrict_geom_time_iter(inst, gs, zspan, period, REST_AT))
      instants[k++] = (TInstant *) inst;
    else
    {
      if (k > 0)
      {
        /* Continue the last instant of the sequence until the time of inst2
         * projected to the period (if any) */
        Datum value = tinstant_value(instants[k - 1]);
        bool tofree = false;
        bool upper_inc = false;
        if (period)
        {
          Span extend, inter;
          span_set(TimestampTzGetDatum(instants[k - 1]->t),
            TimestampTzGetDatum(inst->t), true, false, T_TIMESTAMPTZ, &extend);
          found = inter_span_span(&timespan, &extend, &inter);
          if (found)
          {
            if (! datum_eq(inter.lower, inter.upper, T_TIMESTAMPTZ))
            {
              instants[k++] = tinstant_make(value, seq->temptype,
                DatumGetTimestampTz(inter.upper));
              tofree = true;
            }
            else
              upper_inc = true;
          }
        }
        else
        {
          /* Continue the last instant of the sequence until the time of inst2 */
          instants[k++] = tinstant_make(value, seq->temptype, inst->t);
          tofree = true;
        }
        lower_inc = (instants[0]->t == start) ? seq->period.lower_inc : true;
        result[l++] = tsequence_make((const TInstant **) instants, k,
          lower_inc, upper_inc, STEP, NORMALIZE_NO);
        if (tofree)
          pfree(instants[k - 1]);
        k = 0;
      }
    }
  }
  /* Add a last sequence with the remaining instants */
  if (k > 0)
  {
    lower_inc = (instants[0]->t == start) ? seq->period.lower_inc : true;
    TimestampTz end = DatumGetTimestampTz(seq->period.upper);
    bool upper_inc = (instants[k - 1]->t == end) ?
      seq->period.upper_inc : false;
    result[l++] = tsequence_make((const TInstant **) instants, k, lower_inc,
      upper_inc, STEP, NORMALIZE_NO);
  }
  /* Clean up and return */
  pfree(instants);
  *count = l;
  if (l == 0)
  {
    pfree(result);
    return NULL;
  }
  return result;
}

/**
 * @ingroup libmeos_internal_temporal_restrict
 * @brief Restrict a temporal sequence point with step interpolation to a
 * geometry and possibly a Z span and a period.
 * @param[in] seq Temporal point
 * @param[in] gs Geometry
 * @param[in] zspan Span of values to restrict the Z dimension
 * @param[in] period Period to restrict the T dimension
 * @param[in] atfunc True if the restriction is at, false for minus
 * @note The function computes the "at" restriction on all dimensions and if
 * the requested restriction is "minus", then it computes the complement of the
 * "at" restriction with respect to the time dimension.
 * @sqlfunc atGeometry(), minusGeometry(), atGeometryTime(), minusGeometryTime()
 */
TSequenceSet *
tpointseq_step_restrict_geom_time(const TSequence *seq,
  const GSERIALIZED *gs, const Span *zspan, const Span *period, bool atfunc)
{
  assert(MEOS_FLAGS_GET_INTERP(seq->flags) == STEP);
  /* Instantaneous sequence */
  if (seq->count == 1)
  {
    const TInstant *inst = TSEQUENCE_INST_N(seq, 0);
    if (tpointinst_restrict_geom_time_iter(inst, gs, zspan, period, atfunc))
      return tsequence_to_tsequenceset(seq);
    return NULL;
  }

  /* General case */
  int count;
  TSequence **sequences = tpointseq_step_at_geom_time_iter(seq, gs, zspan,
    period, &count);
  /* Return if the computation of "at" is empty */
  if (count == 0)
    return atfunc ? NULL : tsequence_to_tsequenceset(seq);

  /* Construct the result for "at" restriction */
  TSequenceSet *result_at = tsequenceset_make_free(sequences, count,
    NORMALIZE_NO);
  /* If "at" restriction, return */
  if (atfunc)
    return result_at;

  /* If "minus" restriction, compute the complement wrt time */
  SpanSet *ps = tsequenceset_time(result_at);
  TSequenceSet *result = tcontseq_restrict_periodset(seq, ps, atfunc);
  pfree(ps);
  pfree(result_at);
  return result;
}

/*****************************************************************************/

/**
 * @brief Return the timestamp at which a segment of a temporal point takes a
 * base value
 *
 * This function must take into account the roundoff errors and thus it uses
 * the datum_point_eq_eps for comparing two values so the coordinates of the
 * values may differ by MEOS_EPSILON.
 *
 * @param[in] inst1,inst2 Temporal values
 * @param[in] value Base value
 * @param[out] t Timestamp
 * @result Return true if the point is found in the temporal point
 * @pre The segment is not constant and has linear interpolation
 * @note The resulting timestamp may be at an exclusive bound
 */
static bool
tpointsegm_timestamp_at_value1(const TInstant *inst1, const TInstant *inst2,
  Datum value, TimestampTz *t)
{
  Datum value1 = tinstant_value(inst1);
  Datum value2 = tinstant_value(inst2);
  /* Is the lower bound the answer? */
  bool result = true;
  if (datum_point_eq(value1, value))
    *t = inst1->t;
  /* Is the upper bound the answer? */
  else if (datum_point_eq(value2, value))
    *t = inst2->t;
  else
  {
    double dist;
    double fraction = (double) geosegm_locate_point(value1, value2, value, &dist);
    if (fabs(dist) >= MEOS_EPSILON)
      result = false;
    else
    {
      double duration = (double) (inst2->t - inst1->t);
      *t = inst1->t + (TimestampTz) (duration * fraction);
    }
  }
  return result;
}

/**
 * @brief Return the timestamp at which a temporal point sequence is equal to a
 * point
 *
 * This function is called by the #tpointseq_interperiods function while
 * computing atGeometry to find the timestamp at which an intersection point
 * found by PostGIS is located. This function differs from function
 * #tpointsegm_intersection_value in particular since the latter is used for
 * finding crossings during synchronization and thus it is required that the
 * timestamp in strictly between the timestamps of a segment.
 *
 * @param[in] seq Temporal point sequence
 * @param[in] value Base value
 * @param[out] t Timestamp
 * @result Return true if the point is found in the temporal point
 * @pre The point is known to belong to the temporal sequence (taking into
 * account roundoff errors), the temporal sequence has linear interpolation,
 * and is simple
 * @note The resulting timestamp may be at an exclusive bound
 */
static bool
tpointseq_timestamp_at_value(const TSequence *seq, Datum value,
  TimestampTz *t)
{
  const TInstant *inst1 = TSEQUENCE_INST_N(seq, 0);
  for (int i = 1; i < seq->count; i++)
  {
    const TInstant *inst2 = TSEQUENCE_INST_N(seq, i);
    /* We are sure that the segment is not constant since the
     * sequence is simple */
    if (tpointsegm_timestamp_at_value1(inst1, inst2, value, t))
      return true;
    inst1 = inst2;
  }
  /* We should never arrive here */
  elog(ERROR, "The value has not been found due to roundoff errors");
  return false;
}

/**
 * @brief Get the periods at which a temporal sequence point with linear
 * interpolation intersects a geometry
 * @param[in] seq Temporal point
 * @param[in] gsinter Intersection of the temporal point and the geometry
 * @param[out] count Number of elements in the resulting array
 * @pre The temporal sequence is simple, that is, non self-intersecting and
 * the intersecting geometry is non empty
 */
Span *
tpointseq_interperiods(const TSequence *seq, GSERIALIZED *gsinter, int *count)
{
  /* The temporal sequence has at least 2 instants since
   * (1) the test for instantaneous full sequence is done in the calling function
   * (2) the simple components of a non self-intersecting sequence have at least
   *     two instants */
  assert(seq->count > 1);
  const TInstant *start = TSEQUENCE_INST_N(seq, 0);
  const TInstant *end = TSEQUENCE_INST_N(seq, seq->count - 1);
  Span *result;

  /* If the sequence is stationary the whole sequence intersects with the
   * geometry since gsinter is not empty */
  if (seq->count == 2 &&
    datum_point_eq(tinstant_value(start), tinstant_value(end)))
  {
    result = palloc(sizeof(Span));
    result[0] = seq->period;
    *count = 1;
    return result;
  }

  /* General case */
  LWGEOM *lwgeom_inter = lwgeom_from_gserialized(gsinter);
  int type = lwgeom_inter->type;
  int countinter;
  LWPOINT *lwpoint_inter = NULL; /* make compiler quiet */
  LWLINE *lwline_inter = NULL; /* make compiler quiet */
  LWCOLLECTION *coll = NULL; /* make compiler quiet */
  if (type == POINTTYPE)
  {
    countinter = 1;
    lwpoint_inter = lwgeom_as_lwpoint(lwgeom_inter);
  }
  else if (type == LINETYPE)
  {
    countinter = 1;
    lwline_inter = lwgeom_as_lwline(lwgeom_inter);
  }
  else
  /* It is a collection of type MULTIPOINTTYPE, MULTILINETYPE, or
   * COLLECTIONTYPE */
  {
    coll = lwgeom_as_lwcollection(lwgeom_inter);
    countinter = coll->ngeoms;
  }
  Span *periods = palloc(sizeof(Span) * countinter);
  int k = 0;
  for (int i = 0; i < countinter; i++)
  {
    if (countinter > 1)
    {
      /* Find the i-th intersection */
      LWGEOM *subgeom = coll->geoms[i];
      if (subgeom->type == POINTTYPE)
        lwpoint_inter = lwgeom_as_lwpoint(subgeom);
      else /* type == LINETYPE */
        lwline_inter = lwgeom_as_lwline(subgeom);
      type = subgeom->type;
    }
    TimestampTz t1, t2;
    GSERIALIZED *gspoint;
    /* Each intersection is either a point or a linestring */
    if (type == POINTTYPE)
    {
      gspoint = geo_serialize((LWGEOM *) lwpoint_inter);
      tpointseq_timestamp_at_value(seq, PointerGetDatum(gspoint), &t1);
      pfree(gspoint);
      /* If the intersection is not at an exclusive bound */
      if ((seq->period.lower_inc || t1 > start->t) &&
          (seq->period.upper_inc || t1 < end->t))
        span_set(t1, t1, true, true, T_TIMESTAMPTZ, &periods[k++]);
    }
    else
    {
      /* Get the fraction of the start point of the intersecting line */
      LWPOINT *lwpoint = lwline_get_lwpoint(lwline_inter, 0);
      gspoint = geo_serialize((LWGEOM *) lwpoint);
      tpointseq_timestamp_at_value(seq, PointerGetDatum(gspoint), &t1);
      pfree(gspoint);
      /* Get the fraction of the end point of the intersecting line */
      lwpoint = lwline_get_lwpoint(lwline_inter, lwline_inter->points->npoints - 1);
      gspoint = geo_serialize((LWGEOM *) lwpoint);
      tpointseq_timestamp_at_value(seq, PointerGetDatum(gspoint), &t2);
      pfree(gspoint);
      /* If t1 == t2 and the intersection is not at an exclusive bound */
      if (t1 == t2)
      {
        if ((seq->period.lower_inc || t1 > start->t) &&
            (seq->period.upper_inc || t1 < end->t))
          span_set(t1, t1, true, true, T_TIMESTAMPTZ, &periods[k++]);
      }
      else
      {
        TimestampTz lower1 = Min(t1, t2);
        TimestampTz upper1 = Max(t1, t2);
        bool lower_inc1 = (lower1 == start->t) ? seq->period.lower_inc : true;
        bool upper_inc1 = (upper1 == end->t) ? seq->period.upper_inc : true;
        span_set(lower1, upper1, lower_inc1, upper_inc1, T_TIMESTAMPTZ,
          &periods[k++]);
      }
    }
  }
  lwgeom_free(lwgeom_inter);

  if (k == 0)
  {
    *count = k;
    pfree(periods);
    return NULL;
  }
  if (k == 1)
  {
    *count = k;
    return periods;
  }

  int newcount;
  result = spanarr_normalize(periods, k, SORT, &newcount);
  pfree(periods);
  *count = newcount;
  return result;
}

/**
 * @brief Restrict a temporal sequence point with linear interpolation to a
 * geometry
 * @pre The arguments have the same SRID, the geometry is 2D and is not empty.
 * This is verified in #tpoint_restrict_geom_time
 * @note The computation is based on the PostGIS function ST_Intersection
 * which delegates the computation to GEOS. The geometry must be in 2D.
 * When computing the intersection the Z values of the temporal point must
 * be dropped since the Z values "are copied, averaged or interpolated"
 * as stated in https://postgis.net/docs/ST_Intersection.html
 * After this computation, the Z values are recovered by restricting the
 * original sequence to the time span of the 2D result.
 */
static TSequenceSet *
tpointseq_linear_at_geom(const TSequence *seq, const GSERIALIZED *gs)
{
  assert(MEOS_FLAGS_GET_LINEAR(seq->flags));
  TSequenceSet *result;

  /* Instantaneous sequence */
  if (seq->count == 1)
  {
    const TInstant *inst = TSEQUENCE_INST_N(seq, 0);
    if (! tpointinst_restrict_geom_time_iter(inst, gs, NULL, NULL, REST_AT))
      return NULL;
    result = tsequence_to_tsequenceset(seq);
    return result;
  }

  /* Bounding box test */
  STBox box1, box2;
  tsequence_set_bbox(seq, &box1);
  /* Non-empty geometries have a bounding box */
  geo_set_stbox(gs, &box2);
  if (! overlaps_stbox_stbox(&box1, &box2))
    return NULL;

  /* Convert the point to 2D before computing the restriction to geometry */
  bool hasz = MEOS_FLAGS_GET_Z(seq->flags);
  TSequence *seq2d = hasz ?
    (TSequence *) tpoint_force2d((Temporal *) seq) : (TSequence *) seq;

  /* Split the temporal point in an array of non self-intersecting fragments */
  int countsimple;
  TSequence **simpleseqs = tpointseq_make_simple(seq2d, &countsimple);
  Span *allperiods = NULL; /* make compiler quiet */
  int totalcount = 0;
  GSERIALIZED *traj, *gsinter;
  Datum inter;

  if (countsimple == 1)
  {
    /* Particular case when the input sequence is simple */
    pfree_array((void **) simpleseqs, countsimple);
    traj = tpointseq_cont_trajectory(seq2d);
    inter = geom_intersection2d(PointerGetDatum(traj), PointerGetDatum(gs));
    gsinter = DatumGetGserializedP(inter);
    if (! gserialized_is_empty(gsinter))
      allperiods = tpointseq_interperiods(seq2d, gsinter, &totalcount);
    PG_FREE_IF_COPY_P(gsinter, DatumGetPointer(inter));
    pfree(DatumGetPointer(inter)); pfree(traj);
    if (totalcount == 0)
    {
      if (hasz)
        pfree(seq2d);
      return NULL;
    }
  }
  else
  {
    /* General case */
    if (hasz)
      pfree(seq2d);
    Span **periods = palloc(sizeof(Span *) * countsimple);
    int *countpers = palloc0(sizeof(int) * countsimple);
    /* Loop for every simple fragment of the sequence */
    for (int i = 0; i < countsimple; i++)
    {
      traj = tpointseq_cont_trajectory(simpleseqs[i]);
      inter = geom_intersection2d(PointerGetDatum(traj), PointerGetDatum(gs));
      gsinter = DatumGetGserializedP(inter);
      if (! gserialized_is_empty(gsinter))
      {
        periods[i] = tpointseq_interperiods(simpleseqs[i], gsinter,
          &countpers[i]);
        totalcount += countpers[i];
      }
      PG_FREE_IF_COPY_P(gsinter, DatumGetPointer(inter));
      pfree(DatumGetPointer(inter)); pfree(traj);
    }
    pfree_array((void **) simpleseqs, countsimple);
    if (totalcount == 0)
      return NULL;
    /* Assemble the periods into a single array */
    allperiods = palloc(sizeof(Span) * totalcount);
    int k = 0;
    for (int i = 0; i < countsimple; i++)
    {
      for (int j = 0; j < countpers[i]; j++)
        allperiods[k++] = periods[i][j];
      if (countpers[i] != 0)
        pfree(periods[i]);
    }
    /* It is necessary to sort the periods */
    spanarr_sort(allperiods, totalcount);
  }
  /* Compute the periodset */
  assert(totalcount > 0);
  SpanSet *ps = spanset_make_free(allperiods, totalcount, NORMALIZE);
  /* Recover the Z values from the original sequence */
  result = tcontseq_restrict_periodset(seq, ps, REST_AT);
  pfree(ps);
  return result;
}

/**
 * @brief Restrict a temporal sequence point with linear interpolation to a
 * geometry and possibly a Z span and a period.
 * @note The function first filters the temporal point wrt the time dimension
 * to reduce the number of instants before computing the restriction to the
 * geometry, which is an expensive operation. Notice that we need to filter wrt
 * the Z dimension after that since while doing this, the subtype of the
 * temporal point may change from a sequence to a sequence set.
 */
static TSequenceSet *
tpointseq_linear_at_geom_time(const TSequence *seq, const GSERIALIZED *gs,
  const Span *zspan, const Span *period)
{
  assert(MEOS_FLAGS_GET_LINEAR(seq->flags));
  TSequenceSet *result = NULL;

  /* Instantaneous sequence */
  if (seq->count == 1)
  {
    const TInstant *inst = TSEQUENCE_INST_N(seq, 0);
    if (tpointinst_restrict_geom_time_iter(inst, gs, zspan, period, REST_AT))
      result = tsequence_to_tsequenceset(seq);
    return result;
  }

  /* General case */
  TSequence *at_t = NULL;
  TSequenceSet *at_xt = NULL;

  /* Restrict the temporal point to the T dimension */
  if (period)
  {
    /* Bounding box test for the T dimension */
    if (overlaps_span_span(&seq->period, period))
      /* Restrict to the period */
      at_t = tcontseq_at_period(seq, period);
  }
  else
    at_t = (TSequence *) seq;

  /* Compute atGeometry for the sequence restricted to the T dimension */
  if (at_t)
  {
    at_xt = tpointseq_linear_at_geom(at_t, gs);
    if (period)
      pfree(at_t);
  }

  /* Restrict to the Z dimension */
  if (at_xt)
  {
    if (zspan)
    {
      /* Bounding box test for the Z dimension */
      STBox box1;
      tsequenceset_set_bbox(at_xt, &box1);
      Span zspan1;
      span_set(Float8GetDatum(box1.zmin), Float8GetDatum(box1.zmax), true, true,
        T_FLOAT8, &zspan1);
      if (overlaps_span_span(&zspan1, zspan))
      {
        /* Get the Z coordinate values as a temporal float */
        Temporal *tfloat_z = tpoint_get_coord((Temporal *) at_xt, 2);
        /* Restrict to the zspan */
        Temporal *tfloat_zspan = tnumber_restrict_span(tfloat_z, zspan, REST_AT);
        pfree(tfloat_z);
        if (tfloat_zspan)
        {
          SpanSet *ss = temporal_time(tfloat_zspan);
          result = tsequenceset_restrict_periodset(at_xt, ss, REST_AT);
          pfree(tfloat_zspan);
          pfree(ss);
        }
      }
      pfree(at_xt);
    }
    else
      result = at_xt;
  }

  return result;
}

/**
 * @ingroup libmeos_internal_temporal_restrict
 * @brief Restrict a temporal sequence point with linear interpolation to
 * (the complement of) a geometry and possibly a Z span and a period.
 * @param[in] seq Temporal point
 * @param[in] gs Geometry
 * @param[in] zspan Span of values to restrict the Z dimension
 * @param[in] period Period to restrict the T dimension
 * @param[in] atfunc True if the restriction is at, false for minus
 * @sqlfunc atGeometry(), minusGeometry(), atGeometryTime(), minusGeometryTime()
 */
TSequenceSet *
tpointseq_linear_restrict_geom_time(const TSequence *seq,
  const GSERIALIZED *gs, const Span *zspan, const Span *period, bool atfunc)
{
  assert(MEOS_FLAGS_GET_LINEAR(seq->flags));
  TSequenceSet *result_at = tpointseq_linear_at_geom_time(seq, gs, zspan,
    period);

  /* If "at" restriction, return */
  if (atfunc)
    return result_at;

  /* If "minus" restriction, compute the complement wrt time */
  if (! result_at)
    return tsequence_to_tsequenceset(seq);

  SpanSet *ps = tsequenceset_time(result_at);
  TSequenceSet *result = tcontseq_restrict_periodset(seq, ps, atfunc);
  pfree(ps);
  pfree(result_at);
  return result;
}

/**
 * @ingroup libmeos_internal_temporal_restrict
 * @brief Restrict a temporal point sequence to (the complement of) a geometry
 * and possibly a Z span and a period.
 * @param[in] seq Temporal point
 * @param[in] gs Geometry
 * @param[in] zspan Span of values to restrict the Z dimension
 * @param[in] period Period to restrict the T dimension
 * @param[in] atfunc True if the restriction is at, false for minus
 * @sqlfunc atGeometry(), minusGeometry(), atGeometryTime(), minusGeometryTime()
 */
Temporal *
tpointseq_restrict_geom_time(const TSequence *seq, const GSERIALIZED *gs,
  const Span *zspan, const Span *period, bool atfunc)
{
  interpType interp = MEOS_FLAGS_GET_INTERP(seq->flags);
  if (interp == DISCRETE)
    return (Temporal *) tpointseq_disc_restrict_geom_time((TSequence *) seq,
      gs, zspan, period, atfunc);
  else if (interp == STEP)
    return (Temporal *) tpointseq_step_restrict_geom_time((TSequence *) seq,
      gs, zspan, period, atfunc);
  else /* interp == LINEAR */
    return (Temporal *) tpointseq_linear_restrict_geom_time((TSequence *) seq,
      gs, zspan, period, atfunc);
}

/**
 * @ingroup libmeos_internal_temporal_restrict
 * @brief Restrict a temporal point sequence set to (the complement of) a
 * geometry and possibly a Z span and a period.
 * @param[in] ss Temporal point
 * @param[in] gs Geometry
 * @param[in] zspan Span of values to restrict the Z dimension
 * @param[in] period Period to restrict the T dimension
 * @param[in] atfunc True if the restriction is at, false for minus
 * @sqlfunc atGeometry(), minusGeometry(), atGeometryTime(), minusGeometryTime()
 */
TSequenceSet *
tpointseqset_restrict_geom_time(const TSequenceSet *ss, const GSERIALIZED *gs,
  const Span *zspan, const Span *period, bool atfunc)
{
  const TSequence *seq;
  TSequenceSet *result = NULL;

  /* Singleton sequence set */
  if (ss->count == 1)
  {
    seq = TSEQUENCESET_SEQ_N(ss, 0);
    /* We can safely cast since the composing sequences are continuous */
    return (TSequenceSet *) tpointseq_restrict_geom_time(seq, gs, zspan,
      period, atfunc);
  }

  /* General case */
  STBox box2;
  /* Non-empty geometries have a bounding box */
  geo_set_stbox(gs, &box2);

  /* Initialize to 0 due to the bounding box test below */
  TSequenceSet **seqsets = palloc0(sizeof(TSequenceSet *) * ss->count);
  int totalseqs = 0;
  for (int i = 0; i < ss->count; i++)
  {
    /* Bounding box test */
    seq = TSEQUENCESET_SEQ_N(ss, i);
    STBox box1;
    tsequence_set_bbox(seq, &box1);
    if (atfunc && ! overlaps_stbox_stbox(&box1, &box2))
      continue;
    else
    {
      /* We can safely cast since the composing sequences are continuous */
      seqsets[i] = (TSequenceSet *) tpointseq_restrict_geom_time(seq, gs,
        zspan, period, atfunc);
      if (seqsets[i])
        totalseqs += seqsets[i]->count;
    }
  }
  /* Assemble the sequences from all the sequence sets */
  if (totalseqs > 0)
    result = tseqsetarr_to_tseqset(seqsets, ss->count, totalseqs);
  pfree_array((void **) seqsets, ss->count);
  return result;
}

/**
 * @ingroup libmeos_internal_temporal_restrict
 * @brief Restrict a temporal point to (the complement of) a geometry and
 * possibly a Z span and a period.
 * @param[in] temp Temporal point
 * @param[in] gs Geometry
 * @param[in] zspan Span of values to restrict the Z dimension
 * @param[in] period Period to restrict the T dimension
 * @param[in] atfunc True if the restriction is at, false for minus
 * @sqlfunc atGeometry(), minusGeometry(), atGeometryTime(), minusGeometryTime()
 */
Temporal *
tpoint_restrict_geom_time(const Temporal *temp, const GSERIALIZED *gs,
  const Span *zspan, const Span *period, bool atfunc)
{
  /* Parameter test */
  if (gserialized_is_empty(gs))
    return atfunc ? NULL : temporal_copy(temp);
  ensure_same_srid(tpoint_srid(temp), gserialized_get_srid(gs));
  ensure_has_not_Z_gs(gs);
  if (zspan)
    ensure_has_Z(temp->flags);

  /* Bounding box test */
  STBox box1, box2;
  temporal_set_bbox(temp, &box1);
  /* Non-empty geometries have a bounding box */
  geo_set_stbox(gs, &box2);
  if (zspan)
  {
    box2.zmin = DatumGetFloat8(zspan->lower);
    box2.zmax = DatumGetFloat8(zspan->upper);
    MEOS_FLAGS_SET_Z(box2.flags, true);
  }
  if (period)
  {
    memcpy(&box2.period, period, sizeof(Span));
    MEOS_FLAGS_SET_T(box2.flags, true);
  }
  bool overlaps = overlaps_stbox_stbox(&box1, &box2);
  if (! overlaps)
    return atfunc ? NULL : temporal_copy(temp);

  Temporal *result;
  assert(temptype_subtype(temp->subtype));
  if (temp->subtype == TINSTANT)
    result = (Temporal *) tpointinst_restrict_geom_time((TInstant *) temp,
      gs, zspan, period, atfunc);
  else if (temp->subtype == TSEQUENCE)
    result = tpointseq_restrict_geom_time((TSequence *) temp,
      gs, zspan, period, atfunc);
  else /* temp->subtype == TSEQUENCESET */
    result = (Temporal *) tpointseqset_restrict_geom_time((TSequenceSet *)
      temp, gs, zspan, period, atfunc);
  return result;
}

#if MEOS
/**
 * @ingroup libmeos_temporal_restrict
 * @brief Restrict a temporal point to a geometry.
 * @sqlfunc atGeometry()
 */
Temporal *
tpoint_at_geom_time(const Temporal *temp, const GSERIALIZED *gs,
  const Span *zspan, const Span *period)
{
  return tpoint_restrict_geom_time(temp, gs, zspan, period, REST_AT);
}

/**
 * @ingroup libmeos_temporal_restrict
 * @brief Restrict a temporal point to (the complement of) a geometry.
 * @sqlfunc minusGeometry()
 */
Temporal *
tpoint_minus_geom_time(const Temporal *temp, const GSERIALIZED *gs,
  const Span *zspan, const Span *period)
{
  return tpoint_restrict_geom_time(temp, gs, zspan, period, REST_MINUS);
}
#endif /* MEOS */

/*****************************************************************************
 * Restriction functions for a spatiotemporal box
 *****************************************************************************/

/*
 * Cohen Sutherland algorithm for line clipping extended for 3D.
 * https://en.wikipedia.org/wiki/Cohen%E2%80%93Sutherland_algorithm
 */

/* Region codes */
const int INSIDE  = 0;  // 000000
const int LEFT    = 1;  // 000001
const int RIGHT   = 2;  // 000010
const int BOTTOM  = 4;  // 000100
const int TOP     = 8;  // 001000
const int FRONT   = 16; // 010000
const int BACK    = 32; // 100000

/* Border codes */
const int XMAX    = 1;  // 001
const int YMAX    = 2;  // 010
const int ZMAX    = 4;  // 100

/**
 * @brief Compute region code for a point(x, y, z)
 */
static int
computeCode(double x, double y, double z, bool hasz, const STBox *box)
{
  /* Initialized as being inside */
  int code = INSIDE;
  if (x < box->xmin)      /* to the left of the box */
    code |= LEFT;
  else if (x > box->xmax) /* to the right of the box */
    code |= RIGHT;
  if (y < box->ymin)      /* below the box */
    code |= BOTTOM;
  else if (y > box->ymax) /* above the box */
    code |= TOP;
  if (hasz)
  {
    if (z < box->zmin)      /* in front of the box */
      code |= FRONT;
    else if (z > box->zmax) /* behind the the box */
      code |= BACK;
  }
  return code;
}

/**
 * @brief Compute max border code for a point(x, y, z)
 */
static int
computeMaxBorderCode(double x, double y, double z, bool hasz, const STBox *box)
{
  /* Initialized as being inside */
  int code = INSIDE;
  /* Check if we are on a max border
   * Note: After clipping, we don't need to apply fabs() */
  if (box->xmax - x < MEOS_EPSILON) /* on xmax border */
    code |= XMAX;
  if (box->ymax - y < MEOS_EPSILON) /* on ymax border */
    code |= YMAX;
  if (hasz && box->zmax - z < MEOS_EPSILON) /* on zmax border */
    code |= ZMAX;
  return code;
}

/**
 * @brief Clipping a line from p1 = (x1, y1, z1) to p2 = (x2, y2, z2)
 * @param[in] p1,p2 Input points
 * @param[in] box Bounding box
 * @param[in] hasz Has Z dimension?
 * @param[in] border_inc True when the box contains the upper border
 * @param[out] p3,p4 Output points
 * @param[out] p3_inc,p4_inc Are the points included or not in the box?
 * @result True if the line segment defined by p1,p2 intersects the bounding
 * box, false otherwise
 * @note When border_inc is false, the max border is counted as outside of the box
 * @note p3_inc and p4_inc are only written/returned when border_inc is true
 * @note It is possible to mix 2D/3D geometries, the Z dimension is only
 * considered if both the temporal point and the box have Z dimension
 */
bool
cohenSutherlandClip(Datum p1, Datum p2, const STBox *box, bool hasz,
  bool border_inc, Datum *p3, Datum *p4, bool *p3_inc, bool *p4_inc)
{
  assert(MEOS_FLAGS_GET_X(box->flags));
  const GSERIALIZED *gs1 = DatumGetGserializedP(p1);
  const GSERIALIZED *gs2 = DatumGetGserializedP(p2);
  if (hasz)
    assert(MEOS_FLAGS_GET_Z(box->flags) && (bool) FLAGS_GET_Z(gs1->gflags) &&
      (bool) FLAGS_GET_Z(gs2->gflags));

  int srid = gserialized_get_srid(gs1);
  assert(srid == gserialized_get_srid(gs2));

  /* Get the input points */
  double x1, y1, z1 = 0.0, x2, y2, z2 = 0.0;
  if (hasz)
  {
    const POINT3DZ *pt1 = GSERIALIZED_POINT3DZ_P(gs1);
    const POINT3DZ *pt2 = GSERIALIZED_POINT3DZ_P(gs2);
    x1 = pt1->x; x2 = pt2->x;
    y1 = pt1->y; y2 = pt2->y;
    z1 = pt1->z; z2 = pt2->z;
  }
  else
  {
    const POINT2D *pt1 = GSERIALIZED_POINT2D_P(gs1);
    const POINT2D *pt2 = GSERIALIZED_POINT2D_P(gs2);
    x1 = pt1->x; x2 = pt2->x;
    y1 = pt1->y; y2 = pt2->y;
  }

  /* Compute region codes for the input points */
  int code1 = computeCode(x1, y1, z1, hasz, box);
  int code2 = computeCode(x2, y2, z2, hasz, box);

  /* Initialize line as outside the rectangular window */
  bool found = false;
  while (true)
  {
    if (!(code1 | code2))
    {
      /* If both endpoints lie within rectangle */
      found = true;
      break;
    }
    else if (code1 & code2)
    {
      /* If both endpoints are outside rectangle, in same region */
      break;
    }
    else
    {
      /* Some segment of line lies within the rectangle */
      int code_out;
      double x, y, z = 0.0;
      /* At least one endpoint is outside the rectangle, pick it. */
      if (code1 != 0)
        code_out = code1;
      else
        code_out = code2;

      /*
       * Find intersection point using the following formulas
       * y = y1 + slope * (x - x1),
       * x = x1 + (1 / slope) * (y - y1)
       */
      if (code_out & LEFT)
      {
        /* point is to the left of rectangle */
        x = box->xmin;
        y = y1 + (y2 - y1) * (box->xmin - x1) / (x2 - x1);
        if (hasz)
          z = z1 + (z2 - z1) * (box->xmin - x1) / (x2 - x1);
      }
      else if (code_out & RIGHT)
      {
        /* point is to the right of rectangle */
        x = box->xmax;
        y = y1 + (y2 - y1) * (box->xmax - x1) / (x2 - x1);
        if (hasz)
          z = z1 + (z2 - z1) * (box->xmax - x1) / (x2 - x1);
      }
      else if (code_out & BOTTOM)
      {
        /* point is below the rectangle */
        y = box->ymin;
        x = x1 + (x2 - x1) * (box->ymin - y1) / (y2 - y1);
        if (hasz)
          z = z1 + (z2 - z1) * (box->ymin - y1) / (y2 - y1);
      }
      else if (code_out & TOP)
      {
        /* point is above the clip rectangle */
        y = box->ymax;
        x = x1 + (x2 - x1) * (box->ymax - y1) / (y2 - y1);
        if (hasz)
          z = z1 + (z2 - z1) * (box->ymax - y1) / (y2 - y1);
      }
      else if (hasz && code_out & FRONT)
      {
        /* point is in front of the rectangle */
        z = box->zmin;
        x = x1 + (x2 - x1) * (box->zmin - z1) / (z2 - z1);
        y = y1 + (y2 - y1) * (box->zmin - z1) / (z2 - z1);
      }
      else if (hasz && code_out & BACK)
      {
        /* point is behind the rectangle */
        z = box->zmax;
        x = x1 + (x2 - x1) * (box->zmax - z1) / (z2 - z1);
        y = y1 + (y2 - y1) * (box->zmax - z1) / (z2 - z1);
      }

      /*
       * Now intersection point x, y, z is found.
       * We replace point outside rectangle by intersection point
       */
      if (code_out == code1)
      {
        x1 = x;
        y1 = y;
        if (hasz)
          z1 = z;
        code1 = computeCode(x1, y1, z1, hasz, box);
      }
      else
      {
        x2 = x;
        y2 = y;
        if (hasz)
          z2 = z;
        code2 = computeCode(x2, y2, z2, hasz, box);
      }
    }
  }
  if (found)
  {
    /* We need to remove the max border */
    if (! border_inc)
    {
      /* Compute max border codes for the input points */
      int max_code1 = computeMaxBorderCode(x1, y1, z1, hasz, box);
      int max_code2 = computeMaxBorderCode(x2, y2, z2, hasz, box);
      /* If the whole segment is on a max border, remove it */
      if (max_code1 & max_code2)
        return false;
      /* Point is included if its max_code is 0 */
      *p3_inc = ! max_code1;
      *p4_inc = ! max_code2;
    }
    *p3 = PointerGetDatum(gspoint_make(x1, y1, z1, hasz, false, srid));
    *p4 = PointerGetDatum(gspoint_make(x2, y2, z2, hasz, false, srid));
  }
  return found;
}

/*****************************************************************************/

/**
 * @brief Restrict a temporal point instant to (the complement of) a
 * spatiotemporal box (iteration function).
 * @pre The arguments have the same SRID. This is verified in
 * #tpoint_restrict_stbox
 */
static bool
tpointinst_restrict_stbox_iter(const TInstant *inst, const STBox *box,
  bool border_inc, bool atfunc)
{
  bool hasz = MEOS_FLAGS_GET_Z(inst->flags) && MEOS_FLAGS_GET_Z(box->flags);
  bool hast = MEOS_FLAGS_GET_T(box->flags);

  /* Restrict to the T dimension */
  if (hast && ! contains_span_value(&box->period, DatumGetTimestampTz(inst->t),
      T_TIMESTAMPTZ))
    return ! atfunc;

  /* Restrict to the XY(Z) dimension */
  Datum value = tinstant_value(inst);
  /* Get the input point */
  double x, y, z = 0.0;
  if (hasz)
  {
    const POINT3DZ *pt = DATUM_POINT3DZ_P(value);
    x = pt->x;
    y = pt->y;
    z = pt->z;
  }
  else
  {
    const POINT2D *pt = DATUM_POINT2D_P(value);
    x = pt->x;
    y = pt->y;
  }
  /* Compute region code for the input point */
  int code = computeCode(x, y, z, hasz, box);
  int max_code = 0;
  if (! border_inc)
    max_code = computeMaxBorderCode(x, y, z, hasz, box);
  if ((code | max_code) != 0)
    return ! atfunc;

  /* Point is inside the region */
  return atfunc;
}

/**
 * @ingroup libmeos_internal_temporal_restrict
 * @brief Restrict a temporal point instant to (the complement of) a
 * spatiotemporal box.
 * @param[in] inst Temporal instant point
 * @param[in] box Spatiotemporal box
 * @param[in] border_inc True when the box contains the upper border
 * @param[in] atfunc True if the restriction is at, false for minus
 * @pre The box has X dimension and the arguments have the same SRID.
 * This is verified in #tpoint_restrict_stbox
 * @sqlfunc atStbox(), minusStbox()
 */
TInstant *
tpointinst_restrict_stbox(const TInstant *inst, const STBox *box,
  bool border_inc, bool atfunc)
{
  if (tpointinst_restrict_stbox_iter(inst, box, border_inc, atfunc))
    return tinstant_copy(inst);
  return NULL;
}

/**
 * @ingroup libmeos_internal_temporal_restrict
 * @brief Restrict a temporal point discrete sequence to (the complement of) a
 * spatiotemporal box.
 * @param[in] seq Temporal discrete sequence point
 * @param[in] box Spatiotemporal box
 * @param[in] border_inc True when the box contains the upper border
 * @param[in] atfunc True if the restriction is at, false for minus
 * @sqlfunc atStbox(), minusStbox()
 */
TSequence *
tpointseq_disc_restrict_stbox(const TSequence *seq, const STBox *box,
  bool border_inc, bool atfunc)
{
  assert(MEOS_FLAGS_GET_INTERP(seq->flags) == DISCRETE);
  /* Instantaneous sequence */
  if (seq->count == 1)
  {
    const TInstant *inst = TSEQUENCE_INST_N(seq, 0);
    if (tpointinst_restrict_stbox_iter(inst, box, border_inc, atfunc))
      return tsequence_copy(seq);
    return NULL;
  }

  /* General case */
  const TInstant **instants = palloc(sizeof(TInstant *) * seq->count);
  int k = 0;
  for (int i = 0; i < seq->count; i++)
  {
    const TInstant *inst = TSEQUENCE_INST_N(seq, i);
    if (tpointinst_restrict_stbox_iter(inst, box, border_inc, atfunc))
      instants[k++] = inst;
  }
  TSequence *result = NULL;
  if (k > 0)
    result = tsequence_make(instants, k, true, true, DISCRETE, NORMALIZE_NO);
  pfree(instants);
  return result;
}

/**
 * @brief Restrict a temporal sequence point with step interpolation to a
 * spatiotemporal box (iteration function).
 */
static TSequence **
tpointseq_step_at_stbox_iter(const TSequence *seq, const STBox *box,
  bool border_inc, int *count)
{
  /* Compute the time span of the result if the box has T dimension */
  bool hast = MEOS_FLAGS_GET_T(box->flags);
  bool found;
  Span timespan;
  if (hast)
  {
    found = inter_span_span(&seq->period, &box->period, &timespan);
    if (! found)
    {
      *count = 0;
      return NULL;
    }
  }

  bool lower_inc;
  TSequence **result = palloc(sizeof(TSequence *) * seq->count);
  TInstant **instants = palloc(sizeof(TInstant *) * seq->count);
  TimestampTz start = DatumGetTimestampTz(seq->period.lower);
  int k = 0, l = 0; /* k: number of instants, l: number of sequences */
  for (int i = 0; i < seq->count; i++)
  {
    const TInstant *inst = TSEQUENCE_INST_N(seq, i);
    if (tpointinst_restrict_stbox_iter(inst, box, border_inc, REST_AT))
      instants[k++] = (TInstant *) inst;
    else
    {
      if (k > 0)
      {
        /* Continue the last instant of the sequence until the time of inst2
         * projected to the T dimension (if any) */
        Datum value = tinstant_value(instants[k - 1]);
        bool tofree = false;
        bool upper_inc = false;
        if (hast)
        {
          Span extend, inter;
          span_set(TimestampTzGetDatum(instants[k - 1]->t),
            TimestampTzGetDatum(inst->t), true, false, T_TIMESTAMPTZ, &extend);
          found = inter_span_span(&timespan, &extend, &inter);
          if (found)
          {
            if (! datum_eq(inter.lower, inter.upper, T_TIMESTAMPTZ))
            {
              instants[k++] = tinstant_make(value, seq->temptype,
                DatumGetTimestampTz(inter.upper));
              tofree = true;
            }
            else
              upper_inc = true;
          }
        }
        else
        {
          /* Continue the last instant of the sequence until the time of inst2 */
          instants[k++] = tinstant_make(value, seq->temptype, inst->t);
          tofree = true;
        }
        lower_inc = (instants[0]->t == start) ? seq->period.lower_inc : true;
        result[l++] = tsequence_make((const TInstant **) instants, k,
          lower_inc, upper_inc, STEP, NORMALIZE_NO);
        if (tofree)
          pfree(instants[k - 1]);
        k = 0;
      }
    }
  }
  /* Add a last sequence with the remaining instants */
  if (k > 0)
  {
    lower_inc = (instants[0]->t == start) ? seq->period.lower_inc : true;
    TimestampTz end = DatumGetTimestampTz(seq->period.upper);
    bool upper_inc = (instants[k - 1]->t == end) ?
      seq->period.upper_inc : false;
    result[l++] = tsequence_make((const TInstant **) instants, k, lower_inc,
      upper_inc, STEP, NORMALIZE_NO);
  }
  /* Clean up and return */
  pfree(instants);
  *count = l;
  if (l == 0)
  {
    pfree(result);
    return NULL;
  }
  return result;
}

/**
 * @ingroup libmeos_internal_temporal_restrict
 * @brief Restrict a temporal sequence point with step interpolation to a
 * spatiotemporal box.
 * @param[in] seq Temporal point
 * @param[in] box Spatiotemporal box
 * @param[in] border_inc True when the box contains the upper border
 * @param[in] atfunc True if the restriction is at, false for minus
 * @note The function computes the "at" restriction on all dimensions and if
 * the requested restriction is "minus", then it computes the complement of the
 * "at" restriction with respect to the time dimension.
 * @sqlfunc atStbox(), minusStbox()
 */
TSequenceSet *
tpointseq_step_restrict_stbox(const TSequence *seq, const STBox *box,
  bool border_inc, bool atfunc)
{
  assert(MEOS_FLAGS_GET_INTERP(seq->flags) == STEP);
  /* Instantaneous sequence */
  if (seq->count == 1)
  {
    const TInstant *inst = TSEQUENCE_INST_N(seq, 0);
    if (tpointinst_restrict_stbox_iter(inst, box, border_inc, atfunc))
      return tsequence_to_tsequenceset(seq);
    return NULL;
  }

  /* General case */
  int count;
  TSequence **sequences = tpointseq_step_at_stbox_iter(seq, box, border_inc,
    &count);
  /* Return if the computation of "at" is empty */
  if (count == 0)
    return atfunc ? NULL : tsequence_to_tsequenceset(seq);

  /* Construct the result for "at" restriction */
  TSequenceSet *result_at = tsequenceset_make_free(sequences, count,
    NORMALIZE_NO);
  /* If "at" restriction, return */
  if (atfunc)
    return result_at;

  /* If "minus" restriction, compute the complement wrt time */
  SpanSet *ps = tsequenceset_time(result_at);
  TSequenceSet *result = tcontseq_restrict_periodset(seq, ps, atfunc);
  pfree(ps);
  pfree(result_at);
  return result;
}

/*****************************************************************************/

/**
 * @brief Restrict the temporal point to the spatial dimensions of a
 * spatiotemporal box
 * @param[in] seq Temporal point sequence
 * @param[in] box Bounding box
 * @param[in] border_inc True when the box contains the upper border
 * @param[out] count Number of elements in the resulting array
 * @pre The sequence is simple in order to recover the time dimension from
 * the result of the Cohen-Sutherland line clipping algorithm
 * @note Since this function is called AFTER the restriction to the time
 * dimension it is necessary to test for instantaneous sequence
 */
TSequence **
tpointseq_linear_at_stbox_xyz(const TSequence *seq, const STBox *box,
  bool border_inc, int *count)
{
  assert(MEOS_FLAGS_GET_INTERP(seq->flags) == LINEAR);
  TSequence **result = NULL;
  *count = 0;

  /* Instantaneous sequence */
  if (seq->count == 1)
  {
    const TInstant *inst = TSEQUENCE_INST_N(seq, 0);
    if (tpointinst_restrict_stbox_iter(inst, box, border_inc, REST_AT))
    {
      result = palloc(sizeof(TSequence *));
      result[0] = tsequence_copy(seq);
      *count = 1;
    }
    return result;
  }

  /* General case */
  bool hasz_seq = MEOS_FLAGS_GET_Z(seq->flags);
  bool hasz_box = MEOS_FLAGS_GET_Z(box->flags);
  bool hasz = hasz_seq && hasz_box;
  result = palloc(sizeof(TSequence *) * seq->count);
  const TInstant *inst1 = TSEQUENCE_INST_N(seq, 0);
  Datum p1 = tinstant_value(inst1);
  bool lower_inc = seq->period.lower_inc;
  int k = 0;
  for (int i = 1; i < seq->count; i++)
  {
    const TInstant *inst2 = TSEQUENCE_INST_N(seq, i);
    bool upper_inc = (i == seq->count - 1) ? seq->period.upper_inc : false;
    Datum p2 = tinstant_value(inst2);
    Datum p3, p4;
    TInstant *instants[2];
    if (datum2_point_eq(p1, p2))
    {
      /* Constant segment */
      double x, y, z = 0.0;
      if (hasz)
      {
        const POINT3DZ *pt = DATUM_POINT3DZ_P(p1);
        x = pt->x;
        y = pt->y;
        z = pt->z;
      }
      else
      {
        const POINT2D *pt = DATUM_POINT2D_P(p1);
        x = pt->x;
        y = pt->y;
      }
      /* Compute region code for the input point */
      int code = computeCode(x, y, z, hasz, box);
      int max_code = 0;
      if (! border_inc)
        max_code = computeMaxBorderCode(x, y, z, hasz, box);
      if ((code | max_code) == 0)
      {
        instants[0] = (TInstant *) inst1;
        instants[1] = (TInstant *) inst2;
        result[k++] = tsequence_make((const TInstant **) instants, 2,
          lower_inc, upper_inc, LINEAR, NORMALIZE_NO);
      }
    }
    else
    {
      bool p3_inc, p4_inc;
      bool found = cohenSutherlandClip(p1, p2, box, hasz, border_inc, &p3, &p4,
        &p3_inc, &p4_inc);
      if (found)
      {
        if (! border_inc)
        {
          lower_inc &= p3_inc;
          upper_inc &= p4_inc;
        }
        TimestampTz t1, t2;
        if (hasz_seq && ! hasz)
        {
          /* Force the computation at 2D */
          TInstant *inst1_2d = (TInstant *) tpoint_force2d((Temporal *) inst1);
          TInstant *inst2_2d = (TInstant *) tpoint_force2d((Temporal *) inst2);
          tpointsegm_timestamp_at_value1(inst1_2d, inst2, p3, &t1);
          tpointsegm_timestamp_at_value1(inst1_2d, inst2, p4, &t2);
          pfree(inst1_2d); pfree(inst2_2d);
        }
        else
        {
          tpointsegm_timestamp_at_value1(inst1, inst2, p3, &t1);
          tpointsegm_timestamp_at_value1(inst1, inst2, p4, &t2);
        }
        pfree(DatumGetPointer(p3)); pfree(DatumGetPointer(p4));
        /* To reduce roundoff errors we project the temporal points to the
         * timestamps instead of taking the intersection values returned by
         * the function #cohenSutherlandClip */
        Datum inter1, inter2;
        if (t1 != inst1->t)
          inter1 = tsegment_value_at_timestamp(inst1, inst2, LINEAR, t1);
        else
          inter1 = p1;
        if (t2 != inst2->t)
          inter2 = tsegment_value_at_timestamp(inst1, inst2, LINEAR, t2);
        else
          inter2 = p2;
        /* We cannot add the end point of the segment as a singleton sequence
         * if it is at an exclusive upper bound */
        if (t1 != t2 || t1 != inst2->t || upper_inc)
        {
          int j = 0;
          instants[j++] = tinstant_make(inter1, inst1->temptype, t1);
          if (! datum_point_eq(inter1, inter2))
            instants[j++] = tinstant_make(inter2, inst1->temptype, t2);
          result[k++] = tsequence_make((const TInstant **) instants, j,
            (j == 1) ? true : lower_inc, (j == 1) ? true : upper_inc, LINEAR,
            NORMALIZE_NO);
          pfree(instants[0]);
          if (j > 1)
            pfree(instants[1]);
        }
        if (t1 != inst1->t)
          pfree(DatumGetPointer(inter1));
        if (t2 != inst2->t)
          pfree(DatumGetPointer(inter2));
      }
    }
    inst1 = inst2;
    p1 = p2;
    lower_inc = true;
  }
  *count = k;
  return result;
}

/**
 * @brief Restrict a temporal sequence point with linear interpolation to a
 * spatiotemporal box.
 * @param[in] seq Temporal point sequence
 * @param[in] box Spatiotemporal box
 * @param[in] border_inc True when the box contains the upper border
 * @param[out] count Number of elements in the resulting array
 * @pre The box has X dimension and the arguments have the same SRID.
 * This is verified in #tpoint_restrict_stbox
 * @pre This function is called for each sequence of a sequence set and thus,
 * cannot compute the complement for the "minus" function.
 * @note The function first filters the temporal point wrt the time dimension
 * to reduce the number of instants before computing the restriction to the
 * spatial dimension.
 */
static TSequence **
tpointseq_linear_at_stbox_iter(const TSequence *seq, const STBox *box,
  bool border_inc, int *count)
{
  assert(MEOS_FLAGS_GET_LINEAR(seq->flags));
  bool hast = MEOS_FLAGS_GET_T(box->flags);
  TSequence **result = NULL;
  *count = 0;

  /* Instantaneous sequence */
  if (seq->count == 1)
  {
    const TInstant *inst = TSEQUENCE_INST_N(seq, 0);
    if (tpointinst_restrict_stbox_iter(inst, box, border_inc, REST_AT))
    {
      result = palloc(sizeof(TSequence *));
      result[0] = tsequence_copy(seq);
      *count = 1;
    }
    return result;
  }

  /* Restrict to the temporal dimension */
  TSequence *seq_t;
  if (hast)
  {
    /* Restrict to the period */
    seq_t = tcontseq_at_period(seq, &box->period);
  }
  else
    seq_t = (TSequence *) seq;

  /* Restrict to the spatial dimension */
  if (seq_t)
  {
    int newcount;
    result = tpointseq_linear_at_stbox_xyz(seq_t, box, border_inc, &newcount);
    *count = newcount;
    if (hast)
      pfree(seq_t);
  }
  return result;
}

/**
 * @ingroup libmeos_internal_temporal_restrict
 * @brief Restrict a temporal point sequence to (the complement of) a
 * spatiotemporal box.
 * @param[in] seq Temporal sequence point
 * @param[in] box Spatiotemporal box
 * @param[in] border_inc True when the box contains the upper border
 * @param[in] atfunc True if the restriction is at, false for minus
 * @sqlfunc atStbox()
 */
TSequenceSet *
tpointseq_linear_restrict_stbox(const TSequence *seq, const STBox *box,
  bool border_inc, bool atfunc)
{
  int count;
  TSequence **sequences = tpointseq_linear_at_stbox_iter(seq, box, border_inc,
    &count);
  if (sequences == NULL)
    return atfunc ? NULL : tsequence_to_tsequenceset(seq);

  TSequenceSet *result_at = tsequenceset_make_free(sequences, count,
    NORMALIZE);
  /* If "at" restriction, return */
  if (atfunc)
    return result_at;

  /* If "minus" restriction, compute the complement wrt time */
  SpanSet *ps = tsequenceset_time(result_at);
  TSequenceSet *result = tcontseq_restrict_periodset(seq, ps, atfunc);
  pfree(ps);
  pfree(result_at);
  return result;
}

/**
 * @ingroup libmeos_internal_temporal_restrict
 * @brief Restrict a temporal point sequence to (the complement of) a
 * spatiotemporal box.
 * @param[in] seq Temporal sequence point
 * @param[in] box Spatiotemporal box
 * @param[in] border_inc True when the box contains the upper border
 * @param[in] atfunc True if the restriction is at, false for minus
 * @pre The box has X dimension and the arguments have the same SRID.
 * This is verified in #tpoint_restrict_stbox
 * @note For linear interpolation the function computes the "at" restriction on
 * all dimensions and if the requested restriction is "minus", then it computes
 * the complement of the "at" restriction with respect to the time dimension.
 * @sqlfunc atStbox(), minusStbox()
 */
Temporal *
tpointseq_restrict_stbox(const TSequence *seq, const STBox *box, bool border_inc,
  bool atfunc)
{
  interpType interp = MEOS_FLAGS_GET_INTERP(seq->flags);
  /* Discrete sequences can cope with "at" and "minus" in a single pass */
  if (interp == DISCRETE)
    return (Temporal *) tpointseq_disc_restrict_stbox((TSequence *) seq, box,
      border_inc, atfunc);
  else if (interp == STEP)
    return (Temporal *) tpointseq_step_restrict_stbox((TSequence *) seq, box,
      border_inc, atfunc);
  else /* interp == LINEAR */
    return (Temporal *) tpointseq_linear_restrict_stbox((TSequence *) seq, box,
      border_inc, atfunc);
}

/**
 * @ingroup libmeos_internal_temporal_restrict
 * @brief Restrict a temporal point sequence set to (the complement of) a
 * spatiotemporal box.
 * @param[in] ss Temporal sequence set point
 * @param[in] box Spatiotemporal box
 * @param[in] border_inc True when the box contains the upper border
 * @param[in] atfunc True if the restriction is at, false for minus
 * @pre The box has X dimension and the arguments have the same SRID.
 * This is verified in #tpoint_restrict_stbox
 * @sqlfunc atStbox(), minusStbox()
 */
TSequenceSet *
tpointseqset_restrict_stbox(const TSequenceSet *ss, const STBox *box,
  bool border_inc, bool atfunc)
{
  const TSequence *seq;
  TSequenceSet *result = NULL;

  /* Singleton sequence set */
  if (ss->count == 1)
  {
    seq = TSEQUENCESET_SEQ_N(ss, 0);
    /* We can safely cast since the composing sequences are continuous */
    return (TSequenceSet *) tpointseq_restrict_stbox(seq, box, border_inc,
      atfunc);
  }

  /* General case */

  /* Initialize to 0 due to the bounding box test below */
  TSequenceSet **seqsets = palloc0(sizeof(TSequenceSet *) * ss->count);
  int totalseqs = 0;
  for (int i = 0; i < ss->count; i++)
  {
    /* Bounding box test */
    seq = TSEQUENCESET_SEQ_N(ss, i);
    STBox box1;
    tsequence_set_bbox(seq, &box1);
    if (atfunc && ! overlaps_stbox_stbox(&box1, box))
      continue;
    else
    {
      /* We can safely cast since the composing sequences are continuous */
      seqsets[i] = (TSequenceSet *) tpointseq_restrict_stbox(seq, box,
        border_inc, atfunc);
      if (seqsets[i])
        totalseqs += seqsets[i]->count;
    }
  }
  /* Assemble the sequences from all the sequence sets */
  if (totalseqs > 0)
    result = tseqsetarr_to_tseqset(seqsets, ss->count, totalseqs);
  pfree_array((void **) seqsets, ss->count);
  return result;
}

/**
 * @ingroup libmeos_internal_temporal_restrict
 * @brief Restrict a temporal point to (the complement of) a spatiotemporal box
 * @param[in] temp Temporal point
 * @param[in] box Spatiotemporal box
 * @param[in] border_inc True when the box contains the upper border
 * @param[in] atfunc True if the restriction is at, false for minus
 * @note It is possible to mix 2D/3D geometries, the Z dimension is only
 * considered if both the temporal point and the box have Z dimension
 * @sqlfunc atStbox(), minusStbox()
 */
Temporal *
tpoint_restrict_stbox(const Temporal *temp, const STBox *box, bool border_inc,
  bool atfunc)
{
  /* At least one of MEOS_FLAGS_GET_X and MEOS_FLAGS_GET_T is true */
  bool hasx = MEOS_FLAGS_GET_X(box->flags);
  bool hast = MEOS_FLAGS_GET_T(box->flags);
  assert(hasx || hast);

  /* Short-circuit restriction to only T dimension */
  if (hast && ! hasx)
    return temporal_restrict_period(temp, &box->period, atfunc);

  /* Parameter test */
  ensure_same_srid(tpoint_srid(temp), stbox_srid(box));
  ensure_same_geodetic(temp->flags, box->flags);

  /* Bounding box test */
  STBox box1;
  temporal_set_bbox(temp, &box1);
  bool overlaps = overlaps_stbox_stbox(&box1, box);
  if (! overlaps)
    return atfunc ? NULL : temporal_copy(temp);

  Temporal *result;
  assert(temptype_subtype(temp->subtype));
  if (temp->subtype == TINSTANT)
    result = (Temporal *) tpointinst_restrict_stbox((TInstant *) temp,
      box, border_inc, atfunc);
  else if (temp->subtype == TSEQUENCE)
    result = (Temporal *) tpointseq_restrict_stbox((TSequence *) temp,
      box, border_inc, atfunc);
  else /* temp->subtype == TSEQUENCESET */
    result = (Temporal *) tpointseqset_restrict_stbox((TSequenceSet *) temp,
      box, border_inc, atfunc);
  return result;
}

#if MEOS
/**
 * @ingroup libmeos_temporal_restrict
 * @brief Restrict a temporal point to a spatiotemporal box.
 * @sqlfunc atStbox(), minusGeometry()
 */
Temporal *
tpoint_at_stbox(const Temporal *temp, const STBox *box, bool border_inc)
{
  Temporal *result = tpoint_restrict_stbox(temp, box, border_inc, REST_AT);
  return result;
}

/**
 * @ingroup libmeos_temporal_restrict
 * @brief Restrict a temporal point to the complement of a spatiotemporal box.
 * @sqlfunc minusStbox()
 */
Temporal *
tpoint_minus_stbox(const Temporal *temp, const STBox *box, bool border_inc)
{
  Temporal *result = tpoint_restrict_stbox(temp, box, border_inc, REST_MINUS);
  return result;
}
#endif /* MEOS */

/*****************************************************************************/