&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDocu FOR CcbCDocu.



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
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 x-codcli x-CodMat x-desde ~
x-hasta btn-excel btn-exit 
&Scoped-Define DISPLAYED-OBJECTS x-codcli x-nomcli x-CodMat x-DesMat ~
x-desde x-hasta x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-excel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 8 BY 1.62.

DEFINE BUTTON btn-exit 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 2" 
     SIZE 8 BY 1.62.

DEFINE VARIABLE x-codcli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE x-CodMat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Producto" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE x-DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY 1 NO-UNDO.

DEFINE VARIABLE x-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 66.29 BY .88 NO-UNDO.

DEFINE VARIABLE x-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 73 BY 1.88
     BGCOLOR 9 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72.72 BY 5.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-codcli AT ROW 1.38 COL 14 COLON-ALIGNED WIDGET-ID 2
     x-nomcli AT ROW 1.38 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     x-CodMat AT ROW 2.54 COL 14 COLON-ALIGNED WIDGET-ID 20
     x-DesMat AT ROW 2.54 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     x-desde AT ROW 3.69 COL 14 COLON-ALIGNED WIDGET-ID 6
     x-hasta AT ROW 3.69 COL 36 COLON-ALIGNED WIDGET-ID 8
     x-mensaje AT ROW 5.42 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     btn-excel AT ROW 6.81 COL 56.57 WIDGET-ID 10
     btn-exit AT ROW 6.81 COL 65 WIDGET-ID 12
     RECT-1 AT ROW 6.69 COL 1.29 WIDGET-ID 14
     RECT-2 AT ROW 1.12 COL 1.57 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 74.29 BY 7.69 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDocu B "?" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Ventas por Clientes - Detalle"
         HEIGHT             = 7.69
         WIDTH              = 74.29
         MAX-HEIGHT         = 7.69
         MAX-WIDTH          = 74.29
         VIRTUAL-HEIGHT     = 7.69
         VIRTUAL-WIDTH      = 74.29
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN x-DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Ventas por Clientes - Detalle */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ventas por Clientes - Detalle */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-excel W-Win
ON CHOOSE OF btn-excel IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN
        x-codcli
        x-desde
        x-hasta
        x-codmat.
    IF x-CodCli = "" THEN DO:
        MESSAGE 'Puede que la información exceda el límite de registros soportados por el EXCEL' SKIP
            'Continuamos?'
            VIEW-AS ALERT-BOX WARNING
            BUTTONS YES-NO
            TITLE 'AVISO IMPORTANTE'
            UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
    END.
    RUN excel.
    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-exit W-Win
ON CHOOSE OF btn-exit IN FRAME F-Main /* Button 2 */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-codcli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-codcli W-Win
ON LEAVE OF x-codcli IN FRAME F-Main /* Cliente */
DO:

  ASSIGN {&SELF-NAME}.
  FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = {&SELF-NAME} NO-LOCK NO-ERROR.
  IF AVAIL gn-clie THEN DISPLAY gn-clie.nomcli @ x-nomcli WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodMat W-Win
ON LEAVE OF x-CodMat IN FRAME F-Main /* Producto */
DO:
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
      AND Almmmatg.codmat = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN x-DesMat:SCREEN-VALUE = ALmmmatg.desmat.
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
  DISPLAY x-codcli x-nomcli x-CodMat x-DesMat x-desde x-hasta x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 x-codcli x-CodMat x-desde x-hasta btn-excel btn-exit 
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
DEFINE VARIABLE t-Letra                 AS INTEGER.
DEFINE VARIABLE iInt                    AS INTEGER     NO-UNDO.

DEFINE VARIABLE cLetra  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLetra2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE t-col   AS INTEGER   NO-UNDO.

DEFINE VARIABLE dSigno  AS DECIMAL     NO-UNDO.

DEFINE VARIABLE cMoneda AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDesMat AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDesMar AS CHARACTER   NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A3"):Value = "CODMAT".
chWorkSheet:Range("B3"):Value = "DESMAT".
chWorkSheet:Range("C3"):Value = "CODDOC".
chWorkSheet:Range("D3"):Value = "NRODOC".
chWorkSheet:Range("E3"):Value = "CODCLI".
chWorkSheet:Range("F3"):Value = "RAZON SOCIAL".
chWorkSheet:Range("G3"):Value = "FCHDOC".
chWorkSheet:Range("H3"):Value = "UNDVTA".
chWorkSheet:Range("I3"):Value = "CANTIDAD".
chWorkSheet:Range("J3"):Value = "MONEDA".
chWorkSheet:Range("K3"):Value = "IMPORTE".
chWorkSheet:Range("L3"):Value = "GUIA".
chWorkSheet:Range("M3"):Value = "EMISION".
chWorkSheet:Range("N3"):Value = "IMPORTE BRUTO".
chWorkSheet:Range("O3"):Value = "% DSCTO".
chWorkSheet:Range("P3"):Value = "MARCA".

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("D"):NumberFormat = "@".
chWorkSheet:Columns("E"):NumberFormat = "@".
chWorkSheet:Columns("L"):NumberFormat = "@".

FOR EACH ccbcdocu USE-INDEX llave13 NO-LOCK WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.fchdoc >= x-desde
    AND ccbcdocu.fchdoc <= x-hasta
    AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK,N/C,N/D") > 0:
    /* FILTROS */
    IF ccbcdocu.flgest = "A" THEN NEXT.
    IF x-CodCli <> '' AND Ccbcdocu.codcli <> x-CodCli THEN NEXT.
    /* ******* */
    DISPLAY "PROCESANDO: " +  Ccbcdocu.coddoc + "-" + CcbCDocu.NroDoc @ x-mensaje
        WITH FRAME {&FRAME-NAME}.
    FOR EACH ccbddocu OF ccbcdocu NO-LOCK WHERE (x-codmat = "" OR Ccbddocu.codmat = x-codmat):
        cDesMar = "".
        CASE ccbcdocu.coddoc:
            WHEN 'N/C' THEN DO:
                FIND FIRST CcbTabla WHERE CcbTabla.CodCia = s-codcia
                    AND CcbTabla.Tabla  = ccbcdocu.coddoc
                    AND CcbTabla.Codigo = ccbddocu.codmat NO-LOCK NO-ERROR.
                IF AVAIL CcbTabla THEN cDesMat = CcbTabla.Nombre.                
            END.
            OTHERWISE DO:
                FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
                    AND almmmatg.codmat = ccbddocu.codmat NO-LOCK NO-ERROR.
                IF AVAIL almmmatg THEN DO:
                    cDesMat = Almmmatg.DesMat.
                    cDesMar = Almmmatg.DesMar.
                END.
                    
            END.
        END CASE.

        IF CcbCDocu.CodMon = 1 THEN cMoneda = "S/.". ELSE cMoneda = "$".

        IF CcbCDocu.CodDoc = "N/C" THEN dSigno = -1. ELSE dSigno = 1.


        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbDDocu.codmat.     
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = cDesMat.     
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbDDocu.CodDoc.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbDDocu.NroDoc.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbCDocu.CodCli.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbCDocu.NomCli.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbCDocu.FchDoc.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbDDocu.UndVta.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbDDocu.CanDes * dSigno.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = cMoneda.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbDDocu.ImpLin * dSigno.
        IF Ccbcdocu.codref = "G/R" THEN DO:
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = CcbCDocu.NroRef.
            FIND B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
                AND B-CDOCU.coddoc = Ccbcdocu.codref
                AND B-CDOCU.nrodoc = Ccbcdocu.nroref
                NO-LOCK NO-ERROR.
            IF AVAILABLE B-CDOCU THEN DO:
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Value = B-CDOCU.FchDoc.
            END.
        END.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = (CcbDDocu.ImpLin * dSigno) + CcbDDocu.ImpDto * dSigno.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbDDocu.por_dsctos[3].
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = cDesMar.
    END.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/*
FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.codcli BEGINS x-codcli
    AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK,N/C,N/D") > 0
    AND ccbcdocu.fchdoc >= x-desde
    AND ccbcdocu.fchdoc <= x-hasta
    AND ccbcdocu.flgest <> "A",
    EACH ccbddocu OF ccbcdocu NO-LOCK:
    CASE ccbcdocu.coddoc:
        WHEN 'N/C' THEN DO:
            FIND FIRST CcbTabla WHERE CcbTabla.CodCia = s-codcia
                AND CcbTabla.Tabla  = ccbcdocu.coddoc
                AND CcbTabla.Codigo = ccbddocu.codmat NO-LOCK NO-ERROR.
            IF AVAIL CcbTabla THEN cDesMat = CcbTabla.Nombre.
        END.
        OTHERWISE DO:
            FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
                AND almmmatg.codmat = ccbddocu.codmat NO-LOCK NO-ERROR.
            IF AVAIL almmmatg THEN cDesMat = Almmmatg.DesMat.
        END.
    END CASE.

    IF CcbCDocu.CodMon = 1 THEN cMoneda = "S/.". ELSE cMoneda = "$".

    IF CcbCDocu.CodDoc = "N/C" THEN dSigno = -1. ELSE dSigno = 1.

    DISPLAY "PROCESANDO: " +  Ccbcdocu.coddoc + "-" + CcbCDocu.NroDoc @ x-mensaje
        WITH FRAME {&FRAME-NAME}.

    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.codmat.     
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = cDesMat.     
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.CodDoc.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.NroDoc.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbCDocu.CodCli.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbCDocu.NomCli.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbCDocu.FchDoc.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.UndVta.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.CanDes * dSigno.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = cMoneda.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.PreUni * dSigno.
    IF Ccbcdocu.codref = "G/R" THEN DO:
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbCDocu.NroRef.
        FIND B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
            AND B-CDOCU.coddoc = Ccbcdocu.codref
            AND B-CDOCU.nrodoc = Ccbcdocu.nroref
            NO-LOCK NO-ERROR.
        IF AVAILABLE B-CDOCU THEN DO:
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = B-CDOCU.FchDoc.
        END.
    END.
END.
*/

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
          x-hasta = TODAY
          x-desde = (TODAY - DAY(TODAY) + 1).
  END.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
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

