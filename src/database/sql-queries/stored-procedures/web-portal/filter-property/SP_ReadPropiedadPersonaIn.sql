/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadPropiedadPersonaIn
	@proc_description
	@proc_param inPersonaIdentificacion person associated with the properties
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_ReadPropiedadPersonaIn]
	@inPersonaIdentificacion VARCHAR(64),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */
		SELECT	
			[Pro].[Lote] AS [Propiedad],
			[TU].[Nombre] AS [UsodePropiedad], 
			[TZ].[Nombre] AS [ZonadePropiedad],
			[Pro].[MetrosCuadrados] AS [Territorio],
			[Pro].[ValorFiscal] AS [ValorFiscal], 
			[Pro].[FechaRegistro] AS [FechadeRegistro]
		FROM [dbo].[Propiedad] AS [Pro]
			INNER JOIN [dbo].[TipoUsoPropiedad] AS [TU]
			ON [TU].[ID] = [Pro].[IDTipoUsoPropiedad]
			INNER JOIN [dbo].[TipoZonaPropiedad] AS [TZ]
			ON [TZ].[ID] = [Pro].[IDTipoZonaPropiedad]
			INNER JOIN [dbo].[PersonaXPropiedad] AS [PXP]
			ON [PXP].[IDPropiedad] = [Pro].[ID]
			INNER JOIN [dbo].[Persona] AS [Per]
			ON [Per].[ID] = [PXP].[IDPersona]
		WHERE [Pro].[Activo] = 1 AND [Per].[Activo] = 1
		AND [Per].[ValorDocIdentidad] = @inPersonaIdentificacion
		ORDER BY [Pro].[Lote];
		SET @outResultCode = 5200; /* OK */
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