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
	@inTelefono1 VARCHAR(16),
	@inTelefono2 VARCHAR(16),
	@inEmail VARCHAR(256),
	@inEventUser VARCHAR(16),
	@inEventIP VARCHAR(64),
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
		
				/* Get the event params to create a new register at dbo.EventLog */

				DECLARE 
					@idEventType INT,
					@idEntityType INT,
					@actualData NVARCHAR(MAX), 
					@newData NVARCHAR(MAX);

				SELECT @idEventType = [EVT].[ID] -- event data
				FROM [dbo].[EventType] AS [EVT]
				WHERE [EVT].[Name] = 'Update';

				SELECT @idEntityType = [ENT].[ID] -- event data
				FROM [dbo].[EntityType] AS [ENT]
				WHERE [ENT].[Name] = 'Persona';

				IF @inEventUser IS NULL -- event data
					BEGIN
						SET @inEventUser = 'MunITCR';
					END;

				IF @inEventIP IS NULL -- event data
					BEGIN
						SET @inEventIP = '0.0.0.0';
					END;


				IF @idTipoIdentificacion IS NOT NULL
					BEGIN
						IF @idPersona IS NOT NULL
							BEGIN
								BEGIN TRANSACTION [updatePersona]
									
									/* Get "Persona" data before update */
									SET @actualData = ( -- event data
										SELECT 
											[P].[Nombre] AS [Nombre],
											[P].[IdTipoDocIdentidad] AS [TipodeDocumentoIdentidad],
											[P].[ValorDocIdentidad] AS [Identificacion],
											[P].[Telefono1] AS [Telefono1],
											[P].[Telefono2] AS [Telefono2], 
											[P].[CorreoElectronico] AS [CorreoElectronico],
											[P].[Activo] AS [Activo]
										FROM [dbo].[Persona] AS [P]
										WHERE [P].[ID] = @idPersona
										FOR JSON AUTO
									);

									/* Update "Persona" using  @idPersona */
									UPDATE [dbo].[Persona] 
										SET 
											[Nombre] = @inNombre,
											[IDTipoDocIdentidad] = @idTipoIdentificacion,
											[ValorDocIdentidad] = @inIdentificacion,
											[Telefono1] = @inTelefono1,
											[Telefono2] = @inTelefono2,
											[CorreoElectronico] = @inEmail
									WHERE [Persona].[ID] = @idPersona;

									/* Get "Persona" data after update */
									SET @newData = ( -- event data
										SELECT 
											[P].[Nombre] AS [Nombre],
											[P].[IdTipoDocIdentidad] AS [TipodeDocumentoIdentidad],
											[P].[ValorDocIdentidad] AS [Identificacion],
											[P].[Telefono1] AS [Telefono1],
											[P].[Telefono2] AS [Telefono2], 
											[P].[CorreoElectronico] AS [CorreoElectronico],
											[P].[Activo] AS [Activo]
										FROM [dbo].[Persona] AS [P]
										WHERE [P].[ID] = @idPersona
										FOR JSON AUTO
									);

									IF (@idEventType IS NOT NULL) AND (@idEntityType IS NOT NULL) 
									AND (@inEventUser IS NOT NULL) AND (@inEventIP IS NOT NULL)
										BEGIN
											INSERT INTO [dbo].[EventLog] (
												[IDEventType],
												[IDEntityType],
												[EntityID],
												[BeforeUpdate],
												[AfterUpdate],
												[Username],
												[UserIP]
											) VALUES (
												@idEventType,
												@idEntityType,
												@idPersona,
												@actualData,
												@newData,
												@inEventUser,
												@inEventIP
											);
											SET @outResultCode = 5200; /* OK */
										END;
									ELSE
										BEGIN
											/* Cannot insert the new "Evento" because some 
											event's params are null */
											SET @outResultCode = 5407;
											RETURN;
										END;

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