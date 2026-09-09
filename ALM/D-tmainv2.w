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

/* Local Variable Definitions ---                                       */
DEFINE VAR I-TPOREP AS INTEGER INIT 1.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
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
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6 SKIP
    Fi-Mensaje NO-LABEL FONT 6 SKIP     
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 
        TITLE "Procesando ..." FONT 7.

/*******/

/* Local Variable Definitions ---                                       */

DEFINE VAR I AS INTEGER.
DEFINE VAR X-TITULO1 AS CHAR .
DEFINE VAR X-TITULO2 AS CHAR .
DEFINE VAR X-DESMAT  AS CHAR.
DEFINE VAR X-DESMAR  AS CHAR.
DEFINE VAR X-UNIDAD  AS CHAR.
/*DEFINE VAR X-CONTEO  AS CHAR INIT "---------------".*/
DEFINE VAR X-RECONT  AS CHAR INIT "_______________".
DEFINE VAR X-DIFE  AS CHAR INIT   "_______________".

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
&Scoped-Define ENABLED-OBJECTS RECT-62 RECT-61 RECT-58 RECT-60 RECT-59 ~
I-TipMat F-CodFam F-SubFam DesdeC F-marca1 F-provee1 x-IP HastaC F-Rotacion ~
R-Tipo Btn_OK Btn_Cancel Btn_Cancel-2 
&Scoped-Define DISPLAYED-OBJECTS I-TipMat F-CodFam F-SubFam DesdeC F-marca1 ~
F-provee1 x-IP F-DesFam F-DesSub HastaC F-Rotacion R-Tipo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Cancel-2 
     IMAGE-UP FILE "img\excel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5 TOOLTIP "Detallado por material y todos los almacenes"
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE x-IP AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "IP" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .69 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE F-marca1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-provee1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-Rotacion AS CHARACTER FORMAT "X":U 
     LABEL "Rotacion" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .81 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .69 NO-UNDO.

DEFINE VARIABLE I-TipMat AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Solo con Stock", 1,
"Todos los Seleccionados", 2
     SIZE 37.72 BY 1.08 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER INITIAL "A" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ambos", "",
"Activados", "A",
"Desactivados", "D"
     SIZE 12.86 BY 1.92 NO-UNDO.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16 BY 3.38.

DEFINE RECTANGLE RECT-59
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.29 BY 4.62.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.43 BY 2.23.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.86 BY 1.58.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 12.57 BY 5.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     I-TipMat AT ROW 9 COL 10.29 NO-LABEL
     F-CodFam AT ROW 1.54 COL 9.57 COLON-ALIGNED
     F-SubFam AT ROW 2.42 COL 9.57 COLON-ALIGNED
     DesdeC AT ROW 4.19 COL 9.57 COLON-ALIGNED
     F-marca1 AT ROW 4.92 COL 9.57 COLON-ALIGNED
     F-provee1 AT ROW 5.73 COL 9.57 COLON-ALIGNED
     x-IP AT ROW 6.58 COL 9.57 COLON-ALIGNED
     F-DesFam AT ROW 1.5 COL 16.14 COLON-ALIGNED NO-LABEL
     F-DesSub AT ROW 2.42 COL 16.14 COLON-ALIGNED NO-LABEL
     HastaC AT ROW 4.15 COL 38.86 COLON-ALIGNED
     F-Rotacion AT ROW 5.73 COL 38.86 COLON-ALIGNED
     R-Tipo AT ROW 2.62 COL 54.86 NO-LABEL
     Btn_OK AT ROW 5.35 COL 56
     Btn_Cancel AT ROW 7.15 COL 56.29
     Btn_Cancel-2 AT ROW 8.85 COL 56.29 WIDGET-ID 2
     "Estado" VIEW-AS TEXT
          SIZE 7.14 BY .69 AT ROW 1.69 COL 57.57
          FONT 1
     RECT-62 AT ROW 5.19 COL 55.43
     RECT-61 AT ROW 8.69 COL 8
     RECT-58 AT ROW 1.38 COL 54.29
     RECT-60 AT ROW 1.38 COL 4.14
     RECT-59 AT ROW 3.88 COL 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70.29 BY 10.42
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
         TITLE              = "Analisis de Documentos"
         HEIGHT             = 10.42
         WIDTH              = 70.29
         MAX-HEIGHT         = 10.42
         MAX-WIDTH          = 70.29
         VIRTUAL-HEIGHT     = 10.42
         VIRTUAL-WIDTH      = 70.29
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
   FRAME-NAME L-To-R,COLUMNS                                            */
/* SETTINGS FOR FILL-IN F-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Analisis de Documentos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Analisis de Documentos */
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
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel-2 W-Win
ON CHOOSE OF Btn_Cancel-2 IN FRAME F-Main /* Cancelar */
DO:
  RUN Asigna-Variables.
  SESSION:SET-WAIT-STATE("GENERAL").
    RUN Excel.
  SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN DesdeC F-CodFam F-SubFam 
         R-TIPO F-DesFam HastaC I-Tipmat
         F-marca1 F-provee1 F-Rotacion x-IP.

  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Articulo */
DO:
  
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodFam W-Win
ON LEAVE OF F-CodFam IN FRAME F-Main /* Linea */
DO:
   ASSIGN F-CodFam.
   FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA AND
        Almtfami.codfam = F-CodFam NO-LOCK NO-ERROR.
   IF AVAILABLE Almtfami THEN 
      DISPLAY Almtfami.desfam @ F-DesFam WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-marca1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-marca1 W-Win
ON LEAVE OF F-marca1 IN FRAME F-Main /* Marca */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND almtabla WHERE almtabla.Tabla = "MK" 
                  AND  almtabla.Codigo = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE almtabla THEN DO:
      MESSAGE "Codigo de Marca no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-provee1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-provee1 W-Win
ON LEAVE OF F-provee1 IN FRAME F-Main /* Proveedor */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA 
                AND  gn-prov.CodPro = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN do:
/*     DISPLAY gn-prov.NomPro @ FILL-IN-NomPro1 WITH FRAME {&FRAME-NAME}.*/
  END.
  ELSE DO:
      FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
                    AND  gn-prov.CodPro = SELF:SCREEN-VALUE 
                   NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-prov THEN DO:
           MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
      END.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-SubFam W-Win
ON LEAVE OF F-SubFam IN FRAME F-Main /* Sub-linea */
DO:
   ASSIGN F-CodFam.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   IF F-CodFam = "" THEN DO:
      SELF:SCREEN-VALUE = "".
      RETURN.
   END.
   FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA AND
        AlmSFami.codfam = F-CodFam AND
        AlmSFami.subfam = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE AlmSFami THEN 
      DISPLAY AlmSFami.dessub @ F-DesSub WITH FRAME {&FRAME-NAME}.
   ELSE DO:
      MESSAGE "Codigo de Sub-Familia no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC W-Win
ON LEAVE OF HastaC IN FRAME F-Main /* A */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
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
  ASSIGN DesdeC F-CodFam F-SubFam 
         R-TIPO F-DesFam HastaC I-Tipmat
         F-marca1 F-provee1 F-Rotacion.
  IF HastaC = "" THEN HastaC = "999999999".
         
  X-titulo1 = "LISTADO DE PRE-INVENTARIO".
  X-titulo2 = "ALMACEN " + S-CODALM + " " + S-DESALM.
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
  DISPLAY I-TipMat F-CodFam F-SubFam DesdeC F-marca1 F-provee1 x-IP F-DesFam 
          F-DesSub HastaC F-Rotacion R-Tipo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-62 RECT-61 RECT-58 RECT-60 RECT-59 I-TipMat F-CodFam F-SubFam 
         DesdeC F-marca1 F-provee1 x-IP HastaC F-Rotacion R-Tipo Btn_OK 
         Btn_Cancel Btn_Cancel-2 
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 5.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

DEFINE VARIABLE cDesFam AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDesSub AS CHARACTER   NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Header del Excel */
cRange = "A" + '2'.
chWorkSheet:Range(cRange):Value = s-nomcia.
cRange = "A" + '3'.
chWorkSheet:Range(cRange):Value = s-codalm.
cRange = "D" + '2'.
chWorkSheet:Range(cRange):Value = x-titulo1.
cRange = "G" + '3'.
chWorkSheet:Range(cRange):Value = "Fecha".
cRange = "H" + '3'.
chWorkSheet:Range(cRange):Value = TODAY.
cRange = "A" + '4'.
chWorkSheet:Range(cRange):Value = x-titulo2.
cRange = "G" + '4'.
chWorkSheet:Range(cRange):Value = "Hora:".
cRange = "H" + '4'.
chWorkSheet:Range(cRange):Value = TIME.

/*Formato*/
chWorkSheet:Columns("B"):NumberFormat = "@".


/* set the column names for the Worksheet */
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Ubicación".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Artículo".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion                        ".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Marca                      ".

cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Familia".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Sub Familia".


cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Unidad".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Sistema".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Físico".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Diferencia".

loopREP:
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
    AND  Almmmatg.codfam BEGINS F-CodFam
    AND  Almmmatg.subfam BEGINS F-Subfam
    AND  (Almmmatg.codmat >= DesdeC
    AND   Almmmatg.CodMat <= HastaC)
    AND  Almmmatg.CodPr1 BEGINS F-provee1
    AND  Almmmatg.Codmar BEGINS F-Marca1
    AND  Almmmatg.TpoArt BEGINS R-tipo
    AND  Almmmatg.TipArt BEGINS F-Rotacion
    AND (x-IP = 'Todos' OR Almmmatg.Chr__03 = x-IP)
    USE-INDEX matg09 ,
    EACH Almmmate NO-LOCK  WHERE Almmmate.Codcia = Almmmatg.Codcia AND
         Almmmate.CodAlm = TRIM(S-CODALM)  AND
         Almmmate.Codmat = Almmmatg.Codmat BREAK BY Almmmatg.Desmat:
    I = 1.
    IF i <= 15 then do:
       IF  I-Tipmat = 1 AND Almmmate.StkAct = 0 THEN NEXT.
          ASSIGN 
             X-Desmat = ""
             X-DesMar = ""
             X-Unidad = ""
             cDesFam  = ""
             cDesSub  = "".
             
          IF AVAILABLE Almmmatg THEN        
          ASSIGN 
             X-Desmat = Almmmatg.DesMat
             X-DesMar = Almmmatg.DesMar
             X-Unidad = Almmmatg.UndBas.

          FIND FIRST AlmTFam WHERE AlmTFam.CodCia = s-codcia
              AND Almtfam.codfam = almmmatg.codfam NO-LOCK NO-ERROR.
          IF AVAIL almtfam THEN cDesfam = almtfam.codfam + '-' + almtfam.desfam.

          FIND FIRST AlmSFam WHERE AlmSFam.CodCia = s-codcia
              AND AlmSFam.codfam = almmmatg.codfam
              AND AlmSFam.subfam = almmmatg.subfam NO-LOCK NO-ERROR.
          IF AVAIL AlmSFam THEN cDessub = AlmSFam.Subfam + '-' + AlmSFam.DesSub.  

          DISPLAY Almmmate.Codmat @ Fi-Mensaje LABEL "Codigo de Articulo"
                  FORMAT "X(11)" 
                  WITH FRAME F-Proceso.
          
          t-Column = t-Column + 1.
          cColumn = STRING(t-Column).
          cRange = "A" + cColumn.
          chWorkSheet:Range(cRange):Value = Almmmate.codubi.
          cRange = "B" + cColumn.
          chWorkSheet:Range(cRange):Value = Almmmate.Codmat.
          cRange = "C" + cColumn.
          chWorkSheet:Range(cRange):Value = X-Desmat.
          cRange = "D" + cColumn.
          chWorkSheet:Range(cRange):Value = X-Desmar.

          cRange = "E" + cColumn.
          chWorkSheet:Range(cRange):Value = cDesFam.
          cRange = "F" + cColumn.
          chWorkSheet:Range(cRange):Value = cDesSub.


          cRange = "G" + cColumn.
          chWorkSheet:Range(cRange):Value = X-Unidad.
          cRange = "H" + cColumn.
          chWorkSheet:Range(cRange):Value = Almmmate.stkact.
          cRange = "I" + cColumn.
          chWorkSheet:Range(cRange):Value = X-Recont.
          cRange = "J" + cColumn.
          chWorkSheet:Range(cRange):Value = X-Dife.
         
    END. /*IF i <= 15 then...*/
  END.

HIDE FRAME f-Proceso.

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

  DEFINE FRAME F-REP
        Almmmate.codubi FORMAT 'x(10)'
         Almmmate.Codmat
         X-Desmat       FORMAT "X(45)"
         X-Desmar       FORMAT "X(15)"
         X-Unidad       FORMAT "X(5)"
         /*X-Conteo       FORMAT "X(15)" AT 85*/
         Almmmate.stkact AT 92 
         X-Recont       FORMAT "X(15)" AT 115
         X-Dife         FORMAT "X(15)" AT 135 SKIP(1)
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME H-REP
         HEADER
         S-NOMCIA AT 1 FORMAT "X(45)" SKIP
         "( " + S-CODALM + ")"  FORMAT "X(15)"
         x-titulo1 AT 45 FORMAT "X(35)"
         "Pag.  : " AT 115 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         "Fecha : " AT 115 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP 
         X-TITULO2  FORMAT "X(50)" "Hora  :"  AT 115 FORMAT "X(10)" STRING(TIME,"HH:MM:SS")    FORMAT "X(12)" SKIP             
         "------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "Ubicacion  Articulo         Descripcion                         Marca          Unid                 Sistema               Fisico            Diferencia" SKIP
         "------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*                 1         2         3         4         5         6         7         8         9        10        11        12        13
          123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
          1234567890 123456 123456789012345678901234567890123456789012345 123456789012345 12345    >>>>>>>>>                123456789012345     123456789012345
*/
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN . 

        FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
                                   AND  Almmmatg.codfam BEGINS F-CodFam
                                   AND  Almmmatg.subfam BEGINS F-Subfam
                                   AND  (Almmmatg.codmat >= DesdeC
                                   AND   Almmmatg.CodMat <= HastaC)
                                   AND  Almmmatg.CodPr1 BEGINS F-provee1
                                   AND  Almmmatg.Codmar BEGINS F-Marca1
                                   AND  Almmmatg.TpoArt BEGINS R-tipo
                                   AND  Almmmatg.TipArt BEGINS F-Rotacion
                                   AND (x-IP = 'Todos' OR Almmmatg.Chr__03 = x-IP)
                                   /*USE-INDEX matg09*/ ,
              EACH Almmmate NO-LOCK  WHERE Almmmate.Codcia = Almmmatg.Codcia AND
                                           Almmmate.CodAlm = TRIM(S-CODALM)  AND
                                           Almmmate.Codmat = Almmmatg.Codmat BREAK BY Almmmatg.codmat /*BY Almmmatg.Desmat*/:
         I = 1.
           IF i <= 15 then do:
          IF  I-Tipmat = 1 AND Almmmate.StkAct = 0 THEN NEXT.
          ASSIGN 
             X-Desmat = ""
             X-DesMar = ""
             X-Unidad = "".
             
          IF AVAILABLE Almmmatg THEN        
          ASSIGN 
             X-Desmat = Almmmatg.DesMat
             X-DesMar = Almmmatg.DesMar
             X-Unidad = Almmmatg.UndBas.
          DISPLAY Almmmate.Codmat @ Fi-Mensaje LABEL "Codigo de Articulo"
                  FORMAT "X(11)" 
                  WITH FRAME F-Proceso.

          VIEW STREAM REPORT FRAME H-REP.

          DISPLAY STREAM REPORT
                Almmmate.codubi
                Almmmate.Codmat
                X-Desmat       FORMAT "X(45)"
                X-Desmar       FORMAT "X(15)"
                X-Unidad       FORMAT "X(5)"
                /*X-Conteo       FORMAT "X(15)" */
                Almmmate.stkact
                X-Recont       FORMAT "X(15)"
                X-Dife         FORMAT "X(15)" 
                WITH FRAME F-REP.
      
   END.  
  end.
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
    ENABLE ALL .
    
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
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
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
  ASSIGN DesdeC F-CodFam F-SubFam 
         R-TIPO F-DesFam HastaC I-Tipmat
         F-marca1 F-provee1 .

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
    ASSIGN 
        DesdeC F-CodFam F-SubFam 
        R-TIPO F-DesFam HastaC I-Tipmat
        F-marca1 F-provee1.
    FOR EACH Almtabla WHERE Tabla = 'IP' NO-LOCK:
        x-IP:ADD-LAST(Almtabla.codigo).
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
        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-Codfam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        WHEN "" THEN ASSIGN input-var-1 = "".
        WHEN "F-Marca1" THEN ASSIGN input-var-1 = "MK".
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

