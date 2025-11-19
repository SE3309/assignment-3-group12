CREATE VIEW DefenderPlayers 
AS SELECT *
   FROM Player
   WHERE position = 'DEFENDER';

SELECT *
FROM DefenderPlayers;

INSERT INTO DefenderPlayers
VALUES ('P001561', 'Sergio', 'Ramos', 'DEFENDER', 'Spain', 'RMADRID');




CREATE VIEW AdvertisementRevenue
AS SELECT priority, COUNT(*) AS adCount, SUM(revenue) AS totalRevenue, AVG(revenue) AS avgRevenue
   FROM Advertisement
   GROUP BY priority;
   
SELECT priority, adCount, ROUND(totalRevenue, 2) AS totalRevenue, ROUND(avgRevenue, 2) AS avgRevenue
FROM AdvertisementRevenue;

INSERT INTO AdvertisementRevenue (priority, adCount, totalRevenue, avgRevenue)
VALUES (3, 15, 5000, 545); 

   



   

