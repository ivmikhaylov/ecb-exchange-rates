## Directory content:

The files in directory `/run/db` can be divided to 4 groups based on the access roles:
- For `Script-Read` that calls stored functions in order to return actual and historical currency exchange rates.
- For `Script-Write` that calls stored procedures to load in bilk new exchange rates from an RSS feed.
- For `Script-Admin` that manages front-end users and virtually locks the service. 
- System files.


## Script-Read:

2 main `entry posints` are used by `Script-Read` to get actual and historical currency exchange rates:

-  `get_actual_rates_json` and
-  `get_historic_rates_json`

> `get_actual_rates_json` provides the actual exchange rates on the given date in a `JSON` format.

  ***Example of use:***

```SQL

  MariaDB [ecb-rates-db]> SELECT get_actual_rates_json('2022-03-12'); 

```

With the following output:
```SQL
  +---------------------------------------------+
  | [{"Currency name":   "Swiss Franc",         | 
  |   "Alphabetic code": "CHF",                 |
  |   "Numeric code":    "756",                 |
  |   "Calendar date":   "2022-03-12",          |
  |   "Morning rate":    "1.02300",             |
  |   "Evening rate":    "1.02300",             |
  |   "Latest rate":     "1.02300"},            |
  |                                             |
  |  {"Currency name":   "Singapore Dollar",    | 
  |   "Alphabetic code": "SGD",                 |
  |   "Numeric code":    "702",                 |
  |   "Calendar date":   "2022-03-12",          |
  |   "Morning rate":    "1.49490",             |
  |   "Evening rate":    "1.49490",             |
  |   "Latest rate":     "1.49490"},            |
  |  ...                                        |
  |                                          }] |
  +---------------------------------------------+
```

Response code if the service is 'locked':
  
```SQL
  +--------------------------------------------------------------------+
  | get_actual_rates_json('2022-03-12')                                |
  +--------------------------------------------------------------------+
  | [{"Response code": "503", "Response name": "Service Unavailable"}] |
  +--------------------------------------------------------------------+ */
```

> `get_historic_rates_json` Get historic exchange rates of a given currency for a given period of time in a `JSON` format.

  ***Example of use:***

```SQL

  MariaDB [ecb-rates-db]> SELECT get_historic_rates_json('USD', '2022-03-11', '2022-03-16');

```

With the following output:
```SQL
  +---------------------------------------+
  | [{"Currency name":    "US Dollar",    |
  |    "Alphabetic code": "USD",          |
  |    "Numeric code":    "840",          |
  |    "Calendar date":   "2022-03-11",   |
  |    "Morning rate":    "",             |
  |    "Evening rate":    "1.09900",      |
  |    "Latest rate":     "1.09900"},     |
  |                                       |
  |  {"Currency name":    "US Dollar",    |
  |    "Alphabetic code": "USD",          |
  |    "Numeric code":    "840",          |
  |    "Calendar date":   "2022-03-12",   |
  |    "Morning rate":    "1.09900",      |
  |    "Evening rate":    "1.09900",      |
  |    "Latest rate":     "1.09900"},     |
  |  ...                                  |
  |                                    }] |
  +---------------------------------------+
```
  Response code if the service is locked:

```SQL
  +--------------------------------------------------------------------+
  | get_historic_rates_json('USD', '2022-03-11', '2022-03-16')         |
  +--------------------------------------------------------------------+
  | [{"Response code": "503", "Response name": "Service Unavailable"}] |
  +--------------------------------------------------------------------+ 


### `01_db_tables_admin.sql` creates bd tables at initiation stage.

Tables should be created at initiation stage of the db.
The file `01_db_create_tables.sql` should go first in the alphabetical order in `/docker-entrypoint-initdb.d`

**Comment:** Note `01_` in the prefix of the filename. 

- `groups` table for access rights:

`groups` table stores user rights to access the `ecb-rates-db` service via REST API:
   read    - get reponces for requests on exchange rates
   write   - manually update db with the rates. RSS updates are done separately on the back-end side.
   execute - admin rights to `lock` and `UNlock` the service. Admin rights to `start`, `restart` and `stop` the container are NOT included here.

```SQL
MariaDB [ecb-rates-db]> describe groups;
+--------------+---------------------+------+-----+---------------------+-------------------------------+
| Field        | Type                | Null | Key | Default             | Extra                         |
+--------------+---------------------+------+-----+---------------------+-------------------------------+
| group_id     | tinyint(3) unsigned | NO   | PRI | NULL                | auto_increment                |
| group_name   | varchar(15)         | NO   | UNI | NULL                |                               |
| to_read      | tinyint(1)          | NO   |     | NULL                |                               |
| to_write     | tinyint(1)          | NO   |     | NULL                |                               |
| to_execute   | tinyint(1)          | NO   |     | NULL                |                               |
| updated_time | timestamp           | NO   |     | current_timestamp() | on update current_timestamp() |
+--------------+---------------------+------+-----+---------------------+-------------------------------+
```

`groups` table has the following constraints:
```SQL
MariaDB [ecb-rates-db]> SHOW CREATE TABLE groups\G
...
  PRIMARY KEY (`group_id`),
  UNIQUE KEY `group_name` (`group_name`)
...

```


- `users` table for login and hashed password:

User passwords to be hashed by bcrypt algorithm.

**Comment:** Note the `hashed_password` and the `salt`.

```SQL
MariaDB [ecb-rates-db]> describe users;
+-----------------+------------------+------+-----+---------------------+-------------------------------+
| Field           | Type             | Null | Key | Default             | Extra                         |
+-----------------+------------------+------+-----+---------------------+-------------------------------+
| user_id         | int(10) unsigned | NO   | PRI | NULL                | auto_increment                |
| user_name       | varchar(255)     | NO   | UNI | NULL                |                               |
| hashed_password | longtext         | NO   |     | NULL                |                               |
| salt            | varchar(16)      | NO   |     | NULL                |                               |
| updated_time    | timestamp        | NO   |     | current_timestamp() | on update current_timestamp() |
+-----------------+------------------+------+-----+---------------------+-------------------------------+
```

`users` table has the following constraints:
```SQL
MariaDB [ecb-rates-db]> SHOW CREATE TABLE users\G
...
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_name` (`user_name`)
...

```


- `users_groups` table for mapping users to groups:

`users_groups` table helps to map `users` with the `groups` of access rights.

**Comment:** It's required to `normalize` database `many-to-many` relationship.

```SQL
MariaDB [ecb-rates-db]> describe users_groups;
+--------------+---------------------+------+-----+---------------------+-------------------------------+
| Field        | Type                | Null | Key | Default             | Extra                         |
+--------------+---------------------+------+-----+---------------------+-------------------------------+
| user_id      | int(10) unsigned    | NO   | PRI | NULL                |                               |
| group_id     | tinyint(3) unsigned | NO   | PRI | NULL                |                               |
| updated_time | timestamp           | NO   |     | current_timestamp() | on update current_timestamp() |
+--------------+---------------------+------+-----+---------------------+-------------------------------+
```

`users_groups` table has the following constraints:
```SQL
MariaDB [ecb-rates-db]> SHOW CREATE TABLE users_groups\G
...
  PRIMARY KEY (`user_id`,`group_id`),
  KEY `fk_group_id` (`group_id`),
  CONSTRAINT `fk_group_id` FOREIGN KEY (`group_id`) REFERENCES `groups` (`group_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE
...

```


- `currencies` table for currencies' codes and names:

Currency codes format is from ISO 4217: https://en.wikipedia.org/wiki/ISO_4217
For example: `EUR, 978, 2, Euro`

`minor_unit` represents the number of digits after the decimal separator.

```SQL
MariaDB [ecb-rates-db]> describe currencies;
+-----------------+---------------------+------+-----+---------------------+-------------------------------+
| Field           | Type                | Null | Key | Default             | Extra                         |
+-----------------+---------------------+------+-----+---------------------+-------------------------------+
| alphabetic_code | char(3)             | NO   | PRI | NULL                |                               |
| numeric_code    | char(3)             | NO   | UNI | NULL                |                               |
| minor_unit      | tinyint(3) unsigned | YES  |     | NULL                |                               |
| currency        | varchar(40)         | NO   |     | NULL                |                               |
| updated_time    | timestamp           | NO   |     | current_timestamp() | on update current_timestamp() |
+-----------------+---------------------+------+-----+---------------------+-------------------------------+
```

`currencies` table has the following constraints:
```SQL
MariaDB [ecb-rates-db]> SHOW CREATE TABLE currencies\G
...
  PRIMARY KEY (`alphabetic_code`),
  UNIQUE KEY `numeric_code` (`numeric_code`)
...

```


- `publications` table for bank day's info:

European Central Bank (ECB) publications of currency exchange rates are listened from: https://www.bank.lv/vk/ecb_rss.xml
   For example: 
```XML
...
<title>Eiropas Centrālās bankas publicētie eiro atsauces kursi. 17. March_LONG</title>
<link>https://www.bank.lv/</link>
<guid isPermaLink="false">https://www.bank.lv/#17.03</guid>
<description><![CDATA[AUD 1.50550000 BGN 1.95580000 BRL 5.63390000 CAD 1.39980000 CHF 1.03850000 CNY 7.01760000 CZK 24.77700000 DKK 7.44390000 GBP 0.84315000 HKD 8.63910000 HRK 7.57300000 HUF 372.05000000 IDR 15835.97000000 ILS 3.57770000 INR 83.84350000 ISK 142.10000000 JPY 131.27000000 KRW 1340.02000000 MXN 22.78800000 MYR 4.63640000 NOK 9.78000000 NZD 1.61300000 PHP 57.69000000 PLN 4.68890000 RON 4.94650000 SEK 10.45030000 SGD 1.49800000 THB 36.76700000 TRY 16.31230000 USD 1.10510000 ZAR 16.52860000 ]]></description>
<pubDate>Thu, 17 Mar 2022 02:00:00 +0200</pubDate>
...
```

```SQL
MariaDB [ecb-rates-db]> describe publications;
+---------------+----------------------+------+-----+---------------------+-------------------------------+
| Field         | Type                 | Null | Key | Default             | Extra                         |
+---------------+----------------------+------+-----+---------------------+-------------------------------+
| pub_id        | smallint(5) unsigned | NO   | PRI | NULL                | auto_increment                |
| pub_title     | char(80)             | NO   |     | NULL                |                               |
| pub_link      | char(40)             | NO   |     | NULL                |                               |
| pub_perm_link | char(40)             | NO   |     | NULL                |                               |
| pub_date      | datetime             | NO   | UNI | NULL                |                               |
| updated_time  | timestamp            | NO   |     | current_timestamp() | on update current_timestamp() |
+---------------+----------------------+------+-----+---------------------+-------------------------------+
```

`publications` table has the following constraints:
```SQL
MariaDB [ecb-rates-db]> SHOW CREATE TABLE publications\G
...
  PRIMARY KEY (`pub_id`),
  UNIQUE KEY `pub_date` (`pub_date`)
...

```


- `rates` table for currency exchange rates of a day:

ECB Currency exchange rates are from: https://www.bank.lv/en/component/content/article?id=8791
For example: `20050322, GBP, 0.69410`

```SQL
MariaDB [ecb-rates-db]> describe rates;
+--------------+------------------------+------+-----+---------------------+-------------------------------+
| Field        | Type                   | Null | Key | Default             | Extra                         |
+--------------+------------------------+------+-----+---------------------+-------------------------------+
| cal_day      | date                   | NO   | PRI | NULL                |                               |
| cur_code     | char(3)                | NO   | PRI | NULL                |                               |
| value        | decimal(10,5) unsigned | NO   |     | NULL                |                               |
| pub_id       | smallint(5) unsigned   | NO   | MUL | NULL                |                               |
| updated_time | timestamp              | NO   |     | current_timestamp() | on update current_timestamp() |
+--------------+------------------------+------+-----+---------------------+-------------------------------+
```

`rates` table has the following constraints:
```SQL
MariaDB [ecb-rates-db]> SHOW CREATE TABLE rates\G
...
  PRIMARY KEY (`cal_day`,`cur_code`),
  KEY `fk_cur_code_alphabetic` (`cur_code`),
  KEY `fk_pub_id` (`pub_id`),
  CONSTRAINT `fk_cur_code_alphabetic` FOREIGN KEY (`cur_code`) REFERENCES `currencies` (`alphabetic_code`) ON UPDATE CASCADE,
  CONSTRAINT `fk_pub_id` FOREIGN KEY (`pub_id`) REFERENCES `publications` (`pub_id`) ON UPDATE CASCADE
...

```
