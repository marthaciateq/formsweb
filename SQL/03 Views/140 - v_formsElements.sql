CREATE VIEW v_formsElementos (
	idform,
	idformElemento,
	elemento,
	descripcionElemento,
	minimoElemento,
	ordenElemento,
	requerido,
	descripcionOpcion,
	ordenOpcion
) AS
	select 
		a.idform,
		a.idformElemento,
		a.elemento,
		a.descripcion,
		a.minimo,
		a.orden,
		a.requerido,
		b.descripcion,
		b.orden
	from formsElementos a
		left join felementosOpciones  b on a.idformElemento=b.idformElemento
