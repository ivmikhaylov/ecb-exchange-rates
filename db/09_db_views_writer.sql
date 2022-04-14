
/* Get a sequence of all dates between MIN and MAX dates in publications.date.

  MariaDB [ecb-rates-db]> SELECT * FROM get_date_seq;
  +------------+
  | dates      |
  +------------+
  | 2022-03-01 |
  | 2022-03-02 |
  | 2022-03-03 |
  | 2022-03-04 |
  | 2022-03-05 |
  | 2022-03-06 |
  | 2022-03-07 |
  | 2022-03-08 |
  | 2022-03-09 |
  | 2022-03-10 |
  | 2022-03-11 |
  | 2022-03-12 |
  | 2022-03-13 |
  | 2022-03-14 |
  | 2022-03-15 |
  +------------+  */ 

DROP VIEW IF EXISTS get_date_seq;
CREATE VIEW get_date_seq AS(
  SELECT 
    min_pub.date + INTERVAL (seq) DAY AS dates
  FROM
    seq_0_to_999999,
    (
      SELECT DATE(MIN(pub_datetime)) AS date
      FROM publications
    ) AS min_pub
  WHERE 
    seq BETWEEN 0 AND DATEDIFF(NOW(), min_pub.date)
);


/* Generate a list of missing dates or gaps in the sequence of publications.date.

  Example of use:

  MariaDB [ecb-rates-db]> SELECT * FROM get_missing_dates;
  +------------+
  | missing    |
  +------------+
  | 2022-03-03 |
  | 2022-03-04 |
  | 2022-03-06 |
  | 2022-03-09 |
  | 2022-03-10 |
  +------------+  */

DROP VIEW IF EXISTS get_missing_dates;
CREATE VIEW get_missing_dates AS(
  SELECT 
    s.dates AS missing
  FROM
    get_date_seq AS s
    LEFT JOIN publications AS p ON s.dates = DATE(p.pub_datetime)
  WHERE 
    p.pub_datetime IS NULL
  ORDER BY s.dates
);


/* A view to list session variables.

  Example of use:

  MariaDB [ecb-rates-db]> SELECT var_value FROM session_variables WHERE var_name = 'run_status';
  +-----------+
  | var_value |
  +-----------+
  | locked    |
  +-----------+  */

DROP VIEW IF EXISTS session_variables;
CREATE VIEW session_variables AS(
  SELECT 
    var_name,
    var_value
  FROM 
    session
);
