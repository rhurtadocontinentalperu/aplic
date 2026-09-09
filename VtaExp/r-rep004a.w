&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
DEF SHARED VAR s-coddiv AS CHAR.

DEF TEMP-TABLE detalle
    FIELD codcia AS INT
    FIELD codmat LIKE almmmatg.codmat
    FIELD semana AS CHAR
    FIELD canped LIKE facdpedi.canped
    FIELD periodo AS INT
    FIELD nrosem AS INT
    INDEX llave01 AS PRIMARY codcia codmat periodo nrosem.

DEF BUFFER b-detalle FOR detalle.

DEF STREAM REPORTE.
DEF VAR x-Periodo-1 AS INT NO-UNDO.
DEF VAR x-Periodo-2 AS INT NO-UNDO.
DEF VAR x-Semana-1 AS INT NO-UNDO.
DEF VAR x-Semana-2 AS INT NO-UNDO.
DEF VAR x-Semana AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 BUTTON-2 COMBO-BOX-Periodo-1 ~
COMBO-BOX-Semana-1 BtnDone COMBO-BOX-Periodo-2 COMBO-BOX-Semana-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo-1 COMBO-BOX-Semana-1 ~
COMBO-BOX-Periodo-2 COMBO-BOX-Semana-2 FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Salir" 
     SIZE 8 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 8 BY 1.62.

DEFINE VARIABLE COMBO-BOX-Periodo-1 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Desde el Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo-2 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Hasta el Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Semana-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Semana" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Semana-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Semana" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 4.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-2 AT ROW 1.81 COL 75 WIDGET-ID 14
     COMBO-BOX-Periodo-1 AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-Semana-1 AT ROW 2.62 COL 39 COLON-ALIGNED WIDGET-ID 4
     BtnDone AT ROW 3.42 COL 75 WIDGET-ID 12
     COMBO-BOX-Periodo-2 AT ROW 4.23 COL 19 COLON-ALIGNED WIDGET-ID 6
     COMBO-BOX-Semana-2 AT ROW 4.23 COL 39 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-Mensaje AT ROW 6.12 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     "Seleccione los rangos de despacho a proyectar" VIEW-AS TEXT
          SIZE 43 BY .62 AT ROW 1.54 COL 10 WIDGET-ID 16
          BGCOLOR 7 FGCOLOR 15 
     RECT-1 AT ROW 1.81 COL 4 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.72 BY 6.46 WIDGET-ID 100.


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
         TITLE              = "REPORTE DE PROYECCION DE DESPACHOS POR SEMANAS"
         HEIGHT             = 6.46
         WIDTH              = 83.72
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 87.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 87.14
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
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE PROYECCION DE DESPACHOS POR SEMANAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE PROYECCION DE DESPACHOS POR SEMANAS */
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
ON CHOOSE OF BtnDone IN FRAME F-Main /* Salir */
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


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    IF COMBO-BOX-Semana-1 = '' OR COMBO-BOX-Semana-2 = '' THEN DO:
        MESSAGE 'Seleccione las semanas' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Periodo-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Periodo-1 W-Win
ON VALUE-CHANGED OF COMBO-BOX-Periodo-1 IN FRAME F-Main /* Desde el Periodo */
DO:
  ASSIGN {&self-name}.
  DEF VAR x-Lista AS CHAR NO-UNDO.
  x-Lista = ''.
  FOR EACH evtsemana NO-LOCK WHERE codcia = 1 AND periodo = {&self-name}:
      x-Semana = 'Del ' + STRING(EvtSemanas.FecIni, '99/99/9999') +
        ' al ' + STRING(EvtSemanas.FecFin, '99/99/9999').
      IF x-Lista = '' THEN x-Lista = x-Semana.
      ELSE x-Lista = x-Lista + ',' + x-Semana.
      COMBO-BOX-Semana-1:LIST-ITEMS = x-Lista.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Periodo-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Periodo-2 W-Win
ON VALUE-CHANGED OF COMBO-BOX-Periodo-2 IN FRAME F-Main /* Hasta el Periodo */
DO:
    ASSIGN {&self-name}.
    DEF VAR x-Lista AS CHAR NO-UNDO.
    x-Lista = ''.
    FOR EACH evtsemana NO-LOCK WHERE codcia = 1 AND periodo = {&self-name}:
        x-Semana = 'Del ' + STRING(EvtSemanas.FecIni, '99/99/9999') +
          ' al ' + STRING(EvtSemanas.FecFin, '99/99/9999').
        IF x-Lista = '' THEN x-Lista = x-Semana.
        ELSE x-Lista = x-Lista + ',' + x-Semana.
        COMBO-BOX-Semana-2:LIST-ITEMS = x-Lista.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Semana-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Semana-1 W-Win
ON VALUE-CHANGED OF COMBO-BOX-Semana-1 IN FRAME F-Main /* Semana */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Semana-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Semana-2 W-Win
ON VALUE-CHANGED OF COMBO-BOX-Semana-2 IN FRAME F-Main /* Semana */
DO:
    ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN
    x-Periodo-1 = INT(COMBO-BOX-Periodo-1)
    x-Periodo-2 = INT(COMBO-BOX-Periodo-2)
    x-Semana-1 = LOOKUP (COMBO-BOX-Semana-1, COMBO-BOX-Semana-1:LIST-ITEMS IN FRAME {&FRAME-NAME}) 
    x-Semana-2 = LOOKUP (COMBO-BOX-Semana-2, COMBO-BOX-Semana-2:LIST-ITEMS IN FRAME {&FRAME-NAME}) .

FOR EACH detalle:
    DELETE detalle.
END.
FOR EACH EvtSemanas NO-LOCK WHERE EvtSemanas.codcia = s-codcia
    AND Evtsemanas.periodo >= x-Periodo-1
    AND Evtsemanas.periodo <= x-Periodo-2:
    IF Evtsemanas.Periodo = x-Periodo-1 
        AND EvtSemanas.NroSem < x-Semana-1 THEN NEXT.
    IF Evtsemanas.Periodo = x-Periodo-2
        AND EvtSemanas.NroSem > x-Semana-2 THEN NEXT.
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** PROCESANDO " +
        "PERIODO " + STRING(evtsemanas.periodo, '9999') +
        " SEMANA " + STRING(evtsemanas.nrosem, '99').
    FOR EACH faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia
        AND faccpedi.coddiv = s-coddiv
        AND faccpedi.coddoc = "COT"
        AND faccpedi.fchent >= EvtSemanas.FecIni
        AND faccpedi.fchent <= EvtSemanas.FecFin
        AND faccpedi.flgest = 'P',
        EACH facdpedi OF faccpedi NO-LOCK WHERE facdpedi.canped > facdpedi.canate:
        FIND detalle WHERE detalle.codcia = s-codcia
            AND detalle.codmat = facdpedi.codmat
            AND detalle.periodo = Evtsemanas.periodo
            AND detalle.nrosem = Evtsemanas.nrosem
            NO-ERROR.
        IF NOT AVAILABLE detalle THEN DO:
            CREATE detalle.
            ASSIGN
                detalle.codcia = s-codcia
                detalle.codmat = facdpedi.codmat
                detalle.periodo = evtsemanas.periodo
                detalle.nrosem = evtsemanas.nrosem.
        END.
        detalle.canped = detalle.canped + (facdpedi.canped - facdpedi.canate).
    END.
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
  DISPLAY COMBO-BOX-Periodo-1 COMBO-BOX-Semana-1 COMBO-BOX-Periodo-2 
          COMBO-BOX-Semana-2 FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 BUTTON-2 COMBO-BOX-Periodo-1 COMBO-BOX-Semana-1 BtnDone 
         COMBO-BOX-Periodo-2 COMBO-BOX-Semana-2 
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
DEF VAR x-Llave AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Semana AS CHAR NO-UNDO.
DEF VAR x-Almacenes AS CHAR INIT '40b,35' NO-UNDO.
DEF VAR j AS INT NO-UNDO.

RUN Carga-Temporal.
FIND FIRST detalle NO-LOCK NO-ERROR.
IF NOT AVAILABLE detalle THEN DO:
    MESSAGE 'Fin de archivo' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
x-Titulo = 'Producto|Marca|Linea|Sublinea|Unidad|'.
FOR EACH EvtSemanas NO-LOCK WHERE EvtSemanas.codcia = s-codcia
    AND Evtsemanas.periodo >= x-Periodo-1
    AND Evtsemanas.periodo <= x-Periodo-2:
    IF Evtsemanas.Periodo = x-Periodo-1 
        AND EvtSemanas.NroSem < x-Semana-1 THEN NEXT.
    IF Evtsemanas.Periodo = x-Periodo-2
        AND EvtSemanas.NroSem > x-Semana-2 THEN NEXT.
    x-Semana = 'Del ' + STRING(EvtSemanas.FecIni, '99/99/9999') +
        ' al ' + STRING(EvtSemanas.FecFin, '99/99/9999').
    x-Titulo = x-Titulo + TRIM(x-Semana) + '|'.
END.
DO j = 1 TO NUM-ENTRIES(x-Almacenes):
    x-Titulo = x-Titulo + 'Almacen ' + ENTRY(j, x-Almacenes) + '|'.
END.
/* FOR EACH Vtaalmdiv NO-LOCK WHERE VtaAlmDiv.CodCia = s-codcia   */
/*     AND VtaAlmDiv.CodDiv = s-coddiv                            */
/*     BY VtaAlmDiv.Orden:                                        */
/*     x-Titulo = x-Titulo + 'Almacen ' + Vtaalmdiv.codalm + '|'. */
/* END.                                                           */
x-Titulo = REPLACE(x-Titulo, '|', CHR(9) ).
PUT STREAM REPORTE x-Titulo SKIP.
FOR EACH detalle NO-LOCK USE-INDEX Llave01,
    FIRST almmmatg OF detalle NO-LOCK,
    FIRST almtfami OF almmmatg NO-LOCK,
    FIRST almsfami OF almmmatg NO-LOCK
    BREAK BY detalle.codmat:
    IF FIRST-OF(detalle.codmat) THEN DO:
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** RESUMIENDO " + detalle.codmat.
        x-Llave = detalle.codmat + ' ' + almmmatg.desmat + '|' +
            almmmatg.desmar + '|' +
            almmmatg.codfam + ' ' + Almtfami.desfam + '|' +
            almmmatg.subfam + ' ' + AlmSFami.dessub + '|' +
            Almmmatg.UndBas + '|'.
        FOR EACH EvtSemanas NO-LOCK WHERE EvtSemanas.codcia = s-codcia
            AND Evtsemanas.periodo >= x-Periodo-1
            AND Evtsemanas.periodo <= x-Periodo-2:
            IF Evtsemanas.Periodo = x-Periodo-1 
                AND EvtSemanas.NroSem < x-Semana-1 THEN NEXT.
            IF Evtsemanas.Periodo = x-Periodo-2
                AND EvtSemanas.NroSem > x-Semana-2 THEN NEXT.
            FIND b-detalle WHERE b-detalle.codcia = s-codcia
                AND b-detalle.codmat = detalle.codmat
                AND b-detalle.periodo = evtsemanas.periodo
                AND b-detalle.nrosem = evtsemanas.nrosem
                NO-LOCK NO-ERROR.
            IF AVAILABLE b-detalle THEN DO:
                x-Llave = x-LLave + STRING(b-detalle.canped, '>>>,>>>,>>9.99') + '|'.
            END.
            ELSE DO:
                x-Llave = x-LLave + ' ' + '|'.
            END.
        END.
    END.
    IF LAST-OF(detalle.codmat) THEN DO:
        /* stock por almacen */
        DO j = 1 TO NUM-ENTRIES(x-Almacenes):
            FIND Almmmate WHERE Almmmate.codcia = s-codcia
                AND Almmmate.codalm = ENTRY(j, x-Almacenes)
                AND Almmmate.codmat = detalle.codmat
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmate 
            THEN x-Llave = x-LLave + STRING(Almmmate.stkact, '->>>,>>>,>>9.99') + '|'.
            ELSE x-Llave = x-LLave + ' ' + '|'.
        END.
/*         FOR EACH Vtaalmdiv NO-LOCK WHERE VtaAlmDiv.CodCia = s-codcia                   */
/*             AND VtaAlmDiv.CodDiv = s-coddiv                                            */
/*             BY VtaAlmDiv.Orden:                                                        */
/*             FIND Almmmate WHERE Almmmate.codcia = s-codcia                             */
/*                 AND Almmmate.codalm = Vtaalmdiv.codalm                                 */
/*                 AND Almmmate.codmat = detalle.codmat                                   */
/*                 NO-LOCK NO-ERROR.                                                      */
/*             IF AVAILABLE Almmmate                                                      */
/*             THEN x-Llave = x-LLave + STRING(Almmmate.stkact, '->>>,>>>,>>9.99') + '|'. */
/*             ELSE x-Llave = x-LLave + ' ' + '|'.                                        */
/*         END.                                                                           */
        x-Llave = REPLACE ( x-Llave, '|', CHR(9) ).
        PUT STREAM REPORTE x-LLave SKIP.
    END.
END.
OUTPUT STREAM REPORTE CLOSE.

/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Despachos', YES).
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIN DEL PROCESO **".

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DEF VAR x-Lista AS CHAR NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
      x-Lista = ''.
      FOR EACH evtsemanas NO-LOCK WHERE codcia = s-codcia BREAK BY evtsemanas.periodo:
          IF FIRST-OF(evtsemanas.periodo) THEN DO:
              IF x-Lista = '' THEN x-Lista = STRING(evtsemanas.periodo, '9999').
              ELSE x-Lista = x-Lista + ',' + STRING(evtsemanas.periodo, '9999').
          END.
      END.
      COMBO-BOX-Periodo-1:LIST-ITEMS = x-Lista.
      COMBO-BOX-Periodo-2:LIST-ITEMS = x-Lista.
      COMBO-BOX-Periodo-1:SCREEN-VALUE = STRING(YEAR(TODAY), '9999').
      COMBO-BOX-Periodo-2:SCREEN-VALUE = STRING(YEAR(TODAY), '9999').
      APPLY 'VALUE-CHANGED' TO COMBO-BOX-Periodo-1.
      APPLY 'VALUE-CHANGED' TO COMBO-BOX-Periodo-2.
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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

