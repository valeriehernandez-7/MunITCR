USE [MunITCR]
GO

CREATE OR ALTER TRIGGER [TR_CreatePropiedadAsociacionCC]
ON [dbo].[Propiedad] 
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE 
		@idNuevaPropiedad INT,
		@tipoZonaPropiedad VARCHAR(128),
		@fechaNuevaPropiedad DATE;
	SELECT 
		@idNuevaPropiedad = [NuevaPropiedad].[ID],
		@tipoZonaPropiedad = [TZP].[Nombre],
		@fechaNuevaPropiedad = [NuevaPropiedad].[FechaRegistro]
	FROM INSERTED [NuevaPropiedad]
		INNER JOIN [dbo].[TipoZonaPropiedad] AS [TZP]
		ON [TZP].[ID] = [NuevaPropiedad].[IDTipoZonaPropiedad];


	DECLARE @TMPPXCC TABLE (
		IDNuevaPropiedad INT,
		IDNuevoConceptoCobro INT,
		FechaNuevaPropiedad DATE
	);


	/* All @tipoZonaPropiedad have to pay "Impuesto sobre propiedad" */
	INSERT INTO @TMPPXCC (
		[IDNuevaPropiedad],
		[IDNuevoConceptoCobro],
		[FechaNuevaPropiedad]
	) SELECT 
		@idNuevaPropiedad,
		[CC].[ID],
		@fechaNuevaPropiedad
	FROM [dbo].[ConceptoCobro] AS [CC]
	WHERE [CC].[Nombre] = 'Impuesto sobre propiedad';


	/* All @tipoZonaPropiedad have to pay "Consumo de agua" except for "Bosque" */
	IF (@tipoZonaPropiedad <> 'Bosque')
		BEGIN
			INSERT INTO @TMPPXCC (
				[IDNuevaPropiedad],
				[IDNuevoConceptoCobro],
				[FechaNuevaPropiedad]
			) SELECT 
				@idNuevaPropiedad,
				[CC].[ID],
				@fechaNuevaPropiedad
			FROM [dbo].[ConceptoCobro] AS [CC]
			WHERE [CC].[Nombre] = 'Consumo de agua';
		END;


	/* All @tipoZonaPropiedad have to pay "Recoleccion de basura y limpieza de canos" 
	except for "Agricola" and "Bosque" */
	IF (@tipoZonaPropiedad <> 'Agricola' AND @tipoZonaPropiedad <> 'Bosque')
		BEGIN
			INSERT INTO @TMPPXCC (
				[IDNuevaPropiedad],
				[IDNuevoConceptoCobro],
				[FechaNuevaPropiedad]
			) SELECT 
				@idNuevaPropiedad,
				[CC].[ID],
				@fechaNuevaPropiedad
			FROM [dbo].[ConceptoCobro] AS [CC]
			WHERE [CC].[Nombre] = 'Recoleccion de basura y limpieza de canos';
		END;


	/* Only @tipoZonaPropiedad "Zona Comercial"  has to pay "Patente comercial" */
	IF (@tipoZonaPropiedad = 'Zona Comercial')
		BEGIN
			INSERT INTO @TMPPXCC (
				[IDNuevaPropiedad],
				[IDNuevoConceptoCobro],
				[FechaNuevaPropiedad]
			) SELECT 
				@idNuevaPropiedad,
				[CC].[ID],
				@fechaNuevaPropiedad
			FROM [dbo].[ConceptoCobro] AS [CC]
			WHERE [CC].[Nombre] = 'Patente comercial';
		END;


	/* Only @tipoZonaPropiedad "Residencial" and "Zona Comercial" have to 
	pay "Mantenimiento de parques y alumbrado publico" */
	IF (@tipoZonaPropiedad = 'Residencial') OR (@tipoZonaPropiedad = 'Zona Industrial')
	OR (@tipoZonaPropiedad = 'Zona Comercial')
		BEGIN
			INSERT INTO @TMPPXCC (
				[IDNuevaPropiedad],
				[IDNuevoConceptoCobro],
				[FechaNuevaPropiedad]
			) SELECT 
				@idNuevaPropiedad,
				[CC].[ID],
				@fechaNuevaPropiedad
			FROM [dbo].[ConceptoCobro] AS [CC]
			WHERE [CC].[Nombre] = 'Mantenimiento de parques y alumbrado publico';
		END;


	IF EXISTS (SELECT 1 FROM @TMPPXCC)
		BEGIN
			INSERT INTO [dbo].[PropiedadXConceptoCobro] (
				[IDPropiedad],
				[IDConceptoCobro],
				[FechaInicio]
			) SELECT
				[PXCC].[IDNuevaPropiedad],
				[PXCC].[IDNuevoConceptoCobro],
				[PXCC].[FechaNuevaPropiedad]
			FROM @TMPPXCC AS [PXCC];
		END;

	SET NOCOUNT OFF;
END;