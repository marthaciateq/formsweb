-- =============================================
-- Author:		Jose Angel Hernandez
-- Create date: 07 Dic 2016
-- Description:	Elimina los espacios en blanco a la derecha e izquierda de la cadena
-- =============================================
CREATE FUNCTION [dbo].[fn_trim] 
(
	-- Add the parameters for the function here
	@string VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	-- Return the result of the function
	RETURN LTRIM(RTRIM(@string))

END
