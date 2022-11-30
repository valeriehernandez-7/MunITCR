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
CREATE OR ALTER PROCEDURE [SP_FacturacionArregloPago]
	/* SP Parameters */
    @inFechaOperacion DATE;
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0; /* Unassigned code */
		DECLARE @TMPPropiedadesAP TABLE (
					[ID] INT IDENTITY(1,1) PRIMARY KEY,
					[IDPropiedad] INT,
					[IDPropiedadAP] INT
				);
        DECLARE @IDConceptoCobro INT,
                @ActualProp INT,
                @ActualAP INT,
                @ActualCC INT,
                @Cuota Money,
                @IDMin INT,
                @IDMax INT;

        SELECT @IDConceptoCobro =( --ES UNA SEÑAL
            SELECT [CC].[ID]
            FROM [dbo].[ConceptoCobro] AS CC
            WHERE [CC].[Nombre] = 'Arreglo de pago')


        INSERT INTO @TMPPropiedadesAP(
            IDPropiedad,
            IDPropiedadAP
        ) SELECT
                [P].[ID],
                [PAP].[ID]
        FROM [dbo].[Propiedad] AS P
        LEFT JOIN [dbo].[PropiedadXConceptoCobro] AS PXCC
        ON [PXCC].[IDPropiedad] = [P].[ID]
        LEFT JOIN [dbo].[PropiedadXCCArregloPago] AS PAP
        ON [PXCC].[ID] = [PAP].[IDPropiedadXCC]
        WHERE [PAP].[Activo] = 1 AND
            [P].[Activo] = 1 

        SELECT  @IDMIN =  MIN([TMP].ID),
                @IDMAX = MAX([TMP].ID)
        FROM @TMPPropiedadesAP AS TMP

		BEGIN TRANSACTION [FacturacionArregloPago]
			/* TRANSACTION LINES */

            WHILE (@IDMin<@IDMax)
            BEGIN
                SELECT @ActualProp = [TMP].[IDPropiedad],
                    @ActualAP = [TMP].[IDPropiedadAP]
                FROM @TMPPropiedadesAP AS TMP
                WHERE @IDMIN = [TMP].[ID]

                SELECT @Cuota =(
                    SELECT [MAP].[MontoCuota]
                    FROM [dbo].[MovimientoArregloPago] AS MAP
                    WHERE [MAP].[IDPropiedadXCCArregloPago] = @ActualAP
                )

                INSERT INTO [dbo].[PropiedadXConceptoCobro](
                    IDPropiedad,
                    IDConceptoCobro,
                    FechaInicio,
                    FechaFin
                )VALUES(
                    @ActualProp,
                    @IDConceptoCobro,
                    @inFechaOperacion,
                    DATEADD(month,'1',@inFechaOperacion)
                )

                SET @ActualCC = SCOPE_IDENTITY();

                UPDATE [dbo].[Factura]
                    SET [MontoOriginal] = [MontoOriginal] + @Cuota,
                        [MontoPagar] = [MontoPagar] + @Cuota
                    WHERE
                        IDPropiedad = @ActualProp AND
                        Fecha = @inFechaOperacion
                INSERT INTO [dbo].[DetalleCC](
                    [IDFactura],
                    [IDPropiedadXConceptoCobro],
                    [Monto]
                    )VALUES(
                        SCOPE_IDENTITY(),
                        @ActualCC,
                        @Cuota
                    );

                UPDATE [dbo].[PropiedadXCCArregloPago] 
                    SET [MontoSaldo] =(
                        [MontoSaldo]-@Cuota --ESTO SE PUEDE HACER? LA VERDAD NO ESTOY SEGURO XD
                    )WHERE [ID] = @ActualAP
                SET @IDMin = @IDMin + 1
            END

			SET @outResultCode = 5200; /* OK */
		COMMIT TRANSACTION [FacturacionArregloPago]
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION [FacturacionArregloPago]
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