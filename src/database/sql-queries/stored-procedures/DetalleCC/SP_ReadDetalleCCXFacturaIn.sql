/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadDetalleCCXFacturaIn
	@proc_description 
	@proc_param inIDFactura 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_ReadDetalleCCXFacturaIn]
	@inIDFactura INT,
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		DECLARE @idFactura INT;
		SELECT @idFactura = [F].[ID]
		FROM [dbo].[Factura] AS [F]
		WHERE [F].[ID] = @inIDFactura
		AND [F].[Activo] = 1;

		IF (@idFactura IS NOT NULL)
			BEGIN
				SELECT 
					[F].[Fecha] AS [Fecha],
					[F].[FechaVencimiento] AS [FechaVencimiento],
					[F].[MontoOriginal] AS [Subtotal],
					([F].[MontoPagar] - [F].[MontoOriginal]) AS [Morosidades],
					[F].[MontoPagar] AS [Total]
				FROM [dbo].[Factura] AS [F]
				WHERE [F].[ID] = @idFactura;

				SELECT 
					[CC].[Nombre] AS [ConceptoCobro],
					[PXCC].[FechaInicio] AS [Asociacion],
					( CASE
						WHEN [PXCC].[FechaFin] IS NULL THEN 'N.A.'
						ELSE CONVERT(VARCHAR, [PXCC].[FechaFin])
					END) AS [Desasociacion],
					[PMCC].[Nombre] AS [PeriodoMontoCC],
					[TMCC].[Nombre] AS [TipoMontoCC],
					(CASE 
						WHEN ([CC].[Nombre] = 'Intereses moratorios') 
						OR ([CC].[Nombre] = 'Reconexion de agua') 
						OR ([CC].[Nombre] = 'Arreglo de pago') 
						THEN 'Morosidad'
						ELSE 'Recurrente'
					END) AS [TipoConceptoCobro],
					[DCC].[Monto] AS [MontoConceptoCobro]
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
				WHERE [F].[ID] = @idFactura
				AND [DCC].[Activo] = 1
				ORDER BY [TipoConceptoCobro] DESC, [PeriodoMontoCC], [TipoMontoCC], [ConceptoCobro];
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