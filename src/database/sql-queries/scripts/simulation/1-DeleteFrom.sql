USE [MunITCR]
GO

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

DELETE FROM [dbo].[OrdenReconexion];
DBCC CHECKIDENT ('[dbo].[OrdenReconexion]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[OrdenCorte];
DBCC CHECKIDENT ('[dbo].[OrdenCorte]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[DetalleCCConsumoAgua];
DBCC CHECKIDENT ('[dbo].[DetalleCCConsumoAgua]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[DetalleCCArregloPago];
DBCC CHECKIDENT ('[dbo].[DetalleCCArregloPago]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[DetalleCC];
DBCC CHECKIDENT ('[dbo].[DetalleCC]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[Factura];
DBCC CHECKIDENT ('[dbo].[Factura]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[ComprobantePago];
DBCC CHECKIDENT ('[dbo].[ComprobantePago]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[MedioPago];
DBCC CHECKIDENT ('[dbo].[MedioPago]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[PersonaXPropiedad];
DBCC CHECKIDENT ('[dbo].[PersonaXPropiedad]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[MovimientoArregloPago];
DBCC CHECKIDENT ('[dbo].[MovimientoArregloPago]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[PropiedadXCCArregloPago];
GO

DELETE FROM [dbo].[TasaInteres];
DBCC CHECKIDENT ('[dbo].[TasaInteres]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[MovimientoConsumoAgua];
DBCC CHECKIDENT ('[dbo].[MovimientoConsumoAgua]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[PropiedadXCCConsumoAgua];
GO

DELETE FROM [dbo].[PropiedadXConceptoCobro];
DBCC CHECKIDENT ('[dbo].[PropiedadXConceptoCobro]', RESEED, 0) WITH NO_INFOMSGS;
GO

DELETE FROM [dbo].[UsuarioXPropiedad];
DBCC CHECKIDENT ('[dbo].[UsuarioXPropiedad]', RESEED, 0) WITH NO_INFOMSGS;
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

DELETE FROM [dbo].[TipoMovimientoArregloPago];
DBCC CHECKIDENT ('[dbo].[TipoMovimientoArregloPago]', RESEED, 0) WITH NO_INFOMSGS;
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

DELETE FROM [dbo].[CCArregloPago];
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
