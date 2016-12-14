CREATE TABLE formsUsuarios(
	idform char(32) NOT NULL,
	idusuario char(32) NOT NULL,
	CONSTRAINT forms_idform PRIMARY KEY(idform)
) 
GO


ALTER TABLE formsUsuarios ADD  CONSTRAINT FK_formsUsuarios_idform FOREIGN KEY(idform)
REFERENCES forms (idform)
GO


ALTER TABLE formsUsuarios  ADD  CONSTRAINT FK_formsUsuarios_idusuario FOREIGN KEY(idusuario)
REFERENCES usuarios(idusuario)
GO



