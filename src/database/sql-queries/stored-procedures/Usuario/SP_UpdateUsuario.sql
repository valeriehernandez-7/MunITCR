/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_UpdateUsuario
	@proc_description 
	@proc_param inOldUsername 
	@proc_param inIdentificacionPersona 
	@proc_param inUsername 
	@proc_param inPassword 
	@proc_param inTipoUsuario 
	@proc_param inEventUser 
	@proc_param inEventIP 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_UpdateUsuario]
	@inOldUsername VARCHAR(16),
	@inIdentificacionPersona VARCHAR(64),
	@inUsername VARCHAR(16),
	@inPassword VARCHAR(16),
	@inTipoUsuario VARCHAR(16),
	@inEventUser VARCHAR(16),
	@inEventIP VARCHAR(64),
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
				SELECT @idUsuario = [U].[ID]
				FROM [dbo].[Usuario] AS [U]
				WHERE [U].[Username] = @inOldUsername
				AND [U].[Activo] = 1;

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

				/* Get the event params to create a new register at dbo.EventLog */

				DECLARE 
					@idEventType INT,
					@idEntityType INT,
					@actualData NVARCHAR(MAX), 
					@newData NVARCHAR(MAX);
					
				SELECT @idEventType = [EVT].[ID] -- event data
				FROM [dbo].[EventType] AS [EVT]
				WHERE [EVT].[Name] = 'Update';

				SELECT @idEntityType = [ENT].[ID] -- event data
				FROM [dbo].[EntityType] AS [ENT]
				WHERE [ENT].[Name] = 'Usuario';

				IF @inEventUser IS NULL -- event data
					BEGIN
						SET @inEventUser = 'MunITCR';
					END;

				IF @inEventIP IS NULL -- event data
					BEGIN
						SET @inEventIP = '0.0.0.0';
					END;
				IF (@idUsuario IS NOT NULL) AND (@idPersona IS NOT NULL) 
				AND (@permisosUsuario IS NOT NULL)
					BEGIN
						BEGIN TRANSACTION [updateUsuario]

							/* Get "Usuario" data before update */
							SET @actualData = ( -- event data
								SELECT 
									[U].[IDPersona] AS [IDPersona],
									[U].[Username] AS [Username],
									[U].[Password] AS [Password],
									[U].[Administrador] AS [Administrador],
									[U].[Activo] AS [Activo]
								FROM [dbo].[Usuario] AS [U]
								WHERE [U].[ID] = @idUsuario
								FOR JSON AUTO
							);

							/* Update "Usuario" using  @idUsuario */
							UPDATE [dbo].[Usuario]
								SET 
									[IDPersona] = @idPersona,
									[Username] = @inUsername,
									[Password] = @inPassword,
									[Administrador] = @permisosUsuario
							WHERE [Usuario].[ID] = @idUsuario;

							/* Get "Usuario" data after update */
							SET @newData = ( -- event data
								SELECT 
									[U].[IDPersona] AS [IDPersona],
									[U].[Username] AS [Username],
									[U].[Password] AS [Password],
									[U].[Administrador] AS [Administrador],
									[U].[Activo] AS [Activo]
								FROM [dbo].[Usuario] AS [U]
								WHERE [U].[ID] = @idUsuario
								FOR JSON AUTO
							);

							IF (@idEventType IS NOT NULL) AND (@idEntityType IS NOT NULL) AND (@idUsuario IS NOT NULL)
							AND (@inEventUser IS NOT NULL) AND (@inEventIP IS NOT NULL)
								BEGIN
									INSERT INTO [dbo].[EventLog] (
										[IDEventType],
										[IDEntityType],
										[EntityID],
										[BeforeUpdate],
										[AfterUpdate],
										[Username],
										[UserIP]
									) VALUES (
										@idEventType,
										@idEntityType,
										@idUsuario,
										@actualData,
										@newData,
										@inEventUser,
										@inEventIP
									);
									SET @outResultCode = 5200; /* OK */
								END;
							ELSE
								BEGIN
									/* Cannot insert the new "Evento" because some 
									event's params are null */
									SET @outResultCode = 5408;
									RETURN;
								END;
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