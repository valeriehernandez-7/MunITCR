/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name
	@proc_description
	@proc_param
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
	@author <a href="https://github.com/efmz200">Erick F. Madrigal Zavala</a>
*/
CREATE OR ALTER PROCEDURE [SP_Name]
	/* SP Parameters */
	-- @inVariable TYPE,
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */
		/* TRY LINES */
		BEGIN TRANSACTION [transactionName]
			/* TRANSACTION LINES */
			SET @outResultCode = 5200; /* OK */
		COMMIT TRANSACTION [transactionName]
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [transactionName]
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