&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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

/* Shared Variable Definitions ---                                       */
DEFINE SHARED TEMP-TABLE MVTO LIKE CcbDMvto.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE SHARED VARIABLE S-TPOCMB   AS DECIMAL.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE s-total AS DECIMAL.
DEFINE VAR C-MON  AS CHAR EXTENT 2 NO-UNDO.
DEFINE VAR C-CREF AS CHAR NO-UNDO.
DEFINE VAR C-NREF AS CHAR NO-UNDO.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

C-MON[1] = "S/." .
C-MON[2] = "US$" .

DEFINE BUFFER B-MVTO FOR MVTO.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES MVTO CcbCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table MVTO.CodRef MVTO.NroRef CcbCDocu.FchDoc C-MON[CcbCDocu.CodMon] CcbCDocu.ImpTot MVTO.ImpTot   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table MVTO.CodRef ~
MVTO.NroRef ~
MVTO.ImpTot   
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table MVTO
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table MVTO
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH MVTO WHERE       MVTO.TpoRef = "C" NO-LOCK, ~
             FIRST CcbCDocu WHERE             CcbCDocu.CodCia = MVTO.CodCia         AND CcbCDocu.CodDoc = MVTO.CodRef         AND CcbCDocu.NroDoc = MVTO.NroRef NO-LOCK
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH MVTO WHERE       MVTO.TpoRef = "C" NO-LOCK, ~
             FIRST CcbCDocu WHERE             CcbCDocu.CodCia = MVTO.CodCia         AND CcbCDocu.CodDoc = MVTO.CodRef         AND CcbCDocu.NroDoc = MVTO.NroRef NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table MVTO CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table MVTO
&Scoped-define SECOND-TABLE-IN-QUERY-br_table CcbCDocu


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-11 
&Scoped-Define DISPLAYED-OBJECTS F-ImpTot 

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
DEFINE VARIABLE F-ImpTot AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 28.72 BY 1.08.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      MVTO, 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      MVTO.CodRef
      MVTO.NroRef COLUMN-LABEL "     Numero     " FORMAT "X(11)"
      CcbCDocu.FchDoc COLUMN-LABEL "      Fecha   "
      C-MON[CcbCDocu.CodMon] COLUMN-LABEL "Moneda" FORMAT "X(4)"
      CcbCDocu.ImpTot 
      MVTO.ImpTot COLUMN-LABEL "Importe Canjeado"
  ENABLE
      MVTO.CodRef
      MVTO.NroRef
      MVTO.ImpTot
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 58.72 BY 3.5
         FONT 4
         TITLE "CUENTAS POR COBRAR".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1.29
     F-ImpTot AT ROW 4.69 COL 43 COLON-ALIGNED NO-LABEL
     "Importe Total" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 4.69 COL 34
     RECT-11 AT ROW 4.5 COL 31
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
         HEIGHT             = 6.15
         WIDTH              = 62.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table TEXT-1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM

OPEN QUERY {&SELF-NAME} FOR EACH MVTO WHERE
      MVTO.TpoRef = "C" NO-LOCK,
      FIRST CcbCDocu WHERE
            CcbCDocu.CodCia = MVTO.CodCia
        AND CcbCDocu.CodDoc = MVTO.CodRef
        AND CcbCDocu.NroDoc = MVTO.NroRef NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
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
ON ANY-PRINTABLE OF br_table IN FRAME F-Main /* CUENTAS POR COBRAR */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main /* CUENTAS POR COBRAR */
DO:
  /* This code `isplays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* CUENTAS POR COBRAR */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* CUENTAS POR COBRAR */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON "RETURN":U OF MVTO.CodRef, MVTO.NroRef, MVTO.Imptot
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON "LEAVE":U OF MVTO.CodRef 
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   MVTO.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = CAPS(SELF:SCREEN-VALUE).
   FIND FacDocum WHERE FacDocum.CodCia = s-codcia AND 
        FacDocum.CodDoc = MVTO.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE FacDocum OR NOT FacDocum.TpoDoc THEN RETURN NO-APPLY.
END.

ON "LEAVE":U OF MVTO.NroRef DO:
   IF SELF:SCREEN-VALUE = '' THEN RETURN.
   MVTO.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SELF:SCREEN-VALUE.
   FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
        CcbCDocu.CodCli = s-codcli AND
        CcbCDocu.CodDoc = MVTO.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} AND
        CcbCDocu.NroDoc = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.

   IF NOT AVAILABLE CcbCDocu THEN DO:
      MESSAGE 'El documento no pertenece al cliente' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.

   IF CcbCDocu.FlgEst = 'C' THEN DO:
      MESSAGE 'El documento se encuentra cancelado' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   
   s-total = 0.
   s-total = CcbCDocu.SdoAct.
/*    IF CcbCDocu.CodMon = S-CODMON THEN s-total = CcbCDocu.SdoAct.          */
/*    ELSE DO:                                                               */
/*       IF CcbCDocu.CodMon = 1 THEN s-total = (CcbCDocu.SdoAct / S-TPOCMB). */
/*       ELSE s-total = (CcbCDocu.SdoAct * S-TPOCMB).                        */
/*    END.                                                                   */
   ASSIGN
      MVTO.ImpTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(s-total, '9999,999.99').
      
      
END.

/* ***************************  Main Block  *************************** */
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-Total B-table-Win 
PROCEDURE Imp-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN F-ImpTot = 0.
FOR EACH B-MVTO WHERE 
         B-MVTO.CodCia = S-CODCIA AND
         B-MVTO.Coddoc = s-coddoc AND
         B-MVTO.TpoRef = 'C':
/*    F-ImpTot = F-ImpTot + B-MVTO.ImpTot.*/
    IF s-CodMon = 1
    THEN F-ImpTot = F-ImpTot + B-MVTO.DepNac[1].
    ELSE F-ImpTot = F-ImpTot + B-MVTO.DepUsa[1].
END.
DISPLAY F-ImpTot WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE F-PRECIO AS DECIMAL NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

  ASSIGN MVTO.CodCia = S-CODCIA
         MVTO.Coddoc = s-coddoc
         MVTO.TpoRef = 'C'
         MVTO.CodRef = C-CREF
         MVTO.NroRef = C-NREF.
  /* Importe en S/. y US$ */
/*  s-total = 0.
 *   IF CcbCDocu.CodMon = S-CODMON THEN s-total = CcbCDocu.SdoAct.
 *   ELSE DO:
 *       IF CcbCDocu.CodMon = 1 THEN s-total = (CcbCDocu.SdoAct / S-TPOCMB).
 *       ELSE s-total = (CcbCDocu.SdoAct * S-TPOCMB).
 *   END.
 *   ASSIGN
 *       MVTO.ImpTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(s-total, '9999,999.99').
 *   IF Ccbcdocu.codmon = 1 THEN DO:
 *     IF Ccbcdocu.codmon = s-codmon
 *     THEN ASSIGN
 *             Mvto.DepNac[1] = MVTO.ImpTot
 *             Mvto.DepUsa[1] = MVTO.ImpTot / s-TpoCmb.
 *     ELSE ASSIGN
 *             Mvto.DepUsa[1] = MVTO.ImpTot
 *             Mvto.Depnac[1] = MVTO.ImpTot * s-TpoCmb.
 *             
 *   END.
 *   ELSE DO:
 *     IF Ccbcdocu.codmon = s-codmon
 *     THEN ASSIGN
 *             Mvto.DepUsa[1] = MVTO.ImpTot
 *             Mvto.DepNac[1] = MVTO.ImpTot * s-TpoCmb.
 *     ELSE ASSIGN            
 *             Mvto.DepNac[1] = MVTO.ImpTot
 *             Mvto.DepUsa[1] = MVTO.ImpTot / s-TpoCmb.
 *   END.*/
  IF CcbCDocu.CodMon = 1
  THEN ASSIGN
            Mvto.DepNac[1] = MVTO.ImpTot
            Mvto.DepUsa[1] = MVTO.ImpTot / s-TpoCmb.
  ELSE ASSIGN
            Mvto.DepUsa[1] = MVTO.ImpTot
            Mvto.DepNac[1] = MVTO.ImpTot * s-TpoCmb.
               
  FIND FacDocum WHERE FacDocum.CodCia = s-codcia 
    AND FacDocum.CodDoc = Mvto.Codref NO-LOCK NO-ERROR.
  IF AVAILABLE FacDocum 
  THEN MVTO.CodCta = IF CcbCDocu.Codmon = 1 THEN FacDocum.CodCta[1] ELSE FacDocum.CodCta[2].
             
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN Imp-Total.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Imp-Total.

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
  
  RUN Imp-Total.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Documentos B-table-Win 
PROCEDURE Procesa-Documentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR I AS INTEGER.

    input-var-1 = "P".
    input-var-2 = S-CODCLI.

    RUN lkup\C-doctip-03a ("Documentos Pendientes").   /* TODAS LAS DIVISIONES */

    IF output-var-1 = ? THEN RETURN ERROR.

    EMPTY TEMP-TABLE MVTO.
    DO i = 1 TO NUM-ENTRIES(output-var-2) WITH FRAME {&FRAME-NAME}:
        /* Solo acepta documentos de Cargo */
        FIND FIRST facdocum WHERE
            FacDocum.CodCia = s-codcia AND
            FacDocum.CodDoc = SUBSTRING(ENTRY(I,output-var-2),1,3)
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE facdocum OR NOT FacDocum.TpoDoc THEN NEXT.
        FIND ccbcdocu WHERE
            ccbcdocu.codcia = s-codcia AND
            ccbcdocu.codcli = s-codcli AND
            ccbcdocu.coddoc = SUBSTRING(ENTRY(I,output-var-2),1,3) AND
            ccbcdocu.nrodoc = SUBSTRING(ENTRY(I,output-var-2),4) 
            USE-INDEX LLAVE01 NO-LOCK NO-ERROR.
        /* LETRAS N BANCO */
        IF Ccbcdocu.coddoc = 'LET' AND Ccbcdocu.flgubi <> 'C' THEN DO:
            MESSAGE 'La letra' ccbcdocu.nrodoc 'NO está en CARTERA' VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
        CREATE MVTO.
        ASSIGN
            MVTO.CodRef = Ccbcdocu.CodDoc
            MVTO.NroRef = Ccbcdocu.NroDoc
            /*MVTO.ImpTot = ccbcdocu.sdoact*/
            MVTO.CodCia = S-CODCIA
            MVTO.Coddoc = s-coddoc
            MVTO.TpoRef = 'C'.

        s-total = 0.
        s-total = CcbCDocu.SdoAct.
/*         IF CcbCDocu.CodMon = S-CODMON THEN s-total = CcbCDocu.SdoAct.          */
/*         ELSE DO:                                                               */
/*            IF CcbCDocu.CodMon = 1 THEN s-total = (CcbCDocu.SdoAct / S-TPOCMB). */
/*            ELSE s-total = (CcbCDocu.SdoAct * S-TPOCMB).                        */
/*         END.                                                                   */
        ASSIGN
           MVTO.ImpTot = s-total.

        IF CcbCDocu.CodMon = 1
        THEN ASSIGN
                  Mvto.DepNac[1] = MVTO.ImpTot
                  Mvto.DepUsa[1] = MVTO.ImpTot / s-TpoCmb.
        ELSE ASSIGN
                  Mvto.DepUsa[1] = MVTO.ImpTot
                  Mvto.DepNac[1] = MVTO.ImpTot * s-TpoCmb.

        FIND FacDocum WHERE FacDocum.CodCia = s-codcia 
          AND FacDocum.CodDoc = Mvto.Codref NO-LOCK NO-ERROR.
        IF AVAILABLE FacDocum 
        THEN MVTO.CodCta = IF CcbCDocu.Codmon = 1 THEN FacDocum.CodCta[1] ELSE FacDocum.CodCta[2].

    END.
     RUN dispatch IN THIS-PROCEDURE ('open-query':U).


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
        WHEN "CodRef" THEN ASSIGN input-var-1 = 'CARGO'.
        WHEN "NroRef" THEN ASSIGN input-var-1 = MVTO.CodRef:screen-value in browse {&BROWSE-NAME}
                                  input-var-2 = S-CODCLI
                                  input-var-3 = 'P'.
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
  {src/adm/template/snd-list.i "MVTO"}
  {src/adm/template/snd-list.i "CcbCDocu"}

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
DEFINE VARIABLE F-STKRET AS DECIMAL NO-UNDO.

C-CREF = MVTO.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
C-NREF = MVTO.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

FIND B-MVTO WHERE 
     B-mvto.codref = C-CREF AND
     B-mvto.nroref = C-NREF NO-LOCK NO-ERROR.
IF AVAILABLE B-MVTO AND ROWID(B-MVTO) <> ROWID(MVTO) THEN DO:
   MESSAGE "Documento ya canjeado" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
FIND CcbCDocu WHERE 
     CcbCDocu.CodCia = S-CODCIA AND
     CcbCDocu.CodDoc = C-CREF AND
     CcbCDocu.NroDoc = C-NREF NO-LOCK NO-ERROR.
IF NOT AVAILABLE CcbCDocu THEN DO:
   MESSAGE "Forma de pago diferente al Doc. anterior" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.   
IF DECIMAL(MVTO.ImpTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
   MESSAGE "Documento con importe igual a cero" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
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
IF NOT AVAILABLE MVTO THEN RETURN "ADM-ERROR".
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

