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

/* Tabla con asociaciones o desasociaciones de personas 
con propiedades del archivo Operaciones.xml */
DECLARE @TMPPersonaXPropiedad TABLE (
	[ID] INT IDENTITY(1,1) PRIMARY KEY,
	[TipoOperacion] VARCHAR(8),
	[PersonaValorDocIdentidad] VARCHAR(64),
	[PropiedadLote] VARCHAR(32)
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
	@minIDOperacion INT,
	@maxIDOperacion INT,
	@minMesOperacion INT,
	@maxMesOperacion INT,
	@fechaOperacion DATE,
	@fechaFinMes DATE;


/* Obtiene el ID minimo y maximo de la tabla de operaciones 
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

				/* <Propiedades/Propiedad> : Procesar propiedades */

				/* <PropiedadCambio/PropiedadCambios> : 
				Procesar cambios de valor fiscal de propiedad */

				/* <PersonasyPropiedades/PropiedadPersona> : 
				Procesar asociación o des asociación entre personas y propiedades */

				/* <Usuario/Usuario> : 
				Procesar asociación o des asociación entre usuarios y personas */

				/* <PropiedadesyUsuarios/UsuarioPropiedad> : 
				Procesar asociación o des asociación entre usuarios y propiedades */

				/* <Lecturas/LecturaMedidor> : 
				Procesar lecturas de medidor de propiedad */

				/* <Pago/Pago> : Procesar pagos factura mas vieja por propiedad con medio de pago <> 'Arreglo de pago' */

				/* <Pago/Pago> : Procesar pagos factura mas vieja por propiedad con medio de pago 'Arreglo de pago' */

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
				DELETE FROM @TMPPersonaXPropiedad;
				DELETE FROM @TMPUsuario;
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
