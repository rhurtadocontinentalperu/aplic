&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : p-bgrped.p
    Purpose     : Avisa que un pedido ya está aprobado

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


/* ********************************************************************
   Busca Pedidos Oficina por Aprobar
   Sintaxis: 
   ******************************************************************** */

/* ***************************  Main Block  *************************** */
DEF VAR s-CodCia AS INT INIT 001 NO-UNDO.
DEF VAR s-CodDiv AS CHAR INIT '00000' NO-UNDO.

s-CodCia = INTEGER(SUBSTRING(SESSION:PARAMETER,1,3)).
s-CodDiv = SUBSTRING(SESSION:PARAMETER,4).

DEF TEMP-TABLE T-PEDI LIKE FacCPedi.
DEF VAR s-CodDoc AS CHAR INIT 'PED' NO-UNDO.
DEF VAR s-FlgEst AS CHAR INIT 'G,W,X' NO-UNDO.      /* Pedido Por Aprobar */
DEF VAR s-Titulo AS CHAR INIT 'CIA NO DEFINIDA' FORMAT 'x(50)'.

FIND GN-CIAS WHERE GN-CIAS.CodCia = s-CodCia NO-LOCK NO-ERROR.
IF AVAILABLE GN-CIAS THEN s-Titulo = TRIM(GN-CIAS.NomCia) +
                                    ': PEDIDOS POR APROBAR'.

DEF VAR x-Mensaje AS CHAR VIEW-AS EDITOR INNER-CHARS 50 INNER-LINES 5.
DEFINE FRAME f-Mensaje
    SKIP(1)
    x-Mensaje AT 5 BGCOLOR 11 FGCOLOR 0 FONT 1 SKIP(1) 
    "Presione F10 para cerrar esta ventana..." FGCOLOR 15 SKIP
    /*"Presione F12 para cerrar el programa...." SKIP*/
    WITH AT COLUMN 50 ROW 1 NO-LABELS OVERLAY
        TITLE s-Titulo
        WIDTH 60
        VIEW-AS DIALOG-BOX BGCOLOR 1.
/* loop buscando informacion nueva */
PRINCIPAL:
REPEAT:
    FOR EACH FacCPedi WHERE codcia = s-codcia
            AND coddoc = s-coddoc
            AND nroped <> ''
            AND coddiv = s-coddiv
            AND fchped = TODAY
            AND LOOKUP(flgest, s-flgest) > 0
            NO-LOCK:
        FIND T-PEDI OF FacCPedi NO-LOCK NO-ERROR.
        IF NOT AVAILABLE T-PEDI
        THEN DO:
            /* AVISO AL USUARIO */
            ASSIGN
                x-Mensaje = 'PEDIDO: ' + STRING(faccpedi.nroped, 'XXX-XXXXXX') +
                            ' falta aprobarlo.'.
            DISPLAY x-Mensaje WITH FRAME f-Mensaje.
            READKEY.
            REPEAT WHILE LASTKEY <> KEYCODE("F10"):
                READKEY.
                /*
                IF LASTKEY = KEYCODE("F12")
                THEN LEAVE PRINCIPAL.
                */
            END.
            HIDE FRAME f-Mensaje.
            CREATE T-PEDI.
            RAW-TRANSFER FacCPedi TO T-PEDI.
        END.
    END.
END.
QUIT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


