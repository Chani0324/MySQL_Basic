
--17.PLSqlFunction.sql
/*
1. 저장 함수(function)
	- 오라클 사용자 정의 함수 
	- 오라클 함수 종류
		- 지원함수(count(??){ }, avg()...) + 사용자 정의 함수
2. 주의사항
	- 절대 기존 함수명들과 중복 불가
3. 프로시저와 다른 문법
	- 리턴 타입 선언 + 리턴 값
	
4. 문법
create [or replace] function 함수명()
return 반환타입 	-- 여기서는 크기 지정 x
is
	변수		-- 여기서는 크기 지정 o
begin
	로직
	return 값;
end;
/
	
프로시저는 CALL 로 호출 해야하고, 함수는 SELECT로 호출해야 한다.
	
*/

--1. emp table의 사번으로 사원 이름
-- (리턴 값, 이름의 타입이 리턴타입) 검색 로직 함수 
-- 사번 받고 사원명 반환 -> 함수 호출로 이름값 검색
CREATE FUNCTION user_fun(num number)
RETURN varchar2
IS
	v_ename emp.ename%TYPE;
BEGIN
	SELECT ename
		INTO v_ename
	FROM emp 
	WHERE empno = num;
	RETURN v_ename;
END;

/


-- 주의사항 : 함수 내부에 검색 table명이 명시되어 있을 경우 함수호출하는 from절에는
-- dual이라는 오라클만의 잉여 table을 넣어줌.
-- oracle에서는 from 생략 불가이기 때문에 문법시에 자주 사용
SELECT user_fun(7369) FROM dual;

DROP FUNCTION user_fun;

--2.? %type 사용해서 사원명으로 해당 사원의 직무(job) 반환하는 함수 
-- 함수명 : emp_job
CREATE OR REPLACE FUNCTION emp_job(v_ename emp.ename%TYPE)
RETURN emp.ename%TYPE
IS
	v_job emp.job%TYPE
BEGIN
	SELECT job
		INTO v_job
	FROM emp 
	WHERE ename = v_ename;
	RETURN v_job;
END;


--DROP function emp_job;
select emp_job('SMITH') from dual;

---------------------------------

CREATE OR REPLACE FUNCTION star_ename(v_empno emp.empno%TYPE)
RETURN varchar2 -- RETURN 타입 명시시에는 타입의 크기 명시 하면 안됨...
IS
	len_ename int
	v_star varchar2(10) := ''	-- 변수 선언시에는 type의 크기 선언해야함...
BEGIN
	SELECT LENGTH(ename) INTO len_ename FROM emp WHERE empno = v_empno;
	FOR i IN 1..len_ename LOOP
		v_star := v_star || '*';
	END LOOP;
	RETURN v_star;
END;

SELECT star_ename(7369) FROM dual;



--3.? 특별 보너스를 지급하기 위한 저장 함수
	-- 급여를 200% 인상해서 지급(sal*2)
-- 함수명 : cal_bonus
-- test sql문장
CREATE OR REPLACE FUNCTION cal_bonus(v_empno emp.empno%TYPE)
RETURN emp.sal%TYPE
IS 
	v_sal emp.sal%TYPE
BEGIN 
	SELECT sal*2
		INTO v_sal
	FROM emp 
	WHERE empno = v_empno;
	RETURN v_sal;
END;


select empno, job, sal, cal_bonus(7369) from emp where empno=7369;





-- 4.? 부서 번호를 입력 받아 최고 급여액(max(sal))을 반환하는 함수
-- 사용자 정의 함수 구현시 oracle 자체 함수도 호출
-- 함수명 : s_max_sal
CREATE OR REPLACE FUNCTION s_max_sal(s_deptno emp.deptno%TYPE)
RETURN emp.sal%TYPE 
IS 
	max_sal emp.sal%TYPE;
BEGIN 
	SELECT max(sal) INTO max_sal FROM emp WHERE deptno = s_deptno;
	RETURN max_sal;
END;
/


select s_max_sal(10) from dual;


--5. ? 부서 번호를 입력 받아 부서별 평균 급여를 구해주는 함수
-- 함수명 : avg_sal
-- 함수 내부에서 avg() 호출 가능
CREATE OR REPLACE FUNCTION avg_sal(v_deptno emp.deptno%TYPE)
RETURN emp.sal%TYPE
IS 
	v_sal emp.sal%TYPE;
BEGIN 
	SELECT avg(sal) INTO v_sal FROM emp WHERE deptno = v_deptno;
	RETURN v_sal;
END;
/


select distinct deptno, avg_sal(deptno) from emp;	-- 함수에 특정 상수가 아니라 emp table의 column명을 넣으면 col전체 계산도 가능.
select deptno, avg_sal(deptno) from emp;	-- 함수에 특정 상수가 아니라 emp table의 column명을 넣으면 col전체 계산도 가능.
select avg_sal(10) from dual;

SELECT avg(sal)	FROM emp GROUP BY deptno;

--6. 존재하는 함수 삭제 명령어
drop function avg_sal;



-- 함수 내용 검색
desc user_source;
select text from user_source where type='FUNCTION';

--8. procedure 또는 function에 문제 발생시 show error로 메세지 출력하기
show error

-- 참고 : dbms_output.put_line()의 실행결과 확인 시 : >set serveroutput on