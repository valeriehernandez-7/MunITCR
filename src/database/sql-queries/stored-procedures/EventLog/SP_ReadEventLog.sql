/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_ReadEventLog
	@proc_description 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_ReadEventLog]
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

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
		ORDER BY [EL].[DateTime] DESC;
		
		SET @outResultCode = 5200; /* OK */
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