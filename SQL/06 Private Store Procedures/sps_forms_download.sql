-- =============================================
-- Author:		ˆWngel Hernˆhndez
-- Create date: 25 Nov 2016
-- Description:	Inicia la descarga del esquema formulario para poder trabajar offline
-- =============================================
CREATE PROCEDURE [dbo].[sps_forms_download] 
	-- Add the parameters for the stored procedure here
	@idSession varchar(MAX)
	, @idForm char(32)
AS
BEGIN
	DECLARE @error      VARCHAR(MAX);
	DECLARE @idUsuario  VARCHAR(32);
	
	DECLARE @INICIADO INT = 0
	
	-- 1= iniciado 2= Descargado 3 = Fallo

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		
		EXECUTE sp_servicios_validar   @idSession, @@PROCID, @idUsuario OUTPUT
		
		-- Registrar el intento de descarga
		INSERT INTO bFormsUsuarios ( idForm , idUsuario , fecha    , estatus   )
							VALUES ( @idForm, @idUsuario, GETDATE(), @INICIADO )
		
		-- Devolver los datos que se van a descargar
		SELECT idform
				, descripcion
				, estatus
				, titulo
				, fcaducidad
		FROM 
			[dbo].[forms]
		WHERE idForm = @idForm;
			
		-- Preguntas
		SELECT idFormElemento
				, elemento
				, descripcion
				, orden
				, requerido
				, minimo
				, row_number() OVER( ORDER BY idFormElemento ) AS row
		INTO #tmpElementos
		FROM
			[dbo].[formsElementos]
		WHERE
			idForm = @idForm
		ORDER BY orden ASC ;
			
			

		SELECT * FROM #tmpElementos;
		
		-- Posibles Respuestas
		SELECT	 idFelementoOpcion
				, opcionesTable.[idFormElemento]
				, opcionesTable.[descripcion]
				, opcionesTable.[orden]
		FROM
			[dbo].[felementosOpciones] AS opcionesTable
		INNER JOIN #tmpElementos AS tmpElementos ON tmpElementos.idFormElemento = opcionesTable.idFormElemento 
		ORDER BY orden ASC;
		
		
		-- Respuestas
		SELECT tmpElementos.[idFormElemento]
				, dbo.fn_trim(dataTable.[idFelementoOpcion]) AS idFelementoOpcion
				, dataTable.[descripcion]
				, dataTable.[fecha]
				, dataTable.[idUsuario]
		FROM #tmpElementos AS tmpElementos
		INNER JOIN [dbo].[fElementosOpciones] AS opcionesTable ON tmpElementos.idFormElemento = opcionesTable.idFormElemento
		INNER JOIN [dbo].[elementsData] AS dataTable ON opcionesTable.idFelementoOpcion = dataTable.idFelementoOpcion AND dataTable.idUsuario = @idUsuario;
		
		
		DROP TABLE #tmpElementos;
		
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @error = ERROR_MESSAGE()
		
		EXECUTE sp_error 'S', @error
	END CATCH
	
END
