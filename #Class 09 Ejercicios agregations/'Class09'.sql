use sakila;

-- 1.Get the amount of cities per country in the database. Sort them by country, country_id.
select co.country, co.country_id, count(ci.city_id)
from country co
inner join city ci on co.country_id = ci.country_id
group by co.country, co.country_id
order by co.country, co.country_id;

-- 2.Get the amount of cities per country in the database. Show only the countries with more than 10 cities, order from the highest amount of cities to the lowest.
select co.country, co.country_id, count(ci.city_id)
from country co
inner join city ci on co.country_id = ci.country_id
group by co.country, co.country_id
having count(ci.city_id) > 10
order by count(ci.city_id) desc;

-- 3.Generate a report with customer (first, last) name, address, total films rented and the total money spent renting films.
select c.first_name, c.last_name, a.address, count(r.rental_id), sum(p.amount)
from customer c
inner join address a on c.address_id = a.address_id
inner join rental r on c.customer_id = r.customer_id
inner join payment p on c.customer_id = p.customer_id
group by c.first_name, c.last_name, a.address

-- Show the ones who spent more money first.
order by sum(p.amount) desc;

-- 4.Which film categories have the larger film duration (comparing average)?
select ca.name, avg(f.length)
from film f
inner join film_category fc on f.film_id = fc.film_id
inner join category ca on ca.category_id = fc.category_id
group by ca.name

-- Order by average in descending order
order by avg(f.length) desc;

-- 5.Show sales per film rating
select f.rating, sum(p.amount)
from film f
inner join inventory i on f.film_id = i.film_id
inner join rental r on i.inventory_id = r.inventory_id
inner join payment p on r.rental_id = p.rental_id
group by f.rating