-- 00.MySQL 계정 생성.sql

/*
 * 사용자 계정 생성
 * 해당 사용자는 playdata database 사용 예정
 * 작업 단계
 * 1. 사용자 계정 생성(SCOTT/TIGHER)
 * 2. 권한 부여
 * 3. 사용자 계정으로 DDL(create/drop/alter) + DML(insert/update/delete) + DQL(select)
 * 4. DBeaver에 SCOTT/TIGER 계정으로 접속 instance 생성
 * 
 */

-- admin인 root 계정으로 접속(cmd)
>mysql -u root -p

-- database list 확인
SHOW DATABASES;

-- mysql 사용자 리스트 확인
-- mysql database는 사용자 계정에 대한 정보 보유
USE mysql;

SELECT USER FROM USER;

-- SCOTT/TIGER 계정 생성

-- 로컬 user 생성 명령어 : host=localhost
create user 'SCOTT'@'localhost' identified by 'TIGER';

-- 외부 접속 user 생성 명령어 : host=%
create user 'SCOTT'@'%' identified by 'TIGER';

-- 특정 ip 주소에서만 접속 가능한 user 생성 방식



-- 특정 database 사용 가능하게 권한 부여
-- admin으로 로그인 (root 계정) 해야지만 권한 부여 가능
GRANT ALL PRIVILEGES ON playdata.* TO 'SCOTT'@'localhost';

-- 생성 및 권한이 있는 SCOTT 계정으로 playdata인 database 사용 명령어
mysql -u SCOTT -p

-- use mysql; 권한 없어서 에러 발생
-- select user from user; 권한 없어서 에러 발생

SHOW DATABASES;
USE playdata;
SHOW tables;
SELECT * FROM emp;
SELECT * FROM dept;

-- 계정 삭제
-- admin 계정 (root 계정)으로 접속 필요
mysql> DROP USER 'SCOTT'@'%';

mysql> SELECT USER, host FROM USER; -- 제대로 삭제되었는지 확인
mysql> SHOW grants FOR 'SCOTT'@'localhost'; -- 해당 user의 권한을 확인하는 명령어

