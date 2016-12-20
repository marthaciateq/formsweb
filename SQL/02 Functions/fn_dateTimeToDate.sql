-- ============================================================================================================================================
-- Author: Angel Hernandez
-- Create date: Dic 2016
-- Description:	Función que recibe como parámetro un tipo Datetime y le quita la parte Tiempo.
--				Retornando el dato como: 2014-10-22 00:00:00.000
-- ============================================================================================================================================
CREATE FUNCTION [dbo].[fn_dateTimeToDate] 
(
	@fecha datetime		--Fecha a establecer
)
RETURNS datetime
AS
BEGIN
	return convert(datetime,convert(varchar(max),@fecha,111),111)
END
