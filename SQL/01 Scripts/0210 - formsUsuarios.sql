
CREATE TABLE [dbo].[formsUsuarios](
	[idform] [char](32) NOT NULL,
	[idusuario] [char](32) NOT NULL,
	[finalizado] [bit] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[formsUsuarios]  WITH CHECK ADD  CONSTRAINT [FK_formsUsuarios_idform] FOREIGN KEY([idform])
REFERENCES [dbo].[forms] ([idform])
GO

ALTER TABLE [dbo].[formsUsuarios] CHECK CONSTRAINT [FK_formsUsuarios_idform]
GO

ALTER TABLE [dbo].[formsUsuarios]  WITH CHECK ADD  CONSTRAINT [FK_formsUsuarios_idusuario] FOREIGN KEY([idusuario])
REFERENCES [dbo].[usuarios] ([idusuario])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[formsUsuarios] CHECK CONSTRAINT [FK_formsUsuarios_idusuario]
GO


