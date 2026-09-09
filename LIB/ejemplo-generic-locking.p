
DEF BUFFER bAlmacen FOR Almacen.
DEF VAR pMensaje AS CHAR NO-UNDO.

RLOOP:
FOR EACH bAlmacen NO-LOCK WHERE bAlmacen.codcia = 999.
    DO TRANSACTION ON ERROR UNDO, THROW:
        {lib/generic-locking.i ~
            &TableName="Almacen" ~
            &Condition="(Almacen.codcia = bAlmacen.codcia AND Almacen.codalm = bAlmacen.codalm)" ~
            &VarMessage="pMensaje" ~
            &VarScope="FIRST" ~
            &TypeLocking="EXCLUSIVE-LOCK NO-WAIT" ~
            }
        /* El control del error es a través de "pMensaje" */
        IF pMensaje > '' THEN NEXT RLOOP.

        ASSIGN Almacen.corrsal = 2.
    END.
    DISPLAY "REGISTRO ACTUALIZADO:" ALMACEN.CODALM LOCKED(Almacen). PAUSE 0.
END.

