/* 주의 사항
 * 1. 단일 line 주석 작성시 -- 와 내용 사이에 blank 필수
 * 
 * 2. DBeaver 접속 문제 발생시 해결책
 * 	userSSL false / allowPublicKeyRetrieval true 속성 추가 
 * 	https://earth-95.tistory.com/52
 * 	
 */

-- mysql
-- id/pw - admin/playdata

-- database에 접속
use playdata;


-- 1. 해당 계정이 사용 가능한 모든 table 검색
show tables;

-- 2. emp table의 모든 내용(모든 사원(row), 속성(컬럼)) 검색
SELECT * FROM emp;

-- 3. emp의 구조 검색
desc emp;

-- 4. emp의 사번(empno)만 검색
SELECT empno from emp;
SELECT empno as 사번 from emp;


-- 5. emp의 사번(empno), 이름(ename)만 검색
SELECT empno, ename from emp;

-- 6. emp의 사번(empno), 이름(ename)만 검색(별칭 적용)
SELECT empno as 사번, ename as 이름 from emp;

-- 7. 부서 번호(deptno) 검색
SELECT deptno from emp;

-- 8. 중복 제거된 부서 번호 검색
-- DISTINCT : 중복 제거 명령어
SELECT DISTINCT deptno from emp;

-- 9. 8 + 오름차순 정렬(order by)해서 검색
-- 오름 차순 : asc  / 내림차순 : desc
select distinct deptno from emp order by deptno desc;

select distinct deptno from emp order by deptno asc;


-- 10. ? 사번(empno)과 이름(ename) 검색 단 사번은 내림차순(order by desc) 정렬
select empno, ename from emp order by empno desc;

-- 11. ? dept table의 deptno 값만 검색 단 오름차순(asc)으로 검색
select deptno from dept order by deptno asc;

-- 12. ? 입사일(hiredate) 검색, 
-- 입사일이 오래된 직원부터 검색되게 해 주세요
-- 고려사항 : date 타입도 정렬(order by) 가능
select hiredate from emp order by hiredate asc;

-- 13. ?모든 사원의 이름과 월 급여(sal)와 연봉 검색
select ename, sal, sal*12 + comm as 연봉 from emp;

-- 14. ?모든 사원의 이름과 월급여(sal)와 연봉(sal*12) 검색
-- 모든 db는 지원하는 내장 함수 
-- null -> 숫자값으로 대체하는 함수 : IFNULL(null보유컬럼명, 대체값)
select ename, sal, sal*12 + ifnull(comm, 0)	as 연봉 from emp;


-- 모든 사원의 이름과 월급여(sal)와 연봉(sal*12)+comm 검색
select ename, sal, sal*12 + ifnull(comm, 0)	as 연봉 from emp;


-- *** 조건식 ***
-- 15. comm이 null인 사원들의 이름과 comm만 검색
-- where 절 : 조건식 의미
select ename, comm from emp where comm is null;

-- 16. comm이 null이 아닌 사원들의 이름과 comm만 검색
-- where 절 : 조건식 의미
-- 아니다 라는 부정 연산자 : not 
select ename, comm from emp where comm is not null;

-- 17. ? 사원명이 스미스인 사원의 이름과 사번만 검색
-- sql상에서 문자열 데이터 표현 : '' ("" 사용 불가)
select ename, empno from emp where ename='SMITH'; -- null값 조건은 is로 표현해야됨.(문법)



-- 18. 부서번호가 10번 부서의 직원들 이름, 사번, 부서번호 검색
-- 단, 사번은 내림차순 검색
select ename, empno, deptno from emp where deptno=10 order by empno asc;


-- 19. ? 기본 syntax를 기반으로 
-- emp  table 사용하면서 문제 만들기
-- 입사 날짜 1985년 이후인 사원 이름 검색
select ename, hiredate from emp where date_format(hiredate, '%Y-%m-&d') >= date_format('1985-01-01', '%Y-%m-&d');



-- 20. 급여가 900이상인 사원들 이름, 사번, 급여 검색 
select ename as 이름, empno as 사번, sal as 급여 from emp where sal>=900;


/*
 * mysql은 대소문자 구별 안하는게 defual
 * 	해결방법 1 : 데이터 생성 시 alter로 제한을 둠
 * 	해결방법 2 : 대소문자 구분 함수 사용
 */
-- 21. deptno 10, job 은 manager(대문자로) 이름, 사번, deptno, job 검색
-- 대소문자 구분 검색시 binary() 함수 사용
select ename, empno, deptno, job from emp where deptno=10 and job=binary('manager');

-- 소문자 manager는 미존재 따라서 검색 안됨
select ename, empno, deptno, job from emp where deptno=10 and job=binary('MANAGER');

-- 대문자 또는 소문자로 변경하는 함수 사용
-- 대문자 upper() / 소문자 lower()
select ename, empno, deptno, job from emp where deptno=20 and ename=upper('smith');
select ename, empno, deptno, job from emp where deptno=20 and lower(ename)='smith';




-- 23. sal이 2000이하(sal <= 2000) 이거나(or) 3000이상(sal >= 3000) 
-- 사원명, 급여 검색
select ename, sal from emp where sal <= 2000 or sal >= 3000;



-- 24.  comm이 300 or 500 or 1400인
select ename, comm from emp where comm=300 or comm=500 or comm=1400;

-- in 연산식 사용해서 좀더 개선된 코드
select ename, comm from emp where comm in (300, 500, 1400);

-- 25. ?  comm이 300 or 500 or 1400이 아닌 사원명 검색
select ename, comm from emp where ifnull(comm, 0) not in (300, 500 ,1400);




-- 26. 81/09/28 날 입사한 사원 이름.사번 검색
select ename, empno from emp where hiredate = '1981-09-28';
select ename, empno from emp where date_format(hiredate, '%Y-%m-%d') = date_format('1981-09-28', '%Y-%m-%d');



-- 27. 날짜 타입의 범위를 기준으로 검색
-- 범위비교시 연산자 : between~and
select ename, empno, hiredate from emp where hiredate between '1981-09-28' and '1987-04-19' order by hiredate asc;




-- 28. 검색시 포함된 모든 데이터 검색하는 기술
-- like 연산자 사용
-- % : 철자 개수 무관하게 검색 / _ : 철자 개수 의미
select ename from emp;


-- 29. 두번째 음절의 단어가 M인 모든 사원명 검색 
select ename from emp where ename like '_M%';

-- 30. 단어가 M을 포함한 모든 사원명 검색 
select ename from emp where ename like '%M%';


-- 리뷰 후에 2문제 직접 만들고 풀이도 작성하기
-- 31. 81년도에 입사한 사원 중에 급여가 1400이상이고 직무가 manager 또는 clerk인 사원 이름, 번호
select ename as 사원이름, empno as 사원번호
from emp 
where hiredate between '1981-01-01' and '1981-12-31' and sal >= 1400 and job in (upper('manager'), upper('clerk'));

-- 32. 연봉이 30,000이 넘는 사원이름, 사원번호, comm, 연봉 검색. 단 comm은 숫자로만 표현하고 연봉 내림차순으로 정렬
select ename 사원이름, empno 사원번호, ifnull(comm, 0) 상여금, sal*12 + ifnull(comm, 0) 연봉
from emp 
where sal*12 + ifnull(comm, 0) >= 30000 order by 연봉 desc;
