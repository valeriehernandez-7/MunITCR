/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadPropiedadXCCArregloPagoPropiedadIn
	@proc_description 
	@proc_param inPropiedadLote 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_ReadPropiedadXCCArregloPagoPropiedadIn]
	@inPropiedadLote VARCHAR(32),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF (@inPropiedadLote IS NOT NULL)
			BEGIN
				/* Show active "arreglos de pago" of Property based on @inPropiedadLote */
				SELECT 
					[TI].[PlazoMeses] AS [PlazoEnMeses],
					([TI].[TasaInteresAnual] * 100) AS [TasaInteresAnual],
					[PXCCAP].[MontoOriginal] AS [MontodeDeuda],
					[PXCCAP].[MontoAcumuladoAmortizacion] AS [MontodeAmortizacion],
					[PXCCAP].[MontoAcumuladoAplicado] AS [MontoCancelado],
					[PXCCAP].[MontoSaldo] AS [Saldo],
				FROM [dbo].[PropiedadXCCArregloPago] AS [PXCCAP]
					INNER JOIN [dbo].[TasaInteres] AS [TI]
					ON [TI].[ID] = [PXCCAP].[IDTasaInteres]
					INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
					ON [PXCC].[ID] = [PXCCAP].[IDPropiedadXCC]
					INNER JOIN [dbo].[Propiedad] AS [P]
					ON [P].[ID] = [PXCC].[IDPropiedad]
				WHERE [P].[Lote] = @inPropiedadLote
				AND [P].[Activo] = 1
				AND [PXCCAP].[Activo] = 1
				AND [PXCC].[FechaFin] IS NULL
				ORDER BY [PXCC].[FechaInicio];
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