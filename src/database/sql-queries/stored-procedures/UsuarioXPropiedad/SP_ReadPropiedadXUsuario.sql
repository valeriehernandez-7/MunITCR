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
					[Usr].[Username] AS [Usuario],
					[Pro].[Lote] AS [Propiedad],
					[UxP].[FechaInicio] AS [FechadeRegistro]
				FROM [dbo].[UsuarioXPropiedad] AS [UxP]
					LEFT JOIN [dbo].[Usuario] AS [Usr]
					ON [UxP].[IDUsuario] = [Usr].[ID]
					LEFT JOIN [dbo].[Propiedad] AS [Pro]
					ON [UxP].[IDPropiedad] =  [Pro].[ID]
				WHERE [UxP].[FechaFin] IS NULL
				AND [UxP].[Activo] = 1
				AND [Usr].[Activo] = 1 
				AND [Pro].[Activo] = 1;
			END
		ELSE
			BEGIN
				SELECT  
					[Usr].[Username] AS [Usuario],
					[Pro].[Lote] AS [Propiedad],
					[UxP].[FechaInicio] AS [FechadeRegistro]
				FROM [dbo].[UsuarioXPropiedad] AS [UxP]
					LEFT JOIN [dbo].[Usuario] AS [Usr]
					ON [UxP].[IDUsuario] = [Usr].[ID]
					LEFT JOIN [dbo].[Propiedad] AS [Pro]
					ON [UxP].[IDPropiedad] =  [Pro].[ID]
				WHERE [UxP].[FechaFin] IS NOT NULL
				AND [UxP].[Activo] = 1
				AND [Usr].[Activo] = 1 
				AND [Pro].[Activo] = 1;
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