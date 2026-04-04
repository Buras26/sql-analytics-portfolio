CREATE OR REPLACE FUNCTION fn_age_group (
    p_age INT
)
RETURNS TEXT
LANGUAGE sql
AS $$
    SELECT
        CASE
            WHEN p_age < 25 THEN 'Under 25'
            WHEN p_age BETWEEN 25 AND 39 THEN '25–39'
            WHEN p_age BETWEEN 40 AND 59 THEN '40–59'
            ELSE '60+'
        END;
$$;

SELECT
    customer_id,
    age,
    fn_age_group(age) AS age_group
FROM analytics.customers;

			-- CLASS WORK


CREATE OR REPLACE FUNCTION fn_nationality 
	(country_name TEXT)
RETURNS TEXT
LANGUAGE sql
AS $$
    SELECT
		CASE
			WHEN country_name = 'Armenia' THEN 'hay'
			WHEN country_name = 'Georgia' THEN 'vraci'
			ELSE 'Other'
		END
	
  	;
$$;

SELECT
	c.customer_id,
	co.country_name,
	fn_nationality(co.country_name) as nationality
FROM analytics.customers c
	LEFT JOIN analytics.cities ci ON c.city_id = ci.city_id
	LEFT JOIN analytics.regions r ON ci.region_id = r.region_id
	LEFT JOIN analytics.countries co ON r.country_id = co.country_id;






CREATE OR REPLACE FUNCTION fn_customers_by_natinality
	(p_nationality TEXT)
RETURNS
	(number_of_customers INT)
LANGUAGE sql
AS $$
    SELECT
		CASE
			WHEN country_name = 'Armenia' THEN 'hay'
			WHEN country_name = 'Georgia' THEN 'vraci'
			ELSE 'Other'
		END
SELECT 
	count(*) AS number_of_customers
FROM analytics.customers c
	LEFT JOIN analytics.cities ci ON c.city_id = ci.city_id
	LEFT JOIN analytics.regions r ON ci.region_id = r.region_id
	LEFT JOIN analytics.countries co ON r.country_id = co.country_id
WHERE fn_get_nationality(co.country_name) = p.nationality;

$$;


SELECT *
FROM fn_customers_by_natinality


CREATE OR REPLACE FUNCTION fn_customers_by_nationality (
    p_nationality TEXT
   
)
RETURNS TABLE (
    number_of_customers INT
   
)
LANGUAGE sql
AS $$
    SELECT 
	
		count(*) as number_of_customers
		-- cou.city_id
	FROM analytics.customers cust
	LEFT JOIN analytics.cities ci on (cust.city_id = ci.city_id)
	LEFT JOIN analytics.regions r on (ci.region_id = r.region_id)
	LEFT JOIN analytics.countries cou on (r.country_id = cou.country_id)
	WHERE analytics.fn_nationality(cou.country_name) = p_nationality
$$;



SELECT * FROM fn_customers_by_nationality('Armenian')




















