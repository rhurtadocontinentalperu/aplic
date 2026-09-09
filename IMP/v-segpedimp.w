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

DEFINE BUFFER B-CCMP FOR ImCOCmp.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE PV-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NomCia  AS CHARACTER.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE SHARED VARIABLE S-PROVEE  AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.

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
&Scoped-define EXTERNAL-TABLES ImCOCmp
&Scoped-define FIRST-EXTERNAL-TABLE ImCOCmp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ImCOCmp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ImCOCmp.Aduanas ImCOCmp.Naviera ~
ImCOCmp.PrtTrans ImCOCmp.PrtoSalida ImCOCmp.NavTrans ImCOCmp.NomNave ~
ImCOCmp.FchEmbE ImCOCmp.FchEmbR ImCOCmp.FchTransE ImCOCmp.FchTransR ~
ImCOCmp.TravesiaEE ImCOCmp.TravesiaER ImCOCmp.TravesiaTE ImCOCmp.TravesiaTR ~
ImCOCmp.DsaduanaEE ImCOCmp.DsaduanaER ImCOCmp.DsaduanaTE ImCOCmp.DsaduanaTR 
&Scoped-define ENABLED-TABLES ImCOCmp
&Scoped-define FIRST-ENABLED-TABLE ImCOCmp
&Scoped-Define ENABLED-OBJECTS RECT-24 
&Scoped-Define DISPLAYED-FIELDS ImCOCmp.NroImp ImCOCmp.NroPed ~
ImCOCmp.Aduanas ImCOCmp.Naviera ImCOCmp.PrtTrans ImCOCmp.PrtoSalida ~
ImCOCmp.NavTrans ImCOCmp.NomNave ImCOCmp.FchEmbE ImCOCmp.FchEmbR ~
ImCOCmp.FchTransE ImCOCmp.FchTransR ImCOCmp.TravesiaEE ImCOCmp.TravesiaER ~
ImCOCmp.TravesiaTE ImCOCmp.TravesiaTR ImCOCmp.FchLlegaEE ImCOCmp.FchLlegaER ~
ImCOCmp.FchLlegaTE ImCOCmp.FchLlegaTR ImCOCmp.DsaduanaEE ImCOCmp.DsaduanaER ~
ImCOCmp.DsaduanaTE ImCOCmp.DsaduanaTR ImCOCmp.FchIngAlmEE ~
ImCOCmp.FchIngAlmER ImCOCmp.FchIngAlmTE ImCOCmp.FchIngAlmTR 
&Scoped-define DISPLAYED-TABLES ImCOCmp
&Scoped-define FIRST-DISPLAYED-TABLE ImCOCmp
&Scoped-Define DISPLAYED-OBJECTS F-Aduanas F-Naviera 

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
DEFINE VARIABLE F-Aduanas AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE F-Naviera AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 9.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     ImCOCmp.NroImp AT ROW 1.19 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     ImCOCmp.NroPed AT ROW 1.19 COL 36 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 23 BY .81
     ImCOCmp.Aduanas AT ROW 2.15 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     F-Aduanas AT ROW 2.15 COL 26 COLON-ALIGNED NO-LABEL
     F-Naviera AT ROW 2.92 COL 26 COLON-ALIGNED NO-LABEL
     ImCOCmp.Naviera AT ROW 2.96 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     ImCOCmp.PrtTrans AT ROW 3.69 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 27 BY .81
     ImCOCmp.PrtoSalida AT ROW 3.77 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 27 BY .81
     ImCOCmp.NavTrans AT ROW 4.5 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 27 BY .81
     ImCOCmp.NomNave AT ROW 4.58 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 27 BY .81
     ImCOCmp.FchEmbE AT ROW 6.38 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.FchEmbR AT ROW 6.38 COL 27 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.FchTransE AT ROW 6.38 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.FchTransR AT ROW 6.38 COL 69 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.TravesiaEE AT ROW 7.15 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.TravesiaER AT ROW 7.15 COL 27 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.TravesiaTE AT ROW 7.15 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.TravesiaTR AT ROW 7.15 COL 69 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.FchLlegaEE AT ROW 7.92 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.FchLlegaER AT ROW 7.92 COL 27 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.FchLlegaTE AT ROW 7.92 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.FchLlegaTR AT ROW 7.92 COL 69 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.DsaduanaEE AT ROW 8.69 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.DsaduanaER AT ROW 8.69 COL 27 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.DsaduanaTE AT ROW 8.69 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.DsaduanaTR AT ROW 8.69 COL 69 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.FchIngAlmEE AT ROW 9.46 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.FchIngAlmER AT ROW 9.46 COL 27 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.FchIngAlmTE AT ROW 9.46 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCOCmp.FchIngAlmTR AT ROW 9.46 COL 69 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Real" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 5.81 COL 72.43
     "Estimado" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 5.81 COL 62
     "Real" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 5.62 COL 31.43
     "Estimado" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 5.62 COL 21
     RECT-24 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.ImCOCmp
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
         HEIGHT             = 9.5
         WIDTH              = 88.29.
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

/* SETTINGS FOR FILL-IN F-Aduanas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Naviera IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.FchIngAlmEE IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.FchIngAlmER IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.FchIngAlmTE IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.FchIngAlmTR IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.FchLlegaEE IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.FchLlegaER IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.FchLlegaTE IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.FchLlegaTR IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.NroImp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCOCmp.NroPed IN FRAME F-Main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME ImCOCmp.Aduanas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.Aduanas V-table-Win
ON LEAVE OF ImCOCmp.Aduanas IN FRAME F-Main /* Ag. Aduanas */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN "ADM-ERROR".
     FIND gn-prov WHERE 
        gn-prov.CodCia = PV-CODCIA AND
        gn-prov.CodPro = ImCocmp.Aduanas:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
        DISPLAY gn-prov.NomPro @ F-Aduanas WITH FRAME {&FRAME-NAME}.
     ELSE DO:
        MESSAGE "Aduanas no Registrado" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
     END.
     IF gn-prov.flgsit = 'C' THEN DO:
        MESSAGE 'Aduanas CESADO' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.DsaduanaEE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.DsaduanaEE V-table-Win
ON LEAVE OF ImCOCmp.DsaduanaEE IN FRAME F-Main /* Dias Desaduanaje */
DO:
  DEFINE VAR Fch5 AS DATE.
  Fch5 = DATE(ImCOCmp.FchLlegaEE:SCREEN-VALUE) + INTEGER(ImCOCmp.DsaduanaEE:SCREEN-VALUE).
  DISPLAY Fch5 @ ImCOCmp.FchIngAlmEE WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.DsaduanaER
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.DsaduanaER V-table-Win
ON LEAVE OF ImCOCmp.DsaduanaER IN FRAME F-Main /* DsaduanaR */
DO:
  DEFINE VAR Fch6 AS DATE.
  Fch6 = DATE(ImCOCmp.FchLlegaER:SCREEN-VALUE) + INTEGER(ImCOCmp.DsaduanaER:SCREEN-VALUE).
  DISPLAY Fch6 @ ImCOCmp.FchIngAlmER WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.DsaduanaTE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.DsaduanaTE V-table-Win
ON LEAVE OF ImCOCmp.DsaduanaTE IN FRAME F-Main /* Dias Desaduanaje */
DO:
  DEFINE VAR Fch7 AS DATE.
  Fch7 = DATE(ImCOCmp.FchLlegaTE:SCREEN-VALUE) + INTEGER(ImCOCmp.DsaduanaTE:SCREEN-VALUE).
  DISPLAY Fch7 @ ImCOCmp.FchIngAlmTE WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.DsaduanaTR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.DsaduanaTR V-table-Win
ON LEAVE OF ImCOCmp.DsaduanaTR IN FRAME F-Main /* DsaduanaTR */
DO:
  DEFINE VAR Fch8 AS DATE.
  Fch8 = DATE(ImCOCmp.FchLlegaTR:SCREEN-VALUE) + INTEGER(ImCOCmp.DsaduanaTR).
  DISPLAY Fch8 @ ImCOCmp.FchIngAlmTR WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.Naviera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.Naviera V-table-Win
ON LEAVE OF ImCOCmp.Naviera IN FRAME F-Main /* Ag. Naviera */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN "ADM-ERROR".
     FIND gn-prov WHERE 
        gn-prov.CodCia = PV-CODCIA AND
        gn-prov.CodPro = ImCocmp.Naviera:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
        DISPLAY gn-prov.NomPro @ F-Naviera WITH FRAME {&FRAME-NAME}.
     ELSE DO:
        MESSAGE "Naviera no Registrado" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
     END.
     IF gn-prov.flgsit = 'C' THEN DO:
        MESSAGE 'Naviera CESADO' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.TravesiaEE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.TravesiaEE V-table-Win
ON LEAVE OF ImCOCmp.TravesiaEE IN FRAME F-Main /* Dias de Travesia */
DO:
  DEFINE VAR Fch1 AS DATE.
  Fch1 = DATE(ImCOCmp.FchEmbE:SCREEN-VALUE) + INTEGER(ImCOCmp.TravesiaEE:SCREEN-VALUE).
  DISPLAY Fch1 @ ImCOCmp.FchLlegaEE WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.TravesiaER
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.TravesiaER V-table-Win
ON LEAVE OF ImCOCmp.TravesiaER IN FRAME F-Main /* TravesiaR */
DO:
  DEFINE VAR Fch2 AS DATE.
  Fch2 = DATE(ImCOCmp.FchEmbR:SCREEN-VALUE) + INTEGER(ImCOCmp.TravesiaER:SCREEN-VALUE).
  DISPLAY Fch2 @ ImCOCmp.FchLlegaER WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.TravesiaTE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.TravesiaTE V-table-Win
ON LEAVE OF ImCOCmp.TravesiaTE IN FRAME F-Main /* Dias de Travesia */
DO:
  DEFINE VAR Fch3 AS DATE.
  Fch3 = DATE(ImCOCmp.FchTransE:SCREEN-VALUE) + INTEGER(ImCOCmp.TravesiaTE:SCREEN-VALUE).
  DISPLAY Fch3 @ ImCOCmp.FchLlegaTE WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCOCmp.TravesiaTR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCOCmp.TravesiaTR V-table-Win
ON LEAVE OF ImCOCmp.TravesiaTR IN FRAME F-Main /* TravesiaTR */
DO:
  DEFINE VAR Fch4 AS DATE.
  Fch4 = DATE(ImCOCmp.FchTransR:SCREEN-VALUE) + INTEGER(ImCOCmp.TravesiaTR:SCREEN-VALUE).
  DISPLAY Fch4 @ ImCOCmp.FchLlegaTR WITH FRAME {&FRAME-NAME}.
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
  {src/adm/template/row-list.i "ImCOCmp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ImCOCmp"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN 
            ImCOcmp.FchLlegaEE  = ImCOcmp.FchEmbE    + ImCOcmp.TravesiaEE
            ImCOcmp.FchLlegaER  = ImCOcmp.FchEmbR    + ImCOcmp.TravesiaER
            ImCOcmp.FchIngAlmEE = ImCOcmp.FchLlegaEE + ImCOcmp.DsaduanaEE
            ImCOcmp.FchIngAlmER = ImCOcmp.FchLlegaER + ImCOcmp.DsaduanaER
            ImCOcmp.FchLlegaTE  = ImCOcmp.FchTransE  + ImCOcmp.TravesiaTE
            ImCOcmp.FchLlegaTR  = ImCOcmp.FchTransR  + ImCOcmp.TravesiaTR    
            ImCOcmp.FchIngAlmTE = ImCOcmp.FchLlegaTE + ImCOcmp.DsaduanaTE
            ImCOcmp.FchIngAlmTR = ImCOcmp.FchLlegaTR + ImCOcmp.DsaduanaTR.
       /* DISPLAY 
 *             ImCOcmp.FchLlegaEE
 *             ImCOcmp.FchLlegaER
 *             ImCOcmp.FchLlegaTE
 *             ImCOcmp.FchLlegaTR
 *             ImCOcmp.FchIngAlmEE
 *             ImCOcmp.FchIngAlmER
 *             ImCOcmp.FchIngAlmTE
 *             ImCOcmp.FchIngAlmTR WITH FRAME {&FRAME-NAME}.
 *         DISPLAY ImCOCmp.nroimp WITH FRAME {&FRAME-NAME}.*/
    END.
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE ImCOcmp THEN DO WITH FRAME {&FRAME-NAME}:
     F-Aduanas:SCREEN-VALUE = "".
     FIND gn-prov WHERE 
          gn-prov.CodCia = PV-CODCIA AND 
          gn-prov.CodPro = ImCOcmp.Aduanas 
          NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
        F-Aduanas:screen-value = gn-prov.NomPro.
     F-Naviera:SCREEN-VALUE = "".
     FIND gn-prov WHERE 
          gn-prov.CodCia = PV-CODCIA AND 
          gn-prov.CodPro = ImCOcmp.Naviera 
          NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
        F-Naviera:screen-value = gn-prov.NomPro.  
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
  DEF VAR I AS INTEGER.
  DEF VAR x-Ok AS LOG NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  SYSTEM-DIALOG PRINTER-SETUP UPDATE x-Ok.
  IF x-Ok = NO THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */ 

  IF ImCOCmp.FlgSit <> "A" THEN RUN IMP\r-pedimp(ROWID(ImCOCmp), ImCOCmp.CODDOC, ImCOCmp.NROIMP).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
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
    input-var-1 = "".
    CASE HANDLE-CAMPO:name:
        WHEN "CndCmp" THEN ASSIGN input-var-1 = "" /*"20"*/.
        

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
  {src/adm/template/snd-list.i "ImCOCmp"}

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
  
  /*IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
 *      Im-CREA = NO.
 *      RUN Actualiza-DCMP.
 *      RUN Procesa-Handle IN lh_Handle ("Pagina2").
 *      RUN Procesa-Handle IN lh_Handle ('Browse').
  END.*/
  
  
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
 IF INTEGRAL.ImCOCmp.FlgSit = 'E' THEN DO:
    RETURN "OK".
 END.
 ELSE RETURN "ADM-ERROR".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

