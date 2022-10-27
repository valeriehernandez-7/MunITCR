/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadPropiedadInPersona
	@proc_description
	@proc_param inPropiedadLote property associated with person as owner
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_ReadPropiedadInPersona]
	@inPropiedadLote VARCHAR(32),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */
		SELECT	
			[Per].[Nombre], 
			[DI].[Nombre] AS [TipodeIdentificación],
			[Per].[ValorDocIdentidad] AS [Identificación],
			[Per].[Telefono1] AS [Teléfono1],
			[Per].[Telefono2] AS [Teléfono2], 
			[Per].[CorreoElectronico] AS [CorreoElectrónico]
		FROM [dbo].[Persona] AS [Per]
			INNER JOIN [dbo].[TipoDocIdentidad] AS [DI]
			ON [Per].[IdTipoDocIdentidad] = [DI].[ID]
			INNER JOIN [dbo].[PersonaXPropiedad] AS [PXP]
			ON [PXP].[IDPersona] = [Per].[ID]
			INNER JOIN [dbo].[Propiedad] AS [Pro]
			ON [Pro].[ID] = [PXP].[IDPropiedad]
		WHERE [Per].[Activo] = 1 AND [Pro].[Activo] = 1
		AND [Pro].[Lote] = @inPropiedadLote
		ORDER BY [Per].[ValorDocIdentidad];
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