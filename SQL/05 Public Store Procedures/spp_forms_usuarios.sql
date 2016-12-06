CREATE PROCEDURE spp_forms_usuarios
	@idusuario varchar(max)
AS
BEGIN
	select a.idform, b.titulo
	from formsUsuarios a inner join forms b on a.idform = b.idform
	where idusuario = @idusuario
END