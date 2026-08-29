-- Query 1: Top 10 Customers by Total Spend
use chinook;
select c.customerid,
concat(c.firstname,'',c.lastname) as customername,c.country,
round(sum(i.total),2) as totalspend
from customer c
join invoice i on c.customerid=i.customerid
group by c.customerid
order by totalspend desc
limit 10;

-- Query 2: Best Selling Genres

use chinook;
select 
g.name as genre,
count(il.trackid) as tracksold,
round(sum(il.unitprice * il.quantity),2) as revenue
from genre g 
join track t on g.genreid = t.genreid
join invoiceline il on t.trackid=il.trackid
group by g.genreid
order by tracksold desc;

-- Query 3: Sales by Country

use chinook;
select
c.country,
count(distinct c.customerid) as totalcustomers,
count(distinct i.invoiceid) as totalorders,
round(sum(i.total),2) as totalrevenue,
round(avg(i.total),2) as avgordervalue
from customer c 
join invoice i on c.customerid=i.customerid
group by c.country
order by totalrevenue desc;

-- Query 4: Top 10 Best Selling Tracks
use chinook;
select
t.name as trackname,
ar.name as artistname,
count(il.invoicelineid) as timesSold,
round(sum(il.unitprice * il.quantity),2) as totalrevenue
from track t
join album al on t.albumid=al.albumid
join artist ar on al.artistid=ar.artistid
join invoiceline il on t.trackid=il.trackid
group by t.trackid
order by timesSold desc
limit 10;

-- Query 5: Employee Sales Performance
use chinook;
select
concat(e.firstname,' ',e.lastname) as employeename,
e.title,
round(sum(i.total),2) as totalsales,
count(distinct i.invoiceid) as totalinvoices
from employee e
join customer c on e.employeeid=c.supportrepid
join invoice i on c.customerid=i.customerid
group by e.employeeid
order by totalsales desc;

-- Query 6: Customers Above Average Spend
-- CTEs (Common Table Expressions)
 use chinook;
 with customerspend as (
 select
 customerid,
 round(sum(total),2) as totalspend
from invoice
group by customerid
),
avgspend as(
select round(avg(totalspend),2) as averagespend
from customerspend
)
select 
c.firstname,
c.lastname,
cs.totalspend,
av.averagespend,
round(cs.totalspend - av.averagespend,2) as aboveaverage
from customerspend cs
cross join avgspend av
join customer c on cs.customerid = c.customerid
where cs.totalspend > av.averagespend
order by cs.totalspend desc
limit 10;

-- Query 7: Monthly Revenue Trend (MoM Change)
use chinook;
with monthlyrevenue as(
select
date_format(invoicedate, '%Y-%m') as month,
round(sum(total),2) as revenue,
count(*) as numinvoices
from invoice
group by date_format(invoicedate, '%Y-%m')
)
select
month,
revenue,
numinvoices,
lag(revenue) over (order by month) as prevMonthRevenue,
round(revenue - lag(revenue) over(order by month),2) as MoM_change
from monthlyrevenue;

-- Query 8: Employee Sales Ranking
-- Window Functions (RANK, NTILE)

use chinook;
select 
concat(e.firstname,' ',e.lastname) as employeename,
e.title,
round(sum(i.total),2) as totalsales,
rank() over(order by sum(i.total) desc) as salesrank,
round(sum(i.total)/sum(sum(i.total)) over () * 100 ,2) as PercentageOfTotal
from employee e
join customer c on e.employeeid=c.supportrepid
join invoice i on c.customerid = i.customerid
group by e.employeeid;

-- Query 9: Customer Lifetime Value Segments
-- NTILE() (Customer Segmentation)

use chinook;
with customerValue as (
select
c.customerid,
concat(c.firstname,' ',c.lastname) as customername,
c.country,
round(sum(i.total),2) as CLV,
ntile(4) over(order by sum(i.total)) as quartile
from customer c
join invoice i on c.customerid=i.customerid
group by c.customerid
)
select
customername,
country,
CLV,
quartile,
case
when quartile=4 then 'champions'
when quartile=3 then 'loyal'
when quartile=2 then 'potential'
else 'at risk'
end as segment
from customervalue
order by CLV desc
limit 15;

-- Query 10: Running Total of Sales by Month



