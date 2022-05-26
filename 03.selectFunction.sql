-- 3.selectFunction.sql
/* db 구축
 * 1. 설치 + table 생성 및 데이터 저장
 * 2. aws - mysql : dbeaver
 * 3. 개인 시스템(local) - oracle 과 mysql : dbeaver, sqlplus(oracle), workbench(mysql)
 * 
 * 		mysql 하나를 workbench와 dbeaver
 * 			- workbench database 생성 -> table 생성 -> insert -> select
 * 			- dbeaver로 mysql 접속 connection에 새로고침 필수
 * 				- workbench에서 작업했던 내용이 동기화
 * 
 */

/*
   내장 함수 종류
      1. 단일행 함수 - 입력한 행수(row) 만큼 결과 반환
      2. 집계(다중행, 그룹) 함수 - 입력한 행수와 달리 결과값 하나만 반환 
*/

use playdata;

-- 단일행 함수 : 입력 데이터 수만큼 출력 데이터
/* Mysql Db 자체적인 지원 함수 다수 존재
1. 숫자 함수 MySQL Numeric Functions
2. 문자 함수
3. 날짜 함수 
**/
  
-- mysql은 oracle과 달리 from절이 생략 가능
-- 2+3의 결과인 5데이터값 보유한 table은 없음. 현로직은 연산 결과만 sql로 확인.
select 2+3;


-- *** [숫자함수] ***
-- 1. 절대값 구하는 함수 : abs()
select 3.5, abs(-3.5), abs(+3.5);



-- 2. 반올림 구하는 함수 : round(데이터 [, 반올림자릿수])
-- 반올림자릿수 : 소수점을 기준으로 양수는 소수점 이하 자리수 의미
         -- 음수인 경우 정수자릿수 의미
select round(5.6), 5.6;
select round(5.6, -1), 5.6;	-- round(숫자, -1) : 일의 자리에서 반올림
select round(5.62, 1), 5.6;	-- round(숫자, 1) : 소수점 둘쨰 자리에서 반올림



-- 3. 지정한 자리수 이하 버리는 함수 : truncate()
-- 반올림 미적용
-- truncate(데이터, 소수자릿수)
-- 자릿수 : +(소수점 이하), -(정수 의미)
-- 참고 : 존재하는 table의 데이터만 삭제시 방법 : delete[복원]/truncate[복원불가]
select truncate(56.66, -1), 5.6;

  
-- 4. 나누고 난 나머지 값 연산 함수 : mod()
-- 모듈러스 연산자, % 표기로 연산, 오라클에선 mod() 함수명 사용
select mod(5, 2);


-- 5. ? emp table에서 사번(empno)이 홀수인 사원의 이름(ename), 
-- 사번(empno) 검색 
select mod(empno, 2) from emp;
select ename, empno from emp where mod(empno, 2) = 1;



-- 6. 제곱수 구하는 함수 : power()
select power(4, 2);


-- *** [문자함수] ***
/* tip : 영어 대소문자 의미하는 단어들
대문자 : upper
소문자 : lower
철자 : case 
*/
-- 1. 대문자로 변화시키는 함수
-- upper() : 대문자[uppercase]
-- lower() : 소문자[lowercase]
-- emp사원의 이름들을 다 소문자로 변경해서 검색
select ename from emp;
select lower(ename) from emp; -- 원본 table의 데이터는 여전히 대문자 단 검색시 소문자로 변환해서 제공

-- binary() 사용해서 job 컬럼의 대소문자 구분해서 검색
select ename from emp where job=binary('manager');


-- 2. ? manager로 job 칼럼과 뜻이 일치되는 사원의 사원명 검색하기 
-- mysql은 데이터값의 대소문자 구분없이 검색 가능
-- 해결책 1 : binary()  대소문자 구분을 위한 함수
-- 해결책 2 : alter 명령어로 처리

select ename, job from emp;
-- 검색
select ename from emp where job='manager';


-- 3. 문자열 길이를 검색 : length();
select ename, length(ename)	from emp;

-- 4. 문자열 일부 추출 함수 : substr()
-- 서브스트링 : 하나의 문자열에서 일부 언어 발췌하는 로직의 표현
select length(1), length('가'), length('a');


-- substr(데이터, 시작위치, 추출할 개수)
-- 시작위치 : 1부터 시작
select substr('sdse', 2, 2);	-- 맨처음은 1부터 시작.




-- 5. ? 년도 구분없이 2월에 입사한 사원(mm = 02)이름, 입사일 검색
-- date 타입에도 substr() 함수 사용 가능
-- 문자열 index 시작 - 1 
select hiredate from emp;

-- 년도만 검색
select ename, substr(hiredate, 1, 4) from emp where substr(hiredate, 6, 2) = 02;

-- 월만 검색
select ename, substr(hiredate, 6, 2) from emp where substr(hiredate, 6, 2) = 02;

-- 일만 검색
select ename, substr(hiredate, 9, 2) from emp where substr(hiredate, 6, 2) = 02;




-- 7. 문자열 앞뒤의 잉여 여백 제거 함수 : trim()
/*length(trim(' abc ')) 실행 순서
   ' abc ' 문자열에 디비에 생성
   trim() 호출해서 잉여 여백제거
   trim() 결과값으로 length() 실행 */

select '  ab  ', length('  ab  '), length(trim('  ab  '));



-- *** [날짜 함수] ***
-- 1. ?어제, 오늘, 내일 날짜 검색 
-- 현재 시스템 날짜에 대한 정보 제공 함수
-- sysdate() & now(): 날짜 시분 초
-- curdate() : 날짜
select now();
select curdate();

-- sleep(int) : 적용한 초단위로 잠시 대기
select now(), sleep(2), now();	-- 하나의 sql문장에서 다수 호출시 첫번째 호출한 결과값 공유
select sysdate(), sleep(2), sysdate();	-- 적용 시점마다 날짜와 시간 호출
select curdate();

-- 2.?emp table에서 근무일수 계산하기, 사번과 근무일수 검색
select empno, curdate()-hiredate as 근무일수 from emp; -- 날짜 계산이 안되고 숫자크기로 인식해서 계산됨.
select empno, curdate()-20220524 from emp;	-- 날짜로 인식해서 계산 됨

select empno, curdate()-(substr(hiredate, 1, 4)*power(10, 4) + substr(hiredate, 6, 2)*power(10, 2) + substr(hiredate, 9, 2))
from emp;

select abs(datediff(curdate(), hiredate))+1 from emp;

-- ? 교육시작 경과일수
-- 순수 문자열을 날짜 형식으로 변환해서 검색
/* 
	yy/mm/dd 포멧으로 연산시에는 반드시 to_date() 라는 날짜 포멧으로
	변경하는 함수 필수 
	단순 숫자 형식으로 문자 데이터 연산시 정상 연산 
*/

-- 문자열을 날짜로 변경
select str_to_date("2022 1 3", "%Y %m %d"); 	
select str_to_date("20220103", "%Y %m %d");




-- 3. 특정 일수 및 개월수 더하는 함수 : ADDDATE()
-- 10일 이후 검색 
select adddate(curdate(), interval 10 day);

-- 15분 이후
select adddate(sysdate(), interval 15 minute);


-- 4. ? emp table에서 입사일 이후 3개월 지난 일자 검색
select hiredate, adddate(hiredate, interval 3 month) as 입사후3개월 from emp;

-- 5. 두 날짜 사이의 개월수 검색 : months_between()
-- 오늘(sysdate) 기준으로 2021-09-19
select timestampdiff(month, hiredate, curdate()) + 1 as 근무개월수 from emp;

-- 특정 기준일로 오늘은 며칠차?(기준일 포함할 경우 +1)
/* timestamp : 1970년 1월 1일 0시 0분 0초를 기준으로 경과된 시간이 계산되어지는 함수
 */
select timestampdiff(day, '2022-05-01', now()) + 1 as 경과일수; -- 기준일 미포함


-- 오늘을 기준으로 100일은?(오늘이 1일로 계산할 경우 기준일 포함)
select date_add(curdate(), interval 100 day) as 100일후;


-- emp 직원들의 입사일 기준으로 5개월 후의 일자는?
select hiredate, date_add(hiredate, interval 5 month) as 입사5개월후 from emp;

-- 근무 연차(입사하자마자 1년 차로 계산될 경우)
select timestampdiff(year, hiredate, curdate()) + 1 as 근무연차 from emp;

-- 1년 365일중 오늘은 몇일차?
select dayofyear(now());



-- 7. 주어진 날짜를 기준으로 해당 달의 가장 마지막 날짜 : last_day()
select last_day(now());



-- 8.? 2020년 2월의 마지막 날짜는?
select last_day('2020-02-01');



-- *** [형변환 함수] ***
-- Data type
-- DATETIME : 'YYYY-MM-DD HH:MM:SS'
-- DATE : 'YYYY-MM-DD'
-- TIME : 'HH:MM:SS'
-- CHAR : String varcher
-- SIGNED : Integer(64bit), 부호 사용 가능
-- UNSIGNED : Integer(64bit), 부호 사용 불가
-- BINARY : binary String


-- cast() - 특정 type으로 형변환

-- 숫자를 문자로 변환
select cast(1 as char(10));

-- 문자를 숫자로 변환
select cast('1' as signed);



-- [2] STR_TO_DATE() : 날짜로 변경 시키는 함수

SELECT STR_TO_DATE("August 10 2022", "%M %d %Y"); 
SELECT STR_TO_DATE("Aug 10 2022", "%M %d %Y"); 


-- 2. 문자열로 date타입 검색 가능[데이터값 표현이 유연함]
-- 1980년 12월 17일 입사한 직원명 검색
select ename from emp where hiredate='1980/12/17';
select ename from emp where hiredate='80/12/17';
select ename from emp where hiredate='1980-12-17';



-- *** 조건식 함수 ***

/*
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE result
END;
 */

-- 1. deptno 에 따른 출력 데이터
-- 10번 부서는 A로 검색/20번 부서는 B로 검색/그외 무로 검색
select deptno from emp;

select deptno,
	case
		when deptno=10 then 'A'
		when deptno=20 then 'B'
		else deptno
	end as level
from emp;



-- 2. emp table의 연봉(sal) 인상계산
-- job이 ANALYST 5%인상(sal*1.05), SALESMAN 은 10%(sal*1.1) 인상, 
-- MANAGER는 15%(sal*1.15), CLERK 20%(sal*1.2) 인상
select ename as '이름', job as '직무', sal*12 as '기존연봉', 
	case job
		when 'ANALYST' then sal*12*1.05
		when 'SALESMAN' then sal*12*1.1
		when 'MANAGER' then sal*12*1.15
		when 'MANAGER' then sal*12*1.2
		else sal*12
	end as '인상후연봉'
from emp;
	



