-- =============================================
-- Author:		Ángel Hernández
-- Create date: 12 Dic 2016
-- Description:	Finaliza la encuesta
-- =============================================
CREATE PROCEDURE sps_forms_finalizar
	-- Add the parameters for the stored procedure here
	  @idSession VARCHAR(MAX)
	, @idForm    CHAR(32)
	, @datos     VARCHAR(MAX)
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
			-- Eliminar las respuestas que se encuentren en la DB remota ya que serán reemplazadas por los datos que vienen de la DB local
			
			DELETE dataTable 
			FROM [dbo].[formsElementos] AS elementosTable
				INNER JOIN [dbo].[elementsData] AS dataTable ON elementosTable.idFormElemento = dataTable.idFormElemento
			WHERE dataTable.idUsuario = @idUsuario;
		
		
			SELECT    col1 AS idFelementoOpcion
					, col2 AS idFormElemento
					, col3 AS descripcion
					, CAST(dbo.ownerDateFormatToStandarFormat(col4) AS DATETIME) AS fecha
			INTO #tmpUserDataTable
			FROM fn_table(4, @datos) AS userDataTable;
			
			-- Insertar los datos que vienen de la DB local
			INSERT INTO [dbo].[elementsData](idFormElemento, idFelementoOpcion, descripcion, fecha, idUsuario)
			SELECT idFormElemento, idFelementoOpcion, descripcion,  CASE WHEN fecha = '' THEN NULL ELSE fecha END, @idUsuario
			FROM #tmpUserDataTable;
			
			DROP TABLE #tmpUserDataTable;
		
			-- Marcar de finalizado
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
