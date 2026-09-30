---EDA by Customer
select
	min(customer_age) min_cust_age,
	max(customer_age) max_cust_age,
	avg(customer_age) avg_age,
	avg(quantity) avg_qty_pertxn,
	avg(revenue) avg_revenue_pertxn
from vw_sales_fact;

select 
	loyalty_tier,
	count(distinct customer_id) total_cust,
	count(txn_id) as txn_qty,
	sum(revenue) as total_revenue,
	sum(gross_profit) total_gross_profit
from vw_sales_fact
group by loyalty_tier
order by total_revenue desc;


select 
	gender,
	count(distinct customer_id) total_cust,
	count(distinct txn_id) as txn_qty,
	sum(quantity) as total_qty,
	sum(revenue) as total_revenue
from vw_sales_fact
group by gender
order by total_revenue desc;

select
	case 
		when customer_age between 18 and 24 then 'Young Adult'
		when customer_age between 25 and 39 then 'Adult'
		when customer_age between 40 and 59 then 'Middle-Aged'
		else 'Senior'
	end as age_group,
	count(distinct customer_id) total_cust,
	count(distinct txn_id) as txn_qty,
	sum(quantity) as total_qty,
	sum(revenue) as total_revenue,
	sum(revenue)/count(distinct customer_id) as revenue_per_cust
from vw_sales_fact
group by age_group
order by total_revenue desc
;	

select 
	customer_id,
	customer_name,
	count(distinct txn_id) as txn_qty,
	sum(quantity) as total_qty,
	sum(revenue) as total_revenue
from vw_sales_fact
group by customer_id, customer_name
order by total_revenue desc
limit 10; -- Top 10 cust by revenue

--- EDA by Product
select 
	category_name,
	sum(revenue) as total_revenue
from vw_sales_fact
group by category_name
order by total_revenue desc
;

select 
	product_name,
	category_name,
	sum(quantity) as total_qty,
	sum(revenue) as total_revenue
from vw_sales_fact
group by product_name, category_name
order by total_revenue desc
limit 10
;

select 
	product_name,
	category_name,
	sum(quantity) as total_qty,
	sum(revenue) as total_revenue
from vw_sales_fact
group by product_name, category_name
order by total_qty desc
;


select
	product_id,
	product_name,
	category_name,
	sum(quantity) as total_qty,
	case 
		when sum(quantity) >= avg(sum(quantity)) over() then 'Above Avg'
		else 'Under Avg'
	end qty_performance
from vw_sales_fact
group by product_id, product_name, category_name
order by product_id;
