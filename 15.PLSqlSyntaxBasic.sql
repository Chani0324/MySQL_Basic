-- 15.PLSqlSyntaxBasic.sql
-- oracle db / SCOTT / TIGER
/* 
* 프로시저 & 함수
	- 재사용을 위한 기능 구현
	- sqlplus 우선 권장.

1. 프로시저
	- db 자체의 기능을 직접 구현하는 메카니즘
	- 호출 방법이 함수와 차이가 있음
		- 프로시저 개발시에 return 키워드가 없음.
		- 함수는 return 키워드로 명확하게 호출한 곳으로 값 제공.
		
		- oracle 함수
			1. 내장 함수 - max()/min() ...
				select max(sal) from emp;
				자바 관점에서 public int max(int v1, int v2){} : 두 값 비교 후 가장 큰 값 반환
				sql 관점에서 max(컬럼명) : from절에 있는 해당 table의 데이터 중에 해당 column의 가장 큰 값 반환.
					- java와 sql 함수의 공통점 : 반환값이 존재한다.
				
			2. 사용자 정의 함수
2. 함수
	- oracle 함수 호출하듯 사용자 정의 함수 호출 가능

--------------------------------------------------------
1. oracle db만의 프로그래밍 개발 방법
	1. 이름 없이 단순 개발
	2. 프로스저라는 타이틀로 개발 - 이름 부여(재사용)
	3. 함수라는 타이틀로 개발 - 이름 부여(재사용)
	
	java 관점에서 이름없는 문법
		- static {}
		- 개발자가 코드로 호출 불가능
		- 단 실행은 byte code(실행코드)가 메모리에 로딩시에 자동 단 한번 실행됨.
		

2. 장점
	- 단 한번의 개발 만으로 내장 함수처럼 만들어서 필요시 호출해서 실행 가능
	- 프로시저와 함수로 구현시 db내부에 pcode로 변환

3. test를 위한 필수 셋팅 
	- set serveroutput on 
	
4. 필수 암기 
	1. 할당(대입) 연산자  :=
	2. 선언, 시작, 끝
		declare ~ begin ~ end; /

5. 참고
	1. 사용 tool에 따른 차이점
		- dbeaver인 경우 / 표기가 있을 경우 문법에러 발생
			- 기본은 / 로 마무리 필수
			- sqlplus의 동작이 우선
			
6. 문법
	declare
		변수
	begin
		로직
	end;
	/
	
*/

--1. 실행 결과 확인을 위한 필수 설정 명령어
-- sqlplus에서는 필수. 단 dbeaver에선 불필요한 명령어
SET serveroutput ON;

--2. 연산을 통한 간단한 문법 습득
declare
	no integer;	-- no라는 변수(컬럼)는 정수 타입으로 설정.
begin
	no := 10;	-- 변수에 값 대입
	dbms_output.put_line('결과 ' || no);	-- 출력, || 결합연산자

	no := 10 / 5;
	dbms_output.put_line('결과 ' || no);
end;

/

-- 이름을 대입해서 출력
DECLARE
	name varchar(10);
BEGIN
	name := '카리나';
	dbms_output.put_line(name || 'playdata');
END;

/

--3. 연산을 통한 간단한 문법 습득 + 예외 처리 문장
-- 혹여 문제가 생겨도 프로그램 종료가 아니라 유연하게 실행 유지
-- 예외처리시 실행 유지
-- 예외 미처리시 실행 강제 종료

/* java에서의 예외 처리
 * 1. 메소드 내부에서 발생시 해당 메소드 호출한 곳으로 예외 처리 위임
 *	- 메소드 선운구에 throws 예외
 * 2. 예외 발생 로직상에서 직접 처리
 * 	- try{
 * 		구현 로직
 * 		}catch(예외 타입 변수) {
 * 			발생시 처리하는 로직
 * 			변수.printStackTrace();
 * 		}
 */

-- step01 : SQL Error [1476] [22012]: ORA-01476: divisor is equal to zero ORA-06512: at line 5
declare
	no integer;	
begin
	no := 10 / 0;	-- 문제 발생시 강제 종료
	dbms_output.put_line('결과 ' || no);
end;

/

-- step02 - 예외 처리 적용
DECLARE
	no integer := 0;	
begin
	no := 10 / 0;	-- 문제 발생 시 예외 처리 로직에서 처리 후에 실행 유지.
	-- 예외처리
	EXCEPTION 
		WHEN OTHERS THEN	--- : 발생된 모든 예외 의미
			dbms_output.put_line('연산 오류');

	dbms_output.put_line('결과 ' || no);
end;

/




--4. 중첩 block & 변수 선언 위치에 따른 구분
-- step01 - 전역(java의 멤버), 로컬(java의 로컬) 변수 선언 및 활용

DECLARE 
	v_g varchar2(10) := 'global variable';
BEGIN
	DECLARE -- 변수 선언시에는 DECLARE 필수.
		v_1 varchar2(10) := 'local variavle';	
	BEGIN 
		dbms_output.put_line(1 || v_g);
		dbms_output.put_line(2 || v_1);
	END;
	dbms_output.put_line(3 || v_g);
	dbms_output.put_line(4 || v_1);	-- 오류 발생. local변수 v_1은 해당 declare끝나면 사라짐.
END;

/

-- 5. emp01 table의 컬럼 타입을 그대로 사용하고 싶다면?
	-- %type : db의 특정 컬럼의 타입 의미
	-- emp01의 emp01.empno%type 표현은 number(4) 의미
drop table emp01;
create table emp01 as select * from emp;
SELECT * FROM emp01;

-- 사번(empno, 4자리 정수값)으로 사원(문자열) 검색하는 로직의 프로시저
DECLARE
	v_empno emp01.empno%TYPE := 7369;
	v_ename emp01.ename%TYPE;
BEGIN
	SELECT ename
		INTO v_ename	-- SELECT 절에 검색된 COLUMN 데이터를 프로시저 변수에 대입
	FROM emp01
	WHERE empno=v_empno;
	dbms_output.put_line(v_ename);
END;

/


--7. 이미 존재하는 table의 record의 모든 컬럼 타입 활용 키워드 : %rowtype
/* 7369 사번으로 해당 사원의 모든 정보를 검색해서 사번, 이름만 착출해서 출력 */
DECLARE 
	v_rows emp01%rowtype;	-- 총 8개의 변수가 선언됨.
BEGIN
	SELECT * INTO v_rows FROM emp01 WHERE empno=7369;
	dbms_output.put_line(v_rows.empno || ' ' || v_rows.ename);
END;

/




--8. ???
-- emp05라는 table을 데이터 없이 emp table로 부터 생성하기
-- %rowtype을 사용하셔서 emp의 사번이 7369인 사원 정보 검색해서 
-- emp05 table에 insert
-- 힌트 : begin 부분엔 다수의 sql문장 작성 가능, into 절
drop table emp05;
create table emp05 as select * from emp where 1=0;

DECLARE
	v_rows emp05%rowtype;
BEGIN
	SELECT * INTO v_rows FROM emp WHERE empno=7369;
	INSERT INTO emp05 VALUES v_rows;
END;

/

SELECT * FROM emp05;


--8. 조건식
/*  1. 단일 조건식
	if(조건) then
		
	end if;
	
   2. 다중 조건
	if(조건1) then
		조건1이 true인 경우 실행되는 블록 
	elsif(조건2) then
		조건2가 true인 경우 실행되는 블록
	end if; 
*/
-- 사원의 연봉을 계산하는 procedure 개발[comm이 null인 직원들은 0으로 치환]


select empno, ename, sal, comm 
from emp 
where ename='SMITH';


DECLARE
	v_emp emp%rowtype;
	salary number(7, 2);
BEGIN
	SELECT empno, ename, sal, comm 
		INTO v_emp.empno, v_emp.ename, v_emp.sal, v_emp.comm
	FROM emp WHERE ename = 'SMITH';

	IF (v_emp.comm IS null) THEN
		v_emp.comm := 0;
	END IF;
	
	salary := v_emp.sal*12 + v_emp.comm;
	dbms_output.put_line(salary);
END;

/



-- 9.??? 실행시 가변적인 데이터 적용해 보기
-- 실행시마다 가변적인 데이터(동적 데이터) 반영하는 문법 : 변수 선언시 "&변수명"

-- cmd의 sqlplus에서는 정상 실행됨. dbeaver에서는 오류 발생.
-- step01
DECLARE
	-- 실행시마다 입력 데이터 대입을 위한 문법. dbeaver에서는 &대신 :를 사용.
	v_inputename emp.ename%TYPE := &v;
	v_emp emp%rowtype;
	salary number(7, 2);
BEGIN
	SELECT empno, ename, sal, comm 
		INTO v_emp.empno, v_emp.ename, v_emp.sal, v_emp.comm
	FROM emp WHERE ename = v_inputename;

	IF (v_emp.comm IS null) THEN
		v_emp.comm := 0;
	END IF;
	
	salary := v_emp.sal*12 + v_emp.comm;
	dbms_output.put_line(salary);
END;

/

-- step02
-- emp table의 deptno=10 : ACCOUNT 출력, 
-- deptno=20 이라면 RESEARCH 출력, 10번과 20번이 아닌 경우엔 NONE 출력
-- test data는 emp table의 각 사원의 사번(empno)
-- sqlplus 창에서 결과 확인하기
-- 제약조건 : emp table에서만 사용 즉 다중 조건식으로 출력시에 dbms_output.put_line('ACCOUNT');
-- := 할당연산자 / = 동등비교 연산자

SELECT * FROM emp;

DECLARE
	ck_inputempno emp.empno%TYPE := :v;
	v_deptno emp.deptno%TYPE;
BEGIN
	SELECT deptno INTO v_deptno
	FROM emp WHERE empno = ck_inputempno;
	
	IF (v_deptno = 10) THEN
		dbms_output.put_line('ACCOUNT');
	ELSIF (v_deptno = 20) THEN
		dbms_output.put_line('RESEARCH');
	ELSE
		dbms_output.put_line('None');
	END IF;
END;

/


--11. 반복문
/* 
1. 기본
	loop 
		ps/sql 문장들 + 조건에 사용될 업데이트
		exit 조건;
	end loop;

2. while 기본문법
	 while 조건식 loop
		plsql 문장;
	 end loop;

3. for 기본 문법
	for 변수 in [reverse] start ..end loop
		plsql문장
	end loop;
*/
-- loop 
declare
	num number(2) := 0;
begin
	loop
		dbms_output.put_line(num);
		num := num+1;
		exit when num > 5;
	end loop;
end;
/

-- while
DECLARE 
	num number(2) := 0;
BEGIN
	WHILE num <= 5 LOOP
		dbms_output.put_line(num);
		num := num+1;
	end LOOP;
END;

/

-- for 
-- 오름차순
DECLARE
BEGIN
	FOR num IN 1..5 LOOP
		dbms_output.put_line(num);
	end LOOP;
END;

-- 내림차순
DECLARE
BEGIN
	FOR num IN reverse 1..5 LOOP
		dbms_output.put_line(num);
	end LOOP;
END;


--12.? emp table 직원들의 사번을 입력받아서(동적데이터) 해당하는 
-- 사원의 이름 음절 수 만큼 * 표 찍기 
-- length()
DECLARE
	v_inputempno emp.empno%TYPE := :v;
	len_ename int;
BEGIN
	SELECT LENGTH(ename) INTO len_ename FROM emp WHERE empno = v_inputempno;
--	dbms_output.put_line('*'*len_ename); -- 문자와 숫자 곱하는거 안됨.
	FOR i IN 1..len_ename LOOP
		dbms_output.put('*');
	end LOOP;
	dbms_output.new_line;
END;


DECLARE
	v_inputempno emp.empno%TYPE := :v;
	len_ename int;
	v_star varchar(10) := '';
BEGIN
	SELECT LENGTH(ename) INTO len_ename FROM emp WHERE empno = v_inputempno;
	FOR i IN 1..len_ename LOOP
		v_star := v_star || '*';
	END LOOP;
	dbms_output.put_line(v_star);
END;



