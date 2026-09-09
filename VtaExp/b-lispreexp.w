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

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHARACTER.
DEFINE SHARED VARIABLE S-USER-ID  AS CHARACTER.
DEFINE SHARED VARIABLE s-coddiv AS CHAR.

DEFINE VARIABLE F-FACTOR     AS DECIMAL   NO-UNDO.

DEFINE BUFFER MATG FOR Almmmatg.
DEFINE VARIABLE F-CODMAR AS CHAR INIT "" NO-UNDO.
DEFINE VARIABLE X-Mon AS CHAR NO-UNDO.
DEFINE VARIABLE X-CTOUND AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRENET AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-CTOPRM AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PreVta LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-MrgUti AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-MrgCom AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PorImp AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PreSol AS DECIMAL NO-UNDO.
DEFINE VARIABLE X-CTOTOT AS DECIMAL FORMAT "->>>>>>>>>9.999999" NO-UNDO.
DEFINE VARIABLE F-PorMax AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-clase  AS CHAR.
DEFINE VARIABLE F-PreVta-A AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PreVta-B AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PreVta-C AS DECIMAL NO-UNDO.

DEFINE VARIABLE F-MrgUti-A AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-MrgUti-B AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-MrgUti-C AS DECIMAL NO-UNDO.

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

DEFINE VARIABLE x-dsc1 AS DECIMAL NO-UNDO.
DEFINE VARIABLE X-PRE1 AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-dsc2 AS DECIMAL NO-UNDO.
DEFINE VARIABLE X-PRE2 AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-dsc3 AS DECIMAL NO-UNDO.
DEFINE VARIABLE X-PRE3 AS DECIMAL NO-UNDO.

DEFINE VARIABLE x-password AS LOGICAL NO-UNDO INITIAL FALSE.

/* Preprocesadores para cada campo filtro */ 
&SCOPED-DEFINE CONDICION Almmmatg.CodCia = S-CODCIA ~
AND Almmmatg.subfam <> '888'

/*&SCOPED-DEFINE FILTRO1 ( (Almmmatg.FchmPre[2] >= F-FchDes) AND (Almmmatg.FchmPre[2] <= F-FchHas) )*/
&SCOPED-DEFINE FILTRO1 (Almmmatg.DesMat = F-Filtro) /*AND (Almmmatg.DesMar BEGINS F-marca) )*/
 
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

DEFINE VARIABLE MaxCat LIKE ClfClie.PorDsc.
DEFINE VARIABLE MaxVta LIKE Dsctos.PorDto.

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
&Scoped-define INTERNAL-TABLES Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almmmatg.codmat Almmmatg.DesMat ~
Almmmatg.DesMar Almmmatg.PreAlt[5] Almmmatg.PreAlt[6] Almmmatg.PorMax ~
Almmmatg.UndBas Almmmatg.PreAlt[3] Almmmatg.Dec__01 Almmmatg.PreOfi ~
Almmmatg.Chr__01 Almmmatg.PreAlt[4] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table Almmmatg.PreAlt[5] ~
Almmmatg.PreAlt[6] Almmmatg.PreAlt[3] Almmmatg.PreAlt[4] 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table Almmmatg
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define QUERY-STRING-br_table FOR EACH Almmmatg WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION}  ~
 AND Almmmatg.CodCia = S-CODCIA ~
 AND Almmmatg.DesMat BEGINS F-Filtro ~
 AND Almmmatg.CodPr1 BEGINS F-Provee ~
 AND Almmmatg.TpoArt BEGINS R-Tipo ~
 AND Almmmatg.FchCes = ? NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almmmatg WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION}  ~
 AND Almmmatg.CodCia = S-CODCIA ~
 AND Almmmatg.DesMat BEGINS F-Filtro ~
 AND Almmmatg.CodPr1 BEGINS F-Provee ~
 AND Almmmatg.TpoArt BEGINS R-Tipo ~
 AND Almmmatg.FchCes = ? NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-24 CB-FchMod F-FchDes F-FchHas R-Tipo ~
F-CodMat F-Filtro F-Provee br_table 
&Scoped-Define DISPLAYED-OBJECTS CB-FchMod F-FchDes F-FchHas R-Tipo ~
F-CodMat F-Filtro FILL-IN-Mensaje F-Provee 

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
Codigo|||integral.Almmmatg.CodCia|yes,integral.Almmmatg.codmat|yes
Descripcion|||integral.Almmmatg.CodCia|yes,integral.Almmmatg.DesMat|yes
Marca|||integral.Almmmatg.CodCia|yes,integral.Almmmatg.DesMar|yes
Familia|y||integral.Almmmatg.CodCia|yes,integral.Almmmatg.codfam|yes,integral.Almmmatg.CtoLis|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "Codigo,Descripcion,Marca,Familia",
     SortBy-Case = Familia':U).

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


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-Descuentos 
       MENU-ITEM m_Descuento_Promocional LABEL "Descuento Promocional"
       MENU-ITEM m_Descuento_Por_Volumen LABEL "Descuento Por Volumen".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE CB-FchMod AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Filtrar" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Todas","Ultimas Modificaciones" 
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE F-CodMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .69 NO-UNDO.

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

DEFINE VARIABLE F-Provee AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .81 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER INITIAL "A" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Activos", "A",
"Inactivos", "D",
"Ambos", ""
     SIZE 24.86 BY .54 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.43 BY .85.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almmmatg.codmat COLUMN-LABEL "Articulo" FORMAT "X(8)":U
      Almmmatg.DesMat FORMAT "X(55)":U
      Almmmatg.DesMar FORMAT "X(14)":U
      Almmmatg.PreAlt[5] COLUMN-LABEL "Mon" FORMAT "9":U COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
      Almmmatg.PreAlt[6] COLUMN-LABEL "Tipo de!Cambio" FORMAT "Z9.99":U
            COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
      Almmmatg.PorMax COLUMN-LABEL "%Max!Dscto" FORMAT ">9.99":U
      Almmmatg.UndBas COLUMN-LABEL "Und!Base" FORMAT "X(6)":U
      Almmmatg.PreAlt[3] COLUMN-LABEL "Precio Lista" FORMAT ">>,>>>,>>9.9999":U
            COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
      Almmmatg.Dec__01 COLUMN-LABEL "%Marg Utilid!Pre.Ofi." FORMAT "->>9.99":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      Almmmatg.PreOfi COLUMN-LABEL "Precio de Oficina" FORMAT ">>>>,>>9.9999":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      Almmmatg.Chr__01 COLUMN-LABEL "UM.!Pre.Ofi." FORMAT "X(6)":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      Almmmatg.PreAlt[4] COLUMN-LABEL "Precio Expolibreria" FORMAT ">>>>,>>9.9999":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 5
  ENABLE
      Almmmatg.PreAlt[5] HELP "1: Soles      2 :Dólares"
      Almmmatg.PreAlt[6]
      Almmmatg.PreAlt[3]
      Almmmatg.PreAlt[4]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 132.86 BY 10.58
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CB-FchMod AT ROW 1.15 COL 4.86 COLON-ALIGNED
     F-FchDes AT ROW 1.27 COL 29.43 COLON-ALIGNED
     F-FchHas AT ROW 1.27 COL 45.86 COLON-ALIGNED
     R-Tipo AT ROW 1.38 COL 59.86 NO-LABEL
     F-CodMat AT ROW 2.15 COL 8 COLON-ALIGNED
     F-Filtro AT ROW 2.15 COL 27.14 COLON-ALIGNED
     FILL-IN-Mensaje AT ROW 2.92 COL 69 COLON-ALIGNED NO-LABEL
     F-Provee AT ROW 2.96 COL 8 COLON-ALIGNED
     br_table AT ROW 3.92 COL 1.14
     RECT-24 AT ROW 1.19 COL 59
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
         HEIGHT             = 13.92
         WIDTH              = 135.14.
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
/* BROWSE-TAB br_table F-Provee F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-Descuentos:HANDLE
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.Almmmatg"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _OrdList          = "integral.Almmmatg.CodCia|yes,integral.Almmmatg.codmat|yes"
     _Where[1]         = "{&CONDICION} 
 AND integral.Almmmatg.CodCia = S-CODCIA
 AND integral.Almmmatg.DesMat BEGINS F-Filtro
 AND integral.Almmmatg.CodPr1 BEGINS F-Provee
 AND integral.Almmmatg.TpoArt BEGINS R-Tipo
 AND integral.Almmmatg.FchCes = ?"
     _FldNameList[1]   > integral.Almmmatg.codmat
"codmat" "Articulo" "X(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.Almmmatg.DesMat
"DesMat" ? "X(55)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.Almmmatg.DesMar
"DesMar" ? "X(14)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.Almmmatg.PreAlt[5]
"PreAlt[5]" "Mon" "9" "decimal" 11 9 ? ? ? ? yes "1: Soles      2 :Dólares" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.Almmmatg.PreAlt[6]
"PreAlt[6]" "Tipo de!Cambio" "Z9.99" "decimal" 11 9 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.Almmmatg.PorMax
"PorMax" "%Max!Dscto" ">9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > integral.Almmmatg.UndBas
"UndBas" "Und!Base" "X(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > integral.Almmmatg.PreAlt[3]
"PreAlt[3]" "Precio Lista" ">>,>>>,>>9.9999" "decimal" 11 9 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > integral.Almmmatg.Dec__01
"Dec__01" "%Marg Utilid!Pre.Ofi." "->>9.99" "decimal" 12 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > integral.Almmmatg.PreOfi
"PreOfi" "Precio de Oficina" ">>>>,>>9.9999" "decimal" 12 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > integral.Almmmatg.Chr__01
"Chr__01" "UM.!Pre.Ofi." "X(6)" "character" 12 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > integral.Almmmatg.PreAlt[4]
"PreAlt[4]" "Precio Expolibreria" ">>>>,>>9.9999" "decimal" 5 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ANY-PRINTABLE OF br_table IN FRAME F-Main
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main
DO:
/*  IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
 *      RUN lgc/d-detart.r({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codmat).
 *   RUN dispatch IN THIS-PROCEDURE ('display-fields':U).*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
/*
  IF Almmmatg.PorVta[5] = 0 THEN
     Almmmatg.PorVta[5]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(ROUND(Almmmatg.MrgUti * F-DctoPro / 100,2)).
*/
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
   0  objects when the browser's current row changes. */
   {src/adm/template/brschnge.i} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CB-FchMod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-FchMod B-table-Win
ON VALUE-CHANGED OF CB-FchMod IN FRAME F-Main /* Filtrar */
DO:
  ASSIGN CB-FchMod F-FchDes F-FchHas R-Tipo.
  IF CB-FchMod = "Todas" THEN 
    RUN set-attribute-list('Key-Name=?').
  ELSE 
    RUN set-attribute-list('Key-Name=Fechas').
    
  RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
  
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
  ASSIGN F-Filtro R-Tipo.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U). 
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


&Scoped-define SELF-NAME m_Descuento_Por_Volumen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Descuento_Por_Volumen B-table-Win
ON CHOOSE OF MENU-ITEM m_Descuento_Por_Volumen /* Descuento Por Volumen */
DO:
  IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
     RUN VtaExp/D-Dtovol ({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codmat).
     RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Descuento_Promocional
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Descuento_Promocional B-table-Win
ON CHOOSE OF MENU-ITEM m_Descuento_Promocional /* Descuento Promocional */
DO:
  IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
     RUN VtaExp/D-Dtoprom ({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codmat).
     RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-Tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-Tipo B-table-Win
ON VALUE-CHANGED OF R-Tipo IN FRAME F-Main
DO:
  ASSIGN R-Tipo.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON FIND OF Almmmatg 
DO:
   X-CTOTOT = Almmmatg.CtoTot.
   IF Almmmatg.AftIgv THEN X-CTOTOT = X-CTOTOT / (1 + FacCfgGn.PorIgv / 100).
   X-CTOUND = Almmmatg.CtoTot.

   F-PreNet = ROUND(X-CTOUND * ( 1 + Almmmatg.MrgUti / 100), 2).
   
   IF Almmmatg.MonVta = 1 THEN DO:
      ASSIGN X-Mon = "S/."
             F-CTOPRM = Almmmatg.CtoPrm[1]
             F-PreSol = Almmmatg.PreVta[1].
   END.
   ELSE
      ASSIGN X-Mon = "US$"
             F-CTOPRM = Almmmatg.CtoPrm[2]
             F-PreSol = ROUND(Almmmatg.PreVta[1] * FacCfgGn.Tpocmb[1],2).
             

END.
/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
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
         WHEN 'Marca':U THEN DO:
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.DesMar
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Familia':U THEN DO:
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.codfam BY Almmmatg.CtoLis
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
         WHEN 'Marca':U THEN DO:
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.DesMar
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         WHEN 'Familia':U THEN DO:
           &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.codfam BY Almmmatg.CtoLis
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Precios B-table-Win 
PROCEDURE Captura-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i AS INT NO-UNDO.

  /* BORRAMOS INFORMACION PREVIA */
  FOR EACH Expmmatg WHERE Expmmatg.codcia = s-codcia
        AND Expmmatg.coddiv = s-coddiv:
    DELETE Expmmatg.                            
  END.
  

  FOR EACH Almmmatg WHERE {&CONDICION}:
    ASSIGN
        Almmmatg.PreAlt[5] = Almmmatg.MonVta
        Almmmatg.PreAlt[6] = Almmmatg.TpoCmb
        Almmmatg.PreAlt[3] = Almmmatg.PreVta[1]     /* Precio de lista para promociones y dtoc por volumen */
        Almmmatg.PreAlt[4] = Almmmatg.PreOfi
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'TRANSFIRIENDO PRECIOS: ' + Almmmatg.codmat.
    PROMOCION:
    DO i = 1 TO 10:
        IF Almmmatg.PromDivi[i] = s-coddiv THEN DO:
            CREATE Expmmatg.
            ASSIGN
                Expmmatg.CodCia = Almmmatg.codcia
                Expmmatg.CodDiv = s-coddiv
                Expmmatg.codmat = Almmmatg.codmat
                Expmmatg.PromDto = Almmmatg.PromDto[i]
                Expmmatg.PromFchD = Almmmatg.PromFchD[i]
                Expmmatg.PromFchH = Almmmatg.PromFchH[i].
            LEAVE PROMOCION.
        END.
    END.
    /* RHC 30.12.09 BLOQUEADO ****************************************************************
    VOLUMEN:
    DO i = 1 TO 10:
        IF Almmmatg.DtoVolD[i] > 0 THEN DO:
            FIND Expmmatg OF Almmmatg WHERE Expmmatg.coddiv = s-coddiv EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Expmmatg THEN DO:
                CREATE Expmmatg.
                ASSIGN
                    Expmmatg.CodCia = Almmmatg.codcia
                    Expmmatg.CodDiv = s-coddiv
                    Expmmatg.codmat = Almmmatg.codmat.
            END.
            ASSIGN
                Expmmatg.DtoVolD[1] = Almmmatg.DtoVolD[1] 
                Expmmatg.DtoVolD[2] = Almmmatg.DtoVolD[2]
                Expmmatg.DtoVolD[3] = Almmmatg.DtoVolD[3]
                Expmmatg.DtoVolD[4] = Almmmatg.DtoVolD[4]
                Expmmatg.DtoVolD[5] = Almmmatg.DtoVolD[5]
                Expmmatg.DtoVolD[6] = Almmmatg.DtoVolD[6]
                Expmmatg.DtoVolD[7] = Almmmatg.DtoVolD[7]
                Expmmatg.DtoVolD[8] = Almmmatg.DtoVolD[8]
                Expmmatg.DtoVolD[9] = Almmmatg.DtoVolD[9]
                Expmmatg.DtoVolD[10] = Almmmatg.DtoVolD[10].
            ASSIGN
                Expmmatg.DtoVolR[1] = Almmmatg.DtoVolR[1]
                Expmmatg.DtoVolR[2] = Almmmatg.DtoVolR[2]
                Expmmatg.DtoVolR[3] = Almmmatg.DtoVolR[3]
                Expmmatg.DtoVolR[4] = Almmmatg.DtoVolR[4]
                Expmmatg.DtoVolR[5] = Almmmatg.DtoVolR[5]
                Expmmatg.DtoVolR[6] = Almmmatg.DtoVolR[6]
                Expmmatg.DtoVolR[7] = Almmmatg.DtoVolR[7]
                Expmmatg.DtoVolR[8] = Almmmatg.DtoVolR[8]
                Expmmatg.DtoVolR[9] = Almmmatg.DtoVolR[9]
                Expmmatg.DtoVolR[10] = Almmmatg.DtoVolR[10].
            LEAVE VOLUMEN.
        END.
    END.
    ************************************************************************ */
  
  END.
  FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime B-table-Win 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN F-CodMat F-Filtro R-Tipo F-Provee CB-FchMod F-FchDes F-FchHas.
    END.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL CHR(27) "@" CHR(27) "C" CHR(66) CHR(15) CHR(27) "P".
        IF CB-FchMod = "Todas" THEN RUN Imprimir-Todos.
        ELSE RUN Imprimir-por-Fechas.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
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
 DEFINE VAR x-ctotot1 AS DECIMAL INIT 0.
 DEFINE VAR x-ctotot2 AS DECIMAL INIT 0.
 DEFINE VAR x-ctorep1 AS DECIMAL INIT 0.
 DEFINE VAR x-ctorep2 AS DECIMAL INIT 0.
 DEFINE VAR x-preuni1 AS DECIMAL INIT 0.
 DEFINE VAR x-preuni2 AS DECIMAL INIT 0.
 DEFINE VAR x-prenet1 AS DECIMAL INIT 0.
 DEFINE VAR x-prenet2 AS DECIMAL INIT 0.

 DEFINE FRAME f-cab
        MATG.codmat FORMAT "X(6)"        AT 02
        MATG.DesMat FORMAT "X(40)"       AT 09
        MATG.UndStk FORMAT "X(4)"        AT 50
        MATG.Pesmat FORMAT ">>,>>9.9999" 
        x-Ctotot1   FORMAT "->>>,>>9.99"
        x-Ctotot2   FORMAT "->>>,>>9.99"
        x-Ctorep2   FORMAT "->>>,>>9.99"
        x-Ctorep1   FORMAT "->>>,>>9.99"
        x-Preuni2   FORMAT "->>>,>>9.99"
        x-Preuni1   FORMAT "->>>,>>9.99"
        MATG.PorMax FORMAT "->>9.99"      
        x-prenet2   FORMAT "->>>,>>9.99"
        x-prenet1   FORMAT "->>>,>>9.99"
        MATG.MrgUti FORMAT "->>9.99"
        HEADER
        CHR(18) + CHR(27) + CHR(77) + CHR(14) + CHR(27) + CHR(71) + S-NOMCIA + CHR(20) + CHR(27) + CHR(80) + CHR(15) + CHR(27) + CHR(72) FORMAT "X(20)"
        CHR(27) + CHR(77) + CHR(15) + CHR(27) + CHR(72) + "LISTA DE PRECIOS" TO 72 FORMAT "X(21)" 
        "PAGINA : " TO 135 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "FECHA : " TO 152 TODAY FORMAT "99/99/9999" SKIP(1)
        "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " CODIGO                                          UND         PESO       COSTO REPOSICION      COSTO.REP.UNITARIO         PRECIO UNITARIO      %            PRECIO NETO      %MRG." SKIP
        "ARTICULO       DESCRIPCION                       MED          KG.         US$      S/.           US$      S/.               US$     S/.      DCTO.        US$       S/.     UTIL." SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP


/*        999999 1234567890123456789012345678901234567890 12345678901234567 123 -99,999.9999 -99,999.9999  X  -99,999.9999 -999.99 -999.99 99/99/9999
                 9                                        50                68  71          83           96 99          110    117    124       */     
          WITH WIDTH 200 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH MATG WHERE MATG.CodCia = S-CODCIA
                 AND  MATG.DesMat BEGINS F-Filtro
                 AND  MATG.TpoArt BEGINS R-Tipo
                 AND  MATG.CodPr1 BEGINS F-Provee  
                 AND  (MATG.FchmPre[2] >= F-FchDes) 
                 AND  (MATG.FchmPre[2] <= F-FchHas)
                BY MATG.CodFam BY MATG.OrdLis:
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
 DEFINE VAR x-ctotot1 AS DECIMAL INIT 0.
 DEFINE VAR x-ctotot2 AS DECIMAL INIT 0.
 DEFINE VAR x-ctorep1 AS DECIMAL INIT 0.
 DEFINE VAR x-ctorep2 AS DECIMAL INIT 0.
 DEFINE VAR x-preuni1 AS DECIMAL INIT 0.
 DEFINE VAR x-preuni2 AS DECIMAL INIT 0.
 DEFINE VAR x-prenet1 AS DECIMAL INIT 0.
 DEFINE VAR x-prenet2 AS DECIMAL INIT 0.
 
 DEFINE FRAME f-cab
        MATG.codmat FORMAT "X(6)"        AT 02
        MATG.DesMat FORMAT "X(40)"       AT 09
        MATG.UndStk FORMAT "X(4)"        AT 50
        MATG.Pesmat FORMAT ">>,>>9.9999" 
        x-Ctotot2   FORMAT "->>>,>>9.99"
        x-Ctotot1   FORMAT "->>>,>>9.99"
        x-Ctorep2   FORMAT "->>>,>>9.99"
        x-Ctorep1   FORMAT "->>>,>>9.99"
        x-Preuni2   FORMAT "->>>,>>9.99"
        x-Preuni1   FORMAT "->>>,>>9.99"
        MATG.PorMax FORMAT "->>9.99"      
        x-prenet2   FORMAT "->>>,>>9.99"
        x-prenet1   FORMAT "->>>,>>9.99"
        MATG.MrgUti FORMAT "->>9.99"
        HEADER
        CHR(18) + CHR(27) + CHR(77) + CHR(14) + CHR(27) + CHR(71) + S-NOMCIA + CHR(20) + CHR(27) + CHR(80) + CHR(15) + CHR(27) + CHR(72) FORMAT "X(20)"
        CHR(27) + CHR(77) + CHR(15) + CHR(27) + CHR(72) + "LISTA DE PRECIOS" TO 72 FORMAT "X(21)" 
        "PAGINA : " TO 135 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "FECHA : " TO 152 TODAY FORMAT "99/99/9999" SKIP(1)
        "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " CODIGO                                          UND         PESO       COSTO REPOSICION      COSTO.REP.UNITARIO         PRECIO UNITARIO      %            PRECIO NETO      %MRG." SKIP
        "ARTICULO       DESCRIPCION                       MED          KG.         US$      S/.           US$      S/.               US$     S/.      DCTO.        US$       S/.     UTIL." SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*        999999 1234567890123456789012345678901234567890 12345678901234567 123 99,999.9999 99,999.9999  X  99,999.9999 999.99 999.99 99/99/9999
                 9                                        50                68  71          83           96 99          110    117    124       */     
        WITH WIDTH 200 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.
 
  FOR EACH MATG WHERE MATG.CodCia = S-CODCIA
                 AND  MATG.DesMat BEGINS F-Filtro
                 AND  MATG.TpoArt BEGINS R-Tipo
                 AND  MATG.CodPr1 BEGINS F-Provee
                BREAK BY MATG.CodFam
                      BY MATG.OrdLis:
      
      IF FIRST-OF(MATG.CodFam) THEN DO:
         DOWN 1 STREAM REPORT WITH FRAME F-Cab.
         FIND Almtfami WHERE Almtfami.CodCia = s-codcia 
                        AND  Almtfami.codfam = MATG.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN 
            PUT STREAM REPORT CHR(27) + CHR(71) + MATG.CodFam Almtfami.desfam AT 10 CHR(27) + CHR(72).
         DOWN 1 STREAM REPORT WITH FRAME F-Cab.
      END.     
      IF MATG.MonVta = 1 THEN DO:
         x-ctotot1 = MATG.CtoTot.
         x-ctotot2 = ROUND(MATG.CtoTot / FacCfgGn.Tpocmb[1], 2).
         IF MATG.AftIgv THEN DO:
            x-ctotot1 = x-ctotot1 / ( 1 + FacCfgGn.PorIgv / 100 ).
            x-ctotot2 = x-ctotot2 / ( 1 + FacCfgGn.PorIgv / 100 ).
         END.
         x-Ctorep1 = x-ctotot1.
         x-Ctorep2 = x-ctotot2.
         IF MATG.Pesmat > 0 THEN DO:
            x-Ctorep1 = ROUND(x-ctotot1 / 1000 * MATG.Pesmat, 2).
            x-Ctorep2 = ROUND(x-ctotot2 / 1000 * MATG.Pesmat, 2).
         END.
         x-Preuni1 = MATG.PreAlt[4].
         x-Preuni2 = ROUND(MATG.PreAlt[4] / FacCfgGn.Tpocmb[1], 2).
         x-prenet1 = ROUND(x-Ctorep1 * (1 + MATG.MrgUti / 100), 2).
         x-prenet2 = ROUND(x-Ctorep2 * (1 + MATG.MrgUti / 100), 2).
         END.
      ELSE DO:
         x-ctotot1 = ROUND(MATG.CtoTot * FacCfgGn.Tpocmb[1], 2).
         x-ctotot2 = MATG.CtoTot.
         IF MATG.AftIgv THEN DO:
            x-ctotot1 = x-ctotot1 / ( 1 + FacCfgGn.PorIgv / 100 ).
            x-ctotot2 = x-ctotot2 / ( 1 + FacCfgGn.PorIgv / 100 ).
         END.
         x-Ctorep1 = x-ctotot1.
         x-Ctorep2 = x-ctotot2.
         IF MATG.Pesmat > 0 THEN DO:
            x-Ctorep1 = ROUND(x-ctotot1 / 1000 * MATG.Pesmat, 2).
            x-Ctorep2 = ROUND(x-ctotot2 / 1000 * MATG.Pesmat, 2).
         END.
         x-Preuni1 = ROUND(MATG.PreAlt[4] * FacCfgGn.Tpocmb[1], 2).
         x-Preuni2 = MATG.PreAlt[4].
         x-prenet1 = ROUND(x-Ctorep1 * (1 + MATG.MrgUti / 100), 2).
         x-prenet2 = ROUND(x-Ctorep2 * (1 + MATG.MrgUti / 100), 2).
      END.

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
          MATG.UndStk
          MATG.Pesmat
          x-Ctotot1   
          x-Ctotot2   
          x-Ctorep1   
          x-Ctorep2   
          x-Preuni1   
          x-Preuni2   
          MATG.PorMax 
          x-prenet1   
          x-prenet2   
          MATG.MrgUti WITH FRAME F-Cab.
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
/*   FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA AND    */
/*                       Almtfami.codfam = Almmmatg.Codfam */
/*                       No-LOCK NO-ERROR.                 */
/*   IF AVAILABLE Almtfami THEN                            */
/*   Almmmatg.TpoCmb = Almtfami.Tpocmb.                    */

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
     FIND MATG WHERE MATG.CodCia = S-CODCIA 
                AND  MATG.CodMat = F-CodMat 
               NO-LOCK NO-ERROR.
     IF AVAILABLE MATG THEN OUTPUT-VAR-1 = ROWID(MATG).
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1 NO-ERROR.
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
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  ENABLE 
      CB-FchMod F-CodMat F-FchDes F-FchHas F-Filtro FILL-IN-Mensaje F-Provee R-Tipo
      WITH FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  RUN Imprime.

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
  ENABLE 
      CB-FchMod F-CodMat F-FchDes F-FchHas F-Filtro FILL-IN-Mensaje F-Provee R-Tipo
      WITH FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
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
 DEF VAR x-Moneda AS INT INIT 0 NO-UNDO.

  ASSIGN x-Moneda = INTEGER(Almmmatg.PreAlt[5]:SCREEN-VALUE IN BROWSE {&browse-name}) NO-ERROR.

  IF NOT (x-Moneda >= 1 AND x-Moneda <= 2 ) THEN DO:
      MESSAGE 'Solo s permiten los siguientes valores.' SKIP
          '1: Soles' SKIP
          '2: Dólares'
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'entry':U TO Almmmatg.PreAlt[5] IN BROWSE {&browse-name}.
      RETURN 'ADM-ERROR'.
  END.
RETURN 'OK'.
  
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
DISABLE 
    CB-FchMod F-CodMat F-FchDes F-FchHas F-Filtro FILL-IN-Mensaje F-Provee R-Tipo
    WITH FRAME {&FRAME-NAME}.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

