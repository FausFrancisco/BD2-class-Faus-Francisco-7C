use sakila;

-- 1.Find the films with less duration, show the title and rating.
select title, rating
from film
where length <= all(
    select length
    from film
);

-- 2.Write a query that returns the tiltle of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset.
select title
from film 
where length <= all(
	select length
    from film 
)and title = all(
	select title
	from film
);

-- 3.Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.
select c.first_name, c.last_name, a.address, min(p.amount)
from customer c
inner join payment p on c.customer_id = p.customer_id
inner join address a on c.address_id = a.address_id
where p.amount <= all(
	select amount
    from payment
)group by c.first_name, c.last_name, a.address;

-- 4.Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.
select c.first_name, c.last_name, p1.amount, p2.amount
from customer c
inner join payment p1 on c.customer_id = p1.customer_id
inner join payment p2 on c.customer_id = p2.customer_id
where p1.amount >= all(
	select p.amount
    from payment p
    where p.customer_id = c.customer_id
) and p2.amount <= all(
	select p.amount
    from payment p
    where p.customer_id = c.customer_id
)group by c.first_name, c.last_name, p1.amount, p2.amount;

