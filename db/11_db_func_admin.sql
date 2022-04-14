DELIMITER $$


/* Hash password by auth_ed25519.so 

  Example of use:

  MariaDB [ecb-rates-db]> SELECT ed25519_password("secret");
  +---------------------------------------------+
  | ed25519_password("secret")                  |
  +---------------------------------------------+
  | ZIgUREUg5PVgQ6LskhXmO+eZLS0nC8be6HPjYWR4YJY |
  +---------------------------------------------+  */

DROP FUNCTION IF EXISTS ed25519_password $$
CREATE FUNCTION ed25519_password RETURNS STRING SONAME "auth_ed25519.so"
$$


/* RUN user query create.
  Used to create db account with user data from variables. 

  Example of use:

  MariaDB [ecb-rates-db]> CALL run_user_create_query("a_user_name", "localhost", ed25519_password("secret"));
  MariaDB [ecb-rates-db]> SELECT User FROM mysql.user WHERE User = "a_user_name";

  +---------------+
  | User          |
  +---------------+
  | a_user_name   |
  +---------------+  */

DROP PROCEDURE IF EXISTS run_user_create_query $$
CREATE PROCEDURE run_user_create_query(
  IN user_name VARCHAR(20), 
  IN host_name VARCHAR(20),
  IN hashed_pwd CHAR(43)
)
BEGIN

  /* IDENTIFIED VIA ed25519 USING is not supported by Go mysql connecter yet*/
  SET @query_stm = CONCAT(
    'CREATE USER IF NOT EXISTS "', 
    user_name, 
    '"@"', 
    host_name, 
    '" IDENTIFIED BY "', 
    hashed_pwd, 
    '"'
  );

  PREPARE query_stm FROM @query_stm; 
  EXECUTE query_stm; 
  DEALLOCATE PREPARE query_stm;

END $$


/* RUN user drop query.
  Used to delete user account from db with user data from variables. 

  Example of use:

  MariaDB [ecb-rates-db]> CALL run_user_drop_query("a_user_name", "localhost");
  MariaDB [ecb-rates-db]> SELECT User FROM mysql.user WHERE User = "a_user_name";
  Empty set (0.001 sec)  */

DROP PROCEDURE IF EXISTS run_user_drop_query $$
CREATE PROCEDURE run_user_drop_query(
  IN user_name VARCHAR(20), 
  IN host_name VARCHAR(20)
)
BEGIN

  SET @query_stm = CONCAT(
    'DROP USER IF EXISTS "', 
    user_name, 
    '"@"', 
    host_name, 
    '"'
  );

  PREPARE query_stm FROM @query_stm; 
  EXECUTE query_stm; 
  DEALLOCATE PREPARE query_stm;

END $$


DELIMITER ;
