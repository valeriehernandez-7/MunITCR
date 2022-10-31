/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_UpdatePersonaXPropiedadDesasociacion
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
CREATE OR ALTER PROCEDURE [SP_UpdatePersonaXPropiedadDesasociacion]
	@inPersonaIdentificacion VARCHAR(64),
	@inPropiedadLote VARCHAR(32),
	@inFechaDesasociacionPxP DATE,
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
				/* Gets the PK of "Persona" using @idPersonaIdentificacion */
				DECLARE @idPersona INT;
				SELECT @idPersona = [Per].[ID]
				FROM [dbo].[Persona] AS [Per]
				WHERE [Per].[ValorDocIdentidad] = @inPersonaIdentificacion;

				/* Gets the PK of "Propiedad" using @inPropiedadLote */
				DECLARE @idPropiedad INT;
				SELECT @idPropiedad = [Pro].[ID]
				FROM [dbo].[Propiedad] AS [Pro]
				WHERE [Pro].[Lote] = @inPropiedadLote;

				/* Gets the PK of "PersonaXPropiedad" using @idPersona and @idPropiedad */
				DECLARE @idPersonaXPropiedad INT;
				SELECT @idPersonaXPropiedad = [PXP].[ID]
				FROM [dbo].[PersonaXPropiedad] AS [PXP]
				WHERE [IDPersona] = @idPersona 
				AND [IDPropiedad] = @idPropiedad
				AND [PXP].[FechaFin] IS NULL
				AND [PXP].[Activo] = 1;

				IF @inFechaDesasociacionPxP IS NULL
					BEGIN
						SET @inFechaDesasociacionPxP = GETDATE();
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
				WHERE [ENT].[Name] = 'Propietario de Propiedad';

				IF @inEventUser IS NULL -- event data
					BEGIN
						SET @inEventUser = 'MunITCR';
					END;

				IF @inEventIP IS NULL -- event data
					BEGIN
						SET @inEventIP = '0.0.0.0';
					END;

				IF (@idPersonaXPropiedad IS NOT NULL)
					BEGIN
						IF (@idPersona IS NOT NULL) AND (@idPropiedad IS NOT NULL) 
						AND (@inFechaDesasociacionPxP IS NOT NULL)
							BEGIN
								BEGIN TRANSACTION [disassociatePersonaXPropiedad]

									/* Get "PersonaXPropiedad" data before update */
									SET @actualData = ( -- event data
										SELECT 
											[PXP].[IDPersona] AS [IDPersona],
											[PXP].[IDPropiedad] AS [IDPropiedad],
											[PXP].[FechaInicio] AS [FechaInicio],
											[PXP].[FechaFin] AS [FechaFin],
											[PXP].[Activo] AS [Activo]
										FROM [dbo].[PersonaXPropiedad] AS [PXP]
										WHERE [PXP].[ID] = @idPersonaXPropiedad 
										FOR JSON AUTO
									);

									/* Update "PersonaXPropiedad" using  @idPersonaXPropiedad 
									as "persona de propiedad" disassociation */
									UPDATE [dbo].[PersonaXPropiedad]
										SET 
											[IDPersona] = @idPersona,
											[IDPropiedad] = @idPropiedad,
											[FechaFin] = @inFechaDesasociacionPxP
									WHERE [PersonaXPropiedad].[ID] = @idPersonaXPropiedad;

									/* Get "PersonaXPropiedad" data after update */
									SET @newData = ( -- event data
										SELECT 
											[PXP].[IDPersona] AS [IDPersona],
											[PXP].[IDPropiedad] AS [IDPropiedad],
											[PXP].[FechaInicio] AS [FechaInicio],
											[PXP].[FechaFin] AS [FechaFin],
											[PXP].[Activo] AS [Activo]
										FROM [dbo].[PersonaXPropiedad] AS [PXP]
										WHERE [PXP].[ID] = @idPersonaXPropiedad 
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
								COMMIT TRANSACTION [disassociatePersonaXPropiedad]
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
						/* Cannot make the disassociation "Persona" 
						with "Propiedad" because is already disassociated */
						SET @outResultCode = 5406; 
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
				ROLLBACK TRANSACTION [disassociatePersonaXPropiedad]
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