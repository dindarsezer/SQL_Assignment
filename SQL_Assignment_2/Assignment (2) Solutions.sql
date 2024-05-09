


---Session 9

----Assignment-2



--1. Product sales

 CREATE VIEW V_PRODUCT_1 AS
 SELECT DISTINCT d.customer_id, d.first_name, d.last_name
 FROM	product.product AS A
		INNER JOIN 
		sale.order_item AS B
		ON A.product_id = B.product_id
		INNER JOIN
		sale.orders AS C
		ON B.order_id = C.order_id
		INNER JOIN
		sale.customer AS D
		ON C.customer_id = D.customer_id
WHERE	A.product_name =  '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' 




 CREATE VIEW V_PRODUCT_2 AS
 SELECT DISTINCT d.customer_id, d.first_name, d.last_name
 FROM	product.product AS A
		INNER JOIN 
		sale.order_item AS B
		ON A.product_id = B.product_id
		INNER JOIN
		sale.orders AS C
		ON B.order_id = C.order_id
		INNER JOIN
		sale.customer AS D
		ON C.customer_id = D.customer_id
WHERE	product_name = 'Polk Audio - 50 W Woofer - Black'



SELECT	A.*, CASE WHEN B.customer_id IS NULL THEN 'NO' ELSE 'YES' END other_product_is_purchased
FROM	V_PRODUCT_1 AS A
		LEFT JOIN
		V_PRODUCT_2 AS B
		ON	A.customer_id = B.customer_id
ORDER BY other_product_is_purchased



SELECT	A.*, 
		B.first_name,
		ISNULL(B.first_name, 'NO'),
		NULLIF(ISNULL(B.first_name, 'NO'), A.first_name),
		ISNULL(NULLIF(ISNULL(B.first_name, 'NO'), A.first_name), 'YES') other_product
FROM	V_PRODUCT_1 AS A
		LEFT JOIN
		V_PRODUCT_2 AS B
		ON	A.customer_id = B.customer_id


SELECT	A.*, 
		ISNULL(NULLIF(ISNULL(B.first_name, 'NO'), A.first_name), 'YES') other_product
FROM	V_PRODUCT_1 AS A
		LEFT JOIN
		V_PRODUCT_2 AS B
		ON	A.customer_id = B.customer_id







SELECT	A.*, CASE WHEN B.customer_id IS NULL THEN 'NO' ELSE 'YES' END other_product_is_purchased
FROM	( 
			SELECT DISTINCT d.customer_id, d.first_name, d.last_name
			 FROM	product.product AS A
					INNER JOIN 
					sale.order_item AS B
					ON A.product_id = B.product_id
					INNER JOIN
					sale.orders AS C
					ON B.order_id = C.order_id
					INNER JOIN
					sale.customer AS D
					ON C.customer_id = D.customer_id
			WHERE	A.product_name =  '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' 
		) AS A
		LEFT JOIN
		(
		 SELECT DISTINCT d.customer_id, d.first_name, d.last_name
		 FROM	product.product AS A
				INNER JOIN 
				sale.order_item AS B
				ON A.product_id = B.product_id
				INNER JOIN
				sale.orders AS C
				ON B.order_id = C.order_id
				INNER JOIN
				sale.customer AS D
				ON C.customer_id = D.customer_id
		WHERE	product_name = 'Polk Audio - 50 W Woofer - Black'
		) AS B
		ON	A.customer_id = B.customer_id
ORDER BY other_product_is_purchased



---2. Conversion rate


CREATE TABLE advertisement 
(
visitor_id INT ,
adv_type CHAR(1),
action_type varchar(15)

)

INSERT advertisement 
VALUES			(1,'A', 'Left'),
				(2,'A', 'Order'),
				(3,'B', 'Left'),
				(4,'A', 'Order'),
				(5,'A', 'Review'),
				(6,'A', 'Left'),
				(7,'B', 'Left'),
				(8,'B', 'Order'),
				(9,'B', 'Review'),
				(10,'A', 'Review')






SELECT	adv_type, 
		COUNT(visitor_id) total_visitor,
		SUM(CASE WHEN action_type = 'Order' THEN 1 ELSE 0 END) cnt_order,
		CAST (1.0* SUM(CASE WHEN action_type = 'Order' THEN 1 ELSE 0 END) / COUNT(visitor_id) AS decimal(3,2)) AS conversion_rate
FROM	advertisement
GROUP BY adv_type




WITH T1 AS (
			SELECT	adv_type, 
					COUNT(visitor_id) total_visitor,
					SUM(CASE WHEN action_type = 'Order' THEN 1 ELSE 0 END) cnt_order
			FROM	advertisement
			GROUP BY adv_type
			)
SELECT adv_type, CAST (1.0* cnt_order / total_visitor AS decimal(3,2)) AS conversion_rate
FROM T1











