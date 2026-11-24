create database project1;

-- Q1 find the total revenue?
select round(sum(quantity * unit_price),0) as total_revenue from order_details;

-- Q2 Find top 10 selling Products
select product_name,sum(quantity) as sales from products p join order_details r on p.product_id=r.product_id
 group by product_name order by sum(quantity) desc limit 10;
 
 -- Q3  Find the top 3 customers in each region?
 
 with cte as (select r.region,c.customer_name,sum(od.quantity) as sales,dense_rank() over(partition  by region  order by
 sum(od.quantity) desc) as rank_num from orders r join customers c on r.customer_id=c.customer_id
 join order_details od on od.order_id=r.order_id  group by region,customer_name)
 select region,customer_name,sales,rank_num from cte where rank_num<=3;
 
 alter table orders modify column order_date datetime;
 -- Q4 Find the monthly sales?
 select month(r.order_date) as months,sum(od.quantity*od.unit_price) as sales from orders r 
 join order_details od on r.order_id=od.order_id group by month(r.order_date)  ;

-- Q5 Find top 5 customers by revenue?

select  c.customer_name, sum(od.quantity*od.unit_price) as Revenue from customers c
 join orders o on c.customer_id=o.customer_id join order_details od on o.order_id=od.order_id 
 group by customer_name order by sum(od.quantity*od.unit_price) desc limit 5;
 
 -- Q6 calculate running total
 
 with cte as(select  c.customer_name, sum(od.quantity*od.unit_price) as Revenue from customers c
 join orders o on c.customer_id=o.customer_id join order_details od on o.order_id=od.order_id 
 group by customer_name order by sum(od.quantity*od.unit_price) desc)
 select customer_name,Revenue,sum(revenue) over(order by customer_name) as runnin_total from cte;
 
 select * from products;
 
 -- Q7 catagory wise sales?
 
 select p.category,sum(od.quantity*od.unit_price) as sales from products p 
 join order_details od on p.product_id=od.product_id group by category order by sales desc;