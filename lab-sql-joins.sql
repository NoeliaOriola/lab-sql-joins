USE sakila;

-- 1. List the number of films per category.
SELECT c.name AS category, COUNT(fc.film_id) AS number_of_films 
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name;

-- 2. Retrieve the store ID, city, and country for each store.
SELECT s.store_id, ci.city AS city, co.country AS country
FROM store s
INNER JOIN address a ON s.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id;

-- 3. Calculate the total revenue generated by each store in dollars.alter
SELECT 
    s.store_id,
    CONCAT(ci.city, ', ', co.country) AS store_location,
    SUM(p.amount) AS total_revenue
FROM store s
INNER JOIN staff st ON s.manager_staff_id = st.staff_id
INNER JOIN address a ON s.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id
INNER JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id, ci.city, co.country;

-- 4. Determine the average running time of films for each category.
SELECT c.name AS category,ROUND(AVG(f.length), 2) AS average_running_time
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

-- BONUS
-- 5. Identify the film categories with the longest average running time.
SELECT c.name AS cateogry, ROUND(AVG(f.length), 2) AS average_running_time
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY average_running_time DESC;

-- 6. Display the top 10 most frequently rented movies in descending order.
SELECT f.title AS film_title, COUNT(*) AS rental_count
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count desc
lIMIT 10;

-- 7. Determine if "Academy Dinosaur" can be rented from Store 1.
SELECT CASE
WHEN COUNT(*) > 0 THEN 'Available in Store 1'
ELSE 'Not available in Store 1'
END AS availability
FROM film f
INNER JOIN inventory I ON f.film_id = i.film_id
INNER JOIN store s ON i.store_id = s.store_id
WHERE f.title = 'Academy Dinosaur'
AND s.store_id = 1;

-- 8. Provide a list of all distinct film titles, along with their availability status in the inventory. 
-- Include a column indicating whether each title is 'Available' or 'NOT available'.alter
-- Note that there are 42 titles that are not in the inventory, and this information can be obtained using a CASE statement combined with IFNULL."

SELECT DISTINCT f.title AS film_title, 
CASE
 WHEN i.film_id IS NOT NULL THEN 'Available'
 ELSE 'NOT available'
 END AS availability_status
 FROM film f
 LEFT JOIN inventory i ON f.film_id = i.film_id
 ORDER BY f.title;
 
