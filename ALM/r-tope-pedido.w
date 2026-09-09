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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.

DEF VAR s-Tabla AS CHAR INIT 'TOPEDESPACHO' NO-UNDO.

DEF VAR x-CanPed AS DEC NO-UNDO.
DEF VAR x-Tope   AS DEC NO-UNDO.
DEF VAR x-AlmDes AS CHAR NO-UNDO.
DEF VAR x-AlmSug AS CHAR NO-UNDO.
DEF VAR x-StkDes AS DEC NO-UNDO.
DEF VAR x-StkSug AS DEC NO-UNDO.

&SCOPED-DEFINE Condicion ( ~
logtabla.codcia = s-codcia AND ~
logtabla.Tabla = s-tabla AND ~
(FILL-IN-FchDoc-1 = ? OR logtabla.Dia >= FILL-IN-FchDoc-1) AND ~
(FILL-IN-FchDoc-2 = ? OR logtabla.Dia <= FILL-IN-FchDoc-2) )


DEF TEMP-TABLE Detalle
    FIELD Hora AS CHAR COLUMN-LABEL 'Hora'
    FIELD Fecha AS DATE COLUMN-LABEL 'Fecha'
    FIELD Usuario AS CHAR COLUMN-LABEL 'Usuario'
    FIELD Vendedor AS CHAR COLUMN-LABEL 'Vendedor'
    FIELD NroPed AS CHAR COLUMN-LABEL 'Nro.Pedido'
    FIELD NroCot AS CHAR COLUMN-LABEL 'Nro. Cotizacion'
    FIELD CodMat AS CHAR COLUMN-LABEL 'Código'
    FIELD DesMat AS CHAR COLUMN-LABEL 'Descripción'
    FIELD Marca AS CHAR COLUMN-LABEL 'Marca'
    FIELD Unidad AS CHAR COLUMN-LABEL 'Unidad'
    FIELD CanPed AS DEC COLUMN-LABEL 'Cantidad Pedido'
    FIELD Tope AS DEC COLUMN-LABEL 'Cantidad Tope'
    FIELD AlmDes AS CHAR COLUMN-LABEL 'Almacén Despacho'
    FIELD AlmSug AS CHAR COLUMN-LABEL 'Almacén Sugerido'
    FIELD StkDes AS DEC COLUMN-LABEL 'Stock Alm. Despacho'
    FIELD StkSug AS DEC COLUMN-LABEL 'Stock Alm. Sugerido'
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
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES logtabla FacCPedi Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 logtabla.Hora logtabla.Dia ~
logtabla.Usuario logtabla.Evento FacCPedi.CodVen FacCPedi.CodDoc ~
FacCPedi.NroPed FacCPedi.CodRef FacCPedi.NroRef Almmmatg.codmat ~
Almmmatg.DesMat Almmmatg.DesMar Almmmatg.UndStk ~
DECIMAL(ENTRY(4,logtabla.ValorLlave,'|')) @ x-CanPed ~
DECIMAL(ENTRY(5,logtabla.ValorLlave,'|')) @ x-Tope ~
ENTRY(6,logtabla.ValorLlave,'|') @ x-AlmDes ~
DECIMAL(ENTRY(7,logtabla.ValorLlave,'|')) @ x-StkDes ~
ENTRY(8,logtabla.ValorLlave,'|') @ x-AlmSug ~
DECIMAL(ENTRY(9,logtabla.ValorLlave,'|')) @ x-StkSug 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH logtabla ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = logtabla.codcia ~
  AND FacCPedi.CodDoc = ENTRY(1,logtabla.ValorLlave,'|') ~
  AND FacCPedi.NroPed = ENTRY(2,logtabla.ValorLlave,'|') NO-LOCK, ~
      FIRST Almmmatg WHERE Almmmatg.CodCia = logtabla.codcia ~
  AND Almmmatg.codmat = ENTRY(3,logtabla.ValorLlave,'|') NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH logtabla ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = logtabla.codcia ~
  AND FacCPedi.CodDoc = ENTRY(1,logtabla.ValorLlave,'|') ~
  AND FacCPedi.NroPed = ENTRY(2,logtabla.ValorLlave,'|') NO-LOCK, ~
      FIRST Almmmatg WHERE Almmmatg.CodCia = logtabla.codcia ~
  AND Almmmatg.codmat = ENTRY(3,logtabla.ValorLlave,'|') NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 logtabla FacCPedi Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 logtabla
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 FacCPedi
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-2 FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 ~
BUTTON-1 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Aplicar Filtros" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 6 BY 1.62.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      logtabla, 
      FacCPedi
    FIELDS(FacCPedi.CodVen
      FacCPedi.CodDoc
      FacCPedi.NroPed
      FacCPedi.CodRef
      FacCPedi.NroRef), 
      Almmmatg
    FIELDS(Almmmatg.codmat
      Almmmatg.DesMat
      Almmmatg.DesMar
      Almmmatg.UndStk) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      logtabla.Hora FORMAT "X(8)":U WIDTH 6.72
      logtabla.Dia FORMAT "99/99/9999":U
      logtabla.Usuario FORMAT "x(12)":U WIDTH 8.43
      logtabla.Evento FORMAT "x(10)":U WIDTH 10.57
      FacCPedi.CodVen FORMAT "x(10)":U
      FacCPedi.CodDoc FORMAT "x(3)":U
      FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U
      FacCPedi.CodRef COLUMN-LABEL "Ref." FORMAT "x(3)":U WIDTH 5
      FacCPedi.NroRef COLUMN-LABEL "Numero" FORMAT "X(12)":U
      Almmmatg.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U WIDTH 6.86
      Almmmatg.DesMat FORMAT "X(45)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 11.14
      Almmmatg.UndStk COLUMN-LABEL "Unidad" FORMAT "X(8)":U
      DECIMAL(ENTRY(4,logtabla.ValorLlave,'|')) @ x-CanPed COLUMN-LABEL "Cantidad Pedido"
      DECIMAL(ENTRY(5,logtabla.ValorLlave,'|')) @ x-Tope COLUMN-LABEL "Cantidad Tope"
      ENTRY(6,logtabla.ValorLlave,'|') @ x-AlmDes COLUMN-LABEL "Alm. Despacho"
      DECIMAL(ENTRY(7,logtabla.ValorLlave,'|')) @ x-StkDes COLUMN-LABEL "Disponible"
      ENTRY(8,logtabla.ValorLlave,'|') @ x-AlmSug COLUMN-LABEL "Alm. Sugerido"
      DECIMAL(ENTRY(9,logtabla.ValorLlave,'|')) @ x-StkSug COLUMN-LABEL "Disponible"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 141 BY 22.88
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-2 AT ROW 1.27 COL 64 WIDGET-ID 8
     FILL-IN-FchDoc-1 AT ROW 1.54 COL 9 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-FchDoc-2 AT ROW 1.54 COL 30 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 1.54 COL 47 WIDGET-ID 6
     BROWSE-2 AT ROW 3.15 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 143.29 BY 25.38
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
         TITLE              = "INFORME TOPE DE DESPACHO"
         HEIGHT             = 25.38
         WIDTH              = 143.29
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartWindowCues" W-Win _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartWindow,ab,49271
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
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
/* BROWSE-TAB BROWSE-2 BUTTON-1 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.logtabla,INTEGRAL.FacCPedi WHERE INTEGRAL.logtabla ...,INTEGRAL.Almmmatg WHERE INTEGRAL.logtabla ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST USED, FIRST USED"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "FacCPedi.CodCia = logtabla.codcia
  AND FacCPedi.CodDoc = ENTRY(1,logtabla.ValorLlave,'|')
  AND FacCPedi.NroPed = ENTRY(2,logtabla.ValorLlave,'|')"
     _JoinCode[3]      = "Almmmatg.CodCia = logtabla.codcia
  AND Almmmatg.codmat = ENTRY(3,logtabla.ValorLlave,'|')"
     _FldNameList[1]   > INTEGRAL.logtabla.Hora
"logtabla.Hora" ? ? "character" ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.logtabla.Dia
     _FldNameList[3]   > INTEGRAL.logtabla.Usuario
"logtabla.Usuario" ? ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.logtabla.Evento
"logtabla.Evento" ? ? "character" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.FacCPedi.CodVen
     _FldNameList[6]   = INTEGRAL.FacCPedi.CodDoc
     _FldNameList[7]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacCPedi.CodRef
"FacCPedi.CodRef" "Ref." ? "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacCPedi.NroRef
"FacCPedi.NroRef" "Numero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.Almmmatg.codmat
"Almmmatg.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "6.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[12]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.Almmmatg.UndStk
"Almmmatg.UndStk" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"DECIMAL(ENTRY(4,logtabla.ValorLlave,'|')) @ x-CanPed" "Cantidad Pedido" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"DECIMAL(ENTRY(5,logtabla.ValorLlave,'|')) @ x-Tope" "Cantidad Tope" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"ENTRY(6,logtabla.ValorLlave,'|') @ x-AlmDes" "Alm. Despacho" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"DECIMAL(ENTRY(7,logtabla.ValorLlave,'|')) @ x-StkDes" "Disponible" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"ENTRY(8,logtabla.ValorLlave,'|') @ x-AlmSug" "Alm. Sugerido" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > "_<CALC>"
"DECIMAL(ENTRY(9,logtabla.ValorLlave,'|')) @ x-StkSug" "Disponible" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* INFORME TOPE DE DESPACHO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* INFORME TOPE DE DESPACHO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Aplicar Filtros */
DO:
  ASSIGN FILL-IN-FchDoc-1 FILL-IN-FchDoc-2.
  {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN Excel.
  {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle W-Win 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

GET FIRST {&BROWSE-NAME}.
REPEAT WHILE AVAILABLE LogTabla:
    CREATE Detalle.
    ASSIGN
        Detalle.Hora = logtabla.Hora 
        Detalle.Fecha = logtabla.Dia 
        Detalle.Usuario = logtabla.Usuario
        Detalle.Vendedor = FacCPedi.CodVen
        Detalle.NroPed = FacCPedi.NroPed
        Detalle.NroCot = FacCPedi.NroRef
        Detalle.CodMat = Almmmatg.codmat 
        Detalle.DesMat = Almmmatg.DesMat 
        Detalle.Marca = Almmmatg.DesMar 
        Detalle.Unidad = Almmmatg.UndStk
        Detalle.CanPed = DECIMAL(ENTRY(4,logtabla.ValorLlave,'|'))
        Detalle.Tope = DECIMAL(ENTRY(5,logtabla.ValorLlave,'|'))
        Detalle.AlmDes = ENTRY(6,logtabla.ValorLlave,'|')
        Detalle.AlmSug = ENTRY(8,logtabla.ValorLlave,'|')
        Detalle.StkDes = DECIMAL(ENTRY(7,logtabla.ValorLlave,'|'))
        Detalle.StkSug = DECIMAL(ENTRY(9,logtabla.ValorLlave,'|'))
        .
    GET NEXT {&BROWSE-NAME}.
END.

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
  DISPLAY FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-2 FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 BUTTON-1 BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR c-csv-file AS CHAR NO-UNDO.
DEF VAR c-xls-file AS CHAR INIT 'Archivo_Excel' NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.xlsx'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".xlsx"
    SAVE-AS
    TITLE "Guardar como"
    USE-FILENAME
    UPDATE rpta.
IF rpta = NO THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
/* Variable de memoria */
DEFINE VAR hProc AS HANDLE NO-UNDO.
/* Levantamos la libreria a memoria */
RUN lib\Tools-to-excel PERSISTENT SET hProc.

/* Cargamos la informacion al temporal */
EMPTY TEMP-TABLE Detalle.
RUN Carga-Detalle.

/* Programas que generan el Excel */
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:handle,
                                  INPUT  c-csv-file,
                                  OUTPUT c-xls-file) .

/* Borramos librerias de la memoria */
DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').

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
  {src/adm/template/snd-list.i "FacCPedi"}
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

