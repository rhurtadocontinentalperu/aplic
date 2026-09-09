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
DEFINE VARIABLE cFlgEst AS CHARACTER   NO-UNDO.
DEFINE VARIABLE S-TITULO AS CHARACTER   NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS F-DIVISION BUTTON-5 txt-codcli txt-codven ~
DesdeF HastaF rs-docs rs-flgest Btn_OK Btn_Cancel RECT-64 RECT-65 
&Scoped-Define DISPLAYED-OBJECTS F-DIVISION txt-codcli txt-nomcli ~
txt-codven x-nomven DesdeF HastaF rs-docs rs-flgest txt-msj 

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
     SIZE 11 BY 1.88
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.88
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

DEFINE VARIABLE txt-codven AS CHARACTER FORMAT "X(3)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 57 BY .81 NO-UNDO.

DEFINE VARIABLE txt-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-nomven AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE rs-docs AS CHARACTER INITIAL "T" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", "T",
"Cotizacion", "C",
"Pedidos", "P",
"O/D", "O"
     SIZE 17 BY 2.81 NO-UNDO.

DEFINE VARIABLE rs-flgest AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Atenciones", "T",
"Pendientes", "P",
"Cerrados", "X",
"Anuladas", "A"
     SIZE 12 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 10.12.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13.72 BY 10.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-DIVISION AT ROW 1.54 COL 9 COLON-ALIGNED WIDGET-ID 6
     BUTTON-5 AT ROW 1.54 COL 22 WIDGET-ID 2
     txt-codcli AT ROW 2.46 COL 9 COLON-ALIGNED WIDGET-ID 24
     txt-nomcli AT ROW 2.46 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     txt-codven AT ROW 3.42 COL 9 COLON-ALIGNED WIDGET-ID 38
     x-nomven AT ROW 3.42 COL 15.43 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     DesdeF AT ROW 4.5 COL 9 COLON-ALIGNED WIDGET-ID 4
     HastaF AT ROW 4.5 COL 25 COLON-ALIGNED WIDGET-ID 8
     rs-docs AT ROW 6.38 COL 11 NO-LABEL WIDGET-ID 12
     rs-flgest AT ROW 6.38 COL 40 NO-LABEL WIDGET-ID 32
     Btn_OK AT ROW 2.08 COL 68 WIDGET-ID 22
     Btn_Cancel AT ROW 4.23 COL 68 WIDGET-ID 20
     txt-msj AT ROW 9.88 COL 4 NO-LABEL WIDGET-ID 16
     "Documentos:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 5.58 COL 4 WIDGET-ID 28
     "Estado Docs:" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 5.58 COL 32 WIDGET-ID 30
     RECT-64 AT ROW 1.12 COL 2 WIDGET-ID 10
     RECT-65 AT ROW 1.15 COL 67 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.72 BY 10.46
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
         TITLE              = "COTIZACIONES Y PEDIDOS"
         HEIGHT             = 10.46
         WIDTH              = 80.72
         MAX-HEIGHT         = 10.46
         MAX-WIDTH          = 80.72
         VIRTUAL-HEIGHT     = 10.46
         VIRTUAL-WIDTH      = 80.72
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
/* SETTINGS FOR FILL-IN x-nomven IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* COTIZACIONES Y PEDIDOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* COTIZACIONES Y PEDIDOS */
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
  
    ASSIGN F-DIVISION DesdeF HastaF rs-docs txt-codcli rs-flgest
        txt-codven.
    /*Tipo de Documentos*/
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
    
    /*Estado de Documentos*/
    CASE rs-flgest:
        /*WHEN "T" THEN ASSIGN cFlgEst = "P,C,A".*/
        WHEN "T" THEN ASSIGN cFlgEst = "P,C,X".
        WHEN "P" THEN ASSIGN cFlgEst = "P".
        WHEN "X" THEN ASSIGN cFlgEst = "X".
        WHEN "A" THEN ASSIGN cFlgEst = "A".
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
      AND gn-clie.codcli = txt-codcli:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      NO-LOCK NO-ERROR.
  IF AVAIL gn-clie 
      THEN DISPLAY gn-clie.nomcli @ txt-nomcli WITH FRAME {&FRAME-NAME}.
  ELSE DISPLAY "" @ txt-nomcli WITH FRAME {&FRAME-NAME}.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-codven
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-codven W-Win
ON LEAVE OF txt-codven IN FRAME F-Main /* Vendedor */
DO:
    FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = txt-codcli:SCREEN-VALUE IN FRAME {&FRAME-NAME}
        NO-LOCK NO-ERROR.
    IF AVAIL gn-ven 
        THEN DISPLAY gn-ven.nomven @ x-nomven WITH FRAME {&FRAME-NAME}.
    ELSE DISPLAY "" @ x-nomven WITH FRAME {&FRAME-NAME}.  
      
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
  DISPLAY F-DIVISION txt-codcli txt-nomcli txt-codven x-nomven DesdeF HastaF 
          rs-docs rs-flgest txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE F-DIVISION BUTTON-5 txt-codcli txt-codven DesdeF HastaF rs-docs 
         rs-flgest Btn_OK Btn_Cancel RECT-64 RECT-65 
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
    DEFINE VARIABLE cEstado            AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE dImpLin AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE cDesMat AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cDesMar AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cCodFam AS CHARACTER   NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).    

    /*Formato*/
    chWorkSheet:Columns("B"):NumberFormat = "@".    
    chWorkSheet:Columns("C"):NumberFormat = "@".    
    chWorkSheet:Columns("H"):NumberFormat = "@".    
    chWorkSheet:Columns("I"):NumberFormat = "@".    
    chWorkSheet:Columns("P"):NumberFormat = "@".    

    /*Cabecera*/
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = S-TITULO.

    iCount = iCount + 3.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Documento".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Número".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cliente".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Apellidos y Nombres".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Emision".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Entrega".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Vencimiento".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Vendedor".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Articulo".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descripcion".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Marca".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cant. Pedida".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cant. Atendida".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Diferencia".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe Tot".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "Familia".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "Estado".

    DEF VAR k AS INT.
    DEF VAR x-CodDoc AS CHAR.

    DO k = 1 TO NUM-ENTRIES(cCodDoc):
        x-CodDoc = ENTRY(k, cCodDoc).
        FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia
            AND faccpedi.coddiv = f-division
            AND faccpedi.coddoc = x-CodDoc
            AND (faccpedi.codcli BEGINS txt-codcli OR txt-codcli = "")
            AND faccpedi.codven BEGINS txt-codven
            AND faccpedi.fchped >= DesdeF
            AND faccpedi.fchped <= HastaF
            AND LOOKUP(faccpedi.flgest,cFlgEst) > 0 NO-LOCK,
            EACH facdpedi OF faccpedi NO-LOCK:
            FIND FIRST almmmatg WHERE almmmatg.codcia = faccpedi.codcia
                AND almmmatg.codmat = facdpedi.codmat NO-LOCK NO-ERROR.
            IF AVAIL almmmatg THEN
                ASSIGN 
                    cDesMat = almmmatg.desmat
                    cDesMar = almmmatg.desmar
                    cCodFam = almmmatg.codfam.
            ELSE 
                ASSIGN 
                    cDesMat = ''
                    cDesMar = ''
                    cCodFam = ''.

            CASE faccpedi.flgest:
                WHEN "P" THEN cEstado = "Pendiente".
                WHEN "C" THEN cEstado = "Atendido".
                WHEN "A" THEN cEstado = "Anulado".
                WHEN "X" THEN cEstado = "Cerrado".
            END CASE.

            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = faccpedi.coddoc.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = faccpedi.nroped.
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = faccpedi.codcli.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = faccpedi.NomCli.
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = faccpedi.fchped.
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = faccpedi.fchent.
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = faccpedi.fchven.
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = faccpedi.codven.
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = facdpedi.codmat.
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = cDesMat.
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = cDesMar.
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = facdpedi.canped.
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = facdpedi.canate.
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = facdpedi.canped - facdpedi.canate.
            cRange = "O" + cColumn.
            chWorkSheet:Range(cRange):Value = facdpedi.implin.
            cRange = "P" + cColumn.
            chWorkSheet:Range(cRange):Value = cCodFam.
            cRange = "Q" + cColumn.
            chWorkSheet:Range(cRange):Value = cEstado.
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

