/*****************************************************************************
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
 * @brief Functions for parsing temporal points.
 */

#include "point/tpoint_parser.h"

/* C */
#include <assert.h>
/* MEOS */
#include <meos.h>
#include <meos_internal.h>
#include "general/type_parser.h"
#include "point/tpoint_spatialfuncs.h"

/*****************************************************************************/

/**
 * @brief Parse a spatiotemporal box from the buffer.
 */
STBox *
stbox_parse(const char **str)
{
  /* make compiler quiet */
  double xmin = 0, xmax = 0, ymin = 0, ymax = 0, zmin = 0, zmax = 0;
  Span period;
  bool hasx = false, hasz = false, hast = false, geodetic = false;
  int srid = 0;
  bool hassrid = false;

  /* Determine whether the box has an SRID */
  p_whitespace(str);
  if (pg_strncasecmp(*str,"SRID=",5) == 0)
  {
    /* Move str to the start of the number part */
    *str += 5;
    int delim = 0;
    /* Delimiter will be either ',' or ';' depending on whether interpolation
       is given after */
    while ((*str)[delim] != ',' && (*str)[delim] != ';' && (*str)[delim] != '\0')
    {
      srid = srid * 10 + (*str)[delim] - '0';
      delim++;
    }
    /* Set str to the start of the temporal point */
    *str += delim + 1;
    hassrid = true;
  }

  /* Determine whether the box is geodetic or not */
  if (pg_strncasecmp(*str, "STBOX", 5) == 0)
  {
    *str += 5;
    p_whitespace(str);
  }
  else if (pg_strncasecmp(*str, "GEODSTBOX", 9) == 0)
  {
    *str += 9;
    geodetic = true;
    p_whitespace(str);
    if (! hassrid)
      srid = 4326;
  }
  else
  {
    meos_error(ERROR, MEOS_ERR_TEXT_INPUT,
      "Could not parse spatiotemporal box");
    return NULL;
  }

  /* Determine whether the box has X, Z, and/or T dimensions */
  if (pg_strncasecmp(*str, "ZT", 2) == 0)
  {
    hasx = hasz = hast = true;
    *str += 2;
  }
  else if (pg_strncasecmp(*str, "XT", 2) == 0)
  {
    hasx = hast = true;
    *str += 2;
  }
  else if (pg_strncasecmp(*str, "Z", 1) == 0)
  {
    *str += 1;
    hasx = hasz = true;
  }
  else if (pg_strncasecmp(*str, "X", 1) == 0)
  {
    *str += 1;
    hasx = true;
  }
  else if (pg_strncasecmp(*str, "T", 1) == 0)
  {
    *str += 1;
    hast = true;
  }
  else
  {
    meos_error(ERROR, MEOS_ERR_TEXT_INPUT,
      "Could not parse spatiotemporal box: Missing dimension information");
    return NULL;
  }

  /* Parse external opening parenthesis (if both space and time dimensions) */
  if (hast)
  {
    p_whitespace(str);
    if (! ensure_oparen(str, "spatiotemporal box"))
      return NULL;
  }

  if (hasx)
  {
    /* Parse enclosing opening parenthesis */
    p_whitespace(str);
    if (! ensure_oparen(str, "spatiotemporal box"))
      return NULL;

    /* Parse lower bounds */
    p_whitespace(str);
    if (! ensure_oparen(str, "spatiotemporal box"))
      return NULL;
    /* xmin */
    xmin = double_parse(str);
    /* ymin */
    p_whitespace(str);
    p_comma(str);
    p_whitespace(str);
    ymin = double_parse(str);
    if (hasz)
    {
      /* zmin */
      p_whitespace(str);
      p_comma(str);
      p_whitespace(str);
      zmin = double_parse(str);
    }
    p_whitespace(str);
    if (! ensure_cparen(str, "spatiotemporal box"))
      return NULL;

    /* Parse optional comma */
    p_whitespace(str);
    p_comma(str);

    /* Parse upper bounds */
    p_whitespace(str);
    if (! ensure_oparen(str, "spatiotemporal box"))
      return NULL;
    /* xmax */
    xmax = double_parse(str);
    /* ymax */
    p_whitespace(str);
    p_comma(str);
    p_whitespace(str);
    ymax = double_parse(str);
    if (hasz)
    {
      /* zmax */
      p_whitespace(str);
      p_comma(str);
      p_whitespace(str);
      zmax = double_parse(str);
    }
    p_whitespace(str);
    if (! ensure_cparen(str, "spatiotemporal box"))
      return NULL;

    /* Parse enclosing closing parenthesis */
    p_whitespace(str);
    if (! ensure_cparen(str, "spatiotemporal box"))
      return NULL;

    if (hast)
    {
      p_whitespace(str);
      if (((*str)[0]) == ',')
      {
        hasx = true;
        *str += 1;
        p_whitespace(str);
      }
    }
  }

  if (hast)
    span_parse(str, T_TSTZSPAN, false, &period);

  /* Parse external closing parenthesis (if both space and time dimensions) */
  if (hast)
  {
    p_whitespace(str);
    if (! ensure_cparen(str, "spatiotemporal box"))
      return NULL;
  }

  /* Ensure there is no more input */
  if (! ensure_end_input(str, true, "spatiotemporal box"))
    return NULL;

  return stbox_make(hasx, hasz, geodetic, srid, xmin, xmax, ymin, ymax, zmin,
    zmax, hast ? &period : NULL);
}

/*****************************************************************************/

/**
 * @brief Parse a temporal instant point from the buffer.
 * @param[in] str Input string
 * @param[in] temptype Temporal type
 * @param[in] end Set to true when reading a single instant to ensure there is
 * no moreinput after the sequence
 * @param[in] make Set to false for the first pass to do not create the instant
 * @param[in,out] tpoint_srid SRID of the temporal point
 */
TInstant *
tpointinst_parse(const char **str, meosType temptype, bool end, bool make,
  int *tpoint_srid)
{
  p_whitespace(str);
  meosType basetype = temptype_basetype(temptype);
  /* The next instruction will throw an exception if it fails */
  Datum geo = temporal_basetype_parse(str, basetype);
  GSERIALIZED *gs = DatumGetGserializedP(geo);
  if (! ensure_point_type(gs) || ! ensure_non_empty(gs) ||
      ! ensure_has_not_M_gs(gs))
    return NULL;
  /* If one of the SRID of the temporal point and of the geometry
   * is SRID_UNKNOWN and the other not, copy the SRID */
  int geo_srid = gserialized_get_srid(gs);
  if (*tpoint_srid == SRID_UNKNOWN && geo_srid != SRID_UNKNOWN)
    *tpoint_srid = geo_srid;
  else if (*tpoint_srid != SRID_UNKNOWN && geo_srid == SRID_UNKNOWN)
    gserialized_set_srid(gs, *tpoint_srid);
  /* If the SRID of the temporal point and of the geometry do not match */
  else if (*tpoint_srid != SRID_UNKNOWN && geo_srid != SRID_UNKNOWN &&
    *tpoint_srid != geo_srid)
  {
    meos_error(ERROR, MEOS_ERR_TEXT_INPUT,
      "Geometry SRID (%d) does not match temporal type SRID (%d)",
      geo_srid, *tpoint_srid);
      return NULL;
  }
/* The next instruction will throw an exception if it fails */
  TimestampTz t = timestamp_parse(str);
  if (! ensure_end_input(str, end, "temporal point"))
    return NULL;
  TInstant *result = make ?
    tinstant_make(PointerGetDatum(gs), temptype, t) : NULL;
  pfree(gs);
  return result;
}

/**
 * @brief Parse a temporal discrete sequence point from the buffer.
 * @param[in] str Input string
 * @param[in] temptype Temporal type
 * @param[in,out] tpoint_srid SRID of the temporal point
 */
TSequence *
tpointseq_disc_parse(const char **str, meosType temptype, int *tpoint_srid)
{
  p_whitespace(str);
  /* We are sure to find an opening brace because that was the condition
   * to call this function in the dispatch function tpoint_parse */
  p_obrace(str);

  /* First parsing */
  const char *bak = *str;
  tpointinst_parse(str, temptype, false, false, tpoint_srid);
  int count = 1;
  while (p_comma(str))
  {
    count++;
    tpointinst_parse(str, temptype, false, false, tpoint_srid);
  }
  if (!p_cbrace(str))
  {
    meos_error(ERROR, MEOS_ERR_TEXT_INPUT,
      "Could not parse temporal point value: Missing closing brace");
    return NULL;
  }
  if (! ensure_end_input(str, true, "temporal point"))
    return NULL;

  /* Second parsing */
  *str = bak;
  TInstant **instants = palloc(sizeof(TInstant *) * count);
  for (int i = 0; i < count; i++)
  {
    p_comma(str);
    instants[i] = tpointinst_parse(str, temptype, false, true, tpoint_srid);
  }
  p_cbrace(str);
  return tsequence_make_free(instants, count, true, true, DISCRETE,
    NORMALIZE_NO);
}

/**
 * @brief Parse a temporal sequence point from the buffer.
 * @param[in] str Input string
 * @param[in] temptype Temporal type
 * @param[in] interp Interpolation
 * @param[in] end Set to true when reading a single instant to ensure there is
 * no moreinput after the sequence
 * @param[in] make Set to false for the first pass to do not create the instant
 * @param[in,out] tpoint_srid SRID of the temporal point
*/
TSequence *
tpointseq_cont_parse(const char **str, meosType temptype, interpType interp,
  bool end, bool make, int *tpoint_srid)
{
  p_whitespace(str);
  bool lower_inc = false, upper_inc = false;
  /* We are sure to find an opening bracket or parenthesis because that was the
   * condition to call this function in the dispatch function tpoint_parse */
  if (p_obracket(str))
    lower_inc = true;
  else if (p_oparen(str))
    lower_inc = false;

  /* First parsing */
  const char *bak = *str;
  tpointinst_parse(str, temptype, false, false, tpoint_srid);
  int count = 1;
  while (p_comma(str))
  {
    count++;
    tpointinst_parse(str, temptype, false, false, tpoint_srid);
  }
  if (p_cbracket(str))
    upper_inc = true;
  else if (p_cparen(str))
    upper_inc = false;
  else
  {
    meos_error(ERROR, MEOS_ERR_TEXT_INPUT,
      "Could not parse temporal point value: Missing closing bracket/parenthesis");
    return NULL;
  }
  /* Ensure there is no more input */
  if (! ensure_end_input(str, end, "temporal point"))
    return NULL;
  if (! make)
    return NULL;

  /* Second parsing */
  *str = bak;
  TInstant **instants = palloc(sizeof(TInstant *) * count);
  for (int i = 0; i < count; i++)
  {
    p_comma(str);
    instants[i] = tpointinst_parse(str, temptype, false, true, tpoint_srid);
  }
  p_cbracket(str);
  p_cparen(str);
  return tsequence_make_free(instants, count, lower_inc, upper_inc,
    interp, NORMALIZE);
}

/**
 * @brief Parse a temporal sequence set point from the buffer.
 * @param[in] str Input string
 * @param[in] temptype Temporal type
 * @param[in] interp Interpolation
 * @param[in,out] tpoint_srid SRID of the temporal point
 */
TSequenceSet *
tpointseqset_parse(const char **str, meosType temptype, interpType interp,
  int *tpoint_srid)
{
  p_whitespace(str);
  /* We are sure to find an opening brace because that was the condition
   * to call this function in the dispatch function tpoint_parse */
  p_obrace(str);

  /* First parsing */
  const char *bak = *str;
  tpointseq_cont_parse(str, temptype, interp, false, false, tpoint_srid);
  int count = 1;
  while (p_comma(str))
  {
    count++;
    tpointseq_cont_parse(str, temptype, interp, false, false, tpoint_srid);
  }
  if (!p_cbrace(str))
  {
    meos_error(ERROR, MEOS_ERR_INTERNAL_ERROR,
      "Could not parse temporal point value: Missing closing brace");
    return NULL;
  }
  if (! ensure_end_input(str, true, "temporal point"))
    return NULL;

  /* Second parsing */
  *str = bak;
  TSequence **sequences = palloc(sizeof(TSequence *) * count);
  for (int i = 0; i < count; i++)
  {
    p_comma(str);
    sequences[i] = tpointseq_cont_parse(str, temptype, interp, false, true,
      tpoint_srid);
  }
  p_cbrace(str);
  return tsequenceset_make_free(sequences, count, NORMALIZE);
}

/**
 * @brief Parse a temporal point value from the buffer.
 * @param[in] str Input string
 * @param[in] temptype Temporal type
 */
Temporal *
tpoint_parse(const char **str, meosType temptype)
{
  int tpoint_srid = 0;
  p_whitespace(str);

  /* Starts with "SRID=". The SRID specification must be gobbled for all
   * types excepted TInstant. We cannot use the atoi() function
   * because this requires a string terminated by '\0' and we cannot
   * modify the string in case it must be passed to the tpointinst_parse
   * function. */
  const char *bak = *str;
  if (pg_strncasecmp(*str, "SRID=", 5) == 0)
  {
    /* Move str to the start of the number part */
    *str += 5;
    int delim = 0;
    tpoint_srid = 0;
    /* Delimiter will be either ',' or ';' depending on whether interpolation
       is given after */
    while ((*str)[delim] != ',' && (*str)[delim] != ';' && (*str)[delim] != '\0')
    {
      tpoint_srid = tpoint_srid * 10 + (*str)[delim] - '0';
      delim++;
    }
    /* Set str to the start of the temporal point */
    *str += delim + 1;
  }

  /* We cannot ensure that the SRID is geodetic for geography since
   * the srid_is_latlong function is not exported by PostGIS */
  // if (temptype == T_TGEOGPOINT)
    // srid_is_latlong(fcinfo, tpoint_srid);

  interpType interp = temptype_continuous(temptype) ? LINEAR : STEP;
  /* Starts with "Interp=Step" */
  if (pg_strncasecmp(*str, "Interp=Step;", 12) == 0)
  {
    /* Move str after the semicolon */
    *str += 12;
    interp = STEP;
  }

  /* Allow spaces after the SRID and/or Interpolation */
  p_whitespace(str);

  Temporal *result = NULL; /* keep compiler quiet */
  /* Determine the type of the temporal point */
  if (**str != '{' && **str != '[' && **str != '(')
  {
    /* Pass the SRID specification */
    *str = bak;
    result = (Temporal *) tpointinst_parse(str, temptype, true, true,
      &tpoint_srid);
  }
  else if (**str == '[' || **str == '(')
    result = (Temporal *) tpointseq_cont_parse(str, temptype, interp, true, true,
      &tpoint_srid);
  else if (**str == '{')
  {
    bak = *str;
    p_obrace(str);
    p_whitespace(str);
    if (**str == '[' || **str == '(')
    {
      *str = bak;
      result = (Temporal *) tpointseqset_parse(str, temptype, interp,
        &tpoint_srid);
    }
    else
    {
      *str = bak;
      result = (Temporal *) tpointseq_disc_parse(str, temptype, &tpoint_srid);
    }
  }
  return result;
}

#if MEOS
/**
 * @ingroup libmeos_temporal_inout
 * @brief Return a temporal geometric point from its Well-Known Text (WKT)
 * representation.
 */
Temporal *
tgeompoint_in(const char *str)
{
  /* Ensure validity of the arguments */
  if (! ensure_not_null((void *) str))
    return NULL;
  return tpoint_parse(&str, T_TGEOMPOINT);
}
/**
 * @ingroup libmeos_temporal_inout
 * @brief Return a temporal geographic point from its Well-Known Text (WKT)
 * representation.
 */
Temporal *
tgeogpoint_in(const char *str)
{
  /* Ensure validity of the arguments */
  if (! ensure_not_null((void *) str))
    return NULL;
  return tpoint_parse(&str, T_TGEOGPOINT);
}
#endif /* MEOS */

/*****************************************************************************/
