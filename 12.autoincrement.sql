-- 12.autoincrement.sql
/*
1. 개요
	- 새 데이터 저장시 고유 번호가 자동 생성 및 적용하게 하는 기술
	
2. 대표적인 활용 영역
	- 게시물 글번호에 주로 사용

3. 문법
	- auto_increment 키워드 적용
	- 생성
		- 컬럼명 타입 auto_increment
	- 시작 값을 100으로 하려 할 경우
		- alter table table명 auto_increment = 100;
	
*/	
	     

use playdata;

-- 1. 사번에 적용하여 1씩 자동 증가하도록

DROP TABLE IF EXISTS emp01;


-- empno를 auto_increment로 자동증가 적용시 pk로 미등록하면 에러 발생함.
CREATE TABLE emp01(
	empno int AUTO_INCREMENT,
	ename varchar(10) NOT NULL,
	PRIMARY KEY (empno)
);

DESC emp01;

INSERT INTO emp01 (ename) VALUES ('카리나');
SELECT * FROM emp01;

-- 2. 수정 : 자동증가분 시작값을 100으로 설정해 보기 
ALTER TABLE emp01 AUTO_INCREMENT = 100;

INSERT INTO emp01 (ename) VALUES ('카리나');
SELECT * FROM emp01;

 


