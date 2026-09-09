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

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHAR.
DEFINE SHARED VARIABLE S-CODMOV   AS INTEGER.
DEFINE SHARED VARIABLE S-NROSER   AS INTEGER.

DEFINE VARIABLE I-NRODOC AS INTEGER   NO-UNDO.

/* Definición de variables locales */
DEFINE TEMP-TABLE T-DOCU LIKE CcbCDocu.

/* Preprocesadores para condiciones */
/*
&SCOPED-DEFINE CONDICION ( T-DOCU.CodDoc BEGINS CB-CodDoc AND ~
                           T-DOCU.FlgCon = "A" )
*/
&SCOPED-DEFINE CONDICION ( T-DOCU.CodCia = S-CODCIA AND ~
                           T-DOCU.CodDiv BEGINS S-CODDIV AND ~
                           T-DOCU.CodAlm = S-CODALM AND ~
                           T-DOCU.CodDoc = CB-CodDoc AND ~
                           T-DOCU.TpoFac = "C" AND ~
                           T-DOCU.Flgcon = "A" )

/*
   FOR EACH CcbCDocu WHERE T-DOCU.CodCia = S-CODCIA AND ~
                           T-DOCU.CodDiv BEGINS S-CODDIV AND ~
                           T-DOCU.CodAlm = S-CODALM AND ~
                           T-DOCU.CodDoc = C-DOC AND ~
                           T-DOCU.TpoFac = "C" AND ~
                           T-DOCU.Flgcon = "A"
*/
&SCOPED-DEFINE CODIGO T-DOCU.NroDoc

DEFINE BUFFER B-CDOCU FOR CcbCDocu.

DEFINE BUFFER B-DDOCU FOR CcbDDocu.

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
&Scoped-define INTERNAL-TABLES T-DOCU

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-DOCU.CodDoc T-DOCU.NroDoc T-DOCU.NomCli T-DOCU.CodVen T-DOCU.FchDoc T-DOCU.FchVto (IF T-DOCU.CodMon = 2 THEN 'US$' ELSE 'S/.') @ T-DOCU.FlgUbiA T-DOCU.ImpTot   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH T-DOCU EXCLUSIVE-LOCK      WHERE {&CONDICION} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table T-DOCU
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-DOCU


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-23 br_table CB-CodDoc FILL-IN-codigo 
&Scoped-Define DISPLAYED-OBJECTS CB-CodDoc FILL-IN-codigo 

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
DEFINE VARIABLE CB-CodDoc AS CHARACTER FORMAT "X(3)":U INITIAL "BOL" 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "BOL","FAC" 
     SIZE 7.72 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-codigo AS CHARACTER FORMAT "XXX-XXXXXX":U 
     LABEL "No." 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.86 BY 10.92.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-DOCU SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      T-DOCU.CodDoc COLUMN-LABEL "Doc."
      T-DOCU.NroDoc FORMAT "XXX-XXXXXXXX"
      T-DOCU.NomCli FORMAT "x(40)"
      T-DOCU.CodVen COLUMN-LABEL "Vend." FORMAT "x(5)"
      T-DOCU.FchDoc COLUMN-LABEL "Fecha       !Emision       ."
      T-DOCU.FchVto COLUMN-LABEL "Fecha!Vencimiento"
      (IF T-DOCU.CodMon = 2 THEN  'US$' ELSE 'S/.') @ T-DOCU.FlgUbiA COLUMN-LABEL "Mon." FORMAT "XXXX"
      T-DOCU.ImpTot FORMAT "->,>>>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 83.14 BY 9.54
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 2.15 COL 1.86
     CB-CodDoc AT ROW 1.19 COL 9.43 COLON-ALIGNED
     FILL-IN-codigo AT ROW 1.19 COL 22.29 COLON-ALIGNED
     RECT-23 AT ROW 1 COL 1
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
         HEIGHT             = 11.46
         WIDTH              = 85.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table RECT-23 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH T-DOCU EXCLUSIVE-LOCK
     WHERE {&CONDICION} INDEXED-REPOSITION.
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

{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
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


&Scoped-define SELF-NAME CB-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-CodDoc B-table-Win
ON VALUE-CHANGED OF CB-CodDoc IN FRAME F-Main /* Documento */
DO:
  ASSIGN CB-CodDoc.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codigo B-table-Win
ON LEAVE OF FILL-IN-codigo IN FRAME F-Main /* No. */
DO:
    IF INPUT FILL-IN-codigo = "" THEN RETURN.
    &IF "{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}" &THEN
        FIND FIRST {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
            {&CONDICION} AND ( {&CODIGO} = INPUT FILL-IN-codigo ) NO-LOCK NO-ERROR.
        IF NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            BELL.
            MESSAGE "Registro no encontrado" VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = "".
            RETURN.
        END.
        REPOSITION {&BROWSE-NAME} TO ROWID ROWID( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} ) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE
                "Registro no se encuentra en el filtro actual" SKIP
                "       Deshacer la actual selección ?       "
                VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO TITLE "Pregunta"
                UPDATE answ AS LOGICAL.
            IF answ THEN DO:
                RUN dispatch IN THIS-PROCEDURE ('open-query':U).
                REPOSITION {&BROWSE-NAME} TO ROWID ROWID( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} ) NO-ERROR.
            END.
        END.
        ASSIGN SELF:SCREEN-VALUE = "".
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
RUN Carga-Detalle.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle B-table-Win 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE I     AS INTE NO-UNDO.
DEFINE VARIABLE C-DOC AS CHAR NO-UNDO.

FOR EACH T-DOCU:
    DELETE T-DOCU.
END.

DO I = 1 TO 2:
    C-DOC = ENTRY(I,"BOL,FAC").
/*    FIND FIRST CcbCDocu WHERE 
 *                CcbCDocu.CodCia = S-CODCIA  AND  
 *                CcbCDocu.CodDiv BEGINS S-CODDIV  AND
 *                ccbCDocu.TpoFac = "C"       AND  
 *                CcbCDocu.Flgcon = "A"       AND  
 *                CcbCDocu.CodDoc = C-DOC     AND
 *                ccbCDocu.CodAlm = S-CODALM  /*** Add by C.Q. 24/03/2000 ****/
 *                NO-LOCK NO-ERROR.
 *     IF AVAILABLE CcbCDocu THEN DO:
 *        REPEAT WHILE 
 *               CcbCDocu.CodCia = S-CODCIA  AND
 *               CcbCDocu.CodDiv BEGINS S-CODDIV  AND
 *               ccbCDocu.TpoFac = "C"       AND
 *               CcbCDocu.Flgcon = "A"       AND
 *               CcbCDocu.CodDoc = C-DOC     AND
 *               CcbCDocu.CodAlm = S-CODALM  /*** Add by C.Q. 24/03/2000 ****/
 *               :
 *             IF CcbCDocu.FlgCon = "A" AND CcbCDocu.FlgEst = "C" THEN DO:
 *                 CREATE T-DOCU.
 *                 RAW-TRANSFER CcbCDocu  TO T-DOCU.
 *             END.
 *             FIND NEXT CcbCDocu USE-INDEX LLAVE11 NO-LOCK NO-ERROR.
 *        END.
 *     END.*/

    FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = S-CODCIA
                       AND  CcbCDocu.CodDiv = S-CODDIV
                       AND  ccbCDocu.CodAlm = S-CODALM  /*** Add by C.Q. 24/03/2000 ****/
                       AND  CcbCDocu.CodDoc = C-DOC
                       AND  ccbCDocu.TpoFac = "C"
                       AND  CcbCDocu.Flgcon = "A"
                      USE-INDEX LLAVE14 NO-LOCK:
        IF CcbCDocu.FlgCon = "A" AND CcbCDocu.FlgEst = "C" THEN DO:
            CREATE T-DOCU.
            RAW-TRANSFER CcbCDocu  TO T-DOCU.
        END.
    END.
END.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Guia B-table-Win 
PROCEDURE Genera-Guia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR i AS INTEGER.
DEFINE VAR R-ROW AS ROWID.
&IF DEFINED (FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}) > 0 &THEN
    IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
       FIND CcbCDocu WHERE 
            CcbCDocu.CodCia = T-DOCU.CodCia AND
            CcbCDocu.CodDoc = T-DOCU.CodDoc AND
            CcbCDocu.NroDoc = T-DOCU.NroDoc EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE CcbCDocu THEN DO ON ERROR UNDO, RETURN "ADM-ERROR":
          RUN VTA\act_alm(ROWID(CcbCDocu)).
          FIND FacCorre WHERE 
                FacCorre.CodCia = S-CODCIA AND
                FacCorre.CodDoc = S-CODDOC AND
                FacCorre.CodDiv = S-CODDIV AND
                FacCorre.NroSer = S-NROSER  EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE FacCorre THEN DO:
              ASSIGN I-NroDoc = FacCorre.Correlativo.
                     FacCorre.Correlativo = FacCorre.Correlativo + 1.
          END.
          RELEASE FacCorre.
          CREATE B-CDocu.
          ASSIGN B-CDocu.CodCia = CcbCDocu.CodCia
                 B-CDocu.CodAlm = CcbCDocu.CodAlm
                 B-CDocu.CodDiv = CcbCDocu.CodDiv
                 B-CDocu.CodDoc = S-CODDOC
                 B-CDocu.NroDoc = STRING(S-NROSER,"999") + STRING(I-NroDoc,"999999") 
                 B-CDocu.FchDoc = TODAY 
                 B-CDocu.FchVto = TODAY 
                 B-CDOCU.NroSal = CcbCDocu.NroSal
                 B-CDocu.CodPed = CcbCDocu.CodPed
                 B-CDocu.NroPed = CcbCDocu.NroPed 
                 B-CDocu.CodRef = CcbCDocu.CodDoc
                 B-CDocu.NroRef = CcbCDocu.NroDoc 
                 B-CDocu.Nomcli = CcbCDocu.Nomcli
                 B-CDocu.Dircli = CcbCDocu.Dircli
                 B-CDocu.Ruccli = CcbCDocu.Ruccli
                 B-CDocu.CodMov = CcbCDocu.Codmov 
                 B-CDocu.CodCli = CcbCDocu.CodCli
                 B-CDocu.CodVen = CcbCDocu.CodVen
                 B-CDocu.FmaPgo = CcbCDocu.FmaPgo
                 B-CDocu.CodMon = CcbCDocu.CodMon
                 B-CDocu.TpoCmb = CcbCDocu.TpoCmb
                 B-CDocu.PorIgv = CcbCDocu.PorIgv
                 B-CDocu.NroOrd = CcbCDocu.NroOrd
                 B-CDOCU.CodDpto = CcbCDocu.CodDpto 
                 B-CDOCU.CodProv = CcbCDocu.CodProv 
                 B-CDOCU.CodDist = CcbCDocu.CodDist 
                 B-CDocu.Tipo    = "CONTADO"
                 B-CDocu.TipVta  = "1"
                 B-CDocu.TpoFac  = "C"
                 B-CDocu.FlgEst  = "F"
                 B-CDOCU.FlgSit  = ""
                 B-CDOCU.FlgCon  = ""
                 B-CDOCU.ImpBrt  = 0
                 B-CDOCU.ImpDto  = 0
                 B-CDOCU.ImpExo  = 0
                 B-CDOCU.ImpIgv  = 0
                 B-CDOCU.ImpInt  = 0
                 B-CDOCU.ImpIsc  = 0
                 B-CDOCU.ImpTot  = 0
                 B-CDOCU.ImpVta  = 0
                 B-CDOCU.SdoAct  = 0
                 B-CDocu.usuario = S-USER-ID.
          FOR EACH CCBDDOCU OF CCBCDOCU NO-LOCK:
              CREATE B-DDOCU.
              ASSIGN B-DDocu.CodCia = B-CDocu.CodCia 
                     B-DDocu.Coddoc = B-CDocu.Coddoc 
                     B-DDocu.NroDoc = B-CDocu.NroDoc 
                     B-DDocu.codmat = CcbDDocu.codmat 
                     B-DDocu.CanDes = CcbDDocu.CanDes 
                     B-DDocu.UndVta = CcbDDocu.UndVta 
                     B-DDocu.Factor = CcbDDocu.Factor 
                     B-DDocu.Pesmat = CcbDDocu.Pesmat 
                     B-DDocu.PreUni = CcbDDocu.PreUni 
                     B-DDocu.PreBas = CcbDDocu.PreBas 
                     B-DDocu.PorDto = CcbDDocu.PorDto 
                     B-DDocu.ImpLin = CcbDDocu.ImpLin 
                     B-DDocu.ImpIsc = CcbDDocu.ImpIsc 
                     B-DDocu.ImpIgv = CcbDDocu.ImpIgv 
                     B-DDocu.ImpDto = CcbDDocu.ImpDto 
                     B-DDocu.AftIsc = CcbDDocu.AftIsc 
                     B-DDocu.AftIgv = CcbDDocu.AftIgv.
          END.
          R-ROW = ROWID(B-CDocu).
          RELEASE B-CDocu.
          FIND FacCPedi WHERE 
               FacCPedi.CodCia = CcbCDocu.CodCia AND
               FacCPedi.CodDoc = CcbCDocu.CodRef AND
               FacCPedi.NroPed = CcbCDocu.NroRef EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE FacCPedi THEN DO:
             FOR EACH FacDPedi OF FacCPedi :
                 FacDPedi.FlgEst = "A".
             END.
             FacCPedi.FlgEst = "A".
          END.
          RELEASE FacCPedi.
          CcbCDocu.FlgCon = "X".
       END.
       RELEASE CcbCDocu.
       T-DOCU.FlgCon = "".
       RUN VTA\R-ImpGui.R(R-ROW).
    END.
    
&ENDIF
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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
  {src/adm/template/snd-list.i "T-DOCU"}

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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


