use sakila;

CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
);

# 1- Insert a new employee to , but with an null email. Explain what happens.
insert into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values 
	(1002, 'Murphy', 'Diane', 'x5800', null, 1, null, 'President');

-- Error Code: 1048. Column 'email' cannot be null.
-- We cannot insert an employee with a NULL email because the email field in the employees table is defined with the NOT NULL constraint, which means that it must always contain a value and cannot be left empty or null.

# 2- Run the first the query.
UPDATE employees SET employeeNumber = employeeNumber - 20;	# first query
# What did happen? Explain. Then run this other.
UPDATE employees SET employeeNumber = employeeNumber + 20;	# second query
# Explain this case also.

-- In the first query updates the employeeNumber value for each employee in the employees table, subtracting 20 from each current value.
-- In the second query updates the employeeNumber value for each employee in the employees table, adding 20 from each current value.

# 3- Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.
alter table employees
add column age int,
add constraint check_age check (age between 16 and 70);

# 4- Describe the referential integrity between tables film, actor and film_actor in sakila db.

-- Films can only be associated with existing actors, and actors can only be associated with existing movies.
-- Updates to the film_id or actor_id are automatically propagated to the relationship table (film_actor).
-- Actors or films cannot be removed if associations exist in film_actor, thus avoiding the creation of orphan data in the database.

# 5- Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time updated on inserts and updates operations. Bonus: add a column lastUpdateUser and the respective trigger(s) to specify who was the last MySQL user that changed the row (assume multiple users, other than root, can connect to MySQL and change this table).
alter table employees
add column lastUpdate datetime,
add column lastUpdateUser varchar(100)

delimiter $$
create trigger ins_employee
	before insert on employees
	for each row
begin
    set new.lastUpdate = now(); 
    set new.lastUpdateUser = current_user();
end $$

create trigger upd_employee
	before update on employees
	for each row
begin
	set new.lastUpdate = now();
	set	new.lastUpdateUser = current_user();
end $$
delimiter ;

# 6- Find all the triggers in sakila db related to loading film_text table. What do they do? Explain each of them using its source code for the explanation.

-- ins_film: This trigger inserts a new record into film_text after a new record is inserted into the film table.
-- upd_film: This trigger updates the data in the film_text table after an existing record in the film table is updated.
