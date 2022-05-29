SHOW DATABASES;

-- create database gamedata;

use gamedata;

drop table if exists characterInfo;
drop table if exists guildInfo;


-- 테이블 생성 및 PK 설정
CREATE TABLE characterInfo (
	id 				varchar(20) NOT NULL,
	guildNum		int,
	job				varchar(10),
	lev 			SMALLINT,
	serverName		varchar(10),
	charSex			varchar(10),
	userID			varchar(20),
	createDate		date,
	lastDate		date,
	cashMoney		int,	
	CONSTRAINT pk_characterInfo PRIMARY KEY (id)	
);

CREATE TABLE guildInfo (
	guildNum		int NOT NULL,
	guildName		varchar(10),
	guildTend		varchar(6),
	guildRegion		varchar(10),
	guildLev		SMALLINT,
	guildCreateDate	date,
	CONSTRAINT pk_guildInfo PRIMARY KEY (guildNum)
);

-- FK 설정
ALTER TABLE characterInfo ADD CONSTRAINT fk_characterInfo_guildInfo FOREIGN KEY (guildNum) REFERENCES guildInfo(guildNum) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- 대소문자 구별해서 data 받음
ALTER TABLE characterInfo CHANGE id id varchar(20) BINARY;
ALTER TABLE characterInfo CHANGE userId userId varchar(20) BINARY;

-- guildInfo table에 data 저장
INSERT INTO guildInfo values(1, 'SKT_T1', '전투', '소환사협곡', 25, STR_TO_DATE('01-07-2012', '%d-%m-%Y'))

-- characterInfo table에 data 저장
INSERT INTO characterInfo values('SKT_T1_Faker', 1, '마법사', 99, 'Kor01', '남', 'GoJeonPa', STR_TO_DATE('01-04-2010', '%d-%m-%Y'), STR_TO_DATE('30-05-2022', '%d-%m-%Y'), 1000000);
INSERT INTO characterInfo values('SKT_T1_Zeus', 1, '전사', 93, 'Kor01', '남', 'TopLine', STR_TO_DATE('12-07-2015', '%d-%m-%Y'), STR_TO_DATE('30-05-2022', '%d-%m-%Y'), 98768);



SELECT * FROM characterInfo;
SELECT * FROM guildInfo