COPY analytics._stg_rockbuster
FROM '/docker-entrypoint-initdb.d/data/rockbuster/rockbuster_denormalized.csv'
CSV HEADER
NULL 'NULL';

