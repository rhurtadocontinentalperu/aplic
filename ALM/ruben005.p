/* PROGRAMA DE AJUSTE DE TRANSFERENCIAS INCONSISTENTES */

DEF VAR s-codcia AS INT INIT 001.
DEF VAR s-Usuario AS CHAR INIT 'MAY2005' NO-UNDO.
/*
DEF VAR x-NroDoc AS INT INIT 910001 NO-UNDO. /* 9mmnnn */
*/

/* primero: capturamos la informacion en un archivo temporal */
DEF VAR x-Linea AS CHAR FORMAT 'x(100)' NO-UNDO.
DEF TEMP-TABLE t-dmov  LIKE almdmov
    FIELD nrorf1 LIKE almcmov.nrorf1
    FIELD nrorf2 LIKE almcmov.nrorf2.

INPUT FROM c:\tmp\inconsistencias.prn.
REPEAT:
    IMPORT UNFORMATTED x-Linea.
    CREATE t-dmov.
    ASSIGN
        t-dmov.codcia = s-codcia
        t-dmov.codalm = TRIM(SUBSTRING(x-Linea,25,3))
        t-dmov.fchdoc = DATE(INTEGER(SUBSTRING(x-Linea,14,2)),
                                INTEGER(SUBSTRING(x-Linea,11,2)),
                                INTEGER(SUBSTRING(x-Linea,17,4)))
        t-dmov.tipmov = SUBSTRING(x-Linea,45,1)
        t-dmov.codmov = INTEGER(SUBSTRING(x-Linea,55,2))
        t-dmov.nroser = INTEGER(SUBSTRING(x-Linea,65,3))
        t-dmov.nrodoc = INTEGER(SUBSTRING(x-Linea,75,6))
        t-dmov.codmat = SUBSTRING(x-Linea,1,6)
        t-dmov.candes = DECIMAL(SUBSTRING(x-Linea,81,14))
        t-dmov.codund = SUBSTRING(x-Linea,95,3)
        t-dmov.nrorf1 = SUBSTRING(x-Linea,98,13)
        t-dmov.nrorf2 = SUBSTRING(x-Linea,98,12).
END.
INPUT CLOSE.

for each t-dmov by t-dmov.codmat:
    display t-dmov.codcia t-dmov.codalm t-dmov.codmat t-dmov.candes
        t-dmov.fchdoc format '99/99/9999' t-dmov.tipmov t-dmov.codmov
        t-dmov.nroser t-dmov.nrodoc t-dmov.nrorf1 t-dmov.nrorf2
        with stream-io no-labels width 100.
end.

/* segundo: generamos el movimiento de ajuste */
DEF TEMP-TABLE t-almcmov LIKE almcmov.
DEF TEMP-TABLE t-almdmov LIKE almdmov
    FIELD nrorf1 LIKE almcmov.nrorf1
    FIELD nrorf2 LIKE almcmov.nrorf2.
DEF TEMP-TABLE t-almmmatg LIKE almmmatg.

DEF STREAM s-errores.

OUTPUT STREAM s-errores TO c:\tmp\errores.txt.
FOR EACH t-dmov:
    FIND FIRST almdmov OF t-dmov NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almdmov THEN DO:
        DISPLAY STREAM s-errores "REGISTRO NO ENCONTRADO"
            WITH NO-LABELS NO-BOX STREAM-IO.
        DISPLAY STREAM s-errores t-dmov.codalm format 'x(3)' t-dmov.tipmov
            t-dmov.codmov t-dmov.nroser t-dmov.nrodoc
            t-dmov.codmat t-dmov.candes t-dmov.codund
            WITH NO-LABELS NO-BOX STREAM-IO DOWN.
        NEXT.
    END.
    CASE t-dmov.tipmov:
        WHEN 'I' THEN DO:
            CREATE t-almdmov.
            BUFFER-COPY almdmov TO t-almdmov
                ASSIGN 
                    t-almdmov.codmov = 66
                    t-almdmov.nrorf1 = t-dmov.nrorf1
                    t-almdmov.nrorf2 = t-dmov.nrorf2.
            CREATE t-almdmov.
            BUFFER-COPY almdmov TO t-almdmov
                ASSIGN 
                    t-almdmov.codmov = 67
                    t-almdmov.tipmov = 'S'
                    t-almdmov.nrorf1 = t-dmov.nrorf1
                    t-almdmov.nrorf2 = t-dmov.nrorf2.
        END.
        WHEN 'S' THEN DO:
            CREATE t-almdmov.
            BUFFER-COPY almdmov TO t-almdmov
                ASSIGN 
                    t-almdmov.codmov = 66
                    t-almdmov.nrorf1 = t-dmov.nrorf1
                    t-almdmov.nrorf2 = t-dmov.nrorf2.
            CREATE t-almdmov.
            BUFFER-COPY almdmov TO t-almdmov
                ASSIGN 
                    t-almdmov.codmov = 67
                    t-almdmov.tipmov = 'I'
                    t-almdmov.nrorf1 = t-dmov.nrorf1
                    t-almdmov.nrorf2 = t-dmov.nrorf2.
        END.
    END CASE.
END.
OUTPUT STREAM s-errores CLOSE.

/* tercero: generamos las cabeceras para los detalles */
FOR EACH t-almdmov:
    FIND FIRST t-almcmov OF t-almdmov NO-LOCK NO-ERROR.
    IF AVAILABLE t-almcmov THEN NEXT.
    CREATE t-almcmov.
    BUFFER-COPY t-almdmov TO t-almcmov
        ASSIGN 
            t-almcmov.almdes = t-Almdmov.AlmOri
            t-almcmov.usuario = s-Usuario.     /* <<< OJO <<< */
END.

/* cuarto: consistencia */
FOR EACH t-almcmov:
    FIND FIRST almcmov OF t-almcmov NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almcmov THEN NEXT.
    DISPLAY t-almcmov.codalm t-almcmov.tipmov t-almcmov.codmov
        t-almcmov.nroser t-almcmov.nrodoc
        WITH TITLE 'INCONSISTENCIAS'.
END.

FOR EACH t-almdmov:
    FIND t-almcmov OF t-almdmov NO-LOCK NO-ERROR.
    IF NOT AVAILABLE t-almcmov
    THEN DO:
        MESSAGE 'Detalle sin cabecera' VIEW-AS ALERT-BOX ERROR.
        LEAVE.
    END.
END.
MESSAGE 'Procedemos a la actualizacion?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta-1 AS LOG.
IF rpta-1 = NO THEN RETURN.

/* quinto: migramos la informacion */
FOR EACH t-almcmov:
    FIND FIRST almcmov OF t-almcmov NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almcmov 
    THEN DO:
        CREATE almcmov.
        BUFFER-COPY t-almcmov TO almcmov
            ASSIGN almcmov.usuario = s-Usuario.
    END.        
    FOR EACH t-almdmov OF t-almcmov:
        CREATE almdmov.
        BUFFER-COPY t-almdmov TO almdmov.
        FIND t-almmmatg OF t-almdmov NO-LOCK NO-ERROR.
        IF NOT AVAILABLE t-almmmatg
        THEN DO:
            CREATE t-almmmatg.
            BUFFER-COPY t-almdmov TO t-almmmatg.
        END.
    END.
END.

OUTPUT TO c:\tmp\materiales.txt.
FOR EACH t-almmmatg:
    DISPLAY t-almmmatg.codmat WITH NO-LABELS NO-BOX STREAM-IO.
END.
OUTPUT CLOSE.

