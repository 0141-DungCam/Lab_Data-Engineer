use BikeStores
--2.1. Tính doanh thu (bảng order_items)
--    a. doanh thu của tất cả các sản phẩm
select 
	sum ( list_price * quantity * ( 1 - discount ) )
from 
	order_items
;

--    b. doanh thu theo từng mã sản phẩm (product id), top 5 sản phẩm bán chạy nhất
select 
	top 5 product_id,
	sum ( list_price * quantity * ( 1 - discount ) ) revenue
from 
	order_items
group by
	product_id
order by
	revenue desc
;

--    c. doanh thu theo mã hóa đơn (order id), top 5 hóa đơn bán chạy nhất
select 
	top 5 order_id,
	sum ( list_price * quantity * ( 1 - discount ) ) revenue
from
	order_items
group by 
	order_id
order by 
	revenue desc
;

--2.2) Thống kê doanh thu theo sản phẩm
select
	p.product_name, p.product_id , sum( oi.quantity * oi.list_price * ( 1 - oi.discount) ) as revenue
from
	orders o
		join order_items oi on oi.order_id = o.order_id
		join products p on oi.product_id = p.product_id
where 
	o.order_status = 4
group by	
	p.product_name, p.product_id
order by
	revenue desc
;

--2.3) Top 10 sản phẩm bán tốt nhất theo doanh thu
select top 10
	p.product_name, p.product_id , sum( oi.quantity * oi.list_price * ( 1 - oi.discount) ) as revenue
from
	orders o
		join order_items oi on oi.order_id = o.order_id
		join products p on oi.product_id = p.product_id
where 
	o.order_status = 4
group by	
	p.product_name, p.product_id
order by
	revenue desc
;

--2.4) Top 10 sản phẩm bán chạy nhất theo số lượng
select top 10
	p.product_name, p.product_id , sum( oi.quantity ) as total
from
	orders o
		join order_items oi on oi.order_id = o.order_id
		join products p on oi.product_id = p.product_id
where 
	o.order_status = 4
group by	
	p.product_name, p.product_id
order by
	total desc
;

--2.5) Trung bình bán được bao nhiêu sản phẩm
select
	p.product_name, p.product_id , avg( oi.quantity ) as average
from
	orders o
		join order_items oi on oi.order_id = o.order_id
		join products p on oi.product_id = p.product_id
where 
	o.order_status = 4
group by	
	p.product_name, p.product_id
order by
	average desc
;

