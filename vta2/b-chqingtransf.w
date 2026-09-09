&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CMOV FOR Almcmov.
DEFINE BUFFER B-DMOV FOR Almdmov.
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
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR lh_handle AS HANDLE.
DEF SHARED VAR s-codalm AS CHAR.

DEF VAR s-update-codmat AS LOG NO-UNDO.

DEFINE VAR x-timedesde AS INT.
DEFINE VAR x-timehasta AS INT.

DEF BUFFER b-Detalle FOR Detalle.
DEFINE VARIABLE clave AS CHARACTER FORMAT "x(20)" LABEL "Clave" NO-UNDO.

DEF VAR s-task-no AS INT NO-UNDO.
DEF VAR x-HorIni LIKE faccpedi.horsac NO-UNDO.
DEF VAR x-FchIni LIKE faccpedi.fecsac NO-UNDO.

DEF VAR x-CodDoc AS CHAR INIT "G/R" NO-UNDO.

FIND FIRST Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
     Almtmovm.Tipmov = "I" AND
     Almtmovm.CodMov = 03
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtmovm THEN DO:
   MESSAGE "No existe movimiento 03 de Ingreso por Transferencias" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
/* CHEQUEAMOS LA CONFIGURACION DE CORRELATIVOS */
FIND FIRST Almtdocm WHERE Almtdocm.CodCia = S-CODCIA AND
     Almtdocm.CodAlm = S-CODALM AND
     Almtdocm.TipMov = "I" AND
     Almtdocm.Codmov = Almtmovm.Codmov NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtdocm THEN DO:
   MESSAGE "No esta asignado el movimiento 03" SKIP
           "de Ingreso por Transferencias al almacen" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES Almcmov
&Scoped-define FIRST-EXTERNAL-TABLE Almcmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almcmov.
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
    BY Detalle.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Detalle WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF Detalle NO-LOCK ~
    BY Detalle.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table Detalle Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Detalle
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-65 BUTTON-13 BUTTON-15 x-NroDoc ~
FILL-IN_Observ txtTTrans br_table 
&Scoped-Define DISPLAYED-OBJECTS x-FchDoc x-NroDoc FILL-IN-Almacen ~
x-NroItem FILL-IN_Observ txtTTxx txtTTrans 

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


/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE ocxTimer AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chocxTimer AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-13 
     LABEL "Cerrar G/R" 
     SIZE 13 BY 1.12.

DEFINE BUTTON BUTTON-15 
     LABEL "Nueva G/R" 
     SIZE 13 BY 1.12.

DEFINE VARIABLE FILL-IN-Almacen AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén Origen" 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Observ AS CHARACTER FORMAT "X(50)" 
     LABEL "Observaciones" 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE txtTTrans AS CHARACTER FORMAT "X(60)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 24 BY 1.65
     BGCOLOR 15 FGCOLOR 12 FONT 8 NO-UNDO.

DEFINE VARIABLE txtTTxx AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 48.86 BY 1.65
     BGCOLOR 15 FGCOLOR 12 FONT 8 NO-UNDO.

DEFINE VARIABLE x-FchDoc AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha de emisión" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-NroDoc AS CHARACTER FORMAT "x(14)":U 
     LABEL "Nro. de G/R" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-NroItem AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Nro Items" 
     VIEW-AS FILL-IN 
     SIZE 4.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 95 BY 3.65.

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
      Detalle.UndVta COLUMN-LABEL "Unidad" FORMAT "XXXXXXX":U WIDTH 8.72
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
     x-FchDoc AT ROW 1.54 COL 56 COLON-ALIGNED
     x-NroDoc AT ROW 1.58 COL 12 COLON-ALIGNED
     FILL-IN-Almacen AT ROW 2.54 COL 12 COLON-ALIGNED WIDGET-ID 14
     x-NroItem AT ROW 2.62 COL 88 COLON-ALIGNED WIDGET-ID 10
     FILL-IN_Observ AT ROW 3.5 COL 12 COLON-ALIGNED HELP
          "Observaciones" WIDGET-ID 16
     txtTTxx AT ROW 5.04 COL 51.86 RIGHT-ALIGNED NO-LABEL WIDGET-ID 20
     txtTTrans AT ROW 5.04 COL 50.57 COLON-ALIGNED WIDGET-ID 24
     br_table AT ROW 7.08 COL 1.14
     RECT-65 AT ROW 1 COL 1
     SPACE(0.00) SKIP(2.82)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.Almcmov
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CMOV B "?" ? INTEGRAL Almcmov
      TABLE: B-DMOV B "?" ? INTEGRAL Almdmov
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
         HEIGHT             = 17.23
         WIDTH              = 96.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
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
/* BROWSE-TAB br_table txtTTrans F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Almacen IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       txtTTrans:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN txtTTxx IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
ASSIGN 
       txtTTxx:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN x-FchDoc IN FRAME F-Main
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
     _OrdList          = "Temp-Tables.Detalle.NroItm|yes"
     _FldNameList[1]   = Temp-Tables.Detalle.NroItm
     _FldNameList[2]   > Temp-Tables.Detalle.codmat
"Temp-Tables.Detalle.codmat" "Codigo" "X(14)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[4]   > Temp-Tables.Detalle.UndVta
"Temp-Tables.Detalle.UndVta" "Unidad" "XXXXXXX" "character" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.Detalle.CanPed
"Temp-Tables.Detalle.CanPed" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME ocxTimer ASSIGN
       FRAME           = FRAME F-Main:HANDLE
       ROW             = 3.62
       COLUMN          = 77.57
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 22
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      ocxTimer:NAME = "ocxTimer":U .
/* ocxTimer OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      ocxTimer:MOVE-AFTER(FILL-IN_Observ:HANDLE IN FRAME F-Main).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


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
    MESSAGE 'Artículo NO registrado en la Guia'
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
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* Cerrar G/R */
DO:
  MESSAGE 'Cerramos la Orden?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN Cierre-de-guia.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  RUN Borra-Temporal.
  RUN Elimina-Items-Backup.
  ASSIGN
      x-FchDoc = ?
      x-NroDoc = ''
      FILL-IN_Observ = ''
      x-NroDoc:SENSITIVE = YES
      FILL-IN_Observ:SENSITIVE = YES.
  DISPLAY x-FchDoc x-NroDoc FILL-IN_Observ WITH FRAME {&FRAME-NAME}.
  APPLY 'ENTRY':U TO x-NroDoc IN FRAME {&FRAME-NAME}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-15 B-table-Win
ON CHOOSE OF BUTTON-15 IN FRAME F-Main /* Nueva G/R */
DO:
    MESSAGE 'Nuevo Pedido?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
    RUN Borra-Temporal.
    RUN Elimina-Items-Backup.
    ASSIGN
        x-NroDoc = '' x-NroDoc:SENSITIVE = YES
        x-FchDoc = ?
        x-NroItem = 0.
    DISPLAY 
        x-NroDoc
        x-FchDoc
        WITH FRAME {&FRAME-NAME}.
    RUN adm-open-query.
    APPLY 'ENTRY':U TO x-NroDoc IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ocxTimer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ocxTimer B-table-Win OCX.Tick
PROCEDURE ocxTimer.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR ztime AS INT.

x-timehasta = TIME.

zTime = x-timehasta - x-timedesde.
DO WITH FRAME {&FRAME-NAME}:
    txtTTrans:SCREEN-VALUE = STRING(ztime,"HH:MM:SS").
    txtTTxx:SCREEN-VALUE = "Tiempo transcurrido ".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroDoc B-table-Win
ON ENTRY OF x-NroDoc IN FRAME F-Main /* Nro. de G/R */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        txtTTrans:VISIBLE = FALSE.
        txtTTxx:VISIBLE = FALSE.
        /*ocxTimer:ENABLED = FALSE.*/
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroDoc B-table-Win
ON LEAVE OF x-NroDoc IN FRAME F-Main /* Nro. de G/R */
OR RETURN OF {&SELF-NAME}
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    /* RUTINA CON EL SCANNER */
    CASE SUBSTRING(SELF:SCREEN-VALUE,1,1):
      WHEN '9' THEN DO:           /* G/R */
          ASSIGN SELF:SCREEN-VALUE = SUBSTRING(SELF:SCREEN-VALUE,2,3) + SUBSTRING(SELF:SCREEN-VALUE,6,6).
      END.
    END CASE.
    /* buscamos en los almacenes de la división actual */
    DEF VAR x-Ok AS LOG NO-UNDO.

    x-Ok = NO.
    FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia:
        FIND Almcmov WHERE Almcmov.codcia = s-codcia 
            AND Almcmov.codalm = Almacen.codalm
            AND Almcmov.almdes = s-codalm
            AND Almcmov.tipmov = "S"
            AND Almcmov.codmov = 03
            AND Almcmov.nroser = INTEGER(SUBSTRING(x-nrodoc:SCREEN-VALUE, 1, 3))
            AND Almcmov.nrodoc = INTEGER(SUBSTRING(x-nrodoc:SCREEN-VALUE, 4))
            AND Almcmov.flgest <> "A"
            AND Almcmov.flgsit = "T"
            AND Almcmov.codref <> "OTR"     /* OJO */
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almcmov THEN DO:
            x-Ok = YES.
            LEAVE.
        END.
    END.
    IF x-Ok = NO THEN DO:
        MESSAGE 'Guia por Transferencia NO registrada o anulada' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    /*RD01- Verifica si la orden ya ha sido chequeado*/
/*     IF Almcmov.Libre_c02 = 'C' THEN DO:                                           */
/*         MESSAGE 'Guia de Transferencia YA fue chequeada' VIEW-AS ALERT-BOX ERROR. */
/*         DISPLAY x-NroDoc WITH FRAME {&FRAME-NAME}.                                */
/*         RETURN NO-APPLY.                                                          */
/*     END.                                                                          */
    IF x-NroDoc <> SELF:SCREEN-VALUE THEN DO:
        /* Arranca el ciclo */
        x-timedesde = TIME.
        txtTTrans:VISIBLE = TRUE.            
        txtTTxx:VISIBLE = TRUE.

        ASSIGN
            x-FchIni = TODAY
            x-HorIni = STRING(TIME, 'HH:MM').
        ASSIGN {&SELF-NAME}.
        RUN Calcula-NroItems.
        RUN Borra-Temporal.
        RUN Carga-con-kits.
        RUN Recarga-Items-Backup.
        RUN dispatch IN THIS-PROCEDURE ('open-query':U).
        FIND Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = Almcmov.codalm
            NO-LOCK.
        ASSIGN
            x-fchdoc = Almcmov.fchdoc.
        DISPLAY
            x-fchdoc
            Almacen.Descripcion @ FILL-IN-Almacen
            WITH FRAME {&FRAME-NAME}.
        x-NroDoc:SENSITIVE = NO.
    END.
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

txtTTrans:VISIBLE = FALSE.
txtTTxx:SCREEN-VALUE = "Tiempo transcurrido :".
txtTTxx:VISIBLE = FALSE.

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "Almcmov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almcmov"}

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
    AND w-report.Llave-C = x-coddoc + x-nrodoc
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

  EMPTY TEMP-TABLE Detalle.
  
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
    FOR EACH Almdmov OF Almcmov NO-LOCK:
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

EMPTY TEMP-TABLE T-DPEDI.

/* RHC 13.07.2012 CARGAMOS TODO EN UNIDADES DE STOCK 
    NO LE AFECTA A LAS VENTAS AL CREDITO 
*/
FOR EACH Almdmov OF Almcmov NO-LOCK,
    FIRST Almmmatg OF Almdmov NO-LOCK:
    FIND T-DPEDI WHERE T-DPEDI.codmat = Almdmov.codmat NO-ERROR.
    IF NOT AVAILABLE T-DPEDI THEN DO:
        CREATE T-DPEDI.
        ASSIGN
            T-DPEDI.CodCia = Almdmov.codcia
            T-DPEDI.CodMat = Almdmov.codmat
            T-DPEDI.UndVta = Almmmatg.UndStk
            T-DPEDI.CanPed = Almdmov.candes * Almdmov.factor.
    END.
    ELSE T-DPEDI.canped = T-DPEDI.canped + Almdmov.candes * Almdmov.factor.
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
  DEF VAR x-UsrChq AS CHAR NO-UNDO.  
  
  /* Primero veamos si es consistente */
  EMPTY TEMP-TABLE c-Detalle.
  
  /* Acumulamos por producto */
  FOR EACH Detalle:
    FIND C-Detalle WHERE C-Detalle.codmat = Detalle.codmat
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE C-Detalle THEN CREATE C-Detalle.
    BUFFER-COPY Detalle TO C-Detalle
        ASSIGN
            C-Detalle.canped = C-Detalle.canped + Detalle.canped.
  END.
  
  FOR EACH T-DPEDI, FIRST Almmmatg OF T-DPEDI NO-LOCK:
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

  DEF VAR x-Ok AS LOG NO-UNDO.
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR'
      WITH FRAME {&FRAME-NAME}:
      x-Ok = NO.
      FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia:
          FIND B-CMOV WHERE B-CMOV.codcia = s-codcia 
              AND B-CMOV.codalm = Almacen.codalm
              AND B-CMOV.almdes = s-codalm
              AND B-CMOV.tipmov = "S"
              AND B-CMOV.codmov = 03
              AND B-CMOV.nroser = INTEGER(SUBSTRING(x-nrodoc:SCREEN-VALUE, 1, 3))
              AND B-CMOV.nrodoc = INTEGER(SUBSTRING(x-nrodoc:SCREEN-VALUE, 4))
              AND B-CMOV.flgest <> "A"
              AND B-CMOV.flgsit = "T"
              EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE B-CMOV THEN DO:
              x-Ok = YES.
              LEAVE.
          END.
      END.
      IF x-Ok = NO THEN DO:
          MESSAGE 'Guia por Transferencia NO registrada o anulada' VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.

      ASSIGN
          x-NroDoc FILL-IN-Almacen FILL-IN_Observ.

      FIND CURRENT Almtdocm EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
      CREATE Almcmov.
      ASSIGN 
          Almcmov.usuario = S-USER-ID
          Almcmov.NroDoc  = Almtdocm.NroDoc
          Almtdocm.NroDoc = Almtdocm.NroDoc + 1
          Almcmov.CodCia  = Almtdocm.CodCia 
          Almcmov.CodAlm  = Almtdocm.CodAlm 
          Almcmov.TipMov  = Almtdocm.TipMov 
          Almcmov.CodMov  = Almtdocm.CodMov 
          Almcmov.NroSer  = 000
          Almcmov.FlgSit  = ""
          Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
          Almcmov.NomRef  = FILL-IN-Almacen           
          Almcmov.Nrorf1  = x-NroDoc
          Almcmov.AlmDes  = B-CMOV.codalm
          Almcmov.Observ  = FILL-IN_Observ.
      RUN Genera-Detalle.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      RUN alm/sal-trf-vir (ROWID(Almcmov), '999').
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      ASSIGN 
          B-CMOV.FlgSit  = "R" 
          B-CMOV.HorRcp  = STRING(TIME,"HH:MM:SS")
          B-CMOV.NroRf2  = STRING(Almcmov.NroDoc).

      MESSAGE 'Desea Imprmir el Documento?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
            IF rpta = NO THEN RETURN NO-APPLY.

        /* Ic - 12May2015, Impresion desde aqui */
         IF AVAILABLE Almcmov AND 
            Almcmov.FlgEst <> "A" THEN RUN ALM\R-IMPFMT.R(ROWID(almcmov)).

      FIND CURRENT Almtdocm NO-LOCK NO-ERROR.
      IF AVAILABLE(B-CMOV) THEN RELEASE B-CMOV.
      IF AVAILABLE(Almcmov) THEN RELEASE Almcmov.
      IF AVAILABLE(Almdmov) THEN RELEASE Almdmov.
      IF AVAILABLE(Almmmate) THEN RELEASE Almmmate.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load B-table-Win  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "b-chqingtransf.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chocxTimer = ocxTimer:COM-HANDLE
    UIB_S = chocxTimer:LoadControls( OCXFile, "ocxTimer":U)
  .
  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.
ELSE MESSAGE "b-chqingtransf.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

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
    AND w-report.Llave-C = x-coddoc + x-nrodoc:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato B-table-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle B-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR F-PesUnd AS DECIMAL NO-UNDO.
  DEFINE VAR R-ROWID  AS ROWID.

  FOR EACH B-DMOV OF B-CMOV NO-LOCK:
      CREATE almdmov.
      ASSIGN 
          Almdmov.CodCia = Almcmov.CodCia 
          Almdmov.CodAlm = Almcmov.CodAlm 
          Almdmov.TipMov = Almcmov.TipMov 
          Almdmov.CodMov = Almcmov.CodMov 
          Almdmov.NroSer = Almcmov.NroSer 
          Almdmov.NroDoc = Almcmov.NroDoc 
          Almdmov.CodMon = Almcmov.CodMon 
          Almdmov.FchDoc = Almcmov.FchDoc 
          Almdmov.TpoCmb = Almcmov.TpoCmb
          Almdmov.codmat = B-DMOV.codmat
          Almdmov.CanDes = B-DMOV.CanDes
          Almdmov.CodUnd = B-DMOV.CodUnd
          Almdmov.Factor = B-DMOV.Factor
          Almdmov.ImpCto = B-DMOV.ImpCto 
          Almdmov.PreUni = B-DMOV.PreUni 
          Almdmov.AlmOri = Almcmov.AlmDes 
          Almdmov.HraDoc = Almcmov.HorRcp
                 R-ROWID = ROWID(Almdmov).
      RUN ALM\ALMACSTK (R-ROWID).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      /*
      RUN ALM\ALMACPR1 (R-ROWID,"U").
      RUN ALM\ALMACPR2 (R-ROWID,"U").
      */
      /* RHC 03.04.04 REACTIVAMOS KARDEX POR ALMACEN */
      RUN alm/almacpr1 (R-ROWID, 'U').
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
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
        AND w-report.Llave-C = x-coddoc + x-nrodoc
        AND w-report.Campo-C[1] = STRING(ROWID(Detalle))
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN RETURN.
END.
ASSIGN
    w-report.Task-No = s-task-no
    w-report.Llave-C = x-coddoc + x-nrodoc
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
    Detalle.coddoc = x-coddoc
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          BUTTON-13:SENSITIVE = YES
          BUTTON-15:SENSITIVE = YES.
  END.

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
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          BUTTON-13:SENSITIVE = NO
          BUTTON-15:SENSITIVE = NO.
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

FIND FIRST w-report WHERE w-report.Llave-C = x-coddoc + x-nrodoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE w-report THEN RETURN.
s-task-no = w-report.task-no.
FOR EACH w-report WHERE w-report.task-no = s-task-no
    AND w-report.Llave-C = x-coddoc + x-nrodoc:
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
  {src/adm/template/snd-list.i "Almcmov"}
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

  x-NroDoc:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
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

