/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_UpdateUsuarioXPropiedadDesasociacionPersonaIn
	@proc_description
	@proc_param inPersonaIdentificacion person's doc ID
	@proc_param inPropiedadLote property identifier
	@proc_param inFechaDesasociacionUXP desassociation date
	@proc_param inEventUser 
	@proc_param inEventIP 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_UpdateUsuarioXPropiedadDesasociacionPersonaIn]
	@inPersonaIdentificacion VARCHAR(64),
	@inPropiedadLote VARCHAR(32),
	@inFechaDesasociacionUXP DATE,
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
				SELECT @idPropiedad = [P].[ID]
				FROM [dbo].[Propiedad] AS [P]
				WHERE [P].[Lote] = @inPropiedadLote;

				/* Gets the PK of "UsuarioXPropiedad" using @idUsuario and @idPropiedad */
				DECLARE @idUsuarioXPropiedad INT;
				SELECT @idUsuarioXPropiedad = [UXP].[ID]
				FROM [dbo].[UsuarioXPropiedad] AS [UXP]
				WHERE [IDUsuario] = @idUsuario 
				AND [IDPropiedad] = @idPropiedad
				AND [UXP].[FechaFin] IS NULL
				AND [UXP].[Activo] = 1;

				IF @inFechaDesasociacionUXP IS NULL
					BEGIN
						SET @inFechaDesasociacionUXP = GETDATE();
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
				WHERE [ENT].[Name] = 'Usuario de Propiedad';

				IF @inEventUser IS NULL -- event data
					BEGIN
						SET @inEventUser = 'MunITCR';
					END;

				IF @inEventIP IS NULL -- event data
					BEGIN
						SET @inEventIP = '0.0.0.0';
					END;

				IF (@idUsuarioXPropiedad IS NOT NULL)
					BEGIN
						IF (@idUsuario IS NOT NULL) AND (@idPropiedad IS NOT NULL) 
						AND (@inFechaDesasociacionUXP IS NOT NULL)
							BEGIN
								BEGIN TRANSACTION [disassociateUsuarioXPropiedad]

									/* Get "UsuarioXPropiedad" data before update */
									SET @actualData = ( -- event data
										SELECT 
											[UXP].[IDUsuario] AS [IDUsuario],
											[UXP].[IDPropiedad] AS [IDPropiedad],
											[UXP].[FechaInicio] AS [FechaInicio],
											[UXP].[FechaFin] AS [FechaFin],
											[UXP].[Activo] AS [Activo]
										FROM [dbo].[UsuarioXPropiedad] AS [UXP]
										WHERE [UXP].[ID] = @idUsuarioXPropiedad 
										FOR JSON AUTO
									);

									/* Update "UsuarioXPropiedad" using  @idUsuarioXPropiedad 
									as "Usuario de propiedad" disassociation */
									UPDATE [dbo].[UsuarioXPropiedad]
										SET 
											[IDUsuario] = @idUsuario,
											[IDPropiedad] = @idPropiedad,
											[FechaFin] = @inFechaDesasociacionUXP
									WHERE [UsuarioXPropiedad].[ID] = @idUsuarioXPropiedad;

									/* Get "UsuarioXPropiedad" data after update */
									SET @newData = ( -- event data
										SELECT 
											[UXP].[IDUsuario] AS [IDUsuario],
											[UXP].[IDPropiedad] AS [IDPropiedad],
											[UXP].[FechaInicio] AS [FechaInicio],
											[UXP].[FechaFin] AS [FechaFin],
											[UXP].[Activo] AS [Activo]
										FROM [dbo].[UsuarioXPropiedad] AS [UXP]
										WHERE [UXP].[ID] = @idUsuarioXPropiedad 
										FOR JSON AUTO
									);

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
												@idUsuarioXPropiedad,
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
								COMMIT TRANSACTION [disassociateUsuarioXPropiedad]
							END;
						ELSE
							BEGIN
								/* Cannot update association "Usuario" with "Propiedad" because the "Usuario" with 
								@idUsuario did not exist or "Propiedad" with @idPropiedad 
								did not exist or @inFechaAsociacionUXP did not exist*/
								SET @outResultCode = 5404; 
								RETURN;
							END;
					END;
				ELSE
					BEGIN
						/* Cannot make the disassociation "Usuario" 
						with "Propiedad" because is already disassociated */
						SET @outResultCode = 5406; 
						RETURN;
					END;
			END;
		ELSE
			BEGIN
				/* Cannot update association "Usuario" with "Propiedad" because some params are null */
				SET @outResultCode = 5400; 
				RETURN;
			END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [disassociateUsuarioXPropiedad]
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