
/* Create a db user 'reader'@'%' and hash a password from file.
  LOAD DATA can't be stored in a procedure or function.
  Variables are not accepted in CREATE USER query. */

TRUNCATE secret;

LOAD DATA
INFILE "/run/secrets/db-password-reader"
INTO TABLE secret (@hashed_pwd)
  SET hashed_pwd = (SELECT ed25519_password(@hashed_pwd));

TRUNCATE secret;

CALL run_user_create_query("reader", "%", (SELECT ed25519_password(@hashed_pwd)));


/* Grant the lowest privileges to reader just to call stored functions
  versus GRANT ALL PRIVILEGES ON *.* TO 'reader'@'%'; */

GRANT EXECUTE ON FUNCTION get_actual_rates_json     TO 'reader'@'%';
GRANT EXECUTE ON FUNCTION get_historical_rates_json TO 'reader'@'%';


FLUSH PRIVILEGES;
