/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_CreateAP
	@proc_description 
	@proc_param inPropiedadMedidor 
	@proc_param inPlazo 
	@proc_param inTasa 
	@proc_param inCuota 
	@proc_param inTotal 
	@proc_param inAmortizacion 
	@proc_param inFecha 
	@proc_param inFechaFin 
	@proc_param outResultCode Procedure return value
*/
CREATE OR ALTER PROCEDURE [SP_AregloPagoFormalizacion]
	@inPropiedadLote VARCHAR(32),
	@inPlazo INT,
	@inTasa Float,
	@inCuota Money,
	@inTotal Money,
	@inAmortizacion Money,
	@inFecha DATE,
	@inFechaFin DATE,
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */
		IF (@inPropiedadLote IS NOT NULL) AND (@inPlazo IS NOT NULL) AND (@inTasa IS NOT NULL) AND
	       (@inCuota IS NOT NULL) AND (@inTotal IS NOT NULL) AND (@inAmortizacion IS NOT NULL) 
			BEGIN
				DECLARE @IDProp INT;
				SELECT @IDProp = ID
				FROM [dbo].[Propiedad] AS [P]
				WHERE @inPropiedadLote = [P].[Lote];
				
				DECLARE @IDTasaInt INT;
				SELECT @IDTasaInt = ID
				FROM [dbo].[TasaInteres] AS [TI]
				WHERE 
					[TI].[PlazoMeses] = @inPlazo AND
					[TI].[TasaInteresAnual] = @inTasa;

				IF (@inFecha IS NULL)
					BEGIN
						SET @inFecha = GETDATE();
					END
				IF (@inFechaFin IS NULL)
					BEGIN
						SET @inFechaFin = DATEADD(MONTH,@inPlazo,@inFecha)
					END
		BEGIN TRANSACTION [AregloPagoFormalizacion]	
			INSERT INTO [dbo].[PropiedadXConceptoCobro] ( 
				IDPropiedad,
				IDConceptoCobro,
				FechaInicio,
				FechaFin
			)VALUES(
				@IDProp,
				2,
				@inFecha,
				@inFechaFin
			)
		
			INSERT INTO [dbo].[PropiedadXCCArregloPago](
				[PropiedadXCCArregloPago].[IDPropiedadXCC],
				[PropiedadXCCArregloPago].[MontoOriginal],
				[PropiedadXCCArregloPago].[MontoSaldo],
				[PropiedadXCCArregloPago].[MontoAcumuladoAmortizacion],
				[PropiedadXCCArregloPago].[MontoAcumuladoAplicado]	
			)VALUES(
				SCOPE_IDENTITY(),
				@inTotal,
				@inTotal,
				@inAmortizacion,
				@inAmortizacion+@inTotal
			)
		
			INSERt INTO [dbo].[MovimientoArregloPago](
				[MovimientoArregloPago].[IDTipoMovimientoArregloPago],
				[MovimientoArregloPago].[IDPropiedadXCCArregloPago],
				[MovimientoArregloPago].[Fecha],
				[MovimientoArregloPago].[MontoAmortizacion].
				[MovimientoArregloPago].[MontoInteres]
			)VALUES(
				1,
				SCOPE_IDENTITY(),
				@inFecha,
				@inCuota,
				@inAmortizacion,
				@inAmortizacion * @inPlazo
			)
		
			UPDATE [dbo].[Factura] 
				SET [Factura].[PlanArregloPago] = 1		
			WHERE [Factura].[IDPropiedad] = @inPropiedadLote
			AND DATEDIFF(MONTH, [Factura].[FechaVencimiento], @inFecha) > 1
			AND [Factura].[IDComprobantePago] IS NULL
			AND [Factura].[PlanArregloPago] = 0
			AND [Factura].[Activo] = 1
		COMMIT TRANSACTION [AregloPagoFormalizacion]			
		
		END 
		
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [insertMovimientoConsumoAgua]
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