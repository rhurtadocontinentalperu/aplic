&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE BUFFER MATG FOR Almmmatg.
DEFINE VARIABLE F-CODMAR AS CHAR INIT "" NO-UNDO.
DEFINE VARIABLE X-Mon AS CHAR NO-UNDO.
DEFINE VARIABLE F-CTOPRM AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PreVta AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-MrgUti AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-MrgCom AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PorImp AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PreSol AS DECIMAL NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.


/* Definimos Variables de impresoras */
DEFINE VARIABLE s-printer-list AS CHAR NO-UNDO.
DEFINE VARIABLE s-port-list AS CHAR NO-UNDO.
DEFINE VARIABLE s-port-name AS CHAR format "x(20)" NO-UNDO.
DEFINE VARIABLE s-printer-count AS INTEGER NO-UNDO.

DEFINE NEW SHARED VARIABLE s-pagina-final     AS INTEGER.
DEFINE NEW SHARED VARIABLE s-pagina-inicial   AS INTEGER.
DEFINE NEW SHARED VARIABLE s-salida-impresion AS INTEGER.
DEFINE NEW SHARED VARIABLE s-printer-name     AS CHARACTER.
DEFINE NEW SHARED VARIABLE s-print-file       AS CHARACTER.
DEFINE NEW SHARED VARIABLE s-nro-copias       AS INTEGER.
DEFINE NEW SHARED VARIABLE s-orientacion      AS INTEGER.
DEFINE STREAM REPORT.

/* Preprocesadores para cada campo filtro */
&SCOPED-DEFINE FILTRO1 ( (Almmmatg.FchmPre[2] >= F-FchDes) AND (Almmmatg.FchmPre[2] <= F-FchHas) )

DEFINE IMAGE IMAGE-1 FILENAME "IMG\TIME" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6 SKIP
     Fi-Mensaje NO-LABEL FONT 6  SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

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
&Scoped-define INTERNAL-TABLES Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almmmatg.codmat Almmmatg.DesMat ~
Almmmatg.DesMar Almmmatg.UndStk X-Mon @ X-Mon Almmmatg.CtoTot ~
Almmmatg.TpoMrg Almmmatg.MrgUti Almmmatg.PreBas Almmmatg.Prevta[1] ~
F-PRESOL @ F-PRESOL Almmmatg.PorMax Almmmatg.PorVta[1] Almmmatg.PorVta[2] ~
Almmmatg.PorVta[3] Almmmatg.FchPrmD Almmmatg.FchPrmH Almmmatg.CtoLis ~
F-MRGCOM @ F-MRGCOM F-CTOPRM @ F-CTOPRM 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table Almmmatg.TpoMrg ~
Almmmatg.MrgUti Almmmatg.PreBas Almmmatg.PorMax Almmmatg.PorVta[3] ~
Almmmatg.FchPrmD Almmmatg.FchPrmH 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}TpoMrg ~{&FP2}TpoMrg ~{&FP3}~
 ~{&FP1}MrgUti ~{&FP2}MrgUti ~{&FP3}~
 ~{&FP1}PreBas ~{&FP2}PreBas ~{&FP3}~
 ~{&FP1}PorMax ~{&FP2}PorMax ~{&FP3}~
 ~{&FP1}PorVta[3] ~{&FP2}PorVta[3] ~{&FP3}~
 ~{&FP1}FchPrmD ~{&FP2}FchPrmD ~{&FP3}~
 ~{&FP1}FchPrmH ~{&FP2}FchPrmH ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table Almmmatg
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almmmatg WHERE ~{&KEY-PHRASE} ~
      AND Almmmatg.CodCia = S-CODCIA ~
 AND Almmmatg.DesMat BEGINS F-Filtro ~
 AND Almmmatg.CodMar BEGINS F-CodMar ~
 AND Almmmatg.CodPr1 BEGINS F-Provee NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-19 Btn-Procesa CB-TpoMar F-Filtro ~
F-Marca F-CodMat F-Provee F-PorUti F-FchDes F-FchHas CB-FchMod br_table 
&Scoped-Define DISPLAYED-OBJECTS CB-TpoMar F-Filtro F-Marca F-CodMat ~
F-Provee F-DctoMax F-DctoDis F-DctoMay F-DctoPro F-PorUti F-MargPub ~
F-FchDes F-FchHas CB-FchMod 

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
Fechas|y||integral.Almmmatg.DesMat
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "Fechas",
     Keys-Supplied = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
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
Codigo|y||integral.Almmmatg.CodCia|yes,integral.Almmmatg.codmat|yes
Descripcion|||integral.Almmmatg.CodCia|yes,integral.Almmmatg.DesMat|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "Codigo,Descripcion",
     Sort-Case = Codigo':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/* This SmartObject is a valid SortBy-Target. */
&IF '{&user-supported-links}':U ne '':U &THEN
  &Scoped-define user-supported-links {&user-supported-links},SortBy-Target
&ELSE
  &Scoped-define user-supported-links SortBy-Target
&ENDIF

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-Procesa 
     LABEL "Procesar" 
     SIZE 7.72 BY .85.

DEFINE VARIABLE CB-FchMod AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Filtrar" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Todas","Ultimas Modificaciones" 
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE CB-TpoMar AS CHARACTER FORMAT "X(1)":U 
     LABEL "Tipo Margen" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "","M","V" 
     SIZE 5.72 BY 1 NO-UNDO.

DEFINE VARIABLE F-CodMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .69 NO-UNDO.

DEFINE VARIABLE F-DctoDis AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-DctoMax AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-DctoMay AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-DctoPro AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-FchDes AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-FchHas AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-Filtro AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripcion" 
     VIEW-AS FILL-IN 
     SIZE 28.72 BY .69 NO-UNDO.

DEFINE VARIABLE F-Marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 17.72 BY .69 NO-UNDO.

DEFINE VARIABLE F-MargPub AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-PorUti AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-Provee AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.14 BY 3.46.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almmmatg.codmat COLUMN-LABEL "Articulo" FORMAT "X(8)"
      Almmmatg.DesMat FORMAT "X(40)"
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(15)"
      Almmmatg.UndStk COLUMN-LABEL "Unidad"
      X-Mon @ X-Mon COLUMN-LABEL "Mon" FORMAT "X(4)"
      Almmmatg.CtoTot COLUMN-LABEL "Valor Compra!       Neto    ."
            COLUMN-BGCOLOR 15
      Almmmatg.TpoMrg COLUMN-LABEL "T!M" FORMAT "!"
      Almmmatg.MrgUti COLUMN-LABEL "%Marg!Utilid" FORMAT "->>9.99"
            COLUMN-BGCOLOR 16
      Almmmatg.PreBas COLUMN-LABEL "Valor Vta!Sin IGV" FORMAT ">>,>>9.9999"
            COLUMN-BGCOLOR 14
      Almmmatg.Prevta[1] COLUMN-LABEL "Precio Vta!Con IGV" FORMAT ">>>,>>9.9999"
            COLUMN-BGCOLOR 11
      F-PRESOL @ F-PRESOL COLUMN-LABEL "Precio Vta!Con IGV S/." FORMAT ">>>,>>9.9999"
            COLUMN-BGCOLOR 10
      Almmmatg.PorMax COLUMN-LABEL "%Max!Dscto" FORMAT "->9.99"
      Almmmatg.PorVta[1] COLUMN-LABEL "%Dcto!Distrib" FORMAT "->9.99"
      Almmmatg.PorVta[2] COLUMN-LABEL "%Dcto!Mayor" FORMAT "->9.99"
      Almmmatg.PorVta[3] COLUMN-LABEL "%Dcto!Prom" FORMAT "->9.99"
      Almmmatg.FchPrmD
      Almmmatg.FchPrmH
      Almmmatg.CtoLis COLUMN-LABEL "Valor Comp!Sin IGV" FORMAT ">>,>>9.9999"
            COLUMN-BGCOLOR 11
      F-MRGCOM @ F-MRGCOM COLUMN-LABEL "%Marg!Comp" FORMAT "->>9.99"
      F-CTOPRM @ F-CTOPRM COLUMN-LABEL "Costo Prom." FORMAT ">>,>>9.9999"
  ENABLE
      Almmmatg.TpoMrg
      Almmmatg.MrgUti
      Almmmatg.PreBas
      Almmmatg.PorMax
      Almmmatg.PorVta[3]
      Almmmatg.FchPrmD
      Almmmatg.FchPrmH
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 86.14 BY 10.65
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn-Procesa AT ROW 2 COL 77.57
     CB-TpoMar AT ROW 2 COL 69.43 COLON-ALIGNED
     F-Filtro AT ROW 2.15 COL 27.14 COLON-ALIGNED
     F-Marca AT ROW 1.15 COL 65.29 COLON-ALIGNED
     F-CodMat AT ROW 2.15 COL 8 COLON-ALIGNED
     F-Provee AT ROW 2.96 COL 8 COLON-ALIGNED
     F-DctoMax AT ROW 3.46 COL 19 COLON-ALIGNED NO-LABEL
     F-DctoDis AT ROW 3.46 COL 30 COLON-ALIGNED NO-LABEL
     F-DctoMay AT ROW 3.46 COL 41 COLON-ALIGNED NO-LABEL
     F-DctoPro AT ROW 3.46 COL 51.86 COLON-ALIGNED NO-LABEL
     F-PorUti AT ROW 3.46 COL 62.72 COLON-ALIGNED NO-LABEL
     F-MargPub AT ROW 3.46 COL 73.86 COLON-ALIGNED NO-LABEL
     F-FchDes AT ROW 1.15 COL 29.72 COLON-ALIGNED
     F-FchHas AT ROW 1.15 COL 47.86 COLON-ALIGNED
     CB-FchMod AT ROW 1.15 COL 4.86 COLON-ALIGNED
     br_table AT ROW 4.27 COL 1
     RECT-19 AT ROW 1 COL 1
     "% Maximo" VIEW-AS TEXT
          SIZE 9.29 BY .5 AT ROW 2.96 COL 21
          BGCOLOR 1 FGCOLOR 15 
     "% Distribuidor" VIEW-AS TEXT
          SIZE 9.29 BY .5 AT ROW 2.96 COL 32
          BGCOLOR 1 FGCOLOR 15 
     "% Mayorista" VIEW-AS TEXT
          SIZE 9.29 BY .5 AT ROW 2.96 COL 43
          BGCOLOR 1 FGCOLOR 15 
     "% Promocion" VIEW-AS TEXT
          SIZE 9.29 BY .5 AT ROW 2.96 COL 53.86
          BGCOLOR 1 FGCOLOR 15 
     "% Marg.Normal" VIEW-AS TEXT
          SIZE 9.29 BY .5 AT ROW 3 COL 64.72
          BGCOLOR 1 FGCOLOR 14 
     "% Marg.Publ." VIEW-AS TEXT
          SIZE 9.29 BY .5 AT ROW 2.96 COL 75.86
          BGCOLOR 1 FGCOLOR 14 
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
         HEIGHT             = 13.92
         WIDTH              = 86.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
/* BROWSE-TAB br_table CB-FchMod F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main = 2.

/* SETTINGS FOR FILL-IN F-DctoDis IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DctoMax IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DctoMay IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DctoPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-MargPub IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.Almmmatg"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "integral.Almmmatg.CodCia = S-CODCIA
 AND integral.Almmmatg.DesMat BEGINS F-Filtro
 AND integral.Almmmatg.CodMar BEGINS F-CodMar
 AND integral.Almmmatg.CodPr1 BEGINS F-Provee"
     _FldNameList[1]   > integral.Almmmatg.codmat
"Almmmatg.codmat" "Articulo" "X(8)" "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > integral.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(40)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > integral.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(15)" "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > integral.Almmmatg.UndStk
"Almmmatg.UndStk" "Unidad" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[5]   > "_<CALC>"
"X-Mon @ X-Mon" "Mon" "X(4)" ? ? ? ? ? ? ? no ?
     _FldNameList[6]   > integral.Almmmatg.CtoTot
"Almmmatg.CtoTot" "Valor Compra!       Neto    ." ? "decimal" 15 ? ? ? ? ? no ?
     _FldNameList[7]   > integral.Almmmatg.TpoMrg
"Almmmatg.TpoMrg" "T!M" "!" "character" ? ? ? ? ? ? yes ?
     _FldNameList[8]   > integral.Almmmatg.MrgUti
"Almmmatg.MrgUti" "%Marg!Utilid" "->>9.99" "decimal" 16 ? ? ? ? ? yes ?
     _FldNameList[9]   > integral.Almmmatg.PreBas
"Almmmatg.PreBas" "Valor Vta!Sin IGV" ">>,>>9.9999" "decimal" 14 ? ? ? ? ? yes ?
     _FldNameList[10]   > integral.Almmmatg.Prevta[1]
"Almmmatg.Prevta[1]" "Precio Vta!Con IGV" ">>>,>>9.9999" "decimal" 11 ? ? ? ? ? no ?
     _FldNameList[11]   > "_<CALC>"
"F-PRESOL @ F-PRESOL" "Precio Vta!Con IGV S/." ">>>,>>9.9999" ? 10 ? ? ? ? ? no ?
     _FldNameList[12]   > integral.Almmmatg.PorMax
"Almmmatg.PorMax" "%Max!Dscto" "->9.99" "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[13]   > integral.Almmmatg.PorVta[1]
"Almmmatg.PorVta[1]" "%Dcto!Distrib" "->9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[14]   > integral.Almmmatg.PorVta[2]
"Almmmatg.PorVta[2]" "%Dcto!Mayor" "->9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[15]   > integral.Almmmatg.PorVta[3]
"Almmmatg.PorVta[3]" "%Dcto!Prom" "->9.99" "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[16]   > integral.Almmmatg.FchPrmD
"Almmmatg.FchPrmD" ? ? "date" ? ? ? ? ? ? yes ?
     _FldNameList[17]   > integral.Almmmatg.FchPrmH
"Almmmatg.FchPrmH" ? ? "date" ? ? ? ? ? ? yes ?
     _FldNameList[18]   > integral.Almmmatg.CtoLis
"Almmmatg.CtoLis" "Valor Comp!Sin IGV" ">>,>>9.9999" "decimal" 11 ? ? ? ? ? no ?
     _FldNameList[19]   > "_<CALC>"
"F-MRGCOM @ F-MRGCOM" "%Marg!Comp" "->>9.99" ? ? ? ? ? ? ? no ?
     _FldNameList[20]   > "_<CALC>"
"F-CTOPRM @ F-CTOPRM" "Costo Prom." ">>,>>9.9999" ? ? ? ? ? ? ? no ?
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
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main
DO:
  IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
     RUN lgc/d-detart.r({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codmat).
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
  IF Almmmatg.PorVta[3] = 0 THEN
     Almmmatg.PorVta[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(ROUND(Almmmatg.MrgUti * F-DctoPro / 100,2)).
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


&Scoped-define SELF-NAME Almmmatg.TpoMrg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.TpoMrg br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Almmmatg.TpoMrg IN BROWSE br_table /* T!M */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  IF LOOKUP(SELF:SCREEN-VALUE,"V,M") = 0 THEN DO:
     MESSAGE "Debe ingresar  [V] ó [M]" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  IF Almmmatg.TpoMrg:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "V" THEN DO:
     ASSIGN Almmmatg.MrgUti:READ-ONLY = YES
            Almmmatg.PreBas:READ-ONLY = NO.
  END.     
  IF Almmmatg.TpoMrg:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "M" THEN DO:
     ASSIGN Almmmatg.MrgUti:READ-ONLY = NO
            Almmmatg.PreBas:READ-ONLY = YES.
  END.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.MrgUti
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.MrgUti br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Almmmatg.MrgUti IN BROWSE br_table /* %Marg!Utilid */
DO:
   F-MrgUti = DECIMAL(Almmmatg.MrgUti:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
   F-PreVta = Almmmatg.CtoLis / (1 - F-MrgUti / 100).
   DISPLAY F-PreVta @ Almmmatg.PreBas WITH BROWSE {&BROWSE-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.PreBas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.PreBas br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Almmmatg.PreBas IN BROWSE br_table /* Valor Vta!Sin IGV */
DO:
   F-PreVta = DECIMAL(Almmmatg.PreBas:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
   F-MrgUti = ROUND((1 - Almmmatg.CtoLis / F-PreVta) * 100,2).
   DISPLAY F-MrgUti @ Almmmatg.MrgUti WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Procesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Procesa B-table-Win
ON CHOOSE OF Btn-Procesa IN FRAME F-Main /* Procesar */
DO:
  RUN Cambio-Tipo-Margen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CB-FchMod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-FchMod B-table-Win
ON VALUE-CHANGED OF CB-FchMod IN FRAME F-Main /* Filtrar */
DO:
  ASSIGN CB-FchMod F-FchDes F-FchHas.
  IF CB-FchMod = "Todas" THEN RUN set-attribute-list('Key-Name=?').
  ELSE RUN set-attribute-list('Key-Name=Fechas').
  RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CB-TpoMar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-TpoMar B-table-Win
ON VALUE-CHANGED OF CB-TpoMar IN FRAME F-Main /* Tipo Margen */
DO:
   ASSIGN CB-TpoMar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodMat B-table-Win
ON LEAVE OF F-CodMat IN FRAME F-Main /* Codigo */
DO:
  IF INTEGER(SELF:SCREEN-VALUE) = 0 THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  ASSIGN F-CodMat.
  RUN dispatch IN THIS-PROCEDURE ('busca':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-FchDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-FchDes B-table-Win
ON LEAVE OF F-FchDes IN FRAME F-Main /* Desde */
DO:
  /* Almmmatg.FchmPre[2] */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Filtro B-table-Win
ON LEAVE OF F-Filtro IN FRAME F-Main /* Descripcion */
OR "RETURN":U OF F-Filtro
DO:
  IF F-Filtro = F-Filtro:SCREEN-VALUE THEN RETURN.
  ASSIGN F-Filtro F-Marca.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Marca B-table-Win
ON LEAVE OF F-Marca IN FRAME F-Main /* Marca */
OR "RETURN":U OF F-Marca
DO:
  IF F-Marca = F-Marca:SCREEN-VALUE THEN RETURN.
  ASSIGN F-Marca F-Filtro.
  IF F-Marca = "" THEN DO:
     F-CodMar = "".
     RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  END.
  ELSE DO:
     FIND FIRST almtabla WHERE almtabla.Tabla = "MK" AND
                almtabla.Nombre BEGINS F-Marca NO-LOCK NO-ERROR.
     IF AVAILABLE almtabla THEN DO:
        F-CodMar = almtabla.Codigo.
        FIND FIRST Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
             Almmmatg.CodMar BEGINS F-CodMar NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmatg THEN 
           RUN dispatch IN THIS-PROCEDURE ('open-query':U).
     END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Marca B-table-Win
ON MOUSE-SELECT-DBLCLICK OF F-Marca IN FRAME F-Main /* Marca */
OR F8 OF F-Marca
DO:
  ASSIGN input-var-1 = "MK".
  RUN LKUP\C-AlmTab.R ("Marcas").
  IF output-var-1 <> ? THEN 
     F-Marca:SCREEN-VALUE = output-var-3. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Provee
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Provee B-table-Win
ON LEAVE OF F-Provee IN FRAME F-Main /* Proveedor */
OR "RETURN":U OF F-Provee
DO:
  IF F-Provee = F-Provee:SCREEN-VALUE THEN RETURN.
  ASSIGN F-Provee.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U). 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON "RETURN":U OF Almmmatg.MrgUti,Almmmatg.PreBas,Almmmatg.TpoMrg,Almmmatg.PorVta[3]
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.
ON FIND OF Almmmatg 
DO:
   IF Almmmatg.MonVta = 1 THEN DO:
      ASSIGN X-Mon = "S/."
             F-CTOPRM = Almmmatg.CtoPrm[1]
             F-PreSol = Almmmatg.PreVta[1].
   END.          
   ELSE
      ASSIGN X-Mon = "US$"
             F-CTOPRM = Almmmatg.CtoPrm[2]
             F-PreSol = ROUND(Almmmatg.PreVta[1] * FacCfgGn.Tpocmb[1],2).
             
   F-MrgCom = ROUND((1 - (F-CTOPRM / Almmmatg.PreBas)) * 100,2).
END.
/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR key-value AS CHAR NO-UNDO.

  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'Fechas':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro1} )
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Codigo':U THEN DO:
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.codmat
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Descripcion':U THEN DO:
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.DesMat
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Fechas */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Codigo':U THEN DO:
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.codmat
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Descripcion':U THEN DO:
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.DesMat
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* OTHERWISE...*/
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cambio-Tipo-Margen B-table-Win 
PROCEDURE Cambio-Tipo-Margen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
   ASSIGN F-CodMat F-DctoDis F-DctoMax F-DctoMay F-DctoPro F-Filtro 
          F-Marca F-MargPub F-PorUti F-Provee CB-FchMod F-FchDes F-FchHas.
END.
IF CB-FchMod = "Todas" THEN DO:
   FOR EACH MATG WHERE 
            MATG.CodCia = S-CODCIA
        AND MATG.DesMat BEGINS F-Filtro
        AND MATG.CodMar BEGINS F-CodMar
        AND MATG.CodPr1 BEGINS F-Provee
        BY MATG.CodCia BY MATG.CodMat:
       DISPLAY MATG.CodMat @ Fi-Mensaje LABEL "Articulo :"
               FORMAT "X(8)" WITH FRAME F-Proceso.
       ASSIGN MATG.TpoMrg = CB-TpoMar.
   END.
END.
ELSE DO:
   FOR EACH MATG WHERE 
            MATG.CodCia = S-CODCIA
        AND MATG.DesMat BEGINS F-Filtro
        AND MATG.CodMar BEGINS F-CodMar
        AND MATG.CodPr1 BEGINS F-Provee
        AND (MATG.FchmPre[2] >= F-FchDes) 
        AND (MATG.FchmPre[2] <= F-FchHas) 
       BY MATG.CodCia BY MATG.CodMat:
       DISPLAY MATG.CodMat @ Fi-Mensaje LABEL "Articulo :"
               FORMAT "X(8)" WITH FRAME F-Proceso.
       ASSIGN MATG.TpoMrg = CB-TpoMar.
   END.
END.
HIDE FRAME F-PROCESO.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime B-table-Win 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 
 PUT STREAM REPORT CONTROL CHR(27) "@" CHR(27) "C" CHR(66) CHR(15) CHR(27) "P".

 DO WITH FRAME {&FRAME-NAME}:
    ASSIGN F-CodMat F-DctoDis F-DctoMax F-DctoMay F-DctoPro F-Filtro 
           F-Marca F-MargPub F-PorUti F-Provee CB-FchMod F-FchDes F-FchHas.
 END.
 
 IF CB-FchMod = "Todas" THEN RUN Imprimir-Todos.
 ELSE RUN Imprimir-por-Fechas.
 
 PAGE STREAM REPORT.
 OUTPUT STREAM REPORT CLOSE.
 CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN RUN LIB/D-README.R(s-print-file). 
 END CASE. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-por-Fechas B-table-Win 
PROCEDURE Imprimir-por-Fechas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR F-PRECOS AS DECIMAL INIT 0.
 DEFINE VAR F-PREVTA AS DECIMAL INIT 0.
 DEFINE FRAME f-cab
        MATG.codmat FORMAT "X(6)"        AT 02
        MATG.DesMat FORMAT "X(40)"       AT 09
        MATG.DesMar FORMAT "X(17)"       AT 50
        X-Mon       FORMAT "X(3)"        AT 68
        F-CTOPRM    FORMAT ">>,>>9.9999" AT 72
/*      MATG.CtoLis FORMAT ">>,>>9.9999" AT 84*/
        F-PRECOS    FORMAT ">>>>,>>9.99" AT 84
        MATG.TpoMrg FORMAT "X"           AT 97  
/*      MATG.PreBas FORMAT ">>,>>9.9999" AT 100  */
        F-PREVTA    FORMAT ">>>>,>>9.99" AT 100  
        MATG.MrgUti FORMAT ">>9.99"      AT 112
        MATG.PorMax FORMAT ">>9.99"      AT 119 
        MATG.FchAct                      AT 126
/*      MATG.PorVta[1] COLUMN-LABEL "%Dcto!Distrib"   FORMAT "->>9.99"
        MATG.PorVta[2] COLUMN-LABEL "%Dcto!Mayor"     FORMAT "->>9.99"
        MATG.PorVta[3] COLUMN-LABEL "%Dcto!Prom"      FORMAT "->>9.99"
        F-MrgCom    COLUMN-LABEL "%Marg!Comp"         FORMAT "->>9.99" 126
        MATG.FchPrmD 
        MATG.FchPrmH          */
        HEADER
        CHR(18) + CHR(27) + CHR(77) + CHR(14) + CHR(27) + CHR(71) + S-NOMCIA + CHR(20) + CHR(27) + CHR(80) + CHR(15) + CHR(27) + CHR(72) FORMAT "X(20)"
        CHR(27) + CHR(80) + CHR(15) + CHR(27) + CHR(72) + "LISTA DE PRECIOS" TO 56 FORMAT "X(21)" 
        "PAGINA : " TO 103 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "FECHA : " TO 120 TODAY FORMAT "99/99/9999" SKIP(1)
        "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " CODIGO                                                                 PREC.COSTO  PREC.COSTO     P R E C I O %MARG  %DSCT.  F E C H A" SKIP
        "ARTICULO       DESCRIPCION                       M A R C A         MON   PROMEDIO      LISTA   T!M  V E N T A  UTILID MAXIMO  VARIACION" SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*        999999 1234567890123456789012345678901234567890 12345678901234567 123 99,999.9999 99,999.9999  X  99,999.9999 999.99 999.99 99/99/9999
                 9                                        50                68  71          83           96 99          110    117    124       */     
          WITH WIDTH 200 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH MATG WHERE 
           MATG.CodCia = S-CODCIA       AND
           MATG.DesMat BEGINS F-Filtro  AND
           MATG.CodMar BEGINS F-CodMar  AND
           MATG.CodPr1 BEGINS F-Provee  AND
          (MATG.FchmPre[2] >= F-FchDes) AND
          (MATG.FchmPre[2] <= F-FchHas) 
           BY MATG.Desmar BY MATG.DesMat :
      IF MATG.MonVta = 1 THEN 
         ASSIGN X-Mon = "S/."
                F-CTOPRM = MATG.CtoPrm[1].
      ELSE
         ASSIGN X-Mon = "US$"
                F-CTOPRM = MATG.CtoPrm[2].
      F-MrgCom = ROUND((1 - (F-CTOPRM / MATG.PreBas)) * 100,2).
      
      IF Almmmatg.AftIgv THEN DO:
         F-PRECOS = ROUND(MATG.CtoLis + (MATG.CtoLis * (FacCfgGn.PorIgv / 100)),2).
         F-PREVTA = ROUND(MATG.PreBas + (MATG.PreBas * (FacCfgGn.PorIgv / 100)),2).     
      END.
      ELSE DO:
         F-PRECOS = ROUND(MATG.CtoLis,2).
         F-PREVTA = ROUND(MATG.PreBas,2).     
      END.   
            
      DISPLAY  STREAM REPORT 
          MATG.codmat 
          MATG.DesMat 
          MATG.DesMar 
          X-Mon
          F-CTOPRM
/*        MATG.CtoLis */
          F-PRECOS
          MATG.TpoMrg 
/*        MATG.PreBas */
          F-PREVTA
          MATG.MrgUti
          MATG.PorMax 
          MATG.FchAct WITH FRAME F-Cab.

   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-Todos B-table-Win 
PROCEDURE Imprimir-Todos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR F-PRECOS AS DECIMAL INIT 0.
 DEFINE VAR F-PREVTA AS DECIMAL INIT 0.
 DEFINE FRAME f-cab
        MATG.codmat FORMAT "X(6)"        AT 02
        MATG.DesMat FORMAT "X(40)"       AT 09
        MATG.DesMar FORMAT "X(17)"       AT 50
        X-Mon       FORMAT "X(3)"        AT 68
        F-CTOPRM    FORMAT ">>,>>9.9999" AT 72
/*      MATG.CtoLis FORMAT ">>,>>9.9999" AT 84 */
        F-PRECOS    FORMAT ">>>>,>>9.99" AT 84
        MATG.TpoMrg FORMAT "X"           AT 97  
/*      MATG.PreBas FORMAT ">>,>>9.9999" AT 100*/
        F-PREVTA    FORMAT ">>>>,>>9.99" AT 100  
        MATG.MrgUti FORMAT ">>9.99"      AT 112
        MATG.PorMax FORMAT ">>9.99"      AT 119 
        MATG.FchAct                      AT 126
/*      MATG.PorVta[1] COLUMN-LABEL "%Dcto!Distrib"   FORMAT "->>9.99"
        MATG.PorVta[2] COLUMN-LABEL "%Dcto!Mayor"     FORMAT "->>9.99"
        MATG.PorVta[3] COLUMN-LABEL "%Dcto!Prom"      FORMAT "->>9.99"
        F-MrgCom    COLUMN-LABEL "%Marg!Comp"         FORMAT "->>9.99" 126
        MATG.FchPrmD 
        MATG.FchPrmH          */
        HEADER
        CHR(18) + CHR(27) + CHR(77) + CHR(14) + CHR(27) + CHR(71) + S-NOMCIA + CHR(20) + CHR(27) + CHR(80) + CHR(15) + CHR(27) + CHR(72) FORMAT "X(20)"
        CHR(27) + CHR(80) + CHR(15) + CHR(27) + CHR(72) + "LISTA DE PRECIOS" TO 56 FORMAT "X(21)" 
        "PAGINA : " TO 103 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "FECHA : " TO 120 TODAY FORMAT "99/99/9999" SKIP(1)
        "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " CODIGO                                                                 PREC.COSTO  PREC.COSTO     P R E C I O %MARG  %DSCT.  F E C H A" SKIP
        "ARTICULO       DESCRIPCION                       M A R C A         MON   PROMEDIO      LISTA   T!M  V E N T A  UTILID MAXIMO  VARIACION" SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*        999999 1234567890123456789012345678901234567890 12345678901234567 123 99,999.9999 99,999.9999  X  99,999.9999 999.99 999.99 99/99/9999
                 9                                        50                68  71          83           96 99          110    117    124       */     
        WITH WIDTH 200 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.
 
  FOR EACH MATG WHERE 
           MATG.CodCia = S-CODCIA       AND
           MATG.DesMat BEGINS F-Filtro  AND
           MATG.CodMar BEGINS F-CodMar  AND
           MATG.CodPr1 BEGINS F-Provee  
           BY MATG.Desmar BY MATG.DesMat :
      IF MATG.MonVta = 1 THEN 
         ASSIGN X-Mon = "S/."
                F-CTOPRM = MATG.CtoPrm[1].
      ELSE
         ASSIGN X-Mon = "US$"
                F-CTOPRM = MATG.CtoPrm[2].
      F-MrgCom = ROUND((1 - (F-CTOPRM / MATG.PreBas)) * 100,2).
      
      IF Almmmatg.AftIgv THEN DO:
         F-PRECOS = ROUND(MATG.CtoLis + (MATG.CtoLis * (FacCfgGn.PorIgv / 100)),2).
         F-PREVTA = ROUND(MATG.PreBas + (MATG.PreBas * (FacCfgGn.PorIgv / 100)),2).     
      END.
      ELSE DO:
         F-PRECOS = ROUND(MATG.CtoLis,2).
         F-PREVTA = ROUND(MATG.PreBas,2).     
      END.   
      
      DISPLAY  STREAM REPORT 
          MATG.codmat 
          MATG.DesMat 
          MATG.DesMar 
          X-Mon
          F-CTOPRM
/*        MATG.CtoLis */
          F-PRECOS
          MATG.TpoMrg 
/*        MATG.PreBas */
          F-PREVTA
          MATG.MrgUti
          MATG.PorMax 
          MATG.FchAct WITH FRAME F-Cab.
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
  DEFINE VARIABLE F-PreAnt LIKE Almmmatg.PreBas  NO-UNDO.
  IF AVAILABLE Almmmatg THEN F-PreAnt = Almmmatg.PreBas.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  IF Almmmatg.TpoMrg = "V" THEN DO:
     Almmmatg.MrgUti = ROUND((1 - (Almmmatg.CtoLis / Almmmatg.PreBas)) * 100,2).
  END.     
  IF Almmmatg.TpoMrg = "M" THEN DO:
     Almmmatg.PreBas = Almmmatg.CtoLis / (1 - Almmmatg.MrgUti / 100).
  END.     
  F-PorImp = 1.
  IF Almmmatg.AftIsc THEN F-PorImp = (1 + Almmmatg.PorIsc / 100).
  IF Almmmatg.AftIgv THEN F-PorImp = F-PorImp * (1 + FacCfgGn.PorIgv / 100).
  ASSIGN Almmmatg.PorMax    = ROUND(Almmmatg.MrgUti * F-DctoMax / 100,2) + Almmmatg.PorVta[3]
         Almmmatg.PorVta[1] = ROUND(Almmmatg.MrgUti * F-DctoMay / 100,2) + Almmmatg.PorVta[3]
         Almmmatg.PorVta[2] = ROUND(Almmmatg.MrgUti * F-DctoDis / 100,2) + Almmmatg.PorVta[3]
         Almmmatg.PorVta[4] = F-MargPub
         Almmmatg.PreVta[1] = ROUND(Almmmatg.PreBas * F-PorImp,2)
         Almmmatg.PreVta[2] = ROUND(Almmmatg.PreBas * F-PorImp * (1 - (Almmmatg.PorVta[1] / 100)),2)
         Almmmatg.PreVta[3] = ROUND(Almmmatg.PreBas * F-PorImp * (1 - (Almmmatg.PorVta[2] / 100)),2)
         Almmmatg.Prevta[4] = ROUND(Almmmatg.PreBas * F-PorImp * (1 + (Almmmatg.PorVta[4] / 100)),2).
  
  IF F-PreAnt <> Almmmatg.PreBas THEN Almmmatg.FchmPre[3] = TODAY.
  
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
     FIND MATG WHERE MATG.CodCia = S-CODCIA AND 
          MATG.CodMat = F-CodMat NO-LOCK NO-ERROR.
     IF AVAILABLE MATG THEN OUTPUT-VAR-1 = ROWID(MATG).
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  RUN bin/_prnctr.p.

  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").
  
  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
  RUN Imprime.

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
  
  ASSIGN F-MargPub = FacCfgGn.MrgPub
         F-DctoDis = FacCfgGn.DtoDis 
         F-DctoMax = FacCfgGn.DtoMax
         F-DctoMay = FacCfgGn.DtoMay
         F-DctoPro = FacCfgGn.DtoPro.
  
  DISPLAY F-MargPub F-DctoDis 
          F-DctoMax F-DctoMay F-DctoPro WITH FRAME {&FRAME-NAME}.
          
          
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-por-Fechas B-table-Win 
PROCEDURE Recalcular-por-Fechas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE F-PreAnt LIKE MATG.PreBas  NO-UNDO.
   FOR EACH integral.MATG WHERE 
       MATG.CodCia = S-CODCIA
       AND MATG.DesMat BEGINS F-Filtro
       AND MATG.CodMar BEGINS F-CodMar
       AND MATG.CodPr1 BEGINS F-Provee
       AND (MATG.FchmPre[2] >= F-FchDes) 
       AND (MATG.FchmPre[2] <= F-FchHas) 
       BY MATG.CodCia BY MATG.CodMat:
       DISPLAY MATG.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
               FORMAT "X(8)" WITH FRAME F-Proceso.
       F-PreAnt = MATG.PreBas.
       IF MATG.TpoMrg = "V" THEN DO:
          MATG.MrgUti = ROUND((1 - (MATG.CtoLis / MATG.PreBas)) * 100,2).
       END.     
       IF MATG.TpoMrg = "M" THEN DO:
          IF F-PorUti <> 0 THEN MATG.MrgUti = F-PorUti.
          MATG.PreBas = MATG.CtoLis / (1 - MATG.MrgUti / 100).
       END.
       F-PorImp = 1.
       IF MATG.AftIsc THEN F-PorImp = (1 + MATG.PorIsc / 100).
       IF MATG.AftIgv THEN F-PorImp = F-PorImp * (1 + FacCfgGn.PorIgv / 100).
       ASSIGN MATG.PorMax    = ROUND(MATG.MrgUti * F-DctoMax / 100,2) + MATG.PorVta[3]
              MATG.PorVta[1] = ROUND(MATG.MrgUti * F-DctoMay / 100,2) + MATG.PorVta[3]
              MATG.PorVta[2] = ROUND(MATG.MrgUti * F-DctoDis / 100,2) + MATG.PorVta[3]
              MATG.PorVta[4] = F-MargPub
              MATG.PreVta[1] = ROUND(MATG.PreBas * F-PorImp,2)
              MATG.PreVta[2] = ROUND(MATG.PreBas * F-PorImp * (1 - (MATG.PorVta[1] / 100)),2)
              MATG.PreVta[3] = ROUND(MATG.PreBas * F-PorImp * (1 - (MATG.PorVta[2] / 100)),2)
              MATG.Prevta[4] = ROUND(MATG.PreBas * F-PorImp * (1 + (MATG.PorVta[4] / 100)),2).
      IF F-PreAnt <> MATG.PreBas THEN MATG.FchmPre[3] = TODAY.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Todos B-table-Win 
PROCEDURE Recalcular-Todos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE F-PreAnt LIKE MATG.PreBas  NO-UNDO.
   FOR EACH MATG WHERE 
       MATG.CodCia = S-CODCIA
       AND MATG.DesMat BEGINS F-Filtro
       AND MATG.CodMar BEGINS F-CodMar
       AND MATG.CodPr1 BEGINS F-Provee
       BY MATG.CodCia BY MATG.CodMat:
       DISPLAY MATG.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
               FORMAT "X(8)" WITH FRAME F-Proceso.
       F-PreAnt = MATG.PreBas.
       IF MATG.TpoMrg = "V" THEN DO:
          MATG.MrgUti = ROUND((1 - (MATG.CtoLis / MATG.PreBas)) * 100,2).
       END.     
       IF MATG.TpoMrg = "M" THEN DO:
          IF F-PorUti <> 0 THEN MATG.MrgUti = F-PorUti.
          MATG.PreBas = MATG.CtoLis / (1 - MATG.MrgUti / 100).
       END.
       F-PorImp = 1.
       IF MATG.AftIsc THEN F-PorImp = (1 + MATG.PorIsc / 100).
       IF MATG.AftIgv THEN F-PorImp = F-PorImp * (1 + FacCfgGn.PorIgv / 100).
       ASSIGN MATG.PorMax    = ROUND(MATG.MrgUti * F-DctoMax / 100,2) + MATG.PorVta[3]
              MATG.PorVta[1] = ROUND(MATG.MrgUti * F-DctoMay / 100,2) + MATG.PorVta[3]
              MATG.PorVta[2] = ROUND(MATG.MrgUti * F-DctoDis / 100,2) + MATG.PorVta[3]
              MATG.PorVta[4] = F-MargPub
              MATG.PreVta[1] = ROUND(MATG.PreBas * F-PorImp,2)
              MATG.PreVta[2] = ROUND(MATG.PreBas * F-PorImp * (1 - (MATG.PorVta[1] / 100)),2)
              MATG.PreVta[3] = ROUND(MATG.PreBas * F-PorImp * (1 - (MATG.PorVta[2] / 100)),2)
              MATG.Prevta[4] = ROUND(MATG.PreBas * F-PorImp * (1 + (MATG.PorVta[4] / 100)),2).
      IF F-PreAnt <> MATG.PreBas THEN MATG.FchmPre[3] = TODAY.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalculo-Precios B-table-Win 
PROCEDURE Recalculo-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
   ASSIGN F-CodMat F-DctoDis F-DctoMax F-DctoMay F-DctoPro F-Filtro 
          F-Marca F-MargPub F-PorUti F-Provee CB-FchMod F-FchDes F-FchHas.
END.
IF CB-FchMod = "Todas" THEN RUN Recalcular-Todos.
ELSE RUN Recalcular-por-Fechas.
HIDE FRAME F-PROCESO.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
IF NOT AVAILABLE Almmmatg THEN RETURN "ADM-ERROR".
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


