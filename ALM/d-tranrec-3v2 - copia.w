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
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
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

DEF BUFFER B-ALMACEN FOR ALMACEN.

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
&Scoped-Define ENABLED-OBJECTS cb-almacen desdeF hastaF Btn_Excel ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS cb-almacen desdeF hastaF C-Tipmov I-CodMov ~
N-MOVI 

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
     SIZE 11 BY 1.5 TOOLTIP "Cancelar"
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 11 BY 1.5 TOOLTIP "Salida a Excel".

DEFINE VARIABLE C-Tipmov AS CHARACTER FORMAT "X(256)":U INITIAL "Salida" 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 1
     LIST-ITEMS "Salida" 
     DROP-DOWN-LIST
     SIZE 9.43 BY 1 NO-UNDO.

DEFINE VARIABLE cb-almacen AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Almacen" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 9.57 BY 1 NO-UNDO.

DEFINE VARIABLE desdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE hastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE I-CodMov AS CHARACTER FORMAT "X(2)":U INITIAL "03" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .69 NO-UNDO.

DEFINE VARIABLE N-MOVI AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.57 BY .69 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-almacen AT ROW 1.92 COL 11.43 COLON-ALIGNED WIDGET-ID 6
     desdeF AT ROW 2.88 COL 11.29 COLON-ALIGNED
     hastaF AT ROW 2.88 COL 30 COLON-ALIGNED
     C-Tipmov AT ROW 3.69 COL 11.29 COLON-ALIGNED
     I-CodMov AT ROW 3.73 COL 21.14 COLON-ALIGNED NO-LABEL
     N-MOVI AT ROW 3.73 COL 25.29 COLON-ALIGNED NO-LABEL
     Btn_Excel AT ROW 5.62 COL 44 WIDGET-ID 2
     Btn_Cancel AT ROW 5.62 COL 55
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 68 BY 6.77
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
         TITLE              = "Transferencias No Recepcionadas"
         HEIGHT             = 6.77
         WIDTH              = 68
         MAX-HEIGHT         = 6.77
         MAX-WIDTH          = 68
         VIRTUAL-HEIGHT     = 6.77
         VIRTUAL-WIDTH      = 68
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR COMBO-BOX C-Tipmov IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN I-CodMov IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN N-MOVI IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Transferencias No Recepcionadas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Transferencias No Recepcionadas */
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


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel W-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Excel */
DO:
    SESSION:SET-WAIT-STATE("GENERAL").
    ASSIGN C-TipMov DesdeF HastaF I-CodMov cb-almacen .
    CASE C-tipmov:
       /*WHEN "Ingreso" THEN X-Tipmov = "I".*/
       WHEN "Salida"  THEN X-Tipmov = "S".
    END.
    RUN Asigna-Variables.
    RUN Inhabilita.
    RUN Excel. /*RUN Imprime.*/
    RUN Habilita.
    RUN Inicializa-Variables.
    
    SESSION:SET-WAIT-STATE("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-Tipmov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Tipmov W-Win
ON LEAVE OF C-Tipmov IN FRAME F-Main /* Tipo */
DO:
  /*FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
                      Almtmovm.tipmov = X-TIPMOV AND
                      Almtmovm.codmov = integer(I-CodMov:screen-value)  NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN
  assign
    N-MOVI:screen-value = Almtmovm.Desmov.
  ELSE DO:
      MESSAGE "Movimiento No Existe ....." VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  
  IF Almtmovm.MovTrf THEN DO:
      F-AlmDes:SENSITIVE = YES.
     
  END.
  ELSE DO:
      F-AlmDes:SENSITIVE = NO.
      F-NomDes:SCREEN-VALUE = "".
      F-AlmDes:SCREEN-VALUE = "".
  END.  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Tipmov W-Win
ON VALUE-CHANGED OF C-Tipmov IN FRAME F-Main /* Tipo */
DO:
  ASSIGN C-TIPMOV.
  
  CASE C-tipmov:
     /*WHEN "Ingreso" THEN X-Tipmov = "I".*/
     WHEN "Salida"  THEN X-Tipmov = "S".
  END.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-CodMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-CodMov W-Win
ON F8 OF I-CodMov IN FRAME F-Main
DO:
  /*ASSIGN  input-var-1 = X-tipmov
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?.

  RUN lkup\C-TMovm ("Movimientos de Ingreso").
  IF output-var-2 = ? THEN output-var-2 = "". 
  I-Codmov = output-var-2.
  DO WITH FRAME {&FRAME-NAME}:
     Display I-Codmov .
  END.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-CodMov W-Win
ON LEAVE OF I-CodMov IN FRAME F-Main
DO:
  
  /* RHC 27-03-04 se puede dejar en blanco I-CodMov */
  /*IF SELF:SCREEN-VALUE = ''
  THEN DO:
    N-MOVI:screen-value = "Todos".
   
  END.
  ELSE DO:
    FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA 
        AND Almtmovm.tipmov = X-TIPMOV 
        AND Almtmovm.codmov = integer(I-CodMov:screen-value)  
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtmovm 
    THEN N-MOVI:screen-value = Almtmovm.Desmov.
    ELSE DO:
        MESSAGE "Movimiento No Existe ....." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

  END.*/
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-CodMov W-Win
ON MOUSE-SELECT-DBLCLICK OF I-CodMov IN FRAME F-Main
DO:
  /*ASSIGN  input-var-1 = X-tipmov
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?.

  RUN lkup\C-TMovm ("Movimientos de " + C-tipmov).
  IF output-var-2 = ? THEN output-var-2 = "". 
  I-Codmov = output-var-2.
  DO WITH FRAME {&FRAME-NAME}:
     Display I-Codmov .
  END.*/
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
  ASSIGN DesdeF HastaF C-tipmov I-Codmov cb-almacen.

  x-titulo2 = 'Del ' + STRING(DesdeF, '99/99/9999') + ' Al ' + STRING(HastaF, '99/99/9999').
  CASE C-TipMov:
     WHEN 'Salida'  THEN ASSIGN
           x-titulo1 = 'TRANSFERENCIAS POR RECEPCIONAR'
           X-Tipmov = "S".
  END CASE.

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
  DISPLAY cb-almacen desdeF hastaF C-Tipmov I-CodMov N-MOVI 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE cb-almacen desdeF hastaF Btn_Excel Btn_Cancel 
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

DEFINE VARIABLE cAlm                    AS CHARACTER NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:COLUMNS("A"):ColumnWidth = 7.
chWorkSheet:COLUMNS("B"):ColumnWidth = 6.
chWorkSheet:COLUMNS("C"):ColumnWidth = 10.
chWorkSheet:COLUMNS("D"):ColumnWidth = 11.
chWorkSheet:COLUMNS("E"):ColumnWidth = 8.
chWorkSheet:COLUMNS("F"):ColumnWidth = 50.
chWorkSheet:COLUMNS("G"):ColumnWidth = 50.

chWorkSheet:Range("A1: I2"):FONT:Bold = TRUE.
chWorkSheet:Range("A1"):VALUE =
    "TRANSFERENCIAS POR RECEPCIONAR" +
    " DEL " + STRING(desdeF) + " AL " + STRING(hastaF).

chWorkSheet:Range("A2"):VALUE = "Origen".

chWorkSheet:Range("B2"):VALUE = "Descripcion Origen".

chWorkSheet:Range("C2"):VALUE = "Serie".
chWorkSheet:Range("D2"):VALUE = "Documento".
chWorkSheet:Range("E2"):VALUE = "Fecha".
chWorkSheet:Range("F2"):VALUE = "Destino".
chWorkSheet:Range("G2"):VALUE = "Descripción".
chWorkSheet:Range("H2"):VALUE = "Observaciones".
chWorkSheet:Range("I2"):VALUE = "Articulo".
chWorkSheet:Range("J2"):VALUE = "Descripcion".
chWorkSheet:Range("K2"):VALUE = "Unidad".

chWorkSheet:Range("L2"):VALUE = "Linea".
chWorkSheet:Range("M2"):VALUE = "Descripcion Linea".

chWorkSheet:Range("N2"):VALUE = "SubLinea".
chWorkSheet:Range("O2"):VALUE = "Descripcion SubLinea".

chWorkSheet:Range("P2"):VALUE = "Cantidad".
/* chWorkSheet:Range("Q2"):VALUE = "Costo Prom". */
/* chWorkSheet:Range("R2"):VALUE = "Valorizado". */

chWorkSheet:Range("S2"):VALUE = "Nro Hoja Ruta".
chWorkSheet:Range("T2"):VALUE = "Descripcion Hoja Ruta".
chWorkSheet:Range("U2"):VALUE = "Fecha Emision".
chWorkSheet:Range("V2"):VALUE = "Fecha Salida".
chWorkSheet:Range("W2"):VALUE = "Hora Salida".
chWorkSheet:Range("X2"):VALUE = "Fecha Retorno".
chWorkSheet:Range("Y2"):VALUE = "Hora Retorno".

chWorkSheet:Range("Z2"):VALUE = "Orden de Transferencia".

chWorkSheet:Range("AA2"):VALUE = "Almacen Inicio".
chWorkSheet:Range("AB2"):VALUE = "Almacen Intermedio".
chWorkSheet:Range("AC2"):VALUE = "Almacen Final".
chWorkSheet:COLUMNS("AA"):NumberFormat = "@".
chWorkSheet:COLUMNS("AB"):NumberFormat = "@".
chWorkSheet:COLUMNS("AC"):NumberFormat = "@".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:COLUMNS("C"):NumberFormat = "@".
/*chWorkSheet:COLUMNS("E"):NumberFormat = "@".*/
chWorkSheet:COLUMNS("H"):NumberFormat = "@".
chWorkSheet:COLUMNS("K"):NumberFormat = "@".
chWorkSheet:COLUMNS("L"):NumberFormat = "@".
chWorkSheet:COLUMNS("N"):NumberFormat = "@".
chWorkSheet:COLUMNS("I"):NumberFormat = "@".

chWorkSheet:COLUMNS("Z"):NumberFormat = "@".

chWorkSheet = chExcelApplication:Sheets:Item(1).
IF cb-Almacen = 'Todos' THEN cAlm = ''.
ELSE cAlm = cb-Almacen.

loopREP:
FOR EACH B-Almacen WHERE B-Almacen.codcia = s-codcia AND
    B-Almacen.codalm BEGINS cAlm NO-LOCK,
    EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = S-CODCIA AND  
    Almcmov.CodAlm = B-Almacen.codalm AND
    Almcmov.TipMov = X-TipMov AND  
    Almcmov.CodMov = INTEGER(I-CodMov) AND
    Almcmov.FchDoc >= DesdeF  AND  
    Almcmov.FchDoc <= HastaF  and
    Almcmov.flgest <> "A"     and
    Almcmov.flgsit = "T",
    FIRST Almacen NO-LOCK WHERE Almacen.codcia = Almcmov.codcia AND Almacen.codalm = Almcmov.almdes,
    EACH almdmov OF almcmov NO-LOCK,
    FIRST Almmmatg OF Almdmov NO-LOCK
    BREAK BY Almcmov.NroDoc :
    X-Movi = Almcmov.TipMov + STRING(Almcmov.CodMov, '99') + '-'.

    FIND FIRST almtfam OF almmmatg NO-LOCK NO-ERROR.
    FIND FIRST almsfam OF almmmatg NO-LOCK NO-ERROR.

    FIND Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia AND  
         Almtmovm.tipmov = Almcmov.tipmov AND  
         Almtmovm.codmov = Almcmov.CodMov 
         NO-LOCK NO-ERROR.

    t-column = t-column + 1.

    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = Almcmov.CodAlm.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = B-Almacen.descripcion.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = Almcmov.Nroser.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = Almcmov.Nrodoc.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = Almcmov.FchDoc.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = Almcmov.AlmDes.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = Almacen.Descripcion.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = Almcmov.Observ.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = Almdmov.codmat.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.desmat.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = Almdmov.CodUnd.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.codfam.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = IF(AVAILABLE almtfami) THEN almtfami.desfam ELSE "".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.subfam.
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = IF(AVAILABLE almsfami) THEN almsfami.dessub ELSE "".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = Almdmov.candes.

    /* Costo Promedio Kardex */
/*     FIND LAST almstkge WHERE  almstkge.codcia = s-codcia AND                */
/*                             almstkge.codmat = almdmov.codmat AND            */
/*                             almstkge.fecha <= TODAY NO-LOCK NO-ERROR.       */
/*     IF AVAILABLE almstkge THEN DO:                                          */
/*         cRange = "Q" + cColumn.                                             */
/*         chWorkSheet:Range(cRange):Value = almstkge.ctouni.                  */
/*         cRange = "R" + cColumn.                                             */
/*         chWorkSheet:Range(cRange):Value = Almdmov.candes * almstkge.ctouni. */
/*     END.                                                                    */
    /* La hoja de RUTA */
    FOR EACH di-rutaG WHERE di-rutaG.codcia = s-codcia AND
        di-rutaG.coddoc = 'H/R' AND 
        di-rutaG.codalm = almcmov.codalm AND
        di-rutaG.tipmov = 'S' AND 
        di-rutaG.codmov = 3 AND
        di-rutaG.serref = almcmov.nroser AND 
        di-rutaG.nroref = almcmov.nrodoc NO-LOCK,
        FIRST di-rutaC OF di-rutaG WHERE di-rutaC.flgest <> 'A' NO-LOCK:
            cRange = "S" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + di-rutac.nrodoc.
            cRange = "t" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + if(di-rutac.desrut = ?) THEN "" ELSE di-rutac.desrut.
            cRange = "U" + cColumn.
            chWorkSheet:Range(cRange):Value = di-rutac.fchdoc.
            cRange = "v" + cColumn.
            chWorkSheet:Range(cRange):Value = di-rutac.fchsal.
            cRange = "w" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + if(di-rutac.horsal = ?) THEN "" ELSE STRING(di-rutac.horsal,"99:99").
            cRange = "x" + cColumn.
            chWorkSheet:Range(cRange):Value = di-rutac.fchdoc.
            cRange = "y" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + if(di-rutac.horret = ?) THEN "" ELSE STRING(di-rutac.horret,"99:99").
        LEAVE.
    END.

    IF Almcmov.CodRef = "OTR" THEN DO:
        cRange = "Z" + cColumn.
        chWorkSheet:Range(cRange):Value = Almcmov.NroRef.

    END.

    /* Cross Docking */
    FIND Faccpedi WHERE FacCPedi.CodCia = Almcmov.CodCia
        AND FacCPedi.CodDoc = Almcmov.CodRef        /* OTR */
        AND FacCPedi.NroPed = Almcmov.NroRef
        NO-LOCK NO-ERROR.
    IF AVAILABLE Faccpedi AND FacCPedi.CrossDocking = YES THEN DO:
        cRange = "AA" + cColumn.
        chWorkSheet:Range(cRange):Value = Faccpedi.CodAlm.
        cRange = "AB" + cColumn.
        chWorkSheet:Range(cRange):Value = Faccpedi.AlmacenXD.
        cRange = "AC" + cColumn.
        chWorkSheet:Range(cRange):Value = Faccpedi.CodCli.
    END.

    DISPLAY Almcmov.NroDoc @ Fi-Mensaje LABEL "Número de Movimiento"
        FORMAT "X(11)" 
        WITH FRAME F-Proceso.
   READKEY PAUSE 0.
   IF LASTKEY = KEYCODE("F10") THEN LEAVE loopREP.
END.
HIDE FRAME F-Proceso NO-PAUSE.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/*
chWorkSheet:Range("S2"):VALUE = "Nro Hoja Ruta".
chWorkSheet:Range("T2"):VALUE = "Fecha Emision".
chWorkSheet:Range("U2"):VALUE = "Fecha/Hora Salida".
chWorkSheet:Range("V2"):VALUE = "Fecha/Hora Retorno".
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR cAlm AS CHARACTER NO-UNDO.  
  DEFINE FRAME FC-REP
         Almcmov.CodAlm COLUMN-LABEL "Origen"
         Almcmov.Nroser COLUMN-LABEL "Serie"
         Almcmov.Nrodoc COLUMN-LABEL "Documento"
         Almcmov.FchDoc COLUMN-LABEL "Fecha" FORMAT "99/99/9999"
         Almcmov.AlmDes COLUMN-LABEL "Destino"
         Almacen.Descripcion COLUMN-LABEL "Descripcion" FORMAT 'x(40)'
         Almcmov.Observ  COLUMN-LABEL "Observaciones" FORMAT 'x(50)'
         WITH WIDTH 200 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME H-REP
         HEADER
         S-NOMCIA FORMAT "X(45)" SKIP
         "( " + S-CODALM + ")"  FORMAT "X(15)"
         x-titulo1 AT 40 FORMAT "X(35)"
         "Pag.  : " AT 110 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         "Desde : " AT 40 STRING(DESDEF,"99/99/9999") FORMAT "X(10)" "Al" STRING(HASTAF,"99/99/9999") FORMAT "X(12)"
         "Fecha : " AT 110 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP(1)
        WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  IF cb-Almacen = 'Todos' THEN cAlm = ''.
  ELSE cAlm = cb-Almacen.

  FOR EACH B-Almacen WHERE B-Almacen.codcia = s-codcia
          AND B-Almacen.codalm BEGINS cAlm NO-LOCK,
          EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = S-CODCIA AND  
              /*Almcmov.CodAlm = S-CODALM AND  */
              Almcmov.CodAlm = B-Almacen.codalm AND
              Almcmov.TipMov = X-TipMov AND  
              /*(I-CodMov = '' OR Almcmov.CodMov = INTEGER(I-CodMov)) AND  */
              Almcmov.CodMov = INTEGER(I-CodMov) AND
              Almcmov.FchDoc >= DesdeF  AND  
              Almcmov.FchDoc <= HastaF  and
              Almcmov.flgest <> "A"     and
              Almcmov.flgsit = "T",
              FIRST Almacen WHERE Almacen.codcia = Almcmov.codcia
                  AND Almacen.codalm = Almcmov.almdes NO-LOCK
              BREAK BY Almcmov.NroDoc :
        X-Movi = Almcmov.TipMov + STRING(Almcmov.CodMov, '99') + '-'.
        FIND Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia 
                       AND  Almtmovm.tipmov = Almcmov.tipmov 
                       AND  Almtmovm.codmov = Almcmov.CodMov 
                      NO-LOCK NO-ERROR.
        DISPLAY Almcmov.NroDoc @ Fi-Mensaje LABEL "Número de Movimiento"
                FORMAT "X(11)" 
                WITH FRAME F-Proceso.
        VIEW STREAM REPORT FRAME H-REP.
        DISPLAY STREAM REPORT
              Almcmov.CodAlm
              Almcmov.Nroser 
              Almcmov.NroDoc 
              Almcmov.FchDoc 
              Almcmov.Almdes
              Almacen.descripcion 
              Almcmov.Observ
              WITH FRAME FC-REP.      
  END.  
  HIDE FRAME F-PROCESO.

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
    ENABLE ALL EXCEPT N-MOVI i-codmov c-tipmov.
   
   FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
                      Almtmovm.tipmov = X-TIPMOV AND
                      Almtmovm.codmov = integer(I-CodMov:screen-value)  NO-LOCK NO-ERROR.
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
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
        RUN formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
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
  ASSIGN DesdeF HastaF C-tipmov I-Codmov .

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
            HastaF = TODAY
            C-tipmov.
     CASE C-tipmov:
         WHEN "Salida"  THEN X-Tipmov = "S".
     END.
     FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
         Almtmovm.tipmov = X-TIPMOV AND
         Almtmovm.codmov = INTEGER(I-CodMov) NO-LOCK NO-ERROR.
     IF AVAILABLE Almtmovm THEN N-MOVI = Almtmovm.Desmov.
     DISPLAY DesdeF HastaF I-Codmov C-tipmov N-movi.    
     /*cb-almacen:LIST-ITEMS = "Todos".*/
     FOR EACH Almacen WHERE Almacen.CodCia = s-CodCia NO-LOCK:
         cb-almacen:ADD-LAST(Almacen.CodAlm).
     END.             
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

