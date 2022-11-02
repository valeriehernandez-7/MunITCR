/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadEventLogEventInEntityInFechaIn
	@proc_description 
	@proc_param inEventType 
	@proc_param inEntityType 
	@proc_param inFechaInicial 
	@proc_param inFechaFinal 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_ReadEventLogEventInEntityInFechaIn]
	@inEventType NVARCHAR(8),
	@inEntityType NVARCHAR(128),
	@inFechaInicial DATE,
	@inFechaFinal DATE,
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF (@inFechaInicial IS NOT NULL) AND (@inFechaFinal IS NOT NULL)
			BEGIN
				/* Gets the PK of "tipo de evento" using @inEventType */
				DECLARE @idEventType INT;
				SELECT @idEventType = [EVT].[ID]
				FROM [dbo].[EventType] AS [EVT]
				WHERE [EVT].[Name] = @inEventType;

				/* Gets the PK of "tipo de entidad" using @inEntityType */
				DECLARE @idEntityType INT;
				SELECT @idEntityType = [ENT].[ID]
				FROM [dbo].[EntityType] AS [ENT]
				WHERE [ENT].[Name] = @inEntityType;

				IF (@idEventType IS NULL) AND (@idEntityType IS NULL)
					BEGIN
						SELECT 
							[EVT].[Name] AS [TipodeEvento],
							[ENT].[Name] AS [Entidad],
							[EL].[EntityID] AS [IDEntidad],
							[EL].[BeforeUpdate] AS [Historial],
							[EL].[AfterUpdate] AS [Actualizacion],
							[EL].[Username] AS [Autor],
							[EL].[UserIP] AS [IP],
							[EL].[DateTime] AS [Fecha]
						FROM [dbo].[EventLog] AS [EL]
							INNER JOIN [dbo].[EventType] AS [EVT] 
							ON [EVT].[ID] = [EL].[IDEventType]
							INNER JOIN [dbo].[EntityType] AS [ENT] 
							ON [ENT].[ID] = [EL].[IDEntityType]
						WHERE [EL].[DateTime] BETWEEN @inFechaInicial AND @inFechaFinal 
						ORDER BY [EL].[DateTime];
					END;
				ELSE
					BEGIN
						SELECT 
							[EVT].[Name] AS [TipodeEvento],
							[ENT].[Name] AS [Entidad],
							[EL].[EntityID] AS [IDEntidad],
							[EL].[BeforeUpdate] AS [Historial],
							[EL].[AfterUpdate] AS [Actualizacion],
							[EL].[Username] AS [Autor],
							[EL].[UserIP] AS [IP],
							[EL].[DateTime] AS [Fecha]
						FROM [dbo].[EventLog] AS [EL]
							INNER JOIN [dbo].[EventType] AS [EVT] 
							ON [EVT].[ID] = [EL].[IDEventType]
							INNER JOIN [dbo].[EntityType] AS [ENT] 
							ON [ENT].[ID] = [EL].[IDEntityType]
						WHERE [EL].[DateTime] BETWEEN @inFechaInicial AND @inFechaFinal 
						AND [EVT].[ID] = @idEventType 
						AND [ENT].[ID] = @idEntityType 
						ORDER BY [EL].[DateTime];
					END;
				SET @outResultCode = 5200; /* OK */
			END;
	END TRY
	BEGIN CATCH
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