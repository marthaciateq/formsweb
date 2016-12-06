CREATE PROCEDURE sps_formsElementos_buscar 
	@idsesion varchar(max),
	@buscar varchar(max) = null,
	@idform varchar(32) = null
AS
BEGIN
	declare @error varchar(max)
	declare @idusuarioSESION varchar(max)
	declare @idempresaSESION varchar(max)
	
	begin try
		execute sp_servicios_validar @idsesion, @@PROCID, @idusuarioSESION output
		select
			a.*
		from v_formsElementos a
		where (@buscar is null or dbo.fn_buscar(@buscar, a.descripcionElemento, a.descripcionOpcion, null, null, null) = 'S') 
			and (@idform is null or a.idform=@idform)
		order by a.idform,a.ordenElemento,a.ordenOpcion
	end try
	begin catch
		set @error = error_message()
		execute sp_error 'S', @error
	end catch
END