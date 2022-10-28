/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_CreateUsuario
	@proc_description 
	@proc_param inIdentificacionPersona 
	@proc_param inUsername 
	@proc_param inPassword 
	@proc_param inTipoUsuario 
	@proc_param inEventUser 
	@proc_param inEventIP 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_CreateUsuario]
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
					@lastEntityID INT,
					@actualData NVARCHAR(MAX), 
					@newData NVARCHAR(MAX);

				SELECT @idEventType = [EVT].[ID] -- event data
				FROM [dbo].[EventType] AS [EVT]
				WHERE [EVT].[Name] = 'Create';

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

				IF (@idPersona IS NOT NULL) AND (@permisosUsuario IS NOT NULL)
					BEGIN
						IF NOT EXISTS (SELECT 1 FROM [dbo].[Usuario] AS [U] WHERE [U].[IDPersona] = @idPersona)
							BEGIN
								IF NOT EXISTS (SELECT 1 FROM [dbo].[Usuario] AS [U] WHERE [U].[Username] = @inUsername)
									BEGIN
										BEGIN TRANSACTION [insertUsuario]
											INSERT INTO [dbo].[Usuario] (
												[IDPersona],
												[Username],
												[Password],
												[Administrador]
											) VALUES (
												@idPersona,
												@inUsername,
												@inPassword,
												@permisosUsuario
											);

											SET @lastEntityID = SCOPE_IDENTITY(); -- event data

											SET @newData = ( -- event data
												SELECT 
													[U].[IDPersona] AS [IDPersona],
													[U].[Username] AS [Usuario],
													[U].[Password] AS [Contrasena],
													[U].[Administrador] AS [Administrador],
													[U].[Activo] AS [Activo]
												FROM [dbo].[Usuario] AS [U]
												WHERE [U].[ID] = @lastEntityID
												FOR JSON AUTO
											);

											IF (@idEventType IS NOT NULL) AND (@idEntityType IS NOT NULL) AND (@lastEntityID IS NOT NULL)
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
														@lastEntityID,
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
										COMMIT TRANSACTION [insertUsuario]
									END;
								ELSE
									BEGIN
										/* Cannot insert the new "Usuario" because it already 
										exists based on the @inUsername */
										SET @outResultCode = 5407;
										RETURN;
									END;
							END;
						ELSE
							BEGIN
								/* Cannot insert the new "Usuario" because the "Persona" already 
								has their "Usuario" based on the @inIdentificacionPersona */
								SET @outResultCode = 5406;
								RETURN;
							END;
					END;
				ELSE
					BEGIN
						/* Cannot insert the new "Usuario" because a person with 
						@inIdentificacionPersona did not exist or @inTipoUsuario did not exist */
						SET @outResultCode = 5404; 
						RETURN;
					END;
			END;
		ELSE
			BEGIN
				/* Cannot insert the new "Usuario" because some params are null */
				SET @outResultCode = 5400; 
				RETURN;
			END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [insertUsuario]
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