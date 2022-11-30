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
				
				DECLARE @diaFechaOperacion INT = DATEPART(DAY, @inFechaOperacion);
				DECLARE @diaFechaFinMes INT = DATEPART(DAY, EOMONTH(@inFechaOperacion));

				DECLARE @TMPPropiedadAP TABLE (
					[ID] INT IDENTITY(1,1) PRIMARY KEY,
					[IDPropiedad] INT,
					[IDPropiedadXCCAP] INT
				);

				IF (@diaFechaOperacion < @diaFechaFinMes)
					BEGIN
						INSERT INTO @TMPPropiedadAP (
							[IDPropiedad],
							[IDPropiedadXCCAP]
						) SELECT 
							[P].[ID],
							[PXCCAP].[ID]
						FROM [dbo].[Propiedad] AS [P]
							INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
							ON [PXCC].[IDPropiedad] = [P].[ID]
							INNER JOIN [dbo].[PropiedadXCCArregloPago] AS [PXCCAP]
							ON [PXCCAP].[IDPropiedadXCC] = [PXCC].[ID]
						WHERE [P].[Activo] = 1
						AND [P].[FechaRegistro] <= @inFechaOperacion
						AND DATEPART(DAY, [P].[FechaRegistro]) = @diaFechaOperacion
						AND [PXCC].[FechaInicio] <= @inFechaOperacion
						AND [PXCC].[FechaFin] >= @inFechaOperacion
						AND [PXCCAP].[Activo] = 1
						GROUP BY [P].[ID]
						ORDER BY [P].[ID];
					END;
				ELSE
					BEGIN
						INSERT INTO @TMPPropiedadAP (
							[IDPropiedad],
							[IDPropiedadXCCAP]
						) SELECT 
							[P].[ID],
							[PXCCAP].[ID]
						FROM [dbo].[Propiedad] AS [P]
							INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
							ON [PXCC].[IDPropiedad] = [P].[ID]
							INNER JOIN [dbo].[PropiedadXCCArregloPago] AS [PXCCAP]
							ON [PXCCAP].[IDPropiedadXCC] = [PXCC].[ID]
						WHERE [P].[Activo] = 1
						AND [P].[FechaRegistro] <= @inFechaOperacion
						AND DATEPART(DAY, [P].[FechaRegistro]) >= @diaFechaFinMes
						AND [PXCC].[FechaInicio] <= @inFechaOperacion
						AND [PXCC].[FechaFin] >= @inFechaOperacion
						AND [PXCCAP].[Activo] = 1
						GROUP BY [P].[ID]
						ORDER BY [P].[ID];
					END;
				
				IF EXISTS (SELECT 1 FROM @TMPPropiedadAP)
					BEGIN
						BEGIN TRANSACTION [facturacionAP]
							
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