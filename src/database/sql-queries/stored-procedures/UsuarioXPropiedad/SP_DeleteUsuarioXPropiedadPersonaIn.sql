/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_DeleteUsuarioXPropiedadPersonaIn
	@proc_description
	@proc_param inPersonaIdentificacion person's doc ID
	@proc_param inPropiedadLote property identifier
	@proc_param inEventUser 
	@proc_param inEventIP 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_DeleteUsuarioXPropiedadPersonaIn]
	@inPersonaIdentificacion VARCHAR(64),
	@inPropiedadLote VARCHAR(32),
	@inEventUser VARCHAR(16),
	@inEventIP VARCHAR(64),
	@outResultCode INT OUTPUT 
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF (@inPersonaIdentificacion IS NOT NULL) AND (@inPropiedadLote IS NOT NULL)
			BEGIN
				/* Gets the PK of "Usuario" using @inPersonaIdentificacion */
				DECLARE @idUsuario INT;
				SELECT @idUsuario = [U].[ID]
				FROM [dbo].[Usuario] AS [U]
					INNER JOIN [dbo].[Persona] AS [P]
					ON [P].[ID] = [U].[IDPersona]
				WHERE [P].[ValorDocIdentidad] = @inPersonaIdentificacion;
				
				/* Gets the PK of "Propiedad" using @inPropiedadLote */
				DECLARE @idPropiedad INT;
				SELECT @idPropiedad = [Pro].[ID]
				FROM [dbo].[Propiedad] AS [Pro]
				WHERE [Pro].[Lote] = @inPropiedadLote;

				/* Gets the PK of "UsuarioXPropiedad" using @idUsuario and @idPropiedad */
				DECLARE @idUsuarioXUsuario INT;
				SELECT @idUsuarioXUsuario = [UXP].[ID]
				FROM [dbo].[UsuarioXPropiedad] AS [UXP]
				WHERE [IDUsuario] = @idUsuario 
				AND [IDPropiedad] = @idPropiedad
				AND [UXP].[Activo] = 1;

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
				WHERE [ENT].[Name] = 'Usuario de Propiedad';

				IF @inEventUser IS NULL -- event data
					BEGIN
						SET @inEventUser = 'MunITCR';
					END;

				IF @inEventIP IS NULL -- event data
					BEGIN
						SET @inEventIP = '0.0.0.0';
					END;

				IF (@idUsuarioXUsuario IS NOT NULL)
					BEGIN
						BEGIN TRANSACTION [deleteUsuarioXPropiedad]

							/* Get "UsuarioXPropiedad" data before delete */
							SET @actualData = ( -- event data
								SELECT 
									[UXP].[IDUsuario] AS [IDUsuario],
									[UXP].[IDPropiedad] AS [IDPropiedad],
									[UXP].[FechaInicio] AS [FechaInicio],
									[UXP].[FechaFin] AS [FechaFin],
									[UXP].[Activo] AS [Activo]
								FROM [dbo].[UsuarioXPropiedad] AS [UXP]
								WHERE [UXP].[ID] = @idUsuarioXUsuario 
								FOR JSON AUTO
							);

							/* Delete "UsuarioXPropiedad" using  @idUsuarioXUsuario 
							as setting off "Activo" */
							UPDATE [dbo].[UsuarioXPropiedad]
								SET [Activo] = 0
							WHERE [UsuarioXPropiedad].[ID] = @idUsuarioXUsuario;

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
										@idUsuarioXUsuario,
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
						COMMIT TRANSACTION [deleteUsuarioXPropiedad]
					END;
				ELSE
					BEGIN
						/* Cannot delete the "UsuarioXPropiedad" because did not exist based on @idUsuarioXUsuario */
						SET @outResultCode = 5404; 
						RETURN;
					END;
			END;
		ELSE
			BEGIN
				/* Cannot delete association "Usuario" with "Propiedad" because some params are null */
				SET @outResultCode = 5400; 
				RETURN;
			END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [deleteUsuarioXPropiedad]
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