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
DEFINE STREAM report.

DEFINE NEW SHARED VARIABLE xTerm        AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id   LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id    LIKE _user._userid.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.

  
DEFINE VARIABLE l-immediate-display  AS LOGICAL.
DEFINE VARIABLE cb-codcia            AS INTEGER INITIAL 0.
DEFINE VARIABLE pv-codcia            AS INTEGER INITIAL 0.
DEFINE VARIABLE cl-codcia            AS INTEGER INITIAL 0.
DEFINE VARIABLE PTO                  AS LOGICAL.

DEFINE VARIABLE T-CLIEN  AS CHAR INIT "" NO-UNDO.
DEFINE VARIABLE T-VENDE  AS CHAR INIT "" NO-UNDO.
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)" NO-UNDO.
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)" NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-72 RECT-73 RADIO-SET-Orden f-desde ~
f-hasta btn-ok BUTTON-8 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-3 RADIO-SET-Orden f-desde f-hasta ~
TOGGLE-Vendedor x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-ok 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 7" 
     SIZE 12 BY 1.62.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 8" 
     SIZE 12 BY 1.62.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .79
     FONT 6 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 63.14 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Orden AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Por Correlativo", 1,
"Por Vendedor", 2,
"Por Cliente", 5
     SIZE 16 BY 2.12 NO-UNDO.

DEFINE RECTANGLE RECT-72
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 7.81.

DEFINE RECTANGLE RECT-73
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 1.85.

DEFINE VARIABLE TOGGLE-Vendedor AS LOGICAL INITIAL no 
     LABEL "Solo totales por vendedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.29 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-3 AT ROW 2.08 COL 4.86 WIDGET-ID 34
     RADIO-SET-Orden AT ROW 3.69 COL 13 NO-LABEL WIDGET-ID 36
     f-desde AT ROW 4.04 COL 39.43 COLON-ALIGNED WIDGET-ID 30
     f-hasta AT ROW 4.04 COL 56 COLON-ALIGNED WIDGET-ID 32
     TOGGLE-Vendedor AT ROW 6.38 COL 13 WIDGET-ID 42
     x-mensaje AT ROW 7.73 COL 2.86 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     btn-ok AT ROW 9.19 COL 45 WIDGET-ID 24
     BUTTON-8 AT ROW 9.19 COL 57 WIDGET-ID 26
     "Rango de Fechas :" VIEW-AS TEXT
          SIZE 17.14 BY .62 AT ROW 3.15 COL 46 WIDGET-ID 40
          FONT 6
     "Ordenado" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 3.42 COL 4 WIDGET-ID 44
     RECT-72 AT ROW 1.27 COL 2 WIDGET-ID 20
     RECT-73 AT ROW 9.08 COL 2 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70.29 BY 10.19
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
         TITLE              = "Resumen Cotizaciones Mostrador"
         HEIGHT             = 10.19
         WIDTH              = 70.29
         MAX-HEIGHT         = 10.19
         MAX-WIDTH          = 70.29
         VIRTUAL-HEIGHT     = 10.19
         VIRTUAL-WIDTH      = 70.29
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

{src/adm-vm/method/vmviewer.i}
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
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Vendedor IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Resumen Cotizaciones Mostrador */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen Cotizaciones Mostrador */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-ok W-Win
ON CHOOSE OF btn-ok IN FRAME F-Main /* Button 7 */
DO:
      ASSIGN f-Desde f-hasta RADIO-SET-Orden TOGGLE-Vendedor.
    
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
      RUN Imprimir. 
      DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Button 8 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-Orden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-Orden W-Win
ON VALUE-CHANGED OF RADIO-SET-Orden IN FRAME F-Main
DO:
  IF SELF:SCREEN-VALUE = '2'
  THEN TOGGLE-Vendedor:SENSITIVE = YES.
  ELSE TOGGLE-Vendedor:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

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
  DISPLAY FILL-IN-3 RADIO-SET-Orden f-desde f-hasta TOGGLE-Vendedor x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-72 RECT-73 RADIO-SET-Orden f-desde f-hasta btn-ok BUTTON-8 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        DISPLAY "Cargando Informacion..." @ x-mensaje WITH FRAME {&FRAME-NAME}.
        CASE RADIO-SET-Orden:
            WHEN 1 THEN RUN prn-ofi.
            WHEN 2 THEN DO:
                IF TOGGLE-Vendedor = NO THEN RUN prn-ven.
                ELSE RUN prn-ven-2.
            END.
            WHEN 5 THEN RUN prn-cliente.
        END CASE.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
   ASSIGN FILL-IN-3 = S-CODDIV
       F-DESDE   = TODAY
       F-HASTA   = TODAY.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prn-cliente W-Win 
PROCEDURE prn-cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.

 DEFINE FRAME f-cab
     FacCPedm.NroPed FORMAT "XXX-XXXXXX"
     FacCPedm.FchPed 
     /*FacCPedm.FChEnt*/
     FacCPedm.NomCli FORMAT "X(27)"
     FacCPedm.RucCli FORMAT "X(11)"
     /*FacCPedm.CodPos FORMAT "X(4)"*/
     FacCPedm.Codven FORMAT "X(4)"
     X-MON           FORMAT "X(4)"
     FacCPedm.ImpBrt FORMAT "->,>>>,>>9.99"
     FacCPedm.ImpDto FORMAT "->>,>>9.99"
     FacCPedm.ImpVta FORMAT "->,>>>,>>9.99"
     FacCPedm.ImpIgv FORMAT "->>,>>9.99"
     FacCPedm.ImpTot FORMAT "->,>>>,>>9.99"
     X-EST           FORMAT "X(3)"
     HEADER
     {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
     {&PRN2} + {&PRN6A} + "( " + FacCPedm.CodDiv + ")" + {&PRN6B} + {&PRN4} AT 1 FORMAT "X(15)"
     {&PRN6A} + "RESUMEN DE COTIZACIONES MOSTRADOR" + {&PRN6B} AT 40 FORMAT "X(40)"
     {&PRN4} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
     {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} FORMAT "X(12)"
     {&PRN4} + "Fecha : " AT 138 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
     "Hora  : " AT 134 STRING(TIME,"HH:MM:SS") SKIP
     "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
     "    No.      FECHA                                                       T O T A L      TOTAL       VALOR                  P R E C I O        " SKIP
     "COTIZACION  EMISION   C L I E N T E                  R.U.C.   VEND MON.    BRUTO        DSCTO.      VENTA       I.G.V.      V E N T A   ESTADO" SKIP
     "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*    xxx-xxxxxx 99/99/9999 123456789012345678901234567 12345678901 1234 1234 ->,>>>,>>9.99 ->>,>>9.99 ->,>>>,>>9.99 ->>,>>9.99 ->,>>>,>>9.99 123
*/
      WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 

 FOR EACH FacCPedm NO-LOCK WHERE FacCPedm.CodCia = S-CODCIA 
     AND FacCPedm.CodDiv = S-CODDIV 
     AND FacCPedm.CodDoc = "COT"    
     AND FacCPedm.FchPed >= F-desde 
     AND FacCPedm.FchPed <= F-hasta 
     AND FacCPedm.FlgEst = 'P'
     BREAK BY FacCPedm.CodCli:

     /*{&new-page}.*/

     IF FacCPedm.Codmon = 1 THEN X-MON = "S/.". ELSE X-MON = "US$.".
     CASE FacCPedm.FlgEst :
         WHEN "P" THEN DO:
             X-EST = "PEN".
             IF FacCPedm.Codmon = 1 THEN DO:
                w-totbru [1] = w-totbru [1] + FacCPedm.ImpBrt.   
                w-totdsc [1] = w-totdsc [1] + FacCPedm.ImpDto.
                w-totval [1] = w-totval [1] + FacCPedm.ImpVta.
                w-totigv [1] = w-totigv [1] + FacCPedm.ImpIgv.
                w-totven [1] = w-totven [1] + FacCPedm.ImpTot.
             END.   
             ELSE DO:  
                w-totbru [2] = w-totbru [2] + FacCPedm.ImpBrt.   
                w-totdsc [2] = w-totdsc [2] + FacCPedm.ImpDto.
                w-totval [2] = w-totval [2] + FacCPedm.ImpVta.
                w-totigv [2] = w-totigv [2] + FacCPedm.ImpIgv.
                w-totven [2] = w-totven [2] + FacCPedm.ImpTot.                
             END.   
         END.   
         WHEN "C" THEN DO:
             X-EST = "CAN".
             IF FacCPedm.Codmon = 1 THEN DO:
                w-totbru [3] = w-totbru [3] + FacCPedm.ImpBrt.   
                w-totdsc [3] = w-totdsc [3] + FacCPedm.ImpDto.
                w-totval [3] = w-totval [3] + FacCPedm.ImpVta.
                w-totigv [3] = w-totigv [3] + FacCPedm.ImpIgv.
                w-totven [3] = w-totven [3] + FacCPedm.ImpTot.
             END.   
             ELSE DO:  
                w-totbru [4] = w-totbru [4] + FacCPedm.ImpBrt.   
                w-totdsc [4] = w-totdsc [4] + FacCPedm.ImpDto.
                w-totval [4] = w-totval [4] + FacCPedm.ImpVta.
                w-totigv [4] = w-totigv [4] + FacCPedm.ImpIgv.
                w-totven [4] = w-totven [4] + FacCPedm.ImpTot.                
             END.                
         END.   
         WHEN "A" THEN DO:
             X-EST = "ANU".       
             IF FacCPedm.Codmon = 1 THEN DO:
                w-totbru [5] = w-totbru [5] + FacCPedm.ImpBrt.   
                w-totdsc [5] = w-totdsc [5] + FacCPedm.ImpDto.
                w-totval [5] = w-totval [5] + FacCPedm.ImpVta.
                w-totigv [5] = w-totigv [5] + FacCPedm.ImpIgv.
                w-totven [5] = w-totven [5] + FacCPedm.ImpTot.
             END.   
             ELSE DO:  
                w-totbru [6] = w-totbru [6] + FacCPedm.ImpBrt.   
                w-totdsc [6] = w-totdsc [6] + FacCPedm.ImpDto.
                w-totval [6] = w-totval [6] + FacCPedm.ImpVta.
                w-totigv [6] = w-totigv [6] + FacCPedm.ImpIgv.
                w-totven [6] = w-totven [6] + FacCPedm.ImpTot.                
             END.                
         END.   
    END.        
    /*
    DISPLAY STREAM REPORT 
        FacCPedm.NroPed 
        FacCPedm.FchPed 
        FacCPedm.FchEnt
        FacCPedm.NomCli 
        FacCPedm.RucCli
        FacCPedm.CodPos
        FacCPedm.Codven
        X-MON           
        FacCPedm.ImpVta 
        FacCPedm.ImpDto 
        FacCPedm.ImpBrt 
        FacCPedm.ImpIgv 
        FacCPedm.ImpTot 
        X-EST WITH FRAME F-Cab.
    */
    ACCUMULATE FacCPedm.ImpTot (TOTAL BY FacCPedm.CodCli).
    IF LAST-OF(FacCPedm.CodCli) THEN DO:
        DISPLAY STREAM REPORT
            (IF FacCPedm.CodCli BEGINS '11111111' THEN 'CLIENTES VARIOS' ELSE FacCPedm.NomCli) @ FacCPedm.NomCli
            (IF FacCPedm.RucCli = '' THEN FacCPedm.CodCli ELSE FacCPedm.RucCli) @ FacCPedm.RucCli 
            /*FacCPedm.CodPos*/
            (ACCUM TOTAL BY FacCPedm.CodCli FacCPedm.ImpTot) @ FacCPedm.imptot
            'PEN' @ x-est
            WITH FRAME F-Cab.
    END.
 END.
 DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
    PUT STREAM REPORT "" skip. 
 END. 
 PUT STREAM REPORT "----------------------------------------------" SPACE(4) "----------------------------------------------" SPACE(4) "----------------------------------------------" SKIP.
 PUT STREAM REPORT "TOTAL CANCELADAS       SOLES        DOLARES   " SPACE(4) "TOTAL PENDIENTES       SOLES        DOLARES   " SPACE(4) "TOTAL ANULADAS         SOLES        DOLARES   " SKIP.
 PUT STREAM REPORT "----------------------------------------------" SPACE(4) "----------------------------------------------" SPACE(4) "----------------------------------------------" SKIP.
 PUT STREAM REPORT "Total Bruto     :" AT 1 w-totbru[3] AT 19  FORMAT "->,>>>,>>9.99" w-totbru[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[1] AT 69  FORMAT "->,>>>,>>9.99" w-totbru[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[5] AT 119 FORMAT "->,>>>,>>9.99" w-totbru[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Descuento       :" AT 1 w-totdsc[3] AT 19  FORMAT "->,>>>,>>9.99" w-totdsc[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[1] AT 69  FORMAT "->,>>>,>>9.99" w-totdsc[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[5] AT 119 FORMAT "->,>>>,>>9.99" w-totdsc[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Valor de Venta  :" AT 1 w-totval[3] AT 19  FORMAT "->,>>>,>>9.99" w-totval[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[1] AT 69  FORMAT "->,>>>,>>9.99" w-totval[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[5] AT 119 FORMAT "->,>>>,>>9.99" w-totval[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "I.G.V.          :" AT 1 w-totigv[3] AT 19  FORMAT "->,>>>,>>9.99" w-totigv[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[1] AT 69  FORMAT "->,>>>,>>9.99" w-totigv[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[5] AT 119 FORMAT "->,>>>,>>9.99" w-totigv[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Precio de Venta :" AT 1 w-totven[3] AT 19  FORMAT "->,>>>,>>9.99" w-totven[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[1] AT 69  FORMAT "->,>>>,>>9.99" w-totven[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[5] AT 119 FORMAT "->,>>>,>>9.99" w-totven[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prn-ofi W-Win 
PROCEDURE prn-ofi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
    
 DEFINE FRAME f-cab
     FacCPedm.NroPed FORMAT "XXX-XXXXXX"
     FacCPedm.FchPed 
     /*FacCPedm.FChEnt*/
     FacCPedm.NomCli FORMAT "X(27)"
     FacCPedm.RucCli FORMAT "X(11)"
     /*FacCPedm.CodPos FORMAT "X(4)"*/
     FacCPedm.Codven FORMAT "X(4)"
     X-MON           FORMAT "X(4)"
     FacCPedm.ImpBrt FORMAT "->,>>>,>>9.99"
     FacCPedm.ImpDto FORMAT "->>,>>9.99"
     FacCPedm.ImpVta FORMAT "->,>>>,>>9.99"
     FacCPedm.ImpIgv FORMAT "->>,>>9.99"
     FacCPedm.ImpTot FORMAT "->,>>>,>>9.99"
     X-EST           FORMAT "X(3)"
     HEADER
     {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
     {&PRN2} + {&PRN6A} + "( " + FacCPedm.CodDiv + ")" + {&PRN6B} + {&PRN4} AT 1 FORMAT "X(15)"
     {&PRN6A} + "RESUMEN DE COTIZACIONES MOSTRADOR" + {&PRN6B} AT 40 FORMAT "X(40)"
     {&PRN4} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
     {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} FORMAT "X(12)"
     {&PRN4} + "Fecha : " AT 138 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
     "Hora  : " AT 134 STRING(TIME,"HH:MM:SS") SKIP
     "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
     "    No.      FECHA                                                       T O T A L      TOTAL       VALOR                  P R E C I O        " SKIP
     "COTIZACION  EMISION   C L I E N T E                  R.U.C.   VEND MON.    BRUTO        DSCTO.      VENTA       I.G.V.      V E N T A   ESTADO" SKIP
     "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*    xxx-xxxxxx 99/99/9999 123456789012345678901234567 12345678901 1234 1234 ->,>>>,>>9.99 ->>,>>9.99 ->,>>>,>>9.99 ->>,>>9.99 ->,>>>,>>9.99 123
*/
      WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 

 FOR EACH FacCPedm NO-LOCK WHERE FacCPedm.CodCia = S-CODCIA 
     AND FacCPedm.CodDiv = S-CODDIV 
     AND FacCPedm.CodDoc = "COT"    
     AND FacCPedm.FchPed >= F-desde 
     AND FacCPedm.FchPed <= F-hasta 
     BY FacCPedm.NroPed:

     /*{&new-page}.*/
     IF FacCPedm.Codmon = 1 THEN X-MON = "S/.". ELSE X-MON = "US$.".
        
     CASE FacCPedm.FlgEst :
         WHEN "P" THEN DO:
             X-EST = "PEN".
             IF FacCPedm.Codmon = 1 THEN DO:
                w-totbru [1] = w-totbru [1] + FacCPedm.ImpBrt.   
                w-totdsc [1] = w-totdsc [1] + FacCPedm.ImpDto.
                w-totval [1] = w-totval [1] + FacCPedm.ImpVta.
                w-totigv [1] = w-totigv [1] + FacCPedm.ImpIgv.
                w-totven [1] = w-totven [1] + FacCPedm.ImpTot.
             END.   
             ELSE DO:  
                w-totbru [2] = w-totbru [2] + FacCPedm.ImpBrt.   
                w-totdsc [2] = w-totdsc [2] + FacCPedm.ImpDto.
                w-totval [2] = w-totval [2] + FacCPedm.ImpVta.
                w-totigv [2] = w-totigv [2] + FacCPedm.ImpIgv.
                w-totven [2] = w-totven [2] + FacCPedm.ImpTot.                
             END.   
         END.   
         WHEN "C" THEN DO:
             X-EST = "CAN".
             IF FacCPedm.Codmon = 1 THEN DO:
                w-totbru [3] = w-totbru [3] + FacCPedm.ImpBrt.   
                w-totdsc [3] = w-totdsc [3] + FacCPedm.ImpDto.
                w-totval [3] = w-totval [3] + FacCPedm.ImpVta.
                w-totigv [3] = w-totigv [3] + FacCPedm.ImpIgv.
                w-totven [3] = w-totven [3] + FacCPedm.ImpTot.
             END.   
             ELSE DO:  
                w-totbru [4] = w-totbru [4] + FacCPedm.ImpBrt.   
                w-totdsc [4] = w-totdsc [4] + FacCPedm.ImpDto.
                w-totval [4] = w-totval [4] + FacCPedm.ImpVta.
                w-totigv [4] = w-totigv [4] + FacCPedm.ImpIgv.
                w-totven [4] = w-totven [4] + FacCPedm.ImpTot.                
             END.                
         END.   
         WHEN "A" THEN DO:
             X-EST = "ANU".       
             IF FacCPedm.Codmon = 1 THEN DO:
                w-totbru [5] = w-totbru [5] + FacCPedm.ImpBrt.   
                w-totdsc [5] = w-totdsc [5] + FacCPedm.ImpDto.
                w-totval [5] = w-totval [5] + FacCPedm.ImpVta.
                w-totigv [5] = w-totigv [5] + FacCPedm.ImpIgv.
                w-totven [5] = w-totven [5] + FacCPedm.ImpTot.
             END.   
             ELSE DO:  
                w-totbru [6] = w-totbru [6] + FacCPedm.ImpBrt.   
                w-totdsc [6] = w-totdsc [6] + FacCPedm.ImpDto.
                w-totval [6] = w-totval [6] + FacCPedm.ImpVta.
                w-totigv [6] = w-totigv [6] + FacCPedm.ImpIgv.
                w-totven [6] = w-totven [6] + FacCPedm.ImpTot.                
             END.                
         END.   
     END.        
               
     DISPLAY STREAM REPORT 
         FacCPedm.NroPed 
         FacCPedm.FchPed 
         FacCPedm.NomCli 
         FacCPedm.RucCli 
         FacCPedm.Codven
         X-MON           
         FacCPedm.ImpVta 
         FacCPedm.ImpDto 
         FacCPedm.ImpBrt 
         FacCPedm.ImpIgv 
         FacCPedm.ImpTot 
         X-EST WITH FRAME F-Cab.

 END.
 DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
    PUT STREAM REPORT "" skip. 
 END. 
 PUT STREAM REPORT "----------------------------------------------" SPACE(4) "----------------------------------------------" SPACE(4) "----------------------------------------------" SKIP.
 PUT STREAM REPORT "TOTAL CANCELADAS       SOLES        DOLARES   " SPACE(4) "TOTAL PENDIENTES       SOLES        DOLARES   " SPACE(4) "TOTAL ANULADAS         SOLES        DOLARES   " SKIP.
 PUT STREAM REPORT "----------------------------------------------" SPACE(4) "----------------------------------------------" SPACE(4) "----------------------------------------------" SKIP.
 PUT STREAM REPORT "Total Bruto     :" AT 1 w-totbru[3] AT 19  FORMAT "->,>>>,>>9.99" w-totbru[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[1] AT 69  FORMAT "->,>>>,>>9.99" w-totbru[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[5] AT 119 FORMAT "->,>>>,>>9.99" w-totbru[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Descuento       :" AT 1 w-totdsc[3] AT 19  FORMAT "->,>>>,>>9.99" w-totdsc[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[1] AT 69  FORMAT "->,>>>,>>9.99" w-totdsc[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[5] AT 119 FORMAT "->,>>>,>>9.99" w-totdsc[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Valor de Venta  :" AT 1 w-totval[3] AT 19  FORMAT "->,>>>,>>9.99" w-totval[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[1] AT 69  FORMAT "->,>>>,>>9.99" w-totval[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[5] AT 119 FORMAT "->,>>>,>>9.99" w-totval[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "I.G.V.          :" AT 1 w-totigv[3] AT 19  FORMAT "->,>>>,>>9.99" w-totigv[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[1] AT 69  FORMAT "->,>>>,>>9.99" w-totigv[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[5] AT 119 FORMAT "->,>>>,>>9.99" w-totigv[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Precio de Venta :" AT 1 w-totven[3] AT 19  FORMAT "->,>>>,>>9.99" w-totven[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[1] AT 69  FORMAT "->,>>>,>>9.99" w-totven[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[5] AT 119 FORMAT "->,>>>,>>9.99" w-totven[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prn-ven W-Win 
PROCEDURE prn-ven :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.

 DEFINE FRAME f-cab
     FacCPedm.NroPed FORMAT "XXX-XXXXXX"
     FacCPedm.FchPed 
     /*FacCPedm.FChEnt*/
     FacCPedm.NomCli FORMAT "X(27)"
     FacCPedm.RucCli FORMAT "X(11)"
     /*FacCPedm.CodPos FORMAT "X(4)"*/
     FacCPedm.Codven FORMAT "X(4)"
     X-MON           FORMAT "X(4)"
     FacCPedm.ImpBrt FORMAT "->,>>>,>>9.99"
     FacCPedm.ImpDto FORMAT "->>,>>9.99"
     FacCPedm.ImpVta FORMAT "->,>>>,>>9.99"
     FacCPedm.ImpIgv FORMAT "->>,>>9.99"
     FacCPedm.ImpTot FORMAT "->,>>>,>>9.99"
     X-EST           FORMAT "X(3)" SKIP
     HEADER
     {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
     {&PRN2} + {&PRN6A} + "( " + FacCPedm.CodDiv + ")" + {&PRN6B} + {&PRN4} AT 1 FORMAT "X(15)"
     {&PRN6A} + "RESUMEN DE COTIZACIONES MOSTRADOR" + {&PRN6B} AT 40 FORMAT "X(40)"
     {&PRN4} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
     {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} FORMAT "X(12)"
     {&PRN4} + "Fecha : " AT 138 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
     "Hora  : " AT 134 STRING(TIME,"HH:MM:SS") SKIP
     "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
     "    No.      FECHA                                                       T O T A L      TOTAL       VALOR                  P R E C I O        " SKIP
     "COTIZACION  EMISION   C L I E N T E                  R.U.C.   VEND MON.    BRUTO        DSCTO.      VENTA       I.G.V.      V E N T A   ESTADO" SKIP
     "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*    xxx-xxxxxx 99/99/9999 123456789012345678901234567 12345678901 1234 1234 ->,>>>,>>9.99 ->>,>>9.99 ->,>>>,>>9.99 ->>,>>9.99 ->,>>>,>>9.99 123
*/
      WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 

 FOR EACH FacCPedm NO-LOCK WHERE FacCPedm.CodCia = S-CODCIA 
     AND FacCPedm.CodDiv = S-CODDIV 
     AND FacCPedm.CodDoc = "COT"    
     AND FacCPedm.FchPed >= F-desde 
     AND FacCPedm.FchPed <= F-hasta 
     BREAK BY FacCPedm.CodVen:

     /* {&new-page}.*/

     DISPLAY STREAM REPORT WITH FRAME F-CAB.
     IF FIRST-OF(FacCPedm.CodVen) THEN DO:
         PUT STREAM REPORT SKIP "Vendedor: " FacCPedm.CodVen " ".
         FIND Gn-Ven OF FacCPedm NO-LOCK NO-ERROR.
         IF AVAILABLE Gn-Ven
             THEN PUT STREAM REPORT gn-ven.NomVen.
         PUT STREAM REPORT SKIP "----------" SKIP.
     END.
     IF FacCPedm.Codmon = 1 THEN X-MON = "S/.". ELSE X-MON = "US$.".
     CASE FacCPedm.FlgEst :
         WHEN "P" THEN DO:
             X-EST = "PEN".
             IF FacCPedm.Codmon = 1 THEN DO:
                w-totbru [1] = w-totbru [1] + FacCPedm.ImpBrt.   
                w-totdsc [1] = w-totdsc [1] + FacCPedm.ImpDto.
                w-totval [1] = w-totval [1] + FacCPedm.ImpVta.
                w-totigv [1] = w-totigv [1] + FacCPedm.ImpIgv.
                w-totven [1] = w-totven [1] + FacCPedm.ImpTot.
             END.   
             ELSE DO:  
                w-totbru [2] = w-totbru [2] + FacCPedm.ImpBrt.   
                w-totdsc [2] = w-totdsc [2] + FacCPedm.ImpDto.
                w-totval [2] = w-totval [2] + FacCPedm.ImpVta.
                w-totigv [2] = w-totigv [2] + FacCPedm.ImpIgv.
                w-totven [2] = w-totven [2] + FacCPedm.ImpTot.                
             END.   
         END.   
         WHEN "C" THEN DO:
             X-EST = "CAN".
             IF FacCPedm.Codmon = 1 THEN DO:
                w-totbru [3] = w-totbru [3] + FacCPedm.ImpBrt.   
                w-totdsc [3] = w-totdsc [3] + FacCPedm.ImpDto.
                w-totval [3] = w-totval [3] + FacCPedm.ImpVta.
                w-totigv [3] = w-totigv [3] + FacCPedm.ImpIgv.
                w-totven [3] = w-totven [3] + FacCPedm.ImpTot.
             END.   
             ELSE DO:  
                w-totbru [4] = w-totbru [4] + FacCPedm.ImpBrt.   
                w-totdsc [4] = w-totdsc [4] + FacCPedm.ImpDto.
                w-totval [4] = w-totval [4] + FacCPedm.ImpVta.
                w-totigv [4] = w-totigv [4] + FacCPedm.ImpIgv.
                w-totven [4] = w-totven [4] + FacCPedm.ImpTot.                
             END.                
         END.   
         WHEN "A" THEN DO:
             X-EST = "ANU".       
             IF FacCPedm.Codmon = 1 THEN DO:
                w-totbru [5] = w-totbru [5] + FacCPedm.ImpBrt.   
                w-totdsc [5] = w-totdsc [5] + FacCPedm.ImpDto.
                w-totval [5] = w-totval [5] + FacCPedm.ImpVta.
                w-totigv [5] = w-totigv [5] + FacCPedm.ImpIgv.
                w-totven [5] = w-totven [5] + FacCPedm.ImpTot.
             END.   
             ELSE DO:  
                w-totbru [6] = w-totbru [6] + FacCPedm.ImpBrt.   
                w-totdsc [6] = w-totdsc [6] + FacCPedm.ImpDto.
                w-totval [6] = w-totval [6] + FacCPedm.ImpVta.
                w-totigv [6] = w-totigv [6] + FacCPedm.ImpIgv.
                w-totven [6] = w-totven [6] + FacCPedm.ImpTot.                
             END.                
         END.   
    END.        
    DISPLAY STREAM REPORT 
        FacCPedm.NroPed 
        FacCPedm.FchPed 
        /*FacCPedm.FchEnt*/
        FacCPedm.NomCli 
        FacCPedm.RucCli 
        /*FacCPedm.CodPos*/
        FacCPedm.Codven
        X-MON           
        FacCPedm.ImpVta 
        FacCPedm.ImpDto 
        FacCPedm.ImpBrt 
        FacCPedm.ImpIgv 
        FacCPedm.ImpTot 
        X-EST WITH FRAME F-Cab.
    ACCUMULATE FacCPedm.ImpTot (TOTAL BY FacCPedm.CodVen).
    IF LAST-OF(FacCPedm.CodVen) THEN DO:
        UNDERLINE STREAM REPORT
            FacCPedm.ImpTot
            WITH FRAME F-Cab.
        DISPLAY STREAM REPORT
            "SUB-TOTAL >>>" @ FacCPedm.NomCli
            (ACCUM TOTAL BY FacCPedm.CodVen FacCPedm.ImpTot) @ FacCPedm.imptot
            WITH FRAME F-Cab.
    END.
 END.
 DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
    PUT STREAM REPORT "" skip. 
 END. 
 PUT STREAM REPORT "----------------------------------------------" SPACE(4) "----------------------------------------------" SPACE(4) "----------------------------------------------" SKIP.
 PUT STREAM REPORT "TOTAL CANCELADAS       SOLES        DOLARES   " SPACE(4) "TOTAL PENDIENTES       SOLES        DOLARES   " SPACE(4) "TOTAL ANULADAS         SOLES        DOLARES   " SKIP.
 PUT STREAM REPORT "----------------------------------------------" SPACE(4) "----------------------------------------------" SPACE(4) "----------------------------------------------" SKIP.
 PUT STREAM REPORT "Total Bruto     :" AT 1 w-totbru[3] AT 19  FORMAT "->,>>>,>>9.99" w-totbru[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[1] AT 69  FORMAT "->,>>>,>>9.99" w-totbru[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[5] AT 119 FORMAT "->,>>>,>>9.99" w-totbru[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Descuento       :" AT 1 w-totdsc[3] AT 19  FORMAT "->,>>>,>>9.99" w-totdsc[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[1] AT 69  FORMAT "->,>>>,>>9.99" w-totdsc[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[5] AT 119 FORMAT "->,>>>,>>9.99" w-totdsc[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Valor de Venta  :" AT 1 w-totval[3] AT 19  FORMAT "->,>>>,>>9.99" w-totval[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[1] AT 69  FORMAT "->,>>>,>>9.99" w-totval[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[5] AT 119 FORMAT "->,>>>,>>9.99" w-totval[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "I.G.V.          :" AT 1 w-totigv[3] AT 19  FORMAT "->,>>>,>>9.99" w-totigv[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[1] AT 69  FORMAT "->,>>>,>>9.99" w-totigv[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[5] AT 119 FORMAT "->,>>>,>>9.99" w-totigv[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Precio de Venta :" AT 1 w-totven[3] AT 19  FORMAT "->,>>>,>>9.99" w-totven[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[1] AT 69  FORMAT "->,>>>,>>9.99" w-totven[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[5] AT 119 FORMAT "->,>>>,>>9.99" w-totven[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prn-ven-2 W-Win 
PROCEDURE prn-ven-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.

 DEFINE FRAME f-cab
     HEADER
     {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
     {&PRN2} + {&PRN6A} + "( " + FacCPedm.CodDiv + ")" + {&PRN6B} + {&PRN4} AT 1 FORMAT "X(15)"
     {&PRN6A} + "RESUMEN DE COTIZACIONES MOSTRADOR" + {&PRN6B} AT 40 FORMAT "X(40)"
     {&PRN4} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
     {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} FORMAT "X(12)"
     {&PRN4} + "Fecha : " AT 138 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
     "Hora  : " AT 134 STRING(TIME,"HH:MM:SS") SKIP
     "--------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
     "    No.      FECHA     FECHA                                                             T O T A L      TOTAL       VALOR                  P R E C I O        " SKIP
     "COTIZACION  EMISION   ENTREGA    C L I E N T E                  R.U.C. POSTAL VEND MON.    BRUTO        DSCTO.      VENTA       I.G.V.      V E N T A   ESTADO" SKIP
     "--------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*    xxx-xxxxxx 99/99/9999 99/99/9999 123456789012345678901234567 12345678901 1234 1234 1234 ->,>>>,>>9.99 ->>,>>9.99 ->,>>>,>>9.99 ->>,>>9.99 ->,>>>,>>9.99 123
*/
      WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 

 FOR EACH FacCPedm NO-LOCK WHERE FacCPedm.CodCia = S-CODCIA 
     AND FacCPedm.CodDiv = S-CODDIV 
     AND FacCPedm.CodDoc = "COT"    
     AND FacCPedm.FchPed >= F-desde 
     AND FacCPedm.FchPed <= F-hasta 
     BREAK BY FacCPedm.CodVen:

     /*{&new-page}.*/

     IF FacCPedm.Codmon = 1 THEN X-MON = "S/.". ELSE X-MON = "US$.".
     
     CASE FacCPedm.FlgEst :
         WHEN "P" THEN DO:
             X-EST = "PEN".
             IF FacCPedm.Codmon = 1 THEN DO:
                w-totbru [1] = w-totbru [1] + FacCPedm.ImpBrt.   
                w-totdsc [1] = w-totdsc [1] + FacCPedm.ImpDto.
                w-totval [1] = w-totval [1] + FacCPedm.ImpVta.
                w-totigv [1] = w-totigv [1] + FacCPedm.ImpIgv.
                w-totven [1] = w-totven [1] + FacCPedm.ImpTot.
             END.   
             ELSE DO:  
                w-totbru [2] = w-totbru [2] + FacCPedm.ImpBrt.   
                w-totdsc [2] = w-totdsc [2] + FacCPedm.ImpDto.
                w-totval [2] = w-totval [2] + FacCPedm.ImpVta.
                w-totigv [2] = w-totigv [2] + FacCPedm.ImpIgv.
                w-totven [2] = w-totven [2] + FacCPedm.ImpTot.                
             END.   
         END.   
         WHEN "C" THEN DO:
             X-EST = "CAN".
             IF FacCPedm.Codmon = 1 THEN DO:
                w-totbru [3] = w-totbru [3] + FacCPedm.ImpBrt.   
                w-totdsc [3] = w-totdsc [3] + FacCPedm.ImpDto.
                w-totval [3] = w-totval [3] + FacCPedm.ImpVta.
                w-totigv [3] = w-totigv [3] + FacCPedm.ImpIgv.
                w-totven [3] = w-totven [3] + FacCPedm.ImpTot.
             END.   
             ELSE DO:  
                w-totbru [4] = w-totbru [4] + FacCPedm.ImpBrt.   
                w-totdsc [4] = w-totdsc [4] + FacCPedm.ImpDto.
                w-totval [4] = w-totval [4] + FacCPedm.ImpVta.
                w-totigv [4] = w-totigv [4] + FacCPedm.ImpIgv.
                w-totven [4] = w-totven [4] + FacCPedm.ImpTot.                
             END.                
         END.   
         WHEN "A" THEN DO:
             X-EST = "ANU".       
             IF FacCPedm.Codmon = 1 THEN DO:
                w-totbru [5] = w-totbru [5] + FacCPedm.ImpBrt.   
                w-totdsc [5] = w-totdsc [5] + FacCPedm.ImpDto.
                w-totval [5] = w-totval [5] + FacCPedm.ImpVta.
                w-totigv [5] = w-totigv [5] + FacCPedm.ImpIgv.
                w-totven [5] = w-totven [5] + FacCPedm.ImpTot.
             END.   
             ELSE DO:  
                w-totbru [6] = w-totbru [6] + FacCPedm.ImpBrt.   
                w-totdsc [6] = w-totdsc [6] + FacCPedm.ImpDto.
                w-totval [6] = w-totval [6] + FacCPedm.ImpVta.
                w-totigv [6] = w-totigv [6] + FacCPedm.ImpIgv.
                w-totven [6] = w-totven [6] + FacCPedm.ImpTot.                
             END.                
         END.   
    END. 
    
    ACCUMULATE FacCPedm.ImpTot (TOTAL BY FacCPedm.CodVen).
    IF LAST-OF(FacCPedm.CodVen) THEN DO:
        PUT STREAM REPORT SKIP "Vendedor: " FacCPedm.CodVen " ".
        FIND Gn-Ven OF FacCPedm NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-Ven 
            THEN PUT STREAM REPORT gn-ven.NomVen.
        PUT STREAM REPORT (ACCUM TOTAL BY FacCPedm.CodVen FacCPedm.ImpTot) FORMAT "->,>>>,>>9.99" SKIP(1).
    END.
 END.
 DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
    PUT STREAM REPORT "" skip. 
 END. 
 PUT STREAM REPORT "----------------------------------------------" SPACE(4) "----------------------------------------------" SPACE(4) "----------------------------------------------" SKIP.
 PUT STREAM REPORT "TOTAL CANCELADAS       SOLES        DOLARES   " SPACE(4) "TOTAL PENDIENTES       SOLES        DOLARES   " SPACE(4) "TOTAL ANULADAS         SOLES        DOLARES   " SKIP.
 PUT STREAM REPORT "----------------------------------------------" SPACE(4) "----------------------------------------------" SPACE(4) "----------------------------------------------" SKIP.
 PUT STREAM REPORT "Total Bruto     :" AT 1 w-totbru[3] AT 19  FORMAT "->,>>>,>>9.99" w-totbru[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[1] AT 69  FORMAT "->,>>>,>>9.99" w-totbru[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[5] AT 119 FORMAT "->,>>>,>>9.99" w-totbru[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Descuento       :" AT 1 w-totdsc[3] AT 19  FORMAT "->,>>>,>>9.99" w-totdsc[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[1] AT 69  FORMAT "->,>>>,>>9.99" w-totdsc[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[5] AT 119 FORMAT "->,>>>,>>9.99" w-totdsc[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Valor de Venta  :" AT 1 w-totval[3] AT 19  FORMAT "->,>>>,>>9.99" w-totval[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[1] AT 69  FORMAT "->,>>>,>>9.99" w-totval[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[5] AT 119 FORMAT "->,>>>,>>9.99" w-totval[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "I.G.V.          :" AT 1 w-totigv[3] AT 19  FORMAT "->,>>>,>>9.99" w-totigv[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[1] AT 69  FORMAT "->,>>>,>>9.99" w-totigv[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[5] AT 119 FORMAT "->,>>>,>>9.99" w-totigv[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Precio de Venta :" AT 1 w-totven[3] AT 19  FORMAT "->,>>>,>>9.99" w-totven[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[1] AT 69  FORMAT "->,>>>,>>9.99" w-totven[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[5] AT 119 FORMAT "->,>>>,>>9.99" w-totven[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
            /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN ASSIGN input-var-1 = "".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.
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

