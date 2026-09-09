&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

DEFINE VARIABLE c-Pagina AS INTEGER LABEL "                 Imprimiendo Página " NO-UNDO.
DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.
DEFINE VARIABLE P-config AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-Largo AS INTEGER NO-UNDO.
DEFINE VARIABLE P-reset AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-flen AS CHARACTER NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print1" SIZE 5 BY 1.5.

DEFINE FRAME F-Mensaje
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 8
    "por favor..." VIEW-AS TEXT SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 8
    "F10 = Cancela Reporte" VIEW-AS TEXT SIZE 21 BY 1 AT ROW 3.5 COL 12 FONT 8          
    SPACE(10.28) SKIP(0.14)
    WITH CENTERED OVERLAY KEEP-TAB-ORDER
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE
        BGCOLOR 15 FGCOLOR 0 TITLE "Imprimiendo...".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 3.96
         WIDTH              = 41.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

&GLOBAL-DEFINE NEW-PAGE READKEY PAUSE 0. ~
IF LASTKEY = KEYCODE("F10") THEN RETURN ERROR. ~
IF LINE-COUNTER(report) > (P-Largo - 8) OR c-Pagina = 0 ~
THEN RUN NEW-PAGE

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NEW-PAGE Include 
PROCEDURE NEW-PAGE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    c-Pagina = c-Pagina + 1.
    IF c-Pagina > s-pagina-final THEN RETURN ERROR.
    DISPLAY c-Pagina WITH FRAME f-mensaje.
    IF c-Pagina > 1 THEN PAGE STREAM report.
    IF s-pagina-inicial = c-Pagina THEN DO:
        OUTPUT STREAM report CLOSE.
        IF s-salida-impresion = 2 THEN DO:
            OUTPUT STREAM report TO PRINTER NO-MAP NO-CONVERT UNBUFFERED
                PAGED PAGE-SIZE 1000.
            PUT STREAM report CONTROL P-reset NULL P-flen NULL P-config NULL.
        END.
        ELSE DO:
            OUTPUT STREAM report TO VALUE(s-print-file) NO-MAP NO-CONVERT UNBUFFERED
                PAGED PAGE-SIZE 1000.
            IF s-salida-impresion = 3 THEN
                PUT STREAM report CONTROL P-reset P-flen P-config.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

