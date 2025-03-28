--QUESTIONS EASY 
--Q.1 WHO IS THE SENIOR MOST EMPLOYEE BASED ON JOB TITLE?
			/*SELECT *
			FROM employee
			order by levels desc
			limit 1;*/

--Q2 which countries have the most invoices?
			/*select count(*) as c ,billing_country
			from invoice
			group by billing_country
			order by c desc;*/

--Q.3. What are top 3 values of total invoice? 
			/*select total 
			from invoice
			order by total desc 
			limit 3;*/
			
/*  Q.4. Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals */

			/*select sum(total) as invoice_total,billing_city
			from invoice
			group by billing_city
			order by invoice_total desc; */

/*  Q.5. Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money			*/

/* select c.customer_id,c.first_name,c.last_name, sum(i.total) as total
from customer c
join invoice i
on c.customer_id = i.customer_id 
group by c.customer_id
order by total desc
limit 1; */

--moderate 
/*Q. Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A  */
			/*select distinct email,first_name,last_name
			from customer
			join invoice on customer.customer_id = invoice.customer_id
			join invoice_line on invoice.invoice_id = invoice_line.invoice_id
			where track_id in (
							select track_id from track
							join genre on track.genre_id = genre.genre_id
							where genre.name like 'Rock'
			)
			order by email; */

/*Q.2 Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands*/
			/* select artist.artist_id,artist.name,count(artist.artist_id) as number_of_songs
			from track 
			join album on album.album_id = track.album_id
			join artist on album.artist_id = artist.artist_id
			join genre on genre.genre_id = track.genre_id
			where genre.name like 'Rock'
			group by artist.artist_id
			order by number_of_songs desc
			limit 10; */ 

 /* Q.3. Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first */		

		/* select name,milliseconds
		from track
		where milliseconds > (
		              select avg(milliseconds) as avg_track_length
					  from track )
		order by milliseconds desc;  */


--Advance 
/* Q.1Find how much amount spent by each customer on artists? Write a query to return 
customer name, artist name and total spent */
			/* with best_selling_artist as (
				select artist.artist_id as artist_id,artist.name as artist_name,
				sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
				from invoice_line
				join track on track.track_id = invoice_line.track_id
				join album on album.album_id = track.album_id
				join artist on artist.artist_id = album.artist_id
				group by 1
				order by 3 desc
				limit 1
			)
			select c.customer_id,c.first_name,c.last_name,bsa.artist_name,
			sum(il.unit_price * il.quantity) as amount_spent
			from invoice i
			join customer c on c.customer_id = i.customer_id
			join invoice_line il on il.invoice_id=i.invoice_id
			join track t on t.track_id = il.track_id
			join album alm on alm.album_id = t.album_id
			join best_selling_artist bsa on bsa.artist_id = alm.artist_id
			group by 1,2,3,4
			order by 5 desc; */

/*Q.2 We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres */

			/*WITH popular_genre AS 
			(
			    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
				ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
			    FROM invoice_line 
				JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
				JOIN customer ON customer.customer_id = invoice.customer_id
				JOIN track ON track.track_id = invoice_line.track_id
				JOIN genre ON genre.genre_id = track.genre_id
				GROUP BY 2,3,4
				ORDER BY 2 ASC, 1 DESC
			)
			SELECT * FROM popular_genre WHERE RowNo <= 1  */


/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

/* Steps to Solve:  Similar to the above question. There are two parts in question- 
first find the most spent on music for each country and second filter the data for respective customers. */

/* Method 1: using CTE */

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1




			