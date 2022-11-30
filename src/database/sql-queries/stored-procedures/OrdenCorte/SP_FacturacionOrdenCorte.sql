/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_FacturacionOrdenCorte
	@proc_description 
	@proc_param inFechaOperacion
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_FacturacionOrdenCorte]
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

		/* Get the PK of "ConceptoCobro.Nombre = Reconexion de agua" */
		DECLARE @idCCReconexion INT;
		SELECT @idCCReconexion = [CC].[ID]
		FROM [dbo].[ConceptoCobro] AS [CC]
			INNER JOIN [dbo].[CCReconexion] AS [CCR]
			ON [CCR].[IDCC] = [CC].[ID];

		IF (@inFechaOperacion IS NOT NULL) AND (@idCCReconexion IS NOT NULL)
			BEGIN
				DECLARE @TMPFacturaPendiente TABLE (
					[ID] INT IDENTITY(1,1) PRIMARY KEY,
					[IDFactura] INT
				);

				/*  */
				INSERT INTO @TMPFacturaPendiente (
					[IDFactura]
				) SELECT 
					MIN([F].[ID])
				FROM [dbo].[Propiedad] AS [P] 
					INNER JOIN [dbo].[Factura] AS [F]
					ON [F].[IDPropiedad] = [P].[ID]
					INNER JOIN [dbo].[DetalleCC] AS [DCC]
					ON [DCC].[IDFactura] = [F].[ID]
					INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
					ON [PXCC].[ID] = [DCC].[IDPropiedadXConceptoCobro]
					INNER JOIN [dbo].[ConceptoCobro] AS [CC]
					ON [CC].[ID] = [PXCC].[IDConceptoCobro]
					INNER JOIN [dbo].[CCConsumoAgua] AS [CCCA]
					ON [CCCA].[IDCC] = [CC].[ID]
				WHERE [P].[Activo] = 1
				AND [F].[PlanArregloPago] = 0
				AND [F].[IDComprobantePago] IS NULL
				AND [F].[FechaVencimiento] <= @inFechaOperacion
				AND [F].[Activo] = 1
				AND [DCC].[Activo] = 1
				AND [PXCC].[FechaInicio] <= @inFechaOperacion
				AND [PXCC].[FechaFin] IS NULL
				GROUP BY [P].[ID]
				HAVING COUNT([F].[ID]) > 1
				ORDER BY [P].[ID];

				DELETE FROM @TMPFacturaPendiente
				FROM @TMPFacturaPendiente AS [TFP]
					INNER JOIN [dbo].[Factura] AS [F]
					ON [F].[ID] = [TFP].[IDFactura]
					INNER JOIN [dbo].[Propiedad] AS [P]
					ON [P].[ID] = [F].[IDPropiedad]
					INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
					ON [PXCC].[IDPropiedad] = [P].[ID]
					INNER JOIN [dbo].[ConceptoCobro] AS [CC]
					ON [CC].[ID] = [PXCC].[IDConceptoCobro]
					INNER JOIN [dbo].[CCReconexion] AS [CCR]
					ON [CCR].[IDCC] = [CC].[ID]
				WHERE [F].[Activo] = 1
				AND [P].[Activo] = 1
				AND [PXCC].[FechaInicio] <= @inFechaOperacion
				AND [PXCC].[FechaFin] IS NULL;

				IF EXISTS (SELECT 1 FROM @TMPFacturaPendiente)
					BEGIN
						BEGIN TRANSACTION [createOrdenCorteAgua]
							/*  */
							INSERT INTO [dbo].[PropiedadXConceptoCobro] (
								[IDPropiedad],
								[IDConceptoCobro],
								[FechaInicio]
							) SELECT
								[F].[IDPropiedad],
								@idCCReconexion,
								@inFechaOperacion
							FROM @TMPFacturaPendiente AS [TFP]
								INNER JOIN [dbo].[Factura] AS [F]
								ON [F].[ID] = [TFP].[IDFactura]
							WHERE [F].[Activo] = 1;

							/*  */
							INSERT INTO [dbo].[DetalleCC] (
								[IDFactura],
								[IDPropiedadXConceptoCobro],
								[Monto]
							) SELECT
								[TFP].[IDFactura],
								MAX([PXCC].[ID]),
								[CCR].[MontoFijo]
							FROM @TMPFacturaPendiente AS [TFP]
								INNER JOIN [dbo].[Factura] AS [F]
								ON [F].[ID] = [TFP].[IDFactura]
								INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
								ON [PXCC].[IDPropiedad] = [F].[IDPropiedad]
								INNER JOIN [dbo].[ConceptoCobro] AS [CC]
								ON [CC].[ID] = [PXCC].[IDConceptoCobro]
								INNER JOIN [dbo].[CCReconexion] AS [CCR]
								ON [CCR].[IDCC] = [CC].[ID]
							GROUP BY [TFP].[IDFactura], [CCR].[MontoFijo];

							/*  */
							UPDATE [dbo].[Factura]
								SET [MontoPagar] = (
									SELECT SUM([DCC].[Monto])
									FROM [dbo].[Factura] AS [FA]
										INNER JOIN [dbo].[DetalleCC] AS [DCC]
										ON [DCC].[IDFactura] = [FA].[ID]
									WHERE [FA].[ID] = [F].[ID]
									AND [DCC].[Activo] = 1
									GROUP BY [DCC].[IDFactura]
								)
							FROM [dbo].[Factura] AS [F]
								INNER JOIN @TMPFacturaPendiente AS [TFP]
								ON  [TFP].[IDFactura] = [F].[ID]
							WHERE [F].[Activo] = 1;

							/*  */
							INSERT INTO [dbo].[OrdenCorte] (
								[IDFactura],
								[Fecha]
							) SELECT 
								[TFP].[IDFactura],
								@inFechaOperacion
							FROM @TMPFacturaPendiente AS [TFP];
							
							SET @outResultCode = 5200; /* OK */
						COMMIT TRANSACTION [createOrdenCorteAgua]
					END;
				ELSE 
					BEGIN
						/* There is no bill to process */
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
				ROLLBACK TRANSACTION [createOrdenCorteAgua]
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