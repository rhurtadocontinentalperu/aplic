&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPedi FOR FacCPedi.
DEFINE BUFFER B-DPedi FOR FacDPedi.
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
&SCOPED-DEFINE precio-venta-general vta2/Precio-Utilex-Menor 
/*&SCOPED-DEFINE precio-venta-general pri/p-precio-utilex-contado.p*/

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM  AS CHAR.
DEFINE SHARED VARIABLE S-FMAPGO  AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB  AS DEC.
DEFINE SHARED VARIABLE S-CODIGV  AS INT.
DEFINE SHARED VARIABLE S-FLGSIT  AS CHAR.
DEFINE SHARED VARIABLE S-NROCOT  AS CHARACTER.
DEFINE SHARED VARIABLE S-NROPED  AS CHARACTER.
DEFINE SHARED VARIABLE pCodAlm AS CHAR.     /* ALMACEN POR DEFECTO */
DEFINE SHARED VARIABLE s-NroRef AS CHAR.    /* PPV */
DEFINE SHARED VARIABLE s-CodPro AS CHAR.
DEFINE SHARED VARIABLE s-NroVale AS CHAR.

DEFINE SHARED VARIABLE s-codbko AS CHAR.        /*Banco*/
DEFINE SHARED VARIABLE s-Tarjeta AS CHAR.       /*Tarjeta*/

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE I-NroItm AS INTE NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE S-UNDVTA AS CHAR NO-UNDO.
DEFINE VARIABLE X-TIPDTO AS CHAR NO-UNDO.

DEFINE BUFFER B-PEDI FOR PEDI.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/* PRODUCTOS POR ROTACION */
DEFINE SHARED VAR s-FlgRotacion LIKE gn-divi.flgrotacion.
DEFINE SHARED VAR s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE SHARED VAR s-VentaMinorista LIKE GN-DIVI.VentaMayorista.
DEFINE SHARED VAR s-Adm-New-Record AS CHAR.
DEFINE SHARED VAR s-FlgTipoVenta LIKE GN-DIVI.FlgPreVta.

DEFINE VAR s-registro-activo AS LOG INIT NO NO-UNDO.

DEFINE NEW SHARED VARIABLE output-var-4 LIKE FacDPedi.PreUni.
DEFINE NEW SHARED VARIABLE output-var-5 LIKE FacDPedi.PorDto.

DEFINE VARIABLE SW-LOG1  AS LOGI NO-UNDO.
DEFINE VARIABLE X-CODMAT AS CHAR NO-UNDO.

/* Articulo impuesto a las bolsas plasticas ICBPER */
DEFINE VAR x-articulo-ICBPER AS CHAR.
x-articulo-ICBPER = "099268".

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
Almmmatg.DesMat Almmmatg.DesMar PEDI.AlmDes PEDI.UndVta PEDI.CanPed ~
PEDI.PreUni PEDI.PorDto PEDI.Por_Dsctos[1] PEDI.Por_Dsctos[2] ~
PEDI.Por_Dsctos[3] PEDI.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table PEDI.codmat 
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
&Scoped-Define ENABLED-OBJECTS br_table RECT-11 RECT-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje 

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
DEFINE VARIABLE F-ImpDes AS DECIMAL FORMAT "-ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpDto2 AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
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

DEFINE VARIABLE F-ImpTot-D AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1.08
     BGCOLOR 0 FGCOLOR 14 FONT 8 NO-UNDO.

DEFINE VARIABLE F-ImpTot-S AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1.08
     BGCOLOR 0 FGCOLOR 14 FONT 8 NO-UNDO.

DEFINE VARIABLE F-TotBrt AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ValVta AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 141 BY 2.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 141 BY 1.85
     BGCOLOR 0 FGCOLOR 15 .

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
      PEDI.NroItm COLUMN-LABEL "No" FORMAT ">>>9":U
      PEDI.codmat COLUMN-LABEL "Articulo" FORMAT "X(14)":U
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 50.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(12)":U
      PEDI.AlmDes COLUMN-LABEL "Alm.!Desp." FORMAT "x(3)":U WIDTH 5.29
      PEDI.UndVta COLUMN-LABEL "Unidad" FORMAT "x(10)":U WIDTH 5.29
      PEDI.CanPed FORMAT ">>>,>>9.99":U
      PEDI.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT ">>,>>9.9999":U
            WIDTH 6.29
      PEDI.PorDto COLUMN-LABEL "% Dscto.!Incluido" FORMAT "->>9.99":U
      PEDI.Por_Dsctos[1] COLUMN-LABEL "% Dscto!Manual" FORMAT "->>9.99":U
      PEDI.Por_Dsctos[2] COLUMN-LABEL "% Dscto!Evento" FORMAT "->>9.99":U
      PEDI.Por_Dsctos[3] COLUMN-LABEL "% Dscto!Vol/Prom" FORMAT "->>9.99":U
      PEDI.ImpLin FORMAT ">,>>>,>>9.99":U
  ENABLE
      PEDI.codmat
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 141 BY 9.81
         BGCOLOR 15 FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-Mensaje AT ROW 10.96 COL 2 NO-LABEL WIDGET-ID 58
     F-ImpDto2 AT ROW 12.31 COL 92 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     F-TotBrt AT ROW 12.35 COL 19 NO-LABEL
     F-ImpExo AT ROW 12.35 COL 31 NO-LABEL
     F-ValVta AT ROW 12.35 COL 53.14 COLON-ALIGNED NO-LABEL
     F-ImpIsc AT ROW 12.35 COL 65.86 COLON-ALIGNED NO-LABEL
     F-ImpIgv AT ROW 12.35 COL 78.43 COLON-ALIGNED NO-LABEL
     F-ImpTot AT ROW 12.35 COL 108 COLON-ALIGNED NO-LABEL
     F-ImpDes AT ROW 12.38 COL 41 COLON-ALIGNED NO-LABEL
     F-ImpTot-S AT ROW 13.81 COL 104.43 RIGHT-ALIGNED NO-LABEL WIDGET-ID 8
     F-ImpTot-D AT ROW 13.81 COL 111 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     "   $" VIEW-AS TEXT
          SIZE 5 BY 1.35 AT ROW 13.69 COL 107 WIDGET-ID 52
          BGCOLOR 0 FGCOLOR 15 FONT 30
     "TOTAL A PAGAR" VIEW-AS TEXT
          SIZE 27 BY 1.35 AT ROW 13.65 COL 54 WIDGET-ID 50
          BGCOLOR 0 FGCOLOR 11 FONT 30
     "Otros Dctos" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 11.77 COL 94 WIDGET-ID 62
     "Total Importe" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 11.77 COL 110.14
     " S/." VIEW-AS TEXT
          SIZE 4 BY 1.35 AT ROW 13.69 COL 83 WIDGET-ID 6
          BGCOLOR 0 FGCOLOR 15 FONT 30
     "T.Exonerado" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 11.77 COL 31.43
     "I.G.V." VIEW-AS TEXT
          SIZE 5.14 BY .5 AT ROW 11.77 COL 83.14
     "I.S.C." VIEW-AS TEXT
          SIZE 4.57 BY .5 AT ROW 11.77 COL 71.57
     "Total Bruto" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 11.77 COL 20.86
     "Valor Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 11.81 COL 56.86
     "T.Descuento" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 11.81 COL 43.57
     RECT-11 AT ROW 10.81 COL 1
     RECT-3 AT ROW 13.38 COL 1 WIDGET-ID 56
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
   Temp-Tables and Buffers:
      TABLE: B-CPedi B "?" ? INTEGRAL FacCPedi
      TABLE: B-DPedi B "?" ? INTEGRAL FacDPedi
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
         HEIGHT             = 14.23
         WIDTH              = 142.43.
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
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       F-ImpDes:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN F-ImpDto2 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       F-ImpDto2:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN F-ImpExo IN FRAME F-Main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       F-ImpExo:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN F-ImpIgv IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       F-ImpIgv:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN F-ImpIsc IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       F-ImpIsc:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN F-ImpTot IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       F-ImpTot:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN F-ImpTot-D IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       F-ImpTot-D:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN F-ImpTot-S IN FRAME F-Main
   NO-DISPLAY NO-ENABLE ALIGN-R                                         */
ASSIGN 
       F-ImpTot-S:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN F-TotBrt IN FRAME F-Main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       F-TotBrt:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN F-ValVta IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       F-ValVta:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
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
"PEDI.NroItm" "No" ">>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.PEDI.codmat
"PEDI.codmat" "Articulo" "X(14)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "50.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.PEDI.AlmDes
"PEDI.AlmDes" "Alm.!Desp." ? "character" ? ? ? ? ? ? no ? no no "5.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.PEDI.UndVta
"PEDI.UndVta" "Unidad" "x(10)" "character" ? ? ? ? ? ? no ? no no "5.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.PEDI.CanPed
"PEDI.CanPed" ? ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.PEDI.PreUni
"PEDI.PreUni" "Precio!Unitario" ">>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "6.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.PEDI.PorDto
"PEDI.PorDto" "% Dscto.!Incluido" "->>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.PEDI.Por_Dsctos[1]
"PEDI.Por_Dsctos[1]" "% Dscto!Manual" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.PEDI.Por_Dsctos[2]
"PEDI.Por_Dsctos[2]" "% Dscto!Evento" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.PEDI.Por_Dsctos[3]
"PEDI.Por_Dsctos[3]" "% Dscto!Vol/Prom" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.PEDI.ImpLin
"PEDI.ImpLin" ? ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
  DISPLAY I-NroItm @ PEDI.NroItm WITH BROWSE {&BROWSE-NAME}.
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
ON F11 OF PEDI.codmat IN BROWSE br_table /* Articulo */
DO:
    RUN vtamin/D-VTAAUT5(OUTPUT x-codmat, OUTPUT x-canped).
    IF X-CODMAT <> ? AND X-CANPED > 0 THEN DO:
        DISPLAY x-codmat @ PEDI.Codmat WITH BROWSE {&BROWSE-NAME}.
        APPLY "RETURN" TO PEDI.CodMat IN BROWSE {&BROWSE-NAME}.   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI.codmat br_table _BROWSE-COLUMN B-table-Win
ON F12 OF PEDI.codmat IN BROWSE br_table /* Articulo */
DO:
    IF s-CodDoc <> 'P/M' THEN RETURN NO-APPLY.

  RUN vtamin/d-captura-ppv.
  s-registro-activo = NO.
  RUN dispatch IN THIS-PROCEDURE ('disable-fields').
  RUN dispatch IN THIS-PROCEDURE ('cancel-record').
  RUN dispatch IN THIS-PROCEDURE ('open-query').
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDI.codmat IN BROWSE br_table /* Articulo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    DEF VAR pCanPed LIKE PEDI.canped.

    ASSIGN 
        F-CanPed = 1
        pCodMat = SELF:SCREEN-VALUE.

    RUN alm/p-codbrr (INPUT-OUTPUT pCodMat, INPUT-OUTPUT pCanPed, s-codcia).

    IF pCodMat = '' THEN RETURN.    /* NO-APPLY.*/
    ASSIGN
        SELF:SCREEN-VALUE = pCodMat
        f-CanPed = pCanPed.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK.
    IF Almmmatg.Chr__01 = "" THEN DO:
       MESSAGE "Articulo no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    z-Dsctos = 0.
    y-Dsctos = 0.
    IF x-CanPed > 0 AND X-CanPed <> F-CanPed THEN F-CanPed = X-CanPed.
    RUN {&precio-venta-general} (s-CodDiv,
                                   s-CodMon,
                                   s-TpoCmb,
                                   OUTPUT s-UndVta,
                                   OUTPUT f-Factor,
                                   Almmmatg.CodMat,
                                   f-CanPed,
                                   4,
                                   s-flgsit,       /* s-codbko, */
                                   s-codbko,
                                   s-tarjeta,
                                   s-codpro,
                                   s-NroVale,
                                   OUTPUT f-PreBas,
                                   OUTPUT f-PreVta,
                                   OUTPUT f-Dsctos,
                                   OUTPUT y-Dsctos,
                                   OUTPUT z-Dsctos,
                                   OUTPUT x-TipDto ).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        RETURN NO-APPLY.
    END.
    DISPLAY 
        Almmmatg.DesMat @ Almmmatg.DesMat 
        Almmmatg.DesMar @ Almmmatg.DesMar 
        f-CanPed @ PEDI.CanPed
        s-UndVta @ PEDI.UndVta 
        F-DSCTOS @ PEDI.PorDto
        F-PREVTA @ PEDI.PreUni 
        z-Dsctos @ PEDI.Por_Dsctos[2]
        y-Dsctos @ PEDI.Por_Dsctos[3]
        WITH BROWSE {&BROWSE-NAME}.
    IF PEDI.AlmDes:SCREEN-VALUE IN BROWSE {&browse-name} = ''
        THEN PEDI.AlmDes:SCREEN-VALUE IN BROWSE {&browse-name} = ENTRY(1, s-codalm).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PEDI.AlmDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI.AlmDes br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF PEDI.AlmDes IN BROWSE br_table /* Alm.!Desp. */
DO:
    IF s-registro-activo = NO THEN RETURN.
    IF SELF:SCREEN-VALUE = '' THEN SELF:SCREEN-VALUE = ENTRY(1, s-codalm).
    /****    Selecciona las unidades de medida   ****/
    RUN vtagn/c-uniabc ("Unidades de Venta",
                        PEDI.codmat:SCREEN-VALUE IN BROWSE {&browse-name},
                        SELF:SCREEN-VALUE
                        ).
    IF output-var-2 = ? THEN DO:
        APPLY 'ENTRY':U TO PEDI.codmat IN BROWSE {&BROWSE-NAME}.
        RETURN NO-APPLY.
    END.
    FIND Almtconv WHERE 
         Almtconv.CodUnid = Almmmatg.UndBas AND  
         Almtconv.Codalter = output-var-2 
         NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN  F-FACTOR = Almtconv.Equival.
    ELSE DO:
         MESSAGE "Equivalencia no Registrado"
                 VIEW-AS ALERT-BOX.
         APPLY "ENTRY" TO PEDI.CodMat IN BROWSE {&BROWSE-NAME}.
         RETURN NO-APPLY.
    END.
    /************************************************/
    ASSIGN 
        X-CANPED = 1
        F-PreBas = output-var-4
        F-PreVta = output-var-4
        F-Dsctos = ABSOLUTE(output-var-5)
        Y-Dsctos = 0.
    DISPLAY Almmmatg.DesMat @ Almmmatg.DesMat 
            Almmmatg.DesMar @ Almmmatg.DesMar 
            output-var-2 @ PEDI.UndVta
            F-DSCTOS @ PEDI.PorDto
            F-PREVTA @ PEDI.PreUni 
            WITH BROWSE {&BROWSE-NAME}.
    IF PEDI.AlmDes:SCREEN-VALUE IN BROWSE {&browse-name} = ''
        THEN PEDI.AlmDes:SCREEN-VALUE IN BROWSE {&browse-name} = ENTRY(1, s-codalm).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI.AlmDes br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDI.AlmDes IN BROWSE br_table /* Alm.!Desp. */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND Almacen WHERE Almacen.CodCia = S-CodCia 
        AND Almacen.CodAlm = PEDI.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN DO:
       MESSAGE "Almacen no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO PEDI.AlmDes IN BROWSE {&BROWSE-NAME}.
       RETURN NO-APPLY.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI.AlmDes br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF PEDI.AlmDes IN BROWSE br_table /* Alm.!Desp. */
OR F8 OF PEDI.AlmDes
DO:
  ASSIGN
      input-var-1 = s-codalm
      input-var-2 = s-coddiv
      input-var-3 = ''.
  RUN vtagn/c-vtaalmdiv-01 ('Almacenes de Despacho').
  IF output-var-1 <> ? THEN DO:
      SELF:SCREEN-VALUE = output-var-2.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF PEDI.CanPed, PEDI.codmat, PEDI.PreUni , PEDI.AlmDes
DO:
    APPLY 'TAB':U.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Pedido-Vitrina B-table-Win 
PROCEDURE Carga-Pedido-Vitrina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroPed AS CHAR.

FIND B-CPEDI WHERE B-CPEDI.codcia = s-codcia
    AND B-CPEDI.coddoc = pCodDoc
    AND B-CPEDI.nroped = pNroPed
    NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN DO:
    MESSAGE 'Pedido de Vitrina NO válido' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
FOR EACH B-DPEDI OF B-CPEDI:
    CREATE PEDI.
    BUFFER-COPY B-DPEDI TO PEDI.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Clave-Supervisor B-table-Win 
PROCEDURE Clave-Supervisor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE x-clave AS CHARACTER FORMAT "x(20)" LABEL "Clave" NO-UNDO.

FIND FIRST VtaSupCja WHERE Vtasupcja.codcia = s-codcia
    AND Vtasupcja.coddiv = s-coddiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE Vtasupcja THEN DO:
    MESSAGE 'NO están configuradas las claves de los supervisores'
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
PASSWORD:
DO:
    DO ON ERROR UNDO, RETURN "ADM-ERROR" ON ENDKEY UNDO, RETURN "ADM-ERROR":
        x-clave = "".
        UPDATE
            SKIP(.5)
            SPACE(2)
            x-clave PASSWORD-FIELD
            SPACE(2)
            SKIP(.5)
            WITH CENTERED VIEW-AS DIALOG-BOX THREE-D
            SIDE-LABEL TITLE "Ingrese Clave".
        FOR EACH VtaSupCja WHERE Vtasupcja.codcia = s-codcia
            AND Vtasupcja.coddiv = s-coddiv:
            IF COMPARE ( Vtasupcja.clave, "=", x-clave, "CASE-SENSITIVE" ) THEN RETURN "OK".
        END.
        MESSAGE
            "CLAVE INCORRECTA"
            VIEW-AS ALERT-BOX ERROR.
    END.
END.
RETURN "ADM-ERROR".

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
  DEFINE VARIABLE dTpoCmbCom AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE dTpoCmbVta AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE x-Dto2xExonerados AS DEC NO-UNDO.
  DEFINE VARIABLE x-Dto2xAfectosIgv AS DEC NO-UNDO.

    /*Busca Tipo de Cambio*/
  FIND LAST Gn-tccja WHERE
      Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-TcCja THEN DO:
      dTpoCmbCom = Gn-Tccja.Compra.
      dTpoCmbVta = Gn-Tccja.Venta.
  END.
  ELSE DO:
      dTpoCmbCom = 0.
      dTpoCmbVta = 0.
  END.

  ASSIGN 
    F-ImpDes = 0
    F-ImpExo = 0
    F-ImpIgv = 0
    F-ImpIsc = 0
    F-ImpTot = 0
    F-ImpDto2 = 0
    F-TotBrt = 0
    F-ValVta = 0
    F-ImpTot-S = 0
    F-ImpTot-D = 0.
  FOR EACH B-PEDI:
    F-ImpDto2 = F-ImpDto2 + B-PEDI.ImpDto2.
    F-ImpTot = F-ImpTot + B-PEDI.ImpLin.
    F-ImpTot-S = F-ImpTot .
    F-ImpTot-D = (F-ImpTot / dTpoCmbCom).
    F-Igv = F-Igv + B-PEDI.ImpIgv.
    F-Isc = F-Isc + B-PEDI.ImpIsc.
    IF NOT B-PEDI.AftIgv THEN F-ImpExo = F-ImpExo + B-PEDI.ImpLin.
    IF B-PEDI.AftIgv = YES
    THEN f-ImpDes = f-ImpDes + ROUND(B-PEDI.ImpDto / (1 + FacCfgGn.PorIgv / 100), 2).
    ELSE f-ImpDes = f-ImpDes + B-PEDI.ImpDto.
      IF NOT B-PEDI.AftIgv THEN x-Dto2xExonerados = x-Dto2xExonerados + B-PEDI.ImpDto2.
      ELSE x-Dto2xAfectosIgv = x-Dto2xAfectosIgv + B-PEDI.ImpDto2.
  END.
  F-ImpIgv = ROUND(F-Igv,2).
  F-ImpIsc = ROUND(F-Isc,2).
/*   IF f-ImpDto2 > 0 THEN DO:                                                                             */
/*       f-ImpTot = f-ImpTot - f-ImpDto2.                                                                  */
/*       f-ImpTot-S = f-ImpTot.                                                                            */
/*       f-ImpIgv = f-ImpIgv - ROUND (f-ImpDto2 / (1 + Faccfggn.PorIgv / 100) * Faccfggn.PorIgv / 100, 2). */
/*   END.                                                                                                  */
  F-ValVta = F-ImpTot - F-ImpExo - F-ImpIgv.
  F-TotBrt = F-ValVta + F-ImpIsc + F-ImpDes + F-ImpExo.

  /* RHC 06/05/2014 En caso tenga descuento por Encarte */
  IF f-ImpDto2 > 0 THEN DO:
      ASSIGN
          f-ImpTot = f-ImpTot - f-ImpDto2
          f-ImpIgv = f-ImpIgv -  ~
          ROUND(x-Dto2xAfectosIgv / ( 1 + Faccfggn.PorIgv / 100) * Faccfggn.PorIgv / 100, 2)
          f-ImpExo = f-ImpExo - x-Dto2xExonerados
          f-ValVta = f-ImpTot - f-ImpExo - f-ImpIgv.
  END.

  DISPLAY F-ImpDes
        F-ImpExo
        F-ImpIgv
        F-ImpIsc
        F-ImpTot
        F-ImpDto2
        F-TotBrt
        F-Imptot-S
        F-ImpTot-D
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
  IF s-FlgSit = "KC" AND s-CodPro = '10003814' AND s-NroVale = "" THEN DO:
      MESSAGE 'Debe registrar primero un vale de muestra' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  
  I-NroItm = 0.  
  DEFINE VARIABLE N-ITMS AS INTEGER INIT 0 NO-UNDO.
  FOR EACH B-PEDI BY B-PEDI.NroItm:
      N-ITMS = N-ITMS + 1.
      I-NroItm = B-PEDI.NroItm.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  I-NroItm = I-NroItm + 1.
  RUN Procesa-Handle IN lh_handle ('Disable-Head').
  s-registro-activo = YES.
  /*x-CanPed = 1.*/
  x-CanPed = 0.
  APPLY 'ENTRY':U TO PEDI.codmat IN BROWSE {&browse-name}.
  
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
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
      AND Almmmatg.codmat = PEDI.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
      NO-LOCK NO-ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN 
    PEDI.CodCia = S-CODCIA
    PEDI.Factor = F-FACTOR
    PEDI.NroItm = I-NroItm
    PEDI.AlmDes = ENTRY(1, s-codalm).
         
  ASSIGN 
    PEDI.UndVta = PEDI.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    PEDI.CanPed = DEC(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDI.PreUni = DEC(PEDI.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDI.PorDto = DEC(PEDI.PorDto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDI.PreBas = F-PreBas 
    PEDI.Por_DSCTOS[2] = DEC(PEDI.Por_Dsctos[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDI.Por_Dsctos[3] = DEC(PEDI.Por_Dsctos[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDI.AftIgv = ( IF s-CodIgv = 1 THEN Almmmatg.AftIgv ELSE NO )
    PEDI.AftIsc = Almmmatg.AftIsc
    PEDI.Libre_c04 = X-TIPDTO.

/*   {vta2/utilex-descuento-por-encarte.i &Tabla="PEDI"} */

  ASSIGN
      PEDI.ImpLin = PEDI.CanPed * PEDI.PreUni * 
                    ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                    ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                    ( 1 - PEDI.Por_Dsctos[3] / 100 )
      PEDI.ImpDto2 = ROUND ( PEDI.ImpLin * PEDI.PorDto2 / 100, 2).
  IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
      THEN PEDI.ImpDto = 0.
  ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
  ASSIGN
      PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
      PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
  IF PEDI.AftIsc 
  THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
  IF PEDI.AftIgv 
  THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (FacCfgGn.PorIgv / 100) ), 4 ).

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
  s-registro-activo = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Enable-Head').

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
/*   IF s-CodDoc = "P/M" THEN DO:                               */
/*       RUN Clave-Supervisor.                                  */
/*       IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". */
/*   END.                                                       */

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
  DO WITH FRAME {&FRAME-NAME}:
      CASE s-CodDoc:
          WHEN 'P/M' THEN FILL-IN-Mensaje:SCREEN-VALUE = "F11 => Para Cantidades Mayor a 1   F12 => Pre-Pedidos de Vitrina".
          WHEN 'PPV' THEN FILL-IN-Mensaje:SCREEN-VALUE = "F11 => Para Cantidades Mayor a 1   F12 => Pre-Pedidos de Vitrina".
      END CASE.
  END.

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
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Imp-Total.
  RUN Procesa-Handle IN lh_handle ('Enable-Head').
  s-registro-activo = NO.

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

  DEFINE VARIABLE s-StkComprometido AS DECIMAL     NO-UNDO.
  
  IF PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''
    OR INTEGER(PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Codigo de Articulo no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI.CodMat.
       RETURN "ADM-ERROR".
  END.
  /* ARTICULO */
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
    AND  Almmmatg.codmat = PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE "Codigo de articulo no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO PEDI.CodMat.
        RETURN "ADM-ERROR".
  END.

  IF PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = x-articulo-ICBPER THEN DO:
      MESSAGE 'Código de producto pertenece a IMPUESTO A LAS BOLSAS PLASTICAS' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO PEDI.CodMat.
      RETURN "ADM-ERROR".
  END.

  IF NOT (Almmmatg.TpoArt <= s-FlgRotacion) THEN DO:
      MESSAGE "Articulo no autorizado para venderse" VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO PEDI.CodMat.
      RETURN "ADM-ERROR".
  END.
  FIND Almtfami OF Almmmatg NO-LOCK NO-ERROR.
  IF AVAILABLE Almtfami AND Almtfami.SwComercial = NO THEN DO:
      MESSAGE 'El producto pertenece a una familia NO autorizada para ventas'
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO PEDI.CodMat.
      RETURN 'ADM-ERROR'.
  END.
  FIND Almsfami OF Almmmatg NO-LOCK NO-ERROR.
  IF AVAILABLE Almsfami AND AlmSFami.SwDigesa = YES 
      AND (Almmmatg.VtoDigesa = ? OR Almmmatg.VtoDigesa < TODAY) THEN DO:
      MESSAGE 'La fecha de DIGESA ya venció o no se ha registrado su vencimiento'
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO PEDI.CodMat.
      RETURN 'ADM-ERROR'.
  END.
  /* RHC 21/08/2012 CONTROL POR TIPO DE PRODUCTO */
  IF Almmmatg.TpoMrg = "1" AND s-FlgTipoVenta = NO THEN DO:
      MESSAGE "No se puede vender este producto al por menor"
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO PEDI.CodMat.
      RETURN 'ADM-ERROR'.
  END.
  IF Almmmatg.TpoMrg = "2" AND s-FlgTipoVenta = YES THEN DO:
      MESSAGE "No se puede vender este producto al por mayor"
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO PEDI.CodMat.
      RETURN 'ADM-ERROR'.
  END.
  /* ********************************************* */

  /* 08.09.09 Almacenes de despacho */
  IF LOOKUP(PEDI.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}, s-CodAlm) = 0 THEN DO:
      MESSAGE 'Almacen NO AUTORIZADO para ventas' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO PEDI.CodMat.
      RETURN "ADM-ERROR".
  END.

  FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
      AND  Almmmate.CodAlm = PEDI.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND  Almmmate.codmat = PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmate THEN DO:
       MESSAGE "Articulo no asignado al almacen " PEDI.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI.CodMat.
       RETURN "ADM-ERROR".
  END.
  /* CANTIDAD */
  IF DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI.CodMat.
       RETURN "ADM-ERROR".
  END.
  /* *********************************************************************************** */
  /* UNIDAD */
  /* *********************************************************************************** */
/*   DEFINE VAR pCanPed AS DEC NO-UNDO.                                                       */
/*   DEFINE VAR pMensaje AS CHAR NO-UNDO.                                                     */
/*   DEFINE VAR hProc AS HANDLE NO-UNDO.                                                      */
/*                                                                                            */
/*   RUN vtagn/ventas-library PERSISTENT SET hProc.                                           */
/*                                                                                            */
/*   pCanPed = DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).                    */
/*   RUN VTA_Valida-Cantidad IN hProc (INPUT Almmmatg.CodMat,                                 */
/*                                   INPUT PEDI.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}, */
/*                                   INPUT-OUTPUT pCanPed,                                    */
/*                                   OUTPUT pMensaje).                                        */
/*   IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                                   */
/*       MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.                                            */
/*       PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pCanPed).                 */
/*       APPLY 'ENTRY':U TO PEDI.CanPed.                                                      */
/*       RETURN "ADM-ERROR".                                                                  */
/*   END.                                                                                     */

  /* EMPAQUE */
/*   DEF VAR f-Canped AS DEC NO-UNDO.                                                                          */
/*   IF s-FlgEmpaque = YES THEN DO:                                                                            */
/*       IF s-VentaMinorista = 2 THEN DO:  /* LISTA POR DIVISION */                                            */
/*           FIND FIRST VtaListaMin OF Almmmatg WHERE Vtalistamin.coddiv = s-coddiv NO-LOCK NO-ERROR.          */
/*           IF AVAILABLE VtaListaMin AND Vtalistamin.CanEmp > 0 THEN DO:                                      */
/*               f-CanPed = DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.             */
/*               f-CanPed = (TRUNCATE((f-CanPed / Vtalistamin.CanEmp),0) * Vtalistamin.CanEmp).                */
/*               IF f-CanPed <> DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor THEN DO: */
/*                   MESSAGE 'Solo puede vender en empaques de' Vtalistamin.CanEmp Almmmatg.UndBas             */
/*                       VIEW-AS ALERT-BOX ERROR.                                                              */
/*                   APPLY 'ENTRY':U TO PEDI.CodMat.                                                           */
/*                   RETURN "ADM-ERROR".                                                                       */
/*               END.                                                                                          */
/*           END.                                                                                              */
/*       END.                                                                                                  */
/*       ELSE DO:      /* LISTA GENERAL */                                                                     */
/*           IF Almmmatg.DEC__03 > 0 THEN DO:                                                                  */
/*               f-CanPed = DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.             */
/*               f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).                    */
/*               IF f-CanPed <> DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor THEN DO: */
/*                   MESSAGE 'Solo puede vender en empaques de' Almmmatg.DEC__03 Almmmatg.UndBas               */
/*                       VIEW-AS ALERT-BOX ERROR.                                                              */
/*                   APPLY 'ENTRY':U TO PEDI.CodMat.                                                           */
/*                   RETURN "ADM-ERROR".                                                                       */
/*               END.                                                                                          */
/*           END.                                                                                              */
/*       END.                                                                                                  */
/*   END.                                                                                                      */
/*   /* MINIMO DE VENTA */                                                                                     */
/*   IF s-FlgMinVenta = YES /*AND Almmmatg.DEC__03 > 0*/ THEN DO:                                              */
/*       f-CanPed = DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.                     */
/*       IF s-VentaMinorista = 2 THEN DO:  /* LISTA POR DIVISION */                                            */
/*           FIND FIRST VtaListaMin OF Almmmatg WHERE Vtalistamin.coddiv = s-coddiv NO-LOCK NO-ERROR.          */
/*           IF AVAILABLE VtaListaMin AND Vtalistamin.CanEmp > 0 THEN DO:                                      */
/*               IF f-CanPed < Vtalistamin.CanEmp THEN DO:                                                     */
/*                   MESSAGE 'Solo puede vender como mínimo' Vtalistamin.CanEmp Almmmatg.UndBas                */
/*                       VIEW-AS ALERT-BOX ERROR.                                                              */
/*                   APPLY 'ENTRY':U TO PEDI.CodMat.                                                           */
/*                   RETURN "ADM-ERROR".                                                                       */
/*               END.                                                                                          */
/*           END.                                                                                              */
/*       END.                                                                                                  */
/*       ELSE DO:      /* LISTA GENERAL */                                                                     */
/*           IF Almmmatg.DEC__03 > 0 THEN DO:                                                                  */
/*               IF f-CanPed < Almmmatg.DEC__03 THEN DO:                                                       */
/*                   MESSAGE 'Solo puede vender como mínimo' Almmmatg.DEC__03 Almmmatg.UndBas                  */
/*                       VIEW-AS ALERT-BOX ERROR.                                                              */
/*                   APPLY 'ENTRY':U TO PEDI.CodMat.                                                           */
/*                   RETURN "ADM-ERROR".                                                                       */
/*               END.                                                                                          */
/*           END.                                                                                              */
/*       END.                                                                                                  */
/*   END.                                                                                                      */

  /* PRECIO UNITARIO */
  IF DECIMAL(PEDI.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI.CodMat.
       RETURN "ADM-ERROR".
  END.
  IF PEDI.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
       MESSAGE "Codigo de Unidad no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI.CodMat.
       RETURN "ADM-ERROR".
  END.

  /* CONSISTENCIA DE STOCK */
/*   RUN gn/Stock-Comprometido (PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},                                  */
/*                              PEDI.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},                                  */
/*                              OUTPUT s-StkComprometido).                                                          */
/*   IF DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > (Almmmate.StkAct - s-StkComprometido) THEN DO: */
/*       MESSAGE "No hay STOCK disponible en el almacen" PEDI.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} SKIP(1)  */
/*               "     STOCK ACTUAL : " almmmate.StkAct SKIP (1)                                                    */
/*               /*"     COMPROMETIDO : " s-StkComprometido  SKIP(1)*/                                              */
/*               " Continuamos con la grabacion?"                                                                   */
/*               VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO                                                           */
/*               UPDATE rpta AS LOG.                                                                                */
/*       IF rpta = NO THEN RETURN "ADM-ERROR".                                                                      */
/*   END.                                                                                                           */
  /* ********************* */

  /* *********************************************************************************** */
  /* RHC 13.12.2010 Margen de Utilidad */
  /* *********************************************************************************** */
  DEF VAR pError AS CHAR NO-UNDO.
  DEF VAR X-MARGEN AS DEC NO-UNDO.
  DEF VAR X-LIMITE AS DEC NO-UNDO.
  DEF VAR x-PreUni AS DEC NO-UNDO.

  x-PreUni = DECIMAL ( PEDI.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) *
      ( 1 - DECIMAL (PEDI.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) / 100 ) *
      ( 1 - DECIMAL (PEDI.Por_Dsctos[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} )/ 100 ) *
      ( 1 - DECIMAL (PEDI.Por_Dsctos[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) / 100 ) .
  RUN vtagn/p-margen-utilidad (
      PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},      /* Producto */
      x-PreUni,  /* Precio de venta unitario */
      PEDI.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
      s-CodMon,       /* Moneda de venta */
      s-TpoCmb,       /* Tipo de cambio */
      YES,            /* Muestra el error */
      "",
      OUTPUT x-Margen,        /* Margen de utilidad */
      OUTPUT x-Limite,        /* Margen mínimo de utilidad */
      OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
      ).
  IF pError = "ADM-ERROR" THEN DO:
      APPLY 'ENTRY':U TO PEDI.CodMat.
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
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

