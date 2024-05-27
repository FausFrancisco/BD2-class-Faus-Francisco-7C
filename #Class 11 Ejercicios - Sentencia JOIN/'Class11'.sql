use sakila;

-- 4.Find all the film titles that are not in the inventory.
select f.title
from film f
left join inventory i on f.film_id = i.film_id
where i.film_id is null;

-- 5.Find all the films that are in the inventory but were never rented.
--  Show title and inventory_id.
--  This exercise is complicated.
--  hint: use sub-queries in FROM and in WHERE or use left join and ask if one of the fields is null
select f.title, i.inventory_id
from film f
inner join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
where r.rental_id is null;

-- 6.Generate a report with:
--  customer (first, last) name, store id, film title,
--  when the film was rented and returned for each of these customers
--  order by store_id, customer last_name
select c.first_name, c.last_name, s.store_id, f.title, r.rental_date, r.return_date
from customer c
inner join rental r on c.customer_id = r.customer_id
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
inner join store s on i.store_id = s.store_id
order by s.store_id, c.last_name;

-- 7.Show sales per store (money of rented films)
--  show store's city, country, manager info and total sales (money)
--  (optional) Use concat to show city and country and manager first and last name
select concat(ci.city,'and ', co.country) as city_and_country, concat(m.first_name,' ', m.last_name) as manager_info, s.store_id, sum(p.amount) as total_sales
from store s
inner join address a on s.address_id = a.address_id
inner join city ci on a.city_id = ci.city_id
inner join country co on ci.country_id = co.country_id
inner join staff m on s.manager_staff_id = m.staff_id
inner join payment p on s.store_id = p.staff_id
group by s.store_id, city_and_country, manager_info;

-- Which actor has appeared in the most films?
select a.first_name, a.last_name, count(fa.film_id)
from actor a
inner join film_actor fa on a.actor_id = fa.actor_id
group by a.first_name, a.last_name
order by count(fa.film_id) desc
limit 1;