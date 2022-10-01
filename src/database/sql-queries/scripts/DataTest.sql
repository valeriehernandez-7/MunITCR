SELECT * FROM information_schema.tables ORDER BY table_name;
GO

SELECT * FROM [dbo].[ErrorLog];
GO

SELECT * FROM [dbo].[TipoMovimientoConsumoAgua];
GO

SELECT * FROM [dbo].[TipoUsoPropiedad];
GO

SELECT * FROM [dbo].[TipoZonaPropiedad];
GO

SELECT * FROM [dbo].[TipoDocIdentidad];
GO

SELECT * FROM [dbo].[MedioDePago];
GO

SELECT * FROM [dbo].[PeriodoMontoCC];
GO

SELECT * FROM [dbo].[TipoMontoCC];
GO

SELECT * FROM [dbo].[TipoParametro];
GO

SELECT * FROM [dbo].[Parametro];
GO

SELECT * FROM [dbo].[ParametroInteger];
GO

SELECT * FROM [dbo].[ConceptoCobro];
GO

SELECT * FROM [dbo].[CCConsumoAgua];
GO

SELECT * FROM [dbo].[CCImpuestoPropiedad];
GO

SELECT * FROM [dbo].[CCBasura];
GO

SELECT * FROM [dbo].[CCPatenteComercial];
GO

SELECT * FROM [dbo].[CCReconexion];
GO

SELECT * FROM [dbo].[CCInteresMoratorio];
GO

SELECT * FROM [dbo].[CCMantenimientoParque];
GO


DELETE FROM [dbo].[ErrorLog];
DBCC CHECKIDENT ('[dbo].[ErrorLog]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[TipoMovimientoConsumoAgua];
DBCC CHECKIDENT ('[dbo].[TipoMovimientoConsumoAgua]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[TipoUsoPropiedad];
DBCC CHECKIDENT ('[dbo].[TipoUsoPropiedad]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[TipoZonaPropiedad];
DBCC CHECKIDENT ('[dbo].[TipoZonaPropiedad]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[TipoDocIdentidad];
DBCC CHECKIDENT ('[dbo].[TipoDocIdentidad]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[MedioDePago];
DBCC CHECKIDENT ('[dbo].[MedioDePago]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[PeriodoMontoCC];
DBCC CHECKIDENT ('[dbo].[PeriodoMontoCC]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[TipoMontoCC];
DBCC CHECKIDENT ('[dbo].[TipoMontoCC]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[ParametroInteger];
DBCC CHECKIDENT ('[dbo].[TipoParametro]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[Parametro];
DBCC CHECKIDENT ('[dbo].[TipoParametro]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[TipoParametro];
DBCC CHECKIDENT ('[dbo].[TipoParametro]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[ConceptoCobro];
DBCC CHECKIDENT ('[dbo].[TipoParametro]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[CCConsumoAgua];
DBCC CHECKIDENT ('[dbo].[CCConsumoAgua]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[CCImpuestoPropiedad];
DBCC CHECKIDENT ('[dbo].[CCImpuestoPropiedad]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[CCBasura];
DBCC CHECKIDENT ('[dbo].[CCBasura]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[CCPatenteComercial];
DBCC CHECKIDENT ('[dbo].[CCPatenteComercial]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[CCReconexion];
DBCC CHECKIDENT ('[dbo].[CCReconexion]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[CCInteresMoratorio];
DBCC CHECKIDENT ('[dbo].[CCInteresMoratorio]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[CCMantenimientoParque];
DBCC CHECKIDENT ('[dbo].[CCMantenimientoParque]', RESEED, 0) WITH NO_INFOMSGS;
GO
