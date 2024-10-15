use sakila;

# 1. Write a function that returns the amount of copies of a film in a store in sakila-db. Pass either the film id or the film name and the store id.
delimiter //
create procedure film_copies_in_store(
		in p_film_id int,
        in p_store_id int)
begin
    select s.store_id, 
		f.film_id, 
		count(i.inventory_id) as 'copies'
    from inventory i
    inner join store s on i.store_id = s.store_id
    inner join film f on i.film_id = f.film_id
	where s.store_id = p_store_id
		and f.film_id = p_film_id
    group by s.store_id, f.film_id;
end //
delimiter ;

call film_copies_in_store(2, 2);

# 2. Write a stored procedure with an output parameter that contains a list of customer first and last names separated by ";", that live in a certain country. You pass the country it gives you the list of people living there. USE A CURSOR, do not use any aggregation function (ike CONTCAT_WS.
delimiter //
create procedure list_of_customer(
		in p_country_name varchar(255),
        inout customer_list text)
begin
	declare v_finished integer default 0;
    declare v_first_name varchar(255);
    declare v_last_name varchar(255);
    
    declare customer_cursor cursor for
		select c.first_name,
			c.last_name
		from customer c
		inner join address a on c.address_id = a.address_id
        inner join city ci on a.city_id = ci.city_id
        inner join country co on ci.country_id = co.country_id
        where co.country = p_country_name;
        
	declare continue handler for not found set v_finished = 1;
    
    open customer_cursor;
    
    get_customer_list: loop
		fetch customer_cursor into v_first_name, v_last_name;
        
        if v_finished = 1 then 
			leave get_customer_list;
		end if;
        
		set customer_list = concat(v_first_name, ' ', v_last_name, '; ', customer_list);
    
    end loop get_customer_list;
    
    close customer_cursor;
end //
delimiter ;

set @custome_list = '';
call list_of_customer('United States', @custome_list);
select @custome_list;

# 3.Review the function inventory_in_stock and the procedure film_in_stock explain the code, write usage examples.
DELIMITER $$
-- The feature determines whether a specific copy of a movie is available in inventory (not rented or returned).
CREATE FUNCTION inventory_in_stock(p_inventory_id INT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out     INT;

    #AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE
    #FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED
	
    -- Determines if an inventory is available or rented.
    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;
	
    -- If there are no rental records for that inventory, it is in stock.
    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

	-- Check if the inventory is rented and has not been returned.
    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;
	
    -- If rented (no return date), not in stock.
    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END $$

DELIMITER ;
-- Example:
select inventory_in_stock(100);

DELIMITER $$
-- This procedure stores how many copies of a specific movie are in stock at a given store.
CREATE PROCEDURE film_in_stock(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
READS SQL DATA
BEGIN
	-- Select the movie inventories in the specific store that are in stock.
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);
	
    -- Counts how many inventories of the movie in that store are in stock.
     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id)
     INTO p_film_count;
END $$

DELIMITER ;
-- Example:
set @film_count = 0;
call film_in_stock(10, 1, @film_count);
select @film_count;