/* Currency codes format is from ISO 4217: https://en.wikipedia.org/wiki/ISO_4217
   For example: EUR, 978, 2, Euro */
CREATE TABLE IF NOT EXISTS currencies(
  alphabetic_code CHAR(3) PRIMARY KEY, 
  numeric_code CHAR(3) NOT NULL UNIQUE KEY, 

  /* minor_unit represents the number of digits after the decimal separator */
  minor_unit TINYINT UNSIGNED,
  currency_name VARCHAR(40) CHARSET UTF8 NOT NULL, 
  updated_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


/* European Central Bank (ECB) publications of currency exchange rates are listened from: https://www.bank.lv/vk/ecb_rss.xml
   For example: 
      <title>Eiropas Centrālās bankas publicētie eiro atsauces kursi. 17. March_LONG</title>
      <link>https://www.bank.lv/</link>
      <guid isPermaLink="false">https://www.bank.lv/#17.03</guid>
      <description><![CDATA[AUD 1.50550000 BGN 1.95580000 BRL 5.63390000 CAD 1.39980000 CHF 1.03850000 CNY 7.01760000 CZK 24.77700000 DKK 7.44390000 GBP 0.84315000 HKD 8.63910000 HRK 7.57300000 HUF 372.05000000 IDR 15835.97000000 ILS 3.57770000 INR 83.84350000 ISK 142.10000000 JPY 131.27000000 KRW 1340.02000000 MXN 22.78800000 MYR 4.63640000 NOK 9.78000000 NZD 1.61300000 PHP 57.69000000 PLN 4.68890000 RON 4.94650000 SEK 10.45030000 SGD 1.49800000 THB 36.76700000 TRY 16.31230000 USD 1.10510000 ZAR 16.52860000 ]]></description>
      <pubDate>Thu, 17 Mar 2022 02:00:00 +0200</pubDate> */
CREATE TABLE IF NOT EXISTS publications(
  pub_datetime DATE PRIMARY KEY,
  pub_title VARCHAR(80), 
  pub_link VARCHAR(80), 
  pub_guid VARCHAR(80),
  updated_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


/* ECB Currency exchange rates are from: https://www.bank.lv/en/component/content/article?id=8791
   For example: 20050322, GBP, 0.69410 */
CREATE TABLE IF NOT EXISTS rates(
  pub_datetime DATE NOT NULL, 
  cur_code CHAR(3) NOT NULL, 
  evening_rate DECIMAL (10, 5) UNSIGNED NOT NULL,
  updated_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
  PRIMARY KEY (pub_datetime, cur_code), 
  CONSTRAINT fk_cur_code_alphabetic FOREIGN KEY(cur_code) REFERENCES currencies(alphabetic_code) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_pub_datetime FOREIGN KEY(pub_datetime) REFERENCES publications(pub_datetime) ON UPDATE CASCADE ON DELETE RESTRICT
);
