USE [MunITCR]
GO

DECLARE @XMLPath NVARCHAR(MAX);
DECLARE @outResultCode INT;
EXECUTE [dbo].[SP_LoadDataset] @XMLPath, @outResultCode OUTPUT;
SELECT  @outResultCode as N'@outResultCode';
GO
