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

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.

DEF TEMP-TABLE Detalle NO-UNDO
    FIELD CodCli AS CHAR FORMAT 'x(15)' LABEL 'CODIGO'
    FIELD RucCli AS CHAR FORMAT 'x(15)' LABEL 'RUC'
    FIELD Grupo  AS CHAR FORMAT 'x(15)' LABEL 'GRUPO'
    FIELD NomCli AS CHAR FORMAT 'x(100)' LABEL 'CLIENTE'
    FIELD Departamento AS CHAR FORMAT 'x(30)' LABEL 'DEPARTAMENTO'
    FIELD Desde AS INTE LABEL 'CLIENTE DESDE'
    FIELD SdoAct AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'DEUDA ACTUAL'
    FIELD LC_01 AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'LC CAMPAÑA'
    FIELD LC_02 AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'LC CAMPAÑA'
    FIELD LC_03 AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'LC CAMPAÑA'
    FIELD LC_04 AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'LC CAMPAÑA'
    FIELD LC_05 AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'LC CAMPAÑA'
    FIELD Compras_01 AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'COMPRAS'
    FIELD Compras_02 AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'COMPRAS'
    FIELD Compras_03 AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'COMPRAS'
    FIELD Compras_04 AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'COMPRAS'
    FIELD Compras_05 AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'COMPRAS'
    FIELD Protesto AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'PROTESTO'
    FIELD Nros_Protesto AS CHAR FORMAT 'x(40)' LABEL 'LETRAS EN PROTESTO'
    FIELD Refinanciacion AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'REFINANCIAMIENTO'
    INDEX Llave01 AS PRIMARY codcli
    .

DEF VAR x-Periodo-Final AS INTE INIT 2024 NO-UNDO.
DEF VAR x-Periodo-Inicial AS INTE NO-UNDO.

x-Periodo-Inicial = x-Periodo-Final - 4.


DEFINE IMAGE IMAGE-1 FILENAME "IMG\AUXILIAR" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR NO-UNDO.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
    SKIP
    Fi-Mensaje FORMAT 'x(50)' NO-LABEL FONT 6
    SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
    BGCOLOR 15 FGCOLOR 0 
    TITLE "Procesando ..." FONT 7.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-Periodo BUTTON-1 BtnDone RECT-1 ~
RECT-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Periodo FILL-IN-Campana-1 ~
FILL-IN-FchIni-1 FILL-IN-FchFin-1 FILL-IN-Campana-2 FILL-IN-FchIni-2 ~
FILL-IN-FchFin-2 FILL-IN-Campana-3 FILL-IN-FchIni-3 FILL-IN-FchFin-3 ~
FILL-IN-Campana-4 FILL-IN-FchIni-4 FILL-IN-FchFin-4 FILL-IN-Campana-5 ~
FILL-IN-FchIni-5 FILL-IN-FchFin-5 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 10 BY 2.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "PROCESAR" 
     SIZE 36 BY 2.69
     FONT 8.

DEFINE VARIABLE FILL-IN-Campana-1 AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Campaña" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Campana-2 AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Campaña" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Campana-3 AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Campaña" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Campana-4 AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Campaña" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Campana-5 AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Campaña" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchFin-1 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchFin-2 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchFin-3 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchFin-4 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchFin-5 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchIni-1 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchIni-2 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchIni-3 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchIni-4 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchIni-5 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Periodo AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Periodo de corte" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 56 BY 1.08
     BGCOLOR 14 FGCOLOR 0 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 5.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Periodo AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-Campana-1 AT ROW 4.23 COL 19 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-FchIni-1 AT ROW 4.23 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN-FchFin-1 AT ROW 4.23 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     FILL-IN-Campana-2 AT ROW 5.31 COL 19 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-FchIni-2 AT ROW 5.31 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     FILL-IN-FchFin-2 AT ROW 5.31 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     FILL-IN-Campana-3 AT ROW 6.38 COL 19 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-FchIni-3 AT ROW 6.38 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-FchFin-3 AT ROW 6.38 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     FILL-IN-Campana-4 AT ROW 7.46 COL 19 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-FchIni-4 AT ROW 7.46 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-FchFin-4 AT ROW 7.46 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     FILL-IN-Campana-5 AT ROW 8.54 COL 19 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-FchIni-5 AT ROW 8.54 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     FILL-IN-FchFin-5 AT ROW 8.54 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     BUTTON-1 AT ROW 10.69 COL 3 WIDGET-ID 2
     BtnDone AT ROW 1.27 COL 78 WIDGET-ID 4
     "CAMPAÑAS" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 3.15 COL 20 WIDGET-ID 40
          BGCOLOR 14 FGCOLOR 0 FONT 6
     "FECHAS" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 3.15 COL 46 WIDGET-ID 42
          BGCOLOR 14 FGCOLOR 0 FONT 6
     RECT-1 AT ROW 2.88 COL 11 WIDGET-ID 44
     RECT-2 AT ROW 3.96 COL 11 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.29 BY 13.42 WIDGET-ID 100.


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
         TITLE              = "REPORTE DE EVALUACION COMERCIAL"
         HEIGHT             = 13.42
         WIDTH              = 91.29
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-Campana-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Campana-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Campana-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Campana-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Campana-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchFin-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchFin-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchFin-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchFin-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchFin-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchIni-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchIni-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchIni-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchIni-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchIni-5 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE EVALUACION COMERCIAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE EVALUACION COMERCIAL */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* PROCESAR */
DO:
    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    /* Cargamos la informacion al temporal */
    SESSION:SET-WAIT-STATE('GENERAL').
    ASSIGN
        FILL-IN-Campana-1 FILL-IN-Campana-2 FILL-IN-Campana-3 FILL-IN-Campana-4 FILL-IN-Campana-5 
        FILL-IN-FchFin-1 FILL-IN-FchFin-2 FILL-IN-FchFin-3 FILL-IN-FchFin-4 FILL-IN-FchFin-5 
        FILL-IN-FchIni-1 FILL-IN-FchIni-2 FILL-IN-FchIni-3 FILL-IN-FchIni-4 FILL-IN-FchIni-5
        .

    RUN Carga-Temporal.

    /* Programas que generan el Excel */
    DISPLAY "GENERANDO TEXTO" @ fi-Mensaje WITH FRAME f-Proceso.

    cArchivo = LC(pArchivo).
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    SESSION:SET-WAIT-STATE('').
    HIDE FRAME f-Proceso.
    MESSAGE 'Proceso Concluido' VIEW-AS ALERT-BOX INFORMATION.
END.

/*
    /* Archivo de Salida */
    DEF VAR c-csv-file AS CHAR NO-UNDO.
    DEF VAR c-xls-file AS CHAR INIT 'Archivo_Excel' NO-UNDO.
    DEF VAR rpta AS LOG INIT NO NO-UNDO.

    SYSTEM-DIALOG GET-FILE c-xls-file
        FILTERS 'Libro de Excel' '*.xlsx'
        INITIAL-FILTER 1
        ASK-OVERWRITE
        CREATE-TEST-FILE
        DEFAULT-EXTENSION ".xlsx"
        SAVE-AS
        TITLE "Guardar como"
        USE-FILENAME
        UPDATE rpta.
    IF rpta = NO THEN RETURN.
   
    SESSION:SET-WAIT-STATE('GENERAL').

    /* Variable de memoria */
    DEFINE VAR hProc AS HANDLE NO-UNDO.
    /* Levantamos la libreria a memoria */
    RUN lib\Tools-to-excel PERSISTENT SET hProc.

    /* Cargamos la informacion al temporal */
    ASSIGN
        FILL-IN-Campana-1 FILL-IN-Campana-2 FILL-IN-Campana-3 FILL-IN-Campana-4 FILL-IN-Campana-5 
        FILL-IN-FchFin-1 FILL-IN-FchFin-2 FILL-IN-FchFin-3 FILL-IN-FchFin-4 FILL-IN-FchFin-5 
        FILL-IN-FchIni-1 FILL-IN-FchIni-2 FILL-IN-FchIni-3 FILL-IN-FchIni-4 FILL-IN-FchIni-5
        .

    RUN Carga-Temporal.

    /* Programas que generan el Excel */
    DISPLAY "GENERANDO EXCEL" @ fi-Mensaje
    WITH FRAME f-Proceso.

    RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                      INPUT c-xls-file,
                                      OUTPUT c-csv-file) .

    RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:handle,
                                      INPUT  c-csv-file,
                                      OUTPUT c-xls-file) .

    /* Borramos librerias de la memoria */
    DELETE PROCEDURE hProc.

    SESSION:SET-WAIT-STATE('').
    HIDE FRAME f-Proceso.

    MESSAGE 'Proceso Concluido' VIEW-AS ALERT-BOX INFORMATION.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Periodo W-Win
ON LEAVE OF FILL-IN-Periodo IN FRAME F-Main /* Periodo de corte */
DO:
  RUN Carga-Variables.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Detalle.

RUN Deuda-Actual.

RUN Compras. 

RUN Letras-Protestadas.

RUN Refinanciamientos. 

RUN Linea-de-credito.

RUN Datos-Finales.

DEF VAR hDetalle AS HANDLE NO-UNDO.
DEF VAR hDetalleField AS HANDLE NO-UNDO.

hDetalle = TEMP-TABLE Detalle:HANDLE.
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(8):LABEL  = "LC CAMPAÑA " + STRING(FILL-IN-Campana-1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(9):LABEL  = "LC CAMPAÑA " + STRING(FILL-IN-Campana-2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(10):LABEL = "LC CAMPAÑA " + STRING(FILL-IN-Campana-3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(11):LABEL = "LC CAMPAÑA " + STRING(FILL-IN-Campana-4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(12):LABEL = "LC CAMPAÑA " + STRING(FILL-IN-Campana-5,'>>>9').

hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(13):LABEL = "COMPRAS " + STRING(FILL-IN-Campana-1,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(14):LABEL = "COMPRAS " + STRING(FILL-IN-Campana-2,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(15):LABEL = "COMPRAS " + STRING(FILL-IN-Campana-3,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(16):LABEL = "COMPRAS " + STRING(FILL-IN-Campana-4,'>>>9').
hDetalle:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(17):LABEL = "COMPRAS " + STRING(FILL-IN-Campana-5,'>>>9').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Variables W-Win 
PROCEDURE Carga-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR i AS INTE NO-UNDO.

DEF VAR x-Inicio AS INTE NO-UNDO.
DEF VAR x-FchIni AS DATE NO-UNDO.
DEF VAR x-FchFin AS DATE NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN FILL-IN-Periodo.
    x-Inicio = FILL-IN-Periodo.
    DO i = 1 TO 5:
        IF i = 1 THEN FILL-IN-Campana-5 = FILL-IN-Periodo.
        IF i = 2 THEN FILL-IN-Campana-4 = FILL-IN-Periodo - (i - 1).
        IF i = 3 THEN FILL-IN-Campana-3 = FILL-IN-Periodo - (i - 1).
        IF i = 4 THEN FILL-IN-Campana-2 = FILL-IN-Periodo - (i - 1).
        IF i = 5 THEN FILL-IN-Campana-1 = FILL-IN-Periodo - (i - 1).
    END.
    DISPLAY 
        FILL-IN-Campana-1
        FILL-IN-Campana-2
        FILL-IN-Campana-3
        FILL-IN-Campana-4
        FILL-IN-Campana-5.
    FILL-IN-FchIni-1 = DATE(10,01,FILL-IN-Campana-1 - 1).
    FILL-IN-FchFin-1 = DATE(04,30,FILL-IN-Campana-1).
    FILL-IN-FchIni-2 = DATE(10,01,FILL-IN-Campana-2 - 1).
    FILL-IN-FchFin-2 = DATE(04,30,FILL-IN-Campana-2).
    FILL-IN-FchIni-3 = DATE(10,01,FILL-IN-Campana-3 - 1).
    FILL-IN-FchFin-3 = DATE(04,30,FILL-IN-Campana-3).
    FILL-IN-FchIni-4 = DATE(10,01,FILL-IN-Campana-4 - 1).
    FILL-IN-FchFin-4 = DATE(04,30,FILL-IN-Campana-4).
    FILL-IN-FchIni-5 = DATE(10,01,FILL-IN-Campana-5 - 1).
    FILL-IN-FchFin-5 = DATE(04,30,FILL-IN-Campana-5).
    DISPLAY
        FILL-IN-FchFin-1 
        FILL-IN-FchFin-2 
        FILL-IN-FchFin-3 
        FILL-IN-FchFin-4 
        FILL-IN-FchFin-5 
        FILL-IN-FchIni-1 
        FILL-IN-FchIni-2 
        FILL-IN-FchIni-3 
        FILL-IN-FchIni-4 
        FILL-IN-FchIni-5
        .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Compras W-Win 
PROCEDURE Compras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cListaDocCargo AS CHAR NO-UNDO.
DEF VAR x-TpoCmbCmp AS DECI NO-UNDO.
DEF VAR x-TpoCmbVta AS DECI NO-UNDO.

ASSIGN cListaDocCargo = "FAC,BOL".

DEF VAR x-Item AS INTE NO-UNDO.
DEF VAR x-FchIni AS DATE NO-UNDO.
DEF VAR x-FchFin AS DATE NO-UNDO.
DEF VAR x-ImpTot AS DECI NO-UNDO.
DEF VAR x-Contador AS INTE NO-UNDO.
DEF VAR x-Fecha AS DATE NO-UNDO.

DEF VAR iControl AS INTE NO-UNDO.

DO x-Item = 1 TO 2:
    /* Hay que buscar 5 líneas de crédito */
    DO x-Contador = 1 TO 5:
        CASE x-Contador:
            WHEN 1 THEN ASSIGN x-FchIni = FILL-IN-FchIni-1 x-FchFin = FILL-IN-FchFin-1.
            WHEN 2 THEN ASSIGN x-FchIni = FILL-IN-FchIni-2 x-FchFin = FILL-IN-FchFin-2.
            WHEN 3 THEN ASSIGN x-FchIni = FILL-IN-FchIni-3 x-FchFin = FILL-IN-FchFin-3.
            WHEN 4 THEN ASSIGN x-FchIni = FILL-IN-FchIni-4 x-FchFin = FILL-IN-FchFin-4.
            WHEN 5 THEN ASSIGN x-FchIni = FILL-IN-FchIni-5 x-FchFin = FILL-IN-FchFin-5.
        END CASE.
        DO x-Fecha = x-FchIni TO x-FchFin:
            FOR EACH Ccbcdocu 
                FIELDS(fchdoc coddoc nrodoc codcli imptot codmon)
                NO-LOCK 
                WHERE Ccbcdocu.codcia = s-codcia AND
                Ccbcdocu.FchDoc = x-Fecha AND
                Ccbcdocu.coddoc = ENTRY(x-Item, cListaDocCargo) AND
                Ccbcdocu.flgest <> "A":
                iControl = iControl + 1.
                IF iControl MODULO 1000 = 0 THEN
                    DISPLAY "COMPRAS: " + STRING(ccbcdocu.fchdoc) + " " + 
                    ccbcdocu.coddoc + " " + ccbcdocu.nrodoc @ fi-Mensaje
                    WITH FRAME f-Proceso.
                FIND Detalle WHERE Detalle.codcli = Ccbcdocu.codcli EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE Detalle THEN DO:
                    CREATE Detalle.
                    ASSIGN Detalle.codcli = Ccbcdocu.codcli.
                END.
                x-ImpTot = Ccbcdocu.imptot.
                IF Ccbcdocu.codmon = 2 THEN DO:
                    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-tcmb THEN
                        ASSIGN
                        x-TpoCmbCmp = gn-tcmb.compra 
                        x-TpoCmbVta = gn-tcmb.venta.
                    x-ImpTot = x-ImpTot * x-TpoCmbVta.  /* Todo en SOLES */
                END.
                CASE x-Contador:
                WHEN 1 THEN ASSIGN Detalle.Compras_01 = Detalle.Compras_01 + x-ImpTot.
                WHEN 2 THEN ASSIGN Detalle.Compras_02 = Detalle.Compras_02 + x-ImpTot.
                WHEN 3 THEN ASSIGN Detalle.Compras_03 = Detalle.Compras_03 + x-ImpTot.
                WHEN 4 THEN ASSIGN Detalle.Compras_04 = Detalle.Compras_04 + x-ImpTot.
                WHEN 5 THEN ASSIGN Detalle.Compras_05 = Detalle.Compras_05 + x-ImpTot.
                END CASE.
            END.
        END.
    END.
END.
HIDE FRAME f-Proceso.

END PROCEDURE.

/*
            FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
            IF AVAILABLE gn-tcmb THEN
                ASSIGN
                x-TpoCmbCmp = gn-tcmb.compra 
                x-TpoCmbVta = gn-tcmb.venta.
            x-ImpTot = x-ImpTot * x-TpoCmbVta.  /* Todo en SOLES */

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Datos-Finales W-Win 
PROCEDURE Datos-Finales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cTexto AS CHAR NO-UNDO.
DEF VAR iControl AS INTE NO-UNDO.

FOR EACH Detalle EXCLUSIVE-LOCK:
    IF TRUE <> (Detalle.codcli > "") THEN DO:
        DELETE Detalle.
        NEXT.
    END.

    iControl = iControl + 1.
    IF iControl MODULO 1000 = 0 THEN
        DISPLAY "DATOS FINALES: " + Detalle.codcli @ fi-Mensaje WITH FRAME f-Proceso.
    /* Clientes */
    FIND FIRST gn-clie WHERE gn-clie.CodCia = cl-codcia AND
        gn-clie.CodCli = Detalle.codcli
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN NEXT.
    ASSIGN 
        Detalle.nomcli = gn-clie.NomCli 
        Detalle.Desde = YEAR(gn-clie.Fching).
    /* Limpiamos textos */
    /*RUN lib/limpiar-texto-abc (Detalle.nomcli,*/
    RUN lib/limpiar-texto-contains (Detalle.nomcli,
                                    " ",
                                    OUTPUT cTexto).
    Detalle.nomcli = cTexto.
    Detalle.RucCli = gn-clie.ruc.
    /* Grupo */
    Detalle.Grupo = gn-clie.codunico.
    /* Ubigeo */
    FIND FIRST gn-clied WHERE Gn-ClieD.CodCia = cl-codcia AND
        Gn-ClieD.CodCli = Detalle.codcli AND
        Gn-ClieD.Sede = "@@@" NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clied THEN DO:
        FIND TabDepto WHERE TabDepto.CodDepto = Gn-ClieD.CodDept NO-LOCK NO-ERROR.
        IF AVAILABLE TabDepto THEN Detalle.Departamento = TabDepto.NomDepto.
    END.
END.
HIDE FRAME f-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Deuda-Actual W-Win 
PROCEDURE Deuda-Actual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cListaDocCargo AS CHAR NO-UNDO.
DEF VAR cListaDocAbono AS CHAR NO-UNDO.
DEF VAR x-TpoCmbCmp AS DECI NO-UNDO.
DEF VAR x-TpoCmbVta AS DECI NO-UNDO.
DEF VAR cCodRef AS CHAR NO-UNDO.
DEF VAR cNroRef AS CHAR NO-UNDO.

DEF VAR x-ImpTot AS DECI NO-UNDO.

ASSIGN
    cListaDocCargo = "FAC,BOL,N/D,LET,DCO,FAI"
    cListaDocAbono = "N/C,BD,A/R,A/C,LPA"
    .

DEF VAR iItem AS INTE NO-UNDO.
DEF VAR iControl AS INTE NO-UNDO.

/* Documentos de Cargo */
DO iItem = 1 TO NUM-ENTRIES(cListaDocCargo):
    FOR EACH Ccbcdocu 
        FIELDS(coddoc nrodoc fchdoc sdoact codmon codcli )
        NO-LOCK 
        WHERE Ccbcdocu.codcia = s-codcia AND
        Ccbcdocu.flgest = "P" AND
        Ccbcdocu.coddoc = ENTRY(iItem,cListaDocCargo) AND
        Ccbcdocu.sdoact > 0:
        iControl = iControl + 1.
        IF iControl MODULO 1000 = 0 THEN
            DISPLAY "DEUDA ACTUAL: " + STRING(ccbcdocu.fchdoc) + " " + 
            ccbcdocu.coddoc + " " + ccbcdocu.nrodoc @ fi-Mensaje
            WITH FRAME f-Proceso.
        x-ImpTot = Ccbcdocu.SdoAct.
        IF Ccbcdocu.CodMon = 2 THEN DO:
            FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
            IF AVAILABLE gn-tcmb THEN
                ASSIGN
                x-TpoCmbCmp = gn-tcmb.compra 
                x-TpoCmbVta = gn-tcmb.venta.
            x-ImpTot = x-ImpTot * x-TpoCmbVta.  /* Todo en SOLES */
        END.
        FIND Detalle WHERE Detalle.codcli = Ccbcdocu.codcli EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Detalle THEN DO:
            CREATE Detalle.
            ASSIGN
                Detalle.codcli = Ccbcdocu.codcli.
        END.
        ASSIGN
            Detalle.SdoAct = Detalle.SdoAct + x-ImpTot.
    END.
END.
HIDE FRAME f-Proceso.
/* Documentos de Abono */
DO iItem = 1 TO NUM-ENTRIES(cListaDocAbono):
    FOR EACH Ccbcdocu 
        FIELDS(coddoc nrodoc fchdoc sdoact codmon codcli )
        NO-LOCK 
        WHERE Ccbcdocu.codcia = s-codcia AND
        Ccbcdocu.flgest = "P" AND
        Ccbcdocu.coddoc = ENTRY(iItem,cListaDocAbono) AND
        Ccbcdocu.sdoact > 0:
        iControl = iControl + 1.
        IF iControl MODULO 1000 = 0 THEN
            DISPLAY "DEUDA ACTUAL: " + STRING(ccbcdocu.fchdoc) + " " + 
            ccbcdocu.coddoc + " " + ccbcdocu.nrodoc @ fi-Mensaje
            WITH FRAME f-Proceso.
        x-ImpTot = Ccbcdocu.SdoAct.
        IF Ccbcdocu.CodMon = 2 THEN DO:
            FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
            IF AVAILABLE gn-tcmb THEN
                ASSIGN
                x-TpoCmbCmp = gn-tcmb.compra 
                x-TpoCmbVta = gn-tcmb.venta.
            x-ImpTot = x-ImpTot * x-TpoCmbVta.  /* Todo en SOLES */
        END.
        FIND Detalle WHERE Detalle.codcli = Ccbcdocu.codcli EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Detalle THEN DO:
            CREATE Detalle.
            ASSIGN
                Detalle.codcli = Ccbcdocu.codcli.
        END.
        ASSIGN
            Detalle.SdoAct = Detalle.SdoAct - x-ImpTot.
    END.
END.
HIDE FRAME f-Proceso.

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
  DISPLAY FILL-IN-Periodo FILL-IN-Campana-1 FILL-IN-FchIni-1 FILL-IN-FchFin-1 
          FILL-IN-Campana-2 FILL-IN-FchIni-2 FILL-IN-FchFin-2 FILL-IN-Campana-3 
          FILL-IN-FchIni-3 FILL-IN-FchFin-3 FILL-IN-Campana-4 FILL-IN-FchIni-4 
          FILL-IN-FchFin-4 FILL-IN-Campana-5 FILL-IN-FchIni-5 FILL-IN-FchFin-5 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-Periodo BUTTON-1 BtnDone RECT-1 RECT-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Letras-Protestadas W-Win 
PROCEDURE Letras-Protestadas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-FchIni AS DATE NO-UNDO.
DEF VAR x-FchFin AS DATE NO-UNDO.
DEF VAR x-ImpTot AS DECI NO-UNDO.
DEF VAR x-TpoCmbCmp AS DECI NO-UNDO.
DEF VAR x-TpoCmbVta AS DECI NO-UNDO.
DEF VAR x-Documentos AS CHAR NO-UNDO.

/* Del último periodo */
x-FchIni = FILL-IN-FchIni-5.
x-FchFin = FILL-IN-FchFin-5.
x-Documentos = "P/C,P/X".

DEF VAR x-Item AS INTE NO-UNDO.
DEF VAR iControl AS INTE NO-UNDO.

DO x-Item = 1 TO 2:
    FOR EACH Ccbcmvto 
        FIELDS(codcia fchdoc coddoc nrodoc)
        NO-LOCK 
        WHERE Ccbcmvto.codcia = s-codcia AND
        Ccbcmvto.coddoc = ENTRY(x-Item,x-Documentos) AND
        Ccbcmvto.fchdoc >= x-FchIni AND
        Ccbcmvto.fchdoc <= x-FchFin AND
        Ccbcmvto.flgest <> "A":
        iControl = iControl + 1.
        IF iControl MODULO 1000 = 0 THEN
            DISPLAY "PROTESTO: " + STRING(Ccbcmvto.fchdoc) + " " + 
            Ccbcmvto.coddoc + " " + Ccbcmvto.nrodoc @ fi-Mensaje
            WITH FRAME f-Proceso.
        FOR EACH Ccbdmvto NO-LOCK WHERE CcbDMvto.CodCia = Ccbcmvto.codcia AND
            CcbDMvto.CodDoc = Ccbcmvto.coddoc AND
            CcbDMvto.NroDoc = Ccbcmvto.nrodoc,
            FIRST Ccbcdocu 
            FIELDS(codcia codcli imptot codmon fchdoc coddoc nrodoc)
            NO-LOCK 
            WHERE Ccbcdocu.codcia = s-codcia AND
            Ccbcdocu.coddoc = Ccbdmvto.codref AND
            Ccbcdocu.nrodoc = Ccbdmvto.nroref:
            FIND Detalle WHERE Detalle.codcli = Ccbcdocu.codcli EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Detalle THEN DO:
                CREATE Detalle.
                ASSIGN Detalle.codcli = Ccbcdocu.codcli.
            END.
            x-ImpTot = Ccbcdocu.imptot.
            IF Ccbcdocu.codmon = 2 THEN DO:
                FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
                IF AVAILABLE gn-tcmb THEN
                    ASSIGN
                    x-TpoCmbCmp = gn-tcmb.compra
                    x-TpoCmbVta = gn-tcmb.venta.
                x-ImpTot = x-ImpTot * x-TpoCmbVta.  /* Todo en SOLES */
            END.
            ASSIGN Detalle.Protesto = Detalle.Protesto + x-ImpTot.
            IF TRUE <> (Detalle.Nros_Protesto > '') THEN Detalle.Nros_Protesto = Ccbcdocu.nrodoc.
            ELSE Detalle.Nros_Protesto = Nros_Protesto + "," + Ccbcdocu.nrodoc.
        END.
    END.
END.
HIDE FRAME f-Proceso.

/* FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia AND                            */
/*     Ccbcdocu.FchDoc >= x-FchIni AND                                                       */
/*     Ccbcdocu.FchDoc <= x-FchFin AND                                                       */
/*     Ccbcdocu.coddoc = "LET" AND                                                           */
/*     Ccbcdocu.flgest <> "A" AND                                                            */
/*     Ccbcdocu.flgsit = "P":                                                                */
/*     FIND Detalle WHERE Detalle.codcli = Ccbcdocu.codcli EXCLUSIVE-LOCK NO-ERROR.          */
/*     IF NOT AVAILABLE Detalle THEN DO:                                                     */
/*         CREATE Detalle.                                                                   */
/*         ASSIGN Detalle.codcli = Ccbcdocu.codcli.                                          */
/*     END.                                                                                  */
/*     x-ImpTot = Ccbcdocu.imptot.                                                           */
/*     IF Ccbcdocu.codmon = 2 THEN DO:                                                       */
/*         FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.        */
/*         IF AVAILABLE gn-tcmb THEN                                                         */
/*             ASSIGN                                                                        */
/*             x-TpoCmbCmp = gn-tcmb.compra                                                  */
/*             x-TpoCmbVta = gn-tcmb.venta.                                                  */
/*         x-ImpTot = x-ImpTot * x-TpoCmbVta.  /* Todo en SOLES */                           */
/*     END.                                                                                  */
/*     ASSIGN Detalle.Protesto = Detalle.Protesto + x-ImpTot.                                */
/*     IF TRUE <> (Detalle.Nros_Protesto > '') THEN Detalle.Nros_Protesto = Ccbcdocu.nrodoc. */
/*     ELSE Detalle.Nros_Protesto = Nros_Protesto + "," + Ccbcdocu.nrodoc.                   */
/* END.                                                                                      */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Linea-de-credito W-Win 
PROCEDURE Linea-de-credito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ************************************* */
/* Verificamos si es un cliente agrupado */
/* ¿es el Master? */
/* ************************************* */
DEF VAR pMaster AS CHAR.
DEF VAR pRelacionados AS CHAR.
DEF VAR pAgrupados AS LOG.
DEF VAR pCodCli AS CHAR NO-UNDO.
DEF VAR pImpLCred AS DECI NO-UNDO.

DEF VAR x-FchIni AS DATE NO-UNDO.
DEF VAR x-FchFin AS DATE NO-UNDO.
DEF VAR x-Contador AS INTE NO-UNDO.
DEF VAR iControl AS INTE NO-UNDO.

FOR EACH Detalle EXCLUSIVE-LOCK:
    iControl = iControl + 1.
    IF iControl MODULO 1000 = 0 THEN
        DISPLAY "LINEA DE CREDITO: " + Detalle.codcli @ fi-Mensaje
        WITH FRAME f-Proceso.
    pCodCli = Detalle.codcli.
    RUN ccb/p-cliente-master (pCodCli,
                              OUTPUT pMaster,
                              OUTPUT pRelacionados,
                              OUTPUT pAgrupados).
    IF pAgrupados = YES AND pMaster > '' THEN pCodCli = pMaster.    /* Cambiamos al Master */

    /* Buscamos si tiene definida LINEA DE CREDITO */
    FIND FIRST Gn-ClieL WHERE Gn-ClieL.CodCia = cl-CodCia
        AND Gn-ClieL.CodCli = pCodCli
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-cliel THEN NEXT.

    /* Hay que buscar 5 líneas de crédito */
    x-FchIni = ?.   /* Valor de inicio */
    DO x-Contador = 1 TO 5:
        CASE x-Contador:
            WHEN 1 THEN ASSIGN x-FchFin = FILL-IN-FchFin-1.
            WHEN 2 THEN ASSIGN x-FchIni = FILL-IN-FchFin-1 x-FchFin = FILL-IN-FchFin-2.
            WHEN 3 THEN ASSIGN x-FchIni = FILL-IN-FchFin-2 x-FchFin = FILL-IN-FchFin-3.
            WHEN 4 THEN ASSIGN x-FchIni = FILL-IN-FchFin-3 x-FchFin = FILL-IN-FchFin-4.
            WHEN 5 THEN ASSIGN x-FchIni = FILL-IN-FchFin-4 x-FchFin = FILL-IN-FchFin-5.
        END CASE.
        ASSIGN pImpLCred = 0.
        /* ********************************************************************** */
        /* OJO: se toma la fecha final mas no la fecha inicial */
        /* ********************************************************************** */
        FOR EACH Gn-ClieL 
            FIELDS(fchini fchfin implc)
            NO-LOCK 
            WHERE Gn-ClieL.CodCia = cl-CodCia
            AND Gn-ClieL.CodCli = pCodCli
            AND Gn-ClieL.FchFin <= x-FchFin 
            BY gn-cliel.fchini BY gn-cliel.fchfin:
            IF Gn-ClieL.FchIni = ? OR Gn-ClieL.FchFin = ? THEN NEXT.
            /*IF x-FchIni <> ? THEN IF NOT ( Gn-ClieL.FchIni >= (x-FchIni + 1) ) THEN NEXT.*/
            IF x-FchIni <> ? THEN IF NOT (Gn-ClieL.FchFin > x-FchIni) THEN NEXT.
            pImpLCred = Gn-ClieL.ImpLC.     /* VALOR POR DEFECTO => LINEA DE CREDITO TOTAL */
        END.
        CASE x-Contador:
        WHEN 1 THEN ASSIGN Detalle.LC_01 = pImpLCred.
        WHEN 2 THEN ASSIGN Detalle.LC_02 = pImpLCred.
        WHEN 3 THEN ASSIGN Detalle.LC_03 = pImpLCred.
        WHEN 4 THEN ASSIGN Detalle.LC_04 = pImpLCred.
        WHEN 5 THEN ASSIGN Detalle.LC_05 = pImpLCred.
        END CASE.
    END.
END.
HIDE FRAME f-Proceso.

END PROCEDURE.

/*
    /* Hay que buscar 5 líneas de crédito */
    DO x-Contador = 1 TO 5:
        CASE x-Contador:
            WHEN 1 THEN ASSIGN x-FchIni = FILL-IN-FchIni-1 x-FchFin = FILL-IN-FchFin-1.
            WHEN 2 THEN ASSIGN x-FchIni = FILL-IN-FchIni-2 x-FchFin = FILL-IN-FchFin-2.
            WHEN 3 THEN ASSIGN x-FchIni = FILL-IN-FchIni-3 x-FchFin = FILL-IN-FchFin-3.
            WHEN 4 THEN ASSIGN x-FchIni = FILL-IN-FchIni-4 x-FchFin = FILL-IN-FchFin-4.
            WHEN 5 THEN ASSIGN x-FchIni = FILL-IN-FchIni-5 x-FchFin = FILL-IN-FchFin-5.
        END CASE.
        ASSIGN pImpLCred = 0.
        /* ********************************************************************** */
        /* OJO: se toma la fecha final mas no la fecha inicial */
        /* ********************************************************************** */
        FOR EACH Gn-ClieL NO-LOCK WHERE Gn-ClieL.CodCia = cl-CodCia
            AND Gn-ClieL.CodCli = pCodCli
            /*AND Gn-ClieL.FchIni >= x-FchIni*/
            AND Gn-ClieL.FchFin <= x-FchFin 
            BY gn-cliel.fchini BY gn-cliel.fchfin:
            IF Gn-ClieL.FchIni = ? OR Gn-ClieL.FchFin = ? THEN NEXT.
            pImpLCred = Gn-ClieL.ImpLC.     /* VALOR POR DEFECTO => LINEA DE CREDITO TOTAL */
        END.
        CASE x-Contador:
        WHEN 1 THEN ASSIGN Detalle.LC_01 = pImpLCred.
        WHEN 2 THEN ASSIGN Detalle.LC_02 = pImpLCred.
        WHEN 3 THEN ASSIGN Detalle.LC_03 = pImpLCred.
        WHEN 4 THEN ASSIGN Detalle.LC_04 = pImpLCred.
        WHEN 5 THEN ASSIGN Detalle.LC_05 = pImpLCred.
        END CASE.
    END.
*/

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
  FILL-IN-Periodo = YEAR(TODAY).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Carga-Variables.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Refinanciamientos W-Win 
PROCEDURE Refinanciamientos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Solo aprobados
------------------------------------------------------------------------------*/

DEF VAR x-FchIni AS DATE NO-UNDO.
DEF VAR x-FchFin AS DATE NO-UNDO.
DEF VAR x-ImpTot AS DECI NO-UNDO.
DEF VAR x-TpoCmbCmp AS DECI NO-UNDO.
DEF VAR x-TpoCmbVta AS DECI NO-UNDO.
DEF VAR iControl AS INTE NO-UNDO.

/* Del último periodo */
x-FchIni = FILL-IN-FchIni-5.
x-FchFin = FILL-IN-FchFin-5.

FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia,
    EACH Ccbcmvto 
    FIELDS(codcia coddoc nrodoc fchdoc)
    NO-LOCK 
    WHERE Ccbcmvto.codcia = s-codcia AND
    Ccbcmvto.coddiv = gn-divi.coddiv AND
    Ccbcmvto.coddoc = "REF" AND
    Ccbcmvto.fchdoc >= x-FchIni AND
    Ccbcmvto.fchdoc <= x-FchFin AND
    CcbCMvto.FlgEst = "E":
    FOR EACH Ccbdcaja NO-LOCK WHERE Ccbdcaja.codcia = Ccbcmvto.codcia AND
        Ccbdcaja.coddoc = Ccbcmvto.coddoc AND
        Ccbdcaja.nrodoc = Ccbcmvto.nrodoc,
        FIRST Ccbcdocu 
        FIELDS(codcia codcli imptot codmon)
        NO-LOCK 
        WHERE Ccbcdocu.codcia = Ccbdcaja.codcia AND
        Ccbcdocu.coddoc = Ccbdcaja.codref AND
        Ccbcdocu.nrodoc = Ccbdcaja.nroref:
        iControl = iControl + 1.
        IF iControl MODULO 1000 = 0 THEN
            DISPLAY "PROTESTO: " + STRING(Ccbcmvto.fchdoc) + " " + 
            Ccbcmvto.coddoc + " " + Ccbcmvto.nrodoc @ fi-Mensaje
            WITH FRAME f-Proceso.
        FIND Detalle WHERE Detalle.codcli = Ccbcdocu.codcli EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Detalle THEN DO:
            CREATE Detalle.
            ASSIGN Detalle.codcli = Ccbcdocu.codcli.
        END.
        x-ImpTot = Ccbdcaja.imptot.
        IF Ccbdcaja.codmon = 2 THEN DO:
            FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbdcaja.fchdoc NO-LOCK NO-ERROR.
            IF AVAILABLE gn-tcmb THEN
                ASSIGN
                x-TpoCmbCmp = gn-tcmb.compra 
                x-TpoCmbVta = gn-tcmb.venta.
            x-ImpTot = x-ImpTot * x-TpoCmbVta.  /* Todo en SOLES */
        END.
        ASSIGN Detalle.Refinanciacion = Detalle.Refinanciacion + x-ImpTot.
    END.
END.
HIDE FRAME f-Proceso.

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

