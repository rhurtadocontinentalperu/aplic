&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER BONIFICACION FOR FacCPedi.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE TEMP-TABLE T-CPEDI NO-UNDO LIKE FacCPedi.



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

/* Parameters Definitions ---                                           */


/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INT.

DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-flgest AS CHAR.
DEF SHARED VAR S-CNDVTA AS CHAR.

DEF VAR x-Moneda AS CHAR FORMAT 'x(3)'.

DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-DPEDI FOR facdpedi.

DEFINE VAR x-division AS CHAR INIT "".
DEFINE VAR x-division-veri AS CHAR INIT "".

/* Poblar el Browse Temporal */
&SCOPED-DEFINE Condicion ~
( FacCPedi.CodCia = s-codcia ~
AND FacCPedi.CodDoc = s-coddoc ~
AND FacCPedi.CodDiv = x-division ~
AND FacCPedi.FlgEst = s-flgest ~
)

/* Verificar si esta pendiente */
&SCOPED-DEFINE CondicionVeri ~
( FacCPedi.CodCia = s-codcia ~
AND FacCPedi.CodDoc = s-coddoc ~
AND FacCPedi.CodDiv = x-division-veri ~
AND FacCPedi.FlgEst = s-flgest ~
)

/*
&SCOPED-DEFINE Condicion ~
( FacCPedi.CodCia = s-codcia ~
AND FacCPedi.CodDoc = s-coddoc ~
AND FacCPedi.CodDiv = COMBO-BOX-CodDiv ~
AND FacCPedi.FlgEst = s-flgest ~
)
*/


/* RHC 18/01/2016 Control adicional para cambiar la división */
DEFINE SHARED VAR s-acceso-total  AS LOG NO-UNDO.

DEFINE NEW SHARED VAR s-FlgRotacion LIKE gn-divi.flgrotacion.
DEFINE NEW SHARED VAR s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE NEW SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE NEW SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEFINE NEW SHARED VAR s-FlgTipoVenta LIKE GN-DIVI.FlgPreVta.
DEFINE NEW SHARED VAR s-TpoPed AS CHAR.
DEFINE NEW SHARED VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.

/* SORT */
define var x-sort-direccion as char init "".
define var x-sort-column as char init "".
define var x-sort-command as char init "".

DEFINE VAR x-sort-acumulativo AS LOG INIT NO.
DEFINE VAR x-sort-color-reset AS LOG INIT YES.

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
&Scoped-define INTERNAL-TABLES T-CPEDI FacCPedi gn-ven gn-ConVt COTIZACION

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-CPEDI.Libre_c03 T-CPEDI.FchImpOD ~
FacCPedi.NroPed FacCPedi.NomCli ~
IF (FacCPedi.CodMon = 1) THEN ('S/.') ELSE ('US$') @ x-Moneda ~
FacCPedi.ImpTot FacCPedi.CodVen gn-ven.NomVen FacCPedi.FmaPgo ~
gn-ConVt.Nombr FacCPedi.Libre_c05 T-CPEDI.Libre_c02 FacCPedi.FaxCli ~
FacCPedi.FchPed 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-CPEDI.Libre_c03 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-CPEDI
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-CPEDI
&Scoped-define QUERY-STRING-br_table FOR EACH T-CPEDI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi OF T-CPEDI NO-LOCK, ~
      FIRST gn-ven OF T-CPEDI NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK, ~
      FIRST COTIZACION WHERE COTIZACION.CodCia = FacCPedi.CodCia ~
  AND COTIZACION.CodDiv = FacCPedi.CodDiv ~
  AND COTIZACION.CodDoc = FacCPedi.CodRef ~
  AND COTIZACION.NroPed = FacCPedi.NroRef NO-LOCK ~
    BY T-CPEDI.FchImpOD
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-CPEDI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi OF T-CPEDI NO-LOCK, ~
      FIRST gn-ven OF T-CPEDI NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK, ~
      FIRST COTIZACION WHERE COTIZACION.CodCia = FacCPedi.CodCia ~
  AND COTIZACION.CodDiv = FacCPedi.CodDiv ~
  AND COTIZACION.CodDoc = FacCPedi.CodRef ~
  AND COTIZACION.NroPed = FacCPedi.NroRef NO-LOCK ~
    BY T-CPEDI.FchImpOD.
&Scoped-define TABLES-IN-QUERY-br_table T-CPEDI FacCPedi gn-ven gn-ConVt ~
COTIZACION
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-CPEDI
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define THIRD-TABLE-IN-QUERY-br_table gn-ven
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table gn-ConVt
&Scoped-define FIFTH-TABLE-IN-QUERY-br_table COTIZACION


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodDiv FILL-IN-Glosa ~
FILL-IN-division 

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
DEFINE VARIABLE COMBO-BOX-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Diivisión" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 59 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-division AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52.43 BY .81
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-Glosa AS CHARACTER FORMAT "X(256)":U 
     LABEL "Observaciones" 
     VIEW-AS FILL-IN 
     SIZE 70 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-CPEDI, 
      FacCPedi, 
      gn-ven
    FIELDS(gn-ven.NomVen), 
      gn-ConVt
    FIELDS(gn-ConVt.Nombr), 
      COTIZACION
    FIELDS() SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-CPEDI.Libre_c03 COLUMN-LABEL "Registro!Pedido" FORMAT "x(20)":U
            WIDTH 15.43
      T-CPEDI.FchImpOD COLUMN-LABEL "Enviado a!CyC" FORMAT "99/99/9999 HH:MM:SS.SSS":U
            WIDTH 17
      FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U WIDTH 8.72
      FacCPedi.NomCli FORMAT "x(100)":U WIDTH 22.43
      IF (FacCPedi.CodMon = 1) THEN ('S/.') ELSE ('US$') @ x-Moneda COLUMN-LABEL "Mon." FORMAT "x(3)":U
      FacCPedi.ImpTot COLUMN-LABEL "Importe" FORMAT ">>>,>>9.99":U
      FacCPedi.CodVen FORMAT "x(10)":U WIDTH 7
      gn-ven.NomVen FORMAT "X(40)":U WIDTH 14.86
      FacCPedi.FmaPgo COLUMN-LABEL "Condición" FORMAT "X(8)":U
      gn-ConVt.Nombr FORMAT "X(50)":U WIDTH 19.43
      FacCPedi.Libre_c05 COLUMN-LABEL "Motivo" FORMAT "x(60)":U
            WIDTH 29
      T-CPEDI.Libre_c02 COLUMN-LABEL "Division" FORMAT "x(60)":U
      FacCPedi.FaxCli COLUMN-LABEL "" FORMAT "x(10)":U WIDTH 5.43
      FacCPedi.FchPed COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
  ENABLE
      T-CPEDI.Libre_c03
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 142 BY 6.12
         FONT 4
         TITLE "DOCUMENTOS" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodDiv AT ROW 1.19 COL 20 COLON-ALIGNED WIDGET-ID 2
     br_table AT ROW 2.15 COL 1.14
     FILL-IN-Glosa AT ROW 8.27 COL 14.57 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-division AT ROW 8.31 COL 87.57 COLON-ALIGNED NO-LABEL WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: BONIFICACION B "?" ? INTEGRAL FacCPedi
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: T-CPEDI T "?" NO-UNDO INTEGRAL FacCPedi
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
         HEIGHT             = 8.31
         WIDTH              = 142.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table COMBO-BOX-CodDiv F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

/* SETTINGS FOR COMBO-BOX COMBO-BOX-CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Glosa IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-CPEDI,INTEGRAL.FacCPedi OF Temp-Tables.T-CPEDI,INTEGRAL.gn-ven OF Temp-Tables.T-CPEDI,INTEGRAL.gn-ConVt WHERE INTEGRAL.FacCPedi ...,COTIZACION WHERE INTEGRAL.FacCPedi ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST, FIRST USED, FIRST USED, FIRST USED"
     _OrdList          = "Temp-Tables.T-CPEDI.FchImpOD|yes"
     _JoinCode[4]      = "INTEGRAL.gn-ConVt.Codig = INTEGRAL.FacCPedi.FmaPgo"
     _JoinCode[5]      = "COTIZACION.CodCia = INTEGRAL.FacCPedi.CodCia
  AND COTIZACION.CodDiv = INTEGRAL.FacCPedi.CodDiv
  AND COTIZACION.CodDoc = INTEGRAL.FacCPedi.CodRef
  AND COTIZACION.NroPed = INTEGRAL.FacCPedi.NroRef"
     _FldNameList[1]   > Temp-Tables.T-CPEDI.Libre_c03
"T-CPEDI.Libre_c03" "Registro!Pedido" "x(20)" "character" ? ? ? ? ? ? yes ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-CPEDI.FchImpOD
"T-CPEDI.FchImpOD" "Enviado a!CyC" ? "datetime" ? ? ? ? ? ? no ? no no "17" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "22.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"IF (FacCPedi.CodMon = 1) THEN ('S/.') ELSE ('US$') @ x-Moneda" "Mon." "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.ImpTot
"FacCPedi.ImpTot" "Importe" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacCPedi.CodVen
"FacCPedi.CodVen" ? ? "character" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.gn-ven.NomVen
"gn-ven.NomVen" ? ? "character" ? ? ? ? ? ? no ? no no "14.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacCPedi.FmaPgo
"FacCPedi.FmaPgo" "Condición" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.gn-ConVt.Nombr
"gn-ConVt.Nombr" ? ? "character" ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.FacCPedi.Libre_c05
"FacCPedi.Libre_c05" "Motivo" ? "character" ? ? ? ? ? ? no ? no no "29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-CPEDI.Libre_c02
"T-CPEDI.Libre_c02" "Division" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.FacCPedi.FaxCli
"FacCPedi.FaxCli" "" "x(10)" "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Fecha" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ENTRY OF br_table IN FRAME F-Main /* DOCUMENTOS */
DO:
    fill-in-division:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    IF AVAILABLE faccpedi THEN DO:
        fill-in-division:SCREEN-VALUE IN FRAME {&FRAME-NAME} = t-cpedi.libre_c02.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON GO OF br_table IN FRAME F-Main /* DOCUMENTOS */
DO:
    fill-in-division:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main /* DOCUMENTOS */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* DOCUMENTOS */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON START-SEARCH OF br_table IN FRAME F-Main /* DOCUMENTOS */
DO:
    DEFINE VARIABLE hSortColumn AS WIDGET-HANDLE.
    DEFINE VARIABLE hColumnIndex AS WIDGET-HANDLE.
    DEFINE VAR lColumName AS CHAR.
    DEFINE VAR hQueryHandle AS HANDLE NO-UNDO.

    DEFINE VAR n_cols_browse AS INT NO-UNDO.
    DEFINE VAR n_celda AS WIDGET-HANDLE NO-UNDO.

    DEFINE VAR x-col-index AS INT.

    hSortColumn = BROWSE br_table:CURRENT-COLUMN.
    lColumName = hSortColumn:NAME.
    lColumName = TRIM(REPLACE(lColumName," no","")).

    /*
    IF lColumName = 'acubon' THEN DO:
        MESSAGE "Columna imposible de Ordenar".
        RETURN NO-APPLY.
    END.

    IF lColumName = 'x-subzona' THEN lColumName = 'csubzona'.
    IF lColumName = 'x-zona' THEN lColumName = 'czona'.
    */
    x-sort-command = "BY " + lColumName.

    IF x-sort-acumulativo = NO THEN DO:
        IF CAPS(x-sort-command) = CAPS(x-sort-column) THEN DO:
            x-sort-command = "BY " + lColumName + " DESC".
        END.
        ELSE DO:
            x-sort-command = "BY " + lColumName + " DESC".
            IF CAPS(x-sort-command) = CAPS(x-sort-column) THEN DO:
                x-sort-command = "BY " + lColumName.
            END.
            ELSE x-sort-command = "BY " + lColumName.
        END.
        x-sort-column = x-sort-command.

        x-sort-color-reset = YES.
    END.
    ELSE DO:
        x-sort-command = "BY " + lColumName + " DESC".

        IF INDEX(x-sort-column,x-sort-command) > 0 THEN DO:
            x-sort-column = REPLACE(x-sort-column,x-sort-command,"BY " + lColumName).
        END.
        ELSE DO:
            x-sort-command = "BY " + lColumName.
            IF INDEX(x-sort-column,x-sort-command) > 0 THEN DO:
                x-sort-column = REPLACE(x-sort-column,x-sort-command,"BY " + lColumName + " DESC").
            END.
            ELSE DO:
                x-sort-column = x-sort-column + " " + x-sort-command.
            END.
        END.
        x-sort-command = x-sort-column.
    END.

    /* Clear Sort Imagen */
    BROWSE br_table:CLEAR-SORT-ARROWS().

    DO n_cols_browse = 1 TO br_table:NUM-COLUMNS.
        hColumnIndex = br_table:GET-BROWSE-COLUMN(n_cols_browse).
        IF hSortColumn = hColumnIndex  THEN DO:
            IF INDEX(x-sort-command," DESC") > 0 THEN DO:
                BROWSE br_table:SET-SORT-ARROW(n_cols_browse,TRUE).
            END.
            ELSE DO:
                BROWSE br_table:SET-SORT-ARROW(n_cols_browse,FALSE).
            END.            
        END.
    END.

    DEFINE VAR x-query-browse AS CHAR.

    x-query-browse = "FOR EACH T-CPEDI WHERE " + "~{&" + "KEY-PHRASE" + "} NO-LOCK, ".
    x-query-browse = x-query-browse + "FIRST FacCPedi OF T-CPEDI NO-LOCK, ".
    x-query-browse = x-query-browse + "FIRST gn-ven OF T-CPEDI NO-LOCK, ".
    x-query-browse = x-query-browse + "FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK, ".
    x-query-browse = x-query-browse + "FIRST COTIZACION WHERE COTIZACION.CodCia = FacCPedi.CodCia ".
    x-query-browse = x-query-browse + "AND COTIZACION.CodDiv = FacCPedi.CodDiv ".
    x-query-browse = x-query-browse + "AND COTIZACION.CodDoc = FacCPedi.CodRef ".
    x-query-browse = x-query-browse + "AND COTIZACION.NroPed = FacCPedi.NroRef NO-LOCK ".    
    
    hQueryHandle = BROWSE br_table:QUERY.
    hQueryHandle:QUERY-CLOSE().
    /* *--- Este valor debe ser el QUERY que esta definido en el BROWSE. */   
    /*hQueryHandle:QUERY-PREPARE("FOR EACH ORDENES WHERE " + "{& " + "CONDICION" + "} NO-LOCK, FIRST INTEGRAL.FacCPedi OF ORDENES NO-LOCK " + x-sort-command).*/
    hQueryHandle:QUERY-PREPARE(x-query-browse + x-sort-command) NO-ERROR.
    hQueryHandle:QUERY-OPEN().    

    /* Color SortCol */
    IF x-sort-color-reset = YES THEN DO:
        /* Color normal */
        DO n_cols_browse = 1 TO br_table:NUM-COLUMNS.
            n_celda = br_table:GET-BROWSE-COLUMN(n_cols_browse).
            n_celda:COLUMN-BGCOLOR = 15.
        END.        

        x-sort-color-reset = NO.
    END.
    /*hSortColumn:COLUMN-BGCOLOR = 11.   */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* DOCUMENTOS */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}

      fill-in-division:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
      IF AVAILABLE faccpedi THEN DO:
          fill-in-division:SCREEN-VALUE IN FRAME {&FRAME-NAME} = t-cpedi.libre_c02.
      END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodDiv B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-CodDiv IN FRAME F-Main /* Diivisión */
DO:
  ASSIGN {&self-name}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ASSIGN t-cpedi.libre_c03:READ-ONLY IN BROWSE br_table = TRUE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar B-table-Win 
PROCEDURE Aprobar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.
DEF VAR x-CodUbic AS CHAR INIT 'ANP' NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR x-Cuenta AS INT NO-UNDO.

IF {&browse-name}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
    MESSAGE 'Debe seleccionar al menos 1 registro' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
MESSAGE 'Procedemos con la aprobación?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta-1 AS LOG.
IF rpta-1 = NO THEN RETURN 'ADM-ERROR'.
/* **************************************************************************** */
DEF VAR iItem AS INTE NO-UNDO.

CICLO:
DO k = 1 TO {&browse-name}:NUM-SELECTED-ROWS TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:

    x-division-veri = Faccpedi.CodDiv.

    /* ********************************************************************************* */
    IF NOT {&browse-name}:FETCH-SELECTED-ROW(k) THEN NEXT.
    /* ********************************************************************************* */
    /* Buscamos deudas pendientes */
    /* RHC 12/06/18 De cualquier cliente del grupo */
    DEF VAR LocalMaster AS CHAR NO-UNDO.
    DEF VAR LocalRelacionados AS CHAR NO-UNDO.
    DEF VAR LocalAgrupados AS LOG NO-UNDO.
    DEF VAR LocalCliente AS CHAR NO-UNDO.

    RUN ccb/p-cliente-master (Faccpedi.CodCli,
                              OUTPUT LocalMaster,
                              OUTPUT LocalRelacionados,
                              OUTPUT LocalAgrupados).
    IF LocalAgrupados = YES AND LocalRelacionados > '' THEN .
    ELSE LocalRelacionados = Faccpedi.CodCli.
    FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND LOOKUP(CcbCDocu.CodCli, LocalRelacionados) > 0      /*Ccbcdocu.codcli = Faccpedi.codcli*/
        AND Ccbcdocu.flgest = 'P'
        AND LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,LET,N/D,CHQ') > 0
        AND (Ccbcdocu.fchvto + 5) < TODAY   /*AND (Ccbcdocu.fchvto + 8) < TODAY*/
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbcdocu THEN DO:
        MESSAGE 'El cliente/grupo tiene una deuda atrazada:' SKIP
            'Cliente:' Ccbcdocu.nomcli SKIP
            'Documento:' Ccbcdocu.coddoc Ccbcdocu.nrodoc SKIP
            'Vencimiento:' Ccbcdocu.fchvto SKIP
            'Continúa con la aprobación?'
            VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
            UPDATE Rpta AS LOG.
        IF Rpta = NO THEN NEXT CICLO.
    END.
    /* ************************************************************************* */
    /* RHC 21/11/18 Julissa Calderon: Línea de Crédito debe estar AUTORIZADA     */
    /* ************************************************************************* */
    FIND gn-convt WHERE gn-ConVt.Codig = Faccpedi.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt AND gn-convt.tipvta <> "1" THEN DO:   /* SOLO CREDITO */
        IF LocalAgrupados = YES AND LocalMaster > '' THEN LocalCliente = LocalMaster.
        ELSE LocalCliente = Faccpedi.CodCli.
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = LocalCliente 
            NO-LOCK NO-ERROR.
        /* RHC 25/10/2019 Solicitado por Julissa Calderón */
/*         IF AVAILABLE gn-clie AND gn-clie.FlagAut <> 'A' THEN DO:                     */
/*             MESSAGE 'La Línea de Crédito del cliente/grupo NO está AUTORIZADA:' SKIP */
/*                 'Cliente:' gn-clie.nomcli SKIP                                       */
/*                 'Continúa con la aprobación?'                                        */
/*                 VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO                             */
/*                 UPDATE Rpta1 AS LOG.                                                 */
/*             IF Rpta1 = NO THEN NEXT CICLO.                                           */
/*         END.                                                                         */
    END.
    /* ************************************************************************* */
    /* ************************************************************************* */
    /* Verificamos nuevamente */
    IF NOT {&CondicionVeri} OR CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate <> 0 NO-LOCK)
        THEN DO:
        MESSAGE 'El documento' Faccpedi.coddoc Faccpedi.nroped 'ya NO se encuentra pendiente de aprobación'
            VIEW-AS ALERT-BOX ERROR.
        FIND CURRENT Faccpedi NO-LOCK NO-ERROR.
        NEXT CICLO.
    END.
    FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="x-Cuenta"}
        UNDO, LEAVE CICLO.
    END.
    ASSIGN
        Faccpedi.Flgest = 'P'
        Faccpedi.UsrAprobacion = s-user-id
        Faccpedi.FchAprobacion = TODAY.
    /* RHC 30/12/2015 Para no depender del vendedor o el tipo de venta
        vamos a fijarnos en el tipo de canal de venta de la division */
    FIND gn-divi WHERE gn-divi.codcia = COTIZACION.codcia
        AND gn-divi.coddiv = COTIZACION.coddiv NO-LOCK.
    
    CASE s-FlgEst:
        WHEN "X" OR WHEN "T" THEN DO:   /* Aprobado por CREDITOS y COBRANZAS Y TESORERIA */
            /* RHC 01.12.2011 Chequeo de precios con bajo margen SOLO ATE */
            /* si el margen es bajo pasan para pre-aprobarlos por SECR. GG (W) */
            IF Faccpedi.coddiv = '00000' THEN DO:
                {vta2/i-verifica-margen-utilidad-1.i}
            END.
            /* Trámite Documentario pasa a ser aprobado por Logística */
            IF Faccpedi.TipVta = "Si" THEN DO:
                /*ASSIGN Faccpedi.FlgEst = "WC".*/
                ASSIGN Faccpedi.FlgEst = "WL".
            END.
            /* Supermercados pasa a APROBACION POR SECR. GG */
            IF GN-DIVI.CanalVenta = "MOD" THEN DO:  /* SUPERMERCADOS */
                ASSIGN Faccpedi.FlgEst = "W".
            END.
            x-CodUbic = "ANPX".
        END.
        WHEN "WC" THEN DO:
            /* Pasa a ser aprobado por LOGISTICA */
            ASSIGN
                Faccpedi.Flgest = 'WL'.     /* Aprobaciòn por Logística */
            x-CodUbic = "ANPWX".
        END.
        WHEN "W" THEN DO:   /* Aprobado por Asistente de Gerencia General */
            ASSIGN
                Faccpedi.Flgest = 'WX'.     /* Aprobaciòn por Gerencia General */
            /* Provincias pasa a APROBACION POR LOGISTICA */
            IF GN-DIVI.CanalVenta = "PRO" THEN DO:  /* PROVINCIAS */
                ASSIGN Faccpedi.FlgEst = "WL".
            END.
            /* Supermercados pasa a APROBACION POR LOGISTICA */
            IF GN-DIVI.CanalVenta = "MOD" THEN DO:  /* SUPERMERCADOS */
                ASSIGN Faccpedi.FlgEst = "WL".
            END.
            /* RHC 18.04.2012 APROBACION AUTOMATICA (TEMPORAL) */
            IF Faccpedi.FlgEst = "WL" THEN Faccpedi.FlgEst = "P".
            /* ************************************ */
            x-CodUbic = "ANPWX".
        END.
    END CASE.
    /* TRACKING */
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            s-User-Id,
                            x-CodUbic,
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed).
    /* RHC 13.07.2012 GENERACION AUTOMATICA DE ORDENES DE DESPACHO */
    /* RHC 08/02/2018 Se puede crear una O/D o una OTR */
    DEF VAR hProc AS HANDLE NO-UNDO.
    DEF VAR pComprobante AS CHAR NO-UNDO.
    DEF VAR pFlgEst AS CHAR NO-UNDO.
    DEF VAR pRowid AS ROWID NO-UNDO.

    RUN vtagn/ventas-library PERSISTENT SET hProc.

    pMensaje = "".
    pRowid = ROWID(Faccpedi).
    pFlgEst = Faccpedi.FlgEst.  /* OJO */

    CASE TRUE:
        WHEN Faccpedi.CrossDocking = NO THEN DO:
            RUN VTA_Genera-OD IN hProc ( pRowid, OUTPUT pComprobante, OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO CICLO, LEAVE CICLO.
        END.
        WHEN Faccpedi.CrossDocking = YES THEN DO:
            RUN VTA_Genera-OTR IN hProc ( pRowid, OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO CICLO, LEAVE CICLO.
        END.
    END CASE.
    
    /* ********************************************************* */
    /* RHC 07/01/2020 ExpoBodega BONIFICACION amarrada al BONIFICACION */
    /* ********************************************************* */
    FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK.
    FIND BONIFICACION WHERE BONIFICACION.CodCia = Faccpedi.codcia AND
        BONIFICACION.CodDiv = Faccpedi.coddiv AND
        BONIFICACION.CodDoc = Faccpedi.coddoc AND
        BONIFICACION.CodRef = Faccpedi.codref AND
        BONIFICACION.NroRef = Faccpedi.nroref AND
        BONIFICACION.CodOrigen = Faccpedi.coddoc AND
        BONIFICACION.NroOrigen = Faccpedi.nroped NO-LOCK NO-ERROR.
    IF AVAILABLE BONIFICACION THEN DO:
        FIND CURRENT BONIFICACION EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="x-Cuenta"}
            UNDO CICLO, LEAVE CICLO.
        END.
        ASSIGN
            BONIFICACION.FlgEst = pFlgEst
            BONIFICACION.UsrAprobacion = Faccpedi.UsrAprobacion
            BONIFICACION.FchAprobacion = Faccpedi.FchAprobacion.
        pMensaje = "".
        CASE TRUE:
            WHEN BONIFICACION.CrossDocking = NO THEN DO:
                RUN VTA_Genera-OD IN hProc (ROWID(BONIFICACION), OUTPUT pComprobante, OUTPUT pMensaje).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO CICLO, LEAVE CICLO.
            END.
            WHEN BONIFICACION.CrossDocking = YES THEN DO:
                RUN VTA_Genera-OTR IN hProc (ROWID(BONIFICACION), OUTPUT pMensaje).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO CICLO, LEAVE CICLO.
            END.
        END CASE.
        RELEASE BONIFICACION.
    END.
    DELETE PROCEDURE hProc.
    /* ********************************************************* */
    FIND CURRENT Faccpedi NO-LOCK NO-ERROR.
END.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
RUN dispatch IN THIS-PROCEDURE ('open-query').
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar_en_revision B-table-Win 
PROCEDURE Aprobar_en_revision :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR pMensaje1 AS CHAR NO-UNDO.
DEFINE VAR iTotalRegsSele AS INT.
DEFINE VAR iRegsAprobados AS INT.

IF {&browse-name}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
    MESSAGE 'Debe seleccionar al menos 1 registro' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
MESSAGE 'Procedemos con la aprobación * ?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta-1 AS LOG.
IF rpta-1 = NO THEN RETURN 'ADM-ERROR'.
/* **************************************************************************** */


iTotalRegsSele = {&browse-name}:NUM-SELECTED-ROWS.

SESSION:SET-WAIT-STATE('GENERAL').

REPEAT k = 1 TO {&browse-name}:NUM-SELECTED-ROWS :

    IF NOT {&browse-name}:FETCH-SELECTED-ROW(k) THEN NEXT.

    pMensaje = "".
    RUN web/aprobacion-pedido-logistico.r(Faccpedi.coddoc, Faccpedi.nroped, s-flgest, OUTPUT pMensaje).

    IF pMensaje = "" THEN iRegsAprobados = iRegsAprobados + 1.
    IF pMensaje <> "" AND pMensaje1 = ""  THEN pMensaje1 = pMensaje.

END.
SESSION:SET-WAIT-STATE('').
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF pMensaje1 > '' THEN MESSAGE pMensaje1 VIEW-AS ALERT-BOX WARNING.
IF iRegsAprobados > 0 THEN DO:
    MESSAGE "Se aprobaron " + STRING(iRegsAprobados) + " orden(es) " SKIP
            "de un total de " + STRING(iTotalRegsSele)
        VIEW-AS ALERT-BOX INFORMATION.
END.

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-fech-hor-registro AS CHAR.
DEFINE VAR x-fech-hor-envio-a-cyc AS CHAR.

EMPTY TEMP-TABLE T-CPEDI.

SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND GN-DIVI.Campo-Log[1] = NO:
   IF COMBO-BOX-CodDiv = 'Todos' OR COMBO-BOX-CodDiv = gn-divi.coddiv THEN DO:
       x-division = gn-divi.coddiv.
       
       FOR EACH FacCPedi WHERE {&Condicion} NO-LOCK,
           FIRST gn-ven OF FacCPedi NO-LOCK,
           FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK:
           IF s-CndVta <> "" THEN DO:
               IF s-FlgEst = "X" THEN DO:
                   IF s-CndVta = 'CE'  AND LOOKUP(Faccpedi.fmapgo, '001,002') = 0 THEN NEXT.
                   IF s-CndVta = 'NCE' AND LOOKUP(Faccpedi.fmapgo, '001,002') > 0 THEN NEXT.
               END.
               IF LOOKUP(s-CndVta, 'CE,NCE') = 0
                   AND LOOKUP(Faccpedi.fmapgo, s-CndVta) = 0 THEN NEXT.
           END.
           IF NOT CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate <> 0 NO-LOCK)
               THEN DO:
               /*MESSAGE faccpedi.coddoc faccpedi.nroped 'dentro'.*/
               CREATE T-CPEDI.
               BUFFER-COPY Faccpedi TO T-CPEDI.
               /* 
                   Ic - 06Ago2020, Julissa Calderon adiciona columnass de Pedido y Envio a CyC
               */
               ASSIGN   T-CPEDI.libre_c02 = ""
                        T-CPEDI.libre_c03 = ""
                       T-CPEDI.libre_c04 = "".

               x-fech-hor-registro = "".
               x-fech-hor-envio-a-cyc = "".

               RUN datos-registro-pedido(INPUT faccpedi.coddiv, INPUT faccpedi.coddoc, 
                                         INPUT faccpedi.nroped, OUTPUT x-fech-hor-registro,
                                         OUTPUT x-fech-hor-envio-a-cyc).
               ASSIGN   
                   T-CPEDI.libre_c02 = CAPS(TRIM(gn-divi.desdiv)) + " (" + TRIM(gn-divi.coddiv) + ")"
                   T-CPEDI.libre_c03 = x-fech-hor-registro                       
                   T-CPEDI.fchimpOD = DATETIME(x-fech-hor-envio-a-cyc).    /* Para ordenamiento */
           END.
       END.

   END.
END.
/*
FOR EACH t-cpedi:
    MESSAGE t-cpedi.coddiv t-cpedi.coddoc t-cpedi.nroped.
END.
*/
/* RHC 07/01/2020 ExpoLibreros y ExpoBodega */
FOR EACH T-CPEDI WHERE T-CPEDI.CodOrigen = "PED":
    DELETE T-CPEDI.
END.


SESSION:SET-WAIT-STATE("").


/*
FOR EACH FacCPedi WHERE {&Condicion} NO-LOCK,
    FIRST gn-ven OF FacCPedi NO-LOCK,
    FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK:
    IF s-CndVta <> "" THEN DO:
        IF s-FlgEst = "X" THEN DO:
            IF s-CndVta = 'CE'  AND LOOKUP(Faccpedi.fmapgo, '001,002') = 0 THEN NEXT.
            IF s-CndVta = 'NCE' AND LOOKUP(Faccpedi.fmapgo, '001,002') > 0 THEN NEXT.
        END.
        IF LOOKUP(s-CndVta, 'CE,NCE') = 0
            AND LOOKUP(Faccpedi.fmapgo, s-CndVta) = 0 THEN NEXT.
    END.
    IF NOT CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate <> 0 NO-LOCK)
        THEN DO:
        CREATE T-CPEDI.
        BUFFER-COPY Faccpedi TO T-CPEDI.
        /* 
            Ic - 06Ago2020, Julissa Calderon adiciona columnass de Pedido y Envio a CyC
        */
        ASSIGN T-CPEDI.libre_c03 = ""
                T-CPEDI.libre_c04 = "".

        x-fech-hor-registro = "".
        x-fech-hor-envio-a-cyc = "".

        RUN datos-registro-pedido(INPUT faccpedi.coddiv, INPUT faccpedi.coddoc, 
                                  INPUT faccpedi.nroped, OUTPUT x-fech-hor-registro,
                                  OUTPUT x-fech-hor-envio-a-cyc).
        ASSIGN T-CPEDI.libre_c03 = x-fech-hor-registro
                T-CPEDI.libre_c04 = x-fech-hor-envio-a-cyc
                T-CPEDI.fchimpOD = DATETIME(x-fech-hor-envio-a-cyc).    /* Para ordenamiento */

    END.
END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cuenta-corriente B-table-Win 
PROCEDURE cuenta-corriente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE BUFFER b-t-cpedi FOR t-cpedi.

DEFINE VAR lTipoDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.
DEFINE VAR lParameter AS CHAR.

ltipodoc = "".
lnrodoc = "".

FIND FIRST b-t-cpedi NO-ERROR.
IF AVAILABLE b-t-cpedi THEN DO:

    RUN ccb/w-consul-cctv3.r(faccpedi.codcli).

END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE datos-registro-pedido B-table-Win 
PROCEDURE datos-registro-pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCoddiv AS CHAR.
DEFINE INPUT PARAMETER pCoddoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pFechaHoraRegistro AS CHAR.
DEFINE OUTPUT PARAMETER pFechaHoraEnvioCyC AS CHAR.

pFechaHoraRegistro = "".
pFechaHoraEnvioCyC = "".


FIND FIRST vtadtrkped WHERE vtadtrkped.codcia = s-codcia AND
                            vtadtrkped.coddiv = pCodDiv AND
                            vtadtrkped.coddoc = pCodDoc AND 
                            vtadtrkped.nroped = pNroDoc AND
                            vtadtrkped.codubic = 'GNP' NO-LOCK NO-ERROR.

IF AVAILABLE vtadtrkped THEN pFechaHoraRegistro = STRING(vtadtrkped.fechaI,"99/99/9999 HH:MM:SS").

FIND FIRST vtadtrkped WHERE vtadtrkped.codcia = s-codcia AND
                            vtadtrkped.coddiv = pCodDiv AND
                            vtadtrkped.coddoc = pCodDoc AND 
                            vtadtrkped.nroped = pNroDoc AND
                            vtadtrkped.codubic = 'PANPX' NO-LOCK NO-ERROR.

IF AVAILABLE vtadtrkped THEN pFechaHoraEnvioCyC = STRING(vtadtrkped.fechaI,"99/99/9999 HH:MM:SS").


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields B-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Faccpedi THEN FILL-IN-Glosa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Faccpedi.glosa.
  ELSE FILL-IN-Glosa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-CodDiv:DELETE(1).

      IF s-acceso-total = YES THEN DO:
          COMBO-BOX-CodDiv:SENSITIVE = YES.
          COMBO-BOX-CodDiv:ADD-LAST('< Todas las divisiones > ', "Todos").
      END.

      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia
          AND GN-DIVI.Campo-Log[1] = NO:
          COMBO-BOX-CodDiv:ADD-LAST( GN-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv).
          IF gn-divi.coddiv = s-coddiv THEN
              ASSIGN
              COMBO-BOX-CodDiv = s-coddiv
              COMBO-BOX-CodDiv:SCREEN-VALUE = s-coddiv.
      END.          

  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-changed B-table-Win 
PROCEDURE local-row-changed :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-changed':U ) .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rechazar B-table-Win 
PROCEDURE Rechazar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT.

IF {&browse-name}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
    MESSAGE 'Debe seleccionar al menos 1 registro' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.

MESSAGE 'Procedemos con el rechazo?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta-2 AS LOG.
IF rpta-2 = NO THEN RETURN 'ADM-ERROR'.

CICLO:
DO k = 1 TO {&browse-name}:NUM-SELECTED-ROWS TRANSACTION ON ERROR UNDO, NEXT ON STOP UNDO, NEXT:
    IF NOT {&browse-name}:FETCH-SELECTED-ROW(k) THEN NEXT.
    FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN NEXT CICLO.
    FIND CURRENT COTIZACION EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE COTIZACION THEN NEXT CICLO.

    x-division-veri = Faccpedi.CodDiv.

    /* Verificamos nuevamente */
    IF NOT {&CondicionVeri} 
        OR CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate <> 0 NO-LOCK)
        THEN DO:
        MESSAGE 'El documento' Faccpedi.coddoc Faccpedi.nroped 'ya NO se encuentra pendiente de rechazo'
            VIEW-AS ALERT-BOX ERROR.
        FIND CURRENT Faccpedi NO-LOCK NO-ERROR.
        NEXT.
    END.
    ASSIGN
        Faccpedi.Flgest = 'R'
        Faccpedi.UsrAprobacion = s-user-id
        Faccpedi.FchAprobacion = TODAY.
    ASSIGN
        COTIZACION.FlgEst = "P".
    /* TRACKING */
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            s-User-Id,
                            'GNP',
                            'R',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed).
    FOR EACH FacDPedi OF Faccpedi,
        FIRST B-DPEDI WHERE B-DPEDI.CodCia = COTIZACION.CodCia
            AND  B-DPEDI.CodDiv = COTIZACION.CodDiv       /* OJO */
            AND  B-DPEDI.CodDoc = COTIZACION.CodDoc       /* OJO */
            AND  B-DPEDI.NroPed = COTIZACION.NroPed       /* OJO */
            AND  B-DPEDI.CodMat = Facdpedi.CodMat:
        ASSIGN 
            FacDPedi.Flgest = Faccpedi.Flgest.    /* <<< OJO <<< */
        ASSIGN
            B-DPEDI.FlgEst = "P"
            B-DPEDI.CanAte = B-DPEDI.CanAte - (Facdpedi.CanPed - Facdpedi.CanAte).  /* <<<< OJO <<<< */
    END.
END.
IF AVAILABLE(Faccpedi)      THEN RELEASE Faccpedi.
IF AVAILABLE(COTIZACION)    THEN RELEASE COTIZACION.
IF AVAILABLE(B-DPEDI)       THEN RELEASE B-DPEDI.

RUN dispatch IN THIS-PROCEDURE ('open-query').
RETURN "OK".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE riesgo-crediticio B-table-Win 
PROCEDURE riesgo-crediticio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAM pBuscarComoDNI AS LOG.

DEFINE BUFFER b-t-cpedi FOR t-cpedi.
DEFINE BUFFER b-gn-clie FOR gn-clie.

DEFINE VAR lTipoDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.
DEFINE VAR lParameter AS CHAR.

ltipodoc = "".
lnrodoc = "".

FIND FIRST b-t-cpedi NO-ERROR.
IF AVAILABLE b-t-cpedi THEN DO:
    FIND FIRST b-gn-clie WHERE b-gn-clie.codcia = 0 AND 
                                b-gn-clie.codcli = faccpedi.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE b-gn-clie THEN DO:
        if TRUE <> (b-gn-clie.ruc > "") THEN DO:
            MESSAGE "Codigo de CLiente(" + faccpedi.codcli + ") no tiene RUC ni tampoco DNI".
        END.
        ELSE DO:
            lnrodoc = b-gn-clie.ruc.
            IF LENGTH(b-gn-clie.ruc)=8 THEN ltipodoc = 'D'.
            IF LENGTH(b-gn-clie.ruc)=11 THEN ltipodoc = 'R'.
            IF ltipodoc <> "" THEN DO:
                IF ltipodoc = 'R' THEN DO:
                    /* Buscar con DNI */
                    IF SUBSTRING(b-gn-clie.ruc,1,2)='10' AND pBuscarComoDNI THEN DO:
                        ltipodoc = 'D'.
                        lnrodoc = SUBSTRING(b-gn-clie.ruc,3,8).
                    END.
                END.
                /* - */
                lParameter = lTipoDoc + "|" + lNroDoc.
                RUN ccb/w-sentinel-rcrediticio.r(INPUT lParameter).
                /*RUN ccb/w-sentinel-rcrediticio.r(INPUT ltipodoc, INPUT lnrodoc).*/
            END.
            ELSE DO:
                MESSAGE "Imposible identificar si es un RUC o DNI".
            END.
        END.
    END.
    ELSE DO:
        MESSAGE "Codigo de CLiente(" + faccpedi.codcli + ") no existe en la maestra de Cliente".
    END.
END.

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
  {src/adm/template/snd-list.i "T-CPEDI"}
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "gn-ven"}
  {src/adm/template/snd-list.i "gn-ConVt"}
  {src/adm/template/snd-list.i "COTIZACION"}

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

