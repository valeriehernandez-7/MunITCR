USE [MunITCR]
GO

DECLARE 
	@propiedadLote VARCHAR(32),
	@outResultCode INT;

DECLARE @TMPPropiedad TABLE ( 
  [ID] INT IDENTITY(1,1) PRIMARY KEY,
  [PropiedadLote] VARCHAR(32)
);

INSERT INTO @TMPPropiedad
SELECT [P].[Lote] FROM [dbo].[Propiedad] AS [P];

SELECT [TP].[PropiedadLote] FROM @TMPPropiedad AS [TP];

SET @propiedadLote = '';
EXECUTE [SP_ReadDetalleCCPropiedadIn] @propiedadLote, @outResultCode OUTPUT;
