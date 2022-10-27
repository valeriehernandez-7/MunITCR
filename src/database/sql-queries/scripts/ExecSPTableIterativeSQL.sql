DECLARE @TMPPropiedad TABLE (
	[ID] INT IDENTITY (1,1),
	[UsoPropiedad] VARCHAR(128),
	[ZonaPropiedad] VARCHAR(128),
	[lote] CHAR(32),
	[medidor] CHAR(16),
	[metros] BIGINT,
	[valor] MONEY,
	[fecha] DATE
);

INSERT INTO @TMPPropiedad 
VALUES (
	'Habitacion',
	'Residencial',
	'2263',
	'1010',
	22222,
	1155,
	GETDATE()
);

INSERT INTO @TMPPropiedad 
VALUES (
	'Comercial',
	'Zona Industrial',
	'3456',
	'89741',
	126432,
	123,
	GETDATE()
);

INSERT INTO @TMPPropiedad 
VALUES (
	'Lote Baldio',
	'Agricola',
	'1235',
	'693',
	1262,
	1456,
	GETDATE()
);


SELECT * FROM @TMPPropiedad;

DECLARE 
	@idLow INT, 
	@idHigh INT,
	@UsoPropiedad VARCHAR(128),
	@ZonaPropiedad VARCHAR(128),
	@lote CHAR(32),
	@medidor CHAR(16),
	@metros BIGINT,
	@valor MONEY,
	@fecha DATE,
	@outResult INT;

SELECT 
	@idLow = MIN([T].[ID]), 
	@idHigh = MAX([T].[ID])
FROM @TMPPropiedad AS [T];

WHILE (@idLow <= @idHigh)
	BEGIN
		IF EXISTS (SELECT 1 FROM @TMPPropiedad AS [TP] WHERE [TP].[ID] = @idLow)
			BEGIN
				SELECT 
					@UsoPropiedad = [UsoPropiedad],
					@ZonaPropiedad = [ZonaPropiedad],
					@lote = [lote],
					@medidor = [medidor],
					@metros = [metros],
					@valor = [valor],
					@fecha = [fecha]
				FROM @TMPPropiedad AS [T]
				WHERE [T].[ID] = @idLow;
		
				EXECUTE [SP_CreatePropiedad] @UsoPropiedad, @ZonaPropiedad, @lote, @medidor, @metros, @valor, @fecha, @outResult OUTPUT;

				SELECT @outResult;
			END;
		SET @idLow = @idLow + 1;
	END;


SELECT * FROM dbo.Propiedad;
