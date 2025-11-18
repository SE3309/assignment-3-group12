-- Q1 select team from a specific homecity (london)
SELECT teamId, teamName, homeCity
FROM Team
WHERE homeCity = 'London';

-- Q2: Career Goals per Player across all seasons
SELECT 
    p.playerId,
    p.firstName,
    p.lastName,
    t.teamName,
    SUM(ps.goals) AS career_goals,
    COUNT(DISTINCT ps.seasonId) AS seasons_played
FROM Player p
JOIN PlayerStats ps ON ps.playerId = p.playerId
LEFT JOIN Team t ON t.teamId = p.teamId
GROUP BY p.playerId, p.firstName, p.lastName, t.teamName
ORDER BY career_goals DESC;

-- Q3: Positive Win rate
SELECT 
    ts.teamId,
    t.teamName,
    ts.seasonId,
    ts.wins,
    ts.losses,
    (ts.wins / (ts.wins + ts.losses)) AS win_rate
FROM TeamStats ts
JOIN Team t ON t.teamId = ts.teamId
WHERE (ts.wins + ts.losses) > 0
  AND (ts.wins / (ts.wins + ts.losses)) > 0.5
ORDER BY win_rate DESC;

-- Q4: all players on every team
SELECT 
    t.teamId,
    t.teamName,
    p.playerId,
    p.firstName,
    p.lastName
FROM Team t
LEFT JOIN Player p ON p.teamId = t.teamId
ORDER BY t.teamName, p.lastName, p.firstName;


-- Q5: Most goals scored against a given team
SELECT 
    ms_opponent.teamId AS opponent_teamId,
    t.teamName AS opponent_teamName,
    SUM(ms_opponent.goals) AS goals_scored_against
FROM SoccerMatch sm
JOIN MatchStats ms_teamA 
      ON ms_teamA.matchId = sm.matchId
     AND ms_teamA.teamId = 'TEAM001'    -- example ID replace with literal ID
JOIN MatchStats ms_opponent 
      ON ms_opponent.matchId = sm.matchId
     AND ms_opponent.teamId <> ms_teamA.teamId
JOIN Team t ON t.teamId = ms_opponent.teamId
GROUP BY ms_opponent.teamId, t.teamName
ORDER BY goals_scored_against DESC;

-- Q6: Players on a fantasy team
SELECT 
    ft.fantasyTeamId,
    ft.teamName AS fantasy_team_name,
    p.playerId,
    p.firstName,
    p.lastName,
    p.nationality,
    t.teamName AS real_team_name
FROM FantasyTeam ft
JOIN UserPreferences up ON up.username = ft.username
JOIN Team t ON t.teamId = up.teamId
JOIN Player p ON p.teamId = t.teamId
WHERE ft.fantasyTeamId = 'FT001' -- example ID replace with an actual fantasyTeamId
ORDER BY p.lastName, p.firstName;


-- Q7: Players who have never been traded
SELECT 
    p.playerId,
    p.firstName,
    p.lastName
FROM Player p
WHERE NOT EXISTS (
    SELECT 1
    FROM Trade tr
    WHERE tr.playerId = p.playerId
)
ORDER BY p.lastName, p.firstName;


-- EXTRA QUERIES shown on previous commits (final select query list commit)

