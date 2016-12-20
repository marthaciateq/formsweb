-- =============================================
-- Author:		?Wngel Hern?hndez
-- Create date: 30 Sep 2016
-- Description:	Guarda las respuestas de la encuesta
-- =============================================
CREATE PROCEDURE [dbo].[sps_forms_guardar] 
	-- Add the parameters for the stored procedure here
	  @idSession VARCHAR(MAX)
	, @idForm    CHAR(32)
	, @datos     VARCHAR(MAX)
	, @finalizar BIT = 0
AS
BEGIN
	DECLARE @error VARCHAR(MAX);
	DECLARE @idUsuario VARCHAR(32);
	DECLARE @UPDATE CHAR(1) = 'U';
	DECLARE @DELETE CHAR(1) = 'D';
	DECLARE @NEW    CHAR(1) = 'N';
	
	DECLARE @FINISH INT  = 2;
	
	DECLARE @CADUCADA BIT = 0;
	DECLARE @CANCELADA BIT = 0;
	DECLARE @FINALIZADA BIT = 0;

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	BEGIN TRY
	
		EXECUTE sp_servicios_validar   @idSession, @@PROCID, @idUsuario OUTPUT
		
		SELECT @CADUCADA = CASE WHEN( dbo.fn_dateTimeToDate( GETDATE()) > dbo.fn_dateTimeToDate( fcaducidad ) ) THEN 1 ELSE 0 END FROM [dbo].[forms] WHERE idForm = @idForm;
		
		IF ( @CADUCADA = 1 ) 
			execute sp_error 'U', 'No es posible guardar la encuesta porque ya ha caducado.'
		ELSE BEGIN
			SELECT @CANCELADA = CASE WHEN estatus = 9 THEN 1 ELSE 0 END FROM forms WHERE idForm = @idForm;
		
			IF ( @CANCELADA = 1 )
				execute sp_error 'U', 'No es posible guardar la encuesta porque ha sido cancelada por el enviador.'
			ELSE BEGIN
				SELECT @FINALIZADA = CASE WHEN MAX(estatus) = 2 THEN 1 ELSE 0 END FROM bformsUsuarios WHERE idForm = @idForm   AND  idUsuario = @idUsuario;
	
				IF ( @FINALIZADA = 1 )
					execute sp_error 'U', 'No es posible guardar la encuesta porque ya ha sido finalizada.'
				ELSE BEGIN 
				
					BEGIN TRY
					BEGIN TRANSACTION
					
						SELECT    col1 AS idFelementoOpcion
								, col2 AS idFormElemento
								, col3 AS descripcion
								, CAST(dbo.fn_ownerDateFormatToStandarFormat(col4) AS DATETIME) AS fecha
								, col5 AS [action]
						INTO #tmpUserDataTable
						FROM fn_table(5, @datos) AS userDataTable
						WHERE col5 <> '';
						

						UPDATE 
							elementsDataTable
						SET
							elementsDataTable.descripcion = tmpUserDataTable.descripcion
							, elementsDataTable.fecha = CASE WHEN tmpUserDataTable.fecha = '' THEN NULL ELSE tmpUserDataTable.fecha END
						FROM [dbo].[elementsData]  AS elementsDataTable
							INNER JOIN #tmpUserDataTable AS tmpUserDataTable ON elementsDataTable.idFelementoOpcion = tmpUserDataTable.idFelementoOpcion
						WHERE tmpUserDataTable.[action] = @UPDATE AND elementsDataTable.idUsuario = @idUsuario;
						
						
						DELETE elementsDataTable
						FROM
							[dbo].[elementsData] AS elementsDataTable
							INNER JOIN #tmpUserDataTable AS tmpUserDataTable ON elementsDataTable.idFelementoOpcion = tmpUserDataTable.idFelementoOpcion
						WHERE tmpUserDataTable.[action] = @DELETE AND elementsDataTable.idUsuario = @idUsuario;
						
						
						INSERT INTO [dbo].[elementsData]( idelementData, idFelementoOpcion, descripcion, fecha, idUsuario)
						SELECT dbo.fn_randomKey(), idFelementoOpcion, descripcion,  CASE WHEN fecha = '' THEN NULL ELSE fecha END, @idUsuario
						FROM #tmpUserDataTable
						WHERE [action] = @NEW;
						
						DROP TABLE #tmpUserDataTable;
						
						IF ( @finalizar = 1 ) BEGIN
							-- Registrar la finalización de la encuesta
							INSERT INTO bFormsUsuarios ( idForm , idUsuario , fecha    , estatus   )
											VALUES ( @idForm, @idUsuario, GETDATE(), @FINISH )	
						END
					
				
					COMMIT TRANSACTION
					END TRY
					BEGIN CATCH
						ROLLBACK TRANSACTION
						SET @error = ERROR_MESSAGE()
						EXECUTE sp_error 'S', @error
					END CATCH
					
				END -- Finalizada
				
			END -- Cancelada
		
		END -- Caducado
	
	END TRY
	BEGIN CATCH
		SET @error = ERROR_MESSAGE()
		EXECUTE sp_error 'S', @error
	END CATCH
	-- 
END


