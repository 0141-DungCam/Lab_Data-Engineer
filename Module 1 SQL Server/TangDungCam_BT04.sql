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
-- 4.5) Thống kê doanh thu bán hàng theo các tháng trong năm 2016
-- 4.6) Thống kê doanh thu bán háng theo các quý trong năm 2016
-- 4.7) Thống kê doanh thu bán hàng theo từng nhân viên sale năm 2016