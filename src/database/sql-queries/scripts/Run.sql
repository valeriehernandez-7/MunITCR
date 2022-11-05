USE [MunITCR]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

BEGIN TRY
	DECLARE
		@inRDSFilePath NVARCHAR(2048), -- ruta de archivo de Operaciones.xml
		@outResultCode INT, -- codigo resultante de la ejecucion de procedimientos almacenados
		@minTMPID INT, -- PK del registro en iteracion
		@maxTMPID INT, -- PK del ultimo registro por iterar
		@minIDOperacion INT, -- PK de la operacion en iteracion de @TMPOperacion
		@maxIDOperacion INT, -- PK de la ultima operacion por iterar en @TMPOperacion
		@minMesOperacion INT, -- mes de operaciones en iteracion de @TMPOperacion
		@maxMesOperacion INT, -- ultimo mes de operaciones por iterar en @TMPOperacion
		@fechaOperacion DATE, -- fecha actual en el procesamiento de operaciones
		@fechaFinMes DATE; -- fecha de fin de mes en iteracion

	SET @outResultCode = 0; /* OK */

	IF (@inRDSFilePath IS NULL)
		BEGIN
			SET @inRDSFilePath = 'D:\S3\Operaciones.xml'; /* @inRDSFilePath default value */
		END;

	DECLARE
		@docOperaciones INT,
		@data XML,
		@outData XML, --  out parameter 
		@command NVARCHAR(500) = 'SELECT @data = D FROM OPENROWSET (BULK '  + CHAR(39) + @inRDSFilePath + CHAR(39) + ', SINGLE_BLOB) AS Data (D)',
		@parameters NVARCHAR(500) = N'@data [XML] OUTPUT';

	EXECUTE SP_EXECUTESQL @command, @parameters, @data = @outData OUTPUT; -- execute the dinamic SQL command
	SET @data = @outData; -- assign the dinamic SQL out parameter
	EXECUTE SP_XML_PREPAREDOCUMENT @docOperaciones OUTPUT, @data; -- associate the identifier and XML doc

	/* Tabla con fechas de operacion del archivo Operaciones.xml */
	DECLARE @TMPOperacion TABLE (
		[ID] INT IDENTITY(1,1) PRIMARY KEY,
		[Mes] INT,
		[Fecha] DATE
	);

	/* Tabla con informacion de personas del archivo Operaciones.xml */
	DECLARE @TMPPersona TABLE (
		[ID] INT IDENTITY(1,1) PRIMARY KEY,
		[TipoDocIdentidad] VARCHAR(128),
		[Nombre] VARCHAR(128),
		[ValorDocIdentidad] VARCHAR(64),
		[Telefono1] VARCHAR(16),
		[Telefono2] VARCHAR(16),
		[CorreoElectronico] VARCHAR(256)
	);

	/* Tabla con informacion de propiedades del archivo Operaciones.xml */
	DECLARE @TMPPropiedad TABLE (
		[ID] INT IDENTITY(1,1) PRIMARY KEY,
		[TipoUsoPropiedad] VARCHAR(128),
		[TipoZonaPropiedad] VARCHAR(128),
		[Lote] VARCHAR(32),
		[Medidor] VARCHAR(16),
		[MetrosCuadrados] BIGINT,
		[ValorFiscal] MONEY
	);

	/* Tabla con informacion cambio de valor fiscal 
	de propiedades del archivo Operaciones.xml */
	DECLARE @TMPActualizacionPropiedad TABLE (
		[ID] INT IDENTITY(1,1) PRIMARY KEY,
		[Lote] VARCHAR(32),
		[ValorFiscal] MONEY
	);

	/* Tabla con informacion de usuarios y su relacion con 
	persona del archivo Operaciones.xml */
	DECLARE @TMPUsuario TABLE (
		[ID] INT IDENTITY(1,1) PRIMARY KEY,
		[TipoOperacion] VARCHAR(8),
		[PersonaValorDocIdentidad] VARCHAR(64),
		[Username] VARCHAR(16),
		[Password] VARCHAR(16),
		[TipoUsuario] VARCHAR(16)
	);

	/* Tabla con asociaciones o desasociaciones de personas 
	con propiedades del archivo Operaciones.xml */
	DECLARE @TMPPersonaXPropiedad TABLE (
		[ID] INT IDENTITY(1,1) PRIMARY KEY,
		[TipoOperacion] VARCHAR(8),
		[PersonaValorDocIdentidad] VARCHAR(64),
		[PropiedadLote] VARCHAR(32)
	);

	/* Tabla con asociaciones o desasociaciones de usuarios 
	con propiedades del archivo Operaciones.xml */
	DECLARE @TMPUsuarioXPropiedad TABLE (
		[ID] INT IDENTITY(1,1) PRIMARY KEY,
		[TipoOperacion] VARCHAR(8),
		[PersonaValorDocIdentidad] VARCHAR(64),
		[PropiedadLote] VARCHAR(32)
	);

	/* Tabla con informacion de lecturas de medidor 
	de agua por propiedad del archivo Operaciones.xml */
	DECLARE @TMPMovimientoConsumoAgua TABLE (
		[ID] INT IDENTITY(1,1) PRIMARY KEY,
		[TipoMovimientoConsumoAgua] VARCHAR(128),
		[Medidor] VARCHAR(16),
		[LecturaMedidor] INT
	);

	/* Tabla con informacion de pago de facturas 
	por propiedad del archivo Operaciones.xml */
	DECLARE @TMPComprobantePago TABLE (
		[ID] INT IDENTITY(1,1) PRIMARY KEY,
		[PropiedadLote] VARCHAR(32),
		[MedioPago] VARCHAR(128),
		[Referencia] BIGINT
	);

	/* Agrega las fechas de todas las operaciones 
	del archivo Operaciones.xml */
	INSERT INTO @TMPOperacion (
		[Mes],
		[Fecha]
	) SELECT 
		DATEPART(MONTH, DOC.Fecha.value ('@Fecha', 'DATE')),
		DOC.Fecha.value ('@Fecha', 'DATE')
	FROM @data.nodes('Datos/Operacion') AS DOC(Fecha);

	SELECT * FROM @TMPOperacion; -- TO-DO: DELETE

	/* Obtiene el Mes minimo y maximo de la tabla de operaciones 
	como limites de iteracion para la ejecucion de la 
	simulacion de operaciones */
	SELECT 
		@minMesOperacion = MIN([O].[Mes]),
		@maxMesOperacion = MAX([O].[Mes])
	FROM @TMPOperacion AS [O];

	SELECT  -- TO-DO: DELETE
		@minMesOperacion AS [minMesOperacion],
		@maxMesOperacion AS [maxMesOperacion];


	/* Simluacion de procesamiento de operaciones de sistema municipal */
	WHILE (@minMesOperacion <= @maxMesOperacion)
		BEGIN
			/* Obtener las fechas del mes de operacion */
			SELECT 
				@minIDOperacion = MIN([O].[ID]),
				@maxIDOperacion = MAX([O].[ID]),
				@fechaFinMes = MAX([O].[Fecha])
			FROM @TMPOperacion AS [O]
			WHERE [O].[Mes] = @minMesOperacion;

			SELECT  -- TO-DO: DELETE
				@minIDOperacion AS [minOperacion],
				@maxIDOperacion AS [maxOperacion],
				@fechaFinMes AS [fechaFinMes];
			/* Procesar las fechas del mes de operacion */
			WHILE (@minIDOperacion <= @maxIDOperacion)
				BEGIN
					/*Asignar la fecha de operacion actual como la fecha con PK @minIDOperacion */
					SELECT @fechaOperacion = [O].[Fecha]
					FROM @TMPOperacion AS [O]
					WHERE [O].[ID] = @minIDOperacion;


					/* <Personas/Persona> : Procesar personas */
					IF @data.exist('/Datos/Operacion[@Fecha = sql:variable("@fechaOperacion")]/Personas/Persona') = 1
						BEGIN
							INSERT INTO @TMPPersona (
								[TipoDocIdentidad],
								[Nombre],
								[ValorDocIdentidad],
								[Telefono1],
								[Telefono2],
								[CorreoElectronico]
							) SELECT
								OP.Persona.value('@TipoDocumentoIdentidad', 'VARCHAR(128)'),
								OP.Persona.value('@Nombre', 'VARCHAR(128)'),
								OP.Persona.value('@ValorDocumentoIdentidad', 'VARCHAR(64)'),
								OP.Persona.value('@Telefono1', 'VARCHAR(16)'),
								OP.Persona.value('@Telefono2', 'VARCHAR(16)'),
								OP.Persona.value('@Email', 'VARCHAR(256)')
							FROM @data.nodes('/Datos/Operacion[@Fecha = sql:variable("@fechaOperacion")]/Personas/Persona') AS OP(Persona);

							IF EXISTS (SELECT 1 FROM @TMPPersona)
								BEGIN
									/* Obtener las PK de @TMPPersona para ejecutar el 
									SP_CreatePersona de forma iterativa */
									SELECT 
										@minTMPID = MIN([TMP].[ID]),
										@maxTMPID = MAX([TMP].[ID])
									FROM @TMPPersona AS [TMP];

									DECLARE 
										@P_TipoDocIdentidad VARCHAR(128),
										@P_Nombre VARCHAR(128),
										@P_ValorDocIdentidad VARCHAR(64),
										@P_Telefono1 VARCHAR(16),
										@P_Telefono2 VARCHAR(16),
										@P_CorreoElectronico VARCHAR(256);

									WHILE (@minTMPID <= @maxTMPID)
										BEGIN
											IF EXISTS (SELECT 1 FROM @TMPPersona AS [TMP] WHERE [TMP].[ID] = @minTMPID)
												BEGIN
													SELECT
														@P_TipoDocIdentidad = [TMP].[TipoDocIdentidad],
														@P_Nombre = [TMP].[Nombre],
														@P_ValorDocIdentidad = [TMP].[ValorDocIdentidad],
														@P_Telefono1 = [TMP].[Telefono1],
														@P_Telefono2 = [TMP].[Telefono2],
														@P_CorreoElectronico = [TMP].[CorreoElectronico]
													FROM @TMPPersona AS [TMP]
													WHERE [TMP].[ID] = @minTMPID
													AND [TMP].[TipoDocIdentidad] IS NOT NULL
													AND [TMP].[Nombre] IS NOT NULL
													AND [TMP].[ValorDocIdentidad] IS NOT NULL
													AND [TMP].[Telefono1] IS NOT NULL
													AND [TMP].[Telefono2] IS NOT NULL
													AND [TMP].[CorreoElectronico] IS NOT NULL;

													EXECUTE [SP_CreatePersona] @P_Nombre, @P_TipoDocIdentidad, @P_ValorDocIdentidad, @P_Telefono1, @P_Telefono2, @P_CorreoElectronico, NULL, NULL, @outResultCode OUTPUT;
												END;
											SET @minTMPID = @minTMPID + 1;
										END;
									/* Liberacion de memoria para la siguiente iteracion */
									SET @minTMPID = NULL;
									SET	@maxTMPID = NULL;
									DELETE FROM @TMPPersona;
								END;
						END;


					/* <Propiedades/Propiedad> : Procesar propiedades */
					IF @data.exist('/Datos/Operacion[@Fecha = sql:variable("@fechaOperacion")]/Propiedades/Propiedad') = 1
						BEGIN
							INSERT INTO @TMPPropiedad (
								[TipoUsoPropiedad],
								[TipoZonaPropiedad],
								[Lote],
								[Medidor],
								[MetrosCuadrados],
								[ValorFiscal]
							) SELECT
								OP.Propiedad.value('@tipoUsoPropiedad', 'VARCHAR(128)'),
								OP.Propiedad.value('@tipoZonaPropiedad', 'VARCHAR(128)'),
								OP.Propiedad.value('@NumeroFinca', 'VARCHAR(32)'),
								OP.Propiedad.value('@NumeroMedidor', 'VARCHAR(16)'),
								OP.Propiedad.value('@MetrosCuadrados', 'BIGINT'),
								OP.Propiedad.value('@ValorFiscal', 'MONEY')
							FROM @data.nodes('/Datos/Operacion[@Fecha = sql:variable("@fechaOperacion")]/Propiedades/Propiedad') AS OP(Propiedad);

							IF EXISTS (SELECT 1 FROM @TMPPropiedad)
								BEGIN
									/* Obtener las PK de @TMPPropiedad para ejecutar el 
									SP_CreatePropiedad de forma iterativa */
									SELECT 
										@minTMPID = MIN([TMP].[ID]),
										@maxTMPID = MAX([TMP].[ID])
									FROM @TMPPropiedad AS [TMP];

									DECLARE 
										@P_TipoUsoPropiedad VARCHAR(128),
										@P_TipoZonaPropiedad VARCHAR(128),
										@P_Lote VARCHAR(32),
										@P_Medidor VARCHAR(16),
										@P_MetrosCuadrados BIGINT,
										@P_ValorFiscal MONEY;

									WHILE (@minTMPID <= @maxTMPID)
										BEGIN
											IF EXISTS (SELECT 1 FROM @TMPPropiedad AS [TMP] WHERE [TMP].[ID] = @minTMPID)
												BEGIN
													SELECT
														@P_TipoUsoPropiedad = [TMP].[TipoUsoPropiedad],
														@P_TipoZonaPropiedad = [TMP].[TipoZonaPropiedad],
														@P_Lote = [TMP].[Lote],
														@P_Medidor = [TMP].[Medidor],
														@P_MetrosCuadrados = [TMP].[MetrosCuadrados],
														@P_ValorFiscal = [TMP].[ValorFiscal]
													FROM @TMPPropiedad AS [TMP]
													WHERE [TMP].[ID] = @minTMPID
													AND [TMP].[TipoUsoPropiedad] IS NOT NULL
													AND [TMP].[TipoZonaPropiedad] IS NOT NULL
													AND [TMP].[Lote] IS NOT NULL
													AND [TMP].[Medidor] IS NOT NULL
													AND [TMP].[MetrosCuadrados] IS NOT NULL
													AND [TMP].[ValorFiscal] IS NOT NULL;

													EXECUTE [SP_CreatePropiedad] @P_TipoUsoPropiedad, @P_TipoZonaPropiedad, @P_Lote, @P_Medidor, @P_MetrosCuadrados, @P_ValorFiscal, @fechaOperacion, @outResultCode OUTPUT;
												END;
											SET @minTMPID = @minTMPID + 1;
										END;
									/* Liberacion de memoria para la siguiente iteracion */
									SET @minTMPID = NULL;
									SET	@maxTMPID = NULL;
									DELETE FROM @TMPPropiedad;
								END;
						END;


					/* <PropiedadCambio/PropiedadCambios> : 
					Procesar cambios de valor fiscal de propiedad */
					IF @data.exist('/Datos/Operacion[@Fecha = sql:variable("@fechaOperacion")]/PropiedadCambio/PropiedadCambios') = 1
						BEGIN
							INSERT INTO @TMPActualizacionPropiedad (
								[Lote],
								[ValorFiscal]
							) SELECT
								OP.ActualizacionPropiedad.value('@NumFinca', 'VARCHAR(32)'),
								OP.ActualizacionPropiedad.value('@Valor', 'MONEY')
							FROM @data.nodes('/Datos/Operacion[@Fecha = sql:variable("@fechaOperacion")]/PropiedadCambio/PropiedadCambios') AS OP(ActualizacionPropiedad);

							IF EXISTS (SELECT 1 FROM @TMPActualizacionPropiedad)
								BEGIN
									/* Obtener las PK de @TMPActualizacionPropiedad para ejecutar el 
									SP_UpdatePropiedadValorFiscal de forma iterativa */
									SELECT 
										@minTMPID = MIN([TMP].[ID]),
										@maxTMPID = MAX([TMP].[ID])
									FROM @TMPActualizacionPropiedad AS [TMP];

									DECLARE 
										@PV_Lote VARCHAR(32),
										@PV_ValorFiscal MONEY;

									WHILE (@minTMPID <= @maxTMPID)
										BEGIN
											IF EXISTS (SELECT 1 FROM @TMPActualizacionPropiedad AS [TMP] WHERE [TMP].[ID] = @minTMPID)
												BEGIN
													SELECT
														@PV_Lote = [TMP].[Lote],
														@PV_ValorFiscal = [TMP].[ValorFiscal]
													FROM @TMPActualizacionPropiedad AS [TMP]
													WHERE [TMP].[ID] = @minTMPID
													AND [TMP].[Lote] IS NOT NULL
													AND [TMP].[ValorFiscal] IS NOT NULL;

													EXECUTE [SP_UpdatePropiedadValorFiscal] @PV_Lote, @PV_ValorFiscal, NULL, NULL, @outResultCode OUTPUT;
												END;
											SET @minTMPID = @minTMPID + 1;
										END;
									/* Liberacion de memoria para la siguiente iteracion */
									SET @minTMPID = NULL;
									SET	@maxTMPID = NULL;
									DELETE FROM @TMPActualizacionPropiedad;
								END;
						END;


					/* <Usuario/Usuario> : 
					Procesar asociacion o des asociacion entre usuarios y personas */
					IF @data.exist('/Datos/Operacion[@Fecha = sql:variable("@fechaOperacion")]/Usuario/Usuario') = 1
						BEGIN
							INSERT INTO @TMPUsuario (
								[TipoOperacion],
								[PersonaValorDocIdentidad],
								[Username],
								[Password],
								[TipoUsuario]
							) SELECT
								OP.Usuario.value('@TipoAsociacion', 'VARCHAR(8)'),
								OP.Usuario.value('@ValorDocumentoIdentidad', 'VARCHAR(64)'),
								OP.Usuario.value('@Username', 'VARCHAR(16)'),
								OP.Usuario.value('@Password', 'VARCHAR(16)'),
								OP.Usuario.value('@TipoUsuario', 'VARCHAR(16)')
							FROM @data.nodes('/Datos/Operacion[@Fecha = sql:variable("@fechaOperacion")]/Usuario/Usuario') AS OP(Usuario);

							IF EXISTS (SELECT 1 FROM @TMPUsuario)
								BEGIN
									/* Obtener las PK de @TMPUsuario para ejecutar el 
									SP_CreateUsuario o SP_UpdateUsuarioDesasociacion de forma iterativa */
									SELECT 
										@minTMPID = MIN([TMP].[ID]),
										@maxTMPID = MAX([TMP].[ID])
									FROM @TMPUsuario AS [TMP];

									DECLARE 
										@U_TipoOperacion VARCHAR(8),
										@U_PersonaValorDocIdentidad VARCHAR(64),
										@U_Username VARCHAR(16),
										@U_Password VARCHAR(16),
										@U_TipoUsuario VARCHAR(16);

									WHILE (@minTMPID <= @maxTMPID)
										BEGIN
											IF EXISTS (SELECT 1 FROM @TMPUsuario AS [TMP] WHERE [TMP].[ID] = @minTMPID)
												BEGIN
													SELECT
														@U_TipoOperacion = [TMP].[TipoOperacion],
														@U_PersonaValorDocIdentidad = [TMP].[PersonaValorDocIdentidad],
														@U_Username = [TMP].[Username],
														@U_Password = [TMP].[Password],
														@U_TipoUsuario = [TMP].[TipoUsuario]
													FROM @TMPUsuario AS [TMP]
													WHERE [TMP].[ID] = @minTMPID
													AND [TMP].[TipoOperacion] IS NOT NULL
													AND [TMP].[PersonaValorDocIdentidad] IS NOT NULL
													AND [TMP].[Username] IS NOT NULL
													AND [TMP].[Password] IS NOT NULL
													AND [TMP].[TipoUsuario] IS NOT NULL;

													/* Asociacion de nuevo Usuario con Persona */
													IF (@U_TipoOperacion = 'Agregar')
														BEGIN
															EXECUTE [SP_CreateUsuario] @U_PersonaValorDocIdentidad, @U_Username, @U_Password, @U_TipoUsuario, NULL, NULL, @outResultCode OUTPUT;
														END;
													/* Desasociacion de Usuario con Persona */
													ELSE IF (@U_TipoOperacion = 'Eliminar')
														BEGIN
															EXECUTE [SP_UpdateUsuarioDesasociacion] @U_PersonaValorDocIdentidad, @U_Username, NULL, NULL, @outResultCode OUTPUT;
														END;
												END;
											SET @minTMPID = @minTMPID + 1;
										END;
									/* Liberacion de memoria para la siguiente iteracion */
									SET @minTMPID = NULL;
									SET	@maxTMPID = NULL;
									DELETE FROM @TMPUsuario;
								END;
						END;


					/* <PersonasyPropiedades/PropiedadPersona> : 
					Procesar asociacion o des asociacion entre personas y propiedades */
					IF @data.exist('/Datos/Operacion[@Fecha = sql:variable("@fechaOperacion")]/PersonasyPropiedades/PropiedadPersona') = 1
						BEGIN
							INSERT INTO @TMPPersonaXPropiedad (
								[TipoOperacion],
								[PersonaValorDocIdentidad],
								[PropiedadLote]
							) SELECT
								OP.PersonaPropiedad.value('@TipoAsociacion', 'VARCHAR(8)'),
								OP.PersonaPropiedad.value('@ValorDocumentoIdentidad', 'VARCHAR(64)'),
								OP.PersonaPropiedad.value('@NumeroFinca', 'VARCHAR(32)')
							FROM @data.nodes('/Datos/Operacion[@Fecha = sql:variable("@fechaOperacion")]/PersonasyPropiedades/PropiedadPersona') AS OP(PersonaPropiedad);

							IF EXISTS (SELECT 1 FROM @TMPPersonaXPropiedad)
								BEGIN
									/* Obtener las PK de @TMPPersonaXPropiedad para ejecutar el 
									SP_CreatePersonaXPropiedad o SP_UpdatePersonaXPropiedadDesasociacion de forma iterativa */
									SELECT 
										@minTMPID = MIN([TMP].[ID]),
										@maxTMPID = MAX([TMP].[ID])
									FROM @TMPPersonaXPropiedad AS [TMP];

									DECLARE 
										@PP_TipoOperacion VARCHAR(8),
										@PP_PersonaValorDocIdentidad VARCHAR(64),
										@PP_PropiedadLote VARCHAR(32);

									WHILE (@minTMPID <= @maxTMPID)
										BEGIN
											IF EXISTS (SELECT 1 FROM @TMPPersonaXPropiedad AS [TMP] WHERE [TMP].[ID] = @minTMPID)
												BEGIN
													SELECT
														@PP_TipoOperacion = [TMP].[TipoOperacion],
														@PP_PersonaValorDocIdentidad = [TMP].[PersonaValorDocIdentidad],
														@PP_PropiedadLote = [TMP].[PropiedadLote]
													FROM @TMPPersonaXPropiedad AS [TMP]
													WHERE [TMP].[ID] = @minTMPID
													AND [TMP].[TipoOperacion] IS NOT NULL
													AND [TMP].[PersonaValorDocIdentidad] IS NOT NULL
													AND [TMP].[PropiedadLote] IS NOT NULL;

													/* Asociacion de Persona con Propiedad */
													IF (@PP_TipoOperacion = 'Agregar')
														BEGIN
															EXECUTE [SP_CreatePersonaXPropiedad] @PP_PersonaValorDocIdentidad, @PP_PropiedadLote, @fechaOperacion, NULL, NULL, @outResultCode OUTPUT;
														END;
													/* Desasociacion de Persona con Propiedad */
													ELSE IF (@PP_TipoOperacion = 'Eliminar')
														BEGIN
															EXECUTE [SP_UpdatePersonaXPropiedadDesasociacion] @PP_PersonaValorDocIdentidad, @PP_PropiedadLote, @fechaOperacion, NULL, NULL, @outResultCode OUTPUT;
														END;
												END;
											SET @minTMPID = @minTMPID + 1;
										END;
									/* Liberacion de memoria para la siguiente iteracion */
									SET @minTMPID = NULL;
									SET	@maxTMPID = NULL;
									DELETE FROM @TMPPersonaXPropiedad;
								END;
						END;


					/* <PropiedadesyUsuarios/UsuarioPropiedad> : 
					Procesar asociacion o des asociacion entre usuarios y propiedades */
					IF @data.exist('/Datos/Operacion[@Fecha = sql:variable("@fechaOperacion")]/PropiedadesyUsuarios/UsuarioPropiedad') = 1
						BEGIN
							INSERT INTO @TMPUsuarioXPropiedad (
								[TipoOperacion],
								[PersonaValorDocIdentidad],
								[PropiedadLote]
							) SELECT
								OP.UsuarioPropiedad.value('@TipoAsociacion', 'VARCHAR(8)'),
								OP.UsuarioPropiedad.value('@ValorDocumentoIdentidad', 'VARCHAR(64)'),
								OP.UsuarioPropiedad.value('@NumeroFinca', 'VARCHAR(32)')
							FROM @data.nodes('/Datos/Operacion[@Fecha = sql:variable("@fechaOperacion")]/PropiedadesyUsuarios/UsuarioPropiedad') AS OP(UsuarioPropiedad);

							IF EXISTS (SELECT 1 FROM @TMPUsuarioXPropiedad)
								BEGIN
									/* Obtener las PK de @TMPUsuarioXPropiedad para ejecutar el 
									SP_CreateUsuarioXPropiedadPersonaIn o SP_UpdateUsuarioXPropiedadDesasociacionPersonaIn de forma iterativa */
									SELECT 
										@minTMPID = MIN([TMP].[ID]),
										@maxTMPID = MAX([TMP].[ID])
									FROM @TMPUsuarioXPropiedad AS [TMP];

									DECLARE 
										@UP_TipoOperacion VARCHAR(8),
										@UP_PersonaValorDocIdentidad VARCHAR(64),
										@UP_PropiedadLote VARCHAR(32);

									WHILE (@minTMPID <= @maxTMPID)
										BEGIN
											IF EXISTS (SELECT 1 FROM @TMPUsuarioXPropiedad AS [TMP] WHERE [TMP].[ID] = @minTMPID)
												BEGIN
													SELECT
														@UP_TipoOperacion = [TMP].[TipoOperacion],
														@UP_PersonaValorDocIdentidad = [TMP].[PersonaValorDocIdentidad],
														@UP_PropiedadLote = [TMP].[PropiedadLote]
													FROM @TMPUsuarioXPropiedad AS [TMP]
													WHERE [TMP].[ID] = @minTMPID
													AND [TMP].[TipoOperacion] IS NOT NULL
													AND [TMP].[PersonaValorDocIdentidad] IS NOT NULL
													AND [TMP].[PropiedadLote] IS NOT NULL;

													/* Asociacion de Usuario con Propiedad */
													IF (@UP_TipoOperacion = 'Agregar')
														BEGIN
															EXECUTE [SP_CreateUsuarioXPropiedadPersonaIn] @UP_PersonaValorDocIdentidad, @UP_PropiedadLote, @fechaOperacion, NULL, NULL, @outResultCode OUTPUT;
														END;
													/* Desasociacion de Usuario con Propiedad */
													ELSE IF (@UP_TipoOperacion = 'Eliminar')
														BEGIN
															EXECUTE [SP_UpdateUsuarioXPropiedadDesasociacionPersonaIn] @UP_PersonaValorDocIdentidad, @UP_PropiedadLote, @fechaOperacion, NULL, NULL, @outResultCode OUTPUT;
														END;
												END;
											SET @minTMPID = @minTMPID + 1;
										END;
									/* Liberacion de memoria para la siguiente iteracion */
									SET @minTMPID = NULL;
									SET	@maxTMPID = NULL;
									DELETE FROM @TMPUsuarioXPropiedad;
								END;
						END;


					/* <Lecturas/LecturaMedidor> : 
					Procesar lecturas de medidor de propiedad */
					IF @data.exist('/Datos/Operacion[@Fecha = sql:variable("@fechaOperacion")]/Lecturas/LecturaMedidor') = 1
						BEGIN
							INSERT INTO @TMPMovimientoConsumoAgua (
								[TipoMovimientoConsumoAgua],
								[Medidor],
								[LecturaMedidor]
							) SELECT
								OP.ConsumoAgua.value('@TipoMovimiento', 'VARCHAR(128)'),
								OP.ConsumoAgua.value('@NumeroMedidor', 'VARCHAR(16)'),
								OP.ConsumoAgua.value('@Valor', 'INT')
							FROM @data.nodes('/Datos/Operacion[@Fecha = sql:variable("@fechaOperacion")]/Lecturas/LecturaMedidor') AS OP(ConsumoAgua);

							IF EXISTS (SELECT 1 FROM @TMPMovimientoConsumoAgua)
								BEGIN
									/* Obtener las PK de @TMPMovimientoConsumoAgua para ejecutar el 
									SP_CreateMovimientoConsumoAguaMedidorIn de forma iterativa */
									SELECT 
										@minTMPID = MIN([TMP].[ID]),
										@maxTMPID = MAX([TMP].[ID])
									FROM @TMPMovimientoConsumoAgua AS [TMP];

									DECLARE 
										@CA_TipoMovimientoConsumoAgua VARCHAR(128),
										@CA_Medidor VARCHAR(16),
										@CA_LecturaMedidor INT;

									WHILE (@minTMPID <= @maxTMPID)
										BEGIN
											IF EXISTS (SELECT 1 FROM @TMPMovimientoConsumoAgua AS [TMP] WHERE [TMP].[ID] = @minTMPID)
												BEGIN
													SELECT
														@CA_TipoMovimientoConsumoAgua = [TMP].[TipoMovimientoConsumoAgua],
														@CA_Medidor = [TMP].[Medidor],
														@CA_LecturaMedidor = [TMP].[LecturaMedidor]
													FROM @TMPMovimientoConsumoAgua AS [TMP]
													WHERE [TMP].[ID] = @minTMPID
													AND [TMP].[TipoMovimientoConsumoAgua] IS NOT NULL
													AND [TMP].[Medidor] IS NOT NULL
													AND [TMP].[LecturaMedidor] IS NOT NULL;

													EXECUTE [SP_CreateMovimientoConsumoAguaMedidorIn] @CA_Medidor, @CA_TipoMovimientoConsumoAgua, @CA_LecturaMedidor, @fechaOperacion, @outResultCode OUTPUT;
												END;
											SET @minTMPID = @minTMPID + 1;
										END;
									/* Liberacion de memoria para la siguiente iteracion */
									SET @minTMPID = NULL;
									SET	@maxTMPID = NULL;
									DELETE FROM @TMPMovimientoConsumoAgua;
								END;
						END;


					/* <Pago/Pago> : Procesar pagos factura mas vieja por propiedad */
					IF @data.exist('/Datos/Operacion[@Fecha = sql:variable("@fechaOperacion")]/Pago/Pago') = 1
						BEGIN
							INSERT INTO @TMPComprobantePago (
								[PropiedadLote],
								[MedioPago],
								[Referencia] 
							) SELECT
								OP.Pago.value('@NumFinca', 'VARCHAR(32)'),
								OP.Pago.value('@TipoPago', 'VARCHAR(128)'),
								OP.Pago.value('@NumeroReferenciaComprobantePago', 'BIGINT')
							FROM @data.nodes('/Datos/Operacion[@Fecha = sql:variable("@fechaOperacion")]/Pago/Pago') AS OP(Pago);

							IF EXISTS (SELECT 1 FROM @TMPComprobantePago)
								BEGIN
									/* Obtener las PK de @TMPComprobantePago para ejecutar el 
									SP_Pago o SP_PagoArregloPago de forma iterativa */
									SELECT 
										@minTMPID = MIN([TMP].[ID]),
										@maxTMPID = MAX([TMP].[ID])
									FROM @TMPComprobantePago AS [TMP];

									DECLARE 
										@CP_PropiedadLote VARCHAR(32),
										@CP_MedioPago VARCHAR(128),
										@CP_Referencia BIGINT;

									WHILE (@minTMPID <= @maxTMPID)
										BEGIN
											IF EXISTS (SELECT 1 FROM @TMPComprobantePago AS [TMP] WHERE [TMP].[ID] = @minTMPID)
												BEGIN
													SELECT
														@CP_PropiedadLote = [TMP].[PropiedadLote],
														@CP_MedioPago = [TMP].[MedioPago],
														@CP_Referencia = [TMP].[Referencia]
													FROM @TMPComprobantePago AS [TMP]
													WHERE [TMP].[ID] = @minTMPID
													AND [TMP].[PropiedadLote] IS NOT NULL
													AND [TMP].[MedioPago] IS NOT NULL
													AND [TMP].[Referencia] IS NOT NULL;

													/* <Pago/Pago> : Procesar pagos factura mas vieja por propiedad con medio de pago <> 'Arreglo de pago' */
													IF (@CP_MedioPago <> 'Arreglo de pago')
														BEGIN
															EXECUTE [SP_Pago] @CP_PropiedadLote, 1, @CP_Referencia, @CP_MedioPago, @fechaOperacion, @outResultCode OUTPUT;
														END;
													/* <Pago/Pago> : Procesar pagos factura mas vieja por propiedad con medio de pago 'Arreglo de pago' */
													--ELSE IF (@CP_MedioPago = 'Arreglo de pago')
													--	BEGIN
													--		EXECUTE [SP_PagoArregloPago] @CP_PropiedadLote, 1, @CP_Referencia, @fechaOperacion, @outResultCode OUTPUT;
													--	END;
												END;
											SET @minTMPID = @minTMPID + 1;
										END;
									/* Liberacion de memoria para la siguiente iteracion */
									SET @minTMPID = NULL;
									SET	@maxTMPID = NULL;
									DELETE FROM @TMPComprobantePago;
								END;
						END;


					/* Procesar ordenes de reconexion de consumo de agua */

					/* Generar ordenes de corte de consumo de agua */

					/* Generar facturas del mes, a la propiedad cuyo dia respecto 
					de fecha de creacion coincide con el dia de la fecha de operacion */

					/* Procesar detalle de cobro por intereses moratorios en facturas vencidas */

					/* Cancelar arreglos de pago */

					/* Avanzar a la siguiente fecha de operacion */
					SET @minIDOperacion = @minIDOperacion + 1;
				END;
			/* Avanzar al siguiente mes de operaciones */
			SET @minMesOperacion = @minMesOperacion + 1;
		END;

	DELETE FROM @TMPOperacion;

	EXECUTE SP_XML_REMOVEDOCUMENT @docOperaciones; -- release the memory used from xml doc

END TRY
BEGIN CATCH
	IF OBJECT_ID(N'dbo.ErrorLog', N'U') IS NOT NULL /* Verificar la existencia de la tabla dbo.ErrorLog*/
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
			SET @outResultCode = 5504; /* Revisar los registros del ErrorLog */
		END;
	ELSE 
		BEGIN
			SET @outResultCode = 5404; /* ERROR : dbo.ErrorLog no existe */
			RETURN;
		END;
END CATCH;

/* Mostrar todos los registros de las tablas de la base de datos MunITCR */
DECLARE @sqlText VARCHAR(MAX) = '';
SELECT @sqlText = @sqlText + ' SELECT * FROM ' + QUOTENAME(NAME) + CHAR(13) 
FROM SYS.TABLES
WHERE NAME <> 'sysdiagrams'
ORDER BY NAME;
EXECUTE(@sqlText);