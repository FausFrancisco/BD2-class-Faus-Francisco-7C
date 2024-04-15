use sakila;

-- 1.List all the actors that share the last name. Show them in order
select first_name, last_name
from actor a1
where last_name in (
	select last_name
	from actor a2
	where a1.last_name = a2.last_name and a1.actor_id <> a2.actor_id
)order by last_name;

-- 2.Find actors that don't work in any film
select actor.first_name, actor.last_name
from actor 
where actor_id not in(
	select distinct actor_id
	from film_actor
);

-- 3.Find customers that rented only one film
select c.first_name, c.last_name
from customer c
where c.customer_id in (
    select r.customer_id
    from rental r
    group by r.customer_id
    having count(*) = 1
);

-- 4.Find customers that rented more than one film
select c.first_name, c.last_name
from customer c
where c.customer_id in (
    select r.customer_id
    from rental r
    group by r.customer_id
    having count(*) > 1
);

-- 5.List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'
select a.first_name, a.last_name
from actor a
inner join film_actor fa on a.actor_id = fa.actor_id
where fa.film_id in (
    select f.film_id
    from film f
    where f.title in ('BETRAYED REAR', 'CATCH AMISTAD')
);

-- 6.List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
select distinct a.first_name, a.last_name 
from actor a
inner join film_actor fa1 on a.actor_id = fa1.actor_id
where fa1.film_id in (
	select f1.film_id
    from film f1
    where f1.title = 'BETRAYED REAR'
)and a.actor_id not in (
	select fa2.actor_id
    from film_actor fa2
    inner join film f2 on fa2.film_id = f2.film_id
    where f2.title = 'CATCH AMISTAD'
);

-- 7.List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'
select distinct a.first_name, a.last_name 
from actor a
inner join film_actor fa1 on a.actor_id = fa1.actor_id
where fa1.film_id not in (
	select f1.film_id
    from film f1
    where f1.title = 'BETRAYED REAR'
)and a.actor_id in (
	select fa2.actor_id
    from film_actor fa2
    inner join film f2 on fa2.film_id = f2.film_id
    where f2.title = 'CATCH AMISTAD'
);

-- 8.List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'
select a.first_name, a.last_name
from actor a
inner join film_actor fa on a.actor_id = fa.actor_id
where fa.film_id not in (
    select f.film_id
    from film f
    where f.title in ('BETRAYED REAR', 'CATCH AMISTAD')
);