/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadComprobantePagoPropiedadIn
	@proc_description 
	@proc_param @inPropiedadLote 
	@proc_param outResultCode Procedure return value
*/
CREATE OR ALTER PROCEDURE [SP_ReadComprobantePagoPropiedadIn]
	@inPropiedadLote VARCHAR(32),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		/* Show "comprobantes de pago" of "facturas" associate 
		to from "Propiedad" based on @inPropiedadLote */
		IF (@inPropiedadLote IS NOT NULL)
			BEGIN 
				SELECT 
					[CP].[Referencia] AS [Comprobante],
					[CP].[Fecha] AS [FechadePago],
					[MP].[Nombre] AS [MediodePago]
				FROM [dbo].[ComprobantePago] AS [CP]
					INNER JOIN [dbo].[Factura] AS [F]
					ON [F].[IDComprobantePago] = [CP].[ID]
					INNER JOIN [dbo].[Propiedad] AS [P]
					ON [P].[ID] = [F].[IDPropiedad]
					INNER JOIN [dbo].[MedioPago] AS [MP]
					ON [MP].[ID] = [CP].[IDMedioPago]
				WHERE [P].[Lote] = @inPropiedadLote
				AND [P].[Activo] = 1
				AND [F].[Activo] = 1
				ORDER BY [CP].[Fecha];
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