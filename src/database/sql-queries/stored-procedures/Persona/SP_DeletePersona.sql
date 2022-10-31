/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_DeletePersona
	@proc_description 
	@proc_param inIdentificacion 
	@proc_param inEventUser 
	@proc_param inEventIP 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_DeletePersona]
	@inIdentificacion VARCHAR(32),
	@inEventUser VARCHAR(16),
	@inEventIP VARCHAR(64),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF (@inIdentificacion IS NOT NULL)
			BEGIN
				/* Gets the PK of "Persona" using @inIdentificacion */
				DECLARE @idPersona INT;
				SELECT @idPersona = [Per].[ID]
				FROM [dbo].[Persona] AS [Per]
				WHERE [Per].[ValorDocIdentidad] = @inIdentificacion
				AND [Per].[Activo] = 1;

				/* Get the event params to create a new register at dbo.EventLog */

				DECLARE 
					@idEventType INT,
					@idEntityType INT,
					@actualData NVARCHAR(MAX), 
					@newData NVARCHAR(MAX);

				SELECT @idEventType = [EVT].[ID] -- event data
				FROM [dbo].[EventType] AS [EVT]
				WHERE [EVT].[Name] = 'Delete';

				SELECT @idEntityType = [ENT].[ID] -- event data
				FROM [dbo].[EntityType] AS [ENT]
				WHERE [ENT].[Name] = 'Persona';

				IF @inEventUser IS NULL -- event data
					BEGIN
						SET @inEventUser = 'MunITCR';
					END;

				IF @inEventIP IS NULL -- event data
					BEGIN
						SET @inEventIP = '0.0.0.0';
					END;

				IF (@idPersona IS NOT NULL)
					BEGIN
						BEGIN TRANSACTION [deletePersona]
							
							/* Get "Persona" data before delete */
							SET @actualData = ( -- event data
								SELECT 
									[P].[Nombre] AS [Nombre],
									[P].[IdTipoDocIdentidad] AS [IdTipoDocIdentidad],
									[P].[ValorDocIdentidad] AS [ValorDocIdentidad],
									[P].[Telefono1] AS [Telefono1],
									[P].[Telefono2] AS [Telefono2], 
									[P].[CorreoElectronico] AS [CorreoElectronico],
									[P].[Activo] AS [Activo]
								FROM [dbo].[Persona] AS [P]
								WHERE [P].[ID] = @idPersona
								FOR JSON AUTO
							);

							/* Delete of "Persona" using  @idPersona 
							as setting off "Activo" */
							UPDATE [dbo].[Persona]
								SET [Activo] = 0
							WHERE [Persona].[ID] = @idPersona;

							IF (@idEventType IS NOT NULL) AND (@idEntityType IS NOT NULL) 
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
										@idPersona,
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
									SET @outResultCode = 5407;
									RETURN;
								END;

						COMMIT TRANSACTION [deletePersona]
					END;
				ELSE
					BEGIN
						/* Cannot delete the "Persona" because did not exist based on @idPersona */
						SET @outResultCode = 5404; 
						RETURN;
					END;
			END;
		ELSE
			BEGIN
				/* Cannot delete the "Persona" because some params are null */
				SET @outResultCode = 5400; 
				RETURN;
			END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [deletePersona]
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