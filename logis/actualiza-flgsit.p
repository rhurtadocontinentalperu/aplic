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

FIND Di-RutaC WHERE ROWID(Di-RutaC) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Di-RutaC THEN RETURN 'ADM-ERROR'.
IF Di-RutaC.CodDoc <> "PHR" THEN RETURN 'ADM-ERROR'.

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

CASE Di-RutaC.FlgEst:
    /* PHR Generada */
    WHEN "PX" THEN x-FlgSit  = "TG".     /* O/D con PHR */
    WHEN "P"  THEN x-FlgSit  = "C".     /* O/D Lista para Facturar */
END CASE.

IF TRUE <> (x-FlgSit > '') THEN RETURN 'OK'.
CICLO:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH Di-RutaD OF Di-RutaC NO-LOCK:
        {lib/lock-genericov3.i ~
            &Tabla="Faccpedi" ~
            &Condicion="Faccpedi.codcia = s-codcia AND ~
            Faccpedi.coddoc = Di-RutaD.CodRef AND ~
            Faccpedi.nroped = Di-RutaD.NroRef" ~
            &Bloqueo="EXCLUSIVE-LOCK" ~
            &Accion="RETRY" ~
            &Mensaje="YES" ~
            &TipoError="UNDO CICLO, RETURN 'ADM-ERROR'"}
        ASSIGN Faccpedi.FlgSit = x-FlgSit.
    END.
END.
IF AVAILABLE Faccpedi THEN RELEASE Faccpedi.
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


