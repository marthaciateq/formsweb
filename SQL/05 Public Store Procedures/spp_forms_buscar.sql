CREATE PROCEDURE spp_forms_buscar 
	@buscar varchar(max) = null,
	@estados varchar(max) = null
AS
BEGIN
	select * 
	from v_forms
	where (@buscar is null or dbo.fn_buscar(@buscar,titulo,null,null,null,null) = 'S') 
		and (estatus is null or estatus in(select col1 from dbo.fn_table(1,@estados)))
	order by titulo
END
