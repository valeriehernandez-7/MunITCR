USE [MunITCR]
GO

DECLARE @outResultCode INT;
EXECUTE [dbo].[SP_LoadDataset] NULL, @outResultCode OUTPUT;
SELECT  @outResultCode as N'@outResultCode';
GO

DECLARE @sqlText VARCHAR(MAX) = '';
SELECT @sqlText = @sqlText + ' SELECT * FROM ' + QUOTENAME(NAME) + CHAR(13) 
FROM SYS.TABLES
WHERE NAME <> 'sysdiagrams'
ORDER BY NAME;
EXEC(@sqlText);
GO