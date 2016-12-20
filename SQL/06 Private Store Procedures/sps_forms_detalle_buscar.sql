-- =============================================
-- Author:		?Wngel Hern?hndez
-- Create date: 30 Sep 2016
-- Description:	Obtiene Forms y su detalle por medio del id
-- =============================================
CREATE PROCEDURE [dbo].[sps_forms_detalle_buscar] 
	-- Add the parameters for the stored procedure here
	  @idSession VARCHAR(MAX)
	, @idForm CHAR(32)
	, @start INT
	, @limit INT
AS
BEGIN
	DECLARE @idUsuario VARCHAR(32);
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	EXECUTE sp_servicios_validar   @idSession, @@PROCID, @idUsuario OUTPUT
		
	-- Preguntas
	SELECT dbo.fn_trim(idFormElemento) AS idFormElemento
			, elemento
			, descripcion
			, orden
			, requerido
			, minimo
			, row_number() OVER( ORDER BY orden ) AS row
	INTO #tmpElementos
	FROM
		formsElementos
	WHERE 
		idForm = @idForm ;
	
	
		
	SELECT * 
	INTO #tmpElementosPaginados
	FROM #tmpElementos
	WHERE  ( [row] > @start OR  @start IS NULL ) AND ( [row] <= @start + @limit OR @start IS NULL )
	ORDER BY orden ASC;
		
	SELECT * FROM #tmpElementosPaginados;
	
	
	-- Posibles Respuestas
	SELECT	 dbo.fn_trim(opcionesTable.idFelementoOpcion) AS idFelementoOpcion
			, dbo.fn_trim(opcionesTable.[idFormElemento]) AS idFormElemento
			, opcionesTable.[descripcion]
			, opcionesTable.[orden]
	FROM
		[dbo].[felementosOpciones] AS opcionesTable
	INNER JOIN #tmpElementosPaginados AS tmpElementos ON tmpElementos.idFormElemento = opcionesTable.idFormElemento
	ORDER BY opcionesTable.orden ASC ;
	
	
	-- Respuestas
	SELECT dbo.fn_trim(tmpElementos.[idFormElemento]) AS idFormElemento
			, dbo.fn_trim(dataTable.idFelementoOpcion) AS idFelementoOpcion
			, dataTable.descripcion
			, dataTable.fecha
	FROM #tmpElementosPaginados AS tmpElementos
		INNER JOIN [dbo].[fElementosOpciones] AS opcionesTable ON tmpElementos.idFormElemento = opcionesTable.idFormElemento
		INNER JOIN [dbo].[elementsData] AS dataTable ON opcionesTable.idFelementoOpcion = dataTable.idFelementoOpcion   AND   idUsuario = @idUsuario
	ORDER BY tmpElementos.orden ASC, opcionesTable.orden ASC;
	
	
	IF ( @start = 0) BEGIN
		-- Elementos Requeridos, estos solo deben enviarse una vez solamente al cliente
		SELECT    dbo.fn_trim(formsElementosTable.idFormElemento) AS idFormElemento
				, COUNT(elementsDataTable.idFelementoOpcion)   AS numRespuestas
				,  MAX( requerido )  AS requerido
				, CAST( MAX( 
							CASE WHEN LEN( ISNULL(elementsDataTable.descripcion, '') + CASE WHEN elementsDataTable.fecha IS NULL THEN 
																							'' 
																						ELSE 
																							CAST(elementsDataTable.fecha AS VARCHAR(9)) 
																						END 
											) > 0  THEN
								1 
							ELSE 
								0 
							END
						
						) AS BIT ) AS respuestaValida
				, MAX([formsElementosTable].minimo) AS minimo
				, MAX(formsElementosTable.orden) AS orden
				, MAX (formsElementosTable.elemento) AS elemento
		FROM [dbo].[formsElementos] AS formsElementosTable 
			INNER JOIN [dbo].[fElementosOpciones] AS opcionesTable ON formsElementosTable.idFormElemento = opcionesTable.idFormElemento
			LEFT JOIN [dbo].[elementsData] AS elementsDataTable ON opcionesTable.idFelementoOpcion = elementsDataTable.idFelementoOpcion
		WHERE  
			idForm = @idForm 
		GROUP BY formsElementosTable.idFormElemento
		ORDER BY orden;
	END
	
	
	DROP TABLE #tmpElementos;
	DROP TABLE #tmpElementosPaginados;
	
	
END


