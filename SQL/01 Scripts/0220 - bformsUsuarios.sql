CREATE TABLE bformsUsuarios(
    idFormUsuario char(32) NOT NULL,
	idform char(32) NOT NULL,
	idusuario char(32) NOT NULL,
	estatus int NOT NULL,  --(0)Solicitud de descarga, (1)Finalización de descarga, (2)Formulario finalizado
	fecha datetime NOT NULL,
	latitud decimal(18, 10) NOT NULL,
	longitud decimal(18, 10) NOT NULL,

    CONSTRAINT PK_bformsUsuarios PRIMARY KEY (idFormUsuario),
	CONSTRAINT CK_bformsUsuarios_estado CHECK (estatus in (0,1,2))
)
GO

