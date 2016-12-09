
-- =============================================
-- Author:		Ángel Hernández
-- Create date: 06 Dic 2016
-- Description:	Establece el estatus final a una encuesta despues del proceso de descarga
-- =============================================
CREATE PROCEDURE [dbo].[spp_forms_download_commit] 
	-- Add the parameters for the stored procedure here
	@idFormDescarga char(32)
AS
BEGIN
	DECLARE @error VARCHAR(MAX);
	DECLARE @DESCARGADO INT = 2;

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	BEGIN TRY
	
		--EXECUTE sp_servicios_validar   @idSession, @@PROCID, @idUsuario OUTPUT
	
		BEGIN TRANSACTION
		
			UPDATE formsDescargas SET estatus = @DESCARGADO WHERE idFormDescarga = @idFormDescarga;
		
		COMMIT TRANSACTION
	
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @error = ERROR_MESSAGE()
		EXECUTE sp_error 'S', @error
	END CATCH
	-- 
END
