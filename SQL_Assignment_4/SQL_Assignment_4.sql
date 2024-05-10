/*
Assignment - 4
QUESTION:	Create a scalar-valued function that returns the factorial of a number you gave it.
SORU:		Verdiğiniz bir sayının faktöriyelini döndüren skaler değerli bir fonksiyon oluşturun.

Faktöriyel, bir tam sayının kendisi ile 1 arasındaki tüm pozitif tam sayıların çarpımıdır.
Matematiksel olarak,
n! = n×(n−1)×(n−2)×…×2×1
*/

CREATE FUNCTION Factorial (@number INT)
RETURNS INT
AS
BEGIN
		DECLARE	@value INT = 1, @end INT = 1

		WHILE @end <= @number
			BEGIN
				SET	@value = @value * @end
				SET	@end = @end + 1
			END	
		RETURN @value
END;

SELECT dbo.Factorial (0)
SELECT dbo.Factorial (1)
SELECT dbo.Factorial (2)
SELECT dbo.Factorial (3)
SELECT dbo.Factorial (4)
SELECT dbo.Factorial (5)
SELECT dbo.Factorial (6)

