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
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.

&SCOPED-DEFINE Condicion ~
( LogHpkNoUbic.CodCia = s-codcia AND ~
  LogHpkNoUbic.CodDiv = s-coddiv AND ~
  LogHpkNoUbic.CodPed = 'HPK' AND ~
  ( TRUE <> (FILL-IN_CodMat > '') OR LogHpkNoUbic.CodMat = FILL-IN_CodMat ) AND ~
  LogHpkNoUbic.Fecha >= FILL-IN_FchIni AND ~
  LogHpkNoUbic.Fecha <= FILL-IN_FchFin )


DEF TEMP-TABLE Reporte 
    FIELD codped LIKE LogHpkNoUbic.CodPed 
    FIELD nroped LIKE LogHpkNoUbic.NroPed 
    FIELD codref LIKE LogHpkNoUbic.CodRef 
    FIELD nroref LIKE LogHpkNoUbic.NroRef 
    FIELD picador LIKE LogHpkNoUbic.Picador 
    FIELD nompicador LIKE LogHpkNoUbic.NomPicador 
    FIELD codmat LIKE LogHpkNoUbic.CodMat 
    FIELD canped LIKE LogHpkNoUbic.CanPed 
    FIELD undvta LIKE LogHpkNoUbic.UndVta 
    FIELD almdes LIKE LogHpkNoUbic.AlmDes 
    FIELD codzona LIKE LogHpkNoUbic.CodZona 
    FIELD codubi LIKE LogHpkNoUbic.CodUbi 
    FIELD fecha LIKE LogHpkNoUbic.Fecha 
    FIELD hora LIKE LogHpkNoUbic.Hora 
    FIELD usuario LIKE LogHpkNoUbic.Usuario.

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
&Scoped-define INTERNAL-TABLES LogHpkNoUbic Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 LogHpkNoUbic.CodPed ~
LogHpkNoUbic.NroPed LogHpkNoUbic.CodRef LogHpkNoUbic.NroRef ~
LogHpkNoUbic.Picador LogHpkNoUbic.NomPicador LogHpkNoUbic.CodMat ~
Almmmatg.DesMat Almmmatg.DesMar LogHpkNoUbic.CanPed LogHpkNoUbic.UndVta ~
LogHpkNoUbic.AlmDes LogHpkNoUbic.CodZona LogHpkNoUbic.CodUbi ~
LogHpkNoUbic.Fecha LogHpkNoUbic.Hora LogHpkNoUbic.Usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH LogHpkNoUbic ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST Almmmatg OF LogHpkNoUbic OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH LogHpkNoUbic ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST Almmmatg OF LogHpkNoUbic OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 LogHpkNoUbic Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 LogHpkNoUbic
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 FILL-IN_FchIni FILL-IN_FchFin ~
BUTTON-2 BUTTON_Filtrar FILL-IN_CodMat BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_FchIni FILL-IN_FchFin ~
FILL-IN_CodMat FILL-IN_DesMat 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\new.ico":U
     LABEL "A TEXTO" 
     SIZE 6 BY 1.73 TOOLTIP "A TEXTO".

DEFINE BUTTON BUTTON_Filtrar 
     LABEL "FILTRAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN_CodMat AS CHARACTER FORMAT "X(15)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 76 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchFin AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchIni AS DATE FORMAT "99/99/9999":U 
     LABEL "Pickeados desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 187 BY 2.96.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      LogHpkNoUbic, 
      Almmmatg
    FIELDS(Almmmatg.DesMat
      Almmmatg.DesMar) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      LogHpkNoUbic.CodPed COLUMN-LABEL "Doc" FORMAT "x(3)":U WIDTH 5.43
      LogHpkNoUbic.NroPed COLUMN-LABEL "Numero" FORMAT "X(15)":U
            WIDTH 12.43
      LogHpkNoUbic.CodRef COLUMN-LABEL "Ref" FORMAT "x(3)":U WIDTH 5.43
      LogHpkNoUbic.NroRef COLUMN-LABEL "Numero" FORMAT "X(15)":U
            WIDTH 12.43
      LogHpkNoUbic.Picador FORMAT "x(12)":U WIDTH 10.43
      LogHpkNoUbic.NomPicador FORMAT "x(30)":U
      LogHpkNoUbic.CodMat COLUMN-LABEL "Artículo" FORMAT "X(6)":U
            WIDTH 8.86
      Almmmatg.DesMat FORMAT "X(45)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U
      LogHpkNoUbic.CanPed FORMAT "->>>,>>9.9999":U
      LogHpkNoUbic.UndVta FORMAT "x(6)":U
      LogHpkNoUbic.AlmDes COLUMN-LABEL "Almacén" FORMAT "x(5)":U
      LogHpkNoUbic.CodZona COLUMN-LABEL "Zona" FORMAT "x(8)":U
      LogHpkNoUbic.CodUbi FORMAT "x(10)":U
      LogHpkNoUbic.Fecha FORMAT "99/99/9999":U
      LogHpkNoUbic.Hora FORMAT "x(8)":U
      LogHpkNoUbic.Usuario FORMAT "x(15)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 187 BY 22.62 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN_FchIni AT ROW 1.54 COL 29 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_FchFin AT ROW 1.54 COL 51 COLON-ALIGNED WIDGET-ID 4
     BUTTON-2 AT ROW 1.54 COL 151 WIDGET-ID 14
     BUTTON_Filtrar AT ROW 1.81 COL 131 WIDGET-ID 12
     FILL-IN_CodMat AT ROW 2.62 COL 29 COLON-ALIGNED WIDGET-ID 6
     FILL-IN_DesMat AT ROW 2.62 COL 44 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BROWSE-2 AT ROW 3.96 COL 3 WIDGET-ID 200
     RECT-1 AT ROW 1 COL 3 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 191.29 BY 25.73 WIDGET-ID 100.


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
         TITLE              = "CONSULTA DE ARTICULOS DE HPK NO UBICADOS AL PICKEAR"
         HEIGHT             = 25.73
         WIDTH              = 191.29
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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
/* BROWSE-TAB BROWSE-2 FILL-IN_DesMat F-Main */
ASSIGN 
       BROWSE-2:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 8.

/* SETTINGS FOR FILL-IN FILL-IN_DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.LogHpkNoUbic,INTEGRAL.Almmmatg OF INTEGRAL.LogHpkNoUbic"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER USED"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.LogHpkNoUbic.CodPed
"LogHpkNoUbic.CodPed" "Doc" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.LogHpkNoUbic.NroPed
"LogHpkNoUbic.NroPed" "Numero" "X(15)" "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.LogHpkNoUbic.CodRef
"LogHpkNoUbic.CodRef" "Ref" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.LogHpkNoUbic.NroRef
"LogHpkNoUbic.NroRef" "Numero" ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.LogHpkNoUbic.Picador
"LogHpkNoUbic.Picador" ? "x(12)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.LogHpkNoUbic.NomPicador
"LogHpkNoUbic.NomPicador" ? "x(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.LogHpkNoUbic.CodMat
"LogHpkNoUbic.CodMat" "Artículo" ? "character" ? ? ? ? ? ? no ? no no "8.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[9]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   = INTEGRAL.LogHpkNoUbic.CanPed
     _FldNameList[11]   > INTEGRAL.LogHpkNoUbic.UndVta
"LogHpkNoUbic.UndVta" ? "x(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.LogHpkNoUbic.AlmDes
"LogHpkNoUbic.AlmDes" "Almacén" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.LogHpkNoUbic.CodZona
"LogHpkNoUbic.CodZona" "Zona" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   = INTEGRAL.LogHpkNoUbic.CodUbi
     _FldNameList[15]   = INTEGRAL.LogHpkNoUbic.Fecha
     _FldNameList[16]   = INTEGRAL.LogHpkNoUbic.Hora
     _FldNameList[17]   = INTEGRAL.LogHpkNoUbic.Usuario
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSULTA DE ARTICULOS DE HPK NO UBICADOS AL PICKEAR */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA DE ARTICULOS DE HPK NO UBICADOS AL PICKEAR */
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


&Scoped-define SELF-NAME BUTTON_Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Filtrar W-Win
ON CHOOSE OF BUTTON_Filtrar IN FRAME F-Main /* FILTRAR */
DO:
  ASSIGN FILL-IN_CodMat FILL-IN_DesMat FILL-IN_FchFin FILL-IN_FchIni.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodMat W-Win
ON LEAVE OF FILL-IN_CodMat IN FRAME F-Main /* Artículo */
DO:
    DEF VAR pCodMat AS CHAR NO-UNDO.

    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto.r (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN DO:
        ASSIGN SELF:SCREEN-VALUE = "".
        RETURN.
    END.
    SELF:SCREEN-VALUE = pCodMat.
    FILL-IN_DesMat:SCREEN-VALUE = ''.
    FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK.
    IF AVAILABLE Almmmatg THEN FILL-IN_DesMat:SCREEN-VALUE = Almmmatg.desmat.
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
  DISPLAY FILL-IN_FchIni FILL-IN_FchFin FILL-IN_CodMat FILL-IN_DesMat 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 FILL-IN_FchIni FILL-IN_FchFin BUTTON-2 BUTTON_Filtrar 
         FILL-IN_CodMat BROWSE-2 
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
  FILL-IN_FchIni = TODAY.
   FILL-IN_FchFin = TODAY.

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
  {src/adm/template/snd-list.i "LogHpkNoUbic"}
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
    FOR EACH LogHpkNoUbic WHERE {&Condicion} NO-LOCK:
        CREATE Reporte.
        BUFFER-COPY LogHpkNoUbic TO Reporte.
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

