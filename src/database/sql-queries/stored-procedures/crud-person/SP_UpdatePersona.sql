/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_UpdatePersona
	@proc_description
	@proc_param inOldIdentificacion person's current ID
	@proc_param inNombre person's new name
	@proc_param inTipoIdentificacion person's new ID Type
	@proc_param inIdentificacion person's new ID
	@proc_param inTelefono1 person's new contact number
	@proc_param inTelefono2 person's new contact number
	@proc_param inEmail  person's new email
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_UpdatePersona]
	@inOldIdentificacion VARCHAR(64),
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

		IF (@inOldIdentificacion IS NOT NULL) AND (@inNombre IS NOT NULL) 
		AND (@inTipoIdentificacion IS NOT NULL) AND (@inIdentificacion IS NOT NULL) 
		AND (@inTelefono1 IS NOT NULL) AND (@inTelefono2 IS NOT NULL) AND (@inEmail IS NOT NULL)
			BEGIN
				/* Gets the PK of @inTipoIdentificacion */
				DECLARE @idTipoIdentificacion INT;
				SELECT @idTipoIdentificacion = [TDI].[ID]
				FROM [dbo].[TipoDocIdentidad] AS [TDI]
				WHERE [TDI].[Nombre] = @inTipoIdentificacion;

				/* Gets the PK of "Persona" using @inOldIdentificacion */
				DECLARE @idPersona INT;
				SELECT @idPersona = [Per].[ID]
				FROM [dbo].[Persona] AS [Per]
				WHERE [Per].[ValorDocIdentidad] = @inOldIdentificacion
				AND [Per].[Activo] = 1;
		
				IF @idTipoIdentificacion IS NOT NULL
					BEGIN
						IF @idPersona IS NOT NULL
							BEGIN
								BEGIN TRANSACTION [updatePersona]
									UPDATE [dbo].[Persona]
										SET 
											[Nombre] = @inNombre,
											[IDTipoDocIdentidad] = @idTipoIdentificacion,
											[ValorDocIdentidad] = @inIdentificacion,
											[Telefono1] = @inTelefono1,
											[Telefono2] = @inTelefono2,
											[CorreoElectronico] = @inEmail
									WHERE [ValorDocIdentidad] = @inOldIdentificacion;
									SET @outResultCode = 5200; /* OK */
								COMMIT TRANSACTION [updatePersona]
							END;
						ELSE
							BEGIN
								/* Cannot update the "Persona" because not 
								exists based on the @inOldIdentificacion */
								SET @outResultCode = 5406;
								RETURN;
							END;
					END;
				ELSE
					BEGIN
						/* Cannot update the "Persona" because the 
						@inTipoIdentificacion did not exist */
						SET @outResultCode = 5404; 
						RETURN;
					END;
			END;
		ELSE
			BEGIN
				/* Cannot update the "Persona" because some params are null */
				SET @outResultCode = 5400; 
				RETURN;
			END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [updatePersona]
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