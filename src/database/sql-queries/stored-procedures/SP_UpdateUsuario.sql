/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_UpdateUsuario
	@proc_description 
	@proc_param inIdentificacionPersona 
	@proc_param inUsername 
	@proc_param inPassword 
	@proc_param inTipoUsuario 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_UpdateUsuario]
	@inOldUsername VARCHAR(16),
	@inIdentificacionPersona VARCHAR(64),
	@inUsername VARCHAR(16),
	@inPassword VARCHAR(16),
	@inTipoUsuario VARCHAR(16),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF (@inIdentificacionPersona IS NOT NULL) AND (@inUsername IS NOT NULL) AND  
		(@inPassword IS NOT NULL) AND (@inTipoUsuario IS NOT NULL)
			BEGIN
				/* Gets the PK of "Usuario" using @inOldUsername */
				DECLARE @idUsuario INT;
				SELECT @idUsuario = [Usu].[ID]
				FROM [dbo].[Usuario] AS [Usu]
				WHERE [Usu].[Username] = @inOldUsername
				AND [Usu].[Activo] = 1;

				/* Gets the PK of "Persona" using @inIdentificacionPersona */
				DECLARE @idPersona INT;
				SELECT @idPersona = [P].[ID]
				FROM [dbo].[Persona] AS [P]
				WHERE [P].[ValorDocIdentidad] = @inIdentificacionPersona;

				DECLARE @permisosUsuario BIT =
				CASE @inTipoUsuario
					WHEN 'Propietario' THEN 0
					WHEN 'Administrador' THEN 1
				END;

				IF (@idUsuario IS NOT NULL) AND (@idPersona IS NOT NULL) 
				AND (@permisosUsuario IS NOT NULL)
					BEGIN
						BEGIN TRANSACTION [updateUsuario]
							UPDATE [dbo].[Usuario]
								SET 
									[IDPersona] = @idPersona,
									[Username] = @inUsername,
									[Password] = @inPassword,
									[Administrador] = @permisosUsuario
							WHERE [ID] = @idUsuario;
							SET @outResultCode = 5200; /* OK */
						COMMIT TRANSACTION [updateUsuario]
					END;
				ELSE
					BEGIN
						/* Cannot update the "Usuario" because a person with 
						@inIdentificacionPersona did not exist or 
						@inTipoUsuario did not exist */
						SET @outResultCode = 5404; 
						RETURN;
					END;
			END;
		ELSE
			BEGIN
				/* Cannot update the "Usuario" because some params are null */
				SET @outResultCode = 5400; 
				RETURN;
			END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [updateUsuario]
			END;
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