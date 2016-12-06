CREATE PROCEDURE sps_forms_buscar 
	@idsesion varchar(max),
	@buscar varchar(max) = null
AS
BEGIN
	declare @error varchar(max)
	declare @idusuarioSESION varchar(max)
	declare @idempresaSESION varchar(max)
	
	begin try
		execute sp_servicios_validar @idsesion, @@PROCID, @idusuarioSESION output
		select
			a.*,
			(select dbo.fn_validador(MAX(fecha)) from bforms where idform = a.idform) validador			
		from v_forms a
		where (@buscar is null or dbo.fn_buscar(@buscar, a.titulo, null, null, null, null) = 'S') 
		order by a.titulo
	end try
	begin catch
		set @error = error_message()
		execute sp_error 'S', @error
	end catch
END