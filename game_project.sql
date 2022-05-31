SHOW DATABASES;

-- create database gamedata;

use gamedata;

drop table if exists characterInfo;
drop table if exists guildInfo; 


-- 테이블 생성 및 PK 설정
CREATE TABLE characterInfo (
	char_id 				varchar(30) NOT NULL,
	g_num					SMALLINT,
	job						varchar(10),
	lev 					smallint,
	c_power					int,
	server_name				varchar(3),
	char_sex				varchar(1),
	user_id					varchar(30),
	create_date				date,
	last_date				date,
	cash					int,	
	CHECK (char_id NOT REGEXP '!|@|#|&|<|>'),
	CHECK (user_id NOT REGEXP '!|@|#|&|<|>'),
	CHECK (create_date >= '2022-05-30'),
	CHECK (last_date >= '2022-05-30'),
	CHECK (cash >= 0),
	CHECK (lev 1 AND 255),
	CHECK (c_power > 0),
	CONSTRAINT pk_characterInfo PRIMARY KEY (char_id)
);

CREATE TABLE guildInfo (
	g_num					SMALLINT,
	g_name					varchar(30),
	g_trend					varchar(10),
	g_region				varchar(6),
	g_lev					SMALLINT,
	g_create_date			date,
	CONSTRAINT pk_guildInfo PRIMARY KEY (g_num)
);

-- FK 설정
ALTER TABLE characterInfo ADD CONSTRAINT fk_characterInfo_guildInfo FOREIGN KEY (g_num) REFERENCES guildInfo(g_num) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- 대소문자 구별해서 data 받음
ALTER TABLE characterInfo CHANGE char_id char_id varchar(30) BINARY;
ALTER TABLE characterInfo CHANGE user_id user_id varchar(30) BINARY;


-- guildInfo table에 data 저장
INSERT INTO guildInfo values(1, 'SKT_T1', '전투', '소환사협곡', 25, '2012-02-12');

-- characterInfo table에 data 저장
INSERT INTO characterInfo values('SKT_T1_Faker', 1, '마법사', 99, 12342, 'KOR', 'M', 'GoJeonPa', '2011-08-11', '2022-05-30', 2000);
INSERT INTO characterInfo values('SKT_T1_Zeus', 1, '전사', 93, 2829, 'KOR', 'M', 'TopLine', '2015-07-12', '2022-05-30', 1200);

COMMIT;

SELECT * FROM characterInfo;
SELECT * FROM guildInfo
