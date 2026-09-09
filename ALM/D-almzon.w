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

DEFINE VAR X-TITULO1 AS CHAR .
DEFINE VAR X-TITULO2 AS CHAR .
DEFINE VAR X-DESMAT  AS CHAR.
DEFINE VAR X-DESMAR  AS CHAR.
DEFINE VAR X-UNIDAD  AS CHAR.
DEFINE VAR x-nompro AS CHARACTER.
DEFINE VAR F-STKGEN AS DECI.
DEFINE VAR F-STKMIN AS DECI.
DEFINE VAR F-STKALM AS DECI.
DEFINE VAR F-PESALM AS DECI.
DEFINE VAR F-CM3 AS DECI.

define stream REPORT.

DEFINE TEMP-TABLE tt-data
    FIELDS  codubi  AS      CHAR    FORMAT 'x(10)'  COLUMN-LABEL "Ubicaicion"
    FIELDS  CodArt  AS      CHAR    FORMAT '(x(7)'  COLUMN-LABEL "Cod.Mat"
    FIELDS  Desmat  AS      CHAR    FORMAT 'x(60)'  COLUMN-LABEL "Descripcion"
    FIELDS  Marca   AS      CHAR    FORMAT 'x(25)'  COLUMN-LABEL "Marca"
    FIELDS  UndStk  AS      CHAR    FORMAT 'x(10)'  COLUMN-LABEL "U.M. Stk"
    FIELDS  Stock   AS      DEC     FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock"
    FIELDS  Peso    AS      DEC     FORMAT "->>,>>>,>>9.9999" COLUMN-LABEL "Peso"
    FIELDS  Vol     AS      DEC     FORMAT "->>,>>>,>>9.9999" COLUMN-LABEL "Volumen".

/*
PUT STREAM REPORT
  "CodUbi|"
  "CodArt|"
  "Descripcion|"
  "Marca|"
  "UND Stk|"
  "Stock|" 
  "Peso|" 
  "Vol|" SKIP.
*/

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
&Scoped-Define ENABLED-OBJECTS TOGGLE-1 DesdeC HastaC Zona-D Zona-H Btn_OK ~
Btn_Cancel R-Tipo C-tipo RECT-58 RECT-59 RECT-60 RECT-62 RECT-65 
&Scoped-Define DISPLAYED-OBJECTS ChbxTexto TOGGLE-1 F-CodFam F-SubFam ~
DesdeC HastaC F-marca1 Zona-D Zona-H F-DesFam F-DesSub R-Tipo C-tipo 

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

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE C-tipo AS CHARACTER FORMAT "X(256)":U INITIAL "Con-Stock" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Con-Stock","Todos" 
     DROP-DOWN-LIST
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo del" 
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

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .81 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Al" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE Zona-D AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ubicacion del" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE Zona-H AS CHARACTER FORMAT "X(256)":U 
     LABEL "Al" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER INITIAL "A" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ambos", "",
"Activados", "A",
"Desactivados", "D"
     SIZE 12.86 BY 1.92 NO-UNDO.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18.29 BY 3.38.

DEFINE RECTANGLE RECT-59
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 3.77.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 2.12.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 1.81.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18.29 BY 2.19.

DEFINE VARIABLE ChbxTexto AS LOGICAL INITIAL yes 
     LABEL "Enviar a TXT" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Solo SIN ubicacion ( vacio ó G-0)" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     ChbxTexto AT ROW 7.92 COL 53 WIDGET-ID 2
     TOGGLE-1 AT ROW 5.42 COL 12
     F-CodFam AT ROW 1.54 COL 9.86 COLON-ALIGNED
     F-SubFam AT ROW 2.42 COL 9.86 COLON-ALIGNED
     DesdeC AT ROW 3.73 COL 11.57 COLON-ALIGNED
     HastaC AT ROW 3.73 COL 38.43 COLON-ALIGNED
     F-marca1 AT ROW 4.46 COL 9.86 COLON-ALIGNED
     Zona-D AT ROW 6.38 COL 13.57 COLON-ALIGNED
     Zona-H AT ROW 6.38 COL 38.57 COLON-ALIGNED
     Btn_OK AT ROW 7.54 COL 17.86
     Btn_Cancel AT ROW 7.54 COL 37.86
     F-DesFam AT ROW 1.5 COL 16.14 COLON-ALIGNED NO-LABEL
     F-DesSub AT ROW 2.42 COL 16.14 COLON-ALIGNED NO-LABEL
     R-Tipo AT ROW 2.62 COL 54.86 NO-LABEL
     C-tipo AT ROW 6.04 COL 53.14 COLON-ALIGNED NO-LABEL
     "Tipo" VIEW-AS TEXT
          SIZE 7.14 BY .69 AT ROW 5.19 COL 58
          FONT 1
     "Estado" VIEW-AS TEXT
          SIZE 7.14 BY .69 AT ROW 1.69 COL 57.57
          FONT 1
     RECT-58 AT ROW 1.38 COL 51.86
     RECT-59 AT ROW 3.58 COL 3.72
     RECT-60 AT ROW 1.38 COL 3.72
     RECT-62 AT ROW 7.35 COL 4
     RECT-65 AT ROW 5 COL 51.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70.29 BY 9.31
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
         TITLE              = "Articulos Zonificados Por Almacen"
         HEIGHT             = 8.65
         WIDTH              = 69.86
         MAX-HEIGHT         = 11.73
         MAX-WIDTH          = 81.72
         VIRTUAL-HEIGHT     = 11.73
         VIRTUAL-WIDTH      = 81.72
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
/* SETTINGS FOR TOGGLE-BOX ChbxTexto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-CodFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-marca1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-SubFam IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Articulos Zonificados Por Almacen */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Articulos Zonificados Por Almacen */
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


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN ChbxTexto.

  RUN Asigna-Variables.
  RUN Inhabilita.
  IF ChbxTexto = YES THEN DO:
      RUN ue-txt.
  END.
  ELSE RUN Imprime.

  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-tipo W-Win
ON VALUE-CHANGED OF C-tipo IN FRAME F-Main
DO:
  ASSIGN C-Tipo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Articulo del */
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
ON LEAVE OF HastaC IN FRAME F-Main /* Al */
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


&Scoped-define SELF-NAME TOGGLE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-1 W-Win
ON VALUE-CHANGED OF TOGGLE-1 IN FRAME F-Main /* Solo SIN ubicacion ( vacio ó G-0) */
DO:
  IF INPUT {&SELF-NAME} = Yes 
  THEN ASSIGN
            Zona-D:SCREEN-VALUE = ''
            Zona-H:SCREEN-VALUE = ''
            Zona-D:SENSITIVE = NO
            Zona-H:SENSITIVE = NO.
  ELSE ASSIGN
            Zona-D:SENSITIVE = YES
            Zona-H:SENSITIVE = YES.
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
         R-TIPO F-DesFam HastaC
         F-marca1  C-Tipo Zona-D Zona-H
         TOGGLE-1.

  IF HastaC = "" THEN HastaC = "999999999".
  IF Zona-H = "" THEN Zona-H = "ZZZZZZZZZZZ".
         
  X-titulo1 = "PRODUCTOS ZONIFICADOS POR ALMACEN".
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
  DISPLAY ChbxTexto TOGGLE-1 F-CodFam F-SubFam DesdeC HastaC F-marca1 Zona-D 
          Zona-H F-DesFam F-DesSub R-Tipo C-tipo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE TOGGLE-1 DesdeC HastaC Zona-D Zona-H Btn_OK Btn_Cancel R-Tipo C-tipo 
         RECT-58 RECT-59 RECT-60 RECT-62 RECT-65 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

DEFINE VAR lSubTotZon AS DECIMAL.
DEFINE VAR lVolZona AS CHAR.
DEFINE VAR lDesZona AS CHAR.

  DEFINE FRAME F-REPORTE
         SPACE(1)
         Almmmatg.codmat AT 1  COLUMN-LABEL "Codigo" FORMAT "X(9)"
         Almmmatg.DesMat AT 12  COLUMN-LABEL "Descripcion" FORMAT "X(55)"
         Almmmatg.DesMar AT 69  COLUMN-LABEL "Marca" FORMAT "X(15)"
         Almmmatg.UndStk AT 86  COLUMN-LABEL "Unidad" FORMAT "X(10)"
         F-STKALM        AT 98  COLUMN-LABEL "Cantidad" FORMAT "->,>>>,>>9.99"
         F-PESALM        AT 114 FORMAT "->,>>>,>>9.99"
         F-CM3           AT 129 FORMAT "->>,>>>,>>9.99"
         HEADER
         S-NOMCIA FORMAT "X(45)" SKIP
         "( " + S-CODALM + ")"  FORMAT "X(15)"
         x-titulo1 AT 45 FORMAT "X(35)"
         "Pagina : " TO 113 PAGE-NUMBER(REPORT) TO 123 FORMAT "ZZZZZ9" SKIP
         " Fecha : " TO 113 TODAY TO 123 FORMAT "99/99/9999" SKIP
         "  Hora : " TO 113 STRING(TIME,"HH:MM:SS") TO 123 SKIP(1)
         "------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                                                                                                " SKIP
         " Codigo   Descripcion                                               Marca          Unidad             Stock              Peso     Volumen (m3)  " SKIP
         "------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
      /* */
  WITH WIDTH 160 NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO DOWN.

    lSubTotZon = 0.

    FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
                               AND  (Almmmatg.codmat >= DesdeC
                               AND   Almmmatg.CodMat <= HastaC)
                               AND  Almmmatg.TpoArt BEGINS R-tipo
                               USE-INDEX matg01 ,
          EACH Almmmate NO-LOCK  WHERE Almmmate.Codcia = Almmmatg.Codcia AND
                                       Almmmate.CodAlm = TRIM(S-CODALM)  AND
                                       Almmmate.Codmat = Almmmatg.Codmat /*AND
                                       (TOGGLE-1 = Yes OR (Almmmate.CodUbi >= Zona-D  AND Almmmate.CodUbi <= Zona-H))*/
                                       BREAK BY Almmmate.CodUbi 
                                             BY Almmmate.Codmat:

        IF TOGGLE-1 = YES THEN DO:
            IF (Almmmate.codubi <> '' AND Almmmate.codubi <> 'G-0')  THEN NEXT.
        END.
                    
        IF TOGGLE-1 = NO AND NOT (Almmmate.CodUbi >= Zona-D  AND Almmmate.CodUbi <= Zona-H)
        THEN NEXT.
        
      DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      
      F-STKALM = Almmmate.StkAct.

      IF FIRST-OF(Almmmate.CodUbi) THEN DO:
          FIND almtubic WHERE almtubic.CodCia = S-CODCIA
                         AND  almtubic.CodAlm = S-CODALM
                         AND  almtubic.CodUbi = Almmmate.CodUbi 
                        NO-LOCK NO-ERROR.
          lDesZona = ''.
          IF AVAILABLE almtubic THEN           
            /*lDesZona = TRIM(almtubic.DesUbi) + " (" + TRIM(almtubic.codzona) + ")"*/
            DISPLAY STREAM REPORT 
            Almmmate.CodUbi @ Almmmatg.CodMat  
            almtubic.DesUbi  @ Almmmatg.desmat   
            WITH FRAME F-REPORTE.
          ELSE 
            DISPLAY STREAM REPORT 
            Almmmate.CodUbi @ Almmmatg.CodMat  
            " "             @ Almmmatg.desmat
           WITH FRAME F-REPORTE.

           UNDERLINE STREAM REPORT 
            Almmmatg.CodMat  
            Almmmatg.desmat
           WITH FRAME F-REPORTE.
      END.    

      IF (C-tipo = "Con-Stock" AND F-STKALM > 0) OR C-tipo = "Todos" THEN DO:
            F-PESALM = F-STKALM * Almmmatg.Pesmat.
            F-CM3 = F-STKALM * (almmmatg.libre_d02 / 1000000).   /* El volumen esta expresado en CM3 */
            lSubTotZon = lSubTotZon + F-CM3.
            DISPLAY STREAM REPORT 
                 Almmmatg.codmat 
                 Almmmatg.DesMat 
                 Almmmatg.Desmar
                 Almmmatg.UndStk 
                 F-STKALM 
                 F-PESALM WHEN F-PESALM > 0 
                 F-CM3
                 WITH FRAME F-REPORTE.
      END.

      IF LAST-OF(Almmmate.CodUbi) THEN DO:
          DOWN 2 STREAM REPORT WITH FRAME F-REPORTE.
          F-CM3 = lSubTotZon.
          lVolZona = IF AVAILABLE almtubic THEN STRING(almtubic.libre_d01,'>>>,>>9.99') ELSE ''.
         DISPLAY STREAM REPORT 
          " " @ Almmmatg.CodMat  
          "      ** Sub Total ZONA ****" @ Almmmatg.desmat
          ' Vol Zona '  @ Almmmatg.desmar
          lVolZona @ Almmmatg.UndStk
          
          F-CM3
         WITH FRAME F-REPORTE.
    
        lSubTotZon = (lSubTotZon / almtubic.libre_d01) * 100.

        DOWN 2 STREAM REPORT WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            " " @ Almmmatg.CodMat  
            "      Zona ocupada en un (" + STRING(lSubTotZon,'>>9.99') + ")" @ Almmmatg.desmat
        WITH FRAME F-REPORTE.

        lSubTotZon = 100 - lSubTotZon.
        DOWN 2 STREAM REPORT WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            " " @ Almmmatg.CodMat  
            "      Zona libre en un (" + STRING(lSubTotZon,'>>9.99') + ")" @ Almmmatg.desmat
        WITH FRAME F-REPORTE.

        DOWN 2 STREAM REPORT WITH FRAME F-REPORTE.
        lSubTotZon = 0.

      END.    

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
    ENABLE ALL EXCEPT F-Desfam F-DesSub.
    TOGGLE-1:SCREEN-VALUE = 'No'.
    
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
         R-TIPO F-DesFam HastaC
         F-marca1  C-Tipo Zona-D Zona-H.
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
  ASSIGN DesdeC F-CodFam F-SubFam 
         R-TIPO F-DesFam HastaC
         F-marca1  C-Tipo Zona-D Zona-H.

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
        WHEN "F-marca1"  THEN ASSIGN input-var-1 = "MK".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-txt W-Win 
PROCEDURE ue-txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE x-Archivo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-rpta    AS LOGICAL     NO-UNDO.

DEFINE VAR lSubTotZon AS DECIMAL.
DEFINE VAR lVolZona AS CHAR.
DEFINE VAR lDesZona AS CHAR.

x-Archivo = 'UbicacionesArticulos.xlsx'.
SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Excel' '*.xlsx'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.xlsx'
    INITIAL-DIR 'c:\tmp'
    RETURN-TO-START-DIR 
    USE-FILENAME
    SAVE-AS
    UPDATE x-rpta.
  IF x-rpta = NO THEN RETURN.

EMPTY TEMP-TABLE tt-data.

FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
                           AND  (Almmmatg.codmat >= DesdeC
                           AND   Almmmatg.CodMat <= HastaC)
                           AND  Almmmatg.TpoArt BEGINS R-tipo
                           USE-INDEX matg01 ,
      EACH Almmmate NO-LOCK  WHERE Almmmate.Codcia = Almmmatg.Codcia AND
                                   Almmmate.CodAlm = TRIM(S-CODALM)  AND
                                   Almmmate.Codmat = Almmmatg.Codmat /*AND
                                   (TOGGLE-1 = Yes OR (Almmmate.CodUbi >= Zona-D  AND Almmmate.CodUbi <= Zona-H))*/
                                   BREAK BY Almmmate.CodUbi 
                                         BY Almmmate.Codmat:

    /*IF TOGGLE-1 = YES AND Almmmate.codubi <> '' THEN NEXT.*/
    IF TOGGLE-1 = YES THEN DO:
        IF (Almmmate.codubi <> '' AND Almmmate.codubi <> 'G-0')  THEN NEXT.
    END.

    IF TOGGLE-1 = NO AND NOT (Almmmate.CodUbi >= Zona-D  AND Almmmate.CodUbi <= Zona-H) THEN NEXT.

    /* Mensaje Pantalla */    
    DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

    lDesZona = "".
    F-STKALM = Almmmate.StkAct.
    IF (C-tipo = "Con-Stock" AND F-STKALM > 0) OR C-tipo = "Todos" THEN DO:
        
        FIND almtubic WHERE almtubic.CodCia = S-CODCIA
                       AND  almtubic.CodAlm = S-CODALM
                       AND  almtubic.CodUbi = Almmmate.CodUbi NO-LOCK NO-ERROR.
      IF AVAILABLE almtubic THEN lDesZona = almtubic.DesUbi.
        F-PESALM = F-STKALM * Almmmatg.Pesmat.
        F-CM3 = F-STKALM * (almmmatg.libre_d02 / 1000000).   /* El volumen esta expresado en CM3 */
        lSubTotZon = lSubTotZon + F-CM3.
    
      CREATE tt-data.
        ASSIGN  tt-data.codubi  = Almmmate.CodUbi
                tt-data.CodArt  = Almmmatg.codmat
                tt-data.Desmat  = Almmmatg.Desmat
                tt-data.Marca   = Almmmatg.Desmar
                tt-data.UndStk  = Almmmatg.UndStk
                tt-data.Stock   = F-STKALM
                tt-data.Peso    = F-PESALM
                tt-data.Vol     = F-CM3.      
    END.
END.

HIDE FRAME F-PROCESO.

/* Imprimir */
DEFINE VAR hProc AS HANDLE NO-UNDO.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

RUN lib\Tools-to-excel PERSISTENT SET hProc.

c-xls-file = x-Archivo.

run pi-crea-archivo-csv IN hProc (input  buffer tt-data:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-data:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.


MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

