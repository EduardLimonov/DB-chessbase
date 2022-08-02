USE Chessbase;

CREATE OR REPLACE VIEW players_statistics_view AS 
	SELECT _rank, COUNT(*) AS number_of_players, SUM(number_of_wins), SUM(number_of_loses) 
	FROM 
		(SELECT _rank, COUNT(CASE 
							WHEN id_chessplayer_white = Participation_in_competition.id_chessplayer AND result = '1-0' OR 
									id_chessplayer_black = Participation_in_competition.id_chessplayer AND result = '0-1' THEN 1 
							ELSE NULL 
						END) AS number_of_wins, 
					COUNT(CASE 
							WHEN id_chessplayer_black = Participation_in_competition.id_chessplayer AND result = '1-0' OR 
									id_chessplayer_white = Participation_in_competition.id_chessplayer AND result = '0-1' THEN 1 
							ELSE NULL 
						END) AS number_of_loses 
		FROM Participation_in_competition  
				JOIN FIDE_rank 
					ON FIDE_rank.id_rank = Participation_in_competition.FIDE_rank 
				JOIN _Round  
					ON _Round.id_comp = Participation_in_competition.id_comp 
				LEFT JOIN Completed_play 
					ON Completed_play.id_round = _Round.id_round AND 
                    (Completed_play.id_chessplayer_white =  Participation_in_competition.id_chessplayer OR Participation_in_competition.id_chessplayer = id_chessplayer_black) 
		GROUP BY Participation_in_competition.id_chessplayer, _rank) as t 	
	GROUP BY _rank;
    

SELECT * FROM players_statistics_view ORDER BY _rank;
SELECT * FROM players_statistics_simple_view ORDER BY _rank;


CREATE OR REPLACE VIEW players_statistics_simple_view AS
	SELECT _rank, COUNT(*) AS number_of_players 
	FROM (SELECT _rank 
			FROM Participation_in_competition  
				JOIN FIDE_rank 
					ON FIDE_rank.id_rank = Participation_in_competition.FIDE_rank 
		GROUP BY id_chessplayer, _rank) AS t
	GROUP BY _rank;
    

SELECT COUNT(*) FROM 
((SELECT DISTINCT id_chessplayer_white FROM Completed_play)
UNION
(SELECT DISTINCT id_chessplayer_black FROM Completed_play)
) as t;


SELECT MAX(_date)
FROM _Round;

SELECT second_name FROM 
	Chessplayer 
	JOIN Completed_play 
		ON Completed_play.id_chessplayer_white =  id_chessplayer OR id_chessplayer = id_chessplayer_black
	JOIN 
		_Round
		ON _Round.id_round = Completed_play.id_round
	WHERE _date = (SELECT MAX(_date) FROM _Round)
    LIMIT 1;

SELECT MAX(_date) FROM _Round;


SELECT * 
FROM Chessplayer
JOIN Participation_in_competition ON Chessplayer.id_chessplayer = Participation_in_competition.id_chessplayer
JOIN FIDE_rank ON Participation_in_competition.id_rank = FIDE_rank.id_rank
GROUP BY id_chessplayer, _rank;

SELECT * 
FROM players_statistics_simple_view
JOIN (
	SELECT second_name, _rank, _date 
	FROM FIDE_rank 
	JOIN Participation_in_competition ON Participation_in_competition.id_rank = FIDE_rank.id_rank
	JOIN Chessplayer ON Chessplayer.id_chessplayer = Participation_in_competition.id_chessplayer
	JOIN Completed_play 
		ON Completed_play.id_chessplayer_white =  id_chessplayer OR id_chessplayer = id_chessplayer_black
	JOIN _Round
		ON _Round.id_round = Completed_play.id_round
	GROUP BY id_chessplayer, _rank
);

SELECT second_name, _rank, _Round._date 
		FROM FIDE_rank 
		JOIN Participation_in_competition ON Participation_in_competition.FIDE_rank = FIDE_rank.id_rank 
		JOIN Chessplayer ON Chessplayer.id_chessplayer = Participation_in_competition.id_chessplayer 
		JOIN _Round 
			ON _Round.id_comp = Participation_in_competition.id_comp 
		JOIN Completed_play ON Completed_play.id_round = _Round.id_round AND 
			(Completed_play.id_chessplayer_white =  Chessplayer.id_chessplayer OR Chessplayer.id_chessplayer = id_chessplayer_black)
        GROUP BY _rank, Chessplayer.id_chessplayer, _Round._date  
        ORDER BY _Round._date DESC;


# 1
SELECT t._rank, number_of_players, second_name, t._date FROM 
players_statistics_simple_view 
JOIN 
	( 
		SELECT second_name, _rank, _Round._date 
		FROM FIDE_rank 
		JOIN Participation_in_competition ON Participation_in_competition.FIDE_rank = FIDE_rank.id_rank 
		JOIN Chessplayer ON Chessplayer.id_chessplayer = Participation_in_competition.id_chessplayer 
		JOIN _Round 
			ON _Round.id_comp = Participation_in_competition.id_comp 
		JOIN Completed_play ON Completed_play.id_round = _Round.id_round AND 
			(Completed_play.id_chessplayer_white =  Chessplayer.id_chessplayer OR Chessplayer.id_chessplayer = id_chessplayer_black)
        GROUP BY _rank, Chessplayer.id_chessplayer, _Round._date  
        ORDER BY _Round._date DESC
    ) AS t 
    ON players_statistics_simple_view._rank = t._rank 
GROUP BY t._rank;











EXPLAIN SELECT _rank, COUNT(*) AS number_of_players, SUM(number_of_wins), SUM(number_of_loses) 
	FROM 
		(SELECT _rank, COUNT(CASE 
							WHEN id_chessplayer_white = Participation_in_competition.id_chessplayer AND result = '1-0' OR 
									id_chessplayer_black = Participation_in_competition.id_chessplayer AND result = '0-1' THEN 1 
							ELSE NULL 
						END) AS number_of_wins, 
					COUNT(CASE 
							WHEN id_chessplayer_black = Participation_in_competition.id_chessplayer AND result = '1-0' OR 
									id_chessplayer_white = Participation_in_competition.id_chessplayer AND result = '0-1' THEN 1 
							ELSE NULL 
						END) AS number_of_loses 
		FROM Participation_in_competition  
				JOIN FIDE_rank 
					ON FIDE_rank.id_rank = Participation_in_competition.FIDE_rank 
				JOIN _Round
					ON _Round.id_comp = Participation_in_competition.id_comp
				JOIN Completed_play 
					ON Completed_play.id_round = _Round.id_round AND 
                    (Completed_play.id_chessplayer_white =  Participation_in_competition.id_chessplayer OR Participation_in_competition.id_chessplayer = id_chessplayer_black) 
		GROUP BY Participation_in_competition.id_chessplayer, _rank) as t 	
	GROUP BY _rank;






