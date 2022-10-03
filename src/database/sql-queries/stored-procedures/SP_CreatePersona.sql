/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_CreatePersona
	@proc_description
	@proc_param inNombre new person's name
	@proc_param inTipoIdentificacion new person's ID Type
	@proc_param inIdentificacion new person's ID
	@proc_param inTelefono1 new person's contact number
	@proc_param inTelefono2 new person's contact number
	@proc_param inEmail  new person's email
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_CreatePersona]
	@inNombre VARCHAR(128),
	@inTipoIdentificacion VARCHAR(128),
	@inIdentificacion VARCHAR(64),
	@inTelefono1 CHAR(16),
	@inTelefono2 CHAR(16),
	@inEmail VARCHAR(256),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF (@inNombre IS NOT NULL) AND (@inTipoIdentificacion IS NOT NULL) AND (@inIdentificacion IS NOT NULL) AND 
		(@inTelefono1 IS NOT NULL) AND (@inTelefono2 IS NOT NULL) AND (@inEmail IS NOT NULL)
			BEGIN
				/* Gets the PK of @inTipoIdentificacion */
				DECLARE @idTipoIdentificacion INT;
				SELECT @idTipoIdentificacion = [TDI].[ID]
				FROM [dbo].[TipoDocIdentidad] AS [TDI]
				WHERE [TDI].[Nombre] = @inTipoIdentificacion;
		
				IF @idTipoIdentificacion IS NOT NULL
					BEGIN
						IF NOT EXISTS (SELECT 1 FROM [dbo].[Persona] AS [P] WHERE [P].[ValorDocIdentidad] = @inIdentificacion)
							BEGIN
								BEGIN TRANSACTION [insertPersona]
									INSERT INTO [dbo].[Persona] (
										[Nombre],
										[IDTipoDocIdentidad],
										[ValorDocIdentidad],
										[Telefono1],
										[Telefono2],
										[CorreoElectronico]
									) VALUES (
										@inNombre,
										@idTipoIdentificacion,
										@inIdentificacion,
										@inTelefono1,
										@inTelefono2,
										@inEmail
									);
									SET @outResultCode = 5200; /* OK */
								COMMIT TRANSACTION [insertPersona]
							END;
						ELSE
							BEGIN
								/* Cannot insert the new "Persona" because it already exists based on the @inIdentificacion */
								SET @outResultCode = 5406;
								RETURN;
							END;
					END;
				ELSE
					BEGIN
						/* Cannot insert the new "Persona" because the @inTipoIdentificacion did not exist */
						SET @outResultCode = 5404; 
						RETURN;
					END;
			END;
		ELSE
			BEGIN
				/* Cannot insert the new "Persona" because some params are null */
				SET @outResultCode = 5400; 
				RETURN;
			END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [insertPersona]
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