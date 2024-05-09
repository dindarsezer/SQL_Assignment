-- SampleRetail veritaban�n� kullanarak, indirim oran�ndaki art���n �r�nlerin sipari� say�s�n� olumlu y�nde etkileyip etkilemedi�ine ili�kin
-- �r�n kimliklerini(product ID) ve indirim etkilerini(discount effect) i�eren bir rapor olu�turun.

--Sat��� olmayan �r�nleride ben tabloda g�rmek istedi�imden t�m product_id leri almak i�in yeni bir tablo olu�tur
--Olu�turdu�un tabloda ayn� zamanda her bir �r�n i�in �e�itli indirim oranlar�ndaki toplam sipari� miiktar�n� bul 
CREATE VIEW discount_quantity AS
SELECT	B.product_id, discount, SUM(quantity) total_quantity
FROM	sale.order_item AS A
		RIGHT JOIN
		product.product AS B
		ON A.product_id = B.product_id
GROUP BY B.product_id, discount

-- discount_quantity ad� verdi�imiz tabloda discount s�tundaki indirim oranlar�n� s�tunlara d�n��t�rerek toplam �ipari� miktarlar�n� getir
-- Daha sonra kullanabilmek i�in PIVOT ile olu�turdu�umuz bu tabloyu PivotResult ad� alt�nda yeni bir tablo ekle
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


-- �ndirim oranlar�ndaki 5-7-10 luk dilimin averaj�n� alarak 20 lik dilim ile bir k�yaslama yap
SELECT	product_id,
		(CASE 
            WHEN ((ISNULL(AVG(dis_20), 0) - ISNULL(AVG(dis_5+dis_7+dis_10)/3, 0))) = 0 THEN 'N�tr'
            WHEN ((ISNULL(AVG(dis_20), 0) - ISNULL(AVG(dis_5+dis_7+dis_10)/3, 0))) > 0 THEN 'Positive'
            ELSE 'Negative'
        END) AS Discount_Effect
FROM	PivotResult
GROUP BY product_id;