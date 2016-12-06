Mi.Template = function () {
    if (!$("#div_principal").length) {
        $(document.body).children().remove();
        $(document.body).append(
            $('<div id="div_principal" class="container-fluid"></div>').append(
                $('<div id="row_principal" class="row"></div>').append(
                    $('<div id="side-menu" class="col-sm-2 hidden-xs" data-spy="affix" data-offset-top="0"></div>')
               ).append(
                    $('<div id="opciones" class="col-sm-offset-2 col-sm-10"></div>')
               ).append(
                    $('<div id="main" class="col-sm-offset-2 col-sm-10"></>')
               )
            )
        )
    }
}
Mi.Template.acceso = function () {
        Mi.AJAX.request({
            data: [
				{
				    NAME: 'spp_autenticar',
				    login: $("#login").val(),
				    password: $("#password").val()
				},
				{
				    NAME: 'spp_deleted'
				}
            ],
            onsuccess: function (r) {
                var servicios = {}
                for (var i = 0; i < r[1].length; i++)
                    servicios[r[1][i].servicio] = true;
                Mi.Cookie.set('SESIONFORMS', {
                    idsesion: r[0][0].idsesion,
                    login: r[0][0].login,
                    servicios: servicios
                });
                Mi.Cookie.set('SESIONFORMSTABLAS', {
                    deleted: r[2]
                });
                Mi.Template.load();
            }
        });
    $("#login").focus();
}

Mi.Template.oneAutentication = function (onload) {
    //$('#acceso').click(Mi.Template.acceso());
}

Mi.Template.load = function (onload, id, noAutenticacion) {
    if ($.type(onload) != 'function') onload = function () { };
    if (noAutenticacion) {
        Mi.plugin(jQuery);
        Mi.Input.plugin(jQuery);
    	Mi.Template();
    	Mi.Menu.load();
    	onload();
    } else {
        if (Mi.Cookie.exist('SESIONFORMS')) {
            Mi.plugin(jQuery);
            Mi.Input.plugin(jQuery);
            Mi.Template();
    		Mi.Menu.load();
    		onload();
    	} else Mi.Template.oneAutentication(onload);
    }
}

Mi.Template.menuTop = function (opciones,titulo) {
    $('#opciones').append(
        $('<nav id="top-menu" class="navbar navbar-default" role="navigation"></nav>').append(
            $('<div class="navbar-header"><button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse"><span class="sr-only">Desplegar navegación</span><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button><a class="navbar-brand" href="#">'+titulo+'</a></div>')
        ).append(
            $('<div class="collapse navbar-collapse navbar-ex1-collapse"></div>').append(
                $('<ul class="nav navbar-nav navbar-right" id="menuTop"></ul>')
            )
        )
    );
    $("#menuTop").append(
            $('<form class="navbar-form navbar-left" role="search"><div class="form-group"><input id="txtbuscar" type="text" class="form-control" placeholder="Buscar"></div><button id="bbuscar" type="submit" class="btn btn-default">Enviar</button></form>')
    );
    $.each(opciones, function (key, elemento) {
        href = $('<a href="#"><span class="glyphicon '+elemento.img+' aria-hidden="true"></span>' + elemento.label + '</a>');
        href.click(elemento.onclick);
        $('<li></li>').append(href).appendTo($("#menuTop"));
    });
}
