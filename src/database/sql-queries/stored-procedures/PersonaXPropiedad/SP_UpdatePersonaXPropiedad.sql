/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_UpdatePersonaXPropiedad
	@proc_description
	@proc_param inPersonaIdentificacion person's doc ID
	@proc_param inPropiedadLote property identifier
	@proc_param inFechaAsociacionPxP association date
	@proc_param inFechaDesasociacionPxP desassociation date
	@proc_param inEventUser 
	@proc_param inEventIP 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_UpdatePersonaXPropiedad]
	@inOldPersonaIdentificacion VARCHAR(64),
	@inOldPropiedadLote VARCHAR(32),
	@inPersonaIdentificacion VARCHAR(64),
	@inPropiedadLote VARCHAR(32),
	@inFechaAsociacionPxP DATE,
	@inFechaDesasociacionPxP DATE,
	@inEventUser VARCHAR(16),
	@inEventIP VARCHAR(64),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF (@inOldPersonaIdentificacion IS NOT NULL) AND (@inOldPropiedadLote IS NOT NULL)
		AND (@inPersonaIdentificacion IS NOT NULL) AND (@inPropiedadLote IS NOT NULL)
		AND (@inFechaAsociacionPxP IS NOT NULL)
			BEGIN
				/* Gets the PK of old "Persona" using @idPersonaIdentificacion */
				DECLARE @idOldPersona INT;
				SELECT @idOldPersona = [Per].[ID]
				FROM [dbo].[Persona] AS [Per]
				WHERE [Per].[ValorDocIdentidad] = @inOldPersonaIdentificacion;

				/* Gets the PK of new "Persona" using @idPersonaIdentificacion */
				DECLARE @idPersona INT;
				SELECT @idPersona = [Per].[ID]
				FROM [dbo].[Persona] AS [Per]
				WHERE [Per].[ValorDocIdentidad] = @inPersonaIdentificacion;

				/* Gets the PK of old "Propiedad" using @inPropiedadLote */
				DECLARE @idOldPropiedad INT;
				SELECT @idOldPropiedad = [Pro].[ID]
				FROM [dbo].[Propiedad] AS [Pro]
				WHERE [Pro].[Lote] = @inOldPropiedadLote;

				/* Gets the PK of new "Propiedad" using @inPropiedadLote */
				DECLARE @idPropiedad INT;
				SELECT @idPropiedad = [Pro].[ID]
				FROM [dbo].[Propiedad] AS [Pro]
				WHERE [Pro].[Lote] = @inPropiedadLote;

				DECLARE @idPersonaXPropiedad INT;
				SELECT @idPersonaXPropiedad = [PerXPro].[ID]
				FROM [dbo].[PersonaXPropiedad] AS [PerXPro]
				WHERE [IDPersona] = @idOldPersona 
				AND [IDPropiedad] = @idOldPropiedad;
		
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
				WHERE [ENT].[Name] = 'Propietario de Propiedad';

				IF @inEventUser IS NULL -- event data
					BEGIN
						SET @inEventUser = 'MunITCR';
					END;

				IF @inEventIP IS NULL -- event data
					BEGIN
						SET @inEventIP = '0.0.0.0';
					END;

				IF (@idPersona IS NOT NULL) AND (@idPropiedad IS NOT NULL)
				AND (@idPersonaXPropiedad IS NOT NULL)
					BEGIN
						BEGIN TRANSACTION [updatePerXPro]

							/* Get "PersonaXPropiedad" data before update */
							SET @actualData = ( -- event data
								SELECT 
									[PerXPro].[IDPersona] AS [IDPersona],
									[PerXPro].[IDPropiedad] AS [IDPropiedad],
									[PerXPro].[FechaInicio] AS [FechadeAsociacion],
									[PerXPro].[FechaFin] AS [FechadeDesasociacion],
									[PerXPro].[Activo] AS [Activo]
								FROM [dbo].[PersonaXPropiedad] AS [PerXPro]
								WHERE [PerXPro].[ID] = @idPersonaXPropiedad 
								FOR JSON AUTO
							);

							/* Update "PersonaXPropiedad" using  @idPersonaXPropiedad */
							UPDATE [dbo].[PersonaXPropiedad]
								SET 
									[IDPersona] = @idPersona,
									[IDPropiedad] = @idPropiedad,
									[FechaInicio] = @inFechaAsociacionPxP,
									[FechaFin] = @inFechaDesasociacionPxP
							WHERE [PersonaXPropiedad].[ID] = @idPersonaXPropiedad;

							/* Get "PersonaXPropiedad" data after update */
							SET @newData = ( -- event data
								SELECT 
									[PerXPro].[IDPersona] AS [IDPersona],
									[PerXPro].[IDPropiedad] AS [IDPropiedad],
									[PerXPro].[FechaInicio] AS [FechadeAsociacion],
									[PerXPro].[FechaFin] AS [FechadeDesasociacion],
									[PerXPro].[Activo] AS [Activo]
								FROM [dbo].[PersonaXPropiedad] AS [PerXPro]
								WHERE [PerXPro].[ID] = @idPersonaXPropiedad 
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
										@idPersonaXPropiedad,
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
						COMMIT TRANSACTION [updatePerXPro]
					END;
				ELSE
					BEGIN
						/* Cannot update association "Persona" with "Propiedad" because the "Persona" with 
						@idPersona/@idOldPersona did not exist or "Propiedad" with @idPropiedad/@idOldPropiedad 
						did not exist or @inFechaAsociacionPxP did not exist*/
						SET @outResultCode = 5404; 
						RETURN;
					END;
			END;
		ELSE
			BEGIN
				/* Cannot update association "Persona" with "Propiedad" because some params are null */
				SET @outResultCode = 5400; 
				RETURN;
			END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [updatePerXPro]
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