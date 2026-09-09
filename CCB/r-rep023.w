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

DEF TEMP-TABLE Detalle LIKE Ccbcdocu.

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
&Scoped-Define ENABLED-OBJECTS EDITOR-divisiones BUTTON-1 x-Motivo ~
x-FchDoc-1 x-FchDoc-2 BUTTON-3 Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-divisiones x-Motivo x-FchDoc-1 ~
x-FchDoc-2 f-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\exit":U
     LABEL "&Done" 
     SIZE 8 BY 1.92
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 8 BY 1.88.

DEFINE VARIABLE x-Motivo AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Motivo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 53 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR-divisiones AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 58 BY 4.23 NO-UNDO.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     EDITOR-divisiones AT ROW 1.27 COL 16 NO-LABEL WIDGET-ID 26
     BUTTON-1 AT ROW 1.54 COL 74.86 WIDGET-ID 4
     x-Motivo AT ROW 5.88 COL 19 COLON-ALIGNED WIDGET-ID 18
     x-FchDoc-1 AT ROW 6.96 COL 19 COLON-ALIGNED WIDGET-ID 20
     x-FchDoc-2 AT ROW 6.96 COL 39 COLON-ALIGNED WIDGET-ID 22
     BUTTON-3 AT ROW 8.58 COL 11 WIDGET-ID 10
     Btn_Done AT ROW 8.58 COL 20 WIDGET-ID 12
     f-Mensaje AT ROW 10.73 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     "Divisiones" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.31 COL 7.43 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.57 BY 11.62
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
         TITLE              = "NOTAS DE CREDITO POR OTROS CONCEPTOS (NO DEVOLUCIONES)"
         HEIGHT             = 11.62
         WIDTH              = 80.57
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 109.43
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 109.43
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
ASSIGN 
       EDITOR-divisiones:AUTO-INDENT IN FRAME F-Main      = TRUE
       EDITOR-divisiones:AUTO-RESIZE IN FRAME F-Main      = TRUE
       EDITOR-divisiones:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* NOTAS DE CREDITO POR OTROS CONCEPTOS (NO DEVOLUCIONES) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* NOTAS DE CREDITO POR OTROS CONCEPTOS (NO DEVOLUCIONES) */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
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

    DEF VAR x-Divisiones AS CHAR.
    x-Divisiones = editor-Divisiones:SCREEN-VALUE.
    RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
    /*FILL-IN-Division:SCREEN-VALUE = x-Divisiones.*/
    editor-Divisiones:SCREEN-VALUE = x-Divisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    ASSIGN
        editor-divisiones
        /*FILL-IN-Division*/
        x-Motivo
        x-FchDoc-1
        x-FchDoc-2.
  RUN Excel.
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

DEF VAR x-CodDiv AS CHAR NO-UNDO.
DEF VAR x-CodMat AS CHAR NO-UNDO.

DEF VAR i AS INT NO-UNDO.

IF x-Motivo = 'Todos' THEN DO:
    FOR EACH CcbTabla WHERE CcbTabla.CodCia = s-codcia
        AND CcbTabla.Tabla = "N/C" NO-LOCK:
        IF x-CodMat = '' 
        THEN x-CodMat = CcbTabla.Codigo.
        ELSE x-CodMat = x-CodMat + ',' + CcbTabla.Codigo.
    END.
END.
ELSE x-CodMat = TRIM (SUBSTRING( x-Motivo, 1, INDEX(x-Motivo, ' - ') )).

SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH Detalle:
    DELETE Detalle.
END.

DO i = 1 TO NUM-ENTRIES(editor-Divisiones):
    x-CodDiv = ENTRY(i, editor-Divisiones).
    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = 'N/C'
        AND Ccbcdocu.coddiv = x-CodDiv
        AND CcbCdocu.CndCre = "N" 
        AND Ccbcdocu.fchdoc >= x-FchDoc-1
        AND Ccbcdocu.fchdoc <= x-FchDoc-2:
        f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '*** PROCESANDO ' + 
            ccbcdocu.coddoc + ' ' + 
            ccbcdocu.nrodoc + ' ' + 
            ccbcdocu.coddiv + ' ' +
            STRING(ccbcdocu.fchdoc) + ' ***'.
        FIND FIRST Ccbddocu WHERE Ccbddocu.codcia = Ccbcdocu.codcia
            AND Ccbddocu.coddoc = Ccbcdocu.coddoc
            AND Ccbddocu.nrodoc = Ccbcdocu.nrodoc
            AND LOOKUP(TRIM (Ccbddocu.codmat), x-CodMat) > 0 NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbddocu THEN DO:
            FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia
                AND CcbTabla.Tabla = "N/C"
                AND CcbTabla.Codigo = Ccbddocu.codmat
                NO-LOCK NO-ERROR.
            CREATE Detalle.
            BUFFER-COPY Ccbcdocu TO Detalle.
            IF AVAILABLE CcbTabla THEN Detalle.Glosa = CcbTabla.Nombre.
        END.
    END.
END.
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
SESSION:SET-WAIT-STATE('').

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
  DISPLAY EDITOR-divisiones x-Motivo x-FchDoc-1 x-FchDoc-2 f-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE EDITOR-divisiones BUTTON-1 x-Motivo x-FchDoc-1 x-FchDoc-2 BUTTON-3 
         Btn_Done 
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

    /* Cargamos temporal */
    DEF VAR x-Estado AS CHAR NO-UNDO.

    RUN Carga-Temporal.

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE
            'No hay registro a imprimir'
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    SESSION:SET-WAIT-STATE('GENERAL').

    DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
    DEFINE VARIABLE chChart                 AS COM-HANDLE.
    DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
    DEFINE VARIABLE iCount                  AS INTEGER init 1.
    DEFINE VARIABLE iIndex                  AS INTEGER.
    DEFINE VARIABLE cColumn                 AS CHARACTER.
    DEFINE VARIABLE cRange                  AS CHARACTER.
    DEFINE VARIABLE t-Column                AS INTEGER INIT 1.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "EMISION".
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "DOC".
    cRange = "C" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "NUMERO".
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "CLIENTE".
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "RUC".
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "REF".
    cRange = "G" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "NUMERO".
    cRange = "H" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "DETALLE".
    cRange = "I" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "MON".
    cRange = "J" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "IMPORTE".
    cRange = "K" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "ESTADO".
    cRange = "L" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "DIVISION".
    cRange = "M" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "APROBADO POR".
    FOR EACH Detalle:
        t-column = t-column + 1.                                                                                                                               
        cColumn = STRING(t-Column).                                                                                        
        cRange = "A" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.fchdoc.
        cRange = "B" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.coddoc.
        cRange = "C" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = "'" + detalle.nrodoc.
        cRange = "D" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.nomcli.
        cRange = "E" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = "'" + detalle.codcli.
        cRange = "F" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.codref.
        cRange = "G" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = "'" + detalle.nroref.
        cRange = "H" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.glosa.
        cRange = "I" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.codmon.
        cRange = "J" + cColumn.                                                                                    
        chWorkSheet:Range(cRange):Value = detalle.imptot.
        RUN gn/fFlgEstCCb (detalle.flgest, OUTPUT x-Estado).
        cRange = "K" + cColumn.                                                                                    
        chWorkSheet:Range(cRange):Value = x-Estado.
        cRange = "L" + cColumn.                                                                                    
        chWorkSheet:Range(cRange):Value = "'" + detalle.coddiv.
        FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
            AND Faccpedi.coddoc = Detalle.codped
            AND Faccpedi.nroped = Detalle.NroPed
            NO-LOCK NO-ERROR.
        IF AVAILABLE Faccpedi THEN DO:
            cRange = "M" + cColumn.                                                                                    
            chWorkSheet:Range(cRange):Value = FacCPedi.UsrAprobacion.
            FIND _User WHERE _Userid = FacCPedi.UsrAprobacion NO-LOCK NO-ERROR.
            IF AVAILABLE _User THEN DO:
                chWorkSheet:Range(cRange):Value = FacCPedi.UsrAprobacion + ' ' + _User-Name.
            END.
        END.
    END.

    /* launch Excel so it is visible to the user */
    chExcelApplication:VISIBLE = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
      x-FchDoc-1 = TODAY - DAY(TODAY) - 1
      x-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH CcbTabla WHERE CcbTabla.CodCia = s-codcia
          AND CcbTabla.Tabla = "N/C" NO-LOCK:
          x-Motivo:ADD-LAST(CcbTabla.Codigo + " - " + CcbTabla.Nombre).
      END.
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

