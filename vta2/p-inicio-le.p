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
DEFINE TEMP-TABLE DOCU LIKE integral.Ccbcdocu.
DEFINE TEMP-TABLE DETA LIKE integral.CcbDDocu.

/* ***************************  Definitions  ************************** */
DEF INPUT PARAMETER pCodCia AS INT.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF INPUT-OUTPUT PARAMETER TABLE FOR DOCU.
DEF INPUT-OUTPUT PARAMETER TABLE FOR DETA.
DEF OUTPUT PARAMETER pError AS CHAR.

IF NOT CONNECTED("lima") THEN DO:
    /*CONNECT -db integral -ld lima -N tcp -S 65010 -H 192.168.100.210 -RO NO-ERROR.*/
    CONNECT -pf lima.pf NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pError = 'NO se pudo conectar la base de LIMA' + CHR(10) +
            'Volver a repetir el proceso mas tarde'.
        IF CONNECTED("lima") THEN DISCONNECT lima NO-ERROR.
        RETURN 'ADM-ERROR'.
    END.
END.

RUN vta2/p-facbol-le (pCodCia,
                      pCodDoc,
                      pNroDoc,
                      INPUT-OUTPUT TABLE DOCU,
                      INPUT-OUTPUT TABLE DETA,
                      OUTPUT pError).
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    IF CONNECTED("lima") THEN DISCONNECT lima NO-ERROR.
    RETURN 'ADM-ERROR'.
END.
IF CONNECTED("lima") THEN DISCONNECT lima NO-ERROR.

RETURN "OK".

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
         HEIGHT             = 4.27
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


