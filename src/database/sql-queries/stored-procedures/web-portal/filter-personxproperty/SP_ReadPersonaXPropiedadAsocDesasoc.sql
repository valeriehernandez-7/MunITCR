/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadPersonaXPropiedadAsocDesasoc
	@proc_description
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_ReadPersonaXPropiedadAsocDesasoc]
	@inEsAsociacion BIT,
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF @inEsAsociacion IS NOT NULL
			BEGIN
				IF (@inEsAsociacion = 1)
					BEGIN
					/* Show active associations on dbo.PersonaXPPropiedad */
						SELECT  
							[Per].[ValorDocIdentidad] AS [Propietario],
							[Pro].[Lote] AS [Propiedad],
							[PxP].[FechaInicio] AS [FechadeRegistro]
						FROM [dbo].[PersonaXPropiedad] AS [PxP]
							LEFT JOIN [dbo].[Persona] AS [Per]
							ON [PxP].[IDPersona] = [Per].[ID]
							LEFT JOIN [dbo].[Propiedad] AS [Pro]
							ON [PxP].[IDPropiedad] =  [Pro].[ID]
						WHERE [PxP].[FechaFin] IS NULL
						AND [PxP].[Activo] = 1
						AND [Per].[Activo] = 1 
						AND [Pro].[Activo] = 1;
					END;
				ELSE
					BEGIN
						/* Show active dissociations on dbo.PersonaXPPropiedad */
						SELECT  
							[Per].[ValorDocIdentidad] AS [Propietario],
							[Pro].[Lote] AS [Propiedad],
							[PxP].[FechaFin] AS [FechadeRegistro]
						FROM [dbo].[PersonaXPropiedad] AS [PxP]
							LEFT JOIN [dbo].[Persona] AS [Per]
							ON [PxP].[IDPersona] = [Per].[ID]
							LEFT JOIN [dbo].[Propiedad] AS [Pro]
							ON [PxP].[IDPropiedad] =  [Pro].[ID]
						WHERE [PxP].[FechaFin] IS NOT NULL
						AND [PxP].[Activo] = 1
						AND [Per].[Activo] = 1 
						AND [Pro].[Activo] = 1;
					END;

				SET @outResultCode = 5200; /* OK */
			END;
	END TRY
	BEGIN CATCH
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