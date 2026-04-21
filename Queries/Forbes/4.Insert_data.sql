
COPY analytics.agent_managers
FROM '/docker-entrypoint-initdb.d/data/Forbes/agent_managers.csv'
CSV HEADER
NULL 'NULL';

SELECT *
FROM analytics.agent_managers;


COPY analytics.athletes
FROM '/docker-entrypoint-initdb.d/data/Forbes/athletes.csv'
CSV HEADER
NULL 'NULL';

SELECT *
FROM analytics.athletes;

COPY analytics.awards
FROM '/docker-entrypoint-initdb.d/data/forbes/awards.csv'
CSV HEADER 
NULL '';


SELECT *
FROM analytics.awards;


ALTER TABLE analytics.contracts 
ALTER COLUMN team_id DROP NOT NULL;


COPY analytics.contracts
FROM '/docker-entrypoint-initdb.d/data/Forbes/contracts.csv'
CSV HEADER
NULL '';

SELECT *
FROM analytics.contracts;



COPY analytics.earnings_yearly
FROM '/docker-entrypoint-initdb.d/data/Forbes/earnings_yearly.csv'
CSV HEADER
NULL 'NULL';


SELECT *
FROM analytics.earnings_yearly;

COPY analytics.endorsements
FROM '/docker-entrypoint-initdb.d/data/Forbes/endorsements.csv'
CSV HEADER
NULL '';

SELECT *
FROM analytics.endorsements;

COPY analytics.performance_stats
FROM '/docker-entrypoint-initdb.d/data/Forbes/performance_stats.csv'
CSV HEADER
NULL 'NULL';

SELECT *
FROM analytics.performance_stats;

COPY analytics.social_media
FROM '/docker-entrypoint-initdb.d/data/Forbes/social_media.csv'
CSV HEADER
NULL 'NULL';

SELECT *
FROM analytics.social_media;

COPY analytics.sports
FROM '/docker-entrypoint-initdb.d/data/Forbes/sports.csv'
CSV HEADER
NULL 'NULL';


SELECT *
FROM analytics.sports;


COPY analytics.teams
FROM '/docker-entrypoint-initdb.d/data/Forbes/teams.csv'
CSV HEADER
NULL 'NULL';


SELECT	
	*
FROM analytics.teams;


TRUNCATE analytics.performance_stats;

COPY analytics.performance_stats
FROM '/docker-entrypoint-initdb.d/data/Forbes/performance_stats.csv'
CSV HEADER NULL '';

