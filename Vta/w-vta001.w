&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.

DEF VAR l-immediate-display AS LOGICAL.
DEF VAR PTO                 AS LOGICAL.
DEF VAR xTerm     AS CHARACTER INITIAL "".

DEF TEMP-TABLE T-Reporte
    FIELD CodCia LIKE CcbCDocu.CodCia
    FIELD CodCli LIKE CcbCDocu.CodCli
    FIELD NomCli LIKE Gn-Clie.NomCli
    FIELD ImpMes AS DEC EXTENT 12
    FIELD ImpTot AS DEC
    INDEX Llave01 AS PRIMARY CodCli
    INDEX Llave02 CodCia ImpTot DESCENDING.

DEF VAR x-CodDiv   AS CHAR NO-UNDO.

DEF FRAME F-Proceso
    "Procesando Division"
    ccbcdocu.coddiv SKIP
    "Dia" 
    ccbcdocu.fchdoc
    WITH NO-LABELS CENTERED OVERLAY VIEW-AS DIALOG-BOX.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES GN-DIVI

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 GN-DIVI.CodDiv GN-DIVI.DesDiv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH GN-DIVI ~
      WHERE GN-DIVI.CodCia = s-codcia NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH GN-DIVI ~
      WHERE GN-DIVI.CodCia = s-codcia NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 GN-DIVI


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-70 RECT-71 FILL-IN-Periodo BUTTON-6 ~
BROWSE-1 BUTTON-4 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Periodo txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Button 4" 
     SIZE 15 BY 1.5.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 6" 
     SIZE 15 BY 1.5.

DEFINE VARIABLE FILL-IN-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-70
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50.43 BY 8.92.

DEFINE RECTANGLE RECT-71
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18.86 BY 8.92.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      GN-DIVI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      GN-DIVI.CodDiv COLUMN-LABEL "Division" FORMAT "XX-XXX":U
      GN-DIVI.DesDiv FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS MULTIPLE SIZE 38 BY 5.38
         FONT 4
         TITLE "DIVISIONES".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Periodo AT ROW 1.54 COL 21 COLON-ALIGNED WIDGET-ID 118
     BUTTON-6 AT ROW 2.62 COL 54 WIDGET-ID 98
     BROWSE-1 AT ROW 2.69 COL 7 WIDGET-ID 200
     BUTTON-4 AT ROW 4.23 COL 54 WIDGET-ID 26
     txt-msj AT ROW 9.08 COL 2 NO-LABEL WIDGET-ID 30
     "Marque la(s) división(es) a imprimir" VIEW-AS TEXT
          SIZE 24 BY .5 AT ROW 8.08 COL 7 WIDGET-ID 120
          BGCOLOR 1 FGCOLOR 15 
     RECT-70 AT ROW 1.23 COL 1.57 WIDGET-ID 20
     RECT-71 AT ROW 1.23 COL 52.14 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.14 BY 9.46
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
         TITLE              = "Ventas por Cliente Mensual"
         HEIGHT             = 9.46
         WIDTH              = 71.14
         MAX-HEIGHT         = 9.46
         MAX-WIDTH          = 71.14
         VIRTUAL-HEIGHT     = 9.46
         VIRTUAL-WIDTH      = 71.14
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
/* BROWSE-TAB BROWSE-1 BUTTON-6 F-Main */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "INTEGRAL.GN-DIVI"
     _Where[1]         = "INTEGRAL.GN-DIVI.CodCia = s-codcia"
     _FldNameList[1]   > INTEGRAL.GN-DIVI.CodDiv
"GN-DIVI.CodDiv" "Division" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.GN-DIVI.DesDiv
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Ventas por Cliente Mensual */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ventas por Cliente Mensual */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
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


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
    ASSIGN
      FILL-IN-Periodo.
    /* consistencia */
    IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0
    THEN DO:
      MESSAGE 'Debe seleccionar al menos una division'
          VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
    END.

    DISPLAY "Cargando Información..." @ txt-msj WITH FRAME {&FRAME-NAME}.
    RUN Imprimir.
    DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
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
  DEF VAR x-FchDoc-1 AS DATE NO-UNDO.
  DEF VAR x-FchDoc-2 AS DATE NO-UNDO.
  DEF VAR x-ImpTot   AS DEC  NO-UNDO.
  DEF VAR x-Mes      AS INT  NO-UNDO.
  DEF VAR i          AS INT  NO-UNDO.
  
  ASSIGN
    x-FchDoc-1 = DATE(01,01,FILL-IN-Periodo)
    x-FchDoc-2 = DATE(12,31,FILL-IN-Periodo).
    
  x-CodDiv = ''.
  DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) IN FRAME {&FRAME-NAME}
    THEN DO:
        IF i = 1
        THEN x-CodDiv = TRIM(gn-divi.coddiv).
        ELSE x-CodDiv = x-CodDiv + ',' + TRIM(gn-divi.coddiv).
    END.
  END.
  
  FOR EACH T-Reporte:
    DELETE T-Reporte.
  END.
  
  FOR EACH CcbCDocu WHERE ccbcdocu.CodCia = s-codcia
        AND LOOKUP(TRIM(coddoc), 'FAC,BOL,N/D') > 0
        AND flgest <> 'A'
        AND fchdoc >= x-FchDoc-1
        AND fchdoc <= x-FchDoc-2
        AND LOOKUP(TRIM(ccbcdocu.coddiv), x-CodDiv) > 0
        NO-LOCK:
    /*RD01****
    DISPLAY ccbcdocu.coddiv ccbcdocu.fchdoc WITH FRAME F-Proceso.
    */
    /*RD01*/ 
    DISPLAY "Division: " + ccbcdocu.coddiv + "- Dia: " + STRING(ccbcdocu.fchdoc) @ txt-msj
        WITH FRAME {&FRAME-NAME}.

    x-Mes = MONTH(ccbcdocu.fchdoc).
    /* todo a Soles */
    IF ccbcdocu.codmon = 1
    THEN x-ImpTot = ccbcdocu.imptot.
    ELSE x-ImpTot = ccbcdocu.imptot * ccbcdocu.tpocmb.

    FIND T-Reporte WHERE T-Reporte.codcli = ccbcdocu.codcli
        NO-ERROR.
    IF NOT AVAILABLE T-Reporte
    THEN CREATE T-Reporte.
    ASSIGN
        T-Reporte.codcia = ccbcdocu.codcia
        T-Reporte.codcli = ccbcdocu.codcli
        T-Reporte.ImpMes[x-Mes] = T-Reporte.ImpMes[x-Mes] + x-ImpTot
        T-Reporte.ImpTot = T-Reporte.ImpTot + x-ImpTot.
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = ccbcdocu.codcli 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie
    THEN T-Reporte.nomcli = gn-clie.nomcli.
    ELSE T-Reporte.nomcli = ccbcdocu.nomcli.
  END.
  

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
  DISPLAY FILL-IN-Periodo txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-70 RECT-71 FILL-IN-Periodo BUTTON-6 BROWSE-1 BUTTON-4 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE FRAME F-CAB-1
    t-reporte.codcli     FORMAT 'x(11)'
    t-reporte.nomcli FORMAT 'x(30)'
    t-reporte.impmes[1]  FORMAT '->>>,>>>,>>9.99' 
    t-reporte.impmes[2]  FORMAT '->>>,>>>,>>9.99' 
    t-reporte.impmes[3]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[4]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[5]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[6]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[7]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[8]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[9]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[10] FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[11] FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[12] FORMAT '->>>,>>>,>>9.99'
    t-reporte.imptot     FORMAT '->>>,>>>,>>9.99' SKIP    
    HEADER
        {&PRN4} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
        {&PRN6A} + 'VENTAS POR CLIENTE MENSUAL' + {&PRN6B} + {&PRN4} FORMAT 'x(30)' AT 43
        "Pag.  : " AT 120 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN6A} + 'PERIODO ' + STRING(FILL-IN-Periodo, '9999') + {&PRN6B} + {&PRN4}  FORMAT 'x(30)' AT 43
        "Fecha : " AT 120 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "DIVISON(NES): " x-CodDiv FORMAT 'x(80)' SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"SKIP
        "CODIGO      NOMBRE O RAZON SOCIAL                   ENERO         FEBRERO           MARZO           ABRIL            MAYO          JUNIO           JULIO          AGOSTO        SETIEMBRE         OCTUBRE        NOVIEMBRE      DICIEMBRE         TOTAL   " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"SKIP
/*      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         12345678901 123456789012345678901234567890 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99
*/

  WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  DEFINE FRAME F-CAB-2
    t-reporte.impmes[7]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[8]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[9]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[10] FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[11] FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[12] FORMAT '->>>,>>>,>>9.99'
    t-reporte.imptot     FORMAT '->>>,>>>,>>9.99' SKIP
    HEADER
        {&PRN4} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
        {&PRN6A} + 'VENTAS POR CLIENTE MENSUAL' + {&PRN6B} + {&PRN4} FORMAT 'x(30)' AT 43
        "Pag.  : " AT 120 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN6A} + 'PERIODO ' + STRING(FILL-IN-Periodo, '9999') + {&PRN6B} + {&PRN4}  FORMAT 'x(30)' AT 43
        "Fecha : " AT 120 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "DIVISON(NES): " x-CodDiv FORMAT 'x(80)' SKIP
        "---------------------------------------------------------------------------------------------------------------" SKIP
        "         JULIO          AGOSTO       SETIEMBRE         OCTUBRE       NOVIEMBRE      DICIEMBRE            TOTAL " SKIP
        "---------------------------------------------------------------------------------------------------------------" SKIP
/*      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 
*/

  WITH WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
/**RD01- Revisar
  FOR EACH T-Reporte BREAK BY T-Reporte.CodCia BY T-Reporte.ImpTot DESCENDING ON ERROR UNDO, LEAVE:
    /*{&new-page}.*/
    IF ERROR-STATUS:ERROR = YES THEN LEAVE.
    DISPLAY STREAM REPORT
        t-reporte.impmes[7] 
        t-reporte.impmes[8] 
        t-reporte.impmes[9] 
        t-reporte.impmes[10] 
        t-reporte.impmes[11] 
        t-reporte.impmes[12] 
        t-reporte.imptot 
        WITH FRAME F-CAB-2.
  END.  
  */
  
  FOR EACH T-Reporte BREAK BY T-Reporte.CodCia BY T-Reporte.ImpTot DESCENDING ON ERROR UNDO, LEAVE:
    /*{&new-page}.*/
    IF ERROR-STATUS:ERROR = YES THEN LEAVE.
    DISPLAY STREAM REPORT
        t-reporte.codcli
        t-reporte.nomcli
        t-reporte.impmes[1] 
        t-reporte.impmes[2] 
        t-reporte.impmes[3] 
        t-reporte.impmes[4] 
        t-reporte.impmes[5] 
        t-reporte.impmes[6]
        t-reporte.impmes[7] 
        t-reporte.impmes[8] 
        t-reporte.impmes[9] 
        t-reporte.impmes[10] 
        t-reporte.impmes[11] 
        t-reporte.impmes[12] 
        t-reporte.imptot         
        WITH FRAME F-CAB-1.
  END.

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

    RUN Carga-Temporal.
    FIND FIRST T-Reporte NO-ERROR.
    IF NOT AVAILABLE T-Reporte THEN DO:
      MESSAGE 'No hay registros a imprimir'
          VIEW-AS ALERT-BOX WARNING.
      RETURN.
    END.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.        
        RUN Formato.
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
      FILL-IN-Periodo = YEAR(TODAY).
  END.



  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "GN-DIVI"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

