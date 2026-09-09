&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-Almacen FOR Almacen.
DEFINE BUFFER B-gn-clie FOR gn-clie.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

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
DEFINE SHARED VAR s-acceso-total  AS LOG.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR cl-codcia AS INTEGER.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-DESALM AS CHAR.
DEFINE SHARED VAR S-CODMOV AS INTEGER.
DEFINE SHARED VAR ORDTRB   AS CHAR.
DEFINE SHARED VAR s-status-almacen AS LOG.
DEFINE SHARED VAR S-CODDIV AS CHAR.

/* Variables para enviar un mensaje si ha sido un cross docking */
DEF VAR x-CrossDocking AS LOG INIT NO NO-UNDO.
DEF VAR x-MsgCrossDocking AS CHAR NO-UNDO.
/* ************************************************************ */
DEFINE        VAR C-DESALM AS CHAR.
DEFINE        VAR I-CODMON AS INTEGER.
DEFINE        VAR R-ROWID  AS ROWID.
DEFINE        VAR D-FCHDOC AS DATE.
DEFINE        VAR F-TPOCMB AS DECIMAL.
DEFINE        VAR I-NRO    AS INTEGER NO-UNDO.
DEFINE        VAR S-OBSER  AS CHAR NO-UNDO.
DEFINE        VAR I-MOVORI AS INTEGER NO-UNDO.
DEFINE        VAR pMensaje AS CHAR NO-UNDO.

DEFINE SHARED TEMP-TABLE ITEM LIKE almdmov.

DEFINE BUFFER TDOCM FOR Almtdocm.
DEFINE BUFFER CMOV  FOR Almcmov.
DEFINE BUFFER B-DMOV FOR Almdmov.

DEFINE STREAM Reporte.

DEFINE VARIABLE F-TOTORI AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-TOTDES AS DECIMAL NO-UNDO.

FIND FIRST Almtmovm WHERE Almtmovm.CodCia = S-CODCIA 
                     AND  Almtmovm.Tipmov = "S" 
                     AND  Almtmovm.MovTrf 
                    NO-LOCK NO-ERROR.
IF AVAILABLE Almtmovm THEN I-MOVORI = Almtmovm.CodMov.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\AUXILIAR" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS INTEGER  FORMAT "9999" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Transfiriendo ..." FONT 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES Almcmov Almtdocm
&Scoped-define FIRST-EXTERNAL-TABLE Almcmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almcmov, Almtdocm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almcmov.CrossDocking Almcmov.AlmDes ~
Almcmov.NroRf1 Almcmov.NroRf2 Almcmov.NroRf3 Almcmov.Observ ~
Almcmov.AlmacenXD Almcmov.CodAlm 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define DISPLAYED-FIELDS Almcmov.CrossDocking Almcmov.AlmDes ~
Almcmov.NroRf1 Almcmov.NroRf2 Almcmov.NroRf3 Almcmov.Observ Almcmov.NroDoc ~
Almcmov.FchDoc Almcmov.usuario Almcmov.AlmacenXD Almcmov.CodAlm 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-NomDes FILL-IN-Motivo ~
FILL-IN-AlmacenXD F-NomAlm 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .81
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-NomAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE F-NomDes AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-AlmacenXD AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Motivo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Motivo" 
     VIEW-AS FILL-IN 
     SIZE 59 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Urgente AS CHARACTER FORMAT "X(256)":U INITIAL "URGENTE" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 0 FGCOLOR 14 FONT 6 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almcmov.CrossDocking AT ROW 5.04 COL 96 WIDGET-ID 48
          LABEL "Cross Docking"
          VIEW-AS TOGGLE-BOX
          SIZE 16 BY .77
          BGCOLOR 14 FGCOLOR 0 FONT 10
     F-Estado AT ROW 1.81 COL 94 COLON-ALIGNED NO-LABEL
     Almcmov.AlmDes AT ROW 1.81 COL 13 COLON-ALIGNED
          LABEL "Almacen Origen" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     F-NomDes AT ROW 1.81 COL 22 COLON-ALIGNED NO-LABEL
     Almcmov.NroRf1 AT ROW 2.62 COL 94 COLON-ALIGNED
          LABEL "Referencia 1" FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almcmov.NroRf2 AT ROW 3.42 COL 94 COLON-ALIGNED
          LABEL "Referencia 2"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almcmov.NroRf3 AT ROW 4.23 COL 94 COLON-ALIGNED
          LABEL "Pedido Comercial" FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     Almcmov.Observ AT ROW 3.42 COL 13 COLON-ALIGNED
          LABEL "Observaciones" FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 59 BY .81
     Almcmov.NroDoc AT ROW 1 COL 13 COLON-ALIGNED
          LABEL "No. Documento" FORMAT "9999999"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
          FONT 0
     Almcmov.FchDoc AT ROW 1 COL 94 COLON-ALIGNED FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almcmov.usuario AT ROW 4.23 COL 13 COLON-ALIGNED
          LABEL "Usuario" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FILL-IN-Motivo AT ROW 5.04 COL 13 COLON-ALIGNED WIDGET-ID 44
     FILL-IN-Urgente AT ROW 1 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     Almcmov.AlmacenXD AT ROW 5.85 COL 13 COLON-ALIGNED WIDGET-ID 50
          LABEL "Destino Final"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     FILL-IN-AlmacenXD AT ROW 5.85 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     Almcmov.CodAlm AT ROW 2.62 COL 13 COLON-ALIGNED WIDGET-ID 54
          LABEL "Almacén Destino"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     F-NomAlm AT ROW 2.62 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 56
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Almcmov,integral.Almtdocm
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-Almacen B "?" ? INTEGRAL Almacen
      TABLE: B-gn-clie B "?" ? INTEGRAL gn-clie
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 6.65
         WIDTH              = 121.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Almcmov.AlmacenXD IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.AlmDes IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.CodAlm IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX Almcmov.CrossDocking IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-AlmacenXD IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Motivo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Urgente IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-Urgente:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN Almcmov.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Almcmov.NroRf1 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.NroRf2 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf3 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.Observ IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Almcmov.AlmacenXD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.AlmacenXD V-table-Win
ON LEAVE OF Almcmov.AlmacenXD IN FRAME F-Main /* Destino Final */
DO:
    FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia 
        AND  Almacen.CodAlm = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN FILL-IN-AlmacenXD:SCREEN-VALUE = Almacen.Descripcion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.AlmDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.AlmDes V-table-Win
ON LEAVE OF Almcmov.AlmDes IN FRAME F-Main /* Almacen Origen */
DO:
  FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia 
      AND  Almacen.CodAlm = Almcmov.AlmDes:SCREEN-VALUE  
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN F-NomDes:SCREEN-VALUE = Almacen.Descripcion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodAlm V-table-Win
ON LEAVE OF Almcmov.CodAlm IN FRAME F-Main /* Almacén Destino */
DO:
    FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia 
        AND  Almacen.CodAlm = Almcmov.CodAlm:SCREEN-VALUE  
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN F-NomAlm:SCREEN-VALUE = Almacen.Descripcion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.NroRf1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.NroRf1 V-table-Win
ON LEAVE OF Almcmov.NroRf1 IN FRAME F-Main /* Referencia 1 */
DO:
   IF Almcmov.NroRf1:SCREEN-VALUE = "" THEN RETURN.
   FIND CMOV WHERE 
        CMOV.CodCia = S-CODCIA AND 
        CMOV.CodAlm = Almcmov.AlmDes:SCREEN-VALUE AND
        CMOV.TipMov = "S" AND
        CMOV.CodMov = I-MOVORI AND
        CMOV.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1:SCREEN-VALUE,1,3)) AND
        CMOV.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1:SCREEN-VALUE,5,6)) NO-LOCK NO-ERROR.
   IF NOT AVAILABLE CMOV THEN DO:
      MESSAGE "Numero de guia no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   IF CMOV.FlgSit  = "R" THEN DO:
      MESSAGE "Numero de guia ya fue recepcionada" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   IF CMOV.AlmDes  <> S-CODALM THEN DO:
      MESSAGE "Numero de guia no corresponde al almacen" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   IF CMOV.Flgest ="A" THEN DO:
      MESSAGE "Numero de guia ya fue Anulado" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   DISPLAY 
       CMOV.NroRf1 @ Almcmov.NroRf2 
       /*STRING(CMOV.Nrorf3,"999") + STRING(CMOV.NroDoc,"9999999") @ Almcmov.Nrorf3 */
       WITH FRAME {&FRAME-NAME}.
   ORDTRB = CMOV.Nrorf3 .
   Almcmov.Nrorf1:SENSITIVE = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-ITEM V-table-Win 
PROCEDURE Actualiza-ITEM :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER I-EST AS INTEGER.

EMPTY TEMP-TABLE ITEM.
IF I-EST = 2 THEN DO:
   FOR EACH Almdmov NO-LOCK WHERE 
            Almdmov.CodCia = Almcmov.CodCia AND  
            Almdmov.CodAlm = Almcmov.CodAlm AND  
            Almdmov.TipMov = Almcmov.TipMov AND  
            Almdmov.CodMov = Almcmov.CodMov AND  
            Almdmov.NroSer = Almcmov.NroSer AND  
            Almdmov.NroDoc = Almcmov.NroDoc:
       CREATE ITEM.
       BUFFER-COPY Almdmov TO ITEM.
   END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "Almtdocm"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almcmov"}
  {src/adm/template/row-find.i "Almtdocm"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalle V-table-Win 
PROCEDURE Borra-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Eliminamos el detalle para el almacen de Destino */
  FOR EACH Almdmov EXCLUSIVE-LOCK WHERE Almdmov.CodCia = Almcmov.CodCia 
                                   AND  Almdmov.CodAlm = Almcmov.CodAlm 
                                   AND  Almdmov.TipMov = Almcmov.TipMov 
                                   AND  Almdmov.CodMov = Almcmov.CodMov 
                                   AND  Almdmov.NroSer = Almcmov.NroSer 
                                   AND  Almdmov.NroDoc = Almcmov.NroDoc 
                                  ON ERROR UNDO, RETURN "ADM-ERROR":
           ASSIGN R-ROWID = ROWID(Almdmov).
           RUN ALM\ALMDCSTK (R-ROWID).   /* Descarga del Almacen POR INGRESOS */
           IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
           /*
           RUN ALM\ALMACPR1 (R-ROWID,"D").
           RUN ALM\ALMACPR2 (R-ROWID,"D").
           */
           /* RHC 03.04.04 REACTIVAMOS KARDEX POR ALMACEN */
           RUN alm/almacpr1 (R-ROWID, 'D').
           IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      DELETE Almdmov.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel V-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
DEF VAR x-CtoTot LIKE Almmmatg.ctotot NO-UNDO.
DEF VAR x-PreVta LIKE Almmmatg.prevta NO-UNDO.
DEF VAR x-PreOfi LIKE Almmmatg.preofi NO-UNDO.

ASSIGN
    chWorkSheet:Range("A1"):Value = "CONTINENTAL - INGRESO POR TRANSFERENCIA"
    chWorkSheet:Range("A2"):Value = "ALMACEN"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Range("B2"):Value = "SERIE"
    chWorkSheet:Range("C2"):Value = "NUMERO"
    chWorkSheet:Range("D2"):Value = "FECHA"
    chWorkSheet:Columns("D"):NumberFormat = "mm/dd/yyyy"
    chWorkSheet:Range("E2"):Value = "ORIGEN"
    chWorkSheet:Columns("E"):NumberFormat = "@"
    chWorkSheet:Range("F2"):Value = "OBSERVACIONES"
    chWorkSheet:Range("G2"):Value = "USUARIO"
    chWorkSheet:Range("H2"):Value = "REFERENCIA 1"
    chWorkSheet:Columns("H"):NumberFormat = "@"
    chWorkSheet:Range("I2"):Value = "REFERENCIA 2"
    chWorkSheet:Columns("I"):NumberFormat = "@"
    chWorkSheet:Range("J2"):Value = "ARTICULO"
    chWorkSheet:Columns("J"):NumberFormat = "@"
    chWorkSheet:Range("K2"):Value = "CANTIDAD"
    chWorkSheet:Range("L2"):Value = "UNIDAD"
    chWorkSheet:Range("M2"):Value = "FACTOR".

ASSIGN
    t-Row = 2.
FOR EACH almdmov OF almcmov NO-LOCK:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almdmov.codalm.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almdmov.nroser.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almdmov.nrodoc.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almdmov.fchdoc.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almcmov.AlmDes.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almcmov.observ.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almcmov.usuario.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almcmov.nrorf1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almcmov.nrorf2.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almdmov.codmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almdmov.candes.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almdmov.codund.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almdmov.factor.
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH ITEM WHERE ITEM.codmat <> "" ON ERROR UNDO, RETURN "ADM-ERROR":
      CREATE almdmov.
      ASSIGN Almdmov.CodCia = Almcmov.CodCia 
             Almdmov.CodAlm = Almcmov.CodAlm 
             Almdmov.TipMov = Almcmov.TipMov 
             Almdmov.CodMov = Almcmov.CodMov 
             Almdmov.NroSer = Almcmov.NroSer 
             Almdmov.NroDoc = Almcmov.NroDoc 
             Almdmov.CodMon = Almcmov.CodMon 
             Almdmov.FchDoc = Almcmov.FchDoc 
             Almdmov.TpoCmb = Almcmov.TpoCmb 
             Almdmov.codmat = ITEM.codmat 
             Almdmov.CanDes = ITEM.CanDes 
             Almdmov.CodUnd = ITEM.CodUnd 
             Almdmov.Factor = ITEM.Factor 
             Almdmov.ImpCto = ITEM.ImpCto 
             Almdmov.PreUni = ITEM.PreUni 
             Almdmov.AlmOri = Almcmov.AlmDes 
             Almdmov.CodAjt = '' 
             Almdmov.HraDoc = HorRcp
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
      
      F-TOTDES = F-TOTDES + Almdmov.CanDes.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle-Origen V-table-Win 
PROCEDURE Genera-Detalle-Origen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH ITEM:
       CREATE almdmov.
       ASSIGN Almdmov.CodCia = Almcmov.CodCia 
              Almdmov.CodAlm = Almcmov.CodAlm 
              Almdmov.TipMov = Almcmov.TipMov 
              Almdmov.CodMov = Almcmov.CodMov 
              Almdmov.NroDoc = Almcmov.NroDoc 
              Almdmov.CodMon = Almcmov.CodMon 
              Almdmov.FchDoc = Almcmov.FchDoc 
              Almdmov.TpoCmb = Almcmov.TpoCmb
              Almdmov.codmat = ITEM.codmat
              Almdmov.CanDes = ITEM.CanDes
              Almdmov.CodUnd = ITEM.CodUnd
              Almdmov.Factor = ITEM.Factor
              Almdmov.ImpCto = ITEM.ImpCto
              Almdmov.PreUni = ITEM.PreUni
              Almdmov.Pesmat = ITEM.Pesmat
              Almdmov.AlmOri = Almcmov.AlmDes 
              Almdmov.CodAjt = ''
              R-ROWID = ROWID(Almdmov).
              
       RUN ALM\ALMDGSTK (R-ROWID).
       RUN ALM\ALMACPR1 (R-ROWID,"U").
       RUN ALM\ALMACPR2 (R-ROWID,"U").
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       Solo se aceptan movimientos por CrossDocking
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF s-status-almacen = NO THEN DO:
      MESSAGE 'Almacén INACTIVO' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  /* ************************************************************************************************ */
  /* RHC 09/04/18 NO si es un almacén de Cross Docking */
  /* ************************************************************************************************ */
  FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen AND Almacen.Campo-C[1] = "XD" THEN DO:
      MESSAGE "Estamos en un almacén de CROSSDOCKING" SKIP
          "Acceso Denegado" VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  /* ************************************************************************************************ */
  /* ************************************************************************************************ */
  RUN LKUP/C-TRFSAL.
  IF output-var-1 = ? THEN RETURN "ADM-ERROR".
  FIND CMOV WHERE ROWID(CMOV) = output-var-1 NO-LOCK NO-ERROR.
  /* ************************************************************************************************ */
  /* Verificamos si debe pasar por BARRAS o no*/
  /* ************************************************************************************************ */
  DEFINE BUFFER y-almacen FOR almacen.
  DEFINE BUFFER z-almacen FOR almacen.
  DEFINE VAR x-divsal AS CHAR.
  DEFINE VAR x-diving AS CHAR.
  FIND FIRST z-almacen WHERE z-almacen.codcia = s-codcia AND 
      z-almacen.codalm = cmov.codalm NO-LOCK NO-ERROR.
  IF AVAILABLE z-almacen THEN x-divsal = z-almacen.coddiv.
  FIND FIRST y-almacen WHERE y-almacen.codcia = s-codcia AND 
      y-almacen.codalm = cmov.almdes NO-LOCK NO-ERROR.
  IF AVAILABLE y-almacen THEN x-diving = y-almacen.coddiv.
  /* Si las divisiones son iguales => TRANSFERENCIA INTERNA ENTRE ALMACENES DE LA MISMA DIVISION */
  /* La Guia de referencia NO es MANUAL => CONTROL DE CROSSDOCKING */
  /* Las divisiones son diferentes => CONTROL DE CROSSDOCKING */
  IF (x-divsal <> x-diving) THEN DO:
      /* ************************************************************************************************ */
      /* Consistencia si existe un Almacén de Cross Docking para esta división */
      /* ************************************************************************************************ */
      IF CMOV.CrossDocking = YES THEN DO:
          IF NOT CAN-FIND(FIRST Almacen WHERE Almacen.codcia = s-codcia
                          AND Almacen.coddiv = s-coddiv
                          AND Almacen.campo-C[9] <> "I"
                          AND Almacen.Campo-C[1] = "XD" NO-LOCK) THEN DO:
              MESSAGE 'NO está definido el almacén de CROSS DOCKING' VIEW-AS ALERT-BOX INFORMATION.
              RETURN 'ADM-ERROR'.
          END.
      END.
      ELSE DO:
          /* RHC 06/06/2019 DEBE SER UNA GUIA DE TRANSFERENCIA MANUAL */
          IF NOT (CMOV.CodRef <> "OTR") THEN DO:
              MESSAGE 'Solo se aceptan movimientos por CrossDocking' VIEW-AS ALERT-BOX INFORMATION.
              RETURN 'ADM-ERROR'.
          END.
/*           /* RHC 09/04/2019 NO pasa*/                                                           */
/*           MESSAGE 'Solo se aceptan movimientos por CrossDocking' VIEW-AS ALERT-BOX INFORMATION. */
/*           RETURN 'ADM-ERROR'.                                                                   */
      END.
  END.
  /* *************************************************************************************** */
  /* *************************************************************************************** */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      F-TOTORI = 0
      F-TOTDES = 0.
  RUN Actualiza-ITEM (1).
  
  DO WITH FRAME {&FRAME-NAME}:
      /* Información del Origen */
      FIND CMOV WHERE ROWID(CMOV) = output-var-1 NO-LOCK NO-ERROR.
      DISPLAY 
          TODAY       @ Almcmov.FchDoc
          CMOV.AlmDes @ Almcmov.CodAlm
          CMOV.CodAlm @ Almcmov.AlmDes
          STRING(CMOV.NroSer, '999') + STRING(CMOV.NroDoc) @ Almcmov.NroRf1
          CMOV.nrorf3 @ Almcmov.Nrorf3
          CMOV.AlmacenXD @ Almcmov.AlmacenXD
          .
      ASSIGN
          Almcmov.CrossDocking:SCREEN-VALUE = STRING(CMOV.CrossDocking).
      APPLY 'LEAVE':U TO Almcmov.CodAlm.
      APPLY 'LEAVE':U TO Almcmov.AlmDes.
      APPLY 'LEAVE':U TO Almcmov.AlmacenXD.
      /* Pinta Correlativo */
      FIND Almtdocm WHERE Almtdocm.CodCia = S-CODCIA
          AND  Almtdocm.CodAlm = Almcmov.CodAlm:SCREEN-VALUE    /*S-CODALM*/
          AND  Almtdocm.TipMov = "I"
          AND  Almtdocm.CodMov = S-CODMOV
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almtdocm THEN DO:
          MESSAGE 'NO está configurado el movimiento de transferencia en el almacén' Almcmov.CodAlm:SCREEN-VALUE
              SKIP 'Proceso Abortado' VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
      DISPLAY Almtdocm.NroDoc @ Almcmov.NroDoc.
      /* Motivo */
      FIND FacTabla WHERE FacTabla.CodCia = CMOV.codcia
          AND FacTabla.Tabla = 'REPOMOTIVO'
          AND FacTabla.Codigo = CMOV.Libre_C05
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacTabla THEN DISPLAY FacTabla.Nombre @ FILL-IN-Motivo.
      /* Urgente */
      IF CMOV.Libre_L02 = YES THEN DO:
          FILL-IN-Urgente:VISIBLE = YES.
          FILL-IN-Urgente:SCREEN-VALUE = 'URGENTE'.
      END.
      ELSE FILL-IN-Urgente:VISIBLE = NO.
      
      /* Detalle */
      FOR EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = CMOV.CodCia 
          AND  Almdmov.CodAlm = CMOV.CodAlm 
          AND  Almdmov.TipMov = CMOV.TipMov 
          AND  Almdmov.CodMov = CMOV.CodMov 
          AND  Almdmov.NroSer = CMOV.NroSer
          AND  Almdmov.NroDoc = CMOV.NroDoc:
          CREATE ITEM.
          ASSIGN 
              ITEM.CodCia = Almdmov.CodCia
              ITEM.CodAlm = Almdmov.CodAlm
              ITEM.codmat = Almdmov.codmat 
              ITEM.PreUni = Almdmov.PreUni 
              ITEM.CanDes = Almdmov.CanDes 
              ITEM.Factor = Almdmov.Factor 
              ITEM.ImpCto = Almdmov.ImpCto
              ITEM.CodUnd = Almdmov.CodUnd.
          F-TOTORI = F-TOTORI + Almdmov.CanDes.
      END.  
      
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('browse').
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       Solamente se puden crear documentos, no se puden modificar
------------------------------------------------------------------------------*/
  
  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR r-Rowid AS ROWID.
  DEF VAR x-NroDoc AS INT NO-UNDO.
  DEF VAR pComprobante AS CHAR NO-UNDO.

  DEF BUFFER ORDEN  FOR FacCPedi.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /*RUN lib\p-write-log-txt.r("INGALMXOTR","INICIO:Rutina-Cross-Docking").*/

  /* Code placed here will execute AFTER standard behavior.    */
  IF CMOV.CrossDocking = YES THEN DO:
      
      RUN Rutina-Cross-Docking.
      IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
      
      x-CrossDocking = YES.
  END.
  ELSE DO:

      RUN Rutina-Normal.
      IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".

      x-CrossDocking = NO.
  END.
  DISPLAY Almcmov.NroDoc WITH FRAME {&FRAME-NAME}.
  

  RUN Genera-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      pMensaje = "NO se pudo grabar el detalle de la transferencia".
      UNDO, RETURN 'ADM-ERROR'.
  END.

  FIND CURRENT CMOV EXCLUSIVE-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      pMensaje = ERROR-STATUS:GET-MESSAGE(1).
      UNDO, RETURN 'ADM-ERROR'.
  END.
  IF CMOV.FlgSit <> "T" THEN DO:
      pMensaje = 'NO se puede hacer la transferencia' +  CHR(10) + 
          'La guia ha sido alterada' + CHR(10) +
          'Revisar el documento original en el sistema'.
      UNDO, RETURN "ADM-ERROR".
  END.
  ASSIGN 
      CMOV.FlgSit  = "R" 
      CMOV.HorRcp  = STRING(TIME,"HH:MM:SS")
      CMOV.NroRf2  = STRING(Almcmov.NroDoc).
  IF F-TOTORI <> F-TOTDES THEN ASSIGN CMOV.FlgEst = "D".
  ASSIGN
      Almcmov.Libre_L02 = CMOV.Libre_L02    /* URGENTE */
      Almcmov.Libre_C05 = CMOV.Libre_C05.   /* MOTIVO */
  /* ********************************************************************* */
  /* RHC 21/12/2017 MIGRACION DE ORDENES DE DESPACHO DEL ORIGEN AL DESTINO */
  /* ********************************************************************* */
  DEFINE VAR hProc AS HANDLE NO-UNDO.
  RUN gn/xd-library PERSISTENT SET hProc.
  IF CMOV.CrossDocking = YES THEN DO:
      FIND ORDEN WHERE ORDEN.codcia = s-codcia 
          AND ORDEN.coddoc = CMOV.codref 
          AND ORDEN.nroped = CMOV.nroref NO-LOCK NO-ERROR.
      CASE TRUE:
          WHEN ORDEN.CodRef = "R/A" THEN DO:

              RUN XD_Migra-RA IN hProc (Almcmov.CodAlm,      /* Almacén de Origen */
                                        Almcmov.AlmacenXD,   /* Almacén de Destino */
                                        CMOV.CodRef,         /* OTR */
                                        CMOV.NroRef,         /* Número de la OTR */
                                        OUTPUT pComprobante,    
                                        OUTPUT pMensaje).
              IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                  IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo migrar la OTR'.
                  UNDO, RETURN 'ADM-ERROR'.
              END.

              /* ****************************************** */
              /* RHC 18/08/18 Almacenamos la OTR del ORIGEN */
              /* ****************************************** */
              ASSIGN
                  Almcmov.CodRef = CMOV.CodRef
                  Almcmov.NroRef = CMOV.NroRef.
              /* ****************************************** */
          END.
          WHEN ORDEN.CodRef = "PED" THEN DO:

              RUN XD_Migra-OTR IN hProc (Almcmov.CodAlm,         /* Almacén de Origen */
                                         CMOV.CodRef,         /* OTR */
                                         CMOV.NroRef,         /* Número de la OTR */
                                         OUTPUT pComprobante,    
                                         OUTPUT pMensaje).
              IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                  IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo migrar el PED'.
                  UNDO, RETURN 'ADM-ERROR'.
              END.

          END.
      END CASE.
      x-MsgCrossDocking = "Se generó el movimiento de ingreso en el almacén: " + Almcmov.codalm +
          CHR(10) + "Se generó también el documento: " + pComprobante.
      /*pMensaje = ''.*/
  END.
  DELETE PROCEDURE hProc.
  /* ********************************************************************* */
  /* RHC 28/10/2020 Genera PEDIDO LOGISTICO en forma automática */
  /* ********************************************************************* */

  RUN pri/p-gen-ped-por-ing-trf.r (INPUT ROWID(Almcmov), OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar el PEDIDO LOGISTICO'.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  /* ********************************************************************* */
  /* RHC 01/12/17 Log para e-Commerce */
  /* ********************************************************************* */
  DEF VAR pOk AS LOG NO-UNDO.
  RUN gn/log-inventory-qty.p (ROWID(Almcmov),
                              "C",      /* CREATE */
                              OUTPUT pOk).
  IF pOk = NO THEN DO:
      pMensaje = "NO se pudo actualizar el log de e-Commerce".
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* ********************************************************************* */
  IF AVAILABLE(Almtdocm) THEN RELEASE Almtdocm.
  IF AVAILABLE(CMOV)     THEN RELEASE CMOV.
  IF AVAILABLE(Almdmov)  THEN RELEASE Almdmov.
  IF AVAILABLE(Almmmate) THEN RELEASE Almmmate.

  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('browse').  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF s-status-almacen = NO THEN DO:
      MESSAGE 'Almacén INACTIVO' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  
  DEF VAR RPTA AS CHARACTER.

  IF NOT AVAILABLE Almcmov THEN DO:
      MESSAGE "No existe registros" VIEW-AS ALERT-BOX INFORMATION.
      RETURN "ADM-ERROR".
  END.

  IF Almcmov.FlgEst = 'A' THEN DO:
      MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX INFORMATION.
      RETURN "ADM-ERROR".
  END.
  IF Almcmov.FlgSit = '*' THEN DO:
      MESSAGE "NO se puede anular una transferencia automatica al almacén virtual" 
          VIEW-AS ALERT-BOX INFORMATION.
      RETURN "ADM-ERROR".
  END.
  /* RHC 18/04/2018 */
  IF Almcmov.CrossDocking = YES THEN DO:
      MESSAGE 'NO se puede anular un ingreso por CROSS DOCKING' VIEW-AS ALERT-BOX INFORMATION.
      RETURN 'ADM-ERROR'.
  END.
  /* RHC 24/04/2019 */
  IF INDEX(Almcmov.Observ, 'INCIDENCIA') > 0 THEN DO:
      MESSAGE 'NO se puede anular un ingreso por INCIDENCIA' VIEW-AS ALERT-BOX INFORMATION.
      RETURN 'ADM-ERROR'.
  END.
  /* 29-8-2023: S.Leon */
  DEF VAR dFchCie AS DATE.

  dFchCie = TODAY.
  IF s-acceso-total = NO THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
   END.
   ELSE DO:
       RUN gn/fFchCieCbd ('ALMACEN', OUTPUT dFchCie).
       IF almcmov.fchdoc < dFchCie THEN DO:
           MESSAGE 'No se puede anular movimientos de almacén' SKIP
               'generados hasta el' (dFchCie - 1) 'por cierre contable'
               VIEW-AS ALERT-BOX WARNING.
           RETURN 'ADM-ERROR'.
       END.
   END.

  /* Solo marcamos el FlgEst como Anulado */
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
/*       IF Almcmov.CrossDocking = YES THEN DO:                              */
/*           RUN vta2/pextornaordendesp.p ( ROWID(Almcmov) ).                */
/*           IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                          */
/*               MESSAGE "NO se pudo extornar la OTR por Cross Docking" SKIP */
/*                   "Proceso Abortado" VIEW-AS ALERT-BOX ERROR.             */
/*               UNDO, RETURN 'ADM-ERROR'.                                   */
/*           END.                                                            */
/*       END.                                                                */
      /* RHC 01/12/17 Log para e-Commerce */
      DEF VAR pOk AS LOG NO-UNDO.
      RUN gn/log-inventory-qty.p (ROWID(Almcmov),
                                  "D",      /* DELETE */
                                  OUTPUT pOk).
      IF pOk = NO THEN DO:
          MESSAGE "NO se pudo actualizar el log de e-Commerce" SKIP
              "Proceso Abortado" VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      /* ******************************** */
      RUN Borra-Detalle.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia 
         AND  CMOV.CodAlm = Almcmov.CodAlm 
         AND  CMOV.TipMov = Almcmov.TipMov 
         AND  CMOV.CodMov = Almcmov.CodMov 
         AND  CMOV.NroDoc = Almcmov.NroDoc 
         EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN 
         CMOV.FlgEst = 'A'
         CMOV.Observ = "      A   N   U   L   A   D   O       "
         CMOV.Usuario = S-USER-ID.

      FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia 
         AND  CMOV.CodAlm = Almcmov.AlmDes 
         AND  CMOV.TipMov = "S" 
         AND  CMOV.CodMov = I-MOVORI 
         AND  CMOV.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1,1,3)) 
         AND  CMOV.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1,4)) 
         EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN 
         CMOV.FlgSit  = "T"
         CMOV.HorRcp  = STRING(TIME,"HH:MM:SS").
      /* ************************* */
      IF AVAILABLE(CMOV) THEN RELEASE CMOV.
      IF AVAILABLE(Almdmov) THEN RELEASE Almdmov.
  END.
  /* refrescamos los datos del browse */
  RUN Procesa-Handle IN lh_Handle ('browse').
  /* refrescamos los datos del viewer */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Buscamos en la tabla de movimientos y pedimos datos segun lo configurado*/
  FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almtdocm.CodCia 
                       AND  Almtmovm.Tipmov = Almtdocm.TipMov 
                       AND  Almtmovm.Codmov = Almtdocm.CodMov 
                      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN DO WITH FRAME {&FRAME-NAME}:
     ASSIGN Almcmov.NroRf1:VISIBLE = Almtmovm.PidRef1
            Almcmov.NroRf2:VISIBLE = Almtmovm.PidRef2
                          I-CODMON = Almtmovm.CodMon.
     IF Almtmovm.PidRef1 THEN ASSIGN Almcmov.NroRf1:LABEL = Almtmovm.GloRf1 .
     IF Almtmovm.PidRef2 THEN ASSIGN Almcmov.NroRf2:LABEL = Almtmovm.GloRf2.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almcmov THEN DO WITH FRAME {&FRAME-NAME}:
      /* Almacen DESTINO */
      FIND Almacen WHERE Almacen.CodCia = s-CodCia 
          AND  Almacen.CodAlm = Almcmov.codalm  
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN F-NomAlm:SCREEN-VALUE = Almacen.Descripcion.
      ELSE F-NomDes:SCREEN-VALUE = "".

     /* Almacen ORIGEN */
     FIND Almacen WHERE Almacen.CodCia = s-CodCia 
         AND  Almacen.CodAlm = Almcmov.AlmDes  
         NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN F-NomDes:SCREEN-VALUE = Almacen.Descripcion.
     ELSE F-NomDes:SCREEN-VALUE = "".

     F-Estado:SCREEN-VALUE = "".
     IF Almcmov.FlgEst  = "A" THEN F-Estado:SCREEN-VALUE = "  ANULADO   ".  

     /* Motivo */
     FIND FacTabla WHERE FacTabla.CodCia = Almcmov.codcia
         AND FacTabla.Tabla = 'REPOMOTIVO'
         AND FacTabla.Codigo = Almcmov.Libre_c05
         NO-LOCK NO-ERROR.
     IF AVAILABLE FacTabla THEN DISPLAY FacTabla.Nombre @ FILL-IN-Motivo.

     /* Urgente */
     IF Almcmov.Libre_L02 = YES THEN DO:
         FILL-IN-Urgente:VISIBLE = YES.
         FILL-IN-Urgente:SCREEN-VALUE = 'URGENTE'.
     END.
     ELSE FILL-IN-Urgente:VISIBLE = NO.

     /* Cross Docking */
     FILL-IN-AlmacenXD:SCREEN-VALUE = ''.
     IF Almcmov.AlmacenXD > '' THEN DO:
         FIND Almacen WHERE Almacen.codcia = s-codcia
             AND Almacen.codalm = Almcmov.AlmacenXD
             NO-LOCK NO-ERROR.
         IF AVAILABLE Almacen THEN FILL-IN-AlmacenXD:SCREEN-VALUE = Almacen.Descripcion.
         ELSE DO:
             FIND gn-clie WHERE gn-clie.codcia = cl-codcia
                 AND gn-clie.codcli = Almcmov.AlmacenXD
                 NO-LOCK NO-ERROR.
             IF AVAILABLE gn-clie THEN FILL-IN-AlmacenXD:SCREEN-VALUE = gn-clie.nomcli.
         END.
     END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
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
      DISABLE 
          Almcmov.AlmDes 
          Almcmov.CodAlm 
          Almcmov.NroRf1 
          Almcmov.NroRf2
          Almcmov.NroRf3
          Almcmov.AlmacenXD 
          Almcmov.CrossDocking.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*-----------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  /*
  IF AVAILABLE Almcmov AND 
     Almcmov.FlgEst <> "A" THEN RUN ALM\R-IMPFMT.R(ROWID(almcmov)).
  */
  IF AVAILABLE Almcmov AND 
     Almcmov.FlgEst <> "A" THEN RUN ALM\R-IMPFMT-1.R(ROWID(almcmov), NO).       /* Ic - 18Jun2024 */

     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  pMensaje = "".
  x-CrossDocking = NO.
  x-MsgCrossDocking = ''.
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF pMensaje <> "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  IF x-CrossDocking = YES THEN DO:
      MESSAGE x-MsgCrossDocking VIEW-AS ALERT-BOX INFORMATION.
      RUN Procesa-Handle IN lh_handle ("Last-Record").
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
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
        WHEN "" THEN .
    END CASE.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesar-Documento-Origen V-table-Win 
PROCEDURE Procesar-Documento-Origen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reasigna-Pedidos V-table-Win 
PROCEDURE Reasigna-Pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE CMOV OR CMOV.CodRef <> "OTR" THEN RETURN "OK".
FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
    AND Faccpedi.coddoc = CMOV.codref   /* OTR */
    AND Faccpedi.nroped = CMOV.nroref
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi OR Faccpedi.CodRef <> "O/D" THEN RETURN "OK".

DEF BUFFER PEDIDO FOR Faccpedi.
DEF BUFFER ORDENES FOR Faccpedi.

/* Barremos las O/D */
DEF VAR k AS INT NO-UNDO.
DO k = 1 TO NUM-ENTRIES(Faccpedi.NroRef) ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND ORDENES WHERE ORDENES.codcia = Faccpedi.codcia
        AND ORDENES.coddoc = Faccpedi.codref
        AND ORDENES.nroped = ENTRY(k, Faccpedi.nroref)
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        IF LOCKED(ORDENES) OR AMBIGUOUS(ORDENES) THEN RETURN 'ADM-ERROR'.
        RETURN 'OK'.
    END.
    ASSIGN
        ORDENES.FlgEst = "P"
        ORDENES.FlgSit = "T".   /* Falta Pre-Picking */
    ASSIGN
        ORDENES.codalm = "11e"
        ORDENES.divdes = "00000".
    FOR EACH Facdpedi OF ORDENES:
        ASSIGN Facdpedi.almdes = ORDENES.codalm.
    END.
    
    FIND PEDIDO WHERE PEDIDO.codcia = ORDENES.codcia
        AND PEDIDO.coddiv = ORDENES.coddiv
        AND PEDIDO.coddoc = ORDENES.codref
        AND PEDIDO.nroped = ORDENES.nroref
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        IF LOCKED(ORDENES) OR AMBIGUOUS(ORDENES) THEN RETURN 'ADM-ERROR'.
        NEXT.
    END.
    ASSIGN
        PEDIDO.codalm = "11e"
        PEDIDO.divdes = "00000".
    FOR EACH Facdpedi OF PEDIDO:
        ASSIGN Facdpedi.almdes = PEDIDO.codalm.
    END.
    
END.
IF AVAILABLE(PEDIDO) THEN RELEASE PEDIDO.
IF AVAILABLE(ORDENES) THEN RELEASE ORDENES.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rutina-Cross-Docking V-table-Win 
PROCEDURE Rutina-Cross-Docking :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
      AND Almacen.coddiv = s-coddiv
      AND Almacen.campo-c[1] = "XD"
      AND Almacen.campo-c[9] <> 'I'
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almacen THEN DO:
      pMensaje = "NO definido el almacén de Cross Docking".
      RETURN "ADM-ERROR".
  END.
  IF NOT CAN-FIND(FIRST Almtdocm WHERE Almtdocm.CodCia = s-CodCia AND
                  Almtdocm.CodAlm = Almacen.CodAlm AND
                  Almtdocm.TipMov = 'I' AND
                  Almtdocm.CodMov = s-CodMov)
      THEN DO:
      pMensaje = "NO definido el movimiento de ingreso por transferencia en el almacén " +
          Almacen.CodAlm.
      RETURN "ADM-ERROR".
  END.
  DEF VAR x-Nrodoc LIKE Almtdocm.NroDoc NO-UNDO.
  
  {lib/lock-genericov3.i ~
      &Tabla="Almtdocm" ~
      &Condicion="Almtdocm.CodCia = S-CODCIA AND ~
        Almtdocm.CodAlm = Almacen.CodAlm AND ~
        Almtdocm.TipMov = 'I' AND ~
        Almtdocm.CodMov = S-CODMOV" ~
      &Bloqueo="EXCLUSIVE-LOCK" ~
      &Accion="RETRY" ~
      &Mensaje="NO" ~
      &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
      }
  ASSIGN 
      x-Nrodoc  = Almtdocm.NroDoc.
  REPEAT:
      IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia
                      AND Almcmov.CodAlm = Almtdocm.CodAlm 
                      AND Almcmov.TipMov = Almtdocm.TipMov
                      AND Almcmov.CodMov = Almtdocm.CodMov
                      AND Almcmov.NroSer = 000
                      AND Almcmov.NroDoc = x-NroDoc
                      NO-LOCK)
          THEN LEAVE.
      ASSIGN
          x-NroDoc = x-NroDoc + 1.
  END.
  ASSIGN
      Almcmov.CodCia  = Almtdocm.CodCia 
      Almcmov.CodAlm  = Almacen.CodAlm      /* Almacén de Cross Docking */
      Almcmov.TipMov  = Almtdocm.TipMov 
      Almcmov.CodMov  = Almtdocm.CodMov 
      Almcmov.NroSer  = 000
      Almcmov.NroDoc  = x-NroDoc
      Almcmov.FlgSit  = ""
      Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
      Almcmov.NomRef  = F-NomDes:SCREEN-VALUE IN FRAME {&FRAME-NAME}            
      Almcmov.usuario = S-USER-ID
      NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      pMensaje = ERROR-STATUS:GET-MESSAGE(1).
      RETURN 'ADM-ERROR'.
  END.
  ASSIGN
      Almtdocm.NroDoc = x-NroDoc + 1.
  DISPLAY Almcmov.NroDoc WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rutina-Normal V-table-Win 
PROCEDURE Rutina-Normal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-Nrodoc LIKE Almtdocm.NroDoc NO-UNDO.
  
  {lib/lock-genericov3.i ~
      &Tabla="Almtdocm" ~
      &Condicion="Almtdocm.CodCia = S-CODCIA AND ~
      Almtdocm.CodAlm = s-CodAlm AND ~
      Almtdocm.TipMov = 'I' AND ~
      Almtdocm.CodMov = S-CODMOV" ~
      &Bloqueo="EXCLUSIVE-LOCK" ~
      &Accion="RETRY" ~
      &Mensaje="NO" ~
      &TipoError="RETURN 'ADM-ERROR'" ~
      }
  ASSIGN 
      x-Nrodoc  = Almtdocm.NroDoc.
  REPEAT:
      IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia
                      AND Almcmov.CodAlm = Almtdocm.CodAlm 
                      AND Almcmov.TipMov = Almtdocm.TipMov
                      AND Almcmov.CodMov = Almtdocm.CodMov
                      AND Almcmov.NroSer = 000
                      AND Almcmov.NroDoc = x-NroDoc
                      NO-LOCK)
          THEN LEAVE.
      ASSIGN
          x-NroDoc = x-NroDoc + 1.
  END.
  ASSIGN
      Almcmov.CodCia  = Almtdocm.CodCia 
      Almcmov.TipMov  = Almtdocm.TipMov 
      Almcmov.CodMov  = Almtdocm.CodMov 
      Almcmov.NroSer  = 000
      Almcmov.NroDoc  = x-NroDoc
      Almcmov.FlgSit  = ""
      Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
      Almcmov.NomRef  = F-NomDes:SCREEN-VALUE IN FRAME {&FRAME-NAME}            
      Almcmov.usuario = S-USER-ID
      NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      pMensaje = ERROR-STATUS:GET-MESSAGE(1).
      RETURN "ADM-ERROR".
  END.
  ASSIGN
      Almtdocm.NroDoc = x-NroDoc + 1.

  DISPLAY Almcmov.NroDoc WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
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
  {src/adm/template/snd-list.i "Almtdocm"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN RUN valida-update.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN ERROR.
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE To-Excel V-table-Win 
PROCEDURE To-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Almcmov OR Almcmov.FlgEst = 'A' THEN RETURN.
SESSION:SET-WAIT-STATE('GENERAL').
RUN Excel.
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME} :
   /* Capturamos las modificaciones de fecha o tipo de cambio para revalorizar */
   ASSIGN  D-FCHDOC = INPUT Almcmov.FchDoc.   
   IF Almcmov.AlmDes:SCREEN-VALUE = "" THEN DO:
         MESSAGE "No Ingreso el Almacen Destino" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Almcmov.AlmDes.
         RETURN "ADM-ERROR".   
   END.
   FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia 
                 AND  Almacen.CodAlm = Almcmov.AlmDes:SCREEN-VALUE
                NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almacen THEN DO:
      MESSAGE "Almacen Destino no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.AlmDes.
      RETURN "ADM-ERROR".   
   END.
   IF Almcmov.AlmDes:SCREEN-VALUE = Almtdocm.CodAlm THEN DO:
         MESSAGE "Almacen no puede transferirse a si mismo" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Almcmov.AlmDes.
         RETURN "ADM-ERROR".   
   END.

    /* Verificamos la salida por transferencia */
    FIND CMOV WHERE CMOV.CodCia = s-CodCia 
        AND CMOV.CodAlm = Almcmov.AlmDes:SCREEN-VALUE
        AND CMOV.TipMov = "S" 
        AND CMOV.CodMov = I-MOVORI 
        AND CMOV.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1:SCREEN-VALUE,1,3)) 
        AND CMOV.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1:SCREEN-VALUE,4)) 
        NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'No se encontro la salida por transferencia' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF CMOV.FlgSit = 'R' THEN DO:
        MESSAGE 'La salida por transferencia ya fue recepcionada' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF CMOV.NroSer <> 000 AND (CMOV.Libre_c02 = 'P' AND CMOV.FlgSit = 'T') THEN DO:
        MESSAGE 'La Guia aún NO ha sido verificada en el almacén de salida' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
   /* Articulos por almacen */
   I-NRO = 0.
   FOR EACH ITEM WHERE ITEM.CanDes > 0:
       I-NRO = I-NRO + 1.
   END.
   IF I-NRO = 0 THEN DO:
      MESSAGE "No existen articulos a transferir" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.NroRf1.
      RETURN "ADM-ERROR".
   END.
   /* Verifica que los productos se encuentre asignados al Almacen Destino */
   DEFINE VAR ok AS LOGICAL NO-UNDO.
   ok = TRUE.
   FOR EACH ITEM WHERE ITEM.CanDes > 0:
       FIND Almmmatg WHERE Almmmatg.CodCia = s-codcia 
                      AND  Almmmatg.codmat = ITEM.Codmat 
                     NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Almmmatg THEN DO:
          MESSAGE 'Producto' ITEM.Codmat 'no se encuentra registrado en el catálogo de materiales' 
              VIEW-AS ALERT-BOX ERROR.
          ok = FALSE.
       END.
/*        FIND Almmmate WHERE Almmmate.CodCia = s-codcia                                         */
/*            AND  Almmmate.codalm = S-CODALM                                                    */
/*            AND  Almmmate.codmat = ITEM.Codmat                                                 */
/*            NO-LOCK NO-ERROR.                                                                  */
/*        IF NOT AVAILABLE Almmmate THEN DO:                                                     */
/*           MESSAGE 'Producto ' + ITEM.Codmat + ' no se encuentra asignado al Almacén' S-CODALM */
/*           VIEW-AS ALERT-BOX ERROR.                                                            */
/*           ok = FALSE.                                                                         */
/*        END.                                                                                   */
   END.
   IF ok = FALSE THEN RETURN "ADM-ERROR".
END.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:      
------------------------------------------------------------------------------*/

IF s-status-almacen = NO THEN DO:
    MESSAGE 'Almacén INACTIVO' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
RETURN 'ADM-ERROR'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

