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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.

DEFINE TEMP-TABLE tt-detalle LIKE facdpedi
    FIELDS nomcli   AS CHAR
    FIELDS dircli01 AS CHAR
    FIELDS dircli02 AS CHAR
    FIELDS talmdes  AS CHAR.

DEFINE TEMP-TABLE tt-resumen LIKE faccpedi.

/*Variables Excel*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 3.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Divi txt-desde txt-hasta ~
RADIO-SET-1 BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Divi txt-desde txt-hasta ~
RADIO-SET-1 txt-mensaje 

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
     SIZE 8 BY 1.62.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 2" 
     SIZE 8 BY 1.62.

DEFINE VARIABLE COMBO-BOX-Divi AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 62 BY .92
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE txt-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Resumido", 1,
"Detalle", 2
     SIZE 23 BY 1.88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Divi AT ROW 2.08 COL 12 COLON-ALIGNED WIDGET-ID 2
     txt-desde AT ROW 3.15 COL 12 COLON-ALIGNED WIDGET-ID 6
     txt-hasta AT ROW 3.15 COL 39 COLON-ALIGNED WIDGET-ID 8
     RADIO-SET-1 AT ROW 4.5 COL 15 NO-LABEL WIDGET-ID 10
     BUTTON-1 AT ROW 6.38 COL 56 WIDGET-ID 14
     BUTTON-2 AT ROW 6.38 COL 65 WIDGET-ID 16
     txt-mensaje AT ROW 6.65 COL 2 NO-LABEL WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.43 BY 7.88 WIDGET-ID 100.


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
         TITLE              = "Reporte de Pedidos por Division"
         HEIGHT             = 7.88
         WIDTH              = 80.43
         MAX-HEIGHT         = 7.88
         MAX-WIDTH          = 80.43
         VIRTUAL-HEIGHT     = 7.88
         VIRTUAL-WIDTH      = 80.43
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
/* SETTINGS FOR FILL-IN txt-mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de Pedidos por Division */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Pedidos por Division */
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
    ASSIGN
        combo-box-divi
        txt-desde
        txt-hasta
        txt-mensaje
        radio-set-1.
    RUN Carga-Temporal.
    DISPLAY 'GENERANDO EXCEL...' @ txt-mensaje WITH FRAME {&FRAME-NAME}.
    CASE RADIO-SET-1:
        WHEN 1 THEN RUN Excel-Resumen.
        WHEN 2 THEN RUN Excel-Detalle.
    END CASE.
    DISPLAY 'REPORTE TERMINADO' @ txt-mensaje WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-resumen:
        DELETE tt-resumen.
    END.

    FOR EACH tt-detalle:
        DELETE tt-detalle.
    END.

    IF RADIO-SET-1 = 2 THEN DO:
        FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia
            AND faccpedi.coddiv = ENTRY(1,combo-box-divi,"-")
            AND faccpedi.coddoc = 'PED'
            AND faccpedi.flgest = 'P' NO-LOCK,
            EACH facdpedi OF faccpedi NO-LOCK:
            CREATE tt-detalle.
            BUFFER-COPY facdpedi TO tt-detalle
                ASSIGN 
                    tt-detalle.nomcli   = faccpedi.nomcli
                    tt-detalle.dircli01 = faccpedi.dircli
                    tt-detalle.dircli02 = faccpedi.libre_c03
                    tt-detalle.talmdes  = faccpedi.codalm.
            DISPLAY 'CARGANDO INFORMACION: ' + facdpedi.codmat @ txt-mensaje
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    ELSE DO:
        FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia
            AND faccpedi.coddiv = ENTRY(1,combo-box-divi,"-")
            AND faccpedi.coddoc = 'PED'
            AND faccpedi.flgest = 'P' NO-LOCK:
            CREATE tt-resumen.
            BUFFER-COPY faccpedi TO tt-resumen.
            DISPLAY 'CARGANDO INFORMACION: ' + faccpedi.nroped @ txt-mensaje
                WITH FRAME {&FRAME-NAME}.
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
  DISPLAY COMBO-BOX-Divi txt-desde txt-hasta RADIO-SET-1 txt-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Divi txt-desde txt-hasta RADIO-SET-1 BUTTON-1 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-Detalle W-Win 
PROCEDURE Excel-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A1: K2"):FONT:Bold = TRUE.
chWorkSheet:Range("A1"):VALUE =
    "DETALLE DE PEDIDOS PENDIENTES" +
    " DESDE " + STRING(txt-desde) + " AL " + STRING(txt-hasta).
chWorkSheet:Range("A3"):VALUE = "Division".
chWorkSheet:Range("B3"):VALUE = "Almacen".
chWorkSheet:Range("C3"):VALUE = "CodCli".
chWorkSheet:Range("D3"):VALUE = "Cliente".
chWorkSheet:Range("E3"):VALUE = "Direccion Cliente".
chWorkSheet:Range("F3"):VALUE = "Lugar de Entrega".
chWorkSheet:Range("G3"):VALUE = "Codigo".
chWorkSheet:Range("H3"):VALUE = "Descripcion".
chWorkSheet:Range("I3"):VALUE = "Marca".
chWorkSheet:Range("J3"):VALUE = "Cantidad".

chWorkSheet:COLUMNS("C"):NumberFormat = "@".
chWorkSheet:COLUMNS("G"):NumberFormat = "@".
t-column = 3.

FOR EACH tt-detalle NO-LOCK,
    FIRST almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.codmat = tt-detalle.codmat
        BREAK BY tt-detalle.talmdes:
    FIND FIRST almacen WHERE almacen.codcia = s-codcia
        AND almacen.codalm = tt-detalle.talmdes NO-LOCK NO-ERROR.
    t-column = t-column + 1.
    cColumn = STRING(t-Column).      
    cRange = "A" + cColumn.   
    chWorkSheet:Range(cRange):Value = combo-box-divi.
    cRange = "B" + cColumn.   
    IF AVAIL almacen THEN
    chWorkSheet:Range(cRange):Value = tt-detalle.talmdes + "-" + almacen.descripcion.
    ELSE chWorkSheet:Range(cRange):Value = tt-detalle.talmdes.
    cRange = "C" + cColumn.   
    chWorkSheet:Range(cRange):Value = tt-detalle.codcli.
    cRange = "D" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = tt-detalle.nomcli.                      
    cRange = "E" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = tt-detalle.dircli01.   
    cRange = "F" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = tt-detalle.dircli02.                      
    cRange = "G" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = tt-detalle.codmat. 
    cRange = "H" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = almmmatg.desmat. 
    cRange = "I" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = almmmatg.desmar. 
    cRange = "J" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = tt-detalle.canped.
    IF t-column > 65000 THEN DO:
        MESSAGE 'Documento excede el tamaño' SKIP
                ' Reducir rango de fechas  '
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-Resumen W-Win 
PROCEDURE Excel-Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A1: K2"):FONT:Bold = TRUE.
chWorkSheet:Range("A1"):VALUE =
    "DETALLE DE PEDIDOS PENDIENTES" +
    " DESDE " + STRING(txt-desde) + " AL " + STRING(txt-hasta).
chWorkSheet:Range("A3"):VALUE = "Division".
chWorkSheet:Range("B3"):VALUE = "Almacen".
chWorkSheet:Range("C3"):VALUE = "CodCli".
chWorkSheet:Range("D3"):VALUE = "Cliente".
chWorkSheet:Range("E3"):VALUE = "Direccion Cliente".
chWorkSheet:Range("F3"):VALUE = "Lugar de Entrega".
chWorkSheet:Range("G3"):VALUE = "Nro Pedido".
chWorkSheet:Range("H3"):VALUE = "Importe".

chWorkSheet:COLUMNS("C"):NumberFormat = "@".
chWorkSheet:COLUMNS("G"):NumberFormat = "@".
t-column = 3.

FOR EACH tt-resumen NO-LOCK
    BREAK BY tt-resumen.codalm:
    FIND FIRST almacen WHERE almacen.codcia = s-codcia
        AND almacen.codalm = tt-resumen.codalm NO-LOCK NO-ERROR.
    t-column = t-column + 1.
    cColumn = STRING(t-Column).      
    cRange = "A" + cColumn.   
    chWorkSheet:Range(cRange):Value = combo-box-divi.
    cRange = "B" + cColumn.   
    IF AVAIL almacen THEN
    chWorkSheet:Range(cRange):Value = tt-resumen.codalm + "-" + almacen.descripcion.
    ELSE chWorkSheet:Range(cRange):Value = tt-resumen.codalm.
    cRange = "C" + cColumn.   
    chWorkSheet:Range(cRange):Value = tt-resumen.codcli.
    cRange = "D" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = tt-resumen.nomcli.                      
    cRange = "E" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = tt-resumen.dircli.   
    cRange = "F" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = tt-resumen.Libre_c03.                      
    cRange = "G" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = tt-resumen.nroped.
    cRange = "H" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = tt-resumen.imptot.
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
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
          combo-box-divi:ADD-LAST(gn-divi.coddiv + "-" + gn-divi.desdiv ).          
      END.
      FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
          AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
      IF AVAIL gn-divi THEN ASSIGN combo-box-divi = s-coddiv + "-" + gn-divi.desdiv.
  END.

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

