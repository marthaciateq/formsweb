-- =============================================
-- Author:		�ngel Hern�ndez
-- Create date: 25 Nov 2016
-- Description:	Inicia la descarga del esquema formulario para poder trabajar offline
-- =============================================
CREATE PROCEDURE sps_forms_download
	-- Add the parameters for the stored procedure here
	@idSession varchar(MAX)
	, @idForm char(32)
AS
BEGIN
	DECLARE @error      VARCHAR(MAX);
	DECLARE @idUsuario  VARCHAR(32);
	DECLARE @idFormDescarga CHAR(32);
	
	DECLARE @INICIADO INT = 1
	DECLARE @FALLO INT = 2
	
	-- 1= iniciado 2= Descargado 3 = Fallo

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		
		EXECUTE sp_servicios_validar   @idSession, @@PROCID, @idUsuario OUTPUT
		-- 
		EXECUTE sp_randomKey @idFormDescarga OUTPUT
		
		-- Registrar el intento de descarga
		INSERT INTO formsDescargas ( idFormDescarga , idForm , idUsuario , fecha    , estatus   )
							VALUES ( @idFormDescarga, @idForm, @idUsuario, GETDATE(), @INICIADO )
		
		-- Devolver los datos que se van a descargar
		SELECT idform
				, descripcion
				, estatus
				, titulo
				, fcaducidad
				-- Campo de referencia
				, @idFormDescarga AS idFormDescarga
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
			idForm = @idForm ;
			
			

		SELECT * FROM #tmpElementos;
		
		-- Posibles Respuestas
		SELECT	 idFelementoOpcion
				, opcionesTable.[idFormElemento]
				, opcionesTable.[descripcion]
				, opcionesTable.[orden]
		FROM
			[dbo].[felementosOpciones] AS opcionesTable
		Inner Join #tmpElementos AS tmpElementos ON tmpElementos.idFormElemento = opcionesTable.idFormElemento ;
		
		
		-- Respuestas
		SELECT tmpElementos.[idFormElemento]
				, dbo.trim(dataTable.[idFelementoOpcion]) AS idFelementoOpcion
				, dataTable.[descripcion]
				, dataTable.[fecha]
				, dataTable.[idUsuario]
		FROM #tmpElementos AS tmpElementos
		Inner Join [dbo].[elementsData] AS dataTable ON tmpElementos.idFormElemento = dataTable.idFormElemento;
		
		
		DROP TABLE #tmpElementos;
		
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @error = ERROR_MESSAGE()
		
		UPDATE formsDescargas SET estatus = @FALLO WHERE idFormDescarga = @idFormDescarga;
		
		EXECUTE sp_error 'S', @error
	END CATCH
	
END
