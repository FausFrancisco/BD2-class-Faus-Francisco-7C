use sakila;

# 1. Create a view named list_of_customers, it should contain the following columns:
#	customer id
#	customer full name,
#	address
#	zip code
#	phone
#	city
#	country
#	status (when active column is 1 show it as 'active', otherwise is 'inactive')
#	store id
create view list_of_customers as
	select c.customer_id as "customer id",
    concat(c.first_name, ' ', c.last_name) as "customer full name",
    a.address as "address",
    a.postal_code as "zip code",
    a.phone as "phone",
    ci.city as "city",
    co.country as "country",
    case 
        when c.active = 1 then 'active'
        else 'inactive'
    end as "status",
    c.store_id as "store id"
	from customer c
	inner join address a on c.address_id = a.address_id
	inner join city ci on a.city_id = ci.city_id
	inner join country co on ci.country_id = co.country_id;

select * from list_of_customers;

# 2. Create a view named film_details, it should contain the following columns: film id, title, description, category, price, length, rating, actors - as a string of all the actors separated by comma. Hint use GROUP_CONCAT
create view film_details as
	select f.film_id as "film id",
    f.title as "title",
    f.description as "description",
    c.name as "category",
    f.rental_rate as "price",
    f.length as "length",
    f.rating as "rating",
    group_concat(concat(a.first_name, ' ', a.last_name) order by a.first_name, a.last_name separator ', ') as "actors"
	from film f
	inner join film_category fc on f.film_id = fc.film_id
	inner join category c on fc.category_id = c.category_id
	inner join film_actor fa on f.film_id = fa.film_id
	inner join actor a on fa.actor_id = a.actor_id
	group by f.film_id, f.title, f.description, c.name, f.rental_rate, f.length, f.rating;

select * from film_details;

# 3. Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.
create view sales_by_film_category as
	select c.name as 'category',
    sum(p.amount) as 'total_rental'
    from category c
    inner join film_category fc on c.category_id = fc.category_id
    inner join film f on fc.film_id = f.film_id
    inner join inventory i on f.film_id = i.film_id
    inner join rental r on i.inventory_id = r.inventory_id
    inner join payment p on r.rental_id = p.rental_id
    group by c.name;

select * from sales_by_film_category;

# 4. Create a view called actor_information where it should return, actor id, first name, last name and the amount of films he/she acted on.
create view actor_information as
	select a.actor_id as 'actor_id',
    a.first_name as 'first name',
    a.last_name as 'last name',
    count(fa.film_id) as 'amount of films he/she acted on'
    from actor a
    left join film_actor fa on a.actor_id = fa.actor_id
    group by a.actor_id;

select * from actor_information;

# 5. Analyze view actor_info, explain the entire query and specially how the sub query works. Be very specific, take some time and decompose each part and give an explanation for each.
-- The view will be created with the privileges of the current user and will execute with the privileges of the invoker (the user who runs the query).
CREATE DEFINER=CURRENT_USER SQL SECURITY INVOKER VIEW actor_info
AS
SELECT
a.actor_id, -- Selects the actor's ID from the `actor` table
a.first_name, -- Selects the actor's first name from the `actor` table
a.last_name, -- Selects the actor's last name from the `actor` table
-- Creates a concatenated string that includes the category name and the titles of the movies in that category for the actor
GROUP_CONCAT(DISTINCT CONCAT(c.name, ': ', -- Concatenation of the category name followed by a colon
		-- Subquery to get all movie titles in a specific category that the actor has acted in
		(SELECT GROUP_CONCAT(f.title ORDER BY f.title SEPARATOR ', ') -- Concatenation of movie titles separated by commas and sorted alphabetically
                    FROM sakila.film f -- Table of movies
                    INNER JOIN sakila.film_category fc
                      ON f.film_id = fc.film_id -- Join with `film_category` table to get the category of each movie
                    INNER JOIN sakila.film_actor fa
                      ON f.film_id = fa.film_id -- Join with `film_actor` table to relate movies to actors
                    WHERE fc.category_id = c.category_id -- Filter movies by the current category in the main loop
                    AND fa.actor_id = a.actor_id -- Filter movies by the current actor in the main loop
                 )
             )
             ORDER BY c.name SEPARATOR '; ') -- Sorts categories alphabetically and separates each category and its movies with a semicolon
AS film_info -- Alias ​​for the resulting column containing the movie information by category
FROM sakila.actor a -- Main table `actor` with alias `a`
-- Performs a LEFT JOIN with the `film_actor` table to include actors who have not acted in any movie
LEFT JOIN sakila.film_actor fa
  ON a.actor_id = fa.actor_id -- Matches actors with their movies
-- Performs a LEFT JOIN with the `film_category` table to get the movie categories
LEFT JOIN sakila.film_category fc
  ON fa.film_id = fc.film_id -- Matches movies with their categories
-- Performs a LEFT JOIN with the `category` table to get the category name
LEFT JOIN sakila.category c
  ON fc.category_id = c.category_id -- Gets the category name from the `category` table
GROUP BY a.actor_id, a.first_name, a.last_name; -- Groups results by actor to calculate movie information by actor

# 6. Materialized views, write a description, why they are used, alternatives, DBMS were they exist, etc.
-- Materialized Views:
-- Description:
-- A materialized view is a database object that contains the results of a query, and unlike a regular (virtual) view, it stores the data physically. 
-- This means that the results of the query are computed and saved when the materialized view is created or refreshed, allowing for faster access to large and complex query results.
-- It acts like a snapshot of the data at a certain point in time.

-- Why they are used:
-- Materialized views are used primarily for performance optimization, especially in environments where queries involve complex joins, aggregations, and calculations.
-- They improve query performance because the data is precomputed and stored, rather than computed on the fly each time the view is queried.
-- Common use cases include data warehousing, reporting, and analytics where query performance is crucial.
-- Since materialized views store the data, they can become outdated, requiring manual or automatic refreshes to keep the data up-to-date with the base tables.

-- Alternatives to materialized views:
-- 1. **Regular Views:** Regular (virtual) views are recomputed every time they are queried. While this keeps the data always up-to-date, it can be slower for complex queries compared to materialized views.
-- 2. **Indexes:** Indexes can be used to speed up query performance, particularly for specific columns, but they do not store precomputed results like materialized views do.
-- 3. **Caching:** Application-level caching stores query results in memory or on disk to improve performance. This is external to the database and does not have the same query optimization capabilities as materialized views.
-- 4. **Denormalization:** Instead of using a materialized view, data can be denormalized, meaning that some of the base tables are combined or redundant data is stored to avoid expensive joins. This can be done manually, but it introduces the need for data consistency mechanisms.

-- DBMS that support materialized views:
-- - **Oracle Database:** One of the most well-known systems that supports materialized views, offering sophisticated features like query rewrite and incremental refresh.
-- - **PostgreSQL:** Materialized views are supported but require manual refresh (automatic refresh is not yet available natively).
-- - **MySQL:** Does not natively support materialized views. Instead, you can use tables to simulate them with triggers or scheduled jobs to refresh the data.
-- - **SQL Server:** Does not have materialized views, but offers "Indexed Views" which can achieve similar results by storing the view’s data with an index.
-- - **DB2:** IBM's DB2 supports materialized query tables (MQTs), which are essentially materialized views.
