/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadPropiedadXUsuario
	@proc_description
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_ReadPropiedadXUsuario]
	@inEsAsociacion BIT,
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */
		IF (@inEsAsociacion = 1)
			BEGIN
				SELECT  
					[U].[Username] AS [Usuario],
					[P].[Lote] AS [Propiedad],
					[UXP].[FechaInicio] AS [FechadeRegistro]
				FROM [dbo].[UsuarioXPropiedad] AS [UXP]
					LEFT JOIN [dbo].[Usuario] AS [U]
					ON [UXP].[IDUsuario] = [U].[ID]
					LEFT JOIN [dbo].[Propiedad] AS [P]
					ON [UXP].[IDPropiedad] =  [P].[ID]
				WHERE [UXP].[FechaFin] IS NULL
				AND [UXP].[Activo] = 1
				AND [U].[Activo] = 1 
				AND [P].[Activo] = 1;
			END
		ELSE
			BEGIN
				SELECT  
					[U].[Username] AS [Usuario],
					[P].[Lote] AS [Propiedad],
					[UXP].[FechaInicio] AS [FechadeRegistro]
				FROM [dbo].[UsuarioXPropiedad] AS [UXP]
					LEFT JOIN [dbo].[Usuario] AS [U]
					ON [UXP].[IDUsuario] = [U].[ID]
					LEFT JOIN [dbo].[Propiedad] AS [P]
					ON [UXP].[IDPropiedad] =  [P].[ID]
				WHERE [UXP].[FechaFin] IS NOT NULL
				AND [UXP].[Activo] = 1
				AND [U].[Activo] = 1 
				AND [P].[Activo] = 1;
			END
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