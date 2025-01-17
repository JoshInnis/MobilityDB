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
 * @brief Distance functions for temporal numbers.
 */

#include "general/tnumber_distance.h"

/* C */
#include <assert.h>
#include <float.h>
#include <math.h>
/* MEOS */
#include <meos.h>
#include <meos_internal.h>
#include "general/lifting.h"
#include "general/temporaltypes.h"
#include "general/type_util.h"

/*****************************************************************************
 * Temporal distance
 *****************************************************************************/

/**
 * @brief Return the distance between two numbers
 */
Datum
number_distance(Datum l, Datum r, meosType type)
{
  Datum result = 0;
  assert(tnumber_basetype(type));
  if (type == T_INT4)
    result = Int32GetDatum(abs(DatumGetInt32(l) - DatumGetInt32(r)));
  else /* type == T_FLOAT8 */
      result = Float8GetDatum(fabs(DatumGetFloat8(l) - DatumGetFloat8(r)));
  return result;
}

/*****************************************************************************/

/**
 * @ingroup libmeos_internal_temporal_dist
 * @brief Return the temporal distance between a temporal number and a number.
 * @param[in] temp Temporal number
 * @param[in] value Value
 * @param[in] valuetype Type of the value
 * @param[in] restype Type of the result
 */
Temporal *
distance_tnumber_number(const Temporal *temp, Datum value, meosType valuetype,
  meosType restype)
{
  assert(temp);
  assert(temptype_basetype(temp->temptype) == valuetype);
  LiftedFunctionInfo lfinfo;
  memset(&lfinfo, 0, sizeof(LiftedFunctionInfo));
  lfinfo.func = (varfunc) &number_distance;
  lfinfo.numparam = 0;
  lfinfo.args = true;
  lfinfo.argtype[0] = temptype_basetype(temp->temptype);
  lfinfo.argtype[1] = valuetype;
  lfinfo.restype = restype;
  lfinfo.reslinear = MEOS_FLAGS_LINEAR_INTERP(temp->flags);
  lfinfo.invert = INVERT_NO;
  lfinfo.discont = CONTINUOUS;
  lfinfo.tpfunc_base = &tlinearsegm_intersection_value;
  lfinfo.tpfunc = NULL;
  Temporal *result = tfunc_temporal_base(temp, value, &lfinfo);
  return result;
}

#if MEOS
/**
 * @ingroup libmeos_temporal_dist
 * @brief Return the temporal distance between a temporal integer and an
 * integer.
 * @return On error return NULL
 * @sqlop @p <->
 */
Temporal *
distance_tint_int(const Temporal *temp, int i)
{
  /* Ensure validity of the arguments */
  if (! ensure_not_null((void *) temp) ||
      ! ensure_same_temporal_basetype(temp, T_INT4))
    return NULL;
  return distance_tnumber_number(temp, Int32GetDatum(i), T_INT4, T_TINT);
}

/**
 * @ingroup libmeos_temporal_dist
 * @brief Return the temporal distance between a temporal float and a float.
 * @return On error return NULL
 * @sqlop @p <->
 */
Temporal *
distance_tfloat_float(const Temporal *temp, double d)
{
  /* Ensure validity of the arguments */
  if (! ensure_not_null((void *) temp) ||
      ! ensure_same_temporal_basetype(temp, T_FLOAT8))
    return NULL;
  return distance_tnumber_number(temp, Int32GetDatum(d), T_FLOAT8, T_TFLOAT);
}
#endif /* MEOS */

/**
 * @brief Return true if two segments of the temporal numbers intersect at a
 * timestamp.
 *
 * This function is passed to the lifting infrastructure when computing the
 * temporal distance.
 * @param[in] start1,end1 Temporal instants defining the first segment
 * @param[in] start2,end2 Temporal instants defining the second segment
 * @param[out] value Value
 * @param[out] t Timestamp
 */
static bool
tnumber_min_dist_at_timestamp(const TInstant *start1, const TInstant *end1,
  const TInstant *start2, const TInstant *end2, Datum *value, TimestampTz *t)
{
  if (! tsegment_intersection(start1, end1, LINEAR, start2, end2, LINEAR,
      NULL, NULL, t))
    return false;
  *value = (Datum) 0;
  return true;
}

/**
 * @ingroup libmeos_temporal_dist
 * @brief Return the temporal distance between two temporal numbers
 * @sqlop @p <->
 */
Temporal *
distance_tnumber_tnumber(const Temporal *temp1, const Temporal *temp2)
{
  /* Ensure validity of the arguments */
  if (! ensure_not_null((void *) temp1) || ! ensure_not_null((void *) temp2) ||
      ! ensure_same_temporal_type(temp1, temp2) ||
      ! ensure_tnumber_type(temp1->temptype))
    return NULL;

  LiftedFunctionInfo lfinfo;
  memset(&lfinfo, 0, sizeof(LiftedFunctionInfo));
  lfinfo.func = (varfunc) &number_distance;
  lfinfo.numparam = 0;
  lfinfo.args = true;
  lfinfo.argtype[0] = temptype_basetype(temp1->temptype);
  lfinfo.argtype[1] = temptype_basetype(temp2->temptype);
  lfinfo.restype = temp1->temptype;
  lfinfo.reslinear = MEOS_FLAGS_LINEAR_INTERP(temp1->flags) ||
    MEOS_FLAGS_LINEAR_INTERP(temp2->flags);
  lfinfo.invert = INVERT_NO;
  lfinfo.discont = CONTINUOUS;
  lfinfo.tpfunc = lfinfo.reslinear ? &tnumber_min_dist_at_timestamp : NULL;
  Temporal *result = tfunc_temporal_temporal(temp1, temp2, &lfinfo);
  return result;
}

/*****************************************************************************
 * Nearest approach distance
 *****************************************************************************/

/**
 * @ingroup libmeos_internal_temporal_dist
 * @brief Return the nearest approach distance between a temporal number
 * and a number.
 */
double
nad_tnumber_number(const Temporal *temp, Datum value, meosType basetype)
{
  assert(temp);
  assert(tnumber_type(temp->temptype));
  assert(temptype_basetype(temp->temptype) == basetype);
  TBox box1, box2;
  temporal_set_bbox(temp, &box1);
  number_set_tbox(value, basetype, &box2);
  return nad_tbox_tbox(&box1, &box2);
}

#if MEOS
/**
 * @ingroup libmeos_temporal_dist
 * @brief Return the nearest approach distance between a temporal number
 * and a number.
 * @return On error return -1
 * @sqlop @p |=|
 */
int
nad_tint_int(const Temporal *temp, int i)
{
  /* Ensure validity of the arguments */
  if (! ensure_not_null((void *) temp) ||
      ! ensure_same_temporal_basetype(temp, T_INT4))
    return -1;
  double result = nad_tnumber_number(temp, Int32GetDatum(i), T_INT4);
  return (int) result;
}

/**
 * @ingroup libmeos_temporal_dist
 * @brief Return the nearest approach distance between a temporal number
 * and a number.
 * @return On error return -1
 * @sqlop @p |=|
 */
double
nad_tfloat_float(const Temporal *temp, double d)
{
  /* Ensure validity of the arguments */
  if (! ensure_not_null((void *) temp) ||
      ! ensure_same_temporal_basetype(temp, T_FLOAT8))
    return -1.0;
  return nad_tnumber_number(temp, Float8GetDatum(d), T_FLOAT8);
}
#endif /* MEOS */

/**
 * @ingroup libmeos_temporal_dist
 * @brief Return the nearest approach distance between the temporal boxes.
 * @return On error return -1
 * @sqlop @p |=|
 */
double
nad_tbox_tbox(const TBox *box1, const TBox *box2)
{
  /* Ensure validity of the arguments */
  if (! ensure_not_null((void *) box1) || ! ensure_not_null((void *) box2) ||
      ! ensure_has_X_tbox(box1) || ! ensure_has_X_tbox(box2) ||
      ! ensure_same_span_type(&box1->span, &box2->span))
    return -1.0;

  /* If the boxes do not intersect in the time dimension return infinity */
  bool hast = MEOS_FLAGS_GET_T(box1->flags) && MEOS_FLAGS_GET_T(box2->flags);
  if (hast && ! overlaps_span_span(&box1->period, &box2->period))
    return DBL_MAX;

  return distance_span_span(&box1->span, &box2->span);
}

/**
 * @ingroup libmeos_temporal_dist
 * @brief Return the nearest approach distance between a temporal number
 * and a temporal box.
 * @return On error return -1
 * @sqlop @p |=|
 */
double
nad_tnumber_tbox(const Temporal *temp, const TBox *box)
{
  /* Ensure validity of the arguments */
  if (! ensure_not_null((void *) temp) || ! ensure_not_null((void *) box) ||
      ! ensure_has_X_tbox(box) ||
      ! ensure_same_temporal_basetype(temp, box->span.basetype))
    return -1.0;

  bool hast = MEOS_FLAGS_GET_T(box->flags);
  Span p, inter;
  if (hast)
  {
    temporal_set_period(temp, &p);
    if (! inter_span_span(&p, &box->period, &inter))
      return DBL_MAX;
  }

  /* Project the temporal number to the timespan of the box (if any) */
  Temporal *temp1 = hast ?
    temporal_restrict_period(temp, &inter, REST_AT) : (Temporal *) temp;
  /* Test if the bounding boxes overlap */
  TBox box1;
  temporal_set_bbox(temp1, &box1);
  if (overlaps_tbox_tbox(box, &box1))
    return 0.0;

  /* Get the minimum distance between the values of the boxes */
  double result = datum_gt(box->span.lower, box1.span.upper, T_FLOAT8) ?
    fabs(DatumGetFloat8(box->span.lower) - DatumGetFloat8(box1.span.upper)) :
    fabs(DatumGetFloat8(box1.span.lower) - DatumGetFloat8(box->span.upper));

  if (hast)
    pfree(temp1);

  return result;
}

#if MEOS
/**
 * @brief Return the nearest approach distance between two temporal numbers.
 */
Datum
nad_tnumber_tnumber(const Temporal *temp1, const Temporal *temp2)
{
  assert(temp1); assert(temp2);
  assert(temp1->temptype == temp2->temptype);
  assert(tnumber_type(temp1->temptype));
  TBox box1, box2;
  temporal_set_bbox(temp1, &box1);
  temporal_set_bbox(temp2, &box2);
  double result = nad_tbox_tbox(&box1, &box2);
  if (temp1->temptype == T_TINT)
    return Int32GetDatum(result);
  else
    return Float8GetDatum(result);
}

/**
 * @ingroup libmeos_temporal_dist
 * @brief Return the nearest approach distance between two temporal integers.
 * @return On error return -1
 * @sqlop @p |=|
 */
int
nad_tint_tint(const Temporal *temp1, const Temporal *temp2)
{
  /* Ensure validity of the arguments */
  if (! ensure_not_null((void *) temp1) || ! ensure_not_null((void *) temp2) ||
      ! ensure_same_temporal_type(temp1, temp2) ||
      ! ensure_tnumber_type(temp1->temptype))
    return -1;
  Datum result = nad_tnumber_tnumber(temp1, temp2);
  return Int32GetDatum(result);
}

/**
 * @ingroup libmeos_temporal_dist
 * @brief Return the nearest approach distance between two temporal floats.
 * @return On error return -1
 * @sqlop @p |=|
 */
double
nad_tfloat_tfloat(const Temporal *temp1, const Temporal *temp2)
{
  /* Ensure validity of the arguments */
  if (! ensure_not_null((void *) temp1) || ! ensure_not_null((void *) temp2) ||
      ! ensure_same_temporal_type(temp1, temp2) ||
      ! ensure_tnumber_type(temp1->temptype))
    return -1.0;
  Datum result = nad_tnumber_tnumber(temp1, temp2);
  return Float8GetDatum(result);
}
#endif /* MEOS */

/*****************************************************************************/
