&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
DEFINE SHARED VARIABLE S-FCHDOC   AS DATE.
DEFINE SHARED VARIABLE S-CONDIC   AS CHAR.
DEFINE VAR I-NROSER AS INTEGER NO-UNDO.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

/* Local Variable Definitions ---                                       */
DEFINE VAR X-VENCTO AS CHAR NO-UNDO.
DEFINE BUFFER B-MVTO FOR MVTO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES MVTO

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table MVTO.CodRef MVTO.NroRef MVTO.FchEmi MVTO.FchVto MVTO.ImpTot   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table MVTO.NroRef ~
MVTO.FchEmi ~
MVTO.FchVto ~
MVTO.ImpTot   
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}NroRef ~{&FP2}NroRef ~{&FP3}~
 ~{&FP1}FchEmi ~{&FP2}FchEmi ~{&FP3}~
 ~{&FP1}FchVto ~{&FP2}FchVto ~{&FP3}~
 ~{&FP1}ImpTot ~{&FP2}ImpTot ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table MVTO
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table MVTO
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH MVTO WHERE       MVTO.TpoRef = "L" NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table MVTO
&Scoped-define FIRST-TABLE-IN-QUERY-br_table MVTO


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-11 G-Letras F-LetIni F-Plazo br_table 
&Scoped-Define DISPLAYED-OBJECTS f-NroSer F-LetIni F-Plazo F-NroLet ~
F-ImpTot 

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
DEFINE BUTTON G-Letras 
     LABEL "Generar &Letras" 
     SIZE 13.57 BY .85
     BGCOLOR 15 FGCOLOR 0 FONT 6.

DEFINE VARIABLE F-ImpTot AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-LetIni AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Letra Inicial" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69 NO-UNDO.

DEFINE VARIABLE F-NroLet AS INTEGER FORMAT ">>>9":U INITIAL 1 
     LABEL "Cantidad" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .69 NO-UNDO.

DEFINE VARIABLE f-NroSer AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .69 NO-UNDO.

DEFINE VARIABLE F-Plazo AS CHARACTER FORMAT "X(3)":U INITIAL "001" 
     LABEL "Plazo" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28 BY 1.08.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      MVTO SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      MVTO.CodRef
      MVTO.NroRef COLUMN-LABEL "     Numero  "      
      MVTO.FchEmi COLUMN-LABEL "  F.Emision   "      
      MVTO.FchVto COLUMN-LABEL " F.Vencimiento"      
      MVTO.ImpTot COLUMN-LABEL "  Importe Total"
  ENABLE
      MVTO.NroRef
      MVTO.FchEmi
      MVTO.FchVto
      MVTO.ImpTot
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 49.72 BY 4.04
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     G-Letras AT ROW 4.27 COL 6
     f-NroSer AT ROW 1.19 COL 12 COLON-ALIGNED
     F-LetIni AT ROW 1.96 COL 12 COLON-ALIGNED
     F-Plazo AT ROW 2.73 COL 12 COLON-ALIGNED
     F-NroLet AT ROW 3.5 COL 12 COLON-ALIGNED
     br_table AT ROW 1 COL 27
     F-ImpTot AT ROW 5.27 COL 60.72 COLON-ALIGNED NO-LABEL
     RECT-11 AT ROW 5.08 COL 48.72
     "Importe Total" VIEW-AS TEXT
          SIZE 9.86 BY .5 AT ROW 5.27 COL 51.29
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 5.42
         WIDTH              = 76.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table F-NroLet F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NroLet IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NroSer IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH MVTO WHERE
      MVTO.TpoRef = "L" NO-LOCK.
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ANY-PRINTABLE OF br_table IN FRAME F-Main
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code `isplays initial values for newly added or copied rows. */
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


&Scoped-define SELF-NAME F-LetIni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-LetIni B-table-Win
ON ENTRY OF F-LetIni IN FRAME F-Main /* Letra Inicial */
DO:
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = "LET" AND
     FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
  IF AVAILABLE FacCorre THEN F-LetIni:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(FacCorre.Correlativo).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-LetIni B-table-Win
ON LEAVE OF F-LetIni IN FRAME F-Main /* Letra Inicial */
DO:
  IF INTEGER(SELF:SCREEN-VALUE) = 0 THEN DO:
     MESSAGE 'Letra Inicial debe ser diferente de 0' VIEW-AS ALERT-BOX ERROR.
     RETURN 'NO-APPLY'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-NroLet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-NroLet B-table-Win
ON ENTRY OF F-NroLet IN FRAME F-Main /* Cantidad */
DO:
  X-VENCTO = '1'.
  FIND Gn-convt WHERE Gn-convt.Codig = S-CONDIC NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-convt THEN DO:
     X-VENCTO = Gn-convt.Vencmtos.  
     F-NroLet = NUM-ENTRIES(X-VENCTO).
     DISPLAY F-NroLet WITH FRAME {&FRAME-NAME}.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-NroLet B-table-Win
ON LEAVE OF F-NroLet IN FRAME F-Main /* Cantidad */
DO:
  IF INTEGER(SELF:SCREEN-VALUE) = 0 THEN DO:
     MESSAGE 'Cantidad de letras debe ser diferente de 0' VIEW-AS ALERT-BOX ERROR.
     RETURN 'NO-APPLY'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Plazo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Plazo B-table-Win
ON LEAVE OF F-Plazo IN FRAME F-Main /* Plazo */
DO:
  X-VENCTO = '1'.
  S-CONDIC = SELF:SCREEN-VALUE.
  FIND Gn-convt WHERE Gn-convt.Codig = S-CONDIC NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-convt THEN DO:
     X-VENCTO = Gn-convt.Vencmtos.  
     F-NroLet = NUM-ENTRIES(X-VENCTO, "/").
     DISPLAY F-NroLet WITH FRAME {&FRAME-NAME}.
  END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME G-Letras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL G-Letras B-table-Win
ON CHOOSE OF G-Letras IN FRAME F-Main /* Generar Letras */
DO:
  ASSIGN
     F-NroSer
     F-NroLet
     F-LetIni
     F-Plazo.
  IF F-LetIni = 0 THEN DO:
     APPLY "ENTRY" TO F-LetIni.
     RETURN.
  END.
  RUN Genera-Letras.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON "RETURN":U OF MVTO.NroRef, MVTO.FchEmi, MVTO.FchVto, MVTO.ImpTot
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.
/* ***************************  Main Block  *************************** */
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asignar-Articulos B-table-Win 
PROCEDURE Asignar-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Letras B-table-Win 
PROCEDURE Genera-Letras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR s-imptot AS DECIMAL NO-UNDO INITIAL 0.
  DEFINE VAR s-implet AS DECIMAL NO-UNDO.
  DEFINE VAR s-nrolet AS INTEGER NO-UNDO.
  DEFINE VAR s-conta  AS INTEGER NO-UNDO.
  DEFINE VAR x-fchvto AS DATE    NO-UNDO.
  DEFINE VAR x-Dias   AS CHAR    NO-UNDO.
  
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                 AND  FacCorre.CodDoc = "LET" 
                 AND  FacCorre.CodDiv = S-CODDIV 
                NO-LOCK NO-ERROR.
  FOR EACH MVTO:
     IF MVTO.TpoRef = 'O' THEN s-imptot = s-imptot + MVTO.ImpTot.
     IF MVTO.TpoRef = 'L' THEN DELETE MVTO.
  END.
  s-conta = 1.
  s-nrolet = F-LetIni.
  s-implet = ROUND(s-imptot / F-NroLet , 2).
  x-fchvto = s-fchdoc.
  IF F-NroLet > NUM-ENTRIES(X-Vencto) THEN DO:
     x-Dias = ENTRY(NUM-ENTRIES(X-Vencto), X-Vencto).
     DO s-conta = NUM-ENTRIES(X-Vencto) TO F-NroLet:
        X-Vencto = X-Vencto + "," + x-Dias.
     END.
  END.
  s-conta = 1.
  DO s-conta = 1 TO F-NroLet:
     x-fchvto = s-fchdoc + INTEGER(ENTRY(s-conta, X-Vencto)).
     CREATE MVTO.
     ASSIGN MVTO.CodCia = s-codcia
            MVTO.CodDoc = s-coddoc
            MVTO.TpoRef = 'L'
            MVTO.CodRef = 'LET'
/*            MVTO.NroRef = STRING(s-nrolet,"9999") + 
 *                           STRING(MONTH(S-FCHDOC),"99") +
 *                           SUBSTRIN(STRING(YEAR(S-FCHDOC),"9999"),3,2)*/
            MVTO.NroRef = STRING(f-NroSer, '999') + STRING(s-nrolet ,"999999")
            MVTO.FchEmi = s-fchdoc
            MVTO.FchVto = x-fchvto
            MVTO.ImpTot = IF (s-conta = F-NroLet) THEN
                             (s-imptot - ((s-conta - 1) * s-implet))
                            ELSE s-implet. 
     s-nrolet = s-nrolet + 1.
  END.
    
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  
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
FOR EACH B-MVTO:
    IF B-MVTO.TpoRef = 'L' THEN
       F-ImpTot = F-ImpTot + B-MVTO.ImpTot.
END.
DISPLAY F-ImpTot WITH FRAME {&FRAME-NAME}.

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
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
         MVTO.Coddoc = s-coddoc.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
       
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */      
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA
                 AND  FacCorre.CodDoc = S-CODDOC
                 AND  FacCorre.CodDiv = S-CODDIV
                NO-LOCK NO-ERROR.
  IF AVAILABLE FacCorre THEN F-LetIni:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(FacCorre.Correlativo).
  
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
  FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                       AND  FacCorre.CodDoc = 'LET' 
                       AND  FacCorre.CodDiv = S-CODDIV 
                      NO-LOCK NO-ERROR.
  IF AVAILABLE FacCorre THEN
     ASSIGN
        I-NroSer = FacCorre.NroSer
        f-NroSer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(i-NroSer, '999')
        F-LetIni:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(FacCorre.Correlativo, '999999') .

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
        WHEN "" THEN ASSIGN input-var-1 = ''.
        WHEN "codmat" THEN ASSIGN input-var-1 = ''.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
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
IF DECIMAL(MVTO.ImpTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
   MESSAGE "Documeto con importe igual a cero" VIEW-AS ALERT-BOX ERROR.
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
APPLY 'ENTRY':U TO MVTO.FchEmi IN BROWSE {&BROWSE-NAME}.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


