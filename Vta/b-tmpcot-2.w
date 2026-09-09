&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.



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

DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE CL-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM  AS CHAR.
DEFINE SHARED VARIABLE S-CNDVTA  AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.  

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE F-FACTOR     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE S-UNDBAS     AS CHARACTER NO-UNDO.
DEFINE VARIABLE I-NroItm     AS INTEGER   NO-UNDO.

DEFINE VARIABLE F-PREVTA LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE F-PorImp LIKE Almmmatg.PreBas NO-UNDO.

DEFINE BUFFER B-PEDI FOR PEDI.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VARIABLE X-CLFCLI AS CHARACTER.
DEFINE VARIABLE MaxCat LIKE ClfClie.PorDsc.
DEFINE VARIABLE MaxVta LIKE Dsctos.PorDto.

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
&Scoped-define INTERNAL-TABLES PEDI Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table PEDI.NroItm PEDI.codmat ~
Almmmatg.DesMat Almmmatg.DesMar PEDI.UndVta PEDI.CanPed PEDI.PorDto ~
PEDI.PreUni PEDI.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table PEDI.codmat PEDI.CanPed ~
PEDI.ImpLin 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table PEDI
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table PEDI
&Scoped-define QUERY-STRING-br_table FOR EACH PEDI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF PEDI NO-LOCK ~
    BY PEDI.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PEDI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF PEDI NO-LOCK ~
    BY PEDI.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table PEDI Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PEDI
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-22 
&Scoped-Define DISPLAYED-OBJECTS F-PorDes F-TotBrt F-ImpExo F-ImpDes ~
F-ValVta F-ImpIsc F-ImpIgv F-ImpTot 

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
     SIZE 13.57 BY .88
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpExo AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpIgv AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpIsc AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpTot AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-PorDes AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "% Dscto" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TotBrt AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ValVta AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 112 BY 3.08.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      PEDI, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      PEDI.NroItm COLUMN-LABEL "Item" FORMAT ">>9":U
      PEDI.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(35)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(10)":U
      PEDI.UndVta COLUMN-LABEL "Unidad" FORMAT "x(6)":U
      PEDI.CanPed FORMAT ">>,>>9.99":U
      PEDI.PorDto FORMAT ">>9.99":U
      PEDI.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT ">,>>9.9999":U
      PEDI.ImpLin FORMAT ">>>,>>9.99":U
  ENABLE
      PEDI.codmat
      PEDI.CanPed
      PEDI.ImpLin
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 112 BY 7.54
         BGCOLOR 15 FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     F-PorDes AT ROW 8.88 COL 29 COLON-ALIGNED
     F-TotBrt AT ROW 10.62 COL 2 NO-LABEL
     F-ImpExo AT ROW 10.62 COL 15 NO-LABEL
     F-ImpDes AT ROW 10.62 COL 27 COLON-ALIGNED NO-LABEL
     F-ValVta AT ROW 10.62 COL 43 COLON-ALIGNED NO-LABEL
     F-ImpIsc AT ROW 10.62 COL 59 COLON-ALIGNED NO-LABEL
     F-ImpIgv AT ROW 10.62 COL 75 COLON-ALIGNED NO-LABEL
     F-ImpTot AT ROW 10.62 COL 90 COLON-ALIGNED NO-LABEL
     "T.Descuento" VIEW-AS TEXT
          SIZE 11.57 BY .5 AT ROW 10.04 COL 31
     "I.S.C." VIEW-AS TEXT
          SIZE 5.57 BY .5 AT ROW 10.04 COL 67
     "I.G.V." VIEW-AS TEXT
          SIZE 5.14 BY .5 AT ROW 10.04 COL 83
     "T.Exonerado" VIEW-AS TEXT
          SIZE 11.72 BY .5 AT ROW 10.04 COL 17
     "Total Importe" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 10.04 COL 92
     "Valor Venta" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 10.04 COL 46
     "Total Bruto" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 10.04 COL 3
     RECT-22 AT ROW 8.69 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 2.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDI T "SHARED" ? INTEGRAL FacDPedi
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 10.85
         WIDTH              = 113.57.
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
/* SETTINGS FOR FILL-IN F-PorDes IN FRAME F-Main
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
     _TblList          = "Temp-Tables.PEDI,INTEGRAL.Almmmatg OF Temp-Tables.PEDI"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _OrdList          = "Temp-Tables.PEDI.NroItm|yes"
     _FldNameList[1]   > Temp-Tables.PEDI.NroItm
"PEDI.NroItm" "Item" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.PEDI.codmat
"PEDI.codmat" "Articulo" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(35)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.PEDI.UndVta
"PEDI.UndVta" "Unidad" "x(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.PEDI.CanPed
"PEDI.CanPed" ? ">>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.PEDI.PorDto
     _FldNameList[8]   > Temp-Tables.PEDI.PreUni
"PEDI.PreUni" "Precio!Unitario" ">,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.PEDI.ImpLin
"PEDI.ImpLin" ? ">>>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME PEDI.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDI.codmat IN BROWSE br_table /* Articulo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN .
  ASSIGN
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999")
    NO-ERROR.
  /* Valida Maestro Productos */
  FIND Almmmatg WHERE 
        Almmmatg.CodCia = S-CODCIA AND  
        Almmmatg.codmat = SELF:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF Almmmatg.TpoArt <> "A" THEN DO:
      MESSAGE "Articulo no Activo" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF Almmmatg.Chr__01 = "" THEN DO:
      MESSAGE "Articulo no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  /* Valida Maestro Productos x Almacen */
  FIND Almmmate WHERE 
        Almmmate.CodCia = S-CODCIA AND  
        Almmmate.CodAlm = S-CODALM AND  
        Almmmate.CodMat = SELF:SCREEN-VALUE 
        use-index mate01
        NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmate THEN DO:
      MESSAGE "Articulo no esta asignado al" SKIP
              "    ALMACEN : " S-CODALM VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.   
  END.
 
/*  DEFINE VAR L-OK AS LOGICAL.
 *   RUN lkup/c-uniofi ("Unidades de Venta",
 *                        Almmmate.CodMat,
 *                        OUTPUT L-OK
 *                        ).
 *   IF NOT L-OK THEN RETURN NO-APPLY.*/
  ASSIGN    
    S-UNDBAS = Almmmatg.UndBas
    F-FACTOR = 1.
  RUN Calculo-Precios.
  DISPLAY 
    Almmmatg.DesMat @ Almmmatg.DesMat 
    Almmmatg.DesMar @ Almmmatg.DesMar 
    Almmmatg.Chr__01 @ PEDI.UndVta 
    F-DSCTOS @ PEDI.PorDto
    F-PREVTA @ PEDI.PreUni 
    WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PEDI.CanPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI.CanPed br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF PEDI.CanPed IN BROWSE br_table /* Cantidad */
DO:
  DEFINE VAR L-OK AS LOGICAL.
  RUN lkup/c-uniofi ("Unidades de Venta",
                       Almmmate.CodMat,
                       OUTPUT L-OK
                       ).
  IF NOT L-OK THEN DO:
    APPLY 'ENTRY':U TO PEDI.CodMat IN BROWSE {&BROWSE-NAME}.
    RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI.CanPed br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDI.CanPed IN BROWSE br_table /* Cantidad */
DO:
  FIND Almtconv WHERE 
       Almtconv.CodUnid  = Almmmatg.UndBas AND  
       Almtconv.Codalter = Almmmatg.Chr__01 
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almtconv THEN DO:
      MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF Almtconv.Multiplos <> 0 THEN DO:
    IF DEC(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos <> 
          INT(DEC(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos) THEN DO:
        MESSAGE " La Cantidad debe de ser un, " SKIP
                  " multiplo de : " Almtconv.Multiplos
                  VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
  END.
  RUN Calculo-Precios.
  DISPLAY 
    Almmmatg.DesMat @ Almmmatg.DesMat 
    Almmmatg.DesMar @ Almmmatg.DesMar 
    Almmmatg.Chr__01 @ PEDI.UndVta 
    F-DSCTOS @ PEDI.PorDto
    F-PREVTA @ PEDI.PreUni 
    DEC(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * DEC(PEDI.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) @ PEDI.ImpLin 
    WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PEDI.PreUni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI.PreUni br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDI.PreUni IN BROWSE br_table /* Precio!Unitario */
DO:
  IF F-PREVTA > DEC(PEDI.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO:
     MESSAGE "No Autorizado para modificar Precio " 
        VIEW-AS ALERT-BOX ERROR.
     DISPLAY F-PREVTA @ PEDI.PreUni WITH BROWSE {&BROWSE-NAME}.
     RETURN NO-APPLY.   
  END.
  DISPLAY 
    DEC(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * DEC(PEDI.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    @ PEDI.ImpLin WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PEDI.ImpLin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI.ImpLin br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDI.ImpLin IN BROWSE br_table /* Importe */
DO:
  DISPLAY
    ROUND(DEC(PEDI.ImpLin:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) /
        DEC(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}), 4)
    @ PEDI.PreUni WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF


ON "RETURN":U OF PEDI.codmat, PEDI.UndVta ,PEDI.CanPed ,PEDI.PorDto ,PEDI.PreUni, PEDI.ImpLin
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo-Precios B-table-Win 
PROCEDURE Calculo-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  F-PorImp = 1.

  /*********/
  FIND gn-clie WHERE 
        gn-clie.CodCia = cl-codcia AND  
        gn-clie.CodCli = S-CODCLI NO-LOCK NO-ERROR.
  IF AVAIL gn-clie THEN X-CLFCLI = gn-clie.clfCli.
  ELSE X-CLFCLI = "".
   
  IF S-CODMON = 1 THEN DO:
      IF Almmmatg.MonVta = 1 THEN
          ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * F-FACTOR.
      ELSE
          ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * S-TpoCmb /*Almmmatg.TpoCmb*/ * F-FACTOR.
  END.
        
  IF S-CODMON = 2 THEN DO:
      IF Almmmatg.MonVta = 2 THEN
         ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * F-FACTOR.
      ELSE
         ASSIGN F-PREBAS = ((Almmmatg.PreOfi * F-PorImp) / S-TpoCmb /*Almmmatg.TpoCmb*/) * F-FACTOR.
  END.
  ASSIGN   
   MaxCat = 0
   MaxVta = 0.
   
  FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI /*gn-clie.clfCli*/
                NO-LOCK NO-ERROR.
  IF AVAIL ClfClie THEN DO:
      IF Almmmatg.Chr__02 = "P" THEN 
          MaxCat = ClfClie.PorDsc.
      ELSE 
          MaxCat = ClfClie.PorDsc1.
  END.
   
  FIND Dsctos WHERE 
         Dsctos.CndVta = S-CNDVTA AND  
         Dsctos.clfCli = Almmmatg.Chr__02
          NO-LOCK NO-ERROR.
  IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.
    
  /***************************************************/
  IF NOT AVAIL ClfClie 
  THEN F-DSCTOS = (1 - (1 - MaxVta / 100)) * 100.
  ELSE F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.
  F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).
  RUN BIN/_ROUND1(F-PREVTA,4,OUTPUT F-PREVTA).
  /**********/

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
FOR EACH B-PEDI :
    F-ImpTot = F-ImpTot + B-PEDI.ImpLin.
    F-Igv = F-Igv + B-PEDI.ImpIgv.
    F-Isc = F-Isc + B-PEDI.ImpIsc.
    F-ImpDes = F-ImpDes + B-PEDI.ImpDto.
    IF NOT B-PEDI.AftIgv THEN F-ImpExo = F-ImpExo + B-PEDI.ImpLin.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY 'ENTRY':U TO PEDI.codmat IN BROWSE {&BROWSE-NAME}.
  RUN Procesa-Handle IN lh_handle ('Disable-Head') .

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
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
    i-NroItm = 1.
    FOR EACH B-PEDI BY B-PEDI.NroItm:
        i-NroItm = B-PEDI.NroItm + 1.
    END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN 
    PEDI.CodCia = S-CODCIA
    PEDI.Factor = F-FACTOR
    PEDI.NroItm = I-NroItm
    PEDI.ALMDES = S-CODALM.
         
  ASSIGN 
    PEDI.UndVta = Almmmatg.Chr__01
    PEDI.PreBas = F-PreBas 
    PEDI.AftIgv = Almmmatg.AftIgv 
    PEDI.AftIsc = Almmmatg.AftIsc 
    PEDI.PreUni = DEC(PEDI.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) 
    PEDI.PorDto = DEC(PEDI.PorDto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) 
    PEDI.Por_DSCTOS[2] = Almmmatg.PorMax
    PEDI.ImpDto = ROUND( PEDI.PreBas * (PEDI.PorDto / 100) * PEDI.CanPed , 2 ).
    /*PEDI.ImpLin = ROUND( PEDI.PreUni * PEDI.CanPed , 2 ).*/
  IF PEDI.AftIsc 
  THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
  IF PEDI.AftIgv 
  THEN  PEDI.ImpIgv = PEDI.ImpLin - ROUND(PEDI.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
  
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Imp-Total.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record B-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Enable-Head') .

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
  RUN Procesa-Handle IN lh_handle ('Enable-Head') .

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
  FOR EACH B-PEDI:
    F-FACTOR = B-PEDI.Factor.
    FIND Almmmatg WHERE 
         Almmmatg.CodCia = S-CODCIA AND  
         Almmmatg.codmat = B-PEDI.codmat 
         NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
       RUN Calculo-Precios.
       ASSIGN B-PEDI.PreBas = F-PreBas 
              B-PEDI.AftIgv = Almmmatg.AftIgv 
              B-PEDI.AftIsc = Almmmatg.AftIsc
              B-PEDI.PreUni = F-PREVTA
              B-PEDI.PorDto = F-DSCTOS
              /*B-PEDI.ImpDto = ROUND( B-PEDI.PreUni * (F-DSCTOS / 100) * B-PEDI.CanPed , 2).*/
              B-PEDI.ImpDto = ROUND( B-PEDI.PreBas * (F-DSCTOS / 100) * B-PEDI.CanPed , 2).
              B-PEDI.ImpLin = ROUND( B-PEDI.PreUni * B-PEDI.CanPed , 2 ).  /*- B-PEDI.ImpDto.*/
       IF B-PEDI.AftIsc THEN 
          B-PEDI.ImpIsc = ROUND(B-PEDI.PreBas * B-PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
       IF B-PEDI.AftIgv THEN  
          B-PEDI.ImpIgv = B-PEDI.ImpLin - ROUND(B-PEDI.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).

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
  {src/adm/template/snd-list.i "PEDI"}
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
  
  IF INTEGER(PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
    MESSAGE "Codigo de Articulo no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  IF DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
    MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  IF DECIMAL(PEDI.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
    MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  IF PEDI.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
    MESSAGE "Codigo de Unidad no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
    AND  Almmmatg.codmat = PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE "Codigo de articulo no existe" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
    AND  Almmmate.CodAlm = S-CODALM 
    AND  Almmmate.codmat = PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmate THEN DO:
    MESSAGE "Articulo no asignado al almacen " S-CODALM VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  FIND B-PEDI WHERE B-PEDI.CODCIA = S-CODCIA 
    AND  B-PEDI.CodMat = PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
    NO-LOCK NO-ERROR.
  IF AVAILABLE  B-PEDI AND ROWID(B-PEDI) <> ROWID(PEDI) THEN DO:
    MESSAGE "Codigo de Articulo repetido" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.

  /* RHC 26.09.05 MARGEN DE UTILIDAD */
  DEF VAR X-COSTO AS DEC NO-UNDO.
  DEF VAR X-MARGEN AS DEC NO-UNDO.
  DEF VAR X-LIMITE AS DE NO-UNDO.

  ASSIGN
    X-COSTO = 0
    X-MARGEN = 0.
  IF s-CodMon = 1 THEN DO:
    IF Almmmatg.MonVta = 1 
    THEN ASSIGN X-COSTO = (Almmmatg.Ctotot).
    ELSE ASSIGN X-COSTO = (Almmmatg.Ctotot) * s-Tpocmb .
  END.        
  IF s-CodMon = 2 THEN DO:
    IF Almmmatg.MonVta = 2 
    THEN ASSIGN X-COSTO = (Almmmatg.Ctotot).
    ELSE ASSIGN X-COSTO = (Almmmatg.Ctotot) / s-Tpocmb .
  END.      
  FIND TabGener WHERE Tabgener.codcia = s-codcia 
    AND Tabgener.clave = 'MML'
    AND Tabgener.codigo = Almmmatg.codfam NO-LOCK NO-ERROR.
  IF AVAILABLE TabGener THEN DO:
    X-MARGEN = DECIMAL(PEDI.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    X-MARGEN = ROUND( ((( X-MARGEN / X-COSTO ) - 1 ) * 100 ), 2 ).
    IF Almmmatg.chr__02 = 'P' 
    THEN X-LIMITE = TabGener.Parametro[2].
    ELSE X-LIMITE = TabGener.Parametro[1].
    IF X-MARGEN < X-LIMITE THEN DO:
        MESSAGE 'MARGEN DE UTILIDAD MUY BAJO' SKIP
            'El margen es de' x-Margen '%, no debe ser menor a' x-Limite '%'
            VIEW-AS ALERT-BOX WARNING.
        PEDI.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING( X-COSTO * (1 + X-LIMITE / 100) ).
        APPLY 'ENTRY':U TO PEDI.PreUni IN BROWSE {&BROWSE-NAME}.
        RETURN 'ADM-ERROR'.
    END.
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
  IF NOT AVAILABLE PEDI THEN RETURN "ADM-ERROR".
  IF PEDI.CanAte > 0 THEN DO:
    MESSAGE 'Este item no se puede modificar, ya tiene atenciones parciales'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
               AND  Almmmatg.codmat = PEDI.codmat 
              NO-LOCK NO-ERROR.
  ASSIGN
    S-UNDBAS = Almmmatg.UndBas
    F-FACTOR = PEDI.Factor
    I-NroItm = PEDI.NroItm.

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

