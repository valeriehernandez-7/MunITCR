/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadPersona
	@proc_description 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_ReadPersona]
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */
		SELECT	
			[P].[Nombre], 
			[DI].[Nombre] AS [TipodeIdentificación],
			[P].[ValorDocIdentidad] AS [Identificación],
			[P].[Telefono1] AS [Teléfono1],
			[P].[Telefono2] AS [Teléfono2], 
			[P].[CorreoElectronico] AS [CorreoElectrónico]
		FROM [dbo].[Persona] AS [P]
			LEFT JOIN [dbo].[TipoDocIdentidad] AS [DI]
			ON [P].[IdTipoDocIdentidad] = [DI].[ID]
		WHERE [P].[Activo] = 1
		ORDER BY [P].[ValorDocIdentidad];
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