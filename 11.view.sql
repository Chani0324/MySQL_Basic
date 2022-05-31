-- mysql SCOTT/TIGER

-- 11.view.sql
/*
*
1. view 에 대한 학습
	- 물리적으로는 미 존재, 단 논리적으로 존재
	- 하나 이상의 테이블을 조회한 결과 집합의 독립적인 데이터베이스 객체
	- 논리적(존재하는 table들에 종속적인 가상 table)

2. 개념
	- 보안을 고려해야 하는 table의 특정 컬럼값 은닉
	또는 여러개의 table의 조인된 데이터를 다수 활용을 해야 할 경우
	특정 컬럼 은닉, 다수 table 조인된 결과의 새로운 테이블 자체를 
	가상으로 db내에 생성시킬수 있는 기법 

3. 문법
	- create와 drop : create view/drop view
	- crud는 table과 동일
	
	CREATE VIEW view_name AS
	SELECT column1, column2, ...
	FROM table_name
	WHERE condition;
*/

use playdata;

-- 1. emp table과 dept table 기반으로 empno, ename, deptno, dname으로 view 생성
DROP TABLE IF EXISTS emp_dept;

CREATE TABLE emp_dept AS SELECT empno, ename, e.deptno, dname FROM emp e, dept d;

DESC emp_dept;

-- view 생성
CREATE view emp_dept_v AS SELECT empno, ename, e.deptno, dname FROM emp e, dept d;

DESC emp_dept_v;

select * from emp_dept;

-- dept table의 sales라는 데이터를 영업으로 변경 후 view 검색.
-- view는 dept table의 가변적인 상황을 그대로 인지하여 변경된 내용으로 검색 완료.
UPDATE dept SET dname = '영업' WHERE dname = 'SALES';
SELECT * FROM dept;	-- 영업으로 검색
SELECT * FROM emp_dept_v;	-- 영업으로 검색


-- 2. view 삭제
DROP VIEW emp_dept_v;

SELECT * FROM dept;

UPDATE dept SET dname = 'SALES' WHERE dname = '영업';
SELECT * FROM dept;





	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


