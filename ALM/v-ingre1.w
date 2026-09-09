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
DEFINE SHARED VAR pv-codcia AS INT.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODALM AS CHAR.

DEFINE        VAR I-CODMON AS INTEGER NO-UNDO.
DEFINE        VAR R-ROWID  AS ROWID   NO-UNDO.
DEFINE        VAR L-CREA   AS LOGICAL NO-UNDO.

DEFINE BUFFER TDOCM FOR Almtdocm.
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
&Scoped-define EXTERNAL-TABLES Almcmov Almtdocm
&Scoped-define FIRST-EXTERNAL-TABLE Almcmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almcmov, Almtdocm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almcmov.FchDoc Almcmov.CodCli Almcmov.CodMon ~
Almcmov.CodPro Almcmov.TpoCmb Almcmov.AlmDes Almcmov.NroRf1 Almcmov.Observ ~
Almcmov.NroRf2 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 
&Scoped-Define DISPLAYED-FIELDS Almcmov.NroDoc Almcmov.FchDoc ~
Almcmov.CodCli Almcmov.CodMon Almcmov.CodPro Almcmov.TpoCmb Almcmov.AlmDes ~
Almcmov.NroRf1 Almcmov.Observ Almcmov.NroRf2 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NomCli FILL-IN-NomPro F-AlmRef 

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
DEFINE VARIABLE F-AlmRef AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13 BY .69.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 3.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almcmov.NroDoc AT ROW 1.19 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .69
          FONT 0
     Almcmov.FchDoc AT ROW 1.19 COL 72 COLON-ALIGNED FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .69
     Almcmov.CodCli AT ROW 1.88 COL 12 COLON-ALIGNED FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     Almcmov.CodMon AT ROW 1.96 COL 74.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .5
     Almcmov.CodPro AT ROW 2.58 COL 12 COLON-ALIGNED FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     Almcmov.TpoCmb AT ROW 2.58 COL 72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     Almcmov.AlmDes AT ROW 3.27 COL 12 COLON-ALIGNED
          LABEL "Almacen Origen"
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     Almcmov.NroRf1 AT ROW 3.27 COL 72 COLON-ALIGNED
          LABEL "Referencia 1"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Almcmov.Observ AT ROW 3.96 COL 12 COLON-ALIGNED FORMAT "X(100)"
          VIEW-AS FILL-IN 
          SIZE 47 BY .69
          BGCOLOR 15 FGCOLOR 12 FONT 7
     Almcmov.NroRf2 AT ROW 3.96 COL 72 COLON-ALIGNED
          LABEL "Referencia 2"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FILL-IN-NomCli AT ROW 1.88 COL 22 COLON-ALIGNED NO-LABEL
     FILL-IN-NomPro AT ROW 2.58 COL 22 COLON-ALIGNED NO-LABEL
     F-AlmRef AT ROW 3.27 COL 19.43 COLON-ALIGNED NO-LABEL
     "Moneda :" VIEW-AS TEXT
          SIZE 6.57 BY .69 AT ROW 1.96 COL 67.43
     RECT-2 AT ROW 1.88 COL 74
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
         HEIGHT             = 3.96
         WIDTH              = 89.
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

/* SETTINGS FOR FILL-IN Almcmov.AlmDes IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.CodCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almcmov.CodPro IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-AlmRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf1 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf2 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.Observ IN FRAME F-Main
   EXP-FORMAT                                                           */
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
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  IF Almcmov.AlmDes:VISIBLE THEN DO:
     IF Almcmov.AlmDes:SCREEN-VALUE = S-CODALM THEN DO:
        MESSAGE "Almacen " S-CODALM " No puede transferir a si mismo" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
     END.
     FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
          Almacen.CodAlm = Almcmov.AlmDes:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF NOT AVAILABLE Almacen THEN DO:
        MESSAGE "Almacen no existe" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.
     DISPLAY Almacen.Descripcion @ F-AlmRef WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodCli V-table-Win
ON LEAVE OF Almcmov.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF Almcmov.CodCli:VISIBLE THEN DO:
        FIND gn-clie WHERE gn-clie.CodCia = cl-CodCia AND 
             gn-clie.CodCli = INPUT Almcmov.CodCli NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie THEN DISPLAY gn-clie.NomCli @ FILL-IN-NomCli WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodMon V-table-Win
ON ENTRY OF Almcmov.CodMon IN FRAME F-Main /* Cod!mon */
DO:
  IF I-CODMON <> 3 THEN DO:
/*     ASSIGN Almcmov.CodMon:SCREEN-VALUE= STRING(I-CODMON,'9').*/
/*   ASSIGN Almcmov.CodMon.*/
     APPLY "ENTRY" TO Almcmov.TpoCmb.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodPro V-table-Win
ON LEAVE OF Almcmov.CodPro IN FRAME F-Main /* Proveedor */
DO:
  IF Almcmov.CodPro:VISIBLE THEN DO:
          FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND 
               gn-prov.CodPro = INPUT Almcmov.CodPro NO-LOCK NO-ERROR.
          IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.FchDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.FchDoc V-table-Win
ON LEAVE OF Almcmov.FchDoc IN FRAME F-Main /* Fecha */
DO:
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= INPUT Almcmov.FchDoc NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN DISPLAY gn-tcmb.compra @ Almcmov.TpoCmb WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.TpoCmb V-table-Win
ON ENTRY OF Almcmov.TpoCmb IN FRAME F-Main /* Tipo de cambio */
DO:
  Almcmov.TpoCmb:SENSITIVE = NO.
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
   FOR EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = Almcmov.CodCia 
                             AND  Almdmov.CodAlm = Almcmov.CodAlm 
                             AND  Almdmov.TipMov = Almcmov.TipMov 
                             AND  Almdmov.CodMov = Almcmov.CodMov 
                             AND  Almdmov.NroSer = Almcmov.NroSer 
                             AND  Almdmov.NroDoc = Almcmov.NroDoc :
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
  FOR EACH Almdmov EXCLUSIVE-LOCK WHERE Almdmov.CodCia = Almcmov.CodCia 
                                   AND  Almdmov.CodAlm = Almcmov.CodAlm 
                                   AND  Almdmov.TipMov = Almcmov.TipMov 
                                   AND  Almdmov.CodMov = Almcmov.CodMov 
                                   AND  Almdmov.NroSer = Almcmov.NroSer 
                                   AND  Almdmov.NroDoc = Almcmov.NroDoc
                                  ON ERROR UNDO, RETURN "ADM-ERROR":
           ASSIGN R-ROWID = ROWID(Almdmov).
           RUN ALM\ALMDCSTK (R-ROWID).      /* Descarga del Almacen */
           RUN ALM\ALMACPR1 (R-ROWID,"D").
           RUN ALM\ALMACPR2 (R-ROWID,"D").
      DELETE Almdmov.
  END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Control-Paginas V-table-Win 
PROCEDURE Control-Paginas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER TpoEvt AS INTEGER.
  FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almtdocm.CodCia 
                       AND  Almtmovm.Tipmov = Almtdocm.TipMov 
                       AND  Almtmovm.Codmov = Almtdocm.CodMov 
                      NO-LOCK NO-ERROR.
  IF TpoEvt = 1 THEN DO:
     IF AVAILABLE Almtmovm AND Almtmovm.PidPCo THEN 
          RUN Procesa-Handle IN lh_Handle ('Pagina2').
     ELSE RUN Procesa-Handle IN lh_Handle ('Pagina4').
  END.
  ELSE DO:
     IF AVAILABLE Almtmovm AND Almtmovm.PidPCo THEN 
          RUN Procesa-Handle IN lh_Handle ('Pagina1').
     ELSE RUN Procesa-Handle IN lh_Handle ('Pagina3').
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
   DEFINE VAR F-PesUnd AS DECIMAL NO-UNDO.
   
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
              Almdmov.Pesmat = ITEM.Pesmat
              Almdmov.CodAjt = ''
                     R-ROWID = ROWID(Almdmov).
       FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia 
                            AND  Almtmovm.Tipmov = Almcmov.TipMov 
                            AND  Almtmovm.Codmov = Almcmov.CodMov 
                           NO-LOCK NO-ERROR.
       IF AVAILABLE Almtmovm AND Almtmovm.PidPCo THEN ASSIGN Almdmov.CodAjt = "A".
       ELSE ASSIGN Almdmov.CodAjt = ''.
       RUN ALM\ALMACSTK (R-ROWID).
       RUN ALM\ALMACPR1 (R-ROWID,"U").
       RUN ALM\ALMACPR2 (R-ROWID,"U").
       /* Actualiza el Peso del Material  */
       FIND Almmmatg WHERE Almmmatg.codcia = s-codcia 
                      AND  Almmmatg.codmat = ITEM.Codmat 
                     NO-ERROR.
       IF AVAILABLE Almmmatg AND Almmmatg.Pesmat > 0 THEN DO:
          F-PesUnd = ROUND(ITEM.Pesmat / (ITEM.Candes * ITEM.Factor) * 1000, 3).
          IF ABS((F-PesUnd * 100 / Almmmatg.Pesmat) - 100) <= 4 THEN 
             ASSIGN Almmmatg.Pesmat = F-PesUnd.
       END.
   END.
   RUN Procesa-Handle IN lh_Handle ('browse').
 
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
     DISPLAY TODAY @ Almcmov.FchDoc .
     FIND LAST gn-tcmb NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN DISPLAY gn-tcmb.compra @ Almcmov.TpoCmb.
     RUN Actualiza-ITEM.
     RUN Control-Paginas (1).
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
            Almcmov.NroSer  = 000
            Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS").
            
     IF Fill-in-nompro:screen-value in frame {&FRAME-NAME} <> "" THEN
         ASSIGN Almcmov.NomRef  = Fill-in-nompro:screen-value in frame {&FRAME-NAME}.            
     IF Fill-in-nomcli:screen-value in frame {&FRAME-NAME} <> "" THEN
         ASSIGN Almcmov.NomRef  = Fill-in-nomcli:screen-value in frame {&FRAME-NAME}.            
     IF F-AlmRef:screen-value in frame {&FRAME-NAME} <> "" THEN
         ASSIGN Almcmov.NomRef  = F-AlmRef:screen-value in frame {&FRAME-NAME}.            
         
     FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                   AND  Almacen.CodAlm = Almtdocm.CodAlm 
                  EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN ASSIGN Almcmov.NroDoc = Almacen.CorrIng
                                     Almacen.CorrIng = Almacen.CorrIng + 1.
     RELEASE Almacen.
     DISPLAY Almcmov.NroDoc @ Almcmov.NroDoc WITH FRAME {&FRAME-NAME}.
  END.
  
  ASSIGN Almcmov.usuario = S-USER-ID.
  
  /* ELIMINAMOS EL DETALLE ANTERIOR */
  RUN Borra-Detalle.
  
  /* GENERAMOS NUEVO DETALLE */
  RUN Genera-Detalle.
  
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

  RUN Control-Paginas (2).

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
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    
  /* Solo marcamos el FlgEst como Anulado */
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
     /* Eliminamos el detalle */
     RUN Borra-Detalle.
     FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia 
                AND  CMOV.CodAlm = Almcmov.CodAlm 
                AND  CMOV.TipMov = Almcmov.TipMov 
                AND  CMOV.CodMov = Almcmov.CodMov 
                AND  CMOV.NroSer = Almcmov.NroSer 
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
     ASSIGN Almcmov.CodCli:VISIBLE = Almtmovm.PidCli
            Almcmov.CodPro:VISIBLE = Almtmovm.PidPro
            Almcmov.NroRf1:VISIBLE = Almtmovm.PidRef1
            Almcmov.NroRf2:VISIBLE = Almtmovm.PidRef2
            Almcmov.AlmDes:VISIBLE = Almtmovm.MovTrf
                  F-AlmRef:VISIBLE = Almtmovm.MovTrf
                          I-CODMON = Almtmovm.CodMon.
     IF Almtmovm.CodMon <> 3 THEN DO:
        ASSIGN Almcmov.CodMon:SCREEN-VALUE = STRING(Almtmovm.CodMon,'9').
     END.
     IF Almtmovm.PidRef1 THEN ASSIGN Almcmov.NroRf1:LABEL = Almtmovm.GloRf1.
     IF Almtmovm.PidRef2 THEN ASSIGN Almcmov.NroRf2:LABEL = Almtmovm.GloRf2.
     IF Almtdocm.TipMov = "S" THEN DO:
        ASSIGN Almcmov.TpoCmb:VISIBLE = NO
               Almcmov.CodMon:SCREEN-VALUE = '1'.
     END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  IF AVAILABLE Almcmov THEN DO WITH FRAME {&FRAME-NAME}:
     IF Almcmov.CodPro:VISIBLE THEN DO:
             FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
                           AND  gn-prov.CodPro = Almcmov.CodPro 
                          NO-LOCK NO-ERROR.
             IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro.
     END.
     IF Almcmov.CodCli:VISIBLE THEN DO:
             FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
                           AND  gn-clie.CodCli = Almcmov.CodCli 
                          NO-LOCK NO-ERROR.
             IF AVAILABLE gn-clie THEN DISPLAY gn-clie.NomCli @ FILL-IN-NomCli.
     END.
     IF Almcmov.AlmDes:VISIBLE THEN DO:
        F-AlmRef = "".
        FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                      AND  Almacen.CodAlm = Almcmov.AlmDes 
                     NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen THEN F-AlmRef = Almacen.Descripcion.
        DISPLAY F-AlmRef.
     END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  IF AVAILABLE Almcmov THEN RUN ALM\R-IMPFMT.R(ROWID(almcmov)).

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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ).
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN Control-Paginas (2).
  
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
  IF p-state = 'update-begin':U THEN DO:
     L-CREA = NO.
     RUN Actualiza-ITEM.
     RUN Control-Paginas (1).
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
   IF Almcmov.CodPro:VISIBLE THEN DO:
         FIND gn-prov WHERE gn-prov.CodCia = pv-CodCia  
                       AND  gn-prov.CodPro = Almcmov.CodPro:SCREEN-VALUE 
                      NO-LOCK NO-ERROR.
         IF NOT AVAILABLE gn-prov THEN DO:
            MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO Almcmov.CodPro.
            RETURN "ADM-ERROR".   
         END.
   END.
   IF Almcmov.CodCli:VISIBLE THEN DO:
         FIND gn-clie WHERE gn-clie.CodCia = cl-CodCia 
                       AND  gn-clie.CodCli = Almcmov.CodCli:SCREEN-VALUE 
                      NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clie THEN DO:
         MESSAGE "Codigo de Cliente no Existe" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Almcmov.CodCli.
         RETURN "ADM-ERROR".   
      END.
   END. 
   IF Almcmov.AlmDes:VISIBLE THEN DO:
      FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                    AND  Almacen.CodAlm = Almcmov.AlmDes:SCREEN-VALUE 
                   NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almacen THEN DO:
         MESSAGE "Almacen origen no existe" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Almcmov.AlmDes.
         RETURN "ADM-ERROR".   
      END.
   END.
END.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-UpDate V-table-Win 
PROCEDURE Valida-UpDate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:      
------------------------------------------------------------------------------*/
DEFINE VAR RPTA AS CHAR.

IF NOT AVAILABLE Almcmov THEN  RETURN "ADM-ERROR".

IF Almcmov.FlgEst = 'A' THEN DO:
   MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.

IF Almcmov.CodMov = 66 THEN DO:
   RETURN "ADM-ERROR".
END.

FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
              AND  Almacen.CodAlm = S-CODALM 
             NO-LOCK NO-ERROR.
RUN ALM/D-CLAVE.R(Almacen.Clave,OUTPUT RPTA).
IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

