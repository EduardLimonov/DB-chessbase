USE Chessbase;


CREATE TABLE Num_last_plays
(
	for_last_day INTEGER NOT NULL, 
    for_last_month INTEGER NOT NULL, 
    for_last_year INTEGER NOT NULL
);



DROP FUNCTION IF EXISTS date_of_play;

DELIMITER $$
CREATE FUNCTION date_of_play ( round_id INT )
RETURNS DATE DETERMINISTIC 

BEGIN
	RETURN (SELECT _date FROM _Round WHERE id_round = round_id); 
END; $$
DELIMITER ;


DROP FUNCTION IF EXISTS num_of_plays_for_round;

DELIMITER $$
CREATE FUNCTION num_of_plays_for_round ( round_id INT)
RETURNS INT DETERMINISTIC 

BEGIN
	RETURN (SELECT COUNT(*) FROM Completed_play WHERE id_round = round_id); 
END; $$
DELIMITER ;


drop procedure add_for_period;
DELIMITER $$
CREATE PROCEDURE add_for_period ( round_id INT, delta INT )
BEGIN
	IF DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY) < date_of_play(round_id) 
        THEN
			UPDATE Num_last_plays
			SET for_last_day = for_last_day + delta;
		END IF;
	IF DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH) < date_of_play(round_id) 
        THEN
			UPDATE Num_last_plays
			SET for_last_month = for_last_month + delta;
		END IF;
	IF DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR) < date_of_play(round_id) 
        THEN
			UPDATE Num_last_plays
			SET for_last_year = for_last_year + delta;
		END IF;
END; $$
DELIMITER ;


drop procedure sub_for_period;
DELIMITER $$
CREATE PROCEDURE sub_for_period ( round_id INT, delta INT )
BEGIN
	IF DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY) < date_of_play(round_id) 
        THEN
			UPDATE Num_last_plays
			SET for_last_day = for_last_day - delta;
		END IF;
	IF DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH) < date_of_play(round_id) 
        THEN
			UPDATE Num_last_plays
			SET for_last_month = for_last_month - delta;
		END IF;
	IF DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR) < date_of_play(round_id) 
        THEN
			UPDATE Num_last_plays
			SET for_last_year = for_last_year - delta;
		END IF;
END; $$
DELIMITER ;


-- drop procedure update_for_day;
-- drop procedure update_for_month;
-- drop procedure update_for_year;

-- DELIMITER $$
-- CREATE PROCEDURE update_for_day ( round_id INT, ignore_check BOOL )
-- BEGIN
-- 	IF ignore_check OR DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY) < date_of_play(round_id) 
--         THEN
-- 			UPDATE Num_last_plays
-- 			SET for_last_day = (
-- 				SELECT COUNT(*) FROM Completed_play
-- 				WHERE DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY) < date_of_play(id_round) 
-- 			);
-- 		END IF;
-- END; $$
-- DELIMITER ;

-- DELIMITER $$
-- CREATE PROCEDURE update_for_month ( round_id INT, ignore_check BOOL )
-- BEGIN
-- 	IF ignore_check OR DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH) < date_of_play(round_id)
--         THEN
-- 			UPDATE Num_last_plays
-- 			SET for_last_month = (
-- 				SELECT COUNT(*) FROM Completed_play
-- 				WHERE DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH) < date_of_play(id_round) 
-- 			);
-- 		END IF;
-- END; $$
-- DELIMITER ;

-- DELIMITER $$
-- CREATE PROCEDURE update_for_year ( round_id INT, ignore_check BOOL )
-- BEGIN
-- 	IF ignore_check OR DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR) < date_of_play(round_id) 
--         THEN
-- 			UPDATE Num_last_plays
-- 			SET for_last_year = (
-- 				SELECT COUNT(*) FROM Completed_play
-- 				WHERE DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR) < date_of_play(id_round) 
-- 			);
-- 		END IF;
-- END; $$
-- DELIMITER ;


# триггеры должны отслеживать: добавление и удаление игр, обновление игры (изменение ссылки на тур), обновление туров (изменение даты), удаление тура (ведущее к удалению всех сыгранных партий)
drop trigger if exists insert_play_trigger;
# добавление игры
DELIMITER $$
CREATE TRIGGER insert_play_trigger
	AFTER INSERT ON Completed_play FOR EACH ROW 
    BEGIN
		CALL add_for_period(NEW.id_round, 1);
	END$$
DELIMITER ;

drop trigger if exists delete_play_trigger;
# удаление игры
DELIMITER $$
CREATE TRIGGER delete_play_trigger
	AFTER DELETE ON Completed_play FOR EACH ROW 
    BEGIN
		CALL sub_for_period(OLD.id_round, 1);
	END$$
DELIMITER ;

drop trigger if exists update_play_trigger;
# обновление игры
DELIMITER $$
CREATE TRIGGER update_play_trigger
	AFTER UPDATE ON Completed_play FOR EACH ROW 
    BEGIN
		IF date_of_play(NEW.id_round) != date_of_play(OLD.id_round)
        THEN
			CALL sub_for_period(OLD.id_round, 1);
			CALL add_for_period(NEW.id_round, 1);
		END IF;
	END$$
DELIMITER ;

drop trigger if exists update_round_trigger;
# обновление тура
DELIMITER $$
CREATE TRIGGER update_round_trigger
	AFTER UPDATE ON _Round FOR EACH ROW 
    BEGIN
		IF NEW._date != OLD._date
        THEN
			CALL sub_for_period(OLD.id_round, num_of_plays_for_round(OLD.id_round));
			CALL add_for_period(NEW.id_round, num_of_plays_for_round(NEW.id_round));
		END IF;
	END$$
DELIMITER ;

drop trigger if exists delete_round_trigger;
# удаление тура => удаление всех игр в этом туре
DELIMITER $$
CREATE TRIGGER delete_round_trigger
	BEFORE DELETE ON _Round FOR EACH ROW 
    BEGIN
		DELETE FROM Completed_play WHERE id_round = OLD.id_round;
	END$$
DELIMITER ;


DELETE FROM Num_last_plays;
INSERT INTO Num_last_plays VALUES (
	(SELECT COUNT(*) FROM Completed_play WHERE DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY) < date_of_play(id_round)),
    (SELECT COUNT(*) FROM Completed_play WHERE DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH) < date_of_play(id_round)),
    (SELECT COUNT(*) FROM Completed_play WHERE DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR) < date_of_play(id_round))
);


SELECT * FROM Num_last_plays;
delete from completed_play where id_complet_play >= 100002;
select count(*) from completed_play;
show triggers;

delete from _Round where id_round = 2000;
INSERT INTO _Round VALUE (2000, CURRENT_DATE(), 20, 1);
UPDATE _Round 
SET _date = CURRENT_DATE()
WHERE id_round = 2000;

select * from chessplayer where id_chessplayer = 1005597 or id_chessplayer = 1007465;

INSERT INTO Completed_play VALUES
	(100002, '1-0', 1005597, 1007465, 2000, 1, 1, 1),
    (100003, '1-0', 1007465, 1005597, 2000, 1, 1, 1);


