CREATE TABLE [dbo].[formsElementos](
	[idformElemento] [varchar](32) NOT NULL,
	[idform] [char](32) NOT NULL,
	[elemento] [int] NOT NULL,
	[descripcion] [varchar](max) NOT NULL,
	[orden] [int] NOT NULL,
	[minimo] [int] NOT NULL,
	[requerido] [bit] NULL,
 CONSTRAINT [PK_formsElementos] PRIMARY KEY CLUSTERED 
(
	[idformElemento] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[formsElementos]  WITH CHECK ADD  CONSTRAINT [FK_formsElementos_idform] FOREIGN KEY([idform])
REFERENCES [dbo].[forms] ([idform])
GO

ALTER TABLE [dbo].[formsElementos] CHECK CONSTRAINT [FK_formsElementos_idform]
GO

ALTER TABLE [dbo].[formsElementos]  WITH CHECK ADD  CONSTRAINT [CK_formsElementos_elemento] CHECK  (([elemento]=(7) OR [elemento]=(6) OR [elemento]=(5) OR [elemento]=(4) OR [elemento]=(3) OR [elemento]=(2) OR [elemento]=(1) OR [elemento]=(0)))
GO

ALTER TABLE [dbo].[formsElementos] CHECK CONSTRAINT [CK_formsElementos_elemento]
GO


