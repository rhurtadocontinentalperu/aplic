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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE        VAR F-PESALM AS DECIMAL NO-UNDO.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.

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

DEFINE VAR F-STKALM  AS DECIMAL NO-UNDO.

DEFINE BUFFER B-Mate FOR Almmmate.
DEFINE VAR CATEGORIA AS CHAR INIT "MD".
DEFINE VAR x-nompro AS CHAR FORMAT "X(30)".
DEFINE VAR x-codpro AS CHAR FORMAT "X(11)".

/*****************/

DEF TEMP-TABLE DETALLE LIKE Almmmatg
    FIELD StkAlm AS DEC
    FIELD PreUni AS DEC.

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
&Scoped-Define ENABLED-OBJECTS RECT-49 RECT-47 RECT-56 FILL-IN-CodFam ~
RADIO-SET-Reporte FILL-IN-SubFam F-CodFam F-SubFam DesdeC HastaC F-marca1 ~
F-marca2 F-provee2 F-provee1 TipoStk T-Resumen R-costo T-IGV R-Tipo D-Corte ~
Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodFam RADIO-SET-Reporte ~
FILL-IN-SubFam F-CodFam F-DesFam F-SubFam F-DesSub DesdeC HastaC F-marca1 ~
F-marca2 F-provee2 F-provee1 TipoStk T-Resumen R-costo T-IGV R-TpoRep ~
R-Tipo I-CodMon D-Corte 

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

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Cat. Inicial" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.86 BY .81 NO-UNDO.

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
     LABEL "Cat. Final" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-Familia" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE I-CodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 13.72 BY .81 NO-UNDO.

DEFINE VARIABLE R-costo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Promedio", 1,
"Reposicion", 2
     SIZE 22.57 BY .54 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ambos", "",
"Activados", "A",
"Desactivados", "D"
     SIZE 12.86 BY 1.92 NO-UNDO.

DEFINE VARIABLE R-TpoRep AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "General", 1,
"Corte de Fecha", 3
     SIZE 15 BY 2 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Reporte AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Por Proveedor", 1,
"Por Producto", 2
     SIZE 15 BY 1.73 NO-UNDO.

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
     SIZE 62 BY 3.12.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 62 BY 2.62.

DEFINE RECTANGLE RECT-56
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15 BY 3.35.

DEFINE VARIABLE T-IGV AS LOGICAL INITIAL no 
     LABEL "Con IGV" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .77 NO-UNDO.

DEFINE VARIABLE T-Resumen AS LOGICAL INITIAL no 
     LABEL "Resumen Por Categoria Contable" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.43 BY .73 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodFam AT ROW 1.77 COL 18 COLON-ALIGNED
     RADIO-SET-Reporte AT ROW 1.77 COL 40 NO-LABEL
     FILL-IN-SubFam AT ROW 2.73 COL 18 COLON-ALIGNED
     F-CodFam AT ROW 3.69 COL 18 COLON-ALIGNED
     F-DesFam AT ROW 3.69 COL 24 COLON-ALIGNED NO-LABEL
     F-SubFam AT ROW 4.62 COL 18 COLON-ALIGNED
     F-DesSub AT ROW 4.62 COL 24 COLON-ALIGNED NO-LABEL
     DesdeC AT ROW 6.12 COL 18 COLON-ALIGNED
     HastaC AT ROW 6.19 COL 47 COLON-ALIGNED
     F-marca1 AT ROW 6.96 COL 18 COLON-ALIGNED
     F-marca2 AT ROW 6.96 COL 47 COLON-ALIGNED
     F-provee2 AT ROW 7.65 COL 47 COLON-ALIGNED
     F-provee1 AT ROW 7.69 COL 18 COLON-ALIGNED
     TipoStk AT ROW 9.31 COL 20 NO-LABEL
     T-Resumen AT ROW 10.08 COL 20.14
     R-costo AT ROW 10.85 COL 19.86 NO-LABEL
     T-IGV AT ROW 11.77 COL 49
     R-TpoRep AT ROW 11.96 COL 20 NO-LABEL
     R-Tipo AT ROW 12.15 COL 67 NO-LABEL
     I-CodMon AT ROW 12.46 COL 49 NO-LABEL
     D-Corte AT ROW 13.27 COL 47 COLON-ALIGNED
     Btn_OK AT ROW 14.85 COL 52.43
     Btn_Cancel AT ROW 14.85 COL 64.86
     "Criterio de Seleccion" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     "Estado" VIEW-AS TEXT
          SIZE 7.14 BY .69 AT ROW 11.19 COL 69
          FONT 1
     "Tipo de Costo" VIEW-AS TEXT
          SIZE 10.14 BY .5 AT ROW 10.85 COL 9
     RECT-49 AT ROW 11.77 COL 3
     RECT-46 AT ROW 14.73 COL 1
     RECT-47 AT ROW 8.69 COL 3
     RECT-56 AT ROW 11 COL 66
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 15.58
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
         TITLE              = "Existencias por Almacen"
         HEIGHT             = 15.58
         WIDTH              = 80
         MAX-HEIGHT         = 15.58
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 15.58
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN F-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET I-CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET R-TpoRep IN FRAME F-Main
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
ON END-ERROR OF W-Win /* Existencias por Almacen */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Existencias por Almacen */
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
ON LEAVE OF F-CodFam IN FRAME F-Main /* Cat. Inicial */
DO:
 ASSIGN F-codfam.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.

   FIND Almtabla WHERE Almtabla.Tabla  = "CC" AND
                       Almtabla.codigo = F-Codfam NO-LOCK NO-ERROR.
   IF AVAILABLE Almtabla THEN 
      DISPLAY Almtabla.Nombre @ F-Desfam WITH FRAME {&FRAME-NAME}.
      
     IF NOT AVAILABLE Almtabla THEN DO:
       MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.


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
ON LEAVE OF F-SubFam IN FRAME F-Main /* Cat. Final */
DO:
 ASSIGN F-subfam.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.

   FIND Almtabla WHERE Almtabla.Tabla  = "CC" AND
                       Almtabla.codigo = F-subfam NO-LOCK NO-ERROR.
   IF AVAILABLE Almtabla THEN 
      DISPLAY Almtabla.Nombre @ F-Dessub WITH FRAME {&FRAME-NAME}.
      
     IF NOT AVAILABLE Almtabla THEN DO:
       MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
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


&Scoped-define SELF-NAME R-TpoRep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-TpoRep W-Win
ON VALUE-CHANGED OF R-TpoRep IN FRAME F-Main
DO:
   ASSIGN R-TpoRep.
   CASE R-TpoRep:
        WHEN 1 THEN ASSIGN I-CodMon:SENSITIVE = NO
                            D-Corte:SENSITIVE = NO
                              T-Igv:SENSITIVE = NO.  
        WHEN 2 THEN ASSIGN I-CodMon:SENSITIVE = YES
                              T-Igv:SENSITIVE = YES
                            D-Corte:SENSITIVE = NO.      
        WHEN 3 THEN ASSIGN I-CodMon:SENSITIVE = YES
                            D-Corte:SENSITIVE = YES
                              T-Igv:SENSITIVE = YES.      

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
         F-marca1 F-marca2 F-provee1 F-provee2 T-igv R-COSTO
         FILL-IN-CodFam FILL-IN-SubFam
         RADIO-SET-Reporte.
  
  IF I-CodMon = 1 THEN C-MONEDA = "NUEVOS SOLES".
  ELSE C-MONEDA = "DOLARES AMERICANOS".
  
  IF HastaC <> "" THEN S-SUBTIT = "Materiales del " + DesdeC + " al " + HastaC .
  ELSE S-SUBTIT = "".

  IF HastaC = "" THEN HastaC = "999999999".
  IF F-marca2 = "" THEN F-marca2 = "ZZZZZZZZZZZZZ".
  IF F-provee2 = "" THEN F-provee2 = "ZZZZZZZZZZZZZ".
  IF F-Subfam  = "" THEN F-subfam  = "ZZZZZZZZZZZZZ".
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
  FOR EACH DETALLE:
    DELETE DETALLE.
  END.

  FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA 
                             AND  Almmmate.CodAlm = S-CODALM 
                             AND  (Almmmate.CodMat >= DesdeC  
                             AND   Almmmate.CodMat <= HastaC) , 
       FIRST Almmmatg OF Almmmate WHERE Almmmatg.Catconta[1] >= F-CodFam 
                                 AND  Almmmatg.Catconta[1] <= F-SubFam 
                                 AND  (Almmmatg.CodMar >= F-marca1 
                                 AND   Almmmatg.CodMar <= F-marca2)
                                 AND  (Almmmatg.CodPr1 >= F-provee1
                                 AND   Almmmatg.CodPr1 <= F-provee2)
                                 AND  Almmmatg.TpoArt BEGINS R-Tipo 
                                 AND almmmatg.codfam BEGINS FILL-IN-CodFam
                                 AND almmmatg.subfam BEGINS FILL-IN-SubFam
                                NO-LOCK:
    IF Almmmatg.FchCes <> ? THEN NEXT.
    DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
            FORMAT "X(11)" WITH FRAME F-Proceso.

    CREATE DETALLE.
    BUFFER-COPY Almmmatg TO DETALLE.
          
    /* UBICAMOS EL STOCK GENERAL A LA FECHA */
    ASSIGN
        DETALLE.StkAlm = 0
        DETALLE.PreUni = 0.
    FIND LAST Almdmov WHERE Almdmov.CodCia = S-CODCIA 
                       AND  Almdmov.CodMat = Almmmate.CodMat 
                       AND  Almdmov.FchDoc <= D-Corte 
                      USE-INDEX Almd02 NO-LOCK NO-ERROR.
    IF AVAILABLE Almdmov AND Almdmov.stkact > 0 THEN DO:
        CASE i-CodMon:
            WHEN 1 THEN DETALLE.PreUni = Almdmov.VCtoMn1.
            WHEN 2 THEN DETALLE.PreUni = Almdmov.VCtoMn2.
        END CASE.
    END.
    IF r-Costo = 2 THEN DO:
        DETALLE.PreUni = IF t-Igv THEN Almmmatg.CtoTot ELSE Almmmatg.CtoLis.
        IF Almmmatg.MonVta <> i-CodMon THEN DO:
            IF i-CodMon = 1 
            THEN DETALLE.PreUni = DETALLE.PreUni * Almmmatg.TpoCmb.
            ELSE DETALLE.PreUni = DETALLE.PreUni / Almmmatg.TpoCmb.
        END.
    END.
    /* UBICAMOS EL STOCK DE ALMACEN */
    FIND LAST Almdmov WHERE Almdmov.CodCia = S-CODCIA 
                       AND  Almdmov.CodAlm = Almmmate.CodAlm 
                       AND  Almdmov.CodMat = Almmmate.CodMat 
                       AND  Almdmov.FchDoc <= D-Corte 
                      USE-INDEX Almd03 NO-LOCK NO-ERROR.
    IF AVAILABLE Almdmov THEN DETALLE.StkAlm = Almdmov.StkSub.

    IF (TipoStk = 1 AND DETALLE.STKALM <> 0) OR TipoStk = 2 
    THEN /* OK */.
    ELSE DELETE DETALLE.
  END.
  HIDE FRAME F-Proceso.  
  
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
  DISPLAY FILL-IN-CodFam RADIO-SET-Reporte FILL-IN-SubFam F-CodFam F-DesFam 
          F-SubFam F-DesSub DesdeC HastaC F-marca1 F-marca2 F-provee2 F-provee1 
          TipoStk T-Resumen R-costo T-IGV R-TpoRep R-Tipo I-CodMon D-Corte 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-49 RECT-47 RECT-56 FILL-IN-CodFam RADIO-SET-Reporte 
         FILL-IN-SubFam F-CodFam F-SubFam DesdeC HastaC F-marca1 F-marca2 
         F-provee2 F-provee1 TipoStk T-Resumen R-costo T-IGV R-Tipo D-Corte 
         Btn_OK Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
DEFINE FRAME F-REPORTE
         DETALLE.codmat COLUMN-LABEL "Codigo" FORMAT "X(9)" AT 2
         DETALLE.DesMat COLUMN-LABEL "Descripcion" FORMAT "X(40)"
         DETALLE.DesMar COLUMN-LABEL "Descripcion" FORMAT "X(13)"
         DETALLE.UndStk COLUMN-LABEL "Unid" FORMAT 'x(7)'
         DETALLE.StkAlm COLUMN-LABEL "Cantidad" FORMAT "->>,>>>,>>9.999"
         DETALLE.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT "->>>,>>9.9999"
         F-VALCTO  COLUMN-LABEL "Importe!Total" FORMAT "->>>,>>>,>>9.99"
         DETALLE.Catcon[1] 
         DETALLE.Tipart
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn2}*/ FORMAT "X(50)" SKIP
         "EXISTENCIAS POR ALMACEN VALORIZADAS A PRECIO PROMEDIO AL "  AT 20  D-Corte
         "Pagina :" TO 105 PAGE-NUMBER(REPORT) TO 126 FORMAT "ZZZZZ9" SKIP
         IF T-Resumen THEN "(POR FAMILIA)"  ELSE '' AT 52 FORMAT 'X(20)'
         "Fecha :" TO 105 TODAY TO 126 FORMAT "99/99/9999" SKIP
         S-DESALM AT 40 FORMAT "X(30)"
         "Hora :" TO 105 STRING(TIME,"HH:MM:SS") TO 126 SKIP(1)
         S-SUBTIT        "Moneda : " TO 70 C-MONEDA SKIP
         "---------------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                                            Precio        Importe          " SKIP
         "     Codigo   Descripcion                              MARCA          Unid      Cantidad   Unitario         Total  C.C  Cat" SKIP
         "---------------------------------------------------------------------------------------------------------------------------" SKIP
/*                 1         2         3         4         5         6         7         8         9        10        11        12        13        14
          123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
           123456789 1234567890123456789012345678901234567890 1234567890123 1234 ->>,>>>,>>9.999 >>>>,>>>,>>9.99 ->>>,>>9.9999 ->>>,>>>,>>9.99 1 1      
           123456789 1234567890123456789012345678901234567890 1234567890123 1234 ->>,>>>,>>9.999 ->>>,>>9.9999 ->>>,>>>,>>9.99 1 1      
*/
  WITH WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
  
  FOR EACH DETALLE BREAK BY DETALLE.CodCia BY DETALLE.CatConta[1] BY DETALLE.CodPr1:
      IF FIRST-OF(DETALLE.Catconta[1]) AND NOT T-Resumen THEN DO:
         FIND Almtabla WHERE Almtabla.Tabla = CATEGORIA
                        AND  Almtabla.codigo = DETALLE.Catconta[1] 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtabla THEN DO:
             DISPLAY STREAM REPORT 
                 Almtabla.codigo @ DETALLE.codmat
                 Almtabla.Nombre @ DETALLE.DesMat WITH FRAME F-REPORTE.
             UNDERLINE STREAM REPORT DETALLE.DesMat WITH FRAME F-REPORTE.
         END.
      END.
      IF FIRST-OF(DETALLE.CodPr1) AND NOT T-Resumen THEN DO:
         X-NOMPRO = "".
         FIND Gn-Prov WHERE 
              Gn-Prov.Codcia = pv-codcia AND
              Gn-Prov.CodPro = DETALLE.CodPr1 
              NO-LOCK NO-ERROR.
         IF AVAILABLE Gn-Prov THEN DO:
             x-nompro = Gn-Prov.NomPro.
             DISPLAY STREAM REPORT 
                 DETALLE.CodPr1 @ DETALLE.desmar
                 x-nompro @ DETALLE.DesMat WITH FRAME F-REPORTE.
             UNDERLINE STREAM REPORT DETALLE.DesMat WITH FRAME F-REPORTE.
         END.
      END.
      
      F-VALCTO = DETALLE.StkAlm * DETALLE.PreUni.
      IF NOT T-Resumen THEN
         DISPLAY STREAM REPORT 
              DETALLE.codmat 
              DETALLE.DesMat 
              DETALLE.DesMar 
              DETALLE.UndStk 
              DETALLE.StkAlm
              DETALLE.PreUni
              F-VALCTO
              DETALLE.Catcon[1] 
              DETALLE.TipArt
              WITH FRAME F-REPORTE.

      ACCUMULATE DETALLE.STKALM (SUB-TOTAL BY DETALLE.Catconta[1]).
      ACCUMULATE DETALLE.STKALM (TOTAL).
      ACCUMULATE F-VALCTO (SUB-TOTAL BY DETALLE.Catconta[1]).
      ACCUMULATE F-VALCTO (TOTAL).

      IF LAST-OF(DETALLE.Catconta[1]) THEN DO:
         IF T-Resumen THEN DO:
            FIND Almtabla WHERE Almtabla.Tabla = CATEGORIA
                            AND Almtabla.codigo = DETALLE.Catconta[1] 
                           NO-LOCK NO-ERROR.
            DISPLAY STREAM REPORT 
                 Almtabla.codigo @ DETALLE.codmat
                 Almtabla.Nombre @ DETALLE.DesMat
                 ACCUM SUB-TOTAL BY DETALLE.Catconta[1] DETALLE.STKALM @ DETALLE.STKALM 
                 ACCUM SUB-TOTAL BY DETALLE.Catconta[1] F-VALCTO @ F-VALCTO  WITH FRAME F-REPORTE.
            END.
         ELSE DO: 
            UNDERLINE STREAM REPORT DETALLE.STKALM F-VALCTO WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
                '              Total Categoria  --> ' @ DETALLE.desmat
                ACCUM SUB-TOTAL BY DETALLE.Catconta[1] DETALLE.STKALM @ DETALLE.STKALM 
                ACCUM SUB-TOTAL BY DETALLE.Catconta[1] F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
         END.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.
      IF LAST-OF(DETALLE.Codcia) THEN DO:
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT DETALLE.STKALM F-VALCTO WITH FRAME F-REPORTE.
         DISPLAY STREAM REPORT 
             '              TOTAL GENERAL      --> ' @ DETALLE.desmat
             ACCUM TOTAL DETALLE.STKALM @ DETALLE.STKALM 
             ACCUM TOTAL F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT DETALLE.STKALM F-PESALM F-VALCTO WITH FRAME F-REPORTE.
      END.
  END.

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
         Almmmatg.DesMat AT 17 COLUMN-LABEL "Descripcion" FORMAT "X(55)"
         Almmmatg.DesMar AT 79 FORMAT "X(13)"
         Almmmatg.UndStk AT 94 COLUMN-LABEL "Unidad" FORMAT 'x(7)'
         F-STKALM        AT 100 COLUMN-LABEL "Cantidad" FORMAT "->>,>>>,>>9.99"
         F-PESALM        FORMAT "->>>,>>>,>>9.99"
         Almmmatg.Catcon[1] 
         Almmmatg.Tipart
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A}*/ AT 6 FORMAT "X(50)" SKIP
         "EXISTENCIAS POR ALMACEN" AT 40 
         "Pagina : " TO 103 PAGE-NUMBER(REPORT) TO 113 FORMAT "ZZZZZ9" SKIP
         IF T-Resumen THEN "(POR FAMILIA)"  ELSE '' AT 48 FORMAT 'X(20)'
         " Fecha : " TO 103 TODAY TO 113 FORMAT "99/99/9999" SKIP
         S-DESALM AT 40 FORMAT "X(30)"
         "  Hora : " TO 103 STRING(TIME,"HH:MM:SS") TO 113 SKIP(1)
         S-SUBTIT AT 6 SKIP(1)
         "     ----------------------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                                                                      P e s o          " SKIP
         "     Codigo   Descripcion                                                    MARCA          Unidad      Cantidad       Kilos   C.C. Cat" SKIP
         "     ----------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH WIDTH 160 NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO DOWN.

  FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA 
                             AND  Almmmate.CodAlm = S-CODALM 
                             AND  (Almmmate.CodMat >= DesdeC  
                             AND   Almmmate.CodMat <= HastaC) , 
      EACH Almmmatg OF Almmmate WHERE Almmmatg.Catconta[1] >= F-CodFam 
                                 AND  Almmmatg.Catconta[1] <= F-SubFam 
                                 AND  (Almmmatg.CodMar >= F-marca1 
                                 AND   Almmmatg.CodMar <= F-marca2)
                                 AND  (Almmmatg.CodPr1 >= F-provee1
                                 AND   Almmmatg.CodPr1 <= F-provee2)
                                 AND  Almmmatg.TpoArt BEGINS R-Tipo 
                                 AND almmmatg.codfam BEGINS FILL-IN-CodFam
                                 AND almmmatg.subfam BEGINS FILL-IN-SubFam
                                NO-LOCK
      BREAK BY Almmmate.codcia BY Almmmatg.Catconta[1] BY Almmmatg.CodPr1:
      IF Almmmatg.FchCes <> ? THEN NEXT.
      DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      IF FIRST-OF(Almmmatg.Catconta[1]) AND NOT T-Resumen THEN DO:
         FIND Almtabla WHERE 
              Almtabla.Tabla  = CATEGORIA AND
              Almtabla.codigo = Almmmatg.Catconta[1] NO-LOCK NO-ERROR.
         IF AVAILABLE Almtabla THEN DO:
             DISPLAY STREAM REPORT 
                 Almtabla.codigo @ Almmmatg.codmat
                 Almtabla.Nombre @ Almmmatg.DesMat WITH FRAME F-REPORTE.
             UNDERLINE STREAM REPORT Almmmatg.DesMat WITH FRAME F-REPORTE.
         END.
      END.

      IF FIRST-OF(Almmmatg.CodPr1) AND NOT T-Resumen THEN DO:
         X-NOMPRO = "".
         FIND Gn-Prov WHERE 
              Gn-Prov.Codcia = pv-codcia AND
              Gn-Prov.CodPro = Almmmatg.CodPr1 
              NO-LOCK NO-ERROR.
         IF AVAILABLE Gn-Prov THEN DO:
             x-nompro = Gn-Prov.NomPro.
             DISPLAY STREAM REPORT 
                 Almmmatg.CodPr1 @ Almmmatg.desmar
                 x-nompro @ Almmmatg.DesMat WITH FRAME F-REPORTE.
             UNDERLINE STREAM REPORT Almmmatg.DesMat WITH FRAME F-REPORTE.
         END.
      END.
      F-STKALM = Almmmate.StkAct.
      IF (TipoStk = 1 AND F-STKALM > 0) OR TipoStk = 2 THEN DO:
         F-PESALM = F-STKALM * Almmmatg.Pesmat.
         IF NOT T-Resumen THEN DO:
            DISPLAY STREAM REPORT 
                 Almmmatg.Catconta[1]
                 Almmmatg.codmat 
                 Almmmatg.DesMat 
                 Almmmatg.DesMar 
                 Almmmatg.UndStk 
                 F-STKALM 
                 F-PESALM WHEN F-PESALM > 0 
                 Almmmatg.Catcon[1] 
                 Almmmatg.Tipart
                 WITH FRAME F-REPORTE.
         END.
         ACCUMULATE F-STKALM (SUB-TOTAL BY Almmmatg.Catconta[1]).
         ACCUMULATE F-STKALM (TOTAL).
         ACCUMULATE F-PESALM (SUB-TOTAL BY Almmmatg.Catconta[1]).
         ACCUMULATE F-PESALM (TOTAL).
      END.
      IF LAST-OF(Almmmatg.Catconta[1]) THEN DO:
         IF T-Resumen THEN DO:
            FIND Almtabla WHERE 
                 Almtabla.Tabla  = CATEGORIA AND
                 Almtabla.codigo = Almmmatg.Catconta[1] NO-LOCK NO-ERROR.
            DISPLAY STREAM REPORT 
                    Almtabla.codigo @ Almmmatg.codmat
                    Almtabla.Nombre @ Almmmatg.DesMat
                    ACCUM SUB-TOTAL BY Almmmatg.Catconta[1] F-STKALM @ F-STKALM 
                    ACCUM SUB-TOTAL BY Almmmatg.Catconta[1] F-PESALM @ F-PESALM  WITH FRAME F-REPORTE.
            END.
         ELSE DO:
            UNDERLINE STREAM REPORT F-STKALM F-PESALM WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
                '                    Total Categoria   --> ' @ Almmmatg.desmat
                ACCUM SUB-TOTAL BY Almmmatg.Catconta[1] F-STKALM @ F-STKALM 
                ACCUM SUB-TOTAL BY Almmmatg.Catconta[1] F-PESALM @ F-PESALM WITH FRAME F-REPORTE.
         END.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.
      IF LAST-OF(Almmmate.Codcia) THEN DO:
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKALM F-PESALM WITH FRAME F-REPORTE.
         DISPLAY STREAM REPORT 
             '                    TOTAL GENERAL      --> ' @ Almmmatg.desmat
             ACCUM TOTAL F-STKALM @ F-STKALM 
             ACCUM TOTAL F-PESALM @ F-PESALM WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKALM F-PESALM WITH FRAME F-REPORTE.
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
         Almmmatg.codmat COLUMN-LABEL "Codigo" FORMAT "X(9)" AT 2
         Almmmatg.DesMat COLUMN-LABEL "Descripcion" FORMAT "X(40)"
         Almmmatg.DesMar FORMAT "X(13)"
         Almmmatg.UndStk COLUMN-LABEL "Unid" FORMAT 'x(7)'
         F-STKALM  COLUMN-LABEL "Cantidad" FORMAT "->>,>>>,>>9.999"
         F-PESALM        FORMAT "->>>,>>>,>>9.99"
         F-PRECTO  COLUMN-LABEL "Precio!Unitario" FORMAT "->>>,>>9.9999"
         F-VALCTO  COLUMN-LABEL "Importe!Total" FORMAT "->>>,>>>,>>9.99"
         Almmmatg.Catcon[1] 
         Almmmatg.TipArt
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn2}*/ FORMAT "X(50)" SKIP
         "EXISTENCIAS POR ALMACEN VALORIZADAS A PRECIO PROMEDIO" AT 20  
         "Pagina :" TO 105 PAGE-NUMBER(REPORT) TO 126 FORMAT "ZZZZZ9" SKIP
         IF T-Resumen THEN "(POR FAMILIA)"  ELSE '' AT 44 FORMAT 'X(20)'
         "Fecha :" TO 105 TODAY TO 126 FORMAT "99/99/9999" SKIP
         S-DESALM AT 40 FORMAT "X(30)"
         "Hora :" TO 105 STRING(TIME,"HH:MM:SS") TO 126 SKIP(1)
         S-SUBTIT        "Moneda : " TO 70 C-MONEDA SKIP
         "-------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                                              P E S O       Precio        Importe          " SKIP
         "     Codigo   Descripcion                              MARCA          Unid      Cantidad       Kilos       Unitario         Total  C.C  Cat" SKIP
         "-------------------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
  
  FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA 
                             AND  Almmmate.CodAlm = S-CODALM 
                             AND  (Almmmate.CodMat >= DesdeC  
                             AND   Almmmate.CodMat <= HastaC) , 
       EACH Almmmatg OF Almmmate WHERE Almmmatg.Catconta[1] >= F-CodFam 
                                 AND  Almmmatg.Catconta[1] <= F-SubFam 
                                 AND  (Almmmatg.CodMar >= F-marca1 
                                 AND   Almmmatg.CodMar <= F-marca2)
                                 AND  (Almmmatg.CodPr1 >= F-provee1
                                 AND   Almmmatg.CodPr1 <= F-provee2)
                                 AND  Almmmatg.TpoArt BEGINS R-Tipo 
                                 AND almmmatg.codfam BEGINS FILL-IN-CodFam
                                 AND almmmatg.subfam BEGINS FILL-IN-SubFam
                                NO-LOCK
      BREAK BY Almmmate.codcia BY Almmmatg.Catconta[1] BY Almmmatg.CodPr1:
      IF Almmmatg.FchCes <> ? THEN NEXT.
      DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      IF FIRST-OF(Almmmatg.Catconta[1]) AND NOT T-Resumen THEN DO:
         FIND Almtabla WHERE Almtabla.Tabla  = CATEGORIA
                        AND  Almtabla.codigo = Almmmatg.Catconta[1] 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtabla THEN DO:
             DISPLAY STREAM REPORT 
                 Almtabla.codigo @ Almmmatg.codmat
                 Almtabla.Nombre @ Almmmatg.DesMat WITH FRAME F-REPORTE.
             UNDERLINE STREAM REPORT Almmmatg.DesMat WITH FRAME F-REPORTE.
         END.
      END.
      IF FIRST-OF(Almmmatg.CodPr1) AND NOT T-Resumen THEN DO:
         X-NOMPRO = "".
         FIND Gn-Prov WHERE 
              Gn-Prov.Codcia = pv-codcia AND
              Gn-Prov.CodPro = Almmmatg.CodPr1 
              NO-LOCK NO-ERROR.
         IF AVAILABLE Gn-Prov THEN DO:
             x-nompro = Gn-Prov.NomPro.
             DISPLAY STREAM REPORT 
                 Almmmatg.CodPr1 @ Almmmatg.desmar
                 x-nompro @ Almmmatg.DesMat WITH FRAME F-REPORTE.
             UNDERLINE STREAM REPORT Almmmatg.DesMat WITH FRAME F-REPORTE.
         END.
      END.
      
      F-STKALM = 0.
      
      FOR EACH B-mate NO-LOCK WHERE 
               B-mate.CodCia = S-CODCIA AND
               B-mate.codmat = Almmmatg.CodMat AND
               B-mate.StkAct > 0:
          F-STKALM = F-STKALM + B-Mate.StkAct.
      END.
      
      /*F-STKALM = Almmmate.StkAct.*/
      
      
      IF I-CodMon = 1 THEN F-VALCTO = Almmmatg.VCtMn1. 
      IF I-CodMon = 2 THEN F-VALCTO = Almmmatg.VCtMn2.

      IF F-STKALM <> 0 THEN F-VALCTO = ( F-VALCTO / F-STKALM ) .

      F-STKALM = Almmmate.StkAct.

      F-VALCTO = F-VALCTO * F-STKALM.
      
      IF R-COSTO = 2 THEN DO:
        /************MAGM********************/
         F-VALCTO = Almmmatg.CtoLis.
         IF T-igv THEN F-VALCTO = Almmmatg.CtoTot.
         IF I-CodMon <> Almmmatg.MonVta THEN DO:
          IF I-CodMon = 1 THEN F-VALCTO = F-VALCTO * Almmmatg.TpoCmb. 
          IF I-CodMon = 2 THEN F-VALCTO = F-VALCTO / Almmmatg.TpoCmb. 
         END.
         F-VALCTO = F-VALCTO * F-STKALM .
        /*********************************/
      END.
     
      
      IF (TipoStk = 1 AND F-STKALM > 0) OR TipoStk = 2 THEN DO:
         F-PRECTO = IF F-STKALM <> 0 THEN ROUND(F-VALCTO / F-STKALM,4) ELSE 0.
         F-VALCTO = ROUND(F-STKALM * F-PRECTO,2).
         F-PESALM = Almmmatg.Pesmat * F-STKALM.
         IF NOT T-Resumen THEN
            DISPLAY STREAM REPORT 
                 Almmmatg.codmat 
                 Almmmatg.DesMat 
                 Almmmatg.DesMar 
                 Almmmatg.UndStk 
                 F-STKALM  
                 F-PESALM
                 F-PRECTO  
                 F-VALCTO
                 Almmmatg.Catcon[1] 
                 Almmmatg.TipArt
                 WITH FRAME F-REPORTE.
         ACCUMULATE F-STKALM (SUB-TOTAL BY Almmmatg.Catconta[1]).
         ACCUMULATE F-STKALM (TOTAL).
         ACCUMULATE F-PESALM (SUB-TOTAL BY Almmmatg.Catconta[1]).
         ACCUMULATE F-PESALM (TOTAL).
         ACCUMULATE F-VALCTO (SUB-TOTAL BY Almmmatg.Catconta[1]).
         ACCUMULATE F-VALCTO (SUB-TOTAL BY Almmmatg.CodPr1).
         ACCUMULATE F-VALCTO (TOTAL).
      END.
      IF LAST-OF(Almmmatg.CodPr1) THEN DO:
         IF NOT T-Resumen THEN DO: 
            UNDERLINE STREAM REPORT F-STKALM F-PESALM F-VALCTO WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
                '              Total Proveedor  --> ' @ Almmmatg.desmat
                ACCUM SUB-TOTAL BY Almmmatg.Codpr1 F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
         END.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.

      IF LAST-OF(Almmmatg.Catconta[1]) THEN DO:
         IF T-Resumen THEN DO: 
            FIND Almtabla WHERE Almtabla.Tabla = CATEGORIA AND
                 Almtabla.codigo = Almmmatg.Catconta[1] NO-LOCK NO-ERROR.
            DISPLAY STREAM REPORT 
                 Almtabla.codigo @ Almmmatg.codmat
                 Almtabla.Nombre @ Almmmatg.DesMat
                 ACCUM SUB-TOTAL BY Almmmatg.Catconta[1] F-STKALM @ F-STKALM 
                 ACCUM SUB-TOTAL BY Almmmatg.Catconta[1] F-PESALM @ F-PESALM 
                 ACCUM SUB-TOTAL BY Almmmatg.Catconta[1] F-VALCTO @ F-VALCTO  WITH FRAME F-REPORTE.
            END.
         ELSE DO:
            UNDERLINE STREAM REPORT F-STKALM F-PESALM F-VALCTO WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
                '              Total Categoria  --> ' @ Almmmatg.desmat
                ACCUM SUB-TOTAL BY Almmmatg.Catconta[1] F-STKALM @ F-STKALM 
                ACCUM SUB-TOTAL BY Almmmatg.Catconta[1] F-PESALM @ F-PESALM 
                ACCUM SUB-TOTAL BY Almmmatg.Catconta[1] F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
         END.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.
      IF LAST-OF(Almmmate.Codcia) THEN DO:
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKALM F-PESALM F-VALCTO WITH FRAME F-REPORTE.
         DISPLAY STREAM REPORT 
             '              TOTAL GENERAL      --> ' @ Almmmatg.desmat
             ACCUM TOTAL F-STKALM @ F-STKALM 
             ACCUM TOTAL F-PESALM @ F-PESALM 
             ACCUM TOTAL F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKALM F-PESALM F-VALCTO WITH FRAME F-REPORTE.
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
         Almmmatg.codmat COLUMN-LABEL "Codigo" FORMAT "X(9)" AT 2
         Almmmatg.DesMat COLUMN-LABEL "Descripcion" FORMAT "X(40)"
         Almmmatg.DesMar COLUMN-LABEL "Descripcion" FORMAT "X(13)"
         Almmmatg.UndStk COLUMN-LABEL "Unid" FORMAT 'x(7)'
         F-STKALM  COLUMN-LABEL "Cantidad" FORMAT "->>,>>>,>>9.999"
         /*F-PESALM        FORMAT ">>>>,>>>,>>9.99"*/
         F-PRECTO  COLUMN-LABEL "Precio!Unitario" FORMAT "->>>,>>9.9999"
         F-VALCTO  COLUMN-LABEL "Importe!Total" FORMAT "->>>,>>>,>>9.99"
         Almmmatg.Catcon[1] 
         Almmmatg.Tipart
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn2}*/ FORMAT "X(50)" SKIP
         "EXISTENCIAS POR ALMACEN VALORIZADAS A PRECIO PROMEDIO AL "  AT 20  D-Corte
         "Pagina :" TO 105 PAGE-NUMBER(REPORT) TO 126 FORMAT "ZZZZZ9" SKIP
         IF T-Resumen THEN "(POR FAMILIA)"  ELSE '' AT 52 FORMAT 'X(20)'
         "Fecha :" TO 105 TODAY TO 126 FORMAT "99/99/9999" SKIP
         S-DESALM AT 40 FORMAT "X(30)"
         "Hora :" TO 105 STRING(TIME,"HH:MM:SS") TO 126 SKIP(1)
         S-SUBTIT        "Moneda : " TO 70 C-MONEDA SKIP
         "---------------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                                            Precio        Importe          " SKIP
         "     Codigo   Descripcion                              MARCA          Unid      Cantidad   Unitario         Total  C.C  Cat" SKIP
         "---------------------------------------------------------------------------------------------------------------------------" SKIP
/*                 1         2         3         4         5         6         7         8         9        10        11        12        13        14
          123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
           123456789 1234567890123456789012345678901234567890 1234567890123 1234 ->>,>>>,>>9.999 >>>>,>>>,>>9.99 ->>>,>>9.9999 ->>>,>>>,>>9.99 1 1      
           123456789 1234567890123456789012345678901234567890 1234567890123 1234 ->>,>>>,>>9.999 ->>>,>>9.9999 ->>>,>>>,>>9.99 1 1      
*/
  WITH WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
  
  FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA 
                             AND  Almmmate.CodAlm = S-CODALM 
                             AND  (Almmmate.CodMat >= DesdeC  
                             AND   Almmmate.CodMat <= HastaC) , 
       EACH Almmmatg OF Almmmate WHERE Almmmatg.Catconta[1] >= F-CodFam 
                                 AND  Almmmatg.Catconta[1] <= F-SubFam 
                                 AND  (Almmmatg.CodMar >= F-marca1 
                                 AND   Almmmatg.CodMar <= F-marca2)
                                 AND  (Almmmatg.CodPr1 >= F-provee1
                                 AND   Almmmatg.CodPr1 <= F-provee2)
                                 AND  Almmmatg.TpoArt BEGINS R-Tipo 
                                 AND almmmatg.codfam BEGINS FILL-IN-CodFam
                                 AND almmmatg.subfam BEGINS FILL-IN-SubFam
                                 AND Almmmatg.FchCes = ?
                                NO-LOCK
      BREAK BY Almmmate.codcia BY Almmmatg.Catconta[1] BY Almmmatg.CodPr1:
      /*IF Almmmatg.FchCes <> ? THEN NEXT.*/
      DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      IF FIRST-OF(Almmmatg.Catconta[1]) AND NOT T-Resumen THEN DO:
         FIND Almtabla WHERE Almtabla.Tabla = CATEGORIA
                        AND  Almtabla.codigo = Almmmatg.Catconta[1] 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtabla THEN DO:
             DISPLAY STREAM REPORT 
                 Almtabla.codigo @ Almmmatg.codmat
                 Almtabla.Nombre @ Almmmatg.DesMat WITH FRAME F-REPORTE.
             UNDERLINE STREAM REPORT Almmmatg.DesMat WITH FRAME F-REPORTE.
         END.
      END.
      IF FIRST-OF(Almmmatg.CodPr1) AND NOT T-Resumen THEN DO:
         X-NOMPRO = "".
         FIND Gn-Prov WHERE 
              Gn-Prov.Codcia = pv-codcia AND
              Gn-Prov.CodPro = Almmmatg.CodPr1 
              NO-LOCK NO-ERROR.
         IF AVAILABLE Gn-Prov THEN DO:
             x-nompro = Gn-Prov.NomPro.
             DISPLAY STREAM REPORT 
                 Almmmatg.CodPr1 @ Almmmatg.desmar
                 x-nompro @ Almmmatg.DesMat WITH FRAME F-REPORTE.
             UNDERLINE STREAM REPORT Almmmatg.DesMat WITH FRAME F-REPORTE.
         END.
      END.
      
      /* UBICAMOS EL STOCK GENERAL A LA FECHA */
      FIND LAST Almdmov WHERE Almdmov.CodCia = S-CODCIA 
                         AND  Almdmov.CodMat = Almmmate.CodMat 
                         AND  Almdmov.FchDoc <= D-Corte 
                        USE-INDEX Almd02 NO-LOCK NO-ERROR.
      IF AVAILABLE Almdmov THEN F-STKALM = Almdmov.StkAct.
      ELSE F-STKALM = 0.
      /*
      IF AVAILABLE Almdmov AND I-CodMon = 1 THEN F-VALCTO = Almdmov.VctoMn1.
      IF AVAILABLE Almdmov AND I-CodMon = 2 THEN F-VALCTO = Almdmov.VctoMn2.
      */
      /*
      
      */
      /* UBICAMOS EL STOCK DE ALMACEN */
      FIND LAST Almdmov WHERE Almdmov.CodCia = S-CODCIA 
                         AND  Almdmov.CodAlm = Almmmate.CodAlm 
                         AND  Almdmov.CodMat = Almmmate.CodMat 
                         AND  Almdmov.FchDoc <= D-Corte 
                        USE-INDEX Almd03 NO-LOCK NO-ERROR.
      IF AVAILABLE Almdmov THEN F-STKALM = Almdmov.StkSub.
      ELSE F-STKALM = 0.
     
      IF AVAILABLE Almdmov AND I-CodMon = 1 THEN F-VALCTO = Almdmov.VctoMn1.
      IF AVAILABLE Almdmov AND I-CodMon = 2 THEN F-VALCTO = Almdmov.VctoMn2.
      
      IF F-STKALM <> 0 THEN F-VALCTO = ( F-VALCTO / Almdmov.StkAct ) * F-STKALM .
 
      /* F-VALCTO = F-VALCTO * F-STKALM.*/

      IF R-COSTO = 2 THEN DO:
        /************MAGM********************/
        IF AVAILABLE Almdmov THEN DO:
         F-VALCTO = Almmmatg.CtoLis.
         IF T-igv THEN F-VALCTO = Almmmatg.CtoTot.
         IF I-CodMon <> Almmmatg.MonVta THEN DO:
          IF I-CodMon = 1 THEN F-VALCTO = F-VALCTO * Almmmatg.TpoCmb. 
          IF I-CodMon = 2 THEN F-VALCTO = F-VALCTO / Almmmatg.TpoCmb. 
         END.
        END.
       /*********************************/
      END.
      
      IF (TipoStk = 1 AND F-STKALM > 0) OR TipoStk = 2 THEN DO:
         F-VALCTO = IF F-STKALM <> 0 THEN F-VALCTO ELSE 0.
         F-PRECTO = IF F-STKALM <> 0 THEN ROUND(F-VALCTO / F-STKALM,4) ELSE 0.
         F-VALCTO = ROUND(F-STKALM * F-PRECTO,2).
         F-PESALM = Almmmatg.Pesmat * F-STKALM.
         IF NOT T-Resumen THEN
            DISPLAY STREAM REPORT 
                 Almmmatg.codmat 
                 Almmmatg.DesMat 
                 Almmmatg.DesMar 
                 Almmmatg.UndStk 
                 F-STKALM 
                 /*F-PESALM*/
                 F-PRECTO  
                 F-VALCTO
                 Almmmatg.Catcon[1] 
                 Almmmatg.TipArt
                 WITH FRAME F-REPORTE.

         ACCUMULATE F-STKALM (SUB-TOTAL BY Almmmatg.Catconta[1]).
         ACCUMULATE F-STKALM (TOTAL).
         ACCUMULATE F-PESALM (SUB-TOTAL BY Almmmatg.Catconta[1]).
         ACCUMULATE F-PESALM (TOTAL).
         ACCUMULATE F-VALCTO (SUB-TOTAL BY Almmmatg.Catconta[1]).
         ACCUMULATE F-VALCTO (TOTAL).
      END.
      IF LAST-OF(Almmmatg.Catconta[1]) THEN DO:
         IF T-Resumen THEN DO:
            FIND Almtabla WHERE Almtabla.Tabla = CATEGORIA
                            AND Almtabla.codigo = Almmmatg.Catconta[1] 
                           NO-LOCK NO-ERROR.
            DISPLAY STREAM REPORT 
                 Almtabla.codigo @ Almmmatg.codmat
                 Almtabla.Nombre @ Almmmatg.DesMat
                 ACCUM SUB-TOTAL BY Almmmatg.Catconta[1] F-STKALM @ F-STKALM 
                 /*ACCUM SUB-TOTAL BY Almmmatg.Catconta[1] F-PESALM @ F-PESALM */
                 ACCUM SUB-TOTAL BY Almmmatg.Catconta[1] F-VALCTO @ F-VALCTO  WITH FRAME F-REPORTE.
            END.
         ELSE DO: 
            UNDERLINE STREAM REPORT F-STKALM /*F-PESALM*/ F-VALCTO WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
                '              Total Categoria  --> ' @ Almmmatg.desmat
                ACCUM SUB-TOTAL BY Almmmatg.Catconta[1] F-STKALM @ F-STKALM 
                /*ACCUM SUB-TOTAL BY Almmmatg.Catconta[1] F-PESALM @ F-PESALM */
                ACCUM SUB-TOTAL BY Almmmatg.Catconta[1] F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
         END.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.
      IF LAST-OF(Almmmate.Codcia) THEN DO:
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKALM F-PESALM F-VALCTO WITH FRAME F-REPORTE.
         DISPLAY STREAM REPORT 
             '              TOTAL GENERAL      --> ' @ Almmmatg.desmat
             ACCUM TOTAL F-STKALM @ F-STKALM 
             /*ACCUM TOTAL F-PESALM @ F-PESALM */
             ACCUM TOTAL F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT F-STKALM F-PESALM F-VALCTO WITH FRAME F-REPORTE.
      END.
  END.
  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formatob W-Win 
PROCEDURE Formatob :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE FRAME F-REPORTE
         DETALLE.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)" 
         DETALLE.DesMat COLUMN-LABEL "Descripcion" FORMAT "X(40)"
         DETALLE.DesMar COLUMN-LABEL "Descripcion" FORMAT "X(13)"
         DETALLE.UndStk COLUMN-LABEL "Unid"        FORMAT "X(7)"
         DETALLE.StkAlm COLUMN-LABEL "Cantidad" FORMAT "->>,>>>,>>9.999"
         DETALLE.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT "->>>,>>9.9999"
         F-VALCTO  COLUMN-LABEL "Importe!Total" FORMAT "->>>,>>>,>>9.99"
         DETALLE.Catcon[1] FORMAT "X(2)"
         DETALLE.Tipart    FORMAT "X(3)"
         DETALLE.CodFam
         Almtfami.desfam   FORMAT "X(20)"
         DETALLE.SubFam
         Almsfami.dessub   FORMAT "X(20)"
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn2}*/ FORMAT "X(50)" SKIP
         "EXISTENCIAS POR ALMACEN VALORIZADAS A PRECIO PROMEDIO AL "  AT 20  D-Corte
         "Pagina :" TO 105 PAGE-NUMBER(REPORT) TO 126 FORMAT "ZZZZZ9" SKIP
         IF T-Resumen THEN "(POR FAMILIA)"  ELSE '' AT 52 FORMAT 'X(20)'
         "Fecha :" TO 105 TODAY TO 126 FORMAT "99/99/9999" SKIP
         S-DESALM AT 40 FORMAT "X(30)"
         "Hora :" TO 105 STRING(TIME,"HH:MM:SS") TO 126 SKIP(1)
         S-SUBTIT        "Moneda : " TO 70 C-MONEDA SKIP
         "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                                            Precio         Importe                                                         " SKIP
         "Codigo Descripcion                              MARCA         Unid          Cantidad      Unitario          Total  CC Cat Familia                  Sub-Familia             " SKIP
         "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*                 1         2         3         4         5         6         7         8         9        10        11        12        13        14
          123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
          123456 1234567890123456789012345678901234567890 1234567890123 123456 ->>,>>>,>>9.999 ->>>,>>9.9999 ->>>,>>>,>>9.99 12 123 123 12345678901234567890 123 12345678901234567890
*/
  WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
  
  FOR EACH DETALLE ,
        FIRST Almtfami OF DETALLE NO-LOCK,
        FIRST ALmsfami NO-LOCK WHERE Almsfami.codcia = DETALLE.codcia
            AND Almsfami.codfam = DETALLE.codfam
            AND Almsfami.subfam = DETALLE.subfam
        BREAK BY DETALLE.CodCia BY DETALLE.CatConta[1] BY DETALLE.CodMat:
      IF FIRST-OF(DETALLE.Catconta[1]) AND NOT T-Resumen THEN DO:
         FIND Almtabla WHERE Almtabla.Tabla = CATEGORIA
                        AND  Almtabla.codigo = DETALLE.Catconta[1] 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtabla THEN DO:
             DISPLAY STREAM REPORT 
                 Almtabla.codigo @ DETALLE.codmat
                 Almtabla.Nombre @ DETALLE.DesMat WITH FRAME F-REPORTE.
             UNDERLINE STREAM REPORT DETALLE.DesMat WITH FRAME F-REPORTE.
         END.
      END.
      F-VALCTO = DETALLE.StkAlm * DETALLE.PreUni.
      IF NOT T-Resumen THEN
         DISPLAY STREAM REPORT 
              DETALLE.codmat 
              DETALLE.DesMat 
              DETALLE.DesMar 
              DETALLE.UndStk 
              DETALLE.StkAlm
              DETALLE.PreUni
              F-VALCTO
              DETALLE.Catcon[1] 
              DETALLE.TipArt
              DETALLE.codfam
              DETALLE.subfam
              Almtfami.desfam
              Almsfami.dessub
              WITH FRAME F-REPORTE.

      ACCUMULATE DETALLE.STKALM (SUB-TOTAL BY DETALLE.Catconta[1]).
      ACCUMULATE DETALLE.STKALM (TOTAL).
      ACCUMULATE F-VALCTO (SUB-TOTAL BY DETALLE.Catconta[1]).
      ACCUMULATE F-VALCTO (TOTAL).

      IF LAST-OF(DETALLE.Catconta[1]) THEN DO:
         IF T-Resumen THEN DO:
            FIND Almtabla WHERE Almtabla.Tabla = CATEGORIA
                            AND Almtabla.codigo = DETALLE.Catconta[1] 
                           NO-LOCK NO-ERROR.
            DISPLAY STREAM REPORT 
                 Almtabla.codigo @ DETALLE.codmat
                 Almtabla.Nombre @ DETALLE.DesMat
                 ACCUM SUB-TOTAL BY DETALLE.Catconta[1] DETALLE.STKALM @ DETALLE.STKALM 
                 ACCUM SUB-TOTAL BY DETALLE.Catconta[1] F-VALCTO @ F-VALCTO  WITH FRAME F-REPORTE.
            END.
         ELSE DO: 
            UNDERLINE STREAM REPORT DETALLE.STKALM F-VALCTO WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
                '              Total Categoria  --> ' @ DETALLE.desmat
                ACCUM SUB-TOTAL BY DETALLE.Catconta[1] DETALLE.STKALM @ DETALLE.STKALM 
                ACCUM SUB-TOTAL BY DETALLE.Catconta[1] F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
         END.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.
      IF LAST-OF(DETALLE.Codcia) THEN DO:
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT DETALLE.STKALM F-VALCTO WITH FRAME F-REPORTE.
         DISPLAY STREAM REPORT 
             '              TOTAL GENERAL      --> ' @ DETALLE.desmat
             ACCUM TOTAL DETALLE.STKALM @ DETALLE.STKALM 
             ACCUM TOTAL F-VALCTO @ F-VALCTO WITH FRAME F-REPORTE.
         UNDERLINE STREAM REPORT DETALLE.STKALM F-PESALM F-VALCTO WITH FRAME F-REPORTE.
      END.
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
    ENABLE ALL EXCEPT F-DesFam F-DesSub R-TpoRep i-CodMon.
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

    RUN Carga-Temporal.

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
        CASE RADIO-SET-Reporte:
            WHEN 1 THEN RUN Formato.
            WHEN 2 THEN RUN Formatob.
        END CASE.
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
  ASSIGN D-Corte DesdeC 
         F-CodFam F-SubFam 
         F-DesFam HastaC I-CodMon  
         TipoStk R-TpoRep T-Resumen R-Tipo
         F-marca1 F-marca2 F-provee1 F-provee2 R-COSTO.
  
  IF HastaC <> "" THEN HastaC = "".
  IF F-marca2 <> "" THEN F-marca2 = "".
  IF F-provee2 <> "" THEN F-provee2 = "".
  IF F-subfam  <> "" THEN F-subfam  = "".

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
     /*D-Corte:SENSITIVE = NO.*/
     I-CodMon:SENSITIVE = NO.
     T-Igv:SENSITIVE = NO.
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

