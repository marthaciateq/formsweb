
-- =============================================
-- Author:		Ángel Hernández
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
	

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	BEGIN TRY
	
		EXECUTE sp_servicios_validar   @idSession, @@PROCID, @idUsuario OUTPUT
	
		BEGIN TRANSACTION
		
			SELECT    col1 AS idElementoOpcion
					, col2 AS idFormElemento
					, col3 AS descripcion
					, CAST(dbo.ownerDateFormatToStandarFormat(col4) AS DATETIME) AS fecha
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
				INNER JOIN #tmpUserDataTable AS tmpUserDataTable ON elementsDataTable.idFormElemento = tmpUserDataTable.idFormElemento
																AND elementsDataTable.idElementoOpcion = tmpUserDataTable.idElementoOpcion
			WHERE tmpUserDataTable.[action] = @UPDATE AND elementsDataTable.idUsuario = @idUsuario;
			
			
			DELETE elementsDataTable
			FROM
				[dbo].[elementsData] AS elementsDataTable
				INNER JOIN #tmpUserDataTable AS tmpUserDataTable ON elementsDataTable.idFormElemento = tmpUserDataTable.idFormElemento
																AND elementsDataTable.idElementoOpcion = tmpUserDataTable.idElementoOpcion
			WHERE tmpUserDataTable.[action] = @DELETE AND elementsDataTable.idUsuario = @idUsuario;
			
			
			INSERT INTO [dbo].[elementsData](idFormElemento, idElementoOpcion, descripcion, fecha, idUsuario)
			SELECT idFormElemento, idElementoOpcion, descripcion,  CASE WHEN fecha = '' THEN NULL ELSE fecha END, @idUsuario
			FROM #tmpUserDataTable
			WHERE [action] = @NEW;
			
			DROP TABLE #tmpUserDataTable;
			
			-- Si se solicitó finalizar la encuesta, entonces se marca.
			IF ( @finalizar = 1 )
				UPDATE [dbo].[formsUsuarios] SET finalizado = 1   WHERE   idForm = @idForm   AND   idUsuario = @idUsuario;
				
		
		COMMIT TRANSACTION
	
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @error = ERROR_MESSAGE()
		EXECUTE sp_error 'S', @error
	END CATCH
	-- 
END
