/* A view to list exchange rates as they are in the db.

  For example:

  MariaDB [ecb-rates-db]> SELECT * FROM rates_as_they_are WHERE alphabetic_code = 'USD' ORDER BY pub_date DESC;
  +---------------+-----------------+--------------+------------+--------------+
  | currency_name | alphabetic_code | numeric_code | pub_date   | evening_rate |
  +---------------+-----------------+--------------+------------+--------------+
  | US Dollar     | USD             | 840          | 2022-03-15 |      1.09940 |
  | US Dollar     | USD             | 840          | 2022-03-14 |      1.09910 |
  | US Dollar     | USD             | 840          | 2022-03-13 |      1.09600 |
  | US Dollar     | USD             | 840          | 2022-03-12 |      1.09900 |
  | US Dollar     | USD             | 840          | 2022-03-11 |      1.09900 |
  +---------------+-----------------+--------------+------------+--------------+  
*/

DROP VIEW IF EXISTS rates_as_they_are;
CREATE VIEW rates_as_they_are AS(
  SELECT
    currency_name, 
    alphabetic_code, 
    numeric_code, 
    DATE(pub_datetime) AS pub_date,
    evening_rate 
  FROM 
    rates AS r 
  JOIN currencies AS c ON r.cur_code = c.alphabetic_code
  ORDER BY pub_date
);


/* A view to list exchange rates with an added row representing the next bank day.

  For example:

  MariaDB [ecb-rates-db]> SELECT * FROM rates_with_next_day WHERE alphabetic_code = 'USD' ORDER BY pub_date DESC;
  +---------------+-----------------+--------------+------------+--------------+
  | currency_name | alphabetic_code | numeric_code | pub_date   | evening_rate |
  +---------------+-----------------+--------------+------------+--------------+
  | US Dollar     | USD             | 840          | 2022-03-16 |              |
  | US Dollar     | USD             | 840          | 2022-03-15 | 1.09940      |
  | US Dollar     | USD             | 840          | 2022-03-14 | 1.09910      |
  | US Dollar     | USD             | 840          | 2022-03-13 | 1.09600      |
  | US Dollar     | USD             | 840          | 2022-03-12 | 1.09900      |
  | US Dollar     | USD             | 840          | 2022-03-11 | 1.09900      |
  +---------------+-----------------+--------------+------------+--------------+
  
  Note the next bank day has no evening rates yet. 
  Tomorrow's time is set to 00:00:00. */

DROP VIEW IF EXISTS rates_with_next_day;
CREATE VIEW rates_with_next_day AS(
  ( SELECT
      *
    FROM 
     rates_as_they_are
  ) UNION ALL

  ( SELECT
      currency_name, 
      alphabetic_code, 
      numeric_code, 
      pub_date + INTERVAL 1 DAY, 
      '' AS evening_rate 
    FROM 
      rates_as_they_are 
    WHERE 
      pub_date = (SELECT MAX(pub_date) FROM rates_as_they_are)
  )
);


/* A view to list exchange rates with morning_rate column.

  Example of use:

  MariaDB [ecb-rates-db]> SELECT * FROM rates_with_morning WHERE alphabetic_code = 'USD' ORDER BY pub_date DESC;
  +---------------+-----------------+--------------+------------+--------------+--------------+
  | currency_name | alphabetic_code | numeric_code | pub_date   | evening_rate | morning_rate |
  +---------------+-----------------+--------------+------------+--------------+--------------+
  | US Dollar     | USD             | 840          | 2022-03-16 |              | 1.09940      |
  | US Dollar     | USD             | 840          | 2022-03-15 | 1.09940      | 1.09910      |
  | US Dollar     | USD             | 840          | 2022-03-14 | 1.09910      | 1.09600      |
  | US Dollar     | USD             | 840          | 2022-03-13 | 1.09600      | 1.09900      |
  | US Dollar     | USD             | 840          | 2022-03-12 | 1.09900      | 1.09900      |
  | US Dollar     | USD             | 840          | 2022-03-11 | 1.09900      |              |
  +---------------+-----------------+--------------+------------+--------------+--------------+  */


DROP VIEW IF EXISTS rates_with_morning;
CREATE VIEW rates_with_morning AS(
/* Evening rate of a previous day is a Morning rate of the next one.
   Earliest day in the db gets '' for the Morning rate */
  SELECT 
    *,
    IFNULL(lag(evening_rate, 1) OVER (PARTITION BY alphabetic_code ORDER BY pub_date), '') AS morning_rate 
  FROM 
    rates_with_next_day
);


/* A view to list exchange rates with the latest_rates column.

  Example of use:

  MariaDB [ecb-rates-db]> SELECT * FROM rates_with_latest WHERE alphabetic_code = 'USD' ORDER BY pub_date DESC;
  +---------------+-----------------+--------------+------------+--------------+--------------+-------------+
  | currency_name | alphabetic_code | numeric_code | pub_date   | evening_rate | morning_rate | latest_rate |
  +---------------+-----------------+--------------+------------+--------------+--------------+-------------+
  | US Dollar     | USD             | 840          | 2022-03-16 |              | 1.09940      | 1.09940     |
  | US Dollar     | USD             | 840          | 2022-03-15 | 1.09940      | 1.09910      | 1.09940     |
  | US Dollar     | USD             | 840          | 2022-03-14 | 1.09910      | 1.09600      | 1.09910     |
  | US Dollar     | USD             | 840          | 2022-03-13 | 1.09600      | 1.09900      | 1.09600     |
  | US Dollar     | USD             | 840          | 2022-03-12 | 1.09900      | 1.09900      | 1.09900     |
  | US Dollar     | USD             | 840          | 2022-03-11 | 1.09900      |              | 1.09900     |
  +---------------+-----------------+--------------+------------+--------------+--------------+-------------+

  MariaDB [ecb-rates-db]> SELECT * FROM rates_with_latest WHERE pub_date = '2022-03-12' ORDER BY alphabetic_code;
  +------------------+-----------------+--------------+------------+--------------+--------------+-------------+
  | currency_name    | alphabetic_code | numeric_code | pub_date   | evening_rate | morning_rate | latest_rate |
  +------------------+-----------------+--------------+------------+--------------+--------------+-------------+
  | Swiss Franc      | CHF             | 756          | 2022-03-12 | 1.02300      | 1.02300      | 1.02300     |
  | Singapore Dollar | SGD             | 702          | 2022-03-12 | 1.49490      | 1.49490      | 1.49490     |
  | US Dollar        | USD             | 840          | 2022-03-12 | 1.09900      | 1.09900      | 1.09900     |
  +------------------+-----------------+--------------+------------+--------------+--------------+-------------+  */

DROP VIEW IF EXISTS rates_with_latest;
CREATE VIEW rates_with_latest AS(
  SELECT 
    *,
    CASE WHEN evening_rate != '' THEN evening_rate ELSE morning_rate END AS latest_rate
  FROM 
    rates_with_morning
);
