&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Retorna el saldo del documento en la moneda del mismo

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pCodDiv AS CHAR.        /* Opcional */
DEF OUTPUT PARAMETER pSdoMn1 AS DEC.        /* Soles */
DEF OUTPUT PARAMETER pSdoMn2 AS DEC.        /* Dolares */

DEF SHARED VAR s-codcia AS INT.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.coddiv BEGINS pCodDiv
    AND Ccbcdocu.coddoc = pCodDoc
    AND Ccbcdocu.flgest = 'P'
    AND Ccbcdocu.codcli = pCodCli:
    IF Ccbcdocu.codmon = 1 
    THEN pSdoMn1 = pSdoMn1 + Ccbcdocu.SdoAct.
    ELSE pSdoMn2 = pSdoMn2 + Ccbcdocu.SdoAct.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


