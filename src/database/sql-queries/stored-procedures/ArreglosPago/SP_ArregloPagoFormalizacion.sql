/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ArregloPagoFormalizacion
	@proc_description 
	@proc_param inPropiedadLote 
	@proc_param inPlazoMeses 
	@proc_param inCuota 
	@proc_param inSaldo 
	@proc_param inIntereses 
	@proc_param inAmortizacion 
	@proc_param inFechaFormalizacion 
	@proc_param inFechaVencimiento 
	@proc_param inFechaOperacion 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
	@author <a href="https://github.com/efmz200">Erick F. Madrigal Zavala</a>
*/
CREATE OR ALTER PROCEDURE [SP_ArregloPagoFormalizacion]
	@inPropiedadLote VARCHAR(32),
	@inPlazoMeses INT,
	@inCuota MONEY,
	@inSaldo MONEY,
	@inIntereses MONEY,
	@inAmortizacion MONEY,
	@inFechaFormalizacion DATE,
	@inFechaVencimiento DATE,
	@inFechaOperacion DATE,
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF (@inPropiedadLote IS NOT NULL) AND (@inPlazoMeses > 0) AND (@inCuota > 0)
		AND (@inSaldo > 0) AND (@inIntereses > 0) AND (@inAmortizacion > 0)
		AND (@inFechaFormalizacion IS NOT NULL) AND (@inFechaVencimiento IS NOT NULL)
			BEGIN
				/* Get the PK of the property using @inPropiedadLote */
				DECLARE @idPropiedad INT;
				SELECT @idPropiedad = [P].[ID]
				FROM [dbo].[Propiedad] AS [P]
				WHERE [P].[Lote] = @inPropiedadLote
				AND [P].[Activo] = 1;

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

				/* Get the PK of the interest rate using @inPlazoMeses */
				DECLARE @idTasaInteres INT;
				SELECT @idTasaInteres = [TI].[ID]
				FROM [dbo].[TasaInteres] AS [TI]
				WHERE [TI].[PlazoMeses] = @inPlazoMeses;

				/* Operation date of formalization of the payment arrangement contract */
				IF (@inFechaOperacion IS NULL)
					BEGIN
						SET @inFechaOperacion = GETDATE();
					END;

				/* Get the bill expiration date based on system parameters */
				DECLARE @diasVencimiento INT;
				SELECT @diasVencimiento = [PI].[Valor]
				FROM [dbo].[ParametroInteger] AS [PI]
					INNER JOIN [dbo].[Parametro] AS [PS]
					ON [PS].[ID] = [PI].[IDParametro]
				WHERE [PS].[Descripcion] = 'Cantidad de dias para calculo de fecha de vencimiento';
				
				IF (@idPropiedad IS NOT NULL) AND (@idCCArregloPago IS NOT NULL)
				AND (@idTipoMovimientoArregloPago IS NOT NULL) AND (@idTasaInteres IS NOT NULL)
				AND (@inFechaOperacion IS NOT NULL) AND (@diasVencimiento > 0)
					BEGIN
						BEGIN TRANSACTION [createArregloPagoFormalizacion]
							INSERT INTO [dbo].[PropiedadXConceptoCobro] (
								[IDPropiedad],
								[IDConceptoCobro],
								[FechaInicio],
								[FechaFin]
							) VALUES (
								@idPropiedad,
								@idCCArregloPago,
								@inFechaFormalizacion,
								@inFechaVencimiento
							);
						
							INSERT INTO [dbo].[PropiedadXCCArregloPago] (
								[IDPropiedadXCC],
								[IDTasaInteres],
								[MontoOriginal],
								[MontoSaldo],
								[MontoAcumuladoAmortizacion]
							) VALUES (
								SCOPE_IDENTITY(),
								@idTasaInteres,
								@inSaldo,
								@inSaldo,
								@inAmortizacion
							);
						
							INSERT INTO [dbo].[MovimientoArregloPago] (
								[IDTipoMovimientoArregloPago],
								[IDPropiedadXCCArregloPago],
								[Fecha],
								[MontoCuota],
								[MontoAmortizacion],
								[MontoInteres]
							) VALUES (
								@idTipoMovimientoArregloPago,
								SCOPE_IDENTITY(),
								@inFechaFormalizacion,
								@inCuota,
								@inAmortizacion,
								@inIntereses
							);
						
							UPDATE [dbo].[Factura]
								SET [PlanArregloPago] = 1
							FROM [dbo].[Factura] AS [F]
							WHERE [F].[IDPropiedad] = @idPropiedad
							AND DATEDIFF(MONTH, [F].[FechaVencimiento], @inFechaOperacion) > 1
							AND DATEPART(DAY, [F].[FechaVencimiento]) <= DATEPART(DAY, @inFechaOperacion)
							AND [F].[IDComprobantePago] IS NULL
							AND [F].[PlanArregloPago] = 0
							AND [F].[Activo] = 1;

							SET @outResultCode = 5200; /* OK */
						COMMIT TRANSACTION [createArregloPagoFormalizacion]
					END;
				ELSE
					BEGIN
						/* ERROR: Cannot create the payment arrangement
						cause some params are null */
						SET @outResultCode = 5400;
						RETURN;
					END;
			END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [createArregloPagoFormalizacion]
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