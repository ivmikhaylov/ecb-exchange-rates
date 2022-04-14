DELIMITER $$


/* Get the list of missing dates of publications in a JSON format.

  Example of use:

  MariaDB [ecb-rates-db]> SELECT get_missing_dates_json();
  +--------------------------------------------------------------------+
  | get_missing_dates_json()                                           |                                                                                                                                                                         |
  +--------------------------------------------------------------------+
  | ["2022-03-03","2022-03-04","2022-03-06","2022-03-09","2022-03-10", |
  |  "2022-03-16","2022-03-17","2022-03-18","2022-03-19","2022-03-20", |
  |  "2022-03-21","2022-03-22","2022-03-23","2022-03-24","2022-03-25", |
  |  "2022-03-26","2022-03-27","2022-03-28"]                           |
  +--------------------------------------------------------------------+  

  when NULL:
  +---------------------------------+
  | get_missing_dates_json()        |
  +---------------------------------+
  | ["eecbrates: no missing dates"] |
  +---------------------------------+  */ 

DROP FUNCTION IF EXISTS get_missing_dates_json $$
CREATE FUNCTION get_missing_dates_json(
) RETURNS JSON
BEGIN

  SET @count_missing  = (
    SELECT 
      count(*)
    FROM 
      get_missing_dates
  );

  SET @missing  = (
    SELECT 
      CONCAT('[', GROUP_CONCAT(JSON_QUOTE(missing)), ']')
    FROM 
      get_missing_dates
  );

  SET @errEmptyJason = CONCAT('[', "\"ecbrates: no missing dates\"", ']');

  RETURN (
    CASE @count_missing
      WHEN 0 
      THEN (SELECT @errEmptyJason)
      ELSE (SELECT JSON_COMPACT(@missing))
    END
  );

END $$


/* INSERT in bulk to publications from JSON.

  Example of use:

  SET 
    @pub_dump = (
      SELECT 
        JSON_ARRAYAGG(
          JSON_OBJECT(
            'PUB_DATETIME', pub_datetime,
            'PUB_TITLE', pub_title,
            'PUB_LINK', pub_link,
            'PUB_GUID', pub_guid
          )
        ) 
      FROM 
        publications
    );

  [ {"PUB_DATE": "2022-03-01 02:00:00",
     "PUB_TITLE": "Euro reference rates published by the European Central Bank. 01. March_LONG", 
     "PUB_LINK": "https://www.bank.lv", 
     "PUB_GUID": "https://www.bank.lv/#01.03"}, ...

  MariaDB [ecb-rates-db]> SELECT put_publication_json(@pub_dump); */ 

DROP FUNCTION IF EXISTS put_publication_json $$
CREATE FUNCTION put_publication_json(
  pub_data JSON
) RETURNS JSON
MODIFIES SQL DATA
BEGIN

  SET @status = (SELECT lock_service());

  INSERT INTO publications(pub_datetime, pub_title, pub_link, pub_guid)
  SELECT 
    * 
  FROM 
    JSON_TABLE(
      pub_data, 
      "$[*]" COLUMNS (
        p_datetime DATETIME PATH "$.PUB_DATETIME",
        p_title VARCHAR(80) PATH "$.PUB_TITLE", 
        p_link VARCHAR(40) PATH "$.PUB_LINK", 
        p_guid VARCHAR(40) PATH "$.PUB_GUID"
      )
    ) AS jsontable
  ON DUPLICATE KEY UPDATE pub_datetime=pub_datetime;  
  /* equivalent of doing nothing */

  SET @status = (SELECT unlock_service());

  RETURN (SELECT send_response(200, False));

END $$

  
/* INSERT in bulk to rates from JSON.

  Example of use:

  SET 
    @rates_dump = (
      SELECT 
        JSON_ARRAYAGG(
          JSON_OBJECT(
            'PUB_DATETIME', pub_datetime,
            'CUR_CODE', cur_code,
            'EVENING_RATE', evening_rate
          )
        ) 
      FROM 
        rates
    );

  [{"PUB_DATETIME": "2022-03-11", 
    "CUR_CODE": "CHF", 
    "EVENING_RATE": 1.02300},
    ...

  MariaDB [ecb-rates-db]> SELECT put_rates_json(@rates_dump); */ 

DROP FUNCTION IF EXISTS put_rates_json $$
CREATE FUNCTION put_rates_json(
  rates_data JSON
) RETURNS JSON
MODIFIES SQL DATA
BEGIN

  SET @status = (SELECT lock_service());

  INSERT INTO rates(pub_datetime, cur_code, evening_rate)
  SELECT 
    * 
  FROM 
    JSON_TABLE(
      rates_data, 
      "$[*]" COLUMNS (
        p_datetime DATETIME(0) PATH "$.PUB_DATETIME",
        c_code CHAR(3) PATH "$.CUR_CODE", 
        e_rate DECIMAL (10, 5) PATH "$.EVENING_RATE"
      )
    ) AS jsontable
  ON DUPLICATE KEY UPDATE pub_datetime=pub_datetime;  
  /* equivalent of doing nothing */

  SET @status = (SELECT unlock_service());

  RETURN (SELECT send_response(200, False));

END $$


/* Get the current value of a session variable 
   as a separate value and in a JSON format:

  Example of use:

  MariaDB [ecb-rates-db]> SELECT get_session_var('run_status');
  +-------------------------------+
  | get_session_var('run_status') |
  +-------------------------------+
  | running                       |
  +-------------------------------+

  MariaDB [ecb-rates-db]> SELECT get_session_var_json('run_status', False);
  +-------------------------------------------+
  | get_session_var_json('run_status', False) |
  +-------------------------------------------+
  | {"run_status":"running"}                  |
  +-------------------------------------------+

  MariaDB [ecb-rates-db]> SELECT get_session_var_json('run_status', True);
  +------------------------------------------+
  | get_session_var_json('run_status', True) |
  +------------------------------------------+
  | ["running"]                              |
  +------------------------------------------+  */

DROP FUNCTION IF EXISTS get_session_var $$
CREATE FUNCTION get_session_var(
  variable_name VARCHAR(40)
) RETURNS VARCHAR(40)
RETURN (
  SELECT 
    var_value
  FROM
    session_variables
  WHERE
    var_name = variable_name
) $$


DROP FUNCTION IF EXISTS get_session_var_json $$
CREATE FUNCTION get_session_var_json(
  variable_name VARCHAR(40),
  variable_only BOOLEAN
) RETURNS VARCHAR(40)
BEGIN

  SET
    @variable_value = (
      SELECT var_value
      FROM session_variables AS s
      WHERE s.var_name = variable_name
  );

  RETURN (
    SELECT 
      IF(variable_only, 
        CONCAT('["', @variable_value, '"]'), 
        JSON_COMPACT(JSON_OBJECT(variable_name, @variable_value)))
  );

END $$


/* Is session variable request valid?  

  Example of use:

  MariaDB [ecb-rates-db]> SELECT is_valid_request('run_status', 'locked');
  +------------------------------------------+
  | is_valid_request('run_status', 'locked') |
  +------------------------------------------+
  |                                        1 |
  +------------------------------------------+  */

DROP FUNCTION IF EXISTS is_valid_request $$
CREATE FUNCTION is_valid_request(
  variable_name VARCHAR(40),
  variable_value VARCHAR(40)
) RETURNS INT
RETURN (
  SELECT 
    COUNT(*) 
  FROM 
    var_dict AS d 
  WHERE 
    d.var_name = LOWER(TRIM(variable_name))
    AND d.var_value = LOWER(TRIM(variable_value))
) $$


/* Is session variable have a setting?  

  Example of use:

  MariaDB [ecb-rates-db]> SELECT is_var_exist('run_status');
  +----------------------------+
  | is_var_exist('run_status') |
  +----------------------------+
  |                          1 |
  +----------------------------+  */

DROP FUNCTION IF EXISTS is_var_exist $$
CREATE FUNCTION is_var_exist(
  variable_name VARCHAR(40)
) RETURNS INT
RETURN (
  SELECT 
    COUNT(*) 
  FROM 
    session AS s
  WHERE 
    s.var_name = LOWER(TRIM(variable_name))
) $$


/* Is session locked?  

  Example of use:

  MariaDB [ecb-rates-db]> SELECT is_session_locked();
  +---------------------+
  | is_session_locked() |
  +---------------------+
  |                   1 |
  +---------------------+  */

DROP FUNCTION IF EXISTS is_session_locked $$
CREATE FUNCTION is_session_locked(
) RETURNS INT
RETURN (SELECT get_session_var('run_status') = 'locked') 
$$


/* Update session variable with the value

  Example of use:

  MariaDB [ecb-rates-db]> CALL upd_session_var('run_status', 'running');

*/

DROP PROCEDURE IF EXISTS upd_session_var $$
CREATE PROCEDURE upd_session_var(
  variable_name VARCHAR(40),
  variable_value VARCHAR(40)
)
MODIFIES SQL DATA
BEGIN
  UPDATE 
    session
  SET
    var_value = LOWER(TRIM(variable_value))
  WHERE 
    var_name = LOWER(TRIM(variable_name));
END $$


/* Return status code response in a JSON format.

  Example of use:

  MariaDB [ecb-rates-db]> SELECT send_response(200, True);
  +--------------------------+
  | send_response(200, True) |
  +--------------------------+
  | ["200"]                  |
  +--------------------------+

  MariaDB [ecb-rates-db]> SELECT send_response(200, False);
  +---------------------------+
  | send_response(200, False) |
  +---------------------------+
  | {"200":"OK"}              |
  +---------------------------+  */

DROP FUNCTION IF EXISTS send_response $$
CREATE FUNCTION send_response(
  status_code SMALLINT UNSIGNED,
  code_only BOOLEAN
) RETURNS JSON
BEGIN

  SET
    @status_name = (
      SELECT status_name
      FROM response_codes AS r
      WHERE r.status_code = status_code
  );

  RETURN (
    SELECT 
      IF(code_only, 
        CONCAT('["', status_code, '"]'),
        JSON_COMPACT(JSON_OBJECT(status_code, @status_name)))
  );

END $$


/* Set the value of a session variable and return the status code 
   in a JSON format:

  200 OK
  400 Bad Request
  404 Not Found

  Example of use:

  MariaDB [ecb-rates-db]> SELECT set_session_var("run_status", "locked");
  +-----------------------------------------+
  | set_session_var("run_status", "locked") |
  +-----------------------------------------+
  | {"200":"OK"}                            |
  +-----------------------------------------+

  MariaDB [ecb-rates-db]> SELECT set_session_var("run_status", "pau_____sed");
  +----------------------------------------------+
  | set_session_var("run_status", "pau_____sed") |
  +----------------------------------------------+
  | {"400":"Bad Request"}                        |
  +----------------------------------------------+

  MariaDB [ecb-rates-db]> SELECT set_session_var("test_example", "unset_in_session");
  +-----------------------------------------------------+
  | set_session_var("test_example", "unset_in_session") |
  +-----------------------------------------------------+
  | {"404":"Not Found"}                                 |
  +-----------------------------------------------------+  */

DROP FUNCTION IF EXISTS set_session_var $$
CREATE FUNCTION set_session_var(
  v_name VARCHAR(40),
  v_value VARCHAR(40)
) RETURNS JSON
BEGIN

  IF is_valid_request(v_name, v_value) 
     AND is_var_exist(v_name)
  THEN
    CALL upd_session_var(v_name, v_value);
    RETURN (SELECT send_response(200, False));

  ELSEIF is_var_exist(v_name)
  THEN
    RETURN (SELECT send_response(400, False));
  ELSE
    RETURN (SELECT send_response(404, False));
  END IF;

END $$


/* Set the session "run_status" variable to "locked" 
   and return the status code in a JSON format: 
   see set_session_var() function for the corresponding response codes.

  Example of use:

  MariaDB [ecb-rates-db]> SELECT lock_service();
  +-----------------+
  | lock_service()  |
  +-----------------+
  | {"200":"OK"}    |
  +-----------------+  */

DROP FUNCTION IF EXISTS lock_service $$
CREATE FUNCTION lock_service() RETURNS JSON
RETURN (SELECT set_session_var("run_status", "locked"))
$$


/* Set the session "run_status" variable to "locked" 
   and return the status code in a JSON format: 
   see set_session_var() function for the corresponding response codes.

  Example of use:

  MariaDB [ecb-rates-db]> SELECT unlock_service();
  +-------------------+
  | unlock_service()  |
  +-------------------+
  | {"200":"OK"}      |
  +-------------------+  */

DROP FUNCTION IF EXISTS unlock_service $$
CREATE FUNCTION unlock_service() RETURNS JSON
RETURN (SELECT set_session_var("run_status", "running"))
$$


DELIMITER ;

