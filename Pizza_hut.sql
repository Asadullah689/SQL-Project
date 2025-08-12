create database pizza_hut;
use pizza_hut;
select * from order_details;
select * from orders;
select * from pizza_types;
select * from pizzas;

-- Retrieve the total number of orders placed.
select count(order_id) As total_order  from orders;

-- Calculate the total revenue generated from pizza sales.
select sum(o.quantity *p.price) As total_sales
from order_details as o
join pizzas as p
on o.pizza_id=p.pizza_id;

-- Identify the highest-priced pizza.
select pt. name,p.price
from pizza_types as pt
join pizzas as p
on pt.pizza_type_id=p.pizza_type_id
order by p.price desc
limit 1 ;

-- Identify the most common pizza size ordered.
select p.size,count(od.order_id) as total_order from pizzas as p
join order_details as od
on p.pizza_id=od.pizza_id
group  by p.size
order by total_order desc;

-- List the top 5 most ordered pizza types along with their quantities.
select pt.name,sum(od.quantity) as total_quantity
from pizza_types as pt
left join pizzas as p
   on pt.pizza_type_id=p.pizza_type_id
JOIN order_details AS od
  ON p.pizza_id = od.pizza_id
group by pt.name
order by total_quantity desc
limit 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
select pt.category,
sum(od.quantity) as total_quantity
from pizza_types as pt
 join pizzas as p
   on pt.pizza_type_id=p.pizza_type_id
 JOIN order_details AS od
  ON p.pizza_id = od.pizza_id
  group by pt.category
order by total_quantity desc;

-- Determine the distribution of orders by hour of the day.
select hour(time)as hour,count(order_id) as order_count from orders
group by  hour(time);

-- Join relevant tables to find the category-wise distribution of pizzas.
select category,count(name) as distribution_of_pizzas from pizza_types
group by category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0) from 
(select o.date,
sum(od.quantity) as quantity 
from orders as o
join order_details as od
on o.order_id=od.order_id
group by o.date) as order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.
select pt.name , 
sum(od.quantity *p.price) As Revenue
from pizza_types as pt
join pizzas as p
on pt.pizza_type_id=p.pizza_type_id
join order_details as od
on p.pizza_id=od.pizza_id
group by pt.name 
limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue.
select pt.category , 
round(sum(od.quantity *p.price),0)As Revenue
from pizza_types as pt
join pizzas as p
on pt.pizza_type_id=p.pizza_type_id
join order_details as od
on p.pizza_id=od.pizza_id
group by  pt.category 
order by Revenue desc;

-- Analyze the cumulative revenue generated over time.
SELECT
    o.date,
    ROUND(SUM(p.price * od.quantity), 2) AS daily_revenue,
    ROUND(SUM(SUM(p.price * od.quantity)) OVER (ORDER BY o.date), 2) AS cumulative_revenue
FROM orders AS o
JOIN order_details AS od
    ON o.order_id = od.order_id
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
GROUP BY o.date
ORDER BY o.date;

