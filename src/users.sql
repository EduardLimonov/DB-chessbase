USE Chessbase;

DROP USER oppressor@localhost;
DROP USER discriminated@localhost;
CREATE USER oppressor@localhost IDENTIFIED BY 'oppressor';
CREATE USER discriminated@localhost IDENTIFIED BY 'discriminated';

#REVOKE ALL PRIVILEGES ON *.* FROM `oppressor`@`localhost`;
#REVOKE ALL PRIVILEGES ON *.* FROM `discriminated`@`localhost`;

GRANT SELECT, UPDATE, DELETE ON Chessbase.Chessplayer TO oppressor@localhost;
GRANT SELECT ON Chessbase.players_statistics_view TO discriminated@localhost;
GRANT SELECT ON Chessbase.players_statistics_simple_view TO discriminated@localhost;

FLUSH PRIVILEGES;

SHOW GRANTS FOR oppressor@localhost;
SHOW GRANTS FOR discriminated@localhost;


CREATE USER test IDENTIFIED BY 'test';
GRANT ALL PRIVILEGES ON *.* TO test;
