DROP TABLE IF EXISTS analytics.sports CASCADE;

CREATE TABLE analytics.sports (
    sport_id     SMALLINT     PRIMARY KEY,
    sport_name   VARCHAR(50)  NOT NULL UNIQUE,
    category     VARCHAR(10)  NOT NULL CHECK (category IN ('team','individual')),
    avg_career_years INT      NOT NULL CHECK (avg_career_years > 0),
    global_popularity_score FLOAT NOT NULL CHECK (global_popularity_score BETWEEN 0 AND 10)
);

SELECT
	*
FROM analytics.sports;




CREATE TABLE analytics.athletes (
    athlete_id   INT          PRIMARY KEY,
    full_name    VARCHAR(100) NOT NULL,
    birth_date   DATE         NOT NULL,
    nationality  VARCHAR(50)  NOT NULL,
    gender       CHAR(1)      NOT NULL CHECK (gender IN ('M','F')),
    is_active    BOOLEAN      NOT NULL DEFAULT TRUE,
    profile_bio  TEXT
);


SELECT
	*
FROM analytics.athletes;



CREATE TABLE analytics.teams (
    team_id          INT          PRIMARY KEY,
    team_name        VARCHAR(100) NOT NULL,
    sport_id         SMALLINT     NOT NULL REFERENCES analytics.sports(sport_id),
    country          VARCHAR(50)  NOT NULL,
    city             VARCHAR(50)  NOT NULL,
    founded_year     INT          CHECK (founded_year BETWEEN 1800 AND 2025),
    market_value_usd BIGINT,
    is_active        BOOLEAN      NOT NULL DEFAULT TRUE
);

SELECT
	*
FROM analytics.teams;



CREATE TABLE analytics.contracts (
    contract_id        INT          PRIMARY KEY,
    athlete_id         INT          NOT NULL REFERENCES analytics.athletes(athlete_id),
    team_id            INT          REFERENCES analytics.teams(team_id),
    start_date         DATE         NOT NULL,
    end_date           DATE,
    base_salary_usd    NUMERIC(15,2) NOT NULL CHECK (base_salary_usd >= 0),
    signing_bonus      NUMERIC(15,2) DEFAULT 0,
    performance_clauses TEXT,
    contract_type      VARCHAR(30)  NOT NULL DEFAULT 'standard'
                                    CHECK (contract_type IN ('standard','rookie','max','supermax','veteran','endorsement-linked'))
);


SELECT
	*
FROM analytics.contracts;



CREATE TABLE analytics.earnings_yearly (
    earning_id        INT          PRIMARY KEY,
    athlete_id        INT          NOT NULL REFERENCES analytics.athletes(athlete_id),
    year              INT          NOT NULL CHECK (year BETWEEN 2015 AND 2025),
    on_field_earnings NUMERIC(15,2) NOT NULL,
    off_field_earnings NUMERIC(15,2) NOT NULL,
    total_earnings    NUMERIC(15,2) NOT NULL,
    forbes_rank       INT          CHECK (forbes_rank BETWEEN 1 AND 200),
    currency          CHAR(3)      NOT NULL DEFAULT 'USD',
    UNIQUE (athlete_id, year)
);


SELECT
	*
FROM analytics.earnings_yearly;



CREATE TABLE analyticsendorsements (
    endorsement_id  INT           PRIMARY KEY,
    athlete_id      INT           NOT NULL REFERENCES athletes(athlete_id),
    brand_name      VARCHAR(100)  NOT NULL,
    deal_value_usd  NUMERIC(15,2),
    start_date      DATE          NOT NULL,
    end_date        DATE,
    category        VARCHAR(50),
    is_exclusive    BOOLEAN       DEFAULT FALSE,
    contract_status VARCHAR(20)   NOT NULL DEFAULT 'active'
                                  CHECK (contract_status IN ('active','expired','terminated','pending'))
);


SELECT
	*
FROM analytics.endorsements;



CREATE TABLE analytics.performance_stats (
    stat_id           INT        PRIMARY KEY,
    athlete_id        INT        NOT NULL,
    season_year       INT        NOT NULL,
    sport_id          SMALLINT   NOT NULL,
    games_played      INT,
    wins              INT,
    losses            INT,
    score_metric      FLOAT,
    mvp_awards        INT        DEFAULT 0,
    championship_wins INT        DEFAULT 0,
    injury_days       INT        DEFAULT 0,
    notes             TEXT,
    UNIQUE (athlete_id, season_year)
);


SELECT
	*
FROM analytics.performance_stats;


CREATE TABLE analytics.social_media (
    social_id              INT           PRIMARY KEY,
    athlete_id             INT           NOT NULL,
    platform               VARCHAR(30)   NOT NULL,
    followers_count        BIGINT        NOT NULL CHECK (followers_count >= 0),
    avg_engagement_rate    DECIMAL(5,3),
    posts_per_month        INT,
    verified               BOOLEAN       NOT NULL DEFAULT TRUE,
    joined_date            DATE,
    estimated_post_value_usd NUMERIC(12,2)
);


SELECT
	*
FROM analytics.social_media;


CREATE TABLE analytics.awards (
    award_id        INT          PRIMARY KEY,
    athlete_id      INT          NOT NULL,
    award_name      VARCHAR(100) NOT NULL,
    awarding_body   VARCHAR(100),
    year_awarded    INT          NOT NULL CHECK (year_awarded BETWEEN 1980 AND 2025),
    award_category  VARCHAR(50),
    prize_money     NUMERIC(12,2),
    is_international BOOLEAN     NOT NULL DEFAULT FALSE
);


SELECT
	*
FROM analytics.awards;


CREATE TABLE analytics.agent_managers (
    agent_id           INT          PRIMARY KEY,
    athlete_id         INT          NOT NULL,
    agent_name         VARCHAR(100) NOT NULL,
    agency_name        VARCHAR(100),
    commission_rate    DECIMAL(4,2) CHECK (commission_rate BETWEEN 0 AND 25),
    contract_start     DATE         NOT NULL,
    years_represented  INT,
    total_deals_managed INT         DEFAULT 0,
    email              VARCHAR(100)
);


SELECT
	*
FROM analytics.agent_managers;