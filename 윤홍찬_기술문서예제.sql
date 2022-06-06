--5. 기술문서 보고 사용 가능한 예제로 재구성 해 보기
-- 사용 table : emp 
-- https://docs.oracle.com/cd/E11882_01/appdev.112/e25519/triggers.htm#LNPLS99955


-------------------------------------------------------------------------
-- 9-2와 9-3 예제 실행
-- 제출 : 5시 넘어서 구글 드라이브 오픈 예정
-- 제출파일명 : 이름_기술문서예제.sql / 팀 또는 개인으로.
-- 제출은 5시 48분까지.

-- 9.2
DROP TABLE emp01;
CREATE TABLE emp01 AS SELECT * FROM emp;
SELECT * FROM emp01;

-- create log table
DROP TABLE emp01_log;
CREATE TABLE emp01_log (
  empno     	int,
  ename			varchar(20),
  Log_date  	DATE,
  New_sal   	NUMERIC(7, 2),
  Action    	VARCHAR2(20));

-- create log trigger
CREATE OR REPLACE TRIGGER log_salary_increase
  AFTER UPDATE OF sal ON emp01
  FOR EACH ROW
BEGIN
  INSERT INTO emp01_log (empno, ename, Log_date, New_sal, Action)
  VALUES (:NEW.empno, :NEW.ename, SYSDATE, :NEW.sal, 'New Salary');
END;
/

-- update 로그 확인
UPDATE emp01 SET sal = 1400 WHERE ename = 'SMITH';
UPDATE emp01 SET sal = sal + 1000 WHERE deptno = 10;

SELECT * FROM emp01;
SELECT * FROM emp01_log;

ROLLBACK;

------------------------------------------------------------------
-- 9.3
-- trigger 생성.
CREATE OR REPLACE TRIGGER print_salary_changes
  BEFORE DELETE OR INSERT OR UPDATE ON emp01
  FOR EACH ROW
  WHEN (NEW.job <> 'MANAGER')  -- do not print information about MANAGER
DECLARE
  sal_diff  NUMBER;
BEGIN
  sal_diff  := :NEW.sal  - :OLD.sal;
  DBMS_OUTPUT.PUT(:NEW.ename || ': ');
  DBMS_OUTPUT.PUT('Old sal = ' || :OLD.sal || ', ');
  DBMS_OUTPUT.PUT('New sal = ' || :NEW.sal || ', ');
  DBMS_OUTPUT.PUT_LINE('Difference: ' || sal_diff);
END;

-- data 확인
SELECT ename, deptno, sal, job
FROM emp01
WHERE deptno IN (10, 20, 30)
ORDER BY 2, 1;

-- sal UPDATE 
UPDATE emp01
SET sal = sal * 1.05
WHERE deptno IN (10, 20);


-- data 확인
SELECT ename, job, sal FROM emp01 WHERE job = 'MANAGER' AND deptno IN (10, 20);

SELECT * FROM emp01;

ROLLBACK;
