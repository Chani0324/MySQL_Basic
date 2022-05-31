-- 9.integrity.sql
-- DB 자체적으로 강제적인 제약 사항 설정

/*
1. table 생성시 제약조건을 설정하는 기법 
CREATE TABLE table_name (
    column1 datatype constraint,
    column2 datatype constraint,
    column3 datatype constraint,
    ....
);


2. Data Dictionary란?
	- 제약 조건등의 정보 확인
	- MySQL Server의 개체에 관한 모든 정보 보유하는 table
		- 일반 사용자가 검색은 가능하나 insert/update/delete 불가.
	- information_schema

3. 제약 조건 종류
	emp와 dept의 관계
		- dept의 deptno가 원조 / emp의 deptno는 참조
		- dept : 부모 table / emp : 자식 table
		- dept의 deptno는 중복 불허(not null) - PK(Primary Key)라고 함.
		- emp의 deptno는 FK(Forgein Key)라고 함.
		- 자식 table의 참조 data는 부모 table에서 없는 값을 사용할 수 없음.
		(emp의 deptno에 50같은 값을 먼저 넣을 수 없음. dept에 먼저 deptno 50 data가 있어야 됨)
	
	2-1. PK[primary key] - 기본키, 중복불가, null불가, 데이터들 구분을 위한 핵심 데이터
		: not null + unique
	2-2. not null - 반드시 데이터 존재
	2-3. unique - 중복 불가 
	2-4. check - table 생성시 규정한 범위의 데이터만 저장 가능 
	2-5. default - insert시에 특별한 데이터 미저장시에도 자동 저장되는 기본 값
					- 자바 관점에는 멤버 변수 선언 후 객체 생성 직후 멤버 변수 기본값으로 초기화
	* 2-6. FK[foreign key] 
		- 외래키[참조키], 다른 table의 pk를 참조하는 데이터 
		- table간의 주종 관계가 형성
		- pk 보유 table이 부모, 참조하는 table이 자식
	
4. 제약조건 적용 방식
	4-1. table 생성시 적용
		- create table의 마지막 부분에 설정.
			방법 1. 제약조건명 없이 설정
			방법 2. constraints 제약조건명 명시
			
			- : mysql의 pk에 설정한 사용자 정의 제약조건 이름은 data dictionary table에서 검색 불가.
				oracle db는 명확하게 사용자정의 제약조건명 검색 가능.

	4-2. alter 명령어로 제약조건 추가
	- 이미 존재하는 table의 제약조건 수정(추가, 삭제)명령어
		alter table 테이블명 modify 컬럼명 타입 제약조건;
		
	4-3. 제약조건 삭제(drop)
		- table삭제 
		alter table 테이블명 alter 컬럼명 drop 제약조건;
		
*/

use playdata;


-- 1. table 삭제
DROP TABLE IF EXISTS emp01;


-- 2. 사용자 정의 제약 조건명 명시하기
-- 개발자는 sql 문법 ok된 상태로 table + 제약조건 생성.
create table emp01(
	empno int not null,
	ename varchar(10)
);

desc emp01;

select TABLE_SCHEMA, TABLE_NAME 
from information_schema.TABLES
where TABLE_SCHEMA = 'information_schema';

-- 3. emp table의 제약조건 조회
-- table 생성시 column 선언 시에 not null;

SELECT * FROM INFORMATION_SCHEMA.table_constraints tc
WHERE table_name = 'emp01';

INSERT INTO emp01 (empno, ename) VALUES (1, '재석');
SELECT * FROM emp01;

INSERT INTO emp01 (empno) VALUES (2);
SELECT * FROM emp01;

INSERT INTO emp01 (ename) VALUES ('연아');
SELECT * FROM emp01;

-- *** not null ***
-- 4. alter 로 ename 컬럼을 not null로 변경
desc emp01;
-- emp01의 ename엔 null이 없어야 정상 실행.
DELETE FROM emp01 WHERE ename IS NULL;
ALTER TABLE emp01 MODIFY ename varchar(10) NOT NULL;

DESC emp01;

-- 5. drop 후 dictionary table 검색
drop table if exists emp01;

-- table 삭제시 제약조건도 같이 삭제됨.
select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp01';


-- 6. 제약 조건 설정후 insert 
create table emp01(
	empno int not null,
	ename varchar(10)
);

insert into emp01 values(1, 'tester');
select * from emp01;
insert into emp01 (empno, ename) values(2, 'tester');
insert into emp01 (empno) values(3);
select * from emp01;

-- 오류, empno는 절대 null 값 저장 불가


-- *** unique ***
-- 7. unique : 고유한 값만 저장 가능, null 허용
drop table if exists emp02;

CREATE TABLE emp02 (
	empno int UNIQUE,	-- 중복 데이터 불허.
	ename varchar(10)
);


select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp02';

insert into emp02 values(1, 'tester');
SELECT * FROM emp02;

insert into emp02 (ename) values('master');
select * from emp02;

insert into emp02 (empno) values(2);
select * from emp02;

insert into emp02 (empno) values(2);	-- 중복데이터 불허
select * from emp02;


-- 8. alter 명령어로 ename에 unique 적용

select * from emp02;
DELETE FROM emp02 WHERE ename IS NULL;

select * from emp02;
ALTER TABLE emp02 ADD UNIQUE (ename);
DESC emp02;


-- *** Primary key ***

-- 9. pk설정 : 데이터 구분을 위한 기준 컬럼, 중복과 null 불허
DROP TABLE IF EXISTS emp03;


select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp03';

CREATE TABLE emp03 (
	empno int,
	ename varchar(10) NOT null,
	PRIMARY key(empno)
);

select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp03';

DESC emp03;


insert into emp03 values (1, 'tester');
insert into emp03 values (1, 'master');
select * from emp03;


-- 10. 제약 조건명 명시 하면서 pk 설정
-- 제약 조건명 : pk_empno_emp03
drop table if exists emp03;

CREATE TABLE emp03(
	empno int,
	ename varchar(10) NOT null,
	constraint pk_empno_emp03 primary key (empno)
);

-- 사용자정의 제약 조건명 확인 가능. 단 pk와 not null은 확인 불가.
select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp03';

insert into emp03 values (1, 'tester');
insert into emp03 values (1, 'master');
select * from emp03;


-- 11. alter & pk 명령어 적용
drop table if exists emp03;

CREATE TABLE emp03(
	empno int,
	ename varchar(10) NOT null
);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp03';

ALTER TABLE emp03 ADD CONSTRAINT pk_empno_emp03 PRIMARY KEY (empno);


select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp03';


insert into emp03 values (1, 'tester');
insert into emp03 values (1, 'master');
select * from emp03;

-- 12. 제약 조건 삭제
ALTER TABLE emp03 DROP PRIMARY KEY;
DESC emp03;
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp03';




-- *** foreign key ***

-- 13. 외래키[참조키]
-- emp table 기반으로 emp04 복제 단 제약조건은 적용되지 않음
drop table if exists emp04;
create table emp04 as select * from emp;

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp';
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp04';

-- dept table의 deptno를 emp04의 deptno에 참조관계 형성
desc dept;

-- 생성시 fk 설정
drop table if exists emp04;

CREATE TABLE emp04 (
	empno int,
	ename varchar(10) NOT NULL,
	deptno int,
	PRIMARY KEY (empno),
	FOREIGN KEY (deptno) REFERENCES dept (deptno)
);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp04';

insert into emp04 values (1, '연아', 10);
insert into emp04 values (2, '구씨', 10);
-- dept의 deptno에는 70번이 없기 때문에 err 발생. 부모 table에 먼저 data가 있어야 함.
insert into emp04 values (3, '구씨', 70);


select * from emp04;

-- 14. fk drop : dict table에서 이름 확인후 삭제 
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp04';

alter table emp04 drop foreign key emp04_ibfk_2;

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp04';

-- alter & fk add
drop table if exists emp04;

create table emp04(
	empno int,
	ename varchar(10) not null,
	deptno int
);
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp04';

ALTER TABLE emp04 ADD FOREIGN KEY (deptno) REFERENCES dept (deptno);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp04';

-- 사용자 정의 제약조건명으로 fk 설정 및 삭제
ALTER TABLE emp04
ADD CONSTRAINT fk_deptno_emp04
FOREIGN KEY (deptno) REFERENCES dept (deptno);

ALTER TABLE emp04 DROP FOREIGN KEY fk_deptno_emp04;

	
-- *** check ***	
-- 15. check : if 조건식과 같이 저장 직전의 데이터의 유효 유무 검증하는 제약조건 
-- age값이 1~100까지만 DB에 저장
drop table if exists emp05;

-- 0초과 데이터만 age에 저장 가능하도록
CREATE TABLE emp05 (
	empno int PRIMARY KEY,
	ename varchar(10) NOT NULL,
	age int,
	CHECK (age > 0)
);

DESC emp05;

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';

insert into emp05 values(1, 'master', 10);
insert into emp05 values(2, 'master', -10); -- error

select * from emp05;


DROP TABLE IF EXISTS emp05;

CREATE TABLE emp05 (
	empno int PRIMARY KEY,
	ename varchar(10) NOT NULL,
	age int,
	CHECK (age BETWEEN 1 AND 100)
);

insert into emp05 values(1, 'master', 10);
insert into emp05 values(2, 'master', -10); -- error
insert into emp05 values(3, 'master', 100); 
insert into emp05 values(4, 'master', 101); -- error

DESC emp04;
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';


-- 16. alter & check
drop table if exists emp05;

create table emp05(
	empno int,
	ename varchar(10) not null,
	age int
);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';

ALTER TABLE emp05 ADD CHECK (age BETWEEN 1 AND 100);


insert into emp05 values(1, 'master', 10);
insert into emp05 values(2, 'master', -10); -- error

select * from emp05;

-- 17. drop a check : 제약조건명 검색 후에 이름으로 삭제
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';

ALTER TABLE emp05 DROP CHECK emp05_chk_1;

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';



-- 18. ? gender라는 컬럼에는 데이터가 M 또는(or) F만 저장되어야 함
drop table if exists emp06;

CREATE TABLE emp06 (
	empno int,
	ename varchar(10),
	gender varchar(10)
);

ALTER TABLE emp06 ADD CHECK (gender IN ('M', 'F'));
ALTER TABLE emp06 MODIFY gender char(1);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';
 
insert into emp06 values(1, 'master', 'F');
insert into emp01 values(2, 'master', 'T'); 
select * from emp06;

-- 19. alter & check

drop table if exists emp06;

create table emp06(
	empno int,
	ename varchar(10) not null,
	gender char(1)
);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';
 
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';

insert into emp06 values(1, 'master', 'F');
insert into emp01 values(2, 'master', 'T'); 
select * from emp06;


-- *** default ***
-- 19. 컬럼에 기본값 설정
drop table if exists emp06;

create table emp06(
	empno int,
	ename varchar(10) not null,
	age int default 1
);


select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';
 
insert into emp06 values(1, 'master', 'F');
insert into emp01 values(2, 'master', 'T'); -- error 
select * from emp06;


-- 20. alter & default

drop table if exists emp06;

create table emp06(
	empno int,
	ename varchar(10) not null,
	age int
);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';
ALTER TABLE emp06 ALTER age SET DEFAULT 1;

insert into emp06 values(1, 'master', 10);
select * from emp06;

insert into emp06 (empno, ename) values(2, 'use02');
select * from emp06;

-- 21. default drop 
alter table emp06 alter age drop default;
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';
insert into emp06 (empno, ename) values(3, 'use03'); 
select * from emp06;


