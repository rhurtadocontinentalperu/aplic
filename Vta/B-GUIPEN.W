&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VAR S-CODDOC AS CHAR INIT "G/R".
DEFINE VAR R-GUIA AS RECID.
DEFINE VAR X-MON AS CHAR.
DEFINE VAR X-VTA AS CHAR.
DEFINE VAR X-PAG AS CHAR.

DEFINE VARIABLE P-MON   AS CHAR NO-UNDO.
DEFINE VARIABLE P-EST   AS CHAR NO-UNDO.
DEFINE STREAM REPORT.

DEFINE TEMP-TABLE t-ccbcdocu LIKE ccbcdocu.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH OVERLAY CENTERED KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

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
&Scoped-define INTERNAL-TABLES CcbCDocu gn-clie Ccbaudit Ccbtabla

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCDocu.NroDoc CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.CodVen CcbCDocu.FchDoc CcbCDocu.FchVto X-PAG @ X-PAG X-MON @ X-MON CcbCDocu.ImpTot Ccbaudit.usuario Ccbaudit.fecha Ccbaudit.hora Ccbtabla.nombre   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table CASE COMBO-BOX-8:SCREEN-VALUE IN FRAME {&FRAME-NAME} :      WHEN "Fechas" THEN DO :         OPEN QUERY {&SELF-NAME} FOR EACH CcbCDocu WHERE {&KEY-PHRASE}              AND CcbCDocu.CodCia = S-CODCIA              AND CcbCDocu.CodDiv = S-CODDIV              AND CcbCDocu.CodDoc = S-CODDOC              AND SubString(CcbCDocu.NroDoc, ~
      1, ~
      1) <> "S"              AND CcbCDocu.nomcli BEGINS wclient              AND CcbCDocu.FlgEst BEGINS x-FlgEst              AND CcbCDocu.FchDoc >= F-DesFch              AND CCbCDocu.FchDoc <= F-HasFch NO-LOCK, ~
                    FIRST gn-clie WHERE gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK, ~
                    FIRST Ccbaudit OUTER-JOIN OF Ccbcdocu NO-LOCK WHERE Ccbaudit.evento = 'DELETE', ~
                    FIRST Ccbtabla OUTER-JOIN NO-LOCK WHERE Ccbtabla.codcia = ccbcdocu.codcia                 AND Ccbtabla.codigo = Ccbaudit.codref                 AND Ccbtabla.tabla = 'MA'              BY CcbCDocu.NroDoc DESC.      END.      OTHERWISE DO :         OPEN QUERY {&SELF-NAME} FOR EACH CcbCDocu WHERE {&KEY-PHRASE}              AND CcbCDocu.CodCia = S-CODCIA              AND CcbCDocu.CodDiv = S-CODDIV              AND CcbCDocu.CodDoc = S-CODDOC              AND SubString(CcbCDocu.NroDoc, ~
      1, ~
      1) <> "S"              AND CcbCDocu.nomcli BEGINS wclient              AND CcbCDocu.FlgEst BEGINS x-FlgEst              NO-LOCK, ~
                    FIRST gn-clie WHERE gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK, ~
                    FIRST Ccbaudit OUTER-JOIN OF Ccbcdocu NO-LOCK WHERE Ccbaudit.evento = 'DELETE', ~
                   FIRST Ccbtabla OUTER-JOIN NO-LOCK WHERE Ccbtabla.codcia = ccbcdocu.codcia                AND Ccbtabla.codigo = Ccbaudit.codref                AND Ccbtabla.tabla = 'MA'              BY CcbCDocu.NroDoc DESC.      END. END CASE.
&Scoped-define TABLES-IN-QUERY-br_table CcbCDocu gn-clie Ccbaudit Ccbtabla
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-clie
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Ccbaudit
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table Ccbtabla


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BUTTON-5 F-DesFch F-HasFch ~
COMBO-BOX-8 wclient wguia x-FlgEst br_table 
&Scoped-Define DISPLAYED-OBJECTS F-DesFch F-HasFch COMBO-BOX-8 wclient ~
wguia x-FlgEst 

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
DEFINE BUTTON BUTTON-1 DEFAULT 
     IMAGE-UP FILE "img\print":U NO-FOCUS
     LABEL "Button 1" 
     SIZE 5 BY 1.12.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 5" 
     SIZE 6 BY 1.35.

DEFINE VARIABLE COMBO-BOX-8 AS CHARACTER FORMAT "X(256)":U INITIAL "Guía" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Guía","Cliente","Fechas" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE F-DesFch AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .77 NO-UNDO.

DEFINE VARIABLE F-HasFch AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .77 NO-UNDO.

DEFINE VARIABLE wclient AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .77 NO-UNDO.

DEFINE VARIABLE wguia AS CHARACTER FORMAT "XXX-XXXXXX":U 
     LABEL "# Guía" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .77 NO-UNDO.

DEFINE VARIABLE x-FlgEst AS CHARACTER INITIAL "P" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Por Facturar", "P",
"Facturadas", "F",
"Anuladas", "G"
     SIZE 40 BY .92 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCDocu, 
      gn-clie, 
      Ccbaudit, 
      Ccbtabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      CcbCDocu.NroDoc COLUMN-LABEL " Guia" FORMAT "XXX-XXXXXXXX"
      CcbCDocu.CodCli COLUMN-LABEL "<<<Cliente>>>"
      CcbCDocu.NomCli FORMAT "x(44)"
      CcbCDocu.CodVen COLUMN-LABEL "Vend." FORMAT "x(5)"
      CcbCDocu.FchDoc COLUMN-LABEL "     Fecha    !     Emisión"
      CcbCDocu.FchVto COLUMN-LABEL "   Fecha   !Vencimiento"
      X-PAG @ X-PAG COLUMN-LABEL "Tip.!Vta." FORMAT "X(4)"
      X-MON @ X-MON COLUMN-LABEL "Mon." FORMAT "XXX"
      CcbCDocu.ImpTot
      Ccbaudit.usuario COLUMN-LABEL 'Usuario anulación'
      Ccbaudit.fecha COLUMN-LABEL 'Fecha'
      Ccbaudit.hora  COLUMN-LABEL 'Hora'
      Ccbtabla.nombre COLUMN-LABEL 'MOtivo de anulación'
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 108 BY 13.04
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.38 COL 78
     BUTTON-5 AT ROW 1.27 COL 85 WIDGET-ID 2
     F-DesFch AT ROW 1.42 COL 28.86 COLON-ALIGNED
     F-HasFch AT ROW 1.42 COL 50.57 COLON-ALIGNED
     COMBO-BOX-8 AT ROW 1.46 COL 8.14 COLON-ALIGNED NO-LABEL
     wclient AT ROW 1.46 COL 28.86 COLON-ALIGNED
     wguia AT ROW 1.46 COL 28.86 COLON-ALIGNED
     x-FlgEst AT ROW 2.5 COL 10.57 NO-LABEL
     br_table AT ROW 3.58 COL 2
     "Situacion:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 2.73 COL 2.43
     "Buscar x" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 1.62 COL 2
          FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 16.08
         WIDTH              = 119.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table x-FlgEst F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
CASE COMBO-BOX-8:SCREEN-VALUE IN FRAME {&FRAME-NAME} :
     WHEN "Fechas" THEN DO :
        OPEN QUERY {&SELF-NAME} FOR EACH CcbCDocu WHERE {&KEY-PHRASE}
             AND CcbCDocu.CodCia = S-CODCIA
             AND CcbCDocu.CodDiv = S-CODDIV
             AND CcbCDocu.CodDoc = S-CODDOC
             AND SubString(CcbCDocu.NroDoc,1,1) <> "S"
             AND CcbCDocu.nomcli BEGINS wclient
             AND CcbCDocu.FlgEst BEGINS x-FlgEst
             AND CcbCDocu.FchDoc >= F-DesFch
             AND CCbCDocu.FchDoc <= F-HasFch NO-LOCK,
             FIRST gn-clie WHERE gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK,
             FIRST Ccbaudit OUTER-JOIN OF Ccbcdocu NO-LOCK WHERE Ccbaudit.evento = 'DELETE',
             FIRST Ccbtabla OUTER-JOIN NO-LOCK WHERE Ccbtabla.codcia = ccbcdocu.codcia
                AND Ccbtabla.codigo = Ccbaudit.codref
                AND Ccbtabla.tabla = 'MA'
             BY CcbCDocu.NroDoc DESC.
     END.
     OTHERWISE DO :
        OPEN QUERY {&SELF-NAME} FOR EACH CcbCDocu WHERE {&KEY-PHRASE}
             AND CcbCDocu.CodCia = S-CODCIA
             AND CcbCDocu.CodDiv = S-CODDIV
             AND CcbCDocu.CodDoc = S-CODDOC
             AND SubString(CcbCDocu.NroDoc,1,1) <> "S"
             AND CcbCDocu.nomcli BEGINS wclient
             AND CcbCDocu.FlgEst BEGINS x-FlgEst
             NO-LOCK,
             FIRST gn-clie WHERE gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK,
             FIRST Ccbaudit OUTER-JOIN OF Ccbcdocu NO-LOCK WHERE Ccbaudit.evento = 'DELETE',
            FIRST Ccbtabla OUTER-JOIN NO-LOCK WHERE Ccbtabla.codcia = ccbcdocu.codcia
               AND Ccbtabla.codigo = Ccbaudit.codref
               AND Ccbtabla.tabla = 'MA'
             BY CcbCDocu.NroDoc DESC.
     END.
END CASE.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
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
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main
DO:
   RUN vta\d-guipen.r(CcbCDocu.NroDoc,"G/R").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  RUN Formato.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 B-table-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
  RUN Genera-Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-8 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-8 IN FRAME F-Main
DO:
  wguia:HIDDEN    = yes.
  wclient:HIDDEN  = yes.
  F-DesFch:HIDDEN = yes.
  F-HasFch:HIDDEN = yes.
  ASSIGN COMBO-BOX-8.
  CASE COMBO-BOX-8:
       WHEN "Cliente" THEN
            wclient:HIDDEN = not wclient:HIDDEN.
       WHEN "Guía" THEN
            wguia:HIDDEN = not wguia:HIDDEN.
       WHEN "Fechas" THEN DO :
            F-DesFch:HIDDEN = not F-DesFch:HIDDEN.     
            F-HasFch:HIDDEN = not F-HasFch:HIDDEN.
       END.     
  END CASE.
  ASSIGN COMBO-BOX-8.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-HasFch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-HasFch B-table-Win
ON LEAVE OF F-HasFch IN FRAME F-Main /* Hasta */
or "RETURN":U of F-HasFch
DO:
  ASSIGN F-DesFch F-HasFch.
  RUN ABRIR-QUERY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME wclient
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wclient B-table-Win
ON LEAVE OF wclient IN FRAME F-Main /* Cliente */
or "RETURN":U of wclient
DO:
  ASSIGN WCLIENT.
  RUN ABRIR-QUERY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME wguia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wguia B-table-Win
ON LEAVE OF wguia IN FRAME F-Main /* # Guía */
or "RETURN":U of wguia
DO:
  IF INPUT wguia = "" THEN RETURN.
  find first CcbCdocu where CcbCdocu.NroDoc = substring(wguia:screen-value,1,3) +
             String(integer(substring(wguia:screen-value,5,6)),"999999") AND 
             integral.CcbCDocu.CodDoc = "G/R" AND
             integral.CcbCDocu.NomCli BEGINS wclient NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CcbCdocu THEN DO:
     MESSAGE " No. Guía NO EXISTE "
     VIEW-AS ALERT-BOX ERROR.
     wguia:screen-value = "".
     RETURN.
  END.        
  R-guia = RECID(CcbCdocu).
  REPOSITION BR_TABLE TO RECID R-guia.  
  RUN dispatch IN THIS-PROCEDURE('ROW-CHANGED':U). 
  IF ERROR-STATUS:ERROR THEN DO:
     MESSAGE " No. Guía NO EXISTE "
     VIEW-AS ALERT-BOX ERROR.
     wguia:screen-value = "".
     RETURN.
  END.
  wguia:SCREEN-VALUE = "".    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FlgEst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FlgEst B-table-Win
ON VALUE-CHANGED OF x-FlgEst IN FRAME F-Main
DO:
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
ON FIND OF CCBCDOCU  
DO:
    IF ccbcdocu.CodMon = 1 THEN
        ASSIGN
            X-MON = "S/." .
    ELSE
        ASSIGN
            X-MON = "US$" .
            
    IF CcbCdocu.FmaPgo = "000" THEN
       ASSIGN
            X-PAG = "CT".        
    ELSE
       ASSIGN
            X-PAG = "CR".
                    
    IF ccbcdocu.tipvta = "1" THEN
        ASSIGN
            X-VTA = "Factura".
    ELSE
        ASSIGN
            X-VTA = "Letra".            
END.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE abrir-query B-table-Win 
PROCEDURE abrir-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formato B-table-Win 
PROCEDURE formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE VAR s-printer-list AS CHAR.
 DEFINE VAR s-port-list AS CHAR.
 DEFINE VAR s-port-name AS CHAR format "x(20)".
 DEFINE VAR s-printer-count AS INTEGER.
 
 FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
     AND  FacCorre.CodDiv = S-CODDIV 
     AND  FacCorre.CodDoc = CcbcDocu.CodDoc 
     AND  FacCorre.NroSer = INTEGER(SUBSTRING(CcbcDocu.NroDoc,1,3))  NO-LOCK.

RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
IF s-port-name = '' THEN RETURN.

 /***************** Impresión *******************/
 
 DEFINE FRAME f-cab
        CcbcDocu.NroDoc FORMAT "XXX-XXXXXX"
        CcbcDocu.FchDoc 
        CcbcDocu.NomCli FORMAT "X(30)"
        CcbcDocu.RucCli FORMAT "X(8)"
        CcbcDocu.Codven FORMAT "X(4)"
        P-MON           FORMAT "X(4)"
        CcbcDocu.ImpBrt FORMAT "->,>>>,>>9.99"
        CcbcDocu.ImpDto FORMAT "->>,>>9.99"
        CcbcDocu.ImpVta FORMAT "->,>>>,>>9.99"
        CcbcDocu.ImpIgv FORMAT "->>,>>9.99"
        CcbcDocu.ImpTot FORMAT "->,>>>,>>9.99"
        P-EST           FORMAT "X(3)"
        HEADER
        {&PRN2} + S-NOMCIA + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} "( " + CcbcDocu.CodDiv + ")" + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN3} + "Pag.  : " AT 94 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + "RESUMEN DE GUIAS PENDIENTES DE FACTURAR " AT 40 FORMAT "X(45)" 
        {&PRN3} + "Fecha : " AT 104 FORMAT "X(12)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        "Hora  : " AT 124 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "    No.      FECHA                                                       T O T A L      TOTAL       VALOR                  P R E C I O        " SKIP
        "   GUIA     EMISION   C L I E N T E                   R.U.C.  VEND MON.    BRUTO        DSCTO.      VENTA       I.G.V.      V E N T A   ESTADO" SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

 {lib/_printer-stream-to.i 62 REPORT PAGED}
 PUT CONTROL {&PRN0} + {&PRN5A} + CHR(62) + {&PRN3}.       

 FOR EACH CcbcDocu NO-LOCK WHERE
     CcbcDocu.CodCia = S-CODCIA AND
     CcbcDocu.CodDiv = S-CODDIV AND
     CcbcDocu.CodDoc = "G/R"    AND
     CcbcDocu.flgest = "P"
     BY CcbcDocu.NroDoc:

     IF CcbcDocu.Codmon = 1 THEN P-MON = "S/.".
        ELSE P-MON = "US$.".
     IF CcbcDocu.FlgEst = "P" THEN P-EST = "PEN".   

     DISPLAY STREAM REPORT 
        CcbcDocu.NroDoc 
        CcbcDocu.FchDoc 
        CcbcDocu.NomCli 
        CcbcDocu.RucCli 
        CcbcDocu.Codven
        P-MON           
        CcbcDocu.ImpVta 
        CcbcDocu.ImpDto 
        CcbcDocu.ImpBrt 
        CcbcDocu.ImpIgv 
        CcbcDocu.ImpTot 
        P-EST WITH FRAME F-Cab.
 END.
 OUTPUT STREAM REPORT CLOSE.
 RUN abrir-query.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel B-table-Win 
PROCEDURE Genera-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE pto AS LOGICAL NO-UNDO.

EMPTY TEMP-TABLE t-ccbcdocu.
GET FIRST {&BROWSE-NAME}.
REPEAT WHILE AVAILABLE ccbcdocu:
    CREATE t-ccbcdocu.
    BUFFER-COPY ccbcdocu TO t-ccbcdocu.
    GET NEXT {&BROWSE-NAME}.
END.

FIND FIRST t-ccbcdocu NO-LOCK NO-ERROR.
IF NOT AVAILABLE t-ccbcdocu THEN RETURN ERROR.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

DEFINE VAR cMoneda  AS CHARACTER   NO-UNDO.
DEFINE VAR cPag     AS CHARACTER   NO-UNDO.


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* /* launch Excel so it is visible to the user */ */
/* chExcelApplication:Visible = TRUE.              */

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 3.
chWorkSheet:Columns("B"):ColumnWidth = 9.
chWorkSheet:Columns("C"):ColumnWidth = 40.
chWorkSheet:Columns("D"):ColumnWidth = 10.
chWorkSheet:Columns("E"):ColumnWidth = 10.
chWorkSheet:Columns("F"):ColumnWidth = 10.
chWorkSheet:Columns("G"):ColumnWidth = 10.
chWorkSheet:Columns("H"):ColumnWidth = 20.
chWorkSheet:Columns("I"):ColumnWidth = 20.
chWorkSheet:Columns("J"):ColumnWidth = 20.
chWorkSheet:Columns("K"):ColumnWidth = 20.

chWorkSheet:Range("A2"):Value = "Guia".
chWorkSheet:Range("B2"):Value = "Cod Cliente".
chWorkSheet:Range("C2"):Value = "Cliente".
chWorkSheet:Range("D2"):Value = "Vendedor".
chWorkSheet:Range("E2"):Value = "Fecha Emision".
chWorkSheet:Range("F2"):Value = "Fecha Vencimiento".
chWorkSheet:Range("G2"):Value = "Tpo Venta".
chWorkSheet:Range("H2"):Value = "Moneda".
chWorkSheet:Range("I2"):Value = "Importe Total".
chWorkSheet:Range("J2"):Value = "Usuario Anulacion".
chWorkSheet:Range("K2"):Value = "Fecha Anulacion".

FOR EACH t-ccbcdocu NO-LOCK
    BREAK BY t-ccbcdocu.nrodoc DESC :
    IF t-ccbcdocu.codmon = 1 THEN cMoneda = 'S/.'.
    ELSE cMoneda = '$USD'.
    IF t-CcbCdocu.FmaPgo = "000" THEN cPag = "CT".        
    ELSE cPag = "CR".

    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + t-ccbcdocu.nrodoc. 
    cRange = "B" + cColumn.                                                     
    chWorkSheet:Range(cRange):Value = t-ccbcdocu.codcli.   
    cRange = "C" + cColumn.                                
    chWorkSheet:Range(cRange):Value = t-ccbcdocu.nomcli.   
    cRange = "D" + cColumn.                                
    chWorkSheet:Range(cRange):Value = "'" + t-ccbcdocu.codven.                  
    cRange = "E" + cColumn.                                                     
    chWorkSheet:Range(cRange):Value = t-ccbcdocu.fchdoc.                        
    cRange = "F" + cColumn.                                                     
    chWorkSheet:Range(cRange):Value = t-ccbcdocu.fchvto.                        
    cRange = "G" + cColumn.                                                     
    chWorkSheet:Range(cRange):Value = cPag. 
    cRange = "H" + cColumn.                                                                                                                           
    chWorkSheet:Range(cRange):Value = cMoneda.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = t-ccbcdocu.imptot.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = t-CcbCDocu.UsuAnu.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = t-CcbCDocu.FchAnu.

    DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
    
END.
HIDE FRAME F-Proceso.

/*pto = SESSION:SET-WAIT-STATE("").*/

MESSAGE 'Proceso Terminado'
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.



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
  
  DO WITH FRAME F-MAIN :
    F-DesFch:SCREEN-VALUE = STRING(TODAY).
    F-HasFch:SCREEN-VALUE = STRING(TODAY).
    wclient:hidden = not wclient:hidden.
    F-DesFch:hidden = not F-DesFch:hidden.
    F-HasFch:hidden = not F-HasFch:hidden.
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
  {src/adm/template/snd-list.i "CcbCDocu"}
  {src/adm/template/snd-list.i "gn-clie"}
  {src/adm/template/snd-list.i "Ccbaudit"}
  {src/adm/template/snd-list.i "Ccbtabla"}

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
  Notes:  EN CASO DE ERROR RETORNAR : RETURN "ADM-ERROR"
------------------------------------------------------------------------------*/
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Consistenciar la modificacion de la fila
  Parameters:  Retornar "ADM-ERROR" en caso de bloquear la modificacion
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

