-- insert teams
INSERT INTO Team (teamId, teamName, managerFirstName, managerLastName, homeCity) 
VALUES
  ('MCI', 'Manchester City', 'Pep', 'Guardiola', 'Manchester'),
  ('ARS', 'Arsenal', 'Mikel', 'Arteta', 'London'),
  ('LIV', 'Liverpool', 'Jurgen', 'Klopp', 'Liverpool'),
  ('RMADRID', 'Real Madrid', 'Xabi', 'Alonso', 'Madrid'),
  ('FCBARCE', 'FC Barcelona', 'Hansi', 'Flick', 'Barcelona');

SELECT *
FROM Team;

-- add players into Player tables without explicitely entering in teamID
INSERT INTO Player (playerId, firstName, lastName, nationality, teamId)
SELECT r.playerId, r.firstName, r.lastName, r.nationality, t.teamId
FROM (
    SELECT 'PLY001' AS playerId, 'Erling' AS firstName, 'Haaland' AS lastName, 'Norway' AS nationality, 'Manchester City' AS teamName
    UNION ALL 
    SELECT 'PLY002','Kevin','De Bruyne','Belgium','Manchester City'
    UNION ALL 
    SELECT 'PLY003','Phil','Foden','England','Manchester City'
    UNION ALL 
    SELECT 'PLY010','Bukayo','Saka','England','Arsenal'
    UNION ALL 
    SELECT 'PLY011','Martin','Odegaard','Norway','Arsenal'
    UNION ALL 
    SELECT 'PLY020','Mohamed','Salah','Egypt','Liverpool'
) AS r
JOIN Team AS t ON t.teamName = r.teamName;

SELECT *
FROM Player;


-- create News row for each team
INSERT INTO News (newsId, timeReleased, headline, description)
SELECT
  CONCAT('N_', t.teamId) AS newsId,
  CURDATE() AS timeReleased,
  -- cut off any excess letters from the left after 15 characters using LEFT function
  LEFT(CONCAT(t.teamName, ' update'), 15) AS headline,        
  LEFT(CONCAT('Mgr ', t.managerLastName, ' presser: ', t.teamName), 40) AS description  
FROM Team AS t;

SELECT *
FROM News;


