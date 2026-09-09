DEFINE BUFFER bInterface_SAP FOR Interface_SAP.
DEFINE BUFFER bGn-Tcmb FOR gn-tcmb.
DEFINE BUFFER bInterface FOR INTERFACE_SAP.

DEFINE VAR LocalActualiza AS LOG INIT NO NO-UNDO.
DEFINE VAR LocalAccion AS CHAR INIT 'UPDATE' NO-UNDO.
DEFINE VAR Local_TC AS DECI DECIMALS 4 INIT 1 NO-UNDO.
DEFINE VAR cTpoFac AS CHAR NO-UNDO.
DEFINE VAR dFchIni AS DATE NO-UNDO.
DEFINE VAR dFchFin AS DATE NO-UNDO.
DEFINE VAR dFecha AS DATETIME NO-UNDO.

dFchIni = DATE(02,01,2026).
dFchFin = DATE(02,28,2026).

DELETE FROM INTERFACE_SAP WHERE Interface_SAP.libre_c01 = "gn-clied".

FOR EACH gn-clie NO-LOCK WHERE codcia = 0 AND fching >= dFchIni AND fching <= dFchFin,
    EACH gn-clied OF gn-clie NO-LOCK:
    /* 03/03/2026: NO deben pasar estos registros*/
    IF gn-clied.Sede = "@@@" OR gn-clied.Sede = "ALM" THEN NEXT.
    IF fchcreacion <> ? AND NOT (fchcreacion >= dFchIni AND fchcreacion <= dFchFin) THEN NEXT.

    LocalAccion = "CREATE".

    /* Como GN-CLIED va a ser tratado como DETALLE de GN-CLIE */
    LocalAccion = "UPDATE".     /* Siempre */
    RUN update_interface_SAP (INPUT "CLIE",
                              INPUT gn-clied.codcli,
                              INPUT 0,
                              INPUT 0,
                              INPUT "gn-clied",
                              INPUT "",
                              INPUT "",
                              INPUT gn-clie.usuario,
                              INPUT LocalAccion,
                              INPUT Local_TC).

END.


PROCEDURE update_interface_SAP:

    DEF INPUT PARAMETER pCode_Key AS CHAR NO-UNDO.
    DEF INPUT PARAMETER pNumber_key AS CHAR NO-UNDO.
    DEF INPUT PARAMETER pSerial_Number AS INTE NO-UNDO.
    DEF INPUT PARAMETER pCorrelative_Number AS INTE NO-UNDO.
    DEF INPUT PARAMETER pTable_Key AS CHAR NO-UNDO.
    DEF INPUT PARAMETER pCodDiv AS CHAR NO-UNDO.
    DEF INPUT PARAMETER pOrigin AS CHAR NO-UNDO.
    DEF INPUT PARAMETER pUser_Create AS CHAR NO-UNDO.
    DEF INPUT PARAMETER pLocalAccion AS CHAR NO-UNDO.
    DEF INPUT PARAMETER pLocalTC AS DECI DECIMALS 4 NO-UNDO.

    /* Buscamos el registro sea CREATE o UPDATE */
    /* Siempre va a haber una primera vez con CREATE */
    DEF VAR LocalRegistroUbicado AS LOG INIT NO NO-UNDO.

    IF pLocalAccion = "UPDATE" AND 
        CAN-FIND(FIRST Interface_SAP WHERE Interface_SAP.CODE_key = pCode_Key
                 AND Interface_SAP.number_key = pNumber_Key
                 AND Interface_SAP.state = "N" 
                 AND Interface_SAP.libre_c01 = pTable_Key
                 AND INTERFACE_SAP.libre_c02 = "CREATE"
                 NO-LOCK)
        THEN DO:
        LocalRegistroUbicado = YES.
    END.

    IF LocalRegistroUbicado = YES THEN pLocalAccion = "CREATE".     /* Cambiamos */

    /* Buscamos el registro y lo bloqueamos */
    FIND FIRST Interface_SAP WHERE Interface_SAP.CODE_key = pCode_Key
        AND Interface_SAP.number_key = pNumber_Key
        AND Interface_SAP.state = "N" 
        AND Interface_SAP.libre_c01 = pTable_Key
        AND INTERFACE_SAP.libre_c02 = pLocalAccion
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.

    /* CASO ESPECIAL PARA CLIED */
    FIND FIRST Interface_SAP WHERE Interface_SAP.CODE_key = pCode_Key
        AND Interface_SAP.number_key = pNumber_Key
        AND Interface_SAP.state = "N" 
        AND Interface_SAP.libre_c01 = pTable_Key
        AND INTERFACE_SAP.libre_c02 = "CREATE"
        AND INTERFACE_SAP.libre_c03 = gn-clied.sede
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.

    CASE TRUE:
        WHEN pLocalAccion = "DELETE" THEN DO:
            /* Siempre creamos el registro */
            CREATE Interface_SAP.
            ASSIGN
                Interface_SAP.Id = NEXT-VALUE(next-interface-sap)
                Interface_SAP.division              = pCodDiv
                Interface_SAP.code_key              = pCode_Key
                Interface_SAP.number_key            = pNumber_Key
                Interface_SAP.serial_number         = pSerial_Number
                Interface_SAP.correlative_number    = pCorrelative_Number
                Interface_SAP.libre_c01             = pTable_Key
                Interface_SAP.libre_c02             = pLocalAccion
                Interface_SAP.libre_f01             = pLocalTC
                Interface_SAP.origin                = pOrigin
                NO-ERROR.
        END.
        OTHERWISE DO:
            IF AVAILABLE Interface_SAP THEN DO:
                /* NO tocamos Interface_SAP.libre_c02 */
            END.
            ELSE DO:
                /* Puede que haya sido migrado o puede que no */
                CREATE Interface_SAP.
                ASSIGN
                    Interface_SAP.Id = NEXT-VALUE(next-interface-sap)
                    Interface_SAP.division              = pCodDiv
                    Interface_SAP.code_key              = pCode_Key
                    Interface_SAP.number_key            = pNumber_Key
                    Interface_SAP.serial_number         = pSerial_Number
                    Interface_SAP.correlative_number    = pCorrelative_Number
                    Interface_SAP.libre_c01             = pTable_Key
                    Interface_SAP.libre_c02             = pLocalAccion
                    Interface_SAP.libre_f01             = pLocalTC
                    Interface_SAP.origin                = pOrigin
                    NO-ERROR.
                    IF AVAILABLE(gn-clied) THEN DO:
                        Interface_SAP.libre_c03 = gn-clied.sede.
                    END.
            END.
        END.
    END CASE.

    /* Actualizamos los campos que varían */
    ASSIGN
        Interface_SAP.date_create           = gn-clie.fching
        Interface_SAP.hour_create           = "00:00:00"
        Interface_SAP.user_create           = pUser_Create
        NO-ERROR.
    IF gn-clie.FlagFecha > '' THEN DO:
        ASSIGN dFecha = DATETIME(gn-clie.FlagFecha) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO THEN DO:
            RUN lib/datetime-to-date-hour (dFecha, 
                                           OUTPUT Interface_SAP.date_create, 
                                           OUTPUT Interface_SAP.hour_create).
        END.
    END.
    IF Interface_SAP.hour_create = "00:00:00" THEN DO:
        FOR EACH faccpedi NO-LOCK WHERE faccpedi.codcia = 1 
            AND faccpedi.codcli = gn-clie.codcli
            AND faccpedi.coddoc = "P/M"
            AND faccpedi.fchped <= dFchFin
            BY faccpedi.fchped:
            IF TRIM(Faccpedi.Hora) > '' THEN DO:
                Interface_SAP.hour_create = TRIM(Faccpedi.Hora) + ":00".
                LEAVE.
            END.
        END.
    END.

END PROCEDURE.
