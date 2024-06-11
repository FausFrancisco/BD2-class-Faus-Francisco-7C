use sakila;

#1. Obtener los pares de apellidos de actores que comparten nombres, considerando
#solo los actores cuyo nombre comienza con una vocal. Mostrar el nombre, los 2
#apellidos y las películas que comparten.
select a1.first_name, a1.last_name, a2.last_name, f.title
from actor a1
inner join actor a2 on a1.first_name = a2.first_name and a1.last_name <> a2.last_name 
inner join film_actor fa1 on a1.actor_id = fa1.actor_id
inner join film_actor fa2 on a2.actor_id = fa2.actor_id
inner join film f on fa1.film_id = fa2.film_id = f.film_id
where a1.first_name like 'a%'
	or a1.first_name like 'e%'
	or a1.first_name like 'i%'
    or a1.first_name like 'o%'
    or a1.first_name like 'u%'
order by a1.first_name, a1.last_name, a2.last_name, f.title;

#2. Mostrar aquellas películas cuya cantidad de actores sea mayor al promedio de
#actores por películas. Además, mostrar su cantidad de actores y una lista de los
#nombres de esos actores.
select 
	f.title as Pelicula, 
    count(a.actor_id) as Cantidad_de_Actores, 
    group_concat(concat(a.first_name, ' ', a.last_name) separator ', ') as Actores
from film f
inner join film_actor fa on f.film_id = fa.film_id
inner join actor a on fa.actor_id = a.actor_id
group by f.film_id
having Cantidad_de_Actores > (
	select avg(CantAct)
    from (
		select count(actor_id) as CantAct
		from film_actor
        group by film_id
	) as subquery
);

#3. Generar un informe por empleado mostrando el local, la cantidad y sumatoria de sus 
#ventas, su venta máxima, mínima, cuantas veces se repite la venta máxima y la
#mínima, además mostrar en una columna una concatenación de todos los alquileres
#mostrando el título de la película alquilada y el monto pagado. Considerar sólo los
#datos del año actual.
select concat(s.first_name, ' ', s.last_name) as empleado, 
	st.store_id as local,
    count(payment_id) as cantidad,
    sum(p.amount) as sumatoria,
    max(p.amount) as maxima,
    min(p.amount) as minima,
    lj1.cantidad_max,
    lj2.cantidad_min,
#    (select count(*)
#    from payment p2
#    where p2.staff_id = s.staff_id and p2.amount = (
#		select max(p3.amount) 
#        from payment p3 
#        where p3.staff_id = s.staff_id
#        )
#    ) as cantidad_max,
    
#    (select count(*)
#    from payment p2
#    where p2.staff_id = s.staff_id and p2.amount = (
#		select min(p3.amount) 
#        from payment p3
#        where p3.staff_id = s.staff_id
#        )
#    ) as cantidad_min,
    
    group_concat(concat(f.title, ' ', p.amount) separator ', ') as alquiler
from staff s

inner join store st on s.store_id = st.store_id
inner join payment p on s.staff_id = p.staff_id
inner join rental r on p.rental_id = r.rental_id
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id

left join (
	select staff_id, count(*) as cantidad_max
	from payment
    where amount = (
		select max(amount) 
        from payment 
        where staff_id = payment.staff_id
	)
	group by staff_id
) lj1 on s.staff_id = lj1.staff_id

left join (
	select staff_id, count(*) as cantidad_min
	from payment
    where amount = (
		select min(amount) 
        from payment 
        where staff_id = payment.staff_id
	)
	group by staff_id
) lj2 on s.staff_id = lj2.staff_id

group by s.staff_id;