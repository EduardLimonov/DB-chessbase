drop database IF EXISTS chessbase;

CREATE DATABASE chessbase;

USE chessbase;

CREATE TABLE FIDE_rank (
	id_rank TINYINT PRIMARY KEY,
	_rank ENUM("GM", "IM", "FM", "CM", "WGM", "WIM", "WFM", "") 
);

CREATE TABLE Qualif_cat (
	id_qualif_cat TINYINT PRIMARY KEY,
	qualif_cat ENUM("A", "B", "C", "D", "E") 
);

CREATE TABLE FIDE_cat (
	id_cat TINYINT PRIMARY KEY,
	category ENUM("", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17",
		"18", "19", "20", "21", "22", "23", "24") 
);

CREATE TABLE Chessplayer (
	id_chessplayer BIGINT UNSIGNED PRIMARY KEY,
	second_name VARCHAR(30),
    first_name VARCHAR(30),
    pathronymic VARCHAR(30),
    year_of_birth YEAR
);

CREATE TABLE Moves (
	id_moves INTEGER PRIMARY KEY,
    string_note TEXT,
    debut_code CHAR(3)
);

CREATE TABLE _Time (
	id_time INTEGER PRIMARY KEY,
    white_minutes INTEGER,
    white_seconds INTEGER,
    black_minutes INTEGER,
    black_seconds INTEGER
);

CREATE TABLE Arbiter (
	id_arbiter INTEGER PRIMARY KEY,
    second_name VARCHAR(30),
    first_name VARCHAR(30),
    pathronimic VARCHAR(30),
    qualif_cat TINYINT,
    
    FOREIGN KEY (qualif_cat) REFERENCES Qualif_cat(id_qualif_cat)
);

CREATE TABLE Competition (
	id_comp INTEGER PRIMARY KEY,
    _name VARCHAR(30),
    _date DATE,
    _format VARCHAR(30),
    time_control VARCHAR(30),
    number_of_rounds INTEGER,
    FIDE_category TINYINT,
    id_chief_arbiter INTEGER,
    
    FOREIGN KEY (FIDE_category) REFERENCES FIDE_cat(id_cat),
    FOREIGN KEY (id_chief_arbiter) REFERENCES Arbiter(id_arbiter)
);

CREATE TABLE _Round (
	id_round INTEGER PRIMARY KEY,
	_date DATE,
    _number TINYINT UNSIGNED,
    id_comp INTEGER,
    
    FOREIGN KEY (id_comp) REFERENCES Competition(id_comp)
);

CREATE TABLE Participation_in_competition (
	id_participation INTEGER PRIMARY KEY,
    ELO_rating INTEGER UNSIGNED,
    id_chessplayer BIGINT UNSIGNED,
    id_comp INTEGER,
	FIDE_rank TINYINT,
    
    FOREIGN KEY (FIDE_rank) REFERENCES FIDE_rank(id_rank),
    FOREIGN KEY (id_chessplayer) REFERENCES Chessplayer(id_chessplayer),
    FOREIGN KEY (id_comp) REFERENCES Competition(id_comp)
);

CREATE TABLE Refereeing (
	id_refereeing INTEGER PRIMARY KEY,
    id_comp INTEGER,
    id_arbiter INTEGER,
    
    FOREIGN KEY (id_comp) REFERENCES Competition(id_comp),
    FOREIGN KEY (id_arbiter) REFERENCES Arbiter(id_arbiter)
);

CREATE TABLE Includ_round (
	id_includ_round INTEGER PRIMARY KEY,
    number_of_rounds INTEGER,
    id_round INTEGER,
    id_comp INTEGER,
    
    FOREIGN KEY (id_round) REFERENCES _Round(id_round),
    FOREIGN KEY (id_comp) REFERENCES Competition(id_comp)
);

CREATE TABLE Completed_play (
	id_complet_play INTEGER PRIMARY KEY,
    result VARCHAR(30),
    id_chessplayer_white BIGINT UNSIGNED,
	id_chessplayer_black BIGINT UNSIGNED,
    id_round INTEGER, 
    id_arbiter INTEGER, 
    id_time INTEGER, 
    id_moves INTEGER, 
    
    FOREIGN KEY (id_chessplayer_white) REFERENCES Chessplayer(id_chessplayer),
    FOREIGN KEY (id_chessplayer_black) REFERENCES Chessplayer(id_chessplayer),
    FOREIGN KEY (id_round) REFERENCES _Round(id_round),
    FOREIGN KEY (id_arbiter) REFERENCES Arbiter(id_arbiter),
    FOREIGN KEY (id_time) REFERENCES _Time(id_time),
    FOREIGN KEY (id_moves) REFERENCES Moves(id_moves)
);

#SELECT * from _time;

set names cp1251;
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\times.txt' 
	INTO TABLE _Time;#
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\moves.txt' 
	INTO TABLE Moves;#
    
INSERT Qualif_cat(id_qualif_cat, qualif_cat)
VALUES (0, "A"),
(1, "B"),
(2, "C"),
(3, "D"),
(4, "E");
    
INSERT FIDE_cat(id_cat, category)
VALUES (0, ""),
	(1, "1"),
	(2, "2"),
	(3, "3"),
	(4, "4"),
	(5, "5"),
	(6, "6"),
	(7, "7"),
	(8, "8"),
	(9, "9"),
	(10, "10"),
	(11, "11"),
	(12, "12"),
	(13, "13"),
	(14, "14"),
	(15, "15"),
	(16, "16"),
	(17, "17"),
	(18, "18"),
	(19, "19"),
	(20, "20"),
	(21, "21"),
	(22, "22"),
	(23, "23");
    
INSERT FIDE_rank(id_rank, _rank)
VALUES (0, "GM"),
	(1, "IM"),
	(2, "FM"),
	(3, "CM"),
	(4, "WGM"),
	(5, "WIM"),
	(6, "WFM"),
	(7, "");

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\players.txt' 
	INTO TABLE Chessplayer CHARACTER SET cp1251;#
    
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\arbs.txt' 
	INTO TABLE Arbiter CHARACTER SET cp1251;
    
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\comps.txt' 
	INTO TABLE Competition CHARACTER SET cp1251;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\refers.txt' 
	INTO TABLE Refereeing;
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\partic.txt' 
	INTO TABLE Participation_in_competition CHARACTER SET cp1251;
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\rounds.txt' 
	INTO TABLE _Round;
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\plays.txt' 
	INTO TABLE Completed_play;



