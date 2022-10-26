/*DB Access*/
USE [MunITCR]
GO

/* 
	@proc_name SP_CreateUsuarioXPropiedad
	@proc_description
	@proc_param inUsuarioUsername user's username
	@proc_param inPropiedadLote property identifier
	@proc_param outResultCode Procedure return value
	@author <a href="https://github.com/valeriehernandez-7">Valerie M. Hernández Fernández</a>
*/
CREATE OR ALTER PROCEDURE [SP_CreateUsuarioXPropiedad]
	@inUsuarioUsername VARCHAR(16),
	@inPropiedadLote CHAR(32),
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */

		IF (@inUsuarioUsername IS NOT NULL) AND (@inPropiedadLote IS NOT NULL)
			BEGIN
				/* Gets the PK of "Usuario" using @inUsuarioUsername */
				DECLARE @idUsuario INT;
				SELECT @idUsuario = [U].[ID]
				FROM [dbo].[Usuario] AS [U]
				WHERE [U].[Username] = @inUsuarioUsername;

				/* Gets the PK of "Propiedad" using @inPropiedadLote */
				DECLARE @idPropiedad INT;
				SELECT @idPropiedad = [Pro].[ID]
				FROM [dbo].[Propiedad] AS [Pro]
				WHERE [Pro].[Lote] = @inPropiedadLote;
		
				IF (@idUsuario IS NOT NULL) AND (@idPropiedad IS NOT NULL)
					BEGIN
						IF EXISTS (SELECT 1 FROM [dbo].[Propiedad] AS [P] 
						WHERE [P].[ID] = @idPropiedad AND [P].[IDUsuario] IS NULL)
							BEGIN
								IF NOT EXISTS (SELECT 1 FROM [dbo].[Propiedad] AS [P] 
								WHERE [P].[IDUsuario] = @idUsuario AND [P].[ID] = @idPropiedad)
									BEGIN
										BEGIN TRANSACTION [updateProUser]
											UPDATE [dbo].[Propiedad]
												SET IDUsuario = @idUsuario
											WHERE ID = @idPropiedad;
											SET @outResultCode = 5200; /* OK */
										COMMIT TRANSACTION [updateProUser]
									END;
								ELSE
									BEGIN
										/* Cannot associate "Usuario" with "Propiedad" because the "Usuario" is already 
										associate the "Propiedad" based on the @idUsuario and @idPropiedad */
										SET @outResultCode = 5407;
										RETURN;
									END;
							END;
						ELSE
							BEGIN
								/* Cannot associate "Usuario" because the "Propiedad" already has their "Usuario" */
								SET @outResultCode = 5406;
								RETURN;
							END;
					END;
				ELSE
					BEGIN
						/* Cannot associate "Usuario" with "Propiedad" because the "Usuario" with 
						@idUsuario did not exist or "Propiedad" with @idPropiedad did not exist */
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
				ROLLBACK TRANSACTION [updateProUser]
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