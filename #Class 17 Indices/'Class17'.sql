use sakila;

# 1. Create two or three queries using address table in sakila db:
#	include postal_code in where (try with in/not it operator)
#	eventually join the table with city/country tables.
#	measure execution time.
#	Then create an index for postal_code on address table.
#	measure execution time again and compare with the previous ones.
#	Explain the results

select a.address, a.postal_code, c.city, co.country
from address a
inner join city c on a.city_id = c.city_id
inner join country co on c.country_id = co.country_id
where a.postal_code in ('12345', '67890', '54321');
-- 0,0043 sec / 0,000028 sec

select a.address, a.postal_code, c.city, co.country
from address a
inner join city c on a.city_id = c.city_id
inner join country co on c.country_id = co.country_id
where a.postal_code not in ('12345', '67890', '54321');
-- 0,094 sec / 0,0046 sec

create index idx_postal_code on address (postal_code);

select a.address, a.postal_code, c.city, co.country
from address a
inner join city c on a.city_id = c.city_id
inner join country co on c.country_id = co.country_id
where a.postal_code in ('12345', '67890', '54321');
-- 0,0019 sec / 0,000023 sec

select a.address, a.postal_code, c.city, co.country
from address a
inner join city c on a.city_id = c.city_id
inner join country co on c.country_id = co.country_id
where a.postal_code not in ('12345', '67890', '54321');
-- 0,013 sec / 0,0015 sec

-- Before Index Creation: Queries that filter on postal_code without an index may require a full table scan, meaning the database must scan each row in the address table to find matching postal_code values. This can result in slower query performance, especially as the size of the address table grows.
-- After Index Creation: Once the index is created on the postal_code column, the database can quickly locate the rows that match the query conditions without scanning the entire table. This should lead to faster query execution times, particularly for large datasets.

# 2. Run queries using actor table, searching for first and last name columns independently. Explain the differences and why is that happening?
select first_name
from actor
where first_name = 'PENELOPE';
-- 0,0016 sec / 0,000022 sec

select last_name
from actor
where last_name = 'GUINESS';
-- 0,0013 sec / 0,000025 sec

-- The query last_name is more faster than the query first_name because the query last_name is indexed, we can check that using:
show index from actor;

# 3. Compare results finding text in the description on table film with LIKE and in the film_text using MATCH ... AGAINST. Explain the results.
select title, description 
from film
where description like '%action%';
-- 0,011 sec / 0,000058 sec

select title, description
from film_text
where match(title, description) against('action');
-- 0,034 sec / 0,000029 sec

-- LIKE performs simple pattern matching and is slower, especially on large datasets. 
-- MATCH ... AGAINST is a full-text search with relevance ranking, optimized for performance on large text-based datasets.