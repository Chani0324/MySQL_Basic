--18.PLSqlTrigger.sql
/*
1. 트리거란?
	- PLSQL 블록으로 오라클에서 특정 이벤트 발생시 연관된 다른 작업이 자동 수행되게 하는 메카니즘
	
	ex) 입고 table에 상품입고시 재고 table에 자동으로 재고 증가
		어떤 설계로 개발을 할 것인가?
			1. database table 구조는 어떻게 구성할 것인가
			2. db를 사용하는 언어는 back end(java, python, c#) / front end(html/css/javascript)
			
			참고 : db자체의 trigger 학습 후에는 table에 이벤트로 적용
				장점 : back end의 java 코드가 간결해지고 고민거리가 줄어듦
				table 설계
					새로운 제품이 입고 - insert
					기존 제품 입고 - update
					..
					제품 table과 재고 table 분리된 구조에서의 설계 -> 자동화
	
	
2. 트리거를 사용하는 이유
	- 가상 열 값 자동 생성
	- 로그 이벤트
	- 테이블 액세스에 대한 통계 수집
	- 뷰에 대해 DML 문이 실행될 때 테이블 데이터 수정
	- 자식 테이블과 부모 테이블이 분산 데이터베이스의 서로 다른 노드에 있을 때 참조 무결성 적용
	- 데이터베이스 이벤트, 사용자 이벤트 및 SQL 문에 대한 정보를 구독 애플리케이션에 게시
	- 정규 업무 시간 이후 테이블에 대한 DML 작업 방지
	- 무효 거래 방지
	- 제약 조건으로 정의할 수 없는 복잡한 비즈니스 또는 참조 무결성 규칙을 적용 등

3. trigger 구조[문법]
	1. 구성 
	  실행되는 시점(timing) 
	  실행시키는 사건(event) 
	  trigger가 영향받는 table/view../trigger 
	  body

	2. 문법
		create [or replace] tirgger trigger_name
		timing
			event 1[ or event2 or ...]
		on 
			table_name or view_name
		[referencing old or new]
		[for each row]
			trigger body
			
	3. 부여설명
		- timing : trigger가 실행되는 시점 지정을 event 발생 전과 후 의미
				- before
				- after

4. trigger 유형
	- DML trigger
		1. 문장 trigger	
			- 컬럼의 각 데이터 행 제어 불가
			- 즉 컬럼의 데이터 값이 무엇이냐가 아니라 컬럼 자체에 변화가 일어남을 감지하여 실행

		2. 행 trigger
			- 특정 데이터로 인해 영향받는 행에 한해서만 trigger실행
			- for each row
			- 예 : 기존 row값을 새로운 table의 row로 이관 작업시에도 설정
				- :OLD / :NEW 문구 사용
			- 데이터 구조
				1. OLD : trigger가 처리한 레코드의 원래 값을 저장
				2. NEW : 새값 포함  */

--1. trigger 생성 변경 삭제 권한 부여(admin 계정에서만 가능)
connect system/manager
grant create trigger to SCOTT;
grant alter any trigger to SCOTT;
grant drop any trigger to SCOTT;

conn SCOTT/TIGER

--1. 정해진 시간에만 입력한 경우만 입력 허용, 그 외 오류 발생
drop table order_table;
create table order_table(
	no number,
	ord_code varchar2(10),
	ord_date date
);

SELECT * FROM order_table;
-- 문장 레벨 trigger
/* 1. 오전 10~12시 저장시 insert 허용 
	- 10:00  12:00
	- 시간을 HH:MI
	- sysdate -> 가공(to_char(sysdate, 'HH24:MI')) -> 10:00
	2. 해당 시간이 아닌 다른 시간에 insert 시도시에는 예외 발생
		- RAISE_APPLICATION_ERR(고유번호, '메세지);
		
*/

-- 현 시스템 날짜 검색
select sysdate from dual;  
 
-- 24시간 기준으로 시분 검색
/*
 * 24시간 기준으로 기분 검색
 * to_char() : 문자열로 변환
 * 현 시스템의 년월일시분초를 24시간 기준의 시분으로 변환해서 문자열로 반환하는 기능.
 * 
 * 시분초 표현시
 * 	- 12시간 기준 : HH or HH12
 * 	- 24시간 기준 : HH24
 */
select to_char(sysdate, 'HH24:MI') from dual;  


drop trigger timeorder;


CREATE OR REPLACE TRIGGER timeorder
BEFORE INSERT 
ON order_table
BEGIN 
	IF (to_char(sysdate, 'HH24:MI') NOT BETWEEN '14:00' AND '18:00') THEN
	RAISE_APPLICATION_ERROR(-20100, '주문 시간이 아닙니다.');
	END IF;
END;
/

-- test 문장
-- 허용된 주문 시간이 아닌 경우에 발생되는 예외 : SQL Error [20100] [72000]: ORA-20100
insert into order_table values(1, 'c001', sysdate);
select * from order_table;

drop trigger timeorder;


--2. ord_code 컬럼에 'c001' 제품 번호가 입력될 경우를 제외한 다른 데이터 입력시 에러 발생하는 trigger 
-- 행 레벨 trigger : for each row
-- 새로 저장하는 데이터를 의미하는 표기 : NEW
-- 이미 존재하는 데이터를 의미하는 표기 : OLD


drop trigger datafilterorder;

CREATE OR REPLACE TRIGGER datalfilterorder
BEFORE INSERT 
ON order_table
FOR EACH ROW	-- INSERT 되는 모든 row별 검증 수행 요청하는 설정
BEGIN 
	IF (:NEW.ord_code) NOT IN ('c001') THEN 
		RAISE_APPLICATION_ERROR(-20100, 'c001이 아니여서 불가능합니다.');
	END IF;
END;


-- test 문장
insert into order_table values(1, 'c001', sysdate);
insert into order_table values(2, 'c002', sysdate);
select * from order_table;


--3. 기존 table의 데이터가 업데이트 될 경우 다른 백업 table로 기존 데이터를 이관시키는 로직
-- order_table/update/다른 table인 backup_order로 이관
-- update 전 데이터를 백업
/* 성공
 * order_table : update / update 문장 실행
 * backup_order : ?
 */
--원본 table : order_table
--백업 table : backup_order
drop table backup_order;
create table backup_order(
	no number,
	ord_code varchar2(10),
	ord_date date
);
select * from order_table;

insert into order_table values(1, 'c001', sysdate);
insert into order_table values(2, 'c001', sysdate);
insert into order_table values(3, 'c001', sysdate);


CREATE OR REPLACE TRIGGER backtrigger
BEFORE UPDATE 
ON order_table
FOR EACH ROW 
BEGIN 
	INSERT INTO backup_order VALUES (:OLD.NO, :OLD.ord_code, :OLD.ord_date);
END;


drop trigger backtrigger;


-- test 문장
select * from backup_order;
select * from order_table;
update order_table set ord_code='c002' where no=1;
select * from backup_order;
select * from order_table;


--4. 기존 table의 데이터가 delete 될때 기존  내용을 backup table로 이동
--원본 table : order_table2
--백업 table : backup_order2
drop table backup_order2;
drop table order_table2;

create table order_table2(
	no number,
	ord_code varchar2(10)
);

create table backup_order2(
	no number,
	ord_code varchar2(10),
	time date
);

insert into order_table2 values(1, 'c001');
select * from order_table2;
select * from backup_order2;


CREATE OR REPLACE TRIGGER delete_backup
AFTER DELETE 	-- BEFORE AFTER 뭘 사용할지는 고민. 구글 검색해보기
ON order_table2
FOR EACH ROW 
BEGIN 
	INSERT INTO backup_order2 VALUES (:OLD.NO, :OLD.ord_code, sysdate);
END;



-- test 문장
select * from order_table2;
select * from backup_order2;
delete from order_table2 where no=1;
select * from order_table2;
select * from backup_order2;




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
