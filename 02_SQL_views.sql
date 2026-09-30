-- 2# SQL Views
--- a. Expanded Sales Fact

create view vw_sales_fact as
select 
	sro.txn_id,
	sro.event_time,
	sro.customer_id,
	concat(cm.first_name, ' ', cm.last_name) as customer_name,
	cm.gender,
	extract(year from AGE(
			(select max(event_time)::date + 1 from sales_raw_oltp),
			cast(cm.date_of_birth as date))) as customer_age,
	cm.loyalty_tier,
	sro.product_id,
	prdtl.product_name,
	prdtl.category_name,
	sro.quantity,
	prdtl.retail_price,
	prdtl.unit_cost,
	round(cast(sro.quantity * prdtl.retail_price as numeric), 2) as revenue,
	round(cast(sro.quantity * prdtl.unit_cost as numeric), 2) as cogs,
	round(cast(((sro.quantity * prdtl.retail_price) - (sro.quantity * prdtl.unit_cost)) as numeric), 2) as gross_profit,
	prdtl.supplier_comp,
	sro.store_id,
	sl.store_name,
	sl.store_type,
	sl.region,
	sro.staff_id,
	sr.staff_name,
	sr.job_title,
	sr.is_full_time
from sales_raw_oltp sro
left join customers_master cm on
	cm.customer_id = sro.customer_id
left join(
	select 
		pro.product_id,
		pro.product_name,
		pc.category_name,
		sd.company_name as supplier_comp,
		pro.unit_cost,
		pro.retail_price
	from products_catalog pro
	left join product_categories pc on
		pc.category_id = pro.category_id
	left join supplier_directory sd on 
		sd.supplier_id = pro.supplier_id
) as prdtl on 
	prdtl.product_id = sro.product_id
left join store_locations sl on 
	sl.store_id = sro.store_id
left join staff_records sr on 
	sr.staff_id = sro.staff_id
;
