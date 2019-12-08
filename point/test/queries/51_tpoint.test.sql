﻿-------------------------------------------------------------------------------
-- Input/output functions
-------------------------------------------------------------------------------

-- Temporal instant

SELECT astext(tgeompoint 'Point(1 1)@2012-01-01 08:00:00');
SELECT astext(tgeompoint '  Point(2 2)@2012-01-01 08:00:00  ');
SELECT astext(tgeogpoint 'Point(1 1)@2012-01-01 08:00:00');
SELECT astext(tgeogpoint '  Point(2 2) @ 2012-01-01 08:00:00  ');
/* Errors */
SELECT tgeompoint 'TRUE@2012-01-01 08:00:00';
SELECT tgeogpoint 'ABC@2012-01-01 08:00:00';
SELECT tgeompoint 'Point empty@2012-01-01 08:00:00';
SELECT tgeogpoint 'Point empty@2012-01-01 08:00:00';
SELECT tgeompoint 'Point(1 1)@2000-01-01 00:00:00+01 ,';
SELECT tgeogpoint 'Point(1 1)@2000-01-01 00:00:00+01 ,';

-------------------------------------------------------------------------------

-- Temporal instant set

SELECT astext(tgeompoint ' { Point(1 1)@2001-01-01 08:00:00 , Point(2 2)@2001-01-01 08:05:00 , Point(3 3)@2001-01-01 08:06:00 } ');
SELECT astext(tgeompoint '{Point(1 1)@2001-01-01 08:00:00,Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00}');
SELECT astext(tgeogpoint ' { Point(1 1)@2001-01-01 08:00:00 , Point(2 2)@2001-01-01 08:05:00 , Point(3 3)@2001-01-01 08:06:00 } ');
SELECT astext(tgeogpoint '{Point(1 1)@2001-01-01 08:00:00,Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00}');
/* Errors */
SELECT tgeompoint '{Point(1 1)@2001-01-01 08:00:00,Point empty@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00}';
SELECT tgeogpoint '{Point(1 1)@2001-01-01 08:00:00,Point empty@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00}';
SELECT tgeompoint '{Point(1 1)@2001-01-01 08:00:00,Point(2 2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00}';
SELECT tgeogpoint '{Point(1 1)@2001-01-01 08:00:00,Point(2 2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00}';
SELECT tgeompoint '{Point(1 1)@2001-01-01 08:00:00,Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]';
SELECT tgeogpoint '{Point(1 1)@2001-01-01 08:00:00,Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]';
SELECT tgeogpoint '{Point(1 1)@2001-01-01 08:00:00,Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00} xxx';
SELECT tgeogpoint '{Point(1 1)@2001-01-01 08:00:00,Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00} xxx';

-------------------------------------------------------------------------------

-- Temporal sequence

SELECT astext(tgeompoint ' [ Point(1 1)@2001-01-01 08:00:00 , Point(2 2)@2001-01-01 08:05:00 , Point(3 3)@2001-01-01 08:06:00 ] ');
SELECT astext(tgeompoint '[Point(1 1)@2001-01-01 08:00:00,Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]');
SELECT astext(tgeogpoint ' [ Point(1 1)@2001-01-01 08:00:00 , Point(2 2)@2001-01-01 08:05:00 , Point(3 3)@2001-01-01 08:06:00 ] ');
SELECT astext(tgeogpoint '[Point(1 1)@2001-01-01 08:00:00,Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]');
SELECT astext(tgeompoint '[Point(1 1 1)@2001-01-01, Point(2 2 2)@2001-01-02, Point(3 3 3)@2001-01-03]');
/* Errors */
SELECT tgeompoint '[Point(1 1)@2001-01-01 08:00:00,Point empty@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]';
SELECT tgeogpoint '[Point(1 1)@2001-01-01 08:00:00,Point empty@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]';
SELECT tgeompoint '[Point(1 1)@2001-01-01 08:00:00,Point(2 2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]';
SELECT tgeogpoint '[Point(1 1)@2001-01-01 08:00:00,Point(2 2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]';
SELECT tgeompoint '[Point(1 1)@2001-01-01 08:00:00,Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00}';
SELECT tgeogpoint '[Point(1 1)@2001-01-01 08:00:00,Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00}';
SELECT tgeompoint '[Point(1 1)@2001-01-01 08:00:00,Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00] xxx';
SELECT tgeogpoint '[Point(1 1)@2001-01-01 08:00:00,Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00] xxx';

-------------------------------------------------------------------------------

-- Temporal sequence set

SELECT astext(tgeompoint '  { [ Point(1 1)@2001-01-01 08:00:00 , Point(2 2)@2001-01-01 08:05:00 , Point(3 3)@2001-01-01 08:06:00 ],
 [ Point(1 1)@2001-01-01 09:00:00 , Point(2 2)@2001-01-01 09:05:00 , Point(1 1)@2001-01-01 09:06:00 ] } ');
SELECT astext(tgeompoint '{[Point(1 1)@2001-01-01 08:00:00,Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00],
 [Point(1 1)@2001-01-01 09:00:00,Point(2 2)@2001-01-01 09:05:00,Point(1 1)@2001-01-01 09:06:00]}');

SELECT astext(tgeogpoint '  { [ Point(1 1)@2001-01-01 08:00:00 , Point(2 2)@2001-01-01 08:05:00 , Point(3 3)@2001-01-01 08:06:00 ],
 [ Point(1 1)@2001-01-01 09:00:00 , Point(2 2)@2001-01-01 09:05:00 , Point(1 1)@2001-01-01 09:06:00 ] } ');
SELECT astext(tgeogpoint '{[Point(1 1)@2001-01-01 08:00:00,Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00],
 [Point(1 1)@2001-01-01 09:00:00,Point(2 2)@2001-01-01 09:05:00,Point(1 1)@2001-01-01 09:06:00]}');

/* Errors */
SELECT tgeompoint '{[Point(1 1)@2001-01-01 08:00:00, Point(2 2)@2001-01-01 08:05:00, Point(3 3)@2001-01-01 08:06:00],
 [Point(1 1)@2001-01-01 09:00:00, Point empty@2001-01-01 09:05:00, Point(1 1)@2001-01-01 09:06:00]}';
SELECT tgeogpoint '{[Point(1 1)@2001-01-01 08:00:00, Point(2 2)@2001-01-01 08:05:00, Point(3 3)@2001-01-01 08:06:00],
 [Point(1 1)@2001-01-01 09:00:00, Point empty@2001-01-01 09:05:00, Point(1 1)@2001-01-01 09:06:00]}';
SELECT tgeompoint '{[Point(1 1)@2001-01-01 08:00:00],[Point(2 2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]}';
SELECT tgeogpoint '{[Point(1 1)@2001-01-01 08:00:00],[Point(2 2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]}';
SELECT tgeompoint '{[Point(1 1)@2001-01-01 08:00:00],[Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]';
SELECT tgeogpoint '{[Point(1 1)@2001-01-01 08:00:00],[Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]';
SELECT tgeompoint '{[Point(1 1)@2001-01-01 08:00:00],[Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]} xxx';
SELECT tgeogpoint '{[Point(1 1)@2001-01-01 08:00:00],[Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]} xxx';

-------------------------------------------------------------------------------
-- SRID
-------------------------------------------------------------------------------

SELECT asewkt(tgeompoint 'SRID=4326;[Point(0 1)@2000-01-01, Point(0 1)@2000-01-02]');
SELECT asewkt(tgeompoint '[SRID=4326;Point(0 1)@2000-01-01, Point(0 1)@2000-01-02]');
SELECT asewkt(tgeompoint '[SRID=4326;Point(0 1)@2000-01-01, SRID=4326;Point(0 1)@2000-01-02]');

SELECT asewkt(tgeompoint 'SRID=4326;{[Point(0 1)@2000-01-01], [Point(0 1)@2000-01-02]}');
SELECT asewkt(tgeompoint '{[SRID=4326;Point(0 1)@2000-01-01], [Point(0 1)@2000-01-02]}');
SELECT asewkt(tgeompoint '{[SRID=4326;Point(0 1)@2000-01-01], [SRID=4326;Point(0 1)@2000-01-02]}');

/* Errors */
SELECT tgeompoint '{SRID=4326;Point(0 1)@2000-01-01, SRID=5434;Point(0 1)@2000-01-02}';
SELECT tgeompoint 'SRID=4326;{Point(0 1)@2000-01-01, SRID=5434;Point(0 1)@2000-01-02}';
SELECT tgeompoint '[SRID=4326;Point(0 1)@2000-01-01, SRID=5434;Point(0 1)@2000-01-02]';
SELECT tgeompoint 'SRID=4326;[Point(0 1)@2000-01-01, SRID=5434;Point(0 1)@2000-01-02]';
SELECT tgeompoint '{[SRID=4326;Point(0 1)@2000-01-01], [SRID=5434;Point(0 1)@2000-01-02]';
SELECT tgeompoint 'SRID=4326;{[Point(0 1)@2000-01-01], [SRID=5434;Point(0 1)@2000-01-02]}';
SELECT tgeogpoint 'SRID=5676;Point(1 1)@2001-01-01';
SELECT tgeogpoint '[SRID=4326;Point(0 1)@2000-01-01, SRID=4283;Point(0 1)@2000-01-02]';
SELECT tgeompoint 'SRID=5676;{Point(1 1)@2001-01-01 08:00:00,SRID=4326;Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00}';
SELECT tgeogpoint 'SRID=5676;{Point(1 1)@2001-01-01 08:00:00,SRID=4326;Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00}';
SELECT tgeompoint 'SRID=5676;[Point(1 1)@2001-01-01 08:00:00,SRID=4326;Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]';
SELECT tgeogpoint 'SRID=5676;[Point(1 1)@2001-01-01 08:00:00,SRID=4326;Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]';
SELECT tgeompoint 'SRID=5676;{[Point(1 1)@2001-01-01 08:00:00],[SRID=4326;Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]';
SELECT tgeogpoint 'SRID=5676;{[Point(1 1)@2001-01-01 08:00:00],[SRID=4326;Point(2 2)@2001-01-01 08:05:00,Point(3 3)@2001-01-01 08:06:00]';

-------------------------------------------------------------------------------
-- typmod
-------------------------------------------------------------------------------

SELECT format_type(oid, -1) FROM (SELECT oid FROM pg_type WHERE typname = 'tgeompoint') t;
SELECT format_type(oid, tgeompoint_typmod_in(ARRAY[cstring 'Instant','PointZ','5676']))
FROM (SELECT oid FROM pg_type WHERE typname = 'tgeompoint') t;
/* Errors */
SELECT tgeompoint_typmod_in(ARRAY[cstring 'Instant', NULL,'5676']);
SELECT tgeompoint_typmod_in(ARRAY[[cstring 'Instant'],[cstring 'PointZ'],[cstring '5676']]);

SELECT asewkt(tgeompoint(Instant) 'Point(0 1)@2000-01-01');
SELECT asewkt(tgeompoint(Instant) 'Point(0 1 1)@2000-01-01');
SELECT asewkt(tgeompoint(Instant, Point) 'Point(0 1)@2000-01-01');
SELECT asewkt(tgeompoint(Instant, PointZ) 'Point(0 1 0)@2000-01-01');
SELECT asewkt(tgeompoint(Point, 4326) 'SRID=4326;Point(0 1)@2000-01-01');
SELECT asewkt(tgeompoint(PointZ, 4326) 'SRID=4326;Point(0 1 0)@2000-01-01');
SELECT asewkt(tgeompoint(Instant, Point, 4326) 'SRID=4326;Point(0 1)@2000-01-01');
SELECT asewkt(tgeompoint(Instant, PointZ, 4326) 'SRID=4326;Point(0 1 0)@2000-01-01');

SELECT asewkt(tgeompoint(InstantSet) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(InstantSet) '{Point(0 1 1)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(InstantSet, Point) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(InstantSet, PointZ) '{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(Point, 4326) 'SRID=4326;{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(PointZ, 4326) 'SRID=4326;{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(InstantSet, Point, 4326) 'SRID=4326;{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(InstantSet, PointZ, 4326) 'SRID=4326;{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');

SELECT asewkt(tgeompoint(Sequence) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(Sequence) '[Point(0 1 1)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(Sequence, Point) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(Sequence, PointZ) '[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(Point, 4326) 'SRID=4326;[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(PointZ, 4326) 'SRID=4326;[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(Sequence, Point, 4326) 'SRID=4326;[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(Sequence, PointZ, 4326) 'SRID=4326;[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');

SELECT asewkt(tgeompoint(SequenceSet) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02], [Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(SequenceSet) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02], [Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(SequenceSet, Point) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02], [Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(SequenceSet, PointZ) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02], [Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(Point, 4326) 'SRID=4326;{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02], [Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(PointZ, 4326) 'SRID=4326;{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02], [Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(SequenceSet, Point, 4326) 'SRID=4326;{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02], [Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(SequenceSet, PointZ, 4326) 'SRID=4326;{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02], [Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');

SELECT asewkt(tgeogpoint(Instant,PointZ,4326) 'SRID=4326;Point(0 0 0)@2000-01-01');
SELECT asewkt(tgeogpoint(PointZ,4326) 'SRID=4326;Point(0 0 0)@2000-01-01');
SELECT asewkt(tgeompoint(Point) 'Point(0 0)@2000-01-01');
SELECT asewkt(tgeogpoint(PointZ) 'Point(0 0 0)@2000-01-01');

/* Errors */
SELECT tgeompoint(Instant,PointZ,5676,1234) 'SRID=5676;Point(0 0 0)@2000-01-01';
SELECT tgeompoint(Instan,PointZ,5676) 'SRID=5676;Point(0 0 0)@2000-01-01';
SELECT tgeompoint(Instant,PointZZ,5676) 'SRID=5676;Point(0 0 0)@2000-01-01';
SELECT tgeompoint(Instant,Point,5676) 'SRID=5676;Point(0 0 0)@2000-01-01';
SELECT tgeompoint(Instant,Polygon,5676) 'SRID=5676;Point(0 0 0)@2000-01-01';
SELECT tgeompoint(PointZZ,5676) 'SRID=5676;Point(0 0 0)@2000-01-01';
SELECT tgeompoint(Polygon,5676) 'SRID=5676;Point(0 0 0)@2000-01-01';
SELECT tgeompoint(Instant,PointZZ) 'SRID=5676;Point(0 0 0)@2000-01-01';
SELECT tgeompoint(Instant,Polygon) 'SRID=5676;Point(0 0 0)@2000-01-01';
SELECT tgeompoint(PointZZ) 'SRID=5676;Point(0 0 0)@2000-01-01';
SELECT tgeompoint(Polygon) 'SRID=5676;Point(0 0 0)@2000-01-01';
SELECT tgeompoint(1, 2) '{Point(1 1)@2000-01-01, Point(1 1)@2000-01-02}';
/* Errors */
SELECT asewkt(tgeompoint(Instant, PointZ) 'Point(0 1)@2000-01-01');
SELECT asewkt(tgeompoint(Instant, Point, 4326) 'Point(0 1)@2000-01-01');
SELECT asewkt(tgeompoint(Instant, Point, 4326) 'SRID=5434;Point(0 1)@2000-01-01');
SELECT asewkt(tgeompoint(InstantSet, Point) 'Point(0 1)@2000-01-01');
SELECT asewkt(tgeompoint(InstantSet, PointZ) 'Point(0 1)@2000-01-01');
SELECT asewkt(tgeompoint(Sequence, Point) 'Point(0 1)@2000-01-01');
SELECT asewkt(tgeompoint(Sequence, PointZ) 'Point(0 1)@2000-01-01');
SELECT asewkt(tgeompoint(SequenceSet, Point) 'Point(0 1)@2000-01-01');
SELECT asewkt(tgeompoint(SequenceSet, PointZ) 'Point(0 1)@2000-01-01');
/* Errors */
SELECT asewkt(tgeompoint(Instant, Point) 'Point(0 1 0)@2000-01-01');
SELECT asewkt(tgeompoint(Instant, PointZ, 4326) 'Point(0 1 0)@2000-01-01');
SELECT asewkt(tgeompoint(Instant, PointZ, 4326) 'SRID=5434;Point(0 1 0)@2000-01-01');
SELECT asewkt(tgeompoint(InstantSet, Point) 'Point(0 1 0)@2000-01-01');
SELECT asewkt(tgeompoint(InstantSet, PointZ) 'Point(0 1 0)@2000-01-01');
SELECT asewkt(tgeompoint(Sequence, Point) 'Point(0 1 0)@2000-01-01');
SELECT asewkt(tgeompoint(Sequence, PointZ) 'Point(0 1 0)@2000-01-01');
SELECT asewkt(tgeompoint(SequenceSet, Point) 'Point(0 1 0)@2000-01-01');
SELECT asewkt(tgeompoint(SequenceSet, PointZ) 'Point(0 1 0)@2000-01-01');
/* Errors */
SELECT asewkt(tgeompoint(Instant, Point) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(Instant, PointZ) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(InstantSet, Point, 4326) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(InstantSet, Point, 4326) 'SRID=5434;{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(InstantSet, PointZ) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(Sequence, Point) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(Sequence, PointZ) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(SequenceSet, Point) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(SequenceSet, PointZ) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
/* Errors */
SELECT asewkt(tgeompoint(Instant, Point) '{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(Instant, PointZ) '{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(InstantSet, Point) '{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(InstantSet, PointZ, 4326) '{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(InstantSet, PointZ, 4326) 'SRID=5434;{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(Sequence, Point) '{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(Sequence, PointZ) '{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(SequenceSet, Point) '{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeompoint(SequenceSet, PointZ) '{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
/* Errors */
SELECT asewkt(tgeompoint(Instant, Point) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(Instant, PointZ) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(InstantSet, Point) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(InstantSet, PointZ) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(Sequence, Point, 4326) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(Sequence, Point, 4326) 'SRID=5434;[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(Sequence, PointZ) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(SequenceSet, Point) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(SequenceSet, PointZ) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
/* Errors */
SELECT asewkt(tgeompoint(Instant, Point) '[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(Instant, PointZ) '[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(InstantSet, Point) '[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(InstantSet, PointZ) '[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(Sequence, Point) '[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(Sequence, PointZ, 4326) '[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(Sequence, PointZ, 4326) 'SRID=5434;[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(SequenceSet, Point) '[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeompoint(SequenceSet, PointZ) '[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
/* Errors */
SELECT asewkt(tgeompoint(Instant, Point) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02],
	[Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(Instant, PointZ) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02],
	[Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(InstantSet, Point) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02],
	[Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(InstantSet, PointZ) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02],
	[Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(Sequence, Point) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02],
	[Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(Sequence, PointZ) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02],
	[Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(SequenceSet, Point, 4326) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02],
	[Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(SequenceSet, Point, 4326) 'SRID=5434;{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02],
	[Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(SequenceSet, PointZ) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02],
	[Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
/* Errors */
SELECT asewkt(tgeompoint(Instant, Point) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02],
	[Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(Instant, PointZ) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02],
	[Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(InstantSet, Point) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02],
	[Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(InstantSet, PointZ) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02],
	[Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(Sequence, Point) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02],
	[Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(Sequence, PointZ) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02],
	[Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(SequenceSet, Point) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02],
	[Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(SequenceSet, PointZ, 4326) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02],
	[Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');
SELECT asewkt(tgeompoint(SequenceSet, PointZ, 4326) 'SRID=5434;{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02],
	[Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');

-------------------------------------------------------------------------------/
 
SELECT asewkt(tgeogpoint(Instant, Point) 'Point(0 1)@2000-01-01');
SELECT asewkt(tgeogpoint(Instant, PointZ) 'Point(0 1 0)@2000-01-01');
SELECT asewkt(tgeogpoint(InstantSet, Point) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeogpoint(InstantSet, PointZ) '{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeogpoint(Sequence, Point) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeogpoint(Sequence, PointZ) '[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeogpoint(SequenceSet, Point) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02],
	[Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeogpoint(SequenceSet, PointZ) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02],
	[Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');

/* Errors */
SELECT asewkt(tgeogpoint(Instant, PointZ) 'Point(0 1)@2000-01-01');
SELECT asewkt(tgeogpoint(InstantSet, Point) 'Point(0 1)@2000-01-01');
SELECT asewkt(tgeogpoint(InstantSet, PointZ) 'Point(0 1)@2000-01-01');
SELECT asewkt(tgeogpoint(Sequence, Point) 'Point(0 1)@2000-01-01');
SELECT asewkt(tgeogpoint(Sequence, PointZ) 'Point(0 1)@2000-01-01');
SELECT asewkt(tgeogpoint(SequenceSet, Point) 'Point(0 1)@2000-01-01');
SELECT asewkt(tgeogpoint(SequenceSet, PointZ) 'Point(0 1)@2000-01-01');
/* Errors */
SELECT asewkt(tgeogpoint(Instant, Point) 'Point(0 1 0)@2000-01-01');
SELECT asewkt(tgeogpoint(InstantSet, Point) 'Point(0 1 0)@2000-01-01');
SELECT asewkt(tgeogpoint(InstantSet, PointZ) 'Point(0 1 0)@2000-01-01');
SELECT asewkt(tgeogpoint(Sequence, Point) 'Point(0 1 0)@2000-01-01');
SELECT asewkt(tgeogpoint(Sequence, PointZ) 'Point(0 1 0)@2000-01-01');
SELECT asewkt(tgeogpoint(SequenceSet, Point) 'Point(0 1 0)@2000-01-01');
SELECT asewkt(tgeogpoint(SequenceSet, PointZ) 'Point(0 1 0)@2000-01-01');
/* Errors */
SELECT asewkt(tgeogpoint(Instant, Point) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeogpoint(Instant, PointZ) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeogpoint(InstantSet, PointZ) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeogpoint(Sequence, Point) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeogpoint(Sequence, PointZ) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeogpoint(SequenceSet, Point) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
SELECT asewkt(tgeogpoint(SequenceSet, PointZ) '{Point(0 1)@2000-01-01, Point(1 1)@2000-01-02}');
/* Errors */
SELECT asewkt(tgeogpoint(Instant, Point) '{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeogpoint(Instant, PointZ) '{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeogpoint(InstantSet, Point) '{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeogpoint(Sequence, Point) '{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeogpoint(Sequence, PointZ) '{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeogpoint(SequenceSet, Point) '{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
SELECT asewkt(tgeogpoint(SequenceSet, PointZ) '{Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02}');
/* Errors */
SELECT asewkt(tgeogpoint(Instant, Point) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeogpoint(Instant, PointZ) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeogpoint(InstantSet, Point) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeogpoint(InstantSet, PointZ) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeogpoint(Sequence, PointZ) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeogpoint(SequenceSet, Point) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
SELECT asewkt(tgeogpoint(SequenceSet, PointZ) '[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02]');
/* Errors */
SELECT asewkt(tgeogpoint(Instant, Point) '[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeogpoint(Instant, PointZ) '[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeogpoint(InstantSet, Point) '[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeogpoint(InstantSet, PointZ) '[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeogpoint(Sequence, Point) '[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeogpoint(SequenceSet, Point) '[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
SELECT asewkt(tgeogpoint(SequenceSet, PointZ) '[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02]');
/* Errors */
SELECT asewkt(tgeogpoint(Instant, Point) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02],
	[Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeogpoint(Instant, PointZ) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02],
	[Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeogpoint(InstantSet, Point) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02],
	[Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeogpoint(InstantSet, PointZ) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02],
	[Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeogpoint(Sequence, Point) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02],
	[Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeogpoint(Sequence, PointZ) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02],
	[Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
SELECT asewkt(tgeogpoint(SequenceSet, PointZ) '{[Point(0 1)@2000-01-01, Point(1 1)@2000-01-02],
	[Point(0 1)@2000-01-03, Point(1 1)@2000-01-04]}');
/* Errors */
SELECT asewkt(tgeogpoint(Instant, Point) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02],
	[Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');
SELECT asewkt(tgeogpoint(Instant, PointZ) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02],
	[Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');
SELECT asewkt(tgeogpoint(InstantSet, Point) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02],
	[Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');
SELECT asewkt(tgeogpoint(InstantSet, PointZ) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02],
	[Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');
SELECT asewkt(tgeogpoint(Sequence, Point) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02],
	[Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');
SELECT asewkt(tgeogpoint(Sequence, PointZ) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02],
	[Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');
SELECT asewkt(tgeogpoint(SequenceSet, Point) '{[Point(0 1 0)@2000-01-01, Point(1 1 1)@2000-01-02],
	[Point(0 1 0)@2000-01-03, Point(1 1 1)@2000-01-04]}');

-------------------------------------------------------------------------------
-- Constructor functions
-------------------------------------------------------------------------------

SELECT asewkt(tgeompointinst(ST_Point(1,1), '2012-01-01 08:00:00'));
SELECT asewkt(tgeompointinst(NULL, '2012-01-01 08:00:00'));
SELECT asewkt(tgeogpointinst(ST_Point(1,1), '2012-01-01 08:00:00'));
SELECT asewkt(tgeogpointinst(NULL, '2012-01-01 08:00:00'));
/* Errors */
SELECT asewkt(tgeompointinst(geometry 'point empty', timestamptz '2000-01-01'));
SELECT asewkt(tgeogpointinst(geography 'point empty', timestamptz '2000-01-01'));

-------------------------------------------------------------------------------

SELECT asewkt(tgeompointi(ARRAY[
tgeompointinst(ST_Point(1,1), '2012-01-01 08:00:00'),
tgeompointinst(ST_Point(2,2), '2012-01-01 08:10:00'),
tgeompointinst(ST_Point(1,1), '2012-01-01 08:20:00')
]));
SELECT asewkt(tgeogpointi(ARRAY[
tgeogpointinst(ST_Point(1,1), '2012-01-01 08:00:00'),
tgeogpointinst(ST_Point(2,2), '2012-01-01 08:10:00'),
tgeogpointinst(ST_Point(1,1), '2012-01-01 08:20:00')
]));

/* Errors */
SELECT tgeompointi(ARRAY[tgeompoint 'SRID=5676;Point(1 1)@2001-01-01', 'SRID=4326;Point(2 2)@2001-01-02']);
SELECT tgeompointi(ARRAY[tgeompoint 'Point(1 1)@2001-01-01', 'Point(2 2 2)@2001-01-02']);

-------------------------------------------------------------------------------

SELECT asewkt(tgeompointseq(ARRAY[
tgeompointinst(ST_Point(1,1), '2012-01-01 08:00:00'),
tgeompointinst(ST_Point(2,2), '2012-01-01 08:10:00'),
tgeompointinst(ST_Point(1,1), '2012-01-01 08:20:00')
]));
SELECT asewkt(tgeogpointseq(ARRAY[
tgeogpointinst(ST_Point(1,1), '2012-01-01 08:00:00'),
tgeogpointinst(ST_Point(2,2), '2012-01-01 08:10:00'),
tgeogpointinst(ST_Point(1,1), '2012-01-01 08:20:00')
]));

/* Errors */
SELECT tgeompointseq(ARRAY[tgeompoint 'SRID=5676;Point(1 1)@2001-01-01', 'SRID=4326;Point(2 2)@2001-01-02']);
SELECT tgeompointseq(ARRAY[tgeompoint 'Point(1 1)@2001-01-01', 'Point(2 2 2)@2001-01-02']);

-------------------------------------------------------------------------------

SELECT asewkt(tgeompoints(ARRAY[
tgeompointseq(ARRAY[
tgeompointinst(ST_Point(1,1), '2012-01-01 08:00:00'),
tgeompointinst(ST_Point(2,2), '2012-01-01 08:10:00'),
tgeompointinst(ST_Point(1,1), '2012-01-01 08:20:00')
]),
tgeompointseq(ARRAY[
tgeompointinst(ST_Point(1,1), '2012-01-01 09:00:00'),
tgeompointinst(ST_Point(2,2), '2012-01-01 09:10:00'),
tgeompointinst(ST_Point(1,1), '2012-01-01 09:20:00')
])]));
SELECT asewkt(tgeogpoints(ARRAY[
tgeogpointseq(ARRAY[
tgeogpointinst(ST_Point(1,1), '2012-01-01 08:00:00'),
tgeogpointinst(ST_Point(2,2), '2012-01-01 08:10:00'),
tgeogpointinst(ST_Point(3,3), '2012-01-01 08:20:00')
]),
tgeogpointseq(ARRAY[
tgeogpointinst(ST_Point(1,1), '2012-01-01 09:00:00'),
tgeogpointinst(ST_Point(2,2), '2012-01-01 09:10:00'),
tgeogpointinst(ST_Point(1,1), '2012-01-01 09:20:00')
])]));

/* Errors */
SELECT tgeompoints(ARRAY[tgeompoint '[SRID=5676;Point(1 1)@2001-01-01]', '[SRID=4326;Point(2 2)@2001-01-02]']);
SELECT tgeompoints(ARRAY[tgeompoint '[Point(1 1)@2001-01-01]', '[Point(2 2 2)@2001-01-02]']);

-------------------------------------------------------------------------------
-- Cast functions
-------------------------------------------------------------------------------

SELECT asewkt(tgeogpoint(tgeompoint 'Point(1 1)@2001-01-01'));
SELECT asewkt(tgeogpoint(tgeompoint '{Point(1 1)@2001-01-01, Point(2 2)@2001-01-02}'));
SELECT asewkt(tgeogpoint(tgeompoint '[Point(1 1)@2001-01-01, Point(1 1)@2001-01-02]'));
SELECT asewkt(tgeogpoint(tgeompoint '{[Point(1 1)@2001-01-01, Point(1 1)@2001-01-02], [Point(2 2)@2001-01-03, Point(2 2)@2001-01-04]}'));

-------------------------------------------------------------------------------
-- Transformation functions
-------------------------------------------------------------------------------

SELECT asewkt(tgeompointinst(tgeompoint 'Point(1 1)@2000-01-01'));
SELECT asewkt(tgeompointi(tgeompoint 'Point(1 1)@2000-01-01'));
SELECT asewkt(tgeompointi(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}'));
SELECT asewkt(tgeompointseq(tgeompoint 'Point(1 1)@2000-01-01'));
SELECT asewkt(tgeompointseq(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]'));
SELECT asewkt(tgeompoints(tgeompoint 'Point(1 1)@2000-01-01'));
SELECT asewkt(tgeompoints(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}'));
SELECT asewkt(tgeompoints(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]'));
SELECT asewkt(tgeompoints(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}'));
/* Errors */
SELECT asewkt(tgeompointinst(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}'));
SELECT asewkt(tgeompointinst(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]'));
SELECT asewkt(tgeompointinst(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}'));
SELECT asewkt(tgeompointi(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]'));
SELECT asewkt(tgeompointi(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}'));
SELECT asewkt(tgeompointseq(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}'));
SELECT asewkt(tgeompointseq(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}'));

SELECT asewkt(tgeogpointinst(tgeogpoint 'Point(1.5 1.5)@2000-01-01'));
SELECT asewkt(tgeogpointi(tgeogpoint 'Point(1.5 1.5)@2000-01-01'));
SELECT asewkt(tgeogpointi(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}'));
SELECT asewkt(tgeogpointseq(tgeogpoint 'Point(1.5 1.5)@2000-01-01'));
SELECT asewkt(tgeogpointseq(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]'));
SELECT asewkt(tgeogpoints(tgeogpoint 'Point(1.5 1.5)@2000-01-01'));
SELECT asewkt(tgeogpoints(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}'));
SELECT asewkt(tgeogpoints(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]'));
SELECT asewkt(tgeogpoints(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}'));
/* Errors */
SELECT asewkt(tgeogpointinst(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}'));
SELECT asewkt(tgeogpointinst(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]'));
SELECT asewkt(tgeogpointinst(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}'));
SELECT asewkt(tgeogpointi(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]'));
SELECT asewkt(tgeogpointi(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}'));
SELECT asewkt(tgeogpointseq(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}'));
SELECT asewkt(tgeogpointseq(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}'));

-------------------------------------------------------------------------------

SELECT astext(toLinear(tgeompoint 'Interp=Stepwise;[Point(1 1)@2000-01-01]'));
SELECT astext(toLinear(tgeompoint 'Interp=Stepwise;[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03, Point(2 2)@2000-01-04]'));
SELECT astext(toLinear(tgeompoint 'Interp=Stepwise;{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03, Point(2 2)@2000-01-04], [Point(3 3)@2000-01-05, Point(4 4)@2000-01-06]}'));

-------------------------------------------------------------------------------

SELECT astext(appendInstant(tgeompoint 'Point(1 1)@2000-01-01', tgeompoint 'Point(1 1)@2000-01-02'));
SELECT astext(appendInstant(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', tgeompoint 'Point(1 1)@2000-01-04'));
SELECT astext(appendInstant(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', tgeompoint 'Point(1 1)@2000-01-04'));
SELECT astext(appendInstant(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', tgeompoint 'Point(1 1)@2000-01-06'));
SELECT astext(appendInstant(tgeogpoint 'Point(1.5 1.5)@2000-01-01', tgeogpoint 'Point(1.5 1.5)@2000-01-02'));
SELECT astext(appendInstant(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', tgeogpoint 'Point(1.5 1.5)@2000-01-04'));
SELECT astext(appendInstant(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', tgeogpoint 'Point(1.5 1.5)@2000-01-04'));
SELECT astext(appendInstant(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', tgeogpoint 'Point(1.5 1.5)@2000-01-06'));

SELECT astext(appendInstant(tgeompoint 'Point(1 1 1)@2000-01-01', tgeompoint 'Point(1 1 1)@2000-01-02'));
SELECT astext(appendInstant(tgeompoint '{Point(1 1 1)@2000-01-01, Point(2 2 2)@2000-01-02, Point(1 1 1)@2000-01-03}', tgeompoint 'Point(1 1 1)@2000-01-04'));
SELECT astext(appendInstant(tgeompoint '[Point(1 1 1)@2000-01-01, Point(2 2 2)@2000-01-02, Point(1 1 1)@2000-01-03]', tgeompoint 'Point(1 1 1)@2000-01-04'));
SELECT astext(appendInstant(tgeompoint '{[Point(1 1 1)@2000-01-01, Point(2 2 2)@2000-01-02, Point(1 1 1)@2000-01-03],[Point(3 3 3)@2000-01-04, Point(3 3 3)@2000-01-05]}', tgeompoint 'Point(1 1 1)@2000-01-06'));
SELECT astext(appendInstant(tgeogpoint 'Point(1.5 1.5 1.5)@2000-01-01', tgeogpoint 'Point(1.5 1.5 1.5)@2000-01-02'));
SELECT astext(appendInstant(tgeogpoint '{Point(1.5 1.5 1.5)@2000-01-01, Point(2.5 2.5 2.5)@2000-01-02, Point(1.5 1.5 1.5)@2000-01-03}', tgeogpoint 'Point(1.5 1.5 1.5)@2000-01-04'));
SELECT astext(appendInstant(tgeogpoint '[Point(1.5 1.5 1.5)@2000-01-01, Point(2.5 2.5 2.5)@2000-01-02, Point(1.5 1.5 1.5)@2000-01-03]', tgeogpoint 'Point(1.5 1.5 1.5)@2000-01-04'));
SELECT astext(appendInstant(tgeogpoint '{[Point(1.5 1.5 1.5)@2000-01-01, Point(2.5 2.5 2.5)@2000-01-02, Point(1.5 1.5 1.5)@2000-01-03],[Point(3.5 3.5 3.5)@2000-01-04, Point(3.5 3.5 3.5)@2000-01-05]}', tgeogpoint 'Point(1.5 1.5 1.5)@2000-01-06'));

SELECT astext(appendInstant(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02]', tgeompoint 'Point(3 3)@2000-01-03'));
/* Errors */
SELECT astext(appendInstant(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02}', tgeompoint 'Point(3 3)@2000-01-02'));
SELECT astext(appendInstant(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02}', tgeompoint 'Point(3 3 3)@2000-01-03'));
SELECT astext(appendInstant(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02}', tgeompoint 'SRID=5676;Point(3 3)@2000-01-03'));
SELECT astext(appendInstant(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02]', tgeompoint 'Point(3 3)@2000-01-02'));
SELECT astext(appendInstant(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02]', tgeompoint 'Point(3 3 3)@2000-01-03'));
SELECT astext(appendInstant(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02]', tgeompoint 'SRID=5676;Point(3 3)@2000-01-03'));

-------------------------------------------------------------------------------
-- Accessor functions
-------------------------------------------------------------------------------

SELECT duration(tgeompoint 'Point(1 1)@2000-01-01');
SELECT duration(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}');
SELECT duration(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]');
SELECT duration(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}');
SELECT duration(tgeogpoint 'Point(1.5 1.5)@2000-01-01');
SELECT duration(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}');
SELECT duration(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]');
SELECT duration(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}');

SELECT memSize(tgeompoint 'Point(1 1)@2000-01-01');
SELECT memSize(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}');
SELECT memSize(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]');
SELECT memSize(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}');
SELECT memSize(tgeogpoint 'Point(1.5 1.5)@2000-01-01');
SELECT memSize(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}');
SELECT memSize(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]');
SELECT memSize(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}');

SELECT stbox(tgeompoint 'Point(1 1)@2000-01-01');
SELECT stbox(tgeogpoint 'Point(1.5 1.5)@2000-01-01');

SELECT st_asewkt(getValue(tgeompoint 'Point(1 1)@2000-01-01'));
SELECT st_asewkt(getValue(tgeogpoint 'Point(1.5 1.5)@2000-01-01'));
/* Errors */
SELECT st_asewkt(getValue(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}'));
SELECT st_asewkt(getValue(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]'));
SELECT st_asewkt(getValue(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}'));
SELECT st_asewkt(getValue(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}'));
SELECT st_asewkt(getValue(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]'));
SELECT st_asewkt(getValue(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}'));

SELECT st_asewkt(getValues(tgeompoint 'Point(1 1)@2000-01-01'));
SELECT st_asewkt(getValues(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}'));
SELECT st_asewkt(getValues(tgeompoint '{Point(1 1)@2000-01-01, Point(1 1)@2000-01-02}'));
SELECT st_asewkt(getValues(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]'));
SELECT st_asewkt(getValues(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}'));
SELECT st_asewkt(getValues(tgeogpoint 'Point(1.5 1.5)@2000-01-01'));
SELECT st_asewkt(getValues(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}'));
SELECT st_asewkt(getValues(tgeogpoint '{Point(1 1)@2000-01-01, Point(1 1)@2000-01-02}'));
SELECT st_asewkt(getValues(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]'));
SELECT st_asewkt(getValues(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}'));

SELECT st_asewkt(startValue(tgeompoint 'Point(1 1)@2000-01-01'));
SELECT st_asewkt(startValue(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}'));
SELECT st_asewkt(startValue(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]'));
SELECT st_asewkt(startValue(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}'));
SELECT st_asewkt(startValue(tgeogpoint 'Point(1.5 1.5)@2000-01-01'));
SELECT st_asewkt(startValue(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}'));
SELECT st_asewkt(startValue(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]'));
SELECT st_asewkt(startValue(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}'));

SELECT st_asewkt(endValue(tgeompoint 'Point(1 1)@2000-01-01'));
SELECT st_asewkt(endValue(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}'));
SELECT st_asewkt(endValue(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]'));
SELECT st_asewkt(endValue(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}'));
SELECT st_asewkt(endValue(tgeogpoint 'Point(1.5 1.5)@2000-01-01'));
SELECT st_asewkt(endValue(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}'));
SELECT st_asewkt(endValue(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]'));
SELECT st_asewkt(endValue(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}'));

SELECT getTimestamp(tgeompoint 'Point(1 1)@2000-01-01');
SELECT getTimestamp(tgeogpoint 'Point(1.5 1.5)@2000-01-01');
/* Errors */
SELECT getTimestamp(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}');
SELECT getTimestamp(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]');
SELECT getTimestamp(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}');
SELECT getTimestamp(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}');
SELECT getTimestamp(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]');
SELECT getTimestamp(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}');

SELECT getTime(tgeompoint 'Point(1 1)@2000-01-01');
SELECT getTime(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}');
SELECT getTime(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]');
SELECT getTime(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}');
SELECT getTime(tgeogpoint 'Point(1.5 1.5)@2000-01-01');
SELECT getTime(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}');
SELECT getTime(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]');
SELECT getTime(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}');

SELECT period(tgeompoint 'Point(1 1)@2000-01-01');
SELECT period(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}');
SELECT period(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]');
SELECT period(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}');
SELECT period(tgeogpoint 'Point(1.5 1.5)@2000-01-01');
SELECT period(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}');
SELECT period(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]');
SELECT period(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}');

SELECT timespan(tgeompoint 'Point(1 1)@2000-01-01');
SELECT timespan(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}');
SELECT timespan(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]');
SELECT timespan(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}');
SELECT timespan(tgeogpoint 'Point(1.5 1.5)@2000-01-01');
SELECT timespan(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}');
SELECT timespan(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]');
SELECT timespan(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}');

SELECT numSequences(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]');
SELECT numSequences(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}');
SELECT numSequences(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]');
SELECT numSequences(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}');
/* Errors */
SELECT numSequences(tgeompoint 'Point(1 1)@2000-01-01');
SELECT numSequences(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}');
SELECT numSequences(tgeogpoint 'Point(1.5 1.5)@2000-01-01');
SELECT numSequences(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}');

SELECT asewkt(startSequence(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]'));
SELECT asewkt(startSequence(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}'));
SELECT asewkt(startSequence(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]'));
SELECT asewkt(startSequence(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}'));
/* Errors */
SELECT asewkt(startSequence(tgeompoint 'Point(1 1)@2000-01-01'));
SELECT asewkt(startSequence(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}'));
SELECT asewkt(startSequence(tgeogpoint 'Point(1.5 1.5)@2000-01-01'));
SELECT asewkt(startSequence(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}'));

SELECT asewkt(endSequence(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]'));
SELECT asewkt(endSequence(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}'));
SELECT asewkt(endSequence(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]'));
SELECT asewkt(endSequence(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}'));
/* Errors */
SELECT asewkt(endSequence(tgeompoint 'Point(1 1)@2000-01-01'));
SELECT asewkt(endSequence(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}'));
SELECT asewkt(endSequence(tgeogpoint 'Point(1.5 1.5)@2000-01-01'));
SELECT asewkt(endSequence(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}'));

SELECT asewkt(sequenceN(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', 1));
SELECT asewkt(sequenceN(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', 1));
SELECT asewkt(sequenceN(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', 1));
SELECT asewkt(sequenceN(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', 1));
/* Errors */
SELECT asewkt(sequenceN(tgeompoint 'Point(1 1)@2000-01-01', 1));
SELECT asewkt(sequenceN(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', 1));
SELECT asewkt(sequenceN(tgeogpoint 'Point(1.5 1.5)@2000-01-01', 1));
SELECT asewkt(sequenceN(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', 1));

SELECT asewkt(sequences(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]'));
SELECT asewkt(sequences(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}'));
SELECT asewkt(sequences(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]'));
SELECT asewkt(sequences(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}'));
/* Errors */
SELECT asewkt(sequences(tgeompoint 'Point(1 1)@2000-01-01'));
SELECT asewkt(sequences(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}'));
SELECT asewkt(sequences(tgeogpoint 'Point(1.5 1.5)@2000-01-01'));
SELECT asewkt(sequences(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}'));

SELECT numInstants(tgeompoint 'Point(1 1)@2000-01-01');
SELECT numInstants(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}');
SELECT numInstants(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]');
SELECT numInstants(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}');
SELECT numInstants(tgeogpoint 'Point(1.5 1.5)@2000-01-01');
SELECT numInstants(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}');
SELECT numInstants(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]');
SELECT numInstants(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}');

SELECT asewkt(startInstant(tgeompoint 'Point(1 1)@2000-01-01'));
SELECT asewkt(startInstant(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}'));
SELECT asewkt(startInstant(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]'));
SELECT asewkt(startInstant(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}'));
SELECT asewkt(startInstant(tgeogpoint 'Point(1.5 1.5)@2000-01-01'));
SELECT asewkt(startInstant(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}'));
SELECT asewkt(startInstant(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]'));
SELECT asewkt(startInstant(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}'));

SELECT asewkt(endInstant(tgeompoint 'Point(1 1)@2000-01-01'));
SELECT asewkt(endInstant(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}'));
SELECT asewkt(endInstant(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]'));
SELECT asewkt(endInstant(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}'));
SELECT asewkt(endInstant(tgeogpoint 'Point(1.5 1.5)@2000-01-01'));
SELECT asewkt(endInstant(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}'));
SELECT asewkt(endInstant(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]'));
SELECT asewkt(endInstant(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}'));

SELECT asewkt(instantN(tgeompoint 'Point(1 1)@2000-01-01', 1));
SELECT asewkt(instantN(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', 1));
SELECT asewkt(instantN(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', 1));
SELECT asewkt(instantN(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', 1));
SELECT asewkt(instantN(tgeogpoint 'Point(1.5 1.5)@2000-01-01', 1));
SELECT asewkt(instantN(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', 1));
SELECT asewkt(instantN(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', 1));
SELECT asewkt(instantN(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', 1));

SELECT asewkt(instants(tgeompoint 'Point(1 1)@2000-01-01'));
SELECT asewkt(instants(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}'));
SELECT asewkt(instants(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]'));
SELECT asewkt(instants(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}'));
SELECT asewkt(instants(tgeogpoint 'Point(1.5 1.5)@2000-01-01'));
SELECT asewkt(instants(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}'));
SELECT asewkt(instants(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]'));
SELECT asewkt(instants(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}'));

SELECT numTimestamps(tgeompoint 'Point(1 1)@2000-01-01');
SELECT numTimestamps(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}');
SELECT numTimestamps(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]');
SELECT numTimestamps(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}');
SELECT numTimestamps(tgeogpoint 'Point(1.5 1.5)@2000-01-01');
SELECT numTimestamps(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}');
SELECT numTimestamps(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]');
SELECT numTimestamps(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}');

SELECT startTimestamp(tgeompoint 'Point(1 1)@2000-01-01');
SELECT startTimestamp(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}');
SELECT startTimestamp(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]');
SELECT startTimestamp(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}');
SELECT startTimestamp(tgeogpoint 'Point(1.5 1.5)@2000-01-01');
SELECT startTimestamp(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}');
SELECT startTimestamp(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]');
SELECT startTimestamp(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}');

SELECT endTimestamp(tgeompoint 'Point(1 1)@2000-01-01');
SELECT endTimestamp(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}');
SELECT endTimestamp(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]');
SELECT endTimestamp(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}');
SELECT endTimestamp(tgeogpoint 'Point(1.5 1.5)@2000-01-01');
SELECT endTimestamp(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}');
SELECT endTimestamp(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]');
SELECT endTimestamp(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}');

SELECT timestampN(tgeompoint 'Point(1 1)@2000-01-01', 1);
SELECT timestampN(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', 1);
SELECT timestampN(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', 1);
SELECT timestampN(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', 1);
SELECT timestampN(tgeogpoint 'Point(1.5 1.5)@2000-01-01', 1);
SELECT timestampN(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', 1);
SELECT timestampN(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', 1);
SELECT timestampN(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', 1);

SELECT timestamps(tgeompoint 'Point(1 1)@2000-01-01');
SELECT timestamps(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}');
SELECT timestamps(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]');
SELECT timestamps(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}');
SELECT timestamps(tgeogpoint 'Point(1.5 1.5)@2000-01-01');
SELECT timestamps(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}');
SELECT timestamps(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]');
SELECT timestamps(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}');

SELECT tgeompoint 'Point(1 1)@2000-01-01' ?= ST_Point(1,1);
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' ?= ST_Point(1,1);
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(1 1)@2000-01-02}' ?= ST_Point(2,2);
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' ?= ST_Point(1,1);
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' ?= ST_Point(1,1);
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' ?= ST_Point(1.5,1.5);
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' ?= ST_Point(1.5,1.5);
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' ?= ST_Point(1.5,1.5);
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' ?= ST_Point(1.5,1.5);

SELECT tgeompoint 'Point(1 1)@2000-01-01' ?= geometry 'Point empty';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' ?= geometry 'Point empty';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' ?= geometry 'Point empty';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' ?= geometry 'Point empty';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' ?= geography 'Point empty';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' ?= geography 'Point empty';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' ?= geography 'Point empty';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' ?= geography 'Point empty';

/* Errors */
SELECT tgeompoint 'Point(1 1)@2000-01-01' ?= geometry 'Linestring(1 1,2 2)';
SELECT tgeompoint 'Point(1 1)@2000-01-01' ?= geometry 'SRID=5676;Point(1 1)';
SELECT tgeompoint 'Point(1 1)@2000-01-01' ?= geometry 'Point(1 1 1)';
SELECT tgeogpoint 'Point(1 1)@2000-01-01' ?= geography 'Linestring(1 1,2 2)';
SELECT tgeogpoint 'Point(1 1)@2000-01-01' ?= geography 'SRID=4283;Point(1 1)';
SELECT tgeogpoint 'Point(1 1)@2000-01-01' ?= geography 'Point(1 1 1)';

SELECT tgeompoint 'Point(1 1)@2000-01-01' %= ST_Point(1,1);
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' %= ST_Point(1,1);
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' %= ST_Point(1,1);
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' %= ST_Point(1,1);
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' %= ST_Point(1.5,1.5);
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' %= ST_Point(1.5,1.5);
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' %= ST_Point(1.5,1.5);
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' %= ST_Point(1.5,1.5);
 
SELECT tgeompoint 'Point(1 1)@2000-01-01' %= geometry 'Point empty';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' %= geometry 'Point empty';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' %= geometry 'Point empty';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' %= geometry 'Point empty';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' %= geography 'Point empty';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' %= geography 'Point empty';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' %= geography 'Point empty';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' %= geography 'Point empty';
 
SELECT asewkt(shift(tgeompoint 'Point(1 1)@2000-01-01', '5 min'));
SELECT asewkt(shift(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', '5 min'));
SELECT asewkt(shift(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', '5 min'));
SELECT asewkt(shift(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', '5 min'));
SELECT asewkt(shift(tgeogpoint 'Point(1.5 1.5)@2000-01-01', '5 min'));
SELECT asewkt(shift(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', '5 min'));
SELECT asewkt(shift(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', '5 min'));
SELECT asewkt(shift(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', '5 min'));

/* Errors */
SELECT tgeompoint 'Point(1 1)@2000-01-01' %= geometry 'Linestring(1 1,2 2)';
SELECT tgeompoint 'Point(1 1)@2000-01-01' %= geometry 'SRID=5676;Point(1 1)';
SELECT tgeompoint 'Point(1 1)@2000-01-01' %= geometry 'Point(1 1 1)';
SELECT tgeogpoint 'Point(1 1)@2000-01-01' %= geography 'Linestring(1 1,2 2)';
SELECT tgeogpoint 'Point(1 1)@2000-01-01' %= geography 'SRID=4283;Point(1 1)';
SELECT tgeogpoint 'Point(1 1)@2000-01-01' %= geography 'Point(1 1 1)';

-------------------------------------------------------------------------------
-- Restriction functions
-------------------------------------------------------------------------------

SELECT astext(atValue(tgeompoint 'Point(1 1)@2000-01-01', ST_Point(1,1)));
SELECT astext(atValue(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', ST_Point(1,1)));
SELECT astext(atValue(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', ST_Point(1,1)));
SELECT astext(atValue(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', ST_Point(1,1)));
SELECT astext(atValue(tgeogpoint 'Point(1.5 1.5)@2000-01-01', ST_Point(1.5,1.5)));
SELECT astext(atValue(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', ST_Point(1.5,1.5)));
SELECT astext(atValue(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', ST_Point(1.5,1.5)));
SELECT astext(atValue(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', ST_Point(1.5,1.5)));

SELECT astext(atValue(tgeompoint 'Point(1 1)@2000-01-01', geometry 'Point empty'));
SELECT astext(atValue(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', geometry 'Point empty'));
SELECT astext(atValue(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', geometry 'Point empty'));
SELECT astext(atValue(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', geometry 'Point empty'));
SELECT astext(atValue(tgeogpoint 'Point(1 1)@2000-01-01', geography 'Point empty'));
SELECT astext(atValue(tgeogpoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', geography 'Point empty'));
SELECT astext(atValue(tgeogpoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', geography 'Point empty'));
SELECT astext(atValue(tgeogpoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', geography 'Point empty'));

/* Errors */
SELECT atValue(tgeompoint 'Point(1 1)@2000-01-01', geometry 'Linestring(1 1,2 2)');
SELECT atValue(tgeompoint 'Point(1 1)@2000-01-01', geometry 'SRID=5676;Point(1 1)');
SELECT atValue(tgeompoint 'Point(1 1)@2000-01-01', geometry 'Point(1 1 1)');
SELECT atValue(tgeogpoint 'Point(1 1)@2000-01-01', geography 'Linestring(1 1,2 2)');
SELECT atValue(tgeogpoint 'Point(1 1)@2000-01-01', geography 'SRID=4283;Point(1 1)');
SELECT atValue(tgeogpoint 'Point(1 1)@2000-01-01', geography 'Point(1 1 1)');

SELECT astext(minusValue(tgeompoint 'Point(1 1)@2000-01-01', ST_Point(1,1)));
SELECT astext(minusValue(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', ST_Point(1,1)));
SELECT astext(minusValue(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', ST_Point(1,1)));
SELECT astext(minusValue(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', ST_Point(1,1)));
SELECT astext(minusValue(tgeogpoint 'Point(1.5 1.5)@2000-01-01', ST_Point(1.5,1.5)));
SELECT astext(minusValue(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', ST_Point(1.5,1.5)));
SELECT astext(minusValue(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', ST_Point(1.5,1.5)));
SELECT astext(minusValue(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', ST_Point(1.5,1.5)));

SELECT astext(minusValue(tgeompoint 'Point(1 1)@2000-01-01', geometry 'Point empty'));
SELECT astext(minusValue(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', geometry 'Point empty'));
SELECT astext(minusValue(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', geometry 'Point empty'));
SELECT astext(minusValue(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', geometry 'Point empty'));
SELECT astext(minusValue(tgeogpoint 'Point(1 1)@2000-01-01', geography 'Point empty'));
SELECT astext(minusValue(tgeogpoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', geography 'Point empty'));
SELECT astext(minusValue(tgeogpoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', geography 'Point empty'));
SELECT astext(minusValue(tgeogpoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', geography 'Point empty'));

/* Errors */
SELECT minusValue(tgeompoint 'Point(1 1)@2000-01-01', geometry 'Linestring(1 1,2 2)');
SELECT minusValue(tgeompoint 'Point(1 1)@2000-01-01', geometry 'SRID=5676;Point(1 1)');
SELECT minusValue(tgeompoint 'Point(1 1)@2000-01-01', geometry 'Point(1 1 1)');
SELECT minusValue(tgeogpoint 'Point(1 1)@2000-01-01', geography 'Linestring(1 1,2 2)');
SELECT minusValue(tgeogpoint 'Point(1 1)@2000-01-01', geography 'SRID=4283;Point(1 1)');
SELECT minusValue(tgeogpoint 'Point(1 1)@2000-01-01', geography 'Point(1 1 1)');

SELECT astext(atValues(tgeompoint 'Point(1 1)@2000-01-01', ARRAY[ST_Point(1,1)]));
SELECT astext(atValues(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', ARRAY[ST_Point(1,1)]));
SELECT astext(atValues(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', ARRAY[ST_Point(1,1)]));
SELECT astext(atValues(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', ARRAY[ST_Point(1,1)]));
SELECT astext(atValues(tgeogpoint 'Point(1.5 1.5)@2000-01-01', ARRAY[ST_Point(1.5,1.5)]));
SELECT astext(atValues(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', ARRAY[ST_Point(1.5,1.5)]));
SELECT astext(atValues(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', ARRAY[ST_Point(1.5,1.5)]));
SELECT astext(atValues(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', ARRAY[ST_Point(1.5,1.5)]));

SELECT astext(atValues(tgeompoint 'Point(1 1)@2000-01-01', ARRAY[geometry 'Point empty']));
SELECT astext(atValues(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', ARRAY[geometry 'Point empty']));
SELECT astext(atValues(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', ARRAY[geometry 'Point empty']));
SELECT astext(atValues(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', ARRAY[geometry 'Point empty']));
SELECT astext(atValues(tgeogpoint 'Point(1.5 1.5)@2000-01-01', ARRAY[geography 'Point empty']));
SELECT astext(atValues(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', ARRAY[geography 'Point empty']));
SELECT astext(atValues(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', ARRAY[geography 'Point empty']));
SELECT astext(atValues(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', ARRAY[geography 'Point empty']));

--NULL
SELECT atValues(tgeompoint '{Point(1 1)@2000-01-01}', '{}'::geometry[]);
SELECT atValues(tgeogpoint '{Point(1 1)@2000-01-01}', '{}'::geography[]);

/* Errors */
SELECT atValues(tgeompoint 'Point(1 1)@2000-01-01', ARRAY[geometry 'Linestring(1 1,2 2)']);
SELECT atValues(tgeompoint 'Point(1 1)@2000-01-01', ARRAY[geometry 'SRID=5676;Point(1 1)']);
SELECT atValues(tgeompoint 'Point(1 1)@2000-01-01', ARRAY[geometry 'Point(1 1 1)']);
SELECT atValues(tgeogpoint 'Point(1 1)@2000-01-01', ARRAY[geography 'Linestring(1 1,2 2)']);
SELECT atValues(tgeogpoint 'Point(1 1)@2000-01-01', ARRAY[geography 'SRID=4283;Point(1 1)']);
SELECT atValues(tgeogpoint 'Point(1 1)@2000-01-01', ARRAY[geography 'Point(1 1 1)']);

SELECT astext(minusValues(tgeompoint 'Point(1 1)@2000-01-01', ARRAY[ST_Point(1,1)]));
SELECT astext(minusValues(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', ARRAY[ST_Point(1,1)]));
SELECT astext(minusValues(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', ARRAY[ST_Point(1,1)]));
SELECT astext(minusValues(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', ARRAY[ST_Point(1,1)]));
SELECT astext(minusValues(tgeogpoint 'Point(1.5 1.5)@2000-01-01', ARRAY[ST_Point(1.5,1.5)]));
SELECT astext(minusValues(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', ARRAY[ST_Point(1.5,1.5)]));
SELECT astext(minusValues(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', ARRAY[ST_Point(1.5,1.5)]));
SELECT astext(minusValues(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', ARRAY[ST_Point(1.5,1.5)]));

SELECT astext(minusValues(tgeompoint 'Point(1 1)@2000-01-01', ARRAY[geometry 'Point empty']));
SELECT astext(minusValues(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', ARRAY[geometry 'Point empty']));
SELECT astext(minusValues(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', ARRAY[geometry 'Point empty']));
SELECT astext(minusValues(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', ARRAY[geometry 'Point empty']));
SELECT astext(minusValues(tgeogpoint 'Point(1.5 1.5)@2000-01-01', ARRAY[geography 'Point empty']));
SELECT astext(minusValues(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', ARRAY[geography 'Point empty']));
SELECT astext(minusValues(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', ARRAY[geography 'Point empty']));
SELECT astext(minusValues(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', ARRAY[geography 'Point empty']));

SELECT astext(minusValues(tgeompoint '{Point(1 1)@2000-01-01}', '{}'::geometry[]));
SELECT astext(minusValues(tgeogpoint '{Point(1 1)@2000-01-01}', '{}'::geography[]));

/* Errors */
SELECT minusValues(tgeompoint 'Point(1 1)@2000-01-01', ARRAY[geometry 'Linestring(1 1,2 2)']);
SELECT minusValues(tgeompoint 'Point(1 1)@2000-01-01', ARRAY[geometry 'SRID=5676;Point(1 1)']);
SELECT minusValues(tgeompoint 'Point(1 1)@2000-01-01', ARRAY[geometry 'Point(1 1 1)']);
SELECT minusValues(tgeogpoint 'Point(1 1)@2000-01-01', ARRAY[geography 'Linestring(1 1,2 2)']);
SELECT minusValues(tgeogpoint 'Point(1 1)@2000-01-01', ARRAY[geography 'SRID=4283;Point(1 1)']);
SELECT minusValues(tgeogpoint 'Point(1 1)@2000-01-01', ARRAY[geography 'Point(1 1 1)']);

SELECT astext(atTimestamp(tgeompoint 'Point(1 1)@2000-01-01', timestamptz '2000-01-01'));
SELECT astext(atTimestamp(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', timestamptz '2000-01-01'));
SELECT astext(atTimestamp(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', timestamptz '2000-01-01'));
SELECT astext(atTimestamp(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', timestamptz '2000-01-01'));
SELECT astext(atTimestamp(tgeogpoint 'Point(1.5 1.5)@2000-01-01', timestamptz '2000-01-01'));
SELECT astext(atTimestamp(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', timestamptz '2000-01-01'));
SELECT astext(atTimestamp(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', timestamptz '2000-01-01'));
SELECT astext(atTimestamp(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', timestamptz '2000-01-01'));

SELECT st_astext(valueAtTimestamp(tgeompoint 'Point(1 1)@2000-01-01', timestamptz '2000-01-01'));
SELECT st_astext(valueAtTimestamp(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', timestamptz '2000-01-01'));
SELECT st_astext(valueAtTimestamp(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', timestamptz '2000-01-01'));
SELECT st_astext(valueAtTimestamp(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', timestamptz '2000-01-01'));
SELECT st_astext(valueAtTimestamp(tgeogpoint 'Point(1.5 1.5)@2000-01-01', timestamptz '2000-01-01'));
SELECT st_astext(valueAtTimestamp(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', timestamptz '2000-01-01'));
SELECT st_astext(valueAtTimestamp(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', timestamptz '2000-01-01'));
SELECT st_astext(valueAtTimestamp(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', timestamptz '2000-01-01'));

SELECT astext(minusTimestamp(tgeompoint 'Point(1 1)@2000-01-01', timestamptz '2000-01-01'));
SELECT astext(minusTimestamp(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', timestamptz '2000-01-01'));
SELECT astext(minusTimestamp(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', timestamptz '2000-01-01'));
SELECT astext(minusTimestamp(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', timestamptz '2000-01-01'));
SELECT astext(minusTimestamp(tgeogpoint 'Point(1.5 1.5)@2000-01-01', timestamptz '2000-01-01'));
SELECT astext(minusTimestamp(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', timestamptz '2000-01-01'));
SELECT astext(minusTimestamp(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', timestamptz '2000-01-01'));
SELECT astext(minusTimestamp(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', timestamptz '2000-01-01'));

SELECT astext(atTimestampSet(tgeompoint 'Point(1 1)@2000-01-01', timestampset '{2000-01-01}'));
SELECT astext(atTimestampSet(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', timestampset '{2000-01-01}'));
SELECT astext(atTimestampSet(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', timestampset '{2000-01-01}'));
SELECT astext(atTimestampSet(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', timestampset '{2000-01-01}'));
SELECT astext(atTimestampSet(tgeogpoint 'Point(1.5 1.5)@2000-01-01', timestampset '{2000-01-01}'));
SELECT astext(atTimestampSet(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', timestampset '{2000-01-01}'));
SELECT astext(atTimestampSet(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', timestampset '{2000-01-01}'));
SELECT astext(atTimestampSet(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', timestampset '{2000-01-01}'));

SELECT astext(minusTimestampSet(tgeompoint 'Point(1 1)@2000-01-01', timestampset '{2000-01-01}'));
SELECT astext(minusTimestampSet(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', timestampset '{2000-01-01}'));
SELECT astext(minusTimestampSet(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', timestampset '{2000-01-01}'));
SELECT astext(minusTimestampSet(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', timestampset '{2000-01-01}'));
SELECT astext(minusTimestampSet(tgeogpoint 'Point(1.5 1.5)@2000-01-01', timestampset '{2000-01-01}'));
SELECT astext(minusTimestampSet(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', timestampset '{2000-01-01}'));
SELECT astext(minusTimestampSet(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', timestampset '{2000-01-01}'));
SELECT astext(minusTimestampSet(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', timestampset '{2000-01-01}'));

SELECT astext(atPeriod(tgeompoint 'Point(1 1)@2000-01-01', period '[2000-01-01,2000-01-02]'));
SELECT astext(atPeriod(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', period '[2000-01-01,2000-01-02]'));
SELECT astext(atPeriod(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', period '[2000-01-01,2000-01-02]'));
SELECT astext(atPeriod(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', period '[2000-01-01,2000-01-02]'));
SELECT astext(atPeriod(tgeogpoint 'Point(1.5 1.5)@2000-01-01', period '[2000-01-01,2000-01-02]'));
SELECT astext(atPeriod(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', period '[2000-01-01,2000-01-02]'));
SELECT astext(atPeriod(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', period '[2000-01-01,2000-01-02]'));
SELECT astext(atPeriod(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', period '[2000-01-01,2000-01-02]'));

SELECT astext(minusPeriod(tgeompoint 'Point(1 1)@2000-01-01', period '[2000-01-01,2000-01-02]'));
SELECT astext(minusPeriod(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', period '[2000-01-01,2000-01-02]'));
SELECT astext(minusPeriod(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', period '[2000-01-01,2000-01-02]'));
SELECT astext(minusPeriod(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', period '[2000-01-01,2000-01-02]'));
SELECT astext(minusPeriod(tgeogpoint 'Point(1.5 1.5)@2000-01-01', period '[2000-01-01,2000-01-02]'));
SELECT astext(minusPeriod(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', period '[2000-01-01,2000-01-02]'));
SELECT astext(minusPeriod(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', period '[2000-01-01,2000-01-02]'));
SELECT astext(minusPeriod(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', period '[2000-01-01,2000-01-02]'));

SELECT astext(atPeriodSet(tgeompoint 'Point(1 1)@2000-01-01', periodset '{[2000-01-01,2000-01-02]}'));
SELECT astext(atPeriodSet(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', periodset '{[2000-01-01,2000-01-02]}'));
SELECT astext(atPeriodSet(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', periodset '{[2000-01-01,2000-01-02]}'));
SELECT astext(atPeriodSet(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', periodset '{[2000-01-01,2000-01-02]}'));
SELECT astext(atPeriodSet(tgeogpoint 'Point(1.5 1.5)@2000-01-01', periodset '{[2000-01-01,2000-01-02]}'));
SELECT astext(atPeriodSet(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', periodset '{[2000-01-01,2000-01-02]}'));
SELECT astext(atPeriodSet(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', periodset '{[2000-01-01,2000-01-02]}'));
SELECT astext(atPeriodSet(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', periodset '{[2000-01-01,2000-01-02]}'));

SELECT astext(minusPeriodSet(tgeompoint 'Point(1 1)@2000-01-01', periodset '{[2000-01-01,2000-01-02]}'));
SELECT astext(minusPeriodSet(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', periodset '{[2000-01-01,2000-01-02]}'));
SELECT astext(minusPeriodSet(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', periodset '{[2000-01-01,2000-01-02]}'));
SELECT astext(minusPeriodSet(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', periodset '{[2000-01-01,2000-01-02]}'));
SELECT astext(minusPeriodSet(tgeogpoint 'Point(1.5 1.5)@2000-01-01', periodset '{[2000-01-01,2000-01-02]}'));
SELECT astext(minusPeriodSet(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', periodset '{[2000-01-01,2000-01-02]}'));
SELECT astext(minusPeriodSet(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', periodset '{[2000-01-01,2000-01-02]}'));
SELECT astext(minusPeriodSet(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', periodset '{[2000-01-01,2000-01-02]}'));

SELECT intersectsTimestamp(tgeompoint 'Point(1 1)@2000-01-01', timestamptz '2000-01-01');
SELECT intersectsTimestamp(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', timestamptz '2000-01-01');
SELECT intersectsTimestamp(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', timestamptz '2000-01-01');
SELECT intersectsTimestamp(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', timestamptz '2000-01-01');
SELECT intersectsTimestamp(tgeogpoint 'Point(1.5 1.5)@2000-01-01', timestamptz '2000-01-01');
SELECT intersectsTimestamp(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', timestamptz '2000-01-01');
SELECT intersectsTimestamp(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', timestamptz '2000-01-01');
SELECT intersectsTimestamp(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', timestamptz '2000-01-01');

SELECT intersectsTimestampSet(tgeompoint 'Point(1 1)@2000-01-01', timestampset '{2000-01-01}');
SELECT intersectsTimestampSet(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', timestampset '{2000-01-01}');
SELECT intersectsTimestampSet(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', timestampset '{2000-01-01}');
SELECT intersectsTimestampSet(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', timestampset '{2000-01-01}');
SELECT intersectsTimestampSet(tgeogpoint 'Point(1.5 1.5)@2000-01-01', timestampset '{2000-01-01}');
SELECT intersectsTimestampSet(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', timestampset '{2000-01-01}');
SELECT intersectsTimestampSet(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', timestampset '{2000-01-01}');
SELECT intersectsTimestampSet(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', timestampset '{2000-01-01}');

SELECT intersectsPeriod(tgeompoint 'Point(1 1)@2000-01-01', period '[2000-01-01,2000-01-02]');
SELECT intersectsPeriod(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', period '[2000-01-01,2000-01-02]');
SELECT intersectsPeriod(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', period '[2000-01-01,2000-01-02]');
SELECT intersectsPeriod(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', period '[2000-01-01,2000-01-02]');
SELECT intersectsPeriod(tgeogpoint 'Point(1.5 1.5)@2000-01-01', period '[2000-01-01,2000-01-02]');
SELECT intersectsPeriod(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', period '[2000-01-01,2000-01-02]');
SELECT intersectsPeriod(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', period '[2000-01-01,2000-01-02]');
SELECT intersectsPeriod(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', period '[2000-01-01,2000-01-02]');

SELECT intersectsPeriodSet(tgeompoint 'Point(1 1)@2000-01-01', periodset '{[2000-01-01,2000-01-02]}');
SELECT intersectsPeriodSet(tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}', periodset '{[2000-01-01,2000-01-02]}');
SELECT intersectsPeriodSet(tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]', periodset '{[2000-01-01,2000-01-02]}');
SELECT intersectsPeriodSet(tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}', periodset '{[2000-01-01,2000-01-02]}');
SELECT intersectsPeriodSet(tgeogpoint 'Point(1.5 1.5)@2000-01-01', periodset '{[2000-01-01,2000-01-02]}');
SELECT intersectsPeriodSet(tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}', periodset '{[2000-01-01,2000-01-02]}');
SELECT intersectsPeriodSet(tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]', periodset '{[2000-01-01,2000-01-02]}');
SELECT intersectsPeriodSet(tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}', periodset '{[2000-01-01,2000-01-02]}');

-------------------------------------------------------------------------------
-- Comparison functions and B-tree indexing
-------------------------------------------------------------------------------

SELECT tgeompoint 'Point(1 1)@2000-01-01' = tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' = tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' = tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' = tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint 'Point(1 1)@2000-01-01' = tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' = tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' = tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' = tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint 'Point(1 1)@2000-01-01' = tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' = tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' = tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' = tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint 'Point(1 1)@2000-01-01' = tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' = tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' = tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' = tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';

SELECT tgeompoint 'Point(1 1)@2000-01-01' <> tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' <> tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' <> tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' <> tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint 'Point(1 1)@2000-01-01' <> tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' <> tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' <> tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' <> tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint 'Point(1 1)@2000-01-01' <> tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' <> tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' <> tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' <> tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint 'Point(1 1)@2000-01-01' <> tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' <> tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' <> tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' <> tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';

SELECT tgeompoint 'Point(1 1)@2000-01-01' < tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' < tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' < tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' < tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint 'Point(1 1)@2000-01-01' < tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' < tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' < tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' < tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint 'Point(1 1)@2000-01-01' < tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' < tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' < tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' < tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint 'Point(1 1)@2000-01-01' < tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' < tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' < tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' < tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';

SELECT tgeompoint 'Point(1 1)@2000-01-01' <= tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' <= tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' <= tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' <= tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint 'Point(1 1)@2000-01-01' <= tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' <= tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' <= tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' <= tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint 'Point(1 1)@2000-01-01' <= tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' <= tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' <= tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' <= tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint 'Point(1 1)@2000-01-01' <= tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' <= tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' <= tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' <= tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';

SELECT tgeompoint 'Point(1 1)@2000-01-01' > tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' > tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' > tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' > tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint 'Point(1 1)@2000-01-01' > tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' > tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' > tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' > tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint 'Point(1 1)@2000-01-01' > tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' > tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' > tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' > tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint 'Point(1 1)@2000-01-01' > tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' > tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' > tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' > tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';

SELECT tgeompoint 'Point(1 1)@2000-01-01' >= tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' >= tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' >= tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' >= tgeompoint 'Point(1 1)@2000-01-01';
SELECT tgeompoint 'Point(1 1)@2000-01-01' >= tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' >= tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' >= tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' >= tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}';
SELECT tgeompoint 'Point(1 1)@2000-01-01' >= tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' >= tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' >= tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' >= tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]';
SELECT tgeompoint 'Point(1 1)@2000-01-01' >= tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '{Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03}' >= tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03]' >= tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';
SELECT tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}' >= tgeompoint '{[Point(1 1)@2000-01-01, Point(2 2)@2000-01-02, Point(1 1)@2000-01-03],[Point(3 3)@2000-01-04, Point(3 3)@2000-01-05]}';

SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' = tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' = tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' = tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' = tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' = tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' = tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' = tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' = tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' = tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' = tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' = tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' = tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' = tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' = tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' = tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' = tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';

SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' <> tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' <> tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' <> tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' <> tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' <> tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' <> tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' <> tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' <> tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' <> tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' <> tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' <> tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' <> tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' <> tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' <> tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' <> tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' <> tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';

SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' < tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' < tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' < tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' < tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' < tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' < tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' < tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' < tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' < tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' < tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' < tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' < tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' < tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' < tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' < tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' < tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';

SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' <= tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' <= tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' <= tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' <= tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' <= tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' <= tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' <= tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' <= tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' <= tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' <= tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' <= tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' <= tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' <= tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' <= tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' <= tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' <= tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';

SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' > tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' > tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' > tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' > tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' > tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' > tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' > tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' > tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' > tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' > tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' > tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' > tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' > tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' > tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' > tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' > tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';

SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' >= tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' >= tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' >= tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' >= tgeogpoint 'Point(1.5 1.5)@2000-01-01';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' >= tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' >= tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' >= tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' >= tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' >= tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' >= tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' >= tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' >= tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]';
SELECT tgeogpoint 'Point(1.5 1.5)@2000-01-01' >= tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '{Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03}' >= tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03]' >= tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';
SELECT tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}' >= tgeogpoint '{[Point(1.5 1.5)@2000-01-01, Point(2.5 2.5)@2000-01-02, Point(1.5 1.5)@2000-01-03],[Point(3.5 3.5)@2000-01-04, Point(3.5 3.5)@2000-01-05]}';

------------------------------------------------------------------------------
