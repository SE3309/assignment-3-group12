-- Q1 select team from a specific homecity (london)
SELECT teamId, teamName, homeCity
FROM Team
WHERE homeCity = 'London';


-- Q2: Positive Win Rate, or order by win rate percentage (Team + team stats + ranking?)

-- Q3: Career Goals for a player sum across seasons
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

-- Q4: Players on a team (players + teams) (all teams with their players

-- Q5: Players and teams  affected by news (Player + teams + news)
SELECT 
    n.newsId,
    n.headline,
    te.teamId,
    t.teamName
FROM News n
JOIN TeamEffect te ON te.newsId = n.newsId
JOIN Team t ON t.teamId = te.teamId
ORDER BY n.newsId;

-- Q6: team goals per a season (team + season + match)
SELECT 
    ms.teamId,
    t.teamName,
    sm.seasonId,
    SUM(ms.goals) AS season_goals,
    COUNT(DISTINCT ms.matchId) AS matches_played
FROM MatchStats ms
JOIN SoccerMatch sm ON sm.matchId = ms.matchId
JOIN Team t ON t.teamId = ms.teamId
GROUP BY ms.teamId, t.teamName, sm.seasonId
ORDER BY season_goals DESC;

-- Q7: Most goals in a location (location + match + teams)
SELECT 
    l.locationId,
    l.city,
    l.stadium,
    SUM(ms.goals) AS total_goals,
    COUNT(DISTINCT ms.matchId) AS matches_count
FROM MatchStats ms
JOIN SoccerMatch sm ON sm.matchId = ms.matchId
JOIN Location l ON l.locationId = sm.locationId
GROUP BY l.locationId, l.city, l.stadium
ORDER BY total_goals DESC;

-- Q8: Most goals scored against a team x (team + match)
SELECT 
    ms_opponent.teamId AS opponent_teamId,
    t.teamName AS opponent_teamName,
    SUM(ms_opponent.goals) AS goals_scored_against
FROM SoccerMatch sm
JOIN MatchStats ms_teamA 
      ON ms_teamA.matchId = sm.matchId
     AND ms_teamA.teamId = ?          -- teamA, replace ? with literal
JOIN MatchStats ms_opponent 
      ON ms_opponent.matchId = sm.matchId
     AND ms_opponent.teamId <> ms_teamA.teamId
JOIN Team t ON t.teamId = ms_opponent.teamId
GROUP BY ms_opponent.teamId, t.teamName
ORDER BY goals_scored_against DESC;

-- Q9: Players on a fantasy team x (players + fantasy team)
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
WHERE ft.fantasyTeamId = ? -- replace ? with an actual fantasyTeamId
ORDER BY p.lastName, p.firstName;

-- Q10: Players Trade History (player + trade) x
SELECT 
    tr.tradeId,
    tr.playerId,
    CONCAT(p.firstName, ' ', p.lastName) AS player_name,
    oldT.teamName AS old_team_name,
    newT.teamName AS new_team_name
FROM Trade tr
JOIN Player p ON p.playerId = tr.playerId
JOIN Team oldT ON oldT.teamId = tr.oldTeam
JOIN Team newT ON newT.teamId = tr.newTeam
ORDER BY p.playerId, tr.tradeId;

-- Q11: all teams with their players
SELECT 
    t.teamId,
    t.teamName,
    p.playerId,
    p.firstName,
    p.lastName
FROM Team t
LEFT JOIN Player p ON p.teamId = t.teamId
ORDER BY t.teamName, p.lastName, p.firstName;

-- Q12: news articles about a players injury
SELECT 
    n.newsId,
    n.headline,
    pi.playerId,
    p.firstName,
    p.lastName,
    t.teamName AS current_team,
    pi.injuryType,
    pi.injuryDate,
    pi.expectedRecoveryTime
FROM News n
JOIN PlayerInjury pi ON pi.newsId = n.newsId
JOIN Player p ON p.playerId = pi.playerId
LEFT JOIN Team t ON t.teamId = p.teamId
ORDER BY n.newsId;