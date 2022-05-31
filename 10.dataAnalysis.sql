-- mysql SCOTT/TIGER
/*
1. table의 각 컬럼들 분석
CREATE TABLE titanic_raw
(	passengerid  INT, 			- 승객 id pk  
	survived     INT,			- 생존 여부(0:사망, 1:생존)
	pclass       INT,			- 객실등급 (1, 2, 3)
	name         VARCHAR(100),	- 이름
	gender       VARCHAR(50),	- 성별 (male:남성, female:여성)
	age          DOUBLE,		- 나이
	sibsp        INT,			- 동반한 형제 및 배우자 수
	parch        INT,			- 동반한 부모 및 자녀 수
	ticket       VARCHAR(80),	- 티켓번호
	fare         DOUBLE,		- 요금
	cabin        VARCHAR(50) ,	- 객실 번호
	embarked     VARCHAR(20),	- 탑승 항구(C:프랑스 항구, Q:아일랜드 항구, S:영국 항구)
	PRIMARY KEY (passengerid)
);

2. table의 데이터를 정제
	- survived : 0(사망), 1(생존)
	- embarked : 탑승 항구(C:프랑스 항구, Q:아일랜드 항구, S:영국 항구)
	
3. row 데이터를 정제해서 table을 생성
	방법1 : 기존 table 삭제 + sql파일 오픈해서 모두 변경등의 수작업
			- 비추
	방법2 : 기존 table 삭제 + raw table의 데이터들을 기반으로 새로운 정제된 table 만들기
			- 권장
	...
*/

use playdata;

-- titanic 원데이터 검색
select * from titanic_raw;
 

-- case when then 문장 학습을 위한 table 
drop table if exists emp01;

create table emp01 as select sal, comm, 
	case job
		when 'ANALYST' then sal*1.05
		when 'SALESMAN' then sal*1.1
		when 'MANAGER' then sal*1.15
		when 'CLERK' then sal*1.2
		else sal
	end as '연봉인상'
from emp;

-- sal, comm, 연봉인상 컬럼을 보유한 새로운 table 생성 
select * from emp01;


-- raw 정제해서 새로운 table 생성

-- 1차 연습 : 생존 컬럼만으로 사망, 생존 데이터로 변환 가능한 여부만 확인
-- titanic_raw 의 survived 컬럼값으 0이면 사망, 1이면 생존으로 검색
select survived, 
	case survived
		when 0 then '사망'
		else '생존'
	end as 정제결과 
from titanic_raw;


-- 2차 연습 : 생존 데이터 정제 성공후 titanic table 생성
-- 일반 컬럼과 case문으로 새로운 table 생성 여부 확인 : 가능
create table titanic as select passengerid, 
	case survived
		when 0 then '사망'
		else '생존'
	end as survived 
from titanic_raw;

select * from titanic;


-- 3차 연습 : 항구 정보를 명확하게 정제해서 적용
-- embarked : 탑승 항구(C:프랑스 항구, Q:아일랜드 항구, S:영국 항구) 적용 titanic table 생성
-- 컬럼 : passengerid, survived, embarked
drop table if exists titanic;

-- 3차 -1 연습 : 항구 정보 정제해서 단순 검색
select passengerid, 
	case embarked
		when 'C' then '프랑스 항구'
		when 'Q' then '아일랜드 항구'
		else '영국 항구'
	end as embarked 
from titanic_raw;

-- 3차 -2 연습 : survived컬럼과 embarked 컬럼 만으로 단순 검색 
select passengerid, 
	case survived
		when 0 then '사망'
		else '생존'
	end as survived,
	case embarked
		when 'C' then '프랑스 항구'
		when 'Q' then '아일랜드 항구'
		else '영국 항구'
	end as embarked 	
from titanic_raw;

-- 3차 -3 마무리 : survived컬럼과 embarked 컬럼 적용해서 정제된 데이터로 table 생성 
create table titanic as select passengerid, 
	case survived
		when 0 then '사망'
		else '생존'
	end as survived,
	case embarked
		when 'C' then '프랑스 항구'
		when 'Q' then '아일랜드 항구'
		else '영국 항구'
	end as embarked 	
from titanic_raw;

select * from titanic;

-- raw table 기반으로 case 사용해서 새로운 column 생성시에는 데이터값 기준으로 컬럼 타입이 정해짐
desc titanic;	-- survived : int
desc titanic_raw;	-- surived : varchar(2) 문자열 타입으로 자동 적용


-- 성별 생존자 수와 사망자수 검색
-- group by, count 
DROP TABLE IF EXISTS titanic;

create table titanic as select passengerid, 
	case survived
		when 0 then '사망'
		else '생존'
	end as survived,
	pclass, name, gender, age, sibsp, parch, ticket, fare, cabin,
	case embarked
		when 'C' then '프랑스 항구'
		when 'Q' then '아일랜드 항구'
		else '영국 항구'
	end as embarked 	
from titanic_raw;

DESC titanic;

SELECT gender, survived, count(*)
FROM titanic
GROUP BY gender, survived
ORDER BY gender, survived DESC;

SELECT gender, survived, count(*)
FROM titanic
GROUP BY gender, survived
ORDER BY 1, 2 DESC;

-- age 순으로 정렬
SELECT age FROM titanic ORDER BY age desc;

SELECT age, count(*) FROM titanic GROUP BY age ORDER BY 1 ASC;

-- 연령대별로 생존자수와 사망자수 조회
SELECT
	CASE  
		WHEN age BETWEEN 0 AND 9 THEN '0~9'
		WHEN age BETWEEN 10 AND 19 THEN '10대'
		WHEN age BETWEEN 20 AND 29 THEN '20대'
		WHEN age BETWEEN 30 AND 39 THEN '30대'
		WHEN age BETWEEN 40 AND 49 THEN '40대'
		WHEN age BETWEEN 50 AND 59 THEN '50대'
		WHEN age BETWEEN 60 AND 69 THEN '60대'
		WHEN age BETWEEN 70 AND 89 THEN '70, 80대'
		ELSE '알수 없음'
	END AS ages,
	survived, count(*) 
FROM titanic 
GROUP BY ages, survived 
ORDER BY 1, 2 DESC;

SELECT
	CASE  
		WHEN age BETWEEN 0 AND 9 THEN '0~9'
		WHEN age BETWEEN 10 AND 19 THEN '10대'
		WHEN age BETWEEN 20 AND 29 THEN '20대'
		WHEN age BETWEEN 30 AND 39 THEN '30대'
		WHEN age BETWEEN 40 AND 49 THEN '40대'
		WHEN age BETWEEN 50 AND 59 THEN '50대'
		WHEN age BETWEEN 60 AND 69 THEN '60대'
		WHEN age BETWEEN 70 AND 89 THEN '70, 80대'
		ELSE '알수 없음'
	END AS ages,
	survived, pclass, count(*) 
FROM titanic 
GROUP BY ages, pclass, survived 
ORDER BY 1, 2, 3 asc;

-- 객실 등급별 어떤 등급의 사람들이 가장 많이 사망을 했는지 알아내기 위한 sql
SELECT pclass, count(*)
FROM titanic
GROUP BY pclass;

SELECT * FROM titanic;

SELECT pclass, survived, count(*), RANK() OVER(ORDER BY count(*) desc) AS '사망 순위'
FROM titanic 
GROUP BY pclass, survived
HAVING survived = '사망';


SELECT 
	CASE pclass
		WHEN 1 THEN '1등석'
		WHEN 2 THEN '2등석'
		WHEN 3 THEN '3등석'
	END AS '객실등급',
	count(pclass) AS '객실별 총 인원', count(CASE WHEN survived = '사망' THEN 1 END) AS '사망인원',
	(count(CASE WHEN survived = '사망' THEN 1 end)/count(pclass))*100 AS '객실 등급별 사망률',
	RANK() OVER(ORDER BY count(CASE WHEN survived = '사망' THEN 1 END) desc) AS '사망 순위'
FROM titanic 
GROUP BY 1;


select
	case pclass
		when 1 then ' 1등석 '
		when 2 then ' 2등석 '
		else 		' 3등석 '
	end '객실등급',
	count(pclass) '총 인원수',
	count(case when survived = '사망' then 1 end) as '사망자 수',
	(count(case when survived = '사망' then 1 end)/count(pclass))*100 as '사망률 (%)'
from titanic
group by 1
order by 1;
