USE [MunITCR]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 
	@proc_name SP_LoadDataset
	@proc_description Reads the xml file with the data set to be loaded located in the bucket and inserts the data in bulk 
	into temporary tables and finally inserts the temporary data into the database tables.
	@proc_param inRDSFilePath The file path for the RDS instance. If not specified, the file path is D:\S3\Operaciones.xml
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [dbo].[SP_LoadDataset]
	@inRDSFilePath NVARCHAR(2048),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* OK */

		IF (@inRDSFilePath IS NULL)
			BEGIN
				SET @inRDSFilePath = 'D:\S3\Catalogos.xml'; /* @inRDSFilePath default value */
			END;

		DECLARE
			@hdoc INT,
			@Data XML,
			@outData XML, --  out parameter 
			@Command NVARCHAR(500) = 'SELECT @Data = D FROM OPENROWSET (BULK '  + CHAR(39) + @inRDSFilePath + CHAR(39) + ', SINGLE_BLOB) AS Data (D)',
			@Parameters NVARCHAR(500) = N'@Data [XML] OUTPUT';

		EXECUTE SP_EXECUTESQL @Command, @Parameters, @Data = @outData OUTPUT; -- execute the dinamic SQL command
		SET @Data = @outData; -- assign the dinamic SQL out parameter
		EXECUTE SP_XML_PREPAREDOCUMENT @hdoc OUTPUT, @Data; -- associate the identifier and XML doc

		/* Temporal table to insert "tipos de evento en bitacora" from the xml doc */
		DECLARE @TMPEventoBitacora TABLE (
			[EVB_Nombre] NVARCHAR(8)
		);
		/* Get "tipos de evento en bitacora" from xml dataset */
		INSERT INTO @TMPEventoBitacora (
			[EVB_Nombre]
		) SELECT
			[Nombre]
		FROM OPENXML (
			@hdoc, 'Catalogo/EventosBitacora/EventoBitacora', 1
		) WITH (
			[Nombre] NVARCHAR(8)
		) AS [NewEVB];


		/* Temporal table to insert "tipos de entidad en bitacora" from the xml doc */
		DECLARE @TMPEntidadBitacora TABLE (
			[ETB_Nombre] NVARCHAR(128)
		);
		/* Get "tipos de entidad en bitacora" from xml dataset */
		INSERT INTO @TMPEntidadBitacora (
			[ETB_Nombre]
		) SELECT
			[Nombre]
		FROM OPENXML (
			@hdoc, 'Catalogo/EntidadesBitacora/EntidadBitacora', 1
		) WITH (
			[Nombre] NVARCHAR(128)
		) AS [NewETB];


		/* Temporal table to insert the "tipos de movimiento del cc-consumo agua" from the xml doc */
		DECLARE @TMPTipoMovimientoConsumoAgua TABLE (
			[TMCA_Nombre] VARCHAR(128)
		);
		/* Get tipos de "movimiento del cc-consumo agua" from xml dataset */
		INSERT INTO @TMPTipoMovimientoConsumoAgua (
			[TMCA_Nombre]
		) SELECT
			[Nombre]
		FROM OPENXML (
			@hdoc, 'Catalogo/TipodeMovimientoLecturadeMedidores/TipodeMovimientoLecturadeMedidor', 1
		) WITH (
			[Nombre] VARCHAR(128)
		) AS [NewTMCA];


		/* Temporal table to insert the "tipos de movimiento del cc-arreglo de pago" from the xml doc */
		DECLARE @TMPTipoMovimientoArregloPago TABLE (
			[TMAP_Nombre] VARCHAR(128)
		);
		/* Get tipos de "movimiento del cc-arreglo de pago" from xml dataset */
		INSERT INTO @TMPTipoMovimientoArregloPago (
			[TMAP_Nombre]
		) SELECT
			[Nombre]
		FROM OPENXML (
			@hdoc, 'Catalogo/TiposMovimientoArregloPago/TipoMovimientoArregloPago', 1
		) WITH (
			[Nombre] VARCHAR(128)
		) AS [NewTMAP];


		/* Temporal table to insert the "tasas de interes de arreglo de pago" from the xml doc */
		DECLARE @TMPTasaInteres TABLE (
			[TIAP_PlazoMeses] INT,
			[TIAP_TasaInteresAnual] FLOAT
		);
		/* Get tipos de "tasas de interes de arreglo de pago" from xml dataset */
		INSERT INTO @TMPTasaInteres (
			[TIAP_PlazoMeses],
			[TIAP_TasaInteresAnual]
		) SELECT
			[PlazoMeses],
			[InteresAnual]
		FROM OPENXML (
			@hdoc, 'Catalogo/TasasInteresArregloPago/TasaInteresArregloPago', 1
		) WITH (
			[PlazoMeses] INT,
			[InteresAnual] FLOAT
		) AS [NewTIAP];


		/* Temporal table to insert the "tipos de uso de propiedad" from the xml doc */
		DECLARE @TMPTipoUsoPropiedad TABLE (
			[TUP_Nombre] VARCHAR(128)
		);
		/* Get "tipos de uso de propiedad" from xml dataset */
		INSERT INTO @TMPTipoUsoPropiedad (
			[TUP_Nombre]
		) SELECT
			[Nombre]
		FROM OPENXML (
			@hdoc, 'Catalogo/TipoUsoPropiedades/TipoUsoPropiedad', 1
		) WITH (
			[Nombre] VARCHAR(128)
		) AS [NewTUP];
		

		/* Temporal table to insert the "tipos de zona de propiedad" from the xml doc */
		DECLARE @TMPTipoZonaPropiedad TABLE (
			[TZP_Nombre] VARCHAR(128)
		);
		/* Get "tipos de zona de propiedad" from xml dataset */
		INSERT INTO @TMPTipoZonaPropiedad (
			[TZP_Nombre]
		) SELECT
			[Nombre]
		FROM OPENXML (
			@hdoc, 'Catalogo/TipoZonaPropiedades/TipoZonaPropiedad', 1
		) WITH (
			[Nombre] VARCHAR(128)
		) AS [NewTZP];


		/* Temporal table to insert the "tipos de documento identidad" from the xml doc */
		DECLARE @TMPTipoDocIdentidad TABLE (
			[TDI_Nombre] VARCHAR(128)
		);
		/* Get "tipos de documento identidad" from xml dataset */
		INSERT INTO @TMPTipoDocIdentidad (
			[TDI_Nombre]
		) SELECT
			[Nombre]
		FROM OPENXML (
			@hdoc, 'Catalogo/TipoDocumentoIdentidades/TipoDocumentoIdentidad', 1
		) WITH (
			[Nombre] VARCHAR(128)
		) AS [NewTDI];


		/* Temporal table to insert "medios de pago" from the xml doc */
		DECLARE @TMPMedioPago TABLE (
			[MP_Nombre] VARCHAR(128)
		);
		/* Get "medios de pago" from xml dataset */
		INSERT INTO @TMPMedioPago (
			[MP_Nombre]
		) SELECT
			[Nombre]
		FROM OPENXML (
			@hdoc, 'Catalogo/MediosPago/MedioPago', 1
		) WITH (
			[Nombre] VARCHAR(128)
		) AS [NewMP];


		/* Temporal table to insert "periodos de monto de cc's" from the xml doc */
		DECLARE @TMPPeridoMontoCC TABLE (
			[PMCC_Nombre] VARCHAR(128),
			[PMCC_Meses] INT
		);
		/* Get "periodos de monto de cc's" from xml dataset */
		INSERT INTO @TMPPeridoMontoCC (
			[PMCC_Nombre],
			[PMCC_Meses]
		) SELECT
			[Nombre],
			[QMeses]
		FROM OPENXML (
			@hdoc, 'Catalogo/PeriodoMontoCCs/PeriodoMontoCC', 1
		) WITH (
			[Nombre] VARCHAR(128),
			[QMeses] INT
		) AS [NewPMCC];


		/* Temporal table to insert "tipos de monto de cc" from the xml doc */
		DECLARE @TMPTipoMontoCC TABLE (
			[TMCC_Nombre] VARCHAR(128)
		);
		/* Get "tipos de monto de cc" from xml dataset */
		INSERT INTO @TMPTipoMontoCC (
			[TMCC_Nombre]
		) SELECT
			[Nombre]
		FROM OPENXML (
			@hdoc, 'Catalogo/TipoMontoCCs/TipoMontoCC', 1
		) WITH (
			[Nombre] VARCHAR(128)
		) AS [NewTMCC];


		/* Temporal table to insert "tipos de parametro" from the xml doc */
		DECLARE @TMPTipoParametro TABLE (
			[TP_Nombre] VARCHAR(128)
		);
		/* Get "tipos de parametro" from xml dataset */
		INSERT INTO @TMPTipoParametro (
			[TP_Nombre]
		) SELECT
			[Nombre]
		FROM OPENXML (
			@hdoc, 'Catalogo/TipoParametroSistema/TipoParametro', 1
		) WITH (
			[Nombre] VARCHAR(128)
		) AS [NewTP];


		/* Temporal table to insert "parametros" from the xml doc */
		DECLARE @TMPParametro TABLE (
			[P_NombreTipoParametro] VARCHAR(128),
			[P_Descripcion] VARCHAR(128),
			[P_Valor] VARCHAR(64)
		);
		/* Get "parametros" from xml dataset */
		INSERT INTO @TMPParametro (
			[P_NombreTipoParametro],
			[P_Descripcion],
			[P_Valor]
		) SELECT
			[NombreTipoPar],
			[Nombre],
			[Valor]
		FROM OPENXML (
			@hdoc, 'Catalogo/ParametrosSistema/ParametroSistema', 1
		) WITH (
			[NombreTipoPar] VARCHAR(128),
			[Nombre] VARCHAR(128),
			[Valor] VARCHAR(64)
		) AS [NewP];

		/* Temporal table to insert "conceptos de cobro" from the xml doc */
		DECLARE @TMPConceptoCobro TABLE (
			[CC_PeriodoCC] VARCHAR(128),
			[CC_TipoMontoCC] VARCHAR(128),
			[CC_Nombre] VARCHAR(128),
			[CC_ValorFijo] MONEY,
			[CC_ValorMinimo] MONEY,
			[CC_ValorM2Minimo] MONEY,
			[CC_ValorTractosM2] MONEY,
			[CC_ValorM3] INT,
			[CC_ValorMinimoM3] MONEY,
			[CC_ValorPorcentual] FLOAT
		);
		/* Get "conceptos de cobro" from xml dataset */
		INSERT INTO @TMPConceptoCobro (
			[CC_PeriodoCC],
			[CC_TipoMontoCC],
			[CC_Nombre],
			[CC_ValorFijo],
			[CC_ValorMinimo],
			[CC_ValorM2Minimo],
			[CC_ValorTractosM2],
			[CC_ValorM3],
			[CC_ValorMinimoM3],
			[CC_ValorPorcentual]
		) SELECT
			[PeriodoMontoCC],
			[TipoMontoCC],
			[Nombre],
			[ValorFijo],
			[ValorMinimo],
			[ValorM2Minimo],
			[ValorTractosM2],
			[ValorM3],
			[ValorMinimoM3],
			[ValorPorcentual]
		FROM OPENXML (
			@hdoc, 'Catalogo/CCs/CC', 1
		) WITH (
			[PeriodoMontoCC] VARCHAR(128),
			[TipoMontoCC] VARCHAR(128),
			[Nombre] VARCHAR(128),
			[ValorFijo] MONEY,
			[ValorMinimo] MONEY,
			[ValorM2Minimo] MONEY,
			[ValorTractosM2] MONEY,
			[ValorM3] INT,
			[ValorMinimoM3] MONEY,
			[ValorPorcentual] FLOAT
		) AS [NewCC];


		EXECUTE SP_XML_REMOVEDOCUMENT @hdoc; -- release the memory used from xml doc


		BEGIN TRANSACTION [InsertData]

			INSERT INTO [dbo].[EventType] (
				[Name]
			) SELECT
				[NewEVB].[EVB_Nombre]
			FROM @TMPEventoBitacora AS [NewEVB];


			INSERT INTO [dbo].[EntityType] (
				[Name]
			) SELECT
				[NewETB].[ETB_Nombre]
			FROM @TMPEntidadBitacora AS [NewETB];


			INSERT INTO [dbo].[TipoMovimientoConsumoAgua] (
				[Nombre]
			) SELECT
				[NewTMCA].[TMCA_Nombre]
			FROM @TMPTipoMovimientoConsumoAgua AS [NewTMCA];


			INSERT INTO [dbo].[TipoMovimientoArregloPago] (
				[Nombre]
			) SELECT
				[NewTMAP].[TMAP_Nombre]
			FROM @TMPTipoMovimientoArregloPago AS [NewTMAP];


			INSERT INTO [dbo].[TasaInteres] (
				[PlazoMeses],
				[TasaInteresAnual]
			) SELECT
				[NewTIAP].[TIAP_PlazoMeses],
				[NewTIAP].[TIAP_TasaInteresAnual]
			FROM @TMPTasaInteres AS [NewTIAP];


			INSERT INTO [dbo].[TipoUsoPropiedad] (
				[Nombre]
			) SELECT
				[NewTUP].[TUP_Nombre]
			FROM @TMPTipoUsoPropiedad AS [NewTUP]
			ORDER BY [NewTUP].[TUP_Nombre];


			INSERT INTO [dbo].[TipoZonaPropiedad] (
				[Nombre]
			) SELECT
				[NewTZP].[TZP_Nombre]
			FROM @TMPTipoZonaPropiedad AS [NewTZP]
			ORDER BY [NewTZP].[TZP_Nombre];


			INSERT INTO [dbo].[TipoDocIdentidad] (
				[Nombre]
			) SELECT
				[NewTDI].[TDI_Nombre]
			FROM @TMPTipoDocIdentidad AS [NewTDI];

			INSERT INTO [dbo].[MedioPago] (
				[Nombre]
			) SELECT
				[NewMP].[MP_Nombre]
			FROM @TMPMedioPago AS [NewMP];


			INSERT INTO [dbo].[PeriodoMontoCC] (
				[Nombre],
				[Meses]
			) SELECT
				[NewPMCC].[PMCC_Nombre],
				[NewPMCC].[PMCC_Meses]
			FROM @TMPPeridoMontoCC AS [NewPMCC];


			INSERT INTO [dbo].[TipoMontoCC] (
				[Nombre]
			) SELECT
				[NewTMCC].[TMCC_Nombre]
			FROM @TMPTipoMontoCC AS [NewTMCC];


			INSERT INTO [dbo].[TipoParametro] (
				[Nombre]
			) SELECT
				[NewTP].[TP_Nombre]
			FROM @TMPTipoParametro AS [NewTP];
			

			INSERT INTO [dbo].[Parametro] (
				[IDTipoParametro],
				[Descripcion]
			) SELECT
				[TP].[ID],
				[NewP].[P_Descripcion]
			FROM @TMPParametro AS [NewP]
				INNER JOIN [dbo].[TipoParametro] AS [TP] 
				ON [TP].[Nombre] = [NewP].[P_NombreTipoParametro]
			ORDER BY [NewP].[P_NombreTipoParametro], [NewP].[P_Descripcion];


			INSERT INTO [dbo].[ParametroInteger] (
				[IDParametro],
				[Valor]
			) SELECT
				[P].[ID],
				(SELECT CONVERT(INT, [NewP].[P_Valor]))
			FROM @TMPParametro AS [NewP] 
				INNER JOIN [dbo].[Parametro] AS [P]
				ON [P].[Descripcion] = [NewP].[P_Descripcion]
			WHERE [NewP].[P_NombreTipoParametro] = 'int';


			INSERT INTO [dbo].[ConceptoCobro] (
				[IDPeriodoCC],
				[IDTipoMontoCC],
				[Nombre]
			) SELECT
				[PM].[ID],
				[TM].[ID],
				[NewCC].[CC_Nombre]
			FROM @TMPConceptoCobro AS [NewCC]
				INNER JOIN [dbo].[PeriodoMontoCC] AS [PM]
				ON [PM].[Nombre] = [NewCC].[CC_PeriodoCC]
				INNER JOIN [dbo].[TipoMontoCC] AS [TM]
				ON [TM].[Nombre] = [NewCC].[CC_TipoMontoCC]
			ORDER BY [PM].[ID], [TM].[ID], [NewCC].[CC_Nombre];


			INSERT INTO [dbo].[CCConsumoAgua] (
				[IDCC],
				[MinimoM3],
				[MontoMinimo],
				[MontoMinimoM3]
			) SELECT
				[CC].[ID],
				[NewCC].[CC_ValorM3],
				[NewCC].[CC_ValorMinimo],
				[NewCC].[CC_ValorMinimoM3]
			FROM @TMPConceptoCobro AS [NewCC]
				INNER JOIN [dbo].[ConceptoCobro] AS [CC] 
				ON [CC].[Nombre] = [NewCC].[CC_Nombre]
			WHERE [NewCC].[CC_Nombre] = 'Consumo de agua';


			INSERT INTO [dbo].[CCImpuestoPropiedad] (
				[IDCC],
				[MontoPorcentual]
			) SELECT
				[CC].[ID],
				[NewCC].[CC_ValorPorcentual]
			FROM @TMPConceptoCobro AS [NewCC]
				INNER JOIN [dbo].[ConceptoCobro] AS [CC] 
				ON [CC].[Nombre] = [NewCC].[CC_Nombre]
			WHERE [NewCC].[CC_Nombre] = 'Impuesto sobre propiedad';


			INSERT INTO [dbo].[CCBasura] (
				[IDCC],
				[MontoFijo],
				[MontoMinimo],
				[MontoMinimoM2],
				[MontoTractoM2]
			) SELECT
				[CC].[ID],
				[NewCC].[CC_ValorFijo],
				[NewCC].[CC_ValorMinimo],
				[NewCC].[CC_ValorM2Minimo],
				[NewCC].[CC_ValorTractosM2]
			FROM @TMPConceptoCobro AS [NewCC]
				INNER JOIN [dbo].[ConceptoCobro] AS [CC] 
				ON [CC].[Nombre] = [NewCC].[CC_Nombre]
			WHERE [NewCC].[CC_Nombre] = 'Recoleccion de basura y limpieza de cannos';


			INSERT INTO [dbo].[CCPatenteComercial] (
				[IDCC],
				[MontoFijo]
			) SELECT
				[CC].[ID],
				[NewCC].[CC_ValorFijo]
			FROM @TMPConceptoCobro AS [NewCC]
				INNER JOIN [dbo].[ConceptoCobro] AS [CC] 
				ON [CC].[Nombre] = [NewCC].[CC_Nombre]
			WHERE [NewCC].[CC_Nombre] = 'Patente comercial';


			INSERT INTO [dbo].[CCReconexion] (
				[IDCC],
				[MontoFijo]
			) SELECT
				[CC].[ID],
				[NewCC].[CC_ValorFijo]
			FROM @TMPConceptoCobro AS [NewCC]
				INNER JOIN [dbo].[ConceptoCobro] AS [CC] 
				ON [CC].[Nombre] = [NewCC].[CC_Nombre]
			WHERE [NewCC].[CC_Nombre] = 'Reconexion de agua';


			INSERT INTO [dbo].[CCInteresMoratorio] (
				[IDCC],
				[MontoPorcentual]
			) SELECT
				[CC].[ID],
				[NewCC].[CC_ValorPorcentual]
			FROM @TMPConceptoCobro AS [NewCC]
				INNER JOIN [dbo].[ConceptoCobro] AS [CC] 
				ON [CC].[Nombre] = [NewCC].[CC_Nombre]
			WHERE [NewCC].[CC_Nombre] = 'Intereses moratorios';


			INSERT INTO [dbo].[CCMantenimientoParque] (
				[IDCC],
				[MontoFijo]
			) SELECT
				[CC].[ID],
				[NewCC].[CC_ValorFijo]
			FROM @TMPConceptoCobro AS [NewCC]
				INNER JOIN [dbo].[ConceptoCobro] AS [CC] 
				ON [CC].[Nombre] = [NewCC].[CC_Nombre]
			WHERE [NewCC].[CC_Nombre] = 'Mantenimiento de parques y alumbrado publico';


			INSERT INTO [dbo].[CCArregloPago] (
				[IDCC]
			) SELECT
				[CC].[ID]
			FROM @TMPConceptoCobro AS [NewCC]
				INNER JOIN [dbo].[ConceptoCobro] AS [CC] 
				ON [CC].[Nombre] = [NewCC].[CC_Nombre]
			WHERE [NewCC].[CC_Nombre] = 'Arreglo de pago';

			SET @outResultCode = 5200; /* OK */

		COMMIT TRANSACTION [InsertData]

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [InsertData]
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
