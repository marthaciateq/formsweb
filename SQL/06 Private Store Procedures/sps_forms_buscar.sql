CREATE PROCEDURE sps_forms_buscar 
	@idsesion varchar(max),
	@buscar varchar(max) = null,
	@titulo varchar(max)= null,
	@finicio date=null,
	@ffinal date=null,
	@estados varchar(max)
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
				and (@finicio is null or fcaducidad>=@finicio)		
				and (@ffinal is null or fcaducidad<=@finicio)	
				and (@estados is null or estado in (select col1 from dbo.fn_table(1,@estados)) )							
		order by a.titulo		

	end try
	begin catch
		set @error = error_message()
		execute sp_error 'S', @error
	end catch
END