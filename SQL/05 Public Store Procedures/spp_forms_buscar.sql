CREATE PROCEDURE spp_forms_buscar 
	@buscar varchar(max) = null
AS
BEGIN
	select * 
	from v_forms
	where (@buscar is null or dbo.fn_buscar(@buscar,titulo,null,null,null,null) = 'S') 
		and estatus > 0
	order by titulo
END
