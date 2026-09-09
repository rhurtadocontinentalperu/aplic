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
DEF SHARED VAR cl-codcia AS INT.

DEF VAR s-task-no AS INT NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS x-CodCli x-Fecha-1 x-Fecha-2 x-FlgEst ~
x-Empresa BUTTON-1 BUTTON-2 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS x-CodCli x-NomCli x-Fecha-1 x-Fecha-2 ~
x-FlgEst x-Empresa x-Mensaje 

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
     LABEL "&Done" 
     SIZE 7 BY 1.88
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/print-2.ico":U
     LABEL "Button 1" 
     SIZE 8 BY 1.88.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 8 BY 1.88.

DEFINE VARIABLE x-CodCli AS CHARACTER FORMAT "x(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-Fecha-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-Fecha-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY 1 NO-UNDO.

DEFINE VARIABLE x-Empresa AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todas", 1,
"Continental", 2,
"Cissac", 3
     SIZE 14 BY 3 NO-UNDO.

DEFINE VARIABLE x-FlgEst AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", "",
"Pendiente", "P",
"Cancelado", "C"
     SIZE 12 BY 3 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodCli AT ROW 1.81 COL 19 COLON-ALIGNED WIDGET-ID 2
     x-NomCli AT ROW 1.81 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     x-Fecha-1 AT ROW 3.15 COL 19 COLON-ALIGNED WIDGET-ID 4
     x-Fecha-2 AT ROW 3.15 COL 42 COLON-ALIGNED WIDGET-ID 6
     x-FlgEst AT ROW 4.5 COL 22 NO-LABEL WIDGET-ID 18
     x-Empresa AT ROW 4.5 COL 41 NO-LABEL WIDGET-ID 22
     BUTTON-1 AT ROW 8.27 COL 10 WIDGET-ID 10
     BUTTON-2 AT ROW 8.27 COL 19 WIDGET-ID 16
     BtnDone AT ROW 8.27 COL 28 WIDGET-ID 12
     x-Mensaje AT ROW 8.54 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96 BY 9.5 WIDGET-ID 100.


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
         TITLE              = "CUENTAS CONSOLIDADAS ATE CISSAC"
         HEIGHT             = 9.5
         WIDTH              = 96
         MAX-HEIGHT         = 9.5
         MAX-WIDTH          = 96
         VIRTUAL-HEIGHT     = 9.5
         VIRTUAL-WIDTH      = 96
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
/* SETTINGS FOR FILL-IN x-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CUENTAS CONSOLIDADAS ATE CISSAC */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CUENTAS CONSOLIDADAS ATE CISSAC */
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
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN
      x-CodCli x-Fecha-1 x-Fecha-2 x-flgest x-empresa.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  ASSIGN
      x-CodCli x-Fecha-1 x-Fecha-2 x-flgest x-empresa.

  SESSION:SET-WAIT-STATE('general').
  RUN Carga-Temporal.
  SESSION:SET-WAIT-STATE('').
  FIND FIRST integral.w-report WHERE integral.w-report.task-no = s-task-no
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE integral.w-report THEN DO:
      MESSAGE 'NO hay registros que imprimir' VIEW-AS ALERT-BOX ERROR.
      RETURN.
  END.
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodCli W-Win
ON LEAVE OF x-CodCli IN FRAME F-Main /* Cliente */
DO:
  x-nomcli:SCREEN-VALUE = ''.
  FIND integral.gn-clie WHERE integral.gn-clie.codcia = cl-codcia
      AND integral.gn-clie.codcli = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE integral.gn-clie THEN x-nomcli:SCREEN-VALUE = integral.gn-clie.nomcli.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-temporal W-Win 
PROCEDURE Borra-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH integral.w-report WHERE integral.w-report.task-no = s-task-no:
    DELETE integral.w-report.
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

DEF VAR pEstado AS CHAR NO-UNDO.

REPEAT:
    s-task-no = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST integral.w-report WHERE integral.w-report.task-NO = s-task-no NO-LOCK) 
    THEN LEAVE.
END.
/* Cuentas Conti */
FOR EACH integral.ccbcdocu NO-LOCK WHERE integral.ccbcdocu.codcia = s-codcia
    AND LOOKUP(integral.ccbcdocu.coddoc, 'fac,bol,tck,let,n/d,n/c,a/r,bd') > 0
    AND integral.ccbcdocu.fchdoc >= x-fecha-1
    AND integral.ccbcdocu.fchdoc <= x-fecha-2:
    IF x-flgest <> '' AND integral.ccbcdocu.flgest <> x-flgest THEN NEXT.
    IF x-codcli <> '' AND integral.ccbcdocu.codcli <> x-codcli THEN NEXT.
    RUN gn/fFlgEstCcb (integral.Ccbcdocu.flgest, OUTPUT pEstado).
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '*** CONTI *** ' + integral.ccbcdocu.coddiv + ' ' + 
        integral.ccbcdocu.coddoc + ' ' + integral.ccbcdocu.nrodoc + ' ' + 
        STRING(integral.ccbcdocu.fchdoc).
    CREATE integral.w-report.
    ASSIGN
        INTEGRAL.w-report.Task-No = s-task-no
        INTEGRAL.w-report.Llave-C = 'CONTINENTAL'
        INTEGRAL.w-report.Campo-C[1] = integral.ccbcdocu.coddiv
        INTEGRAL.w-report.Campo-C[2] = integral.ccbcdocu.coddoc
        INTEGRAL.w-report.Campo-C[3] = integral.ccbcdocu.nrodoc
        INTEGRAL.w-report.Campo-C[4] = integral.ccbcdocu.codcli
        INTEGRAL.w-report.Campo-C[5] = integral.ccbcdocu.nomcli
        INTEGRAL.w-report.Campo-C[6] = pEstado
        INTEGRAL.w-report.Campo-I[1] = integral.ccbcdocu.codmon
        INTEGRAL.w-report.Campo-D[1] = integral.ccbcdocu.fchdoc
        INTEGRAL.w-report.Campo-F[1] = integral.ccbcdocu.imptot
        INTEGRAL.w-report.Campo-F[2] = integral.ccbcdocu.sdoact.
END.

IF x-Empresa = 2 THEN RETURN.
/* Cuentas Cissac */
FOR EACH cissac.ccbcdocu USE-INDEX llave13 NO-LOCK WHERE cissac.ccbcdocu.codcia = s-codcia
    AND cissac.ccbcdocu.coddoc = 'LET'
    AND cissac.ccbcdocu.fchdoc >= x-fecha-1
    AND cissac.ccbcdocu.fchdoc <= x-fecha-2:
    IF x-flgest <> '' AND cissac.ccbcdocu.flgest <> x-flgest THEN NEXT.
    IF x-codcli <> '' AND cissac.ccbcdocu.codcli <> x-codcli THEN NEXT.
    RUN gn/fFlgEstCcb (cissac.Ccbcdocu.flgest, OUTPUT pEstado).
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '*** CISSAC *** ' + cissac.ccbcdocu.coddiv + ' ' + 
        cissac.ccbcdocu.coddoc + ' ' + cissac.ccbcdocu.nrodoc + ' ' + 
        STRING(cissac.ccbcdocu.fchdoc).
    CREATE integral.w-report.
    ASSIGN
        integral.w-report.Task-No = s-task-no
        INTEGRAL.w-report.Llave-C = 'CISSAC'
        integral.w-report.Campo-C[1] = cissac.ccbcdocu.coddiv
        integral.w-report.Campo-C[2] = cissac.ccbcdocu.coddoc
        integral.w-report.Campo-C[3] = cissac.ccbcdocu.nrodoc
        integral.w-report.Campo-C[4] = cissac.ccbcdocu.codcli
        integral.w-report.Campo-C[5] = cissac.ccbcdocu.nomcli
        integral.w-report.Campo-C[6] = pEstado
        integral.w-report.Campo-I[1] = cissac.ccbcdocu.codmon
        integral.w-report.Campo-D[1] = cissac.ccbcdocu.fchdoc
        integral.w-report.Campo-F[1] = cissac.ccbcdocu.imptot
        integral.w-report.Campo-F[2] = cissac.ccbcdocu.sdoact.
END.
x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".


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
  DISPLAY x-CodCli x-NomCli x-Fecha-1 x-Fecha-2 x-FlgEst x-Empresa x-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-CodCli x-Fecha-1 x-Fecha-2 x-FlgEst x-Empresa BUTTON-1 BUTTON-2 
         BtnDone 
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

    DEFINE VARIABLE i AS INTEGER.
    DEFINE VARIABLE x-ImporteMn AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE x-ImporteMe AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE x-SaldoMn AS DECIMAL.
    DEFINE VARIABLE x-SaldoMe AS DECIMAL.
    DEFINE VARIABLE cCliente  AS CHARACTER   NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "CONSOLIDADO DE DOCUMENTOS CONTI-CISSAC".

    iCount = iCount + 2.
    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Origen".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Division".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Doc".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Número".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cliente".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nombre".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Estado".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Moneda".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldo Actual".
    iCount = iCount + 1.

    chWorkSheet:Columns("B"):NumberFormat = "@".
    chWorkSheet:Columns("E"):NumberFormat = "@".
    chWorkSheet:Columns("F"):NumberFormat = "@".

    DEF VAR x-ImpTotMn AS DEC NO-UNDO.
    DEF VAR x-ImpTotMe AS DEC NO-UNDO.
    DEF VAR x-SdoActMn AS DEC NO-UNDO.
    DEF VAR x-SdoActMe AS DEC NO-UNDO.

    FOR EACH integral.w-report WHERE integral.w-report.task-no = s-task-no NO-LOCK:   
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = integral.w-report.Llave-C.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = integral.w-report.Campo-C[1].
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = integral.w-report.Campo-D[1].
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = integral.w-report.Campo-C[2].
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = integral.w-report.Campo-C[3].
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = integral.w-report.Campo-C[4].
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = integral.w-report.Campo-C[5].
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = integral.w-report.Campo-F[1].
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = integral.w-report.Campo-C[6].
        IF integral.w-report.Campo-I[1] = 1 THEN DO:
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = "S/.".
            x-ImpTotMn = x-ImpTotMn + integral.w-report.Campo-F[1].
            x-SdoActMn = x-SdoActMn + integral.w-report.Campo-F[2].
        END.
        ELSE DO:
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = "$".
            x-ImpTotMe = x-ImpTotMe + integral.w-report.Campo-F[1].
            x-SdoActMe = x-SdoActMe + integral.w-report.Campo-F[2].
        END.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = integral.w-report.Campo-F[2].
        iCount = iCount + 1.
    END.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL S/.".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = x-ImpTotMn.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "SALDO S/.".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = x-SdoActMn.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL US$".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = x-ImpTotMe.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "SALDO US$".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = x-SdoActMe.

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

DEF VAR RB-TITULO AS CHAR FORMAT 'x(100)' NO-UNDO.

RB-TITULO = "DOCUMENTOS EMITIDOS DESDE " + STRING(X-FECHA-1, "99/99/99") +
    " HASTA " + STRING(X-FECHA-2, "99/99/99").

SESSION:SET-WAIT-STATE('general').
RUN Carga-Temporal.
SESSION:SET-WAIT-STATE('').
FIND FIRST integral.w-report WHERE integral.w-report.task-no = s-task-no
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE integral.w-report THEN DO:
    MESSAGE 'NO hay registros que imprimir' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

GET-KEY-VALUE SECTION "Startup" KEY " BASE" VALUE RB-REPORT-LIBRARY.
ASSIGN
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb/rbccb.prl"
    RB-REPORT-NAME = "Cuentas consolidadas ATE CISSAC"
    RB-INCLUDE-RECORDS = "O"
    RB-FILTER = "w-report.task-no = " + STRING(s-task-no)
    RB-OTHER-PARAMETERS = "s-titulo =" + RB-TITULO.

RUN lib/_Imprime2.p ( RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-OTHER-PARAMETERS ).

RUN Borra-temporal.


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
      x-Fecha-1 = TODAY - DAY(TODAY) + 1
      x-Fecha-2 = TODAY.

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

