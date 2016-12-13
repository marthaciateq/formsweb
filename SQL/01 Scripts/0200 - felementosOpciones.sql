CREATE TABLE [dbo].[felementosOpciones](
	[idfelementoOpcion] [varchar](32) NOT NULL,
	[idformElemento] [varchar](32) NOT NULL,
	[descripcion] [varchar](max) NOT NULL,
	[orden] [int] NOT NULL,
 CONSTRAINT [PK_felementosOpciones] PRIMARY KEY CLUSTERED 
(
	[idfelementoOpcion] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[felementosOpciones]  WITH CHECK ADD  CONSTRAINT [FK_felementosOpciones_idformElemento] FOREIGN KEY([idformElemento])
REFERENCES [dbo].[formsElementos] ([idformElemento])
GO

ALTER TABLE [dbo].[felementosOpciones] CHECK CONSTRAINT [FK_felementosOpciones_idformElemento]
GO

