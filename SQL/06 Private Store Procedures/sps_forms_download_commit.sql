-- =============================================
-- Author:		Ángel Hernández
-- Create date: 06 Dic 2016
-- Description:	Establece el estatus final a una encuesta despues del proceso de descarga
-- =============================================
CREATE PROCEDURE [dbo].[sps_forms_download_commit] 
	-- Add the parameters for the stored procedure here
	  @idSession char(32)
	, @idForm    char(32)
AS
BEGIN
	DECLARE @error VARCHAR(MAX);
	DECLARE @DESCARGADO INT = 1;
	DECLARE @idUsuario  VARCHAR(32);

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	BEGIN TRY
	
		BEGIN TRANSACTION
		
			EXECUTE sp_servicios_validar   @idSession, @@PROCID, @idUsuario OUTPUT
		
			-- Registrar el intento de descarga
			INSERT INTO bFormsUsuarios ( idForm , idUsuario , fecha    , estatus   )
								VALUES ( @idForm, @idUsuario, GETDATE(), @DESCARGADO )
		
		COMMIT TRANSACTION
	
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @error = ERROR_MESSAGE()
		EXECUTE sp_error 'S', @error
	END CATCH
	-- 
END
