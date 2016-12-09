CREATE TABLE [dbo].[formsDescargas](
	[idFormDescarga] [char](32) NOT NULL,
	[idForm] [char](32) NOT NULL,
	[idUsuario] [char](32) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[estatus] [int] NOT NULL,
 CONSTRAINT [PK_formsDescargas] PRIMARY KEY CLUSTERED 
(
	[idFormDescarga] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


