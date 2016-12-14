CREATE TABLE felementosOpciones(
	idfelementoOpcion char(32) NOT NULL,
	idformElemento char (32) NOT NULL,
	descripcion varchar(max),
	orden int,
	CONSTRAINT PK_felementosOpciones PRIMARY KEY (idfelementoOpcion)
)
GO

ALTER TABLE felementosOpciones ADD CONSTRAINT FK_felementosOpciones_idformElement FOREIGN KEY(idformElemento)
REFERENCES formsElementos (idformElemento)
GO

