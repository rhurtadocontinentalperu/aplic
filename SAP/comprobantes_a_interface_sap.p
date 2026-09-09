DEFINE BUFFER bInterface_SAP FOR Interface_SAP.
DEFINE BUFFER bGn-Tcmb FOR gn-tcmb.
DEFINE VAR LocalActualiza AS LOG INIT NO NO-UNDO.
DEFINE VAR LocalAccion AS CHAR INIT 'UPDATE' NO-UNDO.
DEFINE VAR Local_TC AS DECI DECIMALS 4 INIT 1 NO-UNDO.
DEFINE VAR cTpoFac AS CHAR NO-UNDO.

DELETE FROM INTERFACE_SAP WHERE Interface_SAP.code_key = "BOL".
DELETE FROM INTERFACE_SAP WHERE Interface_SAP.code_key = "FAC".
DELETE FROM INTERFACE_SAP WHERE Interface_SAP.code_key = "N/C".

FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = 1:
    FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = 1
        AND ccbcdocu.coddiv = gn-divi.coddiv
        AND ccbcdocu.fchdoc >= DATE(02,01,2026)
        AND ccbcdocu.fchdoc <= DATE(02,28,2026)
        AND ccbcdocu.codped = "P/M"
        AND ccbcdocu.FlgEst = "C":
        IF LOOKUP(TRIM(Ccbcdocu.coddoc), 'FAC,BOL,N/C') = 0 THEN NEXT.
        LocalAccion = "CREATE".

        cTpoFac = (IF ccbcdocu.codped = "P/M" THEN "CONTADO" ELSE "CREDITO").
        IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,N/C') > 0 AND cTpoFac = "CREDITO"  THEN NEXT.

        IF Ccbcdocu.codmon = 2 THEN DO:
            FIND LAST bGn-Tcmb WHERE bGn-Tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR NO-WAIT.
            IF AVAILABLE bGn-Tcmb THEN Local_TC = bGn-Tcmb.venta.
        END.
        RUN update_interface_SAP (INPUT Ccbcdocu.coddoc,
                                  INPUT Ccbcdocu.nrodoc,
                                  INPUT INTEGER(SUBSTRING(Ccbcdocu.nrodoc,1,3)),
                                  INPUT INTEGER(SUBSTRING(Ccbcdocu.nrodoc,4)),
                                  INPUT "ccbcdocu",
                                  INPUT Ccbcdocu.coddiv,
                                  INPUT cTpoFac,
                                  INPUT ccbcdocu.usuario,
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
    
    /* Actualizamos los campos que varían */
    ASSIGN
        Interface_SAP.date_create           = Ccbcdocu.FchDoc
        Interface_SAP.hour_create           = TRIM(ccbcdocu.HorCie) + ":00"
        Interface_SAP.user_create           = pUser_Create
        NO-ERROR.

END PROCEDURE.
