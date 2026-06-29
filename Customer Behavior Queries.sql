CREATE DATABASE shopping_db;
USE shopping_db;
SELECT * FROM customer limit 10;

-- total revenue generated male vs female
SELECT gender, SUM(purchase_amount) as revenue
from customer 
group by gender

-- customer used discount but spent more than avg purchase 
select customer_id, purchase_amount
from customer
where discount_applied = 'Yes' and purchase_amount >= (select AVG(purchase_amount) from customer) 

-- top 5 product with highest review rating 
select item_purchased, ROUND(avg(review_rating),2) as "Average product Rating"
from customer 
group by item_purchased
order by avg(review_rating) desc
limit 5; 

-- avg purchase amt between standard and express shipping 
select shipping_type,
ROUND(avg(purchase_amount),2)
from customer
where shipping_type in ('standard','express')
group by shipping_type

-- COMAPRE subcriber and non-subsriber avg and total spent
select subscription_status,
COUNT(customer_id) as total_customer,
ROUND(AVG(purchase_amount),2) as avg_spend,
ROUND(SUM(purchase_amount),2) as total_spend
from customer
group by subscription_status
order by total_spend, avg_spend desc;

-- highest % of product discount 
select item_purchased,
ROUND(100*sum(case when discount_applied = 'Yes' then 1 else 0 END)/count(*),2) as discount_rate
FROM customer 
group by item_purchased
order by discount_rate desc
limit 5; 

-- SEGMENT CUSTOMER INTO repeted 
with customer_type as (
select customer_id, previous_purchases,
case
when previous_purchases = 1 then 'New'
when previous_purchases between 2 and 10 then 'Returning'
Else 'Loyal'
END as customer_segment 
from customer
)
select customer_segment, count(*) as "Number of customer"
from customer_type 
group by customer_segment

-- top 3 product in each category 
with item_counts as (
select category,
item_purchased,
count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id) desc) as item_rank
from customer
group by category, item_purchased
)
select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <=3; 

-- customer repeted more than 5 time are they subscribers
select subscription_status, 
count(customer_id) as repeat_buyer
from customer
where previous_purchases > 5
group by subscription_status

-- revenue by contribution of each age group 
select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;

