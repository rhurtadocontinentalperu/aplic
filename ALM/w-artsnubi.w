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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 btn-Excel-2 Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS x-codalm x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-Excel 
     IMAGE-UP FILE "IMG/excel.bmp":U
     LABEL "Button 1" 
     SIZE 12 BY 1.46.

DEFINE BUTTON btn-Excel-2 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "btn excel 2" 
     SIZE 12 BY 1.46.

DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.46
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE VARIABLE x-codalm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 47 BY 1
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 64.29 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-codalm AT ROW 2.08 COL 12 COLON-ALIGNED WIDGET-ID 30
     BUTTON-1 AT ROW 2.08 COL 62 WIDGET-ID 32
     x-mensaje AT ROW 4.23 COL 3.72 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     btn-Excel-2 AT ROW 5.58 COL 32 WIDGET-ID 38
     btn-Excel AT ROW 5.58 COL 45 WIDGET-ID 20
     Btn_Done AT ROW 5.58 COL 58 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73.29 BY 7.35 WIDGET-ID 100.


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
         TITLE              = "Articulos sin ubicacion"
         HEIGHT             = 7.35
         WIDTH              = 73.29
         MAX-HEIGHT         = 7.35
         MAX-WIDTH          = 73.29
         VIRTUAL-HEIGHT     = 7.35
         VIRTUAL-WIDTH      = 73.29
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

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON btn-Excel IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       btn-Excel:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN x-codalm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Articulos sin ubicacion */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Articulos sin ubicacion */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-Excel W-Win
ON CHOOSE OF btn-Excel IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN x-CodAlm .
    RUN Excel.    
    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-Excel-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-Excel-2 W-Win
ON CHOOSE OF btn-Excel-2 IN FRAME F-Main /* btn excel 2 */
DO:
    ASSIGN x-CodAlm .
    RUN Texto.    
    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Cancelar */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEF VAR x-Almacenes AS CHAR.
    x-Almacenes = x-CodAlm:SCREEN-VALUE.
    RUN alm/d-repalm (INPUT-OUTPUT x-Almacenes).
    x-CodAlm:SCREEN-VALUE = x-Almacenes.
    
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
  DISPLAY x-codalm x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 btn-Excel-2 Btn_Done 
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

    DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
    DEFINE VARIABLE chChart                 AS COM-HANDLE.
    DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
    DEFINE VARIABLE iCount                  AS INTEGER init 1.
    DEFINE VARIABLE iIndex                  AS INTEGER.
    DEFINE VARIABLE cColumn                 AS CHARACTER.
    DEFINE VARIABLE cRange                  AS CHARACTER.
    DEFINE VARIABLE t-Column                AS INTEGER INIT 5.
    DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
    DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.
    
    DEFINE VARIABLE cLisAlm AS CHARACTER   NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.
    
    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().
    
    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).
    
    /*Header del Excel */
    cRange = "C" + '2'.
    chWorkSheet:Range(cRange):Value = "ARTICULOS SIN UBICACION".
    cRange = "F" + '2'.
    chWorkSheet:Range(cRange):Value = TODAY.
    
    /*Formato*/
    chWorkSheet:Columns("A"):NumberFormat = "@".
    chWorkSheet:Columns("B"):NumberFormat = "@".
    
    
    /* set the column names for the Worksheet */
    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Alm".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Código".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descripción".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Marca".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Unidad".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cantidad".

    cLisAlm = x-codalm:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    
    FOR EACH Almmmate WHERE Almmmate.codcia = s-codcia
        AND LOOKUP(TRIM(Almmmate.CodAlm),cLisAlm) > 0
        AND TRIM(Almmmate.CodUbi) = '' 
        AND almmmate.stkact <> 0 NO-LOCK,
        FIRST almmmatg OF almmmate
        WHERE almmmatg.TpoArt = "A" NO-LOCK:
        t-Column = t-Column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = Almmmate.CodAlm.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = Almmmate.codmat.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = almmmatg.desmat.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = almmmatg.desmar.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = almmmatg.undbas.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = almmmate.stkact.

        DISPLAY 'Cargando...' + Almmmate.codmat @ x-mensaje WITH FRAME {&FRAME-NAME}.
    END.
    
    /* launch Excel so it is visible to the user */
     chExcelApplication:Visible = TRUE.

    DISPLAY '' @ x-mensaje WITH FRAME {&FRAME-NAME}.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lRpta AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cArchivo AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cLisAlm AS CHARACTER   NO-UNDO.
    cLisAlm = x-codalm:SCREEN-VALUE IN FRAME {&FRAME-NAME}.


    DEFINE FRAME F-REPORTE
        Almmmate.CodAlm  
        Almmmate.Codubi
        Almmmate.codmat  
        Almmmatg.desmat  
        Almmmatg.desmar  
        Almmmatg.undbas  
        Almmmate.stkact  
        WITH WIDTH 250 NO-BOX STREAM-IO DOWN.
    
    cArchivo = 'Articulos_sin_ubicacion.txt'.
    SYSTEM-DIALOG GET-FILE cArchivo
        FILTERS 'Texto' '*.txt'
        ASK-OVERWRITE
        CREATE-TEST-FILE
        DEFAULT-EXTENSION '.txt'
        INITIAL-DIR 'M:\'
        RETURN-TO-START-DIR 
        USE-FILENAME
        SAVE-AS
        UPDATE lRpta.
    IF lRpta = NO THEN RETURN.

    DEFINE VAR cCodAlm AS CHAR.
    DEFINE VAR iSec AS INT.

    OUTPUT STREAM REPORT TO VALUE(cArchivo).
    
    REPEAT iSec = 1 TO NUM-ENTRIES(cLisAlm,","):
        cCodAlm = ENTRY(iSec,cLisAlm,",").
        FOR EACH Almmmate WHERE Almmmate.codcia = s-codcia AND Almmmate.CodAlm = cCodAlm NO-LOCK:
            IF almmmate.stkact = 0 THEN NEXT.
            IF almmmate.CodUbi = '' OR almmmate.CodUbi = 'g-0' THEN DO:
                FIND FIRST almmmatg WHERE almmmatg.codcia = 1 AND almmmatg.codmat = almmmate.codmat  NO-LOCK NO-ERROR.
                IF NOT AVAILABLE almmmatg OR almmmatg.TpoArt <> "A" THEN NEXT.

                DISPLAY STREAM report
                    Almmmate.CodAlm 
                    Almmmate.Codubi
                    Almmmate.codmat 
                    Almmmatg.desmat 
                    Almmmatg.desmar 
                    Almmmatg.undbas 
                    Almmmate.stkact 
                    WITH FRAME f-reporte.

                DISPLAY 'Cargando...' + Almmmate.codmat @ x-mensaje WITH FRAME {&FRAME-NAME}.
            END.

        END.
    END.
    
    PAGE STREAM REPORT.
    OUTPUT STREAM REPORT CLOSE.
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

