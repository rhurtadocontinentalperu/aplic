&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-DMOV NO-UNDO LIKE cb-dmov.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR cb-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE P-LIST AS CHAR NO-UNDO.
DEFINE VARIABLE P-LIBROS AS CHAR NO-UNDO.
DEFINE VARIABLE s-TpoCmb AS DEC DECIMALS 6 NO-UNDO.
DEFINE VARIABLE s-CodMon AS INT INIT 1 NO-UNDO.

RUN cbd/cb-m000.r(OUTPUT P-LIST).
IF P-LIST = "" THEN DO:
   MESSAGE "No existen periodos asignados para " skip
            "la empresa" s-codcia VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
P-LIST = SUBSTRING ( P-LIST , 1, LENGTH(P-LIST) - 1 ).

FOR EACH cb-oper NO-LOCK WHERE cb-oper.CodCia = cb-codcia:
    P-LIBROS = P-LIBROS + (IF P-LIBROS = '' THEN '' ELSE ',') + cb-oper.Codope + ' ' + cb-oper.Nomope + ',' + cb-oper.Codope.
END.

DEFINE VARIABLE chExcelApplication  AS COM-HANDLE.
DEFINE VARIABLE chWorkbook          AS COM-HANDLE.
DEFINE VARIABLE chWorksheet         AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-DMOV

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 T-DMOV.CodCta T-DMOV.CodAux ~
T-DMOV.Chr_01 T-DMOV.FchDoc T-DMOV.CCo T-DMOV.CodDiv T-DMOV.CodDoc ~
T-DMOV.NroDoc T-DMOV.FchVto T-DMOV.GloDoc T-DMOV.Dec_01 T-DMOV.Dec_02 ~
T-DMOV.TpoCmb 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH T-DMOV NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH T-DMOV NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 T-DMOV
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 T-DMOV


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Periodo BUTTON-Import-Excel ~
BtnDone COMBO-BOX-NroMes COMBO-BOX-CodOpe COMBO-BOX-CodMon BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo COMBO-BOX-NroMes ~
COMBO-BOX-CodOpe COMBO-BOX-CodMon 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     LABEL "SALIR" 
     SIZE 15 BY 1.12
     BGCOLOR 8 FONT 6.

DEFINE BUTTON BUTTON-Asiento 
     LABEL "GENERAR ASIENTO CONTABLE" 
     SIZE 30 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON-Import-Excel 
     LABEL "IMPORTAR EXCEL" 
     SIZE 19 BY 1.12
     FONT 6.

DEFINE VARIABLE COMBO-BOX-CodMon AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     LABEL "Moneda" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Soles",1,
                     "Dólares",2
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-CodOpe AS CHARACTER FORMAT "X(256)":U 
     LABEL "Libro" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 64 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NroMes AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEM-PAIRS "Enero",1,
                     "Febrero",2,
                     "Marzo",3,
                     "Abril",4,
                     "Mayo",5,
                     "Junio",6,
                     "Julio",7,
                     "Agosto",8,
                     "Setiembre",9,
                     "Octubre",10,
                     "Noviembre",11,
                     "Diciembre",12
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      T-DMOV SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      T-DMOV.CodCta COLUMN-LABEL "A!CUENTA" FORMAT "X(10)":U WIDTH 8.43
      T-DMOV.CodAux COLUMN-LABEL "B!AUXILIAR" FORMAT "X(15)":U
            WIDTH 11.43
      T-DMOV.Chr_01 COLUMN-LABEL "C!NOM. AUXILIAR" FORMAT "x(60)":U
            WIDTH 38.43
      T-DMOV.FchDoc COLUMN-LABEL "D!FECHA" FORMAT "99/99/9999":U
            WIDTH 8.43
      T-DMOV.CCo COLUMN-LABEL "E!CCO" FORMAT "X(8)":U WIDTH 6.72
      T-DMOV.CodDiv COLUMN-LABEL "F!DIVISION" FORMAT "X(5)":U
      T-DMOV.CodDoc COLUMN-LABEL "G!DOC." FORMAT "X(4)":U WIDTH 4.43
      T-DMOV.NroDoc COLUMN-LABEL "H!DOCUMENTO" FORMAT "X(10)":U
      T-DMOV.FchVto COLUMN-LABEL "I!VENCIMIENTO" FORMAT "99/99/9999":U
            WIDTH 11.29
      T-DMOV.GloDoc COLUMN-LABEL "J!GLOSA" FORMAT "X(60)":U WIDTH 34.43
      T-DMOV.Dec_01 COLUMN-LABEL "K!CARGO" FORMAT ">>>>,>>9.99":U
            WIDTH 11.57
      T-DMOV.Dec_02 COLUMN-LABEL "L!ABONO" FORMAT ">>>>,>>9.99":U
            WIDTH 11.72
      T-DMOV.TpoCmb COLUMN-LABEL "M!T.C." FORMAT "Z9.9999":U WIDTH 1.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 179 BY 20
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Periodo AT ROW 1.19 COL 19 COLON-ALIGNED WIDGET-ID 2
     BUTTON-Import-Excel AT ROW 1.19 COL 87 WIDGET-ID 12
     BUTTON-Asiento AT ROW 1.19 COL 107 WIDGET-ID 16
     BtnDone AT ROW 1.19 COL 137 WIDGET-ID 18
     COMBO-BOX-NroMes AT ROW 2.15 COL 19 COLON-ALIGNED WIDGET-ID 4
     COMBO-BOX-CodOpe AT ROW 3.12 COL 19 COLON-ALIGNED WIDGET-ID 6
     COMBO-BOX-CodMon AT ROW 4.08 COL 19 COLON-ALIGNED WIDGET-ID 10
     BROWSE-3 AT ROW 5.23 COL 1 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 180.14 BY 25.5
         DEFAULT-BUTTON BtnDone WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-DMOV T "?" NO-UNDO INTEGRAL cb-dmov
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION DE ASIENTOS CONTABLES"
         HEIGHT             = 25.5
         WIDTH              = 180.14
         MAX-HEIGHT         = 26.31
         MAX-WIDTH          = 180.14
         VIRTUAL-HEIGHT     = 26.31
         VIRTUAL-WIDTH      = 180.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-3 COMBO-BOX-CodMon F-Main */
/* SETTINGS FOR BUTTON BUTTON-Asiento IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.T-DMOV"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-DMOV.CodCta
"T-DMOV.CodCta" "A!CUENTA" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-DMOV.CodAux
"T-DMOV.CodAux" "B!AUXILIAR" "X(15)" "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-DMOV.Chr_01
"T-DMOV.Chr_01" "C!NOM. AUXILIAR" "x(60)" "character" ? ? ? ? ? ? no ? no no "38.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-DMOV.FchDoc
"T-DMOV.FchDoc" "D!FECHA" ? "date" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-DMOV.CCo
"T-DMOV.CCo" "E!CCO" "X(8)" "character" ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-DMOV.CodDiv
"T-DMOV.CodDiv" "F!DIVISION" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-DMOV.CodDoc
"T-DMOV.CodDoc" "G!DOC." ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-DMOV.NroDoc
"T-DMOV.NroDoc" "H!DOCUMENTO" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-DMOV.FchVto
"T-DMOV.FchVto" "I!VENCIMIENTO" ? "date" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-DMOV.GloDoc
"T-DMOV.GloDoc" "J!GLOSA" "X(60)" "character" ? ? ? ? ? ? no ? no no "34.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-DMOV.Dec_01
"T-DMOV.Dec_01" "K!CARGO" ">>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "11.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-DMOV.Dec_02
"T-DMOV.Dec_02" "L!ABONO" ">>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.T-DMOV.TpoCmb
"T-DMOV.TpoCmb" "M!T.C." ? "decimal" ? ? ? ? ? ? no ? no no "1.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION DE ASIENTOS CONTABLES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION DE ASIENTOS CONTABLES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* SALIR */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Asiento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Asiento W-Win
ON CHOOSE OF BUTTON-Asiento IN FRAME F-Main /* GENERAR ASIENTO CONTABLE */
DO:
  DEF VAR s-Periodo LIKE COMBO-BOX-Periodo NO-UNDO.
  DEF VAR s-NroMes  LIKE  COMBO-BOX-NroMes NO-UNDO.
  DEF VAR s-CodOpe  LIKE  COMBO-BOX-CodOpe NO-UNDO.
  DEF VAR s-NroAst  LIKE cb-cmov.nroast NO-UNDO.
  DEF VAR s-Codmon  LIKE cb-cmov.codmon NO-UNDO.

  ASSIGN
      s-Periodo = COMBO-BOX-Periodo 
      s-NroMes  = COMBO-BOX-NroMes
      s-CodOpe  = COMBO-BOX-CodOpe
      s-CodMon  = COMBO-BOX-CodMon.
  
  DEFINE VARIABLE s-NroMesCie AS LOGICAL INITIAL YES NO-UNDO.
  FIND cb-peri WHERE  cb-peri.CodCia     = s-codcia  AND
      cb-peri.Periodo    = s-periodo NO-LOCK.
  IF AVAILABLE cb-peri
  THEN s-NroMesCie = cb-peri.MesCie[s-NroMes + 1].

  IF s-NroMesCie THEN DO:
      MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.

  MESSAGE 'Procedemos a generar el asiento contable?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN.
  IF NOT CAN-FIND(FIRST T-DMOV NO-LOCK) THEN RETURN.

  RUN cbd/cbdnast (
    cb-codcia, 
    s-codcia, 
    s-periodo, 
    s-NroMes, 
    s-codope, 
    OUTPUT s-nroast). 
  CREATE cb-cmov.
  ASSIGN 
      cb-cmov.CodCia  = s-codcia
      cb-cmov.Periodo = s-periodo
      cb-cmov.NroMes  = s-NroMes
      cb-cmov.CodOpe  = s-CodOpe
      cb-cmov.NroAst  = STRING(s-NroAst,"999999")
      cb-cmov.FchAst  = TODAY
      cb-cmov.Usuario = s-user-id
      cb-cmov.CodMon  = s-codmon.
  /* Voucher atrazados colocamos el ultimo dia del mes como fecha de registro */
  IF s-NroMes = 12 THEN cb-cmov.FchAst  = DATE( 1, 1, s-periodo + 1) - 1.
  ELSE cb-cmov.FchAst  = DATE( s-NroMes + 1, 1, s-periodo) - 1.
  /* Buscando el Tipo de Cambio que le corresponde */
  FIND LAST gn-tcmb WHERE gn-tcmb.Fecha <= cb-cmov.FchAst NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN
      IF cb-cmov.CodMon = 1 THEN cb-cmov.TpoCmb = gn-tcmb.Compra.
      ELSE cb-cmov.TpoCmb = gn-tcmb.Venta.
  FOR EACH T-DMOV:
      CREATE cb-dmov.
      BUFFER-COPY cb-cmov
          TO cb-dmov
          ASSIGN 
          cb-dmov.nroitm = T-DMOV.nroitm
          cb-dmov.codcta = T-DMOV.codcta
          cb-dmov.codaux = T-DMOV.codaux
          cb-dmov.clfaux = T-DMOV.clfaux
          cb-dmov.fchdoc = T-DMOV.fchdoc
          cb-dmov.coddiv = T-DMOV.coddiv
          cb-dmov.cco    = T-DMOV.cco
          cb-dmov.coddoc = T-DMOV.coddoc
          cb-dmov.nrodoc = T-DMOV.nrodoc
          cb-dmov.fchvto = T-DMOV.fchvto
          cb-dmov.nroref = T-DMOV.nroref
          cb-dmov.glodoc = T-DMOV.glodoc
          cb-dmov.tpomov = T-DMOV.tpomov
          cb-dmov.impmn1 = T-DMOV.impmn1
          cb-dmov.impmn2 = T-DMOV.impmn2
          cb-dmov.codmon = T-DMOV.codmon.
      IF T-DMOV.tpocmb > 0 THEN cb-dmov.tpocmb = T-DMOV.tpocmb.
      IF cb-dmov.codmon = 2 THEN 
          IF T-DMOV.tpocmb > 0 THEN cb-dmov.impmn1 = cb-dmov.impmn2 * T-DMOV.tpocmb.
          ELSE cb-dmov.impmn1 = cb-dmov.impmn2 * cb-cmov.tpocmb.
  END.
  ASSIGN  
      cb-cmov.HbeMn1 = 0
      cb-cmov.HbeMn2 = 0
      cb-cmov.HbeMn3 = 0
      cb-cmov.DbeMn1 = 0
      cb-cmov.DbeMn2 = 0
      cb-cmov.DbeMn3 = 0.
  FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.CodCia  = cb-cmov.codcia  
      AND cb-dmov.Periodo = cb-cmov.periodo 
      AND cb-dmov.NroMes  = cb-cmov.NroMes  
      AND cb-dmov.CodOpe  = cb-cmov.CodOpe  
      AND cb-dmov.NroAst  = cb-cmov.NroAst:
      IF cb-dmov.TpoMov THEN     /* Tipo H */
          ASSIGN  cb-cmov.HbeMn1 = cb-cmov.HbeMn1 + cb-dmov.ImpMn1
                  cb-cmov.HbeMn2 = cb-cmov.HbeMn2 + cb-dmov.ImpMn2
                  cb-cmov.HbeMn3 = cb-cmov.HbeMn3 + cb-dmov.ImpMn3.
      ELSE 
          ASSIGN cb-cmov.DbeMn1 = cb-cmov.DbeMn1 + cb-dmov.ImpMn1
                 cb-cmov.DbeMn2 = cb-cmov.DbeMn2 + cb-dmov.ImpMn2
                 cb-cmov.DbeMn3 = cb-cmov.DbeMn3 + cb-dmov.ImpMn3.
  END.         

  RELEASE cb-cmov.
  RELEASE cb-dmov.
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
  EMPTY TEMP-TABLE T-DMOV.
  DO WITH FRAME {&FRAME-NAME}:
      ENABLE COMBO-BOX-CodMon COMBO-BOX-CodOpe COMBO-BOX-NroMes COMBO-BOX-Periodo 
          WITH FRAME {&FRAME-NAME}.
      BUTTON-Asiento:SENSITIVE = NO.
      BUTTON-Import-Excel:SENSITIVE = YES.
  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Import-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Import-Excel W-Win
ON CHOOSE OF BUTTON-Import-Excel IN FRAME F-Main /* IMPORTAR EXCEL */
DO:
  ASSIGN COMBO-BOX-CodMon COMBO-BOX-CodOpe COMBO-BOX-NroMes 
      COMBO-BOX-Periodo.
  RUN Importar-Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY COMBO-BOX-Periodo COMBO-BOX-NroMes COMBO-BOX-CodOpe COMBO-BOX-CodMon 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Periodo BUTTON-Import-Excel BtnDone COMBO-BOX-NroMes 
         COMBO-BOX-CodOpe COMBO-BOX-CodMon BROWSE-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel W-Win 
PROCEDURE Importar-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed AS LOG NO-UNDO.

SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
    FILTERS "Archivos Excel (*.xls)" "*.xls,*.xlsx", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).
SESSION:SET-WAIT-STATE('GENERAL').
RUN Proceso-Carga.
SESSION:SET-WAIT-STATE('').
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

{&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

PROCEDURE Proceso-Carga:
/* ******************* */

DEF VAR s-nroitm AS INT NO-UNDO.

/* CARGAMOS EL TEMPORAL */
ASSIGN
    s-TpoCmb = 1
    s-CodMon = COMBO-BOX-CodMon
    s-nroitm = 0
    t-Column = 0
    t-Row = 1.     /* Saltamos el encabezado de los campos */
REPEAT:
    ASSIGN
        s-nroitm = s-nroitm + 1
        t-column = 0
        t-Row    = t-Row + 1.
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    /* CUENTA */
    CREATE T-DMOV.
    ASSIGN
        T-DMOV.NroItm = s-nroitm
        T-DMOV.tpocmb = s-tpocmb
        T-DMOV.codcta = STRING(DECIMAL(cValue), '99999999')
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Error en el registro' t-Row SKIP
            'CUENTA errada:' cValue.
        RETURN.
    END.
    /* AUXILIAR */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-DMOV.codaux = cValue.
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-DMOV.Chr_01 = cValue.
    /* FECHA */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-DMOV.FchDoc = DATE(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Error en el registro' t-Row SKIP
            'FECHA errada:' cValue.
        RETURN.
    END.
    /* CCO */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-DMOV.cco = (IF cValue <> ? THEN cValue ELSE "").
    /* DIVISION */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-DMOV.coddiv = (IF cValue <> ? THEN cValue ELSE "").
    /* COD DOC */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = ? THEN cValue = "".
    ASSIGN
        T-DMOV.coddoc = cValue.
    /* NRO DOCU */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = ? THEN cValue = "".
    ASSIGN
        T-DMOV.nrodoc = cValue.
    /* VENCIMIENTO */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-DMOV.FchVto = DATE(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Error en el registro' t-Row SKIP
            'VENCIMIENTO errado:' cValue.
        RETURN.
    END.
    /* GLOSA */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-DMOV.GloDoc = cValue.
    /* MONEDA */
    ASSIGN
        T-DMOV.CodMon = s-codmon.
    /* CLASIFICACION AUXILIAR */
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.codcta = T-DMOV.codcta
        NO-LOCK NO-ERROR.
    IF AVAILABLE cb-ctas THEN T-DMOV.clfaux = cb-ctas.ClfAux.
    /* IMPORTES */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        dValue = DECIMAL(cValue)
        NO-ERROR.
    IF dValue > 0 THEN DO:
        T-DMOV.Dec_01 = dValue.
        IF s-codmon = 1 THEN
            ASSIGN
            T-DMOV.ImpMn1 = dValue
            T-DMOV.TpoMov = NO.
        ELSE ASSIGN
            T-DMOV.ImpMn2 = dValue
            T-DMOV.TpoMov = NO.
    END.
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        dValue = DECIMAL(cValue)
        NO-ERROR.
    IF dValue > 0 THEN DO:
        T-DMOV.Dec_02 = dValue.
        IF s-codmon = 1 THEN
            ASSIGN
            T-DMOV.ImpMn1 = dValue
            T-DMOV.TpoMov = YES.
        ELSE ASSIGN
            T-DMOV.ImpMn2 = dValue
            T-DMOV.TpoMov = YES.
    END.
    /* T.C. */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        dValue = DECIMAL(cValue)
        NO-ERROR.
    IF dValue > 0 THEN ASSIGN T-DMOV.TpoCmb = dValue.
END.

DO WITH FRAME {&FRAME-NAME}:
    DISABLE  COMBO-BOX-CodMon COMBO-BOX-CodOpe COMBO-BOX-NroMes COMBO-BOX-Periodo 
        WITH FRAME {&FRAME-NAME}.
    BUTTON-Asiento:SENSITIVE = YES.
    BUTTON-Import-Excel:SENSITIVE = NO.
END.
    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  COMBO-BOX-NroMes = MONTH(TODAY).
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Periodo:LIST-ITEMS = P-LIST.
      COMBO-BOX-Periodo:SCREEN-VALUE = ENTRY(LOOKUP(STRING(YEAR(TODAY)),P-LIST) , P-LIST).
      COMBO-BOX-Periodo = INTEGER(ENTRY(LOOKUP(STRING(YEAR(TODAY)),P-LIST) , P-LIST)).
      COMBO-BOX-CodOpe:LIST-ITEM-PAIRS = P-LIBROS.
      /*COMBO-BOX-CodOpe:SCREEN-VALUE = ENTRY(1, ENTRY(1, P-LIBROS), ' ').*/
      /*COMBO-BOX-CodOpe = ENTRY(1, P-LIBROS).*/
      COMBO-BOX-CodOpe:SCREEN-VALUE = "076".
      COMBO-BOX-CodOpe = "076".
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "T-DMOV"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

