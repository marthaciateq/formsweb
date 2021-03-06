-- =============================================
-- Author:		ÃÂÃÂngel HernÃÂÃÂ¡ndez
-- Create date: 23 Dic 2016
-- Description:	Obtiene una lista de las encuestas canceladas, canceldas del servidor
-- =============================================
CREATE PROCEDURE [dbo].[sps_forms_inactive] 
	-- Add the parameters for the stored procedure here
	  @idSession VARCHAR(MAX)
AS
BEGIN
	DECLARE @error VARCHAR(MAX);
	DECLARE @idUsuario VARCHAR(32);
	DECLARE @UPDATE CHAR(1) = 'U';
	DECLARE @DELETE CHAR(1) = 'D';
	DECLARE @NEW    CHAR(1) = 'N';
	DECLARE @FINALIZADO INT  = 2;
	
	DECLARE @CADUCADA BIT = 0;
	DECLARE @CANCELADA BIT = 0;
	DECLARE @idFormUsuario VARCHAR(32)
	

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	BEGIN TRY
	
		EXECUTE sp_servicios_validar   @idSession, @@PROCID, @idUsuario OUTPUT
		
		
		-- Cancelados
		
		SELECT DISTINCT idForm
		FROM bforms
		WHERE idUsuario = @idUsuario AND estatus = 9
		
		UNION
		-- Caducados
		SELECT forms.idForm 
		FROM forms
			INNER JOIN (
				SELECT DISTINCT idForm
				FROM bforms 
				WHERE idUsuario = @idUsuario AND estatus <> 9
			) AS tmpFormsNoCancelados
			ON forms.idForm = tmpFormsNoCancelados.idForm
		WHERE dbo.fn_dateTimeToDate( forms.fcaducidad ) < dbo.fn_dateTimeToDate( GETDATE())
		;
		
		
		
		
	END TRY
	BEGIN CATCH
		
		SET @error = ERROR_MESSAGE()
		EXECUTE sp_error 'S', @error
	END CATCH
	-- 
END



