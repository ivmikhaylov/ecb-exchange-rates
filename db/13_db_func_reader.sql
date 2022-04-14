DELIMITER $$


/* Get the actual exchange rates 
   on the given date in a JSON format.

  Example of use:

  MariaDB [ecb-rates-db]> SELECT get_actual_rates_json(NOW());
  MariaDB [ecb-rates-db]> SELECT get_actual_rates_json('2022-03-12');
  +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
  | [{"CURRENCY_NAME":"Swiss Franc",      "ALPHABETIC_CODE": "CHF", "NUMERIC_CODE": "756", "CALENDAR_DATE": "2022-03-12", "MORNING_RATE": "1.02300", "EVENING_RATE": "1.02300", "LATEST_RATE": "1.02300"},  |
  |  {"CURRENCY_NAME":"Singapore Dollar", "ALPHABETIC_CODE": "SGD", "NUMERIC_CODE": "702", "CALENDAR_DATE": "2022-03-12", "MORNING_RATE": "1.49490", "EVENING_RATE": "1.49490", "LATEST_RATE": "1.49490"},  |
  |  {"CURRENCY_NAME":"US Dollar",        "ALPHABETIC_CODE": "USD", "NUMERIC_CODE": "840", "CALENDAR_DATE": "2022-03-12", "MORNING_RATE": "1.09900", "EVENING_RATE": "1.09900", "LATEST_RATE": "1.09900"}]  |
  +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

  If the service is 'locked':
  +-------------------------------------+
  | get_actual_rates_json('2022-03-12') |
  +-------------------------------------+
  | {"503":"Service Unavailable"}       |
  +-------------------------------------+ 

  when NULL:
  +-------------------------------------+
  | get_actual_rates_json('3000-03-12') |
  +-------------------------------------+
  | ["ecbrates: no rates"]              |
  +-------------------------------------+  */

DROP FUNCTION IF EXISTS get_actual_rates_json $$
CREATE FUNCTION get_actual_rates_json(
  to_date DATETIME
) RETURNS JSON
BEGIN
  IF (SELECT is_session_locked()) THEN
    RETURN (SELECT send_response(503, False));
  END IF;

  SET @count_actual_rates  = (
    SELECT 
      count(*)
    FROM 
      rates_with_latest
    WHERE 
      pub_date = to_date
  );

  SET @actual_rates  = (
    SELECT 
      JSON_ARRAYAGG(
        JSON_OBJECT(
          'CURRENCY_NAME', currency_name,
          'ALPHABETIC_CODE', alphabetic_code,
          'NUMERIC_CODE', numeric_code,
          'CALENDAR_DATE', pub_date, 
          'MORNING_RATE', morning_rate,
          'EVENING_RATE', evening_rate,
          'LATEST_RATE', latest_rate
          )
      )
    FROM 
      rates_with_latest
    WHERE 
      pub_date = to_date
    ORDER BY alphabetic_code
  );

  SET @errEmptyJason = CONCAT('[', "\"ecbrates: no rates\"", ']');

  RETURN (
    CASE @count_actual_rates
      WHEN 0 
      THEN (SELECT @errEmptyJason)
      ELSE (SELECT JSON_COMPACT(@actual_rates))
    END
  );

END $$


/* Get historic exchange rates of a given currency 
   for a given period of time in a JSON format:

  Example of use:

  MariaDB [ecb-rates-db]> SELECT get_historical_rates_json('USD', '2022-03-11', '2022-03-16');
  +--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
  | [{"CURRENCY_NAME": "US Dollar", "ALPHABETIC_CODE": "USD", "NUMERIC_CODE": "840", "CALENDAR_DATE": "2022-03-11", "MORNING_RATE": "",        "EVENING_RATE": "1.09900", "LATEST_RATE": "1.09900"}, |
  |  {"CURRENCY_NAME": "US Dollar", "ALPHABETIC_CODE": "USD", "NUMERIC_CODE": "840", "CALENDAR_DATE": "2022-03-12", "MORNING_RATE": "1.09900", "EVENING_RATE": "1.09900", "LATEST_RATE": "1.09900"}, |
  |  {"CURRENCY_NAME": "US Dollar", "ALPHABETIC_CODE": "USD", "NUMERIC_CODE": "840", "CALENDAR_DATE": "2022-03-13", "MORNING_RATE": "1.09900", "EVENING_RATE": "1.09600", "LATEST_RATE": "1.09600"}, |
  |  {"CURRENCY_NAME": "US Dollar", "ALPHABETIC_CODE": "USD", "NUMERIC_CODE": "840", "CALENDAR_DATE": "2022-03-14", "MORNING_RATE": "1.09600", "EVENING_RATE": "1.09910", "LATEST_RATE": "1.09910"}, |
  |  {"CURRENCY_NAME": "US Dollar", "ALPHABETIC_CODE": "USD", "NUMERIC_CODE": "840", "CALENDAR_DATE": "2022-03-15", "MORNING_RATE": "1.09910", "EVENING_RATE": "1.09940", "LATEST_RATE": "1.09940"}, |
  |  {"CURRENCY_NAME": "US Dollar", "ALPHABETIC_CODE": "USD", "NUMERIC_CODE": "840", "CALENDAR_DATE": "2022-03-16", "MORNING_RATE": "1.09940", "EVENING_RATE": "",        "LATEST_RATE": "1.09940"}] |
  +--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

  In case service is locked:
  +--------------------------------------------------------------+
  | get_historical_rates_json('USD', '2022-03-11', '2022-03-16') |
  +--------------------------------------------------------------+
  | {"503": "Service Unavailable"}                               |
  +--------------------------------------------------------------+

  when NULL:
  +--------------------------------------------------------------+
  | get_historical_rates_json('USD', '3000-03-11', '3000-03-16') |
  +--------------------------------------------------------------+
  | ["ecbrates: no rates"]                                       |
  +--------------------------------------------------------------+  */

DROP FUNCTION IF EXISTS get_historical_rates_json $$
CREATE FUNCTION get_historical_rates_json(
  apha_code CHAR(3), 
  from_date DATETIME, 
  to_date DATETIME
) RETURNS JSON
BEGIN

  IF (SELECT is_session_locked()) THEN
    RETURN (SELECT send_response(503, False));
  END IF;

  SET @count_historic_rates  = (
    SELECT 
      count(*)
    FROM 
      rates_with_latest
    WHERE 
      pub_date = to_date
  );

  SET @historic_rates  = (
    SELECT
      JSON_ARRAYAGG(
        JSON_OBJECT(
          'CURRENCY_NAME', currency_name,
          'ALPHABETIC_CODE', alphabetic_code,
          'NUMERIC_CODE', numeric_code,
          'CALENDAR_DATE', pub_date,
          'MORNING_RATE', morning_rate,
          'EVENING_RATE', evening_rate,
          'LATEST_RATE', latest_rate
        )
      )
    FROM 
      rates_with_latest
    WHERE
      pub_date BETWEEN from_date AND to_date
      AND alphabetic_code = apha_code
  );

  SET @errEmptyJason = CONCAT('[', "\"ecbrates: no rates\"", ']');

  RETURN (
    CASE @count_historic_rates
      WHEN 0 
      THEN (SELECT @errEmptyJason)
      ELSE (SELECT JSON_COMPACT(@historic_rates))
    END
  );

END $$


DELIMITER ;
