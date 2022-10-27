-- https://www.w3schools.com/sql/func_sqlserver_convert.asp

DECLARE @referenciaStr VARCHAR(16) = CONCAT(CONVERT(VARCHAR, GETDATE(), 112), '000000');
DECLARE @referenciaInt BIGINT = CAST(@referenciaStr AS BIGINT);

SELECT @referenciaStr AS [Referencia CHAR];
SELECT @referenciaInt AS [Referencia INT];
SELECT @referenciaInt + 999999 AS [Referencia INT + 999999];
