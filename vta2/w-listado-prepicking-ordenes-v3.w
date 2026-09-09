&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME ssW-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS ssW-Win 
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

/* ********************************************************************************** */
/* RHC 20/07/2015 definimos s-codcia s-codalm s-desalm y s-coddiv SOLO para ALMACENES */
{alm/windowalmacen.i}
/* ********************************************************************************** */

/* Local Variable Definitions ---                                       */

DEFINE NEW SHARED VAR ltxtDesde AS DATE.
DEFINE NEW SHARED VAR ltxtHasta AS DATE.
DEFINE NEW SHARED VAR lChequeados AS LOGICAL.
DEFINE NEW SHARED VAR pSoloImpresos AS LOGICAL.
DEFINE NEW SHARED VAR s-CodDoc AS CHAR INIT 'O/D'.
DEFINE NEW SHARED VAR pOrdenCompra AS CHAR.
DEFINE NEW SHARED VAR s-busqueda AS CHAR.
DEFINE NEW SHARED VAR i-tipo-busqueda AS INT.
DEFINE NEW SHARED VAR pImpresos AS INT.

DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE NEW SHARED VARIABLE lMsgRetorno  AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 RADIO-SET-CodDoc ~
BUTTON-13 BtnDone txtDesde txtHasta txtOC-SMP BtnExcel RADIO-SET-1 ~
ChkChequeo rbtn-impresos txtCliente BUTTON-15 rbtn-cliente BUTTON-PorZona ~
BUTTON-Alfabeticamente 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-CodDoc txtDesde txtHasta ~
txtOC-SMP RADIO-SET-1 ChkChequeo rbtn-impresos txtCliente rbtn-cliente ~
txtArtSinPeso 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR ssW-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-dimprime-od AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-prepicking-ordenes-todos AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BtnExcel 
     LABEL "EXCEL" 
     SIZE 14 BY 1.12.

DEFINE BUTTON BUTTON-13 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-15 
     LABEL "TXT Cabecera y Detalle" 
     SIZE 27.43 BY .92.

DEFINE BUTTON BUTTON-Alfabeticamente 
     LABEL "IMPRIMIR ALFABETICAMENTE" 
     SIZE 29 BY 1.12.

DEFINE BUTTON BUTTON-PorEmpaque 
     LABEL "IMPRIMIR POR EMPAQUE" 
     SIZE 26 BY 1.12.

DEFINE BUTTON BUTTON-PorZona 
     LABEL "IMPRIMIR POR ZONA" 
     SIZE 22 BY 1.12.

DEFINE VARIABLE txtArtSinPeso AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59.57 BY 1
     FGCOLOR 12 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCliente AS CHARACTER FORMAT "X(80)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 53 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtOC-SMP AS CHARACTER FORMAT "X(15)":U 
     LABEL "O/C Sup.Mercados Peruanos" 
     VIEW-AS FILL-IN 
     SIZE 19.14 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Solo Cabeceras", 1,
"Cabecera y Detalle", 2
     SIZE 16 BY 1.15
     FONT 4 NO-UNDO.

DEFINE VARIABLE RADIO-SET-CodDoc AS CHARACTER INITIAL "O/D" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Orden de Despacho (O/D)", "O/D",
"Orden de Mostrador (O/M)", "O/M",
"Orden de Transferencia (OTR)", "OTR"
     SIZE 69 BY 1
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE rbtn-cliente AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Que inicien", 1,
"Que contengan", 2
     SIZE 30 BY .77
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE rbtn-impresos AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Impresos", 2,
"Sin imprimir", 3
     SIZE 30 BY .96
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33 BY 4.62.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 110 BY 2.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 110 BY 2.31.

DEFINE VARIABLE ChkChequeo AS LOGICAL INITIAL yes 
     LABEL "Mostrar solo PENDIENTES" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.29 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-CodDoc AT ROW 1.19 COL 11 NO-LABEL WIDGET-ID 36
     BUTTON-13 AT ROW 1.19 COL 95 WIDGET-ID 4
     BtnDone AT ROW 1.19 COL 135 WIDGET-ID 10
     txtDesde AT ROW 2.35 COL 9 COLON-ALIGNED WIDGET-ID 16
     txtHasta AT ROW 2.35 COL 30 COLON-ALIGNED WIDGET-ID 20
     txtOC-SMP AT ROW 2.35 COL 73 COLON-ALIGNED WIDGET-ID 42
     BtnExcel AT ROW 3.5 COL 112 WIDGET-ID 34
     RADIO-SET-1 AT ROW 3.5 COL 127 NO-LABEL WIDGET-ID 28
     ChkChequeo AT ROW 3.69 COL 10 WIDGET-ID 22
     rbtn-impresos AT ROW 3.69 COL 72 NO-LABEL WIDGET-ID 52
     txtCliente AT ROW 4.65 COL 8 COLON-ALIGNED WIDGET-ID 46
     BUTTON-15 AT ROW 4.65 COL 112 WIDGET-ID 60
     rbtn-cliente AT ROW 4.85 COL 72 NO-LABEL WIDGET-ID 48
     BUTTON-PorZona AT ROW 25.81 COL 2 WIDGET-ID 6
     BUTTON-Alfabeticamente AT ROW 25.81 COL 24 WIDGET-ID 8
     BUTTON-PorEmpaque AT ROW 25.81 COL 53 WIDGET-ID 58
     txtArtSinPeso AT ROW 26 COL 83 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     "Lista de Articulos que NO tienen PESO en la O/D" VIEW-AS TEXT
          SIZE 43.14 BY .62 AT ROW 25.42 COL 86 WIDGET-ID 26
          BGCOLOR 15 FGCOLOR 9 FONT 6
     "Filtrar por:" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 1.38 COL 2 WIDGET-ID 40
     RECT-1 AT ROW 1 COL 111 WIDGET-ID 32
     RECT-2 AT ROW 1 COL 1 WIDGET-ID 62
     RECT-3 AT ROW 3.5 COL 1 WIDGET-ID 64
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.14 BY 26.23 WIDGET-ID 100.


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
  CREATE WINDOW ssW-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONTROL DE IMPRESION DE ORDENES PARA PRE-PICKING"
         HEIGHT             = 26.23
         WIDTH              = 144.14
         MAX-HEIGHT         = 27.38
         MAX-WIDTH          = 159.43
         VIRTUAL-HEIGHT     = 27.38
         VIRTUAL-WIDTH      = 159.43
         MAX-BUTTON         = no
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB ssW-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW ssW-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON BUTTON-PorEmpaque IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-PorEmpaque:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN txtArtSinPeso IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(ssW-Win)
THEN ssW-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME F-Main:HANDLE
       ROW             = 1.19
       COLUMN          = 112
       HEIGHT          = 1.92
       WIDTH           = 8
       WIDGET-ID       = 2
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      CtrlFrame:MOVE-AFTER(BUTTON-13:HANDLE IN FRAME F-Main).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME ssW-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ssW-Win ssW-Win
ON END-ERROR OF ssW-Win /* CONTROL DE IMPRESION DE ORDENES PARA PRE-PICKING */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ssW-Win ssW-Win
ON WINDOW-CLOSE OF ssW-Win /* CONTROL DE IMPRESION DE ORDENES PARA PRE-PICKING */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone ssW-Win
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


&Scoped-define SELF-NAME BtnExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnExcel ssW-Win
ON CHOOSE OF BtnExcel IN FRAME F-Main /* EXCEL */
DO:
  ASSIGN RADIO-SET-1.     
  CASE s-CodDoc:
      WHEN 'O/D' OR WHEN 'O/M' THEN DO:
          CASE RADIO-SET-1:
              WHEN 1 THEN RUN envia-excel IN h_b-prepicking-ordenes-todos.
              WHEN 2 THEN RUN envia-excel-detalle IN h_b-prepicking-ordenes-todos.
          END CASE.
      END.
      WHEN 'OTR' THEN DO:
          CASE RADIO-SET-1:
              WHEN 1 THEN RUN envia-excel IN h_b-prepicking-ordenes-todos.
              WHEN 2 THEN RUN envia-excel-detalle IN h_b-prepicking-ordenes-todos.
          END CASE.
      END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 ssW-Win
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* REFRESCAR */
DO:
    ASSIGN txtDesde txtHasta chkchequeo txtOC-SMP txtCliente rbtn-Cliente rbtn-impresos.
    ltxtDesde = txtDesde.
    ltxtHasta = txtHasta.
    lChequeados = chkchequeo.
    pOrdenCompra = TRIM(txtOC-SMP).
    /*pSoloImpresos = ChbxSoloImpresos.*/
    pImpresos = rbtn-impresos.
    s-busqueda = TRIM(CAPS(txtCliente)).
    i-tipo-busqueda = rbtn-cliente.
    IF s-busqueda <> '' THEN DO:
        IF i-tipo-busqueda = 2 THEN s-busqueda = '*' + s-busqueda + '*'.
    END.    
    RUN Carga-Temporal IN h_b-prepicking-ordenes-todos.
    RUN dispatch IN h_b-prepicking-ordenes-todos ('open-query':U).
    RUN Procesa-Handle IN lh_handle ('Enable-Buttons').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-15 ssW-Win
ON CHOOSE OF BUTTON-15 IN FRAME F-Main /* TXT Cabecera y Detalle */
DO:
    RUN ue-envia-txt-detalle IN h_b-prepicking-ordenes-todos.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Alfabeticamente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Alfabeticamente ssW-Win
ON CHOOSE OF BUTTON-Alfabeticamente IN FRAME F-Main /* IMPRIMIR ALFABETICAMENTE */
DO:
  CASE s-CodDoc:
      WHEN 'O/D' OR WHEN 'O/M' THEN RUN Imprimir-Formato-OD IN h_b-prepicking-ordenes-todos ( INPUT "ALFABETICO").
      WHEN 'OTR' THEN RUN Imprimir-Formato-OTR IN h_b-prepicking-ordenes-todos ( INPUT "ALFABETICO").
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-PorEmpaque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-PorEmpaque ssW-Win
ON CHOOSE OF BUTTON-PorEmpaque IN FRAME F-Main /* IMPRIMIR POR EMPAQUE */
DO:
    RUN Imprimir-Formato-OD IN h_b-prepicking-ordenes-todos ( INPUT "EMPAQUE").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-PorZona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-PorZona ssW-Win
ON CHOOSE OF BUTTON-PorZona IN FRAME F-Main /* IMPRIMIR POR ZONA */
DO:
    CASE s-CodDoc:
        WHEN 'O/D' OR WHEN 'O/M' THEN RUN Imprimir-Formato-OD IN h_b-prepicking-ordenes-todos ( INPUT "ZONA").
        WHEN 'OTR' THEN RUN Imprimir-Formato-OTR IN h_b-prepicking-ordenes-todos ( INPUT "ZONA").
    END CASE.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ChkChequeo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ChkChequeo ssW-Win
ON VALUE-CHANGED OF ChkChequeo IN FRAME F-Main /* Mostrar solo PENDIENTES */
DO:
    ASSIGN txtDesde txtHasta chkchequeo txtOC-SMP txtCliente rbtn-Cliente rbtn-impresos.
  lChequeados = chkchequeo.
  RUN dispatch IN h_b-prepicking-ordenes-todos ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame ssW-Win OCX.Tick
PROCEDURE CtrlFrame.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

     RUN dispatch IN h_b-prepicking-ordenes-todos ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-CodDoc ssW-Win
ON VALUE-CHANGED OF RADIO-SET-CodDoc IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  s-CodDoc = {&self-name}.
  RUN dispatch IN h_b-prepicking-ordenes-todos ('open-query':U).
  IF s-CodDoc = 'Todos' THEN 
      ASSIGN
      BUTTON-PorZona:SENSITIVE = NO
      BUTTON-Alfabeticamente:SENSITIVE = NO
      BtnExcel:SENSITIVE = NO.
  ELSE ASSIGN
      BUTTON-PorZona:SENSITIVE = YES
      BUTTON-Alfabeticamente:SENSITIVE = YES
      BtnExcel:SENSITIVE = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rbtn-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rbtn-cliente ssW-Win
ON VALUE-CHANGED OF rbtn-cliente IN FRAME F-Main
DO:
    ASSIGN txtDesde txtHasta chkchequeo txtOC-SMP txtCliente rbtn-Cliente rbtn-impresos.
    s-busqueda = TRIM(CAPS(txtCliente)).
    i-tipo-busqueda = rbtn-cliente.
    IF s-busqueda <> '' THEN DO:
        IF i-tipo-busqueda = 2 THEN s-busqueda = '*' + s-busqueda + '*'.
    END.    
    RUN dispatch IN h_b-prepicking-ordenes-todos ('open-query':U).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rbtn-impresos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rbtn-impresos ssW-Win
ON VALUE-CHANGED OF rbtn-impresos IN FRAME F-Main
DO:
  ASSIGN txtDesde txtHasta chkchequeo txtOC-SMP txtCliente rbtn-Cliente rbtn-impresos.
  pImpresos = rbtn-impresos.
  RUN dispatch IN h_b-prepicking-ordenes-todos ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCliente ssW-Win
ON LEAVE OF txtCliente IN FRAME F-Main /* Cliente */
DO:
    ASSIGN txtDesde txtHasta chkchequeo txtOC-SMP txtCliente rbtn-Cliente rbtn-impresos.
    s-busqueda = TRIM(CAPS(txtCliente)).
    i-tipo-busqueda = rbtn-cliente.
    IF s-busqueda <> '' THEN DO:
        IF i-tipo-busqueda = 2 THEN s-busqueda = '*' + s-busqueda + '*'.
    END.    
    RUN dispatch IN h_b-prepicking-ordenes-todos ('open-query':U).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK ssW-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects ssW-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta2/b-listado-prepicking-ordenes-todos-v3.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = FchPed':U ,
             OUTPUT h_b-prepicking-ordenes-todos ).
       RUN set-position IN h_b-prepicking-ordenes-todos ( 5.81 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-prepicking-ordenes-todos ( 7.50 , 144.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta2/b-dimprime-od.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-dimprime-od ).
       RUN set-position IN h_b-dimprime-od ( 13.35 , 1.14 ) NO-ERROR.
       RUN set-size IN h_b-dimprime-od ( 11.92 , 111.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-dimprime-od. */
       RUN add-link IN adm-broker-hdl ( h_b-prepicking-ordenes-todos , 'Record':U , h_b-dimprime-od ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-prepicking-ordenes-todos ,
             rbtn-cliente:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-dimprime-od ,
             h_b-prepicking-ordenes-todos , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available ssW-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load ssW-Win  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "w-listado-prepicking-ordenes-v3.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.
ELSE MESSAGE "w-listado-prepicking-ordenes-v3.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI ssW-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(ssW-Win)
  THEN DELETE WIDGET ssW-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI ssW-Win  _DEFAULT-ENABLE
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
  DISPLAY RADIO-SET-CodDoc txtDesde txtHasta txtOC-SMP RADIO-SET-1 ChkChequeo 
          rbtn-impresos txtCliente rbtn-cliente txtArtSinPeso 
      WITH FRAME F-Main IN WINDOW ssW-Win.
  ENABLE RECT-1 RECT-2 RECT-3 RADIO-SET-CodDoc BUTTON-13 BtnDone txtDesde 
         txtHasta txtOC-SMP BtnExcel RADIO-SET-1 ChkChequeo rbtn-impresos 
         txtCliente BUTTON-15 rbtn-cliente BUTTON-PorZona 
         BUTTON-Alfabeticamente 
      WITH FRAME F-Main IN WINDOW ssW-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW ssW-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit ssW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize ssW-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  txtDesde:SCREEN-VALUE IN FRAME {&frame-name} = STRING(TODAY - 15,"99/99/9999").
  txtHasta:SCREEN-VALUE IN FRAME {&frame-name} = STRING(TODAY,"99/99/9999").
  IF s-coddiv = '00000' THEN
      ASSIGN
      BUTTON-PorEmpaque:VISIBLE = YES
      BUTTON-PorEmpaque:SENSITIVE = YES.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle ssW-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pParametro AS CHAR.

CASE pParametro:
    WHEN "Disable-Buttons" THEN DO WITH FRAME {&FRAME-NAME}:
         BUTTON-Alfabeticamente:SENSITIVE = NO.
         BtnExcel:SENSITIVE = NO.
    END.
    WHEN "Enable-Buttons" THEN DO WITH FRAME {&FRAME-NAME}:
         BUTTON-Alfabeticamente:SENSITIVE = YES.
         BtnExcel:SENSITIVE = YES.
    END.
    WHEN 'ue-pinta-referencia' THEN DO:
        txtArtSinPeso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
        txtArtSinPeso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lMsgRetorno.

            END.
END CASE.
IF pParametro="Enable-Buttons" THEN DO:
    txtArtSinPeso:SCREEN-VALUE = lMsgRetorno.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros ssW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros ssW-Win 
PROCEDURE recoge-parametros :
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
        WHEN "" THEN .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records ssW-Win  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed ssW-Win 
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

