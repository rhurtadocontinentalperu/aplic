&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
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

DEFINE SHARED TEMP-TABLE DETA LIKE CcbDDocu.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE cl-codcia  AS INT.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM  AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE F-FACTOR     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE S-UNDBAS     AS CHARACTER NO-UNDO.
DEFINE VARIABLE I-MaxItm     AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-OK         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-ListPr     AS INTEGER   NO-UNDO.

DEFINE VARIABLE F-PREVTA LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE F-PorImp LIKE Almmmatg.PreBas NO-UNDO.

DEFINE BUFFER B-DETA FOR DETA.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

IF S-CODDOC = "FAC" THEN I-MaxItm = FacCfgGn.Items_Factura.
IF S-CODDOC = "BOL" THEN I-MaxItm = FacCfgGn.Items_Boleta.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES DETA Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table DETA.codmat Almmmatg.DesMat DETA.UndVta DETA.CanDes DETA.PreUni DETA.PorDto DETA.ImpLin   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table DETA.codmat   DETA.UndVta  DETA.CanDes  DETA.PreUni  DETA.PorDto   
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table DETA
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table DETA
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH DETA  NO-LOCK, ~
             FIRST Almmmatg OF DETA NO-LOCK
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH DETA  NO-LOCK, ~
             FIRST Almmmatg OF DETA NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table DETA Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DETA
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-11 
&Scoped-Define DISPLAYED-OBJECTS F-TotBrt F-ImpDes F-ValVta F-ImpIgv ~
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

DEFINE VARIABLE F-TotBrt AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ValVta AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76.29 BY 1.42.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      DETA, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      DETA.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)"
      Almmmatg.DesMat FORMAT "X(38)"
      DETA.UndVta COLUMN-LABEL "Unidad" FORMAT "X(5)"
      DETA.CanDes FORMAT ">>>,>>9.99"
      DETA.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT ">>>>,>>9.99" COLUMN-BGCOLOR 11
      DETA.PorDto COLUMN-LABEL "Dscto"  COLUMN-BGCOLOR 16
      DETA.ImpLin FORMAT ">,>>>,>>9.99"
ENABLE
   DETA.codmat 
   DETA.UndVta
   DETA.CanDes
   DETA.PreUni
   DETA.PorDto
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 76.29 BY 7.81
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     F-TotBrt AT ROW 9.42 COL 2 NO-LABEL
     F-ImpDes AT ROW 9.42 COL 10.57 COLON-ALIGNED NO-LABEL
     F-ValVta AT ROW 9.42 COL 21.29 COLON-ALIGNED NO-LABEL
     F-ImpIgv AT ROW 9.42 COL 32 COLON-ALIGNED NO-LABEL
     F-ImpIsc AT ROW 9.42 COL 42.72 COLON-ALIGNED NO-LABEL
     F-ImpExo AT ROW 9.42 COL 55.29 NO-LABEL
     F-ImpTot AT ROW 9.42 COL 64.14 COLON-ALIGNED NO-LABEL
     "Total Importe" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 8.92 COL 66.29
     "T.Exonerado" VIEW-AS TEXT
          SIZE 9.14 BY .5 AT ROW 8.92 COL 55.57
     "I.S.C." VIEW-AS TEXT
          SIZE 4.57 BY .5 AT ROW 8.92 COL 47.57
     "I.G.V." VIEW-AS TEXT
          SIZE 5.14 BY .5 AT ROW 8.92 COL 38.57
     "Valor Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 8.92 COL 25.57
     "T.Descuento" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 8.92 COL 13.14
     "Total Bruto" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 8.92 COL 3.72
     RECT-11 AT ROW 8.85 COL 1
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
         HEIGHT             = 9.27
         WIDTH              = 76.29.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

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
/* SETTINGS FOR FILL-IN F-TotBrt IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-ValVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH DETA  NO-LOCK,
      FIRST Almmmatg OF DETA NO-LOCK.
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


ON "RETURN":U OF DETA.codmat, DETA.UndVta, DETA.CanDes, DETA.PreUni, DETA.PorDto
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON "LEAVE":U OF DETA.CodMat
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
   /* Valida Maestro Productos */
   FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
        Almmmatg.codmat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   /* Valida Maestro Productos x Almacen */
   FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
        Almmmate.CodAlm = S-CODALM AND
        Almmmate.CodMat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almmmate THEN DO:
      MESSAGE "Articulo no esta asignado al" SKIP
              "    ALMACEN : " S-CODALM VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.   
   END.
   S-UNDBAS = Almmmatg.UndBas.
   F-FACTOR = 1.
   RUN Calculo-Precios.
   DISPLAY Almmmatg.DesMat @ Almmmatg.DesMat 
           Almmmatg.UndStk @ DETA.UndVta 
           F-DSCTOS @ DETA.PorDto
           F-PREVTA @ DETA.PreUni WITH BROWSE {&BROWSE-NAME}.
END.

ON "LEAVE":U OF DETA.UndVta
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
        Almmmatg.codmat = DETA.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
        NO-LOCK NO-ERROR.
   IF AVAILABLE Almmmatg THEN DO:
      FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas AND
           Almtconv.Codalter = SELF:SCREEN-VALUE  NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almtconv THEN DO:
         MESSAGE "Codigo de unidad no exixte" VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
      END.
      F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
      RUN Calculo-Precios.
      DISPLAY F-PREVTA  @ DETA.PreUni WITH BROWSE {&BROWSE-NAME}.
   END.
END.

ON "LEAVE":U OF DETA.PorDto
DO:
   IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN RETURN.
   FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
        Almmmatg.codmat = DETA.CodMat:SCREEN-VALUE in browse {&BROWSE-NAME} NO-LOCK NO-ERROR.
   IF AVAILABLE Almmmatg THEN DO:
      IF DECIMAL(SELF:SCREEN-VALUE) > Almmmatg.PorVta[1] THEN DO:
         MESSAGE "Descuento no puede se mayor a" Almmmatg.PorVta[1] VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
      END.
   END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asignar-Articulos B-table-Win 
PROCEDURE Asignar-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE I AS INTEGER NO-UNDO.
   DEFINE VARIABLE C-CODIGO AS CHAR NO-UNDO.
   
   ASSIGN input-var-1 = STRING(I-ListPr).
   
   RUN LKUP\C-AsgArt.r("ASIGNACION DE ARTICULOS").
   
   IF output-var-2 <> "" AND output-var-2 <> ? THEN DO:
      DO I = 1 TO NUM-ENTRIES(output-var-2):
         C-CODIGO = ENTRY(I,output-var-2).
         FIND B-DETA WHERE B-DETA.CODCIA = S-CODCIA AND
              B-DETA.CodMat = C-CODIGO NO-LOCK NO-ERROR.
         IF NOT AVAILABLE B-DETA THEN DO:
            FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
                 Almmmatg.codmat = C-CODIGO NO-LOCK NO-ERROR.
            S-UNDBAS = Almmmatg.UndBas.
            F-FACTOR = 1.
            RUN Calculo-Precios.
            CREATE B-DETA.
            ASSIGN B-DETA.CodCia = S-CODCIA
                   B-DETA.codmat = C-CODIGO
                   B-DETA.UndVta = Almmmatg.UndStk
                   B-DETA.Factor = F-FACTOR
                   B-DETA.PreBas = F-PreBas 
                   B-DETA.AftIgv = Almmmatg.AftIgv 
                   B-DETA.AftIsc = Almmmatg.AftIsc
                   B-DETA.PreUni = F-PREVTA
                   B-DETA.PorDto = F-DSCTOS
                   B-DETA.CanDes = 1
                   B-DETA.ImpDto = ROUND( B-DETA.PreUni * (F-DSCTOS / 100) * B-DETA.CanDes , 2 ).
                   B-DETA.ImpLin = ROUND( B-DETA.PreUni * B-DETA.CanDes , 2 ) - B-DETA.ImpDto.
            IF B-DETA.AftIsc THEN 
               B-DETA.ImpIsc = ROUND(B-DETA.PreBas * B-DETA.CanDes * (Almmmatg.PorIsc / 100),4).
            IF B-DETA.AftIgv THEN  
               B-DETA.ImpIgv = B-DETA.ImpLin - ROUND(B-DETA.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
         END.
      END.
      RUN dispatch IN THIS-PROCEDURE ('open-query':U).
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo-Precios B-table-Win 
PROCEDURE Calculo-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   F-PorImp = 1.
   IF Almmmatg.AftIsc THEN F-PorImp = (1 + Almmmatg.PorIsc / 100).
   IF Almmmatg.AftIgv THEN F-PorImp = F-PorImp * (1 + FacCfgGn.PorIgv / 100).
   IF S-CODMON = 1 THEN DO:
      IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREBAS = Almmmatg.PreBas * F-FACTOR.
      ELSE ASSIGN F-PREBAS = Almmmatg.PreBas * FacCfgGn.Tpocmb[1] * F-FACTOR.
   END.
   IF S-CODMON = 2 THEN DO:
      IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREBAS = ROUND(Almmmatg.PreBas * F-FACTOR ,2).
      ELSE ASSIGN F-PREBAS = ROUND((Almmmatg.PreBas / FacCfgGn.Tpocmb[1]),2) * F-FACTOR.
   END.
   CASE I-ListPr:
        WHEN 2 THEN F-DSCTOS = Almmmatg.PorVta[1].
        WHEN 3 THEN F-DSCTOS = Almmmatg.PorVta[2].
        WHEN 4 THEN DO:
               F-DSCTOS = 0.
               F-PREBAS = F-PREBAS * (1 + (Almmmatg.PorVta[4] / 100)).
          END.
   END CASE. 
   F-PREVTA = ROUND(F-PREBAS * F-PorImp , 2).

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
DEFINE VARIABLE F-IGV AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE F-ISC AS DECIMAL INIT 0 NO-UNDO.
ASSIGN F-ImpDes = 0
       F-ImpExo = 0
       F-ImpIgv = 0
       F-ImpIsc = 0
       F-ImpTot = 0
       F-TotBrt = 0
       F-ValVta = 0.
FOR EACH B-DETA:
    F-ImpTot = F-ImpTot + B-DETA.ImpLin.
    F-Igv = F-Igv + B-DETA.ImpIgv.
    F-Isc = F-Isc + B-DETA.ImpIsc.
    F-ImpDes = F-ImpDes + B-DETA.ImpDto.
    IF NOT B-DETA.AftIgv THEN F-ImpExo = F-ImpExo + B-DETA.ImpLin.
END.
F-ImpIgv = ROUND(F-Igv,2).
F-ImpIsc = ROUND(F-Isc,2).
F-TotBrt = F-ImpTot - F-ImpIgv - F-ImpIsc + F-ImpDes - F-ImpExo.
F-ValVta = F-TotBrt -  F-ImpDes.
DISPLAY F-ImpDes
        F-ImpExo
        F-ImpIgv
        F-ImpIsc
        F-ImpTot
        F-TotBrt
        F-ValVta WITH FRAME {&FRAME-NAME}.

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
  DEFINE VARIABLE N-ITMS AS INTEGER INIT 0 NO-UNDO.
  FOR EACH B-DETA:
      N-ITMS = N-ITMS + 1.
  END.
  IF (N-ITMS + 1) > I-MaxItm THEN DO:
     MESSAGE "El numero de items no puede ser mayor a "  I-MaxItm 
             VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.

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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN DETA.CodCia = S-CODCIA
         DETA.Factor = F-FACTOR.

  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
       Almmmatg.codmat = DETA.codmat NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN DO:
     RUN Calculo-Precios.
     ASSIGN DETA.PreBas = F-PreBas 
            DETA.AftIgv = Almmmatg.AftIgv 
            DETA.AftIsc = Almmmatg.AftIsc 
      /*      DETA.PreUni = F-PREVTA */
            DETA.ImpDto = ROUND( DETA.PreUni * (DETA.PorDto / 100) * DETA.CanDes , 2 ).
            DETA.ImpLin = ROUND( DETA.PreUni * DETA.CanDes , 2 ) - DETA.ImpDto.
     IF DETA.AftIsc THEN 
        DETA.ImpIsc = ROUND(DETA.PreBas * DETA.CanDes * (Almmmatg.PorIsc / 100),4).
     IF DETA.AftIgv THEN  
        DETA.ImpIgv = DETA.ImpLin - ROUND(DETA.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
  END.
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
  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
       gn-clie.CodCli = S-CODCLI NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN I-ListPr = INTEGER(gn-clie.TpoCli).
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios B-table-Win 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH B-DETA:
    F-FACTOR = B-DETA.Factor.
    FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
         Almmmatg.codmat = B-DETA.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
       RUN Calculo-Precios.
       ASSIGN B-DETA.PreBas = F-PreBas 
              B-DETA.PreUni = F-PREVTA
              B-DETA.ImpDto = ROUND( B-DETA.PreUni * (B-DETA.PorDto / 100) * B-DETA.CanDes , 2).
              B-DETA.ImpLin = ROUND( B-DETA.PreUni * B-DETA.CanDes , 2 ) - B-DETA.ImpDto.
       IF B-DETA.AftIsc THEN 
          B-DETA.ImpIsc = ROUND(B-DETA.PreBas * B-DETA.CanDes * (Almmmatg.PorIsc / 100),4).
       IF B-DETA.AftIgv THEN  
          B-DETA.ImpIgv = B-DETA.ImpLin - ROUND(B-DETA.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
    END.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
        WHEN "codmat" THEN ASSIGN input-var-1 = STRING(I-ListPr).
        WHEN "UndVta" THEN ASSIGN input-var-1 = S-UNDBAS.
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
  {src/adm/template/snd-list.i "DETA"}
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
DEFINE VARIABLE F-STKDIS AS DECIMAL NO-UNDO.
IF INTEGER(DETA.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
   MESSAGE "Codigo de Articulo no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
IF DECIMAL(DETA.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
   MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
IF DECIMAL(DETA.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
   MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
     Almmmate.CodAlm = S-CODALM AND
     Almmmate.codmat = DETA.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN DO:
   MESSAGE "Articulo no asignado al almacen " S-CODALM VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
FIND B-DETA WHERE B-DETA.CODCIA = S-CODCIA AND
     B-DETA.CodMat = DETA.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} NO-LOCK NO-ERROR.
IF AVAILABLE  B-DETA AND ROWID(B-DETA) <> ROWID(DETA) THEN DO:
   MESSAGE "Codigo de Articulo repetido" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
/* CONSISTENCIA DE STOCK */
RUN vta/stkdispo (s-codcia, s-codalm, DETA.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
        F-Factor * DECIMAL(DETA.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}), 
        OUTPUT S-OK, OUTPUT F-STKDIS).
IF S-OK = NO THEN DO:
     MESSAGE "No hay STOCK disponible" SKIP
             " STOCK ACTUAL : " almmmate.StkAct SKIP
             " STOCK DISPONIBLE : " F-STKDIS VIEW-AS ALERT-BOX ERROR.
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
IF NOT AVAILABLE DETA THEN RETURN "ADM-ERROR".
F-FACTOR = DETA.Factor.
FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
     Almmmatg.codmat = DETA.codmat NO-LOCK NO-ERROR.
S-UNDBAS = Almmmatg.UndBas.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

