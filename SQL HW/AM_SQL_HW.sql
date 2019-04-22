use sakila;
-- 1a. Display the first and last names of all actors from the table `actor`.
select first_name, last_name 
from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
select UPPER(concat(first_name," " ,last_name)) as 'ACTOR NAME' 
from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name 
from actor 
where first_name like "Joe";

-- 2b. Find all actors whose last name contain the letters `GEN`:
select actor_id, first_name, last_name 
from actor 
where last_name like "%GEN%";

-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select actor_id, first_name, last_name 
from actor 
where last_name like "%Li%"
order by last_name, first_name;

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country 
from country
where country in ( 'Afghanistan','Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
alter table actor
add description BLOB;

select * from actor;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
alter table actor
drop description;
select * from actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) 
from actor
group by last_name;


-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(*) 
from actor 
group by last_name
having count(*) > 1;

-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
select actor_id, first_name, last_name 
from actor 
where first_name = 'GROUCHO';

UPDATE ACTOR 
SET first_name = 'HARPO'
where actor_id = '172';

select actor_id, first_name, last_name 
from actor 
where actor_id = '172';

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE ACTOR 
SET first_name = 'Groucho'
where actor_id = '172';

select actor_id, first_name, last_name 
from actor 
where actor_id = '172';

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
  -- Hint: [https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html](https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html)
DESCRIBE sakila.address;

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
select staff.first_name, staff.last_name, address.address 
from staff
inner join address 
on staff.address_id = address.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
select staff.first_name, staff.last_name, sum(payment.amount)
from staff
inner join payment
on staff.staff_id = payment.staff_id
where payment.payment_date like '%2005-08%'
group by staff.staff_id
 ;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select film.title, count(film_actor.actor_id) as 'Number of Actors' from film
inner join film_actor
on film.film_id = film_actor.film_id
group by film.title;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select film.title, inventory.film_id, count(inventory.film_id) as 'Copies' from inventory
inner join film
on film.film_id = inventory.film_id
where inventory.film_id in
(select film_id from film 
where title = 'Hunchback Impossible'
);

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
select customer.first_name, customer.last_name, sum(payment.amount) as 'Total Paid $' 
from customer
inner join payment
on customer.customer_id = payment.customer_id
group by customer.last_name
order by customer.last_name;

 -- ![Total amount paid](Images/total_payment.png)

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
select film.title, language.name from film 
inner join language
on film.language_id = language.language_id
WHERE film.title like "K%" OR film.title like "Q%" AND 
language.language_id in
(select language_id from language
where name = 'ENGLISH');

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select actor.first_name, actor.last_name, actor.actor_id from actor
inner join film_actor
on actor.actor_id = film_actor.actor_id
where actor.actor_id in
(
select film_actor.actor_id from film_actor
inner join film
on film_actor.film_id = film.film_id
where film_actor.film_id in
(select film_id from film
where title = 'Alone Trip')
)
group by actor.first_name;

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select customer.first_name, customer.last_name, customer.email, address.address, address.city_id from customer
left join address
on customer.address_id = address.address_id
where address.address_id in
	(select address.address_id from address
	left join city
	on address.city_id = city.city_id
	where city.city_id in
		(select city_id from city
		left join country
		on city.country_id = country.country_id
		where country.country_id in
			(select country_id from country
			where country = 'Canada')
		)
	)
group by customer.first_name;

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.

select title, description from film
where film_id in
(select film_id from film_Category
 where category_id in
	(select category_id  from category
	 where name = "Family"
	)
);

-- 7e. Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(rental_id) AS 'Times Rented'
FROM rental r
JOIN inventory i
ON (r.inventory_id = i.inventory_id)
JOIN film f
ON (i.film_id = f.film_id)
GROUP BY f.title
ORDER BY `Times Rented` DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.


SELECT s.store_id, SUM(amount) AS 'Revenue'
FROM payment p
JOIN rental r
ON (p.rental_id = r.rental_id)
JOIN inventory i
ON (i.inventory_id = r.inventory_id)
JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id; 

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, cty.city, country.country 
FROM store s
JOIN address a 
ON (s.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id);

-- 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;
          

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
Create view Top_5_Genres AS
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;


-- 8b. How would you display the view that you created in 8a?
select * from Top_5_Genres

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
-- DROP VIEW Top_5_Genres;