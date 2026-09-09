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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE STREAM report.
DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.

DEFINE TEMP-TABLE NOTCRE LIKE CCBCDOCU.  
def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE f-tipos  AS CHAR FORMAT "X(3)".
DEFINE VARIABLE T-CMPBTE AS CHAR INIT "".
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE T-CLIEN  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-TIP    AS CHAR FORMAT "X(2)".
DEFINE VAR C AS INTEGER.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR.
DEFINE VAR W-ImporteS AS DECIMAL EXTENT 6 INIT 0.
DEFINE VAR W-ImporteD AS DECIMAL EXTENT 6 INIT 0.
 

 DEFINE VAR F-ImpBrt AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpDto AS DECIMAL FORMAT "(>,>>9.99)".
 DEFINE VAR F-ImpVta AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpExo AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpIgv AS DECIMAL FORMAT "(>>>,>>9.99)".
 DEFINE VAR F-ImpTot AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpIsc AS DECIMAL FORMAT "(>,>>9.99)".
 DEFINE VAR JJ       AS INTEGER NO-UNDO.
 DEFINE VAR F-TOTCON AS DECIMAL EXTENT 6 INITIAL 0.
 DEFINE VAR F-TOTCRE AS DECIMAL EXTENT 6 INITIAL 0.
 C = 1.

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
&Scoped-Define ENABLED-OBJECTS RECT-70 RECT-71 RECT-50 RECT-51 ~
FILL-IN-CodDiv f-desde R-S-TipImp FILL-IN-efesol FILL-IN-efedol ~
FILL-IN-remesol FILL-IN-remedol BUTTON-3 BUTTON-4 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodDiv f-desde R-S-TipImp ~
FILL-IN-efesol FILL-IN-efedol FILL-IN-remesol FILL-IN-remedol txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 3" 
     SIZE 15 BY 1.5.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Button 4" 
     SIZE 15 BY 1.5.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .69
     BGCOLOR 15 FGCOLOR 1 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-efedol AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "US$/." 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-efesol AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "S/." 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-remedol AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "US$/." 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-remesol AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "S/." 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     FONT 8 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 77.43 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE R-S-TipImp AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Detalle", 1,
"Cierre", 2
     SIZE 21 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 2.15.

DEFINE RECTANGLE RECT-51
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 2.15.

DEFINE RECTANGLE RECT-70
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.14 BY 6.77.

DEFINE RECTANGLE RECT-71
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 1.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodDiv AT ROW 1.81 COL 4.86 WIDGET-ID 36
     f-desde AT ROW 1.81 COL 51 COLON-ALIGNED WIDGET-ID 34
     R-S-TipImp AT ROW 2.88 COL 11 NO-LABEL WIDGET-ID 46
     FILL-IN-efesol AT ROW 5.31 COL 19 RIGHT-ALIGNED WIDGET-ID 40
     FILL-IN-efedol AT ROW 5.31 COL 25 COLON-ALIGNED WIDGET-ID 38
     FILL-IN-remesol AT ROW 5.31 COL 44 COLON-ALIGNED WIDGET-ID 44
     FILL-IN-remedol AT ROW 5.31 COL 63 COLON-ALIGNED WIDGET-ID 42
     txt-msj AT ROW 6.92 COL 2.57 NO-LABEL WIDGET-ID 30
     BUTTON-3 AT ROW 8.27 COL 50 WIDGET-ID 24
     BUTTON-4 AT ROW 8.27 COL 65 WIDGET-ID 26
     "Efectivo" VIEW-AS TEXT
          SIZE 10.86 BY .65 AT ROW 4.5 COL 15 WIDGET-ID 60
          FONT 12
     "Remesas" VIEW-AS TEXT
          SIZE 12.14 BY .81 AT ROW 4.35 COL 52 WIDGET-ID 58
          FONT 8
     RECT-70 AT ROW 1.23 COL 1.86 WIDGET-ID 20
     RECT-71 AT ROW 8.08 COL 2 WIDGET-ID 28
     RECT-50 AT ROW 4.23 COL 3 WIDGET-ID 54
     RECT-51 AT ROW 4.23 COL 42 WIDGET-ID 56
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.57 BY 9.42
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
         TITLE              = "Reporte de Cierre por Usuario"
         HEIGHT             = 9.42
         WIDTH              = 81.57
         MAX-HEIGHT         = 9.42
         MAX-WIDTH          = 81.57
         VIRTUAL-HEIGHT     = 9.42
         VIRTUAL-WIDTH      = 81.57
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
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-CodDiv IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-efesol IN FRAME F-Main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de Cierre por Usuario */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Cierre por Usuario */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    ASSIGN f-Desde R-S-TipImp FILL-IN-CodDiv
        FILL-IN-efesol FILL-IN-efedol FILL-IN-remesol FILL-IN-remedol.

    IF f-desde = ? THEN DO: 
        MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
        APPLY "ENTRY":U to f-desde.
        RETURN NO-APPLY.   
    END.
    
    DISPLAY "Cargando Información..." @ txt-msj WITH FRAME {&FRAME-NAME}.
    RUN Imprimir.
    DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anulados W-Win 
PROCEDURE Anulados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-tpocmb AS DECIMAL NO-UNDO.
  DEFINE VAR x-titu1  AS CHAR.
  DEFINE VAR x-titu2  AS CHAR.
  DEFINE VAR x-anula  As CHAR.
  DEFINE VAR X-SOL    AS DECIMAL.
  DEFINE VAR X-DOL    AS DECIMAL. 
  DEFINE VAR XX-SOL   AS DECIMAL.
  DEFINE VAR XX-DOL   AS DECIMAL. 
  DEFINE VAR X-RUC    AS CHAR.
  DEFINE VAR X-VEN    AS CHAR.
  DEFINE VAR X        AS INTEGER INIT 1.
  DEFINE VAR X-GLO    AS CHAR FORMAT "X(20)".
  DEFINE VAR X-CODREF AS CHAR.
  DEFINE VAR X-NROREF AS CHAR.
  DEFINE VAR X-FECHA  AS DATE.
  DEFINE VAR X-MOVTO AS CHAR.
  X-MOVTO = 'ANULADO'.
 
  DEFINE FRAME f-cab
      NOTCRE.CodDoc FORMAT "XXX"
      NOTCRE.NroDoc FORMAT "XXX-XXXXXX"
      NOTCRE.FchDoc 
      NOTCRE.Codcli FORMAT "X(10)"
      NOTCRE.NomCli FORMAT "X(35)"
      X-MON         FORMAT "X(4)"
      F-ImpTot 
      NOTCRE.fmapgo format "x(4)"
      X-GLO         FORMAT "X(16)"
      X-CODREF      FORMAT "XXX"
      X-NROREF      FORMAT "XXX-XXXXXX"
      X-FECHA
      HEADER
      {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
      {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
      {&PRN6A} + " REPORTE DE DOCUMENTOS ANULADOS"  AT 41 FORMAT "X(45)"
      {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
      {&PRN2} + {&PRN6A} + "Del : " AT 55 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
      {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
      "Caja : " AT 1 FORMAT "X(10)"  {&PRN6A} + S-USER-ID AT 12 FORMAT "X(15)"
      {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(10)" STRING(TIME,"HH:MM:SS") SKIP 
      "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
      "        No.      FECHA                                                                  TOTAL                                         " SKIP
      "DOC  DOCUMENTO  EMISION    CODIGO             C L I E N T E               MON.          IMPORTE                                       " SKIP
      "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
      WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

      FOR EACH NOTCRE WHERE NOTCRE.Flgest = 'A'
          BREAK BY NOTCRE.codcia BY NOTCRE.Fchdoc  BY NOTCRE.FmaPgo BY (NOTCRE.FmaPgo + NOTCRE.Coddoc)
          BY NOTCRE.Nrodoc:

          x-tpocmb = NOTCRE.Tpocmb.
          F-Impbrt = 0.
          F-Impdto = 0.
          F-Impexo = 0.
          F-Impvta = 0.
          F-Impigv = 0.
          F-Imptot = 0.
          x-anula  = "----- A N U L A D O -------".
          x-mon    = "".
          x-ven    = "".
          x-ruc    = "".

          IF NOTCRE.Flgest = 'A'  THEN DO:
              F-Imptot = ImpTot.
              x-anula  = NOTCRE.Nomcli.
              x-ven    = NOTCRE.Codven.
              x-ruc    = NOTCRE.Ruccli.
              
              IF NOTCRE.Codmon = 1 THEN X-MON = "S/.".
              ELSE X-MON = "US$.".
          END.

          IF FIRST-OF(NOTCRE.fmapgo) THEN DO:
              ASSIGN  XX-SOL = 0 XX-DOL = 0.     
              x-titu2 = " ".
              FIND gn-convt WHERE gn-convt.codig   = NOTCRE.fmapgo NO-LOCK NO-ERROR.
              IF AVAILABLE gn-convt THEN DO:
                  x-titu2 = TRIM(gn-convt.Nombr) + ' ' + X-MOVTO.
              END.
              DISPLAY STREAM REPORT.
              IF R-S-TipImp = 1 THEN DO:
                  DOWN(1) STREAM REPORT WITH FRAME F-Cab.
              END.
              ELSE DO:
                  DOWN(1) STREAM REPORT WITH FRAME F-Cab2.
              END.
              PUT STREAM report 
                  {&PRN2} + {&PRN6A} + x-titu2 at 3 FORMAT "X(35)" + {&PRN3} + {&PRN6B} .
          END.

          IF FIRST-OF(NOTCRE.Fmapgo + NOTCRE.Coddoc) THEN DO:
              ASSIGN X-SOL = 0 X-DOL = 0.
              x-titu1 = " ".
              FIND facdocum WHERE facdocum.codcia  = NOTCRE.codcia and facdocum.coddoc = NOTCRE.coddoc NO-LOCK NO-ERROR.
              IF AVAILABLE facdocum THEN DO:
                  x-titu1 = TRIM(facdocum.NomDoc) + ' ' + X-MOVTO.
              END.
              DISPLAY STREAM REPORT.
              IF R-S-TipImp = 1 THEN DO:
                  DOWN(1) STREAM REPORT WITH FRAME F-Cab.
              END.
              ELSE DO:
                  DOWN(1) STREAM REPORT WITH FRAME F-Cab2.
              END.
              PUT STREAM report
                  {&PRN2} + {&PRN6A} + x-titu1 at 10 FORMAT "X(35)" + {&PRN3} + {&PRN6B} .
          END.

          X = 1.
          X-GLO    = ' '.
          X-CODREF = ' '.
          X-NROREF = ' '.

          IF NOTCRE.codmon = 1 THEN DO:
              X-SOL  = X-SOL  + ( X * F-IMPTOT ).
              XX-SOL = XX-SOL + ( X * F-IMPTOT ).
          END.
          ELSE DO:
              X-DOL  = X-DOL  + (X * F-IMPTOT ).
              XX-DOL = XX-DOL + (X * F-IMPTOT ).
          END. 

          IF R-S-TipImp = 1 THEN DO:
              DISPLAY STREAM REPORT 
                  NOTCRE.CodDoc 
                  NOTCRE.NroDoc 
                  NOTCRE.FchDoc 
                  NOTCRE.Codcli
                  TRIM(x-anula)  @ NOTCRE.NomCli 
                  X-MON           
                  F-ImpTot WHEN F-ImpTot <> 0
                  NOTCRE.Fmapgo
/*                X-GLO 
 *                X-CODREF
 *                X-NROREF 
 *                X-FECHA WHEN NOTCRE.Coddoc = 'N/C'*/
              WITH FRAME F-Cab.
                        
          IF LAST-OF(NOTCRE.Fmapgo + NOTCRE.Coddoc) THEN DO:
              DISPLAY STREAM REPORT.
              DOWN(1) STREAM REPORT WITH FRAME F-Cab.
              PUT STREAM REPORT 
                  {&PRN2} + {&PRN6A} + 'SUBTOTALES   :'   AT 20 FORMAT "X(20)" " S/." AT 50 X-SOL AT 55  {&PRN3} + {&PRN6B} SKIP.
              PUT STREAM REPORT   
                  {&PRN2} + {&PRN6A} + '              '   AT 20 FORMAT "X(20)" "US$." AT 50 X-DOL AT 55  {&PRN3} + {&PRN6B}.
          END.
          IF LAST-OF(NOTCRE.Fmapgo) THEN DO:
              DISPLAY STREAM REPORT.
              DOWN(1) STREAM REPORT WITH FRAME F-Cab.
              PUT STREAM REPORT 
                  {&PRN2} + {&PRN6A} + 'TOTALES      :'   AT 20 FORMAT "X(20)" " S/." AT 50 XX-SOL AT 55  {&PRN3} + {&PRN6B} SKIP.
              PUT STREAM REPORT   
                  {&PRN2} + {&PRN6A} + '              '   AT 20 FORMAT "X(20)" "US$." AT 50 XX-DOL AT 55  {&PRN3} + {&PRN6B}.
          END.
     END.
     /*IF R-S-TipImp = 2 THEN DO:
 *         IF LAST-OF(NOTCRE.Coddoc) OR LAST-OF(NOTCRE.Fmapgo) THEN DO:
 *           display  STREAM REPORT.
 *           PUT STREAM REPORT  X-SOL AT 80 X-DOL AT 110 .
 *         END.
 *      END.*/
 
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Data W-Win 
PROCEDURE Carga-Data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
  DEFINE VAR x-tpocmb AS DECIMAL NO-UNDO.
  DEFINE VAR x-titu1  AS CHAR.
  DEFINE VAR x-titu2  AS CHAR.
  DEFINE VAR x-anula  As CHAR.
  DEFINE VAR X-SOL    AS DECIMAL.
  DEFINE VAR X-DOL    AS DECIMAL. 
  DEFINE VAR XX-SOL   AS DECIMAL.
  DEFINE VAR XX-DOL   AS DECIMAL. 
  DEFINE VAR X-RUC    AS CHAR.
  DEFINE VAR X-VEN    AS CHAR.
  DEFINE VAR X        AS INTEGER INIT 1.
  DEFINE VAR X-GLO    AS CHAR FORMAT "X(20)".
  DEFINE VAR X-CODREF AS CHAR.
  DEFINE VAR X-NROREF AS CHAR.
  DEFINE VAR X-FECHA  AS DATE.
  DEFINE VAR X-MOVTO  AS CHAR.

  X-MOVTO  = '(emitido)'. 
   RUN carga-notcre. 

  DEFINE FRAME f-cab2
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " C I E R R E   D E   C A J A "  AT 35 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Del : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Caja : " AT 1 FORMAT "X(10)"  {&PRN6A} + S-USER-ID AT 12 FORMAT "X(15)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(10)"  STRING(TIME,"HH:MM:SS") SKIP 
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                                                      " SKIP
        "          C O N C E P T O S                                                            SOLES                       DOLARES            " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  DEFINE FRAME f-cab
        NOTCRE.CodDoc FORMAT "XXX"
        NOTCRE.NroDoc FORMAT "XXX-XXXXXX"
        NOTCRE.FchDoc 
        NOTCRE.Codcli FORMAT "X(10)"
        NOTCRE.NomCli FORMAT "X(35)"
        X-MON         FORMAT "X(4)"
        F-ImpTot      
        NOTCRE.fmapgo format "x(4)"
        X-GLO         FORMAT "X(16)"
        X-CODREF      FORMAT "XXX"
        X-NROREF      FORMAT "XXX-XXXXXX"
        X-FECHA
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " REPORTE DE DOCUMENTOS EMITIDOS"  AT 41 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Del : " AT 55 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Caja : " AT 1 FORMAT "X(10)"  {&PRN6A} + S-USER-ID AT 12 FORMAT "X(15)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(10)"  STRING(TIME,"HH:MM:SS") SKIP 
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                                                  TOTAL                                         " SKIP
        "DOC  DOCUMENTO  EMISION    CODIGO             C L I E N T E               MON.          IMPORTE                                       " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 /* FOR EACH NOTCRE NO-LOCK WHERE 
 *            NOTCRE.CodCia = S-CODCIA AND
 *            NOTCRE.CodDiv = FILL-IN-CodDiv AND 
 *            NOTCRE.FchDoc >= F-desde AND
 *            NOTCRE.FchDoc <= F-hasta AND 
 *            LOOKUP(NOTCRE.CodDoc,"BOL,FAC,N/C,N/D") > 0 
 *            NOTCRE.Flgest <> "A"
 *            USE-INDEX LLAVE10
  *  */ 
    FOR EACH NOTCRE WHERE 
             NOTCRE.Flgest <> 'A'
             BREAK BY NOTCRE.codcia BY NOTCRE.Fchdoc  BY NOTCRE.FmaPgo BY (NOTCRE.FmaPgo + NOTCRE.Coddoc)
             BY NOTCRE.Nrodoc:
   

     /*IF R-S-TipImp = 1 THEN  {&NEW-PAGE}. */ 
     F-Impbrt = 0.
     F-Impdto = 0.
     F-Impexo = 0.
     F-Impvta = 0.
     F-Impigv = 0.
     F-Imptot = 0.
     x-anula  = "----- A N U L A D O -------".
     x-mon    = "".
     x-ven    = "".
     x-ruc    = "".
     IF NOTCRE.Flgest = 'A' THEN NEXT.
     IF NOTCRE.Flgest <> 'A'  THEN DO:
        F-ImpBrt = ImpBrt.
        F-ImpDto = ImpDto.
        F-ImpExo = ImpExo.
        F-ImpVta = ImpVta.
        F-ImpIgv = ImpIgv.
        F-Imptot = ImpTot.
        x-anula  = NOTCRE.Nomcli.
        x-ven    = NOTCRE.Codven.
        x-ruc    = NOTCRE.Ruccli.
        IF NOTCRE.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".
       
     END.
     
     IF FIRST-OF(NOTCRE.fmapgo) THEN DO:
          ASSIGN  XX-SOL = 0 XX-DOL = 0.     
          x-titu2 = " ".
          FIND gn-convt WHERE gn-convt.codig   = NOTCRE.fmapgo NO-LOCK NO-ERROR.
          IF AVAILABLE gn-convt THEN do:
            x-titu2 = TRIM(gn-convt.Nombr) + ' ' + X-MOVTO.
          end.
          display  STREAM REPORT.
          IF R-S-TipImp = 1 THEN DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          END.
          ELSE DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab2.
          END.
          put stream report
          {&PRN2} + {&PRN6A} + x-titu2 at 3 FORMAT "X(35)" + {&PRN3} + {&PRN6B} .
     END.
     IF FIRST-OF(NOTCRE.Fmapgo + NOTCRE.Coddoc) THEN DO:
          ASSIGN X-SOL = 0 X-DOL = 0.
          x-titu1 = " ".
          FIND facdocum WHERE facdocum.codcia  = NOTCRE.codcia and facdocum.coddoc = NOTCRE.coddoc NO-LOCK NO-ERROR.
          IF AVAILABLE facdocum THEN do:
            x-titu1 = facdocum.NomDoc.
          end.
          display  STREAM REPORT.
          IF R-S-TipImp = 1 THEN DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          END.
          ELSE DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab2.
          END.
          put stream report
          {&PRN2} + {&PRN6A} + x-titu1 at 10 FORMAT "X(35)" + {&PRN3} + {&PRN6B} .
     END.
     X = 1.
     X-GLO    = ' '.
     X-CODREF = ' '.
     X-NROREF = ' '.
     
     IF NOTCRE.Coddoc = 'N/C' THEN DO:
       X-CODREF = NOTCRE.Codref.
       X-NROREF = NOTCRE.Nroref.
       X-GLO    = 'DEVOLUCION'.
       X        = -1.
       IF NOTCRE.Cndcre = 'N' THEN DO:
       FIND CCBDDOCU WHERE CCBDDOCU.CODCIA = NOTCRE.Codcia AND 
                          CCBDDOCU.CODDOC = NOTCRE.Coddoc AND
                          CCBDDOCU.NRODOC = NOTCRE.Nrodoc NO-LOCK USE-INDEX LLAVE01.
        IF AVAILABLE CCBDDOCU THEN DO:
         FIND CCBTABLA WHERE CCBTABLA.CODCIA = CCBDDOCU.Codcia AND
                             CCBTABLA.TABLA  = 'N/C' AND
                             CCBTABLA.CODIGO = CCBDDOCU.CODMAT NO-LOCK.
         IF AVAILABLE CCBTABLA THEN x-glo = CCBTABLA.Nombre.                  
        END.
       END. 
       FIND CCBCDOCU WHERE CCBCDOCU.CODCIA = NOTCRE.Codcia AND 
                           CCBCDOCU.CODDOC = NOTCRE.Coddoc AND
                           CCBCDOCU.NRODOC = NOTCRE.Nrodoc NO-LOCK USE-INDEX LLAVE01.
       IF AVAILABLE CCBCDOCU THEN X-FECHA = CCBCDOCU.FCHDOC. 
     END.
     IF NOTCRE.codmon = 1 THEN DO:
       X-SOL  = X-SOL  + ( X * F-IMPTOT ).
       XX-SOL = XX-SOL + ( X * F-IMPTOT ).
       END.
     ELSE DO:
       X-DOL  = X-DOL  + (X * F-IMPTOT ).
       XX-DOL = XX-DOL + (X * F-IMPTOT ).
     END. 

     IF R-S-TipImp = 1 THEN DO:
                 
        DISPLAY STREAM REPORT 
              NOTCRE.CodDoc 
              NOTCRE.NroDoc 
              NOTCRE.FchDoc 
              NOTCRE.Codcli
              TRIM(x-anula)  @ NOTCRE.NomCli 
              X-MON           
              F-ImpTot         WHEN F-ImpTot <> 0
              NOTCRE.Fmapgo
              X-GLO 
              X-CODREF 
              X-NROREF 
              X-FECHA          WHEN NOTCRE.Coddoc = 'N/C'
              WITH FRAME F-Cab.
              
        IF LAST-OF(NOTCRE.Fmapgo + NOTCRE.Coddoc) THEN DO:
          display  STREAM REPORT.
          DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          PUT STREAM REPORT 
          {&PRN2} + {&PRN6A} + 'SUBTOTALES   :'   AT 20 FORMAT "X(20)" " S/." AT 50 X-SOL AT 55  {&PRN3} + {&PRN6B} SKIP.
          PUT STREAM REPORT   
          {&PRN2} + {&PRN6A} + '              '   AT 20 FORMAT "X(20)" "US$." AT 50 X-DOL AT 55  {&PRN3} + {&PRN6B}.
        END.
        IF LAST-OF(NOTCRE.Fmapgo) THEN DO:
          display  STREAM REPORT.
          DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          PUT STREAM REPORT 
          {&PRN2} + {&PRN6A} + 'TOTALES      :'   AT 20 FORMAT "X(20)" " S/." AT 50 XX-SOL AT 55 {&PRN3} + {&PRN6B} SKIP.
          PUT STREAM REPORT   
          {&PRN2} + {&PRN6A} + '              '   AT 20 FORMAT "X(20)" "US$." AT 50 XX-DOL AT 55 {&PRN3} + {&PRN6B} SKIP(5). 
        END.
     END.
     IF R-S-TipImp = 2 THEN DO:
          IF LAST-OF(NOTCRE.Fmapgo + NOTCRE.Coddoc) THEN DO:
            display  STREAM REPORT.
            PUT STREAM REPORT  X-SOL AT 80 X-DOL AT 110 .
          END.
     END.
 
 END.

 
 /**********************************************/
 
 IF R-S-TipImp = 2 THEN DO:
  RUN RECIBORESU.
 END.
 ELSE DO:
  RUN RECIBOS.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-NotCre W-Win 
PROCEDURE Carga-NotCre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH CcbcDocu NO-LOCK WHERE 
        CcbcDocu.CodCia = S-CODCIA AND
        CcbcDocu.CodDiv = FILL-IN-CodDiv AND 
        CcbcDocu.FchDoc = F-desde AND
        CcbcDocu.Usuario = S-user-id AND
        LOOKUP(CcbcDocu.CodDoc,"BOL,FAC,N/C,N/D") > 0 USE-INDEX LLAVE10:
        
        CREATE notcre.
        /*
        BUFFER-COPY Ccbcdocu TO notcre.
        */

        /* 03/02/10 COPY assignment */
        
        DO:
          ASSIGN
            notcre.CodCia     = ccbcdocu.CodCia
            notcre.CodDoc     = ccbcdocu.CodDoc
            notcre.NroDoc     = ccbcdocu.NroDoc
            notcre.FchDoc     = ccbcdocu.FchDoc
            notcre.CodCli     = ccbcdocu.CodCli
            notcre.NomCli     = ccbcdocu.NomCli
            notcre.DirCli     = ccbcdocu.DirCli
            notcre.RucCli     = ccbcdocu.RucCli
            notcre.CodAnt     = ccbcdocu.CodAnt
            notcre.CodPed     = ccbcdocu.CodPed
            notcre.NroPed     = ccbcdocu.NroPed
            notcre.NroOrd     = ccbcdocu.NroOrd
            notcre.ImpBrt     = ccbcdocu.ImpBrt
            notcre.ImpExo     = ccbcdocu.ImpExo
            notcre.PorIgv     = ccbcdocu.PorIgv
            notcre.ImpIgv     = ccbcdocu.ImpIgv
            notcre.ImpDto     = ccbcdocu.ImpDto
            notcre.ImpTot     = ccbcdocu.ImpTot
            notcre.SdoAct     = ccbcdocu.SdoAct
            notcre.FlgEst     = ccbcdocu.FlgEst.
        
          ASSIGN
            notcre.usuario    = ccbcdocu.usuario
            notcre.UsrDscto   = ccbcdocu.UsrDscto
            notcre.FlgCie     = ccbcdocu.FlgCie
            notcre.FchCie     = ccbcdocu.FchCie
            notcre.HorCie     = ccbcdocu.HorCie
            notcre.CodMon     = ccbcdocu.CodMon
            notcre.TpoCmb     = ccbcdocu.TpoCmb
            notcre.CodAlm     = ccbcdocu.CodAlm
            notcre.LugEnt     = ccbcdocu.LugEnt
            notcre.Tipo       = ccbcdocu.Tipo
            notcre.CodMov     = ccbcdocu.CodMov
            notcre.CodVen     = ccbcdocu.CodVen
            notcre.ImpIsc     = ccbcdocu.ImpIsc
            notcre.ImpVta     = ccbcdocu.ImpVta
            notcre.ImpFle     = ccbcdocu.ImpFle
            notcre.FchCan     = ccbcdocu.FchCan
            notcre.Glosa      = ccbcdocu.Glosa
            notcre.CodRef     = ccbcdocu.CodRef
            notcre.NroRef     = ccbcdocu.NroRef
            notcre.FchVto     = ccbcdocu.FchVto.
        
          ASSIGN
            notcre.CodCob     = ccbcdocu.CodCob
            notcre.CodCta     = ccbcdocu.CodCta
            notcre.CodAge     = ccbcdocu.CodAge
            notcre.FlgUbi     = ccbcdocu.FlgUbi
            notcre.FlgUbiA    = ccbcdocu.FlgUbiA
            notcre.FchUbi     = ccbcdocu.FchUbi
            notcre.FchUbiA    = ccbcdocu.FchUbiA
            notcre.FlgSit     = ccbcdocu.FlgSit
            notcre.Cndcre     = ccbcdocu.Cndcre
            notcre.CodDiv     = ccbcdocu.CodDiv
            notcre.ImpInt     = ccbcdocu.ImpInt
            notcre.FmaPgo     = ccbcdocu.FmaPgo
            notcre.FchAct     = ccbcdocu.FchAct
            notcre.FlgSitA    = ccbcdocu.FlgSitA
            notcre.TipVta     = ccbcdocu.TipVta
            notcre.PorDto     = ccbcdocu.PorDto
            notcre.TpoFac     = ccbcdocu.TpoFac
            notcre.FchCbd     = ccbcdocu.FchCbd
            notcre.NroSal     = ccbcdocu.NroSal
            notcre.FlgCbd     = ccbcdocu.FlgCbd.
        
          ASSIGN
            notcre.Codope     = ccbcdocu.Codope
            notcre.NroMes     = ccbcdocu.NroMes
            notcre.Nroast     = ccbcdocu.Nroast
            notcre.FchAnu     = ccbcdocu.FchAnu
            notcre.UsuAnu     = ccbcdocu.UsuAnu
            notcre.CodDpto    = ccbcdocu.CodDpto
            notcre.CodProv    = ccbcdocu.CodProv
            notcre.CodDist    = ccbcdocu.CodDist
            notcre.FlgCon     = ccbcdocu.FlgCon
            notcre.LugEnt2    = ccbcdocu.LugEnt2
            notcre.FlgAte     = ccbcdocu.FlgAte
            notcre.FchAte     = ccbcdocu.FchAte
            notcre.imptot2    = ccbcdocu.imptot2
            notcre.ImpCto     = ccbcdocu.ImpCto
            notcre.AcuBon[ 1] = ccbcdocu.AcuBon[ 1]
            notcre.AcuBon[ 2] = ccbcdocu.AcuBon[ 2]
            notcre.AcuBon[ 3] = ccbcdocu.AcuBon[ 3]
            notcre.AcuBon[ 4] = ccbcdocu.AcuBon[ 4]
            notcre.AcuBon[ 5] = ccbcdocu.AcuBon[ 5]
            notcre.AcuBon[ 6] = ccbcdocu.AcuBon[ 6].
        
          ASSIGN
            notcre.AcuBon[ 7] = ccbcdocu.AcuBon[ 7]
            notcre.AcuBon[ 8] = ccbcdocu.AcuBon[ 8]
            notcre.AcuBon[ 9] = ccbcdocu.AcuBon[ 9]
            notcre.AcuBon[10] = ccbcdocu.AcuBon[10]
            notcre.NroCard    = ccbcdocu.NroCard
            notcre.TipBon[ 1] = ccbcdocu.TipBon[ 1]
            notcre.TipBon[ 2] = ccbcdocu.TipBon[ 2]
            notcre.TipBon[ 3] = ccbcdocu.TipBon[ 3]
            notcre.TipBon[ 4] = ccbcdocu.TipBon[ 4]
            notcre.TipBon[ 5] = ccbcdocu.TipBon[ 5]
            notcre.TipBon[ 6] = ccbcdocu.TipBon[ 6]
            notcre.TipBon[ 7] = ccbcdocu.TipBon[ 7]
            notcre.TipBon[ 8] = ccbcdocu.TipBon[ 8]
            notcre.TipBon[ 9] = ccbcdocu.TipBon[ 9]
            notcre.TipBon[10] = ccbcdocu.TipBon[10]
            notcre.CCo        = ccbcdocu.CCo
            notcre.FlgEnv     = ccbcdocu.FlgEnv
            notcre.puntos     = ccbcdocu.puntos
            notcre.mrguti     = ccbcdocu.mrguti
            notcre.Sede       = ccbcdocu.Sede.
        
          ASSIGN
            notcre.Libre_c01  = ccbcdocu.Libre_c01
            notcre.Libre_c02  = ccbcdocu.Libre_c02
            notcre.Libre_c03  = ccbcdocu.Libre_c03
            notcre.Libre_c04  = ccbcdocu.Libre_c04
            notcre.Libre_c05  = ccbcdocu.Libre_c05
            notcre.Libre_d01  = ccbcdocu.Libre_d01
            notcre.Libre_d02  = ccbcdocu.Libre_d02
            notcre.Libre_f01  = ccbcdocu.Libre_f01
            notcre.Libre_f02  = ccbcdocu.Libre_f02.
        END.
            END.
        
            FOR EACH notcre WHERE LOOKUP(notcre.CodDoc,"N/C,N/D") > 0 :
                FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                    ccbcdocu.coddiv = FILL-IN-CodDiv AND 
                    ccbcdocu.coddoc = notcre.codref  AND  
                    ccbcdocu.nrodoc = notcre.nroref USE-INDEX LLAVE00 NO-LOCK NO-ERROR.
                IF AVAILABLE ccbcdocu THEN DO:
                    notcre.fmapgo = ccbcdocu.fmapgo.
                END.
            END.

              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ChequeResu W-Win 
PROCEDURE ChequeResu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR X-impo   AS DECIMAL.
 DEFINE VAR T-MOVTO  AS CHAR.
 DEFINE VAR X-CONT   AS INTEGER INIT 0.
 DEFINE VAR X-SOL    AS DECIMAL INIT 0.
 DEFINE VAR X-DOL    AS DECIMAL INIT 0.
 DEFINE VAR X-SOLDEPO    AS DECIMAL INIT 0.
 DEFINE VAR X-DOLDEPO    AS DECIMAL INIT 0.

 DEFINE FRAME f-cab4
        WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

 FOR EACH CcbCcaja WHERE 
          CcbcCaja.CodCia  = S-CODCIA AND 
          CcbcCaja.CodDiv  = S-CODDIV AND 
          CcbcCaja.CodDoc  = "I/C"    AND
          CcbcCaja.FchDoc = F-desde  AND 
          CCbcCaja.Flgest  <> 'A' AND
         (CcbcCaja.ImpNac[2] <> 0 OR CcbcCaja.ImpNac[3] <> 0 OR
          CcbcCaja.ImpUsa[2] <> 0 OR CcbcCaja.ImpUsa[3] <> 0 OR 
          CcbcCaja.ImpUsa[5] <> 0 OR CcbcCaja.ImpNac[5] <> 0 ) AND

/*        CcbCCaja.CodCaja = S-CODTER AND */
          CcbCCaja.usuario = S-USER-ID       NO-LOCK USE-INDEX LLAVE07
          BREAK BY CcbcCaja.CodCia 
                BY CcbCcaja.Tipo  
                BY CcbcCaja.NroDoc:
     
        X-IMPO   = 0.
        IF CcbCCaja.ImpNac[2] <> 0 OR CcbCCaja.ImpNac[3] <> 0 THEN DO:
          x-impo    = CcbCCaja.ImpNac[2].
          IF x-impo = 0 THEN x-impo = CcbCCaja.ImpNac[3].
          x-sol     = x-sol + x-impo.
        END.   

        IF CcbCCaja.ImpUsa[2] <> 0 OR CcbCCaja.ImpUsa[3] <> 0 THEN DO:
          x-impo    = CcbCCaja.ImpUsa[2].
          IF x-impo = 0 THEN x-impo = CcbCCaja.ImpUsa[3].
          x-dol     = x-dol + x-impo.
        END.   

        IF CcbCCaja.ImpNac[5] <> 0 THEN DO:
          x-impo    = CcbCCaja.ImpNac[5].
          x-soldepo = x-soldepo + x-impo.
        END.   
        
        IF CcbCCaja.ImpUsa[5] <> 0 THEN DO:
          x-impo    = CcbCCaja.ImpUsa[5].
          x-doldepo = x-doldepo + x-impo.
        END.   
 END. 
 
 T-MOVTO  = "CHEQUES (recepcionados)".
 DISPLAY STREAM REPORT.
 DOWN(1) STREAM REPORT WITH FRAME F-CAB4.
 PUT STREAM REPORT {&PRN2} + {&PRN6A} + T-MOVTO  AT 3 FORMAT "X(35)" + {&PRN6B} + {&PRN3}.  
 DISPLAY STREAM REPORT.
 PUT STREAM REPORT X-SOL AT 80 X-DOL AT 110.

 T-MOVTO  = "DEPOSITOS (recepcionados)".
 DISPLAY STREAM REPORT.
 DOWN(1) STREAM REPORT WITH FRAME F-CAB4.
 PUT STREAM REPORT {&PRN2} + {&PRN6A} + T-MOVTO AT 3 FORMAT "X(35)" + {&PRN6B} + {&PRN3}.  
 DISPLAY STREAM REPORT.
 PUT STREAM REPORT X-SOLDEPO AT 80 X-DOLDEPO AT 110.
 
RUN PENDIENTE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cheques W-Win 
PROCEDURE Cheques :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR X-impo   AS DECIMAL.
 DEFINE VAR T-MOVTO  AS CHAR.
 DEFINE VAR X-CONT   AS INTEGER INIT 0.
 DEFINE VAR X-SOL    AS DECIMAL INIT 0.
 DEFINE VAR X-DOL    AS DECIMAL INIT 0.
 DEFINE FRAME f-cab3
        CcbcCaja.Tipo FORMAT "X(10)"
        CcbcCaja.Fchdoc
        CcbcCaja.Codcli
        CcbcCaja.Nomcli
        CcbcCaja.Voucher[2]
        CcbcCaja.CodBco[2]
        CcbcCaja.CodCta[2]
        CcbcCaja.Fchvto[2]
        x-mon
        CcbcCaja.ImpNac[2]
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " RELACION DE CHEQUES RECEPCIONADOS "  AT 45 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Del : " AT 55 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Caja : " AT 1 FORMAT "X(10)"  {&PRN6A} + S-USER-ID AT 12 FORMAT "X(15)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(10)" STRING(TIME,"HH:MM:SS") SKIP 

        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                     NUMERO                                FECHA                                      " SKIP   
        " TIPO       FECHA     CODIGO     NOMBRE              CHEQUE             BANCO   CUENTA      VCTO   MONEDA          IMPORTE            " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

    
 FOR EACH CcbCcaja WHERE 
          CcbcCaja.CodCia  = S-CODCIA AND 
          CcbcCaja.CodDiv  = S-CODDIV AND 
          CcbcCaja.CodDoc  = "I/C"    AND
          CcbcCaja.FchDoc = F-desde  AND 
          CCbcCaja.Flgest  <> 'A' AND
         (CcbcCaja.ImpNac[2] <> 0 OR CcbcCaja.ImpNac[3] <> 0 OR
          CcbcCaja.ImpUsa[2] <> 0 OR CcbcCaja.ImpUsa[3] <> 0) AND
/*        CcbCCaja.CodCaja = S-CODTER AND */
          CcbCCaja.usuario = S-USER-ID      NO-LOCK USE-INDEX LLAVE07
          BREAK BY CcbcCaja.CodCia 
                BY CcbCcaja.Tipo  
                BY CcbcCaja.NroDoc:
       
     
        X-IMPO   = 0.
        T-MOVTO  = "CHEQUES ".
        IF X-CONT = 0 THEN DO:
          DISPLAY STREAM REPORT.
          DOWN(1) STREAM REPORT WITH FRAME F-CAB3.
          PUT STREAM REPORT {&PRN2} + {&PRN6A} + T-MOVTO +  {&PRN6B} + {&PRN3} AT 3 FORMAT "X(40)".  
          X-CONT = 1.       
        END.   
        IF CcbCCaja.ImpNac[2] <> 0 OR CcbCCaja.ImpNac[3] <> 0 THEN DO:
          x-mon     = 'S/.'.
          x-impo    = CcbCCaja.ImpNac[2].
          IF x-impo = 0 THEN x-impo = CcbCCaja.ImpNac[3].
          x-sol     = x-sol + x-impo.
        END.   

        IF CcbCCaja.ImpUsa[2] <> 0 OR CcbCCaja.ImpUsa[3] <> 0 THEN DO:
          x-mon     = 'US$.'.
          x-impo    = CcbCCaja.ImpUsa[2].
          IF x-impo = 0 THEN x-impo = CcbCCaja.ImpUsa[3].
          x-dol     = x-dol + x-impo.
        END.   
       
        DISPLAY STREAM REPORT
          CcbcCaja.Tipo   
          CcbcCaja.Fchdoc
          CcbcCaja.Codcli
          CcbcCaja.Nomcli
          CcbcCaja.Voucher[2]
          CcbcCaja.CodBco[2]
          CcbcCaja.CodCta[2]
          CcbcCaja.Fchvto[2]
          x-mon
          x-impo
          WITH FRAME f-cab3.
                
 END. 

 DISPLAY STREAM REPORT.
 DOWN(1) STREAM REPORT.
 PUT STREAM REPORT SKIP(2).
 PUT STREAM REPORT 
 {&PRN2} + {&PRN6A} + 'SUBTOTALES   :'   AT 20 FORMAT "X(20)" " S/." AT 50 X-SOL AT 55  {&PRN3} + {&PRN6B} SKIP.
 PUT STREAM REPORT   
 {&PRN2} + {&PRN6A} + '              '   AT 20 FORMAT "X(20)" "US$." AT 50 X-DOL AT 55  {&PRN3} + {&PRN6B}.
       

 
RUN DEPOSITOS.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Depositos W-Win 
PROCEDURE Depositos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR X-impo   AS DECIMAL.
 DEFINE VAR T-MOVTO  AS CHAR.
 DEFINE VAR X-CONT   AS INTEGER INIT 0.
 DEFINE VAR X-SOL    AS DECIMAL INIT 0.
 DEFINE VAR X-DOL    AS DECIMAL INIT 0.

 DEFINE FRAME f-cab3
        CcbcCaja.Tipo FORMAT "X(10)"
        CcbcCaja.Fchdoc
        CcbcCaja.Codcli
        CcbcCaja.Nomcli
        CcbcCaja.Voucher[5]
        CcbcCaja.CodBco[5]
        CcbcCaja.CodCta[5]
        CcbcCaja.Fchvto[5]
        x-mon
        CcbcCaja.ImpNac[5]
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " RELACION DE DEPOSITOS "  AT 45 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Del : " AT 55 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Caja : " AT 1 FORMAT "X(10)"  {&PRN6A} + S-USER-ID AT 12 FORMAT "X(15)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(10)" STRING(TIME,"HH:MM:SS") SKIP 

        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                     NUMERO                                FECHA                                      " SKIP   
        " TIPO       FECHA     CODIGO     NOMBRE             B. DEPOSITO         BANCO   CUENTA      VCTO   MONEDA          IMPORTE            " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
    
 
 FOR EACH CcbCcaja WHERE 
          CcbcCaja.CodCia  = S-CODCIA AND 
          CcbcCaja.CodDiv  = S-CODDIV AND 
          CcbcCaja.CodDoc  = "I/C"    AND
          CcbcCaja.FchDoc  = F-desde  AND 
          CCbcCaja.Flgest  <> 'A' AND
         (CcbcCaja.ImpNac[5] <> 0 OR CcbcCaja.ImpUsa[5] <> 0) AND
/*        CcbCCaja.CodCaja = S-CODTER AND */
          CcbCCaja.usuario = S-USER-ID       NO-LOCK USE-INDEX LLAVE07
          BREAK BY CcbcCaja.CodCia 
                BY CcbCcaja.Tipo  
                BY CcbcCaja.NroDoc:
           
       /*{&new-page}.*/
            
     
        X-IMPO   = 0.
        T-MOVTO  = "BOLETAS  DE DEPOSITO".
        IF X-CONT = 0 THEN DO:
          DISPLAY STREAM REPORT.
          DOWN(1) STREAM REPORT WITH FRAME F-CAB3.
          PUT STREAM REPORT {&PRN2} + {&PRN6A} + T-MOVTO +  {&PRN6B} + {&PRN3} AT 3 FORMAT "X(60)".  
          X-CONT = 1.       
        END.   
        IF CcbCCaja.ImpNac[5] <> 0  THEN DO:
          x-mon     = 'S/.'.
          x-impo    = CcbCCaja.ImpNac[5].
          x-sol     = x-sol + x-impo.
        END.   

        IF CcbCCaja.ImpUsa[5] <> 0  THEN DO:
          x-mon     = 'US$.'.
          x-impo    = CcbCCaja.ImpUsa[5].
          x-dol     = x-dol + x-impo.
        END.   
       
        DISPLAY STREAM REPORT
          CcbcCaja.Tipo   
          CcbcCaja.Fchdoc
          CcbcCaja.Codcli
          CcbcCaja.Nomcli
          CcbcCaja.Voucher[5]
          CcbcCaja.CodBco[5]
          CcbcCaja.CodCta[5]
          CcbcCaja.Fchvto[5]
          x-mon
          x-impo
          WITH FRAME f-cab3.
                
 END. 
 DISPLAY STREAM REPORT.
 DOWN(1) STREAM REPORT.
 PUT STREAM REPORT SKIP(2).
 PUT STREAM REPORT 
 {&PRN2} + {&PRN6A} + 'SUBTOTALES   :'   AT 20 FORMAT "X(20)" " S/." AT 50 X-SOL AT 55  {&PRN3} + {&PRN6B} SKIP.
 PUT STREAM REPORT   
 {&PRN2} + {&PRN6A} + '              '   AT 20 FORMAT "X(20)" "US$." AT 50 X-DOL AT 55  {&PRN3} + {&PRN6B}.
       


 
RUN PENDIENTE.

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
  DISPLAY FILL-IN-CodDiv f-desde R-S-TipImp FILL-IN-efesol FILL-IN-efedol 
          FILL-IN-remesol FILL-IN-remedol txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-70 RECT-71 RECT-50 RECT-51 FILL-IN-CodDiv f-desde R-S-TipImp 
         FILL-IN-efesol FILL-IN-efedol FILL-IN-remesol FILL-IN-remedol BUTTON-3 
         BUTTON-4 
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
        RUN carga-data.
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
  
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN FILL-IN-Coddiv = S-CODDIV
          F-DESDE   = TODAY.
  END.



  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pendiente W-Win 
PROCEDURE Pendiente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR x-tpocmb AS DECIMAL NO-UNDO.
  DEFINE VAR x-titu1  AS CHAR.
  DEFINE VAR x-titu2  AS CHAR.
  DEFINE VAR x-anula  As CHAR.
  DEFINE VAR X-SOL    AS DECIMAL.
  DEFINE VAR X-DOL    AS DECIMAL. 
  DEFINE VAR XX-SOL   AS DECIMAL.
  DEFINE VAR XX-DOL   AS DECIMAL. 
  DEFINE VAR X-RUC    AS CHAR.
  DEFINE VAR X-VEN    AS CHAR.
  DEFINE VAR X        AS INTEGER INIT 1.
  DEFINE VAR X-GLO    AS CHAR FORMAT "X(20)".
  DEFINE VAR X-CODREF AS CHAR.
  DEFINE VAR X-NROREF AS CHAR.
  DEFINE VAR X-FECHA  AS DATE.
  DEFINE VAR X-MOVTO  AS CHAR.
  X-MOVTO = '(pendiente)'.
  DEFINE FRAME f-cab2
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.


  DEFINE FRAME f-cab
        CCBCDOCU.CodDoc FORMAT "XXX"
        CCBCDOCU.NroDoc FORMAT "XXX-XXXXXX"
        CCBCDOCU.FchDoc 
        CCBCDOCU.Codcli FORMAT "X(10)"
        CCBCDOCU.NomCli FORMAT "X(35)"
        X-MON         FORMAT "X(4)"
        F-ImpTot      
        CCBCDOCU.fmapgo format "x(4)"
        X-GLO         FORMAT "X(16)"
        X-CODREF      FORMAT "XXX"
        X-NROREF      FORMAT "XXX-XXXXXX"
        X-FECHA
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " CONTRA ENTREGA PENDIENTES "  AT 41 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Al : " AT 55 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Caja : " AT 1 FORMAT "X(10)"  {&PRN6A} + S-USER-ID AT 12 FORMAT "X(15)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(10)" STRING(TIME,"HH:MM:SS") SKIP 

        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                                                  TOTAL                                         " SKIP
        "DOC  DOCUMENTO  EMISION    CODIGO             C L I E N T E               MON.          IMPORTE                                       " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
  FOR EACH CCBCDOCU NO-LOCK WHERE 
           CCBCDOCU.CodCia = S-CODCIA AND
           CCBCDOCU.Flgest = 'P'      AND
           CCBCDOCU.CodDiv = FILL-IN-CodDiv AND
           CCBCDOCU.Fchdoc < F-desde AND
           CCBCDOCU.FmaPgo = '001'  AND 
           LOOKUP(CCBCDOCU.CodDoc,"BOL,FAC") > 0 AND
           CCBCDOCU.Flgest <> "A"
           USE-INDEX LLAVE03
    
            BREAK BY CCBCDOCU.codcia  BY CCBCDOCU.FmaPgo BY (CCBCDOCU.FmaPgo + CCBCDOCU.Coddoc)
             BY CCBCDOCU.Nrodoc:
     
     x-tpocmb = CCBCDOCU.Tpocmb.
     /*IF R-S-TipImp = 1 THEN  {&NEW-PAGE}.*/
     F-Impbrt = 0.
     F-Impdto = 0.
     F-Impexo = 0.
     F-Impvta = 0.
     F-Impigv = 0.
     F-Imptot = 0.
     x-anula  = "----- A N U L A D O -------".
     x-mon    = "".
     x-ven    = "".
     x-ruc    = "".
     IF CCBCDOCU.Flgest = 'A' THEN NEXT.
     IF CCBCDOCU.Flgest <> 'A'  THEN DO:
        
        F-Imptot = CCBCDOCU.SdoAct.    /*ImpTot.*/
        x-anula  = CCBCDOCU.Nomcli.
        x-ven    = CCBCDOCU.Codven.
        x-ruc    = CCBCDOCU.Ruccli.
        IF CCBCDOCU.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".
       
     END.
     
     IF FIRST-OF(CCBCDOCU.fmapgo) THEN DO:
          ASSIGN  XX-SOL = 0 XX-DOL = 0.     
          x-titu2 = " ".
          FIND gn-convt WHERE gn-convt.codig   = CCBCDOCU.fmapgo NO-LOCK NO-ERROR.
          IF AVAILABLE gn-convt THEN do:
            x-titu2 = TRIM(gn-convt.Nombr) + ' ' + X-MOVTO.
          end.
          display  STREAM REPORT.
          IF R-S-TipImp = 1 THEN DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          END.
          ELSE DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab2.
          END.
          put stream report
          {&PRN2} + {&PRN6A} + x-titu2 at 3 FORMAT "X(50)" + {&PRN3} + {&PRN6B} .
     END.
     IF FIRST-OF(CCBCDOCU.Fmapgo + CCBCDOCU.Coddoc) THEN DO:
          ASSIGN X-SOL = 0 X-DOL = 0.
          x-titu1 = " ".
          FIND facdocum WHERE facdocum.codcia  = CCBCDOCU.codcia and facdocum.coddoc = CCBCDOCU.coddoc NO-LOCK NO-ERROR.
          IF AVAILABLE facdocum THEN do:
            x-titu1 = facdocum.NomDoc.
          end.
          display  STREAM REPORT.
          IF R-S-TipImp = 1 THEN DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          END.
          ELSE DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab2.
          END.
          put stream report
          {&PRN2} + {&PRN6A} + x-titu1 at 10 FORMAT "X(35)" + {&PRN3} + {&PRN6B} .
     END.
     X = 1.
     X-GLO    = ' '.
     X-CODREF = ' '.
     X-NROREF = ' '.
     
     
     IF CCBCDOCU.codmon = 1 THEN DO:
       X-SOL  = X-SOL  + ( X * F-IMPTOT ).
       XX-SOL = XX-SOL + ( X * F-IMPTOT ).
       END.
     ELSE DO:
       X-DOL  = X-DOL  + (X * F-IMPTOT ).
       XX-DOL = XX-DOL + (X * F-IMPTOT ).
     END. 

     IF R-S-TipImp = 1 THEN DO:
                 
        DISPLAY STREAM REPORT 
              CCBCDOCU.CodDoc 
              CCBCDOCU.NroDoc 
              CCBCDOCU.FchDoc 
              CCBCDOCU.Codcli
              TRIM(x-anula)  @ CCBCDOCU.NomCli 
              X-MON           
              F-ImpTot         WHEN F-ImpTot <> 0
              CCBCDOCU.Fmapgo
              X-GLO 
              X-CODREF 
              X-NROREF 
              X-FECHA          WHEN CCBCDOCU.Coddoc = 'N/C'
              WITH FRAME F-Cab.
              
        IF LAST-OF(CCBCDOCU.Fmapgo + CCBCDOCU.Coddoc) THEN DO:
          display  STREAM REPORT.
          DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          PUT STREAM REPORT 
          {&PRN2} + {&PRN6A} + 'SUBTOTALES   :'   AT 20 FORMAT "X(20)" " S/." AT 50 X-SOL AT 55  {&PRN3} + {&PRN6B} SKIP.
          PUT STREAM REPORT   
          {&PRN2} + {&PRN6A} + '              '   AT 20 FORMAT "X(20)" "US$." AT 50 X-DOL AT 55  {&PRN3} + {&PRN6B}.
        END.
        IF LAST-OF(CCBCDOCU.Fmapgo) THEN DO:
          display  STREAM REPORT.
          DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          PUT STREAM REPORT 
          {&PRN2} + {&PRN6A} + 'TOTALES      :'   AT 20 FORMAT "X(20)" " S/." AT 50 XX-SOL AT 55 {&PRN3} + {&PRN6B} SKIP.
          PUT STREAM REPORT   
          {&PRN2} + {&PRN6A} + '              '   AT 20 FORMAT "X(20)" "US$." AT 50 XX-DOL AT 55 {&PRN3} + {&PRN6B} SKIP(5). 
        END.
     END.
     IF R-S-TipImp = 2 THEN DO:
          IF LAST-OF(CCBCDOCU.Fmapgo + CCBCDOCU.Coddoc) THEN DO:
            display  STREAM REPORT.
            PUT STREAM REPORT  X-SOL AT 80 X-DOL AT 110 .
          END.
     END.
 
 END.
 
 IF  R-S-TipImp = 2 THEN DO:
  display  STREAM REPORT.
  DOWN(4) STREAM REPORT .
  PUT STREAM REPORT skip(5).
  PUT STREAM REPORT
  'Bajo la presente constancia declaro en honor a la verdad que lo aqui detallado corresponde al total de pagos' SKIP.
  PUT STREAM REPORT
  'por los cuales debo emitir recibos, segun procedimiento de FNP, que declaro conocer. ' SKIP(3).
  PUT STREAM REPORT
  '_______________________________'   AT 10 '_______________________________' AT 90  SKIP.
  PUT STREAM REPORT   
  ' Cajera(o)                     '   AT 10 'Administrador                  ' AT 90 . 


 END.

 IF  R-S-TipImp = 1 THEN RUN ANULADOS.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReciboResu W-Win 
PROCEDURE ReciboResu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR G-EFESOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 DEFINE VAR G-EFEDOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 DEFINE VAR T-MOVTO   AS CHAR .
 DEFINE VAR T-EFESOL AS DECIMAL.
 DEFINE VAR T-EFEDOL AS DECIMAL.
 DEFINE VAR T-CHDSOL AS DECIMAL.
 DEFINE VAR T-CHDDOL AS DECIMAL.
 DEFINE VAR T-CHFSOL AS DECIMAL.
 DEFINE VAR T-CHFDOL AS DECIMAL.
 DEFINE VAR T-NCRSOL AS DECIMAL.
 DEFINE VAR T-NCRDOL AS DECIMAL.
 DEFINE VAR T-DEPSOL AS DECIMAL.
 DEFINE VAR T-DEPDOL AS DECIMAL.
 DEFINE VAR X-MOVTO  AS CHAR.
 X-MOVTO = '(emitido)'.


 DEFINE FRAME f-cab4
        WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
         DISPLAY STREAM REPORT.
         DOWN(1) STREAM REPORT WITH FRAME F-CAB4.
         PUT STREAM REPORT {&PRN2} + {&PRN6A} + 'TOTAL EFECTIVO (declarado)'   AT 3 FORMAT "X(35)" +  {&PRN6B} + {&PRN3}.  
         PUT STREAM REPORT FILL-IN-efesol AT 80  FILL-IN-efedol AT 107.
         DOWN(1) STREAM REPORT WITH FRAME F-CAB4.
         PUT STREAM REPORT {&PRN2} + {&PRN6A} + 'TOTAL REMESAS (declarado)'   AT 3 FORMAT "X(35)" +  {&PRN6B} + {&PRN3} .  
         PUT STREAM REPORT FILL-IN-remesol AT 80 FILL-IN-remedol AT 110.
   
 FOR EACH CcbCcaja WHERE 
          CcbcCaja.CodCia  = S-CODCIA AND 
          CcbcCaja.CodDiv  = S-CODDIV AND 
          CcbcCaja.CodDoc  = "I/C"    AND
          CcbcCaja.FchDoc  = F-desde  AND 
          ( CCbcCaja.tipo    = 'CFAC' OR CcbCcAja.Tipo = 'CANCELACION' )  AND
          CCbcCaja.Flgest  <> 'A' AND
/*        CcbCCaja.CodCaja = S-CODTER AND */
          CcbCCaja.usuario = S-USER-ID       NO-LOCK USE-INDEX LLAVE07,
          EACH CcbDCaja OF CcbCcaja 
          BREAK BY CcbcCaja.CodCia 
                BY CcbCcaja.Tipo   
                BY CcbDcaja.NroDoc
                BY CcbDcaja.Nroref:
           
      
     IF FIRST-OF(CcbcCaja.Tipo) THEN DO:
        T-EFESOL = 0.
        T-EFEDOL = 0.
        T-CHDSOL = 0.
        T-CHDDOL = 0.
        T-CHFSOL = 0.
        T-CHFDOL = 0.
        T-NCRSOL = 0.
        T-NCRDOL = 0.
        T-DEPSOL = 0.
        T-DEPDOL = 0.
        T-MOVTO  = " ".
        IF CcbcCaja.Tipo = "CAFA" THEN T-MOVTO = "CANCELACION DE FACTURAS".
        IF CcbcCaja.Tipo = "CABO" THEN T-MOVTO = "CANCELACION DE BOLETAS".
        IF CcbcCaja.Tipo = "CANCELACION" OR CcbcCaja.Tipo = "CFAC" THEN T-MOVTO = "RECIBOS" + ' ' + X-MOVTO.
         DISPLAY STREAM REPORT.
         DOWN(1) STREAM REPORT WITH FRAME F-CAB4.
         PUT STREAM REPORT {&PRN2} + {&PRN6A} + T-MOVTO  AT 3 FORMAT "X(35)" + {&PRN6B} + {&PRN3}.  
     END.     
     IF CcbDCaja.CodMon = 1 THEN DO:
        x-mon       = 'S/.'.
        G-EFESOL    = G-EFESOL + CcbDCaja.Imptot.
     END.   
     IF CcbDCaja.CodMon = 2 THEN DO:
        x-mon       = 'US$.'.
        G-EFEDOL    = G-EFEDOL + CcbDCaja.Imptot.
     END.   
     IF CcbCcaja.Flgest <> "A"  THEN DO:
        T-EFESOL = T-EFESOL + ( CcbcCaja.ImpNac[1] - CcbCCaja.VueNac ).
        T-EFEDOL = T-EFEDOL + ( CcbcCaja.ImpUsa[1] - CcbCCaja.VueUsa ).
        T-CHDSOL = T-CHDSOL + CcbcCaja.ImpNac[2].
        T-CHDDOL = T-CHDDOL + CcbcCaja.ImpUsa[2].
        T-CHFSOL = T-CHFSOL + CcbcCaja.ImpNac[3].
        T-CHFDOL = T-CHFDOL + CcbcCaja.ImpUsa[3].
        T-NCRSOL = T-NCRSOL + CcbcCaja.ImpNac[6].
        T-NCRDOL = T-NCRDOL + CcbcCaja.ImpUsa[6].
        T-DEPSOL = T-DEPSOL + CcbcCaja.ImpNac[5].
        T-DEPDOL = T-DEPDOL + CcbcCaja.ImpUsa[5].
        
     END.
                
     IF LAST-OF(CcbcCaja.Tipo) THEN DO:
/*        G-EFESOL =  T-EFESOL + T-CHDSOL + T-CHFSOL + T-NCRSOL + T-DEPSOL.
 *         G-EFEDOL =  T-EFEDOL + T-CHDDOL + T-CHFDOL + T-NCRDOL + T-DEPDOL.*/
        DISPLAY STREAM REPORT.
        PUT STREAM REPORT G-EFESOL AT 80 G-EFEDOL AT 110.
     END.
 END. 
 RUN CHEQUERESU. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recibos W-Win 
PROCEDURE Recibos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR G-EFESOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 DEFINE VAR G-EFEDOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 DEFINE VAR G-CHDSOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.  
 DEFINE VAR G-CHDDOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.
 DEFINE VAR G-CHFSOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.
 DEFINE VAR G-CHFDOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.
 DEFINE VAR G-NCRSOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.
 DEFINE VAR G-NCRDOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.  
 DEFINE VAR G-DEPSOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 DEFINE VAR G-DEPDOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 
 DEFINE VAR D-IMPORT AS DECIMAL FORMAT "->>>,>>9.99" INIT 0 EXTENT 2.
 DEFINE VAR T-MOVTO   AS CHAR .
 DEFINE VAR T-EFESOL AS DECIMAL.
 DEFINE VAR T-EFEDOL AS DECIMAL.
 DEFINE VAR T-CHDSOL AS DECIMAL.
 DEFINE VAR T-CHDDOL AS DECIMAL.
 DEFINE VAR T-CHFSOL AS DECIMAL.
 DEFINE VAR T-CHFDOL AS DECIMAL.
 DEFINE VAR T-NCRSOL AS DECIMAL.
 DEFINE VAR T-NCRDOL AS DECIMAL.
 DEFINE VAR T-DEPSOL AS DECIMAL.
 DEFINE VAR T-DEPDOL AS DECIMAL.

 
 DEFINE VAR X-FMAPGO AS CHAR FORMAT "X(5)".
 DEFINE VAR X-FECHA  AS DATE.

DEFINE FRAME f-cab4
        WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

 DEFINE FRAME f-cab8
        CcbcCaja.Coddoc
        CcbcCaja.Nrodoc
        CcbcCaja.Tipo
        CcbcCaja.Fchdoc
        CcbcCaja.Codcli
        CcbcCaja.Nomcli
        CcbdCaja.Codref
        CcbdCaja.Nroref
        CcbdCaja.Fchdoc
        X-FMAPGO
        x-mon
        CcbdCaja.Imptot
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " RELACION DE RECIBOS EMITIDOS "  AT 45 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Del : " AT 55 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Caja : " AT 1 FORMAT "X(10)"  {&PRN6A} + S-USER-ID AT 12 FORMAT "X(15)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(10)" STRING(TIME,"HH:MM:SS") SKIP 

        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                                                      " SKIP
        "          C O N C E P T O S                                                                                                           " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

      
        
 FOR EACH CcbCcaja WHERE 
          CcbcCaja.CodCia  = S-CODCIA AND 
          CcbcCaja.CodDiv  = S-CODDIV AND 
          CcbcCaja.CodDoc  = "I/C"    AND
          CcbcCaja.FchDoc  = F-desde  AND 
          ( CCbcCaja.tipo    = 'CFAC' OR CcbCcAja.Tipo = 'CANCELACION' )  AND
          CCbcCaja.Flgest  <> 'A' AND
/*        CcbCCaja.CodCaja = S-CODTER AND */
          CcbCCaja.usuario = S-USER-ID       NO-LOCK USE-INDEX LLAVE07,
          EACH CcbDCaja OF CcbCcaja 
          BREAK BY CcbcCaja.CodCia 
                BY CcbCcaja.Tipo   
                BY CcbDcaja.NroDoc
                BY CcbDcaja.Nroref:
           
          
      
     IF FIRST-OF(CcbcCaja.Tipo) THEN DO:
        T-EFESOL = 0.
        T-EFEDOL = 0.
        T-CHDSOL = 0.
        T-CHDDOL = 0.
        T-CHFSOL = 0.
        T-CHFDOL = 0.
        T-NCRSOL = 0.
        T-NCRDOL = 0.
        T-DEPSOL = 0.
        T-DEPDOL = 0.
        T-MOVTO  = " ".
        IF CcbcCaja.Tipo = "CAFA" THEN T-MOVTO = "CANCELACION DE FACTURAS".
        IF CcbcCaja.Tipo = "CABO" THEN T-MOVTO = "CANCELACION DE BOLETAS".
        IF CcbcCaja.Tipo = "CANCELACION" OR CcbcCaja.Tipo = "CFAC" THEN T-MOVTO = "RECIBOS".
        IF  R-S-TipImp = 1 AND T-MOVTO = 'RECIBOS' THEN DO:
         DISPLAY STREAM REPORT.
         DOWN(1) STREAM REPORT WITH FRAME F-CAB8.
         PUT STREAM REPORT {&PRN2} + {&PRN6A} + T-MOVTO +  {&PRN6B} + {&PRN3} AT 3 FORMAT "X(35)".  
        END.
        IF  R-S-TipImp = 2 THEN DO:
         DISPLAY STREAM REPORT.
         DOWN(1) STREAM REPORT WITH FRAME F-CAB4.
         PUT STREAM REPORT {&PRN2} + {&PRN6A} + T-MOVTO +  {&PRN6B} + {&PRN3} AT 3 FORMAT "X(35)".  
        END.
     END.     
            
              
     IF CcbDCaja.CodMon = 1 THEN DO:
        x-mon       = 'S/.'.
        G-EFESOL    = G-EFESOL + CcbDCaja.Imptot.
     END.   
     IF CcbDCaja.CodMon = 2 THEN DO:
        x-mon       = 'US$.'.
        G-EFEDOL    = G-EFEDOL + CcbDCaja.Imptot.
     END.   
     X-FMAPGO = ' '.        
     FIND CCBCDOCU WHERE CCBCDOCU.CODCIA = CcbcCaja.Codcia AND 
                         CCBCDOCU.CODDOC = CcbDCaja.CodRef AND
                         CCBCDOCU.NRODOC = ccbDCaja.NroRef NO-LOCK USE-INDEX LLAVE01.
     IF AVAILABLE CCBCDOCU THEN DO:
      X-FMAPGO = CCBCDOCU.FMAPGO. 
      X-FECHA  = CCBCDOCU.FCHDOC.
     END.
     ELSE X-FMAPGO = 'S/N'.
             
     IF CcbCcaja.Flgest <> "A"  THEN DO:
             
        T-EFESOL = T-EFESOL + ( CcbcCaja.ImpNac[1] - CcbCCaja.VueNac ).
        T-EFEDOL = T-EFEDOL + ( CcbcCaja.ImpUsa[1] - CcbCCaja.VueUsa ).
        T-CHDSOL = T-CHDSOL + CcbcCaja.ImpNac[2].
        T-CHDDOL = T-CHDDOL + CcbcCaja.ImpUsa[2].
        T-CHFSOL = T-CHFSOL + CcbcCaja.ImpNac[3].
        T-CHFDOL = T-CHFDOL + CcbcCaja.ImpUsa[3].
        T-NCRSOL = T-NCRSOL + CcbcCaja.ImpNac[6].
        T-NCRDOL = T-NCRDOL + CcbcCaja.ImpUsa[6].
        T-DEPSOL = T-DEPSOL + CcbcCaja.ImpNac[5].
        T-DEPDOL = T-DEPDOL + CcbcCaja.ImpUsa[5].
  
        IF R-S-TipImp = 1 AND T-MOVTO = 'RECIBOS' THEN DO: 
          DISPLAY STREAM REPORT
          CcbcCaja.Coddoc WHEN FIRST-OF(CcbdCaja.NroDoc)
          CcbcCaja.Nrodoc WHEN FIRST-OF(CcbdCaja.NroDoc)
          CcbcCaja.Tipo   WHEN FIRST-OF(CcbdCaja.NroDoc)
          CcbcCaja.Fchdoc WHEN FIRST-OF(CcbdCaja.NroDoc)
          CcbcCaja.Codcli WHEN FIRST-OF(CcbdCaja.NroDoc)
          CcbcCaja.Nomcli WHEN FIRST-OF(CcbdCaja.NroDoc)
          CCbdCaja.Codref
          CcbdCaja.Nroref
          x-fecha @ CcbdCaja.Fchdoc
          x-fmapgo
          x-mon
          CcbdCaja.Imptot
          WITH FRAME f-cab8.
        END.  
          
       END.
    

                 
     IF LAST-OF(CcbcCaja.Tipo) THEN DO:
       IF  R-S-TipImp = 2  THEN DO:
/*        G-EFESOL =  T-EFESOL + T-CHDSOL + T-CHFSOL + T-NCRSOL + T-DEPSOL.
 *         G-EFEDOL =  T-EFEDOL + T-CHDDOL + T-CHFDOL + T-NCRDOL + T-DEPDOL.*/
        DISPLAY STREAM REPORT.
        PUT STREAM REPORT G-EFESOL AT 80 G-EFEDOL AT 110.
       END.   
       IF  R-S-TipImp = 1 AND T-MOVTO = 'RECIBOS'  THEN DO:
        /*G-EFESOL =  T-EFESOL + T-CHDSOL + T-CHFSOL + T-NCRSOL + T-DEPSOL.
 *         G-EFEDOL =  T-EFEDOL + T-CHDDOL + T-CHFDOL + T-NCRDOL + T-DEPDOL.*/
        DISPLAY STREAM REPORT.
        PUT STREAM REPORT 
        {&PRN2} + {&PRN6A} + 'SUBTOTALES   :'  AT 20 FORMAT "X(20)" " S/." AT 50 G-EFESOL AT 55  {&PRN3} + {&PRN6B} SKIP.
        PUT STREAM REPORT   
        {&PRN2} + {&PRN6A} + '              '  AT 20 FORMAT "X(20)" "US$." AT 50 G-EFEDOL AT 55  {&PRN3} + {&PRN6B} SKIP(10).
       
       END.
     END.
                
 END. 
 
RUN CHEQUES. 

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

