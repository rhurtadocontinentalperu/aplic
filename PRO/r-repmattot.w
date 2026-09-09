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

DEFINE TEMP-TABLE tt-datos 
    FIELDS t-codmat LIKE almmmatg.codmat
    FIELDS t-desmat LIKE almmmatg.desmat
    FIELDS t-desmar LIKE almmmatg.desmar
    FIELDS t-codund LIKE PR-LIQD1.CodUnd
    FIELDS t-candes LIKE PR-LIQD1.CanDes
    FIELDS t-imptot LIKE PR-LIQD1.ImpTot.

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
&Scoped-Define ENABLED-OBJECTS RECT-27 dDesde dHasta tg-resumen BUTTON-7 ~
BUTTON-8 
&Scoped-Define DISPLAYED-OBJECTS dDesde dHasta tg-resumen x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-7 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 7" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Button 8" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE dDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE dHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY .88
     BGCOLOR 1 FGCOLOR 15 FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 7.

DEFINE VARIABLE tg-resumen AS LOGICAL INITIAL no 
     LABEL "Resumido por Material" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     dDesde AT ROW 2.08 COL 12 COLON-ALIGNED WIDGET-ID 2
     dHasta AT ROW 2.08 COL 37 COLON-ALIGNED WIDGET-ID 4
     tg-resumen AT ROW 3.69 COL 14 WIDGET-ID 14
     x-mensaje AT ROW 5.04 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     BUTTON-7 AT ROW 6.19 COL 31 WIDGET-ID 6
     BUTTON-8 AT ROW 6.19 COL 47 WIDGET-ID 8
     RECT-27 AT ROW 1.27 COL 2 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 63 BY 7.5 WIDGET-ID 100.


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
         TITLE              = "Materiales Utilizados por Liquidacion"
         HEIGHT             = 7.5
         WIDTH              = 63
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Materiales Utilizados por Liquidacion */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Materiales Utilizados por Liquidacion */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Button 7 */
DO:
    ASSIGN dDesde dHasta tg-resumen.
    IF tg-resumen THEN RUN Excel-Resumen.
    ELSE RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Button 8 */
DO:
      RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ON 'return':U OF dDesde, dHasta
DO:
    APPLY 'tab':U.
    RETURN NO-APPLY.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Data W-Win 
PROCEDURE Carga-Data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FOR EACH tt-datos:
        DELETE tt-datos.
    END.

    FOR EACH PR-LIQC WHERE PR-LIQC.CodCia = s-codcia
        AND PR-LIQC.FecIni >= dDesde
        AND PR-LIQC.FecFin <= dHasta NO-LOCK,
        EACH PR-LIQD1 OF PR-LIQC NO-LOCK,
        FIRST almmmatg OF PR-LIQD1 NO-LOCK:

        FIND FIRST tt-datos WHERE t-codmat = PR-LIQD1.CodMat NO-ERROR.
        IF NOT AVAIL tt-datos THEN DO:
            CREATE tt-datos.
            ASSIGN 
                t-codmat = PR-LIQD1.CodMat
                t-desmat = almmmatg.desmat
                t-desmar = almmmatg.desmar
                t-codund = PR-LIQD1.CodUnd.
        END.
        t-candes = t-candes + PR-LIQD1.CanDes.
        t-imptot = t-imptot + PR-LIQD1.ImpTot.

        DISPLAY "PROCESANDO: " + almmmatg.desmat @ x-mensaje 
            WITH FRAME {&FRAME-NAME}.

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
  DISPLAY dDesde dHasta tg-resumen x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-27 dDesde dHasta tg-resumen BUTTON-7 BUTTON-8 
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

DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
cColumn = STRING(iCount).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "REPORTE DE MATERIAL CONSUMIDO EN PRODUCCION".
iCount = iCount + 1.
cColumn = STRING(iCount).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Nº LIQUIDACION".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "FECHA INI".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "FECHA FIN".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "CODMAT".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "DESCRIPCION".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "MARCA".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "UNIDAD".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "CANTIDAD".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "IMPORTE".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "PRECIO UNIT".

chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("D"):NumberFormat = "@".
chWorkSheet:Range("A1:K2"):Font:Bold = TRUE.

FOR EACH PR-LIQC WHERE PR-LIQC.CodCia = s-codcia
    AND PR-LIQC.FecIni >= dDesde
    AND PR-LIQC.FecFin <= dHasta NO-LOCK,
    EACH PR-LIQD1 OF PR-LIQC NO-LOCK,
    FIRST almmmatg OF PR-LIQD1 NO-LOCK:

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = PR-LIQC.Numliq.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = PR-LIQC.FecIni.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = PR-LIQC.FecFin.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = PR-LIQD1.codmat.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.DesMat.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.DesMar.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = PR-LIQD1.CodUnd.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = PR-LIQD1.CanDes.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = PR-LIQD1.ImpTot.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = PR-LIQD1.PreUni.

    DISPLAY "PROCESANDO: " + almmmatg.desmat @ x-mensaje 
        WITH FRAME {&FRAME-NAME}.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

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

DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

RUN Carga-Data.

/* set the column names for the Worksheet */
cColumn = STRING(iCount).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "REPORTE DE MATERIAL CONSUMIDO EN PRODUCCION".
iCount = iCount + 1.
cColumn = STRING(iCount).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "CODMAT".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "DESCRIPCION".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "MARCA".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "UNIDAD".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "CANTIDAD".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "IMPORTE".

chWorkSheet:Columns("A"):NumberFormat = "@".

chWorkSheet:Range("A1:K2"):Font:Bold = TRUE.

FOR EACH tt-datos:
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = t-codmat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = t-desmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = t-desmar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = t-codund.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = t-candes.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = t-imptot.

    DISPLAY "PROCESANDO: " + t-desmat @ x-mensaje 
        WITH FRAME {&FRAME-NAME}.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

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
      ASSIGN 
          dHasta = TODAY
          dDesde = (TODAY - DAY(TODAY) + 1).
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

