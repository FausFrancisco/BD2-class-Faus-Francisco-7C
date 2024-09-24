# 1. Create a user data_analyst.
create user data_analyst identified by 'password';

# 2. Grant permissions only to SELECT, UPDATE and DELETE to all sakila tables to it.
grant select, update, delete on sakila.* to 'data_analyst'@'%';
show grants for data_analyst;

# 3. Login with this user and try to create a table. Show the result of that operation.
-- Using the user "data_analyst":
use sakila;

create table class19;
# Error Code: 1142. CREATE command denied to user 'data_analyst'@'localhost' for table 'class19'
--

# 4. Try to update a title of a film. Write the update script.
-- Using the user "data_analyst":
update film
set title = "update title"
where film_id = 10;

select * from film where film_id = 10;
--

# 5. With root or any admin user revoke the UPDATE permission. Write the command.
revoke update on sakila.* from 'data_analyst'@'%';

# 6. Login again with data_analyst and try again the update done in step 4. Show the result.
-- Using the user "data_analyst":
update film
set title = "update title"
where film_id = 10;

# Error Code: 1142. UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'
-- 