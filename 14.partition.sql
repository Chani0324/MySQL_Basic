-- 14.partition.sql
/*
 * 1. 기능
 * 	- 논리적으로 하나의 table이지만 물리적으로 여러개의 table로 분리해서 관리하는 기술
 * 	- 데이터와 index를 조각화해서 물리적 메모리를 효율적으로 사용
 * 	- 동일한 대용량 데이터를 RDBMS에서 효율적으로 처리하기 위한 기술
 * 		- 하둡, 스파크, ELK ... 등의 솔루션도 존재
 * 	- RDBMS는 정형 데이터 구조로 무결성 보장하면서 저장하기 위한 기술
 * 
 * 2. 장점	
 * 	- 하나의 table이 너무 클 경우 index의 크기가 물리적인 메모리 보다 훨씬 크거나 데이터 특성상 주기적인 삭제 작업이 필요한 경우 필요
 * 	- 단일 insert와 빠른 검색
 * 
 * 3. 파티션 키로 해당 데이터 저장 및 관리
 * 
 * 4. range() 사용한 partition
 * 	- 파티션 키로 연속된 범위로 파티션을 정의하는 방식
 *  - 가장 일반적
 *  - maxvalue라는 키워드를 사용시 명시되지 않은 범위의 키 값이 담긴 레코드를 저장하는 파티션 정의가 가능
 * 		- 마지막 파티션 기준 데이터를 포함한 그 이상의 모든 데이터를 파티션으로 저장 및 관리
*/

-- test data의 기준 연도

use playdata;


drop table emp00;

/*
 * 년도를 기준으로 하나의 table을 마치 물리적으로 다수의 table이 있는 것처럼 table 생성.
 */

CREATE TABLE emp00 (
    empno                int  NOT NULL,
    ename                varchar(20),
    job                  varchar(20),
    mgr                  smallint,
    hiredate             date,
    sal                  numeric(7, 2),
    comm                 numeric(7, 2),
    deptno               int
 ) PARTITION BY RANGE (YEAR(hiredate))(		-- 파티션 정의, range()가 파티션 키 설정.
 	PARTITION p0 VALUES less than (1980),
 	PARTITION p1 VALUES less than (1983),
 	PARTITION p2 VALUES less than (1986),
 	PARTITION p3 VALUES less than maxvalue
 );

SELECT year(hiredate) FROM emp;
SELECT hiredate FROM emp;





insert into emp00 values( 7839, 'KING', 'PRESIDENT', null, STR_TO_DATE ('17-11-1981','%d-%m-%Y'), 5000, null, 10);
insert into emp00 values( 7698, 'BLAKE', 'MANAGER', 7839, STR_TO_DATE('1-5-1981','%d-%m-%Y'), 2850, null, 30);
insert into emp00 values( 7782, 'CLARK', 'MANAGER', 7839, STR_TO_DATE('9-6-1981','%d-%m-%Y'), 2450, null, 10);
insert into emp00 values( 7566, 'JONES', 'MANAGER', 7839, STR_TO_DATE('2-4-1981','%d-%m-%Y'), 2975, null, 20);
insert into emp00 values( 7902, 'FORD', 'ANALYST', 7566, STR_TO_DATE('3-12-1981','%d-%m-%Y'), 3000, null, 20);
insert into emp00 values( 7369, 'SMITH', 'CLERK', 7902, STR_TO_DATE('17-12-1980','%d-%m-%Y'), 800, null, 20);
insert into emp00 values( 7499, 'ALLEN', 'SALESMAN', 7698, STR_TO_DATE('20-2-1981','%d-%m-%Y'), 1600, 300, 30);
insert into emp00 values( 7521, 'WARD', 'SALESMAN', 7698, STR_TO_DATE('22-2-1981','%d-%m-%Y'), 1250, 500, 30);
insert into emp00 values( 7654, 'MARTIN', 'SALESMAN', 7698, STR_TO_DATE('28-09-1981','%d-%m-%Y'), 1250, 1400, 30);
insert into emp00 values( 7844, 'TURNER', 'SALESMAN', 7698, STR_TO_DATE('8-9-1981','%d-%m-%Y'), 1500, 0, 30);
insert into emp00 values( 7900, 'JAMES', 'CLERK', 7698, STR_TO_DATE('3-12-1981','%d-%m-%Y'), 950, null, 30);
insert into emp00 values( 7934, 'MILLER', 'CLERK', 7782, STR_TO_DATE('23-1-1982','%d-%m-%Y'), 1300, null, 10);
insert into emp00 values( 7839, 'KING2', 'PRESIDENT', null, STR_TO_DATE ('17-11-1983','%d-%m-%Y'), 5000, null, 10);
insert into emp00 values( 7698, 'BLAKE2', 'MANAGER', 7839, STR_TO_DATE('1-5-1983','%d-%m-%Y'), 2850, null, 30);
insert into emp00 values( 7782, 'CLARK2', 'MANAGER', 7839, STR_TO_DATE('9-6-1983','%d-%m-%Y'), 2450, null, 10);
insert into emp00 values( 7566, 'JONES2', 'MANAGER', 7839, STR_TO_DATE('2-4-1983','%d-%m-%Y'), 2975, null, 20);
insert into emp00 values( 7902, 'FORD2', 'ANALYST', 7566, STR_TO_DATE('3-12-1983','%d-%m-%Y'), 3000, null, 20);
insert into emp00 values( 7369, 'SMITH2', 'CLERK', 7902, STR_TO_DATE('17-12-1980','%d-%m-%Y'), 800, null, 20);
insert into emp00 values( 7499, 'ALLEN2', 'SALESMAN', 7698, STR_TO_DATE('20-2-1983','%d-%m-%Y'), 1600, 300, 30);
insert into emp00 values( 7521, 'WARD2', 'SALESMAN', 7698, STR_TO_DATE('22-2-1983','%d-%m-%Y'), 1250, 500, 30);
insert into emp00 values( 7654, 'MARTIN2', 'SALESMAN', 7698, STR_TO_DATE('28-09-1983','%d-%m-%Y'), 1250, 1400, 30);
insert into emp00 values( 7844, 'TURNER2', 'SALESMAN', 7698, STR_TO_DATE('8-9-1983','%d-%m-%Y'), 1500, 0, 30);
insert into emp00 values( 7900, 'JAMES2', 'CLERK', 7698, STR_TO_DATE('3-12-1983','%d-%m-%Y'), 950, null, 30);
insert into emp00 values( 7934, 'MILLER2', 'CLERK', 7782, STR_TO_DATE('23-1-1984','%d-%m-%Y'), 1300, null, 10);
insert into emp00 values( 7839, 'KING2', 'PRESIDENT', null, STR_TO_DATE ('17-11-1985','%d-%m-%Y'), 5000, null, 10);
insert into emp00 values( 7698, 'BLAKE2', 'MANAGER', 7839, STR_TO_DATE('1-5-1985','%d-%m-%Y'), 2850, null, 30);
insert into emp00 values( 7782, 'CLARK2', 'MANAGER', 7839, STR_TO_DATE('9-6-1985','%d-%m-%Y'), 2450, null, 10);
insert into emp00 values( 7566, 'JONES2', 'MANAGER', 7839, STR_TO_DATE('2-4-1985','%d-%m-%Y'), 2975, null, 20);
insert into emp00 values( 7902, 'FORD2', 'ANALYST', 7566, STR_TO_DATE('3-12-1985','%d-%m-%Y'), 3000, null, 20);
insert into emp00 values( 7369, 'SMITH2', 'CLERK', 7902, STR_TO_DATE('17-12-1980','%d-%m-%Y'), 800, null, 20);
insert into emp00 values( 7499, 'ALLEN2', 'SALESMAN', 7698, STR_TO_DATE('20-2-1985','%d-%m-%Y'), 1600, 300, 30);
insert into emp00 values( 7521, 'WARD2', 'SALESMAN', 7698, STR_TO_DATE('22-2-1985','%d-%m-%Y'), 1250, 500, 30);
insert into emp00 values( 7654, 'MARTIN2', 'SALESMAN', 7698, STR_TO_DATE('28-09-1985','%d-%m-%Y'), 1250, 1400, 30);
insert into emp00 values( 7844, 'TURNER2', 'SALESMAN', 7698, STR_TO_DATE('8-9-1985','%d-%m-%Y'), 1500, 0, 30);
insert into emp00 values( 7900, 'JAMES2', 'CLERK', 7698, STR_TO_DATE('3-12-1985','%d-%m-%Y'), 950, null, 30);
insert into emp00 values( 7934, 'MILLER2', 'CLERK', 7782, STR_TO_DATE('23-1-1986','%d-%m-%Y'), 1300, null, 10);

commit;

select * from emp00;
SELECT * FROM emp00 WHERE hiredate='1986-01-23'

desc emp00;

-- 월 기준으로 데이터 나눠서 정리
DROP TABLE IF EXISTS emp00;

CREATE TABLE emp00 (
    empno                int  NOT NULL,
    ename                varchar(20),
    job                  varchar(20),
    mgr                  smallint,
    hiredate             date,
    sal                  numeric(7, 2),
    comm                 numeric(7, 2),
    deptno               int
 ) PARTITION BY list (month(hiredate))(		-- 파티션 정의, range()가 파티션 키 설정.
 	PARTITION p0 VALUES in (01),
 	PARTITION p1 VALUES in (02),
 	PARTITION p2 VALUES in (03),
 	PARTITION p3 VALUES in (04),
 	PARTITION p4 VALUES in (05),
 	PARTITION p5 VALUES in (06),
 	PARTITION p6 VALUES in (07),
 	PARTITION p7 VALUES in (08),
 	PARTITION p8 VALUES in (09),
 	PARTITION p9 VALUES in (10),
 	PARTITION p10 VALUES in (11),
 	PARTITION p11 VALUES in (12)
 );
