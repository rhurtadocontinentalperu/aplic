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

DEF TEMP-TABLE T-MATG LIKE ALMMMATG
    FIELD StkAlm AS DEC
    FIELD StkAlm03  AS DEC
    FIELD StkAlm03A AS DEC
    FIELD StkAlm04  AS DEC
    FIELD StkAlm04A AS DEC
    FIELD StkAlm05  AS DEC
    FIELD StkAlm05A AS DEC
    FIELD StkAlm15  AS DEC
    FIELD StkAlm30  AS DEC
    FIELD StkAlm19  AS DEC
    FIELD StkAlmOtr AS DEC
    FIELD PesAlm AS DEC
    FIELD PreCto AS DEC
    FIELD ValCto AS DEC
    FIELD NomPro AS CHAR
    INDEX Llave01 AS PRIMARY CodCia CodPr1 CodMat.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-CodFam R-Tipo FILL-IN-SubFam DesdeC ~
HastaC F-marca1 F-marca2 F-provee1 F-provee2 TipoStk Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodFam R-Tipo FILL-IN-SubFam ~
DesdeC HastaC F-marca1 F-marca2 D-Corte F-provee1 F-provee2 TipoStk 

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
     SIZE 13 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 13 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE D-Corte AS DATE FORMAT "99/99/9999":U 
     LABEL "Al" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .81 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-marca1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-marca2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-provee1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-provee2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

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

DEFINE VARIABLE R-Tipo AS CHARACTER INITIAL "A" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", "",
"Activados", "A",
"Desactivados", "D"
     SIZE 12.86 BY 2.31 NO-UNDO.

DEFINE VARIABLE TipoStk AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Solo Articulos con Stock", 1,
"Todos los Seleccionados", 2
     SIZE 43 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodFam AT ROW 1.38 COL 20 COLON-ALIGNED
     R-Tipo AT ROW 1.38 COL 63 NO-LABEL
     FILL-IN-SubFam AT ROW 2.35 COL 20 COLON-ALIGNED
     DesdeC AT ROW 3.31 COL 20 COLON-ALIGNED
     HastaC AT ROW 3.31 COL 35 COLON-ALIGNED
     F-marca1 AT ROW 4.27 COL 20 COLON-ALIGNED
     F-marca2 AT ROW 4.27 COL 35 COLON-ALIGNED
     D-Corte AT ROW 4.27 COL 61 COLON-ALIGNED
     F-provee1 AT ROW 5.23 COL 20 COLON-ALIGNED
     F-provee2 AT ROW 5.23 COL 35 COLON-ALIGNED
     TipoStk AT ROW 6.19 COL 22 NO-LABEL
     Btn_OK AT ROW 7.54 COL 6
     Btn_Cancel AT ROW 7.54 COL 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 9
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
         TITLE              = "Existencias por Proveedor"
         HEIGHT             = 8.88
         WIDTH              = 80
         MAX-HEIGHT         = 21.27
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.27
         VIRTUAL-WIDTH      = 114.29
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN D-Corte IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Existencias por Proveedor */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Existencias por Proveedor */
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
  ASSIGN D-Corte DesdeC 
         HastaC TipoStk R-Tipo
         F-marca1 F-marca2 F-provee1 F-provee2 
         FILL-IN-CodFam FILL-IN-SubFam.
         
  
  IF HastaC <> "" THEN S-SUBTIT = "Materiales del " + DesdeC + " al " + HastaC .
  ELSE S-SUBTIT = "".

  IF HastaC = "" THEN HastaC = "999999999".
  IF F-marca2 = "" THEN F-marca2 = "ZZZZZZZZZZZZZ".
  IF F-provee2 = "" THEN F-provee2 = "ZZZZZZZZZZZZZ".
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
  DEF VAR F-StkAlm03  AS DEC NO-UNDO.
  DEF VAR F-StkAlm03A AS DEC NO-UNDO.
  DEF VAR F-StkAlm04  AS DEC NO-UNDO.
  DEF VAR F-StkAlm04A AS DEC NO-UNDO.
  DEF VAR F-StkAlm05  AS DEC NO-UNDO.
  DEF VAR F-StkAlm05A AS DEC NO-UNDO.
  DEF VAR F-StkAlm19  AS DEC NO-UNDO.
  DEF VAR F-StkAlm15  AS DEC NO-UNDO.
  DEF VAR F-StkAlm30  AS DEC NO-UNDO.
  DEF VAR F-StkAlmOtr AS DEC NO-UNDO.

  FOR EACH T-MATG:
    DELETE T-MATG.
  END.

  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
        AND (Almmmatg.CodMar >= F-marca1 
        AND  Almmmatg.CodMar <= F-marca2)
        AND (Almmmatg.CodPr1 >= F-provee1
        AND  Almmmatg.CodPr1 <= F-provee2)
        AND Almmmatg.TpoArt BEGINS R-Tipo 
        AND almmmatg.codfam BEGINS FILL-IN-CodFam
        AND almmmatg.subfam BEGINS FILL-IN-SubFam
        AND almmmatg.codmat >= DesdeC
        AND almmmatg.codmat <= HastaC
        AND almmmatg.fchces = ?:
    DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
            FORMAT "X(11)" WITH FRAME F-Proceso.
    ASSIGN
        F-STKALM    = 0
        F-StkAlm03  = 0
        F-StkAlm03A = 0
        F-StkAlm04  = 0
        F-StkAlm04A = 0
        F-StkAlm05  = 0
        F-StkAlm05A = 0
        F-StkAlm19  = 0
        F-StkAlm15  = 0
        F-StkAlm30  = 0
        F-StkAlmOtr = 0.
    FOR EACH Almmmate OF Almmmatg NO-LOCK :
        CASE Almmmate.codalm:
            WHEN '03'  THEN F-StkAlm03  = F-StkAlm03  + AlmmMate.stkact.
            WHEN '03A' THEN F-StkAlm03A = F-StkAlm03A + AlmmMate.stkact.
            WHEN '04'  THEN F-StkAlm04  = F-StkAlm04  + AlmmMate.stkact.
            WHEN '04A' THEN F-StkAlm04A = F-StkAlm04A + AlmmMate.stkact.
            WHEN '05'  THEN F-StkAlm05  = F-StkAlm05  + AlmmMate.stkact.
            WHEN '05A' THEN F-StkAlm05A = F-StkAlm05A + AlmmMate.stkact.
            WHEN '15'  THEN F-StkAlm15  = F-StkAlm15  + AlmmMate.stkact.
            WHEN '30'  THEN F-StkAlm30  = F-StkAlm30  + AlmmMate.stkact.
/*            WHEN '19'  THEN F-StkAlm19  = F-StkAlm19  + AlmmMate.stkact.*/
            /*OTHERWISE F-StkAlmOtr = F-StkAlmOtr + AlmmMate.stkact.*/
        END CASE.
    END.
    /* OJO =>> SOLO LO QUE SE VA A IMPRIMIR */
    F-StkAlm = F-StkAlm03 + F-StkAlm03A + F-StkAlm04 + F-StkAlm04A +
                F-StkAlm05 + F-StkAlm05A +
                F-StkAlm15 + F-StkAlmOtr + F-StkAlm19 +
                F-StkAlm30.
    IF TipoStk = 1 AND F-STKALM <= 0 THEN NEXT.
    X-NOMPRO = "SIN PROVEEDOR".
    FIND Gn-Prov WHERE 
        Gn-Prov.Codcia = pv-codcia AND
        Gn-Prov.CodPro = Almmmatg.CodPr1 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-Prov 
    THEN x-nompro = Gn-Prov.NomPro.
    /* GRABAMOS LA INFORMACION */
    CREATE T-MATG.
    BUFFER-COPY ALMMMATG TO T-MATG
        ASSIGN T-MATG.StkAlm = F-STKALM
               T-MATG.StkAlm03  = F-StkAlm03
               T-MATG.StkAlm03A = F-StkAlm03A
               T-MATG.StkAlm04  = F-StkAlm04
               T-MATG.StkAlm04A = F-StkAlm04A
               T-MATG.StkAlm05  = F-StkAlm05
               T-MATG.StkAlm05A = F-StkAlm05A
               T-MATG.StkAlm15  = F-StkAlm15
               T-MATG.StkAlm30  = F-StkAlm30
               T-MATG.StkAlmOtr = F-StkAlmOtr
               T-MATG.StkAlm19  = F-StkAlm19
               T-MATG.NomPro = X-NOMPRO.
  END.

  HIDE FRAME F-PROCESO.

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
  DISPLAY FILL-IN-CodFam R-Tipo FILL-IN-SubFam DesdeC HastaC F-marca1 F-marca2 
          D-Corte F-provee1 F-provee2 TipoStk 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-CodFam R-Tipo FILL-IN-SubFam DesdeC HastaC F-marca1 F-marca2 
         F-provee1 F-provee2 TipoStk Btn_OK Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2 W-Win 
PROCEDURE Formato2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Sin el almacen 83 ni 83b y costo unitario
------------------------------------------------------------------------------*/
  DEF VAR x-CtoLis AS DEC.
  DEF VAR x-SubTit AS CHAR FORMAT 'x(50)'.
  
  
  DEFINE FRAME F-REPORTE
         T-MATG.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)"
         T-MATG.DesMat COLUMN-LABEL "Descripcion" FORMAT "X(42)"
         T-MATG.DesMar FORMAT "X(11)"
         T-MATG.UndBas COLUMN-LABEL "Unid"  FORMAT 'x(7)'
         T-MATG.STKALM03  FORMAT "->>,>>9.99"
         T-MATG.STKALM03A FORMAT "->>,>>9.99"
         T-MATG.STKALM04  FORMAT "->>,>>9.99"
         T-MATG.STKALM04A FORMAT "->>,>>9.99"
         T-MATG.STKALM05  FORMAT "->>,>>9.99"
         T-MATG.STKALM05A FORMAT "->>,>>9.99"
         T-MATG.STKALM15  FORMAT "->>,>>9.99"
         T-MATG.STKALM30  FORMAT "->>,>>9.99"
         T-MATG.STKALM    FORMAT "->>>,>>9.99"
         T-MATG.Catcon[1] 
         T-MATG.TipArt
         HEADER
         S-NOMCIA FORMAT "X(50)" SKIP
         "EXISTENCIAS POR ALMACENES LIMA" AT 40  
         "Pagina :" TO 136 PAGE-NUMBER(REPORT) TO 156 FORMAT "ZZZZZ9" SKIP
         "Fecha :" TO 136 TODAY TO 156 FORMAT "99/99/9999" SKIP
         S-DESALM AT 40 FORMAT "X(30)"
         "Hora :" TO 136 STRING(TIME,"HH:MM:SS") TO 156 SKIP(1)
         S-SUBTIT        "Moneda : " TO 70 C-MONEDA SKIP
         x-SubTit SKIP
         "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                                                                                                                            " SKIP
         " Codigo   Descripcion                               MARCA   Unid      Alm.03    Alm.03A     Alm.04    Alm.04A     Alm.05    Alm.05A     Alm.15     Alm.30       Total  CC T " SKIP
         "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*                 1         2         3         4         5         6         7         8         9         0         1         2
          12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
          123456 123456789012345678901234567890123456789012 1234567890 12345 ->>,>>9.99 ->>,>>9.99 ->>,>>9.99 ->>,>>9.99 ->>,>>9.99 ->>,>>9.99 ->>,>>9.99 ->>,>>9.99 ->>>,>>9.99 12 12 >>,>>9.9999
*/


  WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
  
  FOR EACH T-MATG BREAK BY T-MATG.codcia BY T-MATG.CodPr1 BY T-MATG.DesMat:
    IF FIRST-OF(T-MATG.CodPr1) THEN DO:
        DISPLAY STREAM REPORT 
            T-MATG.CodPr1 @ T-MATG.desmar
            T-MATG.NomPro @ T-MATG.DesMat WITH FRAME F-REPORTE.
        UNDERLINE STREAM REPORT T-MATG.DesMat WITH FRAME F-REPORTE.
    END.
    DISPLAY STREAM REPORT 
        T-MATG.codmat 
        T-MATG.DesMat 
        T-MATG.DesMar 
        T-MATG.UndBas
        T-MATG.STKALM03
        T-MATG.STKALM03A  
        T-MATG.STKALM04
        T-MATG.STKALM04A  
        T-MATG.STKALM05
        T-MATG.STKALM05A  
        T-MATG.STKALM15
        T-MATG.STKALM30
        T-MATG.STKALM  
        T-MATG.Catcon[1] 
        T-MATG.TipArt
        WITH FRAME F-REPORTE.
    ACCUMULATE T-MATG.STKALM (TOTAL).
    IF LAST-OF(T-MATG.CodPr1) THEN DO:
        UNDERLINE STREAM REPORT T-MATG.STKALM 
            WITH FRAME F-REPORTE.
        DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
    END.
    IF LAST-OF(T-MATG.Codcia) THEN DO:
        DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
        UNDERLINE STREAM REPORT T-MATG.STKALM 
            WITH FRAME F-REPORTE.
    END.
  END.

END PROCEDURE.

/* RHC BLOQUEADO EL 08.04.05 **********************************************
  DEFINE FRAME F-REPORTE
         T-MATG.codmat COLUMN-LABEL "Codigo" FORMAT "X(9)"
         T-MATG.DesMat COLUMN-LABEL "Descripcion" FORMAT "X(44)"
         T-MATG.DesMar FORMAT "X(11)"
         T-MATG.UndStk COLUMN-LABEL "Unid"
         T-MATG.STKALM03  FORMAT "->,>>9.99"
         T-MATG.STKALM04  FORMAT "->,>>9.99"
         T-MATG.STKALM05  FORMAT "->,>>9.99"
         T-MATG.STKALM83  FORMAT "->,>>9.99"
         T-MATG.STKALM03A FORMAT "->,>>9.99"
         T-MATG.STKALM04A FORMAT "->,>>9.99"
         T-MATG.STKALM05A FORMAT "->,>>9.99"
         T-MATG.STKALM83B FORMAT "->,>>9.99"
         T-MATG.STKALM48  FORMAT "->,>>9.99"
         T-MATG.STKALM    FORMAT "->>>,>>9.99"
         T-MATG.Catcon[1] 
         T-MATG.TipArt
         HEADER
         S-NOMCIA FORMAT "X(50)" SKIP
         "EXISTENCIAS POR ALMACENES LIMA" AT 40  
         "Pagina :" TO 136 PAGE-NUMBER(REPORT) TO 156 FORMAT "ZZZZZ9" SKIP
         "Fecha :" TO 136 TODAY TO 156 FORMAT "99/99/9999" SKIP
         S-DESALM AT 40 FORMAT "X(30)"
         "Hora :" TO 136 STRING(TIME,"HH:MM:SS") TO 156 SKIP(1)
         S-SUBTIT        "Moneda : " TO 70 C-MONEDA SKIP
         "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                                                                                                                                  " SKIP
         "    Codigo   Descripcion                                   MARCA   Unid     Alm.03    Alm.04    Alm.05    Alm.83   Alm.03A   Alm.04A   Alm.05A   Alm.83B    Alm.48     Total  CC T" SKIP
         "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*
                   1         2         3         4         5         6         7         8         9         0         1         2
          12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
          123456789 123456789012345678901234567890123456789012345 1234567890 12345 ->,>>9.99 ->,>>9.99 ->,>>9.99 ->,>>9.99 ->>9.99 ->>9.99 ->>9.99 ->>9.99 ->>>,>>9.99 12 12
*/


  WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
  
  FOR EACH T-MATG BREAK BY T-MATG.codcia BY T-MATG.CodPr1 BY T-MATG.DesMat:
    IF FIRST-OF(T-MATG.CodPr1) THEN DO:
        DISPLAY STREAM REPORT 
            T-MATG.CodPr1 @ T-MATG.desmar
            T-MATG.NomPro @ T-MATG.DesMat WITH FRAME F-REPORTE.
        UNDERLINE STREAM REPORT T-MATG.DesMat WITH FRAME F-REPORTE.
    END.
     
    DISPLAY STREAM REPORT 
        T-MATG.codmat 
        T-MATG.DesMat 
        T-MATG.DesMar 
        T-MATG.UndStk 
        T-MATG.STKALM03
        T-MATG.STKALM03A  
        T-MATG.STKALM04
        T-MATG.STKALM04A  
        T-MATG.STKALM05
        T-MATG.STKALM05A  
        T-MATG.STKALM83
        T-MATG.STKALM83B 
        T-MATG.STKALM48 
        T-MATG.STKALM  
        T-MATG.Catcon[1] 
        T-MATG.TipArt
        WITH FRAME F-REPORTE.
    ACCUMULATE T-MATG.STKALM (TOTAL).
    IF LAST-OF(T-MATG.CodPr1) THEN DO:
        UNDERLINE STREAM REPORT T-MATG.STKALM 
            WITH FRAME F-REPORTE.
        DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
    END.
    IF LAST-OF(T-MATG.Codcia) THEN DO:
        DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
        UNDERLINE STREAM REPORT T-MATG.STKALM 
            WITH FRAME F-REPORTE.
    END.
***************************************************************************** */

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
    ENABLE ALL EXCEPT D-Corte.
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
        RUN Formato2.
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
         HastaC TipoStk R-Tipo
         F-marca1 F-marca2 F-provee1 F-provee2 .
  
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
     D-Corte = TODAY.
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
        WHEN "FILL-IN-SubFam" THEN input-var-1 = FILL-IN-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
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

