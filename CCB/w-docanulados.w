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
DEFINE TEMP-TABLE tt-tempo
    FIELDS tt-coddiv LIKE ccbcdocu.coddiv
    FIELDS tt-codven LIKE ccbcdocu.codven
    FIELDS tt-codmot LIKE ccbaudit.codref
    FIELDS tt-desmot AS CHAR
    FIELDS tt-nrovec AS INT.

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
&Scoped-Define ENABLED-OBJECTS F-DIVISION BUTTON-5 x-Desde x-Hasta btn-Ok ~
btn-cancel 
&Scoped-Define DISPLAYED-OBJECTS F-DIVISION x-Desde x-Hasta x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-cancel 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Button 7" 
     SIZE 15 BY 1.62.

DEFINE BUTTON btn-Ok 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 6" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 6" 
     SIZE 4.43 BY .81.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(60)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE x-Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-DIVISION AT ROW 2.62 COL 13 COLON-ALIGNED WIDGET-ID 4
     BUTTON-5 AT ROW 2.62 COL 59 WIDGET-ID 2
     x-Desde AT ROW 4.23 COL 13 COLON-ALIGNED WIDGET-ID 6
     x-Hasta AT ROW 4.23 COL 38 COLON-ALIGNED WIDGET-ID 8
     x-mensaje AT ROW 6.38 COL 2 NO-LABEL WIDGET-ID 14
     btn-Ok AT ROW 7.73 COL 43 WIDGET-ID 10
     btn-cancel AT ROW 7.73 COL 58 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.29 BY 9.08 WIDGET-ID 100.


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
         TITLE              = "Documentos Anulados por Vendedor"
         HEIGHT             = 9.08
         WIDTH              = 77.29
         MAX-HEIGHT         = 9.08
         MAX-WIDTH          = 77.29
         VIRTUAL-HEIGHT     = 9.08
         VIRTUAL-WIDTH      = 77.29
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
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Documentos Anulados por Vendedor */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Documentos Anulados por Vendedor */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-cancel W-Win
ON CHOOSE OF btn-cancel IN FRAME F-Main /* Button 7 */
DO:
      &IF DEFINED (adm-panel) <> 0 &THEN
          RUN dispatch IN THIS-PROCEDURE ('exit').
      &ELSE
          APPLY "CLOSE":U TO THIS-PROCEDURE.
      &ENDIF
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-Ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-Ok W-Win
ON CHOOSE OF btn-Ok IN FRAME F-Main /* Button 6 */
DO:
    ASSIGN f-division x-desde x-hasta.
    RUN Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 6 */
DO:
    DEF VAR x-Divisiones AS CHAR.
    x-Divisiones = F-Division:SCREEN-VALUE.
    RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
    F-Division:SCREEN-VALUE = x-Divisiones.

  /*DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-Divis02.r("Divisiones").
    IF output-var-2 <> ? THEN DO:
        F-DIVISION = output-var-2.
        DISPLAY F-DIVISION.
        APPLY "ENTRY" TO F-DIVISION .
        RETURN NO-APPLY.

    END.
  END.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION W-Win
ON LEAVE OF F-DIVISION IN FRAME F-Main /* Division */
DO:
    ASSIGN F-DIVISION.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Data W-Win 
PROCEDURE Carga-Data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iInt AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cAlm AS CHARACTER   NO-UNDO.
    cAlm = f-division.

    DO iInt = 1 TO NUM-ENTRIES(cAlm):
        Master:
        FOR EACH CcbAudit USE-INDEX Llave02
            WHERE CcbAudit.CodCia = s-codcia
            AND CcbAudit.CodDiv = ENTRY(iInt,cAlm,",")
            AND CcbAudit.Fecha >= x-Desde
            AND CcbAudit.Fecha <= x-Hasta
            AND LOOKUP(CcbAudit.CodDoc,"FAC,BOL,TCK") > 0 
            AND CcbAudit.Evento <> "DELETE"  NO-LOCK,
            FIRST ccbcdocu WHERE ccbcdocu.codcia = ccbaudit.codcia
                AND ccbcdocu.coddiv = ccbaudit.coddiv
                AND ccbcdocu.coddoc = ccbaudit.coddoc  
                AND ccbcdocu.nrodoc = ccbaudit.nrodoc  
                AND ccbcdocu.flgest = "A" NO-LOCK:
            FIND FIRST tt-tempo WHERE tt-coddiv = ccbcdocu.coddiv
                AND tt-codven = ccbcdocu.codven
                AND tt-codmot = ccbAudit.CodRef NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-tempo THEN DO:
                FIND FIRST ccbtabla WHERE ccbtabla.codcia = ccbcdocu.codcia
                    AND ccbtabla.tabla = "MA"
                    AND ccbtabla.codigo = ccbAudit.CodRef NO-LOCK NO-ERROR.
                CREATE tt-tempo.
                ASSIGN
                    tt-coddiv = ccbcdocu.coddiv
                    tt-codven = ccbcdocu.codven
                    tt-codmot = ccbAudit.CodRef
                    tt-nrovec = 1.
                IF AVAIL ccbtabla THEN tt-desmot = ccbtabla.nombre.                    
            END.
            ELSE DO:
                ASSIGN tt-nrovec = 1 + tt-nrovec.    
            END.
            DISPLAY ccbcdocu.coddoc + "-" + ccbcdocu.nrodoc @ x-mensaje
                WITH FRAME {&FRAME-NAME}.
            PAUSE 0.
        END.
    END.
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

    DEFINE VARIABLE iInt AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cAlm AS CHARACTER   NO-UNDO.
    cAlm = f-division.

    DO iInt = 1 TO NUM-ENTRIES(cAlm):
        Master:
        FOR EACH CcbCDocu USE-INDEX Llave10
            WHERE CcbCDocu.CodCia = s-codcia
            AND CcbCDocu.CodDiv = ENTRY(iInt,cAlm,",")
            AND CcbCDocu.FchDoc >= x-Desde
            AND CcbCDocu.FchDoc <= x-Hasta
            AND LOOKUP(CcbCDocu.CodDoc,"FAC,BOL,TCK") > 0
            AND CcbCDocu.FlgEst = "A" NO-LOCK,
            FIRST CcbAudit USE-INDEX Llave02
            WHERE CcbAudit.CodCia = CcbCDocu.CodCia
            AND CcbAudit.CodDiv = CcbCDocu.CodDiv
            AND CcbAudit.CodDoc = CcbCDocu.CodDoc
            AND CcbAudit.NroDoc = CcbCDocu.NroDoc NO-LOCK: 
            IF CcbAudit.Evento <> "DELETE" THEN NEXT Master.
            
            FIND FIRST tt-tempo WHERE tt-coddiv = ccbcdocu.coddiv
                AND tt-codven = ccbcdocu.codven
                AND tt-codmot = ccbAudit.CodRef NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-tempo THEN DO:
                FIND FIRST ccbtabla WHERE ccbtabla.codcia = ccbcdocu.codcia
                    AND ccbtabla.tabla = "MA"
                    AND ccbtabla.codigo = ccbAudit.CodRef NO-LOCK NO-ERROR.
                CREATE tt-tempo.
                ASSIGN
                    tt-coddiv = ccbcdocu.coddiv
                    tt-codven = ccbcdocu.codven
                    tt-codmot = ccbAudit.CodRef
                    tt-nrovec = 1.
                IF AVAIL ccbtabla THEN tt-desmot = ccbtabla.nombre.                    
            END.
            ELSE DO:
                ASSIGN tt-nrovec = 1 + tt-nrovec.    
            END.
            DISPLAY ccbcdocu.coddoc + "-" + ccbcdocu.nrodoc @ x-mensaje
                WITH FRAME {&FRAME-NAME}.
            PAUSE 0.
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
  DISPLAY F-DIVISION x-Desde x-Hasta x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE F-DIVISION BUTTON-5 x-Desde x-Hasta btn-Ok btn-cancel 
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 3.

RUN Carga-Data.
/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("B"):NumberFormat = "@".
chWorkSheet:Columns("C"):NumberFormat = "@".


chWorkSheet:Range("A2"):Value = "RESUMEN DE DOCUMENTOS ANULADOS POR VENDEDOR".

chWorkSheet:Range("A3"):Value = "DIVISION".
chWorkSheet:Range("B3"):Value = "CODVEN".
chWorkSheet:Range("C3"):Value = "VENDEDOR".
chWorkSheet:Range("D3"):Value = "COD MOT".
chWorkSheet:Range("E3"):Value = "MOTIVO".
chWorkSheet:Range("F3"):Value = "NRO VECES".

FOR EACH tt-tempo NO-LOCK,
    FIRST gn-ven WHERE gn-ven.codcia = s-codcia
    AND gn-ven.codven = tt-codven NO-LOCK:
    t-column = t-column + 1.                                                                                                                               
    cColumn = STRING(t-Column).                                                                                        
    cRange = "A" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tt-coddiv.
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tt-codven. 
    cRange = "C" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = gn-ven.NomVen.
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tt-codmot.
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tt-desmot.
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tt-nrovec.
END.

MESSAGE "Proceso Terminado"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

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

