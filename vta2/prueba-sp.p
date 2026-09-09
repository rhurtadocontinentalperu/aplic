
	DEFINE VARIABLE chAppCom                AS COM-HANDLE.
    DEFINE VAR lValor           AS CHAR.

    /* create a new Excel Application object */
	/*CREATE "Proceso1.Spee400db2" chAppCom.*/

    CREATE "sp_db2.Speed400db2" chAppCom.

    lValor = chAppCom:GetPuedeAnular(1,"FC", "099010807").

    MESSAGE lvalor.

    /* release com-handles */
	RELEASE OBJECT chAppCom NO-ERROR.      



    
