DROP DATABASE IF EXISTS FantasySoccer; -- only use this if you want to reset all data in the DB
CREATE DATABASE FantasySoccer; -- create a new DB from start
USE FantasySoccer;



CREATE TABLE User
			(username VARCHAR(35), 
            passwordHash VARCHAR(255),
			PRIMARY KEY (username),
            CHECK (LENGTH(username) > 0));
DESCRIBE User;
CREATE TABLE UserRole
			(username VARCHAR(35),
            role VARCHAR(25),
            PRIMARY KEY(username),
            FOREIGN KEY (username)
						REFERENCES User(username),
			CHECK(role IN ('USER', 'ADMIN')));
DESCRIBE UserRole;

CREATE TABLE UserPreferences 
			(username VARCHAR(35), 
            teamId VARCHAR(25),
			PRIMARY KEY (username),
            FOREIGN KEY (username)
						REFERENCES User(username));
DESCRIBE UserPreferences;




CREATE TABLE FantasyTeam
			(fantasyTeamId VARCHAR(25), 
            teamName VARCHAR(35), 
            username VARCHAR(35),
			PRIMARY KEY (fantasyTeamId),
            FOREIGN KEY (username) 
						REFERENCES UserPreferences(username)
                        ON UPDATE CASCADE);
DESCRIBE FantasyTeam;



CREATE TABLE Advertisement
			(advertisementId VARCHAR(20), 
            advertiserName VARCHAR(25), 
            message VARCHAR(45), 
            revenue DOUBLE, 
            priority INTEGER,
			PRIMARY KEY (advertisementId));
DESCRIBE Advertisement;



CREATE TABLE News
			(newsId VARCHAR(20), 
            timeReleased DATE, 
            headline VARCHAR(15), 
            description VARCHAR(40),
			PRIMARY KEY (newsId));
DESCRIBE News; 



CREATE TABLE Team 
			(teamId VARCHAR(20), 
            teamName VARCHAR(25), 
            managerFirstName VARCHAR(20), 
            managerLastName VARCHAR(20), 
            homeCity VARCHAR(15),
			PRIMARY KEY (teamId));
DESCRIBE Team;
CREATE TABLE TeamEffect
			(teamId VARCHAR(20),
            newsId VARCHAR(20),
            PRIMARY KEY (teamId, newsId),
            FOREIGN KEY (teamId)
						REFERENCES Team(teamId),
			FOREIGN KEY (newsId)
						REFERENCES News(newsId));
DESCRIBE TeamEffect;

CREATE TABLE Season
			(seasonId VARCHAR(20), 
            year INT, 
            startDate DATE, 
            endDate DATE, 
			PRIMARY KEY (seasonId),
            CHECK (startDate != endDate));
DESCRIBE Season;



CREATE TABLE League 
			(leagueId VARCHAR(20), 
            leagueName VARCHAR(25), 
            isActive BOOL,
			PRIMARY KEY (leagueId));
DESCRIBE League;
CREATE TABLE LeagueTeams 
			(leagueId VARCHAR(20), 
            teamId VARCHAR(20),
			PRIMARY KEY (leagueId, teamId),
            FOREIGN KEY (leagueId) 
						REFERENCES League(leagueId),
			FOREIGN KEY (teamId) 
						REFERENCES Team(teamId));
DESCRIBE LeagueTeams;
CREATE TABLE SeasonManagement
			(seasonId VARCHAR(20), 
            leagueId VARCHAR(20),
			PRIMARY KEY (seasonId, leagueId),
            FOREIGN KEY (seasonId) 
						REFERENCES Season(seasonId),
            FOREIGN KEY (leagueId) 
						REFERENCES League(leagueId));
Describe SeasonManagement;



CREATE TABLE TeamStats
			(teamId VARCHAR(20), 
            seasonId VARCHAR(20), 
            wins INT, 
            losses INT,
            ties INT,
			PRIMARY KEY (teamId, seasonId),
            FOREIGN KEY (teamId) 
						REFERENCES Team(teamId),
            FOREIGN KEY (seasonId) 
						REFERENCES Season(seasonId));
DESCRIBE TeamStats;



CREATE TABLE Tournament
			(tournamentId VARCHAR(20),
            tournamentName VARCHAR(25),
            startDate DATE,
            endDate DATE,
            seasonId VARCHAR(20),
            PRIMARY KEY (tournamentId),
            FOREIGN KEY (seasonId)
						REFERENCES Season(seasonId),
			CHECK(startDate != endDate));
DESCRIBE Tournament;
CREATE TABLE Ranking
			(rankNumber INT,
            teamId VARCHAR(20),
            PRIMARY KEY (rankNumber),
            FOREIGN KEY (teamId)
						REFERENCES Team(teamId),
			CHECK (rankNumber > 0));
DESCRIBE Ranking;
CREATE TABLE TournamentRanking
			(tournamentId VARCHAR(20),
			seasonId VARCHAR(20),
            rankNumber INT,
            PRIMARY KEY (tournamentId, seasonId),
            FOREIGN KEY (tournamentId)
						REFERENCES Tournament(tournamentId),
			FOREIGN KEY (seasonId)
						REFERENCES Season(seasonId),
			FOREIGN KEY (rankNumber)
						REFERENCES Ranking(rankNumber));
DESCRIBE TournamentRanking;



CREATE TABLE Player
			(playerId VARCHAR(20),
            firstName VARCHAR(35),
            lastName VARCHAR(35),
            position VARCHAR(35),
            nationality VARCHAR(25),
            teamId VARCHAR(20),
            PRIMARY KEY (playerId),
            FOREIGN KEY (teamId)
						REFERENCES Team(teamId),
			CHECK (position IN ('GOALKEEPER', 'DEFENDER', 'MIDFIELDER', 'FORWARD')));
			
DESCRIBE Player;
CREATE TABLE PlayerStats
			(playerId VARCHAR(20),
            seasonId VARCHAR(20),
            goals INT,
            assists INT,
            tackles INT,
            shots INT,
            fouls INT,
            PRIMARY KEY (playerId, seasonId),
            FOREIGN KEY (playerId)
						REFERENCES Player(playerId),
			FOREIGN KEY (seasonId)
						REFERENCES Season(seasonId));
DESCRIBE PlayerStats;
CREATE TABLE PlayerInjury
			(playerId VARCHAR(20),
            newsId VARCHAR(20),
            expectedRecoveryTime DATE NOT NULL,
            injuryType VARCHAR(30),
            injuryDate DATE,
            PRIMARY KEY (playerId, newsId),
            FOREIGN KEY (playerId)
						REFERENCES Player(playerId),
			FOREIGN KEY (newsId)
						REFERENCES News(newsId),
			CHECK (injuryType IN ('UPPER', 'LOWER', 'HEAD')));
DESCRIBE PlayerInjury;
CREATE TABLE FantasyRoster
			(fantasyTeamId VARCHAR(25),
			playerId VARCHAR(20),
			PRIMARY KEY (fantasyTeamId, playerId),
			FOREIGN KEY (fantasyTeamId)
						REFERENCES FantasyTeam(fantasyTeamId),
			FOREIGN KEY (playerId)
						REFERENCES Player(playerId));
DESCRIBE FantasyRoster;


CREATE TABLE Trade
			(tradeId VARCHAR(20),
            playerId VARCHAR(20),
            oldTeam VARCHAR(20) NOT NULL,
            newTeam VARCHAR(20) NOT NULL,
            PRIMARY KEY (tradeId),
            FOREIGN KEY (playerId)
						REFERENCES Player(playerId),
			FOREIGN KEY (oldTeam)
						REFERENCES Team(teamId),
			FOREIGN KEY (newTeam)
						REFERENCES Team(teamId),
			CHECK (oldTeam != newTeam));
DESCRIBE Trade;



CREATE TABLE Referee
			(refereeId VARCHAR(20),
            firstName VARCHAR(30),
            lastName VARCHAR(30),
            PRIMARY KEY (refereeId));
DESCRIBE Referee;
CREATE TABLE Location
			(locationId VARCHAR(20),
            city VARCHAR(30),
            stadium VARCHAR(30),
            PRIMARY KEY (locationId));
DESCRIBE Location;
CREATE TABLE SoccerMatch
			(matchId VARCHAR(20),
            teamAId VARCHAR(20),
            teamBId VARCHAR(20),
            refereeId VARCHAR(20),
            seasonId VARCHAR(20),
            locationId VARCHAR(20),
            startDate DATE,
            PRIMARY KEY (matchId),
            FOREIGN KEY (teamAId)
						REFERENCES Team(teamId),
			FOREIGN KEY (teamBId)
						REFERENCES Team(teamId),
			FOREIGN KEY (refereeId)
						REFERENCES Referee(refereeId),
			FOREIGN KEY (locationId)
						REFERENCES Location(locationId));
DESCRIBE SoccerMatch;
CREATE TABLE MatchStats
			(matchId VARCHAR(20),
            teamId VARCHAR(20),
            goals INT,
            shotsOnTarget INT,
            shots INT,
            fouls INT,
            corner INT,
            PRIMARY KEY (matchId, teamId),
            FOREIGN KEY (matchId)
						REFERENCES SoccerMatch(matchId),
			FOREIGN KEY (teamId)
						REFERENCES Team(teamId));
DESCRIBE MatchStats;
CREATE TABLE MatchProbabilities
			(matchId VARCHAR(20),
            probTeamAWinning DOUBLE,
            probTeamBWinning DOUBLE,
            probDraw DOUBLE,
            PRIMARY KEY (matchId),
            FOREIGN KEY (matchId)
						REFERENCES SoccerMatch(matchId));
DESCRIBE MatchProbabilities;






