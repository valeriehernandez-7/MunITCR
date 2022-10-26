/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_CreatePropiedad
	@proc_description 
	@proc_param inUsoPropiedad
	@proc_param inZonaPropiedad
	@proc_param inLote
	@proc_param inMedidor
	@proc_param inMetrosCuadrados
	@proc_param inValorFiscal
	@proc_param inFechaRegistro 
	@proc_param inEventUser 
	@proc_param inEventIP 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_CreatePropiedad]
	@inUsoPropiedad VARCHAR(128),
	@inZonaPropiedad VARCHAR(128),
	@inLote CHAR(32),
	@inMedidor CHAR(16),
	@inMetrosCuadrados BIGINT,
	@inValorFiscal MONEY,
	@inFechaRegistro DATE,
	@inEventUser VARCHAR(16),
	@inEventIP VARCHAR(64),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF (@inUsoPropiedad IS NOT NULL) AND (@inZonaPropiedad IS NOT NULL) AND (@inLote IS NOT NULL) AND
		(@inMedidor IS NOT NULL) AND (@inMetrosCuadrados IS NOT NULL) AND (@inValorFiscal IS NOT NULL)
			BEGIN
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

				/* Checks if the @inMedidor value belongs to another "Propiedad"  */
				DECLARE @idPropiedadXCCConsumoAgua INT;
				SELECT @idPropiedadXCCConsumoAgua = [PXCA].[IDPropiedadXCC]
				FROM [dbo].[PropiedadXCCConsumoAgua] AS [PXCA]
				WHERE [PXCA].[Medidor] = @inMedidor;

				IF @inFechaRegistro IS NULL
					BEGIN
						SET @inFechaRegistro = GETDATE();
					END;

				/* Get the event params to create a new register at dbo.EventLog */

				DECLARE 
					@idEventType INT,
					@idEntityType INT,
					@lastEntityID INT,
					@actualData NVARCHAR(MAX), 
					@newData NVARCHAR(MAX);

				SELECT @idEventType = [EVT].[ID] -- event data
				FROM [dbo].[EventType] AS [EVT]
				WHERE [EVT].[Name] = 'Create';

				SELECT @idEntityType = [ENT].[ID] -- event data
				FROM [dbo].[EntityType] AS [ENT]
				WHERE [ENT].[Name] = 'Propiedad';

				IF (@idUsoPropiedad IS NOT NULL) AND (@idZonaPropiedad IS NOT NULL)
					BEGIN
						IF (NOT EXISTS (SELECT 1 FROM [dbo].[Propiedad] AS [P] WHERE [P].[Lote] = @inLote))
						AND (@idPropiedadXCCConsumoAgua IS NULL)
							BEGIN
								BEGIN TRANSACTION [insertPropiedad]
									/* Insert new "Propiedad" */
									INSERT INTO [dbo].[Propiedad] (
										[IDTipoUsoPropiedad],
										[IDTipoZonaPropiedad],
										[Lote],
										[MetrosCuadrados],
										[ValorFiscal],
										[FechaRegistro]
									) VALUES (
										@idUsoPropiedad,
										@idZonaPropiedad,
										@inLote,
										@inMetrosCuadrados,
										@inValorFiscal,
										@inFechaRegistro
									);

									/* The trigger "TR_CreatePropiedadAsociacionCC" of "dbo.Propiedad" after insert, 
									associates the new "Propiedad" with the "conceptos de cobro" according to @inZonaPropiedad */
									
									/* GET new "Propiedad" PK */
									SET @lastEntityID = SCOPE_IDENTITY(); -- event data

									/* Check if the new "Propiedad" is associated to the "Concepto de Cobro" related to "Consumo de agua" */
									DECLARE @idPropiedadXCCAgua INT;
									SELECT @idPropiedadXCCAgua = [PXCC].[ID]
									FROM dbo.[PropiedadXConceptoCobro] AS [PXCC] 
										INNER JOIN [dbo].[ConceptoCobro] AS [CC]
										ON [CC].[Nombre] = 'Consumo de agua'
									WHERE [PXCC].[IDPropiedad] = @lastEntityID 
									AND [PXCC].IDConceptoCobro = [CC].[ID];

									/* Associate new "Propiedad" with new "PropiedadXCCConsumoAgua" */
									IF (@idPropiedadXCCAgua) IS NOT NULL
										BEGIN
											INSERT INTO [dbo].[PropiedadXCCConsumoAgua] (
												[IDPropiedadXCC],
												[Medidor]
											) VALUES (
												@idPropiedadXCCAgua,
												@inMedidor
											);
										END;


									SET @newData = ( -- event data
										SELECT 
											[P].[ID] AS [ID],
											[P].[Lote] AS [Propiedad],
											[P].[IDTipoUsoPropiedad] AS [UsodePropiedad],
											[P].[IDTipoZonaPropiedad] AS [ZonadePropiedad],
											[P].[MetrosCuadrados] AS [MetrosCuadrados],
											[P].[ValorFiscal] AS [ValorFiscal],
											[P].[FechaRegistro] AS [FechadeRegistro],
											[P].[Activo] AS [Activo]
										FROM [dbo].[Propiedad] AS [P]
										WHERE [P].[ID] = @lastEntityID
										FOR JSON AUTO
									);


									IF (@idEventType IS NOT NULL) AND (@idEntityType IS NOT NULL) 
									AND (@lastEntityID IS NOT NULL)
										BEGIN
											INSERT INTO [dbo].[EventLog] (
												[IDEventType],
												[IDEntityType],
												[EntityID],
												[BeforeUpdate],
												[AfterUpdate],
												[Username],
												[UserIP]
											) VALUES (
												@idEventType,
												@idEntityType,
												@lastEntityID,
												@actualData,
												@newData,
												@inEventUser,
												@inEventIP
											);
											SET @outResultCode = 5200; /* OK */
										END;
									ELSE
										BEGIN
											/* Cannot insert the new "Evento" because some 
											event's params are null */
											SET @outResultCode = 5407;
											RETURN;
										END;
								COMMIT TRANSACTION [insertPropiedad]
							END;
						ELSE
							BEGIN
								/* Cannot insert the new "Propiedad" because it 
								already exists based on the @inLote or @inMedidor */
								SET @outResultCode = 5406;
								RETURN;
							END;
					END;
				ELSE
					BEGIN
						/* Cannot insert the new "Propiedad" because a "Tipo Uso de Propiedad" with 
						@inUsoPropiedad did not exist or "Tipo Zona de Propiedad" with @inZonaPropiedad did not exist */
						SET @outResultCode = 5404; 
						RETURN;
					END;
			END;
		ELSE
			BEGIN
				/* Cannot insert the new "Propiedad" because some params are null */
				SET @outResultCode = 5400; 
				RETURN;
			END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [insertPropiedad]
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