import random
from datetime import date, timedelta
import mysql.connector
from faker import Faker

# clip off any characters that go above the length limit of the attribute
def clip(text, max_len):
    if text is None:
        return ""
    # if the text is under the limit
    if len(text) <= max_len:
        # just return the original text
        return text
    # or else only include the characters from the beginning to the max length limit using substrings
    return text[:max_len]

# Id generator
# add a prefix letter depending on the table and a width which is padding the string with 0's
def rid(prefix, i, width):
    return f"{prefix}{str(i).zfill(width)}"

# picks a random date between 2 start and end dates
def random_date_between(start, end):
    # if start date is greater than end date
    if start >= end:
        # return the start date
        return start
    # get the difference in time between the two dates in days
    days = (end - start).days
    # begin from the starting date and choose a random amount of days to shift to get a random date
    return start + timedelta(days=random.randint(0, days))

# main program
def main():
    # credentials to login into server database
    HOST = "127.0.0.1"
    PORT = 3306
    USER = "root"
    PASSWORD = "password"
    DATABASE = "FantasySoccer"
    # setting the amount of tuples in each relation
    NUM_LEAGUES = 6
    NUM_SEASONS = 5
    NUM_TEAMS = 60
    PLAYERS_PER_TEAM = 26
    NUM_USERS = 1200
    NUM_FANTASY_TEAMS = 2500
    NUM_LOCATIONS = 80
    NUM_REFEREES = 120
    NUM_NEWS = 600
    NUM_TOURNAMENTS = 20
    NUM_ADS = 500
    NUM_TRADES = 600
    NUM_PLAYER_INJURIES = 500
    NUM_RANKS = 120
    NUM_MATCHES = 4000
    # initializing the seed for randomness
    random.seed(7)
    fake = Faker()
    fake.seed_instance(7)
    # connect to the database
    conn = mysql.connector.connect(
        host=HOST,
        port=PORT,
        user=USER,
        password=PASSWORD,
        database=DATABASE,
    )
    # cursor object created
    cur = conn.cursor()
    # execute the USE command in SQL to start using the database
    cur.execute(f"USE {DATABASE}")

    # League
    # store the ids to use them later in other tables to insert them into foreign keys
    # to preserve referential integrity
    league_ids = []
    # store the tuples in an array
    league_rows = []
    # iterate through the number of tuples in the relation
    for i in range(1, NUM_LEAGUES + 1):
        # generate a random id using the function created above
        lid = rid("L", i, 4)
        # add it to the ids array
        league_ids.append(lid)
        # create a random tuple using faker information and append it to the array
        league_rows.append((lid, clip(fake.company(), 25), 1 if random.random() < 0.7 else 0))
        # execute the INSERT sql command
        # use executemany to execute multiple commands continuously
    cur.executemany(
        "INSERT INTO `League` (leagueId, leagueName, isActive) VALUES (%s, %s, %s)",
        league_rows,
    )
    conn.commit()

    # Season
    # store the ids to use them later in other tables to insert them into foreign keys
    # to preserve referential integrity
    base_year = 2020
    season_ids = []
    # store the tuples in an array
    season_rows = []
    # iterate through the number of tuples in the relation
    for i in range(1, NUM_SEASONS + 1):
        # generate a random id using the function created above
        sid = rid("S", i, 4)
        year = base_year + i
        # generate a start and end date
        start_date = date(year, 1, 1)
        end_date = date(year, 12, 31)
        # append the ids
        season_ids.append(sid)
        # append the tuple into the array
        season_rows.append((sid, year, start_date, end_date))
        # execute the INSERT sql command
        # use executemany to execute multiple commands continuously
    cur.executemany(
        "INSERT INTO `Season` (seasonId, year, startDate, endDate) VALUES (%s, %s, %s, %s)",
        season_rows,
    )
    conn.commit()

    # Team
    # store the ids to use them later in other tables to insert them into foreign keys
    # to preserve referential integrity
    team_ids = []
    # store the tuples in an array
    team_rows = []
    # iterate through the number of tuples in the relation
    for i in range(1, NUM_TEAMS + 1):
        # generate a random id using the function created above
        tid = rid("T", i, 5)
        # append the id into ids array
        team_ids.append(tid)
        # append the tuple into the tuples array
        team_rows.append(
            (
                tid,
                clip(fake.company(), 25),
                clip(fake.first_name(), 20),
                clip(fake.last_name(), 20),
                clip(fake.city(), 15),
            )
        )
        # execute the INSERT sql command
        # use executemany to execute multiple commands continuously
    cur.executemany(
        "INSERT INTO `Team` (teamId, teamName, managerFirstName, managerLastName, homeCity) VALUES (%s, %s, %s, %s, %s)",
        team_rows,
    )
    conn.commit()

    # Location
    # store the ids to use them later in other tables to insert them into foreign keys
    # to preserve referential integrity
    location_ids = []
    # store the tuples in an array
    location_rows = []
    # iterate through the number of tuples in the relation
    for i in range(1, NUM_LOCATIONS + 1):
        # generate a random id using the function created above
        loc = rid("LOC", i, 4)
        # append the id into ids array
        location_ids.append(loc)
        # append the tuple into the tuples array
        location_rows.append((loc, clip(fake.city(), 30), clip(fake.company() + " Stadium", 30)))
        # execute the INSERT sql command
        # use executemany to execute multiple commands continuously
    cur.executemany(
        "INSERT INTO `Location` (locationId, city, stadium) VALUES (%s, %s, %s)",
        location_rows,
    )
    conn.commit()

    # Referee
    # store the ids to use them later in other tables to insert them into foreign keys
    # to preserve referential integrity
    referee_ids = []
    # store the tuples in an array
    referee_rows = []
    # iterate through the number of tuples in the relation
    for i in range(1, NUM_REFEREES + 1):
        # generate a random id using the function created above
        rid_ = rid("R", i, 5)
        # append the id into ids array
        referee_ids.append(rid_)
        # append the tuple into the tuples array
        referee_rows.append((rid_, clip(fake.first_name(), 30), clip(fake.last_name(), 30)))
        # execute the INSERT sql command
        # use executemany to execute multiple commands continuously
    cur.executemany(
        "INSERT INTO `Referee` (refereeId, firstName, lastName) VALUES (%s, %s, %s)",
        referee_rows,
    )
    conn.commit()

    # Users
    # store the ids to use them later in other tables to insert them into foreign keys
    # to preserve referential integrity
    usernames = []
    # store the tuples in an array
    user_rows = []
    # iterate through the number of tuples in the relation
    for i in range(1, NUM_USERS + 1):
        # generate a random username using the function created above
        uname = f"user{str(i).zfill(5)}"
        # append the username into ids array
        usernames.append(uname)
        # generate a hashed password
        pwd_hash = fake.sha256()
        # append the tuple into the array
        user_rows.append((uname, pwd_hash))
        # execute the INSERT sql command
        # use executemany to execute multiple commands continuously
    cur.executemany("INSERT INTO `User` (username, passwordHash) VALUES (%s, %s)", user_rows)
    conn.commit()

    # UserRole
    # store the tuples in an array
    roles = []
    # iterate through the number of tuples in the relation
    for uname in usernames:
        # randomly pick either USER or ADMIN as the role
        role = "ADMIN" if random.random() < 0.1 else "USER"
        # add it to the tuples array
        roles.append((uname, role))
        # execute the INSERT sql command
        # use executemany to execute multiple commands continuously
    cur.executemany(
        "INSERT INTO `UserRole` (username, role) VALUES (%s, %s)",
        roles,
    )
    conn.commit()

    # UserPreferences
    # store the tuples in an array
    userpref_rows = []
    # iterate through the number of usernames there are in User table
    for uname in usernames:
        # add the username as a foreign key and a random choice of a teamId
        userpref_rows.append((uname, random.choice(team_ids)))
        # execute the INSERT sql command
        # use executemany to execute multiple commands continuously
    cur.executemany(
        "INSERT INTO `UserPreferences` (username, teamId) VALUES (%s, %s)",
        userpref_rows,
    )
    conn.commit()

    # FantasyTeam
    # store the tuples in an array
    fantasy_rows = []
    # iterate through the number of tuples in the relation
    for i in range(1, NUM_FANTASY_TEAMS + 1):
        ftid = rid("FT", i, 6)
        fantasy_rows.append((ftid, clip(f"FT {fake.word()} {i}", 35), random.choice(usernames)))
        # execute the INSERT sql command
        # use executemany to execute multiple commands continuously
    cur.executemany(
        "INSERT INTO `FantasyTeam` (fantasyTeamId, teamName, username) VALUES (%s, %s, %s)",
        fantasy_rows,
    )
    conn.commit()

    # LeagueTeams
    league_teams_rows = []
    for i, tid in enumerate(team_ids):
        league_teams_rows.append((league_ids[i % len(league_ids)], tid))
    cur.executemany(
        "INSERT INTO `LeagueTeams` (leagueId, teamId) VALUES (%s, %s)",
        league_teams_rows,
    )
    conn.commit()

    # SeasonManagement
    season_mgmt_rows = []
    for sid in season_ids:
        for lid in league_ids:
            season_mgmt_rows.append((sid, lid))
    cur.executemany(
        "INSERT INTO `SeasonManagement` (seasonId, leagueId) VALUES (%s, %s)",
        season_mgmt_rows,
    )
    conn.commit()

    # TeamStats
    team_stats_rows = []
    for sid in season_ids:
        for tid in team_ids:
            # pick a random number between 0 and 30 for each wins, losses and between 0 and 10 for ties
            wins = random.randint(0, 30)
            losses = random.randint(0, 30)
            ties = random.randint(0, 10)
            team_stats_rows.append((tid, sid, wins, losses, ties))
            # execute the INSERT sql command
            # use executemany to execute multiple commands continuously
    cur.executemany(
        "INSERT INTO `TeamStats` (teamId, seasonId, wins, losses, ties) VALUES (%s, %s, %s, %s, %s)",
        team_stats_rows,
    )
    conn.commit()

    # Players
    # store the 4 only values that can be stored for position attribute into an array
    positions = ["GOALKEEPER", "DEFENDER", "MIDFIELDER", "FORWARD"]
    # playerId stored to use later
    player_ids = []
    player_rows = []
    pid = 0
    for tid in team_ids:
        for _ in range(PLAYERS_PER_TEAM):
            pid += 1
            p = rid("P", pid, 6)
            player_ids.append(p)
            player_rows.append(
                (
                    p,
                    clip(fake.first_name(), 35),
                    clip(fake.last_name(), 35),
                    # randomly choose a posiiton from the position array
                    random.choice(positions),
                    clip(fake.country(), 25),
                    tid,
                )
            )
            # execute the INSERT sql command
            # use executemany to execute multiple commands continuously
    cur.executemany(
        "INSERT INTO `Player` (playerId, firstName, lastName, position, nationality, teamId) VALUES (%s, %s, %s, %s, %s, %s)",
        player_rows,
    )
    conn.commit()

    # PlayerStats
    player_stats_rows = []
    for p in player_ids:
        for sid in season_ids:
            # pick numbers between a range
            shots = random.randint(0, 100)
            sot = random.randint(0, shots)
            goals = random.randint(0, sot)
            assists = random.randint(0, 30)
            tackles = random.randint(0, 100)
            fouls = random.randint(0, 40)
            player_stats_rows.append((p, sid, goals, assists, tackles, shots, fouls))
    cur.executemany(
        "INSERT INTO `PlayerStats` (playerId, seasonId, goals, assists, tackles, shots, fouls) VALUES (%s, %s, %s, %s, %s, %s, %s)",
        player_stats_rows,
    )
    conn.commit()

    # Ads
    ad_rows = []
    for i in range(1, NUM_ADS + 1):
        adid = rid("AD", i, 5)
        ad_rows.append(
            (
                # use faker to generate data
                adid,
                clip(fake.company(), 25),
                clip(fake.catch_phrase(), 45),
                round(random.uniform(100.0, 10000.0), 2),
                random.randint(1, 10),
            )
        )
        # execute the INSERT sql command
        # use executemany to execute multiple commands continuously
    cur.executemany(
        "INSERT INTO `Advertisement` (advertisementId, advertiserName, message, revenue, priority) VALUES (%s, %s, %s, %s, %s)",
        ad_rows,
    )
    conn.commit()

    # News
    news_ids = []
    news_rows = []
    for i in range(1, NUM_NEWS + 1):
        nid = rid("N", i, 5)
        y = random.choice([2021, 2022, 2023, 2024, 2025])
        d = random_date_between(date(y, 1, 1), date(y, 12, 31))
        headline = clip(" ".join(fake.words(nb=2)).title(), 15)
        desc = clip(fake.sentence(nb_words=6), 40)
        news_ids.append(nid)
        news_rows.append((nid, d, headline, desc))
        # execute the INSERT sql command
        # use executemany to execute multiple commands continuously
    cur.executemany(
        "INSERT INTO `News` (newsId, timeReleased, headline, description) VALUES (%s, %s, %s, %s)",
        news_rows,
    )
    conn.commit()

    # TeamEffect
    team_effect_rows = []
    seen_pairs = set()
    for nid in news_ids:
        link_count = random.randint(1, 3)
        picks = set()
        while len(picks) < link_count:
            picks.add(random.choice(team_ids))
        for tid in picks:
            key = (tid, nid)
            if key not in seen_pairs:
                seen_pairs.add(key)
                team_effect_rows.append((tid, nid))
    if len(team_effect_rows) > 0:
        cur.executemany(
            "INSERT INTO `TeamEffect` (teamId, newsId) VALUES (%s, %s)",
            team_effect_rows,
        )
        conn.commit()

    # Rankings
    ranking_rows = []
    for r in range(1, NUM_RANKS + 1):
        ranking_rows.append((r, random.choice(team_ids)))
    cur.executemany(
        "INSERT INTO `Ranking` (rankNumber, teamId) VALUES (%s, %s)",
        ranking_rows,
    )
    conn.commit()

    # Tournaments
    tournament_ids = []
    tournament_rows = []
    tournament_to_season = {}
    for i in range(1, NUM_TOURNAMENTS + 1):
        tid = rid("TRN", i, 4)
        sid = random.choice(season_ids)
        # get season range
        idx = season_ids.index(sid)
        s_year = season_rows[idx][1]
        s_start = date(s_year, 1, 1)
        s_end = date(s_year, 12, 31)
        t_start = random_date_between(s_start, s_end - timedelta(days=1))
        t_end = random_date_between(t_start + timedelta(days=1), s_end)
        t_name = clip(f"{fake.word().title()} Cup", 25)
        tournament_ids.append(tid)
        tournament_rows.append((tid, t_name, t_start, t_end, sid))
        tournament_to_season[tid] = sid
    cur.executemany(
        "INSERT INTO `Tournament` (tournamentId, tournamentName, startDate, endDate, seasonId) VALUES (%s, %s, %s, %s, %s)",
        tournament_rows,
    )
    conn.commit()

    # TournamentRanking
    tr_rows = []
    for tid in tournament_ids:
        sid = tournament_to_season[tid]
        rank = random.randint(1, NUM_RANKS)
        tr_rows.append((tid, sid, rank))
    cur.executemany(
        "INSERT INTO `TournamentRanking` (tournamentId, seasonId, rankNumber) VALUES (%s, %s, %s)",
        tr_rows,
    )
    conn.commit()

    # Trades
    trade_rows = []
    for i in range(1, NUM_TRADES + 1):
        trd = rid("TRD", i, 5)
        pid_ = random.choice(player_ids)
        old_t = random.choice(team_ids)
        new_t = random.choice(team_ids)
        while new_t == old_t:
            new_t = random.choice(team_ids)
        trade_rows.append((trd, pid_, old_t, new_t))
    cur.executemany(
        "INSERT INTO `Trade` (tradeId, playerId, oldTeam, newTeam) VALUES (%s, %s, %s, %s)",
        trade_rows,
    )
    conn.commit()

    # PlayerInjury
    injury_types = ["UPPER", "LOWER", "HEAD"]
    injury_rows = []
    seen_inj = set()
    while len(injury_rows) < NUM_PLAYER_INJURIES:
        p = random.choice(player_ids)
        n = random.choice(news_ids)
        key = (p, n)
        if key in seen_inj:
            continue
        seen_inj.add(key)
        n_idx = news_ids.index(n)
        news_date = news_rows[n_idx][1]
        inj_date = news_date
        expected = inj_date + timedelta(days=random.randint(7, 120))
        itype = random.choice(injury_types)
        injury_rows.append((p, n, expected, itype, inj_date))
    cur.executemany(
        "INSERT INTO `PlayerInjury` (playerId, newsId, expectedRecoveryTime, injuryType, injuryDate) VALUES (%s, %s, %s, %s, %s)",
        injury_rows,
    )
    conn.commit()

    # SoccerMatch
    match_ids = []
    match_rows = []
    for i in range(1, NUM_MATCHES + 1):
        mid = rid("M", i, 7)
        team_a = random.choice(team_ids)
        team_b = random.choice(team_ids)
        while team_b == team_a:
            team_b = random.choice(team_ids)
        ref = random.choice(referee_ids)
        sid = random.choice(season_ids)
        sidx = season_ids.index(sid)
        s_year = season_rows[sidx][1]
        s_start = date(s_year, 1, 1)
        s_end = date(s_year, 12, 31)
        start_dt = random_date_between(s_start, s_end)
        loc = random.choice(location_ids)
        match_ids.append(mid)
        match_rows.append((mid, team_a, team_b, ref, sid, loc, start_dt))
    cur.executemany(
        "INSERT INTO `SoccerMatch` (matchId, teamAId, teamBId, refereeId, seasonId, locationId, startDate) VALUES (%s, %s, %s, %s, %s, %s, %s)",
        match_rows,
    )
    conn.commit()

    # MatchStats 
    match_stats_rows = []
    for i, mid in enumerate(match_ids):
        team_a = match_rows[i][1]
        team_b = match_rows[i][2]

        shots_a = random.randint(0, 30)
        sot_a = random.randint(0, shots_a)
        goals_a = random.randint(0, sot_a)
        fouls_a = random.randint(0, 20)
        corners_a = random.randint(0, 10)
        match_stats_rows.append((mid, team_a, goals_a, sot_a, shots_a, fouls_a, corners_a))

        shots_b = random.randint(0, 30)
        sot_b = random.randint(0, shots_b)
        goals_b = random.randint(0, sot_b)
        fouls_b = random.randint(0, 20)
        corners_b = random.randint(0, 10)
        match_stats_rows.append((mid, team_b, goals_b, sot_b, shots_b, fouls_b, corners_b))
    cur.executemany(
        "INSERT INTO `MatchStats` (matchId, teamId, goals, shotsOnTarget, shots, fouls, corner) VALUES (%s, %s, %s, %s, %s, %s, %s)",
        match_stats_rows,
    )
    conn.commit()

    # MatchProbabilities
    match_prob_rows = []
    for mid in match_ids:
        a = random.random()
        b = random.random()
        c = random.random()
        s = a + b + c
        pa = a / s
        pb = b / s
        pd = c / s
        match_prob_rows.append((mid, pa, pb, pd))
    cur.executemany(
        "INSERT INTO `MatchProbabilities` (matchId, probTeamAWinning, probTeamBWinning, probDraw) VALUES (%s, %s, %s, %s)",
        match_prob_rows,
    )
    conn.commit()

    print("Done. Loaded data for updated schema (User.passwordHash, UserRole, Player.position, TeamStats.ties).")

    cur.close()
    conn.close()


if __name__ == "__main__":
    main()



