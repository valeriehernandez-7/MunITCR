/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_CreateFacturaXConceptoCobro
	@proc_description
	@proc_param
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_CreateFacturaXConceptoCobro]
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
				DECLARE @diaFechaOperacion INT = DATEPART(DAY, @inFechaOperacion);
				DECLARE @diaFechaFinMes INT = DATEPART(DAY, EOMONTH(@inFechaOperacion));

				DECLARE @TMPPropiedad TABLE (
					[ID] INT IDENTITY(1,1) PRIMARY KEY,
					[IDPropiedad] INT,
					[IDPropiedadXConceptoCobro] INT
				);

				IF (@diaFechaOperacion < @diaFechaFinMes)
					BEGIN
						INSERT INTO @TMPPropiedad (
							[IDPropiedad],
							[IDPropiedadXConceptoCobro]
						) SELECT 
							[P].[ID],
							[PXCC].[ID]
						FROM [dbo].[Propiedad] AS [P]
							INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
							ON [PXCC].[IDPropiedad] = [P].[ID]
						WHERE DATEPART(DAY, [P].[FechaRegistro]) = @diaFechaOperacion
						AND [PXCC].[FechaFin] IS NULL;
					END;
				ELSE
					BEGIN
						INSERT INTO @TMPPropiedad (
							[IDPropiedad],
							[IDPropiedadXConceptoCobro]
						) SELECT 
							[P].[ID],
							[PXCC].[ID]
						FROM [dbo].[Propiedad] AS [P]
							INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
							ON [PXCC].[IDPropiedad] = [P].[ID]
							INNER JOIN [dbo].[Factura] AS [F]
							ON [F].[IDPropiedad] = [P].[ID]
						WHERE DATEPART(DAY, [P].[FechaRegistro]) >= @diaFechaFinMes
						AND [PXCC].[FechaFin] IS NULL
						AND DATEPART(MONTH, [F].[Fecha]) < DATEPART(MONTH, @inFechaOperacion)
						AND DATEPART(YEAR, [F].[Fecha]) = DATEPART(YEAR, @inFechaOperacion);
					END;
				
				IF EXISTS (SELECT 1 FROM @TMPPropiedad)
					BEGIN
						/* Get the bill expiration date based on system parameters */
						DECLARE @diasVencimiento INT;
						SELECT @diasVencimiento = [PI].[Valor]
						FROM [dbo].[ParametroInteger] AS [PI]
							INNER JOIN [dbo].[Parametro] AS [PS]
							ON [PS].[ID] = [PI].[IDParametro]
						WHERE [PS].[Descripcion] = 'Cantidad de dias para calculo de fecha de vencimiento';

						DECLARE @fechaVencimiento DATE = DATEADD(DAY, @diasVencimiento, @inFechaOperacion);

						IF (@fechaVencimiento IS NOT NULL)
							BEGIN
								BEGIN TRANSACTION [createFacturaXConceptoCobro]
									INSERT INTO [dbo].[Factura] (
										[IDPropiedad],
										[Fecha],
										[FechaVencimiento]
									) SELECT
										[TP].[IDPropiedad],
										@inFechaOperacion,
										@fechaVencimiento
									FROM @TMPPropiedad AS [TP];

									INSERT INTO [dbo].[DetalleCC] (
										[IDFactura],
										[IDPropiedadXConceptoCobro]
									) SELECT 
										SCOPE_IDENTITY(),
										[TP].[IDPropiedadXConceptoCobro]
									FROM @TMPPropiedad AS [TP];

									SET @outResultCode = 5200; /* OK */
								COMMIT TRANSACTION [createFacturaXConceptoCobro]
							END;
						ELSE
							BEGIN
								/* ERROR : Cannot start the billing process because
								some params are null */
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