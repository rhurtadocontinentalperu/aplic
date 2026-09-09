&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 4.5
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
/* Lógica General */
/* Solo va a existir 1 registro CREATE 
   Solo va a existir un registro UPDATE a menos que ya se haya migrado al SAP,
   en ese caso puede haber más de un registro UPDATE */

&IF DEFINED(input_table) &THEN
    DEFINE BUFFER bInterface_SAP FOR Interface_SAP.
    DEFINE BUFFER bGn-Tcmb FOR gn-tcmb.
    DEFINE VAR LocalActualiza AS LOG INIT NO NO-UNDO.
    DEFINE VAR LocalAccion AS CHAR INIT 'UPDATE' NO-UNDO.
    DEFINE VAR Local_TC AS DECI DECIMALS 4 INIT 1 NO-UNDO.

    &IF "{&input_table}" = "faccpedi" &THEN
        /* Limitamos los documentos a migrar */
        IF AVAILABLE(faccpedi) AND LOOKUP(TRIM(Faccpedi.CodDoc), 'P/M,PED,O/D') > 0 THEN DO:
            LocalActualiza = YES.        /* Valor por defecto */
            /* Acciones */
            LocalAccion = "UPDATE".
            IF NEW Faccpedi THEN LocalAccion = "CREATE".
            IF OldFaccpedi.FlgEst <> "A" AND Faccpedi.FlgEst = "A" THEN ASSIGN LocalAccion = "DELETE" LocalActualiza = NO.
            /* */
            CASE Faccpedi.CodDoc:
                WHEN "PED" THEN DO:
                    /* NO se migra cuando se genera la O/D */
                    IF OldFaccpedi.FlgEst <> "C" AND Faccpedi.FlgEst = "C" THEN LocalActualiza = NO.    
                END.
                WHEN "O/D" THEN DO:
                    /* La Orden puede pasar por Picking y Checking en Tiendas, no por WMS */
                    IF LOOKUP(LocalAccion, "CREATE,DELETE") = 0 THEN DO:
                        /* Cierre de picking: Todavía no pasa a SAP */
                        IF OldFaccpedi.FlgSit <> "P" AND Faccpedi.FlgSit = "P" THEN ASSIGN LocalActualiza = NO LocalAccion = "PIQUEADO".
                        /* Cierre de chequeo */
                        IF OldFaccpedi.FlgSit <> "C" AND Faccpedi.FlgSit = "C" THEN LocalAccion = "CHEQUEADO".
                    END.
                END.
                WHEN "P/M" THEN DO:
                    /* Solo pasa a SAP cuando se cancela en caja */
                    LocalActualiza = NO.
                    IF OldFaccpedi.FlgEst <> "C" AND Faccpedi.FlgEst = "C" THEN ASSIGN LocalActualiza = YES LocalAccion = "CREATE".
                END.
            END CASE.

            IF LocalActualiza THEN DO:
                IF Faccpedi.codmon = 2 THEN DO:
                    FIND LAST bGn-Tcmb WHERE bGn-Tcmb.fecha <= Faccpedi.fchped NO-LOCK NO-ERROR NO-WAIT.
                    IF AVAILABLE bGn-Tcmb THEN Local_TC = bGn-Tcmb.venta.
                END.
                RUN update_interface_SAP (INPUT Faccpedi.coddoc,
                                          INPUT Faccpedi.nroped,
                                          INPUT INTEGER(SUBSTRING(Faccpedi.nroped,1,3)),
                                          INPUT INTEGER(SUBSTRING(Faccpedi.nroped,4)),
                                          INPUT "faccpedi",
                                          INPUT Faccpedi.coddiv,
                                          INPUT (IF LOOKUP(Faccpedi.coddoc,"P/M,O/M") > 0 THEN "CONTADO" ELSE "CREDITO"),
                                          INPUT Faccpedi.usuario,
                                          INPUT LocalAccion,
                                          INPUT Local_TC).
            END.
        END.
    &ENDIF
    
    &IF "{&input_table}" = "ccbcdocu" &THEN
        DEF VAR cTpoFac AS CHAR NO-UNDO.

        cTpoFac = (IF ccbcdocu.codped = "P/M" THEN "CONTADO" ELSE "CREDITO").
        IF ccbcdocu.tpofac = "A" THEN cTpoFac = "ANTICIPO".

        IF AVAILABLE(ccbcdocu) AND LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL,N/C,BD') > 0 THEN DO:
            LocalActualiza = YES.        /* Valor por defecto */
            /* Acciones */
            LocalAccion = "UPDATE".
            IF NEW Ccbcdocu THEN LocalAccion = "CREATE".
            IF OldCcbcdocu.FlgEst <> "A" AND Ccbcdocu.FlgEst = "A" THEN LocalAccion = "DELETE".

            /* NOTA: Los comprobantes solo se graban una vez, salvo que sea anulado */
            CASE TRUE:
                WHEN Ccbcdocu.coddoc = "BD" THEN DO:
                    LocalActualiza = NO.
                    /* Casos: */
                    CASE TRUE:
                        /* Se genera la BD pero NO genera FAC x Anticipo */
                        WHEN (OldCcbcdocu.FlgEst <> "P" AND Ccbcdocu.FlgEst = "P") THEN DO:
                            ASSIGN 
                                LocalAccion = "CREATE" 
                                LocalActualiza = YES.
                        END.
                        /* Se genera la BD pero SÍ genera FAC x Anticipo */
                        WHEN (OldCcbcdocu.FlgEst = "E" AND Ccbcdocu.FlgEst = "C")THEN DO:
                            ASSIGN 
                                LocalAccion = "CREATE" 
                                LocalActualiza = YES
                                cTpoFac = "ANTICIPO".
                        END.
                    END CASE.
                    /* 02/06/2026: Por ahora NO se pasa la BD anulada */
                    IF OldCcbcdocu.FlgEst <> "A" AND Ccbcdocu.FlgEst = "A" THEN ASSIGN LocalAccion = "DELETE" LocalActualiza = NO.
                END.
                OTHERWISE DO:
                    /* Solo se pasan los comprobantes nuevos o anulados */
                    LocalActualiza = NO.
                    IF NEW ccbcdocu THEN ASSIGN LocalAccion = "CREATE" LocalActualiza = YES.
                    IF Ccbcdocu.FlgEst = "A" THEN ASSIGN LocalAccion = "DELETE" LocalActualiza = YES.
                END.
            END CASE.
            /* 16/06/2026: NO se pasan las anulaciones hasta nuevos aviso */
            IF LocalAccion = "DELETE" THEN LocalActualiza = NO.
            IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,N/C') > 0 AND cTpoFac = "CREDITO"  THEN LocalActualiza = NO.

            IF LocalActualiza THEN DO:
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
    &ENDIF
    
    &IF "{&input_table}" = "ccbccaja" &THEN
        IF AVAILABLE(ccbccaja) AND lookup(TRIM(Ccbccaja.coddoc), 'I/C,E/C') > 0 THEN DO:
            /* NOTA: Los comprobantes solo se graban una vez, salvo que sea anulado */
            IF NEW ccbccaja THEN ASSIGN LocalAccion = "CREATE" LocalActualiza = YES.
            IF Oldccbccaja.FlgEst <> "A" AND ccbccaja.FlgEst = "A" THEN ASSIGN LocalAccion = "DELETE" LocalActualiza = YES.
            /* 16/06/2026: NO se pasan las anulaciones hasta nuevos aviso */
            IF LocalAccion = "DELETE" THEN LocalActualiza = NO.
            
            IF LocalActualiza THEN DO:
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
    &ENDIF
    
    &IF "{&input_table}" = "gn-clie" &THEN
        IF AVAILABLE(gn-clie) THEN DO:
            LocalAccion = "UPDATE".
            IF NEW gn-clie THEN LocalAccion = "CREATE".
            LocalActualiza = YES.   /* Todos los movimientos (por ahora) */
            IF LocalActualiza THEN DO:
                RUN update_interface_SAP (INPUT "CLIE",
                                          INPUT gn-clie.codcli,
                                          INPUT 0,
                                          INPUT 0,
                                          INPUT "gn-clie",
                                          INPUT gn-clie.coddiv,
                                          INPUT "",
                                          INPUT s-user-id,
                                          INPUT LocalAccion,
                                          INPUT Local_TC).
            END.
        END.
    &ENDIF
    &IF "{&input_table}" = "gn-clied" &THEN
        IF AVAILABLE(gn-clied) THEN DO:
            /* El control va a ser a través del GN-CLIE */
            LocalAccion = "UPDATE".
            IF NEW gn-clied THEN LocalAccion = "CREATE".
            LocalActualiza = YES.   /* Todos los movimientos (por ahora) */
            /* 03/03/2026: NO deben pasar estos registros*/
            IF LocalAccion = "CREATE" AND (gn-clied.Sede = "@@@" OR gn-clied.Sede = "ALM") THEN LocalActualiza = NO.

            IF LocalActualiza THEN DO:
                /* Como GN-CLIED va a ser tratado como DETALLE de GN-CLIE */
                LocalAccion = "UPDATE".     /* Siempre */
                RUN update_interface_SAP (INPUT "CLIE",
                                          INPUT gn-clied.codcli,
                                          INPUT 0,
                                          INPUT 0,
                                          INPUT "gn-clied",
                                          INPUT "",
                                          INPUT "",
                                          INPUT s-user-id,
                                          INPUT LocalAccion,
                                          INPUT Local_TC).
            END.

        END.
    &ENDIF
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE update_interface_sap Include 
PROCEDURE update_interface_sap PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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
&IF "{&input_table}" = "gn-clied" &THEN
    IF AVAILABLE(gn-clied) THEN DO:
        FIND FIRST Interface_SAP WHERE Interface_SAP.CODE_key = pCode_Key
            AND Interface_SAP.number_key = pNumber_Key
            AND Interface_SAP.state = "N" 
            AND Interface_SAP.libre_c01 = pTable_Key
            AND INTERFACE_SAP.libre_c02 = "CREATE"
            /*AND INTERFACE_SAP.libre_c02 = pLocalAccion*/
            AND INTERFACE_SAP.libre_c03 = gn-clied.sede
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    END.
&ENDIF

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
            &IF "{&input_table}" = "gn-clied" &THEN
                IF AVAILABLE(gn-clied) THEN DO:
                    Interface_SAP.libre_c03 = gn-clied.sede.
                END.
            &ENDIF
        END.
    END.
END CASE.

&IF "{&input_table}" = "ccbccaja" &THEN
    IF AVAILABLE(ccbccaja) THEN DO:
        CASE Ccbccaja.Tipo:
            WHEN "ANTREC" THEN Interface_SAP.libre_c03 = "A/R".
            OTHERWISE Interface_SAP.libre_c03 = Ccbccaja.Tipo.
        END CASE.
    END.
&ENDIF

/* Actualizamos los campos que varían */
ASSIGN
    Interface_SAP.date_create           = TODAY
    Interface_SAP.hour_create           = STRING(TIME,'HH:MM:SS')
    Interface_SAP.user_create           = pUser_Create
    NO-ERROR.

/* Rutina anterio 
    FIND FIRST Interface_SAP WHERE Interface_SAP.CODE_key = pCode_Key
        AND Interface_SAP.number_key = pNumber_Key
        AND Interface_SAP.state = "N" 
        AND Interface_SAP.libre_c01 = pTable_Key
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE Interface_SAP THEN CREATE Interface_SAP.
    ASSIGN
        Interface_SAP.division              = pCodDiv
        Interface_SAP.code_key              = pCode_Key
        Interface_SAP.number_key            = pNumber_Key
        Interface_SAP.serial_number         = pSerial_Number
        Interface_SAP.correlative_number    = pCorrelative_Number
        Interface_SAP.date_create           = TODAY
        Interface_SAP.hour_create           = STRING(TIME,'HH:MM:SS')
        Interface_SAP.origin                = pOrigin
        Interface_SAP.user_create           = pUser_Create
        Interface_SAP.libre_c01             = pTable_Key
        Interface_SAP.libre_c02             = pLocalAccion
        NO-ERROR.
    RELEASE Interface_SAP.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

