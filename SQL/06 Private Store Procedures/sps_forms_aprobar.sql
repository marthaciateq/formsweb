CREATE PROCEDURE sps_forms_aprobar
	@idsesion varchar(max),
	@forms varchar(max),
	@comentarios varchar(max)
AS
BEGIN
	declare @error varchar(max)
	declare @idusuarioSESION varchar(max)
	begin try
		execute sp_servicios_validar @idsesion, @@PROCID, @idusuarioSESION output
		declare @terrores table(idform varchar(max), error varchar(max))
		declare @idform varchar(max)
		declare @validador varchar(max)
		declare cursor1 cursor fast_forward for select col1, col2 from fn_table(2,@forms)
		open cursor1
		fetch cursor1 into @idform, @validador
		while @@FETCH_STATUS = 0
		begin
			begin try
				execute sp_forms_workflow @idform, @idusuarioSesion, 'APROBAR', @validador, @comentarios, null
			end try
			begin catch
				set @error = dbo.fn_error(error_message())
				if @error is null set @error = dbo.fn_error(error_message())
				insert into @terrores values(@idform, @error)
			end catch
			fetch cursor1 into @idform, @validador
		end
		close cursor1
		deallocate cursor1
		select * from @terrores
	end try
	begin catch
		set @error = error_message()
		execute sp_error 'S', @error
	end catch
END