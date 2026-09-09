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
DEFINE        VAR C-OP     AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE        VAR F-PESALM AS DECIMAL NO-UNDO.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

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

/****************/
DEFINE VAR F-STKGEN  AS DECIMAL NO-UNDO.
DEFINE VAR F-PESGEN  AS DECIMAL NO-UNDO.
DEFINE VAR F-VALCTO  AS DECIMAL NO-UNDO.
DEFINE VAR F-PRECTO  AS DECIMAL NO-UNDO.
DEFINE VAR C-MONEDA  AS CHARACTER FORMAT "X(20)" NO-UNDO.
DEFINE VAR S-SUBTIT  AS CHARACTER FORMAT "X(40)" NO-UNDO.
/*****************/

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
&Scoped-Define ENABLED-OBJECTS RECT-47 RECT-48 RECT-56 RECT-57 F-CodFam ~
F-SubFam DesdeC HastaC F-marca1 F-marca2 F-provee2 F-provee1 TipoStk ~
T-Resumen R-Tipo R-TpoRep I-CodMon D-Corte Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-DesFam F-CodFam F-SubFam F-DesSub DesdeC ~
HastaC F-marca1 F-marca2 F-provee2 F-provee1 TipoStk T-Resumen R-Tipo ~
R-TpoRep I-CodMon D-Corte 

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

DEFINE VARIABLE D-Corte AS DATE FORMAT "99/99/9999":U 
     LABEL "Al" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .81 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

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

DEFINE VARIABLE F-marca2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-provee1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-provee2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .81 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(9)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE I-CodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 13.72 BY .81 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ambos", "",
"Activados", "A",
"Desactivados", "D"
     SIZE 12.86 BY 1.92 NO-UNDO.

DEFINE VARIABLE R-TpoRep AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "General", 1,
"Valorizado", 2,
"Corte de Fecha", 3
     SIZE 15 BY 2 NO-UNDO.

DEFINE VARIABLE TipoStk AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Solo Articulos con Stock", 1,
"Todos los Seleccionados", 2
     SIZE 43 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-47
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61.14 BY 3.27.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61.14 BY 2.62.

DEFINE RECTANGLE RECT-56
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13.72 BY 3.35.

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.86 BY 11.54.

DEFINE VARIABLE T-Resumen AS LOGICAL INITIAL no 
     LABEL "Resumido por Familia" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.29 BY .73 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-DesFam AT ROW 1.58 COL 24 COLON-ALIGNED NO-LABEL
     F-CodFam AT ROW 1.62 COL 18 COLON-ALIGNED
     F-SubFam AT ROW 2.5 COL 18 COLON-ALIGNED
     F-DesSub AT ROW 2.5 COL 24 COLON-ALIGNED NO-LABEL
     DesdeC AT ROW 4.04 COL 18 COLON-ALIGNED
     HastaC AT ROW 4.08 COL 47 COLON-ALIGNED
     F-marca1 AT ROW 4.92 COL 18 COLON-ALIGNED
     F-marca2 AT ROW 4.92 COL 47 COLON-ALIGNED
     F-provee2 AT ROW 5.69 COL 47 COLON-ALIGNED
     F-provee1 AT ROW 5.73 COL 18 COLON-ALIGNED
     TipoStk AT ROW 7.12 COL 20 NO-LABEL
     T-Resumen AT ROW 8.42 COL 20
     R-Tipo AT ROW 9.73 COL 66.57 NO-LABEL
     R-TpoRep AT ROW 9.81 COL 20 NO-LABEL
     I-CodMon AT ROW 10.19 COL 49 NO-LABEL
     D-Corte AT ROW 11.04 COL 47 COLON-ALIGNED
     Btn_OK AT ROW 12.88 COL 52.86
     Btn_Cancel AT ROW 12.88 COL 65.29
     "Tipo de reporte" VIEW-AS TEXT
          SIZE 12.57 BY .5 AT ROW 9.81 COL 5
          FONT 6
     "Estado" VIEW-AS TEXT
          SIZE 7.14 BY .69 AT ROW 8.85 COL 69.14
          FONT 1
     "Criterio de Seleccion" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     RECT-46 AT ROW 12.77 COL 1
     RECT-47 AT ROW 3.65 COL 2.86
     RECT-48 AT ROW 9.42 COL 2.86
     RECT-56 AT ROW 8.65 COL 66
     RECT-57 AT ROW 1.19 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 13.54
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
         TITLE              = "Existencias Generales"
         HEIGHT             = 13.46
         WIDTH              = 80
         MAX-HEIGHT         = 13.54
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 13.54
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN F-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Existencias Generales */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Existencias Generales */
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


&Scoped-define SELF-NAME F-marca2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-marca2 W-Win
ON LEAVE OF F-marca2 IN FRAME F-Main /* A */
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


&Scoped-define SELF-NAME F-provee2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-provee2 W-Win
ON LEAVE OF F-provee2 IN FRAME F-Main /* A */
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
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
                      Almmmatg.CodMat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.  
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-TpoRep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-TpoRep W-Win
ON VALUE-CHANGED OF R-TpoRep IN FRAME F-Main
DO:
   ASSIGN R-TpoRep.
   CASE R-TpoRep:
        WHEN 1 THEN ASSIGN I-CodMon:SENSITIVE = NO
                            D-Corte:SENSITIVE = NO.
        WHEN 2 THEN ASSIGN I-CodMon:SENSITIVE = YES
                            D-Corte:SENSITIVE = NO.
        WHEN 3 THEN ASSIGN I-CodMon:SENSITIVE = YES
                            D-Corte:SENSITIVE = YES.
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
  ASSIGN D-Corte DesdeC 
         F-CodFam F-SubFam 
         F-DesFam HastaC I-CodMon  
         TipoStk R-TpoRep T-Resumen R-Tipo
         F-marca1 F-marca2 F-provee1 F-provee2.
  
  IF I-CodMon = 1 THEN C-MONEDA = "NUEVOS SOLES".
  ELSE C-MONEDA = "DOLARES AMERICANOS".
  
  IF HastaC <> "" THEN S-SUBTIT = "Materiales del " + DesdeC + " al " + HastaC .
  ELSE S-SUBTIT = "".

  IF HastaC = "" THEN HastaC = "999999999".
  IF F-marca2 = "" THEN F-marca2 = "ZZZZZZZZZZZZZ".
  IF F-provee2 = "" THEN F-provee2 = "ZZZZZZZZZZZZZ".

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
  DISPLAY F-DesFam F-CodFam F-SubFam F-DesSub DesdeC HastaC F-marca1 F-marca2 
          F-provee2 F-provee1 TipoStk T-Resumen R-Tipo R-TpoRep I-CodMon D-Corte 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-47 RECT-48 RECT-56 RECT-57 F-CodFam F-SubFam DesdeC HastaC 
         F-marca1 F-marca2 F-provee2 F-provee1 TipoStk T-Resumen R-Tipo 
         R-TpoRep I-CodMon D-Corte Btn_OK Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1 W-Win 
PROCEDURE Formato1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         SPACE(5)
         Almmmatg.codmat AT  7 COLUMN-LABEL "Codigo" FORMAT "X(9)"
         Almmmatg.DesMat AT 17 COLUMN-LABEL "Descripcion" FORMAT "X(40)"
         Almmmatg.DesMar AT 79 COLUMN-LABEL "Marca" FORMAT "X(10)"
         Almmmatg.UndStk AT 90 COLUMN-LABEL "Unidad"
         F-STKGEN        AT 96 COLUMN-LABEL "Cantidad" FORMAT "->>,>>>,>>9.999"
         F-PESGEN        FORMAT ">>>>,>>>,>>9.99"
         HEADER
         {&Prn3} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} AT 6 FORMAT "X(50)" SKIP
         "EXISTENCIAS GENERALES" AT 48 
         "Pagina : " TO 103 PAGE-NUMBER(REPORT) TO 113 FORMAT "ZZZZZ9" SKIP
         IF T-Resumen THEN "(POR FAMILIA)"  ELSE '' AT 52 FORMAT 'X(20)'
         " Fecha : " TO 103 TODAY TO 113 FORMAT "99/99/9999" SKIP
         "  Hora : " TO 103 STRING(TIME,"HH:MM:SS") TO 113 SKIP(1)
         S-SUBTIT AT 6 SKIP(1)
         "     -----------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                                                                  P e s o   " SKIP
         "     Codigo   Descripcion                                                    Marca      Unidad      Cantidad       Kilos    " SKIP
         "     -----------------------------------------------------------------------------------------------------------------------" SKIP
  WITH WIDTH 160 NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO DOWN.

  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
                             AND  (Almmmatg.CodMat >= DesdeC  
                             AND   Almmmatg.CodMat <= HastaC)  
                             AND  (Almmmatg.CodMar >= F-marca1 
                             AND   Almmmatg.CodMar <= F-marca2)
                             AND  (Almmmatg.CodPr1 >= F-provee1
                             AND   Almmmatg.CodPr1 <= F-provee2)
                             AND  Almmmatg.CodFam BEGINS F-CodFam 
                             AND  Almmmatg.SubFam BEGINS F-SubFam 
                             AND  Almmmatg.TpoArt BEGINS R-Tipo 
                             AND  Almmmatg.FchCes = ? 
                            BREAK BY Almmmatg.codcia 
                                  BY Almmmatg.CodFam 
                                  BY Almmmatg.SubFam 
                                  BY Almmmatg.Ordlis:
      IF FIRST-OF(Almmmatg.CodFam) AND NOT T-Resumen THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = Almmmatg.CodCia 
                        AND  Almtfami.codfam = Almmmatg.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             DISPLAY STREAM REPORT 
                 Almtfami.codfam @ Almmmatg.codmat
                 Almtfami.desfam @ Almmmatg.DesMat WITH FRAME F-REPORTE.
             UNDERLINE STREAM REPORT Almmmatg.DesMat WITH FRAME F-REPORTE.
         END.
      END.
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      F-STKGEN = 0.
      FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA 
                                 AND  Almmmate.codmat = Almmmatg.CodMat 
                                 AND  Almmmate.StkAct > 0:
          F-STKGEN = F-STKGEN + Almmmate.StkAct.
      END.
      IF (TipoStk = 1 AND F-STKGEN > 0) OR TipoStk = 2 THEN DO:
         F-PESGEN = F-STKGEN * Almmmatg.Pesmat.
         IF NOT T-Resumen THEN DO:
            DISPLAY STREAM REPORT 
                 Almmmatg.codmat 
                 Almmmatg.DesMat 
                 Almmmatg.DesMar
                 Almmmatg.UndStk 
                 F-STKGEN  WHEN F-STKGEN > 0
                 F-PESGEN  WHEN F-PESGEN > 0
                 WITH FRAME F-REPORTE.
         END.
         ACCUMULATE F-STKGEN (SUB-TOTAL BY Almmmatg.Subfam).
         ACCUMULATE F-STKGEN (SUB-TOTAL BY Almmmatg.Codfam).
         ACCUMULATE F-STKGEN (TOTAL).
         ACCUMULATE F-PESGEN (SUB-TOTAL BY Almmmatg.Codfam).
         ACCUMULATE F-PESGEN (TOTAL).
      END.
      IF LAST-OF(Almmmatg.CodFam) THEN DO:
         IF T-Resumen THEN DO:
            FIND Almtfami WHERE Almtfami.CodCia = Almmmatg.CodCia 
                           AND  Almtfami.codfam = Almmmatg.CodFam 
                          NO-LOCK NO-ERROR.
            DISPLAY STREAM REPORT 
                 Almtfami.codfam @ Almmmatg.codmat
                 Almtfami.desfam @ Almmmatg.DesMat 
                 ACCUM SUB-TOTAL BY Almmmatg.codfam F-STKGEN @ F-STKGEN 
                 ACCUM SUB-TOTAL BY Almmmatg.codfam F-PESGEN @ F-PESGEN WITH FRAME F-REPORTE.
            DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
            END.
         ELSE DO:
            UNDERLINE STREAM REPORT F-STKGEN F-PESGEN WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
                '                    Total Familia      --> ' @ Almmmatg.desmat
                ACCUM SUB-TOTAL BY Almmmatg.codfam F-STKGEN @ F-STKGEN 
                ACCUM SUB-TOTAL BY Almmmatg.codfam F-PESGEN @ F-PESGEN WITH FRAME F-REPORTE.
            DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
         END.
      END.
      
      IF LAST-OF(Almmmatg.Codcia) THEN DO:
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKGEN F-PESGEN WITH FRAME F-REPORTE.
         DISPLAY STREAM REPORT 
             '                    TOTAL GENERAL      --> ' @ Almmmatg.desmat
             ACCUM TOTAL F-STKGEN @ F-STKGEN 
             ACCUM TOTAL F-PESGEN @ F-PESGEN WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKGEN F-PESGEN WITH FRAME F-REPORTE.
      END.
  END.
  
  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2 W-Win 
PROCEDURE Formato2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         Almmmatg.codmat COLUMN-LABEL "Codigo" FORMAT "X(8)" AT 2
         Almmmatg.DesMat COLUMN-LABEL "Descripcion" FORMAT "X(38)" AT 12
         Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(10)" AT 52
         Almmmatg.UndStk COLUMN-LABEL "Unid"
         F-STKGEN  COLUMN-LABEL "Cantidad" FORMAT "->>,>>>,>>9.99"
         F-PESGEN  FORMAT ">>>>,>>>,>>9.99"
         F-PRECTO  COLUMN-LABEL "Precio!Unitario" FORMAT ">>>,>>9.9999"
         F-VALCTO  COLUMN-LABEL "Importe!Total" FORMAT "->>>,>>>,>>9.99"
         HEADER
         {&Prn3} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} + {&Prn2} FORMAT "X(50)" SKIP
         "EXISTENCIAS GENERALES VALORIZADAS A PRECIO PROMEDIO" AT 20  
         "Pagina :" TO 105 PAGE-NUMBER(REPORT) TO 126 FORMAT "ZZZZZ9" SKIP
         IF T-Resumen THEN "(POR FAMILIA)"  ELSE '' AT 40 FORMAT 'X(20)'
         "Fecha :" TO 105 TODAY TO 126 FORMAT "99/99/9999" SKIP
         "Hora :" TO 105 STRING(TIME,"HH:MM:SS") TO 126 SKIP(1)
         S-SUBTIT        "Moneda : " TO 70 C-MONEDA SKIP
         "-----------------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                                         P E S O       Precio        Importe " SKIP
         "     Codigo   Descripcion                              Marca     Unid      Cantidad       Kilos       Unitario         Total " SKIP
         "-----------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
  
  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
                             AND  Almmmatg.CodMat >= DesdeC  
                             AND  Almmmatg.CodMat <= HastaC  
                             AND  (Almmmatg.CodMar >= F-marca1 
                             AND   Almmmatg.CodMar <= F-marca2)
                             AND  (Almmmatg.CodPr1 >= F-provee1
                             AND   Almmmatg.CodPr1 <= F-provee2)
                             AND  Almmmatg.CodFam BEGINS F-CodFam 
                             AND  Almmmatg.SubFam BEGINS F-SubFam 
                             AND  Almmmatg.TpoArt BEGINS R-Tipo 
                             AND  Almmmatg.FchCes = ?
                            BREAK BY Almmmatg.CodCia 
                                  BY Almmmatg.CodFam 
                                  BY Almmmatg.Subfam 
                                  BY Almmmatg.Ordlis:
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      IF FIRST-OF(Almmmatg.CodFam) AND NOT T-Resumen THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = Almmmatg.CodCia 
                        AND  Almtfami.codfam = Almmmatg.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             DISPLAY STREAM REPORT 
                 Almtfami.codfam @ Almmmatg.codmat
                 Almtfami.desfam @ Almmmatg.DesMat WITH FRAME F-REPORTE.
             UNDERLINE STREAM REPORT Almmmatg.DesMat WITH FRAME F-REPORTE.
         END.
      END.
      F-STKGEN = 0.
      FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA 
                                 AND  Almmmate.codmat = Almmmatg.CodMat 
                                 AND  Almmmate.StkAct > 0:
          F-STKGEN = F-STKGEN + Almmmate.StkAct.
      END.
      IF I-CodMon = 1 THEN F-VALCTO = Almmmatg.VCtMn1. 
      IF I-CodMon = 2 THEN F-VALCTO = Almmmatg.VCtMn2.
      IF (TipoStk = 1 AND F-STKGEN > 0) OR TipoStk = 2 THEN DO:
         F-PRECTO = IF F-STKGEN <> 0 THEN ROUND(F-VALCTO / F-STKGEN,4) ELSE 0.
         F-PESGEN = F-STKGEN * Almmmatg.Pesmat.
         IF NOT T-Resumen THEN DO:
            DISPLAY STREAM REPORT 
                 Almmmatg.codmat 
                 Almmmatg.DesMat
                 Almmmatg.DesMar 
                 Almmmatg.UndStk 
                 F-STKGEN  
                 F-PESGEN  WHEN F-PESGEN > 0
                 F-PRECTO  
                 F-VALCTO WITH FRAME F-REPORTE.
         END.
         ACCUMULATE F-STKGEN (SUB-TOTAL BY Almmmatg.Subfam).
         ACCUMULATE F-STKGEN (SUB-TOTAL BY Almmmatg.Codfam).
         ACCUMULATE F-STKGEN (TOTAL).
         ACCUMULATE F-PESGEN (SUB-TOTAL BY Almmmatg.Subfam).
         ACCUMULATE F-PESGEN (SUB-TOTAL BY Almmmatg.Codfam).
         ACCUMULATE F-PESGEN (TOTAL).
         ACCUMULATE F-VALCTO (SUB-TOTAL BY Almmmatg.Subfam).
         ACCUMULATE F-VALCTO (SUB-TOTAL BY Almmmatg.Codfam).
         ACCUMULATE F-VALCTO (TOTAL).
      END.
      IF LAST-OF(Almmmatg.CodFam) THEN DO:
         IF T-Resumen THEN DO:
            FIND Almtfami WHERE Almtfami.CodCia = Almmmatg.CodCia 
                           AND  Almtfami.codfam = Almmmatg.CodFam 
                          NO-LOCK NO-ERROR.
            DISPLAY STREAM REPORT 
                 Almtfami.codfam @ Almmmatg.codmat
                 Almtfami.desfam @ Almmmatg.DesMat 
                 ACCUM SUB-TOTAL BY Almmmatg.codfam F-STKGEN @ F-STKGEN 
                 ACCUM SUB-TOTAL BY Almmmatg.codfam F-PESGEN @ F-PESGEN 
                 ACCUM SUB-TOTAL BY Almmmatg.codfam F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
            END.
         ELSE DO:
            UNDERLINE STREAM REPORT F-STKGEN F-PESGEN F-VALCTO WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
                '              Total Familia      --> ' @ Almmmatg.desmat
                ACCUM SUB-TOTAL BY Almmmatg.codfam F-STKGEN @ F-STKGEN 
                ACCUM SUB-TOTAL BY Almmmatg.codfam F-PESGEN @ F-PESGEN 
                ACCUM SUB-TOTAL BY Almmmatg.codfam F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
         END.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.
      IF LAST-OF(Almmmatg.Codcia) THEN DO:
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKGEN F-PESGEN F-VALCTO WITH FRAME F-REPORTE.
         DISPLAY STREAM REPORT 
             '              TOTAL GENERAL      --> ' @ Almmmatg.desmat
             ACCUM TOTAL F-STKGEN @ F-STKGEN 
             ACCUM TOTAL F-PESGEN @ F-PESGEN 
             ACCUM TOTAL F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKGEN F-PESGEN F-VALCTO WITH FRAME F-REPORTE.
      END.
  END.
  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato3 W-Win 
PROCEDURE Formato3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         Almmmatg.codmat COLUMN-LABEL "Codigo" FORMAT "X(8)" AT 2
         Almmmatg.DesMat COLUMN-LABEL "Descripcion" FORMAT "X(38)" AT 12
         Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(10)" AT 52
         Almmmatg.UndStk COLUMN-LABEL "Unid"
         F-STKGEN  COLUMN-LABEL "Cantidad" FORMAT "->>,>>>,>>9.99"
         F-PESGEN  FORMAT ">>>>,>>>,>>9.99"
         F-PRECTO  COLUMN-LABEL "Precio!Unitario" FORMAT "->>>,>>9.9999"
         F-VALCTO  COLUMN-LABEL "Importe!Total" FORMAT "->>>>>,>>>,>>9.99"
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} + {&Prn2} FORMAT "X(50)" SKIP
         "EXISTENCIAS VALORIZADAS A PRECIO PROMEDIO AL "  AT 20  D-Corte
         "Pagina :" TO 105 PAGE-NUMBER(REPORT) TO 126 FORMAT "ZZZZZ9" SKIP
         IF T-Resumen THEN "(POR FAMILIA)"  ELSE '' AT 40 FORMAT 'X(20)'
         "Fecha :" TO 105 TODAY TO 126 FORMAT "99/99/9999" SKIP
         "Hora :" TO 105 STRING(TIME,"HH:MM:SS") TO 126 SKIP(1)
         S-SUBTIT        "Moneda : " TO 70 C-MONEDA SKIP
         "-----------------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                                         P E S O       Precio        Importe " SKIP
         "     Codigo   Descripcion                              Marca     Unid      Cantidad       Kilos       Unitario         Total " SKIP
         "-----------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
  
  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
                             AND  Almmmatg.CodMat >= DesdeC  
                             AND  Almmmatg.CodMat <= HastaC  
                             AND  (Almmmatg.CodMar >= F-marca1 
                             AND   Almmmatg.CodMar <= F-marca2)
                             AND  (Almmmatg.CodPr1 >= F-provee1
                             AND   Almmmatg.CodPr1 <= F-provee2)
                             AND  Almmmatg.CodFam BEGINS F-CodFam 
                             AND  Almmmatg.SubFam BEGINS F-SubFam 
                             AND  Almmmatg.TpoArt BEGINS R-Tipo 
                             AND  Almmmatg.FchCes = ?
                            BREAK BY Almmmatg.CodCia 
                                  BY Almmmatg.CodFam 
                                  BY Almmmatg.Subfam 
                                  BY Almmmatg.Ordlis:
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      IF FIRST-OF(Almmmatg.CodFam) AND NOT T-Resumen THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = Almmmatg.CodCia 
                        AND  Almtfami.codfam = Almmmatg.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             DISPLAY STREAM REPORT 
                 Almtfami.codfam @ Almmmatg.codmat
                 Almtfami.desfam @ Almmmatg.DesMat WITH FRAME F-REPORTE.
             UNDERLINE STREAM REPORT Almmmatg.DesMat WITH FRAME F-REPORTE.
         END.
      END.
      FIND LAST Almdmov WHERE Almdmov.CodCia = S-CODCIA 
                         AND  Almdmov.CodMat = Almmmatg.CodMat 
                         AND  Almdmov.FchDoc <= D-Corte 
                        USE-INDEX Almd02 NO-LOCK NO-ERROR.
      IF AVAILABLE Almdmov THEN F-STKGEN = Almdmov.StkAct.
      ELSE F-STKGEN = 0.
      IF AVAILABLE Almdmov AND I-CodMon = 1 THEN F-VALCTO = Almdmov.VctoMn1.
      IF AVAILABLE Almdmov AND I-CodMon = 2 THEN F-VALCTO = Almdmov.VctoMn2.
      IF (TipoStk = 1 AND F-STKGEN > 0) OR TipoStk = 2 THEN DO:
         F-VALCTO = IF F-STKGEN <> 0 THEN F-VALCTO ELSE 0.
         F-PRECTO = IF F-STKGEN <> 0 THEN F-VALCTO / F-STKGEN ELSE 0.
         F-PESGEN = F-STKGEN * Almmmatg.Pesmat.
         IF ( F-PRECTO = 0 AND F-STKGEN < 0 )  OR ( F-PRECTO < 0 ) THEN DO:
          F-PRECTO = ALMMMATG.CTOLIS.
          F-VALCTO = F-PRECTO * F-STKGEN.
         END.
         IF NOT T-Resumen THEN DO:
            DISPLAY STREAM REPORT 
                 Almmmatg.codFam
                 Almmmatg.codmat 
                 Almmmatg.DesMat
                 Almmmatg.DesMar
                 Almmmatg.UndStk 
                 F-STKGEN  
                 F-PESGEN WHEN F-PESGEN > 0
                 F-PRECTO  
                 F-VALCTO WITH FRAME F-REPORTE.
         END.
         ACCUMULATE F-STKGEN (SUB-TOTAL BY Almmmatg.Subfam).
         ACCUMULATE F-STKGEN (SUB-TOTAL BY Almmmatg.Codfam).
         ACCUMULATE F-STKGEN (TOTAL).
         ACCUMULATE F-PESGEN (SUB-TOTAL BY Almmmatg.Subfam).
         ACCUMULATE F-PESGEN (SUB-TOTAL BY Almmmatg.Codfam).
         ACCUMULATE F-PESGEN (TOTAL).
         ACCUMULATE F-VALCTO (SUB-TOTAL BY Almmmatg.Subfam).
         ACCUMULATE F-VALCTO (SUB-TOTAL BY Almmmatg.Codfam).
         ACCUMULATE F-VALCTO (TOTAL).
      END.
      IF LAST-OF(Almmmatg.CodFam) THEN DO:
         IF T-Resumen THEN DO:
            FIND Almtfami WHERE Almtfami.CodCia = Almmmatg.CodCia 
                           AND  Almtfami.codfam = Almmmatg.CodFam 
                          NO-LOCK NO-ERROR.
            DISPLAY STREAM REPORT 
                 Almtfami.codfam @ Almmmatg.codmat
                 Almtfami.desfam @ Almmmatg.DesMat
                /* ACCUM SUB-TOTAL BY Almmmatg.codfam F-STKGEN @ F-STKGEN */
                 ACCUM SUB-TOTAL BY Almmmatg.codfam F-PESGEN @ F-PESGEN 
                 ACCUM SUB-TOTAL BY Almmmatg.codfam F-VALCTO @ F-VALCTO  WITH FRAME F-REPORTE.
            END.
         ELSE DO:
            UNDERLINE STREAM REPORT F-STKGEN F-PESGEN F-VALCTO WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
                '              Total Familia      --> ' @ Almmmatg.desmat
/*                ACCUM SUB-TOTAL BY Almmmatg.codfam F-STKGEN @ F-STKGEN */
                ACCUM SUB-TOTAL BY Almmmatg.codfam F-PESGEN @ F-PESGEN 
                ACCUM SUB-TOTAL BY Almmmatg.codfam F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
         END.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.
      IF LAST-OF(Almmmatg.Codcia) THEN DO:
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKGEN F-PESGEN F-VALCTO WITH FRAME F-REPORTE.
         DISPLAY STREAM REPORT 
             '              TOTAL GENERAL      --> ' @ Almmmatg.desmat
  /*           ACCUM TOTAL F-STKGEN @ F-STKGEN */
             ACCUM TOTAL F-PESGEN @ F-PESGEN 
             ACCUM TOTAL F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKGEN F-PESGEN F-VALCTO WITH FRAME F-REPORTE.
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
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").

/*  IF s-salida-impresion = 1 THEN 
 *      s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".*/
  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + "report.prn".
  
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.
  
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
   
  CASE R-TpoRep:
        WHEN 1 THEN RUN Formato1.
        WHEN 2 THEN RUN Formato2.
        WHEN 3 THEN RUN Formato3.
  END.
  
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
  ASSIGN D-Corte DesdeC 
         F-CodFam F-SubFam 
         F-DesFam HastaC I-CodMon  
         TipoStk R-TpoRep T-Resumen R-Tipo
         F-marca1 F-marca2 F-provee1 F-provee2.
  
  IF HastaC <> "" THEN HastaC = "".
  IF F-marca2 <> "" THEN F-marca2 = "".
  IF F-provee2 <> "" THEN F-provee2 = "".
  
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
     D-Corte:SENSITIVE = NO.
     I-CodMon:SENSITIVE = NO.
     D-Corte = TODAY.
     R-Tipo = ''.
     DISPLAY D-Corte R-Tipo.
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

