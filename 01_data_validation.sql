-- 1# Data Validation
--- Brief Summary
select 
    count(*) as total_transaksi,
    count(distinct customer_id) as total_pelanggan_unik,
    count(distinct product_id) as total_produk_unik,
    min(event_time) as transaksi_pertama,
    max(event_time) as transaksi_terakhir
from sales_raw_oltp;

--- Check Null Values
select *
from sales_raw_oltp
where txn_id is null
	or customer_id is null
	or product_id is null
	or store_id is null
	or staff_id is null
	or quantity is null
	or quantity <= 0
	or payment_method is null
	or event_time is null; -- No Null values found

--- Check Data Relation ---

select 
	sro.txn_id,
	sro.customer_id,
	concat(cm.first_name, ' ', cm.last_name) as customer_name,
	sro.product_id,
	prdtl.product_name,
	prdtl.category_name,
	prdtl.supplier_comp,
	sro.store_id,
	sl.store_name,
	sro.staff_id,
	sr.staff_name
from sales_raw_oltp sro
left join customers_master cm on
	cm.customer_id = sro.customer_id
left join(
	select 
		pro.product_id,
		pro.product_name,
		pc.category_name,
		sd.company_name as supplier_comp
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
	sr.staff_id = sro.staff_id; 

 --- Check orphan key ---
select 
	sro.txn_id,
	sro.customer_id,
	concat(cm.first_name, ' ', cm.last_name) as customer_name,
	sro.product_id,
	pro.product_name,
	sro.store_id,
	sl.store_name,
	sro.staff_id,
	sr.staff_name
from sales_raw_oltp sro
left join customers_master cm on
	cm.customer_id = sro.customer_id
left join products_catalog pro on 
	pro.product_id = sro.product_id
left join store_locations sl on 
	sl.store_id = sro.store_id
left join staff_records sr on 
	sr.staff_id = sro.staff_id
where cm.customer_id is null 
   or pro.product_id is null
   or sl.store_id is null 
   or sr.staff_id is null;

select 
	pro.product_id,
	pro.product_name,
	pro.category_id,
	pc.category_name,
	pro.supplier_id,
	sd.company_name as supplier_comp
from products_catalog pro
left join product_categories pc on
	pc.category_id = pro.category_id
left join supplier_directory sd on 
	sd.supplier_id = pro.supplier_id
where pc.category_id is null
   or sd.supplier_id is null;
