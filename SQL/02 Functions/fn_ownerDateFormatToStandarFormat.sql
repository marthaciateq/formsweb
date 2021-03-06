-- =============================================
-- Author:		Jose Angel Hernandez
-- Create date: 07 Dic 2016
-- Description:	Parsea una fecha expresada en formato YYYY-MM-DD,H.M.S.m al formato estandar YYYY-MM-DD H:M:S:m
-- =============================================
CREATE FUNCTION [dbo].[fn_ownerDateFormatToStandarFormat] 
(
	-- Add the parameters for the function here
	@ownerFormat VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	-- Declare the return variable here
	
	RETURN REPLACE(REPLACE(REPLACE(@ownerFormat,'UTC:', ''), ',', ' '), '.', ':');

END