USE [MunITCR]
GO

CREATE OR ALTER TRIGGER [TR_UpdatePropiedadEventLog]
ON [dbo].[Propiedad] 
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	/* Get the event params to update the register at dbo.EventLog */
	DECLARE
		@idEventLog INT,
		@newData NVARCHAR(MAX);

	/* Get the last event ID at dbo.EventLog */
	SELECT @idEventLog = MAX([EV].[ID]) 
	FROM [dbo].[EventLog] AS [EV];

	/* Get 'INSERTED' data and create NVARCHAR with JSON format */
	SET @newData = (
		SELECT 
			[NP].[IDTipoUsoPropiedad] AS [IDTipoUsoPropiedad],
			[NP].[IDTipoZonaPropiedad] AS [IDTipoZonaPropiedad],
			[NP].[Lote] AS [Lote],
			[NP].[MetrosCuadrados] AS [MetrosCuadrados],
			[NP].[ValorFiscal] AS [ValorFiscal], 
			[NP].[FechaRegistro] AS [FechaRegistro],
			[NP].[Activo] AS [Activo]
		FROM UPDATED [NP] 
		FOR JSON AUTO
	);

	/* Insert new "EventLog" */
	IF (@newData IS NOT NULL) AND (@idEventLog IS NOT NULL)
		BEGIN
			UPDATE [dbo].[EventLog]
				SET [AfterUpdate] = @newData
			FROM [dbo].[EventLog] AS [EL]
				INNER JOIN INSERTED [NuevaPropiedad]
				ON [NuevaPropiedad].[ID] = [EL].[EntityID]
				INNER JOIN [dbo].[EventType] AS [EvT]
				ON [EvT].[ID] = [EL].[IDEventType]
				INNER JOIN [dbo].[EntityType] AS [EnT]
				ON [EnT].[ID] = [EL].[IDEntityType]
			WHERE [EL].[ID] = @idEventLog
			AND [EvT].[Name] = 'Update'
			AND [EnT].[Name] = 'Propiedad';
		END;

	SET NOCOUNT OFF;
END;