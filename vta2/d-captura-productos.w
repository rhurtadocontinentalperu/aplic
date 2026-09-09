&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE SHARED TEMP-TABLE ITEM-2 LIKE FacDPedi.
DEFINE TEMP-TABLE T-MATG NO-UNDO LIKE Almmmatg.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEF INPUT PARAMETER s-TpoPed AS CHAR.

DEF VAR pNroItem AS INT INIT 0 NO-UNDO.
DEF VAR i AS INT INIT 0 NO-UNDO.
FOR EACH ITEM NO-LOCK BY ITEM.NroItm:
    i = i + 1.
    pNroItem = ITEM.NroItm.
END.
pNroItem = MAXIMUM(i,pNroItem) + 1.

/* Local Variable Definitions ---                                       */

DEF VAR x-codalm AS CHAR NO-UNDO.
DEF VAR x-desmat AS CHAR NO-UNDO.
DEF VAR x-desmar AS CHAR NO-UNDO.
DEF VAR x-codfam AS CHAR INIT 'Todos' NO-UNDO.
DEF VAR x-subfam AS CHAR INIT 'Todos' NO-UNDO.

DEFINE SHARED VARIABLE S-CODCIA     AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM     AS CHAR.

DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.       /* División de Ventas */
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE s-FlgTipoVenta AS LOG.

DEFINE NEW SHARED VARIABLE S-CODMAT   AS CHAR.

&SCOPED-DEFINE Condicion Almmmatg.CodCia = s-codcia ~
 AND (x-desmat = '' OR INDEX(Almmmatg.DesMat, x-desmat) > 0) ~
 AND (x-desmar = '' OR INDEX(Almmmatg.DesMar, x-desmar) > 0) ~
 AND Almmmatg.TpoArt <> "D" ~
 AND Almmmatg.PreOfi > 0 ~
 AND Almmmatg.TpoMrg <> "2" ~
 AND (x-CodFam = 'Todos' OR Almmmatg.CodFam = x-CodFam) ~
 AND (x-SubFam = 'Todos' OR Almmmatg.SubFam = x-SubFam) ~
 AND (s-TpoPed <> "LU" OR Almmmatg.Sw-Web = "S") ~
 AND (TOGGLE-FlgPre = no or INTEGRAL.Almmmatg.FlgPre = TOGGLE-FlgPre) ~
 AND NOT (s-FlgTipoVenta = YES AND Almmmatg.TpoMrg = '2')

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almmmatg Almmmate Almtfami T-MATG

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 Almmmatg.DesMat Almmmatg.codmat ~
Almmmatg.DesMar Almmmate.StkAct fComprometido() @ Almmmatg.StkRep ~
Almmmatg.UndStk T-MATG.Libre_d01 ~
(IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1) * Almmmatg.PreOfi @ Almmmatg.PreOfi 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 T-MATG.Libre_d01 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-2 T-MATG
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-2 T-MATG
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH Almmmatg ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = x-codalm ~
 AND (TOGGLE-Stock = No OR Almmmate.StkAct > 0) NO-LOCK, ~
      FIRST Almtfami OF Almmmatg ~
      WHERE Almtfami.SwComercial = TRUE NO-LOCK, ~
      FIRST T-MATG OF Almmmatg OUTER-JOIN NO-LOCK ~
    BY Almmmatg.DesMat
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH Almmmatg ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = x-codalm ~
 AND (TOGGLE-Stock = No OR Almmmate.StkAct > 0) NO-LOCK, ~
      FIRST Almtfami OF Almmmatg ~
      WHERE Almtfami.SwComercial = TRUE NO-LOCK, ~
      FIRST T-MATG OF Almmmatg OUTER-JOIN NO-LOCK ~
    BY Almmmatg.DesMat.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 Almmmatg Almmmate Almtfami T-MATG
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 Almmmatg
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 Almmmate
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 Almtfami
&Scoped-define FOURTH-TABLE-IN-QUERY-BROWSE-2 T-MATG


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodAlm TOGGLE-Stock TOGGLE-FlgPre ~
FILL-IN-1 FILL-IN-Marca COMBO-BOX-Linea COMBO-BOX-SubLinea BROWSE-2 Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodAlm TOGGLE-Stock ~
TOGGLE-FlgPre FILL-IN-1 FILL-IN-Marca COMBO-BOX-Linea COMBO-BOX-SubLinea 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fComprometido D-Dialog 
FUNCTION fComprometido RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.73
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 44 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Linea AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Línea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 53 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-SubLinea AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Sublínea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 53 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripción" 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.

DEFINE VARIABLE TOGGLE-FlgPre AS LOGICAL INITIAL yes 
     LABEL "Productos VIP" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Stock AS LOGICAL INITIAL yes 
     LABEL "Solo con stock" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      Almmmatg, 
      Almmmate, 
      Almtfami, 
      T-MATG SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      Almmmatg.DesMat FORMAT "X(60)":U
      Almmmatg.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U WIDTH 8.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "x(20)":U
      Almmmate.StkAct COLUMN-LABEL "Stock" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
            WIDTH 10.86
      fComprometido() @ Almmmatg.StkRep COLUMN-LABEL "Comprometido" FORMAT "ZZZ,ZZZ,ZZ9.99":U
      Almmmatg.UndStk COLUMN-LABEL "Unidad" FORMAT "X(6)":U WIDTH 6.72
      T-MATG.Libre_d01 COLUMN-LABEL "Cantidad" FORMAT ">>>,>>9.99":U
            WIDTH 8.72
      (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1) * Almmmatg.PreOfi @ Almmmatg.PreOfi COLUMN-LABEL "Precio en S/." FORMAT ">>,>>9.9999":U
            WIDTH 12.43
  ENABLE
      T-MATG.Libre_d01
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 125 BY 14.62
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     COMBO-BOX-CodAlm AT ROW 1 COL 11 COLON-ALIGNED WIDGET-ID 8
     TOGGLE-Stock AT ROW 1 COL 60 WIDGET-ID 12
     TOGGLE-FlgPre AT ROW 1 COL 76 WIDGET-ID 22
     FILL-IN-1 AT ROW 1.96 COL 11 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-Marca AT ROW 2.92 COL 11 COLON-ALIGNED WIDGET-ID 14
     COMBO-BOX-Linea AT ROW 3.88 COL 11 COLON-ALIGNED WIDGET-ID 18
     COMBO-BOX-SubLinea AT ROW 4.85 COL 11 COLON-ALIGNED WIDGET-ID 20
     BROWSE-2 AT ROW 5.81 COL 2 WIDGET-ID 200
     Btn_OK AT ROW 20.62 COL 3
     Btn_Cancel AT ROW 20.62 COL 18
     "F8: Stocks por Almacén                          F7: Pedidos" VIEW-AS TEXT
          SIZE 37 BY .5 AT ROW 20.81 COL 35 WIDGET-ID 16
          BGCOLOR 9 FGCOLOR 15 
     SPACE(57.42) SKIP(1.22)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "SELECCIONE LOS CODIGOS"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "SHARED" ? INTEGRAL FacDPedi
      TABLE: ITEM-2 T "SHARED" ? INTEGRAL FacDPedi
      TABLE: T-MATG T "?" NO-UNDO INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   NOT-VISIBLE FRAME-NAME                                               */
/* BROWSE-TAB BROWSE-2 COMBO-BOX-SubLinea D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

ASSIGN 
       BROWSE-2:ALLOW-COLUMN-SEARCHING IN FRAME D-Dialog = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.Almmmatg,INTEGRAL.Almmmate OF INTEGRAL.Almmmatg,INTEGRAL.Almtfami OF INTEGRAL.Almmmatg,Temp-Tables.T-MATG OF INTEGRAL.Almmmatg"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST, FIRST, FIRST OUTER"
     _OrdList          = "INTEGRAL.Almmmatg.DesMat|yes"
     _Where[1]         = "{&Condicion}"
     _Where[2]         = "Almmmate.CodAlm = x-codalm
 AND (TOGGLE-Stock = No OR Almmmate.StkAct > 0)"
     _Where[3]         = "Almtfami.SwComercial = TRUE"
     _FldNameList[1]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.codmat
"Almmmatg.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmate.StkAct
"Almmmate.StkAct" "Stock" ? "decimal" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fComprometido() @ Almmmatg.StkRep" "Comprometido" "ZZZ,ZZZ,ZZ9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.Almmmatg.UndStk
"Almmmatg.UndStk" "Unidad" "X(6)" "character" ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-MATG.Libre_d01
"T-MATG.Libre_d01" "Cantidad" ">>>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"(IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1) * Almmmatg.PreOfi @ Almmmatg.PreOfi" "Precio en S/." ">>,>>9.9999" ? ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* SELECCIONE LOS CODIGOS */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 D-Dialog
ON F7 OF BROWSE-2 IN FRAME D-Dialog
DO:
  S-CODMAT = Almmmatg.CodMat.
  run vtamay/c-conped.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 D-Dialog
ON F8 OF BROWSE-2 IN FRAME D-Dialog
DO:
  S-CODMAT = Almmmatg.CodMat.
  run alm/d-stkalm.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.Libre_d01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.Libre_d01 BROWSE-2 _BROWSE-COLUMN D-Dialog
ON LEAVE OF T-MATG.Libre_d01 IN BROWSE BROWSE-2 /* Cantidad */
DO:
  FIND T-MATG OF Almmmatg NO-LOCK NO-ERROR.
  IF NOT AVAILABLE T-MATG THEN CREATE T-MATG.
  FIND CURRENT T-MATG EXCLUSIVE-LOCK NO-ERROR.
  ASSIGN
      T-MATG.CodCia = Almmmatg.CodCia
      T-MATG.CodMat = Almmmatg.CodMat
      T-MATG.Libre_d01 = DECIMAL(SELF:SCREEN-VALUE).
  IF T-MATG.Libre_d01 > 0 THEN
      ASSIGN
      T-MATG.Orden = pNroItem
      pNroItem = pNroItem + 1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancel */
DO:
  EMPTY TEMP-TABLE ITEM-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  DEF VAR k AS INT NO-UNDO.
  DEF VAR j AS INT NO-UNDO.

  j = 1.
  FOR EACH ITEM:
      j = j + 1.
  END.
  EMPTY TEMP-TABLE ITEM-2.
  FOR EACH T-MATG WHERE T-MATG.Libre_d01 > 0, FIRST Almmmatg OF T-MATG BY T-MATG.Orden:
      FIND ITEM WHERE ITEM.codmat = T-MATG.codmat NO-ERROR.
      IF AVAILABLE ITEM THEN DO:
          ASSIGN
              ITEM.AlmDes = x-CodAlm
              ITEM.CanPed = T-MATG.Libre_d01.
      END.
      ELSE DO:
          CREATE ITEM.
          ASSIGN
              ITEM.CodCia = s-codcia
              ITEM.CodDiv = s-coddiv
              ITEM.CodCli = s-codcli
              ITEM.AlmDes = x-CodAlm
              ITEM.codmat = Almmmatg.codmat
              ITEM.CanPed = T-MATG.Libre_d01
              ITEM.Factor = 1
              ITEM.NroItm = j.
          j = j + 1.
      END.
      CREATE ITEM-2.
      BUFFER-COPY ITEM TO ITEM-2.
/*       FIND FIRST ITEM WHERE ITEM.codmat = Almmmatg.codmat NO-LOCK NO-ERROR. */
/*       IF NOT AVAILABLE ITEM THEN DO:                                        */
/*           CREATE ITEM-2.                                                    */
/*           ASSIGN                                                            */
/*               ITEM-2.AlmDes = x-CodAlm                                      */
/*               ITEM-2.CanPed = T-MATG.Libre_d01                              */
/*               ITEM-2.CodCia = s-codcia                                      */
/*               ITEM-2.CodCli = s-codcli                                      */
/*               ITEM-2.CodDiv = s-coddiv                                      */
/*               ITEM-2.codmat = Almmmatg.codmat                               */
/*               ITEM-2.Factor = 1                                             */
/*               ITEM-2.NroItm = j.                                            */
/*           j = j + 1.                                                        */
/*       END.                                                                  */
  END.
/*   FOR EACH ITEM-2:                */
/*       CREATE ITEM.                */
/*       BUFFER-COPY ITEM-2 TO ITEM. */
/*   END.                            */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodAlm D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-CodAlm IN FRAME D-Dialog /* Almacén */
DO:
  x-CodAlm = ENTRY(1, COMBO-BOX-CodAlm:SCREEN-VALUE, ' - ').  
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Linea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Linea D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-Linea IN FRAME D-Dialog /* Línea */
DO:
  x-CodFam = INPUT {&SELF-NAME}.
  COMBO-BOX-Sublinea:DELETE(COMBO-BOX-Sublinea:LIST-ITEMS).
  COMBO-BOX-Sublinea:ADD-LAST("Todos").
  COMBO-BOX-Sublinea:SCREEN-VALUE = "Todos".
  FOR EACH Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia
      AND Almsfami.codfam = ENTRY(1, x-CodFam, ' - ') :
      COMBO-BOX-Sublinea:ADD-LAST(AlmSFami.subfam + " - " + AlmSFami.dessub).
  END.
  APPLY 'VALUE-CHANGED':U TO COMBO-BOX-SubLinea.
  /*{&OPEN-QUERY-{&BROWSE-NAME}}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-SubLinea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-SubLinea D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-SubLinea IN FRAME D-Dialog /* Sublínea */
DO:
  x-SubFam = ENTRY(1, INPUT {&SELF-NAME}, ' - ').
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-1 D-Dialog
ON ANY-PRINTABLE OF FILL-IN-1 IN FRAME D-Dialog /* Descripción */
DO:
/*   x-desmat = SELF:SCREEN-VALUE + LAST-EVENT:LABEL. */
/*   {&OPEN-QUERY-{&BROWSE-NAME}}                     */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-1 D-Dialog
ON LEAVE OF FILL-IN-1 IN FRAME D-Dialog /* Descripción */
OR RETURN OF FILL-IN-1
DO:
    IF x-desmat = SELF:SCREEN-VALUE THEN RETURN.
    x-desmat = SELF:SCREEN-VALUE.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Marca D-Dialog
ON ANY-PRINTABLE OF FILL-IN-Marca IN FRAME D-Dialog /* Marca */
DO:
/*   x-desmar = SELF:SCREEN-VALUE + LAST-EVENT:LABEL. */
/*   {&OPEN-QUERY-{&BROWSE-NAME}}                     */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Marca D-Dialog
ON LEAVE OF FILL-IN-Marca IN FRAME D-Dialog /* Marca */
OR RETURN OF FILL-IN-Marca
DO:
    IF x-desmar = SELF:SCREEN-VALUE THEN RETURN.
    x-desmar = SELF:SCREEN-VALUE.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-FlgPre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-FlgPre D-Dialog
ON VALUE-CHANGED OF TOGGLE-FlgPre IN FRAME D-Dialog /* Productos VIP */
DO:
    ASSIGN {&SELF-NAME}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-Stock
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-Stock D-Dialog
ON VALUE-CHANGED OF TOGGLE-Stock IN FRAME D-Dialog /* Solo con stock */
DO:
  ASSIGN {&SELF-NAME}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE autoComplete D-Dialog 
PROCEDURE autoComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER tableHandle AS HANDLE    NO-UNDO.
    DEFINE INPUT  PARAMETER fieldName   AS CHARACTER NO-UNDO.
 
    DEFINE VARIABLE searchQuery  AS HANDLE     NO-UNDO.
    DEFINE VARIABLE searchBuffer AS HANDLE     NO-UNDO.
    DEFINE VARIABLE searchField  AS HANDLE     NO-UNDO.
 
    DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iCount AS INTEGER    NO-UNDO.

    IF tableHandle:TYPE = "TEMP-TABLE" THEN tableHandle = tableHandle:DEFAULT-BUFFER-HANDLE.
    CREATE BUFFER searchBuffer FOR TABLE tableHandle.
 
    searchField = searchBuffer:BUFFER-FIELD(fieldName).
    CREATE QUERY searchQuery.
 
    cValue = SELF:SELECTION-TEXT + LAST-EVENT:LABEL.
 
    searchQuery:SET-BUFFERS(searchBuffer).
    searchQuery:QUERY-PREPARE("FOR EACH " + tableHandle:NAME + " WHERE " +
                               tableHandle:NAME + "." + fieldName + " BEGINS '" + cValue + "'").
    searchQuery:QUERY-OPEN.
    searchQuery:GET-FIRST(NO-LOCK).
 
    IF searchBuffer:AVAILABLE AND
         LENGTH(STRING(searchField:BUFFER-VALUE)) >= LENGTH(cValue) THEN DO:
        searchField = searchBuffer:BUFFER-FIELD(fieldName).
        SELF:SCREEN-VALUE = searchField:STRING-VALUE.
    END.
    ELSE DO:
        SELF:SCREEN-VALUE = "".
        DO iCount = 1 TO LENGTH(cValue):
            APPLY SUBSTRING(cValue,iCount,1) TO SELF.
        END.
    END.
    SELF:SET-SELECTION(1,LENGTH(cValue) + 1).
 
    searchQuery:QUERY-CLOSE.
    DELETE OBJECT searchQuery.
    DELETE OBJECT searchBuffer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-CodAlm TOGGLE-Stock TOGGLE-FlgPre FILL-IN-1 FILL-IN-Marca 
          COMBO-BOX-Linea COMBO-BOX-SubLinea 
      WITH FRAME D-Dialog.
  ENABLE COMBO-BOX-CodAlm TOGGLE-Stock TOGGLE-FlgPre FILL-IN-1 FILL-IN-Marca 
         COMBO-BOX-Linea COMBO-BOX-SubLinea BROWSE-2 Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR i AS INT NO-UNDO.
  DEF VAR k AS INT NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
      DO i = 1 TO NUM-ENTRIES(s-CodAlm):
          FIND Almacen WHERE Almacen.codcia = s-codcia
              AND Almacen.codalm = ENTRY(i, s-CodAlm)
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almacen THEN DO:
              COMBO-BOX-CodAlm:ADD-LAST(almacen.codalm + ' - ' + almacen.descrip).
/*               IF Almacen.codalm = input-var-1 THEN DO:                                       */
/*                   k = i.                                                                     */
/*                   COMBO-BOX-CodAlm:SCREEN-VALUE =  almacen.codalm + ' - ' + almacen.descrip. */
/*               END.                                                                           */
          END.
          IF i = 1 THEN COMBO-BOX-CodAlm:SCREEN-VALUE =  almacen.codalm + ' - ' + almacen.descrip.
      END.
      /*x-CodAlm = ENTRY(k, s-CodAlm).*/
      x-CodAlm = ENTRY(1, s-CodAlm).
      COMBO-BOX-Linea:DELIMITER = CHR(9).
      COMBO-BOX-SubLinea:DELIMITER = CHR(9).
      FOR EACH almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia:
          COMBO-BOX-Linea:ADD-LAST(Almtfami.codfam + ' - ' + Almtfami.desfam, Almtfami.codfam).

      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
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
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
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
  {src/adm/template/snd-list.i "Almmmate"}
  {src/adm/template/snd-list.i "Almtfami"}
  {src/adm/template/snd-list.i "T-MATG"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fComprometido D-Dialog 
FUNCTION fComprometido RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR x-StockComprometido AS DEC NO-UNDO.

/*RUN vta2/stock-comprometido (Almmmatg.CodMat, x-CodAlm, OUTPUT x-StockComprometido).*/
RUN vta2/stock-comprometido-v2 (Almmmatg.CodMat, x-CodAlm, OUTPUT x-StockComprometido).
RETURN x-StockComprometido.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

