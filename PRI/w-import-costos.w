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
DEF VAR x-Moneda AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES AlmmmatgExt Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 AlmmmatgExt.CodMat Almmmatg.DesMat ~
AlmmmatgExt.CtoLis AlmmmatgExt.CtoTot ~
(IF AlmmmatgExt.MonCmp = 1 THEN 'Soles' ELSE (IF AlmmmatgExt.MonCmp = 2 THEN 'Dolares' ELSE '???')) @ x-Moneda ~
AlmmmatgExt.TpoCmb AlmmmatgExt.FchActualizacion AlmmmatgExt.TipoLista 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH AlmmmatgExt ~
      WHERE AlmmmatgExt.CodCia = s-codcia ~
 AND AlmmmatgExt.FlagActualizacion = 1 NO-LOCK, ~
      FIRST Almmmatg OF AlmmmatgExt NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH AlmmmatgExt ~
      WHERE AlmmmatgExt.CodCia = s-codcia ~
 AND AlmmmatgExt.FlagActualizacion = 1 NO-LOCK, ~
      FIRST Almmmatg OF AlmmmatgExt NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 AlmmmatgExt Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 AlmmmatgExt
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BROWSE-2 BUTTON-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "CALCULAR" 
     SIZE 27 BY 1.35
     FONT 8.

DEFINE BUTTON BUTTON-2 
     LABEL "ELIMINAR REGISTROS SELECCIONADOS" 
     SIZE 41 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      AlmmmatgExt, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      AlmmmatgExt.CodMat COLUMN-LABEL "Articulo" FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 78.57
      AlmmmatgExt.CtoLis COLUMN-LABEL "Precio Costo!S/IGV" FORMAT "->>>,>>9.9999":U
            WIDTH 17.43
      AlmmmatgExt.CtoTot COLUMN-LABEL "Precio Costo!c/IGV" FORMAT "->>>,>>9.9999":U
            WIDTH 17.43
      (IF AlmmmatgExt.MonCmp = 1 THEN 'Soles' ELSE (IF AlmmmatgExt.MonCmp = 2 THEN 'Dolares' ELSE '???')) @ x-Moneda COLUMN-LABEL "Moneda" FORMAT "x(8)":U
      AlmmmatgExt.TpoCmb FORMAT "Z9.9999":U WIDTH 13.14
      AlmmmatgExt.FchActualizacion COLUMN-LABEL "Fecha de!Control" FORMAT "99/99/9999":U
            WIDTH 11.14
      AlmmmatgExt.TipoLista COLUMN-LABEL "Tipo Lista" FORMAT "x(20)":U
            WIDTH 16.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 176 BY 21.54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1 COL 2 WIDGET-ID 4
     BROWSE-2 AT ROW 2.62 COL 2 WIDGET-ID 200
     BUTTON-2 AT ROW 24.15 COL 2 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 178.72 BY 24.27 WIDGET-ID 100.


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
         TITLE              = "CALCULO COSTO MONEDA"
         HEIGHT             = 24.27
         WIDTH              = 178.72
         MAX-HEIGHT         = 24.27
         MAX-WIDTH          = 178.72
         VIRTUAL-HEIGHT     = 24.27
         VIRTUAL-WIDTH      = 178.72
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
/* BROWSE-TAB BROWSE-2 BUTTON-1 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.AlmmmatgExt,INTEGRAL.Almmmatg OF INTEGRAL.AlmmmatgExt"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _Where[1]         = "AlmmmatgExt.CodCia = s-codcia
 AND AlmmmatgExt.FlagActualizacion = 1"
     _FldNameList[1]   > INTEGRAL.AlmmmatgExt.CodMat
"AlmmmatgExt.CodMat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "78.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.AlmmmatgExt.CtoLis
"AlmmmatgExt.CtoLis" "Precio Costo!S/IGV" ? "decimal" ? ? ? ? ? ? no ? no no "17.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.AlmmmatgExt.CtoTot
"AlmmmatgExt.CtoTot" "Precio Costo!c/IGV" ? "decimal" ? ? ? ? ? ? no ? no no "17.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"(IF AlmmmatgExt.MonCmp = 1 THEN 'Soles' ELSE (IF AlmmmatgExt.MonCmp = 2 THEN 'Dolares' ELSE '???')) @ x-Moneda" "Moneda" "x(8)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.AlmmmatgExt.TpoCmb
"AlmmmatgExt.TpoCmb" ? ? "decimal" ? ? ? ? ? ? no ? no no "13.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.AlmmmatgExt.FchActualizacion
"AlmmmatgExt.FchActualizacion" "Fecha de!Control" ? "date" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.AlmmmatgExt.TipoLista
"AlmmmatgExt.TipoLista" "Tipo Lista" ? "character" ? ? ? ? ? ? no ? no no "16.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CALCULO COSTO MONEDA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CALCULO COSTO MONEDA */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* CALCULAR */
DO:
  RUN Graba-Costos.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* ELIMINAR REGISTROS SELECCIONADOS */
DO:
    RUN Eliminar-Registros.
    {&OPEN-QUERY-{&BROWSE-NAME}}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Eliminar-Registros W-Win 
PROCEDURE Eliminar-Registros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').

DEF VAR x-Item AS INTE NO-UNDO.
DEF BUFFER B-MEXT FOR AlmmmatgExt.

DO x-Item = 1 TO {&browse-name}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&browse-name}:FETCH-SELECTED-ROW(x-Item) THEN DO:
        {lib/lock-genericov3.i ~
            &Tabla="B-MEXT" ~
            &Condicion="ROWID(B-MEXT) = ROWID(AlmmmatgExt)" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &TipoError="UNDO, NEXT" ~
            &Intentos="10"}
        /* Campos donde se guardan los valores originales a la MONEDA DE COMPRA */
        DEF VAR f-PorIgv AS DECI NO-UNDO.
        f-PorIgv = 0.
        IF Almmmatg.CtoLis > 0 THEN f-PorIgv = ( (Almmmatg.CtoTot / Almmmatg.CtoLis) - 1 ) * 100.
        ASSIGN
            B-MEXT.MonCmp = Almmmatg.DsctoProm[1]
            B-MEXT.CtoTot = Almmmatg.DsctoProm[2].
        ASSIGN
            B-MEXT.CtoLis = Almmmatg.DsctoPro[2] / ( 1 + ( f-PorIgv / 100) ).
        ASSIGN
            B-MEXT.FlagActualizacion = 0
            B-MEXT.FchActualizacion = TODAY.
    END.
END.
SESSION:SET-WAIT-STATE('').

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
  ENABLE BUTTON-1 BROWSE-2 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Costos W-Win 
PROCEDURE Graba-Costos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER b-AlmmmatgExt FOR AlmmmatgExt.

SESSION:SET-WAIT-STATE('GENERAL').
GET FIRST {&BROWSE-NAME}.
DO WHILE NOT QUERY-OFF-END('{&BROWSE-NAME}'):
    FIND b-AlmmmatgExt WHERE ROWID(b-AlmmmatgExt) = ROWID(AlmmmatgExt) EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN LEAVE.
    {lib/lock-genericov3.i ~
        &Tabla="Almmmatg" ~
        &Condicion="Almmmatg.codcia = AlmmmatgExt.codcia AND Almmmatg.codmat = AlmmmatgExt.codmat" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO, LEAVE" ~
        &Intentos="10"}
    /* Campos donde se guardan los costos en la MONEDA DE LA LISTA DE PRECIOS */        
    CASE AlmmmatgExt.TipoLista:
        WHEN "COMP-MARCO" THEN DO:
            IF Almmmatg.MonVta = AlmmmatgExt.MonCmp THEN
                ASSIGN
                Almmmatg.CtoLisMarco = AlmmmatgExt.CtoLis
                Almmmatg.CtoTotMarco = AlmmmatgExt.CtoTot.
            ELSE IF Almmmatg.MonVta = 1 THEN
                ASSIGN
                Almmmatg.CtoLisMarco = AlmmmatgExt.CtoLis * Almmmatg.TpoCmb
                Almmmatg.CtoTotMarco = AlmmmatgExt.CtoTot * Almmmatg.TpoCmb.
            ELSE ASSIGN
                Almmmatg.CtoLisMarco = AlmmmatgExt.CtoLis / Almmmatg.TpoCmb
                Almmmatg.CtoTotMarco = AlmmmatgExt.CtoTot / Almmmatg.TpoCmb.
        END.
        OTHERWISE DO:
            IF Almmmatg.MonVta = AlmmmatgExt.MonCmp THEN
                ASSIGN
                Almmmatg.CtoLis = AlmmmatgExt.CtoLis
                Almmmatg.CtoTot = AlmmmatgExt.CtoTot.
            ELSE IF Almmmatg.MonVta = 1 THEN
                ASSIGN
                Almmmatg.CtoLis = AlmmmatgExt.CtoLis * Almmmatg.TpoCmb
                Almmmatg.CtoTot = AlmmmatgExt.CtoTot * Almmmatg.TpoCmb.
            ELSE ASSIGN
                Almmmatg.CtoLis = AlmmmatgExt.CtoLis / Almmmatg.TpoCmb
                Almmmatg.CtoTot = AlmmmatgExt.CtoTot / Almmmatg.TpoCmb.
            /* Campos donde se guardan los valores originales a la MONEDA DE COMPRA */
            ASSIGN
                Almmmatg.DsctoProm[1] = AlmmmatgExt.MonCmp
                Almmmatg.DsctoProm[2] = AlmmmatgExt.CtoTot.
        END.
    END CASE.

    ASSIGN
        b-AlmmmatgExt.FlagActualizacion = 0.

    GET NEXT {&BROWSE-NAME}.
END.
IF AVAILABLE(Almmmatg) THEN RELEASE Almmmatg.

/* FOR EACH AlmmmatgExt EXCLUSIVE-LOCK WHERE AlmmmatgExt.CodCia = s-CodCia                              */
/*     AND AlmmmatgExt.CodMat > ''                                                                      */
/*     AND AlmmmatgExt.FlagActualizacion = 1:                                                           */
/*     {lib/lock-genericov3.i ~                                                                         */
/*         &Tabla="Almmmatg" ~                                                                          */
/*         &Condicion="Almmmatg.codcia = AlmmmatgExt.codcia AND Almmmatg.codmat = AlmmmatgExt.codmat" ~ */
/*         &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~                                                         */
/*         &Accion="RETRY" ~                                                                            */
/*         &Mensaje="NO" ~                                                                              */
/*         &TipoError="UNDO, NEXT" ~                                                                    */
/*         &Intentos="10"}                                                                              */
/*     /* Campos donde se guardan los costos en la MONEDA DE LA LISTA DE PRECIOS */                     */
/*     CASE AlmmmatgExt.TipoLista:                                                                      */
/*         WHEN "COMP-MARCO" THEN DO:                                                                   */
/*             IF Almmmatg.MonVta = AlmmmatgExt.MonCmp THEN                                             */
/*                 ASSIGN                                                                               */
/*                 Almmmatg.CtoLisMarco = AlmmmatgExt.CtoLis                                            */
/*                 Almmmatg.CtoTotMarco = AlmmmatgExt.CtoTot.                                           */
/*             ELSE IF Almmmatg.MonVta = 1 THEN                                                         */
/*                 ASSIGN                                                                               */
/*                 Almmmatg.CtoLisMarco = AlmmmatgExt.CtoLis * Almmmatg.TpoCmb                          */
/*                 Almmmatg.CtoTotMarco = AlmmmatgExt.CtoTot * Almmmatg.TpoCmb.                         */
/*             ELSE ASSIGN                                                                              */
/*                 Almmmatg.CtoLisMarco = AlmmmatgExt.CtoLis / Almmmatg.TpoCmb                          */
/*                 Almmmatg.CtoTotMarco = AlmmmatgExt.CtoTot / Almmmatg.TpoCmb.                         */
/*         END.                                                                                         */
/*         OTHERWISE DO:                                                                                */
/*             IF Almmmatg.MonVta = AlmmmatgExt.MonCmp THEN                                             */
/*                 ASSIGN                                                                               */
/*                 Almmmatg.CtoLis = AlmmmatgExt.CtoLis                                                 */
/*                 Almmmatg.CtoTot = AlmmmatgExt.CtoTot.                                                */
/*             ELSE IF Almmmatg.MonVta = 1 THEN                                                         */
/*                 ASSIGN                                                                               */
/*                 Almmmatg.CtoLis = AlmmmatgExt.CtoLis * Almmmatg.TpoCmb                               */
/*                 Almmmatg.CtoTot = AlmmmatgExt.CtoTot * Almmmatg.TpoCmb.                              */
/*             ELSE ASSIGN                                                                              */
/*                 Almmmatg.CtoLis = AlmmmatgExt.CtoLis / Almmmatg.TpoCmb                               */
/*                 Almmmatg.CtoTot = AlmmmatgExt.CtoTot / Almmmatg.TpoCmb.                              */
/*             /* Campos donde se guardan los valores originales a la MONEDA DE COMPRA */               */
/*             ASSIGN                                                                                   */
/*                 Almmmatg.DsctoProm[1] = AlmmmatgExt.MonCmp                                           */
/*                 Almmmatg.DsctoProm[2] = AlmmmatgExt.CtoTot.                                          */
/*         END.                                                                                         */
/*     END CASE.                                                                                        */
/*     ASSIGN                                                                                           */
/*         AlmmmatgExt.FlagActualizacion = 0.                                                           */
/*     RELEASE Almmmatg.                                                                                */
/* END.                                                                                                 */
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
  {src/adm/template/snd-list.i "AlmmmatgExt"}
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

