CREATE PROCEDURE sps_formsweb_guardar 
	@idsesion varchar(max),
	@idform varchar(max),
	@titulo varchar(max),
	@descripcion varchar(max),	
	@minimo int,
	@elementos varchar(max),	
	@opciones varchar(max),
	@fcaducidad date,	
	@validador varchar(max),	
	@comentarios varchar(max)
AS
BEGIN
	declare @error varchar(max)
	declare @idusuarioSESION varchar(max)

	begin try
		execute sp_servicios_validar @idsesion, @@PROCID, @idusuarioSESION output
		
		if @titulo is null execute sp_error 'U', 'Campo titulo requerido.'
		if @descripcion is null execute sp_error 'U', 'Campo descripcion requerido.'	
		if @fcaducidad is null execute sp_error 'U', 'Campo fecha de expiración requerido.'			
		if not @idform is null
		begin
			declare @validadorActual varchar(max) = (select dbo.fn_validador(MAX(fecha)) from bforms where idform = @idform)
			if ISNULL(@validador,'') <> ISNULL(@validadorActual,'') execute sp_error 'U', 'El formulario ha sido modificado concurrentemente en otra sesión.'
		end	
		
		if not @idform is null
		begin
			declare @estatusEditables table(estatus int); 
			insert into @estatusEditables values(0)
			declare @estatus int; select @estatus = estatus from forms where idform = @idform
			if not @estatus in (select estatus from @estatusEditables)
			begin
				set @error = 'El formulario tiene estatus ' + UPPER(dbo.fn_forms_estatus(@estatus)) + ', por lo que no puede ser editado.'
				execute sp_error 'U', @error
			end
		end			
		
		declare @telementos table(
			idformElemento varchar(max),
			elemento int,
			descripcion varchar(max),
			minimo int,
			orden int,
			requerido char(1)
		)
		insert into @telementos
			select
				col1,
				CONVERT(int, NULLIF(col2, '')),
				NULLIF(col3, ''),
				CONVERT(int,NULLIF(col4, '')),				
				CONVERT(int,col5),
				NULLIF(col6, '')
			from fn_table(6,@elementos)
			
		if (select COUNT(*) from @telementos) <= 0 execute sp_error 'U', 'Favor de capturar al menos un elemento.' 
		
		declare @topciones table(
			idformElemento varchar(max),			
			descripcion varchar(max),
			orden int
		)		
		insert into @topciones
			select
				col1,				
				NULLIF(col2, ''),
				CONVERT(int,col3)
			from fn_table(3,@opciones)
			
			
		declare @factual datetime; set @factual = GETUTCDATE()		
		
		begin try
				declare @elemento int, @descripcion2 varchar(max),@minimo2 int, @orden int, @requerido char(1)
				declare @idformElemento_ant int 
				declare @idformElemento varchar(32)
				declare @formsElementos table(
					idformElemento varchar(32),
					elemento int,
					descripcion varchar(max),
					minimo int,
					orden int,
					requerido char(1)
				)
				declare @felementosOpciones table(
					idfelementoOpcion varchar(32),
					idformElemento varchar(32),
					descripcion varchar(max),
					orden int
				)				
				declare @terrores table(error varchar(max))
				
				declare insert_cursor cursor for 
					select idformElemento,elemento,descripcion,minimo,orden,requerido from @telementos
						
				open insert_cursor
					fetch next from insert_cursor into @idformElemento_ant,@elemento,@descripcion2,@minimo2,@orden,@requerido
				while @@FETCH_STATUS=0
				begin
					
					if @descripcion2 is null insert into @terrores values('Favor de capturar la descripción del elemento con orden: '+ cast(@orden+1 as varchar(max)))
					if @orden is null insert into @terrores values('Favor de capturar el orden del elemento con descripcion: '+@descripcion2+'.')
					if @requerido is null insert into @terrores values('Favor de capturar si el elemento con orden:'+ cast(@orden+1 as varchar(max))+' es requerido.')					
					if @elemento is null insert into @terrores values('Favor de capturar el tipo de control del elemento con orden:'+ cast(@orden+1 as varchar(max)))					

					insert into @terrores
					select 
						case 
							when (@elemento=1 or @elemento=2) and descripcion is null then 'Favor de capturar la descripción de la opcion: ' + CAST(orden as varchar(max)) + ' del elemento con orden: '+ cast(@orden+1 as varchar(max))
						end
						from @topciones
						where idformElemento=@idformelemento_ant
							and ((descripcion is null and (@elemento=1 or @elemento=2)) or orden is null)
							
					execute sp_randomKey @idformElemento output
					insert into @formsElementos values(@idformElemento,@elemento,@descripcion2,@minimo2,@orden,@requerido)					
					insert into @felementosOpciones
						select dbo.fn_randomKey(),@idformElemento,descripcion,orden from @topciones
							where idformElemento=@idformelemento_ant

					fetch next from insert_cursor into @idformElemento_ant,@elemento,@descripcion2,@minimo2,@orden,@requerido
				end	
				close insert_cursor
				deallocate insert_cursor	
			
			if (select COUNT(*) from @terrores) > 0 
			begin
				select * from @terrores
			end
			else
			begin						
				begin transaction 
					if @idform is null
					begin
						execute sp_randomKey @idform output
						insert into forms values(@idform,@titulo,@descripcion,@minimo,0,@fcaducidad)
					end
					else
					begin 
						update forms set estatus=0, titulo = @titulo, descripcion=@descripcion , minimo=@minimo, fcaducidad=@fcaducidad
						where idform = @idform and estatus in (select estatus from @estatusEditables)
						
						if @@ROWCOUNT <> 1 execute sp_error 'U', 'El formulario fue modificado  concurrentemente en otra sesión, por lo que no puede ser editada.'					

						delete felementosOpciones from felementosOpciones a 
							inner join formsElementos b on a.idformElemento=b.idformElemento
						where b.idform=@idform
						delete from formsElementos where idform=@idform					
					end	
					
					insert into formsElementos
						select a.idformElemento,@idform,a.elemento,a.descripcion,a.orden,a.minimo,a.requerido from @formsElementos a
					
					insert into felementosOpciones
						select * from @felementosOpciones
					
					insert into bforms values(@idform, @idusuarioSESION, @factual, 0, @comentarios)					
				commit
			end
		end try
		begin catch
			rollback
			set @error = error_message()
			execute sp_error 'S', @error
		end catch
	end try
	begin catch
		set @error = error_message()
		execute sp_error 'S', @error
	end catch
END