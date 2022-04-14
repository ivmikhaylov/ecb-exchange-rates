
/* Create a db user 'admin'@'%' and hash a password from file.
  LOAD DATA can't be stored in a procedure or function.
  Variables are not accepted in CREATE USER query. */

TRUNCATE secret;

LOAD DATA
INFILE "/run/secrets/db-password-admin"
INTO TABLE secret (@hashed_pwd)
  SET hashed_pwd = (SELECT ed25519_password(@hashed_pwd));

TRUNCATE secret;

CALL run_user_create_query("admin", "%", (SELECT ed25519_password(@hashed_pwd)));


/* Grant particular privileges to admin to manage front-end users 
  versus GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%'; */

GRANT EXECUTE ON PROCEDURE run_user_create_query TO 'admin'@'%';
GRANT EXECUTE ON PROCEDURE run_user_drop_query   TO 'admin'@'%';


FLUSH PRIVILEGES;
