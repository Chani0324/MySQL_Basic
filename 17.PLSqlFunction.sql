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
*/

--1. emp table의 사번으로 사원 이름
-- (리턴 값, 이름의 타입이 리턴타입) 검색 로직 함수 






--2.? %type 사용해서 사원명으로 해당 사원의 직무(job) 반환하는 함수 
-- 함수명 : emp_job





select emp_job('SMITH') from dual;



--3.? 특별 보너스를 지급하기 위한 저장 함수
	-- 급여를 200% 인상해서 지급(sal*2)
-- 함수명 : cal_bonus
-- test sql문장
select empno, job, sal, cal_bonus(7369) from emp where empno=7369;





-- 4.? 부서 번호를 입력 받아 최고 급여액(max(sal))을 반환하는 함수
-- 사용자 정의 함수 구현시 oracle 자체 함수도 호출
-- 함수명 : s_max_sal


select s_max_sal(10) from dual;



--5. ? 부서 번호를 입력 받아 부서별 평균 급여를 구해주는 함수
-- 함수명 : avg_sal
-- 함수 내부에서 avg() 호출 가능





select distinct deptno, avg_sal(deptno) from emp;
select avg_sal(10) from dual;

--6. 존재하는 함수 삭제 명령어
drop function avg_sal;



-- 함수 내용 검색
desc user_source;
select text from user_source where type='FUNCTION';


-- 프로시저
--7. dept table은 pk(deptno) 설정되어 있음, dept에 새로운 데이터 저장 함수





--8. procedure 또는 function에 문제 발생시 show error로 메세지 출력하기
show error

