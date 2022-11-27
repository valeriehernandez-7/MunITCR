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
				DECLARE @TMPPropiedadSinMorosidad TABLE (
					[ID] INT IDENTITY(1,1) PRIMARY KEY,
					[IDPropiedad] INT
				);

				/*  */
				INSERT INTO @TMPPropiedadSinMorosidad (
					[IDPropiedad]
				) SELECT 
					[P].[Lote]
				FROM [dbo].[Propiedad] AS [P] 
					INNER JOIN [dbo].[Factura] AS [F]
					ON [F].[IDPropiedad] = [P].[ID]
					INNER JOIN [dbo].[OrdenCorte] AS [OC]
					ON [OC].[IDFactura] = [F].[ID]
				WHERE [P].[Activo] = 1
				AND ([F].[IDComprobantePago] IS NOT NULL OR [F].[PlanArregloPago] = 1)
				AND [F].[Activo] = 1
				AND [OC].[Activo] = 1
				AND (
					SELECT COUNT([F].[ID])
					FROM [dbo].[Propiedad] AS [PP] 
						INNER JOIN [dbo].[Factura] AS [F]
						ON [F].[IDPropiedad] = [PP].[ID]
					WHERE [PP].[ID] = [P].[ID]
					AND [F].[PlanArregloPago] = 0
					AND [F].[IDComprobantePago] IS NULL
					AND [F].[FechaVencimiento] < @inFechaOperacion
					AND [F].[Activo] = 1
					GROUP BY [PP].[ID]
					) IS NULL
				ORDER BY [P].[ID];

				IF EXISTS (SELECT 1 FROM @TMPPropiedadSinMorosidad)
					BEGIN
						BEGIN TRANSACTION [createOrdenReconexionAgua]
							/*  */
							UPDATE [dbo].[PropiedadXConceptoCobro]
								SET [FechaFin] = @inFechaOperacion
							FROM [dbo].[PropiedadXConceptoCobro] AS [PXCC]
								INNER JOIN [dbo].[Propiedad] AS [P]
								ON [P].[ID] = [PXCC].[IDPropiedad]
								INNER JOIN @TMPPropiedadSinMorosidad AS [TPSM]
								ON [TPSM].[IDPropiedad] = [P].[ID]
								INNER JOIN [dbo].[ConceptoCobro] AS [CC]
								ON [CC].[ID] = [PXCC].[IDConceptoCobro]
								INNER JOIN [dbo].[CCReconexion] AS [CCR]
								ON [CCR].[IDCC] = [CC].[ID]
							WHERE [PXCC].[FechaFin] IS NULL;

							/*  */
							UPDATE [dbo].[OrdenCorte]
								SET [Activo] = 0
							FROM [dbo].[OrdenCorte] AS [OC]
								INNER JOIN [dbo].[Factura] AS [F]
								ON [F].[ID] = [OC].[IDFactura]
								INNER JOIN [dbo].[Propiedad] AS [P]
								ON [P].[ID] = [F].[IDPropiedad]
								INNER JOIN @TMPPropiedadSinMorosidad AS [TPSM]
								ON [TPSM].[IDPropiedad] = [P].[ID]
							WHERE [OC].[Activo] = 1
							AND [OC].[Fecha] <= @inFechaOperacion
							AND ([F].[IDComprobantePago] IS NOT NULL OR [F].[PlanArregloPago] = 1);

							/*  */
							INSERT INTO [dbo].[OrdenReconexion] (
								[IDOrdenCorte],
								[Fecha]
							) SELECT
								MAX([OC].[ID]),
								@inFechaOperacion
							FROM [dbo].[OrdenCorte] AS [OC]
								INNER JOIN [dbo].[Factura] AS [F]
								ON [F].[ID] = [OC].[IDFactura]
								INNER JOIN [dbo].[Propiedad] AS [P]
								ON [P].[ID] = [F].[IDPropiedad]
								INNER JOIN @TMPPropiedadSinMorosidad AS [TPSM]
								ON [TPSM].[IDPropiedad] = [P].[ID]
							WHERE [OC].[Activo] = 0
							AND [OC].[Fecha] <= @inFechaOperacion
							AND ([F].[IDComprobantePago] IS NOT NULL OR [F].[PlanArregloPago] = 1)
							GROUP BY [P].[ID];

							SET @outResultCode = 5200; /* OK */
						COMMIT TRANSACTION [createOrdenReconexionAgua]
					END;
				ELSE 
					BEGIN
						/* There is no property to process */
						SET @outResultCode = 5401; 
						RETURN;
					END;
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