/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_Pago
	@proc_description 
	@proc_param inPropiedadLote 
	@proc_param inFacturas 
	@proc_param inReferencia 
	@proc_param inMedioPago 
	@proc_param inFecha 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_Pago]
	@inPropiedadLote VARCHAR(32),
	@inFacturas INT,
	@inReferencia BIGINT,
	@inMedioPago VARCHAR(128),
	@inFecha DATE,
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF (@inPropiedadLote IS NOT NULL) AND (@inFacturas > 0) AND (@inMedioPago IS NOT NULL)
			BEGIN
				/* Gets the PK of "Propiedad" using @inPropiedadLote */
				DECLARE @idPropiedad INT;
				SELECT @idPropiedad = [Pro].[ID]
				FROM [dbo].[Propiedad] AS [Pro]
				WHERE [Pro].[Lote] = @inPropiedadLote;

				/* Gets the PK of "Medio de Pago" using @inMedioPago */
				DECLARE @idMedioPago INT;
				SELECT @idMedioPago = [MP].[ID]
				FROM [dbo].[MedioPago] AS [MP]
				WHERE [MP].[Nombre] = @inMedioPago;

				IF (@inReferencia IS NULL) OR EXISTS (SELECT 1 FROM [dbo].[ComprobantePago] AS [CP] WHERE [CP].[Referencia] = @inReferencia)
					BEGIN
						DECLARE @referenciaStr VARCHAR(16) = CONCAT(CONVERT(VARCHAR, GETDATE(), 112), '000000');
						DECLARE @referenciaInt BIGINT = CAST(@referenciaStr AS BIGINT);
						/* Create new "referencia de comprobante de pago" */
						WHILE EXISTS (SELECT [CP].[Referencia] 
						FROM [dbo].[ComprobantePago] AS [CP] 
						WHERE [CP].[Referencia] = @referenciaInt)
							BEGIN
								SET @referenciaInt = @referenciaInt + 1;
							END;
						/* Set the generated reference as the "Referencia" */
						SET @inReferencia = @referenciaInt;
					END;
				
				IF @inFecha IS NULL
					BEGIN
						SET @inFecha = GETDATE();
					END;
				
				IF (@idPropiedad IS NOT NULL) AND (@idMedioPago IS NOT NULL) 
				AND (@inReferencia IS NOT NULL) AND (@inFecha IS NOT NULL)
					BEGIN
						/* Get the PK of the oldest "facturas pendientes" 
						"no anuladas" of the property with @idPropiedad as PK */
						DECLARE @TMPFactura TABLE (
							[IDFacturaPendiente] INT
						);
						
						INSERT INTO @TMPFactura (
							[IDFacturaPendiente]
						) SELECT TOP (@inFacturas)
							[F].[ID]
						FROM [dbo].[Factura] AS [F]
							INNER JOIN [dbo].[Propiedad] AS [P]
							ON [P].[ID] = [F].[IDPropiedad]
						WHERE [P].[ID] = @idPropiedad 
						AND [F].[IDComprobantePago] IS NULL 
						AND [F].[PlanArregloPago] = 0
						AND [F].[Activo] = 1
						ORDER BY [F].[Fecha];

						IF EXISTS (SELECT 1 FROM @TMPFactura)
							BEGIN
								BEGIN TRANSACTION [createPago]
									/* Create "Comprobante de Pago" */
									INSERT INTO [dbo].[ComprobantePago] (
										[IDMedioPago],
										[Referencia],
										[Fecha]
									) VALUES (
										@idMedioPago,
										@inReferencia,
										@inFecha
									);
									
									/* Assign the last "comprobante de pago" 
									as pay state of "factura pendientes" */
									UPDATE [dbo].[Factura]
										SET [IDComprobantePago] = SCOPE_IDENTITY()
									FROM [dbo].[Factura] AS [F]
										INNER JOIN @TMPFactura AS [TF]
										ON [TF].[IDFacturaPendiente] = [F].[ID];

									/* Terminate the association between property and the concept
									of default interest on the invoice paid */
									UPDATE [dbo].[PropiedadXConceptoCobro]
										SET [FechaFin] = @inFecha
									FROM [dbo].[PropiedadXConceptoCobro] AS [PXCC]
										INNER JOIN [dbo].[Factura] AS [F]
										ON [F].[IDPropiedad] = [PXCC].[IDPropiedad]
										INNER JOIN @TMPFactura AS [TF]
										ON [TF].[IDFacturaPendiente] = [F].[ID]
										INNER JOIN [dbo].[DetalleCC] AS [DCC]
										ON [DCC].[IDPropiedadXConceptoCobro] = [PXCC].[ID]
										INNER JOIN [dbo].[ConceptoCobro] AS [CC]
										ON [CC].[ID] = [PXCC].[IDConceptoCobro]
										INNER JOIN [dbo].[CCInteresMoratorio] AS [CCIM]
										ON [CCIM].[IDCC] = [CC].[ID]
									WHERE [DCC].[IDFactura] = [F].[ID]
									AND [PXCC].[FechaInicio] <= @inFecha
									AND [PXCC].[FechaFin] IS NULL;
									
									SET @outResultCode = 5200; /* OK */
								COMMIT TRANSACTION [createPago]
							END;
						ELSE
							BEGIN
								/* Cannot insert the new "ComprobantePago" because 
								there is no "facturas pendientes" */
								SET @outResultCode = 5405; 
								RETURN;
							END;
					END;
				ELSE
					BEGIN
						/* Cannot insert the new "ComprobantePago" because a 
						"Medio de pago" with name @inMedioPago did not exist or 
						@inFecha is null or @inReferencia is null */
						SET @outResultCode = 5404; 
						RETURN;
					END;
			END;
		ELSE
			BEGIN
				/* Cannot insert the new "Comprobante de Pago" 
				because some params are null or the amount of
				"facturas pendientes" is not valid */
				SET @outResultCode = 5400; 
				RETURN;
			END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [createPago]
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