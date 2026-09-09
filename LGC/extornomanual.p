DEF VAR s-codcia AS INT INIT 001 NO-UNDO.
DEF VAR s-user-id AS CHAR INIT 'ADMIN' NO-UNDO.
DEF VAR pPeriodo AS CHAR NO-UNDO.
DEF VAR pMeses AS CHAR NO-UNDO.
DEF VAR pMes AS CHAR NO-UNDO.
DEF VAR s-codalm AS CHAR NO-UNDO.
DEF VAR s-coddiv AS CHAR NO-UNDO.

pMeses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre".

DISABLE TRIGGERS FOR LOAD OF integral.Almcmov.
DISABLE TRIGGERS FOR LOAD OF integral.Almdmov.
DISABLE TRIGGERS FOR LOAD OF cissac.Almcmov.
DISABLE TRIGGERS FOR LOAD OF cissac.Almdmov.
DISABLE TRIGGERS FOR LOAD OF integral.lg-cocmp.
DISABLE TRIGGERS FOR LOAD OF integral.lg-docmp.
DISABLE TRIGGERS FOR LOAD OF cissac.Faccpedi.
DISABLE TRIGGERS FOR LOAD OF cissac.Facdpedi.
DISABLE TRIGGERS FOR LOAD OF cissac.Ccbcdocu.
DISABLE TRIGGERS FOR LOAD OF cissac.Ccbddocu.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 1ro Extornamos los movimientos de salida de Continental */
    RUN extorno-conti-cissac-salida-conti NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE "ERROR" + CHR(10) +
            "NO se pudo extornar los movimientos de transferencias y devoluciones en Continental".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    MESSAGE 'paso 1 ok'.

    /* 2do Generamos los movimientos de ingresos en Cissac */
    RUN extorno-conti-cissac-ingreso-cissac NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE "ERROR" + CHR(10) +
            "NO se pudo extornar los movimientos de ingresos en Cissac".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    MESSAGE 'paso 2 ok'.

    /* 3ro Generamos la venta de Cissac a Continental */
    RUN extorno-conti-cissac-venta-cissac-conti NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE "ERROR" + CHR(10) +
            'NO se pudo extornar los movimientos de devoluciones en Cissac'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    MESSAGE 'paso 3 ok'.

    /* 4to Generamos los movimientos de ingreso a Continental */
    RUN extorno-conti-cissac-transfer-conti NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE "ERROR" + CHR(10) +
            'NO se pudo extornar los movimientos de salidas-ingreso por transferencia en Continental'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    MESSAGE 'paso 4 ok'.

END.
MESSAGE 'Proceso terminado con éxito' VIEW-AS ALERT-BOX INFORMATION.


PROCEDURE extorno-conti-cissac-salida-conti:

    trloop:
    DO TRANSACTION ON ERROR UNDO, RETURN ON STOP UNDO, RETURN ERROR:
        FOR EACH integral.Almacen NO-LOCK WHERE integral.Almacen.codcia = s-codcia:
            FOR EACH integral.Almcmov WHERE integral.Almcmov.codcia = s-codcia
                AND integral.Almcmov.codalm = integral.Almacen.codalm
                AND integral.Almcmov.nrorf3 = '201312'
                AND integral.Almcmov.coddoc = "DEVCOCI":
                FOR EACH integral.Almdmov OF integral.Almcmov:
                    DELETE integral.Almdmov.
                END.
                ASSIGN
                     INTEGRAL.Almcmov.FlgEst = "A".
            END.
        END.
    END.

END PROCEDURE.

PROCEDURE extorno-conti-cissac-ingreso-cissac:
    trloop:
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
        FOR EACH cissac.Almcmov WHERE cissac.Almcmov.codcia = s-codcia
            AND cissac.Almcmov.codalm = "21"
            AND cissac.Almcmov.tipmov = "I"
            AND cissac.Almcmov.codmov = 09
            AND cissac.Almcmov.coddoc = "DEVCOCI"
            AND cissac.Almcmov.nrorf3 = '201312':
            FOR EACH cissac.Ccbcdocu WHERE cissac.Ccbcdocu.codcia = s-codcia
                AND cissac.Ccbcdocu.coddoc = "N/C"
                AND cissac.Ccbcdocu.codalm = cissac.Almcmov.codalm
                AND cissac.Ccbcdocu.codmov = cissac.Almcmov.codmov
                AND INTEGER(cissac.Ccbcdocu.nroped) = cissac.Almcmov.nrodoc:
                ASSIGN
                    cissac.Ccbcdocu.flgest = "A".
            END.
            FOR EACH cissac.Almdmov OF cissac.Almcmov:
                DELETE cissac.Almdmov.
            END.
            ASSIGN
                cissac.Almcmov.flgest = "A".
        END.
    END.

END PROCEDURE.

PROCEDURE extorno-conti-cissac-venta-cissac-conti:

    DEF BUFFER CCOT FOR cissac.faccpedi.
    DEF BUFFER CPED FOR cissac.faccpedi.
    DEF BUFFER CORD FOR cissac.faccpedi.
    DEF BUFFER CGUI FOR cissac.ccbcdocu.
    DEF BUFFER CFAC FOR cissac.ccbcdocu.

    FIND cissac.Almacen WHERE cissac.Almacen.codcia = s-codcia
        AND cissac.Almacen.codalm = "21"
        NO-LOCK NO-ERROR.
    ASSIGN
        s-codalm = cissac.Almacen.codalm
        s-coddiv = cissac.Almacen.coddiv.

    trloop:
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
        /* EXTORNAMOS LAS ORDENES DE COMPRA */
        FOR EACH integral.Lg-cocmp WHERE integral.Lg-cocmp.codcia = s-codcia
            AND integral.Lg-cocmp.coddiv = "00000"
            AND integral.Lg-cocmp.tpodoc = "N"
            AND integral.Lg-cocmp.libre_c01 = '201312'
            AND integral.LG-COCmp.Libre_c02 = "DEVCOCI".
            ASSIGN
                integral.Lg-cocmp.flgsit = "A".
        END.
        /* BARREMOS LAS COTIZACIONES */
        FOR EACH CCOT WHERE CCOT.codcia = s-codcia
            AND CCOT.coddiv = s-coddiv
            AND CCOT.coddoc = "COT"
            AND CCOT.libre_c01 = '201312'
            AND CCOT.libre_c02 = "DEVCOCI":
            /* BARREMOS LOS PEDIDOS */
            FOR EACH CPED WHERE CPED.codcia = s-codcia
                AND CPED.coddiv = s-coddiv
                AND CPED.coddoc = "PED"
                AND CPED.codref = CCOT.coddoc
                AND CPED.nroref = CCOT.nroped:
                /* BARREMOS LAS ORDENES DE DESPACHO */
                FOR EACH CORD WHERE CORD.codcia = s-codcia
                    AND CORD.coddiv = s-coddiv
                    AND CORD.coddoc = "O/D"
                    AND CORD.codref = CPED.coddoc
                    AND CORD.nroref = CPED.nroped:
                    /* BARREMOS LAS GUIAS DE REMISION */
                    FOR EACH CGUI WHERE CGUI.codcia = s-codcia
                        AND CGUI.coddiv = s-coddiv
                        AND CGUI.coddoc = "G/R"
                        AND CGUI.codped = CORD.coddoc
                        AND CGUI.nroped = CORD.nroped:
                        /* BARREMOS LAS FACTURAS */
                        FOR EACH CFAC WHERE CFAC.codcia = s-codcia
                            AND CFAC.coddiv = s-coddiv
                            AND CFAC.coddoc = "FAC"
                            AND CFAC.codref = CGUI.coddoc
                            AND CFAC.nroref = CGUI.nrodoc:
                            /* ANULAMOS FACTURAS */
                            ASSIGN 
                                CFAC.FlgEst = "A"
                                CFAC.SdoAct = 0
                                CFAC.UsuAnu = S-USER-ID
                                CFAC.FchAnu = TODAY
                                CFAC.Glosa  = "A N U L A D O".
                        END.
                        /* ACTUALIZAMOS ALMACEN */
                        RUN des_alm ( ROWID (CGUI) ) NO-ERROR.
                        IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN ERROR.

                        /* ANULAMOS INGRESO POR ORDEN DE COMPRA EN CONTINENTAL */
                        RUN Anula-Ingreso-por-Compra ( CGUI.NroDoc ) NO-ERROR.
                        IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN ERROR.

                        /* ANULAMOS GUIA */
                        ASSIGN 
                            CGUI.FlgEst = "A"
                            CGUI.SdoAct = 0
                            CGUI.Glosa  = "** A N U L A D O **"
                            CGUI.FchAnu = TODAY
                            CGUI.Usuanu = s-User-Id.
                    END.
                    /* ANULAMOS ORDENES DE DESPACHO */
                    ASSIGN 
                        CORD.FlgEst = "A"
                        CORD.Glosa = " A N U L A D O".
                END.
                /* ANULAMOS PEDIDOS */
                ASSIGN 
                    CPED.FlgEst = "A"
                    CPED.Glosa = " A N U L A D O".
            END.
            /* ANULAMOS COTIZACIONES */
            ASSIGN 
                CCOT.FlgEst = "A"
                CCOT.Glosa = " A N U L A D O".
        END.
    END.

END PROCEDURE.


PROCEDURE extorno-conti-cissac-transfer-conti:

    trloop:
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
        FOR EACH integral.Almcmov WHERE integral.Almcmov.codcia = s-codcia
            AND integral.Almcmov.codalm = "21"
            AND integral.Almcmov.tipmov = "S"
            AND integral.Almcmov.codmov = 03
            AND integral.Almcmov.nrorf3 =  '201312'
            AND integral.Almcmov.coddoc = "DEVCOCI":
            ASSIGN
                integral.Almcmov.flgest = "A".
            FOR EACH integral.Almdmov OF integral.Almcmov:
                DELETE integral.Almdmov.
            END.
        END.
        FOR EACH integral.Almcmov WHERE integral.Almcmov.codcia = s-codcia
            AND integral.Almcmov.almdes = "21"
            AND integral.Almcmov.tipmov = "I"
            AND integral.Almcmov.codmov = 03
            AND integral.Almcmov.nrorf3 =  '201312'
            AND integral.Almcmov.coddoc = "DEVCOCI":
            ASSIGN
                integral.Almcmov.flgest = "A".
            FOR EACH integral.Almdmov OF integral.Almcmov:
                DELETE integral.Almdmov.
            END.
        END.
    END.

END PROCEDURE.


PROCEDURE des_alm:

    DEFINE INPUT PARAMETER X-ROWID AS ROWID.

    FIND cissac.ccbcdocu WHERE ROWID(cissac.ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cissac.ccbcdocu THEN RETURN ERROR.

    trloop:
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
        /* Anulamos orden de despacho */
        FIND cissac.almcmov WHERE cissac.almcmov.codcia = cissac.ccbcdocu.codcia 
            AND cissac.almcmov.codalm = cissac.ccbcdocu.codalm 
            AND cissac.almcmov.tipmov = "S" 
            AND cissac.almcmov.codmov = cissac.ccbcdocu.codmov 
            AND cissac.almcmov.nroSer = 0  
            AND cissac.almcmov.nrodoc = INTEGER(cissac.ccbcdocu.nrosal) EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE cissac.almcmov THEN DO:
            FOR EACH cissac.almdmov OF cissac.almcmov:
                DELETE cissac.almdmov.
            END.
            ASSIGN 
                cissac.almcmov.flgest = "A".
        END.
    END.


END PROCEDURE.


PROCEDURE Anula-Ingreso-por-Compra:

    DEF INPUT PARAMETER x-NroRf3 AS CHAR.

    DEF VAR r-Rowid AS ROWID NO-UNDO.

    trloop:
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
        FIND FIRST integral.Almcmov WHERE integral.Almcmov.CodCia  = s-CodCia 
            AND integral.Almcmov.CodAlm  = s-CodAlm 
            AND integral.Almcmov.TipMov  = "I"
            AND integral.Almcmov.CodMov  = 02
            AND integral.Almcmov.NroSer  = 000
            AND integral.Almcmov.NroRf3  = x-NroRf3
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE integral.Almcmov THEN UNDO trloop, RETURN ERROR.
        FOR EACH integral.Almdmov OF integral.Almcmov:
            DELETE integral.Almdmov.
        END.
        ASSIGN
            integral.Almcmov.flgest = "A".
    END.


END PROCEDURE.
