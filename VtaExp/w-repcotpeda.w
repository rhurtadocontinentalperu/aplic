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

DEFINE TEMP-TABLE tt-tabla
    FIELDS t-coddoc LIKE faccpedi.coddoc
    FIELDS t-nroped LIKE faccpedi.nroped
    FIELDS t-codcli LIKE faccpedi.codcli
    FIELDS t-nomcli LIKE faccpedi.NomCli
    FIELDS t-fchped LIKE faccpedi.fchped
    FIELDS t-fchent LIKE faccpedi.fchent
    FIELDS t-fchven LIKE faccpedi.fchven
    FIELDS t-codven LIKE faccpedi.codven
    FIELDS t-codmat LIKE facdpedi.codmat
    FIELDS t-desmat LIKE almmmatg.desmat
    FIELDS t-desmar LIKE almmmatg.desmar
    FIELDS t-canped LIKE facdpedi.canped
    FIELDS t-canate LIKE facdpedi.canate
    FIELDS t-codfam LIKE Almmmatg.codfam
    FIELDS t-subfam LIKE almmmatg.subfam
    FIELDS t-implin LIKE FacDPedi.ImpLin
    FIELDS t-codmon AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS r-1 F-DIVISION BUTTON-5 txt-codcli f-ven ~
DesdeF HastaF Btn_OK Btn_Cancel RECT-64 RECT-65 
&Scoped-Define DISPLAYED-OBJECTS r-1 F-DIVISION txt-codcli txt-nomcli f-ven ~
txt-nomven DesdeF HastaF txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img/exit.ico":U
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

DEFINE VARIABLE f-ven AS CHARACTER FORMAT "X(3)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .77 NO-UNDO.

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
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE txt-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.72 BY .81 NO-UNDO.

DEFINE VARIABLE txt-nomven AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.72 BY .81 NO-UNDO.

DEFINE VARIABLE r-1 AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Resumen", "R",
"Detalle", "D"
     SIZE 21 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 8.5.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18 BY 8.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     r-1 AT ROW 6.5 COL 11 NO-LABEL WIDGET-ID 32
     F-DIVISION AT ROW 1.81 COL 8.29 COLON-ALIGNED WIDGET-ID 6
     BUTTON-5 AT ROW 1.81 COL 21.29 WIDGET-ID 2
     txt-codcli AT ROW 2.88 COL 8.29 COLON-ALIGNED WIDGET-ID 24
     txt-nomcli AT ROW 2.88 COL 19.29 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     f-ven AT ROW 4 COL 8.29 COLON-ALIGNED WIDGET-ID 28
     txt-nomven AT ROW 3.96 COL 15 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     DesdeF AT ROW 5.08 COL 8.29 COLON-ALIGNED WIDGET-ID 4
     HastaF AT ROW 5.08 COL 24 COLON-ALIGNED WIDGET-ID 8
     Btn_OK AT ROW 2.08 COL 65.72 WIDGET-ID 22
     Btn_Cancel AT ROW 4.19 COL 65.72 WIDGET-ID 20
     txt-msj AT ROW 8.27 COL 3 NO-LABEL WIDGET-ID 16
     RECT-64 AT ROW 1.12 COL 2 WIDGET-ID 10
     RECT-65 AT ROW 1.15 COL 62.72 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.29 BY 9.04
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
         TITLE              = "Reporte Resumen de Cotizaciones"
         HEIGHT             = 9.04
         WIDTH              = 81.29
         MAX-HEIGHT         = 9.04
         MAX-WIDTH          = 99.72
         VIRTUAL-HEIGHT     = 9.04
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
/* SETTINGS FOR FILL-IN txt-nomven IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte Resumen de Cotizaciones */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte Resumen de Cotizaciones */
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
  
    ASSIGN F-DIVISION DesdeF HastaF txt-codcli f-ven r-1.

    S-TITULO = S-TITULO + "PENDIENTES POR ATENDER.".
    txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.
    CASE r-1:
        WHEN "R" THEN RUN ExcelR.
        WHEN "D" THEN RUN Excel.
    END CASE.    
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


&Scoped-define SELF-NAME f-ven
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-ven W-Win
ON LEAVE OF f-ven IN FRAME F-Main /* Vendedor */
DO:
    ASSIGN f-ven.
    FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = f-ven:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAIL gn-ven THEN DISPLAY gn-ven.nomven @ txt-nomven WITH FRAME {&FRAME-NAME}.
    
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

ON 'RETURN':U OF f-division,txt-codcli,DesdeF,HastaF
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Data W-Win 
PROCEDURE Carga-Data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia
        AND faccpedi.coddiv = f-division
        AND faccpedi.coddoc = "COT"
        AND (faccpedi.codcli BEGINS txt-codcli 
        OR txt-codcli = "")
        AND faccpedi.fchped >= DesdeF
        AND faccpedi.fchped <= HastaF
        AND faccpedi.codven BEGINS f-ven
        AND LOOKUP(faccpedi.flgest,"C,P,E") > 0 NO-LOCK,
        EACH facdpedi OF faccpedi NO-LOCK
        BREAK BY faccpedi.coddoc
        BY faccpedi.nroped:
        
        FIND FIRST almmmatg WHERE almmmatg.codcia = faccpedi.codcia
            AND almmmatg.codmat = facdpedi.codmat NO-LOCK NO-ERROR.        

        CREATE tt-tabla.
        ASSIGN
            t-coddoc = faccpedi.coddoc 
            t-nroped = faccpedi.nroped 
            t-codcli = faccpedi.codcli 
            t-nomcli = faccpedi.NomCli 
            t-fchped = faccpedi.fchped 
            t-fchent = faccpedi.fchent 
            t-fchven = faccpedi.fchven 
            t-codven = faccpedi.codven 
            t-codmat = facdpedi.codmat 
            t-desmat = almmmatg.desmat 
            t-desmar = almmmatg.desmar 
            t-canped = facdpedi.canped 
            t-canate = facdpedi.canate 
            t-codfam = Almmmatg.codfam 
            t-subfam = almmmatg.subfam.
        IF FacCPedi.CodMon = 2 THEN t-implin = FacDPedi.ImpLin * FacCPedi.TpoCmb.
        ELSE t-implin = FacDPedi.ImpLin.
        /*
        IF faccpedi.codmon = 1 THEN t-codmon = "S/.". 
            ELSE  t-codmon = "$.".
        */    
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
  DISPLAY r-1 F-DIVISION txt-codcli txt-nomcli f-ven txt-nomven DesdeF HastaF 
          txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE r-1 F-DIVISION BUTTON-5 txt-codcli f-ven DesdeF HastaF Btn_OK 
         Btn_Cancel RECT-64 RECT-65 
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

    DEFINE VARIABLE dCanAte            AS DECIMAL     NO-UNDO.

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
    chWorkSheet:Columns("O"):NumberFormat = "@".    
    chWorkSheet:Columns("P"):NumberFormat = "@".    
    chWorkSheet:Columns("Q"):NumberFormat = "@".    

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
    /*
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Emision".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Entrega".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Vencimiento".
    */
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Vendedor".
    /*
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Moneda".
    */
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
    chWorkSheet:Range(cRange):Value = "Familia".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "SubFam".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe".

    iCount = iCount + 1.

    FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia
        AND faccpedi.coddiv = f-division
        AND faccpedi.coddoc = "COT"
        AND (faccpedi.codcli BEGINS txt-codcli 
        OR txt-codcli = "")
        AND faccpedi.fchped >= DesdeF
        AND faccpedi.fchped <= HastaF
        AND faccpedi.codven BEGINS f-ven
        AND lookup(faccpedi.flgest,"C,E,P") > 0 NO-LOCK,
        EACH facdpedi OF faccpedi NO-LOCK
        BREAK BY faccpedi.coddoc
        BY faccpedi.nroped:
        
        FIND FIRST almmmatg WHERE almmmatg.codcia = faccpedi.codcia
            AND almmmatg.codmat = facdpedi.codmat NO-LOCK NO-ERROR.

        IF FacDPedi.CanAte < 0 THEN dCanAte = 0.
        ELSE dCanAte = FacDPedi.CanAte.
                                                                    
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
        /*
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.fchped.        
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.fchent.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.fchven.
        */
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.codven.
        /*
        IF faccpedi.codmon = 1 THEN DO:
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = "S/.".
        END.
        ELSE DO:
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = "$.".
        END.
        */
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = facdpedi.codmat.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = almmmatg.desmat.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = almmmatg.desmar.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = facdpedi.canped.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = dCanAte.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = facdpedi.canped - facdpedi.canate.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = Almmmatg.codfam.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = almmmatg.subfam.
        cRange = "Q" + cColumn.
        IF FacCPedi.CodMon = 2 THEN
            chWorkSheet:Range(cRange):Value = FacDPedi.ImpLin * FacCPedi.TpoCmb.
        ELSE 
            chWorkSheet:Range(cRange):Value = FacDPedi.ImpLin.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExcelR W-Win 
PROCEDURE ExcelR :
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

    RUN Carga-Data.

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
    chWorkSheet:Columns("L"):NumberFormat = "@".    
    chWorkSheet:Columns("M"):NumberFormat = "@".    

    /*Cabecera*/
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "RESUMEN COTIZACIONES".

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
    /*
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Moneda".    
    */
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cant. Pedida".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cant. Atendida".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Diferencia".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Familia".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "SubFam".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe".

    iCount = iCount + 1.

    FOR EACH tt-tabla NO-LOCK 
        BREAK BY t-coddoc
        BY t-nroped BY t-subfam:

        ACCUMULATE t-canped (SUB-TOTAL BY t-subfam). 
        ACCUMULATE t-canate (SUB-TOTAL BY t-subfam).
        ACCUMULATE (t-canped - t-canate) (SUB-TOTAL BY t-subfam).
        ACCUMULATE t-ImpLin (SUB-TOTAL BY t-subfam).

        IF LAST-OF(t-subfam) THEN DO:
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = t-coddoc.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = t-nroped.
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = t-codcli.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = t-NomCli.
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = t-fchped.
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = t-fchent.
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = t-fchven.
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = t-codven.
            /*
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = t-codmon.
            */
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY t-subfam t-canped.
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY t-subfam t-canate.
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY t-subfam (t-canped - t-canate).
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = t-codfam.
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = t-subfam.
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY t-subfam t-implin.
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

