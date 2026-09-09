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
         HEIGHT             = 4.81
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/*
  Tabla: "Almacen"
  Alcance: [{"FIRST" | "LAST" | "CURRENT" }]   Valor opcional
  Condicion: "Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm"
  Bloqueo: { "NO-LOCK" | "SHARED-LOCK" | "EXCLUSIVE-LOCK" }
  Accion: { "RETRY" | "LEAVE" }
  Mensaje: { "YES" | "NO" }
  TipoError: { "[UNDO,] RETURN {'ADM-ERROR' | ERROR | }" | "NEXT" | "LEAVE" }
*/

/* OJO :: NO USAR HASTA PROBAR BIEN */

DEF VAR LocalCounter AS INTEGER INITIAL 1 NO-UNDO.
DEF VAR cMsgs AS CHARACTER NO-UNDO.
DEF VAR ix AS INTEGER NO-UNDO.

GetLock:
REPEAT ON STOP UNDO, {&Accion} ON ERROR UNDO, {&Accion}:
    &IF DEFINED(Alcance) &THEN
        FIND {&Alcance} {&Tabla} WHERE {&Condicion} {&Bloqueo} NO-WAIT.
    &ELSE
        FIND {&Tabla} WHERE {&Condicion} {&Bloqueo} NO-WAIT.
    &ENDIF
    IF AVAILABLE {&Tabla} THEN LEAVE.
    CATCH eBlockError AS PROGRESS.Lang.SysError:
        IF {&Mensaje} = YES THEN DO:
            IF eBlockError:NumMessages > 0 THEN DO:
                cMsgs = eBlockError:GetMessage(1).
                DO ix = 2 TO eBlockError:NumMessages:
                    cMsgs = cMsgs + CHR(10) + eBlockError:GetMessage(ix).
                END.
                MESSAGE cMsgs VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            END.
        END.
        DELETE OBJECT eBlockError.
        IF LocalCounter <= 5 THEN DO:
            LocalCounter = LocalCounter + 1.
            UNDO, NEXT GetLock.
        END.
        ELSE DO:
            LEAVE GetLock.
        END.
    END CATCH.
END.
IF LocalCounter >= 5 OR NOT AVAILABLE {&Tabla} THEN {&TipoError}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


