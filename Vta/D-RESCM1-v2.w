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
/* DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0. */
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE f-tipos  AS CHAR FORMAT "X(3)".
DEFINE VARIABLE T-CMPBTE AS CHAR INIT "".
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE T-CLIEN  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-TIP    AS CHAR FORMAT "X(2)".
DEFINE VARIABLE X-SINANT AS DECI INIT 0.
DEFINE VAR C AS INTEGER.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR cl-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.
DEFINE SHARED VAR S-CODALM  AS CHAR.

 DEFINE VAR ESTADO AS CHARACTER.

DEFINE TEMP-TABLE T-CDOC LIKE Ccbcdocu.

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
&Scoped-Define ENABLED-OBJECTS RECT-48 RECT-5 r-sortea R-Condic R-Estado ~
FILL-IN-Serie f-tipo x-CodDiv f-clien f-vende f-desde f-hasta ~
FILL-IN-CndVta RADIO-SET-1 RB-NUMBER-COPIES B-impresoras RB-BEGIN-PAGE ~
RB-END-PAGE BUTTON-4 BtnDone btn-excel 
&Scoped-Define DISPLAYED-OBJECTS r-sortea R-Condic R-Estado FILL-IN-Serie ~
f-tipo x-CodDiv f-clien f-nomcli f-vende f-nomven f-desde f-hasta ~
FILL-IN-CndVta FILL-IN-Descripcion RADIO-SET-1 RB-NUMBER-COPIES ~
RB-BEGIN-PAGE RB-END-PAGE 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-archivo 
     IMAGE-UP FILE "IMG/pvstop":U
     LABEL "&Archivos.." 
     SIZE 5 BY 1.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btn-excel AUTO-GO 
     IMAGE-UP FILE "IMG/excel.bmp":U
     LABEL "Button 6" 
     SIZE 13 BY 1.54.

DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "&Done" 
     SIZE 13 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 4" 
     SIZE 13 BY 1.54.

DEFINE VARIABLE f-tipo AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Tipo Cmpbte." 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "Todos","Boleta","Factura","N/C","N/D","Letras","Ticket" 
     DROP-DOWN-LIST
     SIZE 12 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "x(5)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE f-clien AS CHARACTER FORMAT "XXXXXXXXXXX":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .69 NO-UNDO.

DEFINE VARIABLE f-nomven AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .69 NO-UNDO.

DEFINE VARIABLE f-vende AS CHARACTER FORMAT "XXX":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-CndVta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cond. Venta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Descripcion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Serie AS CHARACTER FORMAT "X(4)":U 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE RB-BEGIN-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "Página Desde" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-END-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 9999 
     LABEL "Página Hasta" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-NUMBER-COPIES AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "No. Copias" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-OUTPUT-FILE AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 12 NO-UNDO.

DEFINE VARIABLE R-Condic AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "C/Totales", 1,
"S/Totales", 2
     SIZE 14 BY 1.12
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE R-Estado AS CHARACTER INITIAL "C" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pendientes", "P",
"Anulados", "A",
"Cancelados", "C",
"Todos", ""
     SIZE 14 BY 2.27
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE r-sortea AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Documento", 1,
"Cliente", 2
     SIZE 14 BY 1.12
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.86 BY 5.77.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 3.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     r-sortea AT ROW 1.23 COL 35.72 NO-LABEL WIDGET-ID 36
     R-Condic AT ROW 1.23 COL 51.29 NO-LABEL WIDGET-ID 26
     R-Estado AT ROW 1.23 COL 67 NO-LABEL WIDGET-ID 30
     FILL-IN-Serie AT ROW 2.15 COL 12 COLON-ALIGNED WIDGET-ID 24
     f-tipo AT ROW 2.69 COL 49.86 COLON-ALIGNED WIDGET-ID 16
     x-CodDiv AT ROW 3.12 COL 12 COLON-ALIGNED WIDGET-ID 62
     f-clien AT ROW 4.04 COL 9 COLON-ALIGNED WIDGET-ID 6
     f-nomcli AT ROW 4.04 COL 20.29 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     f-vende AT ROW 4.77 COL 9 COLON-ALIGNED WIDGET-ID 18
     f-nomven AT ROW 4.77 COL 20.29 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     f-desde AT ROW 4.85 COL 52 COLON-ALIGNED WIDGET-ID 8
     f-hasta AT ROW 4.85 COL 69.29 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-CndVta AT ROW 5.62 COL 9 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-Descripcion AT ROW 5.62 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     RADIO-SET-1 AT ROW 7.92 COL 2.57 NO-LABEL WIDGET-ID 40
     RB-NUMBER-COPIES AT ROW 8.08 COL 70 COLON-ALIGNED WIDGET-ID 48
     B-impresoras AT ROW 8.92 COL 15.57 WIDGET-ID 4
     RB-BEGIN-PAGE AT ROW 9.08 COL 70 COLON-ALIGNED WIDGET-ID 44
     b-archivo AT ROW 9.92 COL 15.57 WIDGET-ID 2
     RB-END-PAGE AT ROW 10.08 COL 70 COLON-ALIGNED WIDGET-ID 46
     RB-OUTPUT-FILE AT ROW 10.15 COL 19.86 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     BUTTON-4 AT ROW 11.77 COL 3 WIDGET-ID 64
     BtnDone AT ROW 11.77 COL 16 WIDGET-ID 66
     btn-excel AT ROW 11.77 COL 29 WIDGET-ID 68
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 83.43 BY .62 AT ROW 6.77 COL 1.29 WIDGET-ID 56
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "Ordenado Por :" VIEW-AS TEXT
          SIZE 12.57 BY .62 AT ROW 1.35 COL 22.57 WIDGET-ID 60
          BGCOLOR 8 FONT 6
     " Rango de Fechas" VIEW-AS TEXT
          SIZE 16 BY .62 AT ROW 3.85 COL 59.43 WIDGET-ID 58
          BGCOLOR 8 FONT 6
     RECT-48 AT ROW 1 COL 1 WIDGET-ID 52
     RECT-5 AT ROW 7.5 COL 1 WIDGET-ID 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 84.86 BY 13.04
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "Resumen de Comprobantes"
         HEIGHT             = 13.04
         WIDTH              = 84.86
         MAX-HEIGHT         = 32.46
         MAX-WIDTH          = 205.72
         VIRTUAL-HEIGHT     = 32.46
         VIRTUAL-WIDTH      = 205.72
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
/* SETTINGS FOR BUTTON b-archivo IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       b-archivo:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN f-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-nomven IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Descripcion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RB-OUTPUT-FILE IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RB-OUTPUT-FILE:HIDDEN IN FRAME F-Main           = TRUE.

ASSIGN 
       RECT-48:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Resumen de Comprobantes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen de Comprobantes */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-archivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-archivo W-Win
ON CHOOSE OF b-archivo IN FRAME F-Main /* Archivos.. */
DO:
     SYSTEM-DIALOG GET-FILE RB-OUTPUT-FILE
        TITLE      "Archivo de Impresi¢n ..."
        FILTERS    "Archivos Impresi¢n (*.txt)"   "*.txt",
                   "Todos (*.*)"   "*.*"
        INITIAL-DIR "./txt"
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
      
    IF OKpressed = TRUE THEN
        RB-OUTPUT-FILE:SCREEN-VALUE = RB-OUTPUT-FILE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-impresoras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-impresoras W-Win
ON CHOOSE OF B-impresoras IN FRAME F-Main
DO:
    SYSTEM-DIALOG PRINTER-SETUP.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-excel W-Win
ON CHOOSE OF btn-excel IN FRAME F-Main /* Button 6 */
DO:
    RUN Asigna-Variables.
    IF r-sortea = 1 THEN RUN Excel-Doc.
    ELSE IF r-sortea = 2 THEN RUN Excel.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  RUN Asigna-Variables.
  DO WITH FRAME {&FRAME-NAME}:
      P-largo   = 66.
      P-Copias  = INPUT RB-NUMBER-COPIES.
      P-pagIni  = INPUT RB-BEGIN-PAGE.
      P-pagfin  = INPUT RB-END-PAGE.
      P-select  = INPUT RADIO-SET-1.
      P-archivo = INPUT RB-OUTPUT-FILE.
      P-detalle = "Impresora Local (EPSON)".
      P-name    = "Epson E/F/J/RX/LQ".
      P-device  = "PRN".

      IF P-select = 2 
         THEN P-archivo = SESSION:TEMP-DIRECTORY + 
              STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
      ELSE RUN setup-print.      
         IF P-select <> 1 
         THEN P-copias = 1.
  END.
  RUN Control-Impresion.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-clien
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-clien W-Win
ON LEAVE OF f-clien IN FRAME F-Main /* Cliente */
DO:
  F-clien = "".
  IF F-clien:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
          gn-clie.Codcli = F-clien:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie THEN F-Nomcli = gn-clie.Nomcli.
  END.
  DISPLAY F-NomCli WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-vende
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-vende W-Win
ON LEAVE OF f-vende IN FRAME F-Main /* Vendedor */
DO:
  F-vende = "".
  IF F-vende:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = F-vende:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
  END.
  DISPLAY F-NomVen WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CndVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CndVta W-Win
ON LEAVE OF FILL-IN-CndVta IN FRAME F-Main /* Cond. Venta */
DO:
  FILL-IN-Descripcion:SCREEN-VALUE = ''.
  FIND gn-convt WHERE gn-convt.codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt THEN FILL-IN-Descripcion:SCREEN-VALUE = gn-ConVt.Nombr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 W-Win
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME F-Main
DO:
    IF SELF:SCREEN-VALUE = "3"
    THEN ASSIGN b-archivo:VISIBLE = YES
                RB-OUTPUT-FILE:VISIBLE = YES
                b-archivo:SENSITIVE = YES
                RB-OUTPUT-FILE:SENSITIVE = YES.
    ELSE ASSIGN b-archivo:VISIBLE = NO
                RB-OUTPUT-FILE:VISIBLE = NO
                b-archivo:SENSITIVE = NO
                RB-OUTPUT-FILE:SENSITIVE = NO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN f-Desde f-hasta f-vende f-clien f-tipo r-sortea R-Estado R-Condic
        FILL-IN-CndVta FILL-IN-Descripcion FILL-IN-Serie
        x-CodDiv.
    
        IF f-desde = ? then do: MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
         APPLY "ENTRY":U to f-desde.
         RETURN NO-APPLY.   
        END.
        IF f-hasta = ? then do: MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
         APPLY "ENTRY":U to f-hasta.
         RETURN NO-APPLY.   
        END.   
        IF f-desde > f-hasta then do: MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
         APPLY "ENTRY":U to f-desde.
         RETURN NO-APPLY.
        END.
        
        CASE f-tipo:screen-value :
           WHEN "Todos" THEN DO:
                f-tipos  = "".
                T-cmpbte = "  RESUMEN DE COMPROBANTES   ". 
           END.     
           WHEN "Boleta"  THEN DO: 
                f-tipos = "BOL". 
                T-cmpbte = "     RESUMEN DE BOLETAS     ". 
           END.            
           WHEN "Factura" THEN DO: 
                f-tipos = "FAC".
                T-cmpbte = "     RESUMEN DE FACTURAS    ". 
           END.     
           WHEN "N/C"      THEN DO: 
                f-tipos = "N/C".
                T-cmpbte = "RESUMEN DE NOTAS DE CREDITO ". 
           END.     
           WHEN "N/D"      THEN DO: 
                f-tipos = "N/D".
                T-cmpbte = " RESUMEN DE NOTAS DE DEBITO ". 
           END.
           WHEN "Letras"      THEN DO: 
                f-tipos = "LET".
                T-cmpbte = "      RESUMEN DE LETRAS     ". 
           END.                               
           WHEN "Ticket"      THEN DO: 
                f-tipos = "TCK".
                T-cmpbte = "      RESUMEN DE TICKETS    ". 
           END.                               
        END.          
        IF f-vende <> "" THEN T-vende = "Vendedor :  " + f-vende + "  " + f-nomven.
        IF f-clien <> "" THEN T-clien = "Cliente :  " + f-clien.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 FOR EACH T-CDOC:
     DELETE T-CDOC.
 END.
 FOR EACH CcbcDocu NO-LOCK WHERE CcbcDocu.CodCia = S-CODCIA 
     AND CcbcDocu.CodDiv = x-CODDIV 
     /*AND CcbcDocu.DivOri = x-CODDIV */
     AND CcbcDocu.FchDoc >= F-desde 
     AND CcbcDocu.FchDoc <= F-hasta 
     AND CcbcDocu.CodDoc BEGINS f-tipos 
     AND CcbcDocu.CodDoc <> "G/R" 
     AND CcbcDocu.CodVen BEGINS f-vende 
     AND CcbcDocu.Codcli BEGINS f-clien 
     AND CcbcDocu.FlgEst BEGINS R-Estado 
     AND CcbCDocu.FmaPgo BEGINS FILL-IN-CndVta 
     AND CcbCDocu.NroDoc BEGINS FILL-IN-serie:
     CREATE T-CDOC.
     BUFFER-COPY Ccbcdocu 
         TO T-CDOC
         ASSIGN T-CDOC.imptot = Ccbcdocu.imptot - Ccbcdocu.ImpTot2 - Ccbcdocu.acubon[5].
     /* CASO DE FACTURAS CON APLICACION DE ADELANTOS */
     DEF VAR x-Factor AS DEC NO-UNDO.
     IF LOOKUP (Ccbcdocu.coddoc, 'FAC,BOL') > 0
         /*AND Ccbcdocu.TpoFac = 'R'*/
         AND Ccbcdocu.FlgEst <> 'A' 
         AND Ccbcdocu.ImpTot2 > 0
         THEN DO:
         /* Recalculamos Importes */
         ASSIGN
             /*T-CDOC.ImpTot = Ccbcdocu.ImpTot - Ccbcdocu.ImpTot2*/
             T-CDOC.Libre_d01 = Ccbcdocu.ImpTot.
         IF T-CDOC.ImpTot <= 0 THEN DO:
             ASSIGN
                 T-CDOC.ImpTot = 0
                 T-CDOC.ImpBrt = 0
                 T-CDOC.ImpExo = 0
                 T-CDOC.ImpDto = 0
                 T-CDOC.ImpVta = 0
                 T-CDOC.ImpIgv = 0.
         END.
         ELSE DO:
             x-Factor = T-CDOC.ImpTot / (Ccbcdocu.imptot - Ccbcdocu.acubon[5]).
             ASSIGN
                 T-CDOC.ImpVta = ROUND (Ccbcdocu.ImpVta * x-Factor, 2)
                 T-CDOC.ImpIgv = T-CDOC.ImpTot - T-CDOC.ImpVta.
             ASSIGN
                 T-CDOC.ImpBrt = T-CDOC.ImpVta + T-CDOC.ImpIsc + T-CDOC.ImpDto + T-CDOC.ImpExo.
         END.
     END.
     /* ******************************************** */
     /* CASO DE DOCUMENTOS DE UTILEX */
     IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,TCK') > 0
               AND Ccbcdocu.ImpDto2 > 0 THEN DO:
         T-CDOC.ImpDto = T-CDOC.ImpDto + Ccbcdocu.ImpDto2 / ( 1 + Ccbcdocu.PorIgv / 100).
     END.

 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Control-Impresion W-Win 
PROCEDURE Control-Impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO c-Copias = 1 to P-copias ON ERROR UNDO, LEAVE
      ON STOP UNDO, LEAVE:
      OUTPUT STREAM report TO NUL PAGED PAGE-SIZE 1000.
      c-Pagina = 0.
      RUN IMPRIMIR.
      OUTPUT STREAM report CLOSE.        
  END.
  OUTPUT STREAM report CLOSE.        
  
  IF NOT LASTKEY = KEYCODE("ESC") AND P-select = 2 THEN DO: 
        RUN bin/_vcat.p ( P-archivo ). 
  END.    
  HIDE FRAME F-Mensaje.  

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
  DISPLAY r-sortea R-Condic R-Estado FILL-IN-Serie f-tipo x-CodDiv f-clien 
          f-nomcli f-vende f-nomven f-desde f-hasta FILL-IN-CndVta 
          FILL-IN-Descripcion RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE 
          RB-END-PAGE 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-48 RECT-5 r-sortea R-Condic R-Estado FILL-IN-Serie f-tipo 
         x-CodDiv f-clien f-vende f-desde f-hasta FILL-IN-CndVta RADIO-SET-1 
         RB-NUMBER-COPIES B-impresoras RB-BEGIN-PAGE RB-END-PAGE BUTTON-4 
         BtnDone btn-excel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.   

    DEFINE VAR W-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
    DEFINE VAR W-TOTISC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVEN AS DECIMAL EXTENT 6 INIT 0.
    
    DEF VAR Titulo AS CHAR INIT '' FORMAT 'x(50)'.
    IF FILL-IN-Descripcion <> '' THEN Titulo = 'CONDICION DE VENTA: ' + FILL-IN-Descripcion.

    CASE R-Estado:
       WHEN "A" THEN ESTADO = "ANULADOS".
       WHEN "P" THEN ESTADO = "PENDIENTES".
       WHEN "C" THEN ESTADO = "CANCELADOS".
       WHEN "" THEN ESTADO = "TODOS".
    END CASE.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    {vta/header-excel.i}

    RUN Carga-Temporal.
    FOR EACH T-CDOC NO-LOCK WHERE
             T-CDOC.CodCia = S-CODCIA AND
             T-CDOC.CodDiv = x-CODDIV AND
             T-CDOC.FchDoc >= F-desde AND
             T-CDOC.FchDoc <= F-hasta AND 
             T-CDOC.CodDoc BEGINS f-tipos AND
             T-CDOC.CodDoc <> "G/R"   AND
             T-CDOC.Codcli BEGINS f-clien AND
             T-CDOC.CodVen BEGINS f-vende AND
             T-CDOC.FlgEst BEGINS R-Estado AND
             T-CDOC.FmaPgo BEGINS FILL-IN-CndVta
             AND T-CDOC.NroDoc BEGINS FILL-IN-serie
        BREAK BY T-CDOC.NomCli:

        IF T-CDOC.Codmon = 1 THEN X-MON = "S/.".
           ELSE X-MON = "US$.".

        IF T-CDOC.TipVta = "1" THEN X-TIP = "CT".
           ELSE X-TIP = "CR".   

        CASE T-CDOC.FlgEst :
             WHEN "P" THEN DO:
                X-EST = "PEN".
                IF T-CDOC.Codmon = 1 THEN DO:
                   w-totbru [1] = w-totbru [1] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totdsc [1] = w-totdsc [1] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totexo [1] = w-totexo [1] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totval [1] = w-totval [1] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totisc [1] = w-totisc [1] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totigv [1] = w-totigv [1] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totven [1] = w-totven [1] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   END.   
                ELSE DO:  
                   w-totbru [2] = w-totbru [2] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totdsc [2] = w-totdsc [2] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totexo [2] = w-totexo [2] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totval [2] = w-totval [2] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totisc [2] = w-totisc [2] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totigv [2] = w-totigv [2] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totven [2] = w-totven [2] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
             END.   
             WHEN "C" THEN DO:
                X-EST = "CAN".
                IF T-CDOC.Codmon = 1 THEN DO:
                   w-totbru [3] = w-totbru [3] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totdsc [3] = w-totdsc [3] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totexo [3] = w-totexo [3] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totval [3] = w-totval [3] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totisc [3] = w-totisc [3] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totigv [3] = w-totigv [3] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totven [3] = w-totven [3] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   END.   
                ELSE DO:  
                   w-totbru [4] = w-totbru [4] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totdsc [4] = w-totdsc [4] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totexo [4] = w-totexo [4] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totval [4] = w-totval [4] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totisc [4] = w-totisc [4] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totigv [4] = w-totigv [4] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totven [4] = w-totven [4] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.                
             END.   
             WHEN "A" THEN DO:
                X-EST = "ANU".       
                IF T-CDOC.Codmon = 1 THEN DO:
                   w-totbru [5] = w-totbru [5] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totdsc [5] = w-totdsc [5] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totexo [5] = w-totexo [5] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totval [5] = w-totval [5] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totisc [5] = w-totisc [5] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totigv [5] = w-totigv [5] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totven [5] = w-totven [5] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   END.   
                ELSE DO:  
                   w-totbru [6] = w-totbru [6] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totdsc [6] = w-totdsc [6] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totexo [6] = w-totexo [6] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totval [6] = w-totval [6] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totisc [6] = w-totisc [6] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totigv [6] = w-totigv [6] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totven [6] = w-totven [6] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.                
             END.   
        END.            
    
        /* set the column names for the Worksheet */
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.CodDoc.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + SUBSTRING(T-CDOC.NroDoc,1,3) + "-" + SUBSTRING(T-CDOC.NroDoc,4).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.FchDoc.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.NomCli.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + T-CDOC.RucCli.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + T-CDOC.Codven.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = X-MON.
        cRange = "H" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpBrt * -1 ).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpBrt.
        cRange = "I" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpDto * -1).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpDto.
        cRange = "J" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpVta * -1).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpVta.
        cRange = "K" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpIgv * -1).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpIgv.
        cRange = "L" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpTot * -1).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpTot.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = X-TIP.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = X-EST.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.UsuAnu.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = X-TIP.
    END.

    /***************************/
    iCount = iCount + 4.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL GENERAL".

    /*Totales Canceladas*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL CANCELADAS".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL PENDIENTES".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL ANULADAS".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".


    /*Detalle Totales Bruto*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Bruto".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[6].

    /*Detalle Totales Descuento*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descuento".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[6].

    /*Detalle Totales Exonerado*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Exonerado".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[6].

    /*Detalle Totales Valor Venta*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Valor Venta".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[6]. 

    /*Detalle Totales ISC*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.S.C".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[6].  

    /*Detalle Totales IGV*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.G.V".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[6]. 

    /*Detalle Totales Precio de Venta*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.G.V".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[6]. 

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-Doc W-Win 
PROCEDURE Excel-Doc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO. 

    DEFINE VAR W-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
    DEFINE VAR W-TOTISC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVEN AS DECIMAL EXTENT 6 INIT 0.
    
    DEFINE VAR M-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
    DEFINE VAR M-TOTISC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTVEN AS DECIMAL EXTENT 6 INIT 0.
     
    DEFINE VAR fImpLin  AS DEC INIT 0 NO-UNDO.    
    DEF VAR Titulo AS CHAR INIT '' FORMAT 'x(50)'.
    IF FILL-IN-Descripcion <> '' THEN Titulo = 'CONDICION DE VENTA: ' + FILL-IN-Descripcion.

    CASE R-Estado:
       WHEN "A" THEN ESTADO = "ANULADOS".
       WHEN "P" THEN ESTADO = "PENDIENTES".
       WHEN "C" THEN ESTADO = "CANCELADOS".
       WHEN "" THEN ESTADO = "TODOS".
    END CASE.       

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).
    
    RUN Carga-Temporal.
    FOR EACH T-CDOC NO-LOCK WHERE
        T-CDOC.CodCia = S-CODCIA AND
        T-CDOC.CodDiv = x-CODDIV AND
        T-CDOC.FchDoc >= F-desde AND
        T-CDOC.FchDoc <= F-hasta AND 
        T-CDOC.CodDoc BEGINS f-tipos AND
        T-CDOC.CodDoc <> "G/R" AND
        T-CDOC.CodVen BEGINS f-vende AND
        T-CDOC.Codcli BEGINS f-clien AND
        T-CDOC.FlgEst BEGINS R-Estado AND
        T-CDOC.FmaPgo BEGINS FILL-IN-CndVta
        AND T-CDOC.NroDoc BEGINS FILL-IN-serie
        USE-INDEX LLAVE10
        BREAK BY T-CDOC.CodCia
        BY T-CDOC.CodDiv BY T-CDOC.CodDoc BY T-CDOC.NroDoc:
    
        IF T-CDOC.Codmon = 1 THEN X-MON = "S/.".
           ELSE X-MON = "US$.".
        IF T-CDOC.TipVta = "1" THEN X-TIP = "CT".
           ELSE X-TIP = "CR".   
    
        {vta/resdoc-1.i}.
    
        C = C + 1.
        fImpLin = 0.
        FOR EACH ccbddocu OF T-CDOC NO-LOCK WHERE implin < 0:
           fImpLin = fImpLin + ccbddocu.implin.
        END.
        X-SINANT = ABSOLUTE (fImpLin).

        IF FIRST-OF( T-CDOC.CodDoc) THEN DO:
            {vta/header-excel.i}.
        END.

        /* set the column names for the Worksheet */
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.CodDoc.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + SUBSTRING(T-CDOC.NroDoc,1,3) + "-" + SUBSTRING(T-CDOC.NroDoc,4).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.FchDoc.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.NomCli.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + T-CDOC.RucCli.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + T-CDOC.Codven.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = X-MON.
        cRange = "H" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpBrt * -1 ).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpBrt.
        cRange = "I" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpDto * -1).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpDto.
        cRange = "J" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpVta * -1).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpVta.
        cRange = "K" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpIgv * -1).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpIgv.
        cRange = "L" + cColumn.
        IF T-CDOC.CodDoc = "N/C" THEN
            chWorkSheet:Range(cRange):Value = (T-CDOC.ImpTot * -1).
        ELSE chWorkSheet:Range(cRange):Value = T-CDOC.ImpTot.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = X-SINANT.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = X-TIP + " " + X-EST.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.UsuAnu.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = T-CDOC.NroCard. 

        IF R-Condic = 1 THEN DO:
            IF LAST-OF(T-CDOC.CodDoc) THEN DO:
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = "-----------".
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Value = "-----------".
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Value = "-----------".
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = "-----------".
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = "-----------".

                /***************************/
                iCount = iCount + 4.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "TOTAL : ".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = T-CDOC.CodDoc.

                /*Totales Canceladas*/
                iCount = iCount + 4.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "TOTAL CANCELADAS".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = "SOLES".
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = "DOLARES".
                cRange = "F" + cColumn.
                chWorkSheet:Range(cRange):Value = "TOTAL PENDIENTES".
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = "SOLES".
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = "DOLARES".
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Value = "TOTAL ANULADAS".
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = "SOLES".
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = "DOLARES".

                /*Detalle Totales Bruto*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "Total Bruto".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[6].
                
                /*Detalle Totales Descuento*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "Descuento".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[6].

                /*Detalle Totales Exonerado*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "Exonerado".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[6].

                /*Detalle Totales Valor Venta*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "Valor Venta".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[6].         

                /*Detalle Totales ISC*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "I.S.C".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[6].  
                
                /*Detalle Totales IGV*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "I.G.V".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[6]. 

                /*Detalle Totales Precio de Venta*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "Precio de Venta".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[6]. 

                M-TOTBRU = 0.
                M-TOTDSC = 0.
                M-TOTEXO = 0.
                M-TOTVAL = 0.  
                M-TOTISC = 0.
                M-TOTIGV = 0.
                M-TOTVEN = 0.

                iCount = iCount + 1.
            END.
        END.
    END.

    /***************************/
    iCount = iCount + 4.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL GENERAL".

    /*Totales Canceladas*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL CANCELADAS".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL PENDIENTES".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL ANULADAS".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".


    /*Detalle Totales Bruto*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Bruto".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[6].

    /*Detalle Totales Descuento*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descuento".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[6].

    /*Detalle Totales Exonerado*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Exonerado".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[6].

    /*Detalle Totales Valor Venta*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Valor Venta".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[6]. 

    /*Detalle Totales ISC*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.S.C".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[6].  

    /*Detalle Totales IGV*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.G.V".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[6]. 

    /*Detalle Totales Precio de Venta*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.G.V".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[6]. 

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR W-Win 
PROCEDURE IMPRIMIR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF r-sortea = 1 THEN 
       RUN prndoc.
    IF r-sortea = 2 THEN  
       RUN prncli.    

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
  ASSIGN
      f-desde = TODAY
      f-hasta = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Gn-Divi WHERE Gn-Divi.codcia = s-codcia NO-LOCK:
        x-CodDiv:ADD-LAST(Gn-Divi.coddiv).
    END.
    x-CodDiv:SCREEN-VALUE = s-CodDiv.
    APPLY 'VALUE-CHANGED':U TO x-CodDiv.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NEW-PAGE W-Win 
PROCEDURE NEW-PAGE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    c-Pagina = c-Pagina + 1.
    IF c-Pagina > P-pagfin
    THEN RETURN ERROR.
    DISPLAY c-Pagina WITH FRAME f-mensaje.
    IF c-Pagina > 1 THEN PAGE STREAM report.
    IF P-pagini = c-Pagina 
    THEN DO:
        OUTPUT STREAM report CLOSE.
        IF P-select = 1 
        THEN DO:
               OUTPUT STREAM report TO PRINTER NO-MAP NO-CONVERT UNBUFFERED
                    PAGED PAGE-SIZE 1000.
               PUT STREAM report CONTROL P-reset NULL P-flen NULL P-config NULL.
        END.
        ELSE DO:
            OUTPUT STREAM report TO VALUE ( P-archivo ) NO-MAP NO-CONVERT UNBUFFERED
                 PAGED PAGE-SIZE 1000.
            IF P-select = 3 THEN
                PUT STREAM report CONTROL P-reset P-flen P-config.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prncli W-Win 
PROCEDURE prncli :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR W-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTISC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL EXTENT 6 INIT 0.

DEF VAR Titulo AS CHAR INIT '' FORMAT 'x(50)'.
IF FILL-IN-Descripcion <> '' THEN Titulo = 'CONDICION DE VENTA: ' + FILL-IN-Descripcion.

 CASE R-Estado:
    WHEN "A" THEN ESTADO = "ANULADOS".
    WHEN "P" THEN ESTADO = "PENDIENTES".
    WHEN "C" THEN ESTADO = "CANCELADOS".
    WHEN "" THEN ESTADO = "TODOS".
 END CASE.

 DEFINE FRAME f-cab
        T-CDOC.CodDoc FORMAT "XXX"
        T-CDOC.NroDoc FORMAT "XXX-XXXXXXXXX"
        T-CDOC.FchDoc 
        T-CDOC.NomCli FORMAT "X(23)"
        T-CDOC.RucCli FORMAT "X(11)"
        T-CDOC.Codven FORMAT "X(4)"
        X-MON           FORMAT "X(4)"
        T-CDOC.ImpBrt FORMAT "->>>>,>>9.99"
        T-CDOC.ImpDto FORMAT "->,>>9.99"
        T-CDOC.ImpVta FORMAT "->>>>,>>9.99"
        T-CDOC.ImpIgv FORMAT "->,>>9.99"
        T-CDOC.ImpTot FORMAT "->>>>,>>9.99"
        X-TIP           FORMAT "X(2)"
        X-EST           FORMAT "X(3)"
        T-CDOC.UsuAnu FORMAT "X(8)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + T-CDOC.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + T-CMPBTE  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN4} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        ESTADO FORMAT "X(25)" SKIP
        Titulo SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                                   T O T A L      TOTAL       VALOR             P R E C I O         USUARIO " SKIP
        "DOC  DOCUMENTO  EMISION   C L I E N T E               R.U.C.  VEND MON.    BRUTO        DSCTO.      VENTA     I.G.V.   V E N T A   ESTADO ANULAC. " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------" SKIP         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.         
         
RUN Carga-Temporal.

 FOR EACH T-CDOC NO-LOCK
     BY T-CDOC.NomCli:
     {&NEW-PAGE}.
     IF T-CDOC.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".
     
     IF T-CDOC.TipVta = "1" THEN X-TIP = "CT".
        ELSE X-TIP = "CR".   

     CASE T-CDOC.FlgEst :
          WHEN "P" THEN DO:
             X-EST = "PEN".
             IF T-CDOC.Codmon = 1 THEN DO:
                w-totbru [1] = w-totbru [1] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [1] = w-totdsc [1] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [1] = w-totexo [1] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [1] = w-totval [1] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [1] = w-totisc [1] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [1] = w-totigv [1] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [1] = w-totven [1] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
             ELSE DO:  
                w-totbru [2] = w-totbru [2] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [2] = w-totdsc [2] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [2] = w-totexo [2] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [2] = w-totval [2] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [2] = w-totisc [2] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [2] = w-totigv [2] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [2] = w-totven [2] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
             END.   
          END.   
          WHEN "C" THEN DO:
             X-EST = "CAN".
             IF T-CDOC.Codmon = 1 THEN DO:
                w-totbru [3] = w-totbru [3] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [3] = w-totdsc [3] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [3] = w-totexo [3] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [3] = w-totval [3] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [3] = w-totisc [3] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [3] = w-totigv [3] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [3] = w-totven [3] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
             ELSE DO:  
                w-totbru [4] = w-totbru [4] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [4] = w-totdsc [4] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [4] = w-totexo [4] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [4] = w-totval [4] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [4] = w-totisc [4] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [4] = w-totigv [4] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [4] = w-totven [4] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
             END.                
          END.   
          WHEN "A" THEN DO:
             X-EST = "ANU".       
             IF T-CDOC.Codmon = 1 THEN DO:
                w-totbru [5] = w-totbru [5] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [5] = w-totdsc [5] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [5] = w-totexo [5] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [5] = w-totval [5] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [5] = w-totisc [5] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [5] = w-totigv [5] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [5] = w-totven [5] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
             ELSE DO:  
                w-totbru [6] = w-totbru [6] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [6] = w-totdsc [6] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [6] = w-totexo [6] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [6] = w-totval [6] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [6] = w-totisc [6] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [6] = w-totigv [6] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [6] = w-totven [6] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
             END.                
          END.   
     END.        

     DISPLAY STREAM REPORT 
        T-CDOC.CodDoc 
        T-CDOC.NroDoc 
        T-CDOC.FchDoc 
        T-CDOC.NomCli 
        T-CDOC.RucCli 
        T-CDOC.Codven
        X-MON           
        (T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpVta
        (T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpDto
        (T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpBrt
        (T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpIgv
        (T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpTot
        X-EST 
        T-CDOC.UsuAnu
        X-TIP WITH FRAME F-Cab.
        
 END.
 
 DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
    PUT STREAM REPORT "" skip. 
 END.   
 
 PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
 PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
 PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
 PUT STREAM REPORT "Total Bruto     :" AT 1 w-totbru[3] AT 19  FORMAT "->,>>>,>>9.99" w-totbru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[1] AT 69  FORMAT "->>,>>9.99"    w-totbru[2] AT 82  FORMAT "->>,>>9.99"  SPACE(4) "Total Bruto     :"
                                            w-totbru[5] AT 116 FORMAT "->>,>>9.99"    w-totbru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
 PUT STREAM REPORT "Descuento       :" AT 1 w-totdsc[3] AT 19  FORMAT "->,>>>,>>9.99" w-totdsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[1] AT 69  FORMAT "->>,>>9.99"   w-totdsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[5] AT 116 FORMAT "->>,>>9.99"   w-totdsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 PUT STREAM REPORT "Exonerado       :" AT 1 w-totexo[3] AT 19  FORMAT "->,>>>,>>9.99" w-totexo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Exonerado       :"
                                            w-totexo[1] AT 69  FORMAT "->>,>>9.99"   w-totexo[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "Exonerado       :"
                                            w-totexo[5] AT 116 FORMAT "->>,>>9.99"   w-totexo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 PUT STREAM REPORT "Valor de Venta  :" AT 1 w-totval[3] AT 19  FORMAT "->,>>>,>>9.99" w-totval[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[1] AT 69  FORMAT "->>,>>9.99"   w-totval[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[5] AT 116 FORMAT "->>,>>9.99"   w-totval[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 PUT STREAM REPORT "I.S.C.          :" AT 1 w-totisc[3] AT 19  FORMAT "->,>>>,>>9.99" w-totisc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "I.S.C.          :"
                                            w-totisc[1] AT 69  FORMAT "->>,>>9.99"   w-totisc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "I.S.C.          :"
                                            w-totisc[5] AT 116 FORMAT "->>,>>9.99"   w-totisc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 PUT STREAM REPORT "I.G.V.          :" AT 1 w-totigv[3] AT 19  FORMAT "->,>>>,>>9.99" w-totigv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[1] AT 69  FORMAT "->>,>>9.99"   w-totigv[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[5] AT 116 FORMAT "->>,>>9.99"   w-totigv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 PUT STREAM REPORT "Precio de Venta :" AT 1 w-totven[3] AT 19  FORMAT "->,>>>,>>9.99" w-totven[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[1] AT 69  FORMAT "->>,>>9.99"   w-totven[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[5] AT 116 FORMAT "->>,>>9.99"   w-totven[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 

 OUTPUT STREAM REPORT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prndoc W-Win 
PROCEDURE prndoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR W-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTISC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL EXTENT 6 INIT 0.

 DEFINE VAR M-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR M-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR M-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR M-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
 DEFINE VAR M-TOTISC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR M-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR M-TOTVEN AS DECIMAL EXTENT 6 INIT 0.
 
 DEFINE VAR fImpLin  AS DEC INIT 0 NO-UNDO.

DEF VAR Titulo AS CHAR INIT '' FORMAT 'x(50)'.
IF FILL-IN-Descripcion <> '' THEN Titulo = 'CONDICION DE VENTA: ' + FILL-IN-Descripcion.

 C = 1.    
 
 CASE R-Estado:
    WHEN "A" THEN ESTADO = "ANULADOS".
    WHEN "P" THEN ESTADO = "PENDIENTES".
    WHEN "C" THEN ESTADO = "CANCELADOS".
    WHEN "" THEN ESTADO = "TODOS".
 END CASE.
 
 DEFINE FRAME f-cab
        T-CDOC.CodDoc FORMAT "XXX"
        T-CDOC.NroDoc FORMAT "XXX-XXXXXXXXX"
        T-CDOC.FchDoc FORMAT '99/99/99'
        T-CDOC.NomCli FORMAT "X(20)"
        T-CDOC.RucCli FORMAT "X(11)"
        T-CDOC.Codven FORMAT "X(4)"
        X-MON           FORMAT "X(3)"
        T-CDOC.ImpBrt FORMAT "->>>>,>>9.99"
        T-CDOC.ImpDto FORMAT "->>>>9.99"
        T-CDOC.ImpVta FORMAT "->>>>,>>9.99"
        T-CDOC.ImpIgv FORMAT "->>>>9.99"
        T-CDOC.ImpTot FORMAT "->>>>,>>9.99"
        X-SINANT        FORMAT "->>>,>>9.99"
        X-TIP           FORMAT "X(2)"
        X-EST           FORMAT "X(3)"
        T-CDOC.UsuAnu FORMAT "X(8)"
        T-CDOC.NroCard FORMAT "X(6)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + T-CDOC.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + T-CMPBTE  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN4} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        ESTADO FORMAT "X(25)" SKIP 
        Titulo SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                             T O T A L      TOTAL       VALOR             P R E C I O PRECIO VENTA        USUARIO        " SKIP
        "DOC  DOCUMENTO  EMISION C L I E N T E            R.U.C.  VEND MON    BRUTO        DSCTO.      VENTA     I.G.V.   V E N T A  SIN ANTICIPO ESTADO ANULAC. TARJETA" SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
     /*  XXX XXX-XXXXXX 99/99/99 12345678901234567890 12345678901 1234 123 ->>>>,>>9.99 ->>>>9.99 ->>>>,>>9.99 ->>>>9.99 ->>>>,>>9.99 ->>>,>>9.99 XX XXX XXXXXXXX 123456
     */
         
     WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

 RUN Carga-Temporal.
  
 FOR EACH T-CDOC NO-LOCK
           USE-INDEX LLAVE10
      BREAK BY T-CDOC.CodCia
            BY T-CDOC.CodDiv
            BY T-CDOC.CodDoc
      BY T-CDOC.NroDoc:
      {&NEW-PAGE}.

      IF T-CDOC.Codmon = 1 THEN X-MON = "S/.".
         ELSE X-MON = "US$.".
      IF T-CDOC.TipVta = "1" THEN X-TIP = "CT".
         ELSE X-TIP = "CR".   

      {vta/resdoc-1.i}.

      C = C + 1.
      fImpLin = 0.
      FOR EACH ccbddocu OF ccbcdocu NO-LOCK WHERE implin < 0:
         fImpLin = fImpLin + ccbddocu.implin.
      END.
      X-SINANT = ABSOLUTE (fImpLin).
      x-SinAnt = T-CDOC.Libre_d01.
      DISPLAY STREAM REPORT 
         T-CDOC.CodDoc 
         T-CDOC.NroDoc 
         T-CDOC.FchDoc 
         T-CDOC.NomCli 
         T-CDOC.RucCli 
         T-CDOC.Codven
         X-MON           
         (T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpVta
         (T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpDto
         (T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpBrt
         (T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpIgv
         (T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1)) @ T-CDOC.ImpTot
         X-SINANT 
         X-EST 
         X-TIP
         T-CDOC.UsuAnu
         T-CDOC.NroCard
          WITH FRAME F-Cab.

      IF R-Condic = 1 THEN DO:
         IF LAST-OF(T-CDOC.CodDoc) THEN DO:
            UNDERLINE STREAM REPORT 
                      T-CDOC.ImpVta
                      T-CDOC.ImpDto
                      T-CDOC.ImpBrt
                      T-CDOC.ImpIgv
                      T-CDOC.ImpTot
                WITH FRAME F-Cab.

             /***************************/
              DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
                 PUT STREAM REPORT "" skip. 
              END.   

              PUT STREAM REPORT "TOTAL : " T-CDOC.CodDoc SKIP.
              PUT STREAM REPORT "----------------------------------------------" SPACE(2) "----------------------------------------------" SPACE(2) "------------------------------------------" SKIP.
              PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES    " SPACE(2) "TOTAL PENDIENTES      SOLES       DOLARES     " SPACE(2) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
              PUT STREAM REPORT "----------------------------------------------" SPACE(2) "----------------------------------------------" SPACE(2) "------------------------------------------" SKIP.
              PUT STREAM REPORT "Total Bruto     :" AT 1 m-totbru[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totbru[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                "Total Bruto     :"      m-totbru[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totbru[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                "Total Bruto     :"      m-totbru[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totbru[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
              PUT STREAM REPORT "Descuento       :" AT 1 m-totdsc[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totdsc[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                "Descuento       :"      m-totdsc[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totdsc[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                "Descuento       :"      m-totdsc[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totdsc[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
              PUT STREAM REPORT "Exonerado       :" AT 1 m-totexo[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totexo[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                "Exonerado       :"      m-totexo[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totexo[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                "Exonerado       :"      m-totexo[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totexo[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
              PUT STREAM REPORT "Valor de Venta  :" AT 1 m-totval[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totval[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                "Valor de Venta  :"      m-totval[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totval[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                "Valor de Venta  :"      m-totval[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totval[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
              PUT STREAM REPORT "I.S.C.          :" AT 1 m-totisc[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totisc[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                "I.S.C.          :"      m-totisc[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totisc[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                "I.S.C.          :"      m-totisc[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totisc[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
              PUT STREAM REPORT "I.G.V.          :" AT 1 m-totigv[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totigv[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                "I.G.V.          :"      m-totigv[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totigv[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                "I.G.V.          :"      m-totigv[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totigv[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
              PUT STREAM REPORT "Precio de Venta :" AT 1 m-totven[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totven[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                "Precio de Venta :"      m-totven[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totven[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                                "Precio de Venta :"      m-totven[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totven[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
             /*****************************/

             M-TOTBRU = 0.
             M-TOTDSC = 0.
             M-TOTEXO = 0.
             M-TOTVAL = 0.  
             M-TOTISC = 0.
             M-TOTIGV = 0.
             M-TOTVEN = 0.

          END.
      END.
  END.


 DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
    PUT STREAM REPORT "" skip. 
 END.   
 
 PUT STREAM REPORT "" SKIP. 
 PUT STREAM REPORT "TOTAL GENERAL " SKIP.
 PUT STREAM REPORT "----------------------------------------------" SPACE(2) "----------------------------------------------" SPACE(2) "------------------------------------------" SKIP.
 PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES    " SPACE(2) "TOTAL PENDIENTES      SOLES       DOLARES     " SPACE(2) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
 PUT STREAM REPORT "----------------------------------------------" SPACE(2) "----------------------------------------------" SPACE(2) "------------------------------------------" SKIP.
 PUT STREAM REPORT "Total Bruto     :" AT 1 w-totbru[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totbru[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Total Bruto     :"      w-totbru[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totbru[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Total Bruto     :"      w-totbru[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totbru[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Descuento       :" AT 1 w-totdsc[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totdsc[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Descuento       :"      w-totdsc[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totdsc[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Descuento       :"      w-totdsc[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totdsc[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Exonerado       :" AT 1 w-totexo[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totexo[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Exonerado       :"      w-totexo[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totexo[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Exonerado       :"      w-totexo[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totexo[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Valor de Venta  :" AT 1 w-totval[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totval[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Valor de Venta  :"      w-totval[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totval[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Valor de Venta  :"      w-totval[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totval[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "I.S.C.          :" AT 1 w-totisc[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totisc[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "I.S.C.          :"      w-totisc[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totisc[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "I.S.C.          :"      w-totisc[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totisc[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "I.G.V.          :" AT 1 w-totigv[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totigv[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "I.G.V.          :"      w-totigv[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totigv[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "I.G.V.          :"      w-totigv[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totigv[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Precio de Venta :" AT 1 w-totven[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totven[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Precio de Venta :"      w-totven[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totven[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Precio de Venta :"      w-totven[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totven[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 
 OUTPUT STREAM REPORT CLOSE.
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-parametros W-Win 
PROCEDURE Procesa-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-parametros W-Win 
PROCEDURE Recoge-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RemVar W-Win 
PROCEDURE RemVar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER IN-VAR AS CHARACTER.
    DEFINE OUTPUT PARAMETER OU-VAR AS CHARACTER.
    DEFINE VARIABLE P-pos AS INTEGER.
    OU-VAR = IN-VAR.
    IF P-select = 2 THEN DO:
        OU-VAR = "".
        RETURN.
    END.
    P-pos =  INDEX(OU-VAR, "[NULL]" ).
    IF P-pos <> 0
    THEN OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) +
                     CHR(0) + SUBSTR(OU-VAR, P-pos + 6).
    P-pos =  INDEX(OU-VAR, "[#B]" ).
    IF P-pos <> 0
    THEN OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) +
                     CHR(P-Largo) + SUBSTR(OU-VAR, P-pos + 4).
    P-pos =  INDEX(OU-VAR, "[#]" ).
    IF P-pos <> 0
    THEN OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) +
                     STRING(P-Largo, ">>9" ) + SUBSTR(OU-VAR, P-pos + 3).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setup-print W-Win 
PROCEDURE setup-print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND integral.P-Codes WHERE integral.P-Codes.Name = P-name NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.P-Codes
    THEN DO:
        MESSAGE "Invalido Tabla de Impresora" SKIP
                "configurado al Terminal" XTerm
                VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* Configurando Variables de Impresion */
    RUN RemVar (INPUT integral.P-Codes.Reset,    OUTPUT P-Reset).
    RUN RemVar (INPUT integral.P-Codes.Flen,     OUTPUT P-Flen).
    RUN RemVar (INPUT integral.P-Codes.C6lpi,    OUTPUT P-6lpi).
    RUN RemVar (INPUT integral.P-Codes.C8lpi,    OUTPUT P-8lpi).
    RUN RemVar (INPUT integral.P-Codes.C10cpi,   OUTPUT P-10cpi).
    RUN RemVar (INPUT integral.P-Codes.C12cpi,   OUTPUT P-12cpi).
    RUN RemVar (INPUT integral.P-Codes.C15cpi,   OUTPUT P-15cpi).
    RUN RemVar (INPUT integral.P-Codes.C20cpi,   OUTPUT P-20cpi).
    RUN RemVar (INPUT integral.P-Codes.Landscap, OUTPUT P-Landscap).
    RUN RemVar (INPUT integral.P-Codes.Portrait, OUTPUT P-Portrait).
    RUN RemVar (INPUT integral.P-Codes.DobleOn,  OUTPUT P-DobleOn).
    RUN RemVar (INPUT integral.P-Codes.DobleOff, OUTPUT P-DobleOff).
    RUN RemVar (INPUT integral.P-Codes.BoldOn,   OUTPUT P-BoldOn).
    RUN RemVar (INPUT integral.P-Codes.BoldOff,  OUTPUT P-BoldOff).
    RUN RemVar (INPUT integral.P-Codes.UlineOn,  OUTPUT P-UlineOn).
    RUN RemVar (INPUT integral.P-Codes.UlineOff, OUTPUT P-UlineOff).
    RUN RemVar (INPUT integral.P-Codes.ItalOn,   OUTPUT P-ItalOn).
    RUN RemVar (INPUT integral.P-Codes.ItalOff,  OUTPUT P-ItalOff).
    RUN RemVar (INPUT integral.P-Codes.SuperOn,  OUTPUT P-SuperOn).
    RUN RemVar (INPUT integral.P-Codes.SuperOff, OUTPUT P-SuperOff).
    RUN RemVar (INPUT integral.P-Codes.SubOn,    OUTPUT P-SubOn).
    RUN RemVar (INPUT integral.P-Codes.SubOff,   OUTPUT P-SubOff).
    RUN RemVar (INPUT integral.P-Codes.Proptnal, OUTPUT P-Proptnal).
    RUN RemVar (INPUT integral.P-Codes.Lpi,      OUTPUT P-Lpi).

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

