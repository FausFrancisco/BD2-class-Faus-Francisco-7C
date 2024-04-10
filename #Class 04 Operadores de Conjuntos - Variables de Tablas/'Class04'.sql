use sakila;

-- 1.Show title and special_features of films that are PG-13
select title, special_features
from film 
where rating = 'PG-13';

-- 2.Get a list of all the different films duration.
select distinct length
from film;

-- 3.Show title, rental_rate and replacement_cost of films that have replacement_cost from 20.00 up to 24.00
select title, rental_rate, replacement_cost
from film
where replacement_cost between 20.00 and 24.00;

-- 4.Show title, category and rating of films that have 'Behind the Scenes' as special_features
select film.title, category.name as category, film.rating
from film
inner join film_category on film.film_id = film_category.film_id
inner join category on film_category.category_id = category.category_id
where film.special_features like '%Behind the Scenes%';

-- 5.Show first name and last name of actors that acted in 'ZOOLANDER FICTION'
select actor.first_name, actor.last_name
from actor
inner join film_actor on actor.actor_id = film_actor.actor_id
inner join film on film_actor.film_id = film.film_id
where film.title = 'ZOOLANDER FICTION';

-- 6.Show the address, city and country of the store with id 1
select address.address, city.city, country.country
from address
inner join city on address.city_id = city.city_id
inner join country on city.country_id = country.country_id
where address.address_id = 1;

-- 7.Show pair of film titles and rating of films that have the same rating.
select f1.title as film1_title, f2.title as film2_title, f1.rating
from film f1
inner join film f2 on f1.rating = f2.rating and f1.film_id < f2.film_id;

-- Get all the films that are available in store id 2 and the manager first/last name of this store (the manager will appear in all the rows).
select film.title, staff.first_name, staff.last_name
from inventory
inner join film on inventory.film_id = film.film_id
inner join store on inventory.store_id = store.store_id
inner join staff on store.manager_staff_id = staff.staff_id
where store.store_id = 2;