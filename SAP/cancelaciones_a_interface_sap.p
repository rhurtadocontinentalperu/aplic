DEFINE BUFFER bInterface_SAP FOR Interface_SAP.
DEFINE BUFFER bGn-Tcmb FOR gn-tcmb.
DEFINE VAR LocalActualiza AS LOG INIT NO NO-UNDO.
DEFINE VAR LocalAccion AS CHAR INIT 'UPDATE' NO-UNDO.
DEFINE VAR Local_TC AS DECI DECIMALS 4 INIT 1 NO-UNDO.
DEFINE VAR cTpoFac AS CHAR NO-UNDO.

DELETE FROM INTERFACE_SAP WHERE Interface_SAP.code_key = "I/C".
DELETE FROM INTERFACE_SAP WHERE Interface_SAP.code_key = "E/C".

FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = 1:
    FOR EACH ccbccaja NO-LOCK WHERE ccbccaja.codcia = 1
        AND ccbccaja.coddiv = gn-divi.coddiv
        AND ccbccaja.fchdoc >= DATE(02,01,2026)
        AND ccbccaja.fchdoc <= DATE(02,28,2026)
        AND ccbccaja.FlgEst = "C":
        IF LOOKUP(TRIM(ccbccaja.coddoc), 'I/C,E/C') = 0 THEN NEXT.
        IF TRIM(ccbccaja.coddoc) = "I/C" AND TRIM(ccbccaja.tipo) = 'CANCELACION' THEN NEXT.
        IF TRIM(ccbccaja.tipo) = 'SENCILLO' THEN NEXT.
        LocalAccion = "CREATE".

        Local_TC = Ccbccaja.TpoCmb.
        RUN update_interface_SAP (INPUT ccbccaja.coddoc,
                                  INPUT ccbccaja.nrodoc,
                                  INPUT INTEGER(SUBSTRING(Ccbccaja.nrodoc,1,3)),
                                  INPUT INTEGER(SUBSTRING(Ccbccaja.nrodoc,4)),
                                  INPUT "ccbccaja",
                                  INPUT ccbccaja.coddiv,
                                  INPUT "CONTADO",
                                  INPUT ccbccaja.usuario,
                                  INPUT LocalAccion,
                                  INPUT Local_TC).

    END.
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
            END.
        END.
    END CASE.

    IF AVAILABLE(ccbccaja) THEN DO:
        CASE Ccbccaja.Tipo:
            WHEN "ANTREC" THEN Interface_SAP.libre_c03 = "A/R".
            OTHERWISE Interface_SAP.libre_c03 = Ccbccaja.Tipo.
        END CASE.
    END.
    
    /* Actualizamos los campos que varían */
    ASSIGN
        Interface_SAP.date_create           = ccbccaja.FchDoc
        Interface_SAP.hour_create           = (IF ccbccaja.HorDoc > '' THEN ccbccaja.HorDoc ELSE TRIM(ccbccaja.HorCie) + ":00")
        Interface_SAP.user_create           = pUser_Create
        NO-ERROR.

END PROCEDURE.
