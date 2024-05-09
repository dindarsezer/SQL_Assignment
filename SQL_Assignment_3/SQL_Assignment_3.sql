-- SampleRetail veritabanýný kullanarak, indirim oranýndaki artýþýn ürünlerin sipariþ sayýsýný olumlu yönde etkileyip etkilemediðine iliþkin
-- ürün kimliklerini(product ID) ve indirim etkilerini(discount effect) içeren bir rapor oluþturun.

--Satýþý olmayan ürünleride ben tabloda görmek istediðimden tüm product_id leri almak için yeni bir tablo oluþtur
--Oluþturduðun tabloda ayný zamanda her bir ürün için çeþitli indirim oranlarýndaki toplam sipariþ miiktarýný bul 
CREATE VIEW discount_quantity AS
SELECT	B.product_id, discount, SUM(quantity) total_quantity
FROM	sale.order_item AS A
		RIGHT JOIN
		product.product AS B
		ON A.product_id = B.product_id
GROUP BY B.product_id, discount

-- discount_quantity adý verdiðimiz tabloda discount sütundaki indirim oranlarýný sütunlara dönüþtürerek toplam þipariþ miktarlarýný getir
-- Daha sonra kullanabilmek için PIVOT ile oluþturduðumuz bu tabloyu PivotResult adý altýnda yeni bir tablo ekle
CREATE TABLE PivotResult (
    product_id INT,
    [dis_5] INT,
    [dis_7] INT,
    [dis_10] INT,
    [dis_20] INT
);

INSERT INTO PivotResult
SELECT *
FROM
	(
	SELECT product_id, discount, total_quantity
	FROM discount_quantity
	) AS SourceTable
	PIVOT
	(
	SUM(total_quantity)
	FOR discount IN ([0.05], [0.07], [0.10], [0.20])
)	AS PivotTable;


-- Ýndirim oranlarýndaki 5-7-10 luk dilimin averajýný alarak 20 lik dilim ile bir kýyaslama yap
SELECT	product_id,
		(CASE 
            WHEN ((ISNULL(AVG(dis_20), 0) - ISNULL(AVG(dis_5+dis_7+dis_10)/3, 0))) = 0 THEN 'Nötr'
            WHEN ((ISNULL(AVG(dis_20), 0) - ISNULL(AVG(dis_5+dis_7+dis_10)/3, 0))) > 0 THEN 'Positive'
            ELSE 'Negative'
        END) AS Discount_Effect
FROM	PivotResult
GROUP BY product_id;