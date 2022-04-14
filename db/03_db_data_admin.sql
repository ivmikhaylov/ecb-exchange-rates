INSERT INTO groups(
  group_name, to_read, to_write, to_execute) 
VALUES 
  ('user_reader',    TRUE, FALSE, FALSE), 
  ('user_admin',     TRUE, FALSE, TRUE ), 
  ('script_builder', TRUE, TRUE,  TRUE ), 
  ('script_updater', TRUE, TRUE,  FALSE), 
  ('script_tester',  TRUE, TRUE,  TRUE )
ON DUPLICATE KEY UPDATE group_id=group_id; 
--equivalent of doing nothing


INSERT INTO var_dict(
  var_name, var_value) 
VALUES 
  ('run_status', 'locked'), 
  ('run_status', 'running'),
  ('test_example', 'unset_in_session')  
ON DUPLICATE KEY UPDATE var_name=var_name; 
--equivalent of doing nothing


/* Default value for 'run_status' session variable is 'running' */
INSERT INTO session(
  var_name, var_value) 
VALUES 
  ('run_status', 'running')
ON DUPLICATE KEY UPDATE var_name=var_name; 
--equivalent of doing nothing


/* Most popular HTTP response codes */
INSERT INTO response_codes(
  status_code, status_name) 
VALUES 
  ('200', 'OK'),
  ('204', 'No Content'),
  ('301', 'Moved Permanently'),
  ('302', 'Temporary Redirect'),
  ('400', 'Bad Request'),
  ('401', 'Unauthorized'),
  ('403', 'Forbidden'),
  ('404', 'Not Found'),
  ('410', 'Gone'),
  ('444', 'No Response'),
  ('500', 'Internal Server Error'),
  ('503', 'Service Unavailable'),
  ('561', 'Unauthorized')
ON DUPLICATE KEY UPDATE status_code=status_code; 
--equivalent of doing nothing


/* The rest of HTTP response codes from 
   https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
INSERT INTO response_codes(
  status_code, status_name) 
VALUES 
  ('100', 'Continue'),
  ('101', 'Switching Protocols'),
  ('102', 'Processing'),
  ('103', 'Early Hints'),
  ('110', 'Response is Stale'),
  ('111', 'Revalidation Failed'),
  ('112', 'Disconnected Operation'),
  ('113', 'Heuristic Expiration'),
  ('199', 'Miscellaneous Warning'),
  ('201', 'Created'),
  ('202', 'Accepted'),
  ('203', 'Non-Authoritative Information'),
  ('205', 'Reset Content'),
  ('206', 'Partial Content'),
  ('207', 'Multi-Status'),
  ('208', 'Already Reported'),
  ('214', 'Transformation Applied'),
  ('226', 'IM Used'),
  ('299', 'Miscellaneous Persistent Warning'),
  ('300', 'Multiple Choices'),
  ('303', 'See Other'),
  ('304', 'Not Modified'),
  ('305', 'Use Proxy'),
  ('306', 'Switch Proxy'),
  ('307', 'Temporary Redirect'),
  ('308', 'Permanent Redirect'),
  ('404', 'error on Wikimedia'),
  ('402', 'Payment Required'),
  ('405', 'Method Not Allowed'),
  ('406', 'Not Acceptable'),
  ('407', 'Proxy Authentication Required'),
  ('408', 'Request Timeout'),
  ('409', 'Conflict'),
  ('411', 'Length Required'),
  ('412', 'Precondition Failed'),
  ('413', 'Payload Too Large'),
  ('414', 'URI Too Long'),
  ('415', 'Unsupported Media Type'),
  ('416', 'Range Not Satisfiable'),
  ('417', 'Expectation Failed'),
  ('418', 'I am a teapot'),
  ('421', 'Misdirected Request'),
  ('422', 'Unprocessable Entity'),
  ('423', 'Locked'),
  ('424', 'Failed Dependency'),
  ('425', 'Too Early'),
  ('426', 'Upgrade Required'),
  ('428', 'Precondition Required'),
  ('429', 'Too Many Requests'),
  ('431', 'Request Header Fields Too Large'),
  ('451', 'Unavailable For Legal Reasons'),
  ('501', 'Not Implemented'),
  ('502', 'Bad Gateway'),
  ('504', 'Gateway Timeout'),
  ('505', 'HTTP Version Not Supported'),
  ('506', 'Variant Also Negotiates'),
  ('507', 'Insufficient Storage'),
  ('508', 'Loop Detected'),
  ('510', 'Not Extended'),
  ('511', 'Network Authentication Required'),
  ('419', 'Page Expired'),
  ('420', 'Method Failure'),
  ('420', 'Enhance Your Calm'),
  ('430', 'Request Header Fields Too Large'),
  ('450', 'Blocked by Windows Parental Controls'),
  ('498', 'Invalid Token'),
  ('499', 'Token Required'),
  ('509', 'Bandwidth Limit Exceeded'),
  ('529', 'Site is overloaded'),
  ('440', 'Login Time-out'),
  ('494', 'Request header too large'),
  ('495', 'SSL Certificate Error'),
  ('496', 'SSL Certificate Required'),
  ('497', 'HTTP Request Sent to HTTPS Port'),
  ('499', 'Client Closed Request'),
  ('520', 'Web Server Returned an Unknown Error'),
  ('521', 'Web Server Is Down'),
  ('522', 'Connection Timed Out'),
  ('523', 'Origin Is Unreachable'),
  ('524', 'A Timeout Occurred'),
  ('525', 'SSL Handshake Failed'),
  ('526', 'Invalid SSL Certificate'),
  ('527', 'Railgun Error')
ON DUPLICATE KEY UPDATE status_code=status_code; 
--equivalent of doing nothing  */
