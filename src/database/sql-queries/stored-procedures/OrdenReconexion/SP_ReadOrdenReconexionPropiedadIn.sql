/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadOrdenReconexionPropiedadIn
	@proc_description
	@proc_param inPropiedadLote
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_ReadOrdenReconexionPropiedadIn]
	@inPropiedadLote VARCHAR(32),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */
		IF (@inPropiedadLote IS NOT NULL)
			BEGIN
				SELECT 
					[OC].[Fecha] AS [SuspensiondeServicio],
					[OR].[Fecha] AS [ReconexiondeServicio]
				FROM [dbo].[OrdenReconexion] AS [OR]
					INNER JOIN [dbo].[OrdenCorte] AS [OC]
					ON [OC].[ID] = [OR].[IDOrdenCorte]
					INNER JOIN [dbo].[Factura] AS [F]
					ON [F].[ID] = [OC].[IDFactura]
					INNER JOIN [dbo].[Propiedad] AS [P]
					ON [P].[ID] = [F].[IDPropiedad]
				WHERE [P].[Lote] = @inPropiedadLote
				AND [P].[Activo] = 1
				AND [OC].[Activo] = 0
				AND [F].[Activo] = 1
				ORDER BY [OR].[Fecha] DESC;
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