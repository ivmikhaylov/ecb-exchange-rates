
/* Create groups of users' rights to access the `ecb-rates-db` service via REST API:
   read    - get reponces for requests on exchange rates
   write   - manually update db with the rates. RSS updates are done separately on the back-end side.
   execute - admin rights to lock and restart the service. Admin rights to start, restart and stop the container are NOT included here. */
CREATE TABLE IF NOT EXISTS groups(
  group_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  group_name VARCHAR(15) NOT NULL UNIQUE KEY, 
  to_read BOOLEAN NOT NULL, 
  to_write BOOLEAN NOT NULL, 
  to_execute BOOLEAN NOT NULL, 
  updated_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS users(
  user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
  user_name VARCHAR(255) NOT NULL UNIQUE KEY, 
  hashed_password LONGTEXT NOT NULL, 
  
  /* User passwords to be hashed by bcrypt algorithm */
  salt VARCHAR(16) NOT NULL, 
  updated_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


--Many to many
CREATE TABLE IF NOT EXISTS users_groups(
  user_id INT UNSIGNED NOT NULL, 
  group_id TINYINT UNSIGNED NOT NULL, 
  updated_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
  PRIMARY KEY (user_id, group_id), 
  CONSTRAINT fk_user_id FOREIGN KEY(user_id) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT, 
  CONSTRAINT fk_group_id FOREIGN KEY(group_id) REFERENCES groups(group_id) ON UPDATE CASCADE ON DELETE RESTRICT
);


/* Table secret to temporarily store hashed passwords */
CREATE TABLE IF NOT EXISTS secret(
  hashed_pwd CHAR(43) NOT NULL
);


/* Dictionary of session variables.
   For example: {'run_status', 'locked'} and {'run_status','running'}  */
CREATE TABLE IF NOT EXISTS var_dict(
  var_name VARCHAR(40) NOT NULL,
  var_value VARCHAR(40) NOT NULL,
  PRIMARY KEY (var_name, var_value),
  updated_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


/* Store session variables.
   For example: --run_status='locked' or 'running'  */
CREATE TABLE IF NOT EXISTS session(
  var_name VARCHAR(40) NOT NULL,
  var_value VARCHAR(40) NOT NULL,
  PRIMARY KEY (var_name, var_value),
  updated_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_var_name_value FOREIGN KEY(var_name, var_value) REFERENCES var_dict(var_name, var_value) ON UPDATE CASCADE ON DELETE RESTRICT
);


/* Dictionary of response codes
   For example: {'200', 'OK'} and {'404','Not Found'}  */
CREATE TABLE IF NOT EXISTS response_codes(
  status_code CHAR(3) PRIMARY KEY,
  status_name VARCHAR(40) NOT NULL
);
