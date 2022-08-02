USE chessbase; 

SET CHARSET utf8mb4;

# 1 а Вывести всех шахматистов, игры которых судил судья А и которые выиграли свою игру; choose Completed_play.id_arbiter = 1, Arbiter.id_arbiter = 1

SELECT Chessplayer.id_chessplayer AS id, 
	Chessplayer.second_name AS second_name, 
	Chessplayer.first_name AS first_name, 
	Chessplayer.pathronymic AS pathronymic, 
    Arbiter.second_name AS arbiter 
FROM Chessplayer 
	JOIN Completed_play 
		 ON (Chessplayer.id_chessplayer = Completed_play.id_chessplayer_white AND Completed_play.result = "1-0" OR 
			Chessplayer.id_chessplayer = Completed_play.id_chessplayer_black AND Completed_play.result = "0-1") 
	JOIN Arbiter ON Arbiter.id_arbiter = Completed_play.id_arbiter 
WHERE Completed_play.id_arbiter = 1; 

# 1 б Добавить: выигравших игру в пятом туре
SELECT Chessplayer.id_chessplayer AS id, 
	Chessplayer.second_name AS second_name, 
	Chessplayer.first_name AS first_name, 
	Chessplayer.pathronymic AS pathronymic, 
    Arbiter.second_name AS arbiter 
FROM Chessplayer 
	JOIN (Completed_play 
		JOIN _Round ON Completed_play.id_round = _Round.id_round AND _Round._number = 5
        ) 
		ON (Chessplayer.id_chessplayer = Completed_play.id_chessplayer_white AND Completed_play.result = "1-0" OR 
			Chessplayer.id_chessplayer = Completed_play.id_chessplayer_black AND Completed_play.result = "0-1") 
	JOIN Arbiter ON Arbiter.id_arbiter = Completed_play.id_arbiter 
WHERE Completed_play.id_arbiter = 1; 

# 2 Посчитать кол-во турниров, в которых играл шахматист А с категорией турнира B; id_chessplayer = 1006497; id FIDE_cat = 2
SELECT COUNT(*) AS num 
FROM Participation_in_competition 
		JOIN Competition ON Competition.id_comp = Participation_in_competition.id_comp 
WHERE  Participation_in_competition.id_chessplayer = 1006497 AND Competition.FIDE_category = 1;

# 3 а Найти арбитров, которые судили максимальное число игр

SELECT Arbiter.id_arbiter AS id, 
	Arbiter.second_name AS second_name, 
    COUNT(*) AS num 
FROM Arbiter 
	JOIN Completed_play ON Arbiter.id_arbiter = Completed_play.id_arbiter 
GROUP BY Arbiter.id_arbiter 
HAVING num = (
	SELECT COUNT(*) AS max_num 
    FROM Arbiter 
		JOIN Completed_play ON Arbiter.id_arbiter = Completed_play.id_arbiter 
    GROUP BY Arbiter.id_arbiter 
    ORDER BY max_num DESC 
    LIMIT 1 
);
    
# 3 б минимальное число игр
    
SELECT Arbiter.id_arbiter AS id, 
	Arbiter.second_name AS second_name, 
    COUNT(*) AS num 
FROM Arbiter 
	JOIN Completed_play ON Arbiter.id_arbiter = Completed_play.id_arbiter 
GROUP BY Arbiter.id_arbiter 
HAVING num = (
	SELECT COUNT(*) AS min_num
    FROM Arbiter JOIN Completed_play ON Arbiter.id_arbiter = Completed_play.id_arbiter 
    GROUP BY Arbiter.id_arbiter
    ORDER BY min_num
    LIMIT 1
);
    
# 4 а Найти шахматистов, которые сыграли больше партий, чем шахматист А, id_chessplayer = 6395208
 
SELECT Chessplayer.id_chessplayer AS id, 
	Chessplayer.second_name AS second_name, Chessplayer.first_name AS first_name, 
    Chessplayer.pathronymic AS pathronymic, 
    COUNT(*) AS num, 
    ( 
	SELECT COUNT(*) 
    FROM Chessplayer 
		JOIN Completed_play ON Chessplayer.id_chessplayer = Completed_play.id_chessplayer_white OR Chessplayer.id_chessplayer = Completed_play.id_chessplayer_black 
	WHERE Chessplayer.id_chessplayer = 6395208 
) as games_of_a 
FROM Chessplayer 
	JOIN Completed_play ON Chessplayer.id_chessplayer = Completed_play.id_chessplayer_white OR Chessplayer.id_chessplayer = Completed_play.id_chessplayer_black 
GROUP BY Chessplayer.id_chessplayer 
HAVING num > ( 
	SELECT COUNT(*) 
    FROM Chessplayer 
		JOIN Completed_play ON Chessplayer.id_chessplayer = Completed_play.id_chessplayer_white OR Chessplayer.id_chessplayer = Completed_play.id_chessplayer_black 
	WHERE Chessplayer.id_chessplayer = 6395208 
) ;
 
 # 4 б которые выиграли больше партий, чем А

/*SELECT Chessplayer.id_chessplayer AS id, 
	Chessplayer.second_name AS second_name, Chessplayer.first_name AS first_name, 
    Chessplayer.pathronymic AS pathronymic, 
    COUNT(*) AS num, 
    ( 
	SELECT COUNT(*) 
    FROM Chessplayer 
		JOIN Completed_play ON Chessplayer.id_chessplayer = Completed_play.id_chessplayer_white AND Completed_play.result = '1-0' 
			OR Chessplayer.id_chessplayer = Completed_play.id_chessplayer_black AND Completed_play.result = '0-1' 
	WHERE Chessplayer.id_chessplayer = 1649738 
	) as games_of_a 
FROM Chessplayer 
	JOIN Completed_play ON Chessplayer.id_chessplayer = Completed_play.id_chessplayer_white AND Completed_play.result = '1-0' 
		OR Chessplayer.id_chessplayer = Completed_play.id_chessplayer_black AND Completed_play.result = '0-1' 
GROUP BY Chessplayer.id_chessplayer 
HAVING num > ( 
	SELECT COUNT(*) 
    FROM Chessplayer 
		JOIN Completed_play ON Chessplayer.id_chessplayer = Completed_play.id_chessplayer_white AND Completed_play.result = '1-0' 
			OR Chessplayer.id_chessplayer = Completed_play.id_chessplayer_black AND Completed_play.result = '0-1' 
	WHERE Chessplayer.id_chessplayer = 1649738 
) ;*/

SELECT Chessplayer.id_chessplayer AS id, 
	Chessplayer.second_name AS second_name, Chessplayer.first_name AS first_name, 
    Chessplayer.pathronymic AS pathronymic, 
    @cnt := COUNT(*) AS num 
FROM Chessplayer 
	JOIN Completed_play ON Chessplayer.id_chessplayer = Completed_play.id_chessplayer_white AND Completed_play.result = '1-0' 
			OR Chessplayer.id_chessplayer = Completed_play.id_chessplayer_black AND Completed_play.result = '0-1' 
WHERE Chessplayer.id_chessplayer = 2614059 
UNION ALL 
SELECT Chessplayer.id_chessplayer AS id, 
	Chessplayer.second_name AS second_name, Chessplayer.first_name AS first_name, 
    Chessplayer.pathronymic AS pathronymic, 
    COUNT(*) AS num 
FROM Chessplayer 
	JOIN Completed_play ON Chessplayer.id_chessplayer = Completed_play.id_chessplayer_white AND Completed_play.result = '1-0' 
			OR Chessplayer.id_chessplayer = Completed_play.id_chessplayer_black AND Completed_play.result = '0-1' 
GROUP BY Chessplayer.id_chessplayer 
HAVING num > @cnt;
 
 # 5 а Посчитать число игр в кажом турнире
 
SELECT Competition.id_comp AS id_comp, Competition._name as _name, COUNT(*) as number_of_plays
 FROM Competition 
	JOIN _Round ON Competition.id_comp = _Round.id_comp 
	JOIN Completed_play ON Completed_play.id_round = _Round.id_round 
GROUP BY Competition.id_comp; 

# 5 б в каждом тура турнира А -- id_comp = 1

SELECT _Round.id_round AS id_round, _Round._number AS _round_number, COUNT(*) AS number_of_plays 
FROM Competition 
	JOIN _Round ON Competition.id_comp = _Round.id_comp 
    JOIN Completed_play ON Completed_play.id_round = _Round.id_round 
WHERE Competition.id_comp = 1 
GROUP BY _Round.id_round;
 
# 6 Посчитать количество шахматистов с одинаковым числом побед

EXPLAIN SELECT num_of_wins, COUNT(*) 
FROM (( 
	SELECT Chessplayer.id_chessplayer AS id, COUNT(Completed_play.id_complet_play) as num_of_wins 
	FROM Chessplayer 
		LEFT JOIN Completed_play ON Chessplayer.id_chessplayer = Completed_play.id_chessplayer_white AND Completed_play.result = "1-0" 
	GROUP BY Chessplayer.id_chessplayer 
) UNION ALL (
	SELECT Chessplayer.id_chessplayer AS id, COUNT(Completed_play.id_complet_play) as num_of_wins 
	FROM Chessplayer 
		LEFT JOIN Completed_play ON Chessplayer.id_chessplayer = Completed_play.id_chessplayer_black AND Completed_play.result = "0-1" 
	GROUP BY Chessplayer.id_chessplayer ) ) AS T
GROUP BY num_of_wins 
ORDER BY num_of_wins;
    
# 7 Найти шахматистов, которые не играли в турнире А; id_comp = 10

SELECT Chessplayer.id_chessplayer AS id, 
	Chessplayer.second_name AS second_name, 
	Chessplayer.first_name AS first_name, 
	Chessplayer.pathronymic AS pathronymic 
FROM Competition 
	JOIN Participation_in_competition ON Competition.id_comp = 10 AND Competition.id_comp = Participation_in_competition.id_comp 
    RIGHT JOIN Chessplayer ON Chessplayer.id_chessplayer = Participation_in_competition.id_chessplayer 
WHERE Competition.id_comp IS NULL;

# 8 Посчитать число игр для каждой квалификационной категории судей по каждой категории ФИДЕ

SELECT Qualif_cat.qualif_cat AS Qualification_category, 
	FIDE_cat.category AS FIDE_category, 
    COUNT(Completed_play.id_complet_play) AS num 
FROM FIDE_cat
	JOIN Qualif_cat 
    LEFT JOIN Arbiter ON Arbiter.qualif_cat = Qualif_cat.id_qualif_cat
    LEFT JOIN Completed_play ON Completed_play.id_arbiter = Arbiter.id_arbiter  
GROUP BY Qualif_cat.id_qualif_cat, FIDE_cat.id_cat 
ORDER BY Qualif_cat.id_qualif_cat, FIDE_cat.id_cat;
    
