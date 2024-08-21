use sakila;

# 1. Write a query that gets all the customers that live in Argentina. Show the first and last name in one column, the address and the city.
select concat(c.first_name, ' ', c.last_name) as customer, a.address, ci.city
from customer c
inner join address a on c.address_id = a.address_id
inner join city ci on a.city_id = ci.city_id
inner join country co on ci.country_id = co.country_id
where co.country = 'Argentina';

# 2. Write a query that shows the film title, language and rating. Rating shall be shown as the full text described here: https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Hint: use case.
select f.title, l.name,
	case 
        when f.rating = 'G' then 'General Audiences'
        when f.rating = 'PG' then 'Parental Guidance Suggested'
        when f.rating = 'PG-13' then 'Parents Strongly Cautioned'
        when f.rating = 'R' then 'Restricted'
        when f.rating = 'NC-17' then 'Adults Only'
    end as rating
from film f
inner join language l on f.language_id = l.language_id;

# 3. Write a search query that shows all the films (title and release year) an actor was part of. Assume the actor comes from a text box introduced by hand from a web page. Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.
select f.title, f.release_year
from film f
inner join film_actor fa on f.film_id = fa.film_id
inner join actor a on fa.actor_id = a.actor_id
where lower(concat(a.first_name, ' ', a.last_name)) = lower('PENELOPE GUINESS'); # PENELOPE GUINESS is an example, you can change it by inserting the FIRST and LAST NAME.

# 4. Find all the rentals done in the months of May and June. Show the film title, customer name and if it was returned or not. There should be returned column with two possible values 'Yes' and 'No'.
select f.title, concat(c.first_name, ' ', c.last_name) AS customer,
    case 
        when r.return_date is not null then 'Yes'
        else 'No'
    end as returned
from rental r
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
inner join customer c on r.customer_id = c.customer_id
where month(r.rental_date) in (5, 6);

# 5. Investigate CAST and CONVERT functions. Explain the differences if any, write examples based on sakila DB.
select rental_id, cast(rental_id as character)
from rental
limit 5;

select rental_id, convert(rental_id, character)
from rental
limit 5;

# Both functions cast a value as a certain type 

# 6. Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function. Explain what they do. Which ones are not in MySql and write usage examples.
# nvl is an Oracle-specific feature that replaces a null value with a default value. Not available in MySQL.
select nvl(actor_id, 0) from actor;

# isnull is a function used in SQL Server and MySQL to check if an expression is null, returning an alternative value if it is.
# In SQL Server:
select isnull(actor_id, 0) from actor;

# In MySQL:
select isnull(actor_id) from actor;

# ifnull is a function available in MySQL and SQLite that returns an alternative value if the expression is null.
select ifnull(actor_id, 0) from actor;

# coalesce is a standard SQL function that returns the first non-null value in a list of expressions.
select coalesce(actor_id, film_id, 1) from film_actor;

# nullif is a standard SQL function that returns null if two expressions are equal; otherwise, it returns the first expression.
select NULLIF(actor_id, 1) from actor;