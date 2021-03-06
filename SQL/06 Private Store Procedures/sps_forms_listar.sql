-- =============================================
-- Author:		�ngel Hern�ndez
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
	DECLARE @FINALIZADO INT = 2;
	DECLARE @DESCARGADO INT = 1;
	DECLARE @APROBADA INT = 1;
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @error VARCHAR(MAX)
	
	BEGIN TRY
	
		EXECUTE sp_servicios_validar @idSession, @@PROCID, @idUsuario OUTPUT;
		
		SELECT idForm, MAX(estatus) AS estatus
		INTO #tmpFormsAprobados
		FROM [dbo].[bForms]
		GROUP BY idForm
		HAVING MAX(estatus) = @APROBADA;

		
		
		SELECT idForm, IdUsuario
		INTO #tmpFormsUsuarios
		FROM [dbo].[formsUsuarios] AS formsUsuariosTable
		WHERE idUsuario = @idUsuario;
		
		------ Formulario
		SELECT    formsTable.idForm
				, descripcion
				, formsTable.estatus
				, titulo
				, fcaducidad AS fCaducidad
				, nombres + ' ' + apaterno + ' ' + amaterno AS nombreCompletoCreo
				, ROW_NUMBER() OVER( ORDER BY formsTable.idForm ) AS row
				, ( SELECT COUNT(idformElemento) AS numElementos FROM formsElementos WHERE idForm = formsTable.idForm) AS numElementos
				, 'R' AS origen
				, minimo
		INTO #tmpForms
		FROM 
			[dbo].[forms] AS formsTable
			INNER JOIN #tmpFormsAprobados AS tmpFormsAprobados ON formsTable.idForm = tmpFormsAprobados.idForm
			INNER JOIN #tmpFormsUsuarios AS tmpFormsUsuarios ON tmpFormsAprobados.idForm = tmpFormsUsuarios.idForm 
			INNER JOIN [dbo].[Usuarios] AS usuariosTable ON tmpFormsUsuarios.idUsuario = usuariosTable.idUsuario
		;
			

		

			
		---- Paginaci�n
		SELECT * 
		FROM #tmpForms
		WHERE ( [row] > @start OR  @start IS NULL ) AND ( [row] <= @start + @limit OR @start IS NULL );
			
			
		
		DROP TABLE #tmpFormsAprobados;
		--DROP TABLE #tmpFormsFinalizados;
		DROP TABLE #tmpFormsUsuarios
		DROP TABLE #tmpForms;
	
	END TRY
	BEGIN CATCH
		SET @error = error_message()
		EXECUTE sp_error 'S', @error
	END CATCH
	
END

