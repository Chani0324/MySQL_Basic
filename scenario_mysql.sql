USE playdata;

SHOW tables;

DESC guild;
DESC player;

SELECT * FROM guild;
SELECT * FROM player;

-- 1. 길드 탈퇴
-- player A는 가입 되어 있는 길드가 마음에 들지 않아 길드를 탈퇴하려고 합니다.
-- player id를 이용해 가입 되어 있는 길드에서 탈퇴합니다.
DROP PROCEDURE IF EXISTS leaving_guild;

CREATE PROCEDURE leaving_guild (player_id VARCHAR(30) BINARY)
BEGIN
	UPDATE player
	SET gno = NULL
	WHERE id = player_id;
	COMMIT;
END;

CALL leaving_guild('10점만점');

SELECT id, gno
FROM player
WHERE id = '10점만점';

-- 2. 길드 가입
-- player A는 새로운 길드 B에 가입하려고 합니다.
-- player id와 guild name을 이용해 새로운 길드에 가입합니다.
DROP PROCEDURE IF EXISTS signing_up_guild;

CREATE PROCEDURE signing_up_guild (player_id VARCHAR(30) BINARY, guild_name VARCHAR(30) BINARY)
BEGIN
	UPDATE player
	SET gno = (
		SELECT gno
		FROM guild
		WHERE guild.name = guild_name
	)
	WHERE id = player_id;
	COMMIT;
END;

CALL signing_up_guild('10점만점', '오직전투');

SELECT id, gno
FROM player
WHERE id = '10점만점';

-- 3. 선물 상자 이벤트
-- 게임사는 결제 금액에 따라 차등으로 선물 상자를 지급하는 이벤트를 진행하려고 합니다.
-- 이벤트 담당자는 이벤트 진행을 위해 유저 별로 지급되는 선물 상자를 검색합니다.
SELECT rid,
	CASE
		WHEN SUM(cash) BETWEEN 100000 AND 990000 THEN '동 선물상자'
		WHEN SUM(cash) BETWEEN 1000000 AND 4990000 THEN '은 선물상자'
		WHEN SUM(cash) BETWEEN 5000000 AND 9990000 THEN '금 선물상자'
		WHEN SUM(cash) BETWEEN 10000000 AND 19990000 THEN '플래티넘 선물상자'
		WHEN SUM(cash) >= 20000000 THEN '다이아 선물상자'
	END AS '이벤트 선물상자'
FROM player
GROUP BY rid
ORDER BY SUM(cash) DESC;

-- 4. 길드 버프 (미완성 작업중)
-- 길드 A는 레이드 중 레이드를 끝내기 위해 길드 버프를 사용하고자 합니다.
-- 길드 버프는 길드원 전원의 전투력을 5초간 100% 증가 시킵니다.
DROP PROCEDURE IF EXISTS guild_buff_starts;
DROP PROCEDURE IF EXISTS guild_buff_ends;

CREATE PROCEDURE guild_buff_starts (IN guild_no INT, OUT start_time DATETIME)
BEGIN
	UPDATE player
	SET str = str * 2, start_time = SYSDATE() 
	WHERE gno = guild_no;
	SELECT start_time;
END;
