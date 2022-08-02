/*****************************************************************************
 *
 * This MobilityDB code is provided under The PostgreSQL License.
 * Copyright (c) 2016-2022, Université libre de Bruxelles and MobilityDB
 * contributors
 *
 * MobilityDB includes portions of PostGIS version 3 source code released
 * under the GNU General Public License (GPLv2 or later).
 * Copyright (c) 2001-2022, PostGIS contributors
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
 * @brief Sections for the documentation of the MEOS library
 */

/*****************************************************************************
 * Sections of the external libMEOS API
 * These sections follow the ones of the MobilityDB documentation although
 * some subsections are merged into a single one
 *****************************************************************************/

/**
 * @defgroup libmeos MEOS library
 * @brief Mobility Engine Open Source (MEOS) library.
 *
 * @defgroup libmeos_api API of the MEOS library
 * @ingroup libmeos
 * @brief API of the Mobility Engine Open Source (MEOS) library.
 *
 * @defgroup libmeos_int Internal functions of the MEOS library
 * @ingroup libmeos
 * @brief Internal functions of Mobility Engine Open Source (MEOS) library.
 */

/**
 * @defgroup libmeos_base Functions for base types
 * @ingroup libmeos_api
 * @brief Functions for base types.

 * @defgroup libmeos_spantime Functions for span and time types
 * @ingroup libmeos_api
 * @brief Functions for span and time types.
 *
 * @defgroup libmeos_spantime_in_out Input/output functions
 * @ingroup libmeos_spantime
 * @brief Input/output functions for span and time types.
 *
 * @defgroup libmeos_spantime_constructor Constructors functions
 * @ingroup libmeos_spantime
 * @brief Constructor functions for span and time types.
 *
 * @defgroup libmeos_spantime_cast Cast functions
 * @ingroup libmeos_spantime
 * @brief Cast functions for span and time types.
 *
 * @defgroup libmeos_spantime_accessor Accessor functions
 * @ingroup libmeos_spantime
 * @brief Accessor functions for span and time types.
 *
 * @defgroup libmeos_spantime_transf Transformation functions
 * @ingroup libmeos_spantime
 * @brief Transformation functions for span and time types.
 *
 * @defgroup libmeos_spantime_bbox Bounding box functions
 * @ingroup libmeos_spantime
 * @brief Bounding box functions for span and time types.
 *
 * @defgroup libmeos_spantime_topo Topological functions
 * @ingroup libmeos_spantime_bbox
 * @brief Topological functions for span and time types.
 *
 * @defgroup libmeos_spantime_pos Position functions
 * @ingroup libmeos_spantime_bbox
 * @brief Position functions for span and time types.
 *
 * @defgroup libmeos_spantime_set Set functions
 * @ingroup libmeos_spantime
 * @brief Set functions for span and time types.
 *
 * @defgroup libmeos_spantime_dist Distance functions
 * @ingroup libmeos_spantime
 * @brief Distance functions for span and time types.
 *
 * @defgroup libmeos_spantime_comp Comparison functions
 * @ingroup libmeos_spantime
 * @brief Comparison functions for span and time types.
 */

/**
 * @defgroup libmeos_box Functions for box types
 * @ingroup libmeos_api
 * @brief Functions for box types.
 *
 * @defgroup libmeos_box_in_out Input/output functions
 * @ingroup libmeos_box
 * @brief Input/output functions for box types.
 *
 * @defgroup libmeos_box_constructor Constructor functions
 * @ingroup libmeos_box
 * @brief Constructor functions for box types.
 *
 * @defgroup libmeos_box_cast Cast functions
 * @ingroup libmeos_box
 * @brief Cast functions for box types.
 *
 * @defgroup libmeos_box_accessor Accessor functions
 * @ingroup libmeos_box
 * @brief Accessor functions for box types.
 *
 * @defgroup libmeos_box_transf Transformation functions
 * @ingroup libmeos_box
 * @brief Transformation functions for box types.
 *
 * @defgroup libmeos_box_topo Topological functions
 * @ingroup libmeos_box
 * @brief Topological functions for box types.
 *
 * @defgroup libmeos_box_pos Position functions
 * @ingroup libmeos_box
 * @brief Position functions for box types.
 *
 * @defgroup libmeos_box_set Set functions
 * @ingroup libmeos_box
 * @brief Set functions for box types.
 *
 * @defgroup libmeos_box_comp Comparison functions
 * @ingroup libmeos_box
 * @brief Comparison functions for box types.
 */

/**
 * @defgroup libmeos_temporal Functions for temporal types
 * @ingroup libmeos_api
 * @brief Functions for temporal types.
 *
 * @defgroup libmeos_temporal_in_out Input/output functions
 * @ingroup libmeos_temporal
 * @brief Input/output functions for temporal types.
 *
 * @defgroup libmeos_temporal_constructor Constructor functions
 * @ingroup libmeos_temporal
 * @brief Constructor functions for temporal types.
 *
 * @defgroup libmeos_temporal_cast Cast functions
 * @ingroup libmeos_temporal
 * @brief Cast functions for temporal types.
 *
 * @defgroup libmeos_temporal_accessor Accessor functions
 * @ingroup libmeos_temporal
 * @brief Accessor functions for temporal types.
 *
 * @defgroup libmeos_temporal_transf Transformation functions
 * @ingroup libmeos_temporal
 * @brief Transformation functions for temporal types.
 *
 * @defgroup libmeos_temporal_restrict Restriction functions
 * @ingroup libmeos_temporal
 * @brief Restriction functions for temporal types.
 *
 * @defgroup libmeos_temporal_bool Boolean functions
 * @ingroup libmeos_temporal
 * @brief Boolean functions for temporal types.
 *
 * @defgroup libmeos_temporal_math Mathematical functions
 * @ingroup libmeos_temporal
 * @brief Mathematical functions for temporal types.
 *
 * @defgroup libmeos_temporal_text Text functions
 * @ingroup libmeos_temporal
 * @brief Text functions for temporal types.
 *
 * @defgroup libmeos_temporal_bbox Bounding box functions
 * @ingroup libmeos_temporal
 * @brief Bounding box functions for temporal types.
 *
 * @defgroup libmeos_temporal_topo Topological functions
 * @ingroup libmeos_temporal_bbox
 * @brief Topological functions for temporal types.
 *
 * @defgroup libmeos_temporal_pos Position functions
 * @ingroup libmeos_temporal_bbox
 * @brief Position functions for temporal types.
 *
 * @defgroup libmeos_temporal_dist Distance functions
 * @ingroup libmeos_temporal
 * @brief Distance functions for temporal types.
 *
 * @defgroup libmeos_temporal_ever Ever/always functions
 * @ingroup libmeos_temporal
 * @brief Ever/always functions for temporal types.
 *
 * @defgroup libmeos_temporal_comp Comparison functions
 * @ingroup libmeos_temporal
 * @brief Comparison functions for temporal types.
 *
 * @defgroup libmeos_temporal_spatial Spatial functions
 * @ingroup libmeos_temporal
 * @brief Spatial functions for temporal point types.
 *
 * @defgroup libmeos_temporal_spatial_accessor Spatial accessor functions
 * @ingroup libmeos_temporal_spatial
 * @brief Spatial accessor functions for temporal point types.
 *
 * @defgroup libmeos_temporal_spatial_transf Spatial transformation functions
 * @ingroup libmeos_temporal_spatial
 * @brief Spatial transformation functions for temporal point types.
 *
 * @defgroup libmeos_temporal_spatial_rel Spatial relationship functions
 * @ingroup libmeos_temporal_spatial
 * @brief Spatial relationship functions for temporal point types.
 *
 * @defgroup libmeos_temporal_time Time functions
 * @ingroup libmeos_temporal
 * @brief Time functions for temporal types.
 *
 * @defgroup libmeos_temporal_agg Local aggregate functions
 * @ingroup libmeos_temporal
 * @brief Local aggregate functions for temporal types.
 *
 * @defgroup libmeos_temporal_tile Tile functions
 * @ingroup libmeos_temporal
 * @brief Tile functions for temporal types.
 *
 * @defgroup libmeos_temporal_similarity Similarity functions
 * @ingroup libmeos_temporal
 * @brief Similarity functions for temporal types.
 */

/*****************************************************************************
 * Sections of the libMEOS internal functions
 *****************************************************************************/

/**
 * @defgroup libmeos_int_spantime Functions for span and time types
 * @ingroup libmeos_int
 * @brief Functions for span and time types.
 *
 * @defgroup libmeos_int_spantime_in_out Input/output functions
 * @ingroup libmeos_int_spantime
 * @brief Input/output functions for span and time types.
 *
 * @defgroup libmeos_int_spantime_constructor Constructors functions
 * @ingroup libmeos_int_spantime
 * @brief Constructor functions for span and time types.
 *
 * @defgroup libmeos_int_spantime_cast Cast functions
 * @ingroup libmeos_int_spantime
 * @brief Cast functions for span and time types.
 *
 * @defgroup libmeos_int_spantime_accessor Accessor functions
 * @ingroup libmeos_int_spantime
 * @brief Accessor functions for span and time types.
 *
 * @defgroup libmeos_int_spantime_transf Transformation functions
 * @ingroup libmeos_int_spantime
 * @brief Transformation functions for span and time types.
 *
 * @defgroup libmeos_int_spantime_bbox Bounding box functions
 * @ingroup libmeos_int_spantime
 * @brief Bounding box functions for span and time types.
 *
 * @defgroup libmeos_int_spantime_topo Topological functions
 * @ingroup libmeos_int_spantime_bbox
 * @brief Topological functions for span and time types.
 *
 * @defgroup libmeos_int_spantime_pos Position functions
 * @ingroup libmeos_int_spantime_bbox
 * @brief Position functions for span and time types.
 *
 * @defgroup libmeos_int_spantime_set Set functions
 * @ingroup libmeos_int_spantime
 * @brief Set functions for span and time types.
 *
 * @defgroup libmeos_int_spantime_dist Distance functions
 * @ingroup libmeos_int_spantime
 * @brief Distance functions for span and time types.
 *
 * @defgroup libmeos_int_spantime_comp Comparison functions
 * @ingroup libmeos_int_spantime
 * @brief Comparison functions for span and time types.
 */

/**
 * @defgroup libmeos_int_box Functions for box types
 * @ingroup libmeos_int
 * @brief Functions for box types.
 *
 * @defgroup libmeos_int_box_in_out Input/output functions
 * @ingroup libmeos_int_box
 * @brief Input/output functions for box types.
 *
 * @defgroup libmeos_int_box_constructor Constructor functions
 * @ingroup libmeos_int_box
 * @brief Constructor functions for box types.
 *
 * @defgroup libmeos_int_box_cast Cast functions
 * @ingroup libmeos_int_box
 * @brief Cast functions for box types.
 *
 * @defgroup libmeos_int_box_accessor Accessor functions
 * @ingroup libmeos_int_box
 * @brief Accessor functions for box types.
 *
 * @defgroup libmeos_int_box_transf Transformation functions
 * @ingroup libmeos_int_box
 * @brief Transformation functions for box types.
 *
 * @defgroup libmeos_int_box_topo Topological functions
 * @ingroup libmeos_int_box
 * @brief Topological functions for box types.
 *
 * @defgroup libmeos_int_box_pos Position functions
 * @ingroup libmeos_int_box
 * @brief Position functions for box types.
 *
 * @defgroup libmeos_int_box_set Set functions
 * @ingroup libmeos_int_box
 * @brief Set functions for box types.
 *
 * @defgroup libmeos_int_box_comp Comparison functions
 * @ingroup libmeos_int_box
 * @brief Comparison functions for box types.
 */

/**
 * @defgroup libmeos_int_temporal Functions for temporal types
 * @ingroup libmeos_int
 * @brief Functions for temporal types.
 *
 * @defgroup libmeos_int_temporal_in_out Input/output functions
 * @ingroup libmeos_int_temporal
 * @brief Input/output functions for temporal types.
 *
 * @defgroup libmeos_int_temporal_constructor Constructor functions
 * @ingroup libmeos_int_temporal
 * @brief Constructor functions for temporal types.
 *
 * @defgroup libmeos_int_temporal_cast Cast functions
 * @ingroup libmeos_int_temporal
 * @brief Cast functions for temporal types.
 *
 * @defgroup libmeos_int_temporal_accessor Accessor functions
 * @ingroup libmeos_int_temporal
 * @brief Accessor functions for temporal types.
 *
 * @defgroup libmeos_int_temporal_transf Transformation functions
 * @ingroup libmeos_int_temporal
 * @brief Transformation functions for temporal types.
 *
 * @defgroup libmeos_int_temporal_restrict Restriction functions
 * @ingroup libmeos_int_temporal
 * @brief Restriction functions for temporal types.
 *
 * @defgroup libmeos_int_temporal_math Mathematical functions
 * @ingroup libmeos_int_temporal
 * @brief Mathematical functions for temporal types.
 *
 * @defgroup libmeos_int_temporal_dist Distance functions
 * @ingroup libmeos_int_temporal
 * @brief Distance functions for temporal types.
 *
 * @defgroup libmeos_int_temporal_ever Ever/always functions
 * @ingroup libmeos_int_temporal
 * @brief Ever/always functions for temporal types.
 *
 * @defgroup libmeos_int_temporal_comp Comparison functions
 * @ingroup libmeos_int_temporal
 * @brief Comparison functions for temporal types.
 *
 * @defgroup libmeos_int_temporal_spatial Spatial functions
 * @ingroup libmeos_int_temporal
 * @brief Spatial functions for temporal point types.
 *
 * @defgroup libmeos_int_temporal_spatial_accessor Spatial accessor functions
 * @ingroup libmeos_int_temporal_spatial
 * @brief Spatial accessor functions for temporal point types.
 *
 * @defgroup libmeos_int_temporal_spatial_transf Spatial transformation functions
 * @ingroup libmeos_int_temporal_spatial
 * @brief Spatial transformation functions for temporal point types.
 *
 * @defgroup libmeos_int_temporal_time Time functions
 * @ingroup libmeos_int_temporal
 * @brief Time functions for temporal types.
 *
 * @defgroup libmeos_int_temporal_agg Local aggregate functions
 * @ingroup libmeos_int_temporal
 * @brief Local aggregate functions for temporal types.
 */

/*****************************************************************************/
