/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_CreateComprobantePago
	@proc_description
	@proc_param inReferencia 
	@proc_param inMedioPago 
	@proc_param inFecha 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
	@author <a href="https://github.com/efmz200">Erick F. Madrigal Zavala</a>
*/
CREATE OR ALTER PROCEDURE [SP_CreateComprobantePago]
	@inReferencia BIGINT,
	@inMedioPago VARCHAR(128),
	@inFecha DATE,
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF @inMedioPago IS NOT NULL
			BEGIN
				/* Gets the PK of "Medio de Pago" using @inMedioPago */
				DECLARE @idMedioPago INT;
				SELECT @idMedioPago = [MP].[ID]
				FROM [dbo].[MedioPago] AS [MP]
				WHERE [MP].[Nombre] = @inMedioPago;

				IF @inReferencia IS NULL
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

				IF (@idMedioPago IS NOT NULL) AND (@inReferencia IS NOT NULL) 
				AND (@inFecha IS NOT NULL)
					BEGIN
						INSERT INTO [dbo].[ComprobantePago] (
							[IDMedioPago],
							[Referencia],
							[Fecha]
						) VALUES (
							@idMedioPago,
							@inReferencia,
							@inFecha
						);
						SET @outResultCode = 5200; /* OK */
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
				because some params are null */
				SET @outResultCode = 5400; 
				RETURN;
			END;
	END TRY
	BEGIN CATCH
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