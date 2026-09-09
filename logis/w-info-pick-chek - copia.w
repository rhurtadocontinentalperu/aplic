&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-report NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE t-report-2 NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE t-VtaCDocu NO-UNDO LIKE VtaCDocu.



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
DEF SHARED VAR s-coddiv AS CHAR.

/*DEF VAR s-coddiv AS CHAR INIT '00000' NO-UNDO.*/

DEF TEMP-TABLE detalle
    FIELD codref LIKE vtacdocu.codref
    FIELD nroref LIKE vtacdocu.nroref
    FIELD dni AS CHAR.

DEF NEW SHARED VAR lh_handle AS HANDLE.

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
&Scoped-define INTERNAL-TABLES t-report t-VtaCDocu DI-RutaC

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 t-report.Campo-C[1] ~
t-report.Campo-F[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH t-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH t-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 t-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 t-report


/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 t-VtaCDocu.CodPed t-VtaCDocu.NroPed ~
DI-RutaC.Observ t-VtaCDocu.Items t-VtaCDocu.Peso t-VtaCDocu.Volumen ~
t-VtaCDocu.Libre_d01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH t-VtaCDocu NO-LOCK, ~
      FIRST DI-RutaC WHERE DI-RutaC.CodCia = t-VtaCDocu.CodCia ~
  AND DI-RutaC.CodDoc = t-VtaCDocu.CodPed ~
  AND DI-RutaC.NroDoc = t-VtaCDocu.NroPed OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH t-VtaCDocu NO-LOCK, ~
      FIRST DI-RutaC WHERE DI-RutaC.CodCia = t-VtaCDocu.CodCia ~
  AND DI-RutaC.CodDoc = t-VtaCDocu.CodPed ~
  AND DI-RutaC.NroDoc = t-VtaCDocu.NroPed OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 t-VtaCDocu DI-RutaC
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 t-VtaCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 DI-RutaC


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-Fecha BUTTON-1 BUTTON-2 BROWSE-1 ~
BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Fecha 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-info-pick-check AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-info-pick-pick AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tab95 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "PROCESAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "PROCESAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-Fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      t-report SCROLLING.

DEFINE QUERY BROWSE-2 FOR 
      t-VtaCDocu, 
      DI-RutaC SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      t-report.Campo-C[1] COLUMN-LABEL "Rubro" FORMAT "X(30)":U
      t-report.Campo-F[1] COLUMN-LABEL "Datos" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 24.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 50 BY 9.69
         FONT 4
         TITLE "PRODUCCION DIARIA" ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      t-VtaCDocu.CodPed COLUMN-LABEL "CodOri" FORMAT "x(3)":U
      t-VtaCDocu.NroPed COLUMN-LABEL "NroOri" FORMAT "X(12)":U
      DI-RutaC.Observ COLUMN-LABEL "Observaciones" FORMAT "x(60)":U
      t-VtaCDocu.Items FORMAT ">>>,>>9":U
      t-VtaCDocu.Peso FORMAT "->>>,>>9.99":U
      t-VtaCDocu.Volumen FORMAT "->>>,>>9.99":U
      t-VtaCDocu.Libre_d01 COLUMN-LABEL "Pedidos" FORMAT "->>>,>>>,>>9":U
            WIDTH 10.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 95 BY 9.69
         FONT 4
         TITLE "RUTAS PENDIENTES" ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Fecha AT ROW 1.54 COL 15 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 1.54 COL 36 WIDGET-ID 4
     BUTTON-2 AT ROW 1.54 COL 132 WIDGET-ID 6
     BROWSE-1 AT ROW 2.88 COL 3 WIDGET-ID 200
     BROWSE-2 AT ROW 2.88 COL 55 WIDGET-ID 300
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 153 BY 25.46
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 2
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-report T "?" NO-UNDO INTEGRAL w-report
      TABLE: t-report-2 T "?" NO-UNDO INTEGRAL w-report
      TABLE: t-VtaCDocu T "?" NO-UNDO INTEGRAL VtaCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ANALISIS"
         HEIGHT             = 25.46
         WIDTH              = 153
         MAX-HEIGHT         = 25.46
         MAX-WIDTH          = 172.29
         VIRTUAL-HEIGHT     = 25.46
         VIRTUAL-WIDTH      = 172.29
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
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-1 BUTTON-2 F-Main */
/* BROWSE-TAB BROWSE-2 BROWSE-1 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.t-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.t-report.Campo-C[1]
"t-report.Campo-C[1]" "Rubro" "X(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-report.Campo-F[1]
"t-report.Campo-F[1]" "Datos" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "24.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.t-VtaCDocu,INTEGRAL.DI-RutaC WHERE Temp-Tables.t-VtaCDocu ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER"
     _JoinCode[2]      = "INTEGRAL.DI-RutaC.CodCia = Temp-Tables.t-VtaCDocu.CodCia
  AND INTEGRAL.DI-RutaC.CodDoc = Temp-Tables.t-VtaCDocu.CodPed
  AND INTEGRAL.DI-RutaC.NroDoc = Temp-Tables.t-VtaCDocu.NroPed"
     _FldNameList[1]   > Temp-Tables.t-VtaCDocu.CodPed
"t-VtaCDocu.CodPed" "CodOri" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-VtaCDocu.NroPed
"t-VtaCDocu.NroPed" "NroOri" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.DI-RutaC.Observ
"DI-RutaC.Observ" "Observaciones" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.t-VtaCDocu.Items
     _FldNameList[5]   = Temp-Tables.t-VtaCDocu.Peso
     _FldNameList[6]   = Temp-Tables.t-VtaCDocu.Volumen
     _FldNameList[7]   > Temp-Tables.t-VtaCDocu.Libre_d01
"t-VtaCDocu.Libre_d01" "Pedidos" "->>>,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ANALISIS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ANALISIS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* PROCESAR */
DO:
  ASSIGN FILL-IN-Fecha.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN First-Process.
  SESSION:SET-WAIT-STATE('').

  {&OPEN-QUERY-{&BROWSE-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* PROCESAR */
DO:
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Second-Process.
    SESSION:SET-WAIT-STATE('').

    {&OPEN-QUERY-BROWSE-2}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-free/objects/tab95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'LABEL-FONT = 4,
                     LABEL-FGCOLOR = 0,
                     FOLDER-BGCOLOR = 8,
                     FOLDER-PARENT-BGCOLOR = 8,
                     LABELS = Picadores|Chequeadores':U ,
             OUTPUT h_tab95 ).
       RUN set-position IN h_tab95 ( 12.85 , 3.00 ) NO-ERROR.
       RUN set-size IN h_tab95 ( 12.92 , 147.00 ) NO-ERROR.

       /* Links to SmartTab95 h_tab95. */
       RUN add-link IN adm-broker-hdl ( h_tab95 , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_tab95 ,
             BROWSE-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-info-pick-pick.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-info-pick-pick ).
       RUN set-position IN h_b-info-pick-pick ( 13.92 , 5.00 ) NO-ERROR.
       RUN set-size IN h_b-info-pick-pick ( 11.04 , 120.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-info-pick-pick ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-info-pick-check.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-info-pick-check ).
       RUN set-position IN h_b-info-pick-check ( 14.19 , 5.00 ) NO-ERROR.
       RUN set-size IN h_b-info-pick-check ( 11.04 , 120.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-info-pick-check ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Fecha W-Win 
PROCEDURE Captura-Fecha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pFecha AS DATE NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN FILL-IN-Fecha.

    pFecha = FILL-IN-Fecha.
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
  DISPLAY FILL-IN-Fecha 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-Fecha BUTTON-1 BUTTON-2 BROWSE-1 BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE First-Process W-Win 
PROCEDURE First-Process :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE t-report.
  /* Items chequeados */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Items Chequeados'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      /*AND VtaCDocu.FchPed >= FILL-IN-Fecha:*/
      IF VtaCDocu.Libre_c04 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c04,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c04,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Items.
      END.
  END.
  /* Items picados */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Items Picados'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      /*AND VtaCDocu.FchPed >= FILL-IN-Fecha:*/
      IF VtaCDocu.Libre_c03 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Items.
      END.
  END.

  /* Peso chequeado */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Peso Chequeado'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      /*AND VtaCDocu.FchPed >= FILL-IN-Fecha:*/
      IF VtaCDocu.Libre_c04 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c04,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c04,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Peso.
      END.
  END.
  /* Peso picado */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Peso Picado'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      /*AND VtaCDocu.FchPed >= FILL-IN-Fecha:*/
      IF VtaCDocu.Libre_c03 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Peso.
      END.
  END.

  /* Volumen chequeado */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Volumen Chequeado'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      /*AND VtaCDocu.FchPed >= FILL-IN-Fecha:*/
      IF VtaCDocu.Libre_c04 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c04,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c04,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Volumen.
      END.
  END.
  /* Volumen picado */
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Volumen Picado'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      /*AND VtaCDocu.FchPed >= FILL-IN-Fecha:*/
      IF VtaCDocu.Libre_c04 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha
          THEN DO:
          t-report.Campo-F[1] = t-report.Campo-F[1] + VtaCDocu.Volumen.
      END.
  END.

  /* Pedidos chequeados */
  EMPTY TEMP-TABLE detalle.
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Pedidos Chequeados'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      /*AND VtaCDocu.FchPed >= FILL-IN-Fecha:*/
      IF VtaCDocu.Libre_c04 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c04,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c04,'|')) = FILL-IN-Fecha
          THEN DO:
          FIND FIRST detalle WHERE detalle.codref = vtacdocu.codref
              AND detalle.nroref = vtacdocu.nroref
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE detalle THEN DO:
              CREATE detalle.
              ASSIGN
                  detalle.codref = vtacdocu.codref
                  detalle.nroref = vtacdocu.nroref.
          END.
      END.
  END.
  FOR EACH detalle:
      ASSIGN
          t-report.Campo-F[1] = t-report.Campo-F[1] + 1.
  END.
  /* Pedidos picados */
  EMPTY TEMP-TABLE detalle.
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Pedidos Picados'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst = 'P':
      /*AND VtaCDocu.FchPed >= FILL-IN-Fecha:*/
      IF VtaCDocu.Libre_c03 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha
          THEN DO:
          FIND FIRST detalle WHERE detalle.codref = vtacdocu.codref
              AND detalle.nroref = vtacdocu.nroref
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE detalle THEN DO:
              CREATE detalle.
              ASSIGN
                  detalle.codref = vtacdocu.codref
                  detalle.nroref = vtacdocu.nroref.
          END.
      END.
  END.
  FOR EACH detalle:
      ASSIGN
          t-report.Campo-F[1] = t-report.Campo-F[1] + 1.
  END.

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
  FILL-IN-Fecha = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Second-Process W-Win 
PROCEDURE Second-Process :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  EMPTY TEMP-TABLE t-vtacdocu.

  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND Vtacdocu.FlgEst = 'P'
      AND LOOKUP(Vtacdocu.FlgSit, 'PC,C') = 0:
      FIND t-vtacdocu WHERE t-vtacdocu.codcia = s-codcia 
          AND t-vtacdocu.coddiv = s-coddiv
          AND t-vtacdocu.codped = Vtacdocu.codori
          AND t-vtacdocu.nroped = Vtacdocu.nroori
          NO-ERROR.
      IF NOT AVAILABLE t-vtacdocu THEN DO:
          CREATE t-vtacdocu.
          ASSIGN
              t-vtacdocu.codcia = s-codcia 
              t-vtacdocu.coddiv = s-coddiv
              t-vtacdocu.codped = Vtacdocu.codori
              t-vtacdocu.nroped = Vtacdocu.nroori.
      END.
      t-vtacdocu.items = t-vtacdocu.items + Vtacdocu.Items.
      t-vtacdocu.peso = t-vtacdocu.peso + Vtacdocu.Peso.
      t-vtacdocu.volumen = t-vtacdocu.volumen + Vtacdocu.Volumen.
  END.
  FOR EACH t-vtacdocu EXCLUSIVE,
      EACH vtacdocu NO-LOCK WHERE vtacdocu.codcia = t-vtacdocu.codcia
      AND vtacdocu.codori = t-vtacdocu.codped
      AND vtacdocu.nroori = t-vtacdocu.nroped
      AND Vtacdocu.FlgEst = 'P'
      AND LOOKUP(Vtacdocu.FlgSit, 'PC,C') = 0
      BREAK BY vtacdocu.codref BY vtacdocu.nroref:
      IF FIRST-OF(vtacdocu.codref) OR FIRST-OF(vtacdocu.nroref) 
          THEN t-vtacdocu.libre_d01 = t-vtacdocu.libre_d01 + 1.
  END.

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
  {src/adm/template/snd-list.i "t-VtaCDocu"}
  {src/adm/template/snd-list.i "DI-RutaC"}
  {src/adm/template/snd-list.i "t-report"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Third-Process W-Win 
PROCEDURE Third-Process :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE t-report-2.
  EMPTY TEMP-TABLE detalle.

  /* Cargamos Picadores */
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst <> 'A'
      AND VtaCDocu.FchPed >= FILL-IN-Fecha:
      IF VtaCDocu.Libre_c03 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 3
          AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha
          THEN DO:
          FIND t-report-2 WHERE t-report-2.campo-c[1] = ENTRY(3,VtaCDocu.Libre_c03,'|')
              EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE t-report-2 THEN DO:
              CREATE t-report-2.
              ASSIGN 
                  t-report-2.campo-c[1] = ENTRY(3,VtaCDocu.Libre_c03,'|').
          END.
          ASSIGN
              t-report-2.Campo-F[1] = t-report-2.Campo-F[1] + VtaCDocu.Items
              t-report-2.Campo-F[2] = t-report-2.Campo-F[2] + VtaCDocu.Peso
              t-report-2.Campo-F[3] = t-report-2.Campo-F[1] + VtaCDocu.Volumen
              .
          FIND FIRST detalle WHERE detalle.dni = t-report-2.campo-c[1]
              AND detalle.codref = vtacdocu.codref
              AND detalle.nroref = vtacdocu.nroref
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE detalle THEN DO:
              CREATE detalle.
              ASSIGN
                  detalle.dni = t-report-2.campo-c[1]
                  detalle.codref = vtacdocu.codref
                  detalle.nroref = vtacdocu.nroref.
          END.
      END.
  END.
  /* Buscamos su nombre */
  DEF VAR pNombre AS CHAR NO-UNDO.
  DEF VAR pOrigen AS CHAR NO-UNDO.

  FOR EACH t-report-2:
      RUN logis/p-busca-por-dni ( INPUT t-report-2.campo-c[1],
                                  OUTPUT pNombre,
                                  OUTPUT pOrigen).
      IF pOrigen <> 'ERROR' THEN t-report-2.campo-c[2] = pNombre.
      FOR EACH detalle NO-LOCK WHERE detalle.dni = t-report-2.campo-c[1]:
           t-report-2.Campo-F[4] =  t-report-2.Campo-F[4] + 1.
      END.
  END.

/*   
  /* Pedidos picados */
  EMPTY TEMP-TABLE detalle.
  CREATE t-report.
  ASSIGN 
      Campo-C[1] = 'Pedidos Picados'.
  FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.CodDiv = s-coddiv
      AND VtaCDocu.CodPed = 'HPK'
      AND VtaCDocu.FlgEst <> 'A'
      AND VtaCDocu.FchPed >= FILL-IN-Fecha:
      IF VtaCDocu.Libre_c03 > '' 
          AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 2
          AND DATE(ENTRY(2,VtaCDocu.Libre_c03,'|')) = FILL-IN-Fecha
          THEN DO:
          FIND FIRST detalle WHERE detalle.codref = vtacdocu.codref
              AND detalle.nroref = vtacdocu.nroref
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE detalle THEN DO:
              CREATE detalle.
              ASSIGN
                  detalle.codref = vtacdocu.codref
                  detalle.nroref = vtacdocu.nroref.
          END.
      END.
  END.
  FOR EACH detalle:
      ASSIGN
          t-report.Campo-F[1] = t-report.Campo-F[1] + 1.
  END.

*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

