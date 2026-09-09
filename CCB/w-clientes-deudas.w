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
DEFINE SHARED VAR s-codcia AS INT.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE TEMP-TABLE ttDeuda
    FIELDS  tcodcli     AS  CHAR    COLUMN-LABEL "Cod.Cliente"
    FIELDS  tnomcli     AS  CHAR    COLUMN-LABEL "Nombre del Cliente"
    FIELDS  truc        AS  CHAR    COLUMN-LABEL "R.U.C."
    FIELDS  tdeuda_sol  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Total deuda Soles" INIT 0
    FIELDS  tdeuda_sol_vig  AS  DEC FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Deuda Vigente Soles" INIT 0
    FIELDS  tdeuda_sol_ven  AS  DEC FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Deuda Vencida Soles" INIT 0
    FIELDS  tdeuda_dol  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Total deuda Dolares" INIT 0
    FIELDS  tdeuda_dol_vig  AS  DEC FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Deuda Vigente Dolares" INIT 0
    FIELDS  tdeuda_dol_ven  AS  DEC FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Deuda Vencida Dolares" INIT 0
    FIELDS  tobservacion    AS  CHAR    COLUMN-LABEL "Observacion"
    FIELDS  tuser           AS  CHAR    COLUMN-LABEL "Analista"
    FIELD   tfecha-hora AS  CHAR    COLUMN-LABEL "Fecha/Hora actualizacion"
    .

DEFINE TEMP-TABLE ttClientes
    FIELDS  tcodcli     AS  CHAR
    INDEX idx01 IS PRIMARY tcodcli.

DEFINE BUFFER x-gn-clie FOR gn-clie.

DEFINE TEMP-TABLE b-ttDeuda LIKE ttDeuda.

DEFINE VAR x-ruta AS CHAR.

/* ----------------------------------------------------- */

define var x-sort-direccion as char init "".
define var x-sort-column as char init "".
define var x-sort-command as char init "".

DEFINE VAR x-sort-acumulativo AS LOG INIT NO.
DEFINE VAR x-sort-color-reset AS LOG INIT YES.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gn-clie

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 gn-clie.CodCli gn-clie.NomCli ~
gn-clie.Ruc 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH gn-clie ~
      WHERE gn-clie.codcia = 0 NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH gn-clie ~
      WHERE gn-clie.codcia = 0 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 gn-clie


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-3 TOGGLE-todos FILL-IN-desde ~
FILL-IN-comentarios BUTTON-12 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-todos FILL-IN-desde ~
FILL-IN-comentarios 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-12 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-comentarios AS INTEGER FORMAT ">>9":U INITIAL 3 
     LABEL "Mostrar el/los" 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE TOGGLE-todos AS LOGICAL INITIAL yes 
     LABEL "Todos" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      gn-clie
    FIELDS(gn-clie.CodCli
      gn-clie.NomCli
      gn-clie.Ruc) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      gn-clie.CodCli FORMAT "x(15)":U WIDTH 16.29
      gn-clie.NomCli FORMAT "x(80)":U WIDTH 49.57
      gn-clie.Ruc FORMAT "x(11)":U WIDTH 17.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 88 BY 22.69
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-3 AT ROW 1.19 COL 2.14 WIDGET-ID 200
     TOGGLE-todos AT ROW 2.15 COL 103 WIDGET-ID 22
     FILL-IN-desde AT ROW 4.46 COL 100.57 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     FILL-IN-comentarios AT ROW 6.58 COL 102.29 COLON-ALIGNED WIDGET-ID 12
     BUTTON-12 AT ROW 9.46 COL 103 WIDGET-ID 10
     "0 = Todos" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 7.73 COL 101 WIDGET-ID 16
          FGCOLOR 9 
     "Documentos emitidos desde" VIEW-AS TEXT
          SIZE 25 BY .62 AT ROW 3.69 COL 97.86 WIDGET-ID 8
     "ultimo(s) comentario(s)" VIEW-AS TEXT
          SIZE 19.86 BY .62 AT ROW 6.77 COL 108.43 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 128.43 BY 23.31 WIDGET-ID 100.


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
         TITLE              = "Reporte de deudas - Clientes"
         HEIGHT             = 23.31
         WIDTH              = 128.43
         MAX-HEIGHT         = 23.31
         MAX-WIDTH          = 138
         VIRTUAL-HEIGHT     = 23.31
         VIRTUAL-WIDTH      = 138
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
/* BROWSE-TAB BROWSE-3 TEXT-3 F-Main */
ASSIGN 
       BROWSE-3:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "INTEGRAL.gn-clie"
     _Options          = "NO-LOCK"
     _TblOptList       = "USED"
     _Where[1]         = "gn-clie.codcia = 0"
     _FldNameList[1]   > INTEGRAL.gn-clie.CodCli
"gn-clie.CodCli" ? "x(15)" "character" ? ? ? ? ? ? no ? no no "16.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.gn-clie.NomCli
"gn-clie.NomCli" ? "x(80)" "character" ? ? ? ? ? ? no ? no no "49.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.gn-clie.Ruc
"gn-clie.Ruc" ? ? "character" ? ? ? ? ? ? no ? no no "17.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de deudas - Clientes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de deudas - Clientes */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 W-Win
ON START-SEARCH OF BROWSE-3 IN FRAME F-Main
DO:
    DEFINE VARIABLE hSortColumn AS WIDGET-HANDLE.
    DEFINE VAR lColumName AS CHAR.
    DEFINE VAR hQueryHandle AS HANDLE NO-UNDO.

    DEFINE VAR n_cols_browse AS INT NO-UNDO.
    DEFINE VAR n_celda AS WIDGET-HANDLE NO-UNDO.

    hSortColumn = BROWSE BROWSE-3:CURRENT-COLUMN.
    lColumName = hSortColumn:NAME.
    lColumName = TRIM(REPLACE(lColumName," no","")).

    IF lColumName = 'acubon' THEN DO:
        MESSAGE "Columna imposible de Ordenar".
        RETURN NO-APPLY.
    END.

    IF lColumName = 'x-subzona' THEN lColumName = 'csubzona'.
    IF lColumName = 'x-zona' THEN lColumName = 'czona'.

    x-sort-command = "BY " + lColumName.

    IF x-sort-acumulativo = NO THEN DO:
        IF CAPS(x-sort-command) = CAPS(x-sort-column) THEN DO:
            x-sort-command = "BY " + lColumName + " DESC".
        END.
        ELSE DO:
            x-sort-command = "BY " + lColumName + " DESC".
            IF CAPS(x-sort-command) = CAPS(x-sort-column) THEN DO:
                x-sort-command = "BY " + lColumName.
            END.
            ELSE x-sort-command = "BY " + lColumName.
        END.
        x-sort-column = x-sort-command.

        x-sort-color-reset = YES.
    END.
    ELSE DO:
        x-sort-command = "BY " + lColumName + " DESC".

        IF INDEX(x-sort-column,x-sort-command) > 0 THEN DO:
            x-sort-column = REPLACE(x-sort-column,x-sort-command,"BY " + lColumName).
        END.
        ELSE DO:
            x-sort-command = "BY " + lColumName.
            IF INDEX(x-sort-column,x-sort-command) > 0 THEN DO:
                x-sort-column = REPLACE(x-sort-column,x-sort-command,"BY " + lColumName + " DESC").
            END.
            ELSE DO:
                x-sort-column = x-sort-column + " " + x-sort-command.
            END.
        END.
        x-sort-command = x-sort-column.
    END.
    
    SESSION:SET-WAIT-STATE("GENERAL").

    hQueryHandle = BROWSE BROWSE-3:QUERY.
    hQueryHandle:QUERY-CLOSE().
    /* *--- Este valor debe ser el QUERY que esta definido en el BROWSE. */   
    hQueryHandle:QUERY-PREPARE("FOR EACH gn-clie WHERE gn-clie.codcia = 0 NO-LOCK " + x-sort-command).
    hQueryHandle:QUERY-OPEN().

    SESSION:SET-WAIT-STATE("").

    /* Color SortCol */
    IF x-sort-color-reset = YES THEN DO:
        /* Color normal */
        DO n_cols_browse = 1 TO BROWSE-3:NUM-COLUMNS.
            n_celda = BROWSE-3:GET-BROWSE-COLUMN(n_cols_browse).
            n_celda:COLUMN-BGCOLOR = 15.
        END.        

        x-sort-color-reset = NO.
    END.
    hSortColumn:COLUMN-BGCOLOR = 11.   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 W-Win
ON VALUE-CHANGED OF BROWSE-3 IN FRAME F-Main
DO:
  IF BROWSE-3:NUM-SELECTED-ROWS > 0 THEN toggle-todos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'no'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 W-Win
ON CHOOSE OF BUTTON-12 IN FRAME F-Main /* Procesar */
DO:

    MESSAGE 'Seguro de realizar el proceso?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.


        SYSTEM-DIALOG GET-DIR x-ruta
           RETURN-TO-START-DIR 
           TITLE 'Directorio Files'.
        IF x-ruta = "" THEN DO:
        RETURN NO-APPLY.
    END.
        
    ASSIGN fill-in-desde fill-in-comentarios toggle-todos.

    RUN procesar.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-todos W-Win
ON VALUE-CHANGED OF TOGGLE-todos IN FRAME F-Main /* Todos */
DO:
    IF toggle-todos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'yes' THEN DO:
        BROWSE-3:DESELECT-ROWS().
    END.
    ELSE DO:
        toggle-todos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'no'.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
ON FIND OF gn-clie DO:
   /*    
   FIND FIRST tt-gn-clie WHERE tt-gn-clie.codcia = gn-clie.codcia AND
                                tt-gn-clie.codcli = gn-clie.codcli NO-LOCK NO-ERROR.
   IF NOT AVAILABLE tt-gn-clie THEN DO:
       
       CREATE tt-gn-clie.
        BUFFER-COPY gn-clie TO tt-gn-clie
            ASSIGN tt-gn-clie.libre_l01 = YES.
   END.
   */
    RETURN.
END.


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
  DISPLAY TOGGLE-todos FILL-IN-desde FILL-IN-comentarios 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-3 TOGGLE-todos FILL-IN-desde FILL-IN-comentarios BUTTON-12 
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
  fill-in-desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 90,"99/99/9999").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar W-Win 
PROCEDURE procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-dia AS DATE.
DEFINE VAR x-desde AS DATE.
DEFINE VAR x-hasta AS DATE.
DEFINE VAR x-sec AS INT.

DEFINE VAR x-hora-hasta AS CHAR.
DEFINE VAR x-hora-desde AS CHAR.
                                          
x-desde = fill-in-desde.
x-hasta = TODAY.

x-hora-desde = STRING(TIME,"HH:MM:SS").

EMPTY TEMP-TABLE ttClientes.

IF toggle-todos = NO THEN DO:
    DO WITH FRAME {&FRAME-NAME}:
        DO x-sec = 1 TO BROWSE-3:NUM-SELECTED-ROWS :
            IF BROWSE-3:FETCH-SELECTED-ROW(X-sec) THEN DO:
                CREATE ttClientes.
                    ASSIGN ttClientes.tcodcli = {&FIRST-TABLE-IN-QUERY-browse-3}.codcli.
            END.
        END.
    END.
END.

DEFINE VAR x-deuda-total-soles AS DEC.
DEFINE VAR x-deuda-vencida-soles AS DEC.
DEFINE VAR x-deuda-vigente-soles AS DEC.

DEFINE VAR x-deuda-total-dolares AS DEC.
DEFINE VAR x-deuda-vencida-dolares AS DEC.
DEFINE VAR x-deuda-vigente-dolares AS DEC.

DEFINE VAR x-tipo-cambio AS DEC.
DEFINE VAR x-saldo-doc AS DEC.

SESSION:SET-WAIT-STATE("GENERAL").

REPEAT x-dia = x-desde TO x-hasta :
    FOR EACH ccbcdocu FIELDS (codcia coddoc nrodoc fchdoc flgest SdoAct codmon codcli FchVto) USE-INDEX llave13 NO-LOCK 
            WHERE ccbcdocu.codcia = s-codcia AND 
                ccbcdocu.fchdoc = x-dia AND 
                Ccbcdocu.SdoAct > 0 AND 
                LOOKUP(ccbcdocu.flgest, 'A,X') = 0  , 
        FIRST facdocum OF ccbcdocu WHERE NOT (facdocum.tpodoc = ?) NO-LOCK:

        FIND FIRST ttClientes WHERE ttClientes.tcodcli = ccbcdocu.codcli NO-LOCK NO-ERROR.

        FIND FIRST x-gn-clie WHERE x-gn-clie.codcia = 0 AND
                                    x-gn-clie.codcli = ccbcdocu.codcli NO-LOCK NO-ERROR.

        IF NOT AVAILABLE x-gn-clie THEN NEXT.

        IF toggle-todos = YES OR AVAILABLE ttClientes THEN DO:
            x-saldo-doc = ccbcdocu.sdoact.
            FIND FIRST ttDeuda WHERE ttDeuda.tcodcli = ccbcdocu.codcli NO-ERROR.
            IF NOT AVAILABLE ttDeuda THEN DO:

                CREATE ttDeuda.
                    ASSIGN  ttDeuda.tcodcli     = ccbcdocu.codcli
                            ttDeuda.tnomcli     = REPLACE(x-gn-clie.nomcli,";"," ")
                            ttDeuda.truc        = x-gn-clie.ruc
                    .
            END.
            IF ccbcdocu.codmon = 2 THEN DO:
                ASSIGN ttDeuda.tdeuda_dol = ttDeuda.tdeuda_dol + x-saldo-doc.            
            END.
            ELSE DO:
                ASSIGN ttDeuda.tdeuda_sol = ttDeuda.tdeuda_sol + x-saldo-doc.
            END.
            IF CcbCDocu.FchVto >= TODAY THEN DO:
                /* x vencer */
                IF ccbcdocu.codmon = 2 THEN DO:
                    ASSIGN ttDeuda.tdeuda_dol_vig = ttDeuda.tdeuda_dol_vig + x-saldo-doc.
                END.
                ELSE DO:
                    ASSIGN ttDeuda.tdeuda_sol_vig = ttDeuda.tdeuda_sol_vig + x-saldo-doc.
                END.            
            END.
            ELSE DO:
                /* vencido */
                IF ccbcdocu.codmon = 2 THEN DO:
                    ASSIGN ttDeuda.tdeuda_dol_ven = ttDeuda.tdeuda_dol_ven + x-saldo-doc.
                END.
                ELSE DO:
                    ASSIGN ttDeuda.tdeuda_sol_ven = ttDeuda.tdeuda_sol_ven + x-saldo-doc.
                END.
            END.
        END.
    END.
END.
                                          
x-hora-hasta = STRING(TIME,"HH:MM:SS").

/**/

EMPTY TEMP-TABLE b-ttDeuda.

DEFINE VAR x-cont-obs AS INT INIT 0.

FOR EACH ttDeuda :
    x-cont-obs = 0.
    /* --- */
    LOOP_OBSERVACIONES:
    FOR EACH ccbtabla WHERE ccbtabla.codcia = s-codcia AND
                            ccbtabla.tabla = "CLIENTE-OBS-ANALISTA" AND
                            ccbtabla.codigo = ttDeuda.tcodcli NO-LOCK BY ccbtabla.libre_f02 DESC :
        IF FILL-in-comentarios = 0 OR x-cont-obs < FILL-in-comentarios THEN DO:

            CREATE b-ttDeuda.
            IF x-cont-obs = 0 THEN DO:                
                BUFFER-COPY ttDeuda TO b-ttDeuda.
            END.
            ELSE DO:
                ASSIGN b-ttDeuda.tcodcli = ttDeuda.tcodcli.
            END.

            ASSIGN b-ttDeuda.tobservacion = ccbtabla.libre_c02.
            ASSIGN b-ttDeuda.tuser = ENTRY(1,ccbtabla.libre_c01,"|") NO-ERROR.
            ASSIGN b-ttDeuda.tfecha-hora = STRING(ccbtabla.libre_f02,"99/99/9999") + " " + 
                                            ENTRY(3,ccbtabla.libre_c01,"|") NO-ERROR.
            /**/
            x-cont-obs = x-cont-obs + 1.
            
        END.
        ELSE DO:
            LEAVE LOOP_OBSERVACIONES.
        END.        
    END.
    IF x-cont-obs = 0 THEN DO:
        CREATE b-ttDeuda.
        BUFFER-COPY ttDeuda TO b-ttDeuda.
    END.
END.

DEFINE VAR x-file AS CHAR.
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

x-file = "Saldos_" + STRING(TODAY,"99/99/9999") + "_" + STRING(TIME,"HH:MM:SS").
x-file = REPLACE(x-file,"/","-").
x-file = REPLACE(x-file,":","").

c-xls-file = x-ruta + "\" + x-file.

run pi-crea-archivo-csv IN hProc (input  buffer b-ttDeuda:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer b-ttDeuda:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

SESSION:SET-WAIT-STATE("").

MESSAGE "Se creo el archivo : " SKIP
        c-xls-file .

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
  {src/adm/template/snd-list.i "gn-clie"}

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

