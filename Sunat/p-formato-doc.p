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

/* Rutina general que devuelve el formato del comprobante solicitado */

DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF OUTPUT PARAMETER pFormato AS CHAR.

IF LOOKUP(pCodDoc,"FAC,BOL,N/C,N/D,G/R") > 0 THEN DO:
    pFormato = '999-99999999'.    /* Valor por defecto */
END.
ELSE DO:
    pFormato = '999-999999'.    /* Valor por defecto */
END.


DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN RETURN.
IF gn-divi.campo-log[10] = NO THEN RETURN.

FIND FIRST FacDocum WHERE FacDocum.CodCia = s-codcia
    AND FacDocum.CodDoc = pCodDoc
    NO-LOCK NO-ERROR.

IF AVAILABLE FacDocum 
    AND FacDocum.CodCta[10] > ''
    AND INDEX ( FacDocum.CodCta[10] , '-' ) > 1
    AND NUM-ENTRIES(FacDocum.CodCta[10],'-') = 2
    THEN pFormato = FacDocum.CodCta[10].

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
         HEIGHT             = 3.96
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


