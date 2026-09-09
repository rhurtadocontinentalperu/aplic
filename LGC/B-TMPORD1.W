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

DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-PROVEE AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.
DEFINE SHARED VARIABLE S-CODMON AS INTEGER.

DEFINE SHARED TEMP-TABLE DCMP LIKE LG-DOCmp.
DEFINE BUFFER OCMP FOR DCMP.

DEFINE VARIABLE F-FACTOR     AS DECIMAL   NO-UNDO.

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
&Scoped-define INTERNAL-TABLES DCMP Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table DCMP.Codmat DCMP.ArtPro Almmmatg.DesMat Almmmatg.DesMar DCMP.UndCmp DCMP.CanPedi DCMP.PreUni DCMP.Dsctos[1] DCMP.Dsctos[2] DCMP.Dsctos[3] DCMP.IgvMat DCMP.ImpTot   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table DCMP.Codmat /*   DCMP.UndCmp*/ ~
DCMP.CanPedi ~
DCMP.PreUni ~
 DCMP.Dsctos[1] ~
DCMP.Dsctos[2] ~
DCMP.Dsctos[3] ~
DCMP.IgvMat   
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}Codmat ~{&FP2}Codmat ~{&FP3}~
 ~{&FP1}/* ~{&FP2}/* ~{&FP3}~
 ~{&FP1}UndCmp*/ ~{&FP2}UndCmp*/ ~{&FP3}~
 ~{&FP1}CanPedi ~{&FP2}CanPedi ~{&FP3}~
 ~{&FP1}PreUni ~{&FP2}PreUni ~{&FP3}~
 ~{&FP1}Dsctos[1] ~{&FP2}Dsctos[1] ~{&FP3}~
 ~{&FP1}Dsctos[2] ~{&FP2}Dsctos[2] ~{&FP3}~
 ~{&FP1}Dsctos[3] ~{&FP2}Dsctos[3] ~{&FP3}~
 ~{&FP1}IgvMat ~{&FP2}IgvMat ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table DCMP
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table DCMP
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH DCMP WHERE ~{&KEY-PHRASE} NO-LOCK, ~
             EACH Almmmatg OF DCMP NO-LOCK       ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table DCMP Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DCMP


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-26 
&Scoped-Define DISPLAYED-OBJECTS F-ImpBrt F-ImpDes F-ValVta F-ImpIgv ~
F-ImpIsc F-ImpExo F-ImpTot 

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
DEFINE VARIABLE F-ImpBrt AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpDes AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpExo AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpIgv AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpIsc AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpTot AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ValVta AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72.86 BY 1.42.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      DCMP, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      DCMP.Codmat
      DCMP.ArtPro
      Almmmatg.DesMat FORMAT "X(40)"
      Almmmatg.DesMar FORMAT "X(15)"
      DCMP.UndCmp COLUMN-LABEL "Unid!Cmp." FORMAT "X(4)"
      DCMP.CanPedi
      DCMP.PreUni FORMAT "->>9.999999"
      DCMP.Dsctos[1] COLUMN-LABEL "Dscto1" FORMAT "->>9.99"
      DCMP.Dsctos[2] COLUMN-LABEL "Dscto2" FORMAT "->>9.99"
      DCMP.Dsctos[3] COLUMN-LABEL "Dscto3" FORMAT "->>9.99"
      DCMP.IgvMat
      DCMP.ImpTot
  ENABLE
      DCMP.Codmat
/*      DCMP.UndCmp*/
      DCMP.CanPedi
      DCMP.PreUni   
      DCMP.Dsctos[1]
      DCMP.Dsctos[2]
      DCMP.Dsctos[3]
      DCMP.IgvMat
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 85.43 BY 7.15
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     F-ImpBrt AT ROW 8.85 COL 1.43 NO-LABEL
     F-ImpDes AT ROW 8.85 COL 9.72 COLON-ALIGNED NO-LABEL
     F-ValVta AT ROW 8.85 COL 20 COLON-ALIGNED NO-LABEL
     F-ImpIgv AT ROW 8.85 COL 30.29 COLON-ALIGNED NO-LABEL
     F-ImpIsc AT ROW 8.85 COL 40.72 COLON-ALIGNED NO-LABEL
     F-ImpExo AT ROW 8.85 COL 53 NO-LABEL
     F-ImpTot AT ROW 8.85 COL 61.29 COLON-ALIGNED NO-LABEL
     RECT-26 AT ROW 8.27 COL 1
     "Total Bruto" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 8.35 COL 3
     "T.Descuento" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 8.35 COL 12.57
     "Valor Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 8.35 COL 24
     "I.G.V." VIEW-AS TEXT
          SIZE 5.14 BY .5 AT ROW 8.35 COL 37
     "I.S.C." VIEW-AS TEXT
          SIZE 4.57 BY .5 AT ROW 8.35 COL 48
     "T.Exonerado" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 8.35 COL 53.57
     "Total Importe" VIEW-AS TEXT
          SIZE 9.29 BY .5 AT ROW 8.35 COL 63.86
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
         HEIGHT             = 8.88
         WIDTH              = 85.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main = 3.

/* SETTINGS FOR FILL-IN F-ImpBrt IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-ImpDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ImpExo IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-ImpIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ImpIsc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ValVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH DCMP WHERE ~{&KEY-PHRASE} NO-LOCK,
      EACH Almmmatg OF DCMP NO-LOCK
      ~{&SORTBY-PHRASE}.
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON "RETURN":U OF DCMP.Codmat, /*DCMP.UndCmp,*/ DCMP.CanPedi,DCMP.PreUni,DCMP.Dsctos[1],DCMP.Dsctos[2],DCMP.Dsctos[3],DCMP.IgvMat
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON "LEAVE":U OF DCMP.Codmat
DO:
  IF DCMP.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN RETURN.
  DCMP.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "codigo de articulo no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  IF Almmmatg.Tpoart <> "A" THEN DO:
     MESSAGE "Articulo Desactivado" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
 
  DISPLAY Almmmatg.DesMat @ Almmmatg.DesMat 
          /*Almmmatg.UndStk*/ Almmmatg.UndCmp @ DCMP.UndCmp
          Almmmatg.ArtPro @ DCMP.ArtPro 
          WITH BROWSE {&BROWSE-NAME}.          

   F-FACTOR = 1.
   FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                  AND  Almtconv.Codalter = Almmmatg.UndCmp
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almtconv THEN DO:
      MESSAGE "Codigo de unidad no exixte en tabla de Equivalencias"
              VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   ELSE F-FACTOR = Almtconv.Equival.

/**** Aqui se comenzo a modificar ****/
/*          Almmmatg.Dsctos[1] @ DCMP.Dsctos[1]
 *           Almmmatg.Dsctos[2] @ DCMP.Dsctos[2]
 *           Almmmatg.Dsctos[3] @ DCMP.Dsctos[3] 
 *           18                 @  DCMP.IgvMat 
 *           WITH BROWSE {&BROWSE-NAME}.          
 * 
 *       IF S-CODMON = 1 THEN DO:
 *          IF Almmmatg.MonVta = 1 THEN
 *             DISPLAY Almmmatg.PreAct @ DCMP.PreUni WITH BROWSE {&BROWSE-NAME}.
 *          ELSE 
 *             DISPLAY ROUND(Almmmatg.PreAct * S-TPOCMB,4) @ DCMP.PreUni WITH BROWSE {&BROWSE-NAME}.
 *       END.
 *       ELSE DO:
 *          IF Almmmatg.MonVta = 2 THEN
 *             DISPLAY Almmmatg.PreAct @ DCMP.PreUni WITH BROWSE {&BROWSE-NAME}.     
 *          ELSE 
 *             DISPLAY ROUND(Almmmatg.PreAct / S-TPOCMB,4) @ DCMP.PreUni WITH BROWSE {&BROWSE-NAME}.
 *       END.*/
/**** Aqui termino la modificacion  *****/

/***** Se Usara con lista de Precios Proveedor Original *****/
  DCMP.ArtPro:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = Almmmatg.ArtPro.
  FIND FIRST LG-dmatpr WHERE LG-dmatpr.CodCia = S-CODCIA 
                        AND  LG-dmatpr.codpro = S-PROVEE 
                        AND  LG-dmatpr.codmat = SELF:SCREEN-VALUE  
                        AND  LG-dmatpr.FlgEst = "A" 
                       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE LG-dmatpr THEN DO:
     MESSAGE "codigo de articulo no esta asignado al proveedor" SKIP
             "desea continua " VIEW-AS ALERT-BOX ERROR BUTTONS YES-NO
             UPDATE Rpta AS LOGICAL.
     IF NOT Rpta THEN RETURN NO-APPLY.
  END.
  IF AVAILABLE LG-dmatpr THEN DO:
     DISPLAY LG-dmatpr.Dsctos[1] @ DCMP.Dsctos[1]
             LG-dmatpr.Dsctos[2] @ DCMP.Dsctos[2]
             LG-dmatpr.Dsctos[3] @ DCMP.Dsctos[3]
             LG-dmatpr.IgvMat    @ DCMP.IgvMat 
             WITH BROWSE {&BROWSE-NAME}.
     IF S-CODMON = 1 THEN DO:
        IF LG-dmatpr.CodMon = 1 THEN
           DISPLAY LG-dmatpr.PreAct @ DCMP.PreUni WITH BROWSE {&BROWSE-NAME}.
        ELSE 
           DISPLAY ROUND(LG-dmatpr.PreAct * S-TPOCMB,4) @ DCMP.PreUni WITH BROWSE {&BROWSE-NAME}.
     END.
     ELSE DO:
        IF LG-dmatpr.CodMon = 2 THEN
           DISPLAY LG-dmatpr.PreAct @ DCMP.PreUni WITH BROWSE {&BROWSE-NAME}.     
        ELSE 
           DISPLAY ROUND(LG-dmatpr.PreAct / S-TPOCMB,4) @ DCMP.PreUni WITH BROWSE {&BROWSE-NAME}.
     END.
   END.
/*********************************************/
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
  IF S-PROVEE = "" THEN DO:
     MESSAGE "Codigo de proveedor no registrado" VIEW-AS ALERT-BOX.
     RETURN "ADM-ERROR".
  END.
  RUN lgc\C-AsgArt.R("Maestro de Articulos").
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cambia-de-Moneda B-table-Win 
PROCEDURE Cambia-de-Moneda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH OCMP NO-LOCK:
     IF S-CODMON = 1 THEN DO:
        IF OCMP.CanAten = 2 THEN
           OCMP.PreUni = ROUND( OCMP.PreUni * S-TPOCMB,4).
     END.
     ELSE DO:
        IF OCMP.CanAten = 1 THEN
           OCMP.PreUni = ROUND( OCMP.PreUni / S-TPOCMB,4).
     END.
     OCMP.CanAten = S-Codmon.
     OCMP.ImpTot = ROUND(OCMP.CanPedi * ROUND(OCMP.PreUni * 
                             (1 - (OCMP.Dsctos[1] / 100)) *
                             (1 - (OCMP.Dsctos[2] / 100)) *
                             (1 - (OCMP.Dsctos[3] / 100)) *
                             (1 + (OCMP.IgvMat / 100)) , 4),2).
  END.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importe-Total B-table-Win 
PROCEDURE Importe-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:  
  ASSIGN F-ImpDes = 0
         F-ImpExo = 0
         F-ImpIgv = 0
         F-ImpIsc = 0
         F-ImpTot = 0
         F-ImpBrt = 0
         F-ValVta = 0.
  FOR EACH OCMP NO-LOCK:
         F-ImpTot = F-ImpTot + OCMP.ImpTot.
         IF OCMP.IgvMat = 0 THEN F-ImpExo = F-ImpExo + OCMP.ImpTot.
  END.
  FIND LAST LG-CFGIGV NO-LOCK NO-ERROR.
  ASSIGN F-ImpIgv = (F-ImpTot - F-ImpExo) - 
                    ROUND((F-ImpTot - F-ImpExo)/ (1 + LG-CFGIGV.PorIgv / 100),2)
         F-ImpBrt = F-ImpTot - F-ImpExo - F-ImpIgv
         F-ImpDes = 0
         F-ValVta = F-ImpTot - F-ImpDes - F-ImpExo - F-ImpIgv.
  DISPLAY F-ImpDes  F-ImpExo  F-ImpIgv  F-ImpIsc  F-ImpTot  F-ImpBrt  F-ValVta.
END.
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
  
  IF S-PROVEE = "" THEN DO:
     MESSAGE "No registro al proveedor" VIEW-AS ALERT-BOX ERROR.
     RETURN ERROR.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
       Almmmatg.CodMat = DCMP.Codmat NO-LOCK NO-ERROR.
  
  ASSIGN DCMP.CodCia = S-CODCIA 
         DCMP.ArtPro = ""
         DCMP.UndCmp = Almmmatg.UndStk
         DCMP.ArtPro = Almmmatg.ArtPro
         DCmp.CanAten = S-Codmon
         DCMP.ImpTot = ROUND(DCmp.CanPedi * ROUND(DCMP.PreUni * 
                                (1 - (DCMP.Dsctos[1] / 100)) *
                                (1 - (DCMP.Dsctos[2] / 100)) *
                                (1 - (DCMP.Dsctos[3] / 100)) *
                                (1 + (DCMP.IgvMat / 100)) , 4),2).
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
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
  
  RUN Importe-Total.

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
  
  RUN Importe-Total.
  
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
/*
    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.
  */  
    
    CASE HANDLE-CAMPO:name:
        WHEN "PreUni" THEN ASSIGN input-var-1 = DCMP.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
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
  {src/adm/template/snd-list.i "DCMP"}
  {src/adm/template/snd-list.i "Almmmatg"}

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
IF DCMP.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "Codigo en blanco" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
IF DECIMAL(DCMP.CanPedi:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
   MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
/* IF DECIMAL(DCMP.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
   MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
FIND OCMP WHERE OCMP.CODCIA = S-CODCIA AND
     OCMP.CodMat = DCMP.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
     NO-LOCK NO-ERROR.
IF AVAILABLE OCMP AND ROWID(OCMP) <> ROWID(DCMP) THEN DO:
   MESSAGE "Articulo repetido" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.  */

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


