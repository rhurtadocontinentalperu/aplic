&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE TEMP-TABLE C-Detalle NO-UNDO LIKE Facdpedi.
DEFINE TEMP-TABLE Detalle NO-UNDO LIKE Facdpedi
       INDEX LLave01 AS PRIMARY CodCia CodMat.
DEFINE TEMP-TABLE T-DPEDI NO-UNDO LIKE FacDPedi.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'PED' NO-UNDO.

DEF SHARED VAR lh_handle AS HANDLE.

DEF VAR s-update-codmat AS LOG NO-UNDO.

DEF BUFFER b-Detalle FOR Detalle.
DEFINE VARIABLE clave AS CHARACTER FORMAT "x(20)" LABEL "Clave" NO-UNDO.

    /* Variable para el Tracking */
    DEFINE VAR s-FechaI AS DATETIME NO-UNDO.
    DEFINE VAR s-FechaT AS DATETIME NO-UNDO.

DEF VAR s-task-no AS INT NO-UNDO.

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
&Scoped-define INTERNAL-TABLES Detalle Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Detalle.NroItm Detalle.codmat ~
Almmmatg.DesMat Detalle.UndVta Detalle.CanPed 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table Detalle.codmat ~
Detalle.CanPed 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table Detalle
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table Detalle
&Scoped-define QUERY-STRING-br_table FOR EACH Detalle WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF Detalle NO-LOCK ~
    BY Detalle.codmat ~
       BY Detalle.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Detalle WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF Detalle NO-LOCK ~
    BY Detalle.codmat ~
       BY Detalle.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table Detalle Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Detalle
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-65 BUTTON-13 BUTTON-15 x-NroDoc ~
br_table 
&Scoped-Define DISPLAYED-OBJECTS x-NroDoc x-FchDoc x-CodCli x-NomCli ~
x-NroItem 

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
DEFINE BUTTON BUTTON-13 
     LABEL "Cerrar Pedido" 
     SIZE 13 BY 1.12.

DEFINE BUTTON BUTTON-15 
     LABEL "Nuevo Pedido" 
     SIZE 13 BY 1.12.

DEFINE VARIABLE x-CodCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha de emisión" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.

DEFINE VARIABLE x-NroDoc AS CHARACTER FORMAT "x(9)":U 
     LABEL "Nro. de Pedido" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-NroItem AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Nro Items" 
     VIEW-AS FILL-IN 
     SIZE 4.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 95 BY 2.96.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Detalle, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Detalle.NroItm FORMAT ">>9":U
      Detalle.codmat COLUMN-LABEL "Codigo" FORMAT "X(14)":U
      Almmmatg.DesMat FORMAT "X(45)":U
      Detalle.UndVta COLUMN-LABEL "Unidad" FORMAT "XXXX":U
      Detalle.CanPed FORMAT ">,>>>,>>9.9999":U
  ENABLE
      Detalle.codmat
      Detalle.CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 95 BY 10.77
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-13 AT ROW 1.27 COL 69 WIDGET-ID 4
     BUTTON-15 AT ROW 1.27 COL 82 WIDGET-ID 8
     x-NroDoc AT ROW 1.54 COL 12 COLON-ALIGNED
     x-FchDoc AT ROW 1.54 COL 56 COLON-ALIGNED
     x-CodCli AT ROW 2.62 COL 12 COLON-ALIGNED
     x-NomCli AT ROW 2.62 COL 25 COLON-ALIGNED NO-LABEL
     x-NroItem AT ROW 2.62 COL 88 COLON-ALIGNED WIDGET-ID 10
     br_table AT ROW 4.23 COL 1
     RECT-65 AT ROW 1 COL 1
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
   Temp-Tables and Buffers:
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: C-Detalle T "?" NO-UNDO INTEGRAL Facdpedi
      TABLE: Detalle T "?" NO-UNDO INTEGRAL Facdpedi
      ADDITIONAL-FIELDS:
          INDEX LLave01 AS PRIMARY CodCia CodMat
      END-FIELDS.
      TABLE: T-DPEDI T "?" NO-UNDO INTEGRAL FacDPedi
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
         HEIGHT             = 14.08
         WIDTH              = 96.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
/* BROWSE-TAB br_table x-NroItem F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN x-CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NroItem IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.Detalle,INTEGRAL.Almmmatg OF Temp-Tables.Detalle"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ","
     _OrdList          = "Temp-Tables.Detalle.codmat|yes,Temp-Tables.Detalle.NroItm|yes"
     _FldNameList[1]   = Temp-Tables.Detalle.NroItm
     _FldNameList[2]   > Temp-Tables.Detalle.codmat
"Detalle.codmat" "Codigo" "X(14)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[4]   > Temp-Tables.Detalle.UndVta
"Detalle.UndVta" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.Detalle.CanPed
"Detalle.CanPed" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME Detalle.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Detalle.codmat br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF Detalle.codmat IN BROWSE br_table /* Codigo */
DO:
/*   IF DECIMAL(Detalle.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 */
/*   THEN Detalle.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '1'.     */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Detalle.codmat br_table _BROWSE-COLUMN B-table-Win
ON F11 OF Detalle.codmat IN BROWSE br_table /* Codigo */
DO:
/*  DEF VAR x-codmat AS CHAR.
 *   DEF VAR x-canped AS DEC.
 *   
 *   RUN vta/d-chqgui (OUTPUT x-codmat, OUTPUT x-canped).
 *   IF X-CODMAT <> ? AND X-CANPED > 0 THEN DO:
 *     DISPLAY 
 *         x-codmat @ Detalle.Codmat 
 *         x-canped @ Detalle.CanPed
 *         WITH BROWSE {&BROWSE-NAME}.
 *     APPLY "RETURN" TO Detalle.CodMat IN BROWSE {&BROWSE-NAME}.   
 *   END.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Detalle.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Detalle.codmat IN BROWSE br_table /* Codigo */
DO:
  IF s-update-codmat = NO THEN RETURN.
  IF SELF:SCREEN-VALUE = '' THEN DO:
      s-update-codmat = NO.
      RETURN.
  END.

  /* Vamos a buscar primero el codigo de barras, luego el codigo interno */
  DEF VAR pCodMat LIKE Detalle.codmat.
  DEF VAR pCanPed LIKE Detalle.canped.

  pCodMat = SELF:SCREEN-VALUE.

  RUN alm/p-codbrr (INPUT-OUTPUT pCodMat, INPUT-OUTPUT pCanPed, s-codcia).

  ASSIGN
    SELF:SCREEN-VALUE = pCodMat
    NO-ERROR.
  IF pcodmat = '' THEN DO:
    Detalle.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '1'.
    RETURN NO-APPLY.
  END.
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = SELF:SCREEN-VALUE
    NO-LOCK.

  FIND T-DPEDI WHERE T-DPEDI.codmat = SELF:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE T-DPEDI THEN DO:
    MESSAGE 'Artículo NO registrado en el Pedido'
        VIEW-AS ALERT-BOX ERROR.
    SELF:SCREEN-VALUE = ''.
    Detalle.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '1'.
    RETURN NO-APPLY.
  END.
  DISPLAY
    Almmmatg.desmat 
    T-DPEDI.undvta @ Detalle.undvta
    pCanPed @ Detalle.CanPed
    WITH BROWSE {&BROWSE-NAME}.
/*   FIND Facdpedi WHERE Facdpedi.codcia = s-codcia                */
/*     AND Facdpedi.coddoc = s-coddoc                              */
/*     AND Facdpedi.nroped = x-nrodoc                              */
/*     AND Facdpedi.codmat = SELF:SCREEN-VALUE                     */
/*     NO-LOCK NO-ERROR.                                           */
/*   IF NOT AVAILABLE Facdpedi THEN DO:                            */
/*     MESSAGE 'Artículo NO registrado en el Pedido'               */
/*         VIEW-AS ALERT-BOX ERROR.                                */
/*     SELF:SCREEN-VALUE = ''.                                     */
/*     Detalle.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '1'. */
/*     RETURN NO-APPLY.                                            */
/*   END.                                                          */
/*                                                                 */
/*   DISPLAY                                                       */
/*     Almmmatg.desmat                                             */
/*     Facdpedi.undvta @ Detalle.undvta                            */
/*     pCanPed @ Detalle.CanPed                                    */
/*     WITH BROWSE {&BROWSE-NAME}.                                 */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Detalle.CanPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Detalle.CanPed br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF Detalle.CanPed IN BROWSE br_table /* Cantidad */
DO:
  IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN SELF:SCREEN-VALUE = '1'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 B-table-Win
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* Cerrar Pedido */
DO:
  MESSAGE 'Cerramos el Pedido?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN Cierre-de-guia.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  RUN Borra-Temporal.
  RUN Elimina-Items-Backup.
  ASSIGN
      x-CodCli = ''
      x-FchDoc = ?
      x-NomCli = ''
      x-NroDoc = ''
      x-NroDoc:SENSITIVE = YES.
  DISPLAY x-CodCli x-FchDoc x-NomCli x-NroDoc WITH FRAME {&FRAME-NAME}.
  APPLY 'ENTRY':U TO x-NroDoc IN FRAME {&FRAME-NAME}.
  RUN adm-open-query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-15 B-table-Win
ON CHOOSE OF BUTTON-15 IN FRAME F-Main /* Nuevo Pedido */
DO:
    MESSAGE 'Nuevo Pedido?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
    RUN Borra-Temporal.
    RUN Elimina-Items-Backup.
    ASSIGN
        x-NroDoc = '' x-NroDoc:SENSITIVE = YES
        x-CodCli = '' x-NomCli = '' x-FchDoc = ?
        x-NroItem = 0.
    DISPLAY 
        x-NroDoc
        x-CodCli
        x-NomCli
        x-FchDoc
        WITH FRAME {&FRAME-NAME}.
    RUN adm-open-query.
    APPLY 'ENTRY':U TO x-NroDoc IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroDoc B-table-Win
ON LEAVE OF x-NroDoc IN FRAME F-Main /* Nro. de Pedido */
OR RETURN OF {&SELF-NAME}
    DO:
        IF SELF:SCREEN-VALUE = '' THEN RETURN.
        FIND Faccpedi WHERE Faccpedi.codcia = s-codcia 
            AND Faccpedi.coddoc = s-coddoc
            /*AND Faccpedi.codalm = s-codalm*/
            AND Faccpedi.nroped = x-nrodoc:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN DO:
            MESSAGE 'Pedido NO registrado' VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = ''.
            RETURN NO-APPLY.
        END.
        IF NOT (Faccpedi.flgest = 'F') THEN DO:
            MESSAGE 'El pedido no se puede chequear' SKIP
                'Debe facturarlo primero'
                VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = ''.
            RETURN NO-APPLY.
        END.
        /*RD01- Verifica si pedido ya ha sido chequeado*/
        IF Faccpedi.flgsit = 'P' THEN DO:
            MESSAGE 'El pedido ya ha sido chequeado'                 
                VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = ''.
            RETURN NO-APPLY.
        END.

        FIND FIRST FacDPedi OF FacCPedi  WHERE FacDPedi.almdes = s-codalm 
            AND Facdpedi.Libre_c02 <> '*'
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE FacDPedi THEN DO:
            MESSAGE 'Pedido NO tiene items en este almacén' VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = ''.
            RETURN NO-APPLY.
        END.
        /* CHEQUEO DE TAREA DE SACADO CERRADA */
        FIND FIRST Vtatrack04 WHERE Vtatrack04.codcia = s-codcia
            AND VtaTrack04.CodAlm = s-codalm
            AND VtaTrack04.CodDoc = s-coddoc
            AND VtaTrack04.CodUbic = 'SMA'
            AND VtaTrack04.Libre_c01 <> 'C'
            AND VtaTrack04.NroPed = x-NroDoc:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTrack04 THEN DO:
            MESSAGE 'Aún no se ha cerrado el sacador' VtaTrack04.codper SKIP
                'del almacén' s-codalm 'del día' DATE(VtaTrack04.FechaI)
                VIEW-AS ALERT-BOX WARNING.
            RETURN NO-APPLY.
        END.
        /* ********************************* */
        IF x-NroDoc <> SELF:SCREEN-VALUE THEN DO:
            ASSIGN {&SELF-NAME}.
            RUN Calcula-NroItems.
            RUN Borra-Temporal.
            RUN Carga-con-kits.
            RUN Recarga-Items-Backup.
            RUN dispatch IN THIS-PROCEDURE ('open-query':U).
            ASSIGN
                x-fchdoc = Faccpedi.fchped
                x-codcli = Faccpedi.codcli
                x-nomcli = Faccpedi.nomcli.
            DISPLAY
                x-fchdoc
                x-codcli
                x-nomcli
                WITH FRAME {&FRAME-NAME}.
            x-NroDoc:SENSITIVE = NO.
        END.
        s-FechaI = DATETIME(TODAY, MTIME).
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF


ON 'RETURN':U OF Detalle.CodMat, Detalle.CanPed IN BROWSE {&BROWSE-NAME} DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Backup-Items B-table-Win 
PROCEDURE Borra-Backup-Items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF s-task-no = 0 THEN RETURN.
FIND w-report WHERE w-report.task-no = s-task-no
    AND w-report.Llave-C = s-coddoc + x-nrodoc
    AND w-report.Campo-C[1] = STRING(ROWID(Detalle))
    EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE w-report THEN RETURN.
DELETE w-report.
RELEASE w-report.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal B-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH Detalle:
    DELETE Detalle.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-NroItems B-table-Win 
PROCEDURE Calcula-NroItems :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iNroItems AS INTEGER     NO-UNDO.
    
    x-NroItem = 0.
    FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = s-codcia
        AND Facdpedi.coddoc = s-coddoc
        AND Facdpedi.nroped = x-nrodoc
        AND Facdpedi.almdes = s-codalm:
        iNroItems = iNroItems + 1.
    END.
    ASSIGN x-NroItem = iNroItems.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-con-kits B-table-Win 
PROCEDURE Carga-con-kits :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH T-DPEDI:
    DELETE T-DPEDI.
END.

FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = s-codcia
    AND Facdpedi.coddoc = s-coddoc
    AND Facdpedi.nroped = x-nrodoc
    AND Facdpedi.almdes = s-codalm:
    FIND Almckits OF Facdpedi NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almckits THEN DO:
        FIND T-DPEDI WHERE T-DPEDI.codmat = Facdpedi.codmat NO-ERROR.
        IF NOT AVAILABLE T-DPEDI THEN DO:
            CREATE T-DPEDI.
            ASSIGN
                T-DPEDI.codmat = Facdpedi.codmat
                T-DPEDI.canped = Facdpedi.canped
                T-DPEDI.undvta = Facdpedi.undvta.
        END.
        ELSE T-DPEDI.canped = T-DPEDI.canped + Facdpedi.canped.
    END.
    ELSE DO:
        FOR EACH Almdkits OF Almckits NO-LOCK,
            FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = Almdkits.codmat2:
            FIND T-DPEDI WHERE T-DPEDI.codmat = Almdkits.codmat2 NO-ERROR.
            IF NOT AVAILABLE T-DPEDI THEN DO:
                CREATE T-DPEDI.
                ASSIGN
                    T-DPEDI.codmat = AlmDKits.codmat2 
                    T-DPEDI.canped = AlmDKits.Cantidad * Facdpedi.canped * Facdpedi.factor
                    T-DPEDI.undvta = ALmmmatg.undbas.
            END.
            ELSE T-DPEDI.canped = T-DPEDI.canped + AlmDKits.Cantidad * Facdpedi.canped * Facdpedi.factor.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-de-guia B-table-Win 
PROCEDURE Cierre-de-guia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-UsrChq LIKE Faccpedi.usrchq NO-UNDO.
  
  
  /* Primero veamos si es consistente */
  FOR EACH C-Detalle:
    DELETE C-Detalle.
  END.
  
  /* Acumulamos por producto */
  FOR EACH Detalle:
    FIND C-Detalle WHERE C-Detalle.codmat = Detalle.codmat
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE C-Detalle THEN CREATE C-Detalle.
    BUFFER-COPY Detalle TO C-Detalle
        ASSIGN
            C-Detalle.canped = C-Detalle.canped + Detalle.canped.
  END.
  
  FOR EACH T-DPEDI:
    FIND C-Detalle WHERE C-Detalle.codmat = T-DPEDI.codmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE C-Detalle THEN DO:
        MESSAGE 'No se ha registrado el artículo' T-DPEDI.codmat
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF C-Detalle.CanPed <> T-DPEDI.CanPed THEN DO:
        MESSAGE 'Diferencia de cantidades en el artículo' SKIP T-DPEDI.codmat Almmmatg.desmat
            VIEW-AS ALERT-BOX ERROR.
        FIND FIRST detalle WHERE detalle.codmat = c-detalle.codmat.
        REPOSITION {&BROWSE-NAME} TO ROWID ROWID(Detalle).
        RETURN 'ADM-ERROR'.
    END.
  END.        
  RUN vtamay/d-chqped (OUTPUT x-UsrChq).
  IF x-UsrChq = '' THEN RETURN 'ADM-ERROR'.
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND LAST Faccpedi WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddoc = s-coddoc
        AND Faccpedi.nroped = x-nrodoc
        EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.
      IF Faccpedi.flgest = 'F'
      THEN DO:
          /* MARCAMOS LOS O/D COMO CERRADAS */
          FOR EACH B-CPEDI WHERE B-CPEDI.codcia = s-codcia
              AND B-CPEDI.codref = Faccpedi.coddoc
              AND B-CPEDI.nroref = Faccpedi.nroped:
              IF B-CPEDI.CodDoc = "O/D" AND B-CPEDI.DivDes = s-CodDiv
                  THEN B-CPEDI.FlgSit = "C".     /* Con Control de Barras */
          END.
          /* ****************************** */
          /* RASTREAMOS LOS COMPROBANTES */
          FOR EACH Ccbcdocu USE-INDEX Llave15 NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
              AND Ccbcdocu.codped = Faccpedi.coddoc
              AND Ccbcdocu.nroped = Faccpedi.nroped
              AND LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') > 0
              AND Ccbcdocu.flgest <> 'A'
              /*AND Ccbcdocu.codcli = Faccpedi.codcli*/
              AND Ccbcdocu.codalm = s-codalm:
              /* TRACKING */
              RUN vtagn/pTracking-04 (s-CodCia,
                              s-CodDiv,
                              Faccpedi.CodDoc,
                              Faccpedi.NroPed,
                              s-User-Id,
                              'VODB',
                              'P',
                              DATETIME(TODAY, MTIME),
                              DATETIME(TODAY, MTIME),
                              Ccbcdocu.CodDoc,
                              Ccbcdocu.NroDoc,
                              Ccbcdocu.CodDoc,
                              Ccbcdocu.NroDoc).
              s-FechaI = DATETIME(TODAY, MTIME).
              s-FechaT = DATETIME(TODAY, MTIME).
          END.
          /* MARCAMOS LOS ITEMS COMO CHEQUEADOS */
          FOR EACH Facdpedi OF Faccpedi WHERE Facdpedi.almdes = s-codalm:
              Facdpedi.Libre_c02 = '*'.
          END.
          FIND FIRST Facdpedi OF Faccpedi WHERE Facdpedi.Libre_c02 <> '*' NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Facdpedi THEN DO:
              ASSIGN 
                  Faccpedi.flgsit = 'P'
                  Faccpedi.UsrChq = x-usrchq
                  Faccpedi.FchChq = TODAY
                  Faccpedi.HorChq = STRING(TIME,'HH:MM').
          END.
      END.        
      RELEASE Faccpedi.
      RELEASE B-CPEDI.
  END.
  
  /* INICIALIZAMOS VARIABLES Y TEMPORALES */
  FOR EACH Detalle:
    DELETE Detalle.
  END.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable-campos B-table-Win 
PROCEDURE disable-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN
    BUTTON-13:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    BUTTON-15:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
                                     
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Elimina-Items-Backup B-table-Win 
PROCEDURE Elimina-Items-Backup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF s-task-no = 0 THEN RETURN.
FOR EACH w-report WHERE w-report.task-no = s-task-no
    AND w-report.Llave-C = s-coddoc + x-nrodoc:
    DELETE w-report.
END.
s-task-no = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable-campos B-table-Win 
PROCEDURE enable-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN
    BUTTON-13:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    BUTTON-15:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Backup-Items B-table-Win 
PROCEDURE Graba-Backup-Items :
/*------------------------------------------------------------------------------
  Purpose:     Guarda a inormacion en el temporal para recuperarla despues
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF s-task-no = 0 THEN DO:
    NUMERO:
    REPEAT:
        s-task-no = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK) THEN LEAVE NUMERO.
    END.
END.

RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'YES' THEN DO:
    CREATE w-report.
END.
ELSE DO:
    FIND w-report WHERE w-report.task-no = s-task-no
        AND w-report.Llave-C = s-coddoc + x-nrodoc
        AND w-report.Campo-C[1] = STRING(ROWID(Detalle))
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN RETURN.
END.
ASSIGN
    w-report.Task-No = s-task-no
    w-report.Llave-C = s-coddoc + x-nrodoc
    w-report.Campo-C[1] = STRING(ROWID(Detalle))
    w-report.LLave-I    = Detalle.NroItm
    w-report.Campo-C[2] = Detalle.codmat 
    w-report.Campo-C[3] = Detalle.UndVta
    w-report.Campo-F[1] = Detalle.CanPed.
RELEASE w-report.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF x-NroDoc = '' THEN DO:
    MESSAGE 'Debe ingresar primero el Pedido'
        VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  s-update-codmat = YES.
  RUN Procesa-Handle IN lh_handle ('disable-campos').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-Item AS INT INIT 1 NO-UNDO.
  
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
    DEF BUFFER B-DETA FOR Detalle.
    FOR EACH B-DETA NO-LOCK BY B-DETA.NroItm:
        x-Item = x-Item + 1.
    END.
  END.
  ELSE x-Item = Detalle.NroItm.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    Detalle.codcia = s-codcia
    Detalle.coddoc = s-coddoc
    Detalle.nroped = x-nrodoc
    Detalle.nroitm = x-item
    Detalle.undvta = T-DPEDI.undvta
    Detalle.canped = DECIMAL(Detalle.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

  RUN Graba-Backup-Items.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record B-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  s-update-codmat = NO.
  RUN Procesa-Handle IN lh_handle ('enable-campos').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Borra-Backup-Items.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Renumera-Item.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
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
  RUN Procesa-Handle IN lh_handle ('enable-campos').
  s-update-codmat = NO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recarga-Items-Backup B-table-Win 
PROCEDURE Recarga-Items-Backup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST w-report WHERE w-report.Llave-C = s-coddoc + x-nrodoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE w-report THEN RETURN.
s-task-no = w-report.task-no.
FOR EACH w-report WHERE w-report.task-no = s-task-no
    AND w-report.Llave-C = s-coddoc + x-nrodoc:
    FIND Facdpedi WHERE Facdpedi.codcia = s-codcia
        AND Facdpedi.coddoc = s-coddoc
        AND Facdpedi.nroped = x-nrodoc
        AND Facdpedi.codmat = w-report.Campo-C[2]
        NO-LOCK.
    IF Facdpedi.almdes <> s-codalm THEN NEXT.
    CREATE Detalle.
    ASSIGN
        Detalle.CodCia = s-codcia
        w-report.Campo-C[1] = STRING(ROWID(Detalle))
        Detalle.NroItm = w-report.LLave-I
        Detalle.codmat = w-report.Campo-C[2]
        Detalle.UndVta = w-report.Campo-C[3]
        Detalle.CanPed = w-report.Campo-F[1].
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Renumera-item B-table-Win 
PROCEDURE Renumera-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Item AS INT INIT 1 NO-UNDO.
  DEF BUFFER B-Detalle FOR Detalle.
  
  FOR EACH B-Detalle BY NroItm:
    B-Detalle.nroitm = x-item.
    RUN Graba-Backup-Items.
    x-item = x-item + 1.
  END.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  
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
  {src/adm/template/snd-list.i "Detalle"}
  {src/adm/template/snd-list.i "Almmmatg"}

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
  x-NroDoc:SENSITIVE IN FRAME {&FRAME-NAME} = NO .

  /* CHequeamos acumulado */
  DEF VAR x-CanPed AS DEC NO-UNDO.

  IF AVAILABLE Detalle THEN DO:
      FOR EACH b-Detalle NO-LOCK WHERE b-Detalle.codmat = Detalle.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}:
          x-CanPed = x-CanPed + b-Detalle.canped.
      END.
      x-CanPed = x-CanPed - Detalle.CanPed + DECIMAL(Detalle.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  END.
  ELSE DO:
      FOR EACH b-Detalle NO-LOCK WHERE b-Detalle.codmat = Detalle.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}:
          x-CanPed = x-CanPed + b-Detalle.canped.
      END.
      x-CanPed = x-CanPed + DECIMAL(Detalle.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  END.
  FIND T-DPEDI WHERE T-DPEDI.codmat = Detalle.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF AVAILABLE T-DPEDI AND x-CanPed > T-DPEDI.canped THEN DO:
    MESSAGE 'CANTIDAD ingresada SUPERA la del pedido'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  IF AVAILABLE T-DPEDI AND x-CanPed < T-DPEDI.canped THEN DO:
    MESSAGE 'CANTIDAD ingresada ES MENOR a la del pedido'
        VIEW-AS ALERT-BOX WARNING.
  END.



/*   FIND Facdpedi WHERE Facdpedi.codcia = s-codcia                               */
/*     AND Facdpedi.coddoc = s-coddoc                                             */
/*     AND Facdpedi.nroped = x-nrodoc                                             */
/*     AND Facdpedi.codmat = Detalle.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} */
/*     NO-LOCK NO-ERROR.                                                          */
/*   IF AVAILABLE Facdpedi AND x-CanPed > Facdpedi.canped THEN DO:                */
/*     MESSAGE 'CANTIDAD ingresada SUPERA la del pedido'                          */
/*         VIEW-AS ALERT-BOX ERROR.                                               */
/*     RETURN 'ADM-ERROR'.                                                        */
/*   END.                                                                         */
/*   IF AVAILABLE Facdpedi AND x-CanPed < Facdpedi.canped THEN DO:                */
/*     MESSAGE 'CANTIDAD ingresada ES MENOR a la del pedido'                      */
/*         VIEW-AS ALERT-BOX WARNING.                                             */
/*   END.                                                                         */

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
  /*RETURN "ADM-ERROR".*/
  s-update-codmat = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

