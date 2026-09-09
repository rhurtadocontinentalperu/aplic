&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR S-NROSER  AS INTEGER.
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR pv-CODCIA  AS INTEGER.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODALM  AS CHAR.
DEFINE SHARED VAR S-DESALM  AS CHAR.
DEFINE SHARED VARIABLE C-CODALM  AS CHAR.
DEFINE SHARED VAR s-status-almacen AS LOG.

DEFINE        VAR C-DESALM AS CHAR     NO-UNDO.
DEFINE        VAR C-DIRALM AS CHAR FORMAT "X(60)" INIT "".
DEFINE        VAR C-DIRPRO AS CHAR FORMAT "X(60)" INIT "".
DEFINE        VAR I-CODMON AS INTEGER  NO-UNDO.
DEFINE        VAR R-ROWID  AS ROWID    NO-UNDO.
DEFINE        VAR D-FCHDOC AS DATE     NO-UNDO.
DEFINE        VAR F-TPOCMB AS DECIMAL  NO-UNDO.
DEFINE        VAR I-NRO    AS INTEGER  NO-UNDO.
DEFINE        VAR S-OBSER  AS CHAR     NO-UNDO.
DEFINE        VAR L-CREA   AS LOGICAL  NO-UNDO.
DEFINE        VAR S-ITEM   AS INTEGER INIT 0.
DEFINE        VAR F-NOMPRO AS CHAR FORMAT "X(50)" INIT "".
DEFINE        VAR F-DIRTRA AS CHAR FORMAT "X(50)" INIT "".
DEFINE        VAR F-RUCTRA AS CHAR FORMAT "X(8)"  INIT "". 
DEFINE        VAR S-TOTPES AS DECIMAL.
DEFINE        VAR I-MOVDES AS INTEGER NO-UNDO.

DEF VAR I-NroSer AS INTEGER .
DEFINE STREAM Reporte.
DEFINE SHARED TEMP-TABLE ITEM LIKE almdmov.

DEFINE BUFFER TDOCM FOR Almtdocm.
DEFINE BUFFER CMOV  FOR Almcmov.

DEFINE STREAM Reporte.

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
DEFINE BUFFER B-Almtmovm FOR Almtmovm.
FIND FIRST B-Almtmovm WHERE B-Almtmovm.CodCia = S-CODCIA 
                     AND  B-Almtmovm.Tipmov = "I" 
                     AND  B-Almtmovm.MovTrf 
                    NO-LOCK NO-ERROR.
IF AVAILABLE B-Almtmovm THEN I-MOVDES = B-Almtmovm.CodMov.

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
&Scoped-Define ENABLED-FIELDS Almcmov.AlmDes Almcmov.Observ Almcmov.CodTra 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define ENABLED-OBJECTS RECT-3 
&Scoped-Define DISPLAYED-FIELDS Almcmov.FchDoc Almcmov.AlmDes ~
Almcmov.CodRef Almcmov.NroRef Almcmov.Observ Almcmov.usuario Almcmov.CodTra ~
Almcmov.NroRf2 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN_NroDoc F-NomDes f-nomtra 

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
     SIZE 16.72 BY .69
     FONT 6 NO-UNDO.

DEFINE VARIABLE F-NomDes AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .69 NO-UNDO.

DEFINE VARIABLE f-nomtra AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 36.43 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroDoc AS CHARACTER FORMAT "XXX-XXXXXX" 
     LABEL "No. documento" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .69
     FONT 6.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 3.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Estado AT ROW 1.12 COL 42.86 COLON-ALIGNED NO-LABEL
     FILL-IN_NroDoc AT ROW 1.19 COL 13.29 COLON-ALIGNED
     Almcmov.FchDoc AT ROW 1.19 COL 73 COLON-ALIGNED FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.AlmDes AT ROW 1.88 COL 13.29 COLON-ALIGNED
          LABEL "Almacen  Destino"
          VIEW-AS FILL-IN 
          SIZE 6.29 BY .69
     F-NomDes AT ROW 1.88 COL 21.57 COLON-ALIGNED NO-LABEL
     Almcmov.CodRef AT ROW 2 COL 64.43 NO-LABEL
          VIEW-AS COMBO-BOX INNER-LINES 1
          LIST-ITEMS "OP" 
          DROP-DOWN-LIST
          SIZE 7.86 BY 1
     Almcmov.NroRef AT ROW 2 COL 70.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .69
     Almcmov.Observ AT ROW 2.65 COL 13.29 COLON-ALIGNED
          LABEL "Observaciones" FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 46.29 BY .69
     Almcmov.usuario AT ROW 2.85 COL 70.43 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .69
     Almcmov.CodTra AT ROW 3.38 COL 13.29 COLON-ALIGNED
          LABEL "Transportista"
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .69
     f-nomtra AT ROW 3.38 COL 23 COLON-ALIGNED NO-LABEL
     Almcmov.NroRf2 AT ROW 3.62 COL 70.29 COLON-ALIGNED
          LABEL "Referencia"
          VIEW-AS FILL-IN 
          SIZE 12.72 BY .69
     RECT-3 AT ROW 1 COL 1
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
         HEIGHT             = 3.58
         WIDTH              = 87.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Almcmov.AlmDes IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX Almcmov.CodRef IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN Almcmov.CodTra IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-nomtra IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN_NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf2 IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almcmov.Observ IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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

&Scoped-define SELF-NAME Almcmov.AlmDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.AlmDes V-table-Win
ON LEAVE OF Almcmov.AlmDes IN FRAME F-Main /* Almacen  Destino */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.

  IF SELF:SCREEN-VALUE = S-CODALM THEN DO:
     MESSAGE "Almacen " S-CODALM " No puede transferir a si mismo" VIEW-AS ALERT-BOX.
     RETURN NO-APPLY.
  END.
  
  FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia AND
       Almacen.CodAlm = Almcmov.AlmDes:SCREEN-VALUE  NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almacen THEN DO:
     MESSAGE "Almacen Destino no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  F-NomDes:SCREEN-VALUE = Almacen.Descripcion.
  C-CODALM = Almacen.CodAlm.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.CodTra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodTra V-table-Win
ON LEAVE OF Almcmov.CodTra IN FRAME F-Main /* Transportista */
DO:

  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND AdmRutas WHERE AdmRutas.CodPro = Almcmov.CodTra:SCREEN-VALUE
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE AdmRutas THEN DO:
     MESSAGE " Código de Transportista no existe " VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  F-NomTra:SCREEN-VALUE = AdmRutas.NomTra.
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
FOR EACH ITEM:
    DELETE ITEM.
END.
IF NOT L-CREA THEN DO:
   FOR EACH Almdmov OF Almcmov NO-LOCK :
       CREATE ITEM.
       ASSIGN ITEM.CodCia = Almdmov.CodCia
              ITEM.CodAlm = Almdmov.CodAlm
              ITEM.codmat = Almdmov.codmat 
              ITEM.PreUni = Almdmov.PreUni 
              ITEM.CanDes = Almdmov.CanDes 
              ITEM.Factor = Almdmov.Factor 
              ITEM.ImpCto = Almdmov.ImpCto
              ITEM.CodUnd = Almdmov.CodUnd.
   END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Orden V-table-Win 
PROCEDURE Actualiza-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER X-FACTOR AS INTEGER.     
  
  FOR EACH Almdmov OF Almcmov NO-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
    FIND PR-ODPD WHERE 
        PR-ODPD.CodCia = Almdmov.CodCia 
        AND PR-ODPD.NumOrd = Almcmov.Nroref    
        AND PR-ODPD.CodMat = Almdmov.Codmat EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE PR-ODPD THEN PR-ODPD.CanDes = PR-ODPD.CanDes + (X-FACTOR * Almdmov.candes).
    RELEASE PR-ODPD.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Requerimiento V-table-Win 
PROCEDURE Actualiza-Requerimiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':
    FOR EACH Almdmov OF Almcmov NO-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
        FIND PR-RQPROD WHERE 
            PR-RQPROD.CodCia = Almdmov.CodCia 
            AND PR-RQPROD.CodAlm = Almcmov.Almdes 
            AND PR-RQPROD.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf2,1,3))
            AND PR-RQPROD.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf2,4,6))
            AND PR-RQPROD.CodMat = almdmov.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE PR-RQPROD THEN PR-RQPROD.CanDes = PR-RQPROD.CanDes + Almdmov.candes.
        RELEASE PR-RQPROD.
    END.
    FIND PR-RQPROC WHERE 
           PR-RQPROC.CodCia = Almcmov.codcia AND
           PR-RQPROC.CodAlm = Almcmov.AlmDes AND
           PR-RQPROC.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf2,1,3)) AND
           PR-RQPROC.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf2,4,6)) 
           EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE PR-RQPROC THEN ASSIGN PR-RQPROC.FlgEst = "C".
    RELEASE PR-RQPROC.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Documento V-table-Win 
PROCEDURE Asigna-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT L-CREA THEN RETURN "ADM-ERROR".
  DEFINE VARIABLE I-ITM AS INTEGER INIT 0 EXTENT 2 NO-UNDO.
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
  DO WITH FRAME {&FRAME-NAME}:
      input-var-1 = Almcmov.AlmDes:SCREEN-VALUE.
      RUN LKUP\C-RQPEN.R("Requerimiento de Material Pendientes").
      IF output-var-1 = ? OR output-var-2 =  "" OR output-var-3 =  "" THEN RETURN.
      DISPLAY output-var-3 @ Almcmov.AlmDes 
              output-var-2 @ Almcmov.NroRf2.
      
      Almcmov.NroRf2:SCREEN-VALUE = output-var-2.
      Almcmov.Almdes:SENSITIVE = FALSE.
      
      FOR EACH ITEM:
          DELETE ITEM.
      END.

      FIND PR-RQPROC WHERE ROWID(PR-RQPROC) = output-var-1 NO-LOCK NO-ERROR.
      
      DISPLAY PR-RQPROC.NumOrd @ Almcmov.Nroref.
      
      FOR EACH PR-RQPROD OF PR-RQPROC NO-LOCK:
          FIND Almmmate WHERE Almmmate.CodCia = PR-RQPROD.CodCia  
                         AND  Almmmate.CodAlm = S-CODALM 
                         AND  Almmmate.CodMat = PR-RQPROD.CodMat 
                        NO-LOCK NO-ERROR. 
          IF NOT AVAILABLE Almmmate THEN DO:
             MESSAGE "Articulo " + PR-RQPROD.CodMat + " no asignado al Almacen" 
             VIEW-AS ALERT-BOX ERROR.
             RETURN.
          END.
          
          IF Almmmate.StkAct < (PR-RQPROD.CanReq - PR-RQPROD.CanDes) THEN DO:
             MESSAGE "Stock no disponible para Articulo " + PR-RQPROD.CodMat
             VIEW-AS ALERT-BOX ERROR.
             RETURN.
          END.
      END.   
      FOR EACH PR-RQPROD OF PR-RQPROC WHERE 
                            (PR-RQPROD.CanReq - PR-RQPROD.Candes > 0) 
                            NO-LOCK:
       
             FIND Almmmatg WHERE Almmmatg.CodCia = PR-RQPROD.CodCia  
                            AND  Almmmatg.CodMat = PR-RQPROD.CodMat 
                           NO-LOCK NO-ERROR. 
             /* GENERAMOS MOVIMIENTO PARA ALMACEN ORIGEN */
             FIND ITEM WHERE ITEM.CodCia = Almtdocm.CodCia
                        AND  ITEM.CodMat = PR-RQPROD.CodMat 
                       NO-LOCK NO-ERROR.
             IF NOT AVAILABLE ITEM THEN CREATE ITEM.
             ASSIGN ITEM.CodCia = Almtdocm.CodCia
                    ITEM.CodAlm = Almtdocm.CodAlm
                    ITEM.CodMat = PR-RQPROD.CodMat
                    ITEM.CodAjt = ""
                    ITEM.Factor = 1
                    ITEM.CodUnd = Almmmatg.UndStk
                    ITEM.AlmOri = PR-RQPROD.CodAlm.
             ASSIGN ITEM.CanDes = (PR-RQPROD.CanReq - PR-RQPROD.CanDes).
      END.
   END.
   
   RUN Procesa-Handle IN lh_Handle ('browse').
   OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Orden-Materiales V-table-Win 
PROCEDURE Asigna-Orden-Materiales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT L-CREA THEN RETURN "ADM-ERROR".
  DEFINE VARIABLE I-ITM AS INTEGER INIT 0 EXTENT 2 NO-UNDO.
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
  DO WITH FRAME {&FRAME-NAME}:
      input-var-1 = "A,C,B". 
      RUN LKUP\C-OPPEN("Ordenes de Produccion Pendientes").
      IF output-var-1 = ? THEN RETURN.
      FIND PR-ODPC WHERE ROWID(PR-ODPC) = output-var-1 NO-LOCK NO-ERROR.
      IF AVAILABLE PR-ODPC THEN DO :
        IF PR-ODPC.CodAlm <> S-CODALM THEN DO:
           MESSAGE "ALMACEN NO ASIGNADO PARA EJECUTAR ORDEN DE PRODUCCION "
                   VIEW-AS ALERT-BOX .
           RETURN .
        END.       
      END.
      DISPLAY output-var-2 @ Almcmov.NroRf2.
      
      Almcmov.NroRf2:SCREEN-VALUE = output-var-2.
/*      Almcmov.Almdes:SENSITIVE = FALSE.*/
      
      FOR EACH ITEM:
          DELETE ITEM.
      END.
     
      DISPLAY PR-ODPC.NumOrd @ Almcmov.Nroref.
      
      FOR EACH PR-ODPD OF PR-ODPC NO-LOCK:
          FIND Almmmate WHERE Almmmate.CodCia = PR-ODPD.CodCia  
                         AND  Almmmate.CodAlm = S-CODALM 
                         AND  Almmmate.CodMat = PR-ODPD.CodMat 
                        NO-LOCK NO-ERROR. 
          IF NOT AVAILABLE Almmmate THEN DO:
             MESSAGE "Articulo " + PR-ODPD.CodMat + " no asignado al Almacen" 
             VIEW-AS ALERT-BOX ERROR.
             RETURN.
          END.

      END.   

      FOR EACH PR-ODPD OF PR-ODPC NO-LOCK:       
             FIND Almmmatg WHERE Almmmatg.CodCia = PR-ODPD.CodCia  
                            AND  Almmmatg.CodMat = PR-ODPD.CodMat 
                           NO-LOCK NO-ERROR. 

             /* GENERAMOS MOVIMIENTO PARA ALMACEN ORIGEN */
             FIND ITEM WHERE ITEM.CodCia = S-CODCIA
                        AND  ITEM.CodMat = PR-ODPD.CodMat 
                       NO-LOCK NO-ERROR.
             IF NOT AVAILABLE ITEM THEN CREATE ITEM.
             ASSIGN ITEM.CodCia = S-CODCIA
                    ITEM.CodAlm = S-CODALM
                    ITEM.CodMat = PR-ODPD.CodMat
                    ITEM.CodAjt = ""
                    ITEM.Factor = 1
                    ITEM.CodUnd = Almmmatg.UndStk.
             ASSIGN ITEM.CanDes = 1.
      END.
   END.
   
   RUN Procesa-Handle IN lh_Handle ('browse3').
   
   OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Orden-Merma V-table-Win 
PROCEDURE Asigna-Orden-Merma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT L-CREA THEN RETURN "ADM-ERROR".
  DEFINE VARIABLE I-ITM AS INTEGER INIT 0 EXTENT 2 NO-UNDO.
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
  DO WITH FRAME {&FRAME-NAME}:
      input-var-1 = "A,C,B". 
      RUN LKUP\C-OPPEN("Ordenes de Produccion Pendientes").
      IF output-var-1 = ? THEN RETURN.
      FIND PR-ODPC WHERE ROWID(PR-ODPC) = output-var-1 NO-LOCK NO-ERROR.
      IF AVAILABLE PR-ODPC THEN DO :
        IF PR-ODPC.CodAlm <> S-CODALM THEN DO:
           MESSAGE "ALMACEN NO ASIGNADO PARA EJECUTAR ORDEN DE PRODUCCION "
                   VIEW-AS ALERT-BOX .
           RETURN .
        END.       
      END.
      DISPLAY output-var-2 @ Almcmov.NroRf2.
      
      Almcmov.NroRf2:SCREEN-VALUE = output-var-2.
/*      Almcmov.Almdes:SENSITIVE = FALSE.*/
      
      FOR EACH ITEM:
          DELETE ITEM.
      END.
     
      DISPLAY PR-ODPC.NumOrd @ Almcmov.Nroref.

      FOR EACH PR-ODPCX OF PR-ODPC:
        FIND FIRST PR-FORMC WHERE PR-FORMC.CodCia = S-CODCIA AND
                                  PR-FORMC.CodArt = PR-ODPCX.CodArt AND
                                  PR-FORMC.CodFor = PR-ODPCX.CodFor
                                  NO-LOCK NO-ERROR.
  
        IF NOT AVAILABLE PR-FORMC THEN DO:
           MESSAGE "No Existe Formula Para Articulo " + PR-ODPCX.CodArt 
           VIEW-AS ALERT-BOX ERROR.
           RETURN.  
        END.

        FOR EACH PR-FORMDM OF PR-FORMC NO-LOCK :        
            FIND Almmmate WHERE Almmmate.CodCia = PR-FORMDM.CodCia  
                           AND  Almmmate.CodAlm = S-CODALM 
                           AND  Almmmate.CodMat = PR-FORMDM.CodMat 
                          NO-LOCK NO-ERROR. 
            IF NOT AVAILABLE Almmmate THEN DO:
               MESSAGE "Articulo " + PR-FORMDM.CodMat + " no asignado al Almacen" 
               VIEW-AS ALERT-BOX ERROR.
               RETURN.
            END.
  
        END.   

        FOR EACH PR-FORMDM OF PR-FORMC NO-LOCK:       
               FIND Almmmatg WHERE Almmmatg.CodCia = PR-FORMDM.CodCia  
                              AND  Almmmatg.CodMat = PR-FORMDM.CodMat 
                             NO-LOCK NO-ERROR. 
  
               /* GENERAMOS MOVIMIENTO PARA ALMACEN ORIGEN */
               FIND ITEM WHERE ITEM.CodCia = S-CODCIA
                          AND  ITEM.CodMat = PR-FORMDM.CodMat 
                         NO-LOCK NO-ERROR.
               IF NOT AVAILABLE ITEM THEN CREATE ITEM.
               ASSIGN ITEM.CodCia = S-CODCIA
                      ITEM.CodAlm = S-CODALM
                      ITEM.CodMat = PR-FORMDM.CodMat
                      ITEM.CodAjt = ""
                      ITEM.Factor = 1
                      ITEM.CodUnd = Almmmatg.UndStk.
               ASSIGN ITEM.CanDes = 1.
        END.
      END.  
   END.
   
   RUN Procesa-Handle IN lh_Handle ('browse3').
   
   OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Orden-Productos V-table-Win 
PROCEDURE Asigna-Orden-Productos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT L-CREA THEN RETURN "ADM-ERROR".
  DEFINE VARIABLE I-ITM AS INTEGER INIT 0 EXTENT 2 NO-UNDO.
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
  DO WITH FRAME {&FRAME-NAME}:
      input-var-1 = "A,C,B". 
      RUN LKUP\C-OPPEN("Ordenes de Produccion Pendientes").
      IF output-var-1 = ? THEN RETURN.
      FIND PR-ODPC WHERE ROWID(PR-ODPC) = output-var-1 NO-LOCK NO-ERROR.
      IF AVAILABLE PR-ODPC THEN DO :
        IF PR-ODPC.CodAlm <> S-CODALM THEN DO:
           MESSAGE "ALMACEN NO ASIGNADO PARA EJECUTAR ORDEN DE PRODUCCION "
                   VIEW-AS ALERT-BOX .
           RETURN .
        END.       
      END.
      DISPLAY output-var-2 @ Almcmov.NroRf2.
      
      Almcmov.NroRf2:SCREEN-VALUE = output-var-2.
/*      Almcmov.Almdes:SENSITIVE = FALSE.*/
      
      FOR EACH ITEM:
          DELETE ITEM.
      END.
     
      DISPLAY PR-ODPC.NumOrd @ Almcmov.Nroref.
      FOR EACH PR-ODPCX OF PR-ODPC:
        FIND Almmmate WHERE Almmmate.CodCia = PR-ODPC.CodCia  
                       AND  Almmmate.CodAlm = S-CODALM 
                       AND  Almmmate.CodMat = PR-ODPCX.CodArt
                       NO-LOCK NO-ERROR. 
        IF NOT AVAILABLE Almmmate THEN DO:
           MESSAGE "Articulo " + PR-ODPCX.CodArt + " no asignado al Almacen" 
           VIEW-AS ALERT-BOX ERROR.
           RETURN.
        END.

        IF Almmmate.StkAct <= 0  THEN DO:
           MESSAGE "Articulo " + PR-ODPCX.CodArt + " Sin Stock" 
           VIEW-AS ALERT-BOX ERROR.
           NEXT.
        END.

        FIND Almmmatg WHERE Almmmatg.CodCia = PR-ODPC.CodCia  
                       AND  Almmmatg.CodMat = PR-ODPCX.CodArt 
                       NO-LOCK NO-ERROR. 
  
               /* GENERAMOS MOVIMIENTO PARA ALMACEN ORIGEN */
        FIND ITEM WHERE ITEM.CodCia = S-CODCIA
                   AND  ITEM.CodMat = PR-ODPCX.CodArt 
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ITEM THEN CREATE ITEM.
          ASSIGN ITEM.CodCia = S-CODCIA
                 ITEM.CodAlm = S-CODALM
                 ITEM.CodMat = PR-ODPCX.CodArt
                 ITEM.CodAjt = ""
                 ITEM.Factor = 1
                 ITEM.CodUnd = Almmmatg.UndStk.
          ASSIGN ITEM.CanDes = 1.
        
         RELEASE ITEM.
      END. 
       
   END.
   
   RUN Procesa-Handle IN lh_Handle ('browse3').
   
   OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
   
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
  /* Eliminamos el detalle para el almacen de Origen */
  FOR EACH Almdmov OF Almcmov EXCLUSIVE-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
    ASSIGN R-ROWID = ROWID(Almdmov).
    /* RUN ALM\ALMCGSTK (R-ROWID).     /* Ingresa al Almacen POR SALIDAS */ */
    RUN alm/almacstk (R-ROWID).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    
    /* RHC 05.04.04 AGREGAMOS KARDEX POR ALMACEN */
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
              Almdmov.HraDoc = Almcmov.HorSal
              R-ROWID = ROWID(Almdmov).
       /*  ALM\ALMDGSTK (R-ROWID). */
       RUN alm/almdcstk (R-ROWID).
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       
       /* RHC 05.04.04 AGREGAMOS KARDEX POR ALMACEN */
       RUN alm/almacpr1 (R-ROWID, 'U').
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF s-status-almacen = NO THEN DO:
      MESSAGE 'Almacén INACTIVO' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  L-CREA = YES.
  C-CODALM = "".
  
  RUN Actualiza-ITEM.
  IF LOOKUP(TRIM(S-CODALM),"11,130,85,86,87") > 0 THEN RUN Procesa-Handle IN lh_Handle ('Pagina2').
  ELSE RUN Procesa-Handle IN lh_Handle ('Pagina3').

  DO WITH FRAME {&FRAME-NAME}:
     FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                          AND  FacCorre.CodDoc = "G/R" 
                          AND  FacCorre.CodDiv = S-CODDIV 
                          AND  FacCorre.NroSer = S-NROSER 
                         NO-LOCK NO-ERROR.
     IF AVAILABLE FacCorre THEN 
        FILL-IN_NroDoc:SCREEN-VALUE = STRING(S-NROSER,"999") + STRING(FacCorre.Correlativo,"999999").

     DISPLAY TODAY @ Almcmov.FchDoc.
     
     Almcmov.CodRef:SCREEN-VALUE = "OP".
     ALMCMOV.CODTRA:SCREEN-VALUE = "" . 

  END.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF L-CREA THEN DO :
     ASSIGN Almcmov.CodCia  = Almtdocm.CodCia 
            Almcmov.CodAlm  = Almtdocm.CodAlm 
            Almcmov.TipMov  = Almtdocm.TipMov
            Almcmov.CodMov  = Almtdocm.CodMov
            Almcmov.CodRef  = Almcmov.CodRef:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            Almcmov.NroRef  = Almcmov.NroRef:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            Almcmov.NroRf2  = Almcmov.NroRf2:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            Almcmov.NroRf1  = TRIM(Almcmov.CodRef) + TRIM(Almcmov.NroRef)
            Almcmov.FlgSit  = "T"
            Almcmov.HorSal  = STRING(TIME,"HH:MM:SS")
            Almcmov.NroSer  = S-NROSER
            Almcmov.NomRef  = F-nomdes:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.            

     IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'ERROR' VIEW-AS ALERT-BOX.
        RETURN "ADM-ERROR".
     END.
     /* ACEPTA EL DOCUMENTO INGRESADO */
     ASSIGN FILL-IN_NroDoc.
     ASSIGN Almcmov.Nrodoc = INTEGER(SUBSTRING(FILL-IN_NroDoc,4,6)).

     IF ERROR-STATUS:ERROR THEN DO:
        RETURN "ADM-ERROR".
     END.

    FIND FIRST FacCorre WHERE 
                FacCorre.CodCia = S-CODCIA AND  
                FacCorre.CodDoc = "G/R" AND  
                FacCorre.CodDiv = S-CODDIV AND  
                FacCorre.NroSer = S-NROSER  EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    IF INTEGER(SUBSTRING(FILL-IN_NroDoc,4,6)) >= FacCorre.Correlativo 
    THEN FacCorre.Correlativo = INTEGER(SUBSTRING(FILL-IN_NroDoc,4,6)) + 1.
    RELEASE FacCorre.
    /*********************************/
  END.

  ASSIGN 
     Almcmov.usuario = S-USER-ID. 
  
  IF NOT L-CREA 
  THEN DO:
    RUN Borra-Detalle.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
    
  RUN Genera-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* RHC 24.03.2011 Generamos un movimiento de ingreso en el almacen 10 */
  RUN alm/ing-trf-vir (ROWID(Almcmov), '999').
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  /* ******************************************************************* */

  RUN Actualiza-Requerimiento.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN Actualiza-Orden(1).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  
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
  
  RUN Procesa-Handle IN lh_Handle ('browse').
  
  FILL-IN_NroDoc:SENSITIVE IN FRAME {&FRAME-NAME} = False.
    
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

  IF Almcmov.FlgEst = 'A' THEN DO:
     MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.

  IF Almcmov.FlgSit  = "R" THEN DO:
     MESSAGE "Transferencia recepcionada, no puede se modificada" VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.

  IF s-user-id <> 'ADMIN' THEN DO:
      RUN alm/p-ciealm-01 (almcmov.fchdoc, almcmov.codalm).
      IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
      IF Almcmov.FchDoc < TODAY THEN DO:
        FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                      AND  Almacen.CodAlm = S-CODALM 
                     NO-LOCK NO-ERROR.
        RUN ALM/D-CLAVE.R(Almacen.Clave,OUTPUT RPTA).
        IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
      END.
      /* consistencia de la fecha del cierre del sistema */
      DEF VAR dFchCie AS DATE.
      RUN gn/fecha-de-cierre (OUTPUT dFchCie).
      IF almcmov.fchdoc <= dFchCie THEN DO:
          MESSAGE 'NO se puede anular ningun documento antes del' (dFchCie + 1)
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.
  C-CODALM = Almcmov.CodAlm.
  /* fin de consistencia */
  
  /* Solo marcamos el FlgEst como Anulado */
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      RUN alm/ing-trf-vir-del (ROWID(Almcmov), '999').
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

     RUN Restaura-requerimiento.
     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
     RUN Actualiza-Orden(-1).
     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
     RUN Borra-Detalle.
     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
     FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia AND
                  CMOV.CodAlm = Almcmov.CodAlm AND
                  CMOV.TipMov = Almcmov.TipMov AND
                  CMOV.CodMov = Almcmov.CodMov AND
                  CMOV.NroSer = Almcmov.NroSer AND 
                  CMOV.NroDoc = Almcmov.NroDoc EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN CMOV.FlgEst = 'A'
            CMOV.FchAnu = TODAY
            CMOV.Usuario = S-USER-ID
            CMOV.Observ = "      A   N   U   L   A   D   O       ".
    RELEASE CMOV.
  END.
  /* refrescamos los datos del viewer */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  /* refrescamos los datos del browse */
  RUN Procesa-Handle IN lh_Handle ('browse').

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
     ASSIGN
        I-CODMON = Almtmovm.CodMon.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  IF AVAILABLE Almcmov THEN DO WITH FRAME {&FRAME-NAME}:
     FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia 
                    AND  Almacen.CodAlm = Almcmov.AlmDes  
                   NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN F-NomDes:SCREEN-VALUE = Almacen.Descripcion.
     ELSE F-NomDes:SCREEN-VALUE = "".
     FILL-IN_NroDoc:SCREEN-VALUE = STRING(Almcmov.NroSer,"999") + STRING(Almcmov.NroDoc,"999999").
     F-Estado:SCREEN-VALUE = "".
     /*
     IF Almcmov.FlgSit  = "T" THEN F-Estado:SCREEN-VALUE = "TRANSFERIDO ".
     IF Almcmov.FlgSit  = "R" THEN F-Estado:SCREEN-VALUE = "RECEPCIONADO".
     IF Almcmov.FlgSit  = "R" AND Almcmov.FlgEst =  "D" THEN F-Estado:SCREEN-VALUE = "RECEPCIONADO(*)".
     */
/*     IF Almcmov.FlgEst  = "A" THEN F-Estado:SCREEN-VALUE = "  ANULADO   ".*/
     IF Almcmov.FlgSit  = "T" THEN F-Estado:SCREEN-VALUE = "TRANSFERIDO ".
     IF Almcmov.FlgSit  = "R" THEN F-Estado:SCREEN-VALUE = "RECEPCIONADO".
     IF Almcmov.FlgSit  = "R" AND Almcmov.FlgEst =  "D" THEN F-Estado:SCREEN-VALUE = "RECEPCIONADO(*)".
     IF Almcmov.FlgEst  = "A" THEN F-Estado:SCREEN-VALUE = "  ANULADO   ".

     FIND AdmRutas WHERE AdmRutas.CodPro = Almcmov.CodTra:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE AdmRutas THEN F-NomTra:SCREEN-VALUE = Admrutas.Nomtra.
     ELSE F-NomTra:SCREEN-VALUE = "".
   
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
  DEF VAR M AS INTEGER.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF LOOKUP(TRIM(Almcmov.CodAlm), '11,85,12') > 0 
    AND (Almcmov.NroSer = 014 OR Almcmov.NroSer = 185 OR Almcmov.NroSer = 102)
  THEN DO:
         IF AlmCmov.FlgEst <> "A" THEN RUN ALM\R-ImpGui.R(ROWID(Almcmov)).
  END.
  ELSE DO:

    DEF VAR Rpta-1 AS LOG NO-UNDO.

    SYSTEM-DIALOG PRINTER-SETUP UPDATE Rpta-1.
    IF RPta-1 = NO THEN RETURN.

    DO M = 1 TO 2:
        S-TOTPES = 0.
        
        DEFINE VAR s-printer-list AS CHAR.
        DEFINE VAR s-port-list AS CHAR.
        DEFINE VAR s-port-name AS CHAR format "x(20)".
        DEFINE VAR s-printer-count AS INTEGER.

        I-NroSer = S-NROSER.
        FIND FIRST FacCorre WHERE 
                   FacCorre.CodCia = S-CODCIA AND
                   FacCorre.CodDoc = "G/R"    AND
                   FacCorre.CodDiv = S-CODDIV AND
                   FacCorre.NroSer = S-NROSER 
                   NO-LOCK NO-ERROR.

/*
        /*MLR* 29/10/07 Nueva librearía de impresión ***/
        RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
        IF s-port-name = '' THEN RETURN.
*/

      S-ITEM = 0.
      
      FIND Almacen WHERE Almacen.CodCia = Almcmov.CodCia 
                    AND  Almacen.CodAlm = Almcmov.CodAlm 
                   NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN
         C-DIRPRO = Almacen.Descripcion.
    
      FIND Almacen WHERE Almacen.CodCia = Almcmov.CodCia 
                    AND  Almacen.CodAlm = Almcmov.AlmDes 
                   NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN
        ASSIGN 
             C-DESALM = Almacen.Descripcion
             C-DIRALM = Almacen.DirAlm.
      ELSE 
        ASSIGN
             C-DESALM = "".
      
      FIND GN-PROV WHERE GN-PROV.Codcia = pv-codcia 
                    AND  gn-prov.CodPro = Almcmov.CodTra 
                   NO-LOCK NO-ERROR.
      IF AVAILABLE GN-PROV THEN DO:
         F-NomPro = gn-prov.NomPro.   
         F-DIRTRA = gn-prov.DirPro. 
         F-RUCTRA = gn-prov.Ruc.
      END.

      DEFINE FRAME F-FMT
             S-Item             AT  1   FORMAT "ZZ9"
             Almdmov.CodMat     AT  6   FORMAT "X(8)"
             Almmmatg.DesMat    AT  18  FORMAT "X(45)"
             Almmmatg.Desmar    AT  70  FORMAT "X(18)"
             Almdmov.CanDes     AT  90  FORMAT ">>>,>>9.99" 
             Almdmov.CodUnd     AT  105 FORMAT "X(4)"          
             HEADER
             SKIP
             {&Prn6a} + s-nomcia + {&Prn6b} FORMAT 'x(50)' SKIP
             "GUIA DE TRANSFERENCIA" AT 30 FORMAT "X(40)" 
             STRING(Almcmov.NroDoc,"999999")  AT 80 FORMAT "X(20)" SKIP(1)
             "Almacen : " Almcmov.CodAlm + " - " + C-DIRPRO FORMAT "X(60)" 
              Almcmov.FchDoc AT 106 SKIP
             "Destino : " Almcmov.Almdes + " - " + C-DESALM AT 15 FORMAT "X(60)" SKIP
             "Observaciones    : "  Almcmov.Observ FORMAT "X(40)"  SKIP  
             "Orden de Trabajo : " ALmcmov.CodRef + Almcmov.NroRef FORMAT "X(40)"SKIP    
             "----------------------------------------------------------------------------------------------------------------------" SKIP
             "     CODIGO      DESCRIPCION                                                                 CANTIDAD    UM           " SKIP
             "----------------------------------------------------------------------------------------------------------------------" SKIP
             WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 160 STREAM-IO DOWN.

/*
      OUTPUT STREAM Reporte TO VALUE(s-port-name) PAGED PAGE-SIZE 31.
*/
      OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 31.
      
      FIND FIRST Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia 
                          AND  Almdmov.CodAlm = Almcmov.CodAlm 
                          AND  Almdmov.TipMov = Almcmov.TipMov 
                          AND  Almdmov.CodMov = Almcmov.CodMov 
                          AND  Almdmov.NroSer = ALmcmov.NroSer
                          AND  Almdmov.NroDoc = Almcmov.NroDoc 
                         USE-INDEX Almd01 NO-LOCK NO-ERROR.
      IF AVAILABLE Almdmov THEN DO:
         PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(34) + {&PRN3}.     
         REPEAT WHILE  AVAILABLE  AlmDMov      AND Almdmov.CodAlm = Almcmov.CodAlm AND
               Almdmov.TipMov = Almcmov.TipMov AND Almdmov.CodMov = Almcmov.CodMov AND
               Almdmov.NroSer = Almcmov.NroSer AND Almdmov.NroDoc = Almcmov.NroDoc:
               FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                              AND  Almmmatg.CodMat = Almdmov.CodMat 
                             NO-LOCK NO-ERROR.
               S-TOTPES = S-TOTPES + ( Almdmov.Candes * Almmmatg.Pesmat ).
               S-Item = S-Item + 1.     
               DISPLAY STREAM Reporte 
                       S-Item 
                       Almdmov.CodMat 
                       Almdmov.CanDes 
                       Almdmov.CodUnd 
                       Almmmatg.DesMat 
                       Almmmatg.Desmar 
                       WITH FRAME F-FMT.
               DOWN STREAM Reporte WITH FRAME F-FMT.
               FIND NEXT Almdmov USE-INDEX Almd01.
         END.
      END.
      DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 7 :
         PUT STREAM Reporte "" skip.
      END.
      PUT STREAM Reporte "----------------------------------------------------------------------------------------------------------------------" SKIP .
      PUT STREAM Reporte SKIP(1).
      PUT STREAM Reporte "               ------------------------------                              ------------------------------             " SKIP.
      PUT STREAM Reporte "                      Jefe Almacen                                                  Recepcion                         ".

     
     
      OUTPUT STREAM Reporte CLOSE.
   END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Restaura-Requerimiento V-table-Win 
PROCEDURE Restaura-Requerimiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':
    FOR EACH Almdmov OF Almcmov NO-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
        FIND PR-RQPROD WHERE 
            PR-RQPROD.CodCia = Almdmov.CodCia 
            AND PR-RQPROD.CodAlm = Almcmov.Almdes 
            AND PR-RQPROD.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf2,1,3))
            AND PR-RQPROD.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf2,4,6))
            AND PR-RQPROD.CodMat = almdmov.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE PR-RQPROD THEN PR-RQPROD.CanDes = PR-RQPROD.CanDes - Almdmov.candes.
        RELEASE PR-RQPROD.
    END.
    FIND PR-RQPROC WHERE 
           PR-RQPROC.CodCia = Almcmov.codcia AND
           PR-RQPROC.CodAlm = Almcmov.AlmDes AND
           PR-RQPROC.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf2,1,3)) AND
           PR-RQPROC.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf2,4,6)) 
           EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE PR-RQPROC THEN DO ON ERROR UNDO, RETURN "ADM-ERROR": 
         ASSIGN PR-RQPROC.FlgEst = "P".
    END.
    RELEASE PR-RQPROC.
  END.    

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
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
     L-CREA = NO.
     RUN Actualiza-ITEM.
     RUN Procesa-Handle IN lh_Handle ('Pagina2').
     RUN Procesa-Handle IN lh_Handle ('browse').
  END.
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
   I-NRO = 0.
   FOR EACH ITEM WHERE ITEM.CanDes > 0:
       I-NRO = I-NRO + 1.
   END.
   IF I-NRO = 0 THEN DO:
      MESSAGE "Debe de existir al menos un ITEM" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.AlmDes.
      RETURN "ADM-ERROR".
   END.
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

  MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
  RETURN 'ADM-ERROR'.

  /* consistencia de la fecha del cierre del sistema */
  DEF VAR dFchCie AS DATE.
  RUN gn/fecha-de-cierre (OUTPUT dFchCie).
  IF almcmov.fchdoc <= dFchCie THEN DO:
      MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  /* fin de consistencia */
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

