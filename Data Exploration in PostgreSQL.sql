--Cusomers who patronized a staff and spent over $110
SELECT customer_id, SUM(amount) AS total_amount
FROM payment
WHERE staff_id = 2
GROUP BY customer_id
HAVING SUM(amount) > 110;

--Selecting film titles that starts with a specific letter
SELECT *
FROM film
WHERE title LIKE 'J%';
 

--Identifying Staff that recorded more transactions
SELECT staff_id, COUNT(amount) AS total_transactions
FROM payment
GROUP BY staff_id
ORDER BY COUNT(amount) DESC
;


-- Getting the average replacement cost of ratings
SELECT rating, ROUND(AVG(replacement_cost),2) AS avg_replacement_cost
FROM film
GROUP BY rating
;


--Display of email addresses of customers in a location
SELECT district, email
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
WHERE district = 'California';


--Joined tables to find an actor's name and the movies they acted
SELECT title, first_name, last_name
FROM actor
INNER JOIN film_actor
ON film_actor.actor_id = actor.actor_id
INNER JOIN film
ON film.film_id = film_actor.film_id
WHERE first_name = 'Nick' AND last_name = 'Wahlberg'
;


-- Top 5 customers who made more rentals
SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 5
;


-- Get details of specific customers using their ids
SELECT *
FROM customer
WHERE customer_id IN (1,5,7);


-- Customer's total expenses for a given month
SELECT customer_id, SUM(amount) AS Month_total_payment
FROM payment
WHERE payment_date BETWEEN '2007-03-01' AND '2007-04-01'
	GROUP BY customer_id
	ORDER BY Month_total_payment DESC;


--Selecting distinct values
SELECT DISTINCT district
FROM address;


--Count rows in a column that have a specific data in it.
SELECT COUNT(title)
FROM film
WHERE title LIKE '%Truman%'
;


--A complex Subquery
SELECT film_id, title
FROM film
WHERE film_id IN
(SELECT inventory.film_id
FROM rental
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30')
ORDER BY title;


SELECT first_name, last_name
FROM customer AS c
WHERE EXISTS (SELECT *
			 FROM payment AS p
			 WHERE c.customer_id = p.customer_id
			 AND amount >11);


-- display the amount of transaction on mondays
SELECT COUNT(*)
FROM payment
WHERE EXTRACT(dow FROM payment_date) = 1


-----------------------------------------------------------------
-- Creating Views for later visualization

--Identifying the video genre customers rent more
CREATE VIEW genre_revenue AS
SELECT name AS genre, COUNT(amount) AS total_count, SUM(amount) AS total_cost 
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN film
ON film_category.film_id = film.film_id
INNER JOIN inventory
ON film.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment
ON rental.customer_id = payment.customer_id
GROUP BY name
ORDER BY total_cost DESC;


-- Total rents by ratings	
CREATE VIEW rating_rents AS
SELECT 
SUM(CASE rating
   	WHEN 'R' THEN 1
   ELSE 0
END) AS r,
SUM(CASE rating
   	WHEN 'PG' THEN 1
   ELSE 0
END) AS pg,
SUM(CASE rating
   	WHEN 'PG-13' THEN 1
   ELSE 0
END) AS pg13
FROM film;


--Display and reward customers according to their ids
CREATE VIEW customers_tier_status AS
SELECT customer_id,
CASE
	WHEN (customer_id <=100) THEN 'Premium'
	WHEN (customer_id BETWEEN 100 AND 200) THEN 'Plus'
	ELSE 'Normal' 
END AS Tier_Status
FROM customer
ORDER BY customer_id;
