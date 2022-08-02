USE chessbase; 

SET CHARSET utf8mb4;

DROP FUNCTION IF EXISTS player_wins;
# Функция возвращает TRUE, если игрок с id_chessplayer выиграл в партии, в которой белыми и черными играли игроки с id_chessplayer_white, id_chessplayer_black соответственно
# партия закончилась с результатом result
DELIMITER $$
CREATE FUNCTION player_wins ( id_chessplayer INT, id_chessplayer_white INT, id_chessplayer_black INT, result CHAR(30) )
RETURNS BOOL DETERMINISTIC 

BEGIN
	RETURN id_chessplayer = id_chessplayer_white AND result = "1-0" OR 
			id_chessplayer = id_chessplayer_black AND result = "0-1"; 
END; $$
DELIMITER ;

# 1 б Вывести всех шахматистов, игры которых судил судья А и которые выиграли свою игру в 5м туре; choose Completed_play.id_arbiter = 1, Arbiter.id_arbiter = 1
SELECT Chessplayer.id_chessplayer AS id, 
	Chessplayer.second_name AS second_name, 
	Chessplayer.first_name AS first_name, 
	Chessplayer.pathronymic AS pathronymic, 
    Arbiter.second_name AS arbiter 
FROM Chessplayer 
	JOIN (Completed_play 
		JOIN _Round ON Completed_play.id_round = _Round.id_round AND _Round._number = 5
        ) 
		ON player_wins(Chessplayer.id_chessplayer, id_chessplayer_white, id_chessplayer_black, result) 
	JOIN Arbiter ON Arbiter.id_arbiter = Completed_play.id_arbiter 
WHERE Completed_play.id_arbiter = 1; 

SELECT * FROM completed_play;



# 4 б Найти шахматистов, которые выиграли больше партий, чем шахматист А, id_chessplayer = 2614059 
SELECT Chessplayer.id_chessplayer AS id, 
	Chessplayer.second_name AS second_name, Chessplayer.first_name AS first_name, 
    Chessplayer.pathronymic AS pathronymic, 
    @cnt := COUNT(*) AS num 
FROM Chessplayer 
	JOIN Completed_play ON player_wins(Chessplayer.id_chessplayer, id_chessplayer_white, id_chessplayer_black, result)  
WHERE Chessplayer.id_chessplayer = 2614059 
UNION ALL 
SELECT Chessplayer.id_chessplayer AS id, 
	Chessplayer.second_name AS second_name, Chessplayer.first_name AS first_name, 
    Chessplayer.pathronymic AS pathronymic, 
    COUNT(*) AS num 
FROM Chessplayer 
	JOIN Completed_play ON player_wins(Chessplayer.id_chessplayer, id_chessplayer_white, id_chessplayer_black, result)  
GROUP BY Chessplayer.id_chessplayer 
HAVING num > @cnt;


