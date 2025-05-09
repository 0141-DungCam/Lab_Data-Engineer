use BikeStores_DungCam
--1.1. Thống kê danh sách khách hàng:
--    a. Ở bang NY và CA nhưng không bao gồm các thành phố Campbell và Buffalo
select *
from sales.customers c
where 
	c.state in ('NY' , 'CA') 
	and c.city not in ('Campbell' , 'Buffalo')
;

--    b. Không ở bang NY nhưng ngoại trừ thành phố Buffalo, sắp xếp danh sách theo last name và lấy 10 người đầu tiên 
select 
	top 10
	*
from sales.customers c
where 
	(c.state != 'NY' or c.city = 'Buffalo')
order by last_name 
;

--    c. Có số điện thoại, họ hoặc tên có chứa ký tự 'ka', mã id trong khoảng 300 đến 600, sắp xếp danh sách theo bang và city
select *
from sales.customers c
where 
	c.phone is not null and c.phone != ''

	and (c.first_name like '%ka%' or c.last_name like '%ka%')
	
	and c.customer_id between 300 and 600
order by 
	c.state , c.city
;

--2.2. Thống kê số lượng khách hàng:
--    a. theo bang, sắp xếp thanh thứ tự giảm dần về số lượng
select 
	c.state, count (*) total 
from 
	sales.customers c
group by 
	c.state
order by	
	total desc

--    b. theo bang nhưng chỉ lấy các khách hàng có số điện thoại và không bao gồm các thành phố  Campbell và Buffalo
select 
	c.state, count (*) total 
from 
	sales.customers c
where
	c.phone is not null and c.phone != ''
	and ( c.city not in ('Campbell' , 'Buffalo') )
group by 
	c.state
order by	
	total desc

--    c. theo bang nhưng chỉ lấy các bang có số lượng >= 10
select 
	c.state, count(*) total 
from 
	sales.customers c
group by 
	c.state
having
	count (*) >= 10
order by	
	total desc
--    d. theo thành phố của từng bang
select 
	c.state, c.city , count(*) total 
from 
	sales.customers c
group by
	 c.state, c.city

--    e. theo thành phố của từng bang, sắp xếp theo bang tăng dần và số lượng khách hàng giảm dần
select c.state, c.city , count(*) total 
from 
	sales.customers c
group by
	 c.state, c.city
order by
	c.state, total desc

--1.3. Lấy danh sách:
--    a. Bang nào nhiều khách hàng nhất
select
	top 1 c.state, count(*) total 
from 
	sales.customers c
group by
	 c.state
order by 
	total desc

--    b. Top 5 thành phố nào nhiều khách hàng nhất
select 
	top 5 c.state, c.city , count(*) total 
from 
	sales.customers c
group by
	 c.state, c.city
order by
	total desc

--1.4. Lấy danh sách sản phẩm:
--    a. từ năm 2017, có giá >= 500
select
	*
from
	production.products p
where
	p.model_year >= 2017
	and p.list_price >= 500

--    b. trong năm 2016 và 2017, có giá >= giá trung bình của các sản phẩm năm 2018
select
	*
from 
	production.products p
where
	p.model_year in ('2016','2017') 
	and p.list_price >= ( select avg(p.list_price) 
						  from production.products p
						  where p.model_year = '2018')

--1.5. Thông kê:
--    a. số lượng sản phẩm theo model year
SELECT 
    model_year,
    COUNT(*) 
FROM 
    production.products
GROUP BY 
    model_year
ORDER BY 
    model_year
;
--    b. giá trung bình các sản phẩm theo model year
select 
	model_year,
	product_name,
	AVG(list_price)
from
	production.products
group by 
	model_year,
	product_name
order by
	model_year,
	product_name
;