&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-Almmmatg NO-UNDO LIKE Almmmatg.



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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-FlgRotacion LIKE GN-DIVI.FlgRotacion.
DEF SHARED VAR S-CODALM AS CHAR.
DEF SHARED VAR s-CodDiv AS CHAR.
DEF SHARED VAR s-CodCli AS CHAR.
DEF SHARED VAR s-NroDec AS INTE.

DEF VAR x-StkAct AS DECI NO-UNDO.

DEF SHARED VAR input-var-1 AS CHAR.
DEF SHARED VAR input-var-2 AS CHAR.
DEF SHARED VAR input-var-3 AS CHAR.
DEF SHARED VAR output-var-1 AS ROWID.
DEF SHARED VAR output-var-2 AS CHAR.
DEF SHARED VAR output-var-3 AS CHAR.

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
&Scoped-define INTERNAL-TABLES t-Almmmatg Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 t-Almmmatg.codmat t-Almmmatg.DesMat ~
t-Almmmatg.DesMar t-Almmmatg.StkMax t-Almmmatg.Prevta[1] t-Almmmatg.UndA ~
t-Almmmatg.Prevta[2] t-Almmmatg.UndB t-Almmmatg.Prevta[3] t-Almmmatg.UndC 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH t-Almmmatg NO-LOCK, ~
      FIRST Almmmatg OF t-Almmmatg NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH t-Almmmatg NO-LOCK, ~
      FIRST Almmmatg OF t-Almmmatg NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 t-Almmmatg Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 t-Almmmatg
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodAlm RADIO-SET-Stock ~
FILL-IN-codigo F-marca BUTTON_Filtrar f-CodFam f-SubFam CMB-filtro ~
FILL-IN-filtro BROWSE-2 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodAlm RADIO-SET-Stock ~
FILL-IN-codigo F-marca f-CodFam f-SubFam CMB-filtro FILL-IN-filtro 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.69
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.69
     BGCOLOR 8 .

DEFINE BUTTON BUTTON_Filtrar 
     LABEL "APLICAR FILTROS" 
     SIZE 35 BY 1.62
     FONT 8.

DEFINE VARIABLE CMB-filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Nombres que inicien con","Nombres que contengan" 
     DROP-DOWN-LIST
     SIZE 20.72 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE COMBO-BOX-CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 44 BY 1 NO-UNDO.

DEFINE VARIABLE f-CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Línea" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE f-SubFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Sub-Línea" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE F-marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-codigo AS CHARACTER FORMAT "X(9)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RADIO-SET-Stock AS CHARACTER INITIAL "C" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", "T",
"Solo con Stock", "C"
     SIZE 21 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      t-Almmmatg
    FIELDS(t-Almmmatg.codmat
      t-Almmmatg.DesMat
      t-Almmmatg.DesMar
      t-Almmmatg.StkMax
      t-Almmmatg.Prevta[1]
      t-Almmmatg.UndA
      t-Almmmatg.Prevta[2]
      t-Almmmatg.UndB
      t-Almmmatg.Prevta[3]
      t-Almmmatg.UndC), 
      Almmmatg
    FIELDS() SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      t-Almmmatg.codmat COLUMN-LABEL "Articulo" FORMAT "X(8)":U
      t-Almmmatg.DesMat FORMAT "X(100)":U WIDTH 98.14
      t-Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      t-Almmmatg.StkMax COLUMN-LABEL "Stock!Actual" FORMAT "-ZZ,ZZZ,ZZ9.99":U
      t-Almmmatg.Prevta[1] COLUMN-LABEL "Precio Vta!A Soles" FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      t-Almmmatg.UndA COLUMN-LABEL "UM.!A" FORMAT "X(8)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      t-Almmmatg.Prevta[2] COLUMN-LABEL "Precio Vta!B Soles" FORMAT ">>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      t-Almmmatg.UndB COLUMN-LABEL "UM.!B" FORMAT "X(8)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      t-Almmmatg.Prevta[3] COLUMN-LABEL "Precio Vta!C Soles" FORMAT ">>>,>>9.9999":U
            WIDTH 9.14 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
      t-Almmmatg.UndC COLUMN-LABEL "UM.!C" FORMAT "X(8)":U WIDTH 4.72
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 181 BY 16.96
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     COMBO-BOX-CodAlm AT ROW 1 COL 9 COLON-ALIGNED WIDGET-ID 8
     RADIO-SET-Stock AT ROW 1 COL 61 NO-LABEL WIDGET-ID 4
     FILL-IN-codigo AT ROW 2.08 COL 9.14 COLON-ALIGNED WIDGET-ID 18
     F-marca AT ROW 2.08 COL 25.14 COLON-ALIGNED WIDGET-ID 14
     BUTTON_Filtrar AT ROW 2.62 COL 91 WIDGET-ID 26
     f-CodFam AT ROW 3.15 COL 9 COLON-ALIGNED WIDGET-ID 22
     f-SubFam AT ROW 4.23 COL 9 COLON-ALIGNED WIDGET-ID 24
     CMB-filtro AT ROW 5.31 COL 11 NO-LABEL WIDGET-ID 10
     FILL-IN-filtro AT ROW 5.31 COL 32 NO-LABEL WIDGET-ID 20
     BROWSE-2 AT ROW 6.65 COL 2 WIDGET-ID 200
     Btn_OK AT ROW 23.62 COL 2
     Btn_Cancel AT ROW 23.62 COL 19
     SPACE(150.71) SKIP(0.45)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "<insert SmartDialog title>"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-Almmmatg T "?" NO-UNDO INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   NOT-VISIBLE FRAME-NAME                                               */
/* BROWSE-TAB BROWSE-2 FILL-IN-filtro D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX CMB-filtro IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-filtro IN FRAME D-Dialog
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.t-Almmmatg,INTEGRAL.Almmmatg OF Temp-Tables.t-Almmmatg"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = "USED, FIRST USED"
     _FldNameList[1]   > Temp-Tables.t-Almmmatg.codmat
"t-Almmmatg.codmat" "Articulo" "X(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-Almmmatg.DesMat
"t-Almmmatg.DesMat" ? "X(100)" "character" ? ? ? ? ? ? no ? no no "98.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-Almmmatg.DesMar
"t-Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-Almmmatg.StkMax
"t-Almmmatg.StkMax" "Stock!Actual" "-ZZ,ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-Almmmatg.Prevta[1]
"t-Almmmatg.Prevta[1]" "Precio Vta!A Soles" ">>>,>>9.9999" "decimal" 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-Almmmatg.UndA
"t-Almmmatg.UndA" "UM.!A" ? "character" 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-Almmmatg.Prevta[2]
"t-Almmmatg.Prevta[2]" "Precio Vta!B Soles" ">>>,>>9.9999" "decimal" 11 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.t-Almmmatg.UndB
"t-Almmmatg.UndB" "UM.!B" ? "character" 11 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.t-Almmmatg.Prevta[3]
"t-Almmmatg.Prevta[3]" "Precio Vta!C Soles" ">>>,>>9.9999" "decimal" 10 0 ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.t-Almmmatg.UndC
"t-Almmmatg.UndC" "UM.!C" ? "character" 10 0 ? ? ? ? no ? no no "4.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* <insert SmartDialog title> */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 D-Dialog
ON F8 OF BROWSE-2 IN FRAME D-Dialog
DO:
    ASSIGN
        input-var-1 = t-Almmmatg.CodMat
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN vtagn/d-almmmate-02.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  RUN Captura-Datos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Filtrar D-Dialog
ON CHOOSE OF BUTTON_Filtrar IN FRAME D-Dialog /* APLICAR FILTROS */
DO:
  ASSIGN CMB-filtro COMBO-BOX-CodAlm f-CodFam FILL-IN-codigo FILL-IN-filtro F-marca f-SubFam.

  IF TRUE <> (FILL-IN-codigo > '') AND f-CodFam = 'Todos' THEN DO:
      MESSAGE 'Debe escoger al menos una línea de producto' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO f-CodFam.
      RETURN NO-APPLY.
  END.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  SESSION:SET-WAIT-STATE('').

  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodAlm D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-CodAlm IN FRAME D-Dialog /* Almacén */
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-CodFam D-Dialog
ON VALUE-CHANGED OF f-CodFam IN FRAME D-Dialog /* Línea */
DO:
  ASSIGN f-CodFam.
  IF f-CodFam <> 'Todos' THEN DO:
      f-SubFam:DELETE(f-SubFam:LIST-ITEM-PAIRS) NO-ERROR.
      f-SubFam:ADD-LAST('Todos','Todos').
      f-SubFam:SCREEN-VALUE = 'Todos'.
      FOR EACH AlmSFami NO-LOCK WHERE AlmSFami.CodCia = s-codcia AND AlmSFami.codfam = f-CodFam:
          f-SubFam:ADD-LAST(AlmSFami.subfam + ' - ' + AlmSFami.dessub, AlmSFami.subfam).
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-marca D-Dialog
ON LEAVE OF F-marca IN FRAME D-Dialog /* Marca */
DO:
  APPLY "VALUE-CHANGED" TO CMB-filtro.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codigo D-Dialog
ON LEAVE OF FILL-IN-codigo IN FRAME D-Dialog /* Codigo */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto.r (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN DO:
        ASSIGN SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    SELF:SCREEN-VALUE = pCodMat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-filtro D-Dialog
ON LEAVE OF FILL-IN-filtro IN FRAME D-Dialog
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-Stock
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-Stock D-Dialog
ON VALUE-CHANGED OF RADIO-SET-Stock IN FRAME D-Dialog
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Datos D-Dialog 
PROCEDURE Captura-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF AVAILABLE t-Almmmatg THEN
    ASSIGN
        output-var-1 = ROWID(Almmmatg)
        output-var-2 = t-Almmmatg.codmat
        output-var-3 = COMBO-BOX-CodAlm.
    IF input-var-2 = "EAN" THEN output-var-2 = t-Almmmatg.codbrr.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&SCOPED-DEFINE precio-venta-general web/PrecioFinalContadoMayorista.p

&SCOPED-DEFINE CONDICION ( Almmmatg.CodCia = S-CODCIA  ~
AND (TRUE <> (FILL-IN-codigo > '') OR Almmmatg.codmat = FILL-IN-codigo) ~
AND (F-Codfam = 'Todos' OR Almmmatg.Codfam = F-Codfam) ~
AND (F-Subfam = 'Todos' OR Almmmatg.Subfam = F-Subfam) ~
AND (TRUE <> (F-Marca > '') OR Almmmatg.DesMar BEGINS F-marca) ~
AND Almmmatg.TpoArt <= s-FlgRotacion )

&SCOPED-DEFINE CONDICION2 ( Almmmate.codcia = Almmmatg.codcia AND ~
Almmmate.codalm = COMBO-BOX-CodAlm AND ~
Almmmate.codmat = Almmmatg.codmat AND ~
(RADIO-SET-Stock = 'T' OR Almmmate.StkAct > 0) )

&SCOPED-DEFINE FILTRO1 ( Almmmatg.codcia = s-codcia AND ~
Almmmatg.DesMat BEGINS FILL-IN-filtro AND ~
(F-Codfam = 'Todos' OR Almmmatg.Codfam = F-Codfam) AND ~
(F-Subfam = 'Todos' OR Almmmatg.Subfam = F-Subfam) )

&SCOPED-DEFINE FILTRO2 ( Almmmatg.codcia = s-codcia AND ~
INDEX(Almmmatg.DesMat, FILL-IN-filtro) <> 0 AND ~
(F-Codfam = 'Todos' OR Almmmatg.Codfam = F-Codfam) AND ~
(F-Subfam = 'Todos' OR Almmmatg.Subfam = F-Subfam) )

EMPTY TEMP-TABLE t-Almmmatg.

CASE TRUE:
    WHEN CMB-filtro <> 'Todos' AND FILL-IN-filtro > '' THEN DO:
        CASE CMB-filtro:
            WHEN 'Nombres que inicien con' THEN DO:
                FOR EACH Almmmatg NO-LOCK WHERE {&FILTRO1}:
                    IF NOT {&CONDICION} THEN NEXT.
                    FOR EACH Almmmate NO-LOCK WHERE {&CONDICION2}:
                        CREATE t-Almmmatg.
                        BUFFER-COPY Almmmatg TO t-Almmmatg.
                        ASSIGN t-Almmmatg.StkMax = Almmmate.StkAct.
                    END.
                END.
            END.
            WHEN 'Nombres que contengan' THEN DO:
                FOR EACH Almmmatg NO-LOCK WHERE {&FILTRO2}:
                    IF NOT {&CONDICION} THEN NEXT.
                    FOR EACH Almmmate NO-LOCK WHERE {&CONDICION2}:
                        CREATE t-Almmmatg.
                        BUFFER-COPY Almmmatg TO t-Almmmatg.
                        ASSIGN t-Almmmatg.StkMax = Almmmate.StkAct.
                    END.
                END.
            END.
        END CASE.
    END.
    OTHERWISE DO:
        FOR EACH Almmmatg NO-LOCK WHERE {&CONDICION}:
            FOR EACH Almmmate NO-LOCK WHERE {&CONDICION2}:
                CREATE t-Almmmatg.
                BUFFER-COPY Almmmatg TO t-Almmmatg.
                ASSIGN t-Almmmatg.StkMax = Almmmate.StkAct.
            END.
        END.
    END.
END CASE.

DEF VAR pComprometido AS DECI NO-UNDO.
DEF VAR s-TpoCmb AS DECI NO-UNDO.
DEF VAR f-Factor AS DECI NO-UNDO.
DEF VAR f-PreBas AS DECI NO-UNDO.
DEF VAR f-PreVta AS DECI NO-UNDO.
DEF VAR f-Dsctos AS DECI NO-UNDO.
DEF VAR y-Dsctos AS DECI NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.
DEF VAR f-FleteUnitario AS DECI NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

FOR EACH t-Almmmatg:
/*     RUN gn/stock-comprometido-v2 (t-Almmmatg.CodMat,              */
/*                                   COMBO-BOX-CodAlm,               */
/*                                   TRUE,                           */
/*                                   OUTPUT pComprometido).          */
/*     ASSIGN t-Almmmatg.StkMax = t-Almmmatg.StkMax - pComprometido. */
/*     IF t-Almmmatg.StkMax <= 0 THEN DO:                            */
/*         DELETE t-Almmmatg.                                        */
/*         NEXT.                                                     */
/*     END.                                                          */
    ASSIGN
        t-Almmmatg.Prevta[1] = 0
        t-Almmmatg.Prevta[2] = 0
        t-Almmmatg.Prevta[3] = 0.
    /* Disparamos solo el primero */
    RUN {&precio-venta-general} (s-CodCia,
                                 s-CodDiv,
                                 s-CodCli,
                                 1,
                                 s-TpoCmb,
                                 OUTPUT f-Factor,
                                 t-Almmmatg.codmat,
                                 '',
                                 t-Almmmatg.undbas,
                                 1,
                                 s-NroDec,
                                 COMBO-BOX-CodAlm,
                                 OUTPUT f-PreBas,
                                 OUTPUT f-PreVta,
                                 OUTPUT f-Dsctos,
                                 OUTPUT y-Dsctos,
                                 OUTPUT x-TipDto,
                                 OUTPUT f-FleteUnitario,
                                 OUTPUT pMensaje
                                   ).
    IF RETURN-VALUE = 'ADM-ERROR' OR f-PreVta <= 0 THEN NEXT.

    IF t-Almmmatg.UndA > '' THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid  = t-Almmmatg.UndBas 
            AND Almtconv.Codalter = t-Almmmatg.UndA
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN NEXT.
        F-FACTOR = Almtconv.Equival.
        t-Almmmatg.Prevta[1] = (f-PreVta + f-FleteUnitario) * f-Factor.
/*         RUN {&precio-venta-general} (s-CodCia,                                   */
/*                                      s-CodDiv,                                   */
/*                                      s-CodCli,                                   */
/*                                      1,                                          */
/*                                      s-TpoCmb,                                   */
/*                                      OUTPUT f-Factor,                            */
/*                                      t-Almmmatg.codmat,                          */
/*                                      '',                                         */
/*                                      t-Almmmatg.UndA,                            */
/*                                      1,                                          */
/*                                      s-NroDec,                                   */
/*                                      COMBO-BOX-CodAlm,                           */
/*                                      OUTPUT f-PreBas,                            */
/*                                      OUTPUT f-PreVta,                            */
/*                                      OUTPUT f-Dsctos,                            */
/*                                      OUTPUT y-Dsctos,                            */
/*                                      OUTPUT x-TipDto,                            */
/*                                      OUTPUT f-FleteUnitario,                     */
/*                                      OUTPUT pMensaje                             */
/*                                        ).                                        */
/*         IF RETURN-VALUE <> 'ADM-ERROR' AND                                       */
/*             f-PreVta > 0 THEN t-Almmmatg.Prevta[1] = f-PreVta + f-FleteUnitario. */
    END.
    IF t-Almmmatg.UndB > '' THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid  = t-Almmmatg.UndBas 
            AND Almtconv.Codalter = t-Almmmatg.UndB
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN NEXT.
        F-FACTOR = Almtconv.Equival.
        t-Almmmatg.Prevta[2] = (f-PreVta + f-FleteUnitario) * f-Factor.
/*         RUN {&precio-venta-general} (s-CodCia,                                   */
/*                                      s-CodDiv,                                   */
/*                                      s-CodCli,                                   */
/*                                      1,                                          */
/*                                      s-TpoCmb,                                   */
/*                                      OUTPUT f-Factor,                            */
/*                                      t-Almmmatg.codmat,                          */
/*                                      '',                                         */
/*                                      t-Almmmatg.UndB,                            */
/*                                      1,                                          */
/*                                      s-NroDec,                                   */
/*                                      COMBO-BOX-CodAlm,                           */
/*                                      OUTPUT f-PreBas,                            */
/*                                      OUTPUT f-PreVta,                            */
/*                                      OUTPUT f-Dsctos,                            */
/*                                      OUTPUT y-Dsctos,                            */
/*                                      OUTPUT x-TipDto,                            */
/*                                      OUTPUT f-FleteUnitario,                     */
/*                                      OUTPUT pMensaje                             */
/*                                        ).                                        */
/*         IF RETURN-VALUE <> 'ADM-ERROR' AND                                       */
/*             f-PreVta > 0 THEN t-Almmmatg.Prevta[2] = f-PreVta + f-FleteUnitario. */
    END.
    IF t-Almmmatg.UndC > '' THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid  = t-Almmmatg.UndBas 
            AND Almtconv.Codalter = t-Almmmatg.UndC
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN NEXT.
        F-FACTOR = Almtconv.Equival.
        t-Almmmatg.Prevta[3] = (f-PreVta + f-FleteUnitario) * f-Factor.
/*         RUN {&precio-venta-general} (s-CodCia,                                   */
/*                                      s-CodDiv,                                   */
/*                                      s-CodCli,                                   */
/*                                      1,                                          */
/*                                      s-TpoCmb,                                   */
/*                                      OUTPUT f-Factor,                            */
/*                                      t-Almmmatg.codmat,                          */
/*                                      '',                                         */
/*                                      t-Almmmatg.UndC,                            */
/*                                      1,                                          */
/*                                      s-NroDec,                                   */
/*                                      COMBO-BOX-CodAlm,                           */
/*                                      OUTPUT f-PreBas,                            */
/*                                      OUTPUT f-PreVta,                            */
/*                                      OUTPUT f-Dsctos,                            */
/*                                      OUTPUT y-Dsctos,                            */
/*                                      OUTPUT x-TipDto,                            */
/*                                      OUTPUT f-FleteUnitario,                     */
/*                                      OUTPUT pMensaje                             */
/*                                        ).                                        */
/*         IF RETURN-VALUE <> 'ADM-ERROR' AND                                       */
/*             f-PreVta > 0 THEN t-Almmmatg.Prevta[3] = f-PreVta + f-FleteUnitario. */
    END.
END.

FOR EACH t-Almmmatg WHERE t-Almmmatg.Prevta[1] <= 0:
    DELETE t-Almmmatg.
END.

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
  DISPLAY COMBO-BOX-CodAlm RADIO-SET-Stock FILL-IN-codigo F-marca f-CodFam 
          f-SubFam CMB-filtro FILL-IN-filtro 
      WITH FRAME D-Dialog.
  ENABLE COMBO-BOX-CodAlm RADIO-SET-Stock FILL-IN-codigo F-marca BUTTON_Filtrar 
         f-CodFam f-SubFam CMB-filtro FILL-IN-filtro BROWSE-2 Btn_OK Btn_Cancel 
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
  DEF VAR i AS INTE NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-CodAlm:DELIMITER = '|'.
      COMBO-BOX-CodAlm:DELETE(1).
      DO i = 1 TO NUM-ENTRIES(s-CodAlm):
          FIND Almacen WHERE Almacen.codcia = s-codcia
              AND Almacen.codalm = ENTRY(i, s-CodAlm)
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almacen THEN DO:
              COMBO-BOX-CodAlm:ADD-LAST(almacen.codalm + ' - ' + almacen.descrip, almacen.codalm).
              IF almacen.codalm = ENTRY(1, s-codalm) THEN COMBO-BOX-CodAlm:SCREEN-VALUE = almacen.codalm.
          END.
      END.
      f-CodFam:DELIMITER = '|'.
      FOR EACH Almtfami NO-LOCK WHERE Almtfami.CodCia = s-codcia AND
          Almtfami.SwComercial = YES:
          f-CodFam:ADD-LAST(Almtfami.codfam + ' - ' + Almtfami.desfam, Almtfami.codfam).
      END.
      f-SubFam:DELIMITER = '|'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "t-Almmmatg"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

