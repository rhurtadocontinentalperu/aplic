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
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NROSER  AS INTEGER.

DEFINE        VAR I-CODMON AS INTEGER NO-UNDO.
DEFINE        VAR R-ROWID  AS ROWID   NO-UNDO.
DEFINE        VAR L-CREA   AS LOGICAL NO-UNDO.
DEFINE        VAR F-ESTADO AS CHAR NO-UNDO.

DEFINE BUFFER CMOV  FOR Almcmov.
DEFINE SHARED TEMP-TABLE ITEM LIKE almdmov.

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
&Scoped-define EXTERNAL-TABLES lg-liqcsg
&Scoped-define FIRST-EXTERNAL-TABLE lg-liqcsg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR lg-liqcsg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS lg-liqcsg.CodPro lg-liqcsg.Observ 
&Scoped-define ENABLED-TABLES lg-liqcsg
&Scoped-define FIRST-ENABLED-TABLE lg-liqcsg
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-5 
&Scoped-Define DISPLAYED-FIELDS lg-liqcsg.CodPro lg-liqcsg.FchDoc ~
lg-liqcsg.Observ lg-liqcsg.CodMon lg-liqcsg.NroRf1 lg-liqcsg.NroRf2 
&Scoped-define DISPLAYED-TABLES lg-liqcsg
&Scoped-define FIRST-DISPLAYED-TABLE lg-liqcsg
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_NroDoc F-STATUS FILL-IN-NomPro 

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
DEFINE VARIABLE F-STATUS AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.57 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroDoc AS CHARACTER FORMAT "XXX-XXXXXX" 
     LABEL "No. documento" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .69
     FONT 0.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16.14 BY .92.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.43 BY 4.15.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN_NroDoc AT ROW 1.23 COL 12.72 COLON-ALIGNED
     F-STATUS AT ROW 1.23 COL 71.57 COLON-ALIGNED NO-LABEL
     lg-liqcsg.CodPro AT ROW 1.96 COL 12.72 COLON-ALIGNED
          LABEL "Proveedor" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     FILL-IN-NomPro AT ROW 1.96 COL 24.14 COLON-ALIGNED NO-LABEL
     lg-liqcsg.FchDoc AT ROW 2 COL 75 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
     lg-liqcsg.Observ AT ROW 2.69 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 45.86 BY .69
     lg-liqcsg.CodMon AT ROW 2.92 COL 72.72 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 14.72 BY .77
     lg-liqcsg.NroRf1 AT ROW 3.46 COL 11
          LABEL "O/C" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 11.14 BY .69
     lg-liqcsg.NroRf2 AT ROW 4.31 COL 6
          LABEL "Ingreso Alm" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .69
     RECT-7 AT ROW 1.08 COL 1.72
     RECT-5 AT ROW 2.85 COL 72.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.lg-liqcsg
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
         HEIGHT             = 4.23
         WIDTH              = 88.14.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR RADIO-SET lg-liqcsg.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lg-liqcsg.CodPro IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-STATUS IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lg-liqcsg.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lg-liqcsg.NroRf1 IN FRAME F-Main
   NO-ENABLE ALIGN-L EXP-LABEL EXP-FORMAT                               */
/* SETTINGS FOR FILL-IN lg-liqcsg.NroRf2 IN FRAME F-Main
   NO-ENABLE ALIGN-L EXP-LABEL EXP-FORMAT                               */
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

&Scoped-define SELF-NAME lg-liqcsg.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lg-liqcsg.CodPro V-table-Win
ON LEAVE OF lg-liqcsg.CodPro IN FRAME F-Main /* Proveedor */
DO:
     FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA AND 
                        gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-prov THEN 
        FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA AND 
             gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN 
        DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.
  
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
       ASSIGN ITEM.CodCia    = Almdmov.CodCia 
              ITEM.CodAlm    = Almdmov.CodAlm 
              ITEM.codmat    = Almdmov.codmat 
              ITEM.PreUni    = Almdmov.PreUni 
              ITEM.CanDes    = Almdmov.CanDes 
              ITEM.CanDev    = Almdmov.CanDev 
              ITEM.Factor    = Almdmov.Factor 
              ITEM.CodUnd    = Almdmov.CodUnd 
              ITEM.ImpCto    = Almdmov.ImpCto 
              ITEM.PreLis    = Almdmov.PreLis 
              ITEM.Dsctos[1] = Almdmov.Dsctos[1] 
              ITEM.Dsctos[2] = Almdmov.Dsctos[2] 
              ITEM.Dsctos[3] = Almdmov.Dsctos[3] 
              ITEM.IgvMat    = Almdmov.IgvMat.
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
  {src/adm/template/row-list.i "lg-liqcsg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "lg-liqcsg"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Consignacion V-table-Win 
PROCEDURE Asigna-Consignacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.

input-var-1 = S-CODALM.
input-var-2 = "I".
input-var-3 = "26".

RUN LKUP\C-MOVCSG("Ingresos x Consignacion").

IF output-var-1 = ? THEN RETURN.

OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH ITEM:
    DELETE ITEM.
END.

FIND Almcmov WHERE ROWID(Almcmov) = output-var-1 NO-LOCK NO-ERROR.

IF AVAILABLE Almcmov THEN DO WITH FRAME {&FRAME-NAME}:
   DISPLAY Almcmov.NroDoc @ Lg-liqcsg.NroRf2
           Almcmov.Nrorf1 @ Lg-liqcsg.NroRf1 
           Almcmov.CodPro @ Lg-liqcsg.CodPro .
           
           Lg-liqcsg.CodMon:SCREEN-VALUE = STRING(Almcmov.Codmon).
  
   FOR EACH Almdmov OF Almcmov NO-LOCK WHERE /*Almdmov.CodCia = Almcmov.CodCia 
                              AND Almdmov.CodAlm = Almcmov.CodAlm
                              AND Almdmov.TipMov = Almcmov.TipMov
                              AND Almdmov.Codmov = Almdmov.CodMov  
                              AND Almdmov.NroSer = Almcmov.NroSer 
                              AND Almcmov.NroDoc = Almcmov.NroDoc 
                              AND*/  (Almdmov.CanDes - Almdmov.CanDev) > 0:
       CREATE ITEM.
       ASSIGN
              ITEM.CodCia = S-CODCIA
              ITEM.CodAlm = S-CODALM
              ITEM.Codmat = Almdmov.Codmat 
              ITEM.CodUnd = Almdmov.CodUnd
              ITEM.CanDes = Almdmov.CanDes
              ITEM.CanDev = Almdmov.CanDev
              ITEM.StkSub = Almdmov.CanDes - Almdmov.CanDev
              ITEM.PreLis = Almdmov.PreLis
              ITEM.Dsctos[1] = Almdmov.Dsctos[1]
              ITEM.Dsctos[2] = Almdmov.Dsctos[2]
              ITEM.Dsctos[3] = Almdmov.Dsctos[3]
              ITEM.IgvMat = Almdmov.IgvMat
              ITEM.PreUni = Almdmov.PreUni 
              ITEM.ImpCto = ROUND(ITEM.StkSub * ITEM.PreUni,2).
       FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                      AND  Almmmatg.codmat = ITEM.codmat  
                     NO-LOCK NO-ERROR.
         
       FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
                      AND  Almtconv.Codalter = ITEM.CodUnd 
                     NO-LOCK NO-ERROR.
       ITEM.Factor = Almtconv.Equival / Almmmatg.FacEqu.
   END.
   RUN Procesa-Handle IN lh_Handle ('browse').
END.

OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

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
   FOR EACH ITEM WHERE ITEM.codmat <> ""
       ON ERROR UNDO, RETURN "ADM-ERROR":
       CREATE lg-liqcsgd.
       ASSIGN lg-liqcsgd.CodCia = lg-liqcsg.CodCia 
              /*lg-liqcsgd.CodMov = lg-liqcsg.CodMov
              lg-liqcsgd.CodAlm = lg-liqcsg.CodAlm
              lg-liqcsgd.TipMov = lg-liqcsg.TipMov */
              lg-liqcsgd.NroSer = lg-liqcsg.NroSer 
              lg-liqcsgd.NroDoc = lg-liqcsg.NroDoc 
              lg-liqcsgd.CodMon = lg-liqcsg.CodMon 
              lg-liqcsgd.FchDoc = lg-liqcsg.FchDoc 
              lg-liqcsgd.TpoCmb = lg-liqcsg.TpoCmb
              lg-liqcsgd.codmat = ITEM.codmat
              lg-liqcsgd.CanDes = ITEM.StkSub
              lg-liqcsgd.CodUnd = ITEM.CodUnd
              lg-liqcsgd.Factor = ITEM.Factor
              lg-liqcsgd.Pesmat = ITEM.Pesmat
              lg-liqcsgd.ImpCto = ROUND(ITEM.StkSub * ITEM.PreUni,2)
              lg-liqcsgd.PreLis = ITEM.PreLis
              lg-liqcsgd.PreUni = ITEM.PreUni
              lg-liqcsgd.Dsctos[1] = ITEM.Dsctos[1]
              lg-liqcsgd.Dsctos[2] = ITEM.Dsctos[2]
              lg-liqcsgd.Dsctos[3] = ITEM.Dsctos[3]
              lg-liqcsgd.IgvMat = ITEM.IgvMat
              /*lg-liqcsgd.CodAjt = 'A'*/
              lg-liqcsgd.HraDoc = lg-liqcsg.HorRcp
                     R-ROWID = ROWID(lg-liqcsgd).
       FIND Almmmatg WHERE 
            Almmmatg.CodCia = lg-liqcsgd.CodCia AND
            Almmmatg.CodMat = lg-liqcsgd.codmat NO-LOCK NO-ERROR.
       IF AVAILABLE Almmmatg AND NOT Almmmatg.AftIgv THEN  lg-liqcsgd.IgvMat = 0.
        
       IF lg-liqcsg.codmon = 1 THEN DO:
          lg-liqcsg.ImpMn1 = lg-liqcsg.ImpMn1 + lg-liqcsgd.ImpMn1.
       END.
       ELSE DO:
          lg-liqcsg.ImpMn2 = lg-liqcsg.ImpMn2 + lg-liqcsgd.ImpMn2.
       END.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  L-CREA = YES.
  DO WITH FRAME {&FRAME-NAME}:
     FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = "LIQ" AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
     IF AVAILABLE FacCorre THEN 
        FILL-IN_NroDoc:SCREEN-VALUE = STRING(S-NROSER,"999") +  STRING(FacCorre.Correlativo,"999999").
        DISPLAY TODAY @ lg-liqcsg.FchDoc.
  END.
  RUN Actualiza-ITEM.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF L-CREA THEN DO:
     ASSIGN lg-liqcsg.CodCia  = S-CODCIA 
            /*lg-liqcsg.CodAlm  = S-CODALM*/
            /*lg-liqcsg.TipMov  = Almtdocm.TipMov*/
            /*lg-liqcsg.CodMov  = Almtdocm.CodMov*/
            lg-liqcsg.NroSer  = S-NROSER
            lg-liqcsg.HorRcp  = STRING(TIME,"HH:MM:SS").

     IF ERROR-STATUS:ERROR THEN DO:
        RETURN "ADM-ERROR".
     END.

     FIND FIRST FacCorre WHERE 
                FacCorre.CodCia = S-CODCIA AND  
                FacCorre.CodDoc = "LIQ" AND  
                FacCorre.CodDiv = S-CODDIV AND  
                FacCorre.NroSer = S-NROSER  EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE FacCorre THEN DO:
        lg-liqcsg.NroDoc = FacCorre.Correlativo .
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
        RELEASE FacCorre.
     END.
     /*********************************/
     lg-liqcsg.NomRef  = Fill-in-nompro:screen-value in frame {&FRAME-NAME}.
  END.
  ASSIGN lg-liqcsg.usuario = S-USER-ID
         lg-liqcsg.ImpIgv  = 0
         lg-liqcsg.ImpMn1  = 0
         lg-liqcsg.ImpMn2  = 0.

  /* ELIMINAMOS EL DETALLE ANTERIOR */
  IF NOT L-CREA THEN DO:
/*
     RUN Actualiza-Detalle-Orden-Compra(-1).
     RUN Borra-Detalle.
*/
  END.
  
  /* GENERAMOS NUEVO DETALLE */
  RUN Genera-Detalle.

  IF lg-liqcsg.codmon = 1 THEN 
     ASSIGN lg-liqcsg.ImpMn2 = ROUND(lg-liqcsg.ImpMn1 / lg-liqcsg.tpocmb, 2)
          /*  lg-liqcsg.ExoMn2 = ROUND(lg-liqcsg.ExoMn1 / lg-liqcsg.tpocmb, 2) */.
  ELSE 
     ASSIGN lg-liqcsg.ImpMn1 = ROUND(lg-liqcsg.ImpMn2 * lg-liqcsg.tpocmb, 2)
           /* lg-liqcsg.ExoMn1 = ROUND(lg-liqcsg.ExoMn2 * lg-liqcsg.tpocmb, 2) */.
  
 /*
  RUN Actualiza-Detalle-Orden-Compra(1).
  RUN Cerrar-Orden-Compra.
*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF AVAILABLE lg-liqcsg THEN DO WITH FRAME {&FRAME-NAME}:
     FILL-IN_NroDoc:SCREEN-VALUE = STRING(lg-liqcsg.NroSer,"999") + STRING(lg-liqcsg.NroDoc,"999999").
     IF lg-liqcsg.FlgEst  = "A" THEN F-STATUS:SCREEN-VALUE = "  ANULADO   ".
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

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

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
  {src/adm/template/snd-list.i "lg-liqcsg"}

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

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
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
DEFINE VARIABLE F-CANT AS DECIMAL NO-UNDO.
DEFINE VARIABLE L-ASIG AS LOGICAL NO-UNDO.
DO WITH FRAME {&FRAME-NAME} :
      FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA AND
           gn-prov.CodPro = lg-liqcsg.CodPro:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-prov THEN DO:
         FIND gn-prov WHERE gn-prov.CodCia = Almtdocm.CodCia  AND
              gn-prov.CodPro = lg-liqcsg.CodPro:SCREEN-VALUE NO-LOCK NO-ERROR.
         IF NOT AVAILABLE gn-prov THEN DO:
            MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO lg-liqcsg.CodPro.
            RETURN "ADM-ERROR".   
         END.
      END.
/*   
   IF string(lg-liqcsg.TpoCmb:SCREEN-VALUE,"Z9.9999") = "0.0000" THEN DO:
      MESSAGE "Ingrese el Tipo de Cambio " VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO lg-liqcsg.TpoCmb.
      RETURN "ADM-ERROR".
   END.
*/   
   
   F-CANT = 0. 
   L-ASIG = YES.
   FOR EACH ITEM:
       F-CANT = F-CANT + ITEM.CanDes.
       FIND Almmmate WHERE
            Almmmate.CodCia = S-CODCIA AND
            Almmmate.CodAlm = S-CODALM AND
            Almmmate.codmat = ITEM.CodMat NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Almmmate THEN DO:
          L-ASIG = NO.
          LEAVE.
       END.
   END.
   IF F-CANT = 0 THEN DO:
      MESSAGE "No existen ITEMS por Liquidar" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO lg-liqcsg.Observ.
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
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

