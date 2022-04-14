/* Currencies reported by https://www.bank.lv/vk/ecb_rss.xml
   Data source:
   https://www.six-group.com/en/products-services/financial-information/data-standards.html#scrollTo=maintenance-agency */
/* Historical currencies were added to allow exchange rates from 04 Jan 1999*/
INSERT INTO currencies(alphabetic_code, numeric_code, minor_unit, currency_name)
VALUES 
  ('LTL', '440', 2, 'Lithuanian Litas'),
  ('LVL', '428', 2, 'Latvian lats'),
  ('AUD', '036', 2, 'Australian Dollar'),
  ('AUD', '036', 2, 'Australian Dollar'),
  ('BGN', '975', 2, 'Bulgarian Lev'),
  ('BRL', '986', 2, 'Brazilian Real'),
  ('CAD', '124', 2, 'Canadian Dollar'),
  ('CHF', '756', 2, 'Swiss Franc'),
  ('CNY', '156', 2, 'Yuan Renminbi'),
  ('CZK', '203', 2, 'Czech Koruna'),
  ('DKK', '208', 2, 'Danish Krone'),
  ('GBP', '826', 2, 'Pound Sterling'),
  ('HKD', '344', 2, 'Hong Kong Dollar'),
  ('HRK', '191', 2, 'Kuna'),
  ('HUF', '348', 2, 'Forint'),
  ('IDR', '360', 2, 'Rupiah'),
  ('INR', '356', 2, 'Indian Rupee'),
  ('ILS', '376', 2, 'New Israeli Sheqel'),
  ('ISK', '352', 0, 'Iceland Krona'),
  ('JPY', '392', 0, 'Yen'),
  ('KRW', '410', 0, 'Won'),
  ('MXN', '484', 2, 'Mexican Peso'),
  ('MYR', '458', 2, 'Malaysian Ringgit'),
  ('NOK', '578', 2, 'Norwegian Krone'),
  ('NZD', '554', 2, 'New Zealand Dollar'),
  ('PHP', '608', 2, 'Philippine Peso'),
  ('PLN', '985', 2, 'Zloty'),
  ('RON', '946', 2, 'Romanian Leu'),
  ('SEK', '752', 2, 'Swedish Krona'),
  ('SGD', '702', 2, 'Singapore Dollar'),
  ('THB', '764', 2, 'Baht'),
  ('TRY', '949', 2, 'Turkish Lira'),
  ('USD', '840', 2, 'US Dollar'),
  ('ZAR', '710', 2, 'Rand'),
  ('AED', '784', 2, 'UAE Dirham'),
  ('AFN', '971', 2, 'Afghani'),
  ('ALL', '008', 2, 'Lek'),
  ('AMD', '051', 2, 'Armenian Dram'),
  ('ANG', '532', 2, 'Netherlands Antillean Guilder'),
  ('AOA', '973', 2, 'Kwanza'),
  ('ARS', '032', 2, 'Argentine Peso'),
  ('AWG', '533', 2, 'Aruban Florin'),
  ('AZN', '944', 2, 'Azerbaijan Manat'),
  ('BAM', '977', 2, 'Convertible Mark'),
  ('BBD', '052', 2, 'Barbados Dollar'),
  ('BDT', '050', 2, 'Taka'),
  ('BHD', '048', 3, 'Bahraini Dinar'),
  ('BIF', '108', 0, 'Burundi Franc'),
  ('BMD', '060', 2, 'Bermudian Dollar'),
  ('BND', '096', 2, 'Brunei Dollar'),
  ('BOB', '068', 2, 'Boliviano'),
  ('BOV', '984', 2, 'Mvdol'),
  ('BSD', '044', 2, 'Bahamian Dollar'),
  ('BTN', '064', 2, 'Ngultrum'),
  ('BWP', '072', 2, 'Pula'),
  ('BYN', '933', 2, 'Belarusian Ruble'),
  ('BZD', '084', 2, 'Belize Dollar'),
  ('CDF', '976', 2, 'Congolese Franc'),
  ('CHE', '947', 2, 'WIR Euro'),
  ('CHW', '948', 2, 'WIR Franc'),
  ('CLF', '990', 4, 'Unidad de Fomento'),
  ('CLP', '152', 0, 'Chilean Peso'),
  ('COP', '170', 2, 'Colombian Peso'),
  ('COU', '970', 2, 'Unidad de Valor Real'),
  ('CRC', '188', 2, 'Costa Rican Colon'),
  ('CUC', '931', 2, 'Peso Convertible'),
  ('CUP', '192', 2, 'Cuban Peso'),
  ('CVE', '132', 2, 'Cabo Verde Escudo'),
  ('DJF', '262', 0, 'Djibouti Franc'),
  ('DOP', '214', 2, 'Dominican Peso'),
  ('DZD', '012', 2, 'Algerian Dinar'),
  ('EGP', '818', 2, 'Egyptian Pound'),
  ('ERN', '232', 2, 'Nakfa'),
  ('ETB', '230', 2, 'Ethiopian Birr'),
  ('EUR', '978', 2, 'Euro'),
  ('FJD', '242', 2, 'Fiji Dollar'),
  ('FKP', '238', 2, 'Falkland Islands Pound'),
  ('GEL', '981', 2, 'Lari'),
  ('GHS', '936', 2, 'Ghana Cedi'),
  ('GIP', '292', 2, 'Gibraltar Pound'),
  ('GMD', '270', 2, 'Dalasi'),
  ('GNF', '324', 0, 'Guinean Franc'),
  ('GTQ', '320', 2, 'Quetzal'),
  ('GYD', '328', 2, 'Guyana Dollar'),
  ('HNL', '340', 2, 'Lempira'),
  ('HTG', '332', 2, 'Gourde'),
  ('IQD', '368', 3, 'Iraqi Dinar'),
  ('IRR', '364', 2, 'Iranian Rial'),
  ('JMD', '388', 2, 'Jamaican Dollar'),
  ('JOD', '400', 3, 'Jordanian Dinar'),
  ('KES', '404', 2, 'Kenyan Shilling'),
  ('KGS', '417', 2, 'Som'),
  ('KHR', '116', 2, 'Riel'),
  ('KMF', '174', 0, 'Comorian Franc '),
  ('KPW', '408', 2, 'North Korean Won'),
  ('KWD', '414', 3, 'Kuwaiti Dinar'),
  ('KYD', '136', 2, 'Cayman Islands Dollar'),
  ('KZT', '398', 2, 'Tenge'),
  ('LAK', '418', 2, 'Lao Kip'),
  ('LBP', '422', 2, 'Lebanese Pound'),
  ('LKR', '144', 2, 'Sri Lanka Rupee'),
  ('LRD', '430', 2, 'Liberian Dollar'),
  ('LSL', '426', 2, 'Loti'),
  ('LYD', '434', 3, 'Libyan Dinar'),
  ('MAD', '504', 2, 'Moroccan Dirham'),
  ('MDL', '498', 2, 'Moldovan Leu'),
  ('MGA', '969', 2, 'Malagasy Ariary'),
  ('MKD', '807', 2, 'Denar'),
  ('MMK', '104', 2, 'Kyat'),
  ('MNT', '496', 2, 'Tugrik'),
  ('MOP', '446', 2, 'Pataca'),
  ('MRU', '929', 2, 'Ouguiya'),
  ('MUR', '480', 2, 'Mauritius Rupee'),
  ('MVR', '462', 2, 'Rufiyaa'),
  ('MWK', '454', 2, 'Malawi Kwacha'),
  ('MXV', '979', 2, 'Mexican Unidad de Inversion (UDI)'),
  ('MZN', '943', 2, 'Mozambique Metical'),
  ('NAD', '516', 2, 'Namibia Dollar'),
  ('NGN', '566', 2, 'Naira'),
  ('NIO', '558', 2, 'Cordoba Oro'),
  ('NPR', '524', 2, 'Nepalese Rupee'),
  ('OMR', '512', 3, 'Rial Omani'),
  ('PAB', '590', 2, 'Balboa'),
  ('PEN', '604', 2, 'Sol'),
  ('PGK', '598', 2, 'Kina'),
  ('PKR', '586', 2, 'Pakistan Rupee'),
  ('PYG', '600', 0, 'Guarani'),
  ('QAR', '634', 2, 'Qatari Rial'),
  ('RSD', '941', 2, 'Serbian Dinar'),
  ('RUB', '643', 2, 'Russian Ruble'),
  ('RWF', '646', 0, 'Rwanda Franc'),
  ('SAR', '682', 2, 'Saudi Riyal'),
  ('SBD', '090', 2, 'Solomon Islands Dollar'),
  ('SCR', '690', 2, 'Seychelles Rupee'),
  ('SDG', '938', 2, 'Sudanese Pound'),
  ('SHP', '654', 2, 'Saint Helena Pound'),
  ('SLL', '694', 2, 'Leone'),
  ('SOS', '706', 2, 'Somali Shilling'),
  ('SRD', '968', 2, 'Surinam Dollar'),
  ('SSP', '728', 2, 'South Sudanese Pound'),
  ('STN', '930', 2, 'Dobra'),
  ('SVC', '222', 2, 'El Salvador Colon'),
  ('SYP', '760', 2, 'Syrian Pound'),
  ('SZL', '748', 2, 'Lilangeni'),
  ('TJS', '972', 2, 'Somoni'),
  ('TMT', '934', 2, 'Turkmenistan New Manat'),
  ('TND', '788', 3, 'Tunisian Dinar'),
  ('TOP', '776', 2, 'Pa''anga'),
  ('TTD', '780', 2, 'Trinidad and Tobago Dollar'),
  ('TWD', '901', 2, 'New Taiwan Dollar'),
  ('TZS', '834', 2, 'Tanzanian Shilling'),
  ('UAH', '980', 2, 'Hryvnia'),
  ('UGX', '800', 0, 'Uganda Shilling'),
  ('USN', '997', 2, 'US Dollar (Next day)'),
  ('UYI', '940', 0, 'Uruguay Peso en Unidades Indexadas (UI)'),
  ('UYU', '858', 2, 'Peso Uruguayo'),
  ('UYW', '927', 4, 'Unidad Previsional'),
  ('UZS', '860', 2, 'Uzbekistan Sum'),
  ('VED', '926', 2, 'Bolívar Soberano'),
  ('VES', '928', 2, 'Bolívar Soberano'),
  ('VND', '704', 0, 'Dong'),
  ('VUV', '548', 0, 'Vatu'),
  ('WST', '882', 2, 'Tala'),
  ('XAF', '950', 0, 'CFA Franc BEAC'),
  ('XCD', '951', 2, 'East Caribbean Dollar'),
  ('XDR', '960', NULL, 'SDR (Special Drawing Right)'),
  ('XOF', '952', 0, 'CFA Franc BCEAO'),
  ('XPF', '953', 0, 'CFP Franc'),
  ('XSU', '994', NULL, 'Sucre'),
  ('XUA', '965', NULL, 'ADB Unit of Account'),
  ('YER', '886', 2, 'Yemeni Rial'),
  ('ZMW', '967', 2, 'Zambian Kwacha'),
  ('ZWL', '932', 2, 'Zimbabwe Dollar')
ON DUPLICATE KEY UPDATE alphabetic_code=alphabetic_code;  
--equivalent of doing nothing  */


/* Example of data in publications

INSERT INTO publications(pub_datetime, pub_title, pub_link, pub_guid)
VALUES
  ('2022-03-01',
   'Eiropas Centrālās bankas publicētie eiro atsauces kursi. 01. March_LONG', 
   'https://www.bank.lv', 
   'https://www.bank.lv/#01.03'
  ),
  ('2022-03-02',
   'Eiropas Centrālās bankas publicētie eiro atsauces kursi. 02. March_LONG', 
   'https://www.bank.lv', 
   'https://www.bank.lv/#02.03'
   
  ),
  ('2022-03-05', 
   'Eiropas Centrālās bankas publicētie eiro atsauces kursi. 05. March_LONG', 
   'https://www.bank.lv', 
   'https://www.bank.lv/#05.03'
  ),
  ('2022-03-07', 
   'Eiropas Centrālās bankas publicētie eiro atsauces kursi. 07. March_LONG', 
   'https://www.bank.lv', 
   'https://www.bank.lv/#07.03'
  ),
  ('2022-03-08', 
   'Eiropas Centrālās bankas publicētie eiro atsauces kursi. 08. March_LONG', 
   'https://www.bank.lv', 
   'https://www.bank.lv/#08.03'
  ),
  ('2022-03-11', 
   'Eiropas Centrālās bankas publicētie eiro atsauces kursi. 11. March_LONG', 
   'https://www.bank.lv', 
   'https://www.bank.lv/#11.03'
  ),
  ('2022-03-12', 
   'Eiropas Centrālās bankas publicētie eiro atsauces kursi. 12. March_LONG', 
   'https://www.bank.lv', 
   'https://www.bank.lv/#12.03'
  ),
  ('2022-03-13', 
   'Eiropas Centrālās bankas publicētie eiro atsauces kursi. 13. March_LONG', 
   'https://www.bank.lv', 
   'https://www.bank.lv/#13.03'
  ),
  ('2022-03-14', 
   'Eiropas Centrālās bankas publicētie eiro atsauces kursi. 14. March_LONG', 
   'https://www.bank.lv', 
   'https://www.bank.lv/#14.03'
  ),
  ('2022-03-15', 
   'Eiropas Centrālās bankas publicētie eiro atsauces kursi. 15. March_LONG', 
   'https://www.bank.lv', 
   'https://www.bank.lv/#15.03'
  )
  ON DUPLICATE KEY UPDATE pub_datetime=pub_datetime;
  --equivalent of doing nothing
*/


/* Example of data in rates

INSERT INTO rates(pub_datetime, cur_code, evening_rate)
VALUES 
  ('2022-03-11', 'USD', 1.09900),
  ('2022-03-12', 'USD', 1.09900),
  ('2022-03-13', 'USD', 1.09600),
  ('2022-03-14', 'USD', 1.09910),
  ('2022-03-15', 'USD', 1.09940),
  ('2022-03-11', 'CHF', 1.02300),
  ('2022-03-12', 'CHF', 1.02300),
  ('2022-03-13', 'CHF', 1.02490),
  ('2022-03-14', 'CHF', 1.03220),
  ('2022-03-15', 'CHF', 1.03360),
  ('2022-03-11', 'SGD', 1.49490),
  ('2022-03-12', 'SGD', 1.49490),
  ('2022-03-13', 'SGD', 1.49470),
  ('2022-03-14', 'SGD', 1.49930),
  ('2022-03-15', 'SGD', 1.49660)
ON DUPLICATE KEY UPDATE cur_code=cur_code;  
--equivalent of doing nothing
*/

