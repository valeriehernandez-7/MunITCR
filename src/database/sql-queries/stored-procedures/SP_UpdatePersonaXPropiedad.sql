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
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_UpdatePersonaXPropiedad]
	@inOldPersonaIdentificacion VARCHAR(64),
	@inOldPropiedadLote CHAR(32),
	@inPersonaIdentificacion VARCHAR(64),
	@inPropiedadLote CHAR(32),
	@inFechaAsociacionPxP DATE,
	@inFechaDesasociacionPxP DATE,
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
		
				IF (@idOldPersona IS NOT NULL) AND (@idPersona IS NOT NULL)
				AND (@idOldPropiedad IS NOT NULL) AND (@idPropiedad IS NOT NULL)
					BEGIN
						BEGIN TRANSACTION [updatePerXPro]
							UPDATE [dbo].[PersonaXPropiedad]
								SET 
									[IDPersona] = @idPersona,
									[IDPropiedad] = @idPropiedad,
									[FechaInicio] = @inFechaAsociacionPxP,
									[FechaFin] = @inFechaDesasociacionPxP
							WHERE [IDPersona] = @idOldPersona 
							AND [IDPropiedad] = @idOldPropiedad 
							SET @outResultCode = 5200; /* OK */
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