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

DEF INPUT PARAMETER pCodCli AS CHAR.
DEF OUTPUT PARAMETER pFmaPgo AS CHAR.

DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR i AS INT NO-UNDO.

/* Condiciones de ventas base */
pFmaPgo = ''.
/* CASO EXPOLIBRERIA */
CASE s-CodDiv:
    WHEN '00015' THEN pFmaPgo = '001'.    
    OTHERWISE DO:
        FOR EACH gn-convt NO-LOCK WHERE Codig <> '000' AND      /* NO CONTADO */
            TipVta = '1':    /* CONTADO */
            IF pFmaPgo = '' 
            THEN pFmaPgo = gn-ConVt.Codig.
            ELSE pFmaPgo = pFmaPgo + ',' + gn-ConVt.Codig.
        END.
        /* Agregamos Transferencias Gratuita */
        FIND gn-convt WHERE gn-ConVt.Codig = '900' NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt THEN pFmaPgo = (IF pFmaPgo = '' THEN '900' ELSE pFmaPgo + ',900').
    END.
END CASE.
FIND gn-clie WHERE codcia = cl-codcia
    AND codcli = pCodCli NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN RETURN.
IF gn-clie.CndVta = '' THEN RETURN.
DO i = 1 TO NUM-ENTRIES(gn-clie.CndVta):
    IF LOOKUP ( ENTRY(i, gn-clie.CndVta), pFmaPgo ) = 0 
    THEN IF pFmaPgo = '' 
        THEN pFmaPgo = ENTRY(i, gn-clie.CndVta).
        ELSE pFmaPgo = pFmaPgo + ',' + ENTRY(i, gn-clie.CndVta).
END.
/* RHC 11.07.2012 SOLO CLIENTE 11111111112 */
IF pCodCli = '11111111112' THEN pFmaPgo = '900'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


