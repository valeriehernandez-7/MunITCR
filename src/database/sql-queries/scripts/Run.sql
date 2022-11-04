USE [MunITCR]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DECLARE
	@inRDSFilePath NVARCHAR(2048),
	@outResultCode INT;

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

DECLARE 
	@minTMPID INT, -- PK del registro en iteracion
	@maxTMPID INT, -- PK del ultimo registro por iterar
	@minIDOperacion INT, -- PK de la operacion en iteracion de @TMPOperacion
	@maxIDOperacion INT, -- PK de la ultima operacion por iterar en @TMPOperacion
	@minMesOperacion INT, -- mes de operaciones en iteracion de @TMPOperacion
	@maxMesOperacion INT, -- ultimo mes de operaciones por iterar en @TMPOperacion
	@fechaOperacion DATE, -- fecha actual en el procesamiento de operaciones
	@fechaFinMes DATE; -- fecha de fin de mes en iteracion


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
					END;


				/* <Usuario/Usuario> : 
				Procesar asociación o des asociación entre usuarios y personas */
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
					END;


				/* <PersonasyPropiedades/PropiedadPersona> : 
				Procesar asociación o des asociación entre personas y propiedades */
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
					END;


				/* <PropiedadesyUsuarios/UsuarioPropiedad> : 
				Procesar asociación o des asociación entre usuarios y propiedades */
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

						/* <Pago/Pago> : Procesar pagos factura mas vieja por propiedad con medio de pago <> 'Arreglo de pago' */


						/* <Pago/Pago> : Procesar pagos factura mas vieja por propiedad con medio de pago 'Arreglo de pago' */

					END;


				/* Procesar ordenes de reconexion de consumo de agua */

				/* Generar ordenes de corte de consumo de agua */

				/* Generar facturas del mes, a la propiedad cuyo día respecto 
				de fecha de creación coincide con el día de la fecha de operación */

				/* Procesar detalle de cobro por intereses moratorios en facturas vencidas */

				/* Cancelar arreglos de pago */

				/* Limpiar las tablas relacionadas a procesos de 
				operacion antes de procesar la siguiente fecha de operacion */
				DELETE FROM @TMPPersona;
				DELETE FROM @TMPPropiedad;
				DELETE FROM @TMPActualizacionPropiedad;
				DELETE FROM @TMPUsuario;
				DELETE FROM @TMPPersonaXPropiedad;
				DELETE FROM @TMPUsuarioXPropiedad;
				DELETE FROM @TMPMovimientoConsumoAgua;
				DELETE FROM @TMPComprobantePago;

				/* Avanzar a la siguiente fecha de operacion */
				SET @minIDOperacion = @minIDOperacion + 1;
			END;
		/* Avanzar al siguiente mes de operaciones */
		SET @minMesOperacion = @minMesOperacion + 1;
	END;

DELETE FROM @TMPOperacion;

EXECUTE SP_XML_REMOVEDOCUMENT @docOperaciones; -- release the memory used from xml doc
