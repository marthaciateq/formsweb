CREATE TABLE formsElementos(
	idformElemento char(32) NOT NULL,
	idform char(32) NOT NULL,
	elemento int NOT NULL, -- 0 Cuadro de texto, 1 Radio Button, 2 Checkbox, 3 Fecha, 4 Hora
	descripcion varchar(max) NOT NULL,
	orden int NOT NULL,
	minimo int,
	requerido char(1) NULL,
	CONSTRAINT PK_formsElementos PRIMARY KEY (idformElemento),
	CONSTRAINT CK_formsElementos_element CHECK (elemento in (0,1,2,3,4,5))
)
GO

ALTER TABLE formsElementos ADD  CONSTRAINT FK_formsElementos_idform FOREIGN KEY(idform)
REFERENCES forms (idform) ON DELETE CASCADE
GO



