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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR cl-codcia AS INT INIT 0.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cCodDoc AS CHARACTER   NO-UNDO.
DEFINE VARIABLE S-TITULO AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tabla
    FIELDS tt-codmat LIKE almmmatg.codmat
    FIELDS tt-canped AS DECIMAL
    FIELDS tt-canate AS DECIMAL
    FIELDS tt-codfam LIKE almmmatg.codfam.

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
&Scoped-Define ENABLED-OBJECTS F-DIVISION BUTTON-5 txt-codcli DesdeF HastaF ~
rs-docs Btn_OK Btn_Cancel RECT-64 RECT-65 
&Scoped-Define DISPLAYED-OBJECTS F-DIVISION txt-codcli txt-nomcli DesdeF ~
HastaF rs-docs txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 6" 
     SIZE 4.43 BY .81.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .77 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .77 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .77 NO-UNDO.

DEFINE VARIABLE txt-codcli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 58 BY .81
     BGCOLOR 7 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE txt-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.72 BY .81 NO-UNDO.

DEFINE VARIABLE rs-docs AS CHARACTER INITIAL "T" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", "T",
"Cotizacion", "C",
"Pedidos", "P",
"O/D", "O"
     SIZE 34.72 BY 1.35 NO-UNDO.

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 7.54.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18 BY 7.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-DIVISION AT ROW 1.81 COL 8.29 COLON-ALIGNED WIDGET-ID 6
     BUTTON-5 AT ROW 1.81 COL 21.29 WIDGET-ID 2
     txt-codcli AT ROW 2.88 COL 8.29 COLON-ALIGNED WIDGET-ID 24
     txt-nomcli AT ROW 2.88 COL 19.29 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     DesdeF AT ROW 3.96 COL 8.29 COLON-ALIGNED WIDGET-ID 4
     HastaF AT ROW 3.96 COL 24.29 COLON-ALIGNED WIDGET-ID 8
     rs-docs AT ROW 5 COL 10.29 NO-LABEL WIDGET-ID 12
     Btn_OK AT ROW 2.08 COL 65.72 WIDGET-ID 22
     Btn_Cancel AT ROW 3.96 COL 65.72 WIDGET-ID 20
     txt-msj AT ROW 6.92 COL 3 NO-LABEL WIDGET-ID 16
     RECT-64 AT ROW 1.12 COL 2 WIDGET-ID 10
     RECT-65 AT ROW 1.15 COL 62.72 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.29 BY 8.23
         FONT 1 WIDGET-ID 100.


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
         TITLE              = "RESUMEN PENDIENTES POR ARTICULO"
         HEIGHT             = 8.23
         WIDTH              = 81.29
         MAX-HEIGHT         = 8.23
         MAX-WIDTH          = 99.72
         VIRTUAL-HEIGHT     = 8.23
         VIRTUAL-WIDTH      = 99.72
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
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       txt-msj:HIDDEN IN FRAME F-Main           = TRUE
       txt-msj:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN txt-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* RESUMEN PENDIENTES POR ARTICULO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* RESUMEN PENDIENTES POR ARTICULO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  
    ASSIGN F-DIVISION DesdeF HastaF rs-docs txt-codcli.

    CASE rs-docs:
        WHEN "T" THEN 
            ASSIGN 
                cCodDoc = "COT,PED,O/D"
                S-TITULO = "COTIZACIONES Y PEDIDOS ".
        WHEN "C" THEN 
            ASSIGN 
                cCodDoc = "COT"
                S-TITULO = "COTIZACIONES ".
        WHEN "P" THEN 
            ASSIGN 
                cCodDoc = "PED"
                S-TITULO = "PEDIDOS ".
        WHEN "O/D" THEN 
            ASSIGN 
                cCodDoc = "O/D"
                S-TITULO = "ORDENES DE DESPACHO ".
    END CASE.
    S-TITULO = S-TITULO + "PENDIENTES POR ATENDER.".
    txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.
    RUN Excel.
    txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 6 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-Divis02.r("Divisiones").
    IF output-var-2 <> ? THEN DO:
        F-DIVISION = output-var-2.
        DISPLAY F-DIVISION.
        APPLY "ENTRY" TO F-DIVISION .
        RETURN NO-APPLY.

    END.
  END.
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


&Scoped-define SELF-NAME txt-codcli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-codcli W-Win
ON RETURN OF txt-codcli IN FRAME F-Main /* Cliente */
DO:
  FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = {&SELF-NAME} NO-LOCK NO-ERROR.
  IF AVAIL gn-clie 
      THEN DISPLAY gn-clie.nomcli @ txt-nomcli WITH FRAME {&FRAME-NAME}.
  ELSE DISPLAY "" @ txt-nomcli WITH FRAME {&FRAME-NAME}.  
  MESSAGE gn-clie.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ON 'RETURN':U OF f-division,txt-codcli,DesdeF,HastaF,rs-docs
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

ON 'LEAVE':U OF txt-codcli
DO:
  FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = txt-codcli:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAIL gn-clie 
      THEN DISPLAY gn-clie.nomcli @ txt-nomcli WITH FRAME {&FRAME-NAME}.
  ELSE DISPLAY "" @ txt-nomcli WITH FRAME {&FRAME-NAME}.    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia
        AND faccpedi.coddiv = f-division
        AND LOOKUP(faccpedi.coddoc,cCodDoc) > 0
        AND (faccpedi.codcli BEGINS txt-codcli 
        OR txt-codcli = "")
        AND faccpedi.fchped >= DesdeF
        AND faccpedi.fchped <= HastaF
        AND faccpedi.flgest = "P" NO-LOCK,
        EACH facdpedi OF faccpedi NO-LOCK
        BREAK BY faccpedi.coddoc
        BY faccpedi.nroped:
        IF facdpedi.canped - facdpedi.canate = 0 THEN NEXT.
        FIND FIRST tabla WHERE tabla.tt-codmat = facdpedi.codmat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE tabla THEN DO:
            CREATE tabla.
            ASSIGN tt-codmat = facdpedi.codmat.
        END.
        ASSIGN
            tt-canped = tt-canped + facdpedi.canped
            tt-canate = tt-canate + facdpedi.canate.               
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
  DISPLAY F-DIVISION txt-codcli txt-nomcli DesdeF HastaF rs-docs txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE F-DIVISION BUTTON-5 txt-codcli DesdeF HastaF rs-docs Btn_OK Btn_Cancel 
         RECT-64 RECT-65 
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

    RUN Carga-Temporal.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).    

    /*Formato*/
    chWorkSheet:Columns("A"):NumberFormat = "@".    
    chWorkSheet:Columns("D"):NumberFormat = "@".    

    /*Cabecera*/
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = S-TITULO.

    iCount = iCount + 3.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Articulo".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descripcion".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Marca".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Familia".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cant. Pedida".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cant. Atendida".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Diferencia".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Stck Actual Alm 40".

    iCount = iCount + 1.

    FOR EACH tabla NO-LOCK:
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
            AND almmmatg.codmat = tt-codmat NO-LOCK NO-ERROR.

        FIND FIRST almmmate WHERE almmmate.codcia = 1
            AND almmmate.codalm = "40"
            AND almmmate.codmat = tt-codmat NO-LOCK NO-ERROR.
        
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-codmat.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = almmmatg.desmat.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = almmmatg.desmar.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = Almmmatg.codfam.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-canped.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-canate.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-canped - tt-canate.
        IF AVAIL almmmate THEN DO:
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = Almmmate.StkAct.
        END.
    END.

    

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN f-division = S-CODDIV
             DesdeF   = TODAY
             HastaF   = TODAY.
      DISPLAY 
          s-coddiv @ f-division
          TODAY @ DesdeF
          TODAY @ HastaF.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN ASSIGN input-var-1 = "".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

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

