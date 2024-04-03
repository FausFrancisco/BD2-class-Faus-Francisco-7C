create database imdb;

use imdb;

create table film (
    film_id integer auto_increment primary key,
    title varchar(255),
    description text,
    release_year integer
);

create table actor (
    actor_id integer auto_increment primary key,
    first_name varchar(50),
    last_name varchar(50)
);

create table film_actor (
    actor_id integer,
    film_id integer
);

alter table film
add last_update datetime
after release_year;

alter table actor
add last_update datetime
after last_name;

alter table film_actor
add constraint fk_actor_id foreign key (actor_id) references actor(actor_id),
add constraint fk_film_id foreign key (film_id) references film(film_id);

insert into actor (first_name, last_name) values ('Tom', 'Hanks');
insert into actor (first_name, last_name) values ('Leonardo', 'DiCaprio');
insert into actor (first_name, last_name) values ('Meryl', 'Streep');

insert into film (title, description, release_year) values ('Forrest Gump', 'A man with a low IQ witnesses historical events in 20th century United States.', 1994);
insert into film (title, description, release_year) values ('Titanic', 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.', 1997);
insert into film (title, description, release_year) values ('The Devil Wears Prada', 'A smart but sensible new graduate lands a job as an assistant to Miranda Priestly, the demanding editor-in-chief of a high fashion magazine.', 2006);

insert into film_actor (actor_id, film_id) values (1, 1);
insert into film_actor (actor_id, film_id) values (2, 2);
insert into film_actor (actor_id, film_id) values (3, 3);