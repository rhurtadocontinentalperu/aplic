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

DEFINE        VAR C-OP     AS CHAR.
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR pv-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA  AS CHARACTER.
DEFINE        VAR F-PESALM  AS DECIMAL NO-UNDO.

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
DEFINE VAR F-SPeso   AS DECIMAL FORMAT "(>,>>>,>>9.99)" NO-UNDO.

DEFINE BUFFER DMOV FOR Almdmov. 

DEFINE VAR I-NROITM  AS INTEGER.

DEFINE TEMP-TABLE  tmp-report LIKE w-report.


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

DEFINE VAR X-TITU    AS CHAR INIT "MARGENES  PRECIOS  DE  VENTA ".
DEFINE VAR X-ARTI    AS CHAR.
DEFINE VAR X-FAMILIA AS CHAR.
DEFINE VAR X-SUBFAMILIA AS CHAR.
DEFINE VAR X-PROVE    AS CHAR.
DEFINE VAR C-TIPO     AS CHAR INIT "Reporte".

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
&Scoped-Define ENABLED-OBJECTS F-CodFam F-SubFam F-prov1 f-cate DesdeC ~
HastaC F-Rango R-Tipo Btn_OK Btn_Cancel Btn_Help RECT-64 RECT-65 RECT-66 
&Scoped-Define DISPLAYED-OBJECTS F-CodFam F-SubFam F-prov1 f-cate DesdeC ~
HastaC F-Rango R-Tipo F-DesFam F-DesSub 

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

DEFINE VARIABLE f-cate AS CHARACTER FORMAT "X":U 
     LABEL "Categoria" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .69 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30.72 BY .69 NO-UNDO.

DEFINE VARIABLE F-prov1 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-Rango AS DECIMAL FORMAT "->>9.99":U INITIAL 100 
     LABEL "Margen Menores" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Sub-linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Activados", "A",
"Desactivados", "D",
"Ambos", ""
     SIZE 12.72 BY 1.73 NO-UNDO.

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 6.08.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15.57 BY 6.04.

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65.86 BY 1.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodFam AT ROW 1.88 COL 12.14 COLON-ALIGNED
     F-SubFam AT ROW 2.65 COL 12.14 COLON-ALIGNED
     F-prov1 AT ROW 3.42 COL 12.14 COLON-ALIGNED
     f-cate AT ROW 4.23 COL 12.29 COLON-ALIGNED
     DesdeC AT ROW 5 COL 12.14 COLON-ALIGNED
     HastaC AT ROW 5 COL 28.86 COLON-ALIGNED
     F-Rango AT ROW 5.96 COL 12.43 COLON-ALIGNED
     R-Tipo AT ROW 2.04 COL 53.43 NO-LABEL
     Btn_OK AT ROW 7.35 COL 33.14
     Btn_Cancel AT ROW 7.35 COL 44.43
     Btn_Help AT ROW 7.35 COL 55.86
     F-DesFam AT ROW 1.88 COL 18.43 COLON-ALIGNED NO-LABEL
     F-DesSub AT ROW 2.65 COL 18.43 COLON-ALIGNED NO-LABEL
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 26.57 BY .5 AT ROW 1 COL 5.43
          FONT 0
     "Estado" VIEW-AS TEXT
          SIZE 6.86 BY .69 AT ROW 1.04 COL 55.43
          FONT 2
     RECT-64 AT ROW 1.15 COL 2.14
     RECT-65 AT ROW 1.23 COL 52.72
     RECT-66 AT ROW 7.31 COL 2.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 68.14 BY 8.04
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
         TITLE              = "Margenes de Precios de Venta"
         HEIGHT             = 8.12
         WIDTH              = 68
         MAX-HEIGHT         = 10.92
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 10.92
         VIRTUAL-WIDTH      = 80
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
   FRAME-NAME Custom                                                    */
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
ON END-ERROR OF W-Win /* Margenes de Precios de Venta */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Margenes de Precios de Venta */
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


&Scoped-define SELF-NAME f-cate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cate W-Win
ON LEAVE OF f-cate IN FRAME F-Main /* Categoria */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND PORCOMI WHERE PORCOMI.CODCIA = S-CODCIA 
                AND  PORCOMI.CATEGO = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE PORCOMI THEN DO:
    MESSAGE "Categoria no Existe " VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO F-cate.
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


&Scoped-define SELF-NAME F-prov1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-prov1 W-Win
ON LEAVE OF F-prov1 IN FRAME F-Main /* Proveedor */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia 
                AND  GN-PROV.CODPRO = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE GN-PROV THEN DO:
    MESSAGE "Codigo de proveedor no existe" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO F-prov1.
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
  ASSIGN DesdeC F-CodFam F-SubFam F-DesFam HastaC R-Tipo F-prov1 F-cate F-Rango.
  X-ARTI        = "Calificacion Cliente + Condicion de Venta : " .
  X-FAMILIA     = "FAMILIA      : "  + F-CODFAM.
  X-SUBFAMILIA  = "SUBFAMILIA   : "  + F-SUBFAM .
  X-PROVE       = "PROVEEDOR    : "  + F-PROV1.

  IF HastaC <> "" THEN 
    S-SUBTIT = "Materiales del " + DesdeC + " al " + HastaC .
  ELSE
    S-SUBTIT = "".

  IF HastaC = "" THEN HastaC = "999999999".

  IF HastaC = "" THEN HastaC = "999999".


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
  DISPLAY F-CodFam F-SubFam F-prov1 f-cate DesdeC HastaC F-Rango R-Tipo F-DesFam 
          F-DesSub 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE F-CodFam F-SubFam F-prov1 f-cate DesdeC HastaC F-Rango R-Tipo Btn_OK 
         Btn_Cancel Btn_Help RECT-64 RECT-65 RECT-66 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
DEFINE VAR X-CONVT  AS CHAR INIT "".
DEFINE VAR X-CONVTA AS CHAR INIT "".
DEFINE VAR X-CATE   AS CHAR INIT "".
DEFINE VAR X-CATEGO AS CHAR INIT "".
DEFINE VAR X-DSCTOS AS DECI INIT 0.
DEFINE VAR MAXCAT   AS DECI INIT 0.
DEFINE VAR MAXVTA   AS DECI INIT 0.
DEFINE VAR F-DSCTOS AS DECI INIT 0.
DEFINE VAR X-PREUSSD AS DECI INIT 0.
DEFINE VAR X-TIPO    AS CHAR INIT "".
DEFINE VAR X         AS DECI.
DEFINE VAR Y         AS DECI.
DEFINE VAR Z         AS DECI.

X-ARTI = X-ARTI + X-TIPO .

  DEFINE FRAME F-REPORTE2
               Almmmatg.codmat  FORMAT "X(6)"
               Almmmatg.DesMat  FORMAT "X(40)"
               Almmmatg.DesMar  FORMAT "X(10)"
               Almmmatg.TipArt  FORMAT "X(2)"
               Almmmatg.UndBas  FORMAT "X(8)"
               F-PREUSSA        FORMAT "->>9.99"
               Almmmatg.UndA    FORMAT "X(8)"
               F-PREUSSB        FORMAT "->>9.99"
               Almmmatg.UndB    FORMAT "X(8)"
               F-PREUSSC        FORMAT "->>9.99"
               Almmmatg.UndC    FORMAT "X(8)"
               F-PREUSSD        FORMAT "->>9.99"
               Almmmatg.Chr__01 FORMAT "X(8)"
              WITH WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6B} + {&Prn3} FORMAT "X(50)" AT 1 SKIP(1)
         {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 40 FORMAT "X(50)" 
         {&PRN3} + {&PRN6A} + "(" + C-TIPO + ")" + {&PRN6B} + {&PRN3} AT 100 FORMAT "X(25)" SKIP(1)
         {&PRN3} + {&PRN6B} + S-SUBTIT AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Pagina : " TO 135 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         {&PRN3} + {&PRN6B} + X-FAMILIA  AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         {&PRN3} + {&PRN6B} + X-SUBFAMILIA AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         {&PRN3} + {&PRN6B} + X-ARTI   AT 1  FORMAT "X(80)" SKIP    
        "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                        UNIDAD (A)        UNIDAD (B)       UNIDAD (C)     OFICINA      " SKIP
        "Codigo D  E  S  C  R  I  P  C  I  O  N          MARCA  CATEGORIA U.B.   MARGEN  UM.       MARGEN% UM.      MARGEN% UM.    MARGEN% UM.  " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
      WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 


 FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.Codcia = S-CODCIA  
                            AND  Almmmatg.codfam BEGINS F-CodFam 
                            AND  Almmmatg.subfam BEGINS F-SubFam 
                            AND  (Almmmatg.CodMat >= DesdeC  
                            AND   Almmmatg.CodMat <= HastaC)
                            AND  Almmmatg.CodPr1 BEGINS F-prov1                            
                            AND  Almmmatg.TpoArt BEGINS R-Tipo
                            AND  Almmmatg.tipart BEGINS F-Cate USE-INDEX Matg09
                           BREAK BY Almmmatg.Codfam
                                 BY Almmmatg.Subfam
                                 BY Almmmatg.CodMar
                                 BY Almmmatg.CodMat:

      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.


      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(Almmmatg.CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = Almmmatg.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT "FAMILIA : " Almtfami.codfam '    ' Almtfami.desfam SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
      IF FIRST-OF(Almmmatg.SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = s-CodCia 
                        AND  Almsfami.codfam = Almmmatg.CodFam 
                        AND  Almsfami.subfam = Almmmatg.Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT "SUB-FAMILIA : " Almsfami.subfam '   ' AlmSFami.dessub SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.

    FOR EACH ClfClie :
        X-CATE = ClfClie.Categoria.
        FOR EACH Gn-Convt :
             X-CONVT  = gn-ConVt.Codig.
             MaxCat   = 0.
             MaxVta   = 0.
             F-DSCTOS = 0.     
             IF Almmmatg.Chr__02 = "P" THEN 
                MaxCat = ClfClie.PorDsc.
             ELSE 
                MaxCat = ClfClie.PorDsc1.  
      
             FIND Dsctos WHERE 
                  Dsctos.CndVta = X-CONVT AND  
                  Dsctos.clfCli = Almmmatg.Chr__02 NO-LOCK NO-ERROR.             
             IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.             
             F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100. 
             IF F-DSCTOS > 0 AND F-DSCTOS > X-DSCTOS THEN DO:
                X-DSCTOS = F-DSCTOS.
                X-CATEGO = X-CATE.
                X-CONVTA = X-CONVT.
                X-TIPO   = TRIM(X-CATE) + TRIM(X-CONVTA) .
             END.                        
          END.   
    END.   
    

    X = 0.
    Y = 0.
    Z = 0.
    F-PREUSSA = Almmmatg.MrgUti-A.
    F-PREUSSB = Almmmatg.MrgUti-B.
    F-PREUSSC = Almmmatg.MrgUti-C. 
    X-PREUSSD = Almmmatg.Preofi * (1 - X-DSCTOS / 100).
    F-PREUSSD = ( ( X-PREUSSD / Almmmatg.Ctotot ) - 1 ) * 100 .     
    
    X = IF MINIMUM( F-PREUSSA,F-PREUSSB ) > 0 THEN MINIMUM( F-PREUSSA,F-PREUSSB ) ELSE MAXIMUM( F-PREUSSA,F-PREUSSB ).
    Y = IF MINIMUM( F-PREUSSC,F-PREUSSD ) > 0 THEN MINIMUM( F-PREUSSC,F-PREUSSD ) ELSE MAXIMUM( F-PREUSSC,F-PREUSSD ).
    Z = IF MINIMUM( X,Y ) > 0 THEN MINIMUM( X,Y ) ELSE MAXIMUM( X,Y ).
    
    IF Z >= F-RANGO THEN NEXT . 

      DISPLAY STREAM REPORT 
               Almmmatg.codmat
               Almmmatg.DesMat
               Almmmatg.DesMar
               Almmmatg.TipArt
               Almmmatg.UndBas
               F-PREUSSA    WHEN F-PREUSSA <> 0
               Almmmatg.UndA    WHEN Almmmatg.UndA <> ""
               F-PREUSSB    WHEN F-PREUSSB <> 0
               Almmmatg.UndB    WHEN Almmmatg.UndB <> "" 
               F-PREUSSC    WHEN F-PREUSSC <> 0
               Almmmatg.UndC    WHEN Almmmatg.UndC <> ""
               F-PREUSSD    WHEN F-PREUSSD <> 0
               Almmmatg.Chr__01 WHEN Almmmatg.Chr__01 <> ""
               WITH FRAME F-REPORTE2.
      DOWN STREAM REPORT WITH FRAME F-REPORTE2.
       
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
    ENABLE ALL EXCEPT F-DesFam F-DesSub.
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
        RUN Formato-2.
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
  ASSIGN DesdeC F-CodFam F-DesFam HastaC f-prov1 f-cate R-Tipo F-rango.
  
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
     ASSIGN /* DesdeF = TODAY  + 1 - DAY(TODAY).
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

