&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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

DEFINE        VAR C-OP     AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE        VAR F-PESALM AS DECIMAL NO-UNDO.

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
DEFINE BUFFER T-MATE FOR Almmmate.

/*******/
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.

/* Local Variable Definitions ---                                       */
DEFINE VAR F-Ingreso AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PreIng  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-TotIng  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-Salida  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PreSal  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-TotSal  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-Saldo   AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-VALCTO  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-STKGEN  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PRECIO  AS DECIMAL FORMAT "(>>>,>>9.99)" NO-UNDO.
DEFINE VAR S-SUBTIT  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR S-SUBTIT-1 AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR S-SUBTIT-2 AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR F-SPeso   AS DECIMAL FORMAT "(>,>>>,>>9.99)" NO-UNDO.

DEFINE BUFFER DMOV FOR Almdmov. 

DEFINE VAR I-NROITM  AS INTEGER.

DEFINE TEMP-TABLE  tmp-report LIKE w-report.
DEFINE TEMP-TABLE T-MATG LIKE Almmmatg
    FIELD StkAct AS DEC.

DEFINE VAR T-Ingreso AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR T-Salida  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.


DEFINE VARIABLE F-PREUSSA AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSB AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSC AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSD AS DECIMAL NO-UNDO.

DEFINE VARIABLE F-PRESOLA AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLB AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLC AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLD AS DECIMAL NO-UNDO.

DEFINE VARIABLE mensaje AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacTabla

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 FacTabla.Codigo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH FacTabla ~
      WHERE FacTabla.CodCia = s-codcia ~
 AND FacTabla.Tabla = "MG" NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH FacTabla ~
      WHERE FacTabla.CodCia = s-codcia ~
 AND FacTabla.Tabla = "MG" NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 FacTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 FacTabla


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-57 F-CodFam F-SubFam F-prov1 HastaC ~
DesdeC nCodMon R-Tipo BROWSE-2 TOGGLE-A TOGGLE-B TOGGLE-C TOGGLE-D TOGGLE-E ~
Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS F-CodFam F-DesFam F-SubFam F-DesSub ~
F-prov1 HastaC DesdeC nCodMon R-Tipo TOGGLE-A TOGGLE-B TOGGLE-C TOGGLE-D ~
TOGGLE-E x-mensaje 

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

DEFINE BUTTON Btn_Help 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "A&yuda" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.14 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.14 BY .69 NO-UNDO.

DEFINE VARIABLE F-prov1 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Sub-linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81
     BGCOLOR 7 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2,
"Ambos", 3
     SIZE 25.86 BY .46 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Activados", "A",
"Desactivados", "D",
"Ambos", ""
     SIZE 12.72 BY 1.73 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.92
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.86 BY 13.96.

DEFINE VARIABLE TOGGLE-A AS LOGICAL INITIAL no 
     LABEL "A" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-B AS LOGICAL INITIAL no 
     LABEL "B" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-C AS LOGICAL INITIAL no 
     LABEL "C" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-D AS LOGICAL INITIAL no 
     LABEL "D" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-E AS LOGICAL INITIAL no 
     LABEL "E" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      FacTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 DISPLAY
      FacTabla.Codigo FORMAT "x(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS MULTIPLE SIZE 27 BY 7.31
         FONT 4
         TITLE "Seleccione los Margenes".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodFam AT ROW 1.58 COL 18 COLON-ALIGNED
     F-DesFam AT ROW 1.58 COL 24.29 COLON-ALIGNED NO-LABEL
     F-SubFam AT ROW 2.35 COL 18 COLON-ALIGNED
     F-DesSub AT ROW 2.35 COL 24.29 COLON-ALIGNED NO-LABEL
     F-prov1 AT ROW 3.08 COL 18.14 COLON-ALIGNED
     HastaC AT ROW 3.81 COL 31 COLON-ALIGNED
     DesdeC AT ROW 3.85 COL 18 COLON-ALIGNED
     nCodMon AT ROW 4.81 COL 19.72 NO-LABEL
     R-Tipo AT ROW 5.62 COL 19.72 NO-LABEL
     BROWSE-2 AT ROW 6.96 COL 40
     TOGGLE-A AT ROW 7.54 COL 20
     TOGGLE-B AT ROW 8.31 COL 20
     TOGGLE-C AT ROW 9.08 COL 20
     TOGGLE-D AT ROW 9.85 COL 20
     TOGGLE-E AT ROW 10.62 COL 20
     Btn_OK AT ROW 15.46 COL 46.57
     Btn_Cancel AT ROW 15.46 COL 57.86
     Btn_Help AT ROW 15.46 COL 69.29
     x-mensaje AT ROW 15.54 COL 2 NO-LABEL WIDGET-ID 2
     "Criterio de Seleccion" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     "Moneda" VIEW-AS TEXT
          SIZE 6.86 BY .58 AT ROW 4.77 COL 12
          FONT 6
     "Categoria" VIEW-AS TEXT
          SIZE 9 BY .69 AT ROW 7.92 COL 10
          FONT 1
     "Haga ~"clic~" con el ~"mouse~" en los registros que desee seleccionar" VIEW-AS TEXT
          SIZE 45 BY .5 AT ROW 14.46 COL 35
     "Estado" VIEW-AS TEXT
          SIZE 6.86 BY .69 AT ROW 5.69 COL 12
          FONT 1
     RECT-57 AT ROW 1.27 COL 1.14
     RECT-46 AT ROW 15.23 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.14 BY 16.27
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
         TITLE              = "Catalogo de Precios"
         HEIGHT             = 16.27
         WIDTH              = 81.14
         MAX-HEIGHT         = 16.27
         MAX-WIDTH          = 81.14
         VIRTUAL-HEIGHT     = 16.27
         VIRTUAL-WIDTH      = 81.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
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
                                                                        */
/* BROWSE-TAB BROWSE-2 R-Tipo F-Main */
/* SETTINGS FOR FILL-IN F-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.FacTabla"
     _Where[1]         = "INTEGRAL.FacTabla.CodCia = s-codcia
 AND INTEGRAL.FacTabla.Tabla = ""MG"""
     _FldNameList[1]   > INTEGRAL.FacTabla.Codigo
"FacTabla.Codigo" ? "x(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Catalogo de Precios */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Catalogo de Precios */
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


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help W-Win
ON CHOOSE OF Btn_Help IN FRAME F-Main /* Ayuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
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
   FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA 
                  AND  Almtfami.codfam = F-CodFam 
                 NO-LOCK NO-ERROR.
   IF AVAILABLE Almtfami THEN 
      DISPLAY Almtfami.desfam @ F-DesFam WITH FRAME {&FRAME-NAME}.
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
   FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA 
                  AND  AlmSFami.codfam = F-CodFam 
                  AND  AlmSFami.subfam = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF AVAILABLE AlmSFami THEN DO:
      DISPLAY AlmSFami.dessub @ F-DesSub WITH FRAME {&FRAME-NAME}.
   END.
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


&Scoped-define BROWSE-NAME BROWSE-2
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
  ASSIGN DesdeC F-CodFam F-SubFam F-DesFam HastaC nCodMon R-Tipo F-prov1 .
  ASSIGN TOGGLE-A TOGGLE-B TOGGLE-C TOGGLE-D TOGGLE-E.

  IF HastaC <> "" THEN 
    S-SUBTIT = "Materiales del " + DesdeC + " al " + HastaC .
  ELSE
    S-SUBTIT = "".

  IF HastaC = "" THEN HastaC = "999999999".
/*    
  S-SUBTIT = "Periodo del " + STRING(DesdeF) + " al " + STRING(HastaF).
*/

  IF HastaC = "" THEN HastaC = "999999".
/*  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.*/

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
  DEF VAR x-Categoria AS CHAR NO-UNDO.
  DEF VAR x-Margenes  AS CHAR NO-UNDO.
  DEF VAR x-Margen    AS CHAR NO-UNDO.
  DEF VAR i AS INT NO-UNDO.

  /* borramos temporal */
  FOR EACH T-MATG:
    DELETE T-MATG.
  END.  

  /* Cargamos las categorias validas */
  IF TOGGLE-A = YES
  THEN IF x-Categoria = '' THEN x-Categoria = "A".
        ELSE x-Categoria = x-Categoria + ',' + "A".
  IF TOGGLE-B = YES
  THEN IF x-Categoria = '' THEN x-Categoria = "B".
        ELSE x-Categoria = x-Categoria + ',' + "B".
  IF TOGGLE-C = YES
  THEN IF x-Categoria = '' THEN x-Categoria = "C".
        ELSE x-Categoria = x-Categoria + ',' + "C".
  IF TOGGLE-D = YES
  THEN IF x-Categoria = '' THEN x-Categoria = "D".
        ELSE x-Categoria = x-Categoria + ',' + "D".
  IF TOGGLE-E = YES
  THEN IF x-Categoria = '' THEN x-Categoria = "E".
        ELSE x-Categoria = x-Categoria + ',' + "E".
  /* Cargamos los Margenes */
  DO WITH FRAME {&FRAME-NAME}:
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i)
        THEN IF x-Margenes = '' THEN x-Margenes = FacTabla.Codigo.
                ELSE x-Margenes = x-Margenes + ',' + FacTabla.Codigo.
    END.
  END.

  ASSIGN
    s-SubTit-1 = IF x-Categoria = '' THEN '' ELSE 'CATEGORIA(s): ' + x-Categoria
    s-SubTit-2 = IF x-Margenes = '' THEN '' ELSE 'MARGEN(nes): ' + x-Margenes.
    
  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.Codcia = S-CODCIA  
        AND Almmmatg.codfam BEGINS F-CodFam 
        AND Almmmatg.subfam BEGINS F-SubFam 
        AND (Almmmatg.CodMat >= DesdeC AND Almmmatg.CodMat <= HastaC)
        AND Almmmatg.CodPr1 BEGINS F-prov1
        AND Almmmatg.TpoArt BEGINS R-Tipo:
    
    /*
    DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
        FORMAT "X(11)" WITH FRAME F-Proceso.
    */
    DISPLAY "Codigo de Articulo: " + Almmmatg.CodMat @ x-mensaje
        WITH FRAME {&FRAME-NAME}.

    IF x-Categoria <> ''
    THEN IF LOOKUP(TRIM(Almmmatg.tipart), x-Categoria) = 0 THEN NEXT.
    IF x-Margenes <> ''
    THEN DO:
        /* Definimos el Margen */
        x-Margen = 'X'.
        IF Almmmatg.MrgUti-C <> 0
        THEN DO:
            MARGENES:
            FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
                    AND FacTabla.Tabla = 'MG':
                IF Almmmatg.MrgUti-C >= FacTabla.Valor[1] 
                    AND Almmmatg.MrgUti-C < FacTabla.Valor[2] 
                THEN DO:
                    x-Margen = FacTabla.Codigo.
                    LEAVE MARGENES.
                END.
            END.                    
        END.
        IF x-Margen = 'X' AND Almmmatg.MrgUti-B <> 0
        THEN DO:
            MARGENES:
            FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
                    AND FacTabla.Tabla = 'MG':
                IF Almmmatg.MrgUti-B >= FacTabla.Valor[1] 
                    AND Almmmatg.MrgUti-B < FacTabla.Valor[2] 
                THEN DO:
                    x-Margen = FacTabla.Codigo.
                    LEAVE MARGENES.
                END.
            END.                    
        END.
        IF x-Margen = 'X' AND Almmmatg.MrgUti-A <> 0
        THEN DO:
            MARGENES:
            FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
                    AND FacTabla.Tabla = 'MG':
                IF Almmmatg.MrgUti-A >= FacTabla.Valor[1] 
                    AND Almmmatg.MrgUti-A < FacTabla.Valor[2] 
                THEN DO:
                    x-Margen = FacTabla.Codigo.
                    LEAVE MARGENES.
                END.
            END.                    
        END.
        IF LOOKUP(x-Margen, x-Margenes) = 0 THEN NEXT.
    END.    
    CREATE T-MATG.
    BUFFER-COPY Almmmatg To T-MATG.  
    /* RHC 26.09.05 STOCK TOTAL */
    FOR EACH Almacen WHERE Almacen.codcia = s-codcia 
            AND Almacen.coddiv <> '00000'
            AND Almacen.flgrep = YES NO-LOCK:
        FOR EACH Almmmate WHERE Almmmate.codcia = s-codcia
                AND Almmmate.codalm = Almacen.codalm
                AND Almmmate.codmat = Almmmatg.codmat NO-LOCK:
            ASSIGN 
                T-MATG.StkAct = T-MATG.StkAct + Almmmate.StkAct.
        END.
    END.            
  END.
  /*
  HIDE FRAME F-PROCESO.
  */

  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

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
  DISPLAY F-CodFam F-DesFam F-SubFam F-DesSub F-prov1 HastaC DesdeC nCodMon 
          R-Tipo TOGGLE-A TOGGLE-B TOGGLE-C TOGGLE-D TOGGLE-E x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 F-CodFam F-SubFam F-prov1 HastaC DesdeC nCodMon R-Tipo 
         BROWSE-2 TOGGLE-A TOGGLE-B TOGGLE-C TOGGLE-D TOGGLE-E Btn_OK 
         Btn_Cancel Btn_Help 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-1 W-Win 
PROCEDURE Formato-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE1
               T-MATG.codmat  FORMAT "X(6)"
               T-MATG.DesMat  FORMAT "X(40)"
               T-MATG.DesMar  FORMAT "X(10)"
               T-MATG.UndBas  FORMAT "X(8)"
               T-MATG.MonVta  FORMAT "9"
               F-PRESOLA        FORMAT ">>>,>>9.9999"
/*               F-PREUSSA        FORMAT ">>>,>>9.9999"*/
               T-MATG.UndA    FORMAT "X(8)"
               F-PRESOLB        FORMAT ">>>,>>9.9999"
/*               F-PREUSSB        FORMAT ">>>,>>9.9999"*/
               T-MATG.UndB    FORMAT "X(8)"
               F-PRESOLC        FORMAT ">>>,>>9.9999"
/*               F-PREUSSC        FORMAT ">>>,>>9.9999"*/
               T-MATG.UndC    FORMAT "X(8)"
               F-PRESOLD        FORMAT ">>>,>>9.9999"
/*               F-PREUSSD        FORMAT ">>>,>>9.9999"*/
               T-MATG.Chr__01 FORMAT "X(4)"
               T-MATG.StkAct    FORMAT '->>,>>9.99'
              WITH WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn3}*/ FORMAT "X(50)" AT 1 SKIP
         "LISTADO DE PRECIOS" AT 62
         "Pagina :" TO 125 PAGE-NUMBER(REPORT) TO 137 FORMAT "ZZZZZ9" SKIP
         "Fecha  :" TO 125 TODAY TO 137 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 125 STRING(TIME,"HH:MM") TO 137 SKIP
         mensaje FORMAT "X(28)" SKIP
         s-SubTit-1 s-SubTit-2 SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                        PREC. VTA. (A)        PREC. VTA. (B)         PREC. VTA. (C)      PREC. VTA. OFIC.           " SKIP
        "Codigo D  E  S  C  R  I  P  C  I  O  N          MARCA      U.B.  MONEDA        S/. UM.              S/.  UM.              S/.   UM.             S/.  UM.  STK ACTUAL" SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*                1         2         3         4         5         6         7         8         9        10        11        12        13        14        15                 
         12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         123456 1234567890123456789012345678901234567890 1234567890 12345678 1 >>>,>>9.9999 12345678 >>>,>>9.9999 12345678 >>>,>>9.9999 12345678 >>>,>>9.9999 1234 >>>,>>9.99 
*/

        
      WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH T-MATG NO-LOCK BREAK BY T-MATG.Codfam
                                 BY T-MATG.Subfam
                                 BY T-MATG.CodMar
                                 BY T-MATG.CodMat:

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(T-MATG.CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = T-MATG.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT "FAMILIA : " Almtfami.codfam '    ' Almtfami.desfam SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
      IF FIRST-OF(T-MATG.SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = s-CodCia 
                        AND  Almsfami.codfam = T-MATG.CodFam 
                        AND  Almsfami.subfam = T-MATG.Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT "SUB-FAMILIA : " Almsfami.subfam '   ' AlmSFami.dessub SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
  IF T-MATG.MonVta = 1 THEN DO:
    F-PRESOLA = T-MATG.Prevta[2].
    F-PRESOLB = T-MATG.Prevta[3].
    F-PRESOLC = T-MATG.Prevta[4].
    F-PRESOLD = T-MATG.PreOfi.

    F-PREUSSA = T-MATG.Prevta[2] / T-MATG.TpoCmb.
    F-PREUSSB = T-MATG.Prevta[3] / T-MATG.TpoCmb.
    F-PREUSSC = T-MATG.Prevta[4] / T-MATG.TpoCmb.
    F-PREUSSD = T-MATG.PreOfi / T-MATG.TpoCmb.
  END.
  ELSE DO:
    F-PREUSSA = T-MATG.Prevta[2].
    F-PREUSSB = T-MATG.Prevta[3].
    F-PREUSSC = T-MATG.Prevta[4].
    F-PREUSSD = T-MATG.PreOfi.

    F-PRESOLA = T-MATG.Prevta[2] * T-MATG.TpoCmb.
    F-PRESOLB = T-MATG.Prevta[3] * T-MATG.TpoCmb.
    F-PRESOLC = T-MATG.Prevta[4] * T-MATG.TpoCmb.
    F-PRESOLD = T-MATG.PreOfi * T-MATG.TpoCmb.
  END.
         
      DISPLAY STREAM REPORT 
               T-MATG.codmat
               T-MATG.DesMat
               T-MATG.DesMar
               T-MATG.UndBas
               T-MATG.MonVta
               F-PRESOLA    WHEN F-PRESOLA <> 0
/*               F-PREUSSA  WHEN F-PREUSSA <> 0 */ 
               T-MATG.UndA    WHEN T-MATG.UndA <> ""
               F-PRESOLB    WHEN F-PRESOLB <> 0 
/*               F-PREUSSB  WHEN F-PREUSSB <> 0 */
               T-MATG.UndB    WHEN T-MATG.UndB <> "" 
               F-PRESOLC    WHEN F-PRESOLC <> 0
/*               F-PREUSSC  WHEN F-PREUSSC <> 0 */
               T-MATG.UndC    WHEN T-MATG.UndC <> ""
               F-PRESOLD    WHEN F-PRESOLD <> 0
/*               F-PREUSSD  WHEN F-PREUSSD <> 0 */
               T-MATG.Chr__01 WHEN T-MATG.Chr__01 <> ""
               T-MATG.StkAct
               WITH FRAME F-REPORTE1.
      DOWN STREAM REPORT WITH FRAME F-REPORTE1.
       
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-2 W-Win 
PROCEDURE Formato-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE2
               T-MATG.codmat  FORMAT "X(6)"
               T-MATG.DesMat  FORMAT "X(40)"
               T-MATG.DesMar  FORMAT "X(10)"
               T-MATG.UndBas  FORMAT "X(8)"
               T-MATG.MonVta  FORMAT "9"
/*               F-PRESOLA        FORMAT ">>>,>>9.9999"*/
               F-PREUSSA        FORMAT ">>>,>>9.9999"
               T-MATG.UndA    FORMAT "X(8)"
/*               F-PRESOLB        FORMAT ">>>,>>9.9999"*/
               F-PREUSSB        FORMAT ">>>,>>9.9999"
               T-MATG.UndB    FORMAT "X(8)"
/*               F-PRESOLC        FORMAT ">>>,>>9.9999"*/
               F-PREUSSC        FORMAT ">>>,>>9.9999"
               T-MATG.UndC    FORMAT "X(8)"
/*               F-PRESOLD        FORMAT ">>>,>>9.9999"*/
               F-PREUSSD        FORMAT ">>>,>>9.9999"
               T-MATG.Chr__01 FORMAT "X(4)"
               T-MATG.StkAct    FORMAT '->>,>>9.99'
              WITH WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn3}*/ FORMAT "X(50)" AT 1 SKIP
         "LISTADO DE PRECIOS" AT 62
         "Pagina :" TO 125 PAGE-NUMBER(REPORT) TO 137 FORMAT "ZZZZZ9" SKIP
         "Fecha  :" TO 125 TODAY TO 137 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 125 STRING(TIME,"HH:MM") TO 137 SKIP
         mensaje FORMAT "X(28)" SKIP
         s-SubTit-1 s-SubTit-2 SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                        PREC. VTA. (A)        PREC. VTA. (B)         PREC. VTA. (C)      PREC. VTA. OFIC.           " SKIP
        "Codigo D  E  S  C  R  I  P  C  I  O  N          MARCA      U.B.  MONEDA       USS. UM.             USS.  UM.             USS.   UM.            USS.  UM.  STK ACTUAL" SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
      WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH T-MATG NO-LOCK BREAK BY T-MATG.Codfam
                                 BY T-MATG.Subfam
                                 BY T-MATG.CodMar
                                 BY T-MATG.CodMat:

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(T-MATG.CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = T-MATG.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT "FAMILIA : " Almtfami.codfam '    ' Almtfami.desfam SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
      IF FIRST-OF(T-MATG.SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = s-CodCia 
                        AND  Almsfami.codfam = T-MATG.CodFam 
                        AND  Almsfami.subfam = T-MATG.Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT "SUB-FAMILIA : " Almsfami.subfam '   ' AlmSFami.dessub SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
  IF T-MATG.MonVta = 1 THEN DO:
    F-PRESOLA = T-MATG.Prevta[2].
    F-PRESOLB = T-MATG.Prevta[3].
    F-PRESOLC = T-MATG.Prevta[4].
    F-PRESOLD = T-MATG.PreOfi.

    F-PREUSSA = T-MATG.Prevta[2] / T-MATG.TpoCmb.
    F-PREUSSB = T-MATG.Prevta[3] / T-MATG.TpoCmb.
    F-PREUSSC = T-MATG.Prevta[4] / T-MATG.TpoCmb.
    F-PREUSSD = T-MATG.PreOfi / T-MATG.TpoCmb.
  END.
  ELSE DO:
    F-PREUSSA = T-MATG.Prevta[2].
    F-PREUSSB = T-MATG.Prevta[3].
    F-PREUSSC = T-MATG.Prevta[4].
    F-PREUSSD = T-MATG.PreOfi.

    F-PRESOLA = T-MATG.Prevta[2] * T-MATG.TpoCmb.
    F-PRESOLB = T-MATG.Prevta[3] * T-MATG.TpoCmb.
    F-PRESOLC = T-MATG.Prevta[4] * T-MATG.TpoCmb.
    F-PRESOLD = T-MATG.PreOfi * T-MATG.TpoCmb.
  END.
         
      DISPLAY STREAM REPORT 
               T-MATG.codmat
               T-MATG.DesMat
               T-MATG.DesMar
               T-MATG.UndBas
               T-MATG.MonVta
/*               F-PRESOLA  WHEN F-PRESOLA <> 0 */
               F-PREUSSA    WHEN F-PREUSSA <> 0
               T-MATG.UndA    WHEN T-MATG.UndA <> ""
/*               F-PRESOLB  WHEN F-PRESOLB <> 0 */
               F-PREUSSB    WHEN F-PREUSSB <> 0
               T-MATG.UndB    WHEN T-MATG.UndB <> "" 
/*               F-PRESOLC  WHEN F-PRESOLC <> 0*/
               F-PREUSSC    WHEN F-PREUSSC <> 0
               T-MATG.UndC    WHEN T-MATG.UndC <> ""
/*               F-PRESOLD  WHEN F-PRESOLD <> 0 */
               F-PREUSSD    WHEN F-PREUSSD <> 0
               T-MATG.Chr__01 WHEN T-MATG.Chr__01 <> ""
               T-MATG.StkAct
               WITH FRAME F-REPORTE2.
      DOWN STREAM REPORT WITH FRAME F-REPORTE2.
       
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-3 W-Win 
PROCEDURE Formato-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE FRAME F-REPORTE
               T-MATG.codmat  FORMAT "X(6)"
               T-MATG.DesMat  FORMAT "X(40)"
               T-MATG.DesMar  FORMAT "X(10)"
               T-MATG.UndBas  FORMAT "X(8)"
               T-MATG.MonVta  FORMAT "9"
               F-PRESOLA        FORMAT ">>>,>>9.9999"
               F-PREUSSA        FORMAT ">>>,>>9.9999"
               T-MATG.UndA    FORMAT "X(8)"
               F-PRESOLB        FORMAT ">>>,>>9.9999"
               F-PREUSSB        FORMAT ">>>,>>9.9999"
               T-MATG.UndB    FORMAT "X(8)"
               F-PRESOLC        FORMAT ">>>,>>9.9999"
               F-PREUSSC        FORMAT ">>>,>>9.9999"
               T-MATG.UndC    FORMAT "X(8)"
               F-PRESOLD        FORMAT ">>>,>>9.9999"
               F-PREUSSD        FORMAT ">>>,>>9.9999"
               T-MATG.Chr__01 FORMAT "X(4)"
               T-MATG.StkAct    FORMAT '->>,>>9.99'
              WITH WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn3}*/ FORMAT "X(50)" AT 1 SKIP
         "LISTADO DE PRECIOS" AT 62
         "Pagina :" TO 125 PAGE-NUMBER(REPORT) TO 137 FORMAT "ZZZZZ9" SKIP
         S-DESALM  FORMAT "X(30)" AT 56
         "Fecha  :" TO 125 TODAY TO 137 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 125 STRING(TIME,"HH:MM") TO 137 SKIP
         mensaje FORMAT "X(28)" SKIP
         s-SubTit-1 s-SubTit-2 SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                               PRECIO DE VTA. (A)                PRECIO DE VTA. (B)                 PRECIO DE VTA. (C)                 PRECIO DE VTA. OFICINA            " SKIP
        "Codigo D  E  S  C  R  I  P  C  I  O  N          MARCA      U.B.  MONEDA        S/.        USS$. UM.              S/.         USS$. UM.              S/.         USS$.  UM.             S/.          USS$.  UM. STK ACTUAL" SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
      WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH T-MATG NO-LOCK BREAK BY T-MATG.Codfam
                                 BY T-MATG.Subfam
                                 BY T-MATG.CodMar
                                 BY T-MATG.CodMat:

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(T-MATG.CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = T-MATG.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT "FAMILIA : " Almtfami.codfam '    ' Almtfami.desfam SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
      IF FIRST-OF(T-MATG.SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = s-CodCia 
                        AND  Almsfami.codfam = T-MATG.CodFam 
                        AND  Almsfami.subfam = T-MATG.Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT "SUB-FAMILIA : " Almsfami.subfam '   ' AlmSFami.dessub SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
/*      IF FIRST-OF(T-MATG.prove) THEN DO:
 *          FIND GN-PROV WHERE GN-PROV.CODCIA = 0 
 *                        AND  GN-PROV.CODPRO = T-MATG.prove 
 *                       NO-LOCK NO-ERROR.
 *          IF AVAILABLE GN-PROV THEN DO:
 *              PUT STREAM REPORT "PROVEEDOR : " T-MATG.prove '    ' gn-prov.NomPro SKIP.
 *              PUT STREAM REPORT '      ------------------------------------------' SKIP.
 *          END.  
 *       END.*/

  IF T-MATG.MonVta = 1 THEN DO:
    F-PRESOLA = T-MATG.Prevta[2].
    F-PRESOLB = T-MATG.Prevta[3].
    F-PRESOLC = T-MATG.Prevta[4].
    F-PRESOLD = T-MATG.PreOfi.

    F-PREUSSA = T-MATG.Prevta[2] / T-MATG.TpoCmb.
    F-PREUSSB = T-MATG.Prevta[3] / T-MATG.TpoCmb.
    F-PREUSSC = T-MATG.Prevta[4] / T-MATG.TpoCmb.
    F-PREUSSD = T-MATG.PreOfi / T-MATG.TpoCmb.
  END.
  ELSE DO:
    F-PREUSSA = T-MATG.Prevta[2].
    F-PREUSSB = T-MATG.Prevta[3].
    F-PREUSSC = T-MATG.Prevta[4].
    F-PREUSSD = T-MATG.PreOfi.

    F-PRESOLA = T-MATG.Prevta[2] * T-MATG.TpoCmb.
    F-PRESOLB = T-MATG.Prevta[3] * T-MATG.TpoCmb.
    F-PRESOLC = T-MATG.Prevta[4] * T-MATG.TpoCmb.
    F-PRESOLD = T-MATG.PreOfi * T-MATG.TpoCmb.
  END.
         
      DISPLAY STREAM REPORT 
               T-MATG.codmat
               T-MATG.DesMat
               T-MATG.DesMar
               T-MATG.UndBas
               T-MATG.MonVta
               F-PRESOLA    WHEN F-PRESOLA <> 0
               F-PREUSSA    WHEN F-PREUSSA <> 0
               T-MATG.UndA    WHEN T-MATG.UndA <> ""
               F-PRESOLB    WHEN F-PRESOLB <> 0
               F-PREUSSB    WHEN F-PREUSSB <> 0
               T-MATG.UndB    WHEN T-MATG.UndB <> "" 
               F-PRESOLC    WHEN F-PRESOLC <> 0
               F-PREUSSC    WHEN F-PREUSSC <> 0
               T-MATG.UndC    WHEN T-MATG.UndC <> ""
               F-PRESOLD    WHEN F-PRESOLD <> 0
               F-PREUSSD    WHEN F-PREUSSD <> 0
               T-MATG.Chr__01 WHEN T-MATG.Chr__01 <> ""
               T-MATG.StkAct
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.
       
  END.

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
    ENABLE ALL EXCEPT F-DesFam F-DesSub x-mensaje.
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
/*  RUN bin/_prnctr.p.*/
  RUN lib/imprimir2.
  IF s-salida-impresion = 0 THEN RETURN.
   
  RUN Carga-Temporal.
  FIND FIRST T-MATG NO-LOCK NO-ERROR.
  IF NOT AVAILABLE T-MATG
  THEN DO:
    MESSAGE 'NO existen registros a imprimir' VIEW-AS ALERT-BOX WARNING.
    RETURN.
  END.

  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
/*  RUN aderb/_prlist.p(
 *       OUTPUT s-printer-list,
 *       OUTPUT s-port-list,
 *       OUTPUT s-printer-count).
 *   s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
 *   s-port-name = REPLACE(S-PORT-NAME, ":", "").*/

  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + "report.prn".
  
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
/*        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */*/
        WHEN 2 THEN OUTPUT STREAM REPORT TO PRINTER             PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.
  
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  CASE nCodMon:
    WHEN 1 THEN 
        mensaje = "EXPRESADO EN SOLES".
    WHEN 2 THEN 
        mensaje = "EXPRESADO EN DOLARES".
    WHEN 3 THEN 
        mensaje = "EXPRESADO EN SOLES/DOLARES".
  END CASE.  
  
  CASE nCodMon:
    WHEN 1 THEN 
        RUN Formato-1.
    WHEN 2 THEN 
        RUN Formato-2.
    WHEN 3 THEN 
        RUN Formato-3.
  END CASE.  
  
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.
  
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/W-README.R(s-print-file).
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
  ASSIGN DesdeC F-CodFam F-DesFam HastaC nCodMon R-Tipo.
  
  IF HastaC <> "" THEN HastaC = "".
/*  IF DesdeF <> ?  THEN DesdeF = ?.
  IF HastaF <> ?  THEN HastaF = ?.*/

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
     ASSIGN /*DesdeF = TODAY  + 1 - DAY(TODAY).
 *             HastaF = TODAY.*/
            R-Tipo = 'A'.
     DISPLAY /*DesdeF HastaF*/ R-Tipo.
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
        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        WHEN "F-marca1" OR WHEN "F-marca2" THEN ASSIGN input-var-1 = "MK".
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "FacTabla"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _Header W-Win 
PROCEDURE _Header :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
titulo = "REPORTE DE MOVIMIENTOS POR DIA".

mens1 = "TIPO Y CODIGO DE MOVIMIENTO : " + C-TipMov + "-" + STRING(I-CodMov, "99") + " " + D-Movi:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
mens2 = "MATERIAL : " + DesdeC + " A: " + HastaC .
mens3 = "FECHA : " + STRING(F-FchDes, "99/99/9999") + " A: " + STRING(F-FchHas, "99/99/9999").

titulo = S-NomCia + fill(" ", (INT((90 - length(titulo)) / 2)) - length(S-NomCia)) + titulo.
mens1 = fill(" ", INT((90 - length(mens1)) / 2)) + mens1.
mens2 = fill(" ", INT((90 - length(mens2)) / 2)) + mens2.
mens3 = C-condicion:SCREEN-VALUE + fill(" ", INT((90 - length(mens3)) / 2) - LENGTH(C-condicion:SCREEN-VALUE)) + mens3.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

