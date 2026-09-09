&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
DEFINE        VAR C-DESALM AS CHAR.
DEFINE        VAR I-CODMON AS INTEGER.
DEFINE        VAR R-ROWID  AS ROWID.
DEFINE        VAR D-FCHDOC AS DATE.
DEFINE        VAR F-TPOCMB AS DECIMAL.
DEFINE        VAR I-NRO    AS INTEGER NO-UNDO.
DEFINE        VAR S-OBSER  AS CHAR NO-UNDO.
DEFINE SHARED TEMP-TABLE ITEM LIKE almdmov.
DEFINE SHARED VAR s-pedvta AS LOGICAL.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES Almcmov Almtdocm
&Scoped-define FIRST-EXTERNAL-TABLE Almcmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almcmov, Almtdocm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almcmov.FchDoc Almcmov.AlmDes Almcmov.NroRf1 ~
Almcmov.NroRf2 Almcmov.Observ 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}FchDoc ~{&FP2}FchDoc ~{&FP3}~
 ~{&FP1}AlmDes ~{&FP2}AlmDes ~{&FP3}~
 ~{&FP1}NroRf1 ~{&FP2}NroRf1 ~{&FP3}~
 ~{&FP1}NroRf2 ~{&FP2}NroRf2 ~{&FP3}~
 ~{&FP1}Observ ~{&FP2}Observ ~{&FP3}
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define ENABLED-OBJECTS RECT-3 
&Scoped-Define DISPLAYED-FIELDS Almcmov.NroDoc Almcmov.FchDoc ~
Almcmov.AlmDes Almcmov.NroRf1 Almcmov.NroRf2 Almcmov.Observ 

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
DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87 BY 2.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almcmov.NroDoc AT ROW 1.19 COL 13.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .69
     Almcmov.FchDoc AT ROW 1.19 COL 73 COLON-ALIGNED FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.AlmDes AT ROW 1.88 COL 13.29 COLON-ALIGNED
          LABEL "Almacen Destino"
          VIEW-AS FILL-IN 
          SIZE 6.29 BY .69
     Almcmov.NroRf1 AT ROW 1.88 COL 73 COLON-ALIGNED
          LABEL "Referencia 1"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.NroRf2 AT ROW 2.58 COL 73 COLON-ALIGNED
          LABEL "Referencia 2"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.Observ AT ROW 2.58 COL 13.29 COLON-ALIGNED NO-LABEL FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 46.29 BY .69
     RECT-3 AT ROW 1 COL 1
     "Observaciones" VIEW-AS TEXT
          SIZE 10.43 BY .5 AT ROW 2.65 COL 3.86
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 2.58
         WIDTH              = 87.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Almcmov.AlmDes IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almcmov.NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf1 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf2 IN FRAME F-Main
   EXP-LABEL                                                            */
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Almcmov.AlmDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.AlmDes V-table-Win
ON LEAVE OF Almcmov.AlmDes IN FRAME F-Main /* Almacen Destino */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  IF SELF:SCREEN-VALUE = S-CODALM THEN DO:
     MESSAGE "Almacen " S-CODALM " No puede transferir a si mismo" VIEW-AS ALERT-BOX.
     RETURN NO-APPLY.
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
DEFINE INPUT PARAMETER I-EST AS INTEGER.
FOR EACH ITEM:
    DELETE ITEM.
END.
IF I-EST = 2 THEN DO:
   FOR EACH Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia 
                     AND  Almdmov.CodAlm = Almcmov.CodAlm 
                     AND  Almdmov.TipMov = Almcmov.TipMov 
                     AND  Almdmov.CodMov = Almcmov.CodMov 
                     AND  Almdmov.NroDoc = Almcmov.NroDoc 
                     AND  Almdmov.NroSer = Almdmov.NroSer:
       CREATE ITEM.
       ASSIGN ITEM.CodCia = Almdmov.CodCia
              ITEM.CodAlm = Almdmov.CodAlm
              ITEM.codmat = Almdmov.codmat 
              ITEM.PreUni = Almdmov.PreUni 
              ITEM.CanDes = Almdmov.CanDes 
              ITEM.Factor = Almdmov.Factor 
              ITEM.ImpCto = Almdmov.ImpCto
              ITEM.CodUnd = Almdmov.CodUnd
              ITEM.Pesmat = Almdmov.Pesmat.
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
    /*I-NRO = 0.
      FOR EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = Almcmov.CodCia 
                                AND  Almdmov.CodAlm = Almcmov.CodAlm 
                                AND  Almdmov.TipMov = Almcmov.TipMov 
                                AND  Almdmov.CodMov = Almcmov.CodMov 
                                AND  Almdmov.NroDoc = Almcmov.NroDoc 
                                AND  Almdmov.NroSer = Almdmov.NroSer:
          FIND Almdrequ WHERE Almdrequ.CodCia = Almdmov.CodCia 
                         AND  Almdrequ.CodAlm = Almcmov.Almdes 
                         AND  Almdrequ.NroDoc = INTEGER(Almcmov.NroRf1)
                         AND  Almdrequ.CodMat = almdmov.codmat NO-ERROR.
          IF AVAILABLE Almdrequ THEN Almdrequ.CanDes = Almdrequ.CanDes + Almdmov.candes.
          RELEASE Almdrequ.
      END.
      FOR EACH Almdrequ NO-LOCK WHERE Almdrequ.CodCia = Almcmov.CodCia 
                                 AND  Almdrequ.CodAlm = Almcmov.AlmDes 
                                 AND  Almdrequ.NroDoc = INTEGER(Almcmov.NroRf1):
          IF (Almdrequ.CanReq - Almdrequ.CanDes) > 0 THEN I-NRO = I-NRO + 1.
      END.
      IF I-NRO = 0 THEN DO: 
         FIND Almcrequ WHERE Almcrequ.CodCia = Almcmov.codcia 
                        AND  Almcrequ.CodAlm = Almcmov.AlmDes 
                        AND  Almcrequ.NroDoc = INTEGER(Almcmov.NroRf1) 
                       EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE Almcrequ THEN 
            ASSIGN Almcrequ.FlgEst = "C"
                   Almcrequ.Observ = S-OBSER.
         RELEASE Almcrequ.
      END.  */
      
      FIND Almcrequ WHERE Almcrequ.CodCia = Almcmov.codcia 
                     AND  Almcrequ.CodAlm = Almcmov.AlmDes 
                     AND  Almcrequ.NroDoc = INTEGER(Almcmov.NroRf1) 
                    EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE Almcrequ THEN 
         ASSIGN Almcrequ.FlgEst = "C"
                Almcrequ.Observ = S-OBSER.
      RELEASE Almcrequ.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalle-Destino V-table-Win 
PROCEDURE Borra-Detalle-Destino :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Eliminamos el detalle para el almacen de Destino */
  FOR EACH Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia 
                    AND  Almdmov.CodAlm = Almcmov.AlmDes 
                    AND  Almdmov.TipMov = "R"            
                    AND  Almdmov.CodMov = Almcmov.CodMov 
                    AND  Almdmov.NroDoc = Almcmov.NroDoc:
           ASSIGN R-ROWID = ROWID(Almdmov).
           RUN ALM\ALMDCSTK (R-ROWID).   /* Descarga del Almacen POR INGRESOS */
           RUN ALM\ALMACPR1 (R-ROWID,"D").
           RUN ALM\ALMACPR2 (R-ROWID,"D").
      DELETE Almdmov.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalle-Origen V-table-Win 
PROCEDURE Borra-Detalle-Origen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Eliminamos el detalle para el almacen de Origen */
  FOR EACH Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia 
                    AND  Almdmov.CodAlm = Almcmov.CodAlm 
                    AND  Almdmov.TipMov = Almcmov.TipMov 
                    AND  Almdmov.CodMov = Almcmov.CodMov 
                    AND  Almdmov.NroDoc = Almcmov.NroDoc:
           ASSIGN R-ROWID = ROWID(Almdmov).
           RUN ALM\ALMCGSTK (R-ROWID).     /* Ingresa al Almacen POR SALIDAS */
           RUN ALM\ALMACPR1 (R-ROWID,"D").
           RUN ALM\ALMACPR2 (R-ROWID,"D").
      DELETE Almdmov.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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
   FOR EACH ITEM:
       RUN Graba-Detalle-Origen.
       RUN Graba-Detalle-Destino.
   END.
   RUN Procesa-Handle IN lh_Handle ('browse').

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
  DEFINE VARIABLE I-ITM AS INTEGER INIT 0 EXTENT 2 NO-UNDO.
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Verificamos si genera pedido automatico */  
  FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almtdocm.CodCia 
                       AND  Almtmovm.Tipmov = Almtdocm.TipMov 
                       AND  Almtmovm.Codmov = Almtdocm.CodMov 
                      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm AND Almtmovm.PidOdt THEN DO WITH FRAME {&FRAME-NAME}:
      input-var-1 = Almcmov.AlmDes:SCREEN-VALUE.
      RUN LKUP\C-REPOSI.R("Reposiciones Pendientes").
      IF output-var-1 = ? OR output-var-2 =  "" OR output-var-3 =  "" THEN RETURN.
      DISPLAY output-var-3 @ Almcmov.AlmDes 
              output-var-2 @ Almcmov.NroRf1.
      FOR EACH ITEM:
          DELETE ITEM.
      END.
      FIND Almcrequ WHERE ROWID(Almcrequ) = output-var-1 NO-LOCK NO-ERROR.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Detalle-Destino V-table-Win 
PROCEDURE Graba-Detalle-Destino :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
       CREATE almdmov.
       ASSIGN Almdmov.CodCia = Almcmov.CodCia 
              Almdmov.CodAlm = Almcmov.AlmDes 
              Almdmov.TipMov = "R"
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
              Almdmov.AlmOri = Almcmov.CodAlm
              Almdmov.CodAjt = ''
                     R-ROWID = ROWID(Almdmov).
       /* PARA EL ALMACEN DESTINO */
       RUN ALM\ALMACSTK (R-ROWID).
       RUN ALM\ALMACPR1 (R-ROWID,"U").
       RUN ALM\ALMACPR2 (R-ROWID,"U").
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Detalle-Origen V-table-Win 
PROCEDURE Graba-Detalle-Origen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  DISPLAY TODAY @ Almcmov.FchDoc WITH FRAME {&FRAME-NAME}.
  RUN Actualiza-ITEM (1).
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  DO WITH FRAME {&FRAME-NAME}:
     FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almtdocm.CodCia 
                          AND  Almtmovm.Tipmov = Almtdocm.TipMov 
                          AND  Almtmovm.Codmov = Almtdocm.CodMov 
                         NO-LOCK NO-ERROR.
     IF AVAILABLE Almtmovm AND Almtmovm.PidOdt THEN DO:
        Almcmov.NroRf1:SENSITIVE = NO.
     END.
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
  
  ASSIGN Almcmov.usuario = S-USER-ID. 
  
  RUN get-attribute('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO :
     ASSIGN Almcmov.CodCia  = Almtdocm.CodCia
            Almcmov.CodAlm  = Almtdocm.CodAlm
            Almcmov.TipMov  = Almtdocm.TipMov
            Almcmov.CodMov  = Almtdocm.CodMov
            Almcmov.FlgSit  = "T"
            Almcmov.HorSal  = STRING(TIME,"HH:MM:SS").
     FIND LAST CMOV WHERE CMOV.Codcia = s-codcia 
                     AND  CMOV.TipMov = Almtdocm.TipMov 
                     AND  CMOV.CodMov = Almtdocm.CodMov 
                    NO-LOCK NO-ERROR.
     IF AVAILABLE CMOV THEN ASSIGN Almcmov.NroDoc  = CMOV.NroDoc + 1.
     ELSE ASSIGN Almcmov.NroDoc  = 1.
/*     FIND TDOCM WHERE ROWID(TDOCM) = ROWID(Almtdocm) NO-ERROR.
     IF AVAILABLE TDOCM THEN ASSIGN Almcmov.NroDoc  = TDOCM.NroDoc
                                       TDOCM.NroDoc = TDOCM.NroDoc + 1. */
                                       
     FIND TDOCM WHERE ROWID(TDOCM) = ROWID(Almtdocm) NO-LOCK NO-ERROR.
     DISPLAY Almcmov.NroDoc @ Almcmov.NroDoc WITH FRAME {&FRAME-NAME}.
  END.
  
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

  RUN Borra-Detalle-Destino.
  RUN Borra-Detalle-Origen.
  /* Solo marcamos el FlgEst como Anulado */
  DO TRANSACTION:
     FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia 
                AND  CMOV.CodAlm = Almcmov.CodAlm 
                AND  CMOV.TipMov = Almcmov.TipMov 
                AND  CMOV.CodMov = Almcmov.CodMov 
                AND  CMOV.NroDoc = Almcmov.NroDoc 
               EXCLUSIVE-LOCK NO-ERROR.
     ASSIGN CMOV.FlgEst = 'A'
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
  FIND Almacen WHERE Almacen.CodCia = Almcmov.CodCia AND
       Almacen.CodAlm = Almcmov.AlmDes NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN C-DESALM = Almacen.Descripcion.
  ELSE C-DESALM = "".
  DEFINE FRAME F-DET
         Almdmov.CodMat AT 13
         Almdmov.CanDes FORMAT ">,>>>,>>9.9999" SPACE(3)
         Almdmov.CodUnd FORMAT "X(3)" SPACE(5)
         Almmmatg.DesMat FORMAT "X(50)" 
         WITH WIDTH 145 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
  OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 50.
  FIND FIRST Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia AND
             Almdmov.CodAlm = Almcmov.CodAlm AND
             Almdmov.TipMov = Almcmov.TipMov AND
             Almdmov.CodMov = Almcmov.CodMov AND
             Almdmov.NroDoc = Almcmov.NroDoc USE-INDEX Almd01 NO-LOCK NO-ERROR.
  IF AVAILABLE Almdmov THEN DO:
     PUT STREAM Reporte CONTROL "~033F".
     PUT STREAM Reporte SPACE(2) SKIP(4).
     PUT STREAM Reporte Almcmov.CodAlm AT 50 " - " S-DESALM FORMAT "X(20)" SKIP.
     PUT STREAM Reporte Almcmov.AlmDes AT 14 " - " C-DESALM FORMAT "X(30)" SKIP(1).
     PUT STREAM Reporte Almcmov.Observ AT 12 SKIP(1).
     PUT STREAM Reporte Almcmov.FchDoc AT 12 SKIP(5).
     PUT STREAM Reporte CONTROL "~033F".
     PUT STREAM Reporte CONTROL "~033x" NULL "~017~033P".
     REPEAT WHILE  AVAILABLE  AlmDMov      AND Almdmov.CodAlm = Almcmov.CodAlm AND
           Almdmov.TipMov = Almcmov.TipMov AND Almdmov.CodMov = Almcmov.CodMov AND
           Almdmov.NroDoc = Almcmov.NroDoc:
           FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia AND
                Almmmatg.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
           DISPLAY STREAM Reporte 
                   Almdmov.CodMat 
                   Almdmov.CanDes 
                   Almdmov.CodUnd 
                   Almmmatg.DesMat WITH FRAME F-DET.
           DOWN STREAM Reporte WITH FRAME F-DET.
           FIND NEXT Almdmov USE-INDEX Almd01.
     END.
  END.
  OUTPUT STREAM Reporte CLOSE.

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

  /* ELIMINAMOS EL DETALLE ANTERIOR */
  /* Verificamos si genera pedido automatico */  
  FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia 
                       AND  Almtmovm.Tipmov = Almcmov.TipMov 
                       AND  Almtmovm.Codmov = Almcmov.CodMov 
                      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm AND Almtmovm.PidOdt AND 
     Almcmov.AlmDes <> "" AND Almcmov.NroRf1 <> ""  THEN RUN Restaura-Pedido.

  RUN Borra-Detalle-Destino.
  RUN Borra-Detalle-Origen.

  RUN Genera-Detalle.
  
  /* Verificamos si genera pedido automatico */  
  FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia 
                       AND  Almtmovm.Tipmov = Almcmov.TipMov 
                       AND  Almtmovm.Codmov = Almcmov.CodMov 
                      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm AND Almtmovm.PidOdt AND 
     Almcmov.AlmDes <> "" AND Almcmov.NroRf1 <> ""  THEN RUN Actualiza-Pedido.
  
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
      FOR EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = Almcmov.CodCia AND 
          Almdmov.CodAlm = Almcmov.CodAlm AND
          Almdmov.TipMov = Almcmov.TipMov AND
          Almdmov.CodMov = Almcmov.CodMov AND
          Almdmov.NroDoc = Almcmov.NroDoc AND
          Almdmov.NroSer = Almdmov.NroSer:
          FIND Almdrequ WHERE Almdrequ.CodCia = Almdmov.CodCia 
               AND Almdrequ.CodAlm = Almcmov.Almdes 
               AND Almdrequ.NroDoc = INTEGER(Almcmov.NroRf1)
               AND Almdrequ.CodMat = almdmov.codmat NO-ERROR.
          IF AVAILABLE Almdrequ THEN Almdrequ.CanDes = Almdrequ.CanDes - Almdmov.candes.
          RELEASE Almdrequ.
      END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
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
     RUN Actualiza-ITEM(2).
     RUN Procesa-Handle IN lh_Handle ('Pagina2').
     RUN Procesa-Handle IN lh_Handle ('browse').
     FIND FIRST Almtmovm WHERE  Almtmovm.CodCia = Almtdocm.CodCia AND
                Almtmovm.Tipmov = Almtdocm.TipMov AND 
                Almtmovm.Codmov = Almtdocm.CodMov NO-LOCK NO-ERROR.
     IF AVAILABLE Almtmovm AND Almtmovm.PidOdt THEN DO:
        Almcmov.NroRf1:SENSITIVE = NO.
     END.
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
   FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almtdocm.CodCia 
                        AND  Almtmovm.Tipmov = Almtdocm.TipMov 
                        AND  Almtmovm.Codmov = Almtdocm.CodMov 
                       NO-LOCK NO-ERROR.
   IF AVAILABLE Almtmovm AND Almtmovm.PidOdt AND 
      INTEGER(Almcmov.NroRf1:SCREEN-VALUE) = 0 THEN DO:
      MESSAGE "No ingreso el numero de pedido" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.NroRf1.
      RETURN "ADM-ERROR".
   END.
   IF AVAILABLE Almtmovm AND Almtmovm.PidOdt THEN DO:
      FIND Almcrequ WHERE Almcrequ.CodCia = Almtdocm.CodCia 
                     AND  Almcrequ.CodAlm = Almcmov.AlmDes:SCREEN-VALUE 
                     AND  Almcrequ.Nroser = INTEGER(SUBSTRING(Almcmov.NroRf1:SCREEN-VALUE,1,3)) 
                     AND  Almcrequ.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1:SCREEN-VALUE,4,6)) 
                    NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almcrequ OR Almcrequ.FlgEst = "A" THEN DO:
         MESSAGE "Numero de pedido no Valido" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Almcmov.NroRf1.
         RETURN "ADM-ERROR".
      END.
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

FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
     Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
RUN ALM/D-CLAVE.R(Almacen.Clave,OUTPUT RPTA).
IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


