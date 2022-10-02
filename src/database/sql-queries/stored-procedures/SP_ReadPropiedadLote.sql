/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadPropiedadLote
	@proc_description 
	@proc_param inUsuario User requesting the operation
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_ReadPropiedadLote]
	@inUsuario VARCHAR(16), 
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		/* Get the user permisions */
		DECLARE @tipoUsuario INT;
		SELECT @tipoUsuario = [U].[Administrador]
		FROM [dbo].[Usuario] AS [U]
		WHERE [U].[Username] = @inUsuario;

		 /* Admin user is able to see all the active properties on DB */
		IF (@tipoUsuario = 1)
			BEGIN
				SELECT [P].[Lote] AS [Propiedad]
				FROM [dbo].[Propiedad] AS [P]
				WHERE [P].[Activo] = 1
				ORDER BY [P].[Lote];		
			END;
		/* Regular user is able to see only the active properties 
		associate to their username  on DB */
		ELSE
			BEGIN
				SELECT [P].[Lote] AS [Propiedad]
				FROM [dbo].[Propiedad] AS [P]
					LEFT JOIN [dbo].[Usuario] AS [U]
					ON [U].[ID] = [P].[IDUsuario]
				WHERE [P].[Activo] = 1 AND [U].[Username] = @inUsuario
				ORDER BY [P].[Lote];
			END;
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