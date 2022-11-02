/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadPersonaInXPropiedad
	@proc_description 
	@proc_param inPersonaIdentificacion 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_ReadPersonaInXPropiedad]
	@inPersonaIdentificacion VARCHAR(64),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */
		SELECT 
			[Pro].[Lote] AS [Propiedad],
			[PXP].[FechaInicio] AS [FechadeAsociación],
			[PXP].[FechaFin] AS [FechadeDesasociación]
		FROM [dbo].[PersonaXPropiedad] AS [PXP]
			LEFT JOIN [dbo].[Persona] AS [Per]
			ON [PXP].[IDPropiedad] = [Per].[ID]
			LEFT JOIN [dbo].[Propiedad] AS [Pro]
			ON [PXP].[IDPropiedad] =  [Pro].[ID]
		WHERE [Per].[ValorDocIdentidad] = @inPersonaIdentificacion
		AND [PXP].[Activo] = 1
		AND [Per].[Activo] = 1
		AND [Pro].[Activo] = 1;
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