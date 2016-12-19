CREATE PROCEDURE sp_forms_workflow
(
	@idform varchar(max),
	@idusuario varchar(max),
	@operacion varchar(max),	--	'BORRAR', 'REVISAR', 'APROBAR','CANCELAR'
	@validador varchar(max),
	@comentarios varchar(max),
	@id varchar(max)
)
AS
BEGIN
	declare @error varchar(max)	
	begin try
		if @idform is null execute sp_error 'U', 'No se proporcionó el IDENTIFICADOR del formulario.'
		if @idusuario is null execute sp_error 'U', 'No se proporcionó el USUARIO que está borrando el formulario.'
		declare @validadorActual varchar(max) = (select dbo.fn_validador(MAX(fecha)) from bforms where idform = @idform)
		if ISNULL(@validador,'') <> ISNULL(@validadorActual,'') execute sp_error 'U', 'El formulario ha sido modificado concurrentemente en otra sesión.'
		declare @estatusActual int = (select estatus from forms where idform = @idform)
		if @estatusActual is null execute sp_error 'U', 'El formulario no existe.'
		
		declare @estatus int
		declare @estatusActualesPermisibles table(estatus int)
		if @operacion = 'BORRAR' begin
			set @estatus = -1
			insert into @estatusActualesPermisibles values(0)
			if not @estatusActual in (select estatus from @estatusActualesPermisibles) begin
				set @error = 'El formulario tiene estatus ' + UPPER(dbo.fn_forms_estatus(@estatusActual)) + ', por lo que no puede ser BORRADO.'
				execute sp_error 'U', @error
			end
		end else if @operacion = 'APROBAR' begin
			set @estatus = 1
			insert into @estatusActualesPermisibles values(0)
			if not @estatusActual in (select estatus from @estatusActualesPermisibles) begin
				set @error = 'El formulario tiene estatus ' + UPPER(dbo.fn_forms_estatus(@estatusActual)) + ', por lo que no puede ser APROBADO.'
				execute sp_error 'U', @error
			end
		end else if @operacion = 'CANCELAR' begin
			set @estatus = 9
			insert into @estatusActualesPermisibles values(1)
			if not @estatusActual in (select estatus from @estatusActualesPermisibles) begin
				set @error = 'El formulario tiene estatus ' + UPPER(UPPER(dbo.fn_forms_estatus(@estatusActual))) + ', por lo que no puede ser CANCELADO.'
				execute sp_error 'U', @error
			end
		end
		declare @factual datetime; set @factual = GETUTCDATE()

		begin try
			begin transaction
				
				if @operacion = 'BORRAR' 
				begin
					if (select count(*) from formsElementos a
							inner join felementosOpciones b on a.idformElemento=b.idformElemento 
							inner join elementsData c on b.idfelementoOpcion=c.idelementData and a.idform=@idform)>0
					begin
						set @error = 'El formulario tiene respuestas relacionadas por lo que no puede ser BORRADO'					
						execute sp_error 'U', @error
					end
					delete from forms where idform = @idform and estatus in (select estatus from @estatusActualesPermisibles)
				end
				else 
				begin
					update forms set estatus = @estatus where idform = @idform and estatus in (select estatus from @estatusActualesPermisibles) 					
					if @@ROWCOUNT <> 1 execute sp_error 'U', 'El formulario ha sido modificado concurrentemente en otra sesión.'
				end
					insert into bforms values(@idform, @idusuario, @factual, @estatus, @comentarios)					
			commit
		end try
		begin catch
			rollback
			set @error = error_message()
			print @error
			execute sp_error 'S', @error
		end catch
	end try
	begin catch
		set @error = error_message()
		print @error		
		execute sp_error 'S', @error
		
	end catch
END

