/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_CreatePersonaXPropiedad
	@proc_description
	@proc_param inPersonaIdentificacion person's doc ID
	@proc_param inPropiedadLote property identifier
	@proc_param inFechaAsociacionPxP association date
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_CreatePersonaXPropiedad]
	@inPersonaIdentificacion VARCHAR(64),
	@inPropiedadLote CHAR(32),
	@inFechaAsociacionPxP DATE,
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

				IF @inFechaAsociacionPxP IS NULL
					BEGIN
						SET @inFechaAsociacionPxP = GETDATE();
					END;
		
				IF (@idPersona IS NOT NULL) AND (@idPropiedad IS NOT NULL) AND (@inFechaAsociacionPxP IS NOT NULL)
					BEGIN
						IF NOT EXISTS (SELECT 1 FROM [dbo].[PersonaXPropiedad] AS [PXP] 
						WHERE [PXP].[IDPersona] = @idPersona AND [PXP].[IDPropiedad] = @idPropiedad)
							BEGIN
								BEGIN TRANSACTION [insertPerXPro]
									INSERT INTO [dbo].[PersonaXPropiedad] (
										[IDPersona],
										[IDPropiedad],
										[FechaInicio]
									) VALUES (
										@idPersona,
										@idPropiedad,
										@inFechaAsociacionPxP
									);
									SET @outResultCode = 5200; /* OK */
								COMMIT TRANSACTION [insertPerXPro]
							END;
						ELSE
							BEGIN
								/* Cannot associate "Persona" with "Propiedad" because the "Persona" is already 
								associate the "Propiedad" based on the @idPersona and @idPropiedad */
								SET @outResultCode = 5406;
								RETURN;
							END;
					END;
				ELSE
					BEGIN
						/* Cannot associate "Persona" with "Propiedad" because the "Persona" with 
						@idPersona did not exist or "Propiedad" with @idPropiedad did not exist 
						or @inFechaAsociacionPxP did not exist*/
						SET @outResultCode = 5404; 
						RETURN;
					END;
			END;
		ELSE
			BEGIN
				/* Cannot associate "Persona" with "Propiedad" because some params are null */
				SET @outResultCode = 5400; 
				RETURN;
			END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [insertPerXPro]
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