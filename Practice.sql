select state 
from customers

select name, unit_price, (unit_price * 1.1) as new_price
from products

select *
from customers 
-- where points > 3000
-- take note of compaarison operators
where birth_date > '1990-01-01'

select * 
from customers
where birth_date > '1990-01-01' AND points >1000 or state = 'va'

select * 
from order_items
where order_id = 6 and unit_price * quantity > 30

select *
from customers
-- where state in ('il','fl','gco','ma')
where state not in ('il','fl','gco','ma')

select *
from products
where quantity_in_stock in (49, 38, 72)

select *
from customers
where birth_date between '1990-01-01' and '2000-01-01'


select *
from customers
where last_name regexp 'b[r,u]|se'


select * 
from customers
order by state desc, first_name desc
-- unique to mysql:
select first_name, last_name, 10 as points 
from customers
order by state, points
-----
select *, quantity * unit_price  as total_price
from order_items
order by total_price

select * 
from customers
where
order by points desc
limit 3

-- JOINS
-- to show customers and their orders
select o.order_id, c.first_name, c.last_name, o.customer_id
from orders o
join customers c
on o.customer_id = c.customer_id

select o.order_id, o.product_id, p.name
from order_items o
join products p
on o.product_id = p.product_id

-- JOINING ACROSS DATABASES
select *
from order_items o
join sql_inventory.products p
on o.product_id = p.product_id

-- SELF JOIN
select e.employee_id,e.first_name,m.first_name
from employees e
join employees m
on e.reports_to = m.employee_id
 
-- JOINING MULTIPLE TABLES
select *
from orders o
join customers c
on o.customer_id = c.customer_id
join order_statuses os
on o.status = os.order_status_id

-- to give name of client as well as paymet method
select p. date, p.amount, p.client_id, c.name, pm.name
from payments p
join payment_methods pm
on p.payment_method = pm.payment_method_id
join clients c
on p.client_id = c.client_id

-- COMPOUND JOINS
select * 
from order_items oi
join order_item_notes oin
on oi.order_id = oin.order_id
and oi.product_id = oin.product_id


-- IMPLICIT JOIN
select *
from orders o, customers c
where o.customer_id = c.customer_id
-- normal join syntax 
select *
from orders o
join customers c
on o.customer_id = c.customer_id


-- OUTER JOINS
select c.customer_id, c.first_name, o.order_id
from orders o
right join customers c
on o.customer_id = c.customer_id
order by c.customer_id

-- products and order items tablle
select p.product_id, p.name, o.quantity
from products p
left join order_items o
on p.product_id = o.product_id
 
-- OUTER JOINS BETWEEN MULTIPLE TABLES
select c.customer_id, c.first_name, o.order_id, s.shipper_id, s.name as shipper
from orders o
right join customers c
on o.customer_id = c.customer_id
left join shippers s
on o.shipper_id = s.shipper_id
order by c.customer_id

-- SELF OUTER JOINS
select e.employee_id, e.first_name, m.first_name
from employees e
left join employees m
on e.reports_to = m.employee_id

-- 'USING' CLAUSE (specific to mysql)
-- if the column name is exactly the same you can replace the ON clause with USING
select o.order_id, c.first_name, s.name as shipping
from orders o
join  customers c
using (customer_id)
left join shippers s
using (shipper_id)
-- 'USING' keyword with compound JOIN
select *
from order_items oi
join order_item_notes on
using (order_id, product_id)

select p.date, p.amount, pm.name, c.name
from payments p
join payment_methods pm
on p.payment_method = pm.payment_method_id
join clients c
using (client_id)


-- CROSS JOIN
-- implicit syntax
select s.name, p.name
from shippers s
cross join products p
-- explicit syntax
select s.name, p.name
from shippers s, products p
 
 
-- UNIONS
select order_id, order_date, 'active' as status
from orders
where order_date >= '2019-01-01'
union
select order_id, order_date, 'archived' as status
from orders
where order_date < '2019-01-01'
-----------

select customer_id, first_name, points, 'bronze' as type
from customers
where points < 2000
union
select customer_id, first_name, points, 'silver' as type
from customers
where points between 2000 and 3000
union
select customer_id, first_name, points, 'gold' as type
from customers
where points > 3000
order by first_name

-- INSERTING A SINGLE ROW
insert into customers
values (default, 'Mosh', 'Pitt', NULL, NULL, 'baruwa', 'lagos', 'LA', default)

insert into customers(first_name, last_name, address, city, state)
values (default, 'Laura', 'Oshkosh', NULL, NULL, 'ipaja', 'lagos', 'LA', default)
-- inserting multiple rows
insert into shippers (name)
values ('shipper1'),
	   ('shipper2'),
	   ('shipper3')

--------------------------------------
insert into products 
values (default, 'product1', 10, 10.4),
	   (default, 'product1', 10, 10.4),
       (default, 'product1', 10, 10.4)
-- or
insert into products (name, quantity_in_stock, unit_price)
values ('product11', 10, 10.4),
	   ('product12', 10, 10.4),
       ('product13', 10, 10.4) 
 
 -- INSERTING HEIRACHIAL ROWS
 -- a parent child relationship where one record in one table can lead to multiple records in another table
 
 -- COPYING TABLES 
 create table order_archived as
 select * from orders
-- a subquery is a select statement that is part of another sql statement
 insert into order_archived
 select *
 from orders
 where order_date < '2019-01-01'
 ------------------------------
 create table invoice_archived as
 select i.invoice_id, i.number, c.name as client, 
		i.invoice_total, i.payment_total,
        i.invoice_date, i.payment_date,
        i.due_date
 from invoices i
 join clients c
 on i.client_id = c.client_id
 where payment_date is not null
 
-- UPDATING A SINGLE ROW
 update invoices
 set payment_total = invoice_total + 130, payment_date = due_date
 where invoice_id = 1

update invoices
set payment_total = 130, payment_date = '2020-11-11'
where invoice_id = 3
 
-- UPDATING MULTIPLE ROWS
update invoices
set payment_total = invoice_total + 130, payment_date = due_date
-- where client_id = 5
where client_id in (4,5)
---------------------------
update customers
set points = points + 50
where birth_date < '1990-01-01'
 
-- USING SUBQUERIWS IN UPDATE STATEMENT
update orders
set comments = 'gold customer'
where customer_id in (
    select customer_id
	from customers
	where points > 3000
    )
 
 
-- DELETING DATA
delete from invoices
where client_id = (
select client_id
from clients
where name = 'myworks'
 ) 
 


