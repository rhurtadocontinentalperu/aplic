&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */


/* Parameters Definitions ---                                           */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

/* Local Variable Definitions ---                                       */
/*
    @PRINTER2.W    VERSION 1.0
*/
{lib/def-prn.i}    
DEFINE STREAM report.
/*DEFINE VARIABLE x-Raya     AS CHARACTER FORMAT "X(145)".
DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id  LIKE _user._userid.*/

DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.

  
def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE T-CLIEN AS CHAR INIT "" NO-UNDO.
DEFINE VARIABLE T-TIPO   AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.


def temp-table t-codven01 field codven as char init ""
                          field desven as char init ""
                          field acc-soles as deci init 0
                          field acc-dolar as deci init 0
                          field acc-dolar-pen as deci init 0
                          field acc-dolar-anu as deci init 0
                          field acc-dolar-ate as deci init 0
                          field acc-dolar-des as deci init 0
/*ML01*/                    FIELDS acc-dolar-ven AS DECI INIT 0
/*ML01*/                    FIELDS acc-dolar-pap AS DECI INIT 0
                          field iColumn as integer init 0
                          field acc-dolar-ped as deci init 0.

/*DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.*/
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

/*Variables para el Archivo de Excel*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE dAnnualQuota            AS DECIMAL.
DEFINE VARIABLE t-Column                AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE f-Column                AS char INITIAL "".
DEFINE VARIABLE x-valor                 AS DECIMAL init 0.
DEFINE VARIABLE f-estado                AS char init "".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-41 RECT-43 r-tipo f-desde f-hasta ~
Btn_OK Btn_Cancel BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-3 r-tipo f-desde f-hasta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\excel":U
     LABEL "" 
     SIZE 5.57 BY 1.42 TOOLTIP "Exportar a Excel - más simple, rápido e innovador - SISTEMAS siempre contigo".

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .69
     FONT 6 NO-UNDO.

DEFINE VARIABLE r-tipo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Listado General", 1,
"Por Vendedor", 2
     SIZE 16.14 BY 1.42 NO-UNDO.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 59.57 BY 5.77.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 59.72 BY 2.23
     BGCOLOR 7 FGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-3 AT ROW 1.38 COL 5.15 WIDGET-ID 52
     r-tipo AT ROW 2.54 COL 11 NO-LABEL WIDGET-ID 54
     f-desde AT ROW 5.58 COL 6.86 COLON-ALIGNED WIDGET-ID 48
     f-hasta AT ROW 5.58 COL 23.57 COLON-ALIGNED WIDGET-ID 50
     Btn_OK AT ROW 7.42 COL 28 WIDGET-ID 86
     Btn_Cancel AT ROW 7.42 COL 41 WIDGET-ID 84
     BUTTON-2 AT ROW 7.42 COL 54 WIDGET-ID 88
     "Rango de Fechas :" VIEW-AS TEXT
          SIZE 17.14 BY .62 AT ROW 4.69 COL 11.14 WIDGET-ID 60
          FONT 6
     RECT-41 AT ROW 1.15 COL 1.43 WIDGET-ID 58
     RECT-43 AT ROW 7 COL 1.29 WIDGET-ID 90
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 61.29 BY 8.65
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Reporte de Cotizaciones Oficina"
         HEIGHT             = 8.65
         WIDTH              = 61.29
         MAX-HEIGHT         = 8.65
         MAX-WIDTH          = 61.29
         VIRTUAL-HEIGHT     = 8.65
         VIRTUAL-WIDTH      = 61.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de Cotizaciones Oficina */
/*OR ENDKEY OF {&WINDOW-NAME} ANYWHERE*/ DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Cotizaciones Oficina */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN f-Desde f-hasta R-tipo.

  IF f-desde = ? then do:
     MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.   
  END.
   
  IF f-hasta = ? then do:
     MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-hasta.
     RETURN NO-APPLY.   
  END.   

  IF f-desde > f-hasta then do:
     MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.
  END.
 
  IF R-tipo = 1  THEN T-tipo = "Relacion General " .
  IF R-tipo = 2  THEN T-tipo = "Por Vendedor     " .


/*
  P-largo   = 66.
  P-Copias  = INPUT FRAME {&FRAME-NAME} RB-NUMBER-COPIES.
  P-pagIni  = INPUT FRAME {&FRAME-NAME} RB-BEGIN-PAGE.
  P-pagfin  = INPUT FRAME {&FRAME-NAME} RB-END-PAGE.
  P-select  = INPUT FRAME {&FRAME-NAME} RADIO-SET-1.
  P-archivo = INPUT FRAME {&FRAME-NAME} RB-OUTPUT-FILE.
  P-detalle = "Impresora Local (EPSON)".
  P-name    = "Epson E/F/J/RX/LQ".
  P-device  = "PRN".
  
  IF P-select = 2 
     THEN P-archivo = SESSION:TEMP-DIRECTORY + 
          STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
  ELSE RUN setup-print.      
     IF P-select <> 1 
     THEN P-copias = 1.
*/
  RUN Imprimir.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main
DO:
  
  assign f-desde f-hasta R-tipo.
  IF R-tipo = 1 THEN RUN GRAFICO.
  IF R-tipo = 2 THEN RUN GRAFICO2.    
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ASSIGN FILL-IN-3 = S-CODDIV
       F-DESDE   = TODAY
       F-HASTA   = TODAY .
       R-TIPO.

/*

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN enable_UI.
  PTO                  = SESSION:SET-WAIT-STATE("").    
  l-immediate-display  = SESSION:IMMEDIATE-DISPLAY.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  RUN disable_UI.

  FRAME F-Mensaje:TITLE =  FRAME {&FRAME-NAME}:TITLE.
  VIEW FRAME F-Mensaje.  
  PAUSE 0.           
  SESSION:IMMEDIATE-DISPLAY = YES.

  DO c-Copias = 1 to P-copias ON ERROR UNDO, LEAVE
                                ON STOP UNDO, LEAVE:
        OUTPUT STREAM report TO NUL PAGED PAGE-SIZE 1000.
        c-Pagina = 0.
        RUN IMPRIMIR.
    OUTPUT STREAM report CLOSE.        
  END.
  OUTPUT STREAM report CLOSE.        
  SESSION:IMMEDIATE-DISPLAY =   l-immediate-display.

  IF NOT LASTKEY = KEYCODE("ESC") AND P-select = 2 THEN DO: 
        RUN bin/_vcat.p ( P-archivo ). 
  END.    
  HIDE FRAME F-Mensaje.  
  RETURN.
END.

*/


ON 'ESC':U OF FRAME {&FRAME-NAME}
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-3 r-tipo f-desde f-hasta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-41 RECT-43 r-tipo f-desde f-hasta Btn_OK Btn_Cancel BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1 W-Win 
PROCEDURE Formato1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE VAR X-soles   AS DECIMAL INIT 0.   
 DEFINE VAR x-dolares AS DECIMAL INIT 0.   
 DEFINE VAR TX-soles   AS DECIMAL INIT 0.   
 DEFINE VAR Tx-dolares AS DECIMAL INIT 0.   
 DEFINE VAR x-flgest  AS CHAR.
 DEFINE FRAME f-cab
        FaccPedi.Nroped
        FaccPedi.FchPed
        FaccPedi.CodCli
        FaccPedi.Nomcli
        FaccPedi.CodVen
        x-soles   FORMAT ">>,>>>,>>>,>>9.99" 
        x-dolares FORMAT ">>,>>>,>>>,>>9.99" 
        x-flgest  FORMAT "X(5)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + FacCpedi.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + "REPORTE DE COTIZACIONES DE OFICINA"  AT 40 FORMAT "X(37)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 89 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 102 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-TIPO AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 114 STRING(TIME,"HH:MM:SS") SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                                                          " SKIP
        "Numero     Fecha       Codigo        Razon Social                               Vendedor                 SOLES          DOLARES    EST    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
  FOR EACH FacCpedi NO-LOCK WHERE
           FacCpedi.CodCia = S-CODCIA AND
           FacCpedi.CodDiv = S-CODDIV AND
           FacCpedi.CodDoc = "COT"    AND
           FacCpedi.FchPed >= F-desde AND
           FacCpedi.FchPed <= F-hasta 
           BREAK BY Nroped :
           

     /*{&new-page}.*/
     X-SOLES   = 0.
     X-DOLARES = 0.
     
     CASE FaccPedi.FlgEst:
          WHEN "A" THEN x-flgest = "ANU" .
          WHEN "C" THEN x-flgest = "ATE" .
          WHEN "P" THEN x-flgest = "PEN" .
          WHEN "V" THEN x-flgest = "VEN" .
         WHEN "E" THEN x-flgest = "xAPRO" .
          OTHERWISE x-flgest = "???".
     END CASE.         

     IF FaccPedi.FlgEst <> 'A' THEN DO:
      IF FaccPedi.CodMon = 1 THEN X-SOLES   = FaccPedi.ImpTot.
      IF FaccPedi.CodMon = 2 THEN X-DOLARES = FaccPedi.ImpTot.
     END.
    TX-SOLES = TX-SOLES + X-SOLES.
    TX-DOLARES = TX-DOLARES + X-DOLARES.

     DISPLAY STREAM REPORT 
        FaccPedi.Nroped
        FaccPedi.FchPed
        FaccPedi.CodCli
        FaccPedi.Nomcli
        FaccPedi.CodVen
        x-soles
        x-dolares
        x-flgest
        WITH FRAME F-Cab.


     DISPLAY '' @ Fi-Mensaje WITH FRAME F-Proceso.
 END.
   PUT STREAM REPORT " " SKIP.  
   PUT STREAM REPORT   "T O T A L   P E R I O D O     : "  AT 40.
   PUT STREAM REPORT  TX-SOLES format ">>,>>>,>>9.99" AT 100.
   PUT STREAM REPORT  TX-DOLARES format ">>,>>>,>>9.99" AT 118.
/*
 CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN RUN LIB/d-README.R(s-print-file). 
 END CASE.                                             
*/

   HIDE FRAME f-proceso.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2 W-Win 
PROCEDURE Formato2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE VAR X-soles   AS DECIMAL INIT 0.   
 DEFINE VAR x-dolares AS DECIMAL INIT 0.   
 DEFINE VAR TX-soles   AS DECIMAL INIT 0.   
 DEFINE VAR Tx-dolares AS DECIMAL INIT 0.   
 DEFINE VAR x-flgest  AS CHAR.
 DEFINE VAR x-desven  AS CHAR.

 DEFINE FRAME f-cab
        FaccPedi.Nroped
        FaccPedi.FchPed
        FaccPedi.CodCli
        FaccPedi.Nomcli
        FaccPedi.CodVen
        x-soles   FORMAT ">>,>>>,>>>,>>9.99" 
        x-dolares FORMAT ">>,>>>,>>>,>>9.99" 
        x-flgest  FORMAT "X(5)"

        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + FacCpedi.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + "REPORTE DE COTIZACIONES DE OFICINA"  AT 40 FORMAT "X(37)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 89 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 102 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-TIPO AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 114 STRING(TIME,"HH:MM:SS") SKIP
        "-------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                                               " SKIP
        "  Numero     Fecha       Codigo        Razon Social                           Vendedor             SOLES       DOLARES  EST    " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
        
  FOR EACH FacCpedi NO-LOCK WHERE
           FacCpedi.CodCia = S-CODCIA AND
           FacCpedi.CodDiv = S-CODDIV AND
           FacCpedi.CodDoc = "COT"    AND
           FacCpedi.FchPed >= F-desde AND
           FacCpedi.FchPed <= F-hasta 
           BREAK BY CodVen 
                 BY NroPed:

     DISPLAY STREAM REPORT WITH FRAME F-CAB.

     X-SOLES = 0.
     X-DOLARES = 0.
     CASE FaccPedi.FlgEst:
          WHEN "A" THEN x-flgest = "ANU" .
          WHEN "C" THEN x-flgest = "ATE" .
          WHEN "P" THEN x-flgest = "PEN" .
          WHEN "V" THEN x-flgest = "VEN" .
         WHEN "E" THEN x-flgest = "xAPRO" .
             OTHERWISE x-flgest = "???".
     END CASE.         

     IF FaccPedi.FlgEst <> 'A' THEN DO:
       IF FaccPedi.CodMon = 1 THEN X-SOLES   = FaccPedi.ImpTot.
       IF FaccPedi.CodMon = 2 THEN X-DOLARES = FaccPedi.ImpTot.
     END.
    ACCUM X-SOLES   (SUB-TOTAL BY FaccPedi.CodVen).   
    ACCUM X-DOLARES (SUB-TOTAL BY FaccPedi.CodVen).   

    TX-SOLES = TX-SOLES + X-SOLES.
    TX-DOLARES = TX-DOLARES + X-DOLARES.
    
    IF FIRST-OF(FaccPedi.CodVen) THEN DO:
       FIND GN-VEN WHERE GN-VEN.CODCIA = S-CODCIA AND
                         GN-VEN.CODVEN = FaccPedi.CodVen
                         NO-LOCK NO-ERROR.
       x-desven = " ".
       IF AVAILABLE GN-VEN THEN x-desven = GN-VEN.NOMVEN .                 
       
       PUT STREAM REPORT  " VENDEDOR  :  "  FaccPedi.CodVen " " x-desven  FORMAT "X(100)" SKIP. 
       PUT STREAM REPORT  " ------------------------------------------------------ "   SKIP.

     END.


     DISPLAY STREAM REPORT 
        FaccPedi.Nroped
        FaccPedi.FchPed
        FaccPedi.CodCli
        FaccPedi.Nomcli
        FaccPedi.CodVen
        x-soles
        x-dolares
        x-flgest
        WITH FRAME F-Cab.   
      
      IF LAST-OF(faccPedi.CodVen) THEN DO:
        UNDERLINE STREAM REPORT 
            x-soles format ">,>>>,>>9.99"
            x-dolares format ">,>>>,>>9.99"
        WITH FRAME F-CAB.
        DISPLAY STREAM REPORT 
            ("TOTAL  : " + FaccPedi.CodVen) @ FaccPedi.Nomcli
            (ACCUM SUB-TOTAL BY FaccPedi.CodVen x-soles ) @ x-soles 
            (ACCUM SUB-TOTAL BY FaccPedi.CodVen x-dolares) @ x-dolares SKIP
            
            WITH FRAME F-CAB.
      END.   
      DISPLAY '' @ Fi-Mensaje WITH FRAME F-Proceso.  
 END.
 PUT STREAM REPORT " " SKIP.
 PUT STREAM REPORT "T O T A L    P E R I O D O    : "  AT 40 .
 PUT STREAM REPORT TX-SOLES    AT 85  FORMAT ">>,>>>,>>>,>>9.99" .
 PUT STREAM REPORT TX-DOLARES  AT 105 FORMAT ">>,>>>,>>>,>>9.99" .

 HIDE FRAME f-proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grafico W-Win 
PROCEDURE Grafico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR X-soles   AS DECIMAL INIT 0.   
DEFINE VAR x-dolares AS DECIMAL INIT 0.   
DEFINE VAR TX-soles   AS DECIMAL INIT 0.   
DEFINE VAR Tx-dolares AS DECIMAL INIT 0.   
DEFINE VAR x-flgest  AS CHAR.


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A1:G1"):Font:Bold = TRUE.

/* set the column names for the Worksheet */

chWorkSheet:Range("D2"):Value =  "REPORTE DE COTIZACIONES DE OFICINA" .
chWorkSheet:Range("A3"):Value = "Desde".
chWorkSheet:Range("B3"):Value = DATE(f-desde). 
chWorkSheet:Range("E3"):Value = "Hasta".
chWorkSheet:Range("F3"):Value = DATE(f-hasta).

chWorkSheet:Range("A4: H4"):Font:Bold = TRUE.
chWorkSheet:Range("A4"):Value = "Numero".
chWorkSheet:Range("B4"):Value = "Fecha".
chWorkSheet:Range("C4"):Value = "Codigo".
chWorkSheet:Range("D4"):Value = "Razon Social".
chWorkSheet:Range("E4"):Value = "Vendedor".
chWorkSheet:Range("F4"):Value = "SOLES".
chWorkSheet:Range("G4"):Value = "DOLARES".
chWorkSheet:Range("H4"):Value = "ESTADO".

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("C"):NumberFormat = "@".
chWorkSheet:Columns("E"):NumberFormat = "@".

iCount = 4.

FOR EACH FacCpedi NO-LOCK WHERE
    FacCpedi.CodCia = S-CODCIA AND
    FacCpedi.CodDiv = S-CODDIV AND
    FacCpedi.CodDoc = "COT"    AND
    FacCpedi.FchPed >= F-desde AND
    FacCpedi.FchPed <= F-hasta BREAK BY Nroped :

    X-SOLES   = 0.
    X-DOLARES = 0.

    CASE FaccPedi.FlgEst:
        WHEN "A" THEN x-flgest = "ANULADO" .
        WHEN "C" THEN x-flgest = "ATENDIDO" .
        WHEN "P" THEN x-flgest = "PENDIENTE" .
        WHEN "V" THEN x-flgest = "VENCIDO" .
        WHEN "E" THEN x-flgest = "xAPROBAR" .
            OTHERWISE x-flgest = "???".
    END CASE.         

    IF FaccPedi.FlgEst <> 'A' THEN DO:
        IF FaccPedi.CodMon = 1 THEN X-SOLES   = FaccPedi.ImpTot.
        IF FaccPedi.CodMon = 2 THEN X-DOLARES = FaccPedi.ImpTot.
    END.
    TX-SOLES = TX-SOLES + X-SOLES.
    TX-DOLARES = TX-DOLARES + X-DOLARES.

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = FaccPedi.Nroped.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = FaccPedi.FchPed.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = FaccPedi.CodCli.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = FaccPedi.Nomcli.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = FaccPedi.CodVen.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = x-soles.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = x-dolares.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = x-flgest.

        DISPLAY '' @ Fi-Mensaje WITH FRAME F-Proceso.
END.

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "T O T A L   P E R I O D O     : ".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = TX-SOLES.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = TX-DOLARES.

      HIDE FRAME f-proceso.   

                
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grafico2 W-Win 
PROCEDURE Grafico2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE VAR X-soles   AS DECIMAL INIT 0.   
 DEFINE VAR x-dolares AS DECIMAL INIT 0.   
 DEFINE VAR TX-soles   AS DECIMAL INIT 0.   
 DEFINE VAR Tx-dolares AS DECIMAL INIT 0.   
 DEFINE VAR x-flgest  AS CHAR.
 DEFINE VAR x-desven  AS CHAR.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A1:G1"):Font:Bold = TRUE.

/* set the column names for the Worksheet */

chWorkSheet:Range("D2"):Value =  "REPORTE DE COTIZACIONES DE OFICINA" .
chWorkSheet:Range("A3"):Value = "Desde".
chWorkSheet:Range("B3"):Value = DATE(f-desde).
chWorkSheet:Range("E3"):Value = "Hasta".
chWorkSheet:Range("F3"):Value = DATE(f-hasta).

chWorkSheet:Range("A4: H4"):Font:Bold = TRUE.
chWorkSheet:Range("A4"):Value = "Numero".
chWorkSheet:Range("B4"):Value = "Fecha".
chWorkSheet:Range("C4"):Value = "Codigo".
chWorkSheet:Range("D4"):Value = "Razon Social".
chWorkSheet:Range("E4"):Value = "Vendedor".
chWorkSheet:Range("F4"):Value = "SOLES".
chWorkSheet:Range("G4"):Value = "DOLARES".
chWorkSheet:Range("H4"):Value = "ESTADO".

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("C"):NumberFormat = "@".
chWorkSheet:Columns("E"):NumberFormat = "@".

iCount = 4.

FOR EACH FacCpedi NO-LOCK WHERE
    FacCpedi.CodCia = S-CODCIA AND
    FacCpedi.CodDiv = S-CODDIV AND
    FacCpedi.CodDoc = "COT"    AND
    FacCpedi.FchPed >= F-desde AND
    FacCpedi.FchPed <= F-hasta BREAK BY CodVen BY NroPed:

    X-SOLES = 0.
    X-DOLARES = 0.
    CASE FaccPedi.FlgEst:
        WHEN "A" THEN x-flgest = "ANULADO" .
        WHEN "C" THEN x-flgest = "ATENDIDO" .
        WHEN "P" THEN x-flgest = "PENDIENTE" .
        WHEN "V" THEN x-flgest = "VENCIDO" .
        WHEN "E" THEN x-flgest = "xAPROBAR" .
            OTHERWISE x-flgest = "???".
    END CASE.         

    IF FaccPedi.FlgEst <> 'A' THEN DO:
        IF FaccPedi.CodMon = 1 THEN X-SOLES   = FaccPedi.ImpTot.
        IF FaccPedi.CodMon = 2 THEN X-DOLARES = FaccPedi.ImpTot.
    END.
    ACCUM X-SOLES   (SUB-TOTAL BY FaccPedi.CodVen).   
    ACCUM X-DOLARES (SUB-TOTAL BY FaccPedi.CodVen).   

    TX-SOLES = TX-SOLES + X-SOLES.
    TX-DOLARES = TX-DOLARES + X-DOLARES.
    
    IF FIRST-OF(FaccPedi.CodVen) THEN DO:
       FIND GN-VEN WHERE GN-VEN.CODCIA = S-CODCIA AND
                         GN-VEN.CODVEN = FaccPedi.CodVen
                         NO-LOCK NO-ERROR.
       x-desven = " ".
       IF AVAILABLE GN-VEN THEN x-desven = GN-VEN.NOMVEN .                 

       iCount = iCount + 1.
       cColumn = STRING(iCount).
       cRange = "A" + cColumn.
       chWorkSheet:Range(cRange):Value = 'VENDEDOR :'.
       cRange = "B" + cColumn.
       chWorkSheet:Range(cRange):Value = "'" + FaccPedi.CodVen .       
       cRange = "C" + cColumn.
       chWorkSheet:Range(cRange):Value =  x-desven.
     END.

     iCount = iCount + 1.
     cColumn = STRING(iCount).
     cRange = "A" + cColumn.
     chWorkSheet:Range(cRange):Value = FaccPedi.Nroped.
     cRange = "B" + cColumn.
     chWorkSheet:Range(cRange):Value = FaccPedi.FchPed.
     cRange = "C" + cColumn.
     chWorkSheet:Range(cRange):Value = FaccPedi.CodCli.
     cRange = "D" + cColumn.
     chWorkSheet:Range(cRange):Value = FaccPedi.Nomcli.
     cRange = "E" + cColumn.
     chWorkSheet:Range(cRange):Value = FaccPedi.CodVen.
     cRange = "F" + cColumn.
     chWorkSheet:Range(cRange):Value = x-soles.
     cRange = "G" + cColumn.
     chWorkSheet:Range(cRange):Value = x-dolares.
     cRange = "H" + cColumn.
     chWorkSheet:Range(cRange):Value = x-flgest.

     IF LAST-OF(faccPedi.CodVen) THEN DO:
         iCount = iCount + 1.
         cColumn = STRING(iCount).
         cRange = "D" + cColumn.
         chWorkSheet:Range(cRange):Value = "TOTAL : " + FaccPedi.CodVen.
         cRange = "F" + cColumn.
         chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY FaccPedi.CodVen x-soles.
         cRange = "G" + cColumn.
         chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY FaccPedi.CodVen x-dolares.
      END.   
      DISPLAY '' @ Fi-Mensaje WITH FRAME F-Proceso.  
END.

iCount = iCount + 1.
cColumn = STRING(iCount).
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "T O T A L   P E R I O D O     : ".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = TX-SOLES.
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = TX-DOLARES.
HIDE FRAME f-proceso.   

chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn2}.
        IF R-tipo = 1 THEN RUN Formato1.
        IF R-tipo = 2 THEN RUN Formato2.    
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

