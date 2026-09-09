&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : p-bgrg_r.p
    Purpose     : Avisa que una guia de remision está para facturar

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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF VAR s-CodCia AS INT INIT 001 NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF STREAM REPORTE.
DEF VAR OK-WAIT-STATE AS LOG NO-UNDO.

s-CodCia = INTEGER(SESSION:PARAMETER).

DEF VAR s-Titulo AS CHAR INIT 'CIA. NO IDENTIFICADA' NO-UNDO FORMAT 'x(50)'.

FIND GN-CIAS WHERE GN-CIAS.CodCia = s-CodCia NO-LOCK NO-ERROR.
IF AVAILABLE GN-CIAS THEN s-Titulo = TRIM(GN-CIAS.NomCia) + 
                                    ': PRODUCTO BAJO STOCK MININO '.

DEF VAR x-Mensaje AS LONGCHAR VIEW-AS EDITOR LARGE INNER-CHARS 80 INNER-LINES 20
    SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL .
DEFINE FRAME f-Mensaje
    SKIP(1)
    x-Mensaje AT 5 BGCOLOR 11 FGCOLOR 0 FONT 1 SKIP(1) 
    "Presione F10 para cerrar esta ventana..." FGCOLOR 15 SKIP
    WITH AT COLUMN 50 ROW 1 NO-LABELS OVERLAY
        TITLE s-Titulo
        WIDTH 100
        VIEW-AS DIALOG-BOX BGCOLOR 1.
/* loop buscando informacion nueva */
PRINCIPAL:
REPEAT:
    x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".
    OK-WAIT-STATE = NO.
    OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
    FOR EACH Logmmate NO-LOCK WHERE Logmmate.codcia = s-codcia
        AND Logmmate.LogEvent = "STOCKMINIMO"
        AND Logmmate.LogFlag = "P"
        AND DATE(Logmmate.LogDate) = TODAY:
        DISPLAY STREAM REPORTE
            logmmate.CodAlm 
            logmmate.codmat 
            logmmate.LogDate 
            logmmate.StkAct 
            logmmate.StkMin 
            (logmmate.StkMin - logmmate.StkAct) COLUMN-LABEL 'Diferencia'
            WITH STREAM-IO NO-BOX WIDTH 320.
        PAUSE 0.
        OK-WAIT-STATE = YES.
    END.
    OUTPUT STREAM REPORTE CLOSE.
    IF OK-WAIT-STATE = YES THEN RUN lib/w-readme (x-Archivo).
    OS-DELETE VALUE (x-Archivo).
END.
QUIT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


