/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadDetalleCCXFacturaPropiedadIn
	@proc_description 
	@proc_param inPropiedadLote 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_ReadDetalleCCXFacturaPropiedadIn]
	@inPropiedadLote VARCHAR(32),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */
		SELECT 
			[F].[ID] AS [IDFactura],
			[F].[Fecha] AS [FechaFactura],
			[F].[FechaVencimiento] AS [FechaVencimientoFactura],
			[F].[MontoOriginal] AS [MontoOriginalFactura],
			([F].[MontoPagar] - [F].[MontoOriginal]) AS [MorosidadesFactura],
			[F].[MontoPagar] AS [MontoPagarFactura],
			[F].[IDComprobantePago] AS [IDComprobantePago],
			(CASE 
				WHEN [F].[PlanArregloPago] = 0 THEN 'No'
				WHEN [F].[PlanArregloPago] = 1 THEN 'Si'
			END) AS [ArregloPagoFactura],
			(CASE 
				WHEN [F].[Activo] = 0 THEN 'Anulada'
				WHEN [F].[Activo] = 1 THEN 'Activa'
			END) AS [EstadoFactura],
			[DCC].[ID] AS [IDDetalleCC],
			[DCC].[Monto] AS [MontoDetalleCC],
			(CASE 
				WHEN [DCC].[Activo] = 0 THEN 'Anulado'
				WHEN [DCC].[Activo] = 1 THEN 'Activo'
			END) AS [EstadoDetalleCC],
			[CC].[Nombre] AS [ConceptoCobro],
			[PMCC].[Nombre] AS [PeriodoMontoCC],
			[TMCC].[Nombre] AS [TipoMontoCC]
		FROM [dbo].[DetalleCC] AS [DCC] 
			INNER JOIN [dbo].[Factura] AS [F]
			ON [F].[ID] = [DCC].[IDFactura]
			INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
			ON [PXCC].[ID] = [DCC].[IDPropiedadXConceptoCobro]
			INNER JOIN [dbo].[Propiedad] AS [P]
			ON [P].[ID] = [PXCC].[IDPropiedad]
			INNER JOIN [dbo].[ConceptoCobro] AS [CC]
			ON [CC].[ID] = [PXCC].[IDConceptoCobro]
			INNER JOIN [dbo].[PeriodoMontoCC] AS [PMCC]
			ON [PMCC].[ID] = [CC].[IDPeriodoCC]
			INNER JOIN [dbo].[TipoMontoCC] AS [TMCC]
			ON [TMCC].[ID] = [CC].[IDTipoMontoCC]
		WHERE [P].[Lote] = @inPropiedadLote
		ORDER BY [F].[Fecha];
		SET @outResultCode = 5200; /* OK */
	END TRY
	BEGIN CATCH
		IF OBJECT_ID(N'dbo.ErrorLog', N'U') IS NOT NULL /* Check Error table existence */
			BEGIN
				/* Update Error table */
				INSERT INTO [dbo].[ErrorLog] (
					[Username],
					[ErrorNumber],
					[ErrorState],
					[ErrorSeverity],
					[ErrorLine],
					[ErrorProcedure],
					[ErrorMessage],
					[ErrorDateTime]
				) VALUES (
					SUSER_NAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);
				SET @outResultCode = 5504; /* CHECK ErrorLog */
			END;
		ELSE 
			BEGIN
				SET @outResultCode = 5404; /* ERROR : dbo.ErrorLog DID NOT EXIST */
				RETURN;
			END;
	END CATCH;
	SET NOCOUNT OFF;
END;
GO