-- =============================================
-- Author:		ˆWngel Hernˆhndez
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
	
	DECLARE @FINALIZADO INT  = 2;
	

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	BEGIN TRY
	
		EXECUTE sp_servicios_validar   @idSession, @@PROCID, @idUsuario OUTPUT
	
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
				-- Registrar el intento de descarga
				INSERT INTO bFormsUsuarios ( idForm , idUsuario , fecha    , estatus   )
								VALUES ( @idForm, @idUsuario, GETDATE(), @FINALIZADO )	
			END
			
		
		COMMIT TRANSACTION
	
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @error = ERROR_MESSAGE()
		EXECUTE sp_error 'S', @error
	END CATCH
	-- 
END
