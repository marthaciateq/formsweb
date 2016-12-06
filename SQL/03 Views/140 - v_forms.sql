CREATE VIEW v_forms (
	idform,
	titulo,
	descripcion,
	minimo,
	fcaducidad,
	estatus,
	estado
) AS
	select 
		a.idform,
		a.titulo,
		a.descripcion,
		a.minimo,
		dbo.fn_datetimeToString(fcaducidad,1) fcaducidad,
		a.estatus,
		dbo.fn_forms_estatus(a.estatus) estatus
	from forms a
