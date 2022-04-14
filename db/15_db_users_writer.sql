
/* Create a db user 'writer'@'%' and hash a password from file.
  LOAD DATA can't be stored in a procedure or function.
  Variables are not accepted in CREATE USER query. */

TRUNCATE secret;

LOAD DATA
INFILE "/run/secrets/db-password-writer"
INTO TABLE secret (@hashed_pwd)
  SET hashed_pwd = (SELECT ed25519_password(@hashed_pwd));

TRUNCATE secret;

CALL run_user_create_query("writer", "%", (SELECT ed25519_password(@hashed_pwd)));


/* Grant medium privileges to writer to actualise exchange rates 
  versus GRANT ALL PRIVILEGES ON *.* TO 'writer'@'%'; */

GRANT EXECUTE ON FUNCTION get_missing_dates_json  TO 'writer'@'%';
GRANT EXECUTE ON FUNCTION put_publication_json    TO 'writer'@'%';
GRANT EXECUTE ON FUNCTION put_rates_json          TO 'writer'@'%';
GRANT EXECUTE ON FUNCTION lock_service            TO 'writer'@'%';
GRANT EXECUTE ON FUNCTION unlock_service          TO 'writer'@'%';

FLUSH PRIVILEGES;
