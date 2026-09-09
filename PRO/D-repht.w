&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHAR.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

/*******/

/* Local Variable Definitions ---                                       */
DEFINE VAR C-DESMOV      AS CHAR NO-UNDO.
DEFINE VAR C-OP          AS CHAR NO-UNDO.
DEFINE VAR X-PROCEDENCIA AS CHAR NO-UNDO.
DEFINE VAR x-codmov      AS CHAR NO-UNDO.
DEFINE VAR X-CODPRO      AS CHAR NO-UNDO.

DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
DEFINE VAR x-titulo2 AS CHAR NO-UNDO.
DEFINE VAR x-tipmov  AS CHAR NO-UNDO.
DEFINE VAR x-desmat  AS CHAR NO-UNDO.
DEFINE VAR x-desmar  AS CHAR NO-UNDO.
DEFINE VAR x-flgest  AS CHAR NO-UNDO.
DEFINE VAR X-Movi    AS CHAR NO-UNDO.

DEFINE TEMP-TABLE T-resume 
       FIELD CodPer LIKE Pl-PERS.CodPer
       FIELD DesPer AS CHAR FORMAT "X(45)"
       FIELD TotHor AS DECI EXTENT 10 FORMAT "->>>,>>9.99"
       FIELD Factor AS DECI EXTENT 10 FORMAT "->>9.99" .

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
&Scoped-Define ENABLED-OBJECTS RECT-62 RECT-60 F-Orden desdeF hastaF ~
Btn_OK-2 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-Orden desdeF hastaF x-mensaje 

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
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE desdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-Orden AS CHARACTER FORMAT "X(6)":U 
     LABEL "Orden" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE hastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51.14 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53 BY 1.77.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53 BY 4.65.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Orden AT ROW 2.27 COL 8.29 COLON-ALIGNED
     desdeF AT ROW 3.31 COL 8.29 COLON-ALIGNED
     hastaF AT ROW 3.31 COL 27.57 COLON-ALIGNED
     x-mensaje AT ROW 4.77 COL 2.86 NO-LABEL WIDGET-ID 4
     Btn_OK-2 AT ROW 6 COL 19.72 WIDGET-ID 2
     Btn_OK AT ROW 6 COL 31
     Btn_Cancel AT ROW 6 COL 42.57
     RECT-62 AT ROW 1.19 COL 1.72
     RECT-60 AT ROW 5.88 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 55.43 BY 7.08
         FONT 4.


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
         TITLE              = "Horas Trabajadas X Orden de Produccion"
         HEIGHT             = 7.08
         WIDTH              = 55.43
         MAX-HEIGHT         = 7.08
         MAX-WIDTH          = 55.43
         VIRTUAL-HEIGHT     = 7.08
         VIRTUAL-WIDTH      = 55.43
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
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
ON END-ERROR OF W-Win /* Horas Trabajadas X Orden de Produccion */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Horas Trabajadas X Orden de Produccion */
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
  ASSIGN DesdeF HastaF F-Orden.
 
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK-2 W-Win
ON CHOOSE OF Btn_OK-2 IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN DesdeF HastaF F-Orden.
 
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Excel.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Orden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Orden W-Win
ON LEAVE OF F-Orden IN FRAME F-Main /* Orden */
DO:
   
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").

   F-ORDEN = SELF:SCREEN-VALUE .   

   FIND PR-ODPC WHERE PR-ODPC.CodCia = S-CODCIA 
                  AND PR-ODPC.NumOrd = F-Orden
                  NO-LOCK NO-ERROR.
   IF NOT AVAILABLE PR-ODPC THEN DO:
      MESSAGE "Orden de produccion No existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-Orden.
      RETURN NO-APPLY.   
   END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN DesdeF HastaF F-Orden .

  x-titulo2 = "ORDEN DE PRODUCCION No " + F-ORDEN.
  x-titulo1 = 'ANALISIS DE HORAS X ORDEN DE PRODUCCION'.

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
  DISPLAY F-Orden desdeF hastaF x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-62 RECT-60 F-Orden desdeF hastaF Btn_OK-2 Btn_OK Btn_Cancel 
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
  
  DEFINE VAR X-DIAS AS INTEGER INIT 208.
  DEFINE VAR I AS INTEGER.
  DEFINE VAR F-STKGEN AS DECI .
  DEFINE VAR F-VALCTO AS DECI .
  DEFINE VAR F-PRECIO AS DECI.
  DEFINE VAR F-TOTAL AS DECI.
  DEFINE VAR X-DESPER  AS CHAR FORMAT "X(35)".
  DEFINE VAR X-HORAI AS DECI .
  DEFINE VAR X-SEGI AS DECI .
  DEFINE VAR X-SEGF AS DECI .
  DEFINE VAR X-IMPHOR AS DECI FORMAT ">>>9.99".
  DEFINE VAR X-BASE   AS DECI .
  DEFINE VAR X-HORMEN AS DECI .
  DEFINE VAR X-FACTOR AS DECI .
  
  DEFINE VAR X-HORA AS DECI EXTENT 10 FORMAT ">>>9.99".
  DEFINE VAR X-TOTA AS DECI EXTENT 10 FORMAT ">>>>>9.99".
  
  DEFINE VAR X-TOT1 AS DECI.
  DEFINE VAR X-TOT2 AS DECI.
  DEFINE VAR X-TOT3 AS DECI.
  DEFINE VAR X-TOT4 AS DECI.
  DEFINE VAR X-TOT5 AS DECI.
  DEFINE VAR X-TOT6 AS DECI.
  DEFINE VAR X-TOT10 AS DECI.

  DEFINE VAR cCodMaq AS CHAR FORMAT 'X(50)'.
  DEFINE VAR cObser  AS CHAR.
  /* create a new Excel Application object */
  CREATE "Excel.Application" chExcelApplication.
  
  /* create a new Workbook */
  chWorkbook = chExcelApplication:Workbooks:Add().
  
  /* get the active Worksheet */
  chWorkSheet = chExcelApplication:Sheets:Item(1).

  chWorkSheet:Range("D2"):Value = "ANALISIS DE HORAS X ORDEN DE PRODUCCION".

  chWorkSheet:Range("A3"):Value = "Nro. OP".
  chWorkSheet:Range("B3"):Value = "Fecha".
  chWorkSheet:Range("C3"):Value = "Cod Per".
  chWorkSheet:Range("D3"):Value = "Nombres y Apellidos".
  chWorkSheet:Range("E3"):Value = "Hora Inicio".
  chWorkSheet:Range("F3"):Value = "Hora Fin".
  chWorkSheet:Range("G3"):Value = "M01".
  chWorkSheet:Range("H3"):Value = "M02".
  chWorkSheet:Range("I3"):Value = "M03".
  chWorkSheet:Range("J3"):Value = "M04".
  chWorkSheet:Range("K3"):Value = "M05".
  chWorkSheet:Range("L3"):Value = "M06".
  chWorkSheet:Range("M3"):Value = "Valor".
  chWorkSheet:Range("N3"):Value = "Costo".
  chWorkSheet:Range("O3"):Value = "Maquina".
  chWorkSheet:Range("P3"):Value = "Observaciones".

  FOR EACH PR-MOV-MES NO-LOCK WHERE PR-MOV-MES.CodCia = S-CODCIA AND  
      PR-MOV-MES.NumOrd BEGINS F-Orden  AND
      PR-MOV-MES.FchReg >= DesdeF  AND  
      PR-MOV-MES.FchReg <= HastaF 
      BREAK BY PR-MOV-MES.NumOrd
      BY PR-MOV-MES.FchReg
      BY PR-MOV-MES.CodPer :

      DISPLAY "Codigo de Personal: " + PR-MOV-MES.CodPer @ x-mensaje
          WITH FRAME {&FRAME-NAME}.

      FIND PL-PERS WHERE Pl-PERS.Codper = PR-MOV-MES.CodPer NO-LOCK NO-ERROR.
      X-DESPER = "".
      IF AVAILABLE Pl-PERS THEN 
          X-DESPER = TRIM(PL-PERS.PatPer) + " " + TRIM(PL-PERS.MatPer) + " " + TRIM(PL-PERS.NomPer).
      X-HORAI  = PR-MOV-MES.HoraI.
      X-HORA   = 0.
      X-IMPHOR = 0.
      X-TOTA   = 0.
      X-BASE   = 0.
      X-HORMEN = 0.
      X-FACTOR = 0.
      
      FOR EACH PL-MOV-MES WHERE
          PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND
          PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND
          PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND
          PL-MOV-MES.CodPln  = 01 AND
          PL-MOV-MES.Codcal  = 0 AND
          PL-MOV-MES.CodPer = PR-MOV-MES.CodPer AND
          (PL-MOV-MES.CodMov = 101 OR PL-MOV-MES.CodMov = 103):
          X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                     
      END.

      FIND LAST PL-VAR-MES WHERE
          PL-VAR-MES.Periodo = PR-MOV-MES.Periodo AND
          PL-VAR-MES.NroMes  = PR-MOV-MES.NroMes  NO-ERROR.

      IF AVAILABLE PL-VAR-MES THEN 
          ASSIGN
            X-HORMEN = PL-VAR-MES.ValVar-MES[11]
            X-FACTOR = PL-VAR-MES.ValVar-MES[12] + PL-VAR-MES.ValVar-MES[13] + PL-VAR-MES.ValVar-MES[3] + PL-VAR-MES.ValVar-MES[5] + PL-VAR-MES.ValVar-MES[10].
      X-IMPHOR = (X-BASE / X-HORMEN) * ( 1 + (X-FACTOR / 100) ) / 60.


      FOR EACH PR-CFGPL NO-LOCK WHERE PR-CFGPL.Codcia = S-CODCIA:
          IF X-HORAI >= PR-CFGPL.HoraI AND X-HORAI < PR-CFGPL.HoraF THEN DO:
              IF PR-MOV-MES.HoraF <= PR-CFGPL.HoraF THEN DO:
                  X-SEGF = TRUNCATE(PR-MOV-MES.HoraF,0) * 60 + (PR-MOV-MES.HoraF - TRUNCATE(PR-MOV-MES.HoraF,0)) * 100 . 
                  X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 . 
                  X-HORA[PR-CFGPL.Nroitm] = X-HORA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) .                 
                  X-TOTA[PR-CFGPL.Nroitm] = X-TOTA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                  X-TOTA[10] = X-TOTA[10] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                  LEAVE.
              END.
              IF PR-MOV-MES.HoraF > PR-CFGPL.HoraF THEN DO:
                  X-SEGF = TRUNCATE(PR-CFGPL.HoraF,0) * 60 + (PR-CFGPL.HoraF - TRUNCATE(PR-CFGPL.HoraF,0)) * 100 . 
                  X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 . 
                  X-HORA[PR-CFGPL.Nroitm] = X-HORA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) .                 
                  X-TOTA[PR-CFGPL.Nroitm] = X-TOTA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                  X-TOTA[10] = X-TOTA[10] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                  X-HORAI = PR-CFGPL.HoraF.
              END.
          END.
      END.               
      X-IMPHOR = X-IMPHOR * 60 .   

      /*Busca Orden de Produccion*/
      cCodMaq = ''.
      cObser = ''.
      FIND FIRST pr-odpc WHERE pr-odpc.codcia = s-codcia
          AND pr-odpc.numord = PR-MOV-MES.NumOrd NO-LOCK NO-ERROR.
      IF AVAIL pr-odpc THEN DO:
          cCodMaq = pr-odpc.codmaq.
          cObser  = REPLACE(pr-odpc.observ[1],CHR(10),' ').
          FIND LprMaqui WHERE LprMaqui.codcia = s-codcia
              AND LprMaqui.CodMaq = cCodMaq NO-LOCK NO-ERROR.
          IF AVAILABLE LprMaqui THEN cCodMaq = cCodMaq + '-' + LPRMAQUI.DesPro.
      END.
      /***/
      t-column = t-column + 1.
      cColumn = STRING(t-Column).
      cRange = "A" + cColumn.
      chWorkSheet:Range(cRange):Value = "'" + PR-MOV-MES.NumOrd.
      cRange = "B" + cColumn.
      chWorkSheet:Range(cRange):Value = PR-MOV-MES.FchReg.
      cRange = "C" + cColumn.
      chWorkSheet:Range(cRange):Value = "'" + PR-MOV-MES.CodPer.
      cRange = "D" + cColumn.
      chWorkSheet:Range(cRange):Value = X-DESPER.
      cRange = "E" + cColumn.
      chWorkSheet:Range(cRange):Value = PR-MOV-MES.HoraI.
      cRange = "F" + cColumn.
      chWorkSheet:Range(cRange):Value = PR-MOV-MES.HoraF.
      cRange = "G" + cColumn.
      chWorkSheet:Range(cRange):Value = X-HORA[1].
      cRange = "H" + cColumn.
      chWorkSheet:Range(cRange):Value = X-HORA[2].
      cRange = "I" + cColumn.
      chWorkSheet:Range(cRange):Value = X-HORA[3].
      cRange = "J" + cColumn.
      chWorkSheet:Range(cRange):Value = X-HORA[4].      
      cRange = "K" + cColumn.
      chWorkSheet:Range(cRange):Value = X-HORA[5].
      cRange = "L" + cColumn.
      chWorkSheet:Range(cRange):Value = X-HORA[6].
      cRange = "M" + cColumn.
      chWorkSheet:Range(cRange):Value = X-IMPHOR.
      cRange = "N" + cColumn.
      chWorkSheet:Range(cRange):Value = X-TOTA[10].
      cRange = "O" + cColumn.
      chWorkSheet:Range(cRange):Value = cCodMaq.
      cRange = "P" + cColumn.
      chWorkSheet:Range(cRange):Value = cObser.


      X-TOT1   =  X-TOT1 + X-HORA[1].
      X-TOT2   =  X-TOT2 + X-HORA[2].
      X-TOT3   =  X-TOT3 + X-HORA[3].
      X-TOT4   =  X-TOT4 + X-HORA[4].
      X-TOT5   =  X-TOT5 + X-HORA[5].
      X-TOT6   =  X-TOT6 + X-HORA[6].
      X-TOT10  =  X-TOT10 + X-TOTA[10].

      IF LAST(PR-MOV-MES.NumOrd) THEN DO:
          t-column = t-column + 1.
          cColumn = STRING(t-Column).
          cRange = "F" + cColumn.
          chWorkSheet:Range(cRange):Value = "Total".
          cRange = "G" + cColumn.
          chWorkSheet:Range(cRange):Value = X-TOT1.
          cRange = "H" + cColumn.
          chWorkSheet:Range(cRange):Value = X-TOT2.
          cRange = "I" + cColumn.
          chWorkSheet:Range(cRange):Value = X-TOT3.
          cRange = "J" + cColumn.
          chWorkSheet:Range(cRange):Value = X-TOT4.      
          cRange = "K" + cColumn.
          chWorkSheet:Range(cRange):Value = X-TOT5.
          cRange = "L" + cColumn.
          chWorkSheet:Range(cRange):Value = X-TOT6.
          cRange = "N" + cColumn.
          chWorkSheet:Range(cRange):Value = X-TOT10.
      END.
  END.  
  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH T-resume:
      DELETE T-Resume.
  END.
  DEFINE VAR X-DIAS AS INTEGER INIT 208.
  DEFINE VAR I AS INTEGER.
  DEFINE VAR F-STKGEN AS DECI .
  DEFINE VAR F-VALCTO AS DECI .
  DEFINE VAR F-PRECIO AS DECI.
  DEFINE VAR F-TOTAL AS DECI.
  DEFINE VAR X-DESPER  AS CHAR FORMAT "X(35)".
  DEFINE VAR X-HORAI AS DECI .
  DEFINE VAR X-SEGI AS DECI .
  DEFINE VAR X-SEGF AS DECI .
  DEFINE VAR X-IMPHOR AS DECI FORMAT ">>>9.99".
  DEFINE VAR X-BASE   AS DECI .
  DEFINE VAR X-HORMEN AS DECI .
  DEFINE VAR X-FACTOR AS DECI .
  
  DEFINE VAR X-HORA AS DECI EXTENT 10 FORMAT ">>>9.99".
  DEFINE VAR X-TOTA AS DECI EXTENT 10 FORMAT ">>>>>9.99".
  
  DEFINE VAR X-TOT1 AS DECI.
  DEFINE VAR X-TOT2 AS DECI.
  DEFINE VAR X-TOT3 AS DECI.
  DEFINE VAR X-TOT4 AS DECI.
  DEFINE VAR X-TOT5 AS DECI.
  DEFINE VAR X-TOT6 AS DECI.
  DEFINE VAR X-TOT10 AS DECI.
  



  DEFINE FRAME FC4-REP
          T-resume.codper COLUMN-LABEL "Articulo"
          T-resume.desper FORMAT "X(35)" COLUMN-LABEL "Descripcion"
          T-resume.tothor[1] FORMAT ">>,>>>,>>9.99" COLUMN-LABEL "Cantidad!Procesada"
        WITH WIDTH 250 NO-BOX NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME FD-REP
        PR-MOV-MES.CodPer AT 10
        X-DESPER          AT 18
        PR-MOV-MES.HoraI  AT 55
        PR-MOV-MES.HoraF  AT 65
        X-HORA[1]         AT 75
        X-HORA[2]         AT 85
        X-HORA[3]         AT 95
        X-HORA[4]         AT 105
        X-HORA[5]         AT 115
        X-HORA[6]         AT 125
        X-IMPHOR          AT 135
        X-TOTA[10]        AT 145
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 



  DEFINE FRAME H-REP
         HEADER
         S-NOMCIA FORMAT "X(45)" SKIP
         x-titulo1 AT 45 FORMAT "X(35)"
         "Pag.  : " AT 115 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         "Desde : " AT 045 FORMAT "X(10)" STRING(DESDEF,"99/99/9999") FORMAT "X(10)" "Al" STRING(HASTAF,"99/99/9999") FORMAT "X(12)"
         "Fecha : " AT 115 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
         "--------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                              M   I   N   U   T   O   S     T  R  A  B  A  J  A  D     Valor     Importe" SKIP
         "          Codigo      Nombre                         Hora I.   Hora F.        01        02        03        04        05        06     Hora       Total " SKIP
         "--------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

       FOR EACH PR-MOV-MES NO-LOCK WHERE PR-MOV-MES.CodCia = S-CODCIA AND  
                                         PR-MOV-MES.NumOrd BEGINS F-Orden  AND
                                         PR-MOV-MES.FchReg >= DesdeF  AND  
                                         PR-MOV-MES.FchReg <= HastaF 
                                         BREAK BY PR-MOV-MES.NumOrd
                                               BY PR-MOV-MES.FchReg
                                               BY PR-MOV-MES.CodPer :
       
        /*
          DISPLAY PR-MOV-MES.CodPer @ Fi-Mensaje LABEL "Codigo de Personal"
                  FORMAT "X(11)" 
                  WITH FRAME F-Proceso.
        */

         DISPLAY "Codigo de Personal: " + PR-MOV-MES.CodPer @ x-mensaje
             WITH FRAME {&FRAME-NAME}.


          VIEW STREAM REPORT FRAME H-REP.
         
          IF FIRST-OF(PR-MOV-MES.NumOrd) THEN DO:
             PUT STREAM REPORT "ORDEN No : " AT 1.
             PUT STREAM REPORT PR-MOV-MES.NumOrd AT 12 FORMAT "X(6)" SKIP.
             X-TOT1 = 0.
             X-TOT2 = 0.
             X-TOT3 = 0.
             X-TOT4 = 0.
             X-TOT5 = 0.
             X-TOT6 = 0.
             X-TOT10 = 0.
          END.
          IF FIRST-OF(PR-MOV-MES.FchReg) THEN DO:
             PUT STREAM REPORT "FECHA : " AT 5 .
             PUT STREAM REPORT PR-MOV-MES.FchReg AT 15 SKIP.
          END.

          FIND PL-PERS WHERE Pl-PERS.Codper = PR-MOV-MES.CodPer
                             NO-LOCK NO-ERROR.
          X-DESPER = "".
          IF AVAILABLE Pl-PERS THEN 
          X-DESPER = TRIM(PL-PERS.PatPer) + " " + TRIM(PL-PERS.MatPer) + " " + TRIM(PL-PERS.NomPer).
          X-HORAI  = PR-MOV-MES.HoraI.
          X-HORA   = 0.
          X-IMPHOR = 0.
          X-TOTA   = 0.
          X-BASE   = 0.
          X-HORMEN = 0.
          X-FACTOR = 0.
                    
          FOR EACH PL-MOV-MES WHERE PL-MOV-MES.Codcia = PR-MOV-MES.Codcia AND
                                   PL-MOV-MES.Periodo = PR-MOV-MES.Periodo AND
                                   PL-MOV-MES.Nromes  = PR-MOV-MES.NroMes AND
                                   PL-MOV-MES.CodPln  = 01 AND
                                   PL-MOV-MES.Codcal  = 0 AND
                                   PL-MOV-MES.CodPer = PR-MOV-MES.CodPer AND
                                   (PL-MOV-MES.CodMov = 101 OR
                                    PL-MOV-MES.CodMov = 103)  :
          
            X-BASE = X-BASE + PL-MOV-MES.VALCAL-MES .                     

              
          END.

        FIND LAST PL-VAR-MES WHERE
                  PL-VAR-MES.Periodo = PR-MOV-MES.Periodo AND
                  PL-VAR-MES.NroMes  = PR-MOV-MES.NroMes 
                  NO-ERROR.

        IF AVAILABLE PL-VAR-MES THEN 
           ASSIGN
           X-HORMEN = PL-VAR-MES.ValVar-MES[11]
           X-FACTOR = PL-VAR-MES.ValVar-MES[12] + PL-VAR-MES.ValVar-MES[13] + PL-VAR-MES.ValVar-MES[3] + PL-VAR-MES.ValVar-MES[5] + PL-VAR-MES.ValVar-MES[10].

           X-IMPHOR = (X-BASE / X-HORMEN) * ( 1 + (X-FACTOR / 100) ) / 60.
          
          FOR EACH PR-CFGPL NO-LOCK WHERE PR-CFGPL.Codcia = S-CODCIA /*AND
                                          PR-CFGPL.Periodo = PR-MOV-MES.Periodo AND
                                          PR-CFGPL.NroMes  = PR-MOV-MES.NroMes*/:
              IF X-HORAI >= PR-CFGPL.HoraI AND X-HORAI < PR-CFGPL.HoraF THEN DO:
                 IF PR-MOV-MES.HoraF <= PR-CFGPL.HoraF THEN DO:
                    X-SEGF = TRUNCATE(PR-MOV-MES.HoraF,0) * 60 + (PR-MOV-MES.HoraF - TRUNCATE(PR-MOV-MES.HoraF,0)) * 100 . 
                    X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 . 
                    X-HORA[PR-CFGPL.Nroitm] = X-HORA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) .                 
                    X-TOTA[PR-CFGPL.Nroitm] = X-TOTA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                    X-TOTA[10] = X-TOTA[10] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 

                    LEAVE.
                 END.
                 IF PR-MOV-MES.HoraF > PR-CFGPL.HoraF THEN DO:
                    X-SEGF = TRUNCATE(PR-CFGPL.HoraF,0) * 60 + (PR-CFGPL.HoraF - TRUNCATE(PR-CFGPL.HoraF,0)) * 100 . 
                    X-SEGI = TRUNCATE(X-HORAI,0) * 60 + (X-HORAI - TRUNCATE(X-HORAI,0)) * 100 . 
                    X-HORA[PR-CFGPL.Nroitm] = X-HORA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) .                 
                    X-TOTA[PR-CFGPL.Nroitm] = X-TOTA[PR-CFGPL.Nroitm] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                    X-TOTA[10] = X-TOTA[10] + (X-SEGF - X-SEGI) * PR-CFGPL.Factor * X-IMPHOR .                 
                    X-HORAI = PR-CFGPL.HoraF.
                 END.
                 
              END.
                             
                                          
          END.               

          X-IMPHOR = X-IMPHOR * 60 .         

          DISPLAY STREAM REPORT
                PR-MOV-MES.CodPer
                X-DESPER
                PR-MOV-MES.HoraI
                PR-MOV-MES.HoraF
                X-HORA[1]                               
                X-HORA[2]                               
                X-HORA[3]                               
                X-HORA[4]                               
                X-HORA[5]                               
                X-HORA[6]    
                X-IMPHOR 
                X-TOTA[10]                           
                WITH FRAME FD-REP.      
 
          X-TOT1 = X-TOT1 + X-HORA[1].
          X-TOT2 = X-TOT2 + X-HORA[2].
          X-TOT3 = X-TOT3 + X-HORA[3].
          X-TOT4 = X-TOT4 + X-HORA[4].
          X-TOT5 = X-TOT5 + X-HORA[5].
          X-TOT6 = X-TOT6 + X-HORA[6].
          X-TOT10 = X-TOT10 + X-TOTA[10].
           
          IF LAST-OF(PR-MOV-MES.NumOrd) THEN DO:
             UNDERLINE STREAM REPORT
               X-HORA[1]
               X-HORA[2]
               X-HORA[3]
               X-HORA[4]
               X-HORA[5]
               X-HORA[6]
               X-TOTA[10]
             WITH FRAME FD-REP.
             DISPLAY STREAM REPORT
                X-TOT1 @ X-HORA[1]
                X-TOT2 @ X-HORA[2]
                X-TOT3 @ X-HORA[3]
                X-TOT4 @ X-HORA[4]
                X-TOT5 @ X-HORA[5]
                X-TOT6 @ X-HORA[6]
                X-TOT10 @ X-TOTA[10]
             WITH FRAME FD-REP.
          END.

  END.  
/*  
  FOR EACH T-resume:
    DISPLAY STREAM REPORT
            T-resume.codmat  
            T-resume.desmat 
            T-resume.undbas 
            T-resume.canrea 
            T-resume.cansis 
            T-resume.Total
            
            WITH FRAME FC4-REP.      
  END.
*/
  
/*
HIDE FRAME F-PROCESO.
*/

DISPLAY " " @ x-mensaje WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita W-Win 
PROCEDURE Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ENABLE ALL EXCEPT x-mensaje  .    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime W-Win 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM report TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM report.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/D-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inhabilita W-Win 
PROCEDURE Inhabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    DISABLE ALL.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Variables W-Win 
PROCEDURE Inicializa-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN DesdeF HastaF F-Orden.
END.

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
  
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN DesdeF = TODAY
            HastaF = TODAY .
      DISPLAY DesdeF HastaF .    
  
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

