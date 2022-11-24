/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_Facturacion
	@proc_description 
	@proc_param inFechaOperacion 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_Facturacion]
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
				DECLARE @fechaHaceUnMes DATE = DATEADD(MONTH, -1, DATEADD(DAY, 1, @inFechaOperacion));
				DECLARE @diaFechaOperacion INT = DATEPART(DAY, @inFechaOperacion);
				DECLARE @diaFechaFinMes INT = DATEPART(DAY, EOMONTH(@inFechaOperacion));

				DECLARE @TMPPropiedad TABLE (
					[ID] INT IDENTITY(1,1) PRIMARY KEY,
					[IDPropiedad] INT
				);

				IF (@diaFechaOperacion < @diaFechaFinMes)
					BEGIN
						INSERT INTO @TMPPropiedad (
							[IDPropiedad]
						) SELECT DISTINCT
							[P].[ID]
						FROM [dbo].[Propiedad] AS [P]
							INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
							ON [PXCC].[IDPropiedad] = [P].[ID]
						WHERE [P].[Activo] = 1
						AND [PXCC].[FechaFin] IS NULL
						AND DATEPART(DAY, [P].[FechaRegistro]) = @diaFechaOperacion
						ORDER BY [P].[ID];
					END;
				ELSE
					BEGIN
						INSERT INTO @TMPPropiedad (
							[IDPropiedad]
						) SELECT DISTINCT
							[P].[ID]
						FROM [dbo].[Propiedad] AS [P]
							INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
							ON [PXCC].[IDPropiedad] = [P].[ID]
						WHERE [P].[Activo] = 1
						AND [PXCC].[FechaFin] IS NULL
						AND DATEPART(DAY, [P].[FechaRegistro]) >= @diaFechaFinMes
						ORDER BY [P].[ID];
					END;
				
				IF EXISTS (SELECT 1 FROM @TMPPropiedad)
					BEGIN
						IF NOT EXISTS ( SELECT 1 
									FROM [dbo].[Factura] AS [F]
										INNER JOIN @TMPPropiedad AS [TP]
										ON [TP].[IDPropiedad] = [F].[IDPropiedad]
									WHERE ([F].[Fecha] BETWEEN @fechaHaceUnMes AND @inFechaOperacion)
									AND [F].[Activo] = 1
						)
							BEGIN
								/* Get the bill expiration date based on system parameters */
								DECLARE @diasVencimiento INT;
								SELECT @diasVencimiento = [PI].[Valor]
								FROM [dbo].[ParametroInteger] AS [PI]
									INNER JOIN [dbo].[Parametro] AS [PS]
									ON [PS].[ID] = [PI].[IDParametro]
								WHERE [PS].[Descripcion] = 'Cantidad de dias para calculo de fecha de vencimiento';

								DECLARE @fechaVencimiento DATE = DATEADD(DAY, @diasVencimiento, @inFechaOperacion);

								DECLARE 
									@minIDTMPPropiedad INT,
									@maxIDTMPPropiedad INT;
								SELECT 
									@minIDTMPPropiedad = MIN([TP].[ID]),
									@maxIDTMPPropiedad = MAX([TP].[ID])
								FROM @TMPPropiedad AS [TP];

								DECLARE @LecturaMedidorUltimaFacturaXPropiedad TABLE (
									[ID] INT IDENTITY(1,1) PRIMARY KEY,
									[LecturaMedidorUltimaFactura] INT,
									[IDPropiedad] INT
								);

								WHILE (@minIDTMPPropiedad <= @maxIDTMPPropiedad)
									BEGIN
										-- INSERT INTO @LecturaMedidorUltimaFacturaXPropiedad (
										-- 	[LecturaMedidorUltimaFactura],
										-- 	[IDPropiedad]
										-- ) SELECT
										-- 	MAX([MCA].[LecturaMedidor]),
										-- 	[TP].[IDPropiedad]
										-- FROM [dbo].[MovimientoConsumoAgua] AS [MCA]
										-- 	INNER JOIN [dbo].[PropiedadXCCConsumoAgua] AS [PXCA]
										-- 	ON [PXCA].[IDPropiedadXCC] = [MCA].[IDPropiedadXCCConsumoAgua]
										-- 	INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
										-- 	ON [PXCC].[ID] = [PXCA].[IDPropiedadXCC]
										-- 	INNER JOIN @TMPPropiedad AS [TP]
										-- 	ON [TP].[IDPropiedad] = [PXCC].[IDPropiedad]
										-- WHERE [MCA].[Fecha] < @fechaHaceUnMes
										-- AND [TP].[ID] = @minIDTMPPropiedad
										-- GROUP BY [TP].[IDPropiedad];

										INSERT INTO @LecturaMedidorUltimaFacturaXPropiedad (
											[LecturaMedidorUltimaFactura],
											[IDPropiedad]
										) SELECT
											(CASE
												WHEN (
													SELECT 
														MAX([MCA].[LecturaMedidor]) 
													FROM [dbo].[MovimientoConsumoAgua] AS [MCA] 
														INNER JOIN [dbo].[PropiedadXCCConsumoAgua] AS [PXCA]
														ON [PXCA].[IDPropiedadXCC] = [MCA].[IDPropiedadXCCConsumoAgua]
														INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
														ON [PXCC].[ID] = [PXCA].[IDPropiedadXCC]
														INNER JOIN @TMPPropiedad AS [TP]
														ON [TP].[IDPropiedad] = [PXCC].[IDPropiedad]
													WHERE [MCA].[Fecha] <= @fechaHaceUnMes
													AND [TP].[ID] = @minIDTMPPropiedad
													GROUP BY [TP].[IDPropiedad]
												) IS NULL THEN 0
												ELSE (
													SELECT 
														MAX([MCA].[LecturaMedidor]) 
													FROM [dbo].[MovimientoConsumoAgua] AS [MCA] 
														INNER JOIN [dbo].[PropiedadXCCConsumoAgua] AS [PXCA]
														ON [PXCA].[IDPropiedadXCC] = [MCA].[IDPropiedadXCCConsumoAgua]
														INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
														ON [PXCC].[ID] = [PXCA].[IDPropiedadXCC]
														INNER JOIN @TMPPropiedad AS [TP]
														ON [TP].[IDPropiedad] = [PXCC].[IDPropiedad]
													WHERE [MCA].[Fecha] <= @fechaHaceUnMes
													AND [TP].[ID] = @minIDTMPPropiedad
													GROUP BY [TP].[IDPropiedad]
												)
											END),
											[TP].[IDPropiedad]
										FROM @TMPPropiedad AS [TP]
											INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
											ON [PXCC].[IDPropiedad] = [TP].[IDPropiedad]
											INNER JOIN [dbo].[PropiedadXCCConsumoAgua] AS [PXCA]
											ON [PXCA].[IDPropiedadXCC] = [PXCC].[ID]
										WHERE [TP].[ID] = @minIDTMPPropiedad;

										SET @minIDTMPPropiedad = @minIDTMPPropiedad + 1;
									END;

								SELECT * FROM @TMPPropiedad;
								SELECT * FROM @LecturaMedidorUltimaFacturaXPropiedad;

								-- IF EXISTS (SELECT 1 FROM @LecturaMedidorUltimaFacturaXPropiedad) AND (@fechaVencimiento IS NOT NULL)
								-- 	BEGIN
								-- 		BEGIN TRANSACTION [createFacturaXConceptoCobro]
								-- 			INSERT INTO [dbo].[Factura] (
								-- 				[IDPropiedad],
								-- 				[Fecha],
								-- 				[FechaVencimiento]
								-- 			) SELECT
								-- 				[TP].[IDPropiedad],
								-- 				@inFechaOperacion,
								-- 				@fechaVencimiento
								-- 			FROM @TMPPropiedad AS [TP];

								-- 			INSERT INTO [dbo].[DetalleCC] (
								-- 				[IDFactura],
								-- 				[IDPropiedadXConceptoCobro]
								-- 			) SELECT 
								-- 				[F].[ID],
								-- 				[PXCC].[ID]
								-- 			FROM @TMPPropiedad AS [TP]
								-- 				INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
								-- 				ON [PXCC].[IDPropiedad] = [TP].[IDPropiedad]
								-- 				INNER JOIN [dbo].[Factura] AS [F]
								-- 				ON [F].[IDPropiedad] = [TP].[IDPropiedad]
								-- 			WHERE [PXCC].[FechaFin] IS NULL
								-- 			AND [F].[Fecha] = @inFechaOperacion
								-- 			AND [F].[Activo] = 1;

								-- 			INSERT INTO [dbo].[DetalleCCConsumoAgua] (
								-- 				[IDDetalleCC],
								-- 				[IDMovimientoConsumoAgua]
								-- 			) SELECT 
								-- 				[DCC].[ID],
								-- 				[MCA].[ID]
								-- 			FROM [dbo].[MovimientoConsumoAgua] AS [MCA]
								-- 				LEFT OUTER JOIN [dbo].[DetalleCCConsumoAgua] AS [DCCCA]
								-- 				ON [DCCCA].[IDMovimientoConsumoAgua] = [MCA].[ID]
								-- 				INNER JOIN [dbo].[PropiedadXCCConsumoAgua] AS [PXCA]
								-- 				ON [PXCA].[IDPropiedadXCC] = [MCA].[IDPropiedadXCCConsumoAgua]
								-- 				INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
								-- 				ON [PXCC].[ID] = [PXCA].[IDPropiedadXCC]
								-- 				INNER JOIN [dbo].[DetalleCC] AS [DCC]
								-- 				ON [DCC].[IDPropiedadXConceptoCobro] = [PXCC].[ID]
								-- 				INNER JOIN [dbo].[Factura] AS [F]
								-- 				ON [F].[ID] = [DCC].[IDFactura]
								-- 				INNER JOIN @TMPPropiedad AS [TP]
								-- 				ON [TP].[IDPropiedad] = [F].[IDPropiedad]
								-- 			WHERE [DCCCA].[IDMovimientoConsumoAgua] IS NULL
								-- 			AND [MCA].[Fecha] BETWEEN @fechaHaceUnMes AND @inFechaOperacion
								-- 			AND [PXCC].[IDPropiedad] = [TP].[IDPropiedad]
								-- 			AND [PXCC].[FechaFin] IS NULL
								-- 			AND [DCC].[Activo] = 1
								-- 			AND [F].[Fecha] = @inFechaOperacion
								-- 			AND [F].[Activo] = 1;

								-- 			/* Update the total of "DetalleCC" associate to "CCConsumoAgua"
								-- 			of "Factura" from @inFechaOperacion of Property at @TMPPropiedad */
								-- 			UPDATE [dbo].[DetalleCC]
								-- 				SET [Monto] = 
								-- 					CASE
								-- 						WHEN ([PXCA].[LecturaMedidor] - [LUF].LecturaMedidorUltimaFactura) > [CCCA].[MinimoM3]
								-- 						THEN [CCCA].[MontoMinimo] + ((([PXCA].[LecturaMedidor] - [LUF].[LecturaMedidorUltimaFactura]) - [CCCA].[MinimoM3]) * [CCCA].[MontoMinimoM3])
								-- 						ELSE [CCCA].[MontoMinimo]
								-- 					END
								-- 			FROM [dbo].[DetalleCC] AS [DCC]
								-- 				INNER JOIN [dbo].[Factura] AS [F]
								-- 				ON [F].[ID] = [DCC].[IDFactura]
								-- 				INNER JOIN @LecturaMedidorUltimaFacturaXPropiedad AS [LUF]
								-- 				ON [LUF].[IDPropiedad] = [F].[IDPropiedad]
								-- 				INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
								-- 				ON [PXCC].[ID] = [DCC].[IDPropiedadXConceptoCobro]
								-- 				INNER JOIN [dbo].[ConceptoCobro] AS [CC]
								-- 				ON [CC].[ID] = [PXCC].[IDConceptoCobro]
								-- 				INNER JOIN [dbo].[CCConsumoAgua] AS [CCCA]
								-- 				ON [CCCA].[IDCC] = [CC].[ID]
								-- 				INNER JOIN [dbo].[PropiedadXCCConsumoAgua] AS [PXCA]
								-- 				ON [PXCA].[IDPropiedadXCC] = [PXCC].[ID]
								-- 			WHERE [DCC].[Activo] = 1
								-- 			AND [F].[Fecha] = @inFechaOperacion
								-- 			AND [F].[Activo] = 1
								-- 			AND [PXCC].[IDPropiedad] = [LUF].[IDPropiedad]
								-- 			AND [PXCC].[FechaFin] IS NULL;

								-- 			SET @outResultCode = 5200; /* OK */
								-- 		COMMIT TRANSACTION [createFacturaXConceptoCobro]
								-- 	END;
								-- ELSE
								-- 	BEGIN
								-- 		/* ERROR : Cannot start the billing process because
								-- 		some params are null */
								-- 		SET @outResultCode = 5403; 
								-- 		RETURN;
								-- 	END;
							END;
						ELSE
							BEGIN
								/* ERROR : Cannot start the billing process because
								some Property has already bills on @inFechaOperacion */
								SET @outResultCode = 5402; 
								RETURN;
							END;
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
				/* ERROR : Cannot start the billing process because
				some params are null */
				SET @outResultCode = 5400; 
				RETURN;
			END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [createFacturaXConceptoCobro]
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