use sakila;

# Add a new customer
#	To store 1
#	For address use an existing address. The one that has the biggest address_id in 'United States'
insert into customer (store_id, first_name, last_name, email, address_id, active, create_date)
values (
	1,
    'John',
    'Doe',
    'john.doe@example.com',
    (select max(a.address_id)
		from address a
		inner join city c on a.city_id = c.city_id
		inner join country co on c.country_id = co.country_id
		where co.country = 'United States'),
	1,
    now()
);

# Add a rental
#	Make easy to select any film title. I.e. I should be able to put 'film tile' in the where, and not the id.
#   Do not check if the film is already rented, just use any from the inventory, e.g. the one with highest id.
#	Select any staff_id from Store 2.
insert into rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
values (
    now(),
    (select max(i.inventory_id)
		from inventory i
		inner join film f on i.film_id = f.film_id
		where f.title = 'ACADEMY DINOSAUR'),
    1,
    date_add(now(), interval 7 day),
    (select staff_id
		from staff
		where store_id = 2
        limit 1),
    now()
);

# Update film year based on the rating
#   For example if rating is 'G' release date will be '2001'
#   You can choose the mapping between rating and year.
#	Write as many statements are needed.
update film
set release_year = 2001
where rating = 'G';

update film
set release_year = 2002
where rating = 'PG';

update film
set release_year = 2003
where rating = 'PG-13';

update film
set release_year = 2004
where rating = 'R';

update film
set release_year = 2005
where rating = 'NC-17';

# Return a film
#   Write the necessary statements and queries for the following steps.
#	Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
#	Use the id to return the film.
update rental
set return_date = now()
where rental_id = (
	select rental_id
    from rental
    where return_date is null
    order by rental_date desc
    limit 1
);

# Try to delete a film
#   Check what happens, describe what to do.
#	Write all the necessary delete statements to entirely remove the film from the DB.
delete from rental
where inventory_id in (
    select inventory_id
    from inventory
    where film_id = (select film_id from film where title = 'ACADEMY DINOSAUR')
);

delete from inventory
where film_id = (select film_id from film where title = 'ACADEMY DINOSAUR');

delete from film_actor
where film_id = (select film_id from film where title = 'ACADEMY DINOSAUR');

delete from film_category
where film_id = (select film_id from film where title = 'ACADEMY DINOSAUR');

delete from film
where title = 'ACADEMY DINOSAUR';

# Rent a film
#   Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
#	Add a rental entry
#	Add a payment entry
#	Use sub-queries for everything, except for the inventory id that can be used directly in the queries.
select inventory_id
from inventory
where store_id = 1
and inventory_id not in (
	select inventory_id
	from rental
	where return_date is null
	)
limit 1; #16

insert into rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
values (
    now(),
    16,
    (select customer_id
		from customer
		limit 1
	),
    date_add(now(), interval 7 day),
    (select staff_id
		from staff
		where store_id = 1
		limit 1
	),
    now()
);

insert into payment (customer_id, staff_id, rental_id, amount, payment_date, last_update)
values (
	(select customer_id
		from rental
		where rental_id = (
			select max(rental_id)
			from rental
			where return_date is null
		)
	),
    (select staff_id
		from rental
		where rental_id = (
			select max(rental_id)
			from rental
			where return_date is null
		)
	),
    (select max(rental_id)
		from rental
		where return_date is null
	),
    5.99,
    now(),
    now()
);