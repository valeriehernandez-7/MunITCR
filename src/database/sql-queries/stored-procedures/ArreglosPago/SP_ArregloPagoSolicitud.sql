/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ArregloPagoSolicitud
	@proc_description 
	@proc_param inPropiedadLote 
	@proc_param inFechaOperacion 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
	@author <a href="https://github.com/efmz200">Erick F. Madrigal Zavala</a>
*/
CREATE OR ALTER PROCEDURE [SP_ArregloPagoSolicitud]
	@inPropiedadLote VARCHAR(32),
	@inFechaOperacion DATE,
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */ 

		IF (@inFechaOperacion IS NULL)
			BEGIN
				SET @inFechaOperacion = GETDATE();
			END

		DECLARE @propiedadAPActivo INT;
		SELECT @propiedadAPActivo = [P].[ID]
		FROM [dbo].[Propiedad] AS [P]
			INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
			ON [PXCC].[IDPropiedad] = [P].[ID]
			INNER JOIN [dbo].[PropiedadXCCArregloPago] AS [PXAP]
			ON [PXAP].[IDPropiedadXCC] = [PXCC].[ID]
		WHERE [P].[Lote] = @inPropiedadLote
		AND [P].[Lote] IS NOT NULL
		AND [PXCC].[FechaFin] > @inFechaOperacion
		AND [PXAP].[Activo] = 1;


		IF (@inPropiedadLote IS NOT NULL) AND (@propiedadAPActivo IS NULL)
			BEGIN
				/* Get the total ammount from pending bills with more than 1 month of delay */
				DECLARE @MontoPagarAP MONEY;
				SET @MontoPagarAP = (
					SELECT SUM([F].[MontoPagar]) AS [Monto]
					FROM [dbo].[Factura] AS [F]
						INNER JOIN [dbo].[Propiedad] AS [P]
						ON [P].[ID] = [F].[IDPropiedad]
					WHERE 
						DATEDIFF(MONTH, [F].[FechaVencimiento], @inFechaOperacion) > 1
						AND [F].[IDComprobantePago] IS NULL
						AND [F].[PlanArregloPago] = 0
						AND [F].[Activo] = 1
						AND [P].[Lote] = @inPropiedadLote
						AND [P].[Activo] = 1
				);

				IF (@MontoPagarAP IS NOT NULL)
					BEGIN
						SELECT 
							[TI].[PlazoMeses] AS [Plazo],
							([TI].[TasaInteresAnual] * 100) AS [Tasa],
							(@MontoPagarAP / ((1 - (POWER((1 + ([TI].[TasaInteresAnual] / ((360 * 12) / 365))), -[TI].[PlazoMeses]))) / (([TI].[TasaInteresAnual] / ((360 * 12) / 365))))) AS [Cuota],
							@inFechaOperacion AS [Fecha],
							DATEADD(MONTH, [TI].[PlazoMeses], @inFechaOperacion) AS [FechaFin]
						FROM [dbo].[TasaInteres] AS [TI];
						SET @outResultCode = 5200; /* OK */
					END;
			END;
		ELSE
			BEGIN
				/* ERROR : The property based on @inPropiedadLote did not exist
				or already has an active loan plan */
				SET @outResultCode = 5400; /* Error */
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