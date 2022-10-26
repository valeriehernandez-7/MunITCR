SELECT * FROM information_schema.tables ORDER BY table_name;
GO

SELECT * FROM [dbo].[ErrorLog];
GO

SELECT * FROM [dbo].[EventLog];
GO

SELECT * FROM [dbo].[EventType];
GO

SELECT * FROM [dbo].[EntityType];
GO

SELECT * FROM [dbo].[TipoMovimientoConsumoAgua];
GO

SELECT * FROM [dbo].[PropiedadXCCConsumoAgua];
GO

SELECT * FROM [dbo].[PropiedadXConceptoCobro];
GO

SELECT * FROM [dbo].[Propiedad];
GO

SELECT * FROM [dbo].[Usuario];
GO

SELECT * FROM [dbo].[Persona];
GO

SELECT * FROM [dbo].[TipoUsoPropiedad];
GO

SELECT * FROM [dbo].[TipoZonaPropiedad];
GO

SELECT * FROM [dbo].[TipoDocIdentidad];
GO

SELECT * FROM [dbo].[TipoParametro];
GO

SELECT * FROM [dbo].[Parametro];
GO

SELECT * FROM [dbo].[ParametroInteger];
GO

SELECT * FROM [dbo].[PeriodoMontoCC];
GO

SELECT * FROM [dbo].[TipoMontoCC];
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

SELECT * FROM [dbo].[OrdenReconexion];
GO

SELECT * FROM [dbo].[OrdenCorte];
GO

SELECT * FROM [dbo].[Factura];
GO

SELECT * FROM [dbo].[EstadoFactura];
GO

SELECT * FROM [dbo].[ComprobantePago];
GO

SELECT * FROM [dbo].[MedioPago];
GO

-- *************************************************************

DELETE FROM [dbo].[ErrorLog];
DBCC CHECKIDENT ('[dbo].[ErrorLog]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[EventLog];
DBCC CHECKIDENT ('[dbo].[EventLog]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[EventType];
DBCC CHECKIDENT ('[dbo].[EventType]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[EntityType];
DBCC CHECKIDENT ('[dbo].[EntityType]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[PersonaXPropiedad];
DBCC CHECKIDENT ('[dbo].[PersonaXPropiedad]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[PropiedadXCCConsumoAgua];
GO

DELETE FROM [dbo].[PropiedadXConceptoCobro];
DBCC CHECKIDENT ('[dbo].[PropiedadXConceptoCobro]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[Propiedad];
DBCC CHECKIDENT ('[dbo].[Propiedad]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[Usuario];
DBCC CHECKIDENT ('[dbo].[Usuario]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[Persona];
DBCC CHECKIDENT ('[dbo].[Persona]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[ParametroInteger];
GO

DELETE FROM [dbo].[Parametro];
DBCC CHECKIDENT ('[dbo].[Parametro]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[TipoParametro];
DBCC CHECKIDENT ('[dbo].[TipoParametro]', RESEED, 0) WITH NO_INFOMSGS;
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

DELETE FROM [dbo].[PeriodoMontoCC];
DBCC CHECKIDENT ('[dbo].[PeriodoMontoCC]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[TipoMontoCC];
DBCC CHECKIDENT ('[dbo].[TipoMontoCC]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[OrdenReconexion];
DBCC CHECKIDENT ('[dbo].[OrdenReconexion]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[OrdenCorte];
DBCC CHECKIDENT ('[dbo].[OrdenCorte]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[Factura];
DBCC CHECKIDENT ('[dbo].[Factura]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[EstadoFactura];
DBCC CHECKIDENT ('[dbo].[EstadoFactura]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[ComprobantePago];
DBCC CHECKIDENT ('[dbo].[ComprobantePago]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[MedioPago];
DBCC CHECKIDENT ('[dbo].[MedioPago]', RESEED, 0) WITH NO_INFOMSGS;
GO