&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Definir el tipo de pedido

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

FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN ''.

IF LOOKUP(Faccpedi.coddoc, 'COT,PED,O/D') = 0 THEN RETURN ''.

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
         HEIGHT             = 4.08
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF BUFFER COTIZACION FOR Faccpedi.
DEF BUFFER PEDIDO FOR Faccpedi.

CASE Faccpedi.CodDoc:
    WHEN 'COT' THEN RETURN Faccpedi.TpoPed.
    WHEN 'PED' THEN DO:
        FIND COTIZACION WHERE COTIZACION.codcia = Faccpedi.codcia
            AND COTIZACION.coddiv = Faccpedi.coddiv
            AND COTIZACION.coddoc = Faccpedi.codref
            AND COTIZACION.nroped = Faccpedi.nroref
            NO-LOCK NO-ERROR.
        IF AVAILABLE COTIZACION THEN RETURN COTIZACION.TpoPed.
        ELSE RETURN ''.
    END.
    WHEN 'O/D' THEN DO:
        FIND PEDIDO WHERE PEDIDO.codcia = Faccpedi.codcia
            AND PEDIDO.coddiv = Faccpedi.coddiv
            AND PEDIDO.coddoc = Faccpedi.codref
            AND PEDIDO.nroped = Faccpedi.nroref
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE PEDIDO THEN RETURN ''.
        FIND COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
            AND COTIZACION.coddiv = PEDIDO.coddiv
            AND COTIZACION.coddoc = PEDIDO.codref
            AND COTIZACION.nroped = PEDIDO.nroref
            NO-LOCK NO-ERROR.
        IF AVAILABLE COTIZACION THEN RETURN COTIZACION.TpoPed.
        ELSE RETURN ''.
    END.

END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


