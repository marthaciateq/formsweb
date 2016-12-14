CREATE TABLE bformsUsuarios(
	idform char(32) NOT NULL,
	idusuario char(32) NOT NULL,
	estatus int NOT NULL, --(0)Solicitud de descarga, (1)Finalización de descarga, (2)Formulario finalizado
	fecha datetime NOT NULL,
	CONSTRAINT CK_bformsUsuarios_estado CHECK (estatus in (0,1,2))
)
GO

CREATE INDEX IX_bformsUsuarios_idform on bformsUsuarios(idform)

