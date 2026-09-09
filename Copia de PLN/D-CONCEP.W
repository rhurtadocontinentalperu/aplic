&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME F-conceptos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS F-conceptos 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{bin\s-global.i}
{pln\s-global.i}

DEFINE STREAM strm-report.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-conceptos

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-5 FILL-IN-conini FILL-IN-confin Btn_OK ~
CMB-carateristicas Btn_Cancel CMB-tipo CMB-inicializa Btn_Help TGL-semana ~
TGL-mes 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-conini FILL-IN-confin ~
CMB-carateristicas CMB-tipo CMB-inicializa TGL-semana TGL-mes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 12 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "A&yuda" 
     SIZE 12 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "&Aceptar" 
     SIZE 12 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE CMB-carateristicas AS CHARACTER FORMAT "X(256)":U 
     LABEL "Caracter¡sticas" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "","Generales","Ingresos y Descuentos Calculados","Ingresos y Descuentos Fijos","Ingresos y Descuentos Variables" 
     DROP-DOWN-LIST
     SIZE 28.43 BY 1 NO-UNDO.

DEFINE VARIABLE CMB-inicializa AS CHARACTER FORMAT "X(256)":U 
     LABEL "Inicializa Valor" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","Al cierre del periodo","Al cierre anual","No cambia con los cierres" 
     DROP-DOWN-LIST
     SIZE 22.43 BY 1 NO-UNDO.

DEFINE VARIABLE CMB-tipo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "","Controles","Dias","Horas","Importes" 
     DROP-DOWN-LIST
     SIZE 11.29 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-confin AS INTEGER FORMAT "999":U INITIAL 999 
     LABEL "Hasta Concepto" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-conini AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Desde Concepto" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 6.

DEFINE VARIABLE TGL-mes AS LOGICAL INITIAL yes 
     LABEL "Mes" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .77 NO-UNDO.

DEFINE VARIABLE TGL-semana AS LOGICAL INITIAL yes 
     LABEL "Semana" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-conceptos
     FILL-IN-conini AT ROW 1.46 COL 13.43 COLON-ALIGNED
     FILL-IN-confin AT ROW 1.46 COL 35.14 COLON-ALIGNED
     Btn_OK AT ROW 1.5 COL 47
     CMB-carateristicas AT ROW 2.35 COL 13.43 COLON-ALIGNED
     Btn_Cancel AT ROW 2.69 COL 47
     CMB-tipo AT ROW 3.31 COL 13.43 COLON-ALIGNED
     CMB-inicializa AT ROW 4.31 COL 13.43 COLON-ALIGNED
     Btn_Help AT ROW 4.5 COL 47
     TGL-semana AT ROW 5.42 COL 15.43
     TGL-mes AT ROW 6.15 COL 15.43
     RECT-5 AT ROW 1.15 COL 1.86
     SPACE(14.56) SKIP(0.34)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Impresi¢n de Conceptos"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX F-conceptos
   FRAME-NAME                                                           */
ASSIGN 
       FRAME F-conceptos:SCROLLABLE       = FALSE
       FRAME F-conceptos:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME F-conceptos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-conceptos F-conceptos
ON WINDOW-CLOSE OF FRAME F-conceptos /* Impresi¢n de Conceptos */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help F-conceptos
ON CHOOSE OF Btn_Help IN FRAME F-conceptos /* Ayuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
    BELL.
    MESSAGE "Ayuda para Archivo: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK F-conceptos
ON CHOOSE OF Btn_OK IN FRAME F-conceptos /* Aceptar */
DO:
    IF CMB-carateristicas:SCREEN-VALUE = "" OR
        CMB-carateristicas:SCREEN-VALUE = ? THEN CMB-carateristicas = "".
    ELSE CMB-carateristicas = CMB-carateristicas:SCREEN-VALUE.
    IF CMB-inicializa:SCREEN-VALUE = "" OR
        CMB-inicializa:SCREEN-VALUE = ? THEN CMB-inicializa = "".
    ELSE CMB-inicializa = CMB-inicializa:SCREEN-VALUE.
    IF CMB-tipo:SCREEN-VALUE = "" OR
        CMB-tipo:SCREEN-VALUE = ? THEN CMB-tipo = "".
    ELSE CMB-tipo = CMB-tipo:SCREEN-VALUE.

    ASSIGN
        FRAME {&FRAME-NAME}
        FILL-IN-confin
        FILL-IN-conini
        TGL-mes
        TGL-semana.

    RUN imprimir.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK F-conceptos 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI F-conceptos  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-conceptos.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI F-conceptos  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY FILL-IN-conini FILL-IN-confin CMB-carateristicas CMB-tipo 
          CMB-inicializa TGL-semana TGL-mes 
      WITH FRAME F-conceptos.
  ENABLE RECT-5 FILL-IN-conini FILL-IN-confin Btn_OK CMB-carateristicas 
         Btn_Cancel CMB-tipo CMB-inicializa Btn_Help TGL-semana TGL-mes 
      WITH FRAME F-conceptos.
  VIEW FRAME F-conceptos.
  {&OPEN-BROWSERS-IN-QUERY-F-conceptos}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir F-conceptos 
PROCEDURE imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE x-NroPag AS INTEGER FORMAT "ZZZ9" NO-UNDO.

FIND integral.PF-CIAS WHERE integral.PF-CIAS.CodCia = s-CodCia NO-LOCK NO-ERROR.

DEFINE FRAME f-cab
    integral.PL-CONC.CodMov COLUMN-LABEL "C¢digo"
    integral.PL-CONC.DesMov COLUMN-LABEL "Descripci¢n" FORMAT "x(40)"
    integral.PL-CONC.Tipmov COLUMN-LABEL "Caracter¡stica" FORMAT "x(35)" VIEW-AS FILL-IN
    integral.PL-CONC.Tipvar COLUMN-LABEL "Tipo" FORMAT "x(10)" VIEW-AS FILL-IN
    integral.PL-CONC.MesMov COLUMN-LABEL "Mes" VIEW-AS FILL-IN
    integral.PL-CONC.SemMov COLUMN-LABEL "Semana" VIEW-AS FILL-IN
    integral.PL-CONC.CieMov COLUMN-LABEL "Cambia" FORMAT "x(30)" VIEW-AS FILL-IN
    HEADER
    PF-CIAS.NomCia "FECHA :" TO 130 TODAY TO 140 SKIP
    "OFICINA DE RELACIONES LABORALES" "PAGINA :" TO 130 x-NroPag TO 140 SKIP
    SKIP(1)
    WITH DOWN NO-BOX STREAM-IO WIDTH 150.

OUTPUT STREAM strm-report TO PRINTER PAGED PAGE-SIZE 66.

/* Seteo de impresi¢n (Impresora EPSON) */
PUT STREAM strm-report CONTROL "~033@~0335~033F~033P~033x~001~033C" CHR(66).
PUT STREAM strm-report CONTROL "~033x" NULL "~017~033P".

ASSIGN x-NroPag = 1.

FOR EACH integral.PL-CONC WHERE
    ( integral.PL-CONC.CodMov >= FILL-IN-conini AND
    integral.PL-CONC.CodMov <= FILL-IN-confin ) AND
    integral.PL-CONC.Tipmov BEGINS CMB-carateristicas AND
    integral.PL-CONC.Tipvar BEGINS CMB-tipo AND
    integral.PL-CONC.CieMov BEGINS CMB-inicializa AND
    ( integral.PL-CONC.MesMov = TRUE OR
    integral.PL-CONC.SemMov = TRUE ) NO-LOCK:
    IF TGL-mes = FALSE AND integral.PL-CONC.SemMov = FALSE THEN NEXT.
    IF TGL-semana = FALSE AND integral.PL-CONC.MesMov = FALSE THEN NEXT.
    DISPLAY STREAM strm-report
        integral.PL-CONC.CodMov
        integral.PL-CONC.DesMov
        integral.PL-CONC.Tipmov
        integral.PL-CONC.Tipvar
        integral.PL-CONC.MesMov
        integral.PL-CONC.SemMov
        integral.PL-CONC.CieMov WITH FRAME f-cab.
    IF LINE-COUNTER( strm-report ) > 62 THEN DO:
        ASSIGN x-NroPag = x-NroPag + 1.
        PAGE STREAM strm-report.
    END.
END.

OUTPUT STREAM strm-report CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

