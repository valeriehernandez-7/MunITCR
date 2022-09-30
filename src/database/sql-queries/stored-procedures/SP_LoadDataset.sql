/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_LoadDataset
	@proc_description Reads the xml file with the data set to be loaded located in the bucket and inserts the data in bulk 
	into temporary tables and finally inserts the temporary data into the database tables.
	@proc_param inRDSFilePath The file path for the RDS instance. If not specified, the file path is D:\S3\Operaciones.xml
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_LoadDataset]
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
			@hdoc, 'Catalogo/TipodeMovimientoLecturadeMedidores/TipodeMovimientoLecturadeMedidor'
		) WITH (
			[Nombre] VARCHAR(128)
		) AS [NewTMCA];


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
			@hdoc, 'Catalogo/TipoUsoPropiedades/TipoUsoPropiedad'
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
			@hdoc, 'Catalogo/TipoZonaPropiedades/TipoZonaPropiedad'
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
			@hdoc, 'Catalogo/TipoDocumentoIdentidades/TipoDocumentoIdentidad'
		) WITH (
			[Nombre] VARCHAR(128)
		) AS [NewTDI];


		/* Temporal table to insert "medios de pago" from the xml doc */
		DECLARE @TMPMedioDePago TABLE (
			[MP_Nombre] VARCHAR(128)
		);
		/* Get "medios de pago" from xml dataset */
		INSERT INTO @TMPMedioDePago (
			[MP_Nombre]
		) SELECT
			[Nombre]
		FROM OPENXML (
			@hdoc, 'Catalogo/TipoMedioPagos/TipoMedioPago'
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
			@hdoc, 'Catalogo/PeriodoMontoCCs/PeriodoMontoCC'
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
			@hdoc, 'Catalogo/TipoMontoCCs/TipoMontoCC'
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
			@hdoc, 'Catalogo/TipoParametroSistema/TipoParametro'
		) WITH (
			[Nombre] VARCHAR(128)
		) AS [NewTP];


		/* Temporal table to insert "parametros" from the xml doc */
		DECLARE @TMPParametro TABLE (
			[P_ID] INT IDENTITY(1,1) NOT NULL,
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
			@hdoc, 'Catalogo/ParametrosSistema/ParametroSistema'
		) WITH (
			[NombreTipoPar] VARCHAR(128),
			[Nombre] VARCHAR(128),
			[Valor] VARCHAR(64)
		) AS [NewP];

		SELECT * FROM @TMPParametro; -- TO-DO: DELETE

		DECLARE
			@paramLow INT = 1,
			@paramHigh INT;
		SELECT @paramHigh = MAX(TPMParam.P_ID) FROM @TMPParametro AS TPMParam;

		SELECT @paramLow AS paramLow, @paramHigh AS paramHigh; -- TO-DO: DELETE



		/* Temporal table to insert "conceptos de cobro" from the xml doc */
		DECLARE @TMPConceptoCobro TABLE (
			[CC_ID] INT IDENTITY(1,1) NOT NULL,
			[CC_IDPeriodoCC] INT,
			[CC_IDTipoMontoCC] INT,
			[CC_Nombre] VARCHAR(128),
			[CC_ValorFijo] MONEY,
			[CC_ValorMinimo] MONEY,
			[CC_ValorM2Minimo] MONEY,
			[CC_ValorTractosM2] MONEY,
			[CC_ValorMinimoM3] MONEY,
			[CC_ValorFijoM3Adicional] MONEY,
			[CC_ValorPorcentual] FLOAT
		);
		/* Get "conceptos de cobro" from xml dataset */
		INSERT INTO @TMPConceptoCobro (
			[CC_IDPeriodoCC],
			[CC_IDTipoMontoCC],
			[CC_Nombre],
			[CC_ValorFijo],
			[CC_ValorMinimo],
			[CC_ValorM2Minimo],
			[CC_ValorTractosM2],
			[CC_ValorMinimoM3],
			[CC_ValorFijoM3Adicional],
			[CC_ValorPorcentual]
		) SELECT
			[PeriodoMontoCC],
			[TipoMontoCC],
			[Nombre],
			[ValorFijo],
			[ValorMinimo],
			[ValorM2Minimo],
			[ValorTractosM2],
			[ValorMinimoM3],
			[ValorFijoM3Adicional],
			[ValorPorcentual]
		FROM OPENXML (
			@hdoc, 'Catalogo/CCs/CC'
		) WITH (
			[PeriodoMontoCC] INT,
			[TipoMontoCC] INT,
			[Nombre] VARCHAR(128),
			[ValorFijo] MONEY,
			[ValorMinimo] MONEY,
			[ValorM2Minimo] MONEY,
			[ValorTractosM2] MONEY,
			[ValorMinimoM3] MONEY,
			[ValorFijoM3Adicional] MONEY,
			[ValorPorcentual] FLOAT
		) AS [NewCC];


		EXECUTE SP_XML_REMOVEDOCUMENT @hdoc; -- release the memory used from xml doc

		--BEGIN TRANSACTION [InsertData]

		--	INSERT INTO [dbo].[TipoMovimientoConsumoAgua] (
		--		[Nombre]
		--	) SELECT
		--		[NewTMCA].[TMCA_Nombre]
		--	FROM @TMPTipoMovimientoConsumoAgua AS [NewTMCA];

		--	INSERT INTO [dbo].[TipoUsoPropiedad] (
		--		[Nombre]
		--	) SELECT
		--		[NewTUP].[TUP_Nombre]
		--	FROM @TMPTipoUsoPropiedad AS [NewTUP];

		--	INSERT INTO [dbo].[TipoZonaPropiedad] (
		--		[Nombre]
		--	) SELECT
		--		[NewTZP].[TZP_Nombre]
		--	FROM @TMPTipoZonaPropiedad AS [NewTZP];

		--	INSERT INTO [dbo].[TipoDocIdentidad] (
		--		[Nombre]
		--	) SELECT
		--		[NewTDI].[TDI_Nombre]
		--	FROM @TMPTipoDocIdentidad AS [NewTDI];

		--	INSERT INTO [dbo].[MedioDePago] (
		--		[Nombre]
		--	) SELECT
		--		[NewMP].[MP_Nombre]
		--	FROM @TMPMedioDePago AS [NewMP];

		--	INSERT INTO [dbo].[PeriodoMontoCC] (
		--		[Nombre]
		--	) SELECT
		--		[NewPMCC].[PMCC_Nombre]
		--	FROM @TMPPeridoMontoCC AS [NewPMCC];

		--	INSERT INTO [dbo].[TipoMontoCC] (
		--		[Nombre]
		--	) SELECT
		--		[NewTMCC].[TMCC_Nombre]
		--	FROM @TMPTipoMontoCC AS [NewTMCC];

		--	INSERT INTO [dbo].[TipoParametro] (
		--		[Nombre]
		--	) SELECT
		--		[NewTP].[TP_Nombre]
		--	FROM @TMPTipoParametro AS [NewTP];

		--	WHILE (@paramLow < @paramHigh)
		--		BEGIN
		--			INSERT INTO dbo.Parametro (
		--				[ID],
		--				[IDTipoParametro],
		--				[Descripcion]
		--			) SELECT
		--				[TMPP].[P_ID],
		--				[TP].[ID],
		--				[TMPP].[P_Descripcion]
		--			FROM @TMPParametro AS [TMPP]
		--				INNER JOIN [dbo].[TipoParametro] AS [TP] 
		--				ON [TP].[Nombre] = [TMPP].[P_NombreTipoParametro]
		--			WHERE [TMPP].[P_ID] = @paramLow;

		--			INSERT INTO dbo.ParametroInteger (
		--				[IDParametro],
		--				[Valor]
		--			) SELECT
		--				[TMPP].[P_ID],
		--				(SELECT CONVERT(INT, [TMPP].[P_Valor]))
		--			FROM @TMPParametro AS [TMPP] 
		--			WHERE [TMPP].[P_ID] = @paramLow AND [TMPP].[P_NombreTipoParametro] = 'int';					
					
		--			SET @paramLow = @paramLow + 1;
		--		END;


		--	SET @outResultCode = 5200; /* OK */

		--COMMIT TRANSACTION [InsertData]
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
GO