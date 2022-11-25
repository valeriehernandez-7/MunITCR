USE [MunITCR]
GO

DECLARE @outResultCode INT;
EXECUTE [dbo].[SP_LoadDataset] NULL, @outResultCode OUTPUT;
SELECT  @outResultCode as N'@outResultCode';
GO
