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

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF STREAM REPORTE.

DEF TEMP-TABLE detalle
    FIELD linea AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS rs-flgest BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS rs-flgest FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 10 BY 1.88.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 2" 
     SIZE 10 BY 1.88.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE rs-flgest AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Activos", "A",
"Desactivados", "D",
"Ambos", ""
     SIZE 22 BY 3 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     rs-flgest AT ROW 1.81 COL 7 NO-LABEL WIDGET-ID 2
     BUTTON-1 AT ROW 2.35 COL 53 WIDGET-ID 6
     BUTTON-2 AT ROW 2.35 COL 64 WIDGET-ID 8
     FILL-IN-Mensaje AT ROW 6.12 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.29 BY 6.88 WIDGET-ID 100.


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
         TITLE              = "Articulos con Stock Consolidado"
         HEIGHT             = 6.88
         WIDTH              = 80.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80.29
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80.29
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
ON END-ERROR OF W-Win /* Articulos con Stock Consolidado */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Articulos con Stock Consolidado */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN rs-flgest.
    RUN Excel.
         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
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
  DISPLAY rs-flgest FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE rs-flgest BUTTON-1 BUTTON-2 
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
DEF VAR x-stkact    AS DEC NO-UNDO.
DEF VAR x-stkcol    AS DEC NO-UNDO.
DEF VAR x-linea     AS CHAR NO-UNDO.
DEF VAR x-almacenes AS CHAR NO-UNDO.
DEF VAR x-Titulo    AS CHAR NO-UNDO.
DEF VAR x-Titulo2   AS CHAR NO-UNDO.
DEF VAR j           AS INT NO-UNDO.
DEF VAR sw          AS LOG NO-UNDO.
DEF VAR x-Archivo   AS CHAR NO-UNDO.
DEF VAR x-CodFam    AS CHAR NO-UNDO.

DEF VAR cDesFam     AS CHAR NO-UNDO.
DEF VAR cDesSub     AS CHAR NO-UNDO.
DEF VAR cProve01    AS CHAR NO-UNDO.
DEF VAR cProve02    AS CHAR NO-UNDO.
DEF VAR iint        AS INT  NO-UNDO.
DEF VAR fching      AS DATE NO-UNDO.

EMPTY TEMP-TABLE detalle.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).

x-Titulo = 'Codigo|Descripcion|Marca|Familia|Subfamilia|Unidad|Proveedor01|Proveedor02|FechaIngreso|Stock'.
x-Almacenes = ''.
iint = 0.
FOR EACH almmmatg NO-LOCK WHERE codcia = s-codcia AND TpoArt BEGINS rs-flgest:
    ASSIGN 
        x-stkact = 0
        sw       = NO
        iint     = iint + 1.

    FOR EACH almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codmat = Almmmatg.codmat:
        x-stkact = x-stkact + almmmate.stkact.        
    END.
    
    FIND FIRST almtfam WHERE almtfam.codcia = s-codcia
        AND almtfam.codfam = almmmatg.codfam NO-LOCK NO-ERROR.
    IF AVAIL almtfam THEN cDesFam = almtfam.desfam.
    ELSE cDesFam = ''.

    FIND FIRST almsfam WHERE almsfam.codcia = s-codcia
        AND almsfam.codfam = almmmatg.codfam 
        AND almsfam.subfam = almmmatg.subfam NO-LOCK NO-ERROR.
    IF AVAIL almsfam THEN cDesSub = almsfam.dessub.
    ELSE cDesSub = ''.

    FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = almmmatg.codpr1 NO-LOCK NO-ERROR.
    IF AVAIL gn-prov THEN cProve01 = gn-prov.codpro + '-' + gn-prov.nompro.
    ELSE cProve01 = ''.

    FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = almmmatg.codpr2 NO-LOCK NO-ERROR.
    IF AVAIL gn-prov THEN cProve02 = gn-prov.codpro + '-' + gn-prov.nompro.
    ELSE cProve02 = ''.

    IF almmmatg.FchIng = ? THEN FchIng = 01/01/2001.
    ELSE FchIng = almmmatg.FchIng.

    
    x-linea = STRING(almmmatg.codmat,'999999') + '|' +
        almmmatg.desmat + '|' +
        almmmatg.desmar + '|' +
        cDesFam + '|' +
        cDesSub + '|' +
        almmmatg.undstk + '|' + 
        cProve01 + '|' + 
        cProve02 + '|' + 
        STRING(FchIng,'99/99/9999') + '|' + 
        STRING(x-stkact,'->>>>>9.99').

    CREATE detalle.
    detalle.linea = x-linea.
END.
x-Titulo = REPLACE(x-Titulo, '|', CHR(9)).
PUT STREAM REPORTE x-Titulo FORMAT 'x(600)' SKIP.
FOR EACH detalle:
    x-linea = TRIM(detalle.linea).
/*     DO j = 1 TO NUM-ENTRIES(x-Almacenes, '|'):                                  */
/*         x-linea = x-linea + STRING(detalle.stkact[j], '>>>>>9.99') + '|' +      */
/*             STRING(detalle.ultmov[j], 'x(5)') + '|'.                            */
/*         IF detalle.fchmov[j] = ?                                                */
/*         THEN x-linea = x-linea + " " + '|'.                                     */
/*         ELSE x-linea = x-linea + STRING(detalle.fchmov[j], '99/99/9999') + '|'. */
/*         x-linea = x-linea + STRING(detalle.ctopro[j], '->>>>>>9.99') + '|'.     */
/*     END.                                                                        */
    x-linea = REPLACE(x-linea, '|', CHR(9)).
    PUT STREAM REPORTE x-linea FORMAT 'x(600)' SKIP.
END.
OUTPUT STREAM REPORTE CLOSE.
/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Detallado', YES).
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

