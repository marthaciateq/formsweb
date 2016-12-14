-- =============================================
-- Author:		�ngel Hern�ndez
-- Create date: 30 Sep 2016
-- Description:	Obtiene Forms y su detalle por medio del id
-- =============================================
CREATE PROCEDURE [dbo].[sps_forms_detalle_buscar] 
	-- Add the parameters for the stored procedure here
	@idForm char(32)
	, @start int
	, @limit int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		
	-- Preguntas
	SELECT dbo.trim(idFormElemento) AS idFormElemento
			, elemento
			, descripcion
			, orden
			, requerido
			, minimo
			, row_number() OVER( ORDER BY idFormElemento ) AS row
	INTO #tmpElementos
	FROM
		formsElementos
	WHERE 
		idForm = @idForm ;
	
	
		
	SELECT * 
	INTO #tmpElementosPaginados
	FROM #tmpElementos
	WHERE  ( [row] > @start OR  @start IS NULL ) AND ( [row] <= @start + @limit OR @start IS NULL );
		
	SELECT * FROM #tmpElementosPaginados;
	
	
	-- Posibles Respuestas
	SELECT	 dbo.trim(opcionesTable.idFelementoOpcion) AS idFelementoOpcion
			, dbo.trim(opcionesTable.[idFormElemento]) AS idFormElemento
			, opcionesTable.[descripcion]
			, opcionesTable.[orden]
	From
		[dbo].[felementosOpciones] AS opcionesTable
	INNER JOIN #tmpElementosPaginados AS tmpElementos ON tmpElementos.idFormElemento = opcionesTable.idFormElemento ;
	
	
	-- Respuestas
	SELECT dbo.trim(tmpElementos.[idFormElemento]) AS idFormElemento
			, dbo.trim(idFelementoOpcion) AS idFelementoOpcion
			, dataTable.descripcion
			, dataTable.fecha
	FROM #tmpElementosPaginados AS tmpElementos
	INNER JOIN [dbo].[elementsData] AS dataTable ON tmpElementos.idFormElemento = dataTable.idFormElemento;
	
	
	IF ( @start = 0) BEGIN
		-- Elementos Requeridos, estos solo deben enviarse una vez solamente al cliente
		SELECT    dbo.trim(formsElementosTable.idFormElemento) AS idFormElemento
				, COUNT(elementsDataTable.idFormElemento)   AS numRespuestas
				, CAST( MAX( CAST(requerido AS TINYINT ) ) AS BIT )  AS requerido
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
		FROM [dbo].[formsElementos] AS formsElementosTable 
			LEFT JOIN [dbo].[elementsData] AS elementsDataTable ON formsElementosTable.idFormElemento = elementsDataTable.idFormElemento
		WHERE  
			idForm = @idForm 
		GROUP BY formsElementosTable.idFormElemento;
	
	END
	
	
	DROP TABLE #tmpElementos;
	DROP TABLE #tmpElementosPaginados;
	
	
END
