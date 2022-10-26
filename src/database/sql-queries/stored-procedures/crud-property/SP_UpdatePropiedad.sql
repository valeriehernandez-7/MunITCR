/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_UpdatePropiedad
	@proc_description
	@proc_param inOldLote
	@proc_param inUsoPropiedad
	@proc_param inZonaPropiedad
	@proc_param inLote
	@proc_param inMetrosCuadrados
	@proc_param inValorFiscal
	@proc_param inFechaRegistro
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_UpdatePropiedad]
	@inOldLote CHAR(32),
	@inUsoPropiedad VARCHAR(128),
	@inZonaPropiedad VARCHAR(128),
	@inLote CHAR(32),
	@inMetrosCuadrados BIGINT,
	@inValorFiscal MONEY,
	@inFechaRegistro DATE,
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF (@inOldLote IS NOT NULL) AND (@inUsoPropiedad IS NOT NULL) 
		AND (@inZonaPropiedad IS NOT NULL) AND (@inLote IS NOT NULL) 
		AND (@inMetrosCuadrados IS NOT NULL) AND (@inValorFiscal IS NOT NULL)
			BEGIN
				/* Gets the PK of old "Propiedad" using @inOldLote */
				DECLARE @idPropiedad INT;
				SELECT @idPropiedad = [Pro].[ID]
				FROM [dbo].[Propiedad] AS [Pro]
				WHERE [Pro].[Lote] = @inOldLote;

				/* Gets the PK of "Tipo Uso de Propiedad" using @inUsoPropiedad */
				DECLARE @idUsoPropiedad INT;
				SELECT @idUsoPropiedad = [UP].[ID]
				FROM [dbo].[TipoUsoPropiedad] AS [UP]
				WHERE [UP].[Nombre] = @inUsoPropiedad;

				/* Gets the PK of "Tipo Zona de Propiedad" using @inZonaPropiedad */
				DECLARE @idZonaPropiedad INT;
				SELECT @idZonaPropiedad = [ZP].[ID]
				FROM [dbo].[TipoZonaPropiedad] AS [ZP]
				WHERE [ZP].[Nombre] = @inZonaPropiedad;

				IF @inFechaRegistro IS NULL
					BEGIN
						SET @inFechaRegistro = GETDATE();
					END;

				IF (@idPropiedad IS NOT NULL) AND (@idUsoPropiedad IS NOT NULL) AND (@idZonaPropiedad IS NOT NULL)
					BEGIN
						BEGIN TRANSACTION [updatePropiedad]
							UPDATE [dbo].[Propiedad]
								SET
									[IDTipoUsoPropiedad] = @idUsoPropiedad,
									[IDTipoZonaPropiedad] = @idZonaPropiedad,
									[Lote] = @inLote,
									[MetrosCuadrados] = @inMetrosCuadrados,
									[ValorFiscal] = @inValorFiscal,
									[FechaRegistro] = @inFechaRegistro
							WHERE [ID] = @idPropiedad;
							SET @outResultCode = 5200; /* OK */
						COMMIT TRANSACTION [updatePropiedad]
					END;
				ELSE
					BEGIN
						/* Cannot update the "Propiedad" because a "Tipo Uso de Propiedad" with 
						@inUsoPropiedad did not exist or "Tipo Zona de Propiedad" with @inZonaPropiedad did not exist */
						SET @outResultCode = 5404; 
						RETURN;
					END;
			END;
		ELSE
			BEGIN
				/* Cannot update the "Propiedad" because some params are null */
				SET @outResultCode = 5400; 
				RETURN;
			END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [updatePropiedad]
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