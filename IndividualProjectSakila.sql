//Financial revenue
select strftime("%Y",return_date) as Year, strftime("%m",return_date) as Month, round(sum(p.amount),2) as Sales from rental r inner join payment p on p.rental_id = r.rental_id where return_date is not null group by strftime("%Y",return_date), strftime("%m",return_date)

//Number of rentals by each stores
select count(r.rental_id) as NumberOfRentals, st.store_id as store from staff s inner join rental r inner join store st on r.staff_id = s.staff_id and s.staff_id = st.manager_staff_id group by st.store_id

//Customers number of customers
select Year, Month, count(*) as NoOfCustomers from (select (customer_id), min(strftime("%Y",rental_date)) as Year, min(strftime("%m",rental_date)) as Month from rental group by customer_id order by 1) group by 1,2 ' group by strftime("%Y",rental_date), strftime("%m",rental_date)

//Customer aggregate most avg amount, frequency, recency
select customer_id, round(avg(amount),2) as AveageSpent, count(*) as frequency, strftime('%Y',max(payment_date))|| '-' || strftime('%m',min(payment_date)) as Recency from payment group by customer_id order by 2 desc limit 10

//Customer aggregate least avg amount, frequency, recency
select customer_id, round(avg(amount),2) as AveageSpent, count(*) as frequency, strftime('%Y',max(payment_date))|| '-' || strftime('%m',min(payment_date)) as Recency from payment group by customer_id order by 2 limit 10

//Tenure of customers
select (customer_id) as CustomerID, round((julianday('now') - max(julianday(rental_date)))/365,2) as tenureYears from rental group by customer_id order by 2 desc limit 10
select (customer_id) as CustomerID, round((julianday('now') - max(julianday(rental_date)))/365,2) as tenureYears from rental group by customer_id order by 2 limit 10

//Top markets
select round(sum(amount),2), country from [customer_list] cu inner join payment p on cu.ID = p.customer_id group by country order by 1 desc limit 10


//DVD films that is rented most
select f.film_id, title, count(*) as RentedCount from rental r inner join inventory i inner join film f on r.inventory_id = i.inventory_id and i.film_id = f.film_id group by f.film_id order by 3 desc limit 10

//DVD film that rented least
select f.film_id, title, count(*) as RentedCount from rental r inner join inventory i inner join film f on r.inventory_id = i.inventory_id and i.film_id = f.film_id group by f.film_id order by 3 limit 10

//DVD category that rented least
select film_id, c.name from (select f.film_id, title, count(*) as RentedCount from rental r inner join inventory i inner join film f on r.inventory_id = i.inventory_id and i.film_id = f.film_id group by f.film_id order by 3 limit 10) b
inner join film_category fc inner join category c on b.film_id = fc.film_id and fc.category_id = c.category_id

//DVD catogory that rented most
select film_id, c.name from (select f.film_id, title, count(*) as RentedCount from rental r inner join inventory i inner join film f on r.inventory_id = i.inventory_id and i.film_id = f.film_id group by f.film_id order by 3 desc limit 10) b
inner join film_category fc inner join category c on b.film_id = fc.film_id and fc.category_id = c.category_id

//DVD category which is least rented excluding the most category
select c.name from (select f.film_id, title, count(*) as RentedCount from rental r inner join inventory i inner join film f on r.inventory_id = i.inventory_id and i.film_id = f.film_id group by f.film_id order by 3 limit 10) b
inner join film_category fc inner join category c on b.film_id = fc.film_id and fc.category_id = c.category_id
except
select c.name from (select f.film_id, title, count(*) as RentedCount from rental r inner join inventory i inner join film f on r.inventory_id = i.inventory_id and i.film_id = f.film_id group by f.film_id order by 3 desc limit 10) b
inner join film_category fc inner join category c on b.film_id = fc.film_id and fc.category_id = c.category_id

//actor that rented most excluding the least rented actors
select a.first_name || " " || a.last_name from (select f.film_id from payment p inner join rental r inner join inventory i inner join film f on p.rental_id = r.rental_id and r.inventory_id = i.inventory_id 
and i.film_id = f.film_id group by f.film_id order by sum(amount) desc limit 10) b 
left join film_actor fa inner join actor a on b.film_id = fa.film_id and fa.actor_id = a.actor_id
except 
select a.first_name || " " || a.last_name  from (select f.film_id from payment p inner join rental r inner join inventory i inner join film f on p.rental_id = r.rental_id and r.inventory_id = i.inventory_id and
 i.film_id = f.film_id group by f.film_id order by sum(amount) limit 10) b 
left join film_actor fa inner join actor a on b.film_id = fa.film_id and fa.actor_id = a.actor_id


//actor that rented least excluding the most sold
select (a.first_name) || " " || a.last_name  from (select f.film_id from payment p inner join rental r inner join inventory i inner join film f on p.rental_id = r.rental_id and r.inventory_id = i.inventory_id and i.film_id = f.film_id group by f.film_id order by sum(amount) limit 10) b 
left join film_actor fa inner join actor a on b.film_id = fa.film_id and fa.actor_id = a.actor_id
except
select (a.first_name) || " " || a.last_name from (select f.film_id from payment p inner join rental r inner join inventory i inner join film f on p.rental_id = r.rental_id and r.inventory_id = i.inventory_id and i.film_id = f.film_id group by f.film_id order by sum(amount) desc limit 10) b 
left join film_actor fa inner join actor a on b.film_id = fa.film_id and fa.actor_id = a.actor_id

//films that never rented or banned
select film_id, title, rating from (select film_id from film except
select film_id from (select * from rental r inner join payment p inner join film f inner join inventory i on r.rental_id = p.rental_id 
and r.inventory_id = i.inventory_id and i.film_id = f.film_id)) a inner join (select * from film_list group by FID) b on a.film_id = b.FID


