&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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

DEF INPUT PARAMETER pRowid AS ROWID.

DEF SHARED VAR s-codcia AS INT.

FIND Vtacdocu WHERE ROWID(Vtacdocu) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Vtacdocu THEN RETURN 'ADM-ERROR'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 5.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Actualizamos el status de las O/D relacionadas de acuerdo al status de la HPK */
DEF VAR x-FlgSit AS CHAR NO-UNDO.

CASE Vtacdocu.FlgSit:
    WHEN "T"   THEN x-FlgSit  = "TG".     /* Orden con HPK */
    WHEN "TP"  THEN x-FlgSit  = "TI".     /* Picking Iniciado */
    WHEN "P"   THEN x-FlgSit  = "P".      /* Picking Completo */
    WHEN "PT"  THEN x-FlgSit = "PT".     /* Asignado a Mesa */
/*     WHEN "PK"  THEN x-FlgSit = "PK".     /* En Proceso de Chequeo */ */
    WHEN "PR"  THEN x-FlgSit = "PR".     /* Recepcionado en Chequeo */
/*     WHEN "PO"  THEN x-FlgSit = "PO".     /* Chequeo Observado */ */
    WHEN "PC"  THEN x-FlgSit = "PC".     /* Chequeo Cerrado */
END CASE.

IF TRUE <> (x-FlgSit > '') THEN RETURN 'OK'.

CASE Vtacdocu.CodTer:
    WHEN "ACUMULATIVO" THEN DO:
        RUN Acumulativo.
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
    OTHERWISE DO:
         RUN Actualiza-OD (INPUT Vtacdocu.CodRef,
                           INPUT Vtacdocu.NroRef,
                           INPUT x-FlgSit).
         IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
END CASE.
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Actualiza-OD) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-OD Procedure 
PROCEDURE Actualiza-OD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroPed AS CHAR.
DEF INPUT PARAMETER pFlgSit AS CHAR.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="Faccpedi" ~
        &Condicion="Faccpedi.codcia = s-codcia AND ~
        Faccpedi.coddoc = pCodDoc AND ~
        Faccpedi.nroped = pNroPed" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    ASSIGN
        Faccpedi.FlgSit = pFlgSit.
    RELEASE Faccpedi.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Acumulativo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Acumulativo Procedure 
PROCEDURE Acumulativo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH Almddocu NO-LOCK WHERE AlmDDocu.CodCia = s-codcia AND
        AlmDDocu.CodLlave = TRIM(Vtacdocu.codped) + ',' + TRIM(Vtacdocu.nroped)
        BREAK BY AlmDDocu.CodDoc BY AlmDDocu.NroDoc:
        IF FIRST-OF(AlmDDocu.CodDoc) OR FIRST-OF(AlmDDocu.NroDoc)
            THEN DO:
            RUN Actualiza-OD (INPUT Almddocu.CodDoc,
                              INPUT Almddocu.NroDoc,
                              INPUT x-FlgSit).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

