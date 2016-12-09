-- =============================================
-- Author:		Ángel Hernández
-- Create date: 06 Oct 2016
-- Description:	Obtiene un listado de los forms que tiene asignados el usuario
-- =============================================
CREATE PROCEDURE [dbo].[sps_forms_listar] 
	-- Add the parameters for the stored procedure here
	  @idSession varchar(MAX)
	, @start int
	, @limit int
AS
BEGIN
	DECLARE @idUsuario VARCHAR(MAX);
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @error VARCHAR(MAX)
	
	BEGIN TRY
	
		EXECUTE sp_servicios_validar @idSession, @@PROCID, @idUsuario OUTPUT;

		-- Formulario
		SELECT    formsTable.idForm
				, descripcion
				, formsTable.estatus
				, titulo
				, fcaducidad AS fCaducidad
				, formsUsuariosTable.finalizado
				, nombres + ' ' + apaterno + ' ' + amaterno AS nombreCompletoCreo
				, ROW_NUMBER() OVER( ORDER BY formsTable.idForm ) AS row
				, ( SELECT COUNT(idformElemento) AS numElementos FROM formsElementos WHERE idForm = formsTable.idForm) AS numElementos
				, ( SELECT MAX(fecha) FROM formsDescargas WHERE idForm = formsTable.idForm AND idUsuario = @idUsuario) AS fechaDescarga 
		INTO #tmpForms
		FROM 
			[dbo].[forms] AS formsTable
			INNER JOIN [dbo].[bforms] AS bitacoraTable ON bitacoraTable.idForm = formsTable.idForm
			INNER JOIN [dbo].[usuarios] AS usuariosTable ON bitacoraTable.idUsuario = usuariosTable.idUsuario
			INNER JOIN [dbo].[formsUsuarios] AS formsUsuariosTable ON formsTable.idForm = formsUsuariosTable.idForm
		WHERE
			formsUsuariosTable.idUsuario = @idUsuario  AND formsUsuariosTable.finalizado = 0;
			

			
		-- Paginación
		SELECT * 
		FROM #tmpForms
		WHERE ( [row] > @start OR  @start IS NULL ) AND ( [row] <= @start + @limit OR @start IS NULL );
			
			
		DROP TABLE #tmpForms;
	
	
	END TRY
	BEGIN CATCH
		SET @error = error_message()
		EXECUTE sp_error 'S', @error
	END CATCH
	
END
