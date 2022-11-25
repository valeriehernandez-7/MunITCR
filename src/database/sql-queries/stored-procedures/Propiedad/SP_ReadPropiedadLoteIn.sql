/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadPropiedadLoteIn
	@proc_description 
	@proc_param inPropiedadLote 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_ReadPropiedadLoteIn]
	@inPropiedadLote VARCHAR(32),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */
		SELECT	
			[P].[Lote] AS [Propiedad],
			[TU].[Nombre] AS [UsoPropiedad], 
			[TZ].[Nombre] AS [ZonaPropiedad],
			[P].[MetrosCuadrados] AS [MetrosCuadradosPropiedad],
			[P].[ValorFiscal] AS [ValorFiscalPropiedad], 
			[P].[FechaRegistro] AS [FechadeRegistroPropiedad],
			(CASE 
				WHEN [P].[Activo] = 0 THEN 'Inactiva'
				WHEN [P].[Activo] = 1 THEN 'Activa'
			END) AS [EstadoPropiedad]
		FROM [dbo].[Propiedad] AS [P]
			INNER JOIN [dbo].[TipoUsoPropiedad] AS [TU]
			ON [TU].[ID] = [P].[IDTipoUsoPropiedad]
			INNER JOIN [dbo].[TipoZonaPropiedad] AS [TZ]
			ON [TZ].[ID] = [P].[IDTipoZonaPropiedad]
		WHERE [P].[Lote] = @inPropiedadLote;
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