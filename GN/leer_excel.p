/* Comprobar que existe el fichero a importar, se tiene que llamar */
DEFINE VARIABLE cFichero AS CHARACTER NO-UNDO.
DEFINE VARIABLE iError AS INTEGER NO-UNDO.
DEFINE VARIABLE cError AS CHARACTER NO-UNDO.

cFichero="C:FicheroExcel.xls".
IF SEARCH(cFichero)=? THEN DO:
    iError=-1.
    cError="No existe el fichero".
    RETURN.
END.

iError=1.
cError="Error indeterminado, no se ha importado".

DEFINE VARIABLE cDescClave AS CHARACTER NO-UNDO.
DEFINE VARIABLE lErrorClave AS LOGICAL NO-UNDO.

DO TRANSACTION ON ERROR UNDO, LEAVE:
    DEFINE VARIABLE chExcel AS COM-HANDLE.
    DEFINE VARIABLE chLibro AS COM-HANDLE.
    DEFINE VARIABLE chHoja AS COM-HANDLE.
    DEFINE VARIABLE iNumLinea AS INTEGER NO-UNDO.

    /* Datos a recuperar */
    DEFINE VARIABLE dCampo1 AS DECIMAL NO-UNDO.
    DEFINE VARIABLE cCampo2 AS CHARACTER NO-UNDO.

    CREATE "Excel.Application" chExcel.
    chLibro = chExcel:Workbooks:OPEN(cFichero) NO-ERROR.
    /* Coger la primera hoja solamente */
    chHoja = chExcel:Sheets:Item(1) NO-ERROR.

    /* Comprobamos que las hojas no esten en blanco */
    IF (chHoja:Cells(1,1):VALUE = ? OR chHoja:Cells(1,1):VALUE = '') THEN DO:
        iError=2.
        cError="La Excel esta en blanco".
        UNDO, LEAVE.
        RETURN.
    END.

    DEFINE VARIABLE lProcesar AS LOGICAL NO-UNDO.
    iNumLinea=2.
    lProcesar=TRUE.
    REPEAT WHILE lProcesar:
        dCampo1 = decimal(chHoja:Cells(iNumLinea,2):VALUE) NO-ERROR.
        cCampo2 = chHoja:Cells(iNumLinea,1):VALUE NO-ERROR.
        IF cCampo2=? OR cCampo2="" THEN DO:
            lProcesar=FALSE.
            iNumLinea = iNumLinea - 2.
        END.
        ELSE DO:
            /* PROCESAR INFORMACION */

            /* Aumentar la linea */
            iNumLinea = iNumLinea + 1.
        END.
    END.
    chLibro:CLOSE(FALSE,,) NO-ERROR. /* cierra archivo sin grabar cambios */
    chExcel:QUIT NO-ERROR.
    RELEASE OBJECT chHoja no-error.
    RELEASE OBJECT chLibro no-error.
    RELEASE OBJECT chExcel no-error.
    chExcel = ?.
    chLibro = ?.
    chHoja = ?.

    IF iError=4 THEN DO:
        UNDO, LEAVE.
        RETURN.
    END.

    /* Todo Correcto */
    iError=0.
    cError="Procesadas: " + STRING(iNumLinea).
END. /* Fin Transaccion */

MESSAGE cError. 
