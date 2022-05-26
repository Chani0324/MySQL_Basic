/*
 * 1. 파일 내용
 * 	- mysql 학습용 table 생성
 * 	- 현 구조는 oracle db 자체적으로 학습용으로 제공한 table의 mysql용으로
 * 
 * 2. mysql 특징
 * 	- database 생성 및 활용
 * 		- db 내부 공간을 사용하고자 공간 이름을 먼저 부여해서 확보 및 이용 가능
 * 	- oracle db와 달리 database 생성부터 선행 필수
 * 		- oracle db는 id/pw로 접속 후에 table생성 및 crud 작업 가능
 * 		- mysql db는 id/pw로 접속 후에 database 생성 및 접속, table 생성하여 crud 작업
 * 
 * 3. sql
 * 	- RDBMS(관계형 데이터베이스) 사용 언어(명령어)
 * 	- 구조 : table 구조(column, row)로 구성
 * 	- table : 사용 명령어
 * 		- table 생성 create / 삭제 delete
 * 		- table에 데이터 저장 insert / 검색 select / 수정 update / 삭제 delete
 * 
 * 4. CRUD 
 * 	- create / read / update / delete
 * 	- sql : insert / select / update / delete
 * 
 * 5. DDL - Data definition Language
 * 		create / drop / alter
 * 6. DML - Data Manipulation Language
 * 		insert / select / update / delete
 * 7. Transaction Controller Language
 * 		commit(영구저장) / rollback(복원)
 * 8. query - select
 * 
 * 	- 수업 실습 단계
 * 		select(join, 함수, 서브쿼리..) -> DML -> DDL -> DML -> TCL ...
 */

-- 현 mysql에 어떤 공간으로 분할할지(database들 확인)
show databases;

-- 사용자 정의로 database 생성
CREATE DATABASE playdata;

-- database에 접속.(필수)
USE playdata;

-- emp와 dept라는 table이 혹여 존재할 경우 삭제하는 명령어
drop table IF EXISTs emp;
drop table IF EXISTs dept;

-- dept table 생성
-- 한부서 표현 속성 : 부서번호(중복불허) / 부서명 / 지역
CREATE TABLE dept (
    deptno               int  NOT NULL ,
    dname                varchar(20),
    loc                  varchar(20),
    CONSTRAINT pk_dept PRIMARY KEY ( deptno )
 );
 
CREATE TABLE emp (
    empno                int  NOT NULL  AUTO_INCREMENT,
    ename                varchar(20),
    job                  varchar(20),
    mgr                  smallint ,
    hiredate             date,
    sal                  numeric(7, 2)    ,
    comm                 numeric(7, 2)    ,
    deptno               int,
    CONSTRAINT pk_emp PRIMARY KEY ( empno )
 );
 
-- dept table의 부서 번호와 emp table의 부서 번호를 동기화
-- 즉 dept의 deptno(부서번호)가 없는 데이터는 절대 emp의 deptno에 insert 불가
-- db 자체가 거부
-- table 생성시에 sql문장으로 설정
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY ( deptno ) REFERENCES dept( deptno ) ON DELETE NO ACTION ON UPDATE NO ACTION;


-- 대소문자 구분을 위한 설정
-- oracle db는 기본 설정으로 데이터의 대소문자 구분
-- emp table의 ename은 반드시 대소문자 구분하라는 설정
alter table emp change ename ename varchar(20) binary;


-- 존재하는 table에 데이터 저장
insert into dept values(10, 'ACCOUNTING', 'NEW YORK');
insert into dept values(20, 'RESEARCH', 'DALLAS');
insert into dept values(30, 'SALES', 'CHICAGO');
insert into dept values(40, 'OPERATIONS', 'BOSTON');
   
-- db는 자체적으로 데이터를 쉽게 가공할 수 있게 내장함수들 제공
-- STR_TO_DATE() : 단순 문자열을 날짜 형식의 타입으로 변환
insert into emp values( 7839, 'KING', 'PRESIDENT', null, STR_TO_DATE ('17-11-1981','%d-%m-%Y'), 5000, null, 10);
insert into emp values( 7698, 'BLAKE', 'MANAGER', 7839, STR_TO_DATE('1-5-1981','%d-%m-%Y'), 2850, null, 30);
insert into emp values( 7782, 'CLARK', 'MANAGER', 7839, STR_TO_DATE('9-6-1981','%d-%m-%Y'), 2450, null, 10);
insert into emp values( 7566, 'JONES', 'MANAGER', 7839, STR_TO_DATE('2-4-1981','%d-%m-%Y'), 2975, null, 20);
insert into emp values( 7788, 'SCOTT', 'ANALYST', 7566, DATE_ADD(STR_TO_DATE('13-7-1987','%d-%m-%Y'),INTERVAL -85 DAY)  , 3000, null, 20);
insert into emp values( 7902, 'FORD', 'ANALYST', 7566, STR_TO_DATE('3-12-1981','%d-%m-%Y'), 3000, null, 20);
insert into emp values( 7369, 'SMITH', 'CLERK', 7902, STR_TO_DATE('17-12-1980','%d-%m-%Y'), 800, null, 20);
insert into emp values( 7499, 'ALLEN', 'SALESMAN', 7698, STR_TO_DATE('20-2-1981','%d-%m-%Y'), 1600, 300, 30);
insert into emp values( 7521, 'WARD', 'SALESMAN', 7698, STR_TO_DATE('22-2-1981','%d-%m-%Y'), 1250, 500, 30);
insert into emp values( 7654, 'MARTIN', 'SALESMAN', 7698, STR_TO_DATE('28-09-1981','%d-%m-%Y'), 1250, 1400, 30);
insert into emp values( 7844, 'TURNER', 'SALESMAN', 7698, STR_TO_DATE('8-9-1981','%d-%m-%Y'), 1500, 0, 30);
insert into emp values( 7876, 'ADAMS', 'CLERK', 7788, DATE_ADD(STR_TO_DATE('13-7-1987', '%d-%m-%Y'),INTERVAL -51 DAY), 1100, null, 20);
insert into emp values( 7900, 'JAMES', 'CLERK', 7698, STR_TO_DATE('3-12-1981','%d-%m-%Y'), 950, null, 30);
insert into emp values( 7934, 'MILLER', 'CLERK', 7782, STR_TO_DATE('23-1-1982','%d-%m-%Y'), 1300, null, 10);
   
-- db에 작업한 내용을 영구 저장하는 필수 명령어
-- insert / update / delete 명령에만 적용
-- 참고 : commit 영구 저장은 tool별로 기본 속성으로 처리 하기도 하나 코드로 commit 작업 권장
commit;

-- 데이터가 정상 저장이 되었는지 검색
-- emp라는 table로부터 모든 데이터 검색
SELECT * FROM emp;