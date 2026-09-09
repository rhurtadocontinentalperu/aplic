&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS bTableWin 
/*------------------------------------------------------------------------

  File: adm2\src\browser.w

  Description: SmartDataBrowser Object

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
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

{src/adm2/widgetprto.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS TableIO-Target,Data-Target,Update-Source

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "aplic/pruebas/dcotcreditodet.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES rowObject

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table NroItm codmat ~
(IF Libre_c05 <> '' AND Libre_c05 <> 'OF' THEN Libre_c05 + ' - ' ELSE '') + DesMat @ DesMat ~
DesMar UndVta TipVta CanPed canate PreUni Por_Dsctos1 Por_Dsctos2 ~
Por_Dsctos3 ImpLin PorDto2 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH rowObject NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH rowObject NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table rowObject
&Scoped-define FIRST-TABLE-IN-QUERY-br_table rowObject


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-25 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_ImpBrt FILL-IN_ImpDto ~
FILL-IN_PorIgv FILL-IN_ImpDto2 FILL-IN_Percepcion FILL-IN_ImpTot ~
FILL-IN_ImpExo FILL-IN_ImpVta FILL-IN_ImpIgv FILL-IN-Peso FILL-IN-Volumen ~
FILL-IN_Import2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-Peso AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Peso (kg)" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Volumen AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Volumen (m3)" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpBrt AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99" INITIAL 0 
     LABEL "IMPORTE BRUTO" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 1 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_ImpDto AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "DESCUENTO DETALLE" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpDto2 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99" INITIAL 0 
     LABEL "DESCUENTO FINAL" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 1 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_ImpExo AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99" INITIAL 0 
     LABEL "IMPORTE EXONERADO" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 1 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_ImpIgv AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99" INITIAL 0 
     LABEL "IMPORTE IGV" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 1 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_Import2 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99" INITIAL 0 
     LABEL "REDONDEO" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 1 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_ImpTot AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99" INITIAL 0 
     LABEL "IMPORTE TOTAL" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 1 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_ImpVta AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99" INITIAL 0 
     LABEL "VALOR VENTA" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 1 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_Percepcion AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "PERCEPCION" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 12 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN_PorIgv AS DECIMAL FORMAT "->>9.99" INITIAL 0 
     LABEL "% I.G.V." 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .81
     BGCOLOR 1 FGCOLOR 15 .

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 144 BY 2.69.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE TEMP-TABLE RowObject NO-UNDO
    {{&DATA-FIELD-DEFS}}
    {src/adm2/robjflds.i}.

DEFINE QUERY br_table FOR 
      rowObject SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table bTableWin _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      NroItm COLUMN-LABEL "No" FORMAT ">>9":U WIDTH 3.43
      codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U WIDTH 6.43
      (IF Libre_c05 <> '' AND Libre_c05 <> 'OF' THEN Libre_c05 + ' - ' ELSE '') + DesMat @ DesMat COLUMN-LABEL "Descripción"
            WIDTH 43.43
      DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 9.43
      UndVta COLUMN-LABEL "Unidad" FORMAT "x(8)":U
      TipVta COLUMN-LABEL "L" FORMAT "X(1)":U WIDTH 1.86
      CanPed COLUMN-LABEL "Cantidad!Aprobada" FORMAT ">,>>>,>>9.9999":U
            WIDTH 7.43
      canate COLUMN-LABEL "Cantidad!Atendida" FORMAT ">,>>>,>>9.9999":U
            WIDTH 7.43
      PreUni COLUMN-LABEL "Precio!Unitario" FORMAT ">,>>>,>>9.99999":U
            WIDTH 8.43
      Por_Dsctos1 COLUMN-LABEL "% Dscto!Admins" FORMAT "->>9.99":U
            WIDTH 6.43
      Por_Dsctos2 COLUMN-LABEL "% Dscto!Evento" FORMAT "->>9.99":U
            WIDTH 5.43
      Por_Dsctos3 COLUMN-LABEL "% Dscto!Vol/Prom" FORMAT "->>9.99":U
            WIDTH 6.43
      ImpLin FORMAT "->>,>>>,>>9.99":U WIDTH 10.43
      PorDto2 COLUMN-LABEL "Otros!Descuentos" FORMAT ">>9.99":U
            WIDTH 8.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN NO-AUTO-VALIDATE NO-ROW-MARKERS SEPARATORS SIZE 144 BY 11.31
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1 WIDGET-ID 200
     FILL-IN_ImpBrt AT ROW 12.5 COL 22 COLON-ALIGNED WIDGET-ID 46
     FILL-IN_ImpDto AT ROW 12.5 COL 52 COLON-ALIGNED WIDGET-ID 48
     FILL-IN_PorIgv AT ROW 12.5 COL 79 COLON-ALIGNED WIDGET-ID 64
     FILL-IN_ImpDto2 AT ROW 12.5 COL 129 COLON-ALIGNED WIDGET-ID 50
     FILL-IN_Percepcion AT ROW 12.54 COL 102 COLON-ALIGNED WIDGET-ID 62
     FILL-IN_ImpTot AT ROW 13.27 COL 129 COLON-ALIGNED WIDGET-ID 58
     FILL-IN_ImpExo AT ROW 13.31 COL 22 COLON-ALIGNED WIDGET-ID 52
     FILL-IN_ImpVta AT ROW 13.31 COL 52 COLON-ALIGNED WIDGET-ID 60
     FILL-IN_ImpIgv AT ROW 13.31 COL 79 COLON-ALIGNED WIDGET-ID 54
     FILL-IN-Peso AT ROW 14.04 COL 52 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-Volumen AT ROW 14.04 COL 79 COLON-ALIGNED WIDGET-ID 44
     FILL-IN_Import2 AT ROW 14.04 COL 129 COLON-ALIGNED WIDGET-ID 56
     RECT-25 AT ROW 12.31 COL 1 WIDGET-ID 66
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataBrowser
   Data Source: "aplic\pruebas\dcotcreditodet.w"
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: Neither
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
  CREATE WINDOW bTableWin ASSIGN
         HEIGHT             = 15.15
         WIDTH              = 146.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB bTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW bTableWin
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Peso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Volumen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpBrt IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpDto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpDto2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpExo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Import2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Percepcion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_PorIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "rowObject"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > _<SDO>.rowObject.NroItm
"NroItm" "No" ? "integer" ? ? ? ? ? ? no "?" no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > _<SDO>.rowObject.codmat
"codmat" "Articulo" ? "character" ? ? ? ? ? ? no "?" no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"(IF Libre_c05 <> '' AND Libre_c05 <> 'OF' THEN Libre_c05 + ' - ' ELSE '') + DesMat @ DesMat" "Descripción" ? ? ? ? ? ? ? ? no ? no no "43.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > _<SDO>.rowObject.DesMar
"DesMar" "Marca" ? "character" ? ? ? ? ? ? no "?" no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > _<SDO>.rowObject.UndVta
"UndVta" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > _<SDO>.rowObject.TipVta
"TipVta" "L" ? "character" ? ? ? ? ? ? no "?" no no "1.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > _<SDO>.rowObject.CanPed
"CanPed" "Cantidad!Aprobada" ? "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > _<SDO>.rowObject.canate
"canate" "Cantidad!Atendida" ? "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > _<SDO>.rowObject.PreUni
"PreUni" "Precio!Unitario" ? "decimal" ? ? ? ? ? ? no "?" no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > _<SDO>.rowObject.Por_Dsctos1
"Por_Dsctos1" "% Dscto!Admins" ? "decimal" ? ? ? ? ? ? no "?" no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > _<SDO>.rowObject.Por_Dsctos2
"Por_Dsctos2" "% Dscto!Evento" ? "decimal" ? ? ? ? ? ? no "?" no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > _<SDO>.rowObject.Por_Dsctos3
"Por_Dsctos3" "% Dscto!Vol/Prom" ? "decimal" ? ? ? ? ? ? no "?" no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > _<SDO>.rowObject.ImpLin
"ImpLin" ? ? "decimal" ? ? ? ? ? ? no "?" no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > _<SDO>.rowObject.PorDto2
"PorDto2" "Otros!Descuentos" ? "decimal" ? ? ? ? ? ? no "?" no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON CTRL-END OF br_table IN FRAME F-Main
DO:
  APPLY "END":U TO BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON CTRL-HOME OF br_table IN FRAME F-Main
DO:
  APPLY "HOME":U TO BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON DEFAULT-ACTION OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsdefault.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON END OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsend.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON HOME OF br_table IN FRAME F-Main
DO:
  {src/adm2/brshome.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON OFF-END OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsoffnd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON OFF-HOME OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsoffhm.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON SCROLL-NOTIFY OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsscrol.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  {src/adm2/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK bTableWin 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN initializeObject.        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI bTableWin  _DEFAULT-DISABLE
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

