&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
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
DEF SHARED VAR s-codcia AS INTE.

/* Local Variable Definitions ---                                       */

DEF VAR x-CodDoc AS CHAR FORMAT 'x(3)' NO-UNDO.
DEF VAR x-NroDoc AS CHAR FORMAT 'x(12)' NO-UNDO.
DEF VAR x-CodMat AS CHAR FORMAT 'x(8)' NO-UNDO.
DEF VAR x-Antes AS DECI FORMAT '>>>,>>9.99' NO-UNDO.
DEF VAR x-Despues AS DECI FORMAT '>>>,>>9.99' NO-UNDO.
DEF VAR x-CodOri AS CHAR FORMAT 'x(8)' NO-UNDO.
DEF VAR x-NroOri AS CHAR FORMAT 'x(15)' NO-UNDO.
DEF VAR x-Motivo AS CHAR FORMAT 'x(8)' NO-UNDO.
DEF VAR x-NomMot AS CHAR FORMAT 'x(30)' NO-UNDO.

&SCOPED-DEFINE Condicion ( logtabla.codcia = s-codcia ~
AND logtabla.Tabla = 'FACDPEDI' ~
AND logtabla.Evento = 'CORRECCION' ~
AND (logtabla.Dia >= FILL-IN-Dia-1 AND logtabla.Dia <= FILL-IN-Dia-2) ~
AND ( TRUE <> (FILL-IN-CodDoc > '') OR ENTRY(1,logtabla.ValorLlave,'|') = FILL-IN-CodDoc ) ~
AND ( TRUE <> (FILL-IN-NroDoc > '') OR ENTRY(2,logtabla.ValorLlave,'|') = FILL-IN-NroDoc ) )

DEF TEMP-TABLE Reporte
    FIELD Dia LIKE logtabla.Dia             LABEL 'Fecha'
    FIELD Hora LIKE logtabla.Hora           LABEL 'Hora'
    FIELD Usuario LIKE logtabla.Usuario     LABEL 'Usuario'
    FIELD CodDoc AS CHAR FORMAT 'x(5)'      LABEL 'Doc'
    FIELD NroDoc AS CHAR FORMAT 'x(12)'     LABEL 'Numero'
    FIELD CodMat AS CHAR FORMAT 'x(10)'     LABEL 'Articulo'
    FIELD DesMat AS CHAR FORMAT 'x(80)'     LABEL 'Descripcion'
    FIELD DesMar AS CHAR FORMAT 'x(30)'     LABEL 'Marca'
    FIELD CodUnd AS CHAR FORMAT 'x(6)'      LABEL 'Unidad'
    FIELD Antes  LIKE x-Antes               LABEL 'Cantidad Antes'
    FIELD Despues LIKE x-Despues            LABEL 'Cantidad Despues'
    FIELD CodOri LIKE x-CodOri              LABEL 'Origen'
    FIELD NroOri LIKE x-nroOri              LABEL 'Numero'
    FIELD Motivo LIKE x-Motivo              LABEL 'Motivo'
    FIELD NomMot LIKE x-NomMot              LABEL 'Descripcion'
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-16

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES logtabla Almmmatg

/* Definitions for BROWSE BROWSE-16                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-16 logtabla.Dia logtabla.Hora ~
logtabla.Usuario ENTRY(1,logtabla.ValorLlave,'|') @ x-CodDoc ~
ENTRY(2,logtabla.ValorLlave,'|') @ x-NroDoc ~
ENTRY(3,logtabla.ValorLlave,'|') @ x-CodMat Almmmatg.DesMat Almmmatg.DesMar ~
Almmmatg.UndBas DECIMAL(ENTRY(4,logtabla.ValorLlave,'|')) @ x-Antes ~
DECIMAL(ENTRY(5,logtabla.ValorLlave,'|')) @ x-Despues ~
(IF NUM-ENTRIES(logtabla.ValorLlave,'|') >= 6 THEN ENTRY(6,logtabla.ValorLlave,'|') ELSE '') @ x-CodOri ~
(IF  NUM-ENTRIES(logtabla.ValorLlave,'|') >= 7 THEN  ENTRY(7,logtabla.ValorLlave,'|') ELSE '') @ x-NroOri ~
(IF NUM-ENTRIES(logtabla.ValorLlave,'|') >= 8 THEN  ENTRY(8,logtabla.ValorLlave,'|') ELSE '') @ x-Motivo ~
(IF NUM-ENTRIES(logtabla.ValorLlave,'|') >= 8 THEN  fMotivo(ENTRY(8,logtabla.ValorLlave,'|')) ELSE '') @ x-NomMot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-16 
&Scoped-define QUERY-STRING-BROWSE-16 FOR EACH logtabla ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST Almmmatg WHERE Almmmatg.codmat = ENTRY(3,logtabla.ValorLlave,'|') ~
      AND Almmmatg.CodCia = s-codcia OUTER-JOIN NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-16 OPEN QUERY BROWSE-16 FOR EACH logtabla ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST Almmmatg WHERE Almmmatg.codmat = ENTRY(3,logtabla.ValorLlave,'|') ~
      AND Almmmatg.CodCia = s-codcia OUTER-JOIN NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-16 logtabla Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-16 logtabla
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-16 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-16}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-CodDoc FILL-IN-Dia-1 FILL-IN-Dia-2 ~
FILL-IN-NroDoc BROWSE-16 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodDoc FILL-IN-Dia-1 FILL-IN-Dia-2 ~
FILL-IN-NroDoc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMotivo W-Win 
FUNCTION fMotivo RETURNS CHARACTER
  ( INPUT pMotivo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\new.ico":U
     LABEL "A TEXTO" 
     SIZE 6 BY 1.73 TOOLTIP "A TEXTO".

DEFINE VARIABLE FILL-IN-CodDoc AS CHARACTER FORMAT "X(5)":U 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Dia-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Dia-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "X(12)":U 
     LABEL "Número" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-16 FOR 
      logtabla, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-16 W-Win _STRUCTURED
  QUERY BROWSE-16 NO-LOCK DISPLAY
      logtabla.Dia FORMAT "99/99/9999":U
      logtabla.Hora FORMAT "X(8)":U
      logtabla.Usuario FORMAT "x(12)":U
      ENTRY(1,logtabla.ValorLlave,'|') @ x-CodDoc COLUMN-LABEL "Doc"
            WIDTH 6.57
      ENTRY(2,logtabla.ValorLlave,'|') @ x-NroDoc COLUMN-LABEL "Número"
            WIDTH 12.43
      ENTRY(3,logtabla.ValorLlave,'|') @ x-CodMat COLUMN-LABEL "Artículo"
            WIDTH 10.43
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 53.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U
      Almmmatg.UndBas COLUMN-LABEL "Unidad" FORMAT "X(8)":U
      DECIMAL(ENTRY(4,logtabla.ValorLlave,'|')) @ x-Antes COLUMN-LABEL "Cantidad!Antes"
            WIDTH 9.43
      DECIMAL(ENTRY(5,logtabla.ValorLlave,'|')) @ x-Despues COLUMN-LABEL "Cantidad!Después"
            WIDTH 8.72
      (IF NUM-ENTRIES(logtabla.ValorLlave,'|') >= 6 THEN ENTRY(6,logtabla.ValorLlave,'|') ELSE '') @ x-CodOri COLUMN-LABEL "Origen"
      (IF  NUM-ENTRIES(logtabla.ValorLlave,'|') >= 7 THEN 
ENTRY(7,logtabla.ValorLlave,'|') ELSE '') @ x-NroOri COLUMN-LABEL "Número"
            WIDTH 12.86
      (IF NUM-ENTRIES(logtabla.ValorLlave,'|') >= 8 THEN 
ENTRY(8,logtabla.ValorLlave,'|') ELSE '') @ x-Motivo COLUMN-LABEL "Motivo"
            WIDTH 6.43
      (IF NUM-ENTRIES(logtabla.ValorLlave,'|') >= 8 THEN 
fMotivo(ENTRY(8,logtabla.ValorLlave,'|')) ELSE '') @ x-NomMot COLUMN-LABEL "Descripción"
            WIDTH 23.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 189 BY 23.42
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodDoc AT ROW 1.27 COL 59 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-Dia-1 AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-Dia-2 AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-NroDoc AT ROW 2.08 COL 59 COLON-ALIGNED WIDGET-ID 8
     BROWSE-16 AT ROW 3.15 COL 2 WIDGET-ID 200
     BUTTON-2 AT ROW 1.27 COL 151 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 190.86 BY 25.85
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "LOG DE MODIFICACIONES HPK"
         HEIGHT             = 25.85
         WIDTH              = 190.86
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 194.14
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 194.14
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-16 FILL-IN-NroDoc F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-16
/* Query rebuild information for BROWSE BROWSE-16
     _TblList          = "INTEGRAL.logtabla,INTEGRAL.Almmmatg WHERE INTEGRAL.logtabla ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST OUTER"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "Almmmatg.codmat = ENTRY(3,logtabla.ValorLlave,'|')"
     _Where[2]         = "Almmmatg.CodCia = s-codcia"
     _FldNameList[1]   = INTEGRAL.logtabla.Dia
     _FldNameList[2]   = INTEGRAL.logtabla.Hora
     _FldNameList[3]   = INTEGRAL.logtabla.Usuario
     _FldNameList[4]   > "_<CALC>"
"ENTRY(1,logtabla.ValorLlave,'|') @ x-CodDoc" "Doc" ? ? ? ? ? ? ? ? no ? no no "6.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"ENTRY(2,logtabla.ValorLlave,'|') @ x-NroDoc" "Número" ? ? ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"ENTRY(3,logtabla.ValorLlave,'|') @ x-CodMat" "Artículo" ? ? ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "53.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"DECIMAL(ENTRY(4,logtabla.ValorLlave,'|')) @ x-Antes" "Cantidad!Antes" ? ? ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"DECIMAL(ENTRY(5,logtabla.ValorLlave,'|')) @ x-Despues" "Cantidad!Después" ? ? ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"(IF NUM-ENTRIES(logtabla.ValorLlave,'|') >= 6 THEN ENTRY(6,logtabla.ValorLlave,'|') ELSE '') @ x-CodOri" "Origen" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"(IF  NUM-ENTRIES(logtabla.ValorLlave,'|') >= 7 THEN 
ENTRY(7,logtabla.ValorLlave,'|') ELSE '') @ x-NroOri" "Número" ? ? ? ? ? ? ? ? no ? no no "12.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"(IF NUM-ENTRIES(logtabla.ValorLlave,'|') >= 8 THEN 
ENTRY(8,logtabla.ValorLlave,'|') ELSE '') @ x-Motivo" "Motivo" ? ? ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"(IF NUM-ENTRIES(logtabla.ValorLlave,'|') >= 8 THEN 
fMotivo(ENTRY(8,logtabla.ValorLlave,'|')) ELSE '') @ x-NomMot" "Descripción" ? ? ? ? ? ? ? ? no ? no no "23.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-16 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* LOG DE MODIFICACIONES HPK */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* LOG DE MODIFICACIONES HPK */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* A TEXTO */
DO:
  /*SESSION:SET-WAIT-STATE('GENERAL').*/
  RUN Texto.
  /*SESSION:SET-WAIT-STATE('').*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodDoc W-Win
ON LEAVE OF FILL-IN-CodDoc IN FRAME F-Main /* Documento */
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Dia-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Dia-1 W-Win
ON LEAVE OF FILL-IN-Dia-1 IN FRAME F-Main /* Fecha Desde */
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Dia-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Dia-2 W-Win
ON LEAVE OF FILL-IN-Dia-2 IN FRAME F-Main /* Fecha Hasta */
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroDoc W-Win
ON LEAVE OF FILL-IN-NroDoc IN FRAME F-Main /* Número */
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-16
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
  DISPLAY FILL-IN-CodDoc FILL-IN-Dia-1 FILL-IN-Dia-2 FILL-IN-NroDoc 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-CodDoc FILL-IN-Dia-1 FILL-IN-Dia-2 FILL-IN-NroDoc BROWSE-16 
         BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
  FILL-IN-Dia-1 = TODAY.
  FILL-IN-Dia-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "logtabla"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').
    EMPTY TEMP-TABLE Reporte.
    
    GET FIRST {&BROWSE-NAME}.
    DO WHILE NOT QUERY-OFF-END('{&BROWSE-NAME}'):
        CREATE Reporte.
        ASSIGN 
            Reporte.Dia = logtabla.Dia
            Reporte.Hora = logtabla.Hora
            Reporte.Usuario = logtabla.Usuario
            Reporte.CodDoc = ENTRY(1,logtabla.ValorLlave,'|')
            Reporte.NroDoc = ENTRY(2,logtabla.ValorLlave,'|')
            Reporte.CodMat = ENTRY(3,logtabla.ValorLlave,'|').
        IF AVAILABLE Almmmatg THEN
            ASSIGN
            Reporte.DesMat = Almmmatg.desmat
            Reporte.DesMar = Almmmatg.desmar
            Reporte.CodUnd = Almmmatg.undbas.
        ASSIGN
            Reporte.Antes = DECIMAL(ENTRY(4,logtabla.ValorLlave,'|'))
            Reporte.Despues = DECIMAL(ENTRY(5,logtabla.ValorLlave,'|'))
            Reporte.CodOri = (IF NUM-ENTRIES(logtabla.ValorLlave,'|') >= 6 THEN ENTRY(6,logtabla.ValorLlave,'|') ELSE '')
            Reporte.NroOri = (IF  NUM-ENTRIES(logtabla.ValorLlave,'|') >= 7 THEN ENTRY(7,logtabla.ValorLlave,'|') ELSE '')
            Reporte.Motivo = (IF NUM-ENTRIES(logtabla.ValorLlave,'|') >= 8 THEN ENTRY(8,logtabla.ValorLlave,'|') ELSE '')
            Reporte.NomMot = (IF NUM-ENTRIES(logtabla.ValorLlave,'|') >= 8 THEN fMotivo(ENTRY(8,logtabla.ValorLlave,'|')) ELSE '')
            .
        GET NEXT {&BROWSE-NAME}.
    END.
    SESSION:SET-WAIT-STATE('').
    FIND FIRST Reporte NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Reporte THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN lib/tt-filev2 (TEMP-TABLE Reporte:HANDLE, cArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fMotivo W-Win 
FUNCTION fMotivo RETURNS CHARACTER
  ( INPUT pMotivo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND AlmTabla WHERE almtabla.Tabla = "HPK" AND
      almtabla.NomAnt = "PO" AND
      almtabla.Codigo = pMotivo
      NO-LOCK NO-ERROR.
  IF AVAILABLE AlmTabla THEN RETURN almtabla.Nombre .
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

