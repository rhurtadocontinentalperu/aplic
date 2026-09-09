&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM LIKE Almdmov.



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
DEFINE SHARED VAR pv-codcia AS INT.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODALM  AS CHAR.
DEFINE SHARED VAR S-DESALM  AS CHAR.
DEFINE SHARED VARIABLE C-CODALM  AS CHAR.
DEFINE SHARED VARIABLE ORDTRB  AS CHAR.

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
&Scoped-Define ENABLED-FIELDS Almcmov.AlmDes Almcmov.NroRf1 Almcmov.NroRf2 ~
Almcmov.Observ Almcmov.CodTra 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define ENABLED-OBJECTS RECT-3 
&Scoped-Define DISPLAYED-FIELDS Almcmov.NroRf3 Almcmov.AlmDes ~
Almcmov.FchDoc Almcmov.NroRf1 Almcmov.NroRf2 Almcmov.Observ Almcmov.CodTra 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov
&Scoped-Define DISPLAYED-OBJECTS f-nomtra F-Estado FILL-IN_NroDoc F-NomDes 

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
     SIZE 40 BY .69 NO-UNDO.

DEFINE VARIABLE f-nomtra AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 34.57 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroDoc AS CHARACTER FORMAT "XXX-XXXXXX" 
     LABEL "No. documento" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .69
     FONT 6.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 3.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     f-nomtra AT ROW 3.38 COL 24.86 COLON-ALIGNED NO-LABEL
     Almcmov.NroRf3 AT ROW 3.38 COL 72.86 COLON-ALIGNED
          LABEL "O/T" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     F-Estado AT ROW 1.12 COL 42.86 COLON-ALIGNED NO-LABEL
     FILL-IN_NroDoc AT ROW 1.19 COL 13.29 COLON-ALIGNED
     F-NomDes AT ROW 1.88 COL 19.57 COLON-ALIGNED NO-LABEL
     Almcmov.AlmDes AT ROW 1.88 COL 13.29 COLON-ALIGNED
          LABEL "Almacen  Destino" FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .69
     Almcmov.FchDoc AT ROW 1.19 COL 73 COLON-ALIGNED FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.NroRf1 AT ROW 1.88 COL 73 COLON-ALIGNED
          LABEL "Referencia 1"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.NroRf2 AT ROW 2.65 COL 73 COLON-ALIGNED
          LABEL "Referencia 2" FORMAT "x(9)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.Observ AT ROW 2.65 COL 13.29 COLON-ALIGNED
          LABEL "Observaciones" FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 46.29 BY .69
     Almcmov.CodTra AT ROW 3.38 COL 13.29 COLON-ALIGNED
          LABEL "Transportista" FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
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
   Temp-Tables and Buffers:
      TABLE: ITEM T "SHARED" ? INTEGRAL Almdmov
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
         HEIGHT             = 4.23
         WIDTH              = 93.29.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Almcmov.AlmDes IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.CodTra IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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
/* SETTINGS FOR FILL-IN Almcmov.NroRf1 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf2 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.NroRf3 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Almcmov.Observ IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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
  IF SELF:SCREEN-VALUE = "" THEN RETURN NO-APPLY.
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
  Almcmov.AlmDes:SENSITIVE = FALSE.
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


&Scoped-define SELF-NAME FILL-IN_NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_NroDoc V-table-Win
ON LEAVE OF FILL-IN_NroDoc IN FRAME F-Main /* No. documento */
DO:
  ASSIGN FILL-IN_NroDoc.
  /* Caso de ingreso manual, verifica que no exista el documento */
  DO WITH FRAME {&FRAME-NAME} :
    FIND Almcmov WHERE Almcmov.CodCia = s-codcia 
                  AND  Almcmov.CodAlm = Almtdocm.CodAlm 
                  AND  Almcmov.TipMov = Almtdocm.TipMov 
                  AND  Almcmov.CodMov = Almtdocm.CodMov 
                  AND  Almcmov.NroSer = INTEGER(SUBSTRING(FILL-IN_NroDoc,1,3)) 
                  AND  Almcmov.NroDoc = INTEGER(SUBSTRING(FILL-IN_NroDoc,4,6)) 
                 NO-LOCK NO-ERROR.
    IF AVAILABLE Almcmov THEN DO:
       MESSAGE 'Documento se encuentra registrado' VIEW-AS ALERT-BOX.
       APPLY 'ENTRY':U TO FILL-IN_NroDoc.
       RETURN NO-APPLY.
    END.
    IF S-NROSER <> INTEGER(SUBSTRING(FILL-IN_NroDoc,1,3)) THEN DO:
       MESSAGE 'Documento no corresponde al n£mero de serie' VIEW-AS ALERT-BOX.
       APPLY 'ENTRY':U TO FILL-IN_NroDoc.
       RETURN NO-APPLY.
    END.
  END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Pedido V-table-Win 
PROCEDURE Actualiza-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      I-NRO = 0.
      FOR EACH Almdmov OF Almcmov NO-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
          FIND Almdrequ WHERE Almdrequ.CodCia = Almdmov.CodCia 
                         AND  Almdrequ.CodAlm = Almcmov.Almdes 
                         AND  Almdrequ.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1,1,3))
                         AND  Almdrequ.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1,4,6))
                         AND  Almdrequ.CodMat = almdmov.codmat EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
          IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
          IF AVAILABLE Almdrequ THEN Almdrequ.CanDes = Almdrequ.CanDes + Almdmov.candes.
          RELEASE Almdrequ.
      END.
      FOR EACH Almdrequ NO-LOCK WHERE Almdrequ.CodCia = Almcmov.CodCia 
                                 AND  Almdrequ.CodAlm = Almcmov.AlmDes 
                                 AND  Almdrequ.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1,1,3))
                                 AND  Almdrequ.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1,4,6)):
          IF (Almdrequ.CanReq - Almdrequ.CanDes) > 0 THEN I-NRO = I-NRO + 1.
      END.
      FIND Almcrequ WHERE Almcrequ.CodCia = Almcmov.codcia 
                     AND  Almcrequ.CodAlm = Almcmov.AlmDes 
                     AND  Almcrequ.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1,1,3)) 
                     AND  Almcrequ.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1,4,6)) 
                    EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
      IF AVAILABLE Almcrequ 
      THEN DO :
         ASSIGN Almcrequ.FlgEst = "P" 
                Almcrequ.Observ = S-OBSER.
         IF I-NRO = 0 THEN 
            ASSIGN Almcrequ.FlgEst = "C"
                   Almcrequ.HorAte = STRING(TIME,"HH:MM").
      END.
      RELEASE Almcrequ.
      
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
  /* Eliminamos el detalle para el almacen de Origen */
  FOR EACH Almdmov OF Almcmov EXCLUSIVE-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
    ASSIGN R-ROWID = ROWID(Almdmov).
    /*RUN ALM\ALMCGSTK (R-ROWID).     /* Ingresa al Almacen POR SALIDAS */ */
    RUN alm/almacstk (R-ROWID).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    
    /*
    RUN ALM\ALMACPR1 (R-ROWID,"D").
    RUN ALM\ALMACPR2 (R-ROWID,"D").
    */
    /* RHC 30.03.04 REACTIVAMOS RUTINA */
    RUN alm/almacpr1 (R-ROWID, "D").
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    
    if trim(almcmov.nrorf3) ne "" then do:
        find almdotrb where almdotrb.codcia = s-codcia
            and almdotrb.nroser = integer(substring(nrorf3,1,3))
            and almdotrb.nrodoc = integer(substring(nrorf3,4,6))
            exclusive-lock no-error.
        if error-status:error then undo, return 'adm-error'.
        if avail almdotrb then  
        almdotrb.canate = almdotrb.canate - Almdmov.CanDes.
        release almdotrb.
    end.    
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
              Almdmov.HraDoc = HorSal
              R-ROWID = ROWID(Almdmov).
       /*RUN ALM\ALMDGSTK (R-ROWID).*/
       RUN alm/almdcstk (R-ROWID).
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       
       if trim(almcmov.nrorf3) ne "" then do:
            find almdotrb where almdotrb.codcia = s-codcia
                and almdotrb.nroser = integer(substring(nrorf3,1,3))
                and almdotrb.nrodoc = integer(substring(nrorf3,4,6))
                exclusive-lock no-error.
            if error-status:error then undo, return 'adm-error'.
            if avail almdotrb then  
            almdotrb.canate = almdotrb.canate + Almdmov.CanDes.
            release almdotrb.
        end.    
       /*
       RUN ALM\ALMACPR1 (R-ROWID,"U").
       RUN ALM\ALMACPR2 (R-ROWID,"U").
       */
       
       /* RHC 30.03.04 REACTIVAMOS */
       RUN alm/almacpr1 (R-ROWID, "U").
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle-Destino V-table-Win 
PROCEDURE Genera-Detalle-Destino :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH ITEM WHERE ITEM.codmat <> "" 
      ON ERROR UNDO, RETURN "ADM-ERROR":
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
                    R-ROWID = ROWID(Almdmov).
      RUN ALM\ALMACSTK (R-ROWID).
      RUN ALM\ALMACPR1 (R-ROWID,"U").
      RUN ALM\ALMACPR2 (R-ROWID,"U").
  END.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-Reposicion V-table-Win 
PROCEDURE Generar-Reposicion :
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
      RUN LKUP\C-REPOSI.R("Reposiciones Pendientes").
      IF output-var-1 = ? OR output-var-2 =  "" OR output-var-3 =  "" THEN RETURN.
      DISPLAY output-var-3 @ Almcmov.AlmDes 
              output-var-2 @ Almcmov.NroRf1.
      Almcmov.NroRf1:SCREEN-VALUE = output-var-2.
      FOR EACH ITEM:
          DELETE ITEM.
      END.
      FIND Almcrequ WHERE ROWID(Almcrequ) = output-var-1 NO-LOCK NO-ERROR.

      Almcmov.Nrorf3:SCREEN-VALUE = Almcrequ.Nrorf3.
      ORDTRB = Almcrequ.Nrorf3.

      FOR EACH Almdrequ OF Almcrequ:
          FIND Almmmate WHERE Almmmate.CodCia = Almdrequ.CodCia  
                         AND  Almmmate.CodAlm = Almtdocm.CodAlm 
                         AND  Almmmate.CodMat = Almdrequ.CodMat 
                        NO-LOCK NO-ERROR. 
          IF AVAILABLE Almmmate AND (Almdrequ.CanReq - Almdrequ.CanDes) > 0 AND
             Almmmate.StkAct > 0 THEN DO:
             FIND Almmmatg WHERE Almmmatg.CodCia = Almdrequ.CodCia  
                            AND  Almmmatg.CodMat = Almdrequ.CodMat 
                           NO-LOCK NO-ERROR. 
             /* GENERAMOS MOVIMIENTO PARA ALMACEN ORIGEN */
             FIND ITEM WHERE ITEM.CodCia = Almtdocm.CodCia
                        AND  ITEM.CodMat = Almdrequ.CodMat 
                       NO-LOCK NO-ERROR.
             IF NOT AVAILABLE ITEM THEN CREATE ITEM.
             ASSIGN ITEM.CodCia = Almtdocm.CodCia
                    ITEM.CodAlm = Almtdocm.CodAlm
                    ITEM.CodMat = Almdrequ.CodMat
                    ITEM.CodAjt = ""
                    ITEM.Factor = 1
                    ITEM.CodUnd = Almmmatg.UndStk
                    ITEM.AlmOri = Almdrequ.CodAlm.
             IF Almmmate.StkAct > (Almdrequ.CanReq - Almdrequ.CanDes) THEN
                ASSIGN ITEM.CanDes = (Almdrequ.CanReq - Almdrequ.CanDes).
             ELSE ASSIGN ITEM.CanDes = Almmmate.StkAct.
             I-ITM[1] = I-ITM[1] + 1.
          END.
          I-ITM[2] = I-ITM[2] + 1.
      END.
   END.
   /* refrescamos los datos del browse */
   
   IF I-ITM[1] <> I-ITM[2] THEN DO:
      MESSAGE "No hay stock disponible para atender algunos articulos" VIEW-AS ALERT-BOX ERROR.
      S-OBSER = "No hay stock disponible para atender todo el pedido".
   END.
   
   RUN Procesa-Handle IN lh_Handle ('browse').
   
   OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Texto V-table-Win 
PROCEDURE Importar-Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Registro AS CHAR FORMAT 'x(100)' NO-UNDO.
  DEF VAR x-CodMat LIKE Almmmatg.codmat NO-UNDO.
  DEF VAR x-CanDes AS DEC NO-UNDO.
  DEF VAR x-Ok AS LOG NO-UNDO.

  IF NOT L-CREA THEN RETURN "ADM-ERROR".
  IF Almcmov.AlmDes:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' THEN DO:
    MESSAGE 'Primero ingrese el almacén destino' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  SYSTEM-DIALOG GET-FILE x-Archivo  FILTERS '*.txt' '*.txt'  RETURN-TO-START-DIR  TITLE 'Archivo Texto'  UPDATE x-Ok.
  IF x-Ok = NO THEN RETURN 'ADM-ERROR'.

  DEFINE VARIABLE I-ITM AS INTEGER INIT 0 EXTENT 2 NO-UNDO.
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH ITEM:
        DELETE ITEM.
    END.
    INPUT FROM VALUE(x-Archivo).
    REPEAT:
        IMPORT UNFORMATTED x-Registro.
        ASSIGN
            x-CodMat = SUBSTRING(x-Registro,1,6)
            x-CanDes = DECIMAL(SUBSTRING(x-Registro,7,10))
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        FIND Almmmate WHERE Almmmate.codcia = s-CodCia
            AND Almmmate.codalm = s-CodAlm
            AND Almmmate.codmat = x-CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate AND SUBSTRING(x-Registro,1,6) <> '' 
            AND Almmmate.StkAct > 0 THEN DO:
            FIND Almmmatg WHERE Almmmatg.CodCia = s-CodCia  
                AND  Almmmatg.CodMat = x-CodMat 
                NO-LOCK NO-ERROR. 
            /* GENERAMOS MOVIMIENTO PARA ALMACEN ORIGEN */
            FIND ITEM WHERE ITEM.CodCia = s-CodCia
                AND ITEM.CodMat = x-CodMat
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ITEM THEN CREATE ITEM.
            ASSIGN 
                ITEM.CodCia = s-CodCia
                ITEM.CodAlm = s-CodAlm
                ITEM.CodMat = x-CodMat
                ITEM.CodAjt = ""
                ITEM.Factor = 1
                ITEM.CodUnd = Almmmatg.UndStk
                ITEM.AlmOri = Almcmov.almdes:SCREEN-VALUE.
            IF Almmmate.StkAct > x-CanDes
            THEN ASSIGN ITEM.CanDes = x-CanDes.
            ELSE ASSIGN ITEM.CanDes = Almmmate.StkAct.
        END.
    END.
  END.
  /* refrescamos los datos del browse */
  RUN Procesa-Handle IN lh_Handle ('browse').
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

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
  FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
    AND FacCorre.CodDoc = "G/R"    
    AND FacCorre.CodDiv = S-CODDIV 
    AND FacCorre.NroSer = S-NROSER 
    NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = No THEN DO:
    MESSAGE 'La serie se encuentra INACTIVA' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  L-CREA = YES.
  C-CODALM = "".
  ORDTRB = "".
  RUN Actualiza-ITEM.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  DO WITH FRAME {&FRAME-NAME}:
     FIND FIRST FacCorre WHERE 
                FacCorre.CodCia = S-CODCIA AND  
                FacCorre.CodDoc = "G/R"    AND  
                FacCorre.CodDiv = S-CODDIV AND  
                FacCorre.NroSer = S-NROSER 
                NO-LOCK NO-ERROR.
     IF AVAILABLE FacCorre THEN 
        FILL-IN_NroDoc:SCREEN-VALUE = STRING(S-NROSER,"999") + 
                                      STRING(FacCorre.Correlativo,"999999").
     DISPLAY TODAY @ Almcmov.FchDoc.
     ALMCMOV.CODTRA:SCREEN-VALUE = "".  
     Almcmov.Nrorf3:SCREEN-VALUE = "".
  END.
/*  FILL-IN_NroDoc:SENSITIVE = True.*/
     
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
/*  RUN get-attribute('ADM-NEW-RECORD').*/
  
  IF L-CREA THEN DO :
     ASSIGN Almcmov.CodCia  = Almtdocm.CodCia 
            Almcmov.CodAlm  = Almtdocm.CodAlm 
            Almcmov.TipMov  = Almtdocm.TipMov
            Almcmov.CodMov  = Almtdocm.CodMov
            Almcmov.FlgSit  = "T"
            Almcmov.HorSal  = STRING(TIME,"HH:MM:SS")
            Almcmov.NroSer  = S-NROSER
            Almcmov.Nrorf1  = Almcmov.Nrorf1:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            Almcmov.Nrorf2  = Almcmov.Nrorf2:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            Almcmov.NomRef  = F-nomdes:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.            

     IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'ERROR' VIEW-AS ALERT-BOX.
        UNDO, RETURN "ADM-ERROR".
     END.
      
/*     /*** CORRELATIVO AUTOMATICO  
 *      FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
 *                           AND  FacCorre.CodDoc = "G/R" 
 *                           AND  FacCorre.CodDiv = S-CODDIV 
 *                           AND  FacCorre.NroSer = S-NROSER  
 *                          EXCLUSIVE-LOCK NO-ERROR.
 *      IF AVAILABLE FacCorre THEN DO:
 *         ASSIGN Almcmov.NroDoc = FacCorre.Correlativo.
 *                FacCorre.Correlativo = FacCorre.Correlativo + 1.
 *      END.
 *      RELEASE FacCorre.
 *      ****/*/
     
     /* ACEPTA EL DOCUMENTO INGRESADO */
     ASSIGN FILL-IN_NroDoc.
     ASSIGN Almcmov.Nrodoc = INTEGER(SUBSTRING(FILL-IN_NroDoc,4,6)).

     IF ERROR-STATUS:ERROR THEN DO:
        UNDO, RETURN "ADM-ERROR".
     END.

     FIND FIRST FacCorre WHERE 
                FacCorre.CodCia = S-CODCIA AND  
                FacCorre.CodDoc = "G/R" AND  
                FacCorre.CodDiv = S-CODDIV AND  
                FacCorre.NroSer = S-NROSER  EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN "ADM-ERROR".
    IF INTEGER(SUBSTRING(FILL-IN_NroDoc,4,6)) >= FacCorre.Correlativo 
    THEN FacCorre.Correlativo = INTEGER(SUBSTRING(FILL-IN_NroDoc,4,6)) + 1.
    RELEASE FacCorre.
    /*********************************/
    FILL-IN_NroDoc:SENSITIVE = False.
  END.
  ASSIGN Almcmov.usuario = S-USER-ID
         Almcmov.Nrorf3. 
                
  /* Verificamos si genera pedido automatico */  
  IF NOT L-CREA AND Almcmov.NroRf1 <> "" 
  THEN DO:
    RUN Restaura-Pedido.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  
  /* ELIMINAMOS EL DETALLE ANTERIOR */
  IF NOT L-CREA 
  THEN DO:
    RUN Borra-Detalle.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
    
  RUN Genera-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
 
  /* Verificamos si genera pedido automatico */
  IF Almcmov.NroRf1 <> ""  
  THEN DO:
    RUN Actualiza-Pedido.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.

    /****   Genera Ingreso por Traslado *****/
/*    RUN get-attribute('ADM-NEW-RECORD').
 *     IF RETURN-VALUE = 'YES' THEN DO :
 *        CREATE Almcmov.
 *        ASSIGN Almcmov.CodCia  = Almtdocm.CodCia
 *               Almcmov.CodAlm  = Almcmov.AlmDes:SCREEN-VALUE
 *               Almcmov.TipMov  = "I"
 *               Almcmov.CodMov  = I-MOVDES
 *               Almcmov.NroSer  = 000
 *               Almcmov.FlgSit  = ""
 *               Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS").
 *               Almcmov.NomRef  = F-NomDes:SCREEN-VALUE IN FRAME {&FRAME-NAME}.            
 *               
 *        IF ERROR-STATUS:ERROR THEN RETURN "ADM-ERROR".
 *        
 *        FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
 *                      AND  Almacen.CodAlm = Almcmov.CodAlm
 *                     EXCLUSIVE-LOCK NO-ERROR.
 *        IF AVAILABLE Almacen THEN ASSIGN Almcmov.NroDoc = Almacen.CorrIng
 *                                        Almacen.CorrIng = Almacen.CorrIng + 1.
 *        RELEASE Almacen.
 *        
 *     END.
 *     
 *     RUN Genera-Detalle-Destino.*/
    
    /****************************************/
    
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
  
  RUN valida-update.
  IF RETURN-VALUE = "ADM-ERROR" THEN  RETURN ERROR.

  /* Solo marcamos el FlgEst como Anulado */
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
     RUN Restaura-Pedido.
     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
     RUN Borra-Detalle.
     IF RETURN-VALUE = 'ADM-ERROR' 
     THEN DO:
        MESSAGE 'No se pudo eliminar el detalle'
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
     END.
     FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia AND
                  CMOV.CodAlm = Almcmov.CodAlm AND
                  CMOV.TipMov = Almcmov.TipMov AND
                  CMOV.CodMov = Almcmov.CodMov AND
                  CMOV.NroSer = Almcmov.NroSer AND 
                  CMOV.NroDoc = Almcmov.NroDoc EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE CMOV
    THEN DO:
        RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
        UNDO, RETURN "ADM-ERROR".
    END.
    ASSIGN CMOV.FlgEst = 'A'
            CMOV.Observ = "      A   N   U   L   A   D   O       "
            CMOV.Usuario = S-USER-ID.
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
     ASSIGN Almcmov.NroRf1:VISIBLE = Almtmovm.PidRef1
            Almcmov.NroRf2:VISIBLE = Almtmovm.PidRef2
                          I-CODMON = Almtmovm.CodMon.
     IF Almtmovm.PidRef1 THEN ASSIGN Almcmov.NroRf1:LABEL = Almtmovm.GloRf1.
     IF Almtmovm.PidRef2 THEN ASSIGN Almcmov.NroRf2:LABEL = Almtmovm.GloRf2.
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
  
  /* Definimos impresoras */
/*  IF LOOKUP(TRIM(s-CodAlm), '11,83,04,48,24,03,05') = 0
 *         OR S-NROSER = 0 THEN DO: */
/*MLR* 10/01/08 * A solicitud de Victor Fernandez *
  IF S-NROSER = 0 OR LOOKUP(TRIM(s-CodAlm), '22,85') > 0 THEN DO: 
* ***/
/*MLR* 10/01/08 */
  IF S-NROSER = 0 OR LOOKUP(TRIM(s-CodAlm), '22') > 0 THEN DO: 
    DEF VAR Rpta-1 AS LOG NO-UNDO.
    SYSTEM-DIALOG PRINTER-SETUP UPDATE Rpta-1.
    IF Rpta-1 = NO THEN RETURN.
    
    DO M = 1 TO 2:
        S-TOTPES = 0.
        
/*        DEFINE VAR s-printer-list AS CHAR.
 *         DEFINE VAR s-port-list AS CHAR.
 *         DEFINE VAR s-port-name AS CHAR format "x(20)".
 *         DEFINE VAR s-printer-count AS INTEGER.
 *         RUN aderb/_prlist.p(
 *             OUTPUT s-printer-list,
 *             OUTPUT s-port-list,
 *             OUTPUT s-printer-count).*/
        
        I-NroSer = S-NROSER.
        FIND FIRST FacCorre WHERE 
                   FacCorre.CodCia = S-CODCIA AND
                   FacCorre.CodDoc = "G/R"    AND
                   FacCorre.CodDiv = S-CODDIV AND
                   FacCorre.NroSer = S-NROSER 
                   NO-LOCK NO-ERROR.

/*        /*MLR* 07/12/07 Nueva librería de impresión ***/
 *         RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
 *         IF s-port-name = '' THEN RETURN.*/

        /* FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND 
             FacCorre.CodAlm = S-CODALM AND
             FacCorre.CodDoc = "G/R" AND
             FacCorre.NroSer = I-NroSer NO-LOCK.  */

/*MLR* 07/12/07 ***
 *         IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
 *            MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
 *            RETURN.
 *         END.
 *         
 *         s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
 *         s-port-name = REPLACE(S-PORT-NAME, ":", "").
 * */
      
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
             Almmmatg.DesMat    AT  18  FORMAT "X(50)"
             Almmmatg.Desmar    AT  70  FORMAT "X(20)"
             Almdmov.CanDes     AT  92  FORMAT ">>>>,>>9.99" 
             Almdmov.CodUnd     AT  104 FORMAT "X(4)" 
             Almmmate.CodUbi    AT  112     
             HEADER
             SKIP(1)
             {&PRN2} + {&PRN7A} + {&PRN6A} + "GUIA DE TRANSFERENCIA" + {&PRN7B} + {&PRN3} + {&PRN6B} AT 30 FORMAT "X(40)" 
             {&PRN2} + {&PRN6A} + STRING(Almcmov.NroDoc,"999999")  + {&PRN3} + {&PRN6B}  AT 80 FORMAT "X(20)" SKIP(1)
             "Almacen : " Almcmov.CodAlm + " - " + C-DIRPRO FORMAT "X(60)" 
              Almcmov.FchDoc AT 106 SKIP
             "Destino : " Almcmov.Almdes + " - " + C-DESALM AT 15 FORMAT "X(60)" SKIP
/*             C-DIRALM AT 15 FORMAT "X(60)"  Almcmov.NroRf1 AT 106 SKIP(1)*/
/*"GUIA TRANS. " AT 17 FORMAT "X(8)" */
             "Observaciones    : "  Almcmov.Observ FORMAT "X(40)"  SKIP              
             /* {&PRND} + "P R O D U C T O S" + {&PRN6B} AT 50 FORMAT "X(55)" 
             /*"G/R:" AT 100 (STRING(Almcmov.NroSer,"999") + STRING(Almcmov.NroDoc,"999999")) FORMAT "X(10)" AT 106 SKIP*/ */
             "----------------------------------------------------------------------------------------------------------------------" SKIP
             "     CODIGO      DESCRIPCION                                                                    CANTIDAD UM       " SKIP
             "----------------------------------------------------------------------------------------------------------------------" SKIP
             WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 160 STREAM-IO DOWN.
             
/*      OUTPUT STREAM Reporte TO VALUE(s-port-name) PAGED PAGE-SIZE 31.*/
      
      OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 31.
            
      FIND FIRST Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia 
                          AND  Almdmov.CodAlm = Almcmov.CodAlm 
                          AND  Almdmov.TipMov = Almcmov.TipMov 
                          AND  Almdmov.CodMov = Almcmov.CodMov 
                          AND  Almdmov.NroDoc = Almcmov.NroDoc 
                         USE-INDEX Almd01 NO-LOCK NO-ERROR.
      IF AVAILABLE Almdmov THEN DO:
         PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(34) + {&PRN3}.     
         REPEAT WHILE  AVAILABLE  AlmDMov      AND Almdmov.CodAlm = Almcmov.CodAlm AND
               Almdmov.TipMov = Almcmov.TipMov AND Almdmov.CodMov = Almcmov.CodMov AND
               Almdmov.NroDoc = Almcmov.NroDoc:
               FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                              AND  Almmmatg.CodMat = Almdmov.CodMat 
                             NO-LOCK NO-ERROR.
               FIND Almmmate WHERE Almmmate.Codcia = Almdmov.Codcia AND 
                                   Almmmate.Codalm = Almdmov.CodAlm AND
                                   Almmmate.Codmat = Almdmov.Codmat
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
                       Almmmate.CodUbi
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
  ELSE       
         IF AlmCmov.FlgEst <> "A" THEN RUN ALM\R-ImpGui.R(ROWID(Almcmov)).
      
  
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
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
  
  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('browse').
  
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Restaura-Pedido V-table-Win 
PROCEDURE Restaura-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF almcmov.nrorf1 <> ''
  THEN DO:
    FIND Almcrequ WHERE 
           Almcrequ.CodCia = Almcmov.codcia AND
           Almcrequ.CodAlm = Almcmov.AlmDes AND
           Almcrequ.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1,1,3)) AND
           Almcrequ.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1,4,6)) EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
    IF NOT AVAILABLE Almcrequ THEN DO:
/*MLR* ***
        RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
*MLR* ***/
        MESSAGE "Registro de Referencia no DISPONIBLE" VIEW-AS ALERT-BOX.
        RETURN "ADM-ERROR".
    END.
    Almcrequ.FlgEst = "P".
    FOR EACH Almdmov OF Almcmov NO-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
        FIND Almdrequ WHERE 
                 Almdrequ.CodCia = Almdmov.CodCia 
             AND Almdrequ.CodAlm = Almcmov.Almdes 
             AND Almdrequ.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1,1,3))
             AND Almdrequ.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1,4,6))
             AND Almdrequ.CodMat = almdmov.codmat EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF NOT AVAILABLE Almdrequ
        THEN DO:
            RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
            UNDO, RETURN "ADM-ERROR".
        END.
        Almdrequ.CanDes = Almdrequ.CanDes - Almdmov.candes.
        RELEASE Almdrequ.
    END.
    RELEASE Almcrequ.
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
     Almcmov.NroRf1:SENSITIVE = NO.
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
   I-NRO = 0.
   FOR EACH ITEM WHERE ITEM.CanDes > 0:
       I-NRO = I-NRO + 1.
   END.
   IF I-NRO = 0 THEN DO:
      MESSAGE "No existen articulos a transferir" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.NroRf1.
      RETURN "ADM-ERROR".
   END.
/*   FIND AlmCierr WHERE 
 *         AlmCierr.CodCia = S-CODCIA AND 
 *         AlmCierr.FchCie = INPUT Almcmov.FchDoc 
 *         NO-LOCK NO-ERROR.
 *    IF AVAILABLE AlmCierr AND
 *       AlmCierr.FlgCie THEN DO:
 *       MESSAGE "Este dia " AlmCierr.FchCie " se encuentra cerrado" SKIP 
 *               "Consulte con sistemas " VIEW-AS ALERT-BOX INFORMATION.
 *       RETURN "ADM-ERROR".
 *    END.*/
   
   FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
   IF I-NRO >  FacCfgGn.Items_Guias THEN DO:
      MESSAGE "Numero de Items Mayor al Configurado para el Tipo de Documento " skip
              "Items Por Guia : " +  STRING(FacCfgGn.Items_Guias,"999") VIEW-AS ALERT-BOX INFORMATION.
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
DEF VAR RPTA AS CHARACTER.

IF NOT AVAILABLE Almcmov THEN DO:
   MESSAGE "No existe registros" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.

IF Almcmov.FlgEst = 'A' THEN DO:
   MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.

IF Almcmov.FlgSit  = "R" THEN DO:
   MESSAGE "Transferencia recepcionada, no puede se modificada" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.

    RUN alm/p-ciealm-01 (Almcmov.FchDoc, s-CodAlm).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN "ADM-ERROR".


  /* RHC 09.07.08 CONTROL DE SERIES ACIVAS */
  FIND FIRST FacCorre WHERE FacCorre.CodCia = Almcmov.codcia
      AND FacCorre.CodDoc = "G/R"    
      AND FacCorre.CodDiv = S-CODDIV 
      AND FacCorre.NroSer = Almcmov.nroser
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = No THEN DO:
      MESSAGE 'La serie se encuentra INACTIVA' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
    

    FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                  AND  Almacen.CodAlm = S-CODALM 
                 NO-LOCK NO-ERROR.
    RUN ALM/D-CLAVE.R(Almacen.Clave,OUTPUT RPTA).
    IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".

    /* consistencia de la fecha del cierre del sistema */
    DEF VAR dFchCie AS DATE.
    RUN gn/fecha-de-cierre (OUTPUT dFchCie).
    IF almcmov.fchdoc <= dFchCie THEN DO:
        MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
            VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
    /* fin de consistencia */

C-CODALM = Almcmov.CodAlm.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

