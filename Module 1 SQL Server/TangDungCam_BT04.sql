use BikeStores
-- 4.1) Thống kê danh sách khách hàng đã từng mua hàng
-- cach 1
SELECT DISTINCT
	*
FROM
	customers c
	JOIN orders o ON o.customer_id = c.customer_id;

-- cach 2
SELECT
	*
FROM
	customers c
WHERE
	EXISTS (
		SELECT
			1
		FROM
			orders
		WHERE
			order_status = 4
			AND customer_id = c.customer_id
	);

-- 4.2) Thống kê danh sách khách hàng chưa từng mua hàng lần nào
--cach 1
SELECT
	*
FROM
	customers c
	LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE
	o.customer_id IS NULL;

--cach 2
SELECT
	*
FROM
	customers c
WHERE
	NOT EXISTS (
		SELECT
			1
		FROM
			orders o
		WHERE
			order_status = 4
			AND o.customer_id = c.customer_id
	);

-- 4.3) Thông kê danh sách các sản phẩm chưa từng được bán
SELECT
	*
FROM
	products p
	LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE
	oi.product_id IS NULL
ORDER BY
	p.product_id;

-- 4.4) Thống kê danh sách khách hàng và bổ sung thêm thông tin nếu có (tổng số lần mua hàng, tổng số tiền đã mua, tổng số loại sản phẩm đã mua)
-- cach 1
SELECT
	c.*,
	(
		SELECT
			COUNT(1)
		FROM
			orders o
		WHERE
			o.customer_id = c.customer_id
	) AS total
FROM
	customers c
ORDER BY
	total;

-- cach 2
SELECT
	c.customer_id,
	c.last_name,
	COUNT(o.order_id) total,
	SUM(
		dbo.calc_revenue (oi.quantity, oi.list_price, oi.discount)
	) AS total_money,
	COUNT(DISTINCT oi.product_id) AS total_product, --thống kê số loại sản phẩm đã mua
	COUNT(DISTINCT p.category_id) AS total_category -- thống kê số loại danh mục đã mua
FROM
	customers AS c
	LEFT JOIN orders o ON o.customer_id = c.customer_id
	JOIN order_items oi ON oi.order_id = o.order_id
	JOIN products p ON p.product_id = oi.product_id
GROUP BY
	c.customer_id,
	c.last_name;

-- 4.5) Thống kê doanh thu bán hàng theo các tháng trong năm 2016
SELECT
	MONTH (o.order_date) AS MONTH,
	CASE MONTH (o.order_date)
		WHEN 1 THEN 'Tháng 1'
		WHEN 2 THEN 'Tháng 2'
		WHEN 3 THEN 'Tháng 3'
		WHEN 4 THEN 'Tháng 4'
		WHEN 5 THEN 'Tháng 5'
		WHEN 6 THEN 'Tháng 6'
		WHEN 7 THEN 'Tháng 7'
		WHEN 8 THEN 'Tháng 8'
		WHEN 9 THEN 'Tháng 9'
		WHEN 10 THEN 'Tháng 10'
		WHEN 11 THEN 'Tháng 11'
		WHEN 12 THEN 'Tháng 12'
	END AS MONTH_NAME,
	SUM(
		dbo.calc_revenue (oi.quantity, oi.list_price, oi.discount)
	) AS revenue
FROM
	orders o
	JOIN order_items oi ON oi.order_id = o.order_id
WHERE
	o.order_status = 4
	AND YEAR (order_date) = 2016
GROUP BY
	MONTH (order_date)
ORDER BY
	MONTH;

-- 4.6) Thống kê doanh thu bán háng theo các quý trong năm 2016
SELECT
	(
		CASE
			WHEN MONTH (o.order_date) IN (1, 2, 3) THEN 'Quý 1'
			WHEN MONTH (o.order_date) IN (4, 5, 6) THEN 'Quý 2'
			WHEN MONTH (o.order_date) IN (7, 8, 9) THEN 'Quý 3'
			ELSE 'Quý 4'
		END
	) QUARTER,
	SUM(
		dbo.calc_revenue (oi.quantity, oi.list_price, oi.discount)
	) AS revenue
FROM
	orders o
	JOIN order_items oi ON oi.order_id = o.order_id
WHERE
	o.order_status = 4
	AND YEAR (order_date) = 2016
GROUP BY
	(
		CASE
			WHEN MONTH (o.order_date) IN (1, 2, 3) THEN 'Quý 1'
			WHEN MONTH (o.order_date) IN (4, 5, 6) THEN 'Quý 2'
			WHEN MONTH (o.order_date) IN (7, 8, 9) THEN 'Quý 3'
			ELSE 'Quý 4'
		END
	)
ORDER BY
	QUARTER;

-- cach 2 DATEPART
SELECT
	datepart (YEAR, o.order_date) AS YEAR,
	DATEPART (QUARTER, o.order_date) AS QUARTER,
	SUM(
		dbo.calc_revenue (oi.quantity, oi.list_price, oi.discount)
	) AS revenue
FROM
	orders o
	JOIN order_items oi ON oi.order_id = o.order_id
WHERE
	o.order_status = 4
	AND YEAR (order_date) IN (2016, 2017)
GROUP BY
	datepart (YEAR, o.order_date),
	DATEPART (QUARTER, o.order_date)
ORDER BY
	YEAR,
	QUARTER;

-- 4.7) Thống kê doanh thu bán hàng theo từng nhân viên sale năm 2016
SELECT
	s.first_name + ' ' + s.last_name AS staff_name,
	SUM(
		dbo.calc_revenue (oi.quantity, oi.list_price, oi.discount)
	) AS revenue
FROM
	orders o
	JOIN order_items oi ON oi.order_id = o.order_id
	JOIN staffs s ON s.staff_id = o.staff_id
WHERE
	o.order_status = 4
	AND YEAR (order_date) = 2016
GROUP BY
	s.first_name + ' ' + s.last_name;