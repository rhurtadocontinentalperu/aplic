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
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-DESALM AS CHAR.
DEFINE SHARED VAR S-CODMOV AS INTEGER.
DEFINE SHARED VAR ORDTRB   AS CHAR.

DEFINE        VAR C-DESALM AS CHAR.
DEFINE        VAR I-CODMON AS INTEGER.
DEFINE        VAR R-ROWID  AS ROWID.
DEFINE        VAR D-FCHDOC AS DATE.
DEFINE        VAR F-TPOCMB AS DECIMAL.
DEFINE        VAR I-NRO    AS INTEGER NO-UNDO.
DEFINE        VAR S-OBSER  AS CHAR NO-UNDO.
DEFINE        VAR I-MOVORI AS INTEGER NO-UNDO.
DEFINE        VAR L-CREA   AS LOGICAL NO-UNDO.

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

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES Almcmov Almtdocm
&Scoped-define FIRST-EXTERNAL-TABLE Almcmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almcmov, Almtdocm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almcmov.NroRf2 Almcmov.Observ 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define ENABLED-OBJECTS RECT-3 
&Scoped-Define DISPLAYED-FIELDS Almcmov.AlmDes Almcmov.NroRf1 ~
Almcmov.NroRf2 Almcmov.NroRf3 Almcmov.Observ Almcmov.NroDoc Almcmov.FchDoc ~
Almcmov.usuario 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-NomDes 

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
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-NomDes AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.43 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 3.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Estado AT ROW 1.12 COL 42.86 COLON-ALIGNED NO-LABEL
     Almcmov.AlmDes AT ROW 1.88 COL 13.29 COLON-ALIGNED
          LABEL "Almacen Origen" FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     F-NomDes AT ROW 1.88 COL 19.14 COLON-ALIGNED NO-LABEL
     Almcmov.NroRf1 AT ROW 1.88 COL 73 COLON-ALIGNED
          LABEL "Referencia 1" FORMAT "XXXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.NroRf2 AT ROW 2.58 COL 73 COLON-ALIGNED
          LABEL "Referencia 2"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.NroRf3 AT ROW 3.27 COL 73.14 COLON-ALIGNED
          LABEL "O/T" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.Observ AT ROW 2.65 COL 13.29 COLON-ALIGNED NO-LABEL FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 46.29 BY .69
     Almcmov.NroDoc AT ROW 1.19 COL 13.29 COLON-ALIGNED
          LABEL "No. Documento"
          VIEW-AS FILL-IN 
          SIZE 9.57 BY .69
          FONT 0
     Almcmov.FchDoc AT ROW 1.19 COL 73 COLON-ALIGNED FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.usuario AT ROW 3.35 COL 13.29 COLON-ALIGNED
          LABEL "Usuario" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     "Observaciones" VIEW-AS TEXT
          SIZE 10.43 BY .5 AT ROW 2.77 COL 3.86
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
         HEIGHT             = 3.31
         WIDTH              = 87.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Almcmov.AlmDes IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almcmov.NroRf1 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Almcmov.NroRf2 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf3 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
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

&Scoped-define SELF-NAME Almcmov.AlmDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.AlmDes V-table-Win
ON LEAVE OF Almcmov.AlmDes IN FRAME F-Main /* Almacen Origen */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN NO-APPLY.
  IF SELF:SCREEN-VALUE = S-CODALM THEN DO:
     MESSAGE "Almacen " S-CODALM " No puede transferir a si mismo" VIEW-AS ALERT-BOX.
     RETURN NO-APPLY.
  END.
  FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia 
                AND  Almacen.CodAlm = Almcmov.AlmDes:SCREEN-VALUE  
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almacen THEN DO:
     MESSAGE "Almacen Destino no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  F-NomDes:SCREEN-VALUE = Almacen.Descripcion.
  Almcmov.Almdes:SENSITIVE = FALSE.
  RETURN NO-APPLY.
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
/*      CMOV.NroDoc = INTEGER(Almcmov.NroRf1:SCREEN-VALUE) NO-LOCK NO-ERROR.*/

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
   DISPLAY CMOV.NroRf1 @ Almcmov.NroRf2 
           STRING(CMOV.Nrorf3,"999") + STRING(CMOV.NroDoc,"999999") @ Almcmov.Nrorf3 WITH FRAME {&FRAME-NAME}.
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
FOR EACH ITEM:
    DELETE ITEM.
END.
IF I-EST = 2 THEN DO:
   FOR EACH Almdmov NO-LOCK WHERE 
            Almdmov.CodCia = Almcmov.CodCia AND  
            Almdmov.CodAlm = Almcmov.CodAlm AND  
            Almdmov.TipMov = Almcmov.TipMov AND  
            Almdmov.CodMov = Almcmov.CodMov AND  
            Almdmov.NroSer = Almcmov.NroSer AND  
            Almdmov.NroDoc = Almcmov.NroDoc:
       CREATE ITEM.
       RAW-TRANSFER Almdmov TO ITEM.
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
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN LKUP/C-TRFSAL.
  IF output-var-1 = ? THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  F-TOTORI = 0.
  F-TOTDES = 0.  
  L-CREA = YES.
  RUN Actualiza-ITEM (1).
  DO WITH FRAME {&FRAME-NAME}:
     
     FIND CMOV WHERE ROWID(CMOV) = output-var-1 NO-LOCK NO-ERROR.
     FIND Almacen WHERE Almacen.codcia = s-codcia
         AND Almacen.codalm = CMOV.codalm
         NO-LOCK.
     FIND Almtdocm WHERE Almtdocm.CodCia = S-CODCIA
                    AND  Almtdocm.CodAlm = S-CODALM
                    AND  Almtdocm.TipMov = "I"
                    AND  Almtdocm.CodMov = S-CODMOV
                   NO-LOCK NO-ERROR.
     IF AVAIL Almtdocm THEN DISPLAY Almtdocm.NroDoc @ Almcmov.NroDoc.
  
     FOR EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = CMOV.CodCia 
                               AND  Almdmov.CodAlm = CMOV.CodAlm 
                               AND  Almdmov.TipMov = CMOV.TipMov 
                               AND  Almdmov.CodMov = CMOV.CodMov 
                               AND  Almdmov.NroSer = CMOV.NroSer
                               AND  Almdmov.NroDoc = CMOV.NroDoc:
       CREATE ITEM.
       ASSIGN ITEM.CodCia = Almdmov.CodCia
              ITEM.CodAlm = Almdmov.CodAlm
              ITEM.codmat = Almdmov.codmat 
              ITEM.PreUni = Almdmov.PreUni 
              ITEM.CanDes = Almdmov.CanDes 
              ITEM.Factor = Almdmov.Factor 
              ITEM.ImpCto = Almdmov.ImpCto
              ITEM.CodUnd = Almdmov.CodUnd.
       F-TOTORI = F-TOTORI + Almdmov.CanDes.
     END.  

     DISPLAY TODAY       @ Almcmov.FchDoc
             CMOV.nrorf3 @ Almcmov.Nrorf3
             CMOV.CodAlm @ Almcmov.AlmDes
             STRING(CMOV.NroSer,"999") + STRING(CMOV.NroDoc,"999999") @ Almcmov.Nrorf1
             Almacen.Descripcion @ F-NomDes.

     Almcmov.Almdes:SENSITIVE  = NO.     
     Almcmov.NroRf2 :SENSITIVE = NO.
             
  
  
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
  Notes:       
------------------------------------------------------------------------------*/
  
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN Almcmov.usuario = S-USER-ID. 
  RUN get-attribute('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO :
     ASSIGN Almcmov.CodCia  = Almtdocm.CodCia 
            Almcmov.CodAlm  = Almtdocm.CodAlm 
            Almcmov.TipMov  = Almtdocm.TipMov 
            Almcmov.CodMov  = Almtdocm.CodMov 
            Almcmov.NroSer  = 000
            Almcmov.FlgSit  = ""
            Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
            Almcmov.NomRef  = F-NomDes:SCREEN-VALUE IN FRAME {&FRAME-NAME}            
            Almcmov.Nrorf1  = Almcmov.Nrorf1:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            Almcmov.Nrorf2  = Almcmov.Nrorf2:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            Almcmov.Nrorf3  = Almcmov.Nrorf3:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            Almcmov.AlmDes  = Almcmov.AlmDes:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
       IF ERROR-STATUS:ERROR THEN RETURN "ADM-ERROR".

    FIND Almtdocm WHERE
          Almtdocm.CodCia = S-CODCIA AND
          Almtdocm.CodAlm = S-CODALM AND
          Almtdocm.TipMov = "I" AND
          Almtdocm.CodMov = S-CODMOV
          EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        Almcmov.NroDoc  = Almtdocm.NroDoc
        Almtdocm.NroDoc = Almtdocm.NroDoc + 1.
    RELEASE Almtdocm.
    DISPLAY Almcmov.NroDoc @ Almcmov.NroDoc WITH FRAME {&FRAME-NAME}.
  END.

  RUN Borra-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN Genera-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  IF L-CREA THEN DO:
    FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia 
                AND  CMOV.CodAlm = Almcmov.AlmDes 
                AND  CMOV.TipMov = "S" 
                AND  CMOV.CodMov = I-MOVORI 
                AND  CMOV.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1,1,3)) 
                AND  CMOV.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1,4,6)) 
               EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    IF CMOV.FlgSit <> "T" THEN DO:
        MESSAGE 'NO se puede hacer la transferencia' SKIP
            'La guia ha sido alterada' SKIP
            'Revisar el documento original en el sistema'
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN "ADM-ERROR".
    END.
    ASSIGN 
        CMOV.FlgSit  = "R" 
        CMOV.HorRcp  = STRING(TIME,"HH:MM:SS")
        CMOV.NroRf2  = STRING(Almcmov.NroDoc, "999999").
    IF F-TOTORI <> F-TOTDES THEN ASSIGN CMOV.FlgEst = "D".
    RELEASE CMOV.
  END.
  
  /****     Genera la salida por transferencia  ****/
/*  RUN get-attribute('ADM-NEW-RECORD').
 *   IF RETURN-VALUE = 'YES' THEN DO :
 *      CREATE Almcmov.
 *      ASSIGN Almcmov.CodCia  = Almtdocm.CodCia
 *             Almcmov.CodAlm  = Almcmov.AlmDes:SCREEN-VALUE
 *             Almcmov.AlmDes  = S-CODALM
 *             Almcmov.TipMov  = "S"
 *             Almcmov.CodMov  = I-MOVORI
 *             Almcmov.FlgSit  = "T"
 *             Almcmov.HorSal  = STRING(TIME,"HH:MM:SS").
 *      FIND LAST CMOV WHERE CMOV.Codcia = s-codcia 
 *                      AND  CMOV.TipMov = "S"
 *                      AND  CMOV.CodMov = I-MOVORI 
 *                     NO-LOCK NO-ERROR.
 *      IF AVAILABLE CMOV THEN ASSIGN Almcmov.NroDoc  = CMOV.NroDoc + 1.
 *      ELSE ASSIGN Almcmov.NroDoc  = 1.
 *   END.
 * 
 *   RUN Genera-Detalle-Origen.*/
  
  /**************************************************/

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
  
  RUN valida-update.
  IF RETURN-VALUE = "ADM-ERROR" THEN  RETURN ERROR.

  /* Solo marcamos el FlgEst como Anulado */
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
     RUN Borra-Detalle.
     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
     FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia 
                AND  CMOV.CodAlm = Almcmov.CodAlm 
                AND  CMOV.TipMov = Almcmov.TipMov 
                AND  CMOV.CodMov = Almcmov.CodMov 
                AND  CMOV.NroDoc = Almcmov.NroDoc 
               EXCLUSIVE-LOCK NO-ERROR.
     IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
     IF AVAILABLE CMOV THEN
        ASSIGN CMOV.FlgEst = 'A'
               CMOV.Observ = "      A   N   U   L   A   D   O       "
              CMOV.Usuario = S-USER-ID.
     RELEASE CMOV.
     FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia 
                AND  CMOV.CodAlm = Almcmov.AlmDes 
                AND  CMOV.TipMov = "S" 
                AND  CMOV.CodMov = I-MOVORI 
                AND  CMOV.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1,1,3)) 
                AND  CMOV.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1,4,6)) 
               EXCLUSIVE-LOCK NO-ERROR.
     IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
     IF AVAILABLE CMOV THEN 
        ASSIGN CMOV.FlgSit  = "T"
               CMOV.HorRcp  = STRING(TIME,"HH:MM:SS").
     RELEASE CMOV.
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
     FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia 
                   AND  Almacen.CodAlm = Almcmov.AlmDes  
                  NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN F-NomDes:SCREEN-VALUE = Almacen.Descripcion.
     ELSE F-NomDes:SCREEN-VALUE = "".
     F-Estado:SCREEN-VALUE = "".
     IF Almcmov.FlgEst  = "A" THEN F-Estado:SCREEN-VALUE = "  ANULADO   ".  
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
  IF AVAILABLE Almcmov AND 
     Almcmov.FlgEst <> "A" THEN RUN ALM\R-IMPFMT.R(ROWID(almcmov)).
     
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
     RUN Actualiza-ITEM(2).
     RUN Procesa-Handle IN lh_Handle ('Pagina2').
     RUN Procesa-Handle IN lh_Handle ('browse').
     Almcmov.NroRf1:SENSITIVE = NO.
     Almcmov.NroRf2:SENSITIVE = NO.
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
    /* Verificamos la salida por transferencia */
    FIND CMOV WHERE CMOV.CodCia = s-CodCia 
        AND CMOV.CodAlm = Almcmov.AlmDes:SCREEN-VALUE
        AND CMOV.TipMov = "S" 
        AND CMOV.CodMov = I-MOVORI 
        AND CMOV.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1:SCREEN-VALUE,1,3)) 
        AND CMOV.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1:SCREEN-VALUE,4,6)) 
        NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'No se encontro la salida por transferencia' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF CMOV.FlgSit = 'R' THEN DO:
        MESSAGE 'La salida por transferencia ya fue recepcionada' VIEW-AS ALERT-BOX ERROR.
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
       IF AVAILABLE Almmmatg THEN DO:
          IF LOOKUP(TRIM(S-CODALM),trim(Almmmatg.almacenes)) = 0 THEN DO:
             MESSAGE 'Producto ' + ITEM.Codmat + ' no se encuentra asignado al Almacen' skip
             "en el Catalogo de Materiales" VIEW-AS ALERT-BOX ERROR.
             ok = FALSE.
          END.
        END.
       ELSE DO:
          MESSAGE 'Producto no se encuentra registrado' VIEW-AS ALERT-BOX ERROR.
          ok = FALSE.
       END.
       FIND Almmmate WHERE Almmmate.CodCia = s-codcia 
                      AND  Almmmate.codalm = S-CODALM 
                      AND  Almmmate.codmat = ITEM.Codmat 
                     NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Almmmate THEN DO:
          MESSAGE 'Producto ' + ITEM.Codmat + ' no se encuentra asignado al Almacen' skip
          VIEW-AS ALERT-BOX ERROR.
          ok = FALSE.
       END.
       
   END.
   IF ok = FALSE THEN RETURN "ADM-ERROR".
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
/* RHC 01/12/17 NO MODIFICAR */
MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
RETURN 'ADM-ERROR'.
/* ************************* */

RUN alm/p-ciealm-01 (Almcmov.FchDoc, s-CodAlm).
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN "ADM-ERROR".

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

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

