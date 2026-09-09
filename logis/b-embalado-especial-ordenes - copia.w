&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE w-report-od NO-UNDO LIKE w-report.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-codcia AS INT.

DEFINE BUFFER x-faccpedi FOR faccpedi.

DEFINE VAR x-vtatabla AS CHAR INIT "CONFIG-VTAS".
DEFINE VAR x-llave_c1 AS CHAR INIT "LOGISTICA".
DEFINE VAR x-llave_c2 AS CHAR INIT "PICKING".
DEFINE VAR x-llave_c3 AS CHAR INIT "METROSXROLLO".

DEFINE VAR x-Directorio AS CHAR.

define stream REPORT-txt.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES w-report-od

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table w-report-od.Campo-D[1] ~
w-report-od.Campo-C[5] w-report-od.Campo-C[1] w-report-od.Campo-C[2] ~
w-report-od.Campo-F[1] w-report-od.Campo-F[2] w-report-od.Campo-C[3] ~
w-report-od.Campo-C[4] w-report-od.Campo-I[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH w-report-od WHERE ~{&KEY-PHRASE} NO-LOCK ~
    BY w-report-od.Campo-D[1] DESCENDING
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH w-report-od WHERE ~{&KEY-PHRASE} NO-LOCK ~
    BY w-report-od.Campo-D[1] DESCENDING.
&Scoped-define TABLES-IN-QUERY-br_table w-report-od
&Scoped-define FIRST-TABLE-IN-QUERY-br_table w-report-od


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-txt FILL-IN-desde FILL-IN-hasta ~
FILL-IN-metros BUTTON-2 br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-divdes FILL-IN-tot-od ~
FILL-IN-desde FILL-IN-hasta FILL-IN-metros FILL-IN-tot-metros ~
FILL-IN-tot-rollos FILL-IN-tot-bultos 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     LABEL "Procesar" 
     SIZE 14 BY .96.

DEFINE BUTTON BUTTON-txt 
     LABEL "Enviar a txt" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-divdes AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9.86 BY .62 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-metros AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Metros x rollo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-tot-bultos AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Total bultos" 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .81
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-tot-metros AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Total metros" 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .81
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-tot-od AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Cant. Ordenes" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-tot-rollos AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Total rollos" 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .81
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      w-report-od SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      w-report-od.Campo-D[1] COLUMN-LABEL "Cierre de!Orden" FORMAT "99/99/9999":U
      w-report-od.Campo-C[5] COLUMN-LABEL "Div!despacho" FORMAT "X(8)":U
            WIDTH 7.14
      w-report-od.Campo-C[1] COLUMN-LABEL "Cod!Orden" FORMAT "X(8)":U
            WIDTH 5.29
      w-report-od.Campo-C[2] COLUMN-LABEL "Nro.!Orden" FORMAT "X(10)":U
            WIDTH 10.29
      w-report-od.Campo-F[1] COLUMN-LABEL "Metraje!Utilizado" FORMAT "->>>,>>>,>>9.99":U
      w-report-od.Campo-F[2] COLUMN-LABEL "Cantidad!Rollos" FORMAT "->>,>>9.99":U
            WIDTH 10
      w-report-od.Campo-C[3] COLUMN-LABEL "Procs" FORMAT "X(5)":U
      w-report-od.Campo-C[4] COLUMN-LABEL "Cliente" FORMAT "X(80)":U
            WIDTH 35.72
      w-report-od.Campo-I[1] COLUMN-LABEL "Bultos" FORMAT "->>>,>>>,>>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 111.57 BY 15.19
         FONT 4 ROW-HEIGHT-CHARS .54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-txt AT ROW 19.27 COL 61 WIDGET-ID 24
     FILL-IN-divdes AT ROW 2.54 COL 26.72 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-tot-od AT ROW 18.92 COL 10.14 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-desde AT ROW 1.23 COL 14.72 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-hasta AT ROW 2.04 COL 14.57 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-metros AT ROW 1.23 COL 38.57 COLON-ALIGNED WIDGET-ID 6
     BUTTON-2 AT ROW 2.35 COL 38.86 WIDGET-ID 8
     br_table AT ROW 3.5 COL 1.43
     FILL-IN-tot-metros AT ROW 18.92 COL 34.43 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-tot-rollos AT ROW 19.73 COL 45 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-tot-bultos AT ROW 18.88 COL 96.29 COLON-ALIGNED WIDGET-ID 26
     "Fecha de" VIEW-AS TEXT
          SIZE 7.29 BY .5 AT ROW 1.31 COL 3.57 WIDGET-ID 10
     "cierre de" VIEW-AS TEXT
          SIZE 7.29 BY .5 AT ROW 1.81 COL 3.57 WIDGET-ID 12
     "Orden" VIEW-AS TEXT
          SIZE 7.29 BY .5 AT ROW 2.35 COL 3.57 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: w-report-od T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 19.81
         WIDTH              = 113.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table BUTTON-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-divdes IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-divdes:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-tot-bultos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-tot-metros IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-tot-od IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-tot-rollos IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.w-report-od"
     _Options          = "NO-LOCK KEY-PHRASE"
     _OrdList          = "Temp-Tables.w-report-od.Campo-D[1]|no"
     _FldNameList[1]   > Temp-Tables.w-report-od.Campo-D[1]
"w-report-od.Campo-D[1]" "Cierre de!Orden" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.w-report-od.Campo-C[5]
"w-report-od.Campo-C[5]" "Div!despacho" ? "character" ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.w-report-od.Campo-C[1]
"w-report-od.Campo-C[1]" "Cod!Orden" ? "character" ? ? ? ? ? ? no ? no no "5.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.w-report-od.Campo-C[2]
"w-report-od.Campo-C[2]" "Nro.!Orden" "X(10)" "character" ? ? ? ? ? ? no ? no no "10.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.w-report-od.Campo-F[1]
"w-report-od.Campo-F[1]" "Metraje!Utilizado" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.w-report-od.Campo-F[2]
"w-report-od.Campo-F[2]" "Cantidad!Rollos" "->>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.w-report-od.Campo-C[3]
"w-report-od.Campo-C[3]" "Procs" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.w-report-od.Campo-C[4]
"w-report-od.Campo-C[4]" "Cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no "35.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.w-report-od.Campo-I[1]
"w-report-od.Campo-I[1]" "Bultos" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 B-table-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Procesar */
DO:
    ASSIGN fill-in-metros fill-in-desde fill-in-hasta.
  IF fill-in-metros <= 0  THEN DO:
      MESSAGE "Metros x rollo debe tener un valor mayor a cero" VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.
  IF fill-in-desde = ? THEN DO:
      MESSAGE "Ingrese la fecha desde" VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.
  IF fill-in-hasta = ? THEN DO:
      MESSAGE "Ingrese la fecha hasta" VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.

  IF fill-in-desde > fill-in-hasta THEN DO:
      MESSAGE "Fecha desde debe ser menor/igual a hasta" VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.


  RUN procesar.

  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                            vtatabla.tabla = x-vtatabla AND
                            vtatabla.llave_c1 = x-llave_c1 AND
                            vtatabla.llave_c2 = x-llave_c2 AND
                            vtatabla.llave_c3 = x-llave_c3 EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE vtatabla THEN DO:
    CREATE vtatabla.
        ASSIGN vtatabla.codcia = s-codcia
                vtatabla.tabla = x-vtatabla
                vtatabla.llave_c1 = x-llave_c1
                vtatabla.llave_c2 = x-llave_c2
                vtatabla.llave_c3 = x-llave_c3.
  END.
  ASSIGN vtatabla.valor[1] = fill-in-metros.
  RELEASE vtatabla NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-txt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-txt B-table-Win
ON CHOOSE OF BUTTON-txt IN FRAME F-Main /* Enviar a txt */
DO:

        x-Directorio = "".

        SYSTEM-DIALOG GET-DIR x-Directorio  
           RETURN-TO-START-DIR 
           TITLE 'Elija el directorio'.
        IF x-Directorio = "" THEN DO:
        RETURN NO-APPLY.
    END.
  
    RUN procesar-txt.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  FILL-IN-desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 5,"99/99/9999").
  FILL-IN-hasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").
  FILL-IN-divdes:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s-coddiv.
  FILL-IN-metros:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.00".

  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                            vtatabla.tabla = x-vtatabla AND
                            vtatabla.llave_c1 = x-llave_c1 AND
                            vtatabla.llave_c2 = x-llave_c2 AND
                            vtatabla.llave_c3 = x-llave_c3 NO-LOCK NO-ERROR.
  IF AVAILABLE vtatabla THEN DO:
        FILL-IN-metros:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(vtatabla.valor[1],">>,>>9.99").
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar B-table-Win 
PROCEDURE procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE w-report-od.

SESSION:SET-WAIT-STATE("GENERAL").

RUN procesar-picking.

{&open-query-br_table}

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-picking B-table-Win 
PROCEDURE procesar-picking :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-cod-ordenes AS CHAR.
DEFINE VAR x-cod-orden AS CHAR.
DEFINE VAR x-sec AS INT.
DEFINE VAR x-metros AS DEC.
DEFINE VAR x-fecha-cierre AS DATE.
DEFINE VAR x-fecha AS DATE.

DEFINE VAR x-total-ordenes AS INT.
DEFINE VAR x-total-metros AS DEC.
DEFINE VAR x-total-rollos AS DEC.
DEFINE VAR x-total-bultos AS DEC.

DEFINE VAR x-coddiv AS CHAR.
DEFINE VAR x-proceso AS CHAR.

x-cod-ordenes = "O/D,O/M".

/* */
REPEAT x-fecha = fill-in-desde TO fill-in-hasta:
    REPEAT x-sec = 1 TO NUM-ENTRIES(x-cod-ordenes,","):
        x-cod-orden = ENTRY(x-sec,x-cod-ordenes,",").

        FOR EACH x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                    x-faccpedi.fchchq = x-fecha AND
                                    x-faccpedi.coddoc = x-cod-orden AND                                    
                                    /*(x-faccpedi.fchchq >= fill-in-desde AND x-faccpedi.fchchq <= fill-in-hasta) AND */
                                    x-faccpedi.empaqespec = YES NO-LOCK:
            x-metros = 0.
            x-fecha-cierre = ?.
            x-proceso = "PXS".
            /* Es Pickign x Ruta */
            FIND FIRST vtacdocu WHERE vtacdocu.codcia = s-codcia AND 
                                        vtacdocu.codref = x-faccpedi.coddoc AND
                                        vtacdocu.nroref = x-faccpedi.nroped AND
                                        vtacdocu.codped = 'HPK' AND
                                        vtacdocu.flgest <> 'A' NO-LOCK NO-ERROR.
            IF AVAILABLE vtacdocu THEN DO:
                FECHACIERRE:
                FOR EACH vtacdocu WHERE vtacdocu.codcia = s-codcia AND 
                                            vtacdocu.codref = x-faccpedi.coddoc AND
                                            vtacdocu.nroref = x-faccpedi.nroped AND
                                            vtacdocu.codped = 'HPK' AND
                                            vtacdocu.flgest <> 'A' NO-LOCK:
                    x-metros = x-metros + VtaCDocu.Importe[3].
                    x-proceso = "PXR".

                    IF Vtacdocu.fecsac = ? THEN DO:
                        x-fecha-cierre = ?.
                        LEAVE FECHACIERRE.
                    END.

                    IF x-fecha-cierre = ? THEN x-fecha-cierre = Vtacdocu.fecsac.
                    IF Vtacdocu.fecsac > x-fecha-cierre THEN x-fecha-cierre = Vtacdocu.fecsac.                    
                END.
            END.
            IF x-proceso = "PXR" THEN DO:
                /* La orden no esta concluido el checking */
                IF x-fecha-cierre = ? THEN NEXT.
            END.
            IF x-proceso = "PXS" THEN DO:
                /* Es picking x sector */
                x-metros = x-faccpedi.acubon[7].
                x-fecha-cierre = x-faccpedi.fchchq.
                IF x-fecha-cierre = ? THEN NEXT.
            END.
            /*  */
            CREATE w-report-od.
                ASSIGN w-report-od.campo-d[1] = x-fecha-cierre
                        w-report-od.campo-c[1] = x-faccpedi.coddoc
                        w-report-od.campo-c[2] = x-faccpedi.nroped
                        w-report-od.campo-f[1] = x-metros
                        w-report-od.campo-f[2] = w-report-od.campo-f[1] / fill-in-metros
                        w-report-od.campo-c[3] = x-proceso
                        w-report-od.campo-c[4] = x-faccpedi.nomcli
                        w-report-od.campo-c[5] = x-faccpedi.divdes
                        w-report-od.campo-i[1] = 0
                    .
                x-total-ordenes = x-total-ordenes + 1.
                x-total-metros = x-total-metros + w-report-od.campo-f[1].
                x-total-rollos = x-total-rollos + w-report-od.campo-f[2].               
            /* Bultos */
            FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND
                                        ccbcbult.coddoc = x-faccpedi.coddoc AND
                                        ccbcbult.nrodoc = x-faccpedi.nroped NO-LOCK NO-ERROR.
            IF AVAILABLE ccbcbult THEN DO:
                ASSIGN w-report-od.campo-i[1] = ccbcbult.bultos.
            END.
            x-total-bultos = x-total-bultos + w-report-od.campo-i[1].
        END.
    END.
END.

/*
/* Picking x Sector */
REPEAT x-sec = 1 TO NUM-ENTRIES(x-cod-ordenes,","):        
        x-cod-orden = ENTRY(x-sec,x-cod-ordenes,",").

    FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:    

        FOR EACH x-faccpedi USE-INDEX llave08 WHERE x-faccpedi.codcia = s-codcia AND
                                    x-faccpedi.divdes = gn-divi.coddiv AND 
                                    x-faccpedi.coddoc = x-cod-orden AND
                                    x-faccpedi.flgest <> 'A' AND 
                                    x-faccpedi.empaqespec = YES AND
                                    (x-faccpedi.libre_f01 >= fill-in-desde AND x-faccpedi.libre_f01 <= fill-in-hasta) NO-LOCK:

            x-fecha-cierre = ?.
            x-metros = 0.

            FIND FIRST w-report-od WHERE w-report-od.campo-c[1] = x-faccpedi.coddoc AND 
                                        w-report-od.campo-c[2] = x-faccpedi.nroped EXCLUSIVE-LOCK NO-ERROR.

            IF AVAILABLE w-report-od AND w-report-od.campo-c[3] = 'PXS'  THEN NEXT.

            IF NOT AVAILABLE w-report-od THEN DO:

                FOR EACH vtacdocu WHERE vtacdocu.codcia = s-codcia AND 
                                            vtacdocu.codref = x-faccpedi.coddoc AND
                                            vtacdocu.nroref = x-faccpedi.nroped AND
                                            vtacdocu.codped = 'HPK' AND
                                            vtacdocu.flgest <> 'A' NO-LOCK:
                    x-metros = x-metros + VtaCDocu.Importe[3].
                    IF x-fecha-cierre = ? THEN x-fecha-cierre = Vtacdocu.fecsac.
                    IF Vtacdocu.fecsac > x-fecha-cierre THEN x-fecha-cierre = Vtacdocu.fecsac.
                END.

                IF x-fecha-cierre = ? THEN NEXT.

                    CREATE w-report-od.
                        ASSIGN w-report-od.campo-d[1] = x-fecha-cierre
                                w-report-od.campo-c[1] = x-faccpedi.coddoc
                                w-report-od.campo-c[2] = x-faccpedi.nroped
                                w-report-od.campo-f[1] = x-metros
                                w-report-od.campo-f[2] = w-report-od.campo-f[1] / fill-in-metros
                                w-report-od.campo-c[3] = "PXR"
                                w-report-od.campo-c[4] = x-faccpedi.nomcli
                                w-report-od.campo-c[5] = x-faccpedi.divdes
                                w-report-od.campo-i[1] = 0
                            .
                        x-total-ordenes = x-total-ordenes + 1.
                        x-total-metros = x-total-metros + w-report-od.campo-f[1].
                        x-total-rollos = x-total-rollos + w-report-od.campo-f[2].
                        /* Bultos */
                        FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND
                                                    ccbcbult.coddoc = x-faccpedi.coddoc AND
                                                    ccbcbult.nrodoc = x-faccpedi.nroped NO-LOCK NO-ERROR.
                        IF AVAILABLE ccbcbult THEN DO:
                            ASSIGN w-report-od.campo-i[1] = ccbcbult.bultos.
                        END.
                        x-total-bultos = x-total-bultos + w-report-od.campo-i[1].
            END.
        END.
   END.
END.
*/


/*
REPEAT x-sec = 1 TO NUM-ENTRIES(x-cod-ordenes,","):
    x-cod-orden = ENTRY(x-sec,x-cod-ordenes,",").
    /* Picking x Ruta */
    FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
        FOR EACH x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                    x-faccpedi.divdes = gn-divi.coddiv AND 
                                    x-faccpedi.coddoc = x-cod-orden AND
                                    x-faccpedi.empaqespec = YES AND
                                    (x-faccpedi.fchchq >= fill-in-desde AND x-faccpedi.fchchq <= fill-in-hasta)  NO-LOCK:

            /* Verificamos si el pedido es EMBALADP ESPECIAL */
            /*
            FIND FIRST faccpedi WHERE faccpedi.codcia = x-faccpedi.codcia AND
                                        faccpedi.coddoc = x-faccpedi.codref AND 
                                        faccpedi.nroped = x-faccpedi.nroref NO-LOCK NO-ERROR.

            IF AVAILABLE faccpedi AND faccpedi.empaqespec = YES THEN DO:
            */
                
                x-metros = 0.
                x-fecha-cierre = ?.
                x-proceso = "PXS".
                /* Es Pickign x Ruta */
                FECHACIERRE:
                FOR EACH vtacdocu WHERE vtacdocu.codcia = s-codcia AND 
                                            vtacdocu.codref = x-faccpedi.coddoc AND
                                            vtacdocu.nroref = x-faccpedi.nroped AND
                                            vtacdocu.codped = 'HPK' AND
                                            vtacdocu.flgest <> 'A' NO-LOCK:
                    x-metros = x-metros + VtaCDocu.Importe[3].
                    x-proceso = "PXR".
                    
                    IF Vtacdocu.fecsac = ? THEN DO:
                        x-fecha-cierre = ?.
                        LEAVE FECHACIERRE.
                    END.
                        
                    IF x-fecha-cierre = ? THEN x-fecha-cierre = Vtacdocu.fecsac.
                    IF Vtacdocu.fecsac > x-fecha-cierre THEN x-fecha-cierre = Vtacdocu.fecsac.                    
                END.
                IF x-proceso = "PXR" THEN DO:
                    IF x-fecha-cierre = ? THEN NEXT.
                END.
                                
                IF x-proceso = "PXS" THEN DO:
                    /* Es picking x sector */
                    x-metros = x-faccpedi.acubon[7].
                    x-fecha-cierre = x-faccpedi.fchchq.
                    IF x-fecha-cierre = ? THEN NEXT.
                END.
                
                CREATE w-report-od.
                    ASSIGN w-report-od.campo-d[1] = x-fecha-cierre
                            w-report-od.campo-c[1] = x-faccpedi.coddoc
                            w-report-od.campo-c[2] = x-faccpedi.nroped
                            w-report-od.campo-f[1] = x-metros
                            w-report-od.campo-f[2] = w-report-od.campo-f[1] / fill-in-metros
                            w-report-od.campo-c[3] = x-proceso
                            w-report-od.campo-c[4] = x-faccpedi.nomcli
                            w-report-od.campo-c[5] = gn-divi.coddiv
                        .
                    x-total-ordenes = x-total-ordenes + 1.
                    x-total-metros = x-total-metros + w-report-od.campo-f[1].
                    x-total-rollos = x-total-rollos + w-report-od.campo-f[2].               
            /*END.*/
        END.
        /* Picking x Sector */
        /*
        x-cod-orden = ENTRY(x-sec,x-cod-ordenes,",").
        FOR EACH x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                    x-faccpedi.divdes = gn-divi.coddiv AND 
                                    x-faccpedi.coddoc = x-cod-orden AND
                                    x-faccpedi.empaqespec = YES AND
                                    (x-faccpedi.libre_f01 >= fill-in-desde AND x-faccpedi.libre_f01 <= fill-in-hasta) NO-LOCK:
            /*
            /* Verificamos si el pedido es EMBALADP ESPECIAL */
            FIND FIRST faccpedi WHERE faccpedi.codcia = x-faccpedi.codcia AND
                                        faccpedi.coddoc = x-faccpedi.codref AND 
                                        faccpedi.nroped = x-faccpedi.nroref NO-LOCK NO-ERROR.
            IF AVAILABLE faccpedi AND faccpedi.empaqespec = YES THEN DO:
            */

            x-fecha-cierre = ?.
            x-metros = 0.

            FIND FIRST w-report-od WHERE w-report-od.campo-c[1] = x-faccpedi.coddoc AND 
                                        w-report-od.campo-c[2] = x-faccpedi.nroped EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE w-report-od THEN DO:

                FOR EACH vtacdocu WHERE vtacdocu.codcia = s-codcia AND 
                                            vtacdocu.codref = x-faccpedi.coddoc AND
                                            vtacdocu.nroref = x-faccpedi.nroped AND
                                            vtacdocu.codped = 'HPK' AND
                                            vtacdocu.flgest <> 'A' NO-LOCK:
                    x-metros = x-metros + VtaCDocu.Importe[3].
                    IF x-fecha-cierre = ? THEN x-fecha-cierre = Vtacdocu.fecsac.
                    IF Vtacdocu.fecsac > x-fecha-cierre THEN x-fecha-cierre = Vtacdocu.fecsac.
                END.

                IF x-fecha-cierre = ? THEN NEXT.

                    CREATE w-report-od.
                        ASSIGN w-report-od.campo-d[1] = x-fecha-cierre
                                w-report-od.campo-c[1] = x-faccpedi.coddoc
                                w-report-od.campo-c[2] = x-faccpedi.nroped
                                w-report-od.campo-f[1] = x-metros
                                w-report-od.campo-f[2] = w-report-od.campo-f[1] / fill-in-metros
                                w-report-od.campo-c[3] = "PXR"
                                w-report-od.campo-c[4] = x-faccpedi.nomcli
                                w-report-od.campo-c[5] = gn-divi.coddiv
                            .
                        x-total-ordenes = x-total-ordenes + 1.
                        x-total-metros = x-total-metros + w-report-od.campo-f[1].
                        x-total-rollos = x-total-rollos + w-report-od.campo-f[2].

            END.
            /*END.*/
        END.
        */
    END.
END.
*/

DO WITH FRAME {&FRAME-NAME}:
    fill-in-tot-od:SCREEN-VALUE = STRING(x-total-ordenes,">,>>>,>>9").
    fill-in-tot-metros:SCREEN-VALUE = STRING(x-total-metros,">,>>>,>>9.99").
    fill-in-tot-rollos:SCREEN-VALUE = STRING(x-total-rollos,">,>>>,>>9.99").
    fill-in-tot-bultos:SCREEN-VALUE = STRING(x-total-bultos,">>,>>>,>>9").
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-txt B-table-Win 
PROCEDURE procesar-txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-archivo AS CHAR.

x-archivo = x-directorio + "\embalaj_especial.txt".

OUTPUT STREAM REPORT-TXT TO VALUE(x-Archivo).

PUT STREAM REPORT-txt
  "Cierre de Orden|" 
  "Div despacho|"
  "Cod Orden|"
  "Nro. Orden|"
  "Metraje utilizado|"
  "Cantidad rollos|"
  "Procs|"
  "Cliente|"
  "Bultos"   SKIP.
FOR EACH w-report-od:
  PUT STREAM REPORT-txt
      w-report-od.campo-d[1] "|"
      w-report-od.campo-c[5] "|"
      w-report-od.campo-c[1] "|"
      w-report-od.campo-c[2] "|"
      w-report-od.campo-f[1] "|"
      w-report-od.campo-f[2] "|"
      w-report-od.campo-c[3] "|"
      w-report-od.campo-c[4] FORMAT 'x(80)' "|"
      w-report-od.campo-i[1] FORMAT '>>,>>>,>>9' SKIP.
END.

OUTPUT STREAM REPORT-txt CLOSE.
MESSAGE 'Archivo creando en :' SKIP
    x-archivo
     VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "w-report-od"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

