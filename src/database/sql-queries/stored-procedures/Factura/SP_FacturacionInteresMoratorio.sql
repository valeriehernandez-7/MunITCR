/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_FacturacionInteresMoratorio
	@proc_description 
	@proc_param inFechaOperacion 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_FacturacionInteresMoratorio]
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
		
		/* Get the PK of "ConceptoCobro.Nombre = Intereses moratorios" */
		DECLARE @idCCInteresMoratorio INT;
		SELECT @idCCInteresMoratorio = [CC].[ID]
		FROM [dbo].[ConceptoCobro] AS [CC]
			INNER JOIN [dbo].[CCInteresMoratorio] AS [CCIM]
			ON [CCIM].[IDCC] = [CC].[ID];
		
		IF (@inFechaOperacion IS NOT NULL) AND (@idCCInteresMoratorio IS NOT NULL)
			BEGIN
				/*  */
				DECLARE @TMPFacturaIntereses TABLE (
					[ID] INT IDENTITY(1,1) PRIMARY KEY,
					[IDFactura] INT
				);

				INSERT INTO @TMPFacturaIntereses (
					[IDFactura]
				) SELECT
					[F].[ID]
				FROM [dbo].[Factura] AS [F]
					INNER JOIN [dbo].[DetalleCC] AS [DCC]
					ON [DCC].[IDFactura] = [F].[ID]
					INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
					ON [PXCC].[ID] = [DCC].[IDPropiedadXConceptoCobro]
					INNER JOIN [dbo].[Propiedad] AS [P]
					ON [P].[ID] = [PXCC].[IDPropiedad]
				WHERE [DCC].[Activo] = 1
				AND [PXCC].[IDConceptoCobro] = @idCCInteresMoratorio
				AND [PXCC].[FechaFin] IS NULL
				AND [F].[PlanArregloPago] = 0
				AND [F].[IDComprobantePago] IS NULL
				AND DATEDIFF(MONTH, [F].[FechaVencimiento], @inFechaOperacion) > 0
				AND [F].[Activo] = 1
				AND [P].[Activo] = 1
				GROUP BY [F].[ID] 
				ORDER BY [F].[ID];

				/*  */
				DECLARE @TMPFacturaVencida TABLE (
					[ID] INT IDENTITY(1,1) PRIMARY KEY,
					[IDFactura] INT
				);

				INSERT INTO @TMPFacturaVencida (
					[IDFactura]
				) SELECT
					[F].[ID]
				FROM [dbo].[Factura] AS [F]
					LEFT OUTER JOIN @TMPFacturaIntereses AS [TFI]
					ON [TFI].[IDFactura] = [F].[ID]
					INNER JOIN [dbo].[DetalleCC] AS [DCC]
					ON [DCC].[IDFactura] = [F].[ID]
					INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
					ON [PXCC].[ID] = [DCC].[IDPropiedadXConceptoCobro]
					INNER JOIN [dbo].[Propiedad] AS [P]
					ON [P].[ID] = [PXCC].[IDPropiedad]
				WHERE [TFI].[IDFactura] IS NULL
				AND [DCC].[Activo] = 1
				AND [PXCC].[IDConceptoCobro] <> @idCCInteresMoratorio
				AND [F].[PlanArregloPago] = 0
				AND [F].[IDComprobantePago] IS NULL
				AND [F].[FechaVencimiento] = @inFechaOperacion
				AND [F].[Activo] = 1
				AND [P].[Activo] = 1
				GROUP BY [F].[ID] 
				ORDER BY [F].[ID];

				IF EXISTS (SELECT 1 FROM @TMPFacturaIntereses) OR EXISTS (SELECT 1 FROM @TMPFacturaVencida)
					BEGIN
						BEGIN TRANSACTION [createIntereses]
							SET @outResultCode = 5200; /* OK */
							IF EXISTS (SELECT 1 FROM @TMPFacturaIntereses)
								BEGIN
									/*  */
									INSERT INTO [dbo].[DetalleCC] (
										[IDFactura],
										[IDPropiedadXConceptoCobro],
										[Monto]
									) SELECT
										[F].[ID],
										[PXCC].[ID],
										([F].[MontoOriginal] * [CCIM].[MontoPorcentual]) AS [DCCMonto]
									FROM @TMPFacturaIntereses AS [TFI]
										INNER JOIN [dbo].[Factura] AS [F]
										ON [F].[ID] = [TFI].[IDFactura]
										INNER JOIN [dbo].[DetalleCC] AS [DCC]
										ON [DCC].[IDFactura] = [F].[ID]
										INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
										ON [PXCC].[ID] = [DCC].[IDPropiedadXConceptoCobro]
										INNER JOIN [dbo].[ConceptoCobro] AS [CC]
										ON [CC].[ID] = [PXCC].[IDConceptoCobro]
										INNER JOIN [dbo].[CCInteresMoratorio] AS [CCIM]
										ON [CCIM].[IDCC] = [CC].[ID]
									WHERE [F].[Activo] = 1
									AND [DCC].[Activo] = 1
									AND [PXCC].[FechaFin] IS NULL
									GROUP BY [F].[ID], [PXCC].[ID], ([F].[MontoOriginal] * [CCIM].[MontoPorcentual]);

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
										INNER JOIN @TMPFacturaIntereses AS [TFI]
										ON [TFI].[IDFactura] = [F].[ID]
									WHERE [F].[Activo] = 1;

									SET @outResultCode = @outResultCode + 1; /* OK */
								END;

							IF EXISTS (SELECT 1 FROM @TMPFacturaVencida)
								BEGIN
									/*  */
									INSERT INTO [dbo].[PropiedadXConceptoCobro] (
										[IDPropiedad],
										[IDConceptoCobro],
										[FechaInicio]
									) SELECT
										[F].[IDPropiedad],
										@idCCInteresMoratorio,
										@inFechaOperacion
									FROM @TMPFacturaVencida AS [TFV]
										INNER JOIN [dbo].[Factura] AS [F]
										ON [F].[ID] = [TFV].[IDFactura]
									WHERE [F].[Activo] = 1;

									/*  */
									INSERT INTO [dbo].[DetalleCC] (
										[IDFactura],
										[IDPropiedadXConceptoCobro],
										[Monto]
									) SELECT
										[F].[ID],
										[PXCC].[ID],
										([F].[MontoOriginal] * [CCIM].[MontoPorcentual]) AS [DCCMonto]
									FROM @TMPFacturaVencida AS [TFV]
										INNER JOIN [dbo].[Factura] AS [F]
										ON [F].[ID] = [TFV].[IDFactura]
										INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
										ON [PXCC].[IDPropiedad] = [F].[IDPropiedad]
										INNER JOIN [dbo].[ConceptoCobro] AS [CC]
										ON [CC].[ID] = [PXCC].[IDConceptoCobro]
										INNER JOIN [dbo].[CCInteresMoratorio] AS [CCIM]
										ON [CCIM].[IDCC] = [CC].[ID]
									WHERE [F].[Activo] = 1
									AND [PXCC].[FechaFin] IS NULL
									GROUP BY [F].[ID], [PXCC].[ID], ([F].[MontoOriginal] * [CCIM].[MontoPorcentual]);

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
										INNER JOIN @TMPFacturaVencida AS [TFV]
										ON [TFV].[IDFactura] = [F].[ID]
									WHERE [F].[Activo] = 1;
									
									SET @outResultCode = @outResultCode + 1; /* OK */
								END;
						COMMIT TRANSACTION [createIntereses]
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
				ROLLBACK TRANSACTION [createIntereses]
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