&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE t-ccbddocu LIKE CcbDDocu.



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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-CODCIA AS INTEGER.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-nroser AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-codcli LIKE gn-clie.codcli.
DEF SHARED VAR s-codmon AS INT.
DEF SHARED VAR S-CNDVTA AS CHAR.    /* Forma de Pago */
DEF SHARED VAR S-TPOCMB AS DECIMAL.  
DEF SHARED VAR s-codmov LIKE almtmov.codmov. 
DEF SHARED VAR s-codalm LIKE almacen.codalm. 

/* Local Variable Definitions ---                                       */
DEF SHARED VAR lh_Handle AS HANDLE.

FIND FIRST FacCfgGn WHERE codcia = s-codcia NO-LOCK.

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
&Scoped-define EXTERNAL-TABLES CcbCDocu
&Scoped-define FIRST-EXTERNAL-TABLE CcbCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCDocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCDocu.CodCli CcbCDocu.NomCli ~
CcbCDocu.DirCli CcbCDocu.FchDoc CcbCDocu.NroDoc CcbCDocu.FchVto ~
CcbCDocu.RucCli CcbCDocu.CodVen CcbCDocu.CodMon CcbCDocu.FmaPgo ~
CcbCDocu.Glosa CcbCDocu.TpoCmb 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.CodCli CcbCDocu.NomCli ~
CcbCDocu.DirCli CcbCDocu.FchDoc CcbCDocu.NroDoc CcbCDocu.FchVto ~
CcbCDocu.RucCli CcbCDocu.CodVen CcbCDocu.CodMon CcbCDocu.FmaPgo ~
CcbCDocu.Glosa CcbCDocu.TpoCmb 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado FILL-IN-NomVen ~
FILL-IN-FmaPgo 

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
DEFINE VARIABLE FILL-IN-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FmaPgo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.CodCli AT ROW 1.77 COL 7 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.NomCli AT ROW 1.77 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 42 BY .81
     CcbCDocu.DirCli AT ROW 2.54 COL 7 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 61.43 BY .81
     CcbCDocu.FchDoc AT ROW 1 COL 80 COLON-ALIGNED
          LABEL "Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.NroDoc AT ROW 1 COL 7 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     FILL-IN-Estado AT ROW 1 COL 21 COLON-ALIGNED NO-LABEL
     CcbCDocu.FchVto AT ROW 1.77 COL 80 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.RucCli AT ROW 2.54 COL 80 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .81
     CcbCDocu.CodVen AT ROW 3.31 COL 7 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FILL-IN-NomVen AT ROW 3.31 COL 14 COLON-ALIGNED NO-LABEL
     CcbCDocu.CodMon AT ROW 3.5 COL 82 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dolares", 2
          SIZE 11 BY 1.35
     CcbCDocu.FmaPgo AT ROW 4.08 COL 7 COLON-ALIGNED
          LABEL "Condicion"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FILL-IN-FmaPgo AT ROW 4.08 COL 14 COLON-ALIGNED NO-LABEL
     CcbCDocu.Glosa AT ROW 4.85 COL 7 COLON-ALIGNED
          LABEL "Glosa"
          VIEW-AS FILL-IN 
          SIZE 54 BY .81
     CcbCDocu.TpoCmb AT ROW 4.85 COL 80 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 3.5 COL 76
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.CcbCDocu
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: t-ccbddocu T "SHARED" ? INTEGRAL CcbDDocu
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
         HEIGHT             = 5.62
         WIDTH              = 97.72.
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

/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchVto IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FmaPgo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME CcbCDocu.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCli V-table-Win
ON LEAVE OF CcbCDocu.CodCli IN FRAME F-Main /* Cliente */
DO:
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = INPUT ccbcdocu.codcli
    NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie
  THEN DISPLAY gn-clie.nomcli @ ccbcdocu.nomcli 
                gn-clie.dircli @ ccbcdocu.dircli
                gn-clie.ruc @ ccbcdocu.ruccli 
                gn-clie.codven @ ccbcdocu.codven
                gn-clie.cndvta @ ccbcdocu.fmapgo
                WITH FRAME {&FRAME-NAME}.
  ELSE DISPLAY '' @ ccbcdocu.nomcli 
                '' @ ccbcdocu.dircli
                '' @ ccbcdocu.ruccli 
                '' @ ccbcdocu.codven
                '' @ ccbcdocu.fmapgo
                WITH FRAME {&FRAME-NAME}.
  IF INPUT ccbcdocu.codcli = FacCfgGn.CliVar
  THEN ASSIGN
            ccbcdocu.nomcli:SENSITIVE = YES
            ccbcdocu.dircli:SENSITIVE = YES
            ccbcdocu.ruccli:SENSITIVE = NO.
  ELSE ASSIGN
            ccbcdocu.nomcli:SENSITIVE = NO
            ccbcdocu.dircli:SENSITIVE = NO
            ccbcdocu.ruccli:SENSITIVE = NO.
  ASSIGN
    S-CODCLI = INPUT {&SELF-NAME}
    S-CNDVTA = (IF AVAILABLE gn-clie THEN gn-clie.CndVta ELSE '').

  FIND gn-convt WHERE gn-convt.Codig = ccbcdocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt 
  THEN DO:
    ASSIGN
        FILL-IN-FmaPgo:SCREEN-VALUE = gn-convt.Nombr.
        /*f-totdias = gn-convt.totdias.*/
    FIND TcmbCot WHERE  TcmbCot.Codcia = 0
        AND  (TcmbCot.Rango1 <= gn-convt.totdias
        AND   TcmbCot.Rango2 >= gn-convt.totdias)
        NO-LOCK NO-ERROR.
    IF AVAIL TcmbCot 
    THEN DO:
        DISPLAY TcmbCot.TpoCmb @ ccbcdocu.TpoCmb
            WITH FRAME {&FRAME-NAME}.
        S-TPOCMB = TcmbCot.TpoCmb.  
    END.
  END.
  ELSE ASSIGN
        FILL-IN-FmaPgo:SCREEN-VALUE = "".

  RUN Cambio-Estado IN lh_handle ('Recalcular-Precios').
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodMon V-table-Win
ON VALUE-CHANGED OF CcbCDocu.CodMon IN FRAME F-Main /* Moneda */
DO:
  S-CODMON = INPUT {&SELF-NAME}.
  RUN Cambio-Estado IN lh_handle ('Recalcular-Precios').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodVen V-table-Win
ON LEAVE OF CcbCDocu.CodVen IN FRAME F-Main /* Vendedor */
DO:
  FIND gn-ven WHERE gn-ven.codcia = s-codcia
    AND gn-ven.codven = INPUT ccbcdocu.codven
    NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven
  THEN DISPLAY gn-ven.nomven @ FILL-IN-NomVen WITH FRAME {&FRAME-NAME}.
  ELSE DISPLAY '' @ FILL-IN-NomVen WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FchDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FchDoc V-table-Win
ON LEAVE OF CcbCDocu.FchDoc IN FRAME F-Main /* Emision */
DO:
  ccbcdocu.fchvto:SCREEN-VALUE = {&SELF-NAME}:SCREEN-VALUE.

  FIND TcmbCot WHERE  TcmbCot.Codcia = 0
    AND  (TcmbCot.Rango1 <=  DATE(ccbcdocu.FchVto:SCREEN-VALUE) - DATE(ccbcdocu.FchDoc:SCREEN-VALUE) + 1
    AND   TcmbCot.Rango2 >= DATE(ccbcdocu.FchVto:SCREEN-VALUE) - DATE(ccbcdocu.FchDoc:SCREEN-VALUE) + 1 )
    NO-LOCK NO-ERROR.
  IF AVAIL TcmbCot 
  THEN DO:
    DISPLAY TcmbCot.TpoCmb @ ccbcdocu.TpoCmb WITH FRAME {&FRAME-NAME}.
    S-TPOCMB = TcmbCot.TpoCmb.  
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FmaPgo V-table-Win
ON LEAVE OF CcbCDocu.FmaPgo IN FRAME F-Main /* Condicion */
DO:
  S-CNDVTA = ccbcdocu.FmaPgo:SCREEN-VALUE.
  FIND gn-convt WHERE gn-convt.Codig = ccbcdocu.FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt 
  THEN FILL-IN-FmaPgo:SCREEN-VALUE = gn-convt.Nombr.
  ELSE FILL-IN-FmaPgo:SCREEN-VALUE = "".
  RUN Cambio-Estado IN lh_handle ('Recalcular-Precios').
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
  {src/adm/template/row-list.i "CcbCDocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCDocu"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal V-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH t-ccbddocu:
    DELETE t-ccbddocu.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
    CREATE t-ccbddocu.
    BUFFER-COPY ccbddocu TO t-ccbddocu.
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
  FOR EACH t-ccbddocu:
    CREATE ccbddocu.
    BUFFER-COPY t-ccbddocu TO ccbddocu
        ASSIGN
            ccbddocu.codcia = ccbcdocu.codcia
            ccbddocu.coddoc = ccbcdocu.coddoc
            ccbddocu.coddiv = ccbcdocu.coddiv
            ccbddocu.nrodoc = ccbcdocu.nrodoc
            ccbddocu.fchdoc = ccbcdocu.fchdoc.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales V-table-Win 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
  DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
  
  ASSIGN
    ccbcdocu.impdto = 0
    ccbcdocu.impigv = 0
    ccbcdocu.impisc = 0
    ccbcdocu.impexo = 0
    ccbcdocu.imptot = 0
    ccbcdocu.impvta = 0
    ccbcdocu.sdoact = 0.
  FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
    ASSIGN
        ccbcdocu.impdto = ccbcdocu.impdto + ccbddocu.impdto
        ccbcdocu.impigv = ccbcdocu.impigv + ccbddocu.impigv
        ccbcdocu.impisc = ccbcdocu.impisc + ccbddocu.impisc
        ccbcdocu.imptot = ccbcdocu.imptot + ccbddocu.implin.
    IF ccbddocu.aftigv = NO
    THEN ccbcdocu.impexo = ccbcdocu.impexo + ccbddocu.implin.
  END.
  ASSIGN
    ccbcdocu.impigv = ROUND(ccbcdocu.impigv,2)
    ccbcdocu.impisc = ROUND(ccbcdocu.impisc,2)
    ccbcdocu.impbrt = ccbcdocu.imptot -
                        ccbcdocu.impigv -
                        ccbcdocu.impisc -
                        ccbcdocu.impexo +
                        ccbcdocu.impdto
    ccbcdocu.impvta = ccbcdocu.impbrt - ccbcdocu.impdto
    ccbcdocu.sdoact = ccbcdocu.imptot.

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
  DO WITH FRAME {&FRAME-NAME}:
    /* Correlativo */
    FIND FacCorre WHERE faccorre.codcia = s-codcia 
        AND faccorre.coddoc = s-coddoc 
        AND faccorre.coddiv = s-coddiv
        AND faccorre.nroser = s-nroser NO-LOCK.
    DISPLAY 
        FacCfgGn.CliVar @ ccbcdocu.codcli
        TODAY @ ccbcdocu.fchdoc
        TODAY @ ccbcdocu.fchvto
        '000' @ ccbcdocu.fmapgo
        STRING(s-nroser, '999') + STRING(FacCorre.Correlativo, '999999') @ ccbcdocu.nrodoc.
    ASSIGN
        S-CODCLI = FacCfgGn.clivar
        S-CODMON = 1
        S-CNDVTA = '000'.
    /* Condiciones iniciales */
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = s-codcli
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie 
    THEN DO:
        S-CNDVTA = gn-clie.cndvta.
        DISPLAY S-CNDVTA @ ccbcdocu.fmapgo.
    END.
    /* Condicion de venta y tipo de cambio */
    FIND gn-convt WHERE gn-convt.Codig = S-CNDVTA NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt 
    THEN DO:
        FILL-IN-FmaPgo:SCREEN-VALUE = gn-convt.Nombr.
        FIND TcmbCot WHERE  TcmbCot.Codcia = 0
            AND  (TcmbCot.Rango1 <= gn-convt.totdias
            AND   TcmbCot.Rango2 >= gn-convt.totdias)
            NO-LOCK NO-ERROR.
        IF AVAIL TcmbCot 
        THEN DO:
            DISPLAY TcmbCot.TpoCmb @ ccbcdocu.TpoCmb
                WITH FRAME {&FRAME-NAME}.
            S-TPOCMB = TcmbCot.TpoCmb.  
        END.
    END.
  END.
  RUN Borra-Temporal.
  RUN Cambio-Estado IN lh_handle ('Pinta-Browse').
  RUN Cambio-Estado IN lh_handle ('Muestra-Botones').

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
  ASSIGN
    ccbcdocu.usuario = s-user-id
    ccbcdocu.flgest  = 'P'.
  RUN Genera-Detalle.
  RUN Graba-Totales.
  RUN vta/act_alm (ROWID(ccbcdocu)).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR':U.
  
   /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
     FIND GN-VEN WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = ccbcdocu.codven
        NO-LOCK NO-ERROR.
     IF AVAILABLE GN-VEN THEN ccbcdocu.cco = gn-ven.cco.

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
  RUN Cambio-Estado IN lh_handle ('Oculta-Botones').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FacDocum WHERE facdocum.codcia = s-codcia
    AND facdocum.coddoc = s-coddoc
    NO-LOCK NO-ERROR.
  s-codmov = facdocum.codmov.       /* Movimiento de salida de almacen */

  FIND FacCorre WHERE faccorre.codcia = s-codcia
    AND faccorre.coddiv = s-coddiv
    AND faccorre.coddoc = s-coddoc
    AND faccorre.nroser = s-nroser
    EXCLUSIVE-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR = YES
  THEN RETURN 'ADM-ERROR':U.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    ccbcdocu.codcia = s-codcia
    ccbcdocu.coddiv = s-coddiv
    ccbcdocu.coddoc = s-coddoc
    ccbcdocu.tpofac = 'I'       /* OJO: Itinerante */
    ccbcdocu.nrodoc = STRING(s-nroser, '999') + STRING(faccorre.correlativo, '999999')
    ccbcdocu.codmov = s-codmov
    ccbcdocu.codalm = s-codalm
    faccorre.correlativo = faccorre.correlativo + 1.
  RELEASE FacCorre.

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
  DEF VAR RPTA AS CHAR NO-UNDO.
  
  RUN ALM/D-CLAVE.R(FacCfgGn.Cla_Venta,OUTPUT RPTA). 
  IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
  IF CcbCDocu.FlgEst = "A" THEN DO:
     MESSAGE 'El documento se encuentra Anulado...' VIEW-AS ALERT-BOX.
     RETURN 'ADM-ERROR'.
  END.
  IF CcbCDocu.SdoAct < CcbCDocu.ImpTot  THEN DO:
     MESSAGE 'El documento registra amortizaciones...' VIEW-AS ALERT-BOX.
     RETURN 'ADM-ERROR'.
  END.

    RUN alm/p-ciealm-01 (Ccbcdocu.FchDoc, Ccbcdocu.CodAlm).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

    /* consistencia de la fecha del cierre del sistema */
    DEF VAR dFchCie AS DATE.
    RUN gn/fecha-de-cierre (OUTPUT dFchCie).
    IF ccbcdocu.fchdoc <= dFchCie THEN DO:
        MESSAGE 'NO se puede anular ningun documento antes del' (dFchCie + 1)
            VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
    /* fin de consistencia */

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':U ON STOP UNDO, RETURN 'ADM-ERROR':U:
    DEF VAR cReturnValue AS CHAR NO-UNDO.
    RUN ccb/d-motanu (ccbcdocu.codcia, ccbcdocu.coddoc, ccbcdocu.nrodoc, s-user-id, OUTPUT cReturnValue).
    IF cReturnValue = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    /* anulamos movimiento de almacen */
    RUN vta/des_alm (ROWID(CcbCDocu)).        
    /* borramos el detalle */
    FOR EACH CcbDDocu OF CcbCDocu ON ERROR UNDO, RETURN "ADM-ERROR":
        DELETE CcbDDocu.
    END.
    /* Borramos cabecera */
    FIND CURRENT CcbCDocu EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR':U.
    ASSIGN
        ccbcdocu.flgest = 'A'
        ccbcdocu.sdoact = 0
        ccbcdocu.glosa  = ' A N U L A D O'
        ccbcdocu.fchanu = TODAY
        ccbcdocu.usuanu = s-user-id.
    FIND CURRENT CcbCDocu NO-LOCK NO-ERROR.
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  END.

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
  RUN Borra-Temporal.
  IF AVAILABLE CcbCDocu THEN DO WITH FRAME {&FRAME-NAME}:
     FIND gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = ccbcdocu.codven
        NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven
     THEN FILL-IN-NomVen:SCREEN-VALUE = gn-ven.nomven.
     ELSE FILL-IN-NomVen:SCREEN-VALUE = ''.
     FIND gn-convt WHERE gn-convt.Codig = ccbcdocu.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt 
     THEN FILL-IN-FmaPgo:SCREEN-VALUE = gn-convt.Nombr.
     ELSE FILL-IN-FmaPgo:SCREEN-VALUE = "".
     IF CcbCDocu.FlgEst = "P" THEN FILL-IN-Estado:SCREEN-VALUE = "PENDIENTE".
     IF CcbCDocu.FlgEst = "A" THEN FILL-IN-Estado:SCREEN-VALUE = "ANULADO".
     IF CcbCDocu.FlgEst = "C" THEN FILL-IN-Estado:SCREEN-VALUE = "CANCELADO".
     RUN Carga-Temporal.
  END.  
  RUN Cambio-Estado IN lh_Handle ('Pinta-Browse').

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
    ASSIGN
        CcbCDocu.FchVto:SENSITIVE = NO
        /*CcbCDocu.FmaPgo:SENSITIVE = NO*/
        CcbCDocu.NroDoc:SENSITIVE = NO
        CcbCDocu.TpoCmb:SENSITIVE = NO.
    APPLY 'ENTRY':U TO ccbcdocu.codcli.
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
  /*
  IF S-CODDOC = "FAC" THEN DO:
     RUN VTA\R-IMPFAC2 (ROWID(CcbCDocu)).
  END.    
  
  IF S-CODDOC = "BOL" THEN DO:
     RUN VTA\R-IMPBOL2 (ROWID(CcbCDocu)).
  END.
  */
  
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
  RUN Cambio-Estado IN lh_handle ('Oculta-Botones').

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
  {src/adm/template/snd-list.i "CcbCDocu"}

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
  DO WITH FRAME {&FRAME-NAME}:
    /* Cliente */
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = INPUT ccbcdocu.codcli
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie
    THEN DO:
        MESSAGE 'Codigo del Cliente mal registrado'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO ccbcdocu.codcli.
        RETURN 'ADM-ERROR'.
    END.        
    IF s-coddoc = 'FAC' AND ccbcdocu.ruccli:SCREEN-VALUE = ''
    THEN DO:
        MESSAGE "El cliente NO tiene RUC"
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR':U.
    END.
    /* Vendedor */
    FIND gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = INPUT ccbcdocu.codven
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-ven
    THEN DO:
        MESSAGE 'Codigo del Vendedor mal registrado'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO ccbcdocu.codven.
        RETURN 'ADM-ERROR'.
    END.        
    /* Forma de pago */
    FIND gn-convt WHERE gn-convt.Codig = INPUT ccbcdocu.FmaPgo
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt 
    THEN DO:
        MESSAGE 'Codigo de la Condición de Venta mal registrado'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO ccbcdocu.fmapgo.
        RETURN 'ADM-ERROR'.
    END.        
    /* ITEMS */
    FIND FIRST t-ccbddocu NO-LOCK NO-ERROR.
    IF NOT AVAILABLE t-ccbddocu
    THEN DO:
        MESSAGE 'No hay Items Registrados'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
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
  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
  RETURN "ADM-ERROR":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

