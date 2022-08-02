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
				JOIN Competition 
					ON Competition.id_comp = Participation_in_competition.id_comp 
				JOIN _Round
					ON _Round.id_comp = Competition.id_comp
				JOIN Completed_play 
					ON Completed_play.id_round = _Round.id_round AND 
                    (Completed_play.id_chessplayer_white =  Participation_in_competition.id_chessplayer OR Participation_in_competition.id_chessplayer = id_chessplayer_black) 
		GROUP BY Participation_in_competition.id_chessplayer, _rank) as t 	
	GROUP BY _rank;
    

SELECT * FROM players_statistics_view;
SELECT * FROM players_statistics_simple_view;


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
