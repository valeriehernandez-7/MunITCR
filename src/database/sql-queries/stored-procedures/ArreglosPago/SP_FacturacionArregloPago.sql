/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_FacturacionArregloPago
	@proc_description 
	@proc_param inFechaOperacion 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
	@author <a href="https://github.com/efmz200">Erick F. Madrigal Zavala</a>
*/
CREATE OR ALTER PROCEDURE [SP_FacturacionArregloPago]
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
				/* Get the PK of "ConceptoCobro.Nombre = Arreglo de pago" */
				DECLARE @idCCArregloPago INT;
				SELECT @idCCArregloPago = [CC].[ID]
				FROM [dbo].[ConceptoCobro] AS [CC]
					INNER JOIN [dbo].[CCArregloPago] AS [CCAP]
					ON [CCAP].[IDCC] = [CC].[ID];

				/* Get the PK of the "TipoMovimientoArregloPago.Nombre = Debito" */
				DECLARE @idTipoMovimientoArregloPago INT;
				SELECT @idTipoMovimientoArregloPago = [TMAP].[ID]
				FROM [dbo].[TipoMovimientoArregloPago] AS [TMAP]
				WHERE [TMAP].[Nombre] = 'Debito';

				DECLARE @fechaHaceUnMes DATE = DATEADD(MONTH, -1, DATEADD(DAY, 1, @inFechaOperacion));
				DECLARE @diaFechaOperacion INT = DATEPART(DAY, @inFechaOperacion);
				DECLARE @diaFechaFinMes INT = DATEPART(DAY, EOMONTH(@inFechaOperacion));

				DECLARE @TMPPropiedadAP TABLE (
					[ID] INT IDENTITY(1,1) PRIMARY KEY,
					[IDPropiedad] INT,
					[IDPropiedadXCC] INT,
					[IDPropiedadXCCAP] INT
				);

				IF (@diaFechaOperacion < @diaFechaFinMes)
					BEGIN
						INSERT INTO @TMPPropiedadAP (
							[IDPropiedad],
							[IDPropiedadXCC],
							[IDPropiedadXCCAP]
						) SELECT 
							[P].[ID],
							[PXCCAP].[IDPropiedadXCC],
							[PXCCAP].[ID]
						FROM [dbo].[Propiedad] AS [P]
							INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
							ON [PXCC].[IDPropiedad] = [P].[ID]
							INNER JOIN [dbo].[PropiedadXCCArregloPago] AS [PXCCAP]
							ON [PXCCAP].[IDPropiedadXCC] = [PXCC].[ID]
							INNER JOIN [dbo].[Factura] AS [F]
							ON [F].[IDPropiedad] = [P].[ID]
						WHERE [P].[Activo] = 1
						AND [P].[FechaRegistro] <= @inFechaOperacion
						AND DATEPART(DAY, [P].[FechaRegistro]) = @diaFechaOperacion
						AND [PXCC].[FechaInicio] <= @inFechaOperacion
						AND [PXCC].[FechaFin] >= @inFechaOperacion
						AND [PXCCAP].[MontoSaldo] > 0
						AND [PXCCAP].[Activo] = 1
						AND DATEPART(MONTH, [F].[Fecha]) = DATEPART(MONTH, @inFechaOperacion)
						AND [F].[IDComprobantePago] IS NULL
						AND [F].[PlanArregloPago] = 0
						AND [F].[Activo] = 1
						ORDER BY [P].[ID];
					END;
				ELSE
					BEGIN
						INSERT INTO @TMPPropiedadAP (
							[IDPropiedad],
							[IDPropiedadXCC],
							[IDPropiedadXCCAP]
						) SELECT 
							[P].[ID],
							[PXCCAP].[IDPropiedadXCC],
							[PXCCAP].[ID]
						FROM [dbo].[Propiedad] AS [P]
							INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
							ON [PXCC].[IDPropiedad] = [P].[ID]
							INNER JOIN [dbo].[PropiedadXCCArregloPago] AS [PXCCAP]
							ON [PXCCAP].[IDPropiedadXCC] = [PXCC].[ID]
							INNER JOIN [dbo].[Factura] AS [F]
							ON [F].[IDPropiedad] = [P].[ID]
						WHERE [P].[Activo] = 1
						AND [P].[FechaRegistro] <= @inFechaOperacion
						AND DATEPART(DAY, [P].[FechaRegistro]) >= @diaFechaFinMes
						AND [PXCC].[FechaInicio] <= @inFechaOperacion
						AND [PXCC].[FechaFin] >= @inFechaOperacion
						AND [PXCCAP].[MontoSaldo] > 0
						AND [PXCCAP].[Activo] = 1
						AND DATEPART(MONTH, [F].[Fecha]) = DATEPART(MONTH, @inFechaOperacion)
						AND [F].[IDComprobantePago] IS NULL
						AND [F].[PlanArregloPago] = 0
						AND [F].[Activo] = 1
						ORDER BY [P].[ID];
					END;
				
				IF EXISTS (SELECT 1 FROM @TMPPropiedadAP) AND (@idTipoMovimientoArregloPago IS NOT NULL)
					BEGIN
						BEGIN TRANSACTION [facturacionAP]

							INSERT INTO [dbo].[MovimientoArregloPago] (
								[IDTipoMovimientoArregloPago],
								[IDPropiedadXCCArregloPago],
								[Fecha],
								[MontoCuota],
								[MontoAmortizacion],
								[MontoInteres]
							) SELECT
								@idTipoMovimientoArregloPago,
								[PXCCAP].[ID],
								@inFechaOperacion,
								(ROUND((([PXCCAP].[MontoOriginal] / ((1 - (POWER((1 + ([TI].[TasaInteresAnual] / ((360 * 12) / 365))), -[TI].[PlazoMeses]))) / (([TI].[TasaInteresAnual] / ((360 * 12) / 365)))))), 2)),
								(ROUND(((ROUND((([PXCCAP].[MontoOriginal] / ((1 - (POWER((1 + ([TI].[TasaInteresAnual] / ((360 * 12) / 365))), -[TI].[PlazoMeses]))) / (([TI].[TasaInteresAnual] / ((360 * 12) / 365)))))), 2)) - (ROUND(([PXCCAP].[MontoSaldo] * (([TI].[TasaInteresAnual] / ((360 * 12) / 365)))), 2))), 2)),
								(ROUND(([PXCCAP].[MontoSaldo] * (([TI].[TasaInteresAnual] / ((360 * 12) / 365)))), 2))
							FROM @TMPPropiedadAP AS [TPAP]
								INNER JOIN [dbo].[PropiedadXCCArregloPago] AS [PXCCAP]
								ON [PXCCAP].[ID] = [TPAP].[IDPropiedadXCCAP]
								INNER JOIN [dbo].[TasaInteres] AS [TI]
								ON [TI].[ID] = [PXCCAP].[IDTasaInteres]
							WHERE [PXCCAP].[Activo] = 1;


							INSERT INTO [dbo].[DetalleCC] (
								[IDFactura],
								[IDPropiedadXConceptoCobro]
							) SELECT 
								[F].[ID],
								[TPAP].[IDPropiedadXCC]
							FROM @TMPPropiedadAP AS [TPAP]
								INNER JOIN [dbo].[Factura] AS [F]
								ON [F].[IDPropiedad] = [TPAP].[IDPropiedad]
							WHERE DATEPART(MONTH, [F].[Fecha]) = DATEPART(MONTH, @inFechaOperacion)
							AND [F].[IDComprobantePago] IS NULL
							AND [F].[PlanArregloPago] = 0
							AND [F].[Activo] = 1;


							INSERT INTO [dbo].[DetalleCCArregloPago] (
								[IDDetalleCC],
								[IDMovimientoArregloPago]
							) SELECT
								[DCC].[ID],
								[MAP].[ID]
							FROM [dbo].[MovimientoArregloPago] AS [MAP]
								LEFT OUTER JOIN [dbo].[DetalleCCArregloPago] AS [DCCAP]
								ON [DCCAP].[IDMovimientoArregloPago] = [MAP].[ID]
								INNER JOIN @TMPPropiedadAP AS [TPAP]
								ON [TPAP].[IDPropiedadXCCAP] = [MAP].[IDPropiedadXCCArregloPago]
								INNER JOIN [dbo].[DetalleCC] AS [DCC]
								ON [DCC].[IDPropiedadXConceptoCobro] = [TPAP].[IDPropiedadXCC]
								INNER JOIN [dbo].[Factura] AS [F]
								ON [F].[ID] = [DCC].[IDFactura]
							WHERE [DCCAP].[IDMovimientoArregloPago] IS NULL
							AND [MAP].[Fecha] BETWEEN @fechaHaceUnMes AND @inFechaOperacion
							AND [DCC].[Activo] = 1
							AND [F].[Activo] = 1;


							UPDATE [dbo].[DetalleCC]
								SET [Monto] = (
									SELECT SUM([MAP].[MontoCuota])
									FROM [dbo].[DetalleCC] AS [DDCC]
										INNER JOIN [dbo].[Factura] AS [F]
										ON [F].[ID] = [DDCC].[IDFactura]
										INNER JOIN [dbo].[MovimientoArregloPago] AS [MAP]
										ON [MAP].[IDPropiedadXCCArregloPago] = [TPAP].[IDPropiedadXCCAP]
										INNER JOIN [dbo].[DetalleCCArregloPago] AS [DCCAP]
										ON [DCCAP].[IDMovimientoArregloPago] = [MAP].[ID]
									WHERE [DDCC].[ID] = [DCC].[ID]
									AND [DDCC].[Activo] = 1
									GROUP BY [DDCC].[IDFactura]
								)
							FROM [dbo].[DetalleCC] AS [DCC]
								INNER JOIN @TMPPropiedadAP AS [TPAP]
								ON [TPAP].[IDPropiedadXCC] = [DCC].[IDPropiedadXConceptoCobro]
							WHERE [DCC].[Activo] = 1;


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
								INNER JOIN @TMPPropiedadAP AS [TPAP]
								ON [TPAP].[IDPropiedad] = [F].[IDPropiedad]
							WHERE DATEPART(MONTH, [F].[Fecha]) = DATEPART(MONTH, @inFechaOperacion)
							AND [F].[IDComprobantePago] IS NULL
							AND [F].[PlanArregloPago] = 0
							AND [F].[Activo] = 1;

							SET @outResultCode = 5200; /* OK */
						COMMIT TRANSACTION [facturacionAP]
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
				/* ERROR : Cannot start the AP billing process because
				some params are null */
				SET @outResultCode = 5400; 
				RETURN;
			END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [facturacionAP]
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