/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_CreateMovimientoConsumoAgua
	@proc_description
	@proc_param 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_CreateMovimientoConsumoAgua]
	@inPropiedadLote VARCHAR(32),
	@inTipo VARCHAR(128),
	@inMonto INT,
	@inFecha DATE,
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF (@inTipo IS NOT NULL) AND (@inPropiedadLote IS NOT NULL) AND (@inMonto IS NOT NULL)
			BEGIN
				/* Gets the PK of @inTipo */
				DECLARE @idTipoMovimientoConsumoAgua INT;
				SELECT @idTipoMovimientoConsumoAgua = [TMCA].[ID]
				FROM [dbo].[TipoMovimientoConsumoAgua] AS [TMCA]
				WHERE [TMCA].[Nombre] = @inTipo;

				/* Gets the PK of @idPropiedadXCCConsumoAgua based on @inPropiedadLote */
				DECLARE @idPropiedadXCCConsumoAgua INT;
				SELECT @idPropiedadXCCConsumoAgua = [PXCCCA].[IDPropiedadXCC]
				FROM [dbo].[PropiedadXCCConsumoAgua] AS [PXCCCA]
					INNER JOIN [dbo].[PropiedadXConceptoCobro] AS [PXCC]
					ON [PXCC].[ID] = [PXCCCA].[IDPropiedadXCC]
				WHERE [PXCC].[IDPropiedad] = @inPropiedadLote;

				IF @inFecha IS NULL
					BEGIN
						SET @inFecha = GETDATE();
					END;
		
				IF (@idTipoMovimientoConsumoAgua IS NOT NULL) AND (@idPropiedadXCCConsumoAgua IS NOT NULL)
				AND (@inFecha IS NOT NULL)
					BEGIN
						/* Calc consumption of water as " monto en metros cubicos" */
						DECLARE 
							@lecturaMedidor INT,
							@montoM3 INT;
						
						IF (@lecturaMedidor IS NOT NULL) AND (@montoM3 IS NOT NULL)
							BEGIN
								IF NOT EXISTS (SELECT 1 FROM [dbo].[MovimientoConsumoAgua] AS [MCA] 
								WHERE [MCA].[IDPropiedadXCCConsumoAgua] = @idPropiedadXCCConsumoAgua 
								AND [MCA].[IDTipoMovimientoConsumoAgua] = @idTipoMovimientoConsumoAgua
								AND [MCA].[Fecha] = @inFecha
								AND [MCA].[MontoM3] = @montoM3
								AND [MCA].[LecturaMedidor] = @lecturaMedidor)
									BEGIN
										BEGIN TRANSACTION [insertMovimientoConsumoAgua]
											INSERT INTO [dbo].[MovimientoConsumoAgua] (
												[IDTipoMovimientoConsumoAgua],
												[IDPropiedadXCCConsumoAgua],
												[Fecha],
												[MontoM3],
												[LecturaMedidor]
											) VALUES (
												@idTipoMovimientoConsumoAgua,
												@idPropiedadXCCConsumoAgua,
												@inFecha,
												@montoM3,
												@lecturaMedidor
											);
											SET @outResultCode = 5200; /* OK */
										COMMIT TRANSACTION [insertMovimientoConsumoAgua]
									END;
								ELSE
									BEGIN
										/* Cannot insert the new "MovimientoConsumoAgua" 
										because @lecturaMedidor or  @montoM3 is null */
										SET @outResultCode = 5407;
										RETURN;
									END;
							END;
						ELSE
							BEGIN
								/* Cannot insert the new "MovimientoConsumoAgua" 
								because it already exists based on the data */
								SET @outResultCode = 5406;
								RETURN;
							END;
					END;
				ELSE
					BEGIN
						/* Cannot insert the new "MovimientoConsumoAgua" because 
						the @idTipoMovimientoConsumoAgua or @idPropiedadXCCConsumoAgua 
						did not exist */
						SET @outResultCode = 5404; 
						RETURN;
					END;
			END;
		ELSE
			BEGIN
				/* Cannot insert the new "MovimientoConsumoAgua" 
				because some params are null */
				SET @outResultCode = 5400; 
				RETURN;
			END;
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