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
&Scoped-Define ENABLED-OBJECTS x-Divi BUTTON-1 x-Desde x-Hasta r-tipo ~
BUTTON-6 BUTTON-7 
&Scoped-Define DISPLAYED-OBJECTS x-Divi x-Desde x-Hasta r-tipo x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 4 BY 1.08.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 6" 
     SIZE 9 BY 1.62.

DEFINE BUTTON BUTTON-7 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 7" 
     SIZE 9 BY 1.62.

DEFINE VARIABLE x-Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-Divi AS CHARACTER FORMAT "X(200)":U INITIAL "00000" 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE x-Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1 NO-UNDO.

DEFINE VARIABLE r-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Pedido Mostrador", 1,
"Pedidos Otros", 2,
"Guias Remision", 3
     SIZE 59 BY 1.08 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-Divi AT ROW 1.81 COL 14 COLON-ALIGNED WIDGET-ID 12
     BUTTON-1 AT ROW 1.81 COL 77 WIDGET-ID 20
     x-Desde AT ROW 3.15 COL 14 COLON-ALIGNED WIDGET-ID 2
     x-Hasta AT ROW 3.15 COL 39 COLON-ALIGNED WIDGET-ID 4
     r-tipo AT ROW 4.5 COL 15.14 NO-LABEL WIDGET-ID 16
     x-mensaje AT ROW 5.85 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     BUTTON-6 AT ROW 7.19 COL 56 WIDGET-ID 8
     BUTTON-7 AT ROW 7.19 COL 66 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 82.43 BY 8.19 WIDGET-ID 100.


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
         TITLE              = "Reporte Pedidos"
         HEIGHT             = 8.19
         WIDTH              = 82.43
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 95.86
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 95.86
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
ON END-ERROR OF W-Win /* Reporte Pedidos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte Pedidos */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEF VAR x-Divisiones AS CHAR.
    x-Divisiones = x-Divi:SCREEN-VALUE.
    RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
    x-Divi:SCREEN-VALUE = x-Divisiones.
    /*cDivi = x-Divisiones.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
    ASSIGN
        x-divi
        x-desde
        x-hasta
        r-tipo.

    IF r-tipo = 1 THEN RUN Excel-M.
    IF r-tipo = 2 THEN RUN Excel-P.
    IF r-tipo = 3 THEN RUN Excel-G.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Button 7 */
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
  DISPLAY x-Divi x-Desde x-Hasta r-tipo x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-Divi BUTTON-1 x-Desde x-Hasta r-tipo BUTTON-6 BUTTON-7 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-G W-Win 
PROCEDURE Excel-G :
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

DEFINE VARIABLE iNroItem  AS INTEGER     NO-UNDO.
DEFINE VARIABLE cAlmDes   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNomCHq   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNroDoc   AS CHARACTER   NO-UNDO EXTENT 10.
DEFINE VARIABLE iInt      AS INTEGER     NO-UNDO INIT 0.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A1: M2"):FONT:Bold = TRUE.
chWorkSheet:Range("A2"):VALUE = "Nro. Guia".
chWorkSheet:Range("B2"):VALUE = "Nombre Cliente".
chWorkSheet:Range("C2"):VALUE = "Fecha Emision".
chWorkSheet:Range("D2"):VALUE = "Hora Chequeo".
chWorkSheet:Range("E2"):VALUE = "Nro de Items".
chWorkSheet:Range("F2"):VALUE = "Chequeador".
chWorkSheet:Range("G2"):VALUE = "Cod. Vendedor".
chWorkSheet:Range("H2"):VALUE = "Alm Despacha".
chWorkSheet:Range("I2"):VALUE = "Glosa".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("G"):NumberFormat = "@".
chWorkSheet:COLUMNS("H"):NumberFormat = "@".


chWorkSheet = chExcelApplication:Sheets:Item(1).

FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia
    AND LOOKUP(ccbcdocu.coddiv,x-divi) > 0
    AND ccbcdocu.coddoc = "G/R"
    AND ccbcdocu.fchdoc >= x-Desde
    AND ccbcdocu.fchdoc <= x-Hasta
    AND ccbcdocu.flgest <> "A" NO-LOCK:

    iNroItem = 0.
    FOR EACH ccbddocu OF ccbcdocu NO-LOCK BREAK BY ccbddocu.codmat:
        IF FIRST-OF(ccbddocu.codmat) THEN iNroItem = iNroItem + 1.
        cAlmDes  = ccbddocu.AlmDes.
        PAUSE 0.
    END.
    
    cNomCHq = "".
    IF CcbCDocu.Libre_c05 <> "" THEN DO:
        FIND Pl-pers WHERE Pl-pers.codcia = s-codcia 
            AND Pl-pers.codper = CcbCDocu.Libre_c05 NO-LOCK NO-ERROR.
        IF AVAILABLE Pl-pers 
            THEN cNomCHq = TRIM(Pl-pers.patper) + ' ' +
                TRIM(Pl-pers.matper) + ',' + TRIM(PL-pers.nomper).
        ELSE cNomCHq = "".
    END.
    
    /*************
    /*Carga Nro Documentos*/
    iInt = 0.
    FOR EACH ccbcdocu USE-INDEX llave06
        WHERE ccbcdocu.codcia = s-codcia
        AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK") > 0
        AND ccbcdocu.codcli = ccbcdocu.codcli
        AND ccbcdocu.flgest <> "A"
        AND ccbcdocu.nroped = ccbcdocu.nroped NO-LOCK:
        iInt = iInt + 1.
        cNroDoc[iInt] = ccbcdocu.coddoc + "-" + ccbcdocu.nrodoc.
        PAUSE 0.
    END.
    *********/

    t-column = t-column + 1.
    cColumn = STRING(t-Column).      
    cRange = "A" + cColumn.   
    chWorkSheet:Range(cRange):Value = ccbcdocu.NroPed.
    cRange = "B" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = ccbcdocu.NomCli.
    cRange = "C" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = ccbcdocu.fchdoc.
    /***
    cRange = "D" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = ccbcdocu.HorChq.
    ****/
    cRange = "E" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = iNroItem.
    cRange = "F" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = cNomChq.
    cRange = "G" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = ccbcdocu.CodVen.
    cRange = "H" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = cAlmDes.
    cRange = "I" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = ccbcdocu.Glosa.

    DISPLAY "PROCESANDO: " + ccbcdocu.coddoc + " - " + ccbcdocu.nroped @ x-mensaje WITH FRAME {&FRAME-NAME}.
    PAUSE 0.

END.

DISPLAY  " "  @ x-mensaje WITH FRAME {&FRAME-NAME}.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-M W-Win 
PROCEDURE Excel-M :
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

DEFINE VARIABLE iNroItem  AS INTEGER     NO-UNDO.
DEFINE VARIABLE cAlmDes   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNomCHq   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNroDoc   AS CHARACTER   NO-UNDO EXTENT 10.
DEFINE VARIABLE iInt      AS INTEGER     NO-UNDO INIT 0.
DEFINE VARIABLE cHora     AS CHARACTER   NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A1: M2"):FONT:Bold = TRUE.
chWorkSheet:Range("A2"):VALUE = "Nro. Pedido".
chWorkSheet:Range("B2"):VALUE = "Nombre Cliente".
chWorkSheet:Range("C2"):VALUE = "Fecha Emision".
chWorkSheet:Range("D2"):VALUE = "Nro de Items".
chWorkSheet:Range("E2"):VALUE = "Chequeador".
chWorkSheet:Range("F2"):VALUE = "Hora Chequeo".
chWorkSheet:Range("G2"):VALUE = "Cod. Vendedor".
chWorkSheet:Range("H2"):VALUE = "Alm Despacha".
chWorkSheet:Range("I2"):VALUE = "Glosa".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("G"):NumberFormat = "@".
chWorkSheet:COLUMNS("H"):NumberFormat = "@".


chWorkSheet = chExcelApplication:Sheets:Item(1).

FOR EACH faccpedm WHERE faccpedm.codcia = s-codcia
    AND LOOKUP(faccpedm.coddiv,x-divi) > 0
    AND faccpedm.coddoc = "P/M"
    AND faccpedm.fchped >= x-Desde
    AND faccpedm.fchped <= x-Hasta
    AND faccpedm.flgest <> "A" NO-LOCK:

    iNroItem = 0.
    FOR EACH facdpedm OF faccpedm NO-LOCK BREAK BY facdpedm.codmat:
        IF FIRST-OF(facdpedm.codmat) THEN iNroItem = iNroItem + 1.
        cAlmDes  = Facdpedm.AlmDes.
    END.
    cNomCHq = "".
    cHora = "".

    IF faccpedm.UsrChq <> "" THEN DO:
        FIND Pl-pers WHERE Pl-pers.codcia = s-codcia 
            AND Pl-pers.codper = faccpedm.UsrChq NO-LOCK NO-ERROR.
        IF AVAILABLE Pl-pers THEN 
            ASSIGN 
                cNomCHq = TRIM(Pl-pers.patper) + ' ' +
                    TRIM(Pl-pers.matper) + ',' + TRIM(PL-pers.nomper).            
    END.


    /*RDP 20-07-10 ******
    IF faccpedm.libre_c01 <> "" THEN DO:
        FIND Pl-pers WHERE Pl-pers.codcia = s-codcia 
            AND Pl-pers.codper = faccpedm.libre_c01 NO-LOCK NO-ERROR.
        IF AVAILABLE Pl-pers THEN 
            ASSIGN 
                cNomCHq = TRIM(Pl-pers.patper) + ' ' +
                    TRIM(Pl-pers.matper) + ',' + TRIM(PL-pers.nomper)
                cHora = Faccpedm.Libre_c02.
    END.
    ELSE IF faccpedm.UsrChq <> "" THEN DO:
        FIND Pl-pers WHERE Pl-pers.codcia = s-codcia 
            AND Pl-pers.codper = faccpedm.UsrChq NO-LOCK NO-ERROR.
        IF AVAILABLE Pl-pers THEN 
            ASSIGN 
                cNomCHq = TRIM(Pl-pers.patper) + ' ' +
                    TRIM(Pl-pers.matper) + ',' + TRIM(PL-pers.nomper)
                cHora  = Faccpedm.HorChq.        
    END.
    
    *RDP  Fin ********/
    
    /****
    /*Carga Nro Documentos*/
    iInt = 0.
    FOR EACH ccbcdocu USE-INDEX llave06
        WHERE ccbcdocu.codcia = s-codcia
        AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK") > 0
        AND ccbcdocu.codcli = faccpedm.codcli
        AND ccbcdocu.flgest <> "A"
        AND ccbcdocu.nroped = faccpedm.nroped NO-LOCK:
        iInt = iInt + 1.
        cNroDoc[iInt] = ccbcdocu.coddoc + "-" + ccbcdocu.nrodoc.
        PAUSE 0.
    END. 
    ****/   

    t-column = t-column + 1.
    cColumn = STRING(t-Column).      
    cRange = "A" + cColumn.   
    chWorkSheet:Range(cRange):Value = Faccpedm.NroPed.
    cRange = "B" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = Faccpedm.NomCli.
    cRange = "C" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = Faccpedm.FchPed.
    cRange = "D" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = iNroItem.
    cRange = "E" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = cNomChq.
    cRange = "F" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = Faccpedm.HorChq.        
    cRange = "G" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = Faccpedm.CodVen.
    cRange = "H" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = cAlmDes.
    cRange = "I" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = Faccpedm.Glosa.

    DISPLAY "PROCESANDO: " + faccpedm.coddoc + " - " + Faccpedm.nroped @ x-mensaje WITH FRAME {&FRAME-NAME}.
    PAUSE 0.

END.

DISPLAY  " "  @ x-mensaje WITH FRAME {&FRAME-NAME}.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-P W-Win 
PROCEDURE Excel-P :
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

DEFINE VARIABLE iNroItem  AS INTEGER     NO-UNDO.
DEFINE VARIABLE cAlmDes   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNomCHq   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNroDoc   AS CHARACTER   NO-UNDO EXTENT 10.
DEFINE VARIABLE iInt      AS INTEGER     NO-UNDO INIT 0.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A1: M2"):FONT:Bold = TRUE.
chWorkSheet:Range("A2"):VALUE = "Nro. Pedido".
chWorkSheet:Range("B2"):VALUE = "Nombre Cliente".
chWorkSheet:Range("C2"):VALUE = "Fecha Emision".
chWorkSheet:Range("D2"):VALUE = "Hora Chequeo".
chWorkSheet:Range("E2"):VALUE = "Nro de Items".
chWorkSheet:Range("F2"):VALUE = "Chequeador".
chWorkSheet:Range("G2"):VALUE = "Cod. Vendedor".
chWorkSheet:Range("H2"):VALUE = "Alm Despacha".
chWorkSheet:Range("I2"):VALUE = "Glosa".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("G"):NumberFormat = "@".
chWorkSheet:COLUMNS("H"):NumberFormat = "@".


chWorkSheet = chExcelApplication:Sheets:Item(1).

FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia
    AND LOOKUP(faccpedi.coddiv,x-divi) > 0
    AND faccpedi.coddoc = "PED"
    AND faccpedi.fchped >= x-Desde
    AND faccpedi.fchped <= x-Hasta
    AND faccpedi.flgest <> "A" NO-LOCK:

    iNroItem = 0.
    FOR EACH facdpedi OF faccpedi NO-LOCK BREAK BY Facdpedi.codmat:
        IF FIRST-OF(facdpedi.codmat) THEN iNroItem = iNroItem + 1.
        cAlmDes  = facdpedi.AlmDes.
        PAUSE 0.
    END.
    
    cNomCHq = "".
    IF FacCPedi.UsrChq <> "" THEN DO:
        FIND Pl-pers WHERE Pl-pers.codcia = s-codcia 
            AND Pl-pers.codper = FacCPedi.UsrChq NO-LOCK NO-ERROR.
        IF AVAILABLE Pl-pers 
            THEN cNomCHq = TRIM(Pl-pers.patper) + ' ' +
                TRIM(Pl-pers.matper) + ',' + TRIM(PL-pers.nomper).
        ELSE cNomCHq = "".
    END.
    
    /*************
    /*Carga Nro Documentos*/
    iInt = 0.
    FOR EACH ccbcdocu USE-INDEX llave06
        WHERE ccbcdocu.codcia = s-codcia
        AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK") > 0
        AND ccbcdocu.codcli = faccpedi.codcli
        AND ccbcdocu.flgest <> "A"
        AND ccbcdocu.nroped = faccpedi.nroped NO-LOCK:
        iInt = iInt + 1.
        cNroDoc[iInt] = ccbcdocu.coddoc + "-" + ccbcdocu.nrodoc.
        PAUSE 0.
    END.
    *********/

    t-column = t-column + 1.
    cColumn = STRING(t-Column).      
    cRange = "A" + cColumn.   
    chWorkSheet:Range(cRange):Value = faccpedi.NroPed.
    cRange = "B" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = faccpedi.NomCli.
    cRange = "C" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = faccpedi.FchPed.
    cRange = "D" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = faccpedi.HorChq.
    cRange = "E" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = iNroItem.
    cRange = "F" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = cNomChq.
    cRange = "G" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = faccpedi.CodVen.
    cRange = "H" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = cAlmDes.
    cRange = "I" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = faccpedi.Glosa.

    DISPLAY "PROCESANDO: " + faccpedi.coddoc + " - " + faccpedi.nroped @ x-mensaje WITH FRAME {&FRAME-NAME}.
    PAUSE 0.

END.

DISPLAY  " "  @ x-mensaje WITH FRAME {&FRAME-NAME}.

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
      ASSIGN 
          x-Desde = TODAY - DAY(TODAY) + 1
          x-Hasta = TODAY.
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

