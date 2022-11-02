/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadMovimientoConsumoAgua
	@proc_description 
	@proc_param inPropiedadLote 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_ReadMovimientoConsumoAgua]
	@inPropiedadLote VARCHAR(32),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		DECLARE @idPropiedad INT;
		SELECT @idPropiedad = [P].[ID] 
		FROM [dbo].[Propiedad] AS [P]
		WHERE [P].[Lote] = @inPropiedadLote;

		IF (@idPropiedad IS NOT NULL)
			BEGIN 
				SELECT 
					[MCCA].[Fecha] AS [Fecha],
					[TMCA].[Nombre] AS [Tipo],
					[MCCA].[MontoM3] AS [Consumo],
					[MCCA].[LecturaMedidor] AS [Saldo]
				FROM [dbo].[MovimientoConsumoAgua] AS [MCCA]
					INNER JOIN [dbo].[TipoMovimientoConsumoAgua] AS [TMCA] 
					ON [TMCA].[ID] = [MCCA].[IDTipoMovimientoConsumoAgua]
					INNER JOIN [dbo].[PropiedadXCCConsumoAgua] AS [PXCA]
					ON [PXCA].[IDPropiedadXCC] = [MCCA].[IDPropiedadXCCConsumoAgua]
					INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
					ON [PXCC].[ID] = [PXCA].[IDPropiedadXCC]
				WHERE [PXCC].[IDPropiedad] = @idPropiedad
				ORDER BY [MCCA].[Fecha];
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