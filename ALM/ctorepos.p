&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER p-CodCia AS INT.
DEF INPUT PARAMETER p-CodMat AS CHAR.
DEF INPUT PARAMETER p-FchDoc AS DATE.
DEF INPUT PARAMETER p-CodMon AS INT.
DEF OUTPUT PARAMETER p-PreUni AS DEC.

/* Definimos los movimientos que intervienen en el costo */
DEF VAR x-Movimientos AS CHAR.

FOR EACH Almtmovm NO-LOCK WHERE Almtmovm.codcia = p-codcia
        AND Almtmovm.tipmov = 'I'
        AND Almtmovm.tpocto = 1:
    IF x-Movimientos = ''
    THEN x-Movimientos = STRING(Almtmovm.codmov, '99').
    ELSE x-Movimientos = x-Movimientos + ',' + STRING(Almtmovm.codmov, '99').
END.
/* Buscamos el ultimo movimiento de compra */
FIND LAST Almdmov USE-INDEX ALMD02 WHERE Almdmov.codcia = p-codcia
    AND Almdmov.codmat = p-codmat
    AND Almdmov.fchdoc <= p-fchdoc
    AND Almdmov.tipmov = 'I'
    AND LOOKUP(STRING(Almdmov.codmov, '99'), x-Movimientos) > 0
    AND Almdmov.preuni > 0 NO-LOCK NO-ERROR.
IF AVAILABLE Almdmov
THEN DO:
    p-PreUni = Almdmov.preuni.
    IF p-CodMon <> Almdmov.codmon
    THEN IF p-CodMon = 1 THEN p-PreUni = p-PreUni * Almdmov.tpocmb.
                        ELSE p-PreUni = p-PreUni / Almdmov.tpocmb.
END.
ELSE p-PreUni = 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


