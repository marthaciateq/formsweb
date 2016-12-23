CREATE TABLE elementsData(
	idelementData char(32) NOT NULL,
	idfelementoOpcion char(32) NOT NULL,
	idFormUsuario char(32) NOT NULL,
	descripcion varchar(512) NULL,
	fecha datetime NULL,
	CONSTRAINT elementsData_idelementData PRIMARY KEY(idelementData)
) 
GO

ALTER TABLE elementsData ADD CONSTRAINT FK_elementsData_idfelementoOpcion FOREIGN KEY(idfelementoOpcion)
REFERENCES felementosOpciones (idfelementoOpcion)
GO

ALTER TABLE elementsData ADD CONSTRAINT FK_elementsData_idformusuario FOREIGN KEY(idFormUsuario)
REFERENCES bformsUsuarios(idFormUsuario)
GO