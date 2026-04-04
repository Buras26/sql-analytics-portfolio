DROP EXTENSION IF EXISTS postgis CASCADE;
CREATE EXTENSION postgis;
SELECT PostGIS_Version();

			-- COUNTRY
			
DROP TABLE IF EXISTS analytics.country CASCADE;

CREATE TABLE analytics.country (
    country_id SERIAL PRIMARY KEY, --autoincrement
    country_name VARCHAR(50) UNIQUE NOT NULL
    -- geometry 
);



INSERT INTO analytics.country (country_name)
SELECT 
  DISTINCT 
  a.customer_country,
  b.geometry
FROM analytics._stg_rockbuster a
LEFT JOIN analytics._stg_countries b on (a.country_name=b.country_name)
WHERE customer_country IS NOT NULL;



			-- COUNTRY BOUNDERIES
			
CREATE TABLE analytics._stg_world_countries (
    country_name TEXT NOT NULL,
    country_code TEXT NOT NULL,
    geom geometry(MULTIPOLYGON, 4326) NOT NULL
);

INSERT INTO analytics._stg_world_countries (country_name, country_code, geom)
SELECT
    feature->'properties'->>'name' AS country_name,
    feature->>'id' AS country_code,
    ST_SetSRID(
        ST_Multi(
            ST_CollectionExtract(
                ST_Force2D(
                    ST_MakeValid(
                        ST_GeomFromGeoJSON(feature->>'geometry')
                    )
                ),
            3)
        ),
        4326
    ) AS geom
FROM (
    SELECT jsonb_array_elements(data->'features') AS feature
    FROM (
        SELECT pg_read_file('/docker-entrypoint-initdb.d/data/rockbuster/countries.geo.json')::jsonb AS data
    ) f
) sub;

SELECT 
    * 
FROM analytics._stg_world_countries 
LIMIT 10


			-- CITY
		

DROP TABLE IF EXISTS analytics.city CASCADE;

CREATE TABLE analytics.city (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(50) NOT NULL,
    country_id INT REFERENCES analytics.country(country_id),
    UNIQUE (city_name, country_id)
);


INSERT INTO analytics.city (city_name, country_id)
SELECT DISTINCT
    s.customer_city,
    c.country_id
FROM analytics._stg_rockbuster s
JOIN analytics.country c
  ON c.country_name = s.customer_country;


SELECT 
    * 
FROM analytics.city 
LIMIT 10


			-- ADDRESS
			
DROP TABLE IF EXISTS analytics.address CASCADE;

CREATE TABLE analytics.address (
    address_id SERIAL PRIMARY KEY,
    address VARCHAR(50),
    address2 VARCHAR(50),
    district VARCHAR(20),
    postal_code VARCHAR(10),
    phone VARCHAR(20),
    city_id INT REFERENCES analytics.city(city_id),
    UNIQUE(address, postal_code, city_id)
);


INSERT INTO analytics.address (
    address,
    address2,
    district,
    postal_code,
    phone,
    city_id
)
SELECT DISTINCT
    s.customer_address,
    s.customer_address2,
    s.customer_district,
    s.customer_postal_code,
    s.customer_phone,
    c.city_id
FROM analytics._stg_rockbuster s
JOIN analytics.city c
  ON c.city_name = s.customer_city;


SELECT 
    * 
FROM analytics.address 
LIMIT 10


			-- CUSTOMER

DROP TABLE IF EXISTS analytics.customer CASCADE;

CREATE TABLE analytics.customer (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    email VARCHAR(50) UNIQUE,
    active BOOLEAN,
    create_date DATE,
    address_id INT REFERENCES analytics.address(address_id)
);


INSERT INTO analytics.customer (
    first_name,
    last_name,
    email,
    active,
    create_date,
    address_id
)
SELECT DISTINCT
    s.customer_first_name,
    s.customer_last_name,
    s.customer_email,
    s.customer_active,
    s.customer_create_date,
    a.address_id
FROM analytics._stg_rockbuster s
JOIN analytics.address a
  ON a.address = s.customer_address;


SELECT 
    * 
FROM analytics.customer 
LIMIT 10

		-- LANGUAGE
		
DROP TABLE IF EXISTS analytics.language CASCADE;

CREATE TABLE analytics.language (
    language_id SERIAL PRIMARY KEY,
    language_name VARCHAR(20) UNIQUE
);


INSERT INTO analytics.language (language_name)
SELECT DISTINCT language_name
FROM analytics._stg_rockbuster;


SELECT 
    * 
FROM analytics.language 
LIMIT 10


				-- FILM

DROP TABLE IF EXISTS analytics.film CASCADE;

CREATE TABLE analytics.film (
    film_id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    release_year INT,
    rental_duration INT,
    rental_rate NUMERIC(4,2),
    length INT,
    replacement_cost NUMERIC(5,2),
    rating VARCHAR(10),
    language_id INT REFERENCES analytics.language(language_id),
    UNIQUE(title, release_year)
);



INSERT INTO analytics.film (
    title,
    description,
    release_year,
    rental_duration,
    rental_rate,
    length,
    replacement_cost,
    rating,
    language_id
)
SELECT DISTINCT
    s.title,
    s.description,
    s.release_year,
    s.rental_duration,
    s.rental_rate,
    s.length,
    s.replacement_cost,
    s.rating,
    l.language_id
FROM analytics._stg_rockbuster s
JOIN analytics.language l
  ON l.language_name = s.language_name;


SELECT 
    * 
FROM analytics.film
LIMIT 10


			-- CATEGORY
			
DROP TABLE IF EXISTS analytics.category CASCADE;

CREATE TABLE analytics.category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(25) UNIQUE
);


INSERT INTO analytics.category (category_name)
SELECT DISTINCT category_name
FROM analytics._stg_rockbuster;


SELECT 
    * 
FROM analytics.category
LIMIT 10



			-- ACTOR

DROP TABLE IF EXISTS analytics.actor CASCADE;

CREATE TABLE analytics.actor (
    actor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    UNIQUE(first_name, last_name)
);


INSERT INTO analytics.actor (first_name, last_name)
SELECT DISTINCT
    actor_first_name,
    actor_last_name
FROM analytics._stg_rockbuster;


SELECT 
    * 
FROM analytics.actor
LIMIT 10


		-- FILM CATEGORY BRIDGE

DROP TABLE IF EXISTS analytics.film_category;

CREATE TABLE analytics.film_category (
    film_id INT REFERENCES analytics.film(film_id),
    category_id INT REFERENCES analytics.category(category_id),
    PRIMARY KEY (film_id, category_id)
);


INSERT INTO analytics.film_category
SELECT DISTINCT
    f.film_id,
    c.category_id
FROM analytics._stg_rockbuster s
JOIN analytics.film f
  ON f.title = s.title
JOIN analytics.category c
  ON c.category_name = s.category_name;

SELECT 
    * 
FROM analytics.film_category
LIMIT 10


		-- FILM ACTOR BRIDGE

DROP TABLE IF EXISTS analytics.film_actor;

CREATE TABLE analytics.film_actor (
    film_id INT REFERENCES analytics.film(film_id),
    actor_id INT REFERENCES analytics.actor(actor_id),
    PRIMARY KEY (film_id, actor_id)
);


INSERT INTO analytics.film_actor
SELECT DISTINCT
    f.film_id,
    a.actor_id
FROM analytics._stg_rockbuster s
JOIN analytics.film f
  ON f.title = s.title
JOIN analytics.actor a
  ON a.first_name = s.actor_first_name
 AND a.last_name  = s.actor_last_name;


SELECT 
    * 
FROM analytics.film_actor
LIMIT 10


		-- STORE

DROP TABLE IF EXISTS analytics.store CASCADE;

CREATE TABLE analytics.store (
    store_id SERIAL PRIMARY KEY,
    store_number INT UNIQUE
);


INSERT INTO analytics.store (store_number)
SELECT DISTINCT store_number
FROM analytics._stg_rockbuster;


SELECT 
    * 
FROM analytics.store
LIMIT 10


			-- STAFF
			
DROP TABLE IF EXISTS analytics.staff CASCADE;

CREATE TABLE analytics.staff (
    staff_id SERIAL PRIMARY KEY,
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    email VARCHAR(50),
    store_id INT REFERENCES analytics.store(store_id)
);

INSERT INTO analytics.staff (
    first_name,
    last_name,
    email,
    store_id
)
SELECT DISTINCT
    s.staff_first_name,
    s.staff_last_name,
    s.staff_email,
    st.store_id
FROM analytics._stg_rockbuster s
JOIN analytics.store st
  ON st.store_number = s.store_number;


SELECT 
    * 
FROM analytics.staff
LIMIT 10


			-- RENTAL


DROP TABLE IF EXISTS analytics.rental CASCADE;

CREATE TABLE analytics.rental (
    rental_id SERIAL PRIMARY KEY,
    rental_date TIMESTAMP,
    return_date TIMESTAMP,
    customer_id INT REFERENCES analytics.customer(customer_id),
    film_id INT REFERENCES analytics.film(film_id),
    staff_id INT REFERENCES analytics.staff(staff_id)
);



INSERT INTO analytics.rental (
    rental_date,
    return_date,
    customer_id,
    film_id,
    staff_id
)
SELECT DISTINCT
    s.rental_date,
    s.return_date,
    c.customer_id,
    f.film_id,
    st.staff_id
FROM analytics._stg_rockbuster s
JOIN analytics.customer c ON c.email = s.customer_email
JOIN analytics.film f ON f.title = s.title
JOIN analytics.staff st ON st.email = s.staff_email;


SELECT 
    * 
FROM analytics.rental
LIMIT 10


				-- PAYMENT

DROP TABLE IF EXISTS analytics.payment CASCADE;

CREATE TABLE analytics.payment (
    payment_id SERIAL PRIMARY KEY,
    rental_id INT REFERENCES analytics.rental(rental_id),
    amount NUMERIC(5,2),
    payment_date TIMESTAMP
);


INSERT INTO analytics.payment (
    rental_id,
    amount,
    payment_date
)
SELECT DISTINCT
    r.rental_id,
    s.amount,
    s.payment_date
FROM analytics._stg_rockbuster s
JOIN analytics.rental r
  ON r.rental_date = s.rental_date;


SELECT 
    * 
FROM analytics.payment
LIMIT 10



SELECT COUNT(*) FROM analytics.customer;
SELECT COUNT(*) FROM analytics.film;
SELECT COUNT(*) FROM analytics.actor;
SELECT COUNT(*) FROM analytics.rental;
SELECT COUNT(*) FROM analytics.payment;


