CREATE TABLE felementosOpciones(
	idfelementoOpcion varchar(32),
	idformElemento varchar(32),
	descripcion varchar(max),
	orden int NOT NULL,
	CONSTRAINT PK_felementosOpciones PRIMARY KEY (idfelementoOpcion)
)
GO

ALTER TABLE felementosOpciones ADD CONSTRAINT FK_felementosOpciones_idformElemento FOREIGN KEY(idformElemento)
REFERENCES formsElementos(idformElemento)
GO