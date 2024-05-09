
--SORU 1 �R�N SATI�LARI
--'2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' isimli �r�n� sat�n alan m��terilerin a�a��daki �r�n� sat�n al�p almad���na dair bir rapor olu�turman�z gerekiyor.
--1. 'Polk Audio - 50 W Woofer - Black' -- (other_product)
USE SampleRetail

--A = sale.customer
--B = sale.orders
--C = sale.order_item
--D = product.product

SELECT
    A.customer_id AS Customer_Id,
    A.first_name AS First_Name,
    A.last_name AS Last_Name,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM sale.orders B
            JOIN sale.order_item C ON B.order_id = C.order_id
            JOIN product.product D ON C.product_id = D.product_id
            WHERE D.product_name = 'Polk Audio - 50 W Woofer - Black'
            AND B.customer_id = A.customer_id
        ) THEN 'Yes'
        ELSE 'No'
    END AS Other_Product
FROM
    sale.customer A
WHERE EXISTS (
    SELECT 1
    FROM sale.orders B
    JOIN sale.order_item C ON B.order_id = C.order_id
    JOIN product.product D ON C.product_id = D.product_id
    WHERE D.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
    AND B.customer_id = A.customer_id
);


-------------�K�NC� ��Z�M-------------------
/*
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

*/
---------------------------------------------------------------------------------------------------------------------------


--SORU 2 D�N���M ORANI (Conversion Rate)
--A�a��da, bir E-Ticaret �irketi taraf�ndan verilen iki farkl� reklam t�r�ne t�klayarak web sitesini ziyaret eden m��terilerin eylemlerinin bir tablosunu g�r�yorsunuz.
--Her bir Reklam t�r� i�in d�n���m oran�n� d�nd�ren bir sorgu yaz�n�z.


--�lk olarak, tabloyu olu�turup ve de�erleri ekleyelim

CREATE TABLE Actions (
    Visitor_ID INT,
    Adv_Type CHAR(1),
    Action VARCHAR(10)
);

-- De�erleri ekleyelim

INSERT INTO Actions (Visitor_ID, Adv_Type, Action) VALUES
(1, 'A', 'Left'),
(2, 'A', 'Order'),
(3, 'B', 'Left'),
(4, 'A', 'Order'),
(5, 'A', 'Review'),
(6, 'A', 'Left'),
(7, 'B', 'Left'),
(8, 'B', 'Order'),
(9, 'B', 'Review'),
(10, 'A', 'Review');

--Tablomuza bakal�m

SELECT *
FROM dbo.Actions

--�imdi, her bir reklam t�r� (Adv_Type) i�in toplam eylem (Action) ve sipari� say�s�n� alal�m

SELECT 
    Adv_Type,
    COUNT(*) AS Total_Actions,
    SUM(CASE WHEN Action = 'Order' THEN 1 ELSE 0 END) AS Total_Orders
FROM 
    Actions
GROUP BY 
    Adv_Type;

--Son olarak, her bir reklam t�r�(Adv_Type) i�in sipari� d�n���m oranlar�n� (Conversion_Rate) hesaplayal�m

SELECT 
    Adv_Type,
    CAST(SUM(CASE WHEN Action = 'Order' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) AS Conversion_Rate
FROM 
    Actions
GROUP BY 
    Adv_Type;

