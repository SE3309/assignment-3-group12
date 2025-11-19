CREATE VIEW DefenderPlayers 
AS SELECT *
   FROM Player
   WHERE position = 'DEFENDER';

SELECT *
FROM DefenderPlayers;

INSERT INTO DefenderPlayers
VALUES ('P001561', 'Sergio', 'Ramos', 'DEFENDER', 'Spain', 'RMADRID');






   

