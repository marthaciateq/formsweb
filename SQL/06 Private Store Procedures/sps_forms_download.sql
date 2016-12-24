-- =============================================
-- Author:		?Wngel Hern?hndez
-- Create date: 25 Nov 2016
-- Description:	Inicia la descarga del esquema formulario para poder trabajar offline
-- =============================================
CREATE PROCEDURE [dbo].[sps_forms_download] 
	-- Add the parameters for the stored procedure here
	@idSession varchar(MAX)
	, @idForm char(32)
	, @latitud   DECIMAL(18, 10)
	, @longitud  DECIMAL(18, 10)
AS
BEGIN
	DECLARE @error      VARCHAR(MAX);
	DECLARE @idUsuario  VARCHAR(32);
	
	DECLARE @INICIADO INT = 0;
	DECLARE @CADUCADA BIT = 0;
	DECLARE @CANCELADA BIT = 0;
	
	-- 1= iniciado 2= Descargado 3 = Fallo

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		
		EXECUTE sp_servicios_validar   @idSession, @@PROCID, @idUsuario OUTPUT
		
		SELECT @CADUCADA = CASE WHEN( dbo.fn_dateTimeToDate( GETDATE()) > dbo.fn_dateTimeToDate( fcaducidad ) ) THEN 1 ELSE 0 END FROM [dbo].[forms] WHERE idForm = @idForm;
		
		IF ( @CADUCADA = 1 ) 
			execute sp_error 'U', 'No es posible descargar la encuesta porque ya ha caducado.'
		ELSE BEGIN
			SELECT @CANCELADA = CASE WHEN estatus = 9 THEN 1 ELSE 0 END FROM forms WHERE idForm = @idForm;
		
			IF ( @CANCELADA = 1 )
				execute sp_error 'U', 'No es posible descargar la encuesta porque ha sido cancelada por el enviador.'
			ELSE BEGIN
				BEGIN TRY
				BEGIN TRANSACTION;
			
					-- Registrar el intento de descarga
					INSERT INTO bFormsUsuarios ( idFormUsuario     , idForm , idUsuario , fecha    , estatus    , latitud , longitud )
										VALUES ( dbo.fn_randomKey(), @idForm, @idUsuario, GETDATE(), @INICIADO, @latitud, @longitud )										
					
					-- Devolver los datos que se van a descargar
					SELECT idForm
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
							, row_number() OVER( ORDER BY orden ) AS row
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
					ORDER BY tmpElementos.orden ASC, opcionesTable.orden ASC;
					
					
					------ Respuestas
					----SELECT tmpElementos.[idFormElemento]
					----		, dbo.fn_trim(dataTable.[idFelementoOpcion]) AS idFelementoOpcion
					----		, dataTable.[descripcion]
					----		, dataTable.[fecha]
					----		, dataTable.[idUsuario]
					----FROM #tmpElementos AS tmpElementos
					----INNER JOIN [dbo].[fElementosOpciones] AS opcionesTable ON tmpElementos.idFormElemento = opcionesTable.idFormElemento
					----INNER JOIN [dbo].[elementsData] AS dataTable ON opcionesTable.idFelementoOpcion = dataTable.idFelementoOpcion AND dataTable.idUsuario = @idUsuario;
					
					
					
					DROP TABLE #tmpElementos;
				
				COMMIT TRANSACTION;
				
				END TRY
				BEGIN CATCH
					ROLLBACK TRANSACTION;
					SET @error = ERROR_MESSAGE();
					
					EXECUTE sp_error 'S', @error;
				END CATCH
				
			END -- Cancelada
		
		END -- Caducado
		
	END TRY
	BEGIN CATCH
		SET @error = ERROR_MESSAGE();
		
		EXECUTE sp_error 'S', @error;
	END CATCH
	
END



