/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadTasasInteresSolictudAPIn
	@proc_description 
	@proc_param inPropiedadLote 
	@proc_param outResultCode Procedure return value
*/
CREATE OR ALTER PROCEDURE [SP_ReadTasasInteresSolictudAPIn]
	@inPropiedadLote VARCHAR(32),
	@inFechaOperacion DATE,
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */
		DECLARE @TotalAPagar Money;
		IF (@inFechaOperacion IS NULL)
				BEGIN
					SET @inFechaOperacion = GETDATE();
				END

		IF (@inPropiedadLote IS NOT NULL)
			BEGIN

			/* get the total ammount from Pending bills with more than 2 months of delay */
			SET @TotalAPagar = (
				SELECT 
					SUM(F.MontoPagar) AS Monto  
				FROM [dbo].[Factura] AS F
				LEFT JOIN [dbo].[Propiedad] AS P 
				ON 
					[P].[ID]=[F].[IDPropiedad]
				WHERE 
					DATEDIFF(MONTH, [F].[FechaVencimiento], @inFechaOperacion) > 1
					AND [P].Lote = @inPropiedadLote
					AND [P].Activo = 1
					AND [F].[Activo] = 1
			);
								
				SELECT 
					PlazoMeses AS Plazo,
					TasaInteresAnual*100 AS Tasa,
					(@TotalAPagar/PlazoMeses + @TotalAPagar*(TasaInteresAnual/12)) AS Cuota,
					DATEADD(month, PlazoMeses, GETDATE()) AS FechaFin
				FROM [dbo].[TasaInteres]

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