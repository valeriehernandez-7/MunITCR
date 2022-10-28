/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_CreateUsuarioXPropiedad
	@proc_description
	@proc_param inUsuarioIdentificacion person's doc ID
	@proc_param inPropiedadLote property identifier
	@proc_param inFechaAsociacionPxP association date
	@proc_param inEventUser 
	@proc_param inEventIP 
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_CreateUsuarioXPropiedad]
	@inUsuarioUsername VARCHAR(64),
	@inPropiedadLote VARCHAR(32),
	@inFechaAsociacionUxP DATE,
	@inEventUser VARCHAR(16),
	@inEventIP VARCHAR(64),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF (@inUsuarioUsername IS NOT NULL) AND (@inPropiedadLote IS NOT NULL)
			BEGIN
				/* Gets the PK of "Usuario" using @idUsuarioIdentificacion */
				DECLARE @idUsuario INT;
				SELECT @idUsuario = [Usr].[ID]
				FROM [dbo].[Usuario] AS [Usr]
				WHERE [Usr].[Username] = @inUsuarioUsername;

				/* Gets the PK of "Propiedad" using @inPropiedadLote */
				DECLARE @idPropiedad INT;
				SELECT @idPropiedad = [Pro].[ID]
				FROM [dbo].[Propiedad] AS [Pro]
				WHERE [Pro].[Lote] = @inPropiedadLote;

				IF @inFechaAsociacionUxP IS NULL
					BEGIN
						SET @inFechaAsociacionUxP = GETDATE();
					END;

				/* Get the event params to create a new register at dbo.EventLog */
				
				DECLARE 
					@idEventType INT,
					@idEntityType INT,
					@lastEntityID INT,
					@actualData NVARCHAR(MAX), 
					@newData NVARCHAR(MAX);

				SELECT @idEventType = [EVT].[ID] -- event data
				FROM [dbo].[EventType] AS [EVT]
				WHERE [EVT].[Name] = 'Create';

				SELECT @idEntityType = [ENT].[ID] -- event data
				FROM [dbo].[EntityType] AS [ENT]
				WHERE [ENT].[Name] = 'Usuario de Propiedad';

				IF @inEventUser IS NULL -- event data
					BEGIN
						SET @inEventUser = 'MunITCR';
					END;

				IF @inEventIP IS NULL -- event data
					BEGIN
						SET @inEventIP = '0.0.0.0';
					END;
		
				IF (@idUsuario IS NOT NULL) AND (@idPropiedad IS NOT NULL) AND (@inFechaAsociacionUxP IS NOT NULL)
					BEGIN
						IF NOT EXISTS (SELECT 1 FROM [dbo].[UsuarioXPropiedad] AS [UXP] 
						WHERE [UXP].[IDUsuario] = @idUsuario AND [UXP].[IDPropiedad] = @idPropiedad)
							BEGIN
								BEGIN TRANSACTION [insertUsrXPro]
									/* Insert new "UsuarioXPropiedad" as "Usuario" + "Propiedad" association */
									INSERT INTO [dbo].[UsuarioXPropiedad] (
										[IDUsuario],
										[IDPropiedad],
										[FechaInicio]
									) VALUES (
										@idUsuario,
										@idPropiedad,
										@inFechaAsociacionUxP
									);

									/* GET new "UsuarioXPropiedad" PK */
									SET @lastEntityID = SCOPE_IDENTITY(); -- event data

									SET @newData = ( -- event data
										SELECT 
											[UsrXPro].[IDUsuario] AS [IDUsuario],
											[UsrXPro].[IDPropiedad] AS [IDPropiedad],
											[UsrXPro].[FechaInicio] AS [FechadeAsociacion],
											[UsrXPro].[FechaFin] AS [FechadeDesasociacion],
											[UsrXPro].[Activo] AS [Activo]
										FROM [dbo].[UsuarioXPropiedad] AS [UsrXPro]
										WHERE [UsrXPro].[ID] = @lastEntityID
										FOR JSON AUTO
									);

									IF (@idEventType IS NOT NULL) AND (@idEntityType IS NOT NULL) AND (@lastEntityID IS NOT NULL)
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
												@lastEntityID,
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
								COMMIT TRANSACTION [insertUsrXPro]
							END;
						ELSE
							BEGIN
								/* Cannot associate "Usuario" with "Propiedad" because the "Usuario" is already 
								associate the "Propiedad" based on the @idUsuario and @idPropiedad */
								SET @outResultCode = 5406;
								RETURN;
							END;
					END;
				ELSE
					BEGIN
						/* Cannot associate "Usuario" with "Propiedad" because the "Usuario" with 
						@idUsuario did not exist or "Propiedad" with @idPropiedad did not exist 
						or @inFechaAsociacionPxP did not exist*/
						SET @outResultCode = 5404; 
						RETURN;
					END;
			END;
		ELSE
			BEGIN
				/* Cannot associate "Usuario" with "Propiedad" because some params are null */
				SET @outResultCode = 5400; 
				RETURN;
			END;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [insertUsrXPro]
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