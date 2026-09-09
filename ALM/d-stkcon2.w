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

DEFINE TEMP-TABLE T-REPORTE
    FIELD CodCia LIKE almmmatg.codcia
    FIELD CodMat LIKE almmmatg.codmat
    FIELD DesMat LIKE almmmatg.desmat
    FIELD DesMar LIKE almmmatg.desmar
    FIELD UndStk AS CHAR FORMAT 'x(7)' /*LIKE almmmatg.undstk*/
    FIELD StkAct LIKE almmmate.stkact
    FIELD Ventas AS DEC FORMAT '->>>,>>>,>>9.99'
    INDEX Llave01 IS PRIMARY CodCia CodMat ASCENDING
    INDEX Llave02 CodCia DesMat ASCENDING
    INDEX Llave03 CodCia StkAct DESCENDING.

DEFINE VAR F-STKGEN AS DECIMAL NO-UNDO.
DEFINE VAR s-Titulo AS CHAR FORMAT 'x(30)'.

s-Titulo = "STOCK CONSOLIDADO DE ARTICULOS".

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
&Scoped-Define ENABLED-OBJECTS F-CodFam F-SubFam f-CodAlm DesdeC HastaC ~
F-marca1 F-marca2 F-provee1 F-provee2 DesdeF HastaF R-Tipo TipoStk ~
RADIO-SET-Orden x-FchVta-1 x-FchVta-2 Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS F-CodFam F-DesFam F-SubFam F-DesSub ~
f-CodAlm DesdeC HastaC F-marca1 F-marca2 F-provee1 F-provee2 DesdeF HastaF ~
R-Tipo TipoStk RADIO-SET-Orden x-FchVta-1 x-FchVta-2 

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

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Creacion" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE f-CodAlm AS CHARACTER FORMAT "X(256)":U INITIAL "03,03A,03B,04,04A,04B,05,05A,83,83A,83B" 
     LABEL "Almacenes" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .69 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .69 NO-UNDO.

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
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(9)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE x-FchVta-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Ventas desde" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .69 NO-UNDO.

DEFINE VARIABLE x-FchVta-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .69 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Ambos", "",
"Activados", "A",
"Desactivados", "D"
     SIZE 41.43 BY .73 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Orden AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Código", 1,
"Descripción", 2,
"Stock", 3
     SIZE 36 BY .85 NO-UNDO.

DEFINE VARIABLE TipoStk AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Solo Articulos con Stock", 1,
"Todos los Seleccionados", 2
     SIZE 51 BY .85 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodFam AT ROW 1.77 COL 18 COLON-ALIGNED
     F-DesFam AT ROW 1.77 COL 24 COLON-ALIGNED NO-LABEL
     F-SubFam AT ROW 2.54 COL 18 COLON-ALIGNED
     F-DesSub AT ROW 2.54 COL 24 COLON-ALIGNED NO-LABEL
     f-CodAlm AT ROW 3.31 COL 18 COLON-ALIGNED
     DesdeC AT ROW 4.08 COL 18 COLON-ALIGNED
     HastaC AT ROW 4.08 COL 47 COLON-ALIGNED
     F-marca1 AT ROW 4.85 COL 18 COLON-ALIGNED
     F-marca2 AT ROW 4.85 COL 47 COLON-ALIGNED
     F-provee1 AT ROW 5.62 COL 18 COLON-ALIGNED
     F-provee2 AT ROW 5.62 COL 47 COLON-ALIGNED
     DesdeF AT ROW 6.38 COL 18 COLON-ALIGNED
     HastaF AT ROW 6.38 COL 47 COLON-ALIGNED
     R-Tipo AT ROW 7.35 COL 20 NO-LABEL
     TipoStk AT ROW 8.12 COL 20 NO-LABEL
     RADIO-SET-Orden AT ROW 9.08 COL 20 NO-LABEL
     x-FchVta-1 AT ROW 10.15 COL 17 COLON-ALIGNED WIDGET-ID 2
     x-FchVta-2 AT ROW 10.15 COL 34 COLON-ALIGNED WIDGET-ID 6
     Btn_OK AT ROW 11.08 COL 46
     Btn_Cancel AT ROW 11.08 COL 57.57
     Btn_Help AT ROW 11.08 COL 69
     "Ordenado por" VIEW-AS TEXT
          SIZE 13 BY .69 AT ROW 9.08 COL 6
          FONT 1
     "Estado" VIEW-AS TEXT
          SIZE 7.14 BY .69 AT ROW 7.38 COL 11
          FONT 1
     "Criterio de Selección" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     RECT-46 AT ROW 10.96 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 84.72 BY 11.81
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
         TITLE              = "Stock Consolidado"
         HEIGHT             = 11.81
         WIDTH              = 84.72
         MAX-HEIGHT         = 12.35
         MAX-WIDTH          = 84.72
         VIRTUAL-HEIGHT     = 12.35
         VIRTUAL-WIDTH      = 84.72
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
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Stock Consolidado */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Stock Consolidado */
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
  RUN Carga-Temporal.
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


&Scoped-define SELF-NAME f-CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-CodAlm W-Win
ON LEAVE OF f-CodAlm IN FRAME F-Main /* Almacenes */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  DEF VAR i AS INT NO-UNDO.
  DO i = 1 TO NUM-ENTRIES(f-codalm:SCREEN-VALUE):
    FIND almacen WHERE almacen.codcia = s-codcia
        AND almacen.codalm = ENTRY(i, f-codalm:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almacen
    THEN DO:
        MESSAGE "El almacen" ENTRY(i, f-codalm:SCREEN-VALUE) "no esta registrado"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
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
   FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA 
                  AND  AlmSFami.codfam = F-CodFam 
                  AND  AlmSFami.subfam = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
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
DEF VAR i AS INT NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  ASSIGN 
    F-CodFam F-SubFam
    f-CodAlm
    DesdeC HastaC 
    F-marca1 F-marca2
    F-provee1 F-provee2
    DesdeF HastaF 
    R-Tipo
    TipoStk  
    RADIO-SET-Orden
    x-FchVta-1 x-FchVta-2.

  IF HastaC = "" THEN HastaC = "999999".
  IF F-marca2 = "" THEN F-marca2 = "ZZZZZZZZZZZZZ".
  IF F-provee2 = "" THEN F-provee2 = "ZZZZZZZZZZZZZ".
  
  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.
  
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
  DEF VAR f-Salida AS DEC NO-UNDO.
  DEF VAR x-CodDia AS INT INIT 1 NO-UNDO.
  DEF VAR x-CodMes AS INT NO-UNDO.
  DEF VAR x-CodAno AS INT NO-UNDO.
  DEF VAR i AS INT NO-UNDO.
  DEF VAR x-Fecha AS DATE NO-UNDO.

  FOR EACH T-REPORTE:
    DELETE T-REPORTE.
  END.
  FOR EACH almmmatg WHERE almmmatg.codcia = s-codcia
        AND (almmmatg.codmat >= DesdeC
        AND almmmatg.codmat <= HastaC)
        AND Almmmatg.codfam BEGINS F-CodFam 
        AND  Almmmatg.subfam BEGINS F-SubFam 
        AND  (Almmmatg.CodMar >= F-marca1 
        AND   Almmmatg.CodMar <= F-marca2)
        AND  (Almmmatg.CodPr1 >= F-provee1
        AND   Almmmatg.CodPr1 <= F-provee2)
        AND  Almmmatg.TpoArt BEGINS R-Tipo 
        AND  (Almmmatg.FchIng >= DesdeF
        AND   Almmmatg.FchIng <= HastaF)
        NO-LOCK,
        EACH almmmate OF almmmatg WHERE LOOKUP(almmmate.codalm, f-CodAlm) > 0
            NO-LOCK:
    IF Almmmatg.FchCes <> ? THEN NEXT.
    DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
        FORMAT "X(8)" WITH FRAME F-Proceso.
    FIND T-REPORTE WHERE t-reporte.codcia = almmmatg.codcia
        AND t-reporte.codmat = almmmatg.codmat NO-ERROR.
    IF NOT AVAILABLE t-reporte THEN CREATE t-reporte.
    ASSIGN
        t-reporte.codcia = almmmatg.codcia
        t-reporte.codmat = almmmatg.codmat
        t-reporte.desmat = almmmatg.desmat
        t-reporte.desmar = almmmatg.desmar
        t-reporte.undstk = almmmatg.undstk
        t-reporte.stkact = t-reporte.stkact + almmmate.stkact.
  END.
  /* CARGAMOS VENTAS */
  FOR EACH t-reporte:
      DISPLAY t-reporte.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
          FORMAT "X(8)" WITH FRAME F-Proceso.
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
          FOR EACH Evtarti NO-LOCK WHERE Evtarti.CodCia = S-CODCIA
              AND Evtarti.CodDiv = Gn-Divi.Coddiv
              AND Evtarti.Codmat = t-reporte.codmat
              AND (Evtarti.Nrofch >= INTEGER(STRING(YEAR(x-FchVta-1),"9999") + STRING(MONTH(x-FchVta-1),"99"))
              AND Evtarti.Nrofch <= INTEGER(STRING(YEAR(x-FchVta-2),"9999") + STRING(MONTH(x-FchVta-2),"99")) ):
              F-Salida  = 0.
              /*****************Capturando el Mes siguiente *******************/
              IF Evtarti.Codmes < 12 THEN DO:
                ASSIGN
                X-CODMES = Evtarti.Codmes + 1
                X-CODANO = Evtarti.Codano.
              END.
              ELSE DO: 
                ASSIGN
                X-CODMES = 01
                X-CODANO = Evtarti.Codano + 1 .
              END.
              /*********************** Calculo Para Obtener los datos diarios ************/
               DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
                    X-FECHA = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")).
                    IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                        FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) NO-LOCK NO-ERROR.
                        IF AVAILABLE Gn-tcmb THEN DO: 
                         F-Salida  = F-Salida  + Evtarti.CanxDia[I].
                        END.
                    END.
               END.
               t-reporte.ventas = t-reporte.ventas + f-Salida.
          END.
      END.
  END.
  /* *************** */
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
  DISPLAY F-CodFam F-DesFam F-SubFam F-DesSub f-CodAlm DesdeC HastaC F-marca1 
          F-marca2 F-provee1 F-provee2 DesdeF HastaF R-Tipo TipoStk 
          RADIO-SET-Orden x-FchVta-1 x-FchVta-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE F-CodFam F-SubFam f-CodAlm DesdeC HastaC F-marca1 F-marca2 F-provee1 
         F-provee2 DesdeF HastaF R-Tipo TipoStk RADIO-SET-Orden x-FchVta-1 
         x-FchVta-2 Btn_OK Btn_Cancel Btn_Help 
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

  DEFINE FRAME F-REPORTE
    t-reporte.codmat                            COLUMN-LABEL 'CODIGO'        
    t-reporte.desmat                            COLUMN-LABEL 'DESCRIPCION'
    t-reporte.desmar FORMAT "X(13)"             COLUMN-LABEL 'MARCA'
    t-reporte.undstk FORMAT 'x(7)'                           COLUMN-LABEL 'UND!STK'
    t-reporte.stkact FORMAT '->>>,>>>,>>9.999'  COLUMN-LABEL 'STOCK!ALM'
    t-reporte.ventas                            COLUMN-LABEL 'VENTAS'
  WITH WIDTH 160 NO-BOX /* NO-LABELS NO-UNDERLINE*/ STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
     HEADER
     s-nomcia FORMAT 'x(30)'
     s-Titulo AT 40
     "Pagina :" TO 90 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
     "Fecha :" TO 90 TODAY FORMAT "99/99/9999" SKIP
     "Hora :"  TO 90 STRING(TIME,"HH:MM") SKIP
     "Almacenes:" f-CodAlm FORMAT 'x(50)' SKIP
     "Ventas desde el:" x-FchVta-1 "hasta el" x-FchVta-2 SKIP
     IF TipoStk = 1 THEN "Solo materiales con stock" ELSE "Todos los productos" FORMAT 'X(40)' SKIP
/*      "------------------------------------------------------------------------------------------------------" SKIP */
/*      "                                                                               UND              STOCK " SKIP */
/*      "  CODIGO          DESCRIPCION                                   MARCA          STK              ALM   " SKIP */
/*      "------------------------------------------------------------------------------------------------------" SKIP */
  WITH PAGE-TOP WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO /*CENTERED*/ DOWN. 

  FOR EACH T-REPORTE USE-INDEX Llave01:
    IF TipoStk = 1 AND t-reporte.stkact = 0 THEN NEXT.
    VIEW STREAM REPORT FRAME F-HEADER.
    DISPLAY STREAM REPORT
      t-reporte.codmat 
      t-reporte.desmat 
      t-reporte.desmar 
      t-reporte.undstk 
      t-reporte.stkact 
      t-reporte.ventas
      WITH FRAME F-REPORTE.
  END.
  HIDE FRAME F-PROCESO.

/*
  DEFINE VAR F-STKGEN AS DECIMAL NO-UNDO.
  DEFINE VAR F-TOTAL  AS DECIMAL NO-UNDO.
  FOR EACH Almmmate WHERE Almmmate.CodCia = S-CODCIA 
                     AND  Almmmate.CodMat >= DesdeC 
                     AND  Almmmate.CodMat <= HastaC,
           EACH Almmmatg OF Almmmate 
                    WHERE Almmmatg.codfam BEGINS F-CodFam 
                     AND  Almmmatg.subfam BEGINS F-SubFam 
                     AND  (Almmmatg.CodMar >= F-marca1 
                     AND   Almmmatg.CodMar <= F-marca2)
                     AND  (Almmmatg.CodPr1 >= F-provee1
                     AND   Almmmatg.CodPr1 <= F-provee2)
                     AND  Almmmatg.TpoArt BEGINS R-Tipo 
                     AND  (Almmmatg.FchIng >= DesdeF
                     AND   Almmmatg.FchIng <= HastaF)
                    NO-LOCK
                    BREAK BY Almmmate.codcia 
                          BY Almmmatg.CodFam 
                          BY Almmmatg.Subfam 
                          BY Almmmate.Codmat:
      IF Almmmatg.FchCes <> ? THEN NEXT.
      DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(8)" WITH FRAME F-Proceso.
      VIEW STREAM REPORT FRAME F-HEADER.
      IF FIRST-OF(Almmmatg.CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = Almmmate.CodCia 
                        AND  Almtfami.codfam = Almmmatg.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             DISPLAY STREAM REPORT 
                 Almtfami.codfam @ Almmmate.codmat
                 Almtfami.desfam @ Almmmatg.DesMat 
                 WITH FRAME F-REPORTE.
             UNDERLINE STREAM REPORT Almmmatg.DesMat WITH FRAME F-REPORTE.
         END.
      END.
      IF FIRST-OF(Almmmatg.SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = Almmmatg.CodCia 
                        AND  Almsfami.codfam = Almmmatg.CodFam 
                        AND  Almsfami.subfam = Almmmatg.Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             DISPLAY STREAM REPORT 
                 Almsfami.subfam @ Almmmate.codmat
                 AlmSFami.dessub @ Almmmatg.DesMat WITH FRAME F-REPORTE.
             DOWN 1 STREAM REPORT WITH FRAME F-REPORTE.
         END.
      END.
      F-TOTAL = 0.
      FOR EACH T-MATE WHERE T-MATE.codcia = s-codcia 
                       AND  T-MATE.Codmat = Almmmate.codmat 
                      NO-LOCK:
          F-TOTAL = F-TOTAL + Almmmate.stkact.
      END.        
      IF TipoStk = 1 AND F-TOTAL = 0 THEN NEXT.
      F-TOTAL = 0.
      IF FIRST-OF(Almmmate.codmat) THEN DO:
         DISPLAY STREAM REPORT 
            Almmmate.codmat 
            Almmmatg.desmat 
            Almmmatg.desmar
            Almmmatg.undstk 
            WITH FRAME F-REPORTE.
         F-STKGEN = 0.
      END.
      F-STKGEN = F-STKGEN + Almmmate.stkact.
      F-PESALM = Almmmatg.Pesmat * Almmmate.stkact.
      IF LAST-OF(Almmmate.codmat) THEN F-TOTAL = F-STKGEN.
      DISPLAY STREAM REPORT
         Almmmate.codalm
         Almmmate.stkact 
         F-PESALM
         F-TOTAL WHEN F-TOTAL > 0  
         WITH FRAME F-REPORTE.
  END.
  PUT STREAM REPORT "---------------------------------------------------------------------------------------------------------------------------------------------" .
  HIDE FRAME F-PROCESO.
*/

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
  DEFINE FRAME F-REPORTE
    t-reporte.codmat                            COLUMN-LABEL 'CODIGO'        
    t-reporte.desmat                            COLUMN-LABEL 'DESCRIPCION'
    t-reporte.desmar FORMAT "X(13)"             COLUMN-LABEL 'MARCA'
    t-reporte.undstk FORMAT 'x(7)'                           COLUMN-LABEL 'UND!STK'
    t-reporte.stkact FORMAT '->>>,>>>,>>9.999'  COLUMN-LABEL 'STOCK!ALM'
    t-reporte.ventas                            COLUMN-LABEL 'VENTAS'
  WITH WIDTH 160 NO-BOX /* NO-LABELS NO-UNDERLINE*/ STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
     HEADER
     s-nomcia FORMAT 'x(30)'
     s-Titulo AT 40
     "Pagina :" TO 90 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
     "Fecha :" TO 90 TODAY FORMAT "99/99/9999" SKIP
     "Hora :"  TO 90 STRING(TIME,"HH:MM") SKIP
     "Almacenes:" f-CodAlm FORMAT 'x(50)' SKIP
      "Ventas desde el:" x-FchVta-1 "hasta el" x-FchVta-2 SKIP
     IF TipoStk = 1 THEN "Solo materiales con stock" ELSE "Todos los productos" FORMAT 'X(40)' SKIP
/*      "------------------------------------------------------------------------------------------------------" SKIP */
/*      "                                                                               UND              STOCK " SKIP */
/*      "  CODIGO          DESCRIPCION                                   MARCA          STK              ALM   " SKIP */
/*      "------------------------------------------------------------------------------------------------------" SKIP */
  WITH PAGE-TOP WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO /*CENTERED*/ DOWN. 

  FOR EACH T-REPORTE USE-INDEX Llave02:
    IF TipoStk = 1 AND t-reporte.stkact = 0 THEN NEXT.
    VIEW STREAM REPORT FRAME F-HEADER.
    DISPLAY STREAM REPORT
        t-reporte.codmat 
        t-reporte.desmat 
        t-reporte.desmar 
        t-reporte.undstk 
        t-reporte.stkact 
        t-reporte.ventas
      WITH FRAME F-REPORTE.
  END.

  PUT STREAM REPORT "------------------------------------------------------------------------------------------------------".
  HIDE FRAME F-PROCESO.

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
    t-reporte.codmat                            COLUMN-LABEL 'CODIGO'        
    t-reporte.desmat                            COLUMN-LABEL 'DESCRIPCION'
    t-reporte.desmar FORMAT "X(13)"             COLUMN-LABEL 'MARCA'
    t-reporte.undstk FORMAT 'x(7)'                           COLUMN-LABEL 'UND!STK'
    t-reporte.stkact FORMAT '->>>,>>>,>>9.999'  COLUMN-LABEL 'STOCK!ALM'
    t-reporte.ventas                            COLUMN-LABEL 'VENTAS'
  WITH WIDTH 160 NO-BOX /* NO-LABELS NO-UNDERLINE*/ STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
     HEADER
     s-nomcia FORMAT 'x(30)'
     s-Titulo AT 40
     "Pagina :" TO 90 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
     "Fecha :" TO 90 TODAY FORMAT "99/99/9999" SKIP
     "Hora :"  TO 90 STRING(TIME,"HH:MM") SKIP
     "Almacenes:" f-CodAlm FORMAT 'x(50)' SKIP
      "Ventas desde el:" x-FchVta-1 "hasta el" x-FchVta-2 SKIP
      IF TipoStk = 1 THEN "Solo materiales con stock" ELSE "Todos los productos" FORMAT 'X(40)' SKIP
 /*      "------------------------------------------------------------------------------------------------------" SKIP */
 /*      "                                                                               UND              STOCK " SKIP */
 /*      "  CODIGO          DESCRIPCION                                   MARCA          STK              ALM   " SKIP */
 /*      "------------------------------------------------------------------------------------------------------" SKIP */
   WITH PAGE-TOP WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO /*CENTERED*/ DOWN. 

  FOR EACH T-REPORTE USE-INDEX Llave03:
    IF TipoStk = 1 AND t-reporte.stkact = 0 THEN NEXT.
    VIEW STREAM REPORT FRAME F-HEADER.
    DISPLAY STREAM REPORT
        t-reporte.codmat 
        t-reporte.desmat 
        t-reporte.desmar 
        t-reporte.undstk 
        t-reporte.stkact 
        t-reporte.ventas
      WITH FRAME F-REPORTE.
  END.
  PUT STREAM REPORT "------------------------------------------------------------------------------------------------------".
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
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3}.
        CASE RADIO-SET-Orden:
            WHEN 1 THEN RUN Formato.
            WHEN 2 THEN RUN Formato-2.
            WHEN 3 THEN RUN Formato-3.
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
  ASSIGN DesdeC HastaC TipoStk F-CodFam F-SubFam DesdeF HastaF F-marca1 F-marca2 F-provee1 F-provee2 R-Tipo.
  
  IF HastaC <> "" THEN HastaC = "".
  IF F-marca2 <> "" THEN F-marca2 = "".
  IF F-provee2 <> "" THEN F-provee2 = "".
  IF DesdeF <> ?  THEN DesdeF = ?.
  IF HastaF <> ?  THEN HastaF = ?.
  
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
  ASSIGN
      x-FchVta-1 = TODAY - DAY(TODAY) + 1
      x-FchVta-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     R-Tipo = ''.
     DISPLAY R-Tipo.
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

