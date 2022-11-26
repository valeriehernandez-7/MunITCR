/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_FacturacionOrdenReconexion
	@proc_description 
	@proc_param inFechaOperacion
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_FacturacionOrdenReconexion]
	@inFechaOperacion DATE,
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF (@inFechaOperacion IS NULL)
			BEGIN
				SET @inFechaOperacion = GETDATE();
			END;

		IF (@inFechaOperacion IS NOT NULL)
			BEGIN
				BEGIN TRANSACTION [createOrdenReconexionAgua]
					/*  */
					UPDATE [dbo].[OrdenCorte]
						SET [Activo] = 0
					FROM [dbo].[OrdenCorte] AS [OC]
						INNER JOIN [dbo].[Factura] AS [F]
						ON [F].[ID] = [OC].[IDFactura]
					WHERE [OC].[Activo] = 1
					AND [F].[IDComprobantePago] IS NOT NULL;

					/*  */
					INSERT INTO [dbo].[OrdenReconexion] (
						[IDOrdenCorte],
						[Fecha]
					) SELECT
						[OC].[ID],
						@inFechaOperacion
					FROM [dbo].[OrdenCorte] AS [OC]
						INNER JOIN [dbo].[Factura] AS [F]
						ON [F].[ID] = [OC].[IDFactura]
						INNER JOIN [dbo].[DetalleCC] AS [DCC]
						ON [DCC].[IDFactura] = [F].[ID]
						INNER JOIN [dbo].[Propiedad] AS [P]
						ON [P].[ID] = [F].[IDPropiedad]
						INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
						ON [PXCC].[ID] = [DCC].[IDPropiedadXConceptoCobro]
						INNER JOIN [dbo].[ConceptoCobro] AS [CC]
						ON [CC].[ID] = [PXCC].[IDConceptoCobro]
						INNER JOIN [dbo].[CCReconexion] AS [CCR]
						ON [CCR].[IDCC] = [CC].[ID]
					WHERE [OC].[Activo] = 0
					AND [F].[IDComprobantePago] IS NOT NULL
					AND [F].[Activo] = 1
					AND [DCC].[Activo] = 1
					AND [P].[Activo] = 1
					AND [PXCC].[FechaFin] IS NULL;

					/*  */
					UPDATE [dbo].[PropiedadXConceptoCobro]
						SET [FechaFin] = @inFechaOperacion
					FROM [dbo].[PropiedadXConceptoCobro] AS [PXCC]
						INNER JOIN [dbo].[DetalleCC] AS [DCC]
						ON [DCC].[IDPropiedadXConceptoCobro] = [PXCC].[ID]
						INNER JOIN [dbo].[Factura] AS [F]
						ON [F].[ID] = [DCC].[IDFactura]
						INNER JOIN [dbo].[OrdenCorte] AS [OC]
						ON [OC].[IDFactura] = [F].[ID]
						INNER JOIN [dbo].[ConceptoCobro] AS [CC]
						ON [CC].[ID] = [PXCC].[IDConceptoCobro]
						INNER JOIN [dbo].[CCReconexion] AS [CCR]
						ON [CCR].[IDCC] = [CC].[ID]
					WHERE [PXCC].[FechaFin] IS NULL
					AND [DCC].[Activo] = 1
					AND [F].[IDComprobantePago] IS NOT NULL
					AND [F].[Activo] = 1
					AND [OC].[Activo] = 0;

					SET @outResultCode = 5200; /* OK */
				COMMIT TRANSACTION [createOrdenReconexionAgua]
			END;
		ELSE
			BEGIN
				/* ERROR : Cannot start the process because
				some params are null */
				SET @outResultCode = 5400; 
				RETURN;
			END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [createOrdenReconexionAgua]
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