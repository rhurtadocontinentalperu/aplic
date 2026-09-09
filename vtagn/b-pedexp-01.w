&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE B-CPEDI NO-UNDO LIKE VtaCDocu
       INDEX Llave01 AS PRIMARY Libre_d01.
DEFINE BUFFER BCPEDI FOR VtaCDocu.
DEFINE SHARED TEMP-TABLE T-DDOCU NO-UNDO LIKE VtaDDocu.



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
DEF SHARED VAR lh_Handle AS HANDLE.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'COT' NO-UNDO.

DEF TEMP-TABLE T-CPEDI LIKE B-CPEDI.
DEF BUFFER BB-CPEDI FOR B-CPEDI.
DEF BUFFER BT-DDOCU FOR T-DDOCU.

/* ACUMULADO POR PRODUCTO */
DEF TEMP-TABLE Resumen
    FIELD codcia LIKE VtaDDocu.codcia
    FIELD codmat LIKE VtaDDocu.codmat
    FIELD codalm LIKE almmmate.codalm
    FIELD canped LIKE VtaDDocu.canped
    FIELD stkact LIKE almmmate.stkact.

DEF VAR s-Inicia-Busqueda AS LOGIC INIT FALSE.
DEF VAR s-Registro-Actual AS ROWID.

DEFINE VARIABLE S-FLGIGV AS LOGICAL.
DEFINE VARIABLE S-PORIGV AS DECIMAL.

/* Importe Mínimo del Pedido*/
DEF VAR pImpMin AS DEC NO-UNDO.

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
&Scoped-define INTERNAL-TABLES B-CPEDI

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table B-CPEDI.Libre_d01 B-CPEDI.NroPed ~
B-CPEDI.CodVen B-CPEDI.FmaPgo B-CPEDI.NomCli B-CPEDI.FchPed B-CPEDI.FchEnt ~
B-CPEDI.Importe[1] B-CPEDI.Libre_d02 B-CPEDI.ImpTot B-CPEDI.Importe[2] ~
B-CPEDI.Importe[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH B-CPEDI WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH B-CPEDI WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table B-CPEDI
&Scoped-define FIRST-TABLE-IN-QUERY-br_table B-CPEDI


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 BUTTON-10 BUTTON-11 BUTTON-6 ~
BUTTON-2 BUTTON-3 BUTTON-7 BUTTON-4 FILL-IN-NomCli br_table 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-1 x-FmaPgo x-ImpTot ~
FILL-IN-NomCli f-Mensaje 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _ImpBD B-table-Win 
FUNCTION _ImpBD RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _ImpCcb B-table-Win 
FUNCTION _ImpCcb RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br_table 
       MENU-ITEM m_Abonos       LABEL "Abonos"        
       MENU-ITEM m_Cargos       LABEL "Cargos"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-10 
     LABEL "Buscar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-11 
     LABEL "Buscar Siguiente" 
     SIZE 16 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "SUBIR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "BAJAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-4 
     LABEL "ELIMINAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-6 
     LABEL "PONER PRIMERO" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-7 
     LABEL "PONER ULTIMO" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE x-FmaPgo AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Condicion" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","001 - CONTADO CONTRA ENTREGA","400 - LETRA CAMPAÑA P.PROP. VENCTOS 15 Y 25 FEB, 8 MAR","401 - LETRA CAMPAÑA PROD. TERC. VENCTOS 2, 9 Y 16 MAR" 
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre:" 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE x-ImpTot AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Monto mínimo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Fecha de entrega", 1,
"Saldo del depósito", 2,
"Nombre del cliente", 3
     SIZE 50 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 2.42.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66 BY 2.42.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      B-CPEDI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      B-CPEDI.Libre_d01 COLUMN-LABEL "Orden" FORMAT ">>>9":U
      B-CPEDI.NroPed COLUMN-LABEL "Cotizacion" FORMAT "X(9)":U
            WIDTH 10
      B-CPEDI.CodVen FORMAT "x(5)":U
      B-CPEDI.FmaPgo COLUMN-LABEL "Condicion" FORMAT "x(5)":U WIDTH 7
      B-CPEDI.NomCli COLUMN-LABEL "Nombre del Cliente" FORMAT "x(60)":U
            WIDTH 28.43
      B-CPEDI.FchPed COLUMN-LABEL "Fecha Cotizacion" FORMAT "99/99/99":U
      B-CPEDI.FchEnt FORMAT "99/99/99":U
      B-CPEDI.Importe[1] COLUMN-LABEL "Importe Total" FORMAT "->>,>>>,>>9.99":U
      B-CPEDI.Libre_d02 COLUMN-LABEL "Saldo Actual" FORMAT "->>,>>>,>>9.99":U
      B-CPEDI.ImpTot COLUMN-LABEL "Proyectado" FORMAT "->>>,>>>,>>9.99":U
      B-CPEDI.Importe[2] COLUMN-LABEL "Saldo de Depósitos!y Notas de Crédito" FORMAT ">,>>>,>>9.99":U
      B-CPEDI.Importe[3] COLUMN-LABEL "Saldo de Cobranzas!y Pedidos en trámite" FORMAT ">,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 145 BY 7.81
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-1 AT ROW 1.81 COL 3 NO-LABEL WIDGET-ID 30
     x-FmaPgo AT ROW 1.81 COL 79 COLON-ALIGNED WIDGET-ID 38
     x-ImpTot AT ROW 2.62 COL 79 COLON-ALIGNED WIDGET-ID 40
     BUTTON-10 AT ROW 3.69 COL 40 WIDGET-ID 8
     BUTTON-11 AT ROW 3.69 COL 55 WIDGET-ID 10
     BUTTON-6 AT ROW 3.69 COL 71 WIDGET-ID 18
     BUTTON-2 AT ROW 3.69 COL 86 WIDGET-ID 22
     BUTTON-3 AT ROW 3.69 COL 101 WIDGET-ID 24
     BUTTON-7 AT ROW 3.69 COL 116 WIDGET-ID 20
     BUTTON-4 AT ROW 3.69 COL 131 WIDGET-ID 12
     FILL-IN-NomCli AT ROW 3.96 COL 5.57 COLON-ALIGNED WIDGET-ID 6
     br_table AT ROW 5.04 COL 1
     f-Mensaje AT ROW 13.12 COL 94 NO-LABEL WIDGET-ID 2
     "Filtros para la PROYECCION" VIEW-AS TEXT
          SIZE 20 BY .5 AT ROW 1 COL 68 WIDGET-ID 42
          BGCOLOR 7 FGCOLOR 15 
     "Ordenado por" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 1 COL 3 WIDGET-ID 34
          BGCOLOR 7 FGCOLOR 15 
     "PUEDE MARCAR VARIOS REGISTROS PARA ELIMINAR" VIEW-AS TEXT
          SIZE 45 BY .5 AT ROW 13.12 COL 2 WIDGET-ID 26
          BGCOLOR 7 FGCOLOR 15 
     "Pulse botón derecho sobre un registro para consultar más detalles" VIEW-AS TEXT
          SIZE 45 BY .5 AT ROW 13.65 COL 2 WIDGET-ID 36
          BGCOLOR 7 FGCOLOR 15 
     RECT-1 AT ROW 1.27 COL 67 WIDGET-ID 44
     RECT-2 AT ROW 1.27 COL 1 WIDGET-ID 46
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
      TABLE: B-CPEDI T "SHARED" NO-UNDO INTEGRAL VtaCDocu
      ADDITIONAL-FIELDS:
          INDEX Llave01 AS PRIMARY Libre_d01
      END-FIELDS.
      TABLE: BCPEDI B "?" ? INTEGRAL VtaCDocu
      TABLE: T-DDOCU T "SHARED" NO-UNDO INTEGRAL VtaDDocu
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
         HEIGHT             = 13.46
         WIDTH              = 145.72.
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
/* BROWSE-TAB br_table FILL-IN-NomCli F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-br_table:HANDLE.

/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR RADIO-SET RADIO-SET-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX x-FmaPgo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.B-CPEDI"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.B-CPEDI.Libre_d01
"B-CPEDI.Libre_d01" "Orden" ">>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.B-CPEDI.NroPed
"B-CPEDI.NroPed" "Cotizacion" ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.B-CPEDI.CodVen
"B-CPEDI.CodVen" ? "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.B-CPEDI.FmaPgo
"B-CPEDI.FmaPgo" "Condicion" "x(5)" "character" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.B-CPEDI.NomCli
"B-CPEDI.NomCli" "Nombre del Cliente" ? "character" ? ? ? ? ? ? no ? no no "28.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.B-CPEDI.FchPed
"B-CPEDI.FchPed" "Fecha Cotizacion" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.B-CPEDI.FchEnt
     _FldNameList[8]   > Temp-Tables.B-CPEDI.Importe[1]
"B-CPEDI.Importe[1]" "Importe Total" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.B-CPEDI.Libre_d02
"B-CPEDI.Libre_d02" "Saldo Actual" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.B-CPEDI.ImpTot
"B-CPEDI.ImpTot" "Proyectado" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.B-CPEDI.Importe[2]
"B-CPEDI.Importe[2]" "Saldo de Depósitos!y Notas de Crédito" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.B-CPEDI.Importe[3]
"B-CPEDI.Importe[3]" "Saldo de Cobranzas!y Pedidos en trámite" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 B-table-Win
ON CHOOSE OF BUTTON-10 IN FRAME F-Main /* Buscar */
DO:
    ASSIGN
      s-Inicia-Busqueda = YES
      s-Registro-Actual = ?
      FILL-IN-NomCli.
    FOR EACH B-CPEDI NO-LOCK:
      IF INDEX(B-CPEDI.nomcli, FILL-IN-NomCli:SCREEN-VALUE) > 0
      THEN DO:
          ASSIGN
              s-Registro-Actual = ROWID(B-CPEDI).
          REPOSITION {&BROWSE-NAME} TO ROWID s-Registro-Actual.
          LEAVE.
      END.
    END.      
    IF s-Registro-Actual = ? THEN MESSAGE 'Fin de búsqueda' VIEW-AS ALERT-BOX WARNING.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 B-table-Win
ON CHOOSE OF BUTTON-11 IN FRAME F-Main /* Buscar Siguiente */
DO:
    IF s-Registro-Actual = ? THEN RETURN.
    GET NEXT {&BROWSE-NAME}.
    REPEAT WHILE AVAILABLE B-CPEDI:
      IF INDEX(B-CPEDI.nomcli, FILL-IN-NomCli:SCREEN-VALUE) > 0
      THEN DO:
          ASSIGN
              s-Registro-Actual = ROWID(B-CPEDI).
              REPOSITION {&BROWSE-NAME} TO ROWID s-Registro-Actual.
              LEAVE.
      END.
      GET NEXT {&BROWSE-NAME}.
    END.
    IF NOT AVAILABLE B-CPEDI THEN s-Registro-Actual = ?.
    IF s-Registro-Actual = ? THEN MESSAGE 'Fin de búsqueda' VIEW-AS ALERT-BOX WARNING.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 B-table-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* SUBIR */
DO:
  RUN Subir.
  /*RUN dispatch IN h_b-preped-01a ('row-available').*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 B-table-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* BAJAR */
DO:
  RUN Bajar.
  /*RUN dispatch IN h_b-preped-01a ('row-available').*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 B-table-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* ELIMINAR */
DO:
    MESSAGE 'Eliminamos el registro' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
    RUN Eliminar.
    /*RUN dispatch IN h_b-preped-01a ('row-available').*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 B-table-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* PONER PRIMERO */
DO:
    RUN Poner-Primero.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 B-table-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* PONER ULTIMO */
DO:
    RUN Poner-Ultimo.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Abonos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Abonos B-table-Win
ON CHOOSE OF MENU-ITEM m_Abonos /* Abonos */
DO:
  IF AVAILABLE B-CPEDI THEN
  RUN vtaexp/d-preped-03a (B-CPEDI.CodCli).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Cargos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Cargos B-table-Win
ON CHOOSE OF MENU-ITEM m_Cargos /* Cargos */
DO:
    IF AVAILABLE B-CPEDI THEN
    RUN vtaexp/d-preped-03b (B-CPEDI.CodCli).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 B-table-Win
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME F-Main
DO:
  ASSIGN radio-set-1.
  RUN Reordena (radio-set-1).
  RUN dispatch IN THIS-PROCEDURE ('open-query').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FmaPgo B-table-Win
ON VALUE-CHANGED OF x-FmaPgo IN FRAME F-Main /* Condicion */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-ImpTot
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-ImpTot B-table-Win
ON LEAVE OF x-ImpTot IN FRAME F-Main /* Monto mínimo */
DO:
    ASSIGN {&self-name}.
    IF x-ImpTot < pImpMin THEN DO:
        DISPLAY pIMpMin @ x-ImpTot WITH FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Bajar B-table-Win 
PROCEDURE Bajar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR iOrden AS INT NO-UNDO.
DEF VAR xOrden AS INT NO-UNDO.
DEF VAR rRecord AS RAW NO-UNDO.

IF NOT AVAILABLE B-CPEDI THEN RETURN.

iOrden = B-CPEDI.Libre_d01.
FIND LAST BB-CPEDI.
IF iOrden = BB-CPEDI.Libre_d01 THEN RETURN.
RAW-TRANSFER B-CPEDI TO rRecord.
DELETE B-CPEDI.

FIND B-CPEDI WHERE B-CPEDI.Libre_d01 = iOrden + 1.
B-CPEDI.Libre_d01 = iOrden.
CREATE B-CPEDI.
RAW-TRANSFER rRecord TO B-CPEDI.
B-CPEDI.Libre_d01 = iOrden + 1.

RUN dispatch IN THIS-PROCEDURE ('open-query').
FIND B-CPEDI WHERE B-CPEDI.Libre_d01 = iOrden + 1.
REPOSITION {&BROWSE-NAME} TO ROWID ROWID(B-CPEDI).
RUN dispatch IN THIS-PROCEDURE ('row-changed').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Prepedidos-Pendientes B-table-Win 
PROCEDURE Borra-Prepedidos-Pendientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR iOrden AS INT INIT 0 NO-UNDO.    

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH BCPEDI WHERE BCPEDI.codcia = s-codcia
            AND BCPEDI.coddiv = s-coddiv
            AND BCPEDI.codped = 'PPD'
            AND BCPEDI.flgest = 'P'
            BY BCPEDI.nroped:
        /* extornamos cotizaciones */
        RUN vtagn/p-actualiza-cotizacion ( ROWID(BCPEDI) , -1 ).       /* Descarga COT */
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        ASSIGN 
            BCPEDI.flgest = 'A'
            BCPEDI.FchAnu = TODAY
            BCPEDI.UsrAnu = s-user-id.
        /* cargamos la cotizacion */
        FIND Vtacdocu WHERE Vtacdocu.codcia = s-codcia
            AND Vtacdocu.codped = BCPEDI.codref
            AND Vtacdocu.nroped = BCPEDI.nroref
            NO-LOCK.
        f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Procesando ' + VtaCDocu.codped + ' ' + VtaCDocu.nroped.
        iOrden = iOrden + 1.
        BUFFER-COPY VtaCDocu 
            EXCEPT VtaCDocu.ImpTot VtaCDocu.Libre_d02
            TO B-CPEDI
            ASSIGN
                B-CPEDI.Libre_d01 = iOrden
                B-CPEDI.Importe[1] = VtaCDocu.ImpTot
                B-CPEDI.Importe[2] = _ImpBD()           /* Importe de depósitos y adelantos */
                B-CPEDI.Importe[3] = _ImpCcb().         /* Importe de PED, PPD y Comprobantes pendientes */
    END.
END.

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
DEF INPUT PARAMETER pFchEnt AS DATE.
DEF INPUT PARAMETER pRegistros AS INT.

DEF VAR iOrden AS INT INIT 1 NO-UNDO.

/* ALMACEN DE DESCARGA */
FIND FIRST VtaAlmDiv WHERE VtaAlmDiv.CodCia = s-codcia
    AND VtaAlmDiv.CodDiv = s-coddiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaAlmDiv THEN DO:
    MESSAGE 'Debe definir el almacén de descarga para la división' s-coddiv
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

FOR EACH B-CPEDI:
    DELETE B-CPEDI.
END.
FOR EACH T-DDOCU:
    DELETE T-DDOCU.
END.

/* Cargamos Pre-Pedidos pendientes */
RUN Borra-Prepedidos-Pendientes.
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.
FIND LAST B-CPEDI NO-LOCK NO-ERROR.
IF AVAILABLE B-CPEDI THEN iOrden = B-CPEDI.Libre_d01 + 1.

/* COTIZACIONES POR ATENDER CLIENTES VIP */
IF iOrden <= pRegistros THEN DO:
    FOR EACH VtaCDocu NO-LOCK WHERE VtaCDocu.codcia = s-codcia
        AND VtaCDocu.coddiv = s-coddiv
        AND VtaCDocu.codped = "COT"
        AND VtaCDocu.flgest = 'P'
        AND VtaCDocu.fchent <= pFchEnt,
        FIRST VtaCliVip NO-LOCK WHERE Vtaclivip.codcia = s-codcia
            AND Vtaclivip.coddiv = s-coddiv
            AND Vtaclivip.codcli = Vtacdocu.codcli
        BY VtaCDocu.FchEnt BY VtaCDocu.ImpTot DESC:
        /* Filtro */
        FIND FIRST B-CPEDI WHERE B-CPEDI.NroPed = VtaCDocu.NroPed NO-LOCK NO-ERROR.
        IF AVAILABLE B-CPEDI THEN NEXT.
        /* ****** */
        f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Procesando ' + VtaCDocu.codped + ' ' + VtaCDocu.nroped.
        CREATE B-CPEDI.
        BUFFER-COPY VtaCDocu 
            EXCEPT VtaCDocu.ImpTot VtaCDocu.Libre_d02
            TO B-CPEDI
            ASSIGN
                B-CPEDI.Libre_d01 = iOrden
                B-CPEDI.Importe[1] = VtaCDocu.ImpTot
                B-CPEDI.Importe[2] = _ImpBD()   /* Importe de depósitos y adelantos */
                B-CPEDI.Importe[3] = _ImpCcb()  /* Importe de PED, PPD y Comprobantes pendientes */
        iOrden = iOrden + 1.
        IF iOrden > pRegistros THEN LEAVE.
    END.
END.
/* COTIZACIONES POR ATENDER */
IF iOrden <= pRegistros THEN DO:
    FOR EACH VtaCDocu NO-LOCK WHERE VtaCDocu.codcia = s-codcia
        AND VtaCDocu.coddiv = s-coddiv
        AND VtaCDocu.codped = "COT"
        AND VtaCDocu.flgest = 'P'
        AND VtaCDocu.fchent <= pFchEnt
        BY VtaCDocu.FchEnt BY VtaCDocu.ImpTot DESC:
        /* Filtro */
        FIND FIRST B-CPEDI WHERE B-CPEDI.NroPed = VtaCDocu.NroPed NO-LOCK NO-ERROR.
        IF AVAILABLE B-CPEDI THEN NEXT.
        /* ****** */
        f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Procesando ' + VtaCDocu.codped + ' ' + VtaCDocu.nroped.
        CREATE B-CPEDI.
        BUFFER-COPY VtaCDocu 
            EXCEPT VtaCDocu.ImpTot VtaCDocu.Libre_d02
            TO B-CPEDI
            ASSIGN
                B-CPEDI.Libre_d01 = iOrden
                B-CPEDI.Importe[1] = VtaCDocu.ImpTot
                B-CPEDI.Importe[2] = _ImpBD()   /* Importe de depósitos y adelantos */
                B-CPEDI.Importe[3] = _ImpCcb()  /* Importe de PED, PPD y Comprobantes pendientes */
        iOrden = iOrden + 1.
        IF iOrden > pRegistros THEN LEAVE.
    END.
END.
/* TOTALES */
FOR EACH B-CPEDI, 
    EACH Vtaddocu NO-LOCK WHERE Vtaddocu.codcia = B-CPEDI.codcia
    AND Vtaddocu.codped = B-CPEDI.CodPed
    AND Vtaddocu.nroped = B-CPEDI.NroPed 
    AND (Vtaddocu.CanPed - Vtaddocu.CanAte) > 0:
    ASSIGN
        s-PorIgv = B-CPEDI.PorIgv
        s-FlgIgv = B-CPEDI.FlgIgv.
    CREATE T-DDOCU.
    BUFFER-COPY Vtaddocu
        EXCEPT Vtaddocu.CanPed Vtaddocu.CanAte Vtaddocu.Libre_d01 Vtaddocu.Libre_d02
        TO T-DDOCU
        ASSIGN
        T-DDOCU.AlmDes    = VtaAlmDiv.CodAlm
        T-DDOCU.CanBase   = Vtaddocu.CanPed                         /* Cotizado */
        T-DDOCU.Libre_d01 = (Vtaddocu.CanPed - Vtaddocu.CanAte)     /* Por Atender */
        T-DDOCU.Libre_d02 = Vtaddocu.CanAte.                        /* Atendido a la fecha*/
    IF  T-DDOCU.Libre_d01 <> T-DDOCU.CanBase THEN DO:
        ASSIGN
            T-DDOCU.CanPed = (Vtaddocu.CanPed - Vtaddocu.CanAte).   /* Solo para el calculo */
        {vtagn/i-vtaddocu-01.i}
        ASSIGN
            T-DDOCU.CanPed = 0.
    END.
    FOR EACH T-DDOCU WHERE T-DDOCU.codcia = B-CPEDI.codcia
        AND T-DDOCU.codped = B-CPEDI.codped
        AND T-DDOCU.nroped = B-CPEDI.nroped:
        B-CPEDI.Libre_d02 = B-CPEDI.Libre_d02 + T-DDOCU.ImpLin.     /* Saldo */
    END.
END.
Radio-set-1 = 1.
DISPLAY
    Radio-set-1 WITH FRAME {&FRAME-NAME}.
ASSIGN
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''
    radio-set-1:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    x-FmaPgo:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    x-ImpTot:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Eliminar B-table-Win 
PROCEDURE Eliminar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR iOrden AS INT NO-UNDO.
DEF VAR xOrden AS INT NO-UNDO.
DEF VAR rRecord AS RAW NO-UNDO.
DEF VAR iItems AS INT NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR'
    WITH FRAME {&FRAME-NAME}:
    IF {&browse-name}:NUM-SELECTED-ROWS = 0 THEN RETURN 'OK'.
    DO iItems = 1 TO {&browse-name}:NUM-SELECTED-ROWS:
        IF {&browse-name}:FETCH-SELECTED-ROW(iItems) THEN DO:
            FIND VtaCDocu OF B-CPEDI EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE VtaCDocu THEN UNDO, RETURN 'ADM-ERROR'.
            IF VtaCDocu.FlgEst = 'T' 
                THEN ASSIGN
                        VtaCDocu.flgest = 'P'.  /* Lo regresamos al estado anterior */
            RELEASE VtaCDocu.
            DELETE B-CPEDI.
        END.
    END.
END.
xOrden = 1.
FOR EACH B-CPEDI:
    B-CPEDI.Libre_d01 = xOrden.
    xOrden = xOrden + 1.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query').

/* IF NOT AVAILABLE B-CPEDI THEN RETURN. */
/* iOrden = B-CPEDI.Libre_d01.                                                       */
/* DELETE B-CPEDI.                                                                   */
/*                                                                                   */
/* xOrden = 1.                                                                       */
/* FOR EACH B-CPEDI:                                                                 */
/*     B-CPEDI.Libre_d01 = xOrden.                                                   */
/*     xOrden = xOrden + 1.                                                          */
/* END.                                                                              */
/* RUN dispatch IN THIS-PROCEDURE ('open-query').                                    */
/* FIND B-CPEDI WHERE B-CPEDI.Libre_d01 = iOrden NO-ERROR.                           */
/* IF NOT AVAILABLE B-CPEDI THEN FIND PREV B-CPEDI WHERE B-CPEDI.Libre_d01 = iOrden. */
/* REPOSITION {&BROWSE-NAME} TO ROWID ROWID(B-CPEDI).                                */
/* RUN dispatch IN THIS-PROCEDURE ('row-changed').                                   */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Eliminar-Todo B-table-Win 
PROCEDURE Eliminar-Todo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR'
    WITH FRAME {&FRAME-NAME}:
    FOR EACH B-CPEDI:
        FIND VtaCDocu OF B-CPEDI EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaCDocu THEN UNDO, RETURN 'ADM-ERROR'.
        IF VtaCDocu.FlgEst = 'T' THEN VtaCDocu.flgest = 'P'.  /* Lo regresamo al estado anterior */
        RELEASE VtaCDocu.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE cFila1 AS CHAR FORMAT 'X' INIT ''.
DEFINE VARIABLE cFila2 AS CHAR FORMAT 'X' INIT ''.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Orden".
cRange = "B" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Cotizacion".
cRange = "C" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Promotor".
cRange = "D" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Vendedor".
cRange = "E" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Condicion".
cRange = "F" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Cliente".
cRange = "G" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Nombre".
cRange = "H" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Fecha Cotizacion".
cRange = "I" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Fecha Entrega".
cRange = "J" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Importe Total".
cRange = "K" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Saldo Actual".
cRange = "L" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Proyectado".
cRange = "M" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Saldo Depósitos".
cRange = "N" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Saldo por Cobrar".

/* BARREMOS TODOS LOS PRODUCTOS */
FOR EACH B-CPEDI:
    t-column = t-column + 1.                                                                                                                               
    cColumn = STRING(t-Column).                                                                                        
    cRange = "A" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = B-CPEDI.Libre_d01.
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = B-CPEDI.NroPed. 
    FIND FIRST ExpPromotor WHERE ExpPromotor.CodCia = s-CodCia
        AND ExpPromotor.CodDiv = s-CodDiv
        AND ExpPromotor.CodVen = B-CPEDI.CodVen
        NO-LOCK NO-ERROR.
    IF AVAILABLE ExpPromotor THEN DO:
        cRange = "C" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = ExpPromotor.Usuario.
    END.
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + B-CPEDI.CodVen.
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + B-CPEDI.FmaPgo.
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + B-CPEDI.CodCli.
    cRange = "G" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + B-CPEDI.NomCli.
    cRange = "H" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = B-CPEDI.FchPed.
    cRange = "I" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = B-CPEDI.FchEnt.
    cRange = "J" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = B-CPEDI.Importe[1].
    cRange = "K" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = B-CPEDI.ImpTot.
    cRange = "L" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = B-CPEDI.Libre_d02.
    cRange = "M" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = B-CPEDI.Importe[2].
    cRange = "N" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = B-CPEDI.Importe[3].
END.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FOR EACH T-DDOCU WHERE T-DDOCU.codcia = B-CPEDI.codcia
        AND T-DDOCU.codped = B-CPEDI.codped
        AND T-DDOCU.nroped = B-CPEDI.nroped:
      DELETE T-DDOCU.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


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
  RUN gn/pMinCotPed (s-CodCia,
                     s-CodDiv,
                     'PED',
                     OUTPUT pImpMin).
  x-ImpTot = pImpMin.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Poner-Primero B-table-Win 
PROCEDURE Poner-Primero :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR iOrden AS INT NO-UNDO.
DEF VAR xOrden AS INT NO-UNDO.
DEF VAR rRecord AS RAW NO-UNDO.

IF NOT AVAILABLE B-CPEDI THEN RETURN.

iOrden = B-CPEDI.Libre_d01.
IF iOrden = 1 THEN RETURN.
RAW-TRANSFER B-CPEDI TO rRecord.
DELETE B-CPEDI.

FOR EACH T-CPEDI:
    DELETE T-CPEDI.
END.

xOrden = 2.
FOR EACH B-CPEDI BY B-CPEDI.Libre_d01:
    CREATE T-CPEDI.
    BUFFER-COPY B-CPEDI TO T-CPEDI
        ASSIGN T-CPEDI.Libre_d01 = xOrden.
    xOrden = xOrden + 1.
    DELETE B-CPEDI.
END.

CREATE T-CPEDI.
RAW-TRANSFER rRecord TO T-CPEDI.
ASSIGN T-CPEDI.Libre_d01 = 1.

FOR EACH T-CPEDI:
    CREATE B-CPEDI.
    BUFFER-COPY T-CPEDI TO B-CPEDI.
END.

RUN dispatch IN THIS-PROCEDURE ('open-query').
FIND B-CPEDI WHERE B-CPEDI.Libre_d01 = 1.
REPOSITION {&BROWSE-NAME} TO ROWID ROWID(B-CPEDI).
RUN dispatch IN THIS-PROCEDURE ('row-changed').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Poner-Ultimo B-table-Win 
PROCEDURE Poner-Ultimo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR iOrden AS INT NO-UNDO.
DEF VAR xOrden AS INT NO-UNDO.
DEF VAR rRecord AS RAW NO-UNDO.

IF NOT AVAILABLE B-CPEDI THEN RETURN.

iOrden = B-CPEDI.Libre_d01.
FIND LAST BB-CPEDI.
IF iOrden = BB-CPEDI.Libre_d01 THEN RETURN.
RAW-TRANSFER B-CPEDI TO rRecord.
DELETE B-CPEDI.

FOR EACH T-CPEDI:
    DELETE T-CPEDI.
END.

xOrden = 1.
FOR EACH B-CPEDI BY B-CPEDI.Libre_d01:
    CREATE T-CPEDI.
    BUFFER-COPY B-CPEDI TO T-CPEDI
        ASSIGN T-CPEDI.Libre_d01 = xOrden.
    xOrden = xOrden + 1.
    DELETE B-CPEDI.
END.

CREATE T-CPEDI.
RAW-TRANSFER rRecord TO T-CPEDI.
ASSIGN T-CPEDI.Libre_d01 = xOrden.

FOR EACH T-CPEDI:
    CREATE B-CPEDI.
    BUFFER-COPY T-CPEDI TO B-CPEDI.
END.

RUN dispatch IN THIS-PROCEDURE ('open-query').
FIND B-CPEDI WHERE B-CPEDI.Libre_d01 = xOrden.
REPOSITION {&BROWSE-NAME} TO ROWID ROWID(B-CPEDI).
RUN dispatch IN THIS-PROCEDURE ('row-changed').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Proyeccion B-table-Win 
PROCEDURE Proyeccion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR x-StkComprometido AS DEC NO-UNDO.
DEF VAR x-ImpLin AS DEC NO-UNDO.
DEF VAR x-ImpDto AS DEC NO-UNDO.
DEF VAR pFmaPgo LIKE VtaCDocu.fmapgo NO-UNDO.
DEF VAR xOrden AS INT NO-UNDO.

IF x-FmaPgo <> 'Todos' THEN DO:
    pFmaPgo = SUBSTRING(x-Fmapgo,1,INDEX(x-FmaPgo, '-') - 2).
END.

/* limpiamos la informacion */
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    LIMPIAMOS:
    FOR EACH B-CPEDI:
        f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'REVISANDO ' + B-CPEDI.codped + ' ' + B-CPEDI.nroped.
        /* ELIMINAMOS LAS QUE NO CUMPLEN LA CONDICION DE VENTA */
        IF NOT (x-FmaPgo = 'Todos' OR B-CPEDI.FmaPgo = pFmaPgo) THEN DO:
            DELETE B-CPEDI.
            NEXT LIMPIAMOS.
        END.
        /* ********************************************** */
        FIND VtaCDocu OF B-CPEDI EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaCDocu THEN UNDO, RETURN 'ADM-ERROR'.
        ASSIGN
            B-CPEDI.ImpTot = 0.      /* Proyectado Cabecera */
        FOR EACH T-DDOCU WHERE T-DDOCU.codcia = B-CPEDI.codcia
            AND T-DDOCU.codped = B-CPEDI.codped
            AND T-DDOCU.nroped = B-CPEDI.nroped:
            ASSIGN
                T-DDOCU.canate = 0     
                T-DDOCU.canped = 0. /* Proyectado Detalle */
        END.
        /* rhc 21.12.09 marcamos la que están en proceso */
        IF VtaCDocu.FlgEst = 'T' THEN VtaCDocu.FlgEst = 'P'.    /* Fuera de Trámite */
        IF VtaCDocu.FlgEst <> 'P' THEN DO:
            DELETE B-CPEDI.          /* Por si acaso */
            RELEASE VtaCDocu.
            NEXT LIMPIAMOS.
        END.
        RELEASE VtaCDocu.
    END.
END.
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    /* acumulamos por producto */
    FOR EACH B-CPEDI, EACH T-DDOCU WHERE T-DDOCU.codcia = B-CPEDI.codcia
            AND T-DDOCU.codped = B-CPEDI.codped
            AND T-DDOCU.nroped = B-CPEDI.nroped:
        FIND Resumen WHERE Resumen.codcia = T-DDOCU.codcia
            AND Resumen.codmat = T-DDOCU.codmat 
            AND Resumen.codalm = T-DDOCU.almdes 
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Resumen THEN DO:
            CREATE Resumen.
            ASSIGN
                Resumen.codcia = T-DDOCU.codcia
                Resumen.codmat = T-DDOCU.codmat
                Resumen.codalm = T-DDOCU.almdes.
        END.
    END.
    /* cargamos el stock disponible */
    FOR EACH Resumen,
        FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = Resumen.codcia
        AND Almmmate.codalm = Resumen.codalm
        AND Almmmate.codmat = Resumen.codmat:
        x-StkAct = Almmmate.stkact.
        RUN vtagn/p-stock-comprometido (Resumen.codmat, Resumen.codalm, OUTPUT x-StkComprometido).
        IF x-StkComprometido > x-StkAct THEN NEXT.
        ASSIGN
            Resumen.stkact = x-StkAct - x-StkComprometido.
    END.
    /* cargamos ventas de acuerdo al saldo del resumen */
    FOR EACH B-CPEDI:
        FOR EACH T-DDOCU WHERE T-DDOCU.codcia = B-CPEDI.codcia
                AND T-DDOCU.codped = B-CPEDI.codped
                AND T-DDOCU.nroped = B-CPEDI.nroped:
            f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CARGANDO SALDOS: ' + B-CPEDI.nroped + ' ' + T-DDOCU.codmat.
            FIND Resumen WHERE Resumen.codcia = T-DDOCU.codcia
                AND Resumen.codalm = T-DDOCU.almdes
                AND Resumen.codmat = T-DDOCU.codmat
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Resumen OR Resumen.stkact <= 0 THEN NEXT.
            ASSIGN
                T-DDOCU.CanPed = MINIMUM( Resumen.stkact, T-DDOCU.Libre_d01 ).
            ASSIGN
                Resumen.stkact = Resumen.stkact - T-DDOCU.CanPed.
        END.
        /* Totales */
        B-CPEDI.ImpTot = 0.
        FOR EACH T-DDOCU NO-LOCK WHERE T-DDOCU.codcia = B-CPEDI.codcia
                AND T-DDOCU.codped = B-CPEDI.codped
                AND T-DDOCU.nroped = B-CPEDI.nroped:
            {vtagn/i-vtaddocu-01.i}
            B-CPEDI.ImpTot = B-CPEDI.ImpTot + T-DDOCU.ImpLin.
        END.
        /* eliminamos los que no cumplen el monto mínimo */
        IF B-CPEDI.ImpTot >= x-ImpTot THEN DO:
            FIND VtaCDocu OF B-CPEDI EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE VtaCDocu THEN UNDO, RETURN 'ADM-ERROR'.
            IF VtaCDocu.FlgEst = 'P' THEN VtaCDocu.FlgEst = 'T'.  /* En Trámite */
            RELEASE VtaCDocu.
        END.
        ELSE DO:
            DELETE B-CPEDI.
        END.
    END.
    /* RENUMERAMOS */
    xOrden = 1.
    FOR EACH B-CPEDI:
        B-CPEDI.Libre_d01 = xOrden.
        xOrden = xOrden + 1.
    END.
END.
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Proyeccion_Old B-table-Win 
PROCEDURE Proyeccion_Old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR x-StkComprometido AS DEC NO-UNDO.
DEF VAR x-ImpLin AS DEC NO-UNDO.
DEF VAR x-ImpDto AS DEC NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    /* limpiamos la informacion */
    FOR EACH B-CPEDI, EACH T-DDOCU WHERE T-DDOCU.codcia = B-CPEDI.codcia
            AND T-DDOCU.codped = B-CPEDI.codped
            AND T-DDOCU.nroped = B-CPEDI.nroped:
        ASSIGN
            T-DDOCU.canate = 0     
            B-CPEDI.Libre_d02 = 0  /* Proyectado Cabecera */
            T-DDOCU.Libre_d02 = 0. /* Proyectado Detalle */
    END.
    /* cargamos ventas de acuerdo al saldo del almacén */
    FOR EACH B-CPEDI:
        FOR EACH T-DDOCU WHERE T-DDOCU.codcia = B-CPEDI.codcia
                AND T-DDOCU.codped = B-CPEDI.codped
                AND T-DDOCU.nroped = B-CPEDI.nroped, 
                FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = T-DDOCU.codcia
                AND Almmmate.codalm = T-DDOCU.almdes
                AND Almmmate.codmat = T-DDOCU.codmat:
            f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'PROCESANDO: ' + B-CPEDI.nroped + ' ' + T-DDOCU.codmat.
            x-StkAct = Almmmate.stkact.
            RUN gn/stock-comprometido (T-DDOCU.codmat, T-DDOCU.almdes, OUTPUT x-StkComprometido).
            FOR EACH BB-CPEDI NO-LOCK WHERE ROWID(BB-CPEDI) <> ROWID(B-CPEDI),
                EACH BT-DDOCU NO-LOCK WHERE BT-DDOCU.codcia = BB-CPEDI.codcia
                    AND BT-DDOCU.codped = BB-CPEDI.codped
                    AND BT-DDOCU.nroped = BB-CPEDI.nroped
                    AND BT-DDOCU.codmat = T-DDOCU.codmat:
                x-StkComprometido = x-StkComprometido + BT-DDOCU.Libre_d02.
            END.
            IF x-StkComprometido > x-StkAct THEN NEXT.
            ASSIGN
                T-DDOCU.Libre_d02 = MINIMUM( (x-StkAct - x-StkComprometido), T-DDOCU.Libre_d01 ).
        END.
        /* Totales */
        FOR EACH T-DDOCU NO-LOCK WHERE T-DDOCU.codcia = B-CPEDI.codcia
                AND T-DDOCU.codped = B-CPEDI.codped
                AND T-DDOCU.nroped = B-CPEDI.nroped:
            ASSIGN 
              /*x-ImpDto = ROUND( T-DDOCU.PreUni * T-DDOCU.Libre_d02 * (T-DDOCU.Por_Dsctos[1] / 100),4 )*/
              x-ImpLin = ROUND( T-DDOCU.PreUni * T-DDOCU.Libre_d02 , 2 ) - x-ImpDto.
            B-CPEDI.Libre_d02 = B-CPEDI.Libre_d02 + x-ImpLin.
        END.
        IF B-CPEDI.PorDto > 0 THEN DO:
          ASSIGN
              B-CPEDI.Libre_d02 = ROUND(B-CPEDI.Libre_d02 * (1 - B-CPEDI.PorDto / 100),2).
        END.
    END.
END.
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
/* RUN dispatch IN THIS-PROCEDURE ('open-query'). */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reordena B-table-Win 
PROCEDURE Reordena :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pOrden AS INT.

DEF VAR iOrden AS INT INIT 1 NO-UNDO.

CASE pOrden:
    WHEN 1 THEN DO:
        FOR EACH B-CPEDI BY B-CPEDI.FchEnt BY B-CPEDI.ImpTot DESC:
            ASSIGN
                B-CPEDI.Libre_d01 = iOrden
                iOrden = iOrden + 1.
        END.
    END.
    WHEN 2 THEN DO:
        FOR EACH B-CPEDI BY B-CPEDI.Importe[2] DESC:
            ASSIGN
                B-CPEDI.Libre_d01 = iOrden
                iOrden = iOrden + 1.
        END.
    END.
    WHEN 3 THEN DO:
        FOR EACH B-CPEDI BY B-CPEDI.Nomcli:
            ASSIGN
                B-CPEDI.Libre_d01 = iOrden
                iOrden = iOrden + 1.
        END.
    END.
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
  {src/adm/template/snd-list.i "B-CPEDI"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Subir B-table-Win 
PROCEDURE Subir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR iOrden AS INT NO-UNDO.
DEF VAR xOrden AS INT NO-UNDO.
DEF VAR rRecord AS RAW NO-UNDO.

IF NOT AVAILABLE B-CPEDI THEN RETURN.

iOrden = B-CPEDI.Libre_d01.
IF iOrden = 1 THEN RETURN.
RAW-TRANSFER B-CPEDI TO rRecord.
DELETE B-CPEDI.

FOR EACH T-CPEDI:
    DELETE T-CPEDI.
END.

xOrden = 1.
FOR EACH B-CPEDI BY B-CPEDI.Libre_d01:
    IF B-CPEDI.Libre_d01 = iOrden - 1 THEN DO:
        CREATE T-CPEDI.
        RAW-TRANSFER rRecord TO T-CPEDI.
        T-CPEDI.Libre_d01 = iOrden - 1.
        xOrden = xOrden + 1.
    END.
    CREATE T-CPEDI.
    BUFFER-COPY B-CPEDI TO T-CPEDI
        ASSIGN T-CPEDI.Libre_d01 = xOrden.
    xOrden = xOrden + 1.
    DELETE B-CPEDI.
END.

FOR EACH T-CPEDI:
    CREATE B-CPEDI.
    BUFFER-COPY T-CPEDI TO B-CPEDI.
END.

RUN dispatch IN THIS-PROCEDURE ('open-query').
FIND B-CPEDI WHERE B-CPEDI.Libre_d01 = iOrden - 1.
REPOSITION {&BROWSE-NAME} TO ROWID ROWID(B-CPEDI).
RUN dispatch IN THIS-PROCEDURE ('row-changed').


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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _ImpBD B-table-Win 
FUNCTION _ImpBD RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pSdoMn1 AS DEC NO-UNDO.     /* Saldo de los docs en S/. */
DEF VAR pSdoMn2 AS DEC NO-UNDO.     /* Saldo de los docs en US$ */
DEF VAR pSdoAct AS DEC NO-UNDO.

  RUN gn/saldo-por-doc-cli (VtaCDocu.codcli,
                            'BD',
                            s-coddiv,
                            OUTPUT pSdoMn1,
                            OUTPUT pSdoMn2).

  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK.
  IF VtaCDocu.codmon = 1
  THEN pSdoAct = pSdoMn1 + pSdoMn2 * gn-tcmb.Venta.
  ELSE pSdoAct = pSdoMn2 + pSdoMn1 / gn-tcmb.Compra.

  /* RHC 14.12.09 incrementamos los saldos por antipos */
  RUN gn/saldo-por-doc-cli (VtaCDocu.codcli,
                            'A/R',
                            s-coddiv,
                            OUTPUT pSdoMn1,
                            OUTPUT pSdoMn2).
  IF VtaCDocu.codmon = 1
  THEN pSdoAct = pSdoAct + ( pSdoMn1 + pSdoMn2 * gn-tcmb.Venta ).
  ELSE pSdoAct = pSdoAct + ( pSdoMn2 + pSdoMn1 / gn-tcmb.Compra ).

   RUN gn/saldo-por-doc-cli (VtaCDocu.codcli,
                             'N/C',
                             s-coddiv,
                             OUTPUT pSdoMn1,
                             OUTPUT pSdoMn2).
   IF VtaCDocu.codmon = 1
   THEN pSdoAct = pSdoAct + ( pSdoMn1 + pSdoMn2 * gn-tcmb.Venta ).
   ELSE pSdoAct = pSdoAct + ( pSdoMn2 + pSdoMn1 / gn-tcmb.Compra ).

  RETURN pSdoAct.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _ImpCcb B-table-Win 
FUNCTION _ImpCcb RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pSdoMn1 AS DEC NO-UNDO.     /* Saldo de los docs en S/. */
DEF VAR pSdoMn2 AS DEC NO-UNDO.     /* Saldo de los docs en US$ */
DEF VAR pSdoAct AS DEC NO-UNDO.

  RUN gn/saldo-por-doc-cli (VtaCDocu.codcli,
                            'FAC',
                            s-coddiv,
                            OUTPUT pSdoMn1,
                            OUTPUT pSdoMn2).

  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK.
  IF VtaCDocu.codmon = 1
  THEN pSdoAct = pSdoMn1 + pSdoMn2 * gn-tcmb.Venta.
  ELSE pSdoAct = pSdoMn2 + pSdoMn1 / gn-tcmb.Compra.

  RUN gn/saldo-por-doc-cli (VtaCDocu.codcli,
                            'BOL',
                            s-coddiv,
                            OUTPUT pSdoMn1,
                            OUTPUT pSdoMn2).
  IF VtaCDocu.codmon = 1
  THEN pSdoAct = pSdoAct + ( pSdoMn1 + pSdoMn2 * gn-tcmb.Venta ).
  ELSE pSdoAct = pSdoAct + ( pSdoMn2 + pSdoMn1 / gn-tcmb.Compra ).

   RUN gn/saldo-por-doc-cli (VtaCDocu.codcli,
                             'LET',
                             s-coddiv,
                             OUTPUT pSdoMn1,
                             OUTPUT pSdoMn2).
   IF VtaCDocu.codmon = 1
   THEN pSdoAct = pSdoAct + ( pSdoMn1 + pSdoMn2 * gn-tcmb.Venta ).
   ELSE pSdoAct = pSdoAct + ( pSdoMn2 + pSdoMn1 / gn-tcmb.Compra ).

   /* PEDIDOS PENDIENTES */
   ASSIGN
       pSdoMn1 = 0
       pSdoMN2 = 0.
   FOR EACH BCPEDI NO-LOCK WHERE BCPEDI.codcia = s-codcia
       AND BCPEDI.coddiv = s-coddiv
       AND BCPEDI.codped = 'PED'
       AND BCPEDI.codcli = VtaCDocu.codcli
       AND BCPEDI.flgest = 'P':
       IF BCPEDI.codmon = 1 
           THEN pSdoMn1 = pSdoMn1 + BCPEDI.ImpTot.
       ELSE pSdoMn2 = pSdoMn2 + BCPEDI.ImpTot.
   END.
   IF VtaCDocu.codmon = 1
   THEN pSdoAct = pSdoAct + ( pSdoMn1 + pSdoMn2 * gn-tcmb.Venta ).
   ELSE pSdoAct = pSdoAct + ( pSdoMn2 + pSdoMn1 / gn-tcmb.Compra ).

    /* PRE-PEDIDOS PENDIENTES */
    ASSIGN
        pSdoMn1 = 0
        pSdoMN2 = 0.
    FOR EACH BCPEDI NO-LOCK WHERE BCPEDI.codcia = s-codcia
        AND BCPEDI.coddiv = s-coddiv
        AND BCPEDI.codped = 'PPD'
        AND BCPEDI.codcli = VtaCDocu.codcli
        AND BCPEDI.flgest = 'P':
        IF BCPEDI.codmon = 1 
            THEN pSdoMn1 = pSdoMn1 + BCPEDI.ImpTot.
        ELSE pSdoMn2 = pSdoMn2 + BCPEDI.ImpTot.
    END.
    IF VtaCDocu.codmon = 1
    THEN pSdoAct = pSdoAct + ( pSdoMn1 + pSdoMn2 * gn-tcmb.Venta ).
    ELSE pSdoAct = pSdoAct + ( pSdoMn2 + pSdoMn1 / gn-tcmb.Compra ).

  RETURN pSdoAct.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

