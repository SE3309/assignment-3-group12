-- setting TeamStats ties to the number of draw matches a team played in each season
SET SQL_SAFE_UPDATES = 0;

UPDATE TeamStats AS ts
JOIN (
  SELECT
    ms.teamId,
    sm.seasonId,
    COUNT(*) AS draw_count
  FROM MatchStats AS ms
  JOIN SoccerMatch AS sm
    ON sm.matchId = ms.matchId
  WHERE ms.matchId IN (
    SELECT matchId
    FROM MatchStats
    GROUP BY matchId
    HAVING MAX(goals) = MIN(goals)
  )
  GROUP BY ms.teamId, sm.seasonId
) AS d
  ON d.teamId   = ts.teamId
 AND d.seasonId = ts.seasonId
SET ts.ties = d.draw_count
WHERE ts.teamId = d.teamId
  AND ts.seasonId = d.seasonId;


-- remove player injuries and the news linked to them that are recorded earlier than 2021
DELETE pi
FROM PlayerInjury AS pi
JOIN News AS n
  ON n.newsId = pi.newsId
WHERE n.timeReleased < '2022-01-01';


-- create a new trade for a random FORWARD player
-- only affect 1 row just to not mess any data up
INSERT INTO Trade (tradeId, playerId, oldTeam, newTeam)
SELECT CONCAT('TRD', p.playerId) AS tradeId,
       p.playerId,
       p.teamId AS oldTeam,
       t2.teamId AS newTeam
FROM Player AS p
JOIN Team AS t2
  ON t2.teamId <> p.teamId
WHERE p.position = 'FORWARD'
LIMIT 1;



