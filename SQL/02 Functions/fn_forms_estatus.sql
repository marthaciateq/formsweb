CREATE FUNCTION fn_forms_estatus
(
	@estatus int
)
RETURNS varchar(max)
AS
BEGIN
	if @estatus = -1 return 'Borrada'
	if @estatus = 0 return 'Generada'
	if @estatus = 1 return 'Aprobada'
	if @estatus = 9 return 'Cancelada'
	return ''
END
