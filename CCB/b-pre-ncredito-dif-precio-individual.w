&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-CcbDDocu NO-UNDO LIKE CcbDDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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

&SCOPED-DEFINE ARITMETICA-SUNAT YES

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VAR x-value AS CHAR.
DEFINE VAR x-mostrar AS INT INIT 1.
DEFINE VAR x-moneda AS CHAR NO-UNDO.

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR x-tipo AS CHAR.       /* Concepto de la N/C */

DEF VAR s-coddoc AS CHAR INIT 'PNC'.

&SCOPED-DEFINE CONDICION ( ~
            ( x-mostrar = 1) OR  ~
            ( x-mostrar = 2 AND tt-ccbddocu.aftisc = YES) OR ~
            ( x-mostrar = 3 AND tt-ccbddocu.aftisc = NO))

DEFINE TEMP-TABLE ttNCItems
    FIELD   tcodmat     AS  CHAR
    FIELD   tcant       AS  DEC INIT 0
    FIELD   timplin     AS  DEC INIT 0.

DEFINE VAR x-total-a-descontar AS DEC INIT 0.

DEFINE VAR x-old-sele AS CHAR.
DEFINE VAR x-item AS INT.
DEFINE VAR x-documento AS CHAR.

/*  */
DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-ccbddocu FOR ccbddocu.
DEFINE BUFFER b-vtatabla FOR vtatabla.


/* Partes de Ingreso Pendientes */
/* Se usa en : ccb/d-inconsistencias-pnc.r */
DEFINE TEMP-TABLE tt-pi-pendiente
    FIELD   ttipo       AS  CHAR
    FIELD   tcodalm     AS  CHAR
    FIELD   tserie      AS  INT     INIT 0
    FIELD   tnrodoc     AS  INT     INIT 0
    FIELD   tfchdoc     AS  DATE
    FIELD   ttabla      AS  CHAR
    FIELD   tcodmat     AS  CHAR
    FIELD   tmsgerror   AS  CHAR.

/*  */
DEFINE TEMP-TABLE tt-conceptos
    FIELD   llave-c     AS  CHAR.


/* Indica cual es el maximo que un articulo usar en una N/C o PNC */
DEFINE VAR x-tolerancia-nc-pnc-articulo AS INT INIT 0.

DEFINE BUFFER x-tt-ccbddocu FOR tt-ccbddocu.

DEFINE VAR x-fld-dscto-acumulado AS DEC INIT 0.

/* DEFINE VAR x-nueva-arimetica-sunat-2021 AS LOG. */
/*                                                 */
/* x-nueva-arimetica-sunat-2021 = YES.             */

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES gn-clie
&Scoped-define FIRST-EXTERNAL-TABLE gn-clie


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-clie.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-CcbDDocu Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table tt-CcbDDocu.AftIsc ~
tt-CcbDDocu.NroItm tt-CcbDDocu.codmat Almmmatg.DesMat Almmmatg.DesMar ~
tt-CcbDDocu.UndVta tt-CcbDDocu.CanDes tt-CcbDDocu.PreBas ~
tt-CcbDDocu.Dcto_Otros_Factor tt-CcbDDocu.Dcto_Otros_VV ~
tt-CcbDDocu.Dcto_Otros_PV tt-CcbDDocu.PreUni tt-CcbDDocu.ImpLin ~
tt-CcbDDocu.ImpDto ~
fDsctoAcumulado(tt-CcbDDocu.Pesmat,tt-CcbDDocu.PreUni) @ x-fld-dscto-acumulado ~
tt-CcbDDocu.ImpDto2 tt-CcbDDocu.Pesmat tt-CcbDDocu.Por_Dsctos[1] ~
tt-CcbDDocu.CanDev tt-CcbDDocu.ImpIsc 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table tt-CcbDDocu.Por_Dsctos[1] ~
tt-CcbDDocu.CanDev 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table tt-CcbDDocu
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table tt-CcbDDocu
&Scoped-define QUERY-STRING-br_table FOR EACH tt-CcbDDocu WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK, ~
      EACH Almmmatg OF tt-CcbDDocu NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH tt-CcbDDocu WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK, ~
      EACH Almmmatg OF tt-CcbDDocu NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table tt-CcbDDocu Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table tt-CcbDDocu
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON-8 BUTTON-9 RADIO-SET-mostrar ~
BUTTON-32 FILL-IN-factor BUTTON-10 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-moneda RADIO-SET-mostrar ~
FILL-IN-importe FILL-IN-factor FILL-IN-totaldscto 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDsctoAcumulado B-table-Win 
FUNCTION fDsctoAcumulado RETURNS DECIMAL
  ( pPrecioConDsctos AS DEC, pPrecioVentaFacturado AS DEC )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-10 
     LABEL "Aplicar" 
     SIZE 7 BY .96
     FONT 4.

DEFINE BUTTON BUTTON-31 
     LABEL "Buscar" 
     SIZE 12 BY .77.

DEFINE BUTTON BUTTON-32 
     LABEL "Generar la PRE-NOTA DE CREDITO" 
     SIZE 34 BY 1.12.

DEFINE BUTTON BUTTON-7 
     LABEL "Exportar a Excel" 
     SIZE 17 BY 1.12.

DEFINE BUTTON BUTTON-8 
     LABEL "Marcar todos" 
     SIZE 12 BY .96
     FONT 4.

DEFINE BUTTON BUTTON-9 
     LABEL "Desmarcar todos" 
     SIZE 14.14 BY .96
     FONT 4.

DEFINE VARIABLE FILL-IN-codmat AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .85 NO-UNDO.

DEFINE VARIABLE FILL-IN-factor AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "% Descuento a aplicar" 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-importe AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Importe Total" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .96
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-moneda AS CHARACTER FORMAT "X(10)":U 
     LABEL "Moneda" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .96
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-totaldscto AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Total del descuento (S/)" 
     VIEW-AS FILL-IN 
     SIZE 19 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 11 NO-UNDO.

DEFINE VARIABLE RADIO-SET-mostrar AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Solo seleccionados", 2,
"Solo NO seleccionados", 3
     SIZE 45.43 BY .96
     FONT 4 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      tt-CcbDDocu, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      tt-CcbDDocu.AftIsc COLUMN-LABEL "Sele" FORMAT "Si/No":U WIDTH 3.14
            VIEW-AS TOGGLE-BOX
      tt-CcbDDocu.NroItm COLUMN-LABEL "Item" FORMAT ">>9":U WIDTH 3.43
      tt-CcbDDocu.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U
            WIDTH 6.57
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 28.29 COLUMN-FONT 3
      Almmmatg.DesMar FORMAT "X(30)":U WIDTH 14.29
      tt-CcbDDocu.UndVta FORMAT "x(8)":U WIDTH 4.57
      tt-CcbDDocu.CanDes FORMAT ">,>>>,>>9.99":U WIDTH 8.43 COLUMN-BGCOLOR 8
      tt-CcbDDocu.PreBas COLUMN-LABEL "P.Uni.!Base" FORMAT ">,>>>,>>9.9999":U
            WIDTH 8.57
      tt-CcbDDocu.Dcto_Otros_Factor COLUMN-LABEL "%Dscto!Manual" FORMAT "->>9.9999":U
            WIDTH 5.43
      tt-CcbDDocu.Dcto_Otros_VV COLUMN-LABEL "%Dscto!Evento" FORMAT "->>9.9999":U
            WIDTH 6.43
      tt-CcbDDocu.Dcto_Otros_PV COLUMN-LABEL "%Dscto!Vol/Prom" FORMAT "->>9.9999":U
            WIDTH 6.29
      tt-CcbDDocu.PreUni COLUMN-LABEL "P.Uni!Vta" FORMAT ">,>>>,>>9.9999":U
            WIDTH 8.43 COLUMN-BGCOLOR 8
      tt-CcbDDocu.ImpLin COLUMN-LABEL "Impte!Vta" FORMAT "->>,>>>,>>9.99":U
            WIDTH 9 COLUMN-BGCOLOR 8
      tt-CcbDDocu.ImpDto COLUMN-LABEL "Dsctos N/C!Acumu" FORMAT ">,>>>,>>9.9999":U
            WIDTH 8.43 COLUMN-FGCOLOR 12 COLUMN-BGCOLOR 15
      fDsctoAcumulado(tt-CcbDDocu.Pesmat,tt-CcbDDocu.PreUni) @ x-fld-dscto-acumulado COLUMN-LABEL "%Dscto N/C!Acumulado" FORMAT "->,>>9.9999":U
            WIDTH 7.86 COLUMN-FGCOLOR 12
      tt-CcbDDocu.ImpDto2 COLUMN-LABEL "Impte.Vta!Final" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 7.43 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 14
      tt-CcbDDocu.Pesmat COLUMN-LABEL "P.Uni!Actual" FORMAT "->>,>>9.9999":U
            WIDTH 7.57 COLUMN-BGCOLOR 14
      tt-CcbDDocu.Por_Dsctos[1] COLUMN-LABEL "Nuevo!Precio" FORMAT "->>,>>9.9999":U
            WIDTH 9.29 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 15
      tt-CcbDDocu.CanDev COLUMN-LABEL "% Dscto" FORMAT ">>9.9999":U
            WIDTH 6.29 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 15
      tt-CcbDDocu.ImpIsc COLUMN-LABEL "Impte Dscto" FORMAT ">,>>>,>>9.99":U
            WIDTH 8.72 COLUMN-BGCOLOR 10
  ENABLE
      tt-CcbDDocu.Por_Dsctos[1]
      tt-CcbDDocu.CanDev
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 184.72 BY 13.81
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 2.19 COL 1.29
     BUTTON-8 AT ROW 17.35 COL 2.86 WIDGET-ID 4
     FILL-IN-moneda AT ROW 1.12 COL 7.86 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-codmat AT ROW 18.62 COL 8.29 COLON-ALIGNED WIDGET-ID 16
     BUTTON-9 AT ROW 17.35 COL 16 WIDGET-ID 6
     BUTTON-31 AT ROW 18.65 COL 20 WIDGET-ID 18
     RADIO-SET-mostrar AT ROW 17.38 COL 31.57 NO-LABEL WIDGET-ID 12
     FILL-IN-importe AT ROW 1.12 COL 36 COLON-ALIGNED WIDGET-ID 24
     BUTTON-32 AT ROW 18.54 COL 89 WIDGET-ID 20
     FILL-IN-factor AT ROW 17.46 COL 105.14 COLON-ALIGNED WIDGET-ID 8
     BUTTON-10 AT ROW 17.35 COL 116.72 WIDGET-ID 10
     FILL-IN-totaldscto AT ROW 16.19 COL 122.14 COLON-ALIGNED WIDGET-ID 26
     BUTTON-7 AT ROW 17.5 COL 125.57 WIDGET-ID 2
     "DobleClick para seleccionar" VIEW-AS TEXT
          SIZE 26 BY .62 AT ROW 16.19 COL 9 WIDGET-ID 28
          FGCOLOR 9 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.gn-clie
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-CcbDDocu T "?" NO-UNDO INTEGRAL CcbDDocu
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
         HEIGHT             = 18.88
         WIDTH              = 185.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R,COLUMNS                    */
/* BROWSE-TAB br_table TEXT-1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-31 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-31:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-7 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-7:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-codmat IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-codmat:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-importe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-moneda IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-totaldscto IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.tt-CcbDDocu,INTEGRAL.Almmmatg OF Temp-Tables.tt-CcbDDocu"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   > Temp-Tables.tt-CcbDDocu.AftIsc
"tt-CcbDDocu.AftIsc" "Sele" ? "logical" ? ? ? ? ? ? no ? no no "3.14" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-CcbDDocu.NroItm
"tt-CcbDDocu.NroItm" "Item" ? "integer" ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-CcbDDocu.codmat
"tt-CcbDDocu.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "6.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? 3 ? ? ? no ? no no "28.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" ? ? "character" ? ? ? ? ? ? no ? no no "14.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-CcbDDocu.UndVta
"tt-CcbDDocu.UndVta" ? ? "character" ? ? ? ? ? ? no ? no no "4.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-CcbDDocu.CanDes
"tt-CcbDDocu.CanDes" ? ">,>>>,>>9.99" "decimal" 8 ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-CcbDDocu.PreBas
"tt-CcbDDocu.PreBas" "P.Uni.!Base" ? "decimal" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-CcbDDocu.Dcto_Otros_Factor
"tt-CcbDDocu.Dcto_Otros_Factor" "%Dscto!Manual" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-CcbDDocu.Dcto_Otros_VV
"tt-CcbDDocu.Dcto_Otros_VV" "%Dscto!Evento" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-CcbDDocu.Dcto_Otros_PV
"tt-CcbDDocu.Dcto_Otros_PV" "%Dscto!Vol/Prom" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no "6.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-CcbDDocu.PreUni
"tt-CcbDDocu.PreUni" "P.Uni!Vta" ">,>>>,>>9.9999" "decimal" 8 ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tt-CcbDDocu.ImpLin
"tt-CcbDDocu.ImpLin" "Impte!Vta" ? "decimal" 8 ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.tt-CcbDDocu.ImpDto
"tt-CcbDDocu.ImpDto" "Dsctos N/C!Acumu" ? "decimal" 15 12 ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"fDsctoAcumulado(tt-CcbDDocu.Pesmat,tt-CcbDDocu.PreUni) @ x-fld-dscto-acumulado" "%Dscto N/C!Acumulado" "->,>>9.9999" ? ? 12 ? ? ? ? no ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.tt-CcbDDocu.ImpDto2
"tt-CcbDDocu.ImpDto2" "Impte.Vta!Final" ? "decimal" 14 9 ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.tt-CcbDDocu.Pesmat
"tt-CcbDDocu.Pesmat" "P.Uni!Actual" ? "decimal" 14 ? ? ? ? ? no ? no no "7.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.tt-CcbDDocu.Por_Dsctos[1]
"tt-CcbDDocu.Por_Dsctos[1]" "Nuevo!Precio" "->>,>>9.9999" "decimal" 15 9 ? ? ? ? yes ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.tt-CcbDDocu.CanDev
"tt-CcbDDocu.CanDev" "% Dscto" ">>9.9999" "decimal" 15 9 ? ? ? ? yes ? no no "6.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > Temp-Tables.tt-CcbDDocu.ImpIsc
"tt-CcbDDocu.ImpIsc" "Impte Dscto" ">,>>>,>>9.99" "decimal" 10 ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ITERATION-CHANGED OF br_table IN FRAME F-Main
DO:
  .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON LEFT-MOUSE-DBLCLICK OF br_table IN FRAME F-Main
DO:


    DEFINE VAR x-dato AS CHAR.
    DEFINE VAR x-current-sele AS CHAR.
    
    DEFINE VAR x-nuevo-dato AS DEC.
    DEFINE VAR x-pdscto AS DEC.
    DEFINE VAR x-oldvalue AS DEC.

    x-current-sele = tt-ccbddocu.aftisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    x-dato = tt-ccbddocu.impisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

    IF x-current-sele = 'Si' THEN DO:
        ASSIGN tt-ccbddocu.por_dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "0.0000".
        ASSIGN tt-ccbddocu.candev:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "0.0000".
        ASSIGN tt-ccbddocu.impisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "0.00".
        ASSIGN tt-ccbddocu.aftisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "no".
        ASSIGN tt-ccbddocu.aftisc = NO.

        ASSIGN tt-ccbddocu.por_dsctos[1] = 0
                tt-ccbddocu.candev = 0
                tt-ccbddocu.impisc = 0.

        x-total-a-descontar = x-total-a-descontar - DEC(x-dato).
    END.
    ELSE DO:        
        ASSIGN tt-ccbddocu.aftisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "yes".
        ASSIGN tt-ccbddocu.aftisc = YES.            
    END.
    br_table:REFRESH() IN FRAME {&FRAME-NAME}.

    RUN total-a-descontar.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

    FIND FIRST tt-ccbddocu NO-LOCK NO-ERROR.
   IF AVAILABLE tt-ccbddocu THEN br_table:REFRESH() IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}

   /* br_table:REFRESH() IN FRAME {&FRAME-NAME}.*/
      x-value = tt-ccbddocu.impisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
      x-old-sele = tt-ccbddocu.aftisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
      x-item = INTEGER(tt-ccbddocu.nroitm:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-CcbDDocu.AftIsc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-CcbDDocu.AftIsc br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF tt-CcbDDocu.AftIsc IN BROWSE br_table /* Sele */
DO:
  
  x-value = tt-ccbddocu.impisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  x-old-sele = SELF:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  x-item = INTEGER(tt-ccbddocu.nroitm:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-CcbDDocu.AftIsc br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF tt-CcbDDocu.AftIsc IN BROWSE br_table /* Sele */
DO:
    /*
    DEFINE VAR x-dato AS CHAR.
    DEFINE VAR x-current-sele AS CHAR.
    
    DEFINE VAR x-nuevo-dato AS DEC.
    DEFINE VAR x-pdscto AS DEC.
    DEFINE VAR x-oldvalue AS DEC.

    x-current-sele = SELF:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    x-dato = tt-ccbddocu.impisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

    IF x-current-sele <> x-old-sele THEN DO:       

        IF x-old-sele = 'Si' THEN DO:
            ASSIGN tt-ccbddocu.por_dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "0.0000".
            ASSIGN tt-ccbddocu.candev:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "0.0000".
            ASSIGN tt-ccbddocu.impisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "0.00".

            ASSIGN tt-ccbddocu.por_dsctos[1] = 0
                    tt-ccbddocu.candev = 0
                    tt-ccbddocu.impisc = 0.

            x-total-a-descontar = x-total-a-descontar - DEC(x-dato).
        END.
        

        RUN total-a-descontar.

    END.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-CcbDDocu.AftIsc br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-CLICK OF tt-CcbDDocu.AftIsc IN BROWSE br_table /* Sele */
DO:
    DEFINE VAR x-dato AS CHAR.
    /*
    x-dato = tt-ccbddocu.impisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

    ASSIGN tt-ccbddocu.por_dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "0.0000".
    ASSIGN tt-ccbddocu.candev:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "0.0000".
    ASSIGN tt-ccbddocu.impisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "0.00".

    ASSIGN tt-ccbddocu.por_dsctos[1] = 0
            tt-ccbddocu.candev = 0
            tt-ccbddocu.impisc = 0.


    x-total-a-descontar = x-total-a-descontar - DEC(x-dato).

    RUN total-a-descontar.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-CcbDDocu.Por_Dsctos[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-CcbDDocu.Por_Dsctos[1] br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF tt-CcbDDocu.Por_Dsctos[1] IN BROWSE br_table /* Nuevo!Precio */
DO:
  x-value = tt-ccbddocu.por_dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-CcbDDocu.Por_Dsctos[1] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF tt-CcbDDocu.Por_Dsctos[1] IN BROWSE br_table /* Nuevo!Precio */
DO:
    DEFINE VAR x-dato AS CHAR.

    DEFINE VAR x-nuevo-imptedscto AS DEC.
    DEFINE VAR x-old-imptedscto AS DEC.

    DEFINE VAR x-nuevo-precio AS DEC.
    DEFINE VAR x-old-precio AS DEC.
    DEFINE VAR x-pdscto AS DEC.
    DEFINE VAR x-qty AS DEC.

    x-dato = tt-ccbddocu.por_dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

    IF x-dato <> x-value THEN DO:
        
        x-old-imptedscto = DEC(tt-ccbddocu.impisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        x-old-precio = DEC(tt-ccbddocu.pesmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        x-nuevo-precio = DEC(x-dato).

        IF x-nuevo-precio >= x-old-precio THEN DO:
            /* ERROR : El nuevo precio esta por encima */
            ASSIGN tt-ccbddocu.por_dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = x-value.     
        END.
        ELSE DO:
            x-pdscto = 1 - ROUND((x-nuevo-precio / x-old-precio),4).
            IF x-nuevo-precio = 0 THEN DO:
                x-pdscto = 0.
                x-old-precio = 0.
            END.
            
            ASSIGN tt-ccbddocu.candev:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(x-pdscto * 100,">,>>9.9999").     

            x-qty = DEC(tt-ccbddocu.candes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

            x-nuevo-imptedscto = ROUND( ((x-old-precio - x-nuevo-precio) * x-qty) , 2).
            tt-ccbddocu.impisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(x-nuevo-imptedscto,">>>,>>9.99").   

            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.candev = x-pdscto
                    {&FIRST-TABLE-IN-QUERY-br_table}.impisc = x-nuevo-imptedscto.

            IF x-pdscto = 0 THEN DO:
                ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc:SCREEN-VALUE IN BROWSE br_table = "NO".
                ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc = NO.
            END.
            ELSE DO:
                ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc:SCREEN-VALUE IN BROWSE br_table = "YES".
                ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc = YES.
            END.

            x-total-a-descontar = x-total-a-descontar - DECIMAL(x-old-imptedscto) + x-nuevo-imptedscto.

            RUN total-a-descontar.

            APPLY 'TAB':U TO {&FIRST-TABLE-IN-QUERY-br_table}.por_dsctos[1] IN BROWSE {&BROWSE-NAME}.

        END.



        /*
        IF x-idscto > DEC(tt-ccbddocu.impdto2:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})  THEN DO:
            tt-ccbddocu.impisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = x-value.     
        END.
        ELSE DO:
            x-nuevo-dato = ROUND(x-idscto / tt-ccbddocu.impdto2,4) * 100.
            tt-ccbddocu.candev:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(x-nuevo-dato,">>>,>>9.9999").     

            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.candev = x-nuevo-dato.

            IF x-idscto = 0 THEN DO:
                ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc:SCREEN-VALUE IN BROWSE br_table = "NO".
                ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc = NO.
            END.
            ELSE DO:
                ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc:SCREEN-VALUE IN BROWSE br_table = "YES".
                ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc = YES.
            END.

            x-total-a-descontar = x-total-a-descontar - DECIMAL(x-value) + x-idscto.

            RUN total-a-descontar.

            APPLY 'TAB':U TO {&FIRST-TABLE-IN-QUERY-br_table}.impisc IN BROWSE {&BROWSE-NAME}.
        END.
        */
    END.           
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-CcbDDocu.CanDev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-CcbDDocu.CanDev br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF tt-CcbDDocu.CanDev IN BROWSE br_table /* % Dscto */
DO:

  x-value = tt-ccbddocu.candev:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-CcbDDocu.CanDev br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF tt-CcbDDocu.CanDev IN BROWSE br_table /* % Dscto */
DO:
    DEFINE VAR x-dato AS CHAR.
    DEFINE VAR x-nuevo-porcentaje AS DEC.
    DEFINE VAR x-pdscto AS DEC.

    DEFINE VAR x-old-imptedscto AS DEC.
    DEFINE VAR x-nuevo-imptedscto AS DEC.

    DEFINE VAR x-precio-vendido AS DEC.
    DEFINE VAR x-precio AS DEC.
    DEFINE VAR x-qty AS DEC.

    x-dato = tt-ccbddocu.candev:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

    IF x-dato <> x-value THEN DO:       

        x-pdscto = DEC(x-dato).

        IF x-pdscto > 100 THEN DO:
            tt-ccbddocu.candev:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = x-value.
        END.
        ELSE DO:

            x-old-imptedscto = DEC(tt-ccbddocu.impisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
            x-precio-vendido = DEC(tt-ccbddocu.pesmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
            x-qty = DEC(tt-ccbddocu.candes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

            x-precio = ROUND(x-precio-vendido * (x-pdscto / 100),4).                        
            x-nuevo-imptedscto = ROUND(x-precio * x-qty,2).

            IF x-precio = 0 THEN DO:
                x-precio-vendido = 0.
            END.
            
            tt-ccbddocu.por_dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(x-precio-vendido - x-precio,"->,>>9.9999").
            tt-ccbddocu.impisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(x-nuevo-imptedscto,">>>,>>9.99").   

            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.impisc = x-nuevo-imptedscto.
            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.por_dsctos[1] = x-precio-vendido - x-precio.

            IF x-pdscto = 0 THEN DO:
                ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc:SCREEN-VALUE IN BROWSE br_table = "NO".
                ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc = NO.                
            END.
            ELSE DO:
                ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc:SCREEN-VALUE IN BROWSE br_table = "YES".
                ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc = YES.
            END.

            x-total-a-descontar = x-total-a-descontar - x-old-imptedscto + x-nuevo-imptedscto.

            RUN total-a-descontar.
        END.

        APPLY 'TAB':U TO {&FIRST-TABLE-IN-QUERY-br_table}.candev IN BROWSE {&BROWSE-NAME}.
    END.

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 B-table-Win
ON CHOOSE OF BUTTON-10 IN FRAME F-Main /* Aplicar */
DO:
  ASSIGN fill-in-factor.

  IF fill-in-factor < 0 OR fill-in-factor > 100 THEN DO:
      MESSAGE "% Descuento errado" VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.

  DEFINE VAR x-precio-vendido AS DEC.
  DEFINE VAR x-precio AS DEC.
  DEFINE VAR x-qty AS DEC.
  DEFINE VAR x-nuevo-imptedscto AS DEC.

  x-total-a-descontar = 0.

  DEFINE VAR x-nuevo-dato AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        GET FIRST br_table.
        DO  WHILE AVAILABLE tt-ccbddocu  :
            IF {&FIRST-TABLE-IN-QUERY-br_table}.aftisc = YES THEN DO:

                x-precio-vendido = {&FIRST-TABLE-IN-QUERY-br_table}.pesmat.
                x-precio = ROUND(x-precio-vendido * (fill-in-factor / 100),4).
                x-qty = {&FIRST-TABLE-IN-QUERY-br_table}.candes.

                x-nuevo-imptedscto = ROUND(x-precio * x-qty,2).

                IF x-precio = 0 THEN DO:
                    x-precio-vendido = 0.
                END.

                ASSIGN tt-ccbddocu.impisc = x-nuevo-imptedscto.
                ASSIGN tt-ccbddocu.por_dsctos[1] = x-precio-vendido - x-precio.
                ASSIGN tt-ccbddocu.candev = fill-in-factor.
                
                x-total-a-descontar = x-total-a-descontar + x-nuevo-imptedscto.
                
            END.
            GET NEXT br_table.
        END.
    END.

    RUN total-a-descontar.

    {&open-query-br_table}


END.
/*
    x-old-imptedscto = DEC(tt-ccbddocu.impisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    x-precio-vendido = DEC(tt-ccbddocu.pesmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    x-qty = DEC(tt-ccbddocu.candes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

    x-precio = ROUND(x-precio-vendido * (x-pdscto / 100),4).                        
    x-nuevo-imptedscto = ROUND(x-precio * x-qty,2).

    IF x-precio = 0 THEN DO:
        x-precio-vendido = 0.
    END.

    tt-ccbddocu.por_dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(x-precio-vendido - x-precio,"->,>>9.9999").
    tt-ccbddocu.impisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(x-nuevo-imptedscto,">>>,>>9.99").   

    ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.impisc = x-nuevo-imptedscto.
    ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.por_dsctos[1] = x-precio-vendido - x-precio.

    IF x-pdscto = 0 THEN DO:
        ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc:SCREEN-VALUE IN BROWSE br_table = "NO".
        ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc = NO.                
    END.
    ELSE DO:
        ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc:SCREEN-VALUE IN BROWSE br_table = "YES".
        ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc = YES.
    END.


/* -------------------------------------- */

    x-dato = tt-ccbddocu.por_dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

    IF x-dato <> x-value THEN DO:
        
        x-old-imptedscto = DEC(tt-ccbddocu.impisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        x-old-precio = DEC(tt-ccbddocu.pesmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        x-nuevo-precio = DEC(x-dato).


    x-pdscto = 1 - ROUND((x-nuevo-precio / x-old-precio),4).
    IF x-nuevo-precio = 0 THEN DO:
        x-pdscto = 0.
        x-old-precio = 0.
    END.

    ASSIGN tt-ccbddocu.candev:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(x-pdscto * 100,">,>>9.9999").     

    x-qty = DEC(tt-ccbddocu.candes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).

    x-nuevo-imptedscto = ROUND( ((x-old-precio - x-nuevo-precio) * x-qty) , 2).
    tt-ccbddocu.impisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(x-nuevo-imptedscto,">>>,>>9.99").   

    ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.candev = x-pdscto
            {&FIRST-TABLE-IN-QUERY-br_table}.impisc = x-nuevo-imptedscto.

    IF x-pdscto = 0 THEN DO:
        ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc:SCREEN-VALUE IN BROWSE br_table = "NO".
        ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc = NO.
    END.
    ELSE DO:
        ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc:SCREEN-VALUE IN BROWSE br_table = "YES".
        ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc = YES.
    END.

    x-total-a-descontar = x-total-a-descontar - DECIMAL(x-old-imptedscto) + x-nuevo-imptedscto.

    RUN total-a-descontar.

    APPLY 'TAB':U TO {&FIRST-TABLE-IN-QUERY-br_table}.por_dsctos[1] IN BROWSE {&BROWSE-NAME}.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-32
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-32 B-table-Win
ON CHOOSE OF BUTTON-32 IN FRAME F-Main /* Generar la PRE-NOTA DE CREDITO */
DO:
  FIND FIRST tt-ccbddocu WHERE tt-ccbddocu.aftisc = YES NO-LOCK NO-ERROR.
  IF NOT AVAILABLE tt-ccbddocu THEN DO:
      MESSAGE "Debe seleccionar al menos un articulo" VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.

  DEFINE BUFFER x-tt-ccbddocu FOR tt-ccbddocu.

  DEFINE VAR x-suma-importe AS DEC INIT 0.
  DEFINE VAR x-conteo AS INT INIT 0.
  DEFINE VAR x-impte-cmpte-referenciado AS DEC.

  FOR EACH x-tt-ccbddocu WHERE x-tt-ccbddocu.aftisc = YES AND x-tt-ccbddocu.impisc > 0 NO-LOCK:
        x-suma-importe = x-suma-importe + x-tt-ccbddocu.impisc.
        x-conteo = x-conteo + 1.
  END.

  IF x-suma-importe <= 0 THEN DO:
      MESSAGE "La Pre-Nota debe tener importe mayor a CERO, por favor verifique!!!".
      RETURN NO-APPLY.
  END.

    x-impte-cmpte-referenciado = ccbcdocu.imptot.
    x-impte-cmpte-referenciado = ccbcdocu.TotalPrecioVenta.

    /* Ic - 15Dic2021 - Verificamos si tiene A/C para sacar le importe real del comprobante */
    IF ccbcdocu.imptot2 > 0 THEN DO:
        FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = s-codcia AND
                                        FELogComprobantes.coddoc = ccbcdocu.coddoc AND
                                        FELogComprobantes.nrodoc = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
        IF AVAILABLE FELogComprobantes THEN DO:
            IF NUM-ENTRIES(FELogComprobantes.dataQR,"|") > 5 THEN DO:
                IF x-impte-cmpte-referenciado <= 0 THEN x-impte-cmpte-referenciado = DEC(TRIM(ENTRY(6,FELogComprobantes.dataQR,"|"))).
            END.
        END.
    END.

  /* Validar LIMITE importes */
    DEFINE VAR hxProc AS HANDLE NO-UNDO.                /* Handle Libreria */
    DEFINE VAR x-impte AS DEC.
    
    RUN ccb\libreria-ccb.r PERSISTENT SET hxProc.

    RUN sumar-imptes-nc_ref-cmpte IN hxProc (INPUT "*", /* Algun concepto o todos */
                                            INPUT ccbcdocu.CodDoc,      /* FAC BOL */
                                            INPUT ccbcdocu.NroDoc,
                                            OUTPUT x-impte).
    
    DELETE PROCEDURE hxProc.                    /* Release Libreria */

    IF (x-impte + x-suma-importe) > x-impte-cmpte-referenciado /* ccbcdocu.imptot*/ THEN DO:
        MESSAGE "Existe N/Cs emitidas que la suma de sus" SKIP
            "importes superan al importe del total del comprobante" SKIP
            ccbcdocu.CodDoc + " " + ccbcdocu.NroDoc
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

                                                     

  /* Validar */
  RUN validar-informacion.

  /* Validar que no tenga PI/PNC pendientes */
  FIND FIRST tt-pi-pendiente WHERE tt-pi-pendiente.ttipo = "ERROR" NO-LOCK NO-ERROR.
  IF AVAILABLE tt-pi-pendiente THEN DO:
      RETURN NO-APPLY.
      /*
      FOR EACH x-tt-ccbddocu WHERE x-tt-ccbddocu.aftisc = YES NO-LOCK:
          FIND FIRST tt-pi-pendiente WHERE tt-pi-pendiente.tcodmat = x-tt-ccbddocu.codmat NO-LOCK NO-ERROR.
          IF AVAILABLE tt-pi-pendiente THEN DO:
              MESSAGE "El articulo(" + tt-pi-pendiente.tcodmat + ") tiene " + tt-pi-pendiente.ttabla +  " pendiente"
                    VIEW-AS ALERT-BOX MESSAGE.
              RETURN NO-APPLY.
                    
          END.
      END.
      */
  END.
  
    MESSAGE   'Se va a generar una PRE-NOTA DE CREDITO' SKIP
            'De ' STRING(x-suma-importe,"->,>>>,>>9.99") SKIP
            'con ' + STRING(x-conteo,"->,>>>,>>9") + ' Items' SKIP
            'Esta seguro de generar la PRE NOTA?'       
      VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

    RUN genera-pre-nota.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 B-table-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Marcar todos */
DO:

    DO WITH FRAME {&FRAME-NAME}:
        GET FIRST br_table.
        DO  WHILE AVAILABLE tt-ccbddocu:
            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc:SCREEN-VALUE IN BROWSE br_table = "YES".
            ASSIGN tt-ccbddocu.aftisc = YES.
            GET NEXT br_table.
        END.
    END.

    {&open-query-br_table}

END.

/*
&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 B-table-Win
ON CHOOSE OF BUTTON-9 IN FRAME F-Main /* Desmarcar todos */
DO:

    x-total-a-descontar = 0.

    DO WITH FRAME {&FRAME-NAME}:
        GET FIRST br_table.
        DO  WHILE AVAILABLE tt-ccbddocu:
            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.aftisc:SCREEN-VALUE IN BROWSE br_table = "NO".
            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.por_Dscto[1]:SCREEN-VALUE IN BROWSE br_table = "0.0000".
            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.candev:SCREEN-VALUE IN BROWSE br_table = "0.0000".
            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.impisc:SCREEN-VALUE IN BROWSE br_table = "0.0000".

            ASSIGN tt-ccbddocu.aftisc = NO
                    tt-ccbddocu.candev = 0
                    tt-ccbddocu.impisc = 0
                    tt-ccbddocu.por_dsctos[1].
            GET NEXT br_table.
        END.
    END.

    {&open-query-br_table}

    RUN total-a-descontar.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-mostrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-mostrar B-table-Win
ON VALUE-CHANGED OF RADIO-SET-mostrar IN FRAME F-Main
DO:
  ASSIGN {&self-name}.

  x-mostrar = {&self-name}.

  {&open-query-br_table}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

DEF VAR celda_br AS WIDGET-HANDLE EXTENT 150 NO-UNDO.
 DEF VAR cual_celda AS WIDGET-HANDLE NO-UNDO.
 DEF VAR n_cols_browse AS INT NO-UNDO.
 DEF VAR col_act AS INT NO-UNDO.
 DEF VAR t_col_br AS INT NO-UNDO INITIAL 2.             /* Color del background de la celda ( 2 : Verde, 11 : Celeste)*/
 DEF VAR vg_col_eti_b AS INT NO-UNDO INITIAL 15.        /* Color del la letra de la celda (15 : Blanco, 28 : Blanco) */ 
 DEFINE VAR x-row AS INT.

ON 'RETURN':U OF tt-ccbddocu.aftisc, tt-ccbddocu.por_dsctos[1], tt-ccbddocu.candev IN BROWSE {&BROWSE-NAME} DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

ON ROW-DISPLAY OF br_table DO:
  IF tt-ccbddocu.aftisc <> YES THEN return.

  DO col_act = 1 TO 6 /*n_cols_browse*/.
      
     cual_celda = celda_br[col_act].
     cual_celda:BGCOLOR = t_col_br.
  END.
END.

ON ANY-KEY OF tt-ccbddocu.AftIsc IN BROWSE br_table
DO:

    DEFINE VARIABLE hColumn AS HANDLE      NO-UNDO.
    DEFINE VAR cColumnName AS CHAR.

    ASSIGN hColumn = SELF:HANDLE.
    cColumnName = CAPS(hColumn:NAME).   
    
END.

ON 'value-changed':U OF tt-ccbddocu.AftIsc IN BROWSE br_table
DO:
    DEFINE VARIABLE hColumn AS HANDLE      NO-UNDO.
    DEFINE VAR cColumnName AS CHAR.

    ASSIGN hColumn = SELF:HANDLE.
    cColumnName = CAPS(hColumn:NAME).   

    IF cColumnName = "AFTISC" THEN DO:
        /*
        br_table:SCROLL-TO-CURRENT-ROW ( )  IN FRAME {&FRAME-NAME} NO-ERROR.
        br_table:SELECT-FOCUSED-ROW( )  IN FRAME {&FRAME-NAME} NO-ERROR.
                
        x-row = br_table:ROW IN FRAME {&FRAME-NAME} NO-ERROR.                
        br_table:SCROLL-TO-SELECTED-ROW ( x-row ) IN FRAME {&FRAME-NAME} NO-ERROR.
        
        GET NEXT br_table.
        IF AVAILABLE tt-ccbddocu THEN DO:            
            GET PREV br_table.
            br_table:SELECT-NEXT-ROW() IN FRAME {&FRAME-NAME} NO-ERROR.
        END.
        ELSE DO:
            br_table:SELECT-PREV-ROW() IN FRAME {&FRAME-NAME} NO-ERROR.
        END.
        */
    END.

END.

DO n_cols_browse = 1 TO br_table:NUM-COLUMNS.
   celda_br[n_cols_browse] = br_table:GET-BROWSE-COLUMN(n_cols_browse).
   cual_celda = celda_br[n_cols_browse].
     
   IF vg_col_eti_b <> 0 THEN cual_celda:LABEL-BGCOLOR = vg_col_eti_b.
   /*IF n_cols_browse = 15 THEN LEAVE.*/
END.

n_cols_browse = br_table:NUM-COLUMNS.
/* IF n_cols_browse > 15 THEN n_cols_browse = 15. */

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "gn-clie"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gn-clie"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE documentos-pendientes B-table-Win 
PROCEDURE documentos-pendientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-pi-pendiente.

DEFINE BUFFER x-tt-ccbddocu FOR tt-ccbddocu.

/**/
DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */
DEFINE VAR x-tolerancia-nc-pnc-articulo AS INT.
DEFINE VAR articulo-con-notas-de-credito AS INT.

RUN ccb\libreria-ccb.r PERSISTENT SET hProc.

x-tolerancia-nc-pnc-articulo = 0.
RUN maximo-nc-pnc-x-articulo IN hProc (INPUT x-tipo, OUTPUT x-tolerancia-nc-pnc-articulo).      

/* Verificar que el item no se este generando mas del tope */

/* tt-ccbddocu.aftisc = YES : Item esta seleccionado para el detalle de la PNC */
FOR EACH x-tt-ccbddocu WHERE x-tt-ccbddocu.aftisc = YES AND x-tt-ccbddocu.impisc > 0 NO-LOCK :
    /* Ic - 15Nov2019 - Validar cuantas N/C y/o PNC sin aprobar tiene el articulo */
    RUN articulo-con-notas-de-credito IN hProc (INPUT x-tipo, 
                                                INPUT x-tt-ccbddocu.codmat,
                                                INPUT x-tt-ccbddocu.coddoc,
                                                INPUT x-tt-ccbddocu.nrodoc,
                                                OUTPUT articulo-con-notas-de-credito).
                                                
    IF articulo-con-notas-de-credito >= x-tolerancia-nc-pnc-articulo THEN DO:
        /* El articulo ya tiene N/C y/o PNC (pendientes x aprobar) y llego al limite */
        FIND FIRST tt-pi-pendiente WHERE tt-pi-pendiente.ttipo = 'ERROR' AND
                                            tt-pi-pendiente.tcodmat = x-tt-ccbddocu.codmat AND
                                            tt-pi-pendiente.tserie = INTEGER(SUBSTRING(x-tt-ccbddocu.nrodoc,1,3)) AND
                                            tt-pi-pendiente.tnrodoc = INTEGER(SUBSTRING(x-tt-ccbddocu.nrodoc,4)) EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE tt-pi-pendiente THEN DO:
            CREATE tt-pi-pendiente.
                ASSIGN  tt-pi-pendiente.ttipo = "ERROR"
                        tt-pi-pendiente.tcodalm = ""
                        tt-pi-pendiente.tfchdoc = TODAY
                        tt-pi-pendiente.tserie = INTEGER(SUBSTRING(x-tt-ccbddocu.nrodoc,1,3))
                        tt-pi-pendiente.tnrodoc = INTEGER(SUBSTRING(x-tt-ccbddocu.nrodoc,4))
                        tt-pi-pendiente.tcodmat = x-tt-ccbddocu.codmat
                        tt-pi-pendiente.ttabla = "N/Cs y/o PNCs emitidas"
                        tt-pi-pendiente.tmsgerror = "Tiene N/Cs y/o PNCs emitidas".
        END.
    END.   
END.

DELETE PROCEDURE hProc.                 /* Release Libreria */


/* PARTES DE INGRESO (PI) */

FOR EACH almcmov WHERE almcmov.codcia = s-codcia AND almcmov.tipmov = 'I' AND
                        almcmov.codmov = 9 AND almcmov.codref = ccbcdocu.coddoc AND
                        almcmov.nroref = ccbcdocu.nrodoc AND almcmov.flgest = 'P' NO-LOCK:
    FOR EACH almdmov OF almcmov NO-LOCK:
        /* Articulo, seleccionado */
        FIND FIRST x-tt-ccbddocu WHERE x-tt-ccbddocu.aftisc = YES AND
                                        x-tt-ccbddocu.codmat = almdmov.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE x-tt-ccbddocu THEN DO:
            FIND FIRST tt-pi-pendiente WHERE tt-pi-pendiente.ttipo = 'ERROR' AND
                                                tt-pi-pendiente.tcodmat = almdmov.codmat AND
                                                tt-pi-pendiente.tserie = almcmov.nroser AND
                                                tt-pi-pendiente.tnrodoc = almcmov.nrodoc EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE tt-pi-pendiente THEN DO:
                CREATE tt-pi-pendiente.
                    ASSIGN  tt-pi-pendiente.ttipo = "ERROR"
                            tt-pi-pendiente.tcodalm = almcmov.codalm
                            tt-pi-pendiente.tfchdoc = almcmov.fchdoc
                            tt-pi-pendiente.tserie = almcmov.nroser
                            tt-pi-pendiente.tnrodoc = almcmov.nrodoc
                            tt-pi-pendiente.tcodmat = almdmov.codmat
                            tt-pi-pendiente.ttabla = "PARTE DE INGRESO (PI)"
                            tt-pi-pendiente.tmsgerror = "Tiene un PI" + STRING(almcmov.nroser,"999") + 
                                                         STRING(almcmov.nrodoc,"999999") + " pendiente de generar N/C".
            END.
        END.
    END.
END.

/* PRE-NOTAS DE CREDITO (PNC)  */
FOR EACH b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND
                        b-ccbcdocu.codref = ccbcdocu.coddoc AND     /* FAC,BOL */
                        b-ccbcdocu.nroref = ccbcdocu.nrodoc AND
                        b-ccbcdocu.coddoc = "PNC" AND
                        b-ccbcdocu.cndcre = 'N' AND
                        b-ccbcdocu.tpofac = 'OTROS' AND
                        b-ccbcdocu.flgest = 'T' NO-LOCK:    /* T: PENDIENTE DE APROBACION */
    FOR EACH ccbddocu OF b-ccbcdocu NO-LOCK:
        /* Articulo, seleccionado */
        FIND FIRST x-tt-ccbddocu WHERE x-tt-ccbddocu.aftisc = YES AND
                                        x-tt-ccbddocu.codmat = ccbddocu.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE x-tt-ccbddocu THEN DO:

            FIND FIRST tt-pi-pendiente WHERE tt-pi-pendiente.ttipo = 'ERROR' AND
                                                tt-pi-pendiente.tcodmat = ccbddocu.codmat AND
                                                tt-pi-pendiente.tserie = INTEGER(SUBSTRING(b-ccbcdocu.nrodoc,1,3)) AND
                                                tt-pi-pendiente.tnrodoc = INTEGER(SUBSTRING(b-ccbcdocu.nrodoc,4)) EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE tt-pi-pendiente THEN DO:
                CREATE tt-pi-pendiente.
                    ASSIGN  tt-pi-pendiente.ttipo = "ERROR"
                            tt-pi-pendiente.tcodalm = ""
                            tt-pi-pendiente.tfchdoc = b-ccbcdocu.fchdoc
                            tt-pi-pendiente.tserie = INTEGER(SUBSTRING(b-ccbcdocu.nrodoc,1,3))
                            tt-pi-pendiente.tnrodoc = INTEGER(SUBSTRING(b-ccbcdocu.nrodoc,4))
                            tt-pi-pendiente.tcodmat = ccbddocu.codmat
                            tt-pi-pendiente.ttabla = "PRE-NOTA DE CREDITO (PNC)"
                            tt-pi-pendiente.tmsgerror = "Tiene PNC(" + b-ccbcdocu.nrodoc + ") pendiente de Aprobacion".
            END.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genera-pre-nota B-table-Win 
PROCEDURE genera-pre-nota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-serie AS INT.                           
DEFINE VAR x-numero AS INT.
DEFINE VAR x-msg-error AS CHAR NO-UNDO.
DEFINE VAR x-item AS INT.

DEFINE VAR x-ImpBrt AS DEC.
DEFINE VAR x-ImpExo AS DEC.
DEFINE VAR x-ImpIgv AS DEC.
DEFINE VAR x-ImpTot AS DEC.
DEFINE VAR x-lineas AS CHAR.

FIND FIRST Faccfggn WHERE Faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccfggn THEN DO:
    MESSAGE "La tabla FACCFGGN no existe registro de configuracion" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

/* El correlativo de la PNC */
FIND FIRST Faccorre WHERE  Faccorre.CodCia = S-CODCIA 
    AND Faccorre.CodDoc = S-CODDOC 
    AND Faccorre.CodDiv = S-CODDIV 
    AND Faccorre.FlgEst = YES EXCLUSIVE-LOCK NO-ERROR.
IF LOCKED faccorre THEN DO:
    MESSAGE "La tabla FACCORRE esta bloqueada por otro usuario" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.                                  
ELSE DO:
    IF NOT AVAILABLE faccorre THEN DO:
        MESSAGE 'Correlativo no asignado a la división' s-coddiv VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
END.

x-serie = FacCorre.nroser.
x-numero = Faccorre.correlativo.
ASSIGN
    Faccorre.correlativo = Faccorre.correlativo + 1.

RELEASE faccorre.

/* - */
SESSION:SET-WAIT-STATE("GENERAL").

x-msg-error = "EXISTE UN ERROR EN LA GRABACION".
GRABAR:
DO TRANSACTION ON ERROR UNDO GRABAR, LEAVE GRABAR : 
    DO:
        /* Header update block */
        CREATE b-ccbcdocu.
        ASSIGN b-Ccbcdocu.codcia = s-codcia
            b-Ccbcdocu.coddiv = s-coddiv
            b-Ccbcdocu.coddoc = 'PNC'
            b-Ccbcdocu.nrodoc = STRING(x-serie,"999") + STRING(x-numero,"99999999")
            b-Ccbcdocu.fchdoc = TODAY       /* OJO */
            b-Ccbcdocu.horcie = STRING(TIME,"HH:MM:SS")
            b-Ccbcdocu.fchvto = ADD-INTERVAL (TODAY, 1, 'years')
            b-Ccbcdocu.codcli = ccbcdocu.codcli
            b-Ccbcdocu.ruccli = ccbcdocu.ruccli
            b-Ccbcdocu.nomcli = ccbcdocu.nomcli
            b-Ccbcdocu.dircli = ccbcdocu.dircli
            b-Ccbcdocu.porigv = ( IF ccbcdocu.porigv > 0 THEN ccbcdocu.porigv ELSE FacCfgGn.PorIgv )
            b-Ccbcdocu.codmon = Ccbcdocu.codmon
            b-Ccbcdocu.usuario = s-user-id
            b-Ccbcdocu.tpocmb = Faccfggn.tpocmb[1]
            b-Ccbcdocu.codref = ccbcdocu.coddoc
            b-Ccbcdocu.nroref = ccbcdocu.nrodoc
            b-Ccbcdocu.codven = ccbcdocu.codven
            b-Ccbcdocu.divori = ccbcdocu.divori
            b-Ccbcdocu.cndcre = 'N'
            b-Ccbcdocu.fmapgo = ccbcdocu.fmapgo
            b-Ccbcdocu.tpofac = "OTROS"         /* Documento es a nivel de articulo */
            b-Ccbcdocu.codcta = x-tipo          /* Concepto */
            b-Ccbcdocu.tipo   = Ccbcdocu.tipo   /* "CREDITO" */
            b-Ccbcdocu.codcaja= ""
            b-Ccbcdocu.FlgEst = 'T'   /* POR APROBAR */
            b-Ccbcdocu.ImpBrt = 0
            b-Ccbcdocu.ImpExo = 0
            b-Ccbcdocu.ImpDto = 0
            b-Ccbcdocu.ImpIgv = 0
            b-Ccbcdocu.ImpTot = 0
            b-Ccbcdocu.ImpTot2 = 0
            /*b-ccbcdocu.libre_c01 = Ccbcdocu.tcodmon*/ NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            x-msg-error = "1.- " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR, LEAVE GRABAR.
        END.
    END.

    x-item = 0.
    x-ImpBrt = 0.
    x-ImpExo = 0.
    x-ImpIgv = 0.
    x-ImpTot = 0.

    /* tt-ccbddocu.aftisc = YES : Item esta seleccionado para el detalle de la PNC */
    FOR EACH tt-ccbddocu WHERE tt-ccbddocu.aftisc = YES AND tt-ccbddocu.impisc > 0  ON ERROR UNDO, THROW:
        /* Detalle update block */
        x-item = x-item + 1.

        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                    almmmatg.codmat = tt-ccbddocu.codmat NO-LOCK NO-ERROR.

        CREATE Ccbddocu.
        BUFFER-COPY b-Ccbcdocu TO Ccbddocu.
        ASSIGN
            Ccbddocu.nroitm = x-item
            Ccbddocu.codmat = tt-ccbddocu.codmat
            Ccbddocu.factor = tt-ccbddocu.factor
            Ccbddocu.candes = tt-ccbddocu.candes
            Ccbddocu.preuni = tt-ccbddocu.pesmat - tt-ccbddocu.por_dsctos[1]
            Ccbddocu.implin = tt-ccbddocu.impisc
            Ccbddocu.undvta = tt-ccbddocu.undvta
            Ccbddocu.impdcto_adelanto[1] = tt-ccbddocu.implin
            Ccbddocu.por_dsctos[1] = tt-ccbddocu.impdto         /* (A) = Impte dsctos x N/C anteriores */
            Ccbddocu.por_dsctos[2] = tt-ccbddocu.impdto2        /* (B) = Importe final incluido (implin - A) */
            Ccbddocu.por_dsctos[3] = tt-ccbddocu.pesmat         /* (C) = precio final B / candes */
            Ccbddocu.prevta[1] = tt-ccbddocu.por_dsctos[1]      /* (D) = el nuevo precio para sacar el descuento */
            Ccbddocu.prevta[2] = tt-ccbddocu.candev             /* (E) = % Dscto */
            Ccbddocu.prevta[3] = tt-ccbddocu.pesmat - tt-ccbddocu.por_dsctos[1] /* precio unitario (C - D) */
            Ccbddocu.flg_factor = ""                    /* Se va usar en la aprobacion de la PNC */
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            x-msg-error = "2.- " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR, LEAVE GRABAR.
        END.

        /* Las lineas */
        IF LOOKUP(almmmatg.codfam,x-lineas,",") = 0 THEN DO:
            IF x-lineas <> "" THEN x-lineas = x-lineas + ",".
            x-lineas = x-lineas + TRIM(almmmatg.codfam).
        END.

        IF almmmatg.aftigv THEN DO:
            ASSIGN
            Ccbddocu.AftIgv = Yes
            Ccbddocu.ImpIgv = tt-ccbddocu.impisc - (tt-ccbddocu.impisc / (1 + (b-Ccbcdocu.PorIgv / 100))) NO-ERROR.
        END.
        ELSE DO:
            ASSIGN
            Ccbddocu.AftIgv = No
            Ccbddocu.ImpIgv = 0.
            Ccbddocu.NroItm = x-item NO-ERROR.
        END.
        IF ERROR-STATUS:ERROR THEN DO:
            x-msg-error = "3.- " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR, LEAVE GRABAR.
        END.

        IF Ccbddocu.AftIgv = YES THEN x-ImpBrt = x-ImpBrt + tt-ccbddocu.impisc.
        IF Ccbddocu.AftIgv = NO THEN x-ImpExo = x-ImpExo + tt-ccbddocu.impisc.
        x-ImpIgv = x-ImpIgv + Ccbddocu.ImpIgv.
        x-ImpTot = x-ImpTot + Ccbddocu.ImpLin.

        /* Actualiza la configuracion Mayra partes de ingreso */
        FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = "PI-PNC-DIFPRECIND" AND
                                vtatabla.llave_c1 = x-documento AND
                                vtatabla.llave_c3 = ccbddocu.codmat AND
                                vtatabla.libre_c03 = "" NO-LOCK:

            FIND FIRST b-vtatabla WHERE ROWID(b-vtatabla) = ROWID(vtatabla) EXCLUSIVE-LOCK NO-ERROR.
            IF LOCKED b-vtatabla THEN DO:
                x-msg-error = "3a.- " + ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR, LEAVE GRABAR.
            END.
            ELSE DO:
                IF AVAILABLE b-vtatabla THEN DO:
                    ASSIGN vtatabla.libre_c03 = "PNC-" + STRING(x-serie,"999") + "-" + STRING(x-numero,"99999999") NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN DO:
                        x-msg-error = "3b.- " + ERROR-STATUS:GET-MESSAGE(1).
                        UNDO GRABAR, LEAVE GRABAR.
                    END.
                END.
            END.
        END.
    END.
    /* Totales */
    DO:
        ASSIGN
            b-ccbcdocu.libre_c01 = x-lineas       /* Todas las lineas segun los articulos contenidos */
            b-Ccbcdocu.flgcie = ""
            b-Ccbcdocu.ImpBrt = x-impbrt
            b-Ccbcdocu.ImpExo = x-impexo
            b-Ccbcdocu.ImpIgv = x-ImpIgv
            b-Ccbcdocu.ImpTot = x-ImpTot
            b-Ccbcdocu.ImpVta = b-Ccbcdocu.ImpBrt - b-Ccbcdocu.ImpIgv
            b-Ccbcdocu.ImpBrt = b-Ccbcdocu.ImpBrt - b-Ccbcdocu.ImpIgv
            b-Ccbcdocu.SdoAct = b-Ccbcdocu.ImpTot NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            x-msg-error = "4.- " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR, LEAVE GRABAR.
        END.
    END.

    /* ****************************** */
    /* Ic - 16Nov2021 - Importes Arimetica de SUNAT */
    /* ****************************** */

    /*
    
    Ic - 04Oct2022, en PNC no pasar la arimetica de SUNAT
    
    &IF {&ARITMETICA-SUNAT} &THEN
        DEF VAR hProc AS HANDLE NO-UNDO.
        RUN sunat/sunat-calculo-importes.r PERSISTENT SET hProc.
        RUN tabla-ccbcdocu IN hProc (INPUT b-Ccbcdocu.CodDiv,
                                     INPUT b-Ccbcdocu.CodDoc,
                                     INPUT b-Ccbcdocu.NroDoc,
                                     OUTPUT x-msg-error).
        DELETE PROCEDURE hProc.
    
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO GRABAR, LEAVE GRABAR.
    &ENDIF
    */

/*     IF x-nueva-arimetica-sunat-2021 = YES THEN DO:                    */
/*         DEF VAR hProc AS HANDLE NO-UNDO.                              */
/*         RUN sunat/sunat-calculo-importes.r PERSISTENT SET hProc.      */
/*         RUN tabla-ccbcdocu IN hProc (INPUT b-Ccbcdocu.CodDiv,         */
/*                                      INPUT b-Ccbcdocu.CodDoc,         */
/*                                      INPUT b-Ccbcdocu.NroDoc,         */
/*                                      OUTPUT x-msg-error).             */
/*         DELETE PROCEDURE hProc.                                       */
/*                                                                       */
/*         IF RETURN-VALUE = "ADM-ERROR" THEN UNDO GRABAR, LEAVE GRABAR. */
/*                                                                       */
/*     END.                                                              */

    x-msg-error = "OK".
END.

RELEASE b-vtatabla NO-ERROR.
IF AVAILABLE b-ccbcdocu THEN RELEASE b-ccbcdocu.
IF AVAILABLE ccbddocu THEN RELEASE ccbddocu.

SESSION:SET-WAIT-STATE("").

IF x-msg-error = "OK" THEN DO:
    MESSAGE "Se genero la PNC con Nro : " + STRING(x-serie,"999") + STRING(x-numero,"99999999")
            VIEW-AS ALERT-BOX INFORMATION.
    /**/
    EMPTY TEMP-TABLE tt-conceptos.
    {&open-query-br_table}

END.                                      
ELSE DO:
    MESSAGE "No se pudo generar la PNC :" SKIP
            x-msg-error
            VIEW-AS ALERT-BOX QUESTION.
END.

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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
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
/*
  MESSAGE gn-clie.nomcli SKIP
        ccbcdocu.nrodoc SKIP        
      .
*/


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE margen-utilidad B-table-Win 
PROCEDURE margen-utilidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE BUFFER x-tt-ccbddocu FOR tt-ccbddocu.

DEFINE VAR x-preuni AS DEC.
DEFINE VAR x-codmon AS INT.
DEFINE VAR x-TpoCmb AS DEC.
DEFINE VAR x-margen AS DEC.
DEFINE VAR x-limite AS DEC.
DEFINE VAR x-msgerror AS CHAR.

x-codmon = 1.       /* La PNC esta en SOLES */
x-TpoCmb = 1.       /* Tipo de cambio */

FOR EACH x-tt-ccbddocu WHERE x-tt-ccbddocu.aftisc = YES AND x-tt-ccbddocu.impisc > 0 NO-LOCK:
        
      x-preuni = x-tt-ccbddocu.pesmat - x-tt-ccbddocu.por_dsctos[1].

      x-Margen = 0.
      X-LIMITE = 0.

      RUN vtagn/p-margen-utilidad (
          x-tt-ccbddocu.CodMat,      /* Producto */
          x-PreUni,  /* Precio de venta unitario */
          x-tt-ccbddocu.UndVta,
          x-CodMon,       /* Moneda de venta */
          x-TpoCmb,       /* Tipo de cambio */
          NO,            /* Muestra el error */
          "",
          OUTPUT x-Margen,        /* Margen de utilidad */
          OUTPUT x-Limite,        /* Margen mínimo de utilidad */
          OUTPUT x-msgError           /* Control de errores: "OK" "ADM-ERROR" */
          ).

    IF X-MARGEN < X-LIMITE THEN DO:
        CREATE tt-pi-pendiente.
            ASSIGN    tt-pi-pendiente.ttipo = "ALERTA"
                      tt-pi-pendiente.tcodalm = ""
                      tt-pi-pendiente.tfchdoc = ?
                      tt-pi-pendiente.tserie = 0
                      tt-pi-pendiente.tnrodoc = 0
                      tt-pi-pendiente.tcodmat = x-tt-ccbddocu.CodMat
                      tt-pi-pendiente.ttabla = "MARGEN DE UTILIDAD MUY BAJO"
                      tt-pi-pendiente.tmsgerror = "El articulo entra en conflicto con el margen".

    END.

END.


END PROCEDURE.
/*
DEF OUTPUT PARAMETER pMargen AS DEC.
DEF OUTPUT PARAMETER pLimite AS DEC.
DEF OUTPUT PARAMETER pError AS CHAR.        /* Se relaciona con el parámetro pVerError */
*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refrescar B-table-Win 
PROCEDURE refrescar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pRowId AS ROWID.
DEFINE INPUT PARAMETER pConcepto AS CHAR.

/* Para chequear si tiene notas de credito */
DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER x-ccbddocu FOR ccbddocu.

DEFINE VAR x-nc-detallada AS LOG INIT NO.
DEFINE VAR x-factor AS DEC INIT 0.
DEFINE VAR x-importe AS DEC INIT 0.

DEFINE VAR x-operacion AS CHAR.
DEFINE VAR x-tipocmb AS DEC INIT 0.
DEFINE VAR x-estado AS CHAR.

DEFINE VAR articulo-con-notas-de-credito AS INT.

SESSION:SET-WAIT-STATE("GENERAL").

/* Libreria */
DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */

RUN ccb\libreria-ccb.r PERSISTENT SET hProc.

/* Procedimientos */
x-tolerancia-nc-pnc-articulo = 0.
RUN maximo-nc-pnc-x-articulo IN hProc (INPUT x-tipo, OUTPUT x-tolerancia-nc-pnc-articulo).      


/* Conceptos consideradas para rebajar el precios */
EMPTY TEMP-TABLE tt-conceptos.

FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND
                        vtatabla.tabla = 'WIN-TO-WIN-DIF-PRECIOS-IND' AND
                        vtatabla.llave_c1 = pConcepto NO-LOCK:        
    CREATE tt-conceptos.
        ASSIGN tt-conceptos.llave-c = vtatabla.llave_c2.
END.

/* --------- */
FIND FIRST ccbcdocu WHERE ROWID(ccbcdocu) = pRowId NO-LOCK NO-ERROR.

IF NOT AVAILABLE ccbcdocu THEN RETURN.

x-documento = ccbcdocu.coddoc + "-" + SUBSTRING(ccbcdocu.nrodoc,1,3) + "-" + SUBSTRING(ccbcdocu.nrodoc,4).

EMPTY TEMP-TABLE ttNCItems.

/* Tiene N/Cs la factura */
FOR EACH x-ccbcdocu WHERE x-ccbcdocu.codcia = ccbcdocu.codcia AND
                            x-ccbcdocu.codref = ccbcdocu.coddoc AND
                            x-ccbcdocu.nroref = ccbcdocu.nrodoc AND
                            ((x-ccbcdocu.coddoc = 'N/C' AND x-ccbcdocu.flgest <> 'A') OR 
                             (x-ccbcdocu.coddoc = 'PNC' AND LOOKUP(x-ccbcdocu.flgest,'T,AP,D,P') > 0)) NO-LOCK:

    FIND FIRST tt-conceptos WHERE tt-conceptos.llave-c = x-ccbcdocu.codcta NO-LOCK NO-ERROR.

    IF NOT AVAILABLE tt-conceptos THEN NEXT.

    x-tipocmb = 1.
    
    IF x-ccbcdocu.codmon <> ccbcdocu.codmon THEN DO:
        /* La Moneda de la factura referenciada sera la misma de la PRE NOTA */
        IF ccbcdocu.codmon = 2 THEN DO:
            /* PRE NOTA va ser Dolares, la N/C esta Soles */
            x-operacion = "DIVIDIR".
        END.
        ELSE DO:
            /* PRE NOTA va ser Soles, la N/C esta Dolares */
            x-operacion = "MULTIPLICAR".
        END.
        x-tipocmb = x-ccbcdocu.tpocmb.
    END.

    IF x-ccbcdocu.cndcre = 'D' OR (x-ccbcdocu.cndcre = 'N' AND x-ccbcdocu.tpofac = 'OTROS') THEN DO:
       /* Devolucion de Mercaderia or detallado por item */
        FOR EACH x-ccbddocu OF x-ccbcdocu NO-LOCK:

            /* Si esta EXCLUIDO no considerar*/
            x-estado = "APROBADO".
            IF (x-ccbcdocu.cndcre = 'N' AND x-ccbcdocu.tpofac = 'OTROS') THEN DO:
                /* N/C a nivel de detalle x articulo */
                IF NOT TRUE <> (x-ccbddocu.flg_factor > "") THEN DO:
                    IF ENTRY(1,x-ccbddocu.flg_factor,"|") <> "APROBADO" THEN DO:
                        x-estado = "EXCLUIDO".
                    END.
                END.
            END.

            IF x-estado = "APROBADO" THEN DO:
                FIND FIRST ttNCItems WHERE tcodmat = x-ccbddocu.codmat EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE ttNCItems THEN DO:
                    CREATE ttNCItems.
                    ASSIGN  ttNCItems.tcodmat = x-ccbddocu.codmat.
                END.

                IF x-operacion = "DIVIDIR" THEN DO:
                    ASSIGN ttNCItems.timplin = ttNCItems.timplin + (x-ccbddocu.implin / x-tipocmb).
                END.
                ELSE DO:
                    ASSIGN ttNCItems.timplin = ttNCItems.timplin + (x-ccbddocu.implin * x-tipocmb).
                END.
            END.            
        END.
    END.
    ELSE DO:
        /*
        
        Ic - 04Mar2020 - Se desabilito a pedido de Susana Leon
        
        /* Nota de Credito otros conceptos */
        IF x-operacion = "DIVIDIR" THEN DO:
            x-factor = ROUND((x-ccbcdocu.imptot / x-tipocmb )/ ccbcdocu.imptot,6). /* Importe N/C total entre Importe Total Factura */
        END.
        ELSE DO:
            x-factor = ROUND((x-ccbcdocu.imptot * x-tipocmb )/ ccbcdocu.imptot,6). /* Importe N/C total entre Importe Total Factura */
        END.
        
        FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
            FIND FIRST ttNCItems WHERE tcodmat = ccbddocu.codmat EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE ttNCItems THEN DO:
                CREATE ttNCItems.
                ASSIGN  ttNCItems.tcodmat = ccbddocu.codmat.
            END.

            x-importe = ccbddocu.implin - ttNCItems.timplin.    /* Importe del articulo menos los n/c cargadas */            
            ASSIGN ttNCItems.timplin = ttNCItems.timplin + (x-importe * x-factor).

        END.
        */
    END.
END.

EMPTY TEMP-TABLE tt-ccbddocu.

/* Items de la FAC,BOL */
FOR EACH ccbddocu OF ccbcdocu NO-LOCK:

    /* Ic - 15Nov2019 - Validar cuantas N/C y/o PNC sin aprobar tiene el articulo */
    RUN articulo-con-notas-de-credito IN hProc (INPUT x-tipo, 
                                                INPUT ccbddocu.codmat,
                                                INPUT ccbddocu.coddoc,
                                                INPUT ccbddocu.nrodoc,
                                                OUTPUT articulo-con-notas-de-credito).
                                                
    IF articulo-con-notas-de-credito >= x-tolerancia-nc-pnc-articulo THEN DO:
        /* El articulo ya tiene N/C y/o PNC (pendientes x aprobar) y llego al limite */
        NEXT.
    END.   

    CREATE tt-ccbddocu.
    BUFFER-COPY ccbddocu TO tt-ccbddocu.
    ASSIGN tt-ccbddocu.candev = 0
            tt-ccbddocu.impisc = 0
            tt-ccbddocu.aftisc = NO
            tt-ccbddocu.impdto = 0
            tt-ccbddocu.prebas = ccbddocu.preuni
            tt-ccbddocu.dcto_otros_factor = ccbddocu.por_dsctos[1]
            tt-ccbddocu.dcto_otros_vv = ccbddocu.por_dsctos[2]
            tt-ccbddocu.dcto_otros_pv = ccbddocu.por_dsctos[3]
            tt-ccbddocu.preuni = ccbddocu.implin / ccbddocu.candes
            tt-ccbddocu.por_dsctos[1] = 0
            tt-ccbddocu.por_dsctos[2] = 0.

    /* Si tiene notas de credito */
    FIND FIRST ttNCItems WHERE tcodmat = ccbddocu.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE ttNCItems THEN DO:
        ASSIGN tt-ccbddocu.impdto = ttNCItems.timplin.
    END.
    ASSIGN tt-ccbddocu.impdto2 = tt-ccbddocu.implin - tt-ccbddocu.impdto.
    IF tt-ccbddocu.impdto2 < 0 THEN ASSIGN tt-ccbddocu.impdto2 = 0.
    /*  */
    ASSIGN tt-ccbddocu.pesmat = ROUND(tt-ccbddocu.impdto2 / ccbddocu.candes,4).
    
    /* Ic - 16Abr2021, Mayra Padilla rebajar cantidad segun parte de ingreso (PI) */
    FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND
                            vtatabla.tabla = "PI-PNC-DIFPRECIND" AND
                            vtatabla.llave_c1 = x-documento AND     /* FAC,BOL - serie - numero */
                            vtatabla.llave_c3 = ccbddocu.codmat AND
                            vtatabla.libre_c03 = "" NO-LOCK:
        /* Cantidad en el parte de ingreso */
        FIND FIRST almdmov WHERE almdmov.codcia = s-codcia AND
                                    almdmov.codalm = vtatabla.llave_c4 AND
                                    almdmov.tipmov = vtatabla.llave_c5 AND
                                    almdmov.codmov = INTEGER(vtatabla.llave_c6) AND
                                    almdmov.nroser = INTEGER(ENTRY(1,vtatabla.llave_c2,"-")) AND
                                    almdmov.nrodoc = INTEGER(ENTRY(2,vtatabla.llave_c2,"-")) AND
                                    almdmov.codmat = vtatabla.llave_c3 NO-LOCK NO-ERROR.
        IF AVAILABLE almdmov THEN DO:
            /* Que el parte de ingreso tenga N/C generada */
            FIND FIRST almcmov OF almdmov WHERE almcmov.flgest = "C" NO-LOCK NO-ERROR.
            IF AVAILABLE almcmov THEN DO:
                ASSIGN tt-ccbddocu.candes = tt-ccbddocu.candes - almdmov.candes.
                IF tt-ccbddocu.candes < 0 THEN ASSIGN tt-ccbddocu.candes = 0.
            END.            
        END.
        
    END.

END.

DISPLAY "" @ fill-in-moneda WITH FRAME {&FRAME-NAME}.
DISPLAY "0.00" @ fill-in-importe WITH FRAME {&FRAME-NAME}.

IF AVAILABLE ccbcdocu THEN DO:
    IF ccbcdocu.codmon = 2 THEN DO:
        DISPLAY "DOLARES" @ fill-in-moneda WITH FRAME {&FRAME-NAME}.
    END.
    ELSE DISPLAY "SOLES" @ fill-in-moneda WITH FRAME {&FRAME-NAME}. 
    DISPLAY ccbcdocu.imptot @ fill-in-importe WITH FRAME {&FRAME-NAME}.
END.

{&open-query-br_table}

DELETE PROCEDURE hProc.     /* Release Libreria */

SESSION:SET-WAIT-STATE("").



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
  {src/adm/template/snd-list.i "gn-clie"}
  {src/adm/template/snd-list.i "tt-CcbDDocu"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE total-a-descontar B-table-Win 
PROCEDURE total-a-descontar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER x-tt-ccbddocu FOR tt-ccbddocu.

    x-total-a-descontar = 0.

    FOR EACH x-tt-ccbddocu WHERE x-tt-ccbddocu.aftisc = YES AND x-tt-ccbddocu.impisc > 0 NO-LOCK:
        x-total-a-descontar = x-total-a-descontar + x-tt-ccbddocu.impisc.
    END.

    IF x-total-a-descontar < 0 THEN x-total-a-descontar = 0.

    DO WITH FRAME {&FRAME-NAME}:
        fill-in-totaldscto:SCREEN-VALUE = STRING(x-total-a-descontar,"->,>>>,>>9.99").
    END.

    RETURN "OK".

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validar-informacion B-table-Win 
PROCEDURE validar-informacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Almacenar los PI / PNC pendientes */
RUN documentos-pendientes.

/* Margen de Utilidad */
RUN margen-utilidad.

FIND FIRST tt-pi-pendiente NO-LOCK NO-ERROR.
IF AVAILABLE tt-pi-pendiente THEN DO:
    RUN ccb/d-inconsistencias-pnc.r(INPUT TABLE tt-pi-pendiente).
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDsctoAcumulado B-table-Win 
FUNCTION fDsctoAcumulado RETURNS DECIMAL
  ( pPrecioConDsctos AS DEC, pPrecioVentaFacturado AS DEC ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR x-retval AS DEC INIT 0.

  IF pPrecioVentaFacturado > 0 THEN DO:
      IF pPrecioConDsctos > 0 THEN DO:
          x-retval = ROUND((pPrecioVentaFacturado - pPrecioConDsctos ) / pPrecioVentaFacturado,4) * 100.
      END.
          
  END.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

