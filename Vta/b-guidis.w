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
DEFINE VAR W-ESTADO AS CHAR .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu gn-clie

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCDocu.FchDoc CcbCDocu.Flgsit CcbCDocu.NroDoc CcbCDocu.NomCli CcbCDocu.Dircli CcbCDocu.Glosa CcbCDocu.CodAge   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table CASE COMBO-BOX-8:SCREEN-VALUE IN FRAME {&FRAME-NAME} :      WHEN "Fechas" THEN DO :         OPEN QUERY {&SELF-NAME} FOR EACH CcbCDocu WHERE {&KEY-PHRASE}              AND CcbCDocu.CodCia = S-CODCIA              AND CcbCDocu.CodDiv = S-CODDIV              AND CcbCDocu.CodDoc = S-CODDOC              AND SubString(CcbCDocu.NroDoc, ~
      1, ~
      1) <> "S"              AND CcbCDocu.nomcli matches ("*" + wclient + "*")              AND CcbCDocu.FlgEst <> "A"              AND CcbCDocu.FlgSit BEGINS w-estado              AND CcbCDocu.FchDoc >= F-DesFch              AND CCbCDocu.FchDoc <= F-HasFch NO-LOCK, ~
                    FIRST gn-clie WHERE gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK                 BY CcbCDocu.FchDoc DESCENDING                 BY CcbCDocu.NroDoc DESCENDING              {&SORTBY-PHRASE}.      END.      OTHERWISE DO :         OPEN QUERY {&SELF-NAME} FOR EACH CcbCDocu WHERE {&KEY-PHRASE}              AND CcbCDocu.CodCia = S-CODCIA              AND CcbCDocu.CodDiv = S-CODDIV              AND CcbCDocu.CodDoc = S-CODDOC              AND SubString(CcbCDocu.NroDoc, ~
      1, ~
      1) <> "S"              AND CcbCDocu.nomcli matches ("*" + wclient + "*")              AND CcbCDocu.FlgEst <> "A"              AND CcbCDocu.FlgSit BEGINS w-estado NO-LOCK, ~
                    FIRST gn-clie WHERE gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK                 BY CcbCDocu.FchDoc DESCENDING                 BY CcbCDocu.NroDoc DESCENDING              {&SORTBY-PHRASE}.      END. END CASE.
&Scoped-define TABLES-IN-QUERY-br_table CcbCDocu gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-clie


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS wclient COMBO-BOX-8 f-tipo F-DesFch F-HasFch ~
wguia br_table 
&Scoped-Define DISPLAYED-OBJECTS wclient COMBO-BOX-8 f-tipo F-DesFch ~
F-HasFch wguia 

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


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-Distribucion 
       MENU-ITEM m_Actualizar_Datos LABEL "Actualizar Datos".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-8 AS CHARACTER FORMAT "X(256)":U INITIAL "Cliente" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Cliente","Guía","Fechas" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE f-tipo AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Est.Dist." 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "Todos","Pendiente","Enviado","Recepcionado" 
     DROP-DOWN-LIST
     SIZE 11 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

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

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCDocu, 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      CcbCDocu.FchDoc COLUMN-LABEL "     Fecha    !     Emisión"
      CcbCDocu.Flgsit Column-label "Estado"
      CcbCDocu.NroDoc COLUMN-LABEL " Guia" FORMAT "XXX-XXXXXXXX"
      CcbCDocu.NomCli FORMAT "x(44)"
      CcbCDocu.Dircli  Column-label "Direccion del Cliente"        
      CcbCDocu.Glosa  Column-label "Observaciones" Format "x(15)"
      CcbCDocu.CodAge Column-label "Transportista"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 86.57 BY 13.04
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     wclient AT ROW 1.31 COL 26 COLON-ALIGNED
     COMBO-BOX-8 AT ROW 1.35 COL 8.14 COLON-ALIGNED NO-LABEL
     f-tipo AT ROW 1.35 COL 74.29 COLON-ALIGNED
     F-DesFch AT ROW 1.42 COL 28.86 COLON-ALIGNED
     F-HasFch AT ROW 1.42 COL 50.57 COLON-ALIGNED
     wguia AT ROW 1.46 COL 28.86 COLON-ALIGNED
     br_table AT ROW 2.73 COL 1
     "Buscar x" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 1.5 COL 2
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
         HEIGHT             = 14.81
         WIDTH              = 87.14.
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
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table wguia F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-Distribucion:HANDLE.

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
             AND CcbCDocu.nomcli matches ("*" + wclient + "*")
             AND CcbCDocu.FlgEst <> "A"
             AND CcbCDocu.FlgSit BEGINS w-estado
             AND CcbCDocu.FchDoc >= F-DesFch
             AND CCbCDocu.FchDoc <= F-HasFch NO-LOCK,
             FIRST gn-clie WHERE gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK
                BY CcbCDocu.FchDoc DESCENDING
                BY CcbCDocu.NroDoc DESCENDING
             {&SORTBY-PHRASE}.
     END.
     OTHERWISE DO :
        OPEN QUERY {&SELF-NAME} FOR EACH CcbCDocu WHERE {&KEY-PHRASE}
             AND CcbCDocu.CodCia = S-CODCIA
             AND CcbCDocu.CodDiv = S-CODDIV
             AND CcbCDocu.CodDoc = S-CODDOC
             AND SubString(CcbCDocu.NroDoc,1,1) <> "S"
             AND CcbCDocu.nomcli matches ("*" + wclient + "*")
             AND CcbCDocu.FlgEst <> "A"
             AND CcbCDocu.FlgSit BEGINS w-estado NO-LOCK,
             FIRST gn-clie WHERE gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK
                BY CcbCDocu.FchDoc DESCENDING
                BY CcbCDocu.NroDoc DESCENDING
             {&SORTBY-PHRASE}.
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


&Scoped-define SELF-NAME f-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-tipo B-table-Win
ON VALUE-CHANGED OF f-tipo IN FRAME F-Main /* Est.Dist. */
DO:
  assign f-tipo.
  CASE f-tipo:screen-value :
       WHEN "Todos" THEN DO:
            w-estado = "".
       END.     
       WHEN "Pendiente"  THEN DO: 
            w-estado = "P". 
       END.            
       WHEN "Enviado" THEN DO: 
            w-estado = "E".
       END.     
       WHEN "Recepcionado"      THEN DO: 
            w-estado = "R".
       END.     
           
  END.          
  RUN ABRIR-QUERY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Actualizar_Datos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Actualizar_Datos B-table-Win
ON CHOOSE OF MENU-ITEM m_Actualizar_Datos /* Actualizar Datos */
DO:
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 1 THEN DO:
   MESSAGE "EL MENÚ CONTEXTUAL SOLO PROCESA UN REGISTRO" skip
           "EL BOTÓN ACTUALIZAR MULTIPLES REGISTROS PROCESA MÁS DE UN REGISTRO"
           VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
  END.

  IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
     RUN Vta/D-GuiDis.r({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NroDoc,"G/R").
     RUN Abrir-Query.
     RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME wclient
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wclient B-table-Win
ON LEAVE OF wclient IN FRAME F-Main /* Cliente */
or "RETURN":U of wclient
DO:
  ASSIGN WCLIENT = WCLIENT:screen-value.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Datos B-table-Win 
PROCEDURE Captura-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE I AS INTEGER NO-UNDO.
output-var-2 = "".
IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
   MESSAGE "No existen registros seleccionados" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
DO I = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
   IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(I) THEN DO:
      output-var-1 = ROWID( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} ).
         IF output-var-2 = "" THEN 
            output-var-2 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NroDoc.
         ELSE output-var-2 = output-var-2 + "," + {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NroDoc.
         output-var-3 = "".
   END.
  
END.
RUN Vta/D-GuiDis2.r(output-var-2,"G/R").
RUN Abrir-Query .
RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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

 RUN aderb/_prlist.p(
     OUTPUT s-printer-list,
     OUTPUT s-port-list,
     OUTPUT s-printer-count).


 FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                AND  FacCorre.CodDiv = S-CODDIV 
                AND  FacCorre.CodDoc = CcbcDocu.CodDoc 
                AND  FacCorre.NroSer = INTEGER(SUBSTRING(CcbcDocu.NroDoc,1,3))  
               NO-LOCK.
     
 IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
    MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
 END.

 s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
 s-port-name = REPLACE(S-PORT-NAME, ":", "").

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
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + CcbcDocu.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 94 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "RESUMEN DE GUIAS PENDIENTES DE FACTURAR " + {&PRN6B} AT 40 FORMAT "X(45)" 
        {&PRN3} + {&PRN6B} + "Fecha : " AT 104 FORMAT "X(12)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        "Hora  : " AT 124 STRING(TIME,"HH:MM:SS") + {&PRN6B} SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "    No.      FECHA                                                       T O T A L      TOTAL       VALOR                  P R E C I O        " SKIP
        "   GUIA     EMISION   C L I E N T E                   R.U.C.  VEND MON.    BRUTO        DSCTO.      VENTA       I.G.V.      V E N T A   ESTADO" SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
 OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
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
    wguia:hidden = not wguia:hidden.
/*    wclient:hidden = not wclient:hidden.*/
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

