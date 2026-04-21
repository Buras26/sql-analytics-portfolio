SELECT DISTINCT
    a.full_name,
    a.nationality,
    s.sport_name
FROM analytics.athletes a
JOIN analytics.performance_stats ps 
    ON ps.athlete_id = a.athlete_id
   AND ps.season_year = 2023
JOIN analytics.sports s 
    ON s.sport_id = ps.sport_id
ORDER BY s.sport_name, a.full_name;


SELECT
    a.full_name,
    a.nationality,
    s.sport_name,
    ey.total_earnings,
    ey.on_field_earnings,
    ey.off_field_earnings,
    ey.forbes_rank
FROM analytics.athletes a
JOIN analytics.earnings_yearly ey
    ON ey.athlete_id = a.athlete_id
   AND ey.year = 2023
JOIN analytics.performance_stats ps
    ON ps.athlete_id = a.athlete_id
   AND ps.season_year = 2023
JOIN analytics.sports s
    ON s.sport_id = ps.sport_id
ORDER BY ey.total_earnings DESC;



SELECT
    e.brand_name,
    e.category,
    e.deal_value_usd,
    e.contract_status,
    e.is_exclusive,
    a.full_name        AS athlete,
    a.nationality,
    am.agent_name,
    am.agency_name,
    am.commission_rate
FROM analytics.endorsements e
JOIN analytics.athletes a
    ON a.athlete_id = e.athlete_id
JOIN analytics.agent_managers am
    ON am.athlete_id = a.athlete_id
WHERE e.contract_status = 'active'
ORDER BY e.deal_value_usd DESC NULLS LAST;



SELECT
    a.athlete_id,
    a.full_name,
    a.nationality,
    a.is_active,
    ey.year,
    ey.total_earnings,
    ey.forbes_rank,
    CASE
        WHEN ey.earning_id IS NULL THEN 'No 2024 data'
        ELSE 'Ranked'
    END                AS data_status
FROM analytics.athletes a
LEFT JOIN analytics.earnings_yearly ey
    ON ey.athlete_id = a.athlete_id
   AND ey.year = 2024
ORDER BY ey.forbes_rank ASC NULLS LAST;

SELECT 
	*
FROM analytics.performance_stats;

DROP COLUMN notes, 