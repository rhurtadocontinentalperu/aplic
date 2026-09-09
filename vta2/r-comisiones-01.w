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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR x-CodDiv LIKE gn-divi.coddiv NO-UNDO.

DEF TEMP-TABLE t-cdoc LIKE ccbcdocu.
DEF TEMP-TABLE t-ddoc LIKE ccbddocu.
DEF BUFFER b-cdoc FOR ccbcdocu.


DEF TEMP-TABLE detalle
    FIELD coddiv AS CHAR
    FIELD codven AS CHAR
    FIELD codfam AS CHAR
    FIELD implin AS DEC
    FIELD implin1 AS DEC
    FIELD implin2 AS DEC
    FIELD impcom1 AS DEC
    FIELD impcom2 AS DEC.

DEF TEMP-TABLE Resumen LIKE Detalle.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Division x-FchDoc-1 x-FchDoc-2 ~
BUTTON-4 Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Division x-FchDoc-1 x-FchDoc-2 ~
x-mensaje 

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
     SIZE 7 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 4" 
     SIZE 7 BY 1.73.

DEFINE VARIABLE COMBO-BOX-Division AS CHARACTER FORMAT "X(256)":U 
     LABEL "Divisiones" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Division AT ROW 1.38 COL 15 COLON-ALIGNED WIDGET-ID 12
     x-FchDoc-1 AT ROW 2.35 COL 15 COLON-ALIGNED
     x-FchDoc-2 AT ROW 2.35 COL 33 COLON-ALIGNED
     BUTTON-4 AT ROW 5.04 COL 55 WIDGET-ID 10
     Btn_Done AT ROW 5.04 COL 62
     x-mensaje AT ROW 5.58 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.86 BY 6.27
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
         TITLE              = "REPORTE DE COMISIONES"
         HEIGHT             = 6.27
         WIDTH              = 69.86
         MAX-HEIGHT         = 8.58
         MAX-WIDTH          = 69.86
         VIRTUAL-HEIGHT     = 8.58
         VIRTUAL-WIDTH      = 69.86
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE COMISIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE COMISIONES */
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


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
    ASSIGN
        x-FchDoc-1 x-FchDoc-2 COMBO-BOX-Division.
    /* Filtro de fechas */
    IF x-FchDoc-1 = ? OR x-FchDoc-2 = ?
        OR x-FchDoc-1 > x-FchDoc-2
        THEN DO:
        MESSAGE 'Solo se permiten fechas de inicio y fin de un mes'
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    x-CodDiv = ENTRY(1, COMBO-BOX-Division, ' - ').

    RUN Genera-Excel.
    
    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-FchCan AS DATE NO-UNDO.
  DEF VAR x-ImpTot AS DEC NO-UNDO.

  DEF VAR x-Signo  AS INT NO-UNDO.
  DEF VAR x-FchDoc AS DATE NO-UNDO.

  EMPTY TEMP-TABLE T-CDOC.
  EMPTY TEMP-TABLE T-DDOC.
  
  /* PRIMERO: LOS COMPROBANTES DE VENTAS */
  DISPLAY 'Calculando Comisiones' @ x-mensaje WITH FRAME {&FRAME-NAME}.

  FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia
      AND (x-CodDiv = 'Todas' OR GN-DIVI.coddiv = x-CodDiv),
      EACH Ventas_Cabecera NO-LOCK WHERE Ventas_Cabecera.CodDiv = gn-divi.coddiv
      AND Ventas_Cabecera.DateKey >= x-FchDoc-1
      AND Ventas_Cabecera.DateKey <= x-FchDoc-2
      AND LOOKUP(Ventas_Cabecera.CodDoc, 'FAC,BOL,TCK,N/C') > 0:
      CREATE T-CDOC.
      ASSIGN
          T-CDOC.codcia = s-codcia
          T-CDOC.coddiv = Ventas_Cabecera.coddiv
          T-CDOC.coddoc = Ventas_Cabecera.coddoc
          T-CDOC.nrodoc = Ventas_Cabecera.nrodoc
          T-CDOC.codven = Ventas_Cabecera.codven
          T-CDOC.fmapgo = Ventas_Cabecera.fmapgo
          T-CDOC.imptot2 = 0.
      ASSIGN
          x-Signo  = 1
          x-FchDoc = Ventas_Cabecera.DateKey.
      DETALLE:
      FOR EACH Ventas_Detalle OF Ventas_Cabecera NO-LOCK,
          FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
          AND Almmmatg.codmat = Ventas_Detalle.codmat 
          AND Almmmatg.codfam <> '009':
          IF Ventas_Detalle.ImpNacSIGV = ? THEN NEXT.
          CREATE T-DDOC.
          ASSIGN
              T-DDOC.codcia = s-codcia
              T-DDOC.coddoc = T-CDOC.coddoc
              T-DDOC.nrodoc = T-CDOC.nrodoc
              T-DDOC.coddiv = T-CDOC.coddiv
              T-DDOC.codmat = Ventas_Detalle.codmat
              T-DDOC.implin = Ventas_Detalle.ImpNacSIGV.
          /* comisiones por linea */
          FIND LAST VtaTabla WHERE VtaTabla.codcia = s-codcia
              AND VtaTabla.Tabla = "CAMPAÑAS"
              AND x-FchDoc >= VtaTabla.Rango_Fecha[1]
              AND x-FchDoc <= VtaTabla.Rango_Fecha[2]
              NO-LOCK NO-ERROR.
          ASSIGN
              t-ddoc.Flg_Factor = Almmmatg.TipArt
              t-ddoc.ImpCto = 0.
          /* comisiones por rotacion */
          ROTACION:
          DO:
              IF Almmmatg.Clase <> 'X' AND (Almmmatg.Libre_f01 = ? OR Almmmatg.Libre_f01 >= TODAY) THEN DO:
                  FIND PorComi WHERE PorComi.CodCia = s-codcia AND PorComi.Catego = Almmmatg.Clase NO-LOCK NO-ERROR.
                  IF AVAILABLE PorComi THEN DO:
                      ASSIGN
                          t-ddoc.impcto = x-Signo * t-ddoc.implin * PorComi.Porcom / 100
                          t-cdoc.imptot2 = t-cdoc.imptot2 + t-ddoc.impcto
                          t-ddoc.Flg_Factor = "*".
                      LEAVE ROTACION.
                  END.
              END.
              FIND FacTabla WHERE FacTabla.codcia = s-codcia
                  AND FacTabla.Tabla = 'CV'
                  AND FacTabla.Codigo = TRIM(Almmmatg.codfam) + t-cdoc.coddiv
                  NO-LOCK NO-ERROR.
              IF AVAILABLE FacTabla THEN DO:
                  IF AVAILABLE VtaTabla
                      THEN ASSIGN
                              t-ddoc.impcto = x-Signo * t-ddoc.implin * FacTabla.Valor[1] / 100
                              t-cdoc.imptot2 = t-cdoc.imptot2 + t-ddoc.impcto.
                      ELSE ASSIGN
                              t-ddoc.impcto = x-Signo * t-ddoc.implin * FacTabla.Valor[2] / 100
                              t-cdoc.imptot2 = t-cdoc.imptot2 + t-ddoc.impcto.
              END.
          END.
          ASSIGN
              t-ddoc.implin = x-Signo * t-ddoc.implin.
      END.
  END.
  
  /* Resumen */
  DEF VAR x-CodFam AS CHAR NO-UNDO.
  DEF VAR x-CodDiv AS CHAR NO-UNDO.
  DEF VAR x-CodVen AS CHAR NO-UNDO.
  
  EMPTY TEMP-TABLE Detalle.
  FOR EACH t-cdoc NO-LOCK, 
      EACH t-ddoc OF t-cdoc NO-LOCK,
      FIRST gn-ven OF t-cdoc NO-LOCK,
      FIRST almmmatg of t-ddoc NO-LOCK, 
      FIRST almtfami OF almmmatg NO-LOCK,
      FIRST gn-divi OF t-cdoc NO-LOCK:
      /* Llaves */
      IF t-ddoc.Flg_Factor = "*" 
      THEN x-CodFam = Almmmatg.codmat + ' ' + Almmmatg.desmat.
      ELSE x-CodFam = Almtfami.codfam + ' ' + Almtfami.desfam.
      x-CodDiv = gn-divi.coddiv + ' ' + gn-divi.desdiv.
      x-CodVen = gn-ven.codven + ' ' + gn-ven.NomVen.
      /* ******* */
      FIND FIRST Detalle WHERE Detalle.coddiv = x-CodDiv
          AND Detalle.codven = x-CodVen
          AND Detalle.codfam = x-CodFam
          NO-ERROR.
      IF NOT AVAILABLE Detalle THEN CREATE Detalle.
      ASSIGN
          detalle.coddiv = x-CodDiv
          detalle.codven = x-CodVen
          detalle.codfam = x-CodFam.
      IF LOOKUP(t-cdoc.fmapgo, '000,001,002') > 0 
      THEN ASSIGN
                detalle.implin1 = detalle.implin1 + t-ddoc.implin
                detalle.impcom1 = detalle.impcom1 + t-ddoc.impcto.
      ELSE ASSIGN
                detalle.implin2 = detalle.implin2 + t-ddoc.implin
                detalle.impcom2 = detalle.impcom2 + t-ddoc.impcto.
      ASSIGN
          detalle.implin = detalle.implin1 + detalle.implin2.
  END.  
/*   FOR EACH t-cdoc NO-LOCK,                                           */
/*       EACH t-ddoc OF t-cdoc NO-LOCK,                                 */
/*       FIRST gn-ven OF t-cdoc NO-LOCK,                                */
/*       FIRST almmmatg of t-ddoc NO-LOCK,                              */
/*       FIRST almtfami OF almmmatg NO-LOCK,                            */
/*       FIRST gn-divi OF t-cdoc NO-LOCK:                               */
/*       CREATE detalle.                                                */
/*       ASSIGN                                                         */
/*           detalle.coddiv = gn-divi.coddiv + ' ' + gn-divi.desdiv     */
/*           detalle.codven = gn-ven.codven + ' ' + gn-ven.NomVen.      */
/*       IF t-ddoc.Flg_Factor = "*"                                     */
/*       THEN detalle.codfam = Almmmatg.codmat + ' ' + Almmmatg.desmat. */
/*       ELSE detalle.codfam = Almtfami.codfam + ' ' + Almtfami.desfam. */
/*       IF LOOKUP(t-cdoc.fmapgo, '000,001,002') > 0                    */
/*       THEN ASSIGN                                                    */
/*                 detalle.implin1 = t-ddoc.implin                      */
/*                 detalle.impcom1 = t-ddoc.impcto.                     */
/*       ELSE ASSIGN                                                    */
/*                 detalle.implin2 = t-ddoc.implin                      */
/*                 detalle.impcom2 = t-ddoc.impcto.                     */
/*       ASSIGN                                                         */
/*           detalle.implin = t-ddoc.implin.                            */
/*   END.                                                               */

  HIDE FRAME f-Mensaje.
      
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
  DISPLAY COMBO-BOX-Division x-FchDoc-1 x-FchDoc-2 x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Division x-FchDoc-1 x-FchDoc-2 BUTTON-4 Btn_Done 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel W-Win 
PROCEDURE Genera-Excel :
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

DEFINE VAR x-NomVen LIKE Gn-Ven.NomVen NO-UNDO.
DEFINE VAR x-ImpLin1 AS DEC NO-UNDO.
DEFINE VAR x-ImpLin2 AS DEC NO-UNDO.
DEFINE VAR x-ImpCom1 AS DEC NO-UNDO.
DEFINE VAR x-ImpCom2 AS DEC NO-UNDO.
  
RUN Carga-Temporal.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:COLUMNS("A"):ColumnWidth = 14.
chWorkSheet:COLUMNS("B"):ColumnWidth = 30.
chWorkSheet:COLUMNS("C"):ColumnWidth = 30.
chWorkSheet:COLUMNS("D"):ColumnWidth = 30.
chWorkSheet:COLUMNS("E"):ColumnWidth = 30.
chWorkSheet:COLUMNS("F"):ColumnWidth = 30.
chWorkSheet:COLUMNS("G"):ColumnWidth = 30.

chWorkSheet:Range("A1: M2"):FONT:Bold = TRUE.
chWorkSheet:Range("A2"):VALUE = "Division".
chWorkSheet:Range("B2"):VALUE = "Vendedor".
chWorkSheet:Range("C2"):VALUE = "Familia".
chWorkSheet:Range("D2"):VALUE = "Importe Total S/.".
chWorkSheet:Range("E2"):VALUE = "Importe Total Contado S/.".
chWorkSheet:Range("F2"):VALUE = "Importe Total Crédito S/.".
chWorkSheet:Range("G2"):VALUE = "Comision Contado S/.".
chWorkSheet:Range("H2"):VALUE = "Comisión Crédito S/.".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet = chExcelApplication:Sheets:Item(1).

FOR EACH detalle BY detalle.coddiv BY detalle.codven BY detalle.codfam:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).      
    cRange = "A" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.coddiv.
    cRange = "B" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.codven.
    cRange = "C" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.codfam.
    cRange = "D" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.implin.
    cRange = "E" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.implin1.
    cRange = "F" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.implin2.
    cRange = "G" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.impcom1.
    cRange = "H" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.impcom2.
END.

/* FOR EACH detalle BREAK BY detalle.codven BY detalle.codfam:                              */
/*     ACCUMULATE detalle.implin   (TOTAL BY detalle.codven BY detalle.codfam).             */
/*     ACCUMULATE detalle.implin1  (TOTAL BY detalle.codven BY detalle.codfam).             */
/*     ACCUMULATE detalle.implin2  (TOTAL BY detalle.codven BY detalle.codfam).             */
/*     ACCUMULATE detalle.impcom1  (TOTAL BY detalle.codven BY detalle.codfam).             */
/*     ACCUMULATE detalle.impcom2  (TOTAL BY detalle.codven BY detalle.codfam).             */
/*     IF LAST-OF(detalle.codven) OR LAST-OF(detalle.codfam)                                */
/*     THEN DO:                                                                             */
/*         t-column = t-column + 1.                                                         */
/*         cColumn = STRING(t-Column).                                                      */
/*         cRange = "A" + cColumn.                                                          */
/*         chWorkSheet:Range(cRange):Value = detalle.coddiv.                                */
/*         cRange = "B" + cColumn.                                                          */
/*         chWorkSheet:Range(cRange):Value = detalle.codven.                                */
/*         cRange = "C" + cColumn.                                                          */
/*         chWorkSheet:Range(cRange):Value = detalle.codfam.                                */
/*         cRange = "D" + cColumn.                                                          */
/*         chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY detalle.codfam detalle.implin.  */
/*         cRange = "E" + cColumn.                                                          */
/*         chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY detalle.codfam detalle.implin1. */
/*         cRange = "F" + cColumn.                                                          */
/*         chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY detalle.codfam detalle.implin2. */
/*         cRange = "G" + cColumn.                                                          */
/*         chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY detalle.codfam detalle.impcom1. */
/*         cRange = "H" + cColumn.                                                          */
/*         chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY detalle.codfam detalle.impcom2. */
/*     END.                                                                                 */
/* END.                                                                                     */

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
/*     FOR EACH Gn-divi NO-LOCK WHERE Gn-divi.codcia = s-codcia: */
/*         x-CodDiv:ADD-LAST(Gn-divi.coddiv).                    */
/*     END.                                                      */
    FOR EACH Gn-divi NO-LOCK WHERE Gn-divi.codcia = s-codcia:
        COMBO-BOX-Division:ADD-LAST(Gn-divi.coddiv + ' - ' + GN-DIVI.DesDiv).
        IF gn-divi.coddiv = s-coddiv THEN
            COMBO-BOX-Division:SCREEN-VALUE = Gn-divi.coddiv + ' - ' + GN-DIVI.DesDiv.
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

