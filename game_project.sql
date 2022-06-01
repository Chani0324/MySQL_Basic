SHOW DATABASES;

-- create database gamedata;

use gamedata;

drop table if exists characterInfo;
drop table if exists guildInfo; 


-- 테이블 생성 및 PK 설정
CREATE TABLE characterInfo (
	char_id 				varchar(30) BINARY,
	user_id					varchar(30) BINARY,
	g_num					SMALLINT,
	job						varchar(10),
	lev 					smallint,
	c_power					int,
	server_name				varchar(3),
	char_sex				varchar(1),
	create_date				date,
	last_date				date,
	cash					int,	
	CHECK (char_id NOT REGEXP '!|@|#|&|<|>'),
	CHECK (user_id NOT REGEXP '!|@|#|&|<|>'),
	CHECK (job REGEXP 'Warrior|Magician|Archer|Priest|Assassin|GM'),
	CHECK (lev BETWEEN 1 AND 255),
	CHECK (c_power > 0),
	CHECK (server_name REGEXP 'KOR|AUS|USA|JPN|CAN'),
	CHECK (char_sex REGEXP 'M|F'),
	CHECK (create_date >= '2020-05-30'),
	CHECK (last_date >= create_date),
	CHECK (cash >= 0),
	CONSTRAINT pk_characterInfo PRIMARY KEY (char_id)
);

CREATE TABLE guildInfo (
	g_num					SMALLINT AUTO_INCREMENT,
	g_name					varchar(30) BINARY UNIQUE NOT NULL,
	g_trend					varchar(10),
	g_region				varchar(6),
	g_lev					SMALLINT,
	g_create_date			date,
	CHECK (g_name NOT REGEXP '!|@|#|&|<|>'),
	CHECK (g_trend REGEXP 'FriendShip|PVE|PVP|Life'),
	CHECK (g_region REGEXP 'North|West|East|South|Middle'),
	CHECK (g_create_date >= '2020-05-30'),
	CONSTRAINT pk01_guildInfo PRIMARY KEY (g_num)
);

-- g_num Auto_increment 설정
ALTER TABLE guildInfo AUTO_INCREMENT = 1000;

-- FK 설정
ALTER TABLE characterInfo ADD CONSTRAINT fk_characterInfo_guildInfo FOREIGN KEY (g_num) REFERENCES guildInfo(g_num) ON DELETE NO ACTION ON UPDATE NO ACTION;


-- guildInfo table에 data 저장
-- g_num, g_name, g_trend, g_region, g_lev, g_create_date
INSERT INTO guildInfo (g_name, g_trend, g_region, g_lev, g_create_date) 
	VALUES ('광부인생', 'PVE', 'North', 25, '2020-07-30');
INSERT INTO guildInfo (g_name, g_trend, g_region, g_lev, g_create_date) 
	VALUES ('투기장', 'PVP', 'Middle', 21, '2021-04-11');
INSERT INTO guildInfo (g_name, g_trend, g_region, g_lev, g_create_date) 
	VALUES ('잼기장', 'PVP', 'South', 28, '2022-01-08');
INSERT INTO guildInfo (g_name, g_trend, g_region, g_lev, g_create_date) 
	VALUES ('40대이상만', 'PVE', 'Middle', 37, '2020-05-30');
INSERT INTO guildInfo (g_name, g_trend, g_region, g_lev, g_create_date) 
	VALUES ('카트하실분', 'Life', 'Middle', 17, '2021-12-24');
INSERT INTO guildInfo (g_name, g_trend, g_region, g_lev, g_create_date) 
	VALUES ('솔로만오세요', 'FriendShip', 'East', 38, '2020-10-23');
INSERT INTO guildInfo (g_name, g_trend, g_region, g_lev, g_create_date) 
	VALUES ('JUSTICE', 'PVE', 'West', 31, '2021-06-09');
INSERT INTO guildInfo (g_name, g_trend, g_region, g_lev, g_create_date) 
	VALUES ('성기사만', 'PVP', 'Middle', 28, '2020-12-26');
INSERT INTO guildInfo (g_name, g_trend, g_region, g_lev, g_create_date) 
	VALUES ('Playdata', 'Life', 'Middle', 9, '2022-05-09');
INSERT INTO guildInfo (g_name, g_trend, g_region, g_lev, g_create_date) 
	VALUES ('중원', 'PVE', 'South', 8, '2022-03-24');

-- characterInfo table에 data 저장
-- char_id, user_id, g_num, job, lev, c_power, server_name, char_sex, create_date, last_date, cash
INSERT INTO characterInfo VALUES ('No1나만도시락', 'No1나만도시락', 1000, 'Magician', 101, 15762, 'KOR', 'F', '2020-05-31', '2022-04-23', 192800);
INSERT INTO characterInfo VALUES ('No2나만도시락', 'No1나만도시락', 1000, 'Assassin', 97, 12831, 'KOR', 'M', '2021-08-22', '2022-04-29', 123900);
INSERT INTO characterInfo VALUES ('세바스짱', '세바스짱', 1000, 'Archer', 105, 16642, 'KOR', 'F', '2020-09-17', '2022-05-30', 1800);
INSERT INTO characterInfo VALUES ('뭐하세요', '트롤인데요', 1003, 'Warrior', 66, 354, 'USA', 'M', '2021-08-22', '2022-04-14', 1000000);
INSERT INTO characterInfo VALUES ('트롤인데요', '트롤인데요', 1003, 'Archer', 112, 17371, 'USA', 'F', '2020-10-30', '2022-05-06', 827100);
INSERT INTO characterInfo VALUES ('성기사있으면던짐', '성기사있으면던짐', 1009, 'Priest', 99, 14872, 'JPN', 'M', '2021-01-01', '2022-02-11', 16200);
INSERT INTO characterInfo VALUES ('투신', '투신', 1005, 'Assassin', 123, 19882, 'CAN', 'F', '2020-10-18', '2022-01-21', 500);
INSERT INTO characterInfo VALUES ('이렐리아', '빅토르', 1002, 'Warrior', 90, 11829, 'AUS', 'F', '2021-09-22', '2022-05-23', 293800);
INSERT INTO characterInfo VALUES ('빅토르', '빅토르', 1002, 'Magician', 100, 15872, 'AUS', 'M', '2021-02-17', '2022-06-01', 10100);
INSERT INTO characterInfo VALUES ('Karina★', '빅토르', 1006, 'Archer', 103, 15442, 'AUS', 'M', '2020-06-19', '2022-05-31', 56200);


COMMIT;

SELECT * FROM characterInfo;
SELECT * FROM guildInfo
