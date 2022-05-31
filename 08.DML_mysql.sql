-- mysql 일반 user SCOTT/TIGER
-- 실습시에 DBeaver에 commit 활용을 위해 auto commit 기능 해제.

-- 8.DML.sql
/* 
- DML : Data Mainpulation Language
            데이터 조작 언어
	   (select/insert/update/delete 모두 다 DML)
	   - 이미 존재하는 table에 데이터 저장, 수정, 삭제, 검색 
	   - commit과 rollback이 적용되는 명령어(transaction명령어) : insert/update/delete만 적용
	   
 
1. insert sql문법
	1-1. 모든 칼럼에 데이터 저장시 
		insert into table명 values(데이터값1, ...)

	1-2.  특정 칼럼에만 데이터 저장시,
		명확하게 칼럼명 기술해야 할 경우 
		insert into table명 (칼럼명1, ...) values(칼럼과매핑될데이터1...)


2. update 
	2-1. 모든 table(다수의 row)의 데이터 한번에 수정
		- where조건문 없는 문장
		- update table명 set 칼럼명=수정데이타;

	2-2. 특정 row값만 수정하는 방법
		- where조건문으로 처리하는 문장
		- update table명 set 칼럼명=수정데이타 where 조건sql;
*/

USE playdata;

-- *** insert ****
-- 1. 칼럼명 기술없이 데이터 입력
drop table IF EXISTS emp01;
drop table IF EXISTS emp02;

create table emp01 as select empno, ename, deptno from emp where 1=0;
create table emp02 as select empno, ename, deptno from emp where 1=0;

select * from emp01;
select * from emp02;

INSERT INTO emp01 VALUES(3212, 'KITTY', 20);

SELECT * FROM emp01;

-- 2. 칼럼명 기술후 데이터 입력 
-- 저장하고자하는 데이터의 순서를 컬럼명 명시하면서 변경 가능.
-- null을 허용하는 컬럼에 값 미저장시 특정 컬럼만 명시해서 값 저장가능.
INSERT INTO emp01 (deptno, ename, empno) values(10, '카르나', 1132);

-- mysql의 경우 타입이 int인 경우 java처럼 default값인 0으로 자동반영
INSERT INTO emp01 (ename) values('카리나');

SELECT * FROM emp01;
SELECT * FROM emp01 WHERE empno = 0;


-- 3. 다중 table에 한번에 데이터 insert하기 
-- , 구분자로 구분해서 저장가능.
drop TABLE IF EXISTS emp01;
drop table IF EXISTS emp02;
create table emp01 as select empno, ename, deptno from emp where 1=0;
create table emp02 as select empno, ename, deptno from emp where 1=0;
select * from emp01;
select * from emp02;

INSERT INTO emp01 VALUES (3212, 'KITTY', 20), (10, '카르나', 1132);

SELECT * FROM emp01;


-- 4. 데이터만 삭제 - rollback으로 복구 불가능한 데이터 삭제 명령어
truncate table emp01;
truncate table emp02;

ROLLBACK; -- 의미없음.
SELECT * FROM emp01;

INSERT INTO emp01 VALUES (3212, 'KITTY', 20), (10, '카르나', 1132);
COMMIT;
select * from emp01;

ROLLBACK;
select * from emp01;


-- *** update ***
-- 1. 테이블의 모든 행 변경
drop table emp01;
create table emp01 as select * from emp;
select deptno from emp01;

-- deptno 값을 50으로 변경
UPDATE emp01 SET deptno = 50;

select deptno from emp01;
ROLLBACK;

-- 10번 부터 번호를 50으로 번경
UPDATE emp01 SET deptno=50 WHERE deptno=10;
SELECT * FROM emp01;
COMMIT;

-- 2. ? emp01 table의 모든 사원의 급여를 10%(sal*1.1) 인상하기
-- ? emp table로 부터 empno, sal, hiredate, ename 순으로 table 생성
UPDATE emp01 SET sal = sal*1.1;
SELECT * FROM emp01;
COMMIT;


-- 3. emp01의 모든 사원의 입사일을 오늘로 바꿔주세요
UPDATE emp01 SET hiredate = curdate();
SELECT * FROM emp01;
COMMIT;



-- 4. 급여가 3000이상(where sal >= 3000)인 사원의 급여만 10%인상
UPDATE emp01 SET sal = sal*1.1 WHERE sal >= 3000;
SELECT sal FROM emp01;
COMMIT;


-- 5. ?emp01 table 사원의 급여가 1000이상인 사원들의 급여만 500원씩 삭감 
-- insert/update/delete 문장에 한해서만 commit과 rollback 영향을 받음
UPDATE emp01 SET sal = sal-500 WHERE sal >= 1000;
SELECT sal FROM emp01;
COMMIT;



-- 6. emp01 table에 DALLAS(dept의 loc)에 위치한 부서의 소속 사원들의 급여를 1000인상
-- 서브쿼리 사용
drop table emp01;
create table emp01 as select * from emp;

UPDATE emp01 
SET sal = sal+1000 
WHERE deptno = (
	SELECT deptno 
	FROM dept 
	WHERE loc = 'DALLAS'
);

select * from emp01;
COMMIT;

-- 7. emp01 table의 SMITH 사원의 부서 번호를 30으로, 직급은 MANAGER 수정
-- 두개 이상의 칼럼값 동시 수정
select deptno, job from emp01 where ename='SMITH';

UPDATE emp01 SET deptno = 30, job = 'MANAGER' WHERE ename = 'SMITH';

select deptno, job, ename from emp01 where ename='SMITH';
COMMIT;


-- *** delete ***
-- 8. 하나의 table의 모든 데이터 삭제
SELECT * FROM emp01;

DELETE FROM emp01;

SELECT * FROM emp01;
ROLLBACK;
SELECT * FROM emp01;


-- 9. 특정 row 삭제(where 조건식 기준)
DELETE FROM emp01 WHERE deptno=30;
SELECT * FROM emp01;

ROLLBACK;
-- 10. emp01 table에서 comm 존재 자체가 없는(null) 사원 모두 삭제
DELETE FROM emp01 WHERE comm IS null;
SELECT * FROM emp01;

ROLLBACK;
-- 11. emp01 table에서 comm이 null이 아닌 사원 모두 삭제
DELETE FROM emp01 WHERE comm IS NOT NULL;
SELECT * FROM emp01;

ROLLBACK;
-- 12. emp01 table에서 부서명이 RESEARCH 부서에 소속된 사원 삭제 
-- 서브쿼리 활용
DELETE FROM emp01
WHERE deptno = (
	SELECT deptno 
	FROM dept 
	WHERE dname = 'RESEARCH'
);

select * from emp01;

ROLLBACK;
-- 13. table 전체 내용 삭제
DELETE FROM emp01;
SELECT * FROM emp01;
ROLLBACK;
SELECT * FROM emp01;

truncate TABLE emp01;
SELECT * FROM emp01;