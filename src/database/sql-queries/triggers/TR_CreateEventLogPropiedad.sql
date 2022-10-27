USE [MunITCR]
GO

CREATE OR ALTER TRIGGER [TR_CreateEventLogPropiedad]
ON [dbo].[Propiedad] 
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	/* Get the event params to create a new register at dbo.EventLog */
	DECLARE 
		@idEventType INT,
		@idEntityType INT,
		@actualData NVARCHAR(MAX), 
		@newData NVARCHAR(MAX);

	/* Get PK of the "EventType" with "Create" as name */
	SELECT @idEventType = [EVT].[ID]
	FROM [dbo].[EventType] AS [EVT]
	WHERE [EVT].[Name] = 'Create';

	/* Get PK of the "EntityType" with "Propiedad" as name */
	SELECT @idEntityType = [ENT].[ID]
	FROM [dbo].[EntityType] AS [ENT]
	WHERE [ENT].[Name] = 'Propiedad';

	/* Get 'INSERTED' data and create NVARCHAR with JSON format */
	SET @newData = (
		SELECT 
			[NP].[Lote] AS [Propiedad],
			[NP].[IDTipoUsoPropiedad] AS [UsodePropiedad],
			[NP].[IDTipoZonaPropiedad] AS [ZonadePropiedad],
			[NP].[MetrosCuadrados] AS [MetrosCuadrados],
			[NP].[ValorFiscal] AS [ValorFiscal],
			[NP].[FechaRegistro] AS [FechadeRegistro],
			[NP].[Activo] AS [Activo]
		FROM INSERTED [NP] 
		FOR JSON AUTO
	);

	/* Insert new "EventLog" */
	IF (@idEventType IS NOT NULL) AND (@idEntityType IS NOT NULL)
		BEGIN
			INSERT INTO [dbo].[EventLog] (
				[IDEventType],
				[IDEntityType],
				[EntityID],
				[BeforeUpdate],
				[AfterUpdate]
			) SELECT 
				@idEventType,
				@idEntityType,
				[NuevaPropiedad].[ID],
				@actualData,
				@newData
			FROM INSERTED [NuevaPropiedad];	
		END;

	SET NOCOUNT OFF;
END;