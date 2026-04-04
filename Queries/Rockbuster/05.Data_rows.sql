SELECT 
  COUNT(*) 
FROM analytics._stg_rockbuster; 

-- 80.115

SELECT 
  COUNT(DISTINCT customer_email)
FROM analytics._stg_rockbuster;

-- 599
SELECT 
  COUNT(DISTINCT title)
FROM analytics._stg_rockbuster;

-- 955

SELECT 
  COUNT(DISTINCT actor_first_name || actor_last_name)
FROM analytics._stg_rockbuster;

-- 199