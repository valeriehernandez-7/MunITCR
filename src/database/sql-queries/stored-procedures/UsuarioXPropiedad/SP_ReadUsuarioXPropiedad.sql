/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadUsuarioXPropiedad
	@proc_description 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_ReadUsuarioXPropiedad]
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY 
		SET @outResultCode = 0; /* Unassigned code */
		SELECT  
			[U].[Username] AS [Usuario],
			[Pro].[Lote] AS [Propiedad],
			[UXP].[FechaInicio] AS [FechadeAsociación],
			[UXP].[FechaFin] AS [FechadeDesasociación]
		FROM [dbo].[UsuarioXPropiedad] AS [UXP]
			INNER JOIN [dbo].[Usuario] AS [U]
			ON [U].[ID] = [UXP].[IDUsuario]
			INNER JOIN [dbo].[Propiedad] AS [Pro]
			ON [Pro].[ID] = [UXP].[IDPropiedad]
			INNER JOIN [dbo].[Persona] AS [Per]
			ON [Per].[ID] = [U].[IDPersona]
		WHERE [UXP].[Activo] = 1
		AND [U].[Activo] = 1
		AND [Pro].[Activo] = 1
		AND [Per].[Activo] = 1;
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