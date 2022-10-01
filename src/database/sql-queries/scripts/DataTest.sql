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

SELECT * FROM [dbo].[Usuario];
GO

SELECT * FROM [dbo].[Persona];
GO


DELETE FROM [dbo].[ErrorLog];
DBCC CHECKIDENT ('[dbo].[ErrorLog]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[Usuario];
DBCC CHECKIDENT ('[dbo].[Usuario]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[Persona];
DBCC CHECKIDENT ('[dbo].[Persona]', RESEED, 0) WITH NO_INFOMSGS;
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

DELETE FROM [dbo].[ParametroInteger];
GO

DELETE FROM [dbo].[TipoParametro];
DBCC CHECKIDENT ('[dbo].[TipoParametro]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[CCConsumoAgua];
GO

DELETE FROM [dbo].[CCImpuestoPropiedad];
GO

DELETE FROM [dbo].[CCBasura];
GO

DELETE FROM [dbo].[CCPatenteComercial];
GO

DELETE FROM [dbo].[CCReconexion];
GO

DELETE FROM [dbo].[CCInteresMoratorio];
GO

DELETE FROM [dbo].[CCMantenimientoParque];
GO

DELETE FROM [dbo].[ConceptoCobro];
DBCC CHECKIDENT ('[dbo].[ConceptoCobro]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[Parametro];
GO

DELETE FROM [dbo].[PeriodoMontoCC];
DBCC CHECKIDENT ('[dbo].[PeriodoMontoCC]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[TipoMontoCC];
DBCC CHECKIDENT ('[dbo].[TipoMontoCC]', RESEED, 0) WITH NO_INFOMSGS;
GO
