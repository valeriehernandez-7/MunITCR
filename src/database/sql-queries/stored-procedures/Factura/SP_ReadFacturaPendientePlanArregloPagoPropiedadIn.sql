/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadFacturaPendientePlanArregloPagoPropiedadIn
	@proc_description 
	@proc_param inPropiedadLote 
	@proc_param outResultCode Procedure return value
*/
CREATE OR ALTER PROCEDURE [SP_ReadFacturaPendientePlanArregloPagoPropiedadIn]
	@inPropiedadLote VARCHAR(32),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF (@inPropiedadLote IS NOT NULL)
			BEGIN
				/* Show all "facturas pendientes" "no anuladas" 
				"asociadas a arreglos de pago" of Property using @inPropiedadLote */
				SELECT 
					[F].[ID] AS [IDFactura],
					[F].[Fecha] AS [Fecha],
					[F].[FechaVencimiento] AS [FechaVencimiento],
					[F].[MontoOriginal] AS [Subtotal],
					([F].[MontoPagar] - [F].[MontoOriginal]) AS [Morosidades],
					[F].[MontoPagar] AS [Total]
				FROM [dbo].[Factura] AS [F]
					INNER JOIN [dbo].[Propiedad] AS [P]
					ON [P].[ID] = [F].[IDPropiedad]
					INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
					ON [PXCC].[IDPropiedad] = [P].[ID]
					INNER JOIN [dbo].[PropiedadXCCArregloPago] AS [PXCCAP]
					ON [PXCCAP].[IDPropiedadXCC] = [PXCC].[ID]
				WHERE [P].[Lote] = @inPropiedadLote
				AND [P].[Activo] = 1
				AND [F].[IDComprobantePago] IS NULL
				AND [F].[PlanArregloPago] = 1
				AND [F].[Activo] = 1
				AND [PXCCAP].[Activo] = 1
				ORDER BY [F].[Fecha];
				SET @outResultCode = 5200; /* OK */
			END;
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