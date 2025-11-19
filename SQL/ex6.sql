-- setting TeamStats ties to the number of draw matches a team played in each season
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
WHERE n.timeReleased < '2021-01-01';

-- insert TournamentRanking rows for every tournament-season
INSERT INTO TournamentRanking (tournamentId, seasonId, rankNumber)
SELECT
  t.tournamentId,
  t.seasonId,
  r.rankNumber
FROM Tournament AS t
JOIN Ranking AS r
  ON r.rankNumber = 1
LEFT JOIN TournamentRanking AS tr
  ON tr.tournamentId = t.tournamentId
 AND tr.seasonId   = t.seasonId
WHERE tr.tournamentId IS NULL;
