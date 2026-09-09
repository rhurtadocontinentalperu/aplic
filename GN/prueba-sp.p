
	DEFINE VARIABLE chAppCom                AS COM-HANDLE.
    DEFINE VAR lValor           AS DECIMAL.

    /* create a new Excel Application object */
	/*CREATE "Proceso1.Spee400db2" chAppCom.*/

    CREATE "sp_db2.Speed400db2" chAppCom.

    lValor = chAppCom:GetLineaCredito(1,"0000000230").

    MESSAGE 'Fin de bsqueda ' + string(lValor,"9999.99999") VIEW-AS ALERT-BOX WARNING.

    /* release com-handles */
	RELEASE OBJECT chAppCom NO-ERROR.      



    
