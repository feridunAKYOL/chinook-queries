-- 1. Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
select c.firstname || " " || c.lastname , c.customerId , c.country
from customer c
where c.country is not "USA"

-- 2. Provide a query only showing the Customers from Brazil.
select *
from customer 
where country  is "Brazil"

-- 3. Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.
select c.firstname, c.lastname, i.invoiceid, i.invoicedate, i.billingcountry
from customer as c, invoice as i
where c.country = 'Brazil' and
c.customerid = i.customerid;

select c.firstname || " " || c.lastname , i.invoiceId , i.invoiceDate, i.billingCountry
from customer c 
inner join invoice i
on c.customerId = i.customerId
where country  is "Brazil"
-- 4. Provide a query showing only the Employees who are Sales Agents.
select * from employee
where employee.title = 'Sales Support Agent';

-- 5. Provide a query showing a unique list of billing countries from the Invoice table.
select distinct billingcountry from invoice;

-- 6. Provide a query showing the invoices of customers who are from Brazil.
select *
from customer as c, invoice as i
where c.country = 'Brazil' and
c.customerid = i.customerid;
------
select * 
from customer c
left join invoice i
on i.customerId = c.customerId
where c.country = "Brazil"


-- 7. Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.
select e.firstname, e.lastname, i.invoiceid, i.customerid, i.invoicedate, i.billingaddress, i.billingcountry, i.billingpostalcode, i.total
from customer as c, invoice as i
on c.customerid = i.customerid
join employee as e
on e.employeeid = c.supportrepid
order by e.employeeid;

-- 8. Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
select e.firstname as 'employee first', e.lastname as 'employee last', c.firstname as 'customer first', c.lastname as 'customer last', c.country, i.total
from employee as e
	join customer as c on e.employeeid = c.supportrepid
	join invoice as i on c.customerid = i.customerid

	-------------------
	select c.firstname || " " || c.lastname as customer, sum( i.total) as totalinvoices , c.country , e.firstname || " " || e.lastname as employee
from customer c , invoice i
on c.customerid = i.customerid
left join employee e
on e.employeeid = c.supportRepId
group by customer

-- 9. How many Invoices were there in 2009 and 2011? What are the respective total sales for each of those years?
select count(i.invoiceid), sum(i.total)
from invoice as i
where i.invoicedate between ('2011-01-01 00:00:00') and ('2011-12-31 00:00:00');
-------------
select count(invoiceId) , sum(invoice.total)
from invoice
where invoicedate like "%2009%" 
-----------------------
select count(i.invoiceid), sum(i.total)
from invoice as i
where i.invoicedate between ('2009-01-01 00:00:00') and ('2009-12-31 00:00:00');

-- 10. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
select count(i.invoicelineid)
from invoiceline as i
where i.invoiceid = 37

-- 11. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: [GROUP BY](http://www.sqlite.org/lang_select.html#resultset)
select invoiceid, count(invoicelineid)
from invoiceline
group by invoiceid

-- 12. Provide a query that includes the track name with each invoice line item.
select i.*, t.name
from invoiceline as i, track as t
on i.trackid = t.trackid
-----------
select i.* , t.name
from invoiceLine i
left join track t
on t.trackId = i.trackId

-- 13. Provide a query that includes the purchased track name AND artist name with each invoice line item.
select i.*, t.name as 'track', ar.name as 'artist'
from invoiceline as i
	join track as t on i.trackid = t.trackid
	join album as al on al.albumid = t.albumid
	join artist as ar on ar.artistid = al.artistid
	---------------
	select *, t.name as "track", a.name as "artist"
from invoiceLine i
left join track t
on i.trackId = t.trackId
left join Album al
on al.AlbumId = t.AlbumId
left join Artist a
on a.ArtistId = al.ArtistId


-- 14. Provide a query that shows the # of invoices per country. HINT: [GROUP BY](http://www.sqlite.org/lang_select.html#resultset)
select billingcountry, count(billingcountry) as '# of invoices'
from invoice
group by billingcountry
------------
select billingcountry , count(i.invoiceId)
from invoice i
group by billingcountry

-- 15. Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resultant table.
select *, count(trackid) as '# of tracks'
from playlisttrack, playlist
on playlisttrack.playlistid = playlist.playlistid
group by playlist.playlistid
-----------
select p.name, count(pt.trackId) as "# tracks"
from playlistTrack as pt, playList p
on pt.playlistId = p.playlistId
group by pt.playlistId

-- 16. Provide a query that shows all the Tracks, but displays no IDs. The resultant table should include the Album name, Media type and Genre.
select t.name as 'track', t.composer, t.milliseconds, t.bytes, t.unitprice, a.title as 'album', g.name as 'genre', m.name as 'media type'
from track as t
	join album as a on a.albumid = t.albumid
	join genre as g on g.genreid = t.genreid
	join mediatype as m on m.mediatypeid = t.mediatypeid
--------------------
select t.name , t.albumid, m.name as "mediatype name", g.name as "genre name",  t.composer, t.milliseconds, t.bytes, t.bytes , t.unitprice, a.title  as"album name"
from track t
left join album a
on a.albumId = t.albumId
left join mediatype m
on m.mediatypeId = t.mediatypeId
left join genre g
on g.genreId = t.genreId

-- 17. Provide a query that shows all Invoices but includes the # of invoice line items.
select invoice.*, count(invoiceline.invoicelineid) as '# of line items'
from invoice, invoiceline
on invoice.invoiceid = invoiceline.invoiceid
group by invoice.invoiceid
------------
select i.* , count(il.invoicelineId) as "# invoice line"
from invoice i
left join invoiceline il
on i.invoiceId = il.invoiceId
group by il.invoiceid

-- 18. Provide a query that shows total sales made by each sales agent.
select e.*, count(i.invoiceid) as 'Total Number of Sales'
from employee as e
	join customer as c on e.employeeid = c.supportrepid
	join invoice as i on i.customerid = c.customerid
group by e.employeeid
----------
select e.title, sum(i.total) as 'Total Sales'
from employee  e
join customer  c 
on e.employeeid = c.supportrepid
join invoice  i
on i.customerid = c.customerid
group by e.employeeid

-- 19. Which sales agent made the most in sales in 2009?
select *, max(total) from
(select e.*, sum(total) as 'Total'
from employee as e
	join customer as c on e.employeeid = c.supportrepid
	join invoice as i on i.customerid = c.customerid
where i.invoicedate between '2009-01-00' and '2009-12-31'
group by e.employeeid)
----------
select * , sum(i.total) as totalSales
from employee e 
left join customer c
on e.employeeid = c.supportRepId
left join invoice i
on i.customerId = c.customerId
where i.invoicedate like "%2009%"
group by e.employeeId
order by totalSales desc
limit 1


-- 20. Which sales agent made the most in sales in 2010?
select *, max(total) from
(select e.*, sum(total) as 'Total'
from employee as e
	join customer as c on e.employeeid = c.supportrepid
	join invoice as i on i.customerid = c.customerid
where i.invoicedate between '2010-01-00' and '2010-12-31'
group by e.employeeid)
------------
select * , sum(i.total) as totalSales
from employee e 
left join customer c
on e.employeeid = c.supportRepId
left join invoice i
on i.customerId = c.customerId
where i.invoicedate like "%2010%"
group by e.employeeId
order by totalSales desc
limit 1

-- 21. Which sales agent made the most in sales over all?
select *, max(total) from
(select e.*, sum(total) as 'Total'
from employee as e
	join customer as c on e.employeeid = c.supportrepid
	join invoice as i on i.customerid = c.customerid
group by e.employeeid)
-----------
select * , sum(i.total) as  maxSales
from employee e 
left join customer c
on e.employeeid = c.supportRepId
inner join invoice i
on i.customerId = c.customerId
group by e.employeeId
order by maxSales desc
limit 1

-- 22. Provide a query that shows the # of customers assigned to each sales agent.
select e.*, count(c.customerid) as 'TotalCustomers'
from employee as e
	join customer as c on e.employeeid = c.supportrepid
group by e.employeeid
-------
select * , count(supportRepId) as total
from employee e
left join customer c
on c.supportRepId = e.employeeId
group by c.supportRepId

-- 23. Provide a query that shows the total sales per country. Which country's customers spent the most?
select i.billingcountry, sum(total) as 'TotalSales'
from invoice as i
group by billingcountry
order by totalsales desc
---------

select c.country as country , sum(i.total) as total
from employee e
left join customer c
on c.supportRepId = e.employeeId
left join invoice i
on c.customerId = i.customerId
group by c.country
order by total desc

-- 24. Provide a query that shows the most purchased track of 2013.
select *, count(t.trackid) as count
from invoiceline as il
	join invoice as i on i.invoiceid = il.invoiceid
	join track as t on t.trackid = il.trackid
where i.invoicedate between '2013-01-01' and '2013-12-31'
group by t.trackid
order by count desc
------------
select t.name, count(il.trackId) as total
from invoiceLine as il
left join track t
on t.trackId = il.trackId
left join invoice i
on i.invoiceId = il.invoiceId
where i.invoicedate like "%2013%"
group by il.trackId
order by total desc

-- 25. Provide a query that shows the top 5 most purchased tracks over all.
select t.name, count(il.trackId) as total
from invoiceLine as il
left join track t
on t.trackId = il.trackId
left join invoice i
on i.invoiceId = il.invoiceId
group by il.trackId
order by total desc
limit 5

-- 26. Provide a query that shows the top 3 best selling artists.

select ar.name, count(il.trackId) as total
from artist as ar
left join album a
on ar.artistId = a.artistId
left join track t
on a.albumId = t.albumId
left join invoiceLine il
on il.trackId = t.trackId
left join invoice i
on i.invoiceId = il.invoiceId
group by a.artistId
order by total desc
limit 3

-- 27. Provide a query that shows the most purchased Media Type.

select m.name as "media type" , count(il.trackId) as total
from mediatype m
left join track t
on m.mediatypeId = t.mediatypeId
left join invoiceLine il
on il.trackId = t.trackId
left join invoice i
on i.invoiceId = il.invoiceId
group by total
order by total desc
limit 1

















