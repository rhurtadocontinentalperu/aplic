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
&IF DEFINED(INPUT_table) &THEN
    DEFINE BUFFER bInterface_SAP FOR Interface_SAP.
    DEFINE VAR LocalActualiza AS LOG INIT NO NO-UNDO.

    &IF "&input_table" = "faccpedi" &THEN
        IF AVAILABLE(faccpedi) THEN DO:
            CASE faccpedi.coddoc:
                WHEN "P/M" THEN DO:
                    IF faccpedi.flgest = "C" THEN LocalActualiza = YES.
                END.
                WHEN "COT" THEN DO:
                    IF oldfaccpedi.flgest <> "P" AND faccpedi.flgest = "P" THEN LocalActualiza = YES.
                    IF faccpedi.flgest = "A" THEN LocalActualiza = YES.
                END.
                WHEN "PED" THEN DO:
                    LocalActualiza = YES.
                END.
                WHEN "O/D" OR WHEN "O/M" THEN DO:
                    IF NEW faccpedi THEN LocalActualiza = YES.
                    IF faccpedi.flgest = "A" THEN LocalActualiza = YES.
                END.
            END CASE.
            IF LocalActualiza THEN DO:
                FIND bInterface_SAP WHERE bInterface_SAP.CODE_key = faccpedi.coddoc
                    AND bInterface_SAP.number_key = faccpedi.nroped
                    AND bInterface_SAP.estate = "N"
                    NO-LOCK NO-ERROR.
                IF AVAILABLE bInterface_SAP THEN DO:
                    {lib/lock-genericov3.i ~
                        &Tabla="Interface_SAP" ~
                        &Condicion="ROWID(Interface_SAP) = ROWID(bInterface_SAP)" ~
                        &Bloqueo = "EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
                        &Accion="RETRY" ~
                        &Mensaje="NO" ~
                        &TipoError="UNDO, RETURN ERROR" ~
                        &Intentos= "10" ~
                        }
                END.
                ELSE CREATE Interface_SAP.
                ASSIGN
                    Interface_SAP.division              = Faccpedi.coddiv
                    Interface_SAP.code_key              = Faccpedi.coddoc
                    Interface_SAP.number_key            = Faccpedi.nroped
                    Interface_SAP.serial_number         = INTEGER(SUBSTRING(Faccpedi.nroped,1,3))
                    Interface_SAP.correlative_number    = INTEGER(SUBSTRING(Faccpedi.nroped,4))
                    Interface_SAP.date_create           = TODAY
                    Interface_SAP.hour_create           = STRING(TIME,'HH:MM:SS')
                    Interface_SAP.origin                = (IF Faccpedi.coddoc = "P/M" THEN "CONTADO" ELSE "CREDITO")
                    Interface_SAP.user_create           = Faccpedi.usuario
                    Interface_SAP.libre_c01             = "faccpedi".
            END.
        END.
    &ENDIF
    
    &IF "&input_table" = "ccbcdocu" &THEN
        IF AVAILABLE(ccbcdocu) THEN DO:
            CASE ccbcdocu.coddoc:
                WHEN "FAC" OR WHEN "BOL" OR WHEN "N/C" THEN DO:
                    LocalActualiza = YES.
                END.
            END CASE.
            IF LocalActualiza THEN DO:
                FIND bInterface_SAP WHERE bInterface_SAP.CODE_key = ccbcdocu.coddoc
                    AND bInterface_SAP.number_key = ccbcdocu.nrodoc
                    AND bInterface_SAP.estate = "N"
                    NO-LOCK NO-ERROR.
                IF AVAILABLE bInterface_SAP THEN DO:
                    {lib/lock-genericov3.i ~
                        &Tabla="Interface_SAP" ~
                        &Condicion="ROWID(Interface_SAP) = ROWID(bInterface_SAP)" ~
                        &Bloqueo = "EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
                        &Accion="RETRY" ~
                        &Mensaje="NO" ~
                        &TipoError="UNDO, RETURN ERROR" ~
                        &Intentos= "10" ~
                        }
                END.
                ELSE CREATE Interface_SAP.
                ASSIGN
                    Interface_SAP.division              = ccbcdocu.coddiv
                    Interface_SAP.code_key              = ccbcdocu.coddoc
                    Interface_SAP.number_key            = ccbcdocu.nrodoc
                    Interface_SAP.serial_number         = INTEGER(SUBSTRING(ccbcdocu.nrodoc,1,3))
                    Interface_SAP.correlative_number    = INTEGER(SUBSTRING(ccbcdocu.nrodoc,4))
                    Interface_SAP.date_create           = TODAY
                    Interface_SAP.hour_create           = STRING(TIME,'HH:MM:SS')
                    Interface_SAP.origin                = (IF ccbcdocu.codped = "P/M" THEN "CONTADO" ELSE "CREDITO")
                    Interface_SAP.user_create           = ccbcdocu.usuario
                    Interface_SAP.libre_c01             = "ccbcdocu".
            END.
        END.
    &ENDIF
    &IF "&input_table" = "ccbccaja" &THEN
        IF AVAILABLE(ccbccaja) THEN DO:
            CASE ccbccaja.coddoc:
                WHEN "I/C" OR WHEN "E/C" THEN DO:
                    LocalActualiza = YES.
                END.
            END CASE.
            IF LocalActualiza THEN DO:
                FIND bInterface_SAP WHERE bInterface_SAP.CODE_key = ccbccaja.coddoc
                    AND bInterface_SAP.number_key = ccbccaja.nrodoc
                    AND bInterface_SAP.estate = "N"
                    NO-LOCK NO-ERROR.
                IF AVAILABLE bInterface_SAP THEN DO:
                    {lib/lock-genericov3.i ~
                        &Tabla="Interface_SAP" ~
                        &Condicion="ROWID(Interface_SAP) = ROWID(bInterface_SAP)" ~
                        &Bloqueo = "EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
                        &Accion="RETRY" ~
                        &Mensaje="NO" ~
                        &TipoError="UNDO, RETURN ERROR" ~
                        &Intentos= "10" ~
                        }
                END.
                ELSE CREATE Interface_SAP.
                ASSIGN
                    Interface_SAP.division              = ccbccaja.coddiv
                    Interface_SAP.code_key              = ccbccaja.coddoc
                    Interface_SAP.number_key            = ccbccaja.nrodoc
                    Interface_SAP.serial_number         = INTEGER(SUBSTRING(ccbccaja.nrodoc,1,3))
                    Interface_SAP.correlative_number    = INTEGER(SUBSTRING(ccbccaja.nrodoc,4))
                    Interface_SAP.date_create           = TODAY
                    Interface_SAP.hour_create           = STRING(TIME,'HH:MM:SS')
                    Interface_SAP.origin                = "CONTADO"
                    Interface_SAP.user_create           = ccbccaja.usuario
                    Interface_SAP.libre_c01             = "ccbccaja".
            END.
        END.
    &ENDIF
            
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


