&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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

{bin/s-global.i}
{pln/s-global.i}

DEFINE VARIABLE x-Crear AS LOGICAL NO-UNDO.
DEFINE VARIABLE reg-act AS ROWID   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES integral.PL-FLG-MES
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-FLG-MES


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-FLG-MES.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-CFG-CTE-MES

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table integral.PL-CFG-CTE-MES.Tpo-Cte-Mes ~
integral.PL-CFG-CTE-MES.Nro-Cte-Mes integral.PL-CFG-CTE-MES.Fch-Cte-Mes ~
integral.PL-CFG-CTE-MES.Moneda-Mes integral.PL-CFG-CTE-MES.Imp-Cte-Mes ~
integral.PL-CFG-CTE-MES.Imp-USA-Mes integral.PL-CFG-CTE-MES.Cuo-Cte-Mes ~
integral.PL-CFG-CTE-MES.Cuo-Por-Mes integral.PL-CFG-CTE-MES.Fch-Prx-Pgo-Mes ~
integral.PL-CFG-CTE-MES.Sdo-Cte-Mes integral.PL-CFG-CTE-MES.Sdo-USA-Mes 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ~
integral.PL-CFG-CTE-MES.Tpo-Cte-Mes integral.PL-CFG-CTE-MES.Nro-Cte-Mes ~
integral.PL-CFG-CTE-MES.Fch-Cte-Mes integral.PL-CFG-CTE-MES.Moneda-Mes ~
integral.PL-CFG-CTE-MES.Imp-Cte-Mes integral.PL-CFG-CTE-MES.Imp-USA-Mes ~
integral.PL-CFG-CTE-MES.Cuo-Cte-Mes integral.PL-CFG-CTE-MES.Cuo-Por-Mes ~
integral.PL-CFG-CTE-MES.Fch-Prx-Pgo-Mes 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}Tpo-Cte-Mes ~{&FP2}Tpo-Cte-Mes ~{&FP3}~
 ~{&FP1}Nro-Cte-Mes ~{&FP2}Nro-Cte-Mes ~{&FP3}~
 ~{&FP1}Fch-Cte-Mes ~{&FP2}Fch-Cte-Mes ~{&FP3}~
 ~{&FP1}Moneda-Mes ~{&FP2}Moneda-Mes ~{&FP3}~
 ~{&FP1}Imp-Cte-Mes ~{&FP2}Imp-Cte-Mes ~{&FP3}~
 ~{&FP1}Imp-USA-Mes ~{&FP2}Imp-USA-Mes ~{&FP3}~
 ~{&FP1}Cuo-Cte-Mes ~{&FP2}Cuo-Cte-Mes ~{&FP3}~
 ~{&FP1}Cuo-Por-Mes ~{&FP2}Cuo-Por-Mes ~{&FP3}~
 ~{&FP1}Fch-Prx-Pgo-Mes ~{&FP2}Fch-Prx-Pgo-Mes ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table integral.PL-CFG-CTE-MES
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table integral.PL-CFG-CTE-MES
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH integral.PL-CFG-CTE-MES ~
      WHERE integral.PL-CFG-CTE-MES.CodCia = s-CodCia ~
 AND integral.PL-CFG-CTE-MES.Periodo = s-Periodo ~
 AND integral.PL-CFG-CTE-MES.NroMes = s-NroMes ~
 AND integral.PL-CFG-CTE-MES.Clf-Cte-Mes = R-Clase ~
 AND integral.PL-CFG-CTE-MES.CodPer = integral.PL-FLG-MES.CodPer NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table integral.PL-CFG-CTE-MES
&Scoped-define FIRST-TABLE-IN-QUERY-br_table integral.PL-CFG-CTE-MES


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 br_table R-Clase 
&Scoped-Define DISPLAYED-OBJECTS R-Clase 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE R-Clase AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Pr‚stamos", 1,
"Adelantos", 2
     SIZE 24.14 BY .58 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58.72 BY 6.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      integral.PL-CFG-CTE-MES SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      integral.PL-CFG-CTE-MES.Tpo-Cte-Mes
      integral.PL-CFG-CTE-MES.Nro-Cte-Mes COLUMN-LABEL "Pr‚stamo"
      integral.PL-CFG-CTE-MES.Fch-Cte-Mes COLUMN-LABEL "      Fecha"
      integral.PL-CFG-CTE-MES.Moneda-Mes
      integral.PL-CFG-CTE-MES.Imp-Cte-Mes
      integral.PL-CFG-CTE-MES.Imp-USA-Mes
      integral.PL-CFG-CTE-MES.Cuo-Cte-Mes
      integral.PL-CFG-CTE-MES.Cuo-Por-Mes
      integral.PL-CFG-CTE-MES.Fch-Prx-Pgo-Mes
      integral.PL-CFG-CTE-MES.Sdo-Cte-Mes
      integral.PL-CFG-CTE-MES.Sdo-USA-Mes
  ENABLE
      integral.PL-CFG-CTE-MES.Tpo-Cte-Mes
      integral.PL-CFG-CTE-MES.Nro-Cte-Mes
      integral.PL-CFG-CTE-MES.Fch-Cte-Mes
      integral.PL-CFG-CTE-MES.Moneda-Mes
      integral.PL-CFG-CTE-MES.Imp-Cte-Mes
      integral.PL-CFG-CTE-MES.Imp-USA-Mes
      integral.PL-CFG-CTE-MES.Cuo-Cte-Mes
      integral.PL-CFG-CTE-MES.Cuo-Por-Mes
      integral.PL-CFG-CTE-MES.Fch-Prx-Pgo-Mes
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 57.29 BY 5.38
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.88 COL 1.72
     R-Clase AT ROW 1.19 COL 8.72 NO-LABEL
     RECT-1 AT ROW 1 COL 1
     " Clase:" VIEW-AS TEXT
          SIZE 5 BY .58 AT ROW 1.19 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.PL-FLG-MES
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 6.5
         WIDTH              = 58.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table TEXT-1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main = 2.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.PL-CFG-CTE-MES"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "integral.PL-CFG-CTE-MES.CodCia = s-CodCia
 AND integral.PL-CFG-CTE-MES.Periodo = s-Periodo
 AND integral.PL-CFG-CTE-MES.NroMes = s-NroMes
 AND integral.PL-CFG-CTE-MES.Clf-Cte-Mes = R-Clase
 AND integral.PL-CFG-CTE-MES.CodPer = integral.PL-FLG-MES.CodPer"
     _FldNameList[1]   > integral.PL-CFG-CTE-MES.Tpo-Cte-Mes
"PL-CFG-CTE-MES.Tpo-Cte-Mes" ? ? "integer" ? ? ? ? ? ? yes ?
     _FldNameList[2]   > integral.PL-CFG-CTE-MES.Nro-Cte-Mes
"PL-CFG-CTE-MES.Nro-Cte-Mes" "Pr‚stamo" ? "integer" ? ? ? ? ? ? yes ?
     _FldNameList[3]   > integral.PL-CFG-CTE-MES.Fch-Cte-Mes
"PL-CFG-CTE-MES.Fch-Cte-Mes" "      Fecha" ? "date" ? ? ? ? ? ? yes ?
     _FldNameList[4]   > integral.PL-CFG-CTE-MES.Moneda-Mes
"PL-CFG-CTE-MES.Moneda-Mes" ? ? "logical" ? ? ? ? ? ? yes ?
     _FldNameList[5]   > integral.PL-CFG-CTE-MES.Imp-Cte-Mes
"PL-CFG-CTE-MES.Imp-Cte-Mes" ? ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[6]   > integral.PL-CFG-CTE-MES.Imp-USA-Mes
"PL-CFG-CTE-MES.Imp-USA-Mes" ? ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[7]   > integral.PL-CFG-CTE-MES.Cuo-Cte-Mes
"PL-CFG-CTE-MES.Cuo-Cte-Mes" ? ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[8]   > integral.PL-CFG-CTE-MES.Cuo-Por-Mes
"PL-CFG-CTE-MES.Cuo-Por-Mes" ? ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[9]   > integral.PL-CFG-CTE-MES.Fch-Prx-Pgo-Mes
"PL-CFG-CTE-MES.Fch-Prx-Pgo-Mes" ? ? "date" ? ? ? ? ? ? yes ?
     _FldNameList[10]   = integral.PL-CFG-CTE-MES.Sdo-Cte-Mes
     _FldNameList[11]   = integral.PL-CFG-CTE-MES.Sdo-USA-Mes
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
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


&Scoped-define SELF-NAME integral.PL-CFG-CTE-MES.Tpo-Cte-Mes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-CFG-CTE-MES.Tpo-Cte-Mes br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF integral.PL-CFG-CTE-MES.Tpo-Cte-Mes IN BROWSE br_table /* Tipo */
DO:
    IF x-Crear = FALSE THEN DO:
        APPLY "ENTRY" TO integral.PL-CFG-CTE-MES.Fch-Cte-Mes IN BROWSE {&BROWSE-NAME}.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-CFG-CTE-MES.Tpo-Cte-Mes br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF integral.PL-CFG-CTE-MES.Tpo-Cte-Mes IN BROWSE br_table /* Tipo */
DO:
    FIND integral.PL-CORR-CTE-MES WHERE
        integral.PL-CORR-CTE-MES.CodCia = s-CodCia AND
        integral.PL-CORR-CTE-MES.Periodo = s-Periodo AND
        integral.PL-CORR-CTE-MES.Clf-Cte-Mes = R-Clase AND
        integral.PL-CORR-CTE-MES.Tpo-Cte-Mes = INPUT BROWSE {&BROWSE-NAME} integral.PL-CFG-CTE-MES.Tpo-Cte-Mes
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.PL-CORR-CTE-MES THEN DO:
        BELL.
        MESSAGE "Correlativo para tipo" INPUT BROWSE {&BROWSE-NAME} integral.PL-CFG-CTE-MES.Tpo-Cte-Mes SKIP
            "no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.PL-CFG-CTE-MES.Tpo-Cte-Mes.
        RETURN NO-APPLY.
    END.
    DISPLAY
        integral.PL-CORR-CTE-MES.Nro-Cte-Mes + 1 @ integral.PL-CFG-CTE-MES.Nro-Cte-Mes
        TODAY @ integral.PL-CFG-CTE-MES.Fch-Cte-Mes
        WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-CFG-CTE-MES.Tpo-Cte-Mes br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF integral.PL-CFG-CTE-MES.Tpo-Cte-Mes IN BROWSE br_table /* Tipo */
OR F8 OF integral.PL-CFG-CTE-MES.Tpo-Cte-Mes
DO:
    IF x-Crear = FALSE THEN RETURN.
    ASSIGN reg-act = ?.
    RUN pln/h-corr-m.r( R-Clase, OUTPUT reg-act ).
    IF reg-act <> ? THEN DO:
        FIND integral.PL-CORR-CTE-MES WHERE
            ROWID( integral.PL-CORR-CTE-MES ) = reg-act NO-LOCK NO-ERROR.
        IF AVAILABLE integral.PL-CORR-CTE-MES THEN
            DISPLAY
                integral.PL-CORR-CTE-MES.Tpo-Cte-Mes @
                integral.PL-CFG-CTE-MES.Tpo-Cte-Mes WITH BROWSE {&BROWSE-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME integral.PL-CFG-CTE-MES.Imp-Cte-Mes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-CFG-CTE-MES.Imp-Cte-Mes br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF integral.PL-CFG-CTE-MES.Imp-Cte-Mes IN BROWSE br_table /* Importe */
DO:
  IF NOT PL-CFG-CTE-MES.Moneda-Mes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "Soles"
  THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-CFG-CTE-MES.Imp-Cte-Mes br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF integral.PL-CFG-CTE-MES.Imp-Cte-Mes IN BROWSE br_table /* Importe */
DO:
    IF R-Clase = 2 THEN
        DISPLAY
            INPUT integral.PL-CFG-CTE-MES.Imp-Cte-Mes @
            integral.PL-CFG-CTE-MES.Cuo-Cte-Mes WITH BROWSE {&BROWSE-NAME}.
    IF x-Crear = TRUE THEN
        integral.PL-CFG-CTE-MES.Sdo-Cte-Mes = integral.PL-CFG-CTE-MES.Imp-Cte-Mes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME integral.PL-CFG-CTE-MES.Imp-USA-Mes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-CFG-CTE-MES.Imp-USA-Mes br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF integral.PL-CFG-CTE-MES.Imp-USA-Mes IN BROWSE br_table /* Importe!US$ */
DO:
    IF PL-CFG-CTE-MES.Moneda-Mes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "Soles"
  THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-Clase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-Clase B-table-Win
ON VALUE-CHANGED OF R-Clase IN FRAME F-Main
DO:
    ASSIGN R-Clase.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
RUN dispatch IN THIS-PROCEDURE ('initialize':U).
&ENDIF

ASSIGN R-Clase = 1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "integral.PL-FLG-MES"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.PL-FLG-MES"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/* Buscamos el correlativo */

    FIND FIRST integral.PL-CORR-CTE-MES WHERE
        integral.PL-CORR-CTE-MES.CodCia = s-CodCia AND
        integral.PL-CORR-CTE-MES.Periodo = s-Periodo AND
        integral.PL-CORR-CTE-MES.Clf-Cte-Mes = R-Clase NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.PL-CORR-CTE-MES THEN DO:
        BELL.
        MESSAGE "Correlativo para clase" R-Clase "no existe"
            VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.

    IF NOT CAN-FIND(FIRST integral.PL-CFG-CTE-MES WHERE
        integral.PL-CFG-CTE-MES.CodCia = s-CodCia AND
        integral.PL-CFG-CTE-MES.Periodo = s-Periodo AND
        integral.PL-CFG-CTE-MES.NroMes = s-NroMes AND
        integral.PL-CFG-CTE-MES.Clf-Cte-Mes = R-Clase AND
        integral.PL-CFG-CTE-MES.CodPer = integral.PL-FLG-MES.CodPer) THEN DO:
        CREATE integral.PL-CFG-CTE-MES.
        ASSIGN
            integral.PL-CFG-CTE-MES.CodCia = s-CodCia
            integral.PL-CFG-CTE-MES.Periodo = s-Periodo
            integral.PL-CFG-CTE-MES.NroMes = s-NroMes
            integral.PL-CFG-CTE-MES.Clf-Cte-Mes = R-Clase
            integral.PL-CFG-CTE-MES.CodPer = integral.PL-FLG-MES.CodPer
            x-Crear = TRUE.
        {&OPEN-QUERY-{&BROWSE-NAME}}
        APPLY "ENTRY" TO integral.PL-CFG-CTE-MES.Tpo-Cte-Mes IN BROWSE {&BROWSE-NAME}.
        RETURN.
    END.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
    
    APPLY "ENTRY" TO integral.PL-CFG-CTE-MES.Tpo-Cte-Mes IN BROWSE {&BROWSE-NAME}.
    ASSIGN x-Crear = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/* Creaci¢n */

    IF x-Crear = TRUE THEN DO:
        /* Buscamos el correlativo */
        FIND integral.PL-CORR-CTE-MES WHERE
            integral.PL-CORR-CTE-MES.CodCia = s-CodCia AND
            integral.PL-CORR-CTE-MES.Periodo = s-Periodo AND
            integral.PL-CORR-CTE-MES.Clf-Cte-Mes = R-Clase AND
            integral.PL-CORR-CTE-MES.Tpo-Cte-Mes = INPUT BROWSE {&BROWSE-NAME} integral.PL-CFG-CTE-MES.Tpo-Cte-Mes NO-ERROR.
        IF AVAILABLE integral.PL-CORR-CTE-MES THEN DO:
            ASSIGN
                integral.PL-CORR-CTE-MES.Nro-Cte-Mes = integral.PL-CORR-CTE-MES.Nro-Cte-Mes + 1.
            DISPLAY
                integral.PL-CORR-CTE-MES.Nro-Cte-Mes @ integral.PL-CFG-CTE-MES.Nro-Cte-Mes
                WITH BROWSE {&BROWSE-NAME}.
        END.
    END.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ).

    IF x-Crear = TRUE THEN
        ASSIGN
            integral.PL-CFG-CTE-MES.CodCia = s-CodCia
            integral.PL-CFG-CTE-MES.Periodo = s-Periodo
            integral.PL-CFG-CTE-MES.NroMes = s-NroMes
            integral.PL-CFG-CTE-MES.Clf-Cte-Mes = R-Clase
            integral.PL-CFG-CTE-MES.CodPer = integral.PL-FLG-MES.CodPer
            integral.PL-CFG-CTE-MES.Nro-Cte-Mes =
                IF AVAILABLE integral.PL-CORR-CTE-MES THEN
                    integral.PL-CORR-CTE-MES.Nro-Cte-Mes
                ELSE 1
            integral.PL-CFG-CTE-MES.Sdo-Cte-Mes = integral.PL-CFG-CTE-MES.Imp-Cte-Mes.

    ASSIGN x-Crear = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record B-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

    ASSIGN x-Crear = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record B-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

    APPLY "ENTRY" TO integral.PL-CFG-CTE-MES.Tpo-Cte-Mes IN BROWSE {&BROWSE-NAME}.
    ASSIGN x-Crear = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.PL-FLG-MES"}
  {src/adm/template/snd-list.i "integral.PL-CFG-CTE-MES"}

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

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


