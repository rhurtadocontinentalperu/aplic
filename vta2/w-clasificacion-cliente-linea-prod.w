&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE tt-w-report-lineas NO-UNDO LIKE w-report.



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

DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR x-tabla AS CHAR.

DEFINE NEW SHARED VAR input-var-1 AS CHAR.
DEFINE NEW SHARED VAR input-var-2 AS CHAR.
DEFINE NEW SHARED VAR input-var-3 AS CHAR.
DEFINE NEW SHARED VAR output-var-1 AS ROWID.

DEFINE VAR x-codclie AS CHAR.

x-tabla = 'CLSF_CLIE_X_LINEA'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-w-report ClfClie

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] tt-w-report.Campo-C[4] ~
tt-w-report.Campo-C[5] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 tt-w-report


/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 ClfClie.Categoria ClfClie.DesCat 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH ClfClie NO-LOCK ~
    BY ClfClie.Categoria INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH ClfClie NO-LOCK ~
    BY ClfClie.Categoria INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 ClfClie
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 ClfClie


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-4}~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BROWSE-4 BROWSE-5 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-clasificacion-cliente-linea AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 1" 
     SIZE 4 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      tt-w-report SCROLLING.

DEFINE QUERY BROWSE-5 FOR 
      ClfClie SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "Codigo" FORMAT "x(11)":U
            WIDTH 11.72
      tt-w-report.Campo-C[2] COLUMN-LABEL "R.U.C." FORMAT "X(11)":U
            WIDTH 12.43
      tt-w-report.Campo-C[3] COLUMN-LABEL "Razon Social" FORMAT "x(80)":U
            WIDTH 53.43
      tt-w-report.Campo-C[4] COLUMN-LABEL "Clsf!Propios" FORMAT "X(3)":U
      tt-w-report.Campo-C[5] COLUMN-LABEL "Clsf!Terceros" FORMAT "X(3)":U
            WIDTH 6.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 96.29 BY 11.15
         FONT 4
         TITLE "Clientes con Clasificacion" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      ClfClie.Categoria COLUMN-LABEL "Clasificacion" FORMAT "X(8)":U
            WIDTH 7 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      ClfClie.DesCat FORMAT "X(20)":U WIDTH 19.14 COLUMN-BGCOLOR 14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 30 BY 8.62
         FONT 4
         TITLE "CLASIFICACIONES" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.15 COL 22 WIDGET-ID 4
     BROWSE-4 AT ROW 2.35 COL 1.72 WIDGET-ID 200
     BROWSE-5 AT ROW 13.73 COL 59.14 WIDGET-ID 300
     "Agregar nuevo cliente :" VIEW-AS TEXT
          SIZE 19 BY .96 AT ROW 1.19 COL 3 WIDGET-ID 6
          BGCOLOR 15 FGCOLOR 9 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 98.14 BY 23.46
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
      TABLE: tt-w-report-lineas T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CLASIFICACION DE CLIENTES x LINEA DE PRODUCTO"
         HEIGHT             = 23.46
         WIDTH              = 98.14
         MAX-HEIGHT         = 23.46
         MAX-WIDTH          = 126
         VIRTUAL-HEIGHT     = 23.46
         VIRTUAL-WIDTH      = 126
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
/* BROWSE-TAB BROWSE-4 BUTTON-1 F-Main */
/* BROWSE-TAB BROWSE-5 BROWSE-4 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Codigo" "x(11)" "character" ? ? ? ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "R.U.C." "X(11)" "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "Razon Social" "x(80)" "character" ? ? ? ? ? ? no ? no no "53.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Clsf!Propios" "X(3)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[5]
"tt-w-report.Campo-C[5]" "Clsf!Terceros" "X(3)" "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "INTEGRAL.ClfClie"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.ClfClie.Categoria|yes"
     _FldNameList[1]   > INTEGRAL.ClfClie.Categoria
"Categoria" "Clasificacion" ? "character" 14 0 ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.ClfClie.DesCat
"DesCat" ? ? "character" 14 ? ? ? ? ? no ? no no "19.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CLASIFICACION DE CLIENTES x LINEA DE PRODUCTO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CLASIFICACION DE CLIENTES x LINEA DE PRODUCTO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&Scoped-define SELF-NAME BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-4 IN FRAME F-Main /* Clientes con Clasificacion */
DO:
    DEFINE VAR x-cli AS CHAR.
    DEFINE VAR x-nomcli AS CHAR.

    x-cli = "".
    x-nomcli = "".

    IF AVAILABLE tt-w-report THEN x-cli = tt-w-report.campo-c[1].
    IF AVAILABLE tt-w-report THEN x-nomcli = tt-w-report.campo-c[3].

    RUN refrescar IN h_b-clasificacion-cliente-linea(INPUT x-cli, INPUT x-nomcli).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON VALUE-CHANGED OF BROWSE-4 IN FRAME F-Main /* Clientes con Clasificacion */
DO:
    DEFINE VAR x-cli AS CHAR.
    DEFINE VAR x-nomcli AS CHAR.

    x-cli = "".
    x-nomcli = "".

    IF AVAILABLE tt-w-report THEN x-cli = tt-w-report.campo-c[1].
    IF AVAILABLE tt-w-report THEN x-nomcli = tt-w-report.campo-c[3].

    RUN refrescar IN h_b-clasificacion-cliente-linea(INPUT x-cli, INPUT x-nomcli).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  /*RUN dispatch IN THIS-PROCEDURE ('qbusca':U).*/
  RUN buscar.
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/b-clasificacion-cliente-linea-prod.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-clasificacion-cliente-linea ).
       RUN set-position IN h_b-clasificacion-cliente-linea ( 13.62 , 1.72 ) NO-ERROR.
       RUN set-size IN h_b-clasificacion-cliente-linea ( 8.85 , 57.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv10.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10 ).
       RUN set-position IN h_p-updv10 ( 22.62 , 11.00 ) NO-ERROR.
       RUN set-size IN h_p-updv10 ( 1.42 , 41.72 ) NO-ERROR.

       /* Links to SmartBrowser h_b-clasificacion-cliente-linea. */
       RUN add-link IN adm-broker-hdl ( h_p-updv10 , 'TableIO':U , h_b-clasificacion-cliente-linea ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-clasificacion-cliente-linea ,
             BROWSE-4:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10 ,
             BROWSE-5:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscar W-Win 
PROCEDURE buscar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'qbusca':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
      RUN lkup/c-client ("Clientes").
      IF OUTPUT-VAR-1 <> ? THEN DO:
          FIND FIRST gn-clie WHERE ROWID(gn-clie) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
          IF AVAILABLE gn-clie THEN DO:
              FIND FIRST tt-w-report WHERE tt-w-report.campo-c[1] = gn-clie.codcli EXCLUSIVE-LOCK NO-ERROR.
              IF NOT AVAILABLE tt-w-report THEN DO:
                  CREATE tt-w-report.
                    ASSIGN tt-w-report.campo-c[1] = gn-clie.codcli
                            tt-w-report.campo-c[2] = gn-clie.ruc
                            tt-w-report.campo-c[3] = gn-clie.nomcli
                            tt-w-report.campo-c[4] = gn-clie.clfcli
                            tt-w-report.campo-c[5] = gn-clie.clfcli2
                        .
                    {&open-query-browse-4}
              END.
              ELSE DO:
                  MESSAGE "Cliente " + gn-clie.nomcli SKIP
                        "Ya existe"
                      VIEW-AS ALERT-BOX INFORMATION.
              END.

          END.
      END.

      /*
      IF OUTPUT-VAR-1 <> ? THEN DO:
           FIND {&FIRST-TABLE-IN-QUERY-BROWSE-2} WHERE
                ROWID({&FIRST-TABLE-IN-QUERY-BROWSE-2}) = OUTPUT-VAR-1
                NO-LOCK NO-ERROR.
           IF AVAIL {&FIRST-TABLE-IN-QUERY-BROWSE-2} THEN DO:
               /*
               FILL-IN-CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                   {&FIRST-TABLE-IN-QUERY-BROWSE-2}.codcli.
               FILL-IN_NomCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                   {&FIRST-TABLE-IN-QUERY-BROWSE-2}.nomcli.
               */
               REPOSITION {&FIRST-TABLE-IN-QUERY-BROWSE-2}  TO ROWID OUTPUT-VAR-1 NO-ERROR.
               IF NOT ERROR-STATUS:ERROR THEN RUN dispatch IN THIS-PROCEDURE ('get-next':U).
           END.
      END.
      */
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-clientes W-Win 
PROCEDURE carga-clientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-cli AS CHAR.
DEFINE VAR x-nomcli AS CHAR.

EMPTY TEMP-TABLE tt-w-report.    
    
FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND
                            vtatabla.tabla = x-tabla NO-LOCK:
    FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
                            gn-clie.codcli = llave_c1 NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:
        FIND FIRST tt-w-report WHERE tt-w-report.campo-c[1] = gn-clie.codcli EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE tt-w-report THEN DO:
            CREATE tt-w-report.
            ASSIGN tt-w-report.campo-c[1] = gn-clie.codcli
                    tt-w-report.campo-c[2] = gn-clie.ruc
                    tt-w-report.campo-c[3] = gn-clie.nomcli
                    tt-w-report.campo-c[4] = gn-clie.clfcli
                    tt-w-report.campo-c[5] = gn-clie.clfcli2
                    .
        END.
    END.

END.

{&open-query-browse-4}

x-cli = "".
FIND FIRST tt-w-report NO-LOCK NO-ERROR.

IF AVAILABLE tt-w-report THEN x-cli = tt-w-report.campo-c[1].
IF AVAILABLE tt-w-report THEN x-nomcli = tt-w-report.campo-c[3].

RUN refrescar IN h_b-clasificacion-cliente-linea(INPUT x-cli, INPUT x-nomcli).

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
  ENABLE BUTTON-1 BROWSE-4 BROWSE-5 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */    
  RUN carga-clientes.
  {&open-query-browse-4}

    

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
  {src/adm/template/snd-list.i "ClfClie"}
  {src/adm/template/snd-list.i "tt-w-report"}

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

