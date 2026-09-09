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

DEFINE        VAR C-OP      AS CHAR.
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA  AS CHARACTER.
DEFINE        VAR F-PESALM  AS DECIMAL NO-UNDO.
DEFINE SHARED VAR S-CODDIV  AS CHARACTER.

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


DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.

/* Local Variable Definitions ---                                       */
DEFINE VAR S-SUBTIT  AS CHAR.
DEFINE VAR X-TITU    AS CHAR INIT "S T O C K   D I S P O N I B L E   X   A L M A C E N".
DEFINE VAR X-MONEDA  AS CHAR.
DEFINE VAR I         AS INTEGER   NO-UNDO.
DEFINE VAR II        AS INTEGER   NO-UNDO.
DEFINE VAR F-Salida  AS DECI INIT 0.
DEFINE VAR T-Vtamn   AS DECI INIT 0.
DEFINE VAR T-Vtame   AS DECI INIT 0.
DEFINE VAR T-Ctomn   AS DECI INIT 0.
DEFINE VAR T-Ctome   AS DECI INIT 0.
DEFINE VAR T-Vta     AS DECI INIT 0.
DEFINE VAR T-Cto     AS DECI INIT 0.

DEFINE VAR X-CODDIV  AS CHAR.
DEFINE VAR X-ARTI    AS CHAR.
DEFINE VAR X-FAMILIA AS CHAR.
DEFINE VAR X-SUBFAMILIA AS CHAR.
DEFINE VAR X-MARCA    AS CHAR.
DEFINE VAR X-PROVE    AS CHAR.
DEFINE VAR X-LLAVE    AS CHAR.
DEFINE VAR X-FECHA AS DATE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .
DEFINE VAR X-NOMMES AS CHAR INIT "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".



DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codcia  LIKE Almdmov.Codcia 
    FIELD t-clase   LIKE Almmmatg.clase
    FIELD t-codfam  LIKE Almmmatg.codfam 
    FIELD t-subfam  LIKE Almmmatg.subfam
    FIELD t-prove   LIKE Almmmatg.CodPr1
    FIELD t-codmat  LIKE Almdmov.codmat
    FIELD t-desmat  LIKE Almmmatg.DesMat    FORMAT "X(40)"
    FIELD t-desmar  LIKE Almmmatg.DesMar    FORMAT "X(8)"
    FIELD t-undbas  LIKE Almmmatg.UndBas    FORMAT "X(8)"
    FIELD t-stkact  LIKE Almmmate.StkAct    FORMAT "->>>>>,>>9.99"
    FIELD t-ventamn AS DEC           FORMAT "->>>>>>>9.99" 
    FIELD t-ventame AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-costome AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-costomn AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-venta   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-costo   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-canti   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99" .

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
&Scoped-Define ENABLED-OBJECTS F-CodAlm F-CodFam F-SubFam F-Marca F-prov1 ~
DesdeC HastaC Btn_OK Btn_Cancel Btn_Help BUTTON-5 BUTTON-1 BUTTON-2 ~
BUTTON-3 BUTTON-4 RECT-61 
&Scoped-Define DISPLAYED-OBJECTS x-mensaje F-CodAlm F-CodFam F-SubFam ~
F-Marca F-prov1 DesdeC HastaC 

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

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 1" 
     SIZE 4.43 BY .81.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 2" 
     SIZE 4.43 BY .81.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 3" 
     SIZE 4.43 BY .81.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 4" 
     SIZE 4.43 BY .81.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 6" 
     SIZE 4.43 BY .81.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodAlm AS CHARACTER FORMAT "X(3)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-Marca AS CHARACTER FORMAT "X(4)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-prov1 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Sub-linea" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 62.14 BY 1.81
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 62.14 BY 8.27
     BGCOLOR 3 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-mensaje AT ROW 8.62 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     F-CodAlm AT ROW 2.35 COL 13 COLON-ALIGNED
     F-CodFam AT ROW 3.27 COL 13 COLON-ALIGNED
     F-SubFam AT ROW 4.23 COL 13 COLON-ALIGNED
     F-Marca AT ROW 5.23 COL 13 COLON-ALIGNED
     F-prov1 AT ROW 6.19 COL 13 COLON-ALIGNED
     DesdeC AT ROW 7.19 COL 13 COLON-ALIGNED
     HastaC AT ROW 7.19 COL 36 COLON-ALIGNED
     Btn_OK AT ROW 10.08 COL 29.43
     Btn_Cancel AT ROW 10.08 COL 40.72
     Btn_Help AT ROW 10.08 COL 52.14
     BUTTON-5 AT ROW 2.35 COL 26.72
     BUTTON-1 AT ROW 3.27 COL 26.57
     BUTTON-2 AT ROW 4.23 COL 26.57
     BUTTON-3 AT ROW 5.23 COL 26.57
     BUTTON-4 AT ROW 6.19 COL 26.57
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.35 COL 4.43
          FONT 6
     RECT-46 AT ROW 9.88 COL 1.86
     RECT-61 AT ROW 1.54 COL 1.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65.29 BY 11.23
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
         TITLE              = "Stock Disponible x Almacen"
         HEIGHT             = 11.23
         WIDTH              = 65.29
         MAX-HEIGHT         = 11.23
         MAX-WIDTH          = 65.29
         VIRTUAL-HEIGHT     = 11.23
         VIRTUAL-WIDTH      = 65.29
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
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Stock Disponible x Almacen */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Stock Disponible x Almacen */
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
  RUN Valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". 
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-Famili02.r("Familias").
    IF output-var-2 <> ? THEN DO:
        F-CODFAM = output-var-2.
        DISPLAY F-CODFAM.
        IF NUM-ENTRIES(F-CODFAM) > 1 THEN ASSIGN 
        F-SUBFAM:SENSITIVE = FALSE
        F-SUBFAM:SCREEN-VALUE = ""
        BUTTON-2:SENSITIVE = FALSE.
        ELSE ASSIGN 
        F-SUBFAM:SENSITIVE = TRUE
        BUTTON-2:SENSITIVE = TRUE.
        APPLY "ENTRY" TO F-CODFAM .
        RETURN NO-APPLY.
    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = F-CODFAM.
    output-var-2 = "".
    RUN lkup\C-SubFam02.r("SubFamilias").
    IF output-var-2 <> ? THEN DO:
        F-SUBFAM = output-var-2.
        DISPLAY F-SUBFAM.
        APPLY "ENTRY" TO F-SUBFAM .
        RETURN NO-APPLY.

        
    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "MK".
    output-var-2 = "".
    RUN lkup\C-ALMTAB02.r("SubFamilias").
    IF output-var-2 <> ? THEN DO:
        F-MARCA = output-var-2.
        DISPLAY F-MARCA.
        APPLY "ENTRY" TO F-MARCA .
        RETURN NO-APPLY.

        
    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-provee02.r("Proveedores").
    IF output-var-2 <> ? THEN DO:
        F-PROV1 = output-var-2.
        DISPLAY F-PROV1.
        APPLY "ENTRY" TO F-PROV1 .
        RETURN NO-APPLY.

    END.
  END.

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
    RUN lkup\C-AlmCen.r("Almacenes").
    IF output-var-2 <> ? THEN DO:
        F-CODALM = output-var-2.
        DISPLAY F-CODALM.
        APPLY "ENTRY" TO F-CODALM.
        RETURN NO-APPLY.

    END.
  END.
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
   IF NUM-ENTRIES(F-CODFAM) > 1 THEN ASSIGN 
       F-SUBFAM:SENSITIVE = FALSE
       F-SUBFAM:SCREEN-VALUE = ""
       BUTTON-2:SENSITIVE = FALSE.
   ELSE ASSIGN
    F-SUBFAM:SENSITIVE = TRUE
    BUTTON-2:SENSITIVE = TRUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Marca W-Win
ON LEAVE OF F-Marca IN FRAME F-Main /* Marca */
DO:
   ASSIGN F-Marca.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   IF F-Marca = "" THEN DO:
      SELF:SCREEN-VALUE = "".
      RETURN.
   END.
   FIND AlmTabla WHERE AlmTabla.Tabla = 'MK' 
                 AND  AlmTabla.Codigo = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE AlmTabla THEN DO:
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
   FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA 
                  AND  AlmSFami.codfam = F-CodFam 
                  AND  AlmSFami.subfam = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE AlmSFami THEN DO:
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
  ASSIGN F-CodAlm 
         F-CodFam 
         F-SubFam 
         F-Marca 
         F-prov1 
         DesdeC 
         HastaC .
  X-ARTI        = "ARTICULOS    : " .
  X-FAMILIA     = "FAMILIA      : "  + F-CODFAM.
  X-SUBFAMILIA  = "SUBFAMILIA   : "  + F-SUBFAM .
  X-MARCA       = "MARCA        : "  + F-MARCA .
  X-PROVE       = "PROVEEDOR    : "  + F-PROV1.
  
  IF HastaC <> "" THEN  X-ARTI  =  X-ARTI + DesdeC + " al " + HastaC .    
   
  IF HastaC = "" THEN HastaC = "999999".
  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-temporal W-Win 
PROCEDURE Carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-stock  AS DECI INIT 0.
DEFINE VAR x-canped AS DECI INIT 0.
DEFINE VAR x-dispo  AS DECI INIT 0.
DEFINE VAR x-totped AS DECI INIT 0.
DEFINE VAR x        AS INTEGER INIT 1.
DEFINE VAR x-codalm LIKE Almacen.CodAlm.
x-codalm = f-codalm.
  DEFINE FRAME F-REPORTE
         Almmmatg.Codmat  AT 1
         Almmmatg.DesMat  FORMAT "X(40)"
         Almmmatg.Desmar  FORMAT "X(15)"
         Almmmatg.UndBas  FORMAT "X(10)" 
         x-stock          FORMAT "->>>>>>>9.99"
         x-totped         FORMAT "->>>>>>>9.99"
         x-dispo          FORMAT "->>>>>>>9.99"
        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-DETALLE
         Facdpedi.CodDoc  AT 40
         Facdpedi.NroPed  
         Facdpedi.Fchped     
         Facdpedi.UndVta  FORMAT "X(10)"   
         Facdpedi.CanPed  FORMAT "->>>>>>>9.99"
         Facdpedi.CanAte  FORMAT "->>>>>>>9.99"
         x-canped         FORMAT "->>>>>>>9.99"
        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1  SKIP
         X-TITU   AT 40 FORMAT "X(50)" SKIP
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Pagina : " TO 135 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         X-FAMILIA  AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         X-SUBFAMILIA AT 1  FORMAT "X(60)" 
         "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         X-ARTI   AT 1  FORMAT "X(60)" 
         X-MARCA  AT 80  FORMAT "X(60)" SKIP
         X-PROVE  AT 1  FORMAT "X(60)" 
         "ALMACEN EVALUADO : " + F-CODALM  At 1 FORMAT "X(150)" SKIP
         "------------------------------------------------------------------------------------------------------------------------" SKIP
         " CODIGO  D E S C R I P C I O N                MARCA    U.M                      STOCK                                   " SKIP
         "                                              COD.REF  NRO.REF                  CANTIDAD        ATENDIDA   PENDIENTE    " SKIP          
         "------------------------------------------------------------------------------------------------------------------------" SKIP         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
    AND  Almmmatg.codfam BEGINS F-CodFam
    AND  Almmmatg.subfam BEGINS F-Subfam
    AND  (Almmmatg.codmat >= DesdeC
          AND   Almmmatg.CodMat <= HastaC)
    AND  Almmmatg.CodPr1 BEGINS F-prov1
    AND  Almmmatg.Codmar BEGINS F-Marca
    USE-INDEX matg09:
                         
      /*  
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */
    DISPLAY "Codigo de Articulo: " + Almmmatg.CodMat  @ x-mensaje
        WITH FRAME {&FRAME-NAME}.
    
    FIND almmmate WHERE 
         Almmmate.CodCia = s-codcia  AND  
         Almmmate.CodAlm = x-codalm  AND  
         Almmmate.codmat = Almmmatg.Codmat NO-LOCK NO-ERROR.
    x-stock = 0.
    
    IF AVAILABLE almmmate THEN DO:
       x-stock = Almmmate.Stkact.
    END.
    VIEW STREAM REPORT FRAME F-HEADER.
    
    IF x-stock = 0 THEN NEXT.
    
    DISPLAY STREAM REPORT 
        Almmmatg.Codmat 
        Almmmatg.DesMat 
        Almmmatg.DesMar 
        Almmmatg.UndBas 
        x-stock         
     WITH FRAME F-REPORTE.
     DOWN STREAM REPORT WITH FRAME F-REPORTE.
     x-totped = 0.
     
    FOR EACH FacDPedi WHERE FacDPedi.CodCia = s-codcia AND  
        FacDPedi.Almdes = x-codalm AND  
        FacDPedi.codmat = Almmmatg.CodMat AND  
        FacDPedi.CodDoc = 'O/D'    AND  
        FacDPedi.FlgEst = 'P' NO-LOCK:

        FIND FIRST FacCPedi OF FacDPedi WHERE 
            FacCPedi.codcia = FacDPedi.CodCia AND  
            FacCPedi.CodAlm = f-codalm        AND  
            Faccpedi.FlgEst = "P"  NO-LOCK NO-ERROR.
          IF NOT AVAIL FacCPedi THEN NEXT.
          X-CanPed = FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
          x-totped = x-totped + x-canped.
          DISPLAY STREAM REPORT 
              Facdpedi.coddoc
              Facdpedi.NroPed
              Facdpedi.Fchped     
              Facdpedi.UndVta     
              Facdpedi.CanPed  
              Facdpedi.CanAte  
              x-canped         
           WITH FRAME F-DETALLE.
           DOWN STREAM REPORT WITH FRAME F-DETALLE.
              
    END.
    x-dispo = x-stock - x-totped.
    UNDERLINE STREAM REPORT 
              x-dispo 
    WITH FRAME F-REPORTE.
    DISPLAY STREAM REPORT 
          ("DISPONIBLE : " ) @ Almmmatg.DesMar 
          x-dispo
    WITH FRAME F-REPORTE.
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
  DISPLAY x-mensaje F-CodAlm F-CodFam F-SubFam F-Marca F-prov1 DesdeC HastaC 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE F-CodAlm F-CodFam F-SubFam F-Marca F-prov1 DesdeC HastaC Btn_OK 
         Btn_Cancel Btn_Help BUTTON-5 BUTTON-1 BUTTON-2 BUTTON-3 BUTTON-4 
         RECT-61 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
    ENABLE ALL EXCEPT x-mensaje.
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
        RUN Carga-Temporal.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
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
  ASSIGN 
         F-CodAlm
         F-CodFam 
         F-SubFam 
         F-Marca 
         F-prov1 
         DesdeC 
         HastaC .
  
  IF HastaC <> "" THEN HastaC = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida W-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF F-CODALM = "" THEN DO:
   MESSAGE "Ingrese Codigo de Almacen " SKIP
           "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO F-CODALM IN FRAME {&FRAME-NAME}.
   RETURN "ADM-ERROR".
END.

IF F-CODALM <> "" THEN DO:
        DO I = 1 TO NUM-ENTRIES(F-CODALM):
          FIND Almacen WHERE Almacen.Codcia = S-CODCIA AND
                             Almacen.Codalm = ENTRY(I,F-CODALM) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Almacen THEN DO:
            MESSAGE "Almacen " + ENTRY(I,F-CODALM) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-CODALM IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
        END.
END.

IF F-CODFAM <> "" THEN DO:
        DO I = 1 TO NUM-ENTRIES(F-CODFAM):
          FIND AlmtFami WHERE AlmtFami.Codcia = S-CODCIA AND
                              AlmtFami.CodFam = ENTRY(I,F-CODFAM) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE AlmtFami THEN DO:
            MESSAGE "Familia " + ENTRY(I,F-CODFAM) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-CODFAM IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
        END.
END.


IF F-PROV1 <> "" THEN DO:
  DO I = 1 TO NUM-ENTRIES(F-PROV1):
          FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia AND 
                             GN-PROV.CODPRO = ENTRY(I,F-PROV1) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Prov THEN DO:
            MESSAGE "Proveedor " + ENTRY(I,F-PROV1) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-PROV1 IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
  END.

END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

