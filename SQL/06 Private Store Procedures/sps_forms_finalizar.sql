-- =============================================
-- Author:		ÃÂÃÂngel HernÃÂÃÂ¡ndez
-- Create date: 12 Dic 2016
-- Description:	Finaliza la encuesta
-- =============================================
CREATE PROCEDURE [dbo].[sps_forms_finalizar] 
	-- Add the parameters for the stored procedure here
	  @idSession VARCHAR(MAX)
	, @idForm    CHAR(32)
	, @latitud   DECIMAL(18,10)
	, @longitud  DECIMAL(18,10)
	, @datos     VARCHAR(MAX)
AS
BEGIN
	DECLARE @error VARCHAR(MAX);
	DECLARE @idUsuario VARCHAR(32);
	DECLARE @UPDATE CHAR(1) = 'U';
	DECLARE @DELETE CHAR(1) = 'D';
	DECLARE @NEW    CHAR(1) = 'N';
	DECLARE @FINALIZADO INT  = 2;
	
	DECLARE @CADUCADA BIT = 0;
	DECLARE @CANCELADA BIT = 0;
	DECLARE @idFormUsuario VARCHAR(32)
	

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	BEGIN TRY
	
		EXECUTE sp_servicios_validar   @idSession, @@PROCID, @idUsuario OUTPUT
		
		SELECT @CADUCADA = CASE WHEN( dbo.fn_dateTimeToDate( GETDATE()) > dbo.fn_dateTimeToDate( fcaducidad ) ) THEN 1 ELSE 0 END FROM [dbo].[forms] WHERE idForm = @idForm;
		
		IF ( @CADUCADA = 1 ) 
			execute sp_error 'U', 'No es posible finalizar la encuesta porque ya ha caducado.'
		ELSE BEGIN
			SELECT @CANCELADA = CASE WHEN estatus = 9 THEN 1 ELSE 0 END FROM forms WHERE idForm = @idForm;
		
			IF ( @CANCELADA = 1 )
				execute sp_error 'U', 'No es posible finalizar la encuesta porque ha sido cancelada por el enviador.'
			ELSE BEGIN
			
				BEGIN TRY
				BEGIN TRANSACTION
					-- Registrar la finalizaciÃ³n de la encuesta
					
					SET @idFormUsuario = dbo.fn_randomKey();
				
				
					SELECT    col1 AS idFelementoOpcion
							, col3 AS descripcion
							, CAST(dbo.fn_ownerDateFormatToStandarFormat(col4) AS DATETIME) AS fecha
					INTO #tmpUserDataTable
					FROM fn_table(3, @datos) AS userDataTable;
					
					-- Insertar los datos que vienen de la DB local
					INSERT INTO [dbo].[elementsData]( idelementData, idFelementoOpcion, idFormUsuario, descripcion, fecha)
					SELECT dbo.fn_randomKey(), idFelementoOpcion, @idFormUsuario, descripcion,  CASE WHEN fecha = '' THEN NULL ELSE fecha END
					FROM #tmpUserDataTable;
					
					DROP TABLE #tmpUserDataTable;
				
					
					-- Registrar la finalizacion de la encuesta
					INSERT INTO bFormsUsuarios ( idFormUsuario, idForm , idUsuario     , estatus, fecha, latitud, longitud   )
									VALUES ( @idFormUsuario, @idForm, @idUsuario, @FINALIZADO, GETDATE(), @latitud, @longitud )	
						
					
				
				COMMIT TRANSACTION
				END TRY
				BEGIN CATCH
					ROLLBACK TRANSACTION
					SET @error = ERROR_MESSAGE()
					EXECUTE sp_error 'S', @error
				END CATCH
				
			END -- Cancelada
		
		END -- Caducado
		
	END TRY
	BEGIN CATCH
		
		SET @error = ERROR_MESSAGE()
		EXECUTE sp_error 'S', @error
	END CATCH
	-- 
END



