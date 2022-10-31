USE [MunITCR]
GO

/* SHOW ALL DB TABLES NAME */
SELECT * FROM information_schema.tables ORDER BY table_name;
GO

-- *************************************************************

/* SHOW ALL DB TABLES AUTOMATIC */
DECLARE @sqlText VARCHAR(MAX) = '';
SELECT @sqlText = @sqlText + ' SELECT * FROM ' + QUOTENAME(NAME) + CHAR(13) 
FROM SYS.TABLES
WHERE NAME <> 'sysdiagrams'
ORDER BY NAME;
EXEC(@sqlText);

-- *************************************************************

/* SHOW DB TABLE */

 SELECT * FROM [CCBasura]  
 SELECT * FROM [CCConsumoAgua]  
 SELECT * FROM [CCImpuestoPropiedad]  
 SELECT * FROM [CCInteresMoratorio]  
 SELECT * FROM [CCMantenimientoParque]  
 SELECT * FROM [CCPatenteComercial]  
 SELECT * FROM [CCReconexion]  
 SELECT * FROM [ComprobantePago]  
 SELECT * FROM [ConceptoCobro]  
 SELECT * FROM [DetalleCC]  
 SELECT * FROM [DetalleCCConsumoAgua]  
 SELECT * FROM [EntityType]  
 SELECT * FROM [ErrorLog]  
 SELECT * FROM [EventLog] ORDER BY [DateTime] DESC  
 SELECT * FROM [EventType]  
 SELECT * FROM [Factura]  
 SELECT * FROM [MedioPago]  
 SELECT * FROM [MovimientoConsumoAgua]  
 SELECT * FROM [OrdenCorte]  
 SELECT * FROM [OrdenReconexion]  
 SELECT * FROM [Parametro]  
 SELECT * FROM [ParametroInteger]  
 SELECT * FROM [ParametroMoney]  
 SELECT * FROM [ParametroPorcentaje]  
 SELECT * FROM [ParametroTexto]  
 SELECT * FROM [PeriodoMontoCC]  
 SELECT * FROM [Persona]  
 SELECT * FROM [PersonaXPropiedad]  
 SELECT * FROM [Propiedad]  
 SELECT * FROM [PropiedadXCCConsumoAgua]  
 SELECT * FROM [PropiedadXConceptoCobro]  
 SELECT * FROM [TipoDocIdentidad]  
 SELECT * FROM [TipoMontoCC]  
 SELECT * FROM [TipoMovimientoConsumoAgua]  
 SELECT * FROM [TipoParametro]  
 SELECT * FROM [TipoUsoPropiedad]  
 SELECT * FROM [TipoZonaPropiedad]  
 SELECT * FROM [Usuario]  
 SELECT * FROM [UsuarioXPropiedad] 
 

-- *************************************************************

/* CLEAR DB TABLE */

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

DELETE FROM [dbo].[DetalleCCConsumoAgua];
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

DELETE FROM [dbo].[ParametroMoney];
GO

DELETE FROM [dbo].[ParametroPorcentaje];
GO

DELETE FROM [dbo].[ParametroTexto];
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

-- *************************************************************

/* DELETE DB STORED PROCEDURES */

DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql += N'DROP PROCEDURE dbo.'+ QUOTENAME(name) + ';' FROM sys.procedures
WHERE name LIKE N'sp[_]%'
AND SCHEMA_NAME(schema_id) = N'dbo';
EXEC sp_executesql @sql;