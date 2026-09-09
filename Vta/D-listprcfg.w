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
DEFINE VAR F-SPeso   AS DECIMAL FORMAT "(>,>>>,>>9.99)" NO-UNDO.

DEFINE BUFFER DMOV FOR Almdmov. 

DEFINE VAR I-NROITM  AS INTEGER.

DEFINE TEMP-TABLE  tmp-report LIKE w-report.


DEFINE VAR T-Ingreso AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR T-Salida  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.

/*
DEFINE VARIABLE F-PREUSSA AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSB AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSC AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSD AS DECIMAL NO-UNDO.

DEFINE VARIABLE F-PRESOLA AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLB AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLC AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLD AS DECIMAL NO-UNDO.
*/
DEFINE VARIABLE mensaje AS CHARACTER.

DEFINE VARIABLE TITU_PRE1 AS CHAR .
DEFINE VARIABLE TITU_PRE2 AS CHAR .
DEFINE VARIABLE TITU_PRE3 AS CHAR .
DEFINE VARIABLE TITU_PRE4 AS CHAR .

DEFINE TEMP-TABLE  tempo 
       FIELD Codmat LIKE Almmmatg.CodMat
       FIELD DesMat LIKE Almmmatg.DesMat
       FIELD DesMar LIKE Almmmatg.DesMar
       FIELD CodFam LIKE Almmmatg.CodFam
       FIELD SubFam LIKE Almmmatg.SubFam
       FIELD CodMar LIKE Almmmatg.CodMar
       FIELD UndBas LIKE Almmmatg.UndBas
       FIELD MonVta LIKE Almmmatg.MonVta
       FIELD F-PRESOLA AS DECIMAL 
       FIELD F-PREUSSA AS DECIMAL 
       FIELD UndA   LIKE Almmmatg.UndA
       FIELD F-PRESOLB AS DECIMAL 
       FIELD F-PREUSSB AS DECIMAL 
       FIELD UndB   LIKE Almmmatg.UndA
       FIELD F-PRESOLC AS DECIMAL 
       FIELD F-PREUSSC AS DECIMAL 
       FIELD UndC   LIKE Almmmatg.UndA
       FIELD F-PRESOLD AS DECIMAL 
       FIELD F-PREUSSD AS DECIMAL 
       FIELD UndD   LIKE Almmmatg.UndA .

DEFINE VAR X-PREA AS DECI INIT 0.
DEFINE VAR X-PREB AS DECI INIT 0.
DEFINE VAR X-PREC AS DECI INIT 0.
DEFINE VAR X-PRED AS DECI INIT 0.
DEFINE VAR MaxCat AS DECI INIT 0.
DEFINE VAR MaxVta AS DECI INIT 0.
DEFINE VAR F-DSCTOS AS DECI INIT 0.
DEFINE VAR S-TPOCMB AS DECI INIT 0.

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
&Scoped-Define ENABLED-OBJECTS F-CodFam F-SubFam DesdeC HastaC R-Tipo ~
nCodMon c-tipo1 c-mos1 f-cate1 f-condi1 c-tipo2 c-mos2 f-cate2 f-condi2 ~
c-tipo3 c-mos3 f-cate3 f-condi3 c-tipo4 c-mos4 f-cate4 f-condi4 Btn_OK ~
Btn_Cancel Btn_Help RECT-57 RECT-58 
&Scoped-Define DISPLAYED-OBJECTS x-mensaje F-CodFam F-DesFam F-SubFam ~
F-DesSub DesdeC HastaC R-Tipo nCodMon c-tipo1 c-mos1 f-cate1 f-condi1 ~
c-tipo2 c-mos2 f-cate2 f-condi2 c-tipo3 c-mos3 f-cate3 f-condi3 c-tipo4 ~
c-mos4 f-cate4 f-condi4 

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

DEFINE VARIABLE c-mos1 AS CHARACTER FORMAT "X(256)":U INITIAL "UndA" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "UndA","UndB","UndC","Credito" 
     DROP-DOWN-LIST
     SIZE 7.57 BY .81 NO-UNDO.

DEFINE VARIABLE c-mos2 AS CHARACTER FORMAT "X(256)":U INITIAL "UndB" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "UndA","UndB","UndC","Credito" 
     DROP-DOWN-LIST
     SIZE 7.57 BY .81 NO-UNDO.

DEFINE VARIABLE c-mos3 AS CHARACTER FORMAT "X(256)":U INITIAL "UndC" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "UndA","UndB","UndC","Credito" 
     DROP-DOWN-LIST
     SIZE 7.57 BY .81 NO-UNDO.

DEFINE VARIABLE c-mos4 AS CHARACTER FORMAT "X(256)":U INITIAL "Credito" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "UndA","UndB","UndC","Credito" 
     DROP-DOWN-LIST
     SIZE 7.57 BY .81 NO-UNDO.

DEFINE VARIABLE c-tipo1 AS CHARACTER FORMAT "X(256)":U INITIAL "Mostrador" 
     LABEL "Columna 1" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Mostrador","Oficina" 
     DROP-DOWN-LIST
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE c-tipo2 AS CHARACTER FORMAT "X(256)":U INITIAL "Mostrador" 
     LABEL "Columna 2" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Mostrador","Oficina" 
     DROP-DOWN-LIST
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE c-tipo3 AS CHARACTER FORMAT "X(256)":U INITIAL "Mostrador" 
     LABEL "Columna 3" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Mostrador","Oficina" 
     DROP-DOWN-LIST
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE c-tipo4 AS CHARACTER FORMAT "X(256)":U INITIAL "Mostrador" 
     LABEL "Columna 4" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Mostrador","Oficina" 
     DROP-DOWN-LIST
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-cate1 AS CHARACTER FORMAT "X":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81 NO-UNDO.

DEFINE VARIABLE f-cate2 AS CHARACTER FORMAT "X":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81 NO-UNDO.

DEFINE VARIABLE f-cate3 AS CHARACTER FORMAT "X":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81 NO-UNDO.

DEFINE VARIABLE f-cate4 AS CHARACTER FORMAT "X":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE f-condi1 AS CHARACTER FORMAT "XXX":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE f-condi2 AS CHARACTER FORMAT "XXX":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE f-condi3 AS CHARACTER FORMAT "XXX":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE f-condi4 AS CHARACTER FORMAT "XXX":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.14 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.14 BY .69 NO-UNDO.

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
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2,
"Ambos", 3
     SIZE 11.57 BY 1.58 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Activados", "A",
"Desactivados", "D",
"Ambos", ""
     SIZE 12.72 BY 1.73 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.81
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.86 BY 8.85.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43.86 BY 6.15.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-mensaje AT ROW 10.42 COL 2.86 NO-LABEL WIDGET-ID 2
     F-CodFam AT ROW 2 COL 7.72 COLON-ALIGNED
     F-DesFam AT ROW 2 COL 14 COLON-ALIGNED NO-LABEL
     F-SubFam AT ROW 2.77 COL 7.72 COLON-ALIGNED
     F-DesSub AT ROW 2.77 COL 14 COLON-ALIGNED NO-LABEL
     DesdeC AT ROW 3.73 COL 7.72 COLON-ALIGNED
     HastaC AT ROW 3.69 COL 22.86 COLON-ALIGNED
     R-Tipo AT ROW 5.12 COL 11 NO-LABEL
     nCodMon AT ROW 7.23 COL 11.43 NO-LABEL
     c-tipo1 AT ROW 5.73 COL 43.29 COLON-ALIGNED
     c-mos1 AT ROW 5.69 COL 53.86 COLON-ALIGNED NO-LABEL
     f-cate1 AT ROW 5.73 COL 61.72 COLON-ALIGNED NO-LABEL
     f-condi1 AT ROW 5.69 COL 68.72 COLON-ALIGNED NO-LABEL
     c-tipo2 AT ROW 6.81 COL 43.29 COLON-ALIGNED
     c-mos2 AT ROW 6.77 COL 54 COLON-ALIGNED NO-LABEL
     f-cate2 AT ROW 6.73 COL 61.72 COLON-ALIGNED NO-LABEL
     f-condi2 AT ROW 6.81 COL 68.72 COLON-ALIGNED NO-LABEL
     c-tipo3 AT ROW 7.81 COL 43.29 COLON-ALIGNED
     c-mos3 AT ROW 7.85 COL 54 COLON-ALIGNED NO-LABEL
     f-cate3 AT ROW 7.81 COL 61.72 COLON-ALIGNED NO-LABEL
     f-condi3 AT ROW 7.92 COL 68.72 COLON-ALIGNED NO-LABEL
     c-tipo4 AT ROW 8.88 COL 43.29 COLON-ALIGNED
     c-mos4 AT ROW 8.88 COL 54 COLON-ALIGNED NO-LABEL
     f-cate4 AT ROW 8.88 COL 61.72 COLON-ALIGNED NO-LABEL
     f-condi4 AT ROW 8.88 COL 68.72 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 10.35 COL 47.43
     Btn_Cancel AT ROW 10.35 COL 58.72
     Btn_Help AT ROW 10.35 COL 70.14
     "Cond.Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 5.04 COL 70.29
     "Moneda" VIEW-AS TEXT
          SIZE 6.86 BY .58 AT ROW 7.77 COL 3.43
          FONT 6
     "Estado" VIEW-AS TEXT
          SIZE 6.86 BY .69 AT ROW 5.69 COL 3.29
          FONT 1
     "Criterio de Selección" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     "Configurando Presentacion" VIEW-AS TEXT
          SIZE 30.29 BY .92 AT ROW 3.96 COL 44.14
          FONT 0
     "Categoria" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 5.04 COL 62.14
     RECT-46 AT ROW 10.19 COL 1.72
     RECT-57 AT ROW 1.27 COL 1.86
     RECT-58 AT ROW 3.81 COL 36.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.72 BY 11.12
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
         HEIGHT             = 11.12
         WIDTH              = 81.72
         MAX-HEIGHT         = 11.12
         MAX-WIDTH          = 81.72
         VIRTUAL-HEIGHT     = 11.12
         VIRTUAL-WIDTH      = 81.72
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
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
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
  IF C-TIPO1 = "Oficina" THEN DO:
   IF F-CATE1 = "" OR F-CONDI1 = "" THEN DO:
    MESSAGE "PARAMETROS INCOMPLETOS PARA LISTA DE PRECIOS OFICINA....VERIFIQUE"  SKIP
             "CONFIGURACION ERRADA PARA COLUMNA 1 "  VIEW-AS ALERT-BOX ERROR. 
    RETURN NO-APPLY .   
   END.
  
   FIND ClfClie WHERE ClfClie.Categoria = F-CATE1  NO-LOCK NO-ERROR.
   IF NOT AVAIL ClfClie THEN DO:
    MESSAGE "CATEGORIA NO EXISTE PARA LISTA DE PRECIOS OFICINA....VERIFIQUE"  SKIP
            "CONFIGURACION ERRADA PARA COLUMNA 1 " VIEW-AS ALERT-BOX ERROR. 
    RETURN NO-APPLY .   
   END.
   
   FIND Gn-Convt WHERE Gn-Convt.Codig = F-CONDI1  NO-LOCK NO-ERROR.
   IF NOT AVAIL Gn-Convt THEN DO:
    MESSAGE "CONDICION DE VENTA NO EXISTE PARA LISTA DE PRECIOS OFICINA....VERIFIQUE"  SKIP
            "CONFIGURACION ERRADA PARA COLUMNA 1 " VIEW-AS ALERT-BOX ERROR. 
    RETURN NO-APPLY .   
   END.
   Titu_Pre1 = "OFI-" + f-cate1 + f-condi1.
  END.

  IF C-TIPO2 = "Oficina" THEN DO:
   IF F-CATE2 = "" OR F-CONDI2 = "" THEN DO:
    MESSAGE "PARAMETROS INCOMPLETOS PARA LISTA DE PRECIOS OFICINA....VERIFIQUE"  SKIP
             "CONFIGURACION ERRADA PARA COLUMNA 2 "  VIEW-AS ALERT-BOX ERROR. 
    RETURN NO-APPLY .   
   END.
  
   FIND ClfClie WHERE ClfClie.Categoria = F-CATE2  NO-LOCK NO-ERROR.
   IF NOT AVAIL ClfClie THEN DO:
    MESSAGE "CATEGORIA NO EXISTE PARA LISTA DE PRECIOS OFICINA....VERIFIQUE"  SKIP
            "CONFIGURACION ERRADA PARA COLUMNA 2 " VIEW-AS ALERT-BOX ERROR. 
    RETURN NO-APPLY .   
   END.
   
   FIND Gn-Convt WHERE Gn-Convt.Codig = F-CONDI2 NO-LOCK NO-ERROR.
   IF NOT AVAIL Gn-Convt THEN DO:
    MESSAGE "CONDICION DE VENTA NO EXISTE PARA LISTA DE PRECIOS OFICINA....VERIFIQUE"  SKIP
            "CONFIGURACION ERRADA PARA COLUMNA 2 " VIEW-AS ALERT-BOX ERROR. 
    RETURN NO-APPLY .   
   END.
   Titu_Pre2 = "OFI-" + f-cate2 + f-condi2.

  END.


  IF C-TIPO3 = "Oficina" THEN DO:
   IF F-CATE3 = "" OR F-CONDI3 = "" THEN DO:
    MESSAGE "PARAMETROS INCOMPLETOS PARA LISTA DE PRECIOS OFICINA....VERIFIQUE"  SKIP
             "CONFIGURACION ERRADA PARA COLUMNA 3 "  VIEW-AS ALERT-BOX ERROR. 
    RETURN NO-APPLY .   
   END.
  
   FIND ClfClie WHERE ClfClie.Categoria = F-CATE3  NO-LOCK NO-ERROR.
   IF NOT AVAIL ClfClie THEN DO:
    MESSAGE "CATEGORIA NO EXISTE PARA LISTA DE PRECIOS OFICINA....VERIFIQUE"  SKIP
            "CONFIGURACION ERRADA PARA COLUMNA 3 " VIEW-AS ALERT-BOX ERROR. 
    RETURN NO-APPLY .   
   END.
   
   FIND Gn-Convt WHERE Gn-Convt.Codig = F-CONDI3  NO-LOCK NO-ERROR.
   IF NOT AVAIL Gn-Convt THEN DO:
    MESSAGE "CONDICION DE VENTA NO EXISTE PARA LISTA DE PRECIOS OFICINA....VERIFIQUE"  SKIP
            "CONFIGURACION ERRADA PARA COLUMNA 3 " VIEW-AS ALERT-BOX ERROR. 
    RETURN NO-APPLY .   
   END.
   Titu_Pre3 = "OFI-" + f-cate3 + f-condi3.

  END.


  IF C-TIPO4 = "Oficina" THEN DO:
   IF F-CATE4 = "" OR F-CONDI4 = "" THEN DO:
    MESSAGE "PARAMETROS INCOMPLETOS PARA LISTA DE PRECIOS OFICINA....VERIFIQUE"  SKIP
             "CONFIGURACION ERRADA PARA COLUMNA 4 "  VIEW-AS ALERT-BOX ERROR. 
    RETURN NO-APPLY .   
   END.
  
   FIND ClfClie WHERE ClfClie.Categoria = F-CATE4  NO-LOCK NO-ERROR.
   IF NOT AVAIL ClfClie THEN DO:
    MESSAGE "CATEGORIA NO EXISTE PARA LISTA DE PRECIOS OFICINA....VERIFIQUE"  SKIP
            "CONFIGURACION ERRADA PARA COLUMNA 4 " VIEW-AS ALERT-BOX ERROR. 
    RETURN NO-APPLY .   
   END.
   
   FIND Gn-Convt WHERE Gn-Convt.Codig = F-CONDI4  NO-LOCK NO-ERROR.
   IF NOT AVAIL Gn-Convt THEN DO:
    MESSAGE "CONDICION DE VENTA NO EXISTE PARA LISTA DE PRECIOS OFICINA....VERIFIQUE"  SKIP
            "CONFIGURACION ERRADA PARA COLUMNA 4 " VIEW-AS ALERT-BOX ERROR. 
    RETURN NO-APPLY .   
   END.
   Titu_Pre4 = "OFI-" + f-cate4 + f-condi4.

  END.


  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-tipo1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tipo1 W-Win
ON VALUE-CHANGED OF c-tipo1 IN FRAME F-Main /* Columna 1 */
DO:
  ASSIGN C-TIPO1 .
  CASE  C-TIPO1 :
   WHEN  "Mostrador" THEN 
        DO:
        C-MOS1:HIDDEN = FALSE.
        F-CONDI1:SCREEN-VALUE = "".
        F-CATE1:SCREEN-VALUE = "".
        F-CONDI1:SENSITIVE = FALSE .
        F-CATE1:SENSITIVE = FALSE.

       
        END.
   WHEN "Oficina" THEN
        DO:
        C-MOS1:HIDDEN = TRUE.
        F-CONDI1:SENSITIVE = TRUE .
        F-CATE1:SENSITIVE = TRUE.
        END.
  
  END CASE.
 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-tipo2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tipo2 W-Win
ON VALUE-CHANGED OF c-tipo2 IN FRAME F-Main /* Columna 2 */
DO:
  ASSIGN C-TIPO2 .
  CASE  C-TIPO2 :
   WHEN  "Mostrador" THEN 
        DO:
        C-MOS2:HIDDEN = FALSE.
        F-CONDI2:SCREEN-VALUE = "".
        F-CATE2:SCREEN-VALUE = "".
        F-CONDI2:SENSITIVE = FALSE .
        F-CATE2:SENSITIVE = FALSE.
       
        END.
   WHEN "Oficina" THEN
        DO:
        C-MOS2:HIDDEN = TRUE.
        F-CONDI2:SENSITIVE = TRUE .
        F-CATE2:SENSITIVE = TRUE.
        END.
  
  END CASE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-tipo3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tipo3 W-Win
ON VALUE-CHANGED OF c-tipo3 IN FRAME F-Main /* Columna 3 */
DO:
  ASSIGN C-TIPO3 .
  CASE  C-TIPO3 :
   WHEN  "Mostrador" THEN 
        DO:
        C-MOS3:HIDDEN = FALSE.
        F-CONDI3:SCREEN-VALUE = "".
        F-CATE3:SCREEN-VALUE = "".
        F-CONDI3:SENSITIVE = FALSE .
        F-CATE3:SENSITIVE = FALSE.

       
        END.
   WHEN "Oficina" THEN
        DO:
        C-MOS3:HIDDEN = TRUE.
        F-CONDI3:SENSITIVE = TRUE .
        F-CATE3:SENSITIVE = TRUE.
        END.
  
  END CASE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-tipo4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tipo4 W-Win
ON VALUE-CHANGED OF c-tipo4 IN FRAME F-Main /* Columna 4 */
DO:
  ASSIGN C-TIPO4 .
  CASE  C-TIPO4 :
   WHEN  "Mostrador" THEN 
        DO:
        C-MOS4:HIDDEN = FALSE.
        F-CONDI4:SCREEN-VALUE = "".
        F-CATE4:SCREEN-VALUE = "".
        F-CONDI4:SENSITIVE = FALSE .
        F-CATE4:SENSITIVE = FALSE.

       
        END.
   WHEN "Oficina" THEN
        DO:
        C-MOS4:HIDDEN = TRUE.
        F-CONDI4:SENSITIVE = TRUE .
        F-CATE4:SENSITIVE = TRUE.
        END.
  
  END CASE.

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


&Scoped-define SELF-NAME f-cate1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cate1 W-Win
ON LEAVE OF f-cate1 IN FRAME F-Main
DO:
  ASSIGN f-cate1.
  IF F-CATE1 = "" THEN MESSAGE "NADA".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cate1 W-Win
ON MOUSE-SELECT-DBLCLICK OF f-cate1 IN FRAME F-Main
DO:
  RUN lkup\c-clfcli.r("CALIFICACION DE CLIENTES").
  IF output-var-2 = ? THEN output-var-2 = "".
  f-cate1:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-cate2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cate2 W-Win
ON MOUSE-SELECT-DBLCLICK OF f-cate2 IN FRAME F-Main
DO:
  RUN lkup\c-clfcli.r("CALIFICACION DE CLIENTES").
  IF output-var-2 = ? THEN output-var-2 = "".
  f-cate2:SCREEN-VALUE = output-var-2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-cate3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cate3 W-Win
ON MOUSE-SELECT-DBLCLICK OF f-cate3 IN FRAME F-Main
DO:
  RUN lkup\c-clfcli.r("CALIFICACION DE CLIENTES").
  IF output-var-2 = ? THEN output-var-2 = "".
  f-cate3:SCREEN-VALUE = output-var-2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-cate4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cate4 W-Win
ON MOUSE-SELECT-DBLCLICK OF f-cate4 IN FRAME F-Main
DO:
  RUN lkup\c-clfcli.r("CALIFICACION DE CLIENTES").
  IF output-var-2 = ? THEN output-var-2 = "".
  f-cate4:SCREEN-VALUE = output-var-2.

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


&Scoped-define SELF-NAME f-condi1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-condi1 W-Win
ON MOUSE-SELECT-DBLCLICK OF f-condi1 IN FRAME F-Main
DO:
  RUN lkup\c-condvt.r("CONDICIONES DE VENTA").
  IF output-var-2 = ? THEN output-var-2 = "".
  f-condi1:SCREEN-VALUE = output-var-2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-condi2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-condi2 W-Win
ON MOUSE-SELECT-DBLCLICK OF f-condi2 IN FRAME F-Main
DO:
  RUN lkup\c-condvt.r("CONDICIONES DE VENTA").
  IF output-var-2 = ? THEN output-var-2 = "".
  f-condi2:SCREEN-VALUE = output-var-2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-condi3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-condi3 W-Win
ON MOUSE-SELECT-DBLCLICK OF f-condi3 IN FRAME F-Main
DO:
  RUN lkup\c-condvt.r("CONDICIONES DE VENTA").
  IF output-var-2 = ? THEN output-var-2 = "".
  f-condi3:SCREEN-VALUE = output-var-2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-condi4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-condi4 W-Win
ON MOUSE-SELECT-DBLCLICK OF f-condi4 IN FRAME F-Main
DO:
  RUN lkup\c-condvt.r("CONDICIONES DE VENTA").
  IF output-var-2 = ? THEN output-var-2 = "".
  f-condi4:SCREEN-VALUE = output-var-2.

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
  ASSIGN DesdeC F-CodFam F-SubFam F-DesFam HastaC nCodMon R-Tipo 
         f-cate1 f-cate2 f-cate3 f-cate4 
         f-condi1 f-condi2 f-condi3 f-condi4
         c-tipo1 c-tipo2 c-tipo3 c-tipo4
         c-mos1 c-mos2 c-mos3 c-mos4 .

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
  
  Titu_Pre1 = "MOS-" + c-mos1.
  Titu_Pre2 = "MOS-" + c-mos2.
  Titu_Pre3 = "MOS-" + c-mos3.
  Titu_Pre4 = "MOS-" + c-mos4.

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

DEFINE VAR F-FACTOR AS DECI INIT 1.
DEFINE VAR F-PORIMP AS DECI INIT 1.
DEFINE VAR F-PREVTA AS DECI INIT 0.
DEFINE VAR F-PREBAS AS DECI INIT 0.
  
 FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.Codcia = S-CODCIA  
                            AND  Almmmatg.codfam BEGINS F-CodFam 
                            AND  Almmmatg.subfam BEGINS F-SubFam 
                            AND  (Almmmatg.CodMat >= DesdeC  
                            AND   Almmmatg.CodMat <= HastaC)
                            AND  Almmmatg.TpoArt BEGINS R-Tipo
                           BREAK BY Almmmatg.Codfam
                                 BY Almmmatg.Subfam
                                 BY Almmmatg.CodMar
                                 BY Almmmatg.CodMat:
    /*
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
    */

     DISPLAY "Codigo de Articulo: " + Almmmatg.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.

  CREATE Tempo.
  Tempo.CodMat = Almmmatg.Codmat .
  Tempo.DesMat = Almmmatg.DesMat .
  Tempo.DesMar = Almmmatg.DesMar .
  Tempo.UndBas = Almmmatg.UndBas .
  Tempo.MonVta = Almmmatg.MonVta .
  Tempo.CodFam = Almmmatg.CodFam .
  Tempo.SubFam = Almmmatg.SubFam .
  Tempo.CodMar = Almmmatg.CodMar .

  /************* PRECIO A *******************/
  IF C-TIPO1 = "Mostrador" THEN DO:
   CASE C-MOS1 :
    WHEN "UndA"    THEN ASSIGN Tempo.UndA = Almmmatg.UndA 
                               X-PREA     = Almmmatg.Prevta[2].
    WHEN "UndB"    THEN ASSIGN Tempo.UndA = Almmmatg.UndB 
                               X-PREA     = X-PREB.
    WHEN "UndC"    THEN ASSIGN Tempo.UndA = Almmmatg.UndC 
                               X-PREA     = X-PREC.
    WHEN "Credito" THEN ASSIGN Tempo.UndA = Almmmatg.Chr__01 
                               X-PREA     = Almmmatg.Preofi.
   END.
   S-TPOCMB = Almmmatg.TpoCmb.

   IF NCODMON = 1 THEN DO:
      IF Almmmatg.MonVta = 1 THEN
          ASSIGN F-PREBAS = X-PREA.
      ELSE
          ASSIGN F-PREBAS = X-PREA * S-TpoCmb .
   END.
        
   IF NCODMON = 2 THEN DO:
      IF Almmmatg.MonVta = 2 THEN
         ASSIGN F-PREBAS = X-PREA.
      ELSE
         ASSIGN F-PREBAS = X-PREA / S-TpoCmb .
   END.

   F-PREVTA = F-PREBAS .
   X-PREA   = F-PREVTA.

   
   IF NCODMON = 1 THEN DO:
    F-PRESOLA = X-PREA.
   END.
   ELSE DO:
    F-PREUSSA = X-PREA.    
   END.
  

  END.
  ELSE DO:

   FIND gn-convt WHERE gn-convt.Codig = F-CONDI1 
                       NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN DO:
       FIND TcmbCot WHERE  TcmbCot.Codcia = 0
                     AND  (TcmbCot.Rango1 <= gn-convt.totdias
                     AND   TcmbCot.Rango2 >= gn-convt.totdias)
                    NO-LOCK NO-ERROR.
       IF AVAIL TcmbCot THEN DO:
           S-TPOCMB = TcmbCot.TpoCmb.  
       END.
   END.  
   
   IF NCODMON = 1 THEN DO:
      IF Almmmatg.MonVta = 1 THEN
          ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * F-FACTOR.
      ELSE
          ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * S-TpoCmb /*Almmmatg.TpoCmb*/ * F-FACTOR.
   END.
        
   IF NCODMON = 2 THEN DO:
      IF Almmmatg.MonVta = 2 THEN
         ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * F-FACTOR.
      ELSE
         ASSIGN F-PREBAS = ((Almmmatg.PreOfi * F-PorImp) / S-TpoCmb /*Almmmatg.TpoCmb*/) * F-FACTOR.
   END.

   MaxCat = 0.
   MaxVta = 0.
   F-DSCTOS = 0.
   FIND ClfClie WHERE ClfClie.Categoria = F-CATE1 NO-LOCK NO-ERROR.
   IF AVAIL ClfClie THEN DO:
      IF Almmmatg.Chr__02 = "P" THEN 
          MaxCat = ClfClie.PorDsc.
      ELSE 
          MaxCat = ClfClie.PorDsc1.
   END.
   FIND Dsctos WHERE 
         Dsctos.CndVta = F-CONDI1 AND  
         Dsctos.clfCli = Almmmatg.Chr__02 NO-LOCK NO-ERROR.
   IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.
   IF NOT AVAIL ClfClie THEN
        F-DSCTOS = (1 - (1 - MaxVta / 100)) * 100.
   ELSE
        F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.


   F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).

   ASSIGN Tempo.UndA = Almmmatg.Chr__01
              X-PREA = F-PREVTA.

   
   IF NCODMON = 1 THEN DO:
    F-PRESOLA = X-PREA.
   END.
   ELSE DO:
    F-PREUSSA = X-PREA.    
   END.
  END.
  /*****************************************/
  
  /************* PRECIO B *******************/
  IF C-TIPO2 = "Mostrador" THEN DO:
   CASE C-MOS2 :
    WHEN "UndA"    THEN ASSIGN Tempo.UndB = Almmmatg.UndA 
                               X-PREB     = Almmmatg.Prevta[2].
    WHEN "UndB"    THEN ASSIGN Tempo.UndB = Almmmatg.UndB 
                               X-PREB     = X-PREB.
    WHEN "UndC"    THEN ASSIGN Tempo.UndB = Almmmatg.UndC 
                               X-PREB     = X-PREC.
    WHEN "Credito" THEN ASSIGN Tempo.UndB = Almmmatg.Chr__01 
                               X-PREB     = Almmmatg.Preofi.
   END.
   S-TPOCMB = Almmmatg.TpoCmb.

   IF NCODMON = 1 THEN DO:
      IF Almmmatg.MonVta = 1 THEN
          ASSIGN F-PREBAS = X-PREB.
      ELSE
          ASSIGN F-PREBAS = X-PREB * S-TpoCmb .
   END.
        
   IF NCODMON = 2 THEN DO:
      IF Almmmatg.MonVta = 2 THEN
         ASSIGN F-PREBAS = X-PREB.
      ELSE
         ASSIGN F-PREBAS = X-PREB / S-TpoCmb .
   END.

   F-PREVTA = F-PREBAS .
   X-PREB   = F-PREVTA.

   
   IF NCODMON = 1 THEN DO:
    F-PRESOLB = X-PREB.
   END.
   ELSE DO:
    F-PREUSSB = X-PREB.    
   END.

  END.
  ELSE DO:
   FIND gn-convt WHERE gn-convt.Codig = F-CONDI2 
                       NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN DO:
       FIND TcmbCot WHERE  TcmbCot.Codcia = 0
                     AND  (TcmbCot.Rango1 <= gn-convt.totdias
                     AND   TcmbCot.Rango2 >= gn-convt.totdias)
                    NO-LOCK NO-ERROR.
       IF AVAIL TcmbCot THEN DO:
           S-TPOCMB = TcmbCot.TpoCmb.  
       END.
   END.  
   
   IF NCODMON = 1 THEN DO:
      IF Almmmatg.MonVta = 1 THEN
          ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * F-FACTOR.
      ELSE
          ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * S-TpoCmb /*Almmmatg.TpoCmb*/ * F-FACTOR.
   END.
        
   IF NCODMON = 2 THEN DO:
      IF Almmmatg.MonVta = 2 THEN
         ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * F-FACTOR.
      ELSE
         ASSIGN F-PREBAS = ((Almmmatg.PreOfi * F-PorImp) / S-TpoCmb /*Almmmatg.TpoCmb*/) * F-FACTOR.
   END.

   MaxCat = 0.
   MaxVta = 0.
   F-DSCTOS = 0.
   FIND ClfClie WHERE ClfClie.Categoria = F-CATE2 NO-LOCK NO-ERROR.
   IF AVAIL ClfClie THEN DO:
      IF Almmmatg.Chr__02 = "P" THEN 
          MaxCat = ClfClie.PorDsc.
      ELSE 
          MaxCat = ClfClie.PorDsc1.
   END.
   FIND Dsctos WHERE 
         Dsctos.CndVta = F-CONDI2 AND  
         Dsctos.clfCli = Almmmatg.Chr__02 NO-LOCK NO-ERROR.
   IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.
   IF NOT AVAIL ClfClie THEN
        F-DSCTOS = (1 - (1 - MaxVta / 100)) * 100.
   ELSE
        F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.

   F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).

   ASSIGN Tempo.UndB = Almmmatg.Chr__01
              X-PREB = F-PREVTA.

   
   IF NCODMON = 1 THEN DO:
    F-PRESOLB = X-PREB.
   END.
   ELSE DO:
    F-PREUSSB = X-PREB.    
   END.


  END.
  /*****************************************/
  
  /************* PRECIO C *******************/
  IF C-TIPO3 = "Mostrador" THEN DO:
   CASE C-MOS3 :
    WHEN "UndA"    THEN ASSIGN Tempo.UndC = Almmmatg.UndA 
                               X-PREC     = Almmmatg.Prevta[2].
    WHEN "UndB"    THEN ASSIGN Tempo.UndC = Almmmatg.UndB 
                               X-PREC     = X-PREB.
    WHEN "UndC"    THEN ASSIGN Tempo.UndC = Almmmatg.UndC 
                               X-PREC     = X-PREC.
    WHEN "Credito" THEN ASSIGN Tempo.UndC = Almmmatg.Chr__01 
                               X-PREC     = Almmmatg.Preofi.
   END.
   S-TPOCMB = Almmmatg.TpoCmb.

   IF NCODMON = 1 THEN DO:
      IF Almmmatg.MonVta = 1 THEN
          ASSIGN F-PREBAS = X-PREC.
      ELSE
          ASSIGN F-PREBAS = X-PREC * S-TpoCmb .
   END.
        
   IF NCODMON = 2 THEN DO:
      IF Almmmatg.MonVta = 2 THEN
         ASSIGN F-PREBAS = X-PREC.
      ELSE
         ASSIGN F-PREBAS = X-PREC / S-TpoCmb .
   END.

   F-PREVTA = F-PREBAS .
   X-PREC   = F-PREVTA.

   
   IF NCODMON = 1 THEN DO:
    F-PRESOLC = X-PREC.
   END.
   ELSE DO:
    F-PREUSSC = X-PREC.    
   END.
   
  END.
  ELSE DO:

   FIND gn-convt WHERE gn-convt.Codig = F-CONDI3 
                       NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN DO:
       FIND TcmbCot WHERE  TcmbCot.Codcia = 0
                     AND  (TcmbCot.Rango1 <= gn-convt.totdias
                     AND   TcmbCot.Rango2 >= gn-convt.totdias)
                    NO-LOCK NO-ERROR.
       IF AVAIL TcmbCot THEN DO:
           S-TPOCMB = TcmbCot.TpoCmb.  
       END.
   END.  
   
   IF NCODMON = 1 THEN DO:
      IF Almmmatg.MonVta = 1 THEN
          ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * F-FACTOR.
      ELSE
          ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * S-TpoCmb /*Almmmatg.TpoCmb*/ * F-FACTOR.
   END.
        
   IF NCODMON = 2 THEN DO:
      IF Almmmatg.MonVta = 2 THEN
         ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * F-FACTOR.
      ELSE
         ASSIGN F-PREBAS = ((Almmmatg.PreOfi * F-PorImp) / S-TpoCmb /*Almmmatg.TpoCmb*/) * F-FACTOR.
   END.

   MaxCat = 0.
   MaxVta = 0.
   F-DSCTOS = 0.
   FIND ClfClie WHERE ClfClie.Categoria = F-CATE3 NO-LOCK NO-ERROR.
   IF AVAIL ClfClie THEN DO:
      IF Almmmatg.Chr__02 = "P" THEN 
          MaxCat = ClfClie.PorDsc.
      ELSE 
          MaxCat = ClfClie.PorDsc1.
   END.
   FIND Dsctos WHERE 
         Dsctos.CndVta = F-CONDI3 AND  
         Dsctos.clfCli = Almmmatg.Chr__02 NO-LOCK NO-ERROR.
   IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.
   IF NOT AVAIL ClfClie THEN
        F-DSCTOS = (1 - (1 - MaxVta / 100)) * 100.
   ELSE
        F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.

   F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).

   ASSIGN Tempo.UndC = Almmmatg.Chr__01
              X-PREC = F-PREVTA.

   
   IF NCODMON = 1 THEN DO:
    F-PRESOLC = X-PREC.
   END.
   ELSE DO:
    F-PREUSSC = X-PREC.    
   END.

  END.
  /*****************************************/


  /************* PRECIO D *******************/
  IF C-TIPO4 = "Mostrador" THEN DO:
   CASE C-MOS4 :
    WHEN "UndA"    THEN ASSIGN Tempo.UndD = Almmmatg.UndA 
                               X-PRED     = Almmmatg.Prevta[2].
    WHEN "UndB"    THEN ASSIGN Tempo.UndD = Almmmatg.UndB 
                               X-PRED     = X-PREB.
    WHEN "UndC"    THEN ASSIGN Tempo.UndD = Almmmatg.UndC 
                               X-PRED     = X-PREC.
    WHEN "Credito" THEN ASSIGN Tempo.UndD = Almmmatg.Chr__01 
                               X-PRED     = Almmmatg.Preofi.
   END.
   S-TPOCMB = Almmmatg.TpoCmb.

   IF NCODMON = 1 THEN DO:
      IF Almmmatg.MonVta = 1 THEN
          ASSIGN F-PREBAS = X-PRED.
      ELSE
          ASSIGN F-PREBAS = X-PRED * S-TpoCmb .
   END.
        
   IF NCODMON = 2 THEN DO:
      IF Almmmatg.MonVta = 2 THEN
         ASSIGN F-PREBAS = X-PRED.
      ELSE
         ASSIGN F-PREBAS = X-PRED / S-TpoCmb .
   END.

   F-PREVTA = F-PREBAS .
   X-PRED   = F-PREVTA.

   
   IF NCODMON = 1 THEN DO:
    F-PRESOLD = X-PRED.
   END.
   ELSE DO:
    F-PREUSSD = X-PRED.    
   END.


  END.
  ELSE DO:
   FIND gn-convt WHERE gn-convt.Codig = F-CONDI4 
                       NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN DO:
       FIND TcmbCot WHERE  TcmbCot.Codcia = 0
                     AND  (TcmbCot.Rango1 <= gn-convt.totdias
                     AND   TcmbCot.Rango2 >= gn-convt.totdias)
                    NO-LOCK NO-ERROR.
       IF AVAIL TcmbCot THEN DO:
           S-TPOCMB = TcmbCot.TpoCmb.  
       END.
   END.  
   
   IF NCODMON = 1 THEN DO:
      IF Almmmatg.MonVta = 1 THEN
          ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * F-FACTOR.
      ELSE
          ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * S-TpoCmb /*Almmmatg.TpoCmb*/ * F-FACTOR.
   END.
        
   IF NCODMON = 2 THEN DO:
      IF Almmmatg.MonVta = 2 THEN
         ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * F-FACTOR.
      ELSE
         ASSIGN F-PREBAS = ((Almmmatg.PreOfi * F-PorImp) / S-TpoCmb /*Almmmatg.TpoCmb*/) * F-FACTOR.
   END.

   MaxCat = 0.
   MaxVta = 0.
   F-DSCTOS = 0.
   FIND ClfClie WHERE ClfClie.Categoria = F-CATE4 NO-LOCK NO-ERROR.
   IF AVAIL ClfClie THEN DO:
      IF Almmmatg.Chr__02 = "P" THEN 
          MaxCat = ClfClie.PorDsc.
      ELSE 
          MaxCat = ClfClie.PorDsc1.
   END.
   FIND Dsctos WHERE 
         Dsctos.CndVta = F-CONDI4 AND  
         Dsctos.clfCli = Almmmatg.Chr__02 NO-LOCK NO-ERROR.
   IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.
   IF NOT AVAIL ClfClie THEN
        F-DSCTOS = (1 - (1 - MaxVta / 100)) * 100.
   ELSE
        F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.

   F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).

   ASSIGN Tempo.UndD = Almmmatg.Chr__01
              X-PRED = F-PREVTA.

   
   IF NCODMON = 1 THEN DO:
    F-PRESOLD = X-PRED.
   END.
   ELSE DO:
    F-PREUSSD = X-PRED.    
   END.
  END.
  /*****************************************/

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
  DISPLAY x-mensaje F-CodFam F-DesFam F-SubFam F-DesSub DesdeC HastaC R-Tipo 
          nCodMon c-tipo1 c-mos1 f-cate1 f-condi1 c-tipo2 c-mos2 f-cate2 
          f-condi2 c-tipo3 c-mos3 f-cate3 f-condi3 c-tipo4 c-mos4 f-cate4 
          f-condi4 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE F-CodFam F-SubFam DesdeC HastaC R-Tipo nCodMon c-tipo1 c-mos1 f-cate1 
         f-condi1 c-tipo2 c-mos2 f-cate2 f-condi2 c-tipo3 c-mos3 f-cate3 
         f-condi3 c-tipo4 c-mos4 f-cate4 f-condi4 Btn_OK Btn_Cancel Btn_Help 
         RECT-57 RECT-58 
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
/*
  DEFINE FRAME F-REPORTE1
               Almmmatg.codmat  FORMAT "X(6)"
               Almmmatg.DesMat  FORMAT "X(40)"
               Almmmatg.DesMar  FORMAT "X(10)"
               Almmmatg.UndBas  FORMAT "X(8)"
               Almmmatg.MonVta  FORMAT "9"
               F-PRESOLA        FORMAT ">>>,>>9.9999"
/*               F-PREUSSA        FORMAT ">>>,>>9.9999"*/
               Almmmatg.UndA    FORMAT "X(8)"
               F-PRESOLB        FORMAT ">>>,>>9.9999"
/*               F-PREUSSB        FORMAT ">>>,>>9.9999"*/
               Almmmatg.UndB    FORMAT "X(8)"
               F-PRESOLC        FORMAT ">>>,>>9.9999"
/*               F-PREUSSC        FORMAT ">>>,>>9.9999"*/
               Almmmatg.UndC    FORMAT "X(8)"
               F-PRESOLD        FORMAT ">>>,>>9.9999"
/*               F-PREUSSD        FORMAT ">>>,>>9.9999"*/
               Almmmatg.Chr__01 FORMAT "X(8)"
              WITH WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn3}*/ FORMAT "X(50)" AT 1 SKIP
         "LISTADO DE PRECIOS" AT 62
         "Pagina :" TO 125 PAGE-NUMBER(REPORT) TO 137 FORMAT "ZZZZZ9" SKIP
         "Fecha  :" TO 125 TODAY TO 137 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 125 STRING(TIME,"HH:MM") TO 137 SKIP
         mensaje FORMAT "X(28)" SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                        PREC. VTA. (A)        PREC. VTA. (B)         PREC. VTA. (C)      PREC. VTA. OFIC." SKIP
        "Codigo D  E  S  C  R  I  P  C  I  O  N          MARCA      U.B.  MONEDA        S/. UM.              S/.  UM.              S/.   UM.             S/.  UM. " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        
      WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.Codcia = S-CODCIA  
                            AND  Almmmatg.codfam BEGINS F-CodFam 
                            AND  Almmmatg.subfam BEGINS F-SubFam 
                            AND  (Almmmatg.CodMat >= DesdeC  
                            AND   Almmmatg.CodMat <= HastaC)
                            AND  Almmmatg.TpoArt BEGINS R-Tipo
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
/*      IF FIRST-OF(Almmmatg.prove) THEN DO:
 *          FIND GN-PROV WHERE GN-PROV.CODCIA = 0 
 *                        AND  GN-PROV.CODPRO = Almmmatg.prove 
 *                       NO-LOCK NO-ERROR.
 *          IF AVAILABLE GN-PROV THEN DO:
 *              PUT STREAM REPORT "PROVEEDOR : " Almmmatg.prove '    ' gn-prov.NomPro SKIP.
 *              PUT STREAM REPORT '      ------------------------------------------' SKIP.
 *          END.  
 *       END.*/

  IF Almmmatg.MonVta = 1 THEN DO:
    F-PRESOLA = Almmmatg.Prevta[2].
    F-PRESOLB = Almmmatg.Prevta[3].
    F-PRESOLC = Almmmatg.Prevta[4].
    F-PRESOLD = Almmmatg.PreOfi.

    F-PREUSSA = Almmmatg.Prevta[2] / Almmmatg.TpoCmb.
    F-PREUSSB = Almmmatg.Prevta[3] / Almmmatg.TpoCmb.
    F-PREUSSC = Almmmatg.Prevta[4] / Almmmatg.TpoCmb.
    F-PREUSSD = Almmmatg.PreOfi / Almmmatg.TpoCmb.
  END.
  ELSE DO:
    F-PREUSSA = Almmmatg.Prevta[2].
    F-PREUSSB = Almmmatg.Prevta[3].
    F-PREUSSC = Almmmatg.Prevta[4].
    F-PREUSSD = Almmmatg.PreOfi.

    F-PRESOLA = Almmmatg.Prevta[2] * Almmmatg.TpoCmb.
    F-PRESOLB = Almmmatg.Prevta[3] * Almmmatg.TpoCmb.
    F-PRESOLC = Almmmatg.Prevta[4] * Almmmatg.TpoCmb.
    F-PRESOLD = Almmmatg.PreOfi * Almmmatg.TpoCmb.
  END.
         
      DISPLAY STREAM REPORT 
               Almmmatg.codmat
               Almmmatg.DesMat
               Almmmatg.DesMar
               Almmmatg.UndBas
               Almmmatg.MonVta
               F-PRESOLA    WHEN F-PRESOLA <> 0
/*               F-PREUSSA  WHEN F-PREUSSA <> 0 */ 
               Almmmatg.UndA    WHEN Almmmatg.UndA <> ""
               F-PRESOLB    WHEN F-PRESOLB <> 0 
/*               F-PREUSSB  WHEN F-PREUSSB <> 0 */
               Almmmatg.UndB    WHEN Almmmatg.UndB <> "" 
               F-PRESOLC    WHEN F-PRESOLC <> 0
/*               F-PREUSSC  WHEN F-PREUSSC <> 0 */
               Almmmatg.UndC    WHEN Almmmatg.UndC <> ""
               F-PRESOLD    WHEN F-PRESOLD <> 0
/*               F-PREUSSD  WHEN F-PREUSSD <> 0 */
               Almmmatg.Chr__01 WHEN Almmmatg.Chr__01 <> ""
               WITH FRAME F-REPORTE1.
      DOWN STREAM REPORT WITH FRAME F-REPORTE1.
       
  END.
  HIDE FRAME F-PROCESO.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-11 W-Win 
PROCEDURE Formato-11 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE1
               Tempo.codmat  FORMAT "X(6)"
               Tempo.DesMat  FORMAT "X(40)"
               Tempo.DesMar  FORMAT "X(10)"
               Tempo.UndBas  FORMAT "X(8)"
               Tempo.MonVta  FORMAT "9"
               F-PRESOLA        FORMAT ">>>,>>9.9999"
               Tempo.UndA    FORMAT "X(8)"
               F-PRESOLB        FORMAT ">>>,>>9.9999"
               Tempo.UndB    FORMAT "X(8)"
               F-PRESOLC        FORMAT ">>>,>>9.9999"
               Tempo.UndC    FORMAT "X(8)"
               F-PRESOLD        FORMAT ">>>,>>9.9999"
               Tempo.UndD FORMAT "X(8)"
              WITH WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn3}*/ FORMAT "X(50)" AT 1 SKIP
         "LISTADO DE PRECIOS" AT 62
         "Pagina :" TO 125 PAGE-NUMBER(REPORT) TO 137 FORMAT "ZZZZZ9" SKIP
         "Fecha  :" TO 125 TODAY TO 137 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 125 STRING(TIME,"HH:MM") TO 137 SKIP
         mensaje FORMAT "X(28)" SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                        PREC. VTA. (A)        PREC. VTA. (B)         PREC. VTA. (C)      PREC. VTA. (D)  " SKIP
        "Codigo D  E  S  C  R  I  P  C  I  O  N          MARCA      U.B.  MONEDA        S/. UM.              S/.  UM.              S/.   UM.             S/.  UM. " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        
      WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Tempo   BREAK BY Tempo.Codfam
                        BY Tempo.Subfam
                        BY Tempo.CodMar
                        BY Tempo.CodMat:

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(Tempo.CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = Tempo.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT "FAMILIA : " Almtfami.codfam '    ' Almtfami.desfam SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
      IF FIRST-OF(Tempo.SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = s-CodCia 
                        AND  Almsfami.codfam = Tempo.CodFam 
                        AND  Almsfami.subfam = Tempo.Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT "SUB-FAMILIA : " Almsfami.subfam '   ' AlmSFami.dessub SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
         
      DISPLAY STREAM REPORT 
               Tempo.codmat
               Tempo.DesMat
               Tempo.DesMar
               Tempo.UndBas
               Tempo.MonVta
               F-PRESOLA    WHEN F-PRESOLA <> 0
               Tempo.UndA    WHEN Tempo.UndA <> ""
               F-PRESOLB    WHEN F-PRESOLB <> 0 
               Tempo.UndB    WHEN Tempo.UndB <> "" 
               F-PRESOLC    WHEN F-PRESOLC <> 0
               Tempo.UndC    WHEN Tempo.UndC <> ""
               F-PRESOLD    WHEN F-PRESOLD <> 0
               Tempo.UndD   WHEN Tempo.UndD <> ""
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
/*
  DEFINE FRAME F-REPORTE2
               Almmmatg.codmat  FORMAT "X(6)"
               Almmmatg.DesMat  FORMAT "X(40)"
               Almmmatg.DesMar  FORMAT "X(10)"
               Almmmatg.UndBas  FORMAT "X(8)"
               Almmmatg.MonVta  FORMAT "9"
/*               F-PRESOLA        FORMAT ">>>,>>9.9999"*/
               F-PREUSSA        FORMAT ">>>,>>9.9999"
               Almmmatg.UndA    FORMAT "X(8)"
/*               F-PRESOLB        FORMAT ">>>,>>9.9999"*/
               F-PREUSSB        FORMAT ">>>,>>9.9999"
               Almmmatg.UndB    FORMAT "X(8)"
/*               F-PRESOLC        FORMAT ">>>,>>9.9999"*/
               F-PREUSSC        FORMAT ">>>,>>9.9999"
               Almmmatg.UndC    FORMAT "X(8)"
/*               F-PRESOLD        FORMAT ">>>,>>9.9999"*/
               F-PREUSSD        FORMAT ">>>,>>9.9999"
               Almmmatg.Chr__01 FORMAT "X(8)"
              WITH WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn3}*/ FORMAT "X(50)" AT 1 SKIP
         "LISTADO DE PRECIOS" AT 62
         "Pagina :" TO 125 PAGE-NUMBER(REPORT) TO 137 FORMAT "ZZZZZ9" SKIP
         "Fecha  :" TO 125 TODAY TO 137 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 125 STRING(TIME,"HH:MM") TO 137 SKIP
         mensaje FORMAT "X(28)" SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                        PREC. VTA. (A)        PREC. VTA. (B)         PREC. VTA. (C)      PREC. VTA. OFIC." SKIP
        "Codigo D  E  S  C  R  I  P  C  I  O  N          MARCA      U.B.  MONEDA       USS. UM.             USS.  UM.             USS.   UM.            USS.  UM. " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
      WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.Codcia = S-CODCIA  
                            AND  Almmmatg.codfam BEGINS F-CodFam 
                            AND  Almmmatg.subfam BEGINS F-SubFam 
                            AND  (Almmmatg.CodMat >= DesdeC  
                            AND   Almmmatg.CodMat <= HastaC)
                            AND  Almmmatg.TpoArt BEGINS R-Tipo
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
/*      IF FIRST-OF(Almmmatg.prove) THEN DO:
 *          FIND GN-PROV WHERE GN-PROV.CODCIA = 0 
 *                        AND  GN-PROV.CODPRO = Almmmatg.prove 
 *                       NO-LOCK NO-ERROR.
 *          IF AVAILABLE GN-PROV THEN DO:
 *              PUT STREAM REPORT "PROVEEDOR : " Almmmatg.prove '    ' gn-prov.NomPro SKIP.
 *              PUT STREAM REPORT '      ------------------------------------------' SKIP.
 *          END.  
 *       END.*/

  IF Almmmatg.MonVta = 1 THEN DO:
    F-PRESOLA = Almmmatg.Prevta[2].
    F-PRESOLB = Almmmatg.Prevta[3].
    F-PRESOLC = Almmmatg.Prevta[4].
    F-PRESOLD = Almmmatg.PreOfi.

    F-PREUSSA = Almmmatg.Prevta[2] / Almmmatg.TpoCmb.
    F-PREUSSB = Almmmatg.Prevta[3] / Almmmatg.TpoCmb.
    F-PREUSSC = Almmmatg.Prevta[4] / Almmmatg.TpoCmb.
    F-PREUSSD = Almmmatg.PreOfi / Almmmatg.TpoCmb.
  END.
  ELSE DO:
    F-PREUSSA = Almmmatg.Prevta[2].
    F-PREUSSB = Almmmatg.Prevta[3].
    F-PREUSSC = Almmmatg.Prevta[4].
    F-PREUSSD = Almmmatg.PreOfi.

    F-PRESOLA = Almmmatg.Prevta[2] * Almmmatg.TpoCmb.
    F-PRESOLB = Almmmatg.Prevta[3] * Almmmatg.TpoCmb.
    F-PRESOLC = Almmmatg.Prevta[4] * Almmmatg.TpoCmb.
    F-PRESOLD = Almmmatg.PreOfi * Almmmatg.TpoCmb.
  END.
         
      DISPLAY STREAM REPORT 
               Almmmatg.codmat
               Almmmatg.DesMat
               Almmmatg.DesMar
               Almmmatg.UndBas
               Almmmatg.MonVta
/*               F-PRESOLA  WHEN F-PRESOLA <> 0 */
               F-PREUSSA    WHEN F-PREUSSA <> 0
               Almmmatg.UndA    WHEN Almmmatg.UndA <> ""
/*               F-PRESOLB  WHEN F-PRESOLB <> 0 */
               F-PREUSSB    WHEN F-PREUSSB <> 0
               Almmmatg.UndB    WHEN Almmmatg.UndB <> "" 
/*               F-PRESOLC  WHEN F-PRESOLC <> 0*/
               F-PREUSSC    WHEN F-PREUSSC <> 0
               Almmmatg.UndC    WHEN Almmmatg.UndC <> ""
/*               F-PRESOLD  WHEN F-PRESOLD <> 0 */
               F-PREUSSD    WHEN F-PREUSSD <> 0
               Almmmatg.Chr__01 WHEN Almmmatg.Chr__01 <> ""
               WITH FRAME F-REPORTE2.
      DOWN STREAM REPORT WITH FRAME F-REPORTE2.
       
  END.
  HIDE FRAME F-PROCESO.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-22 W-Win 
PROCEDURE Formato-22 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE2
               Tempo.codmat  FORMAT "X(6)"
               Tempo.DesMat  FORMAT "X(40)"
               Tempo.DesMar  FORMAT "X(10)"
               Tempo.UndBas  FORMAT "X(8)"
               Tempo.MonVta  FORMAT "9"
               F-PREUSSA        FORMAT ">>>,>>9.9999"
               Tempo.UndA    FORMAT "X(8)"
               F-PREUSSB        FORMAT ">>>,>>9.9999"
               Tempo.UndB    FORMAT "X(8)"
               F-PREUSSC        FORMAT ">>>,>>9.9999"
               Tempo.UndC    FORMAT "X(8)"
               F-PREUSSD        FORMAT ">>>,>>9.9999"
               Tempo.UndD    FORMAT "X(8)"
              WITH WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn3}*/ FORMAT "X(50)" AT 1 SKIP
         "LISTADO DE PRECIOS" AT 62
         "Pagina :" TO 125 PAGE-NUMBER(REPORT) TO 137 FORMAT "ZZZZZ9" SKIP
         "Fecha  :" TO 125 TODAY TO 137 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 125 STRING(TIME,"HH:MM") TO 137 SKIP
         mensaje FORMAT "X(28)" SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                        PREC. VTA. (A)        PREC. VTA. (B)         PREC. VTA. (C)      PREC. VTA. (D) ." SKIP
        "Codigo D  E  S  C  R  I  P  C  I  O  N          MARCA      U.B.  MONEDA       USS. UM.             USS.  UM.             USS.   UM.            USS.  UM. " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
      WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Tempo  BREAK BY Tempo.Codfam
                       BY Tempo.Subfam
                       BY Tempo.CodMar
                       BY Tempo.CodMat:

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(Tempo.CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = Tempo.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT "FAMILIA : " Almtfami.codfam '    ' Almtfami.desfam SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
      IF FIRST-OF(Tempo.SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = s-CodCia 
                        AND  Almsfami.codfam = Tempo.CodFam 
                        AND  Almsfami.subfam = Tempo.Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT "SUB-FAMILIA : " Almsfami.subfam '   ' AlmSFami.dessub SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.

      DISPLAY STREAM REPORT 
               Tempo.codmat
               Tempo.DesMat
               Tempo.DesMar
               Tempo.UndBas
               Tempo.MonVta
               F-PREUSSA    WHEN F-PREUSSA <> 0
               Tempo.UndA    WHEN Tempo.UndA <> ""
               F-PREUSSB    WHEN F-PREUSSB <> 0
               Tempo.UndB    WHEN Tempo.UndB <> "" 
               F-PREUSSC    WHEN F-PREUSSC <> 0
               Tempo.UndC    WHEN Tempo.UndC <> ""
               F-PREUSSD    WHEN F-PREUSSD <> 0
               Tempo.UndD   WHEN Tempo.UndD <> ""
               WITH FRAME F-REPORTE2.
      DOWN STREAM REPORT WITH FRAME F-REPORTE2.
       
  END.
  /*
  HIDE FRAME F-PROCESO.
  */
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
/*
  DEFINE FRAME F-REPORTE
               Almmmatg.codmat  FORMAT "X(6)"
               Almmmatg.DesMat  FORMAT "X(40)"
               Almmmatg.DesMar  FORMAT "X(10)"
               Almmmatg.UndBas  FORMAT "X(8)"
               Almmmatg.MonVta  FORMAT "9"
               F-PRESOLA        FORMAT ">>>,>>9.9999"
               F-PREUSSA        FORMAT ">>>,>>9.9999"
               Almmmatg.UndA    FORMAT "X(8)"
               F-PRESOLB        FORMAT ">>>,>>9.9999"
               F-PREUSSB        FORMAT ">>>,>>9.9999"
               Almmmatg.UndB    FORMAT "X(8)"
               F-PRESOLC        FORMAT ">>>,>>9.9999"
               F-PREUSSC        FORMAT ">>>,>>9.9999"
               Almmmatg.UndC    FORMAT "X(8)"
               F-PRESOLD        FORMAT ">>>,>>9.9999"
               F-PREUSSD        FORMAT ">>>,>>9.9999"
               Almmmatg.Chr__01 FORMAT "X(8)"
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
        "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                               PRECIO DE VTA. (A)                PRECIO DE VTA. (B)                 PRECIO DE VTA. (C)                 PRECIO DE VTA. OFICINA" SKIP
        "Codigo D  E  S  C  R  I  P  C  I  O  N          MARCA      U.B.  MONEDA        S/.        USS$. UM.              S/.         USS$. UM.              S/.         USS$.  UM.             S/.          USS$.  UM." SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
      WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.Codcia = S-CODCIA  
                            AND  Almmmatg.codfam BEGINS F-CodFam 
                            AND  Almmmatg.subfam BEGINS F-SubFam 
                            AND  (Almmmatg.CodMat >= DesdeC  
                            AND   Almmmatg.CodMat <= HastaC)
                            AND  Almmmatg.TpoArt BEGINS R-Tipo
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
/*      IF FIRST-OF(Almmmatg.prove) THEN DO:
 *          FIND GN-PROV WHERE GN-PROV.CODCIA = 0 
 *                        AND  GN-PROV.CODPRO = Almmmatg.prove 
 *                       NO-LOCK NO-ERROR.
 *          IF AVAILABLE GN-PROV THEN DO:
 *              PUT STREAM REPORT "PROVEEDOR : " Almmmatg.prove '    ' gn-prov.NomPro SKIP.
 *              PUT STREAM REPORT '      ------------------------------------------' SKIP.
 *          END.  
 *       END.*/

  IF Almmmatg.MonVta = 1 THEN DO:
    F-PRESOLA = Almmmatg.Prevta[2].
    F-PRESOLB = Almmmatg.Prevta[3].
    F-PRESOLC = Almmmatg.Prevta[4].
    F-PRESOLD = Almmmatg.PreOfi.

    F-PREUSSA = Almmmatg.Prevta[2] / Almmmatg.TpoCmb.
    F-PREUSSB = Almmmatg.Prevta[3] / Almmmatg.TpoCmb.
    F-PREUSSC = Almmmatg.Prevta[4] / Almmmatg.TpoCmb.
    F-PREUSSD = Almmmatg.PreOfi / Almmmatg.TpoCmb.
  END.
  ELSE DO:
    F-PREUSSA = Almmmatg.Prevta[2].
    F-PREUSSB = Almmmatg.Prevta[3].
    F-PREUSSC = Almmmatg.Prevta[4].
    F-PREUSSD = Almmmatg.PreOfi.

    F-PRESOLA = Almmmatg.Prevta[2] * Almmmatg.TpoCmb.
    F-PRESOLB = Almmmatg.Prevta[3] * Almmmatg.TpoCmb.
    F-PRESOLC = Almmmatg.Prevta[4] * Almmmatg.TpoCmb.
    F-PRESOLD = Almmmatg.PreOfi * Almmmatg.TpoCmb.
  END.
         
      DISPLAY STREAM REPORT 
               Almmmatg.codmat
               Almmmatg.DesMat
               Almmmatg.DesMar
               Almmmatg.UndBas
               Almmmatg.MonVta
               F-PRESOLA    WHEN F-PRESOLA <> 0
               F-PREUSSA    WHEN F-PREUSSA <> 0
               Almmmatg.UndA    WHEN Almmmatg.UndA <> ""
               F-PRESOLB    WHEN F-PRESOLB <> 0
               F-PREUSSB    WHEN F-PREUSSB <> 0
               Almmmatg.UndB    WHEN Almmmatg.UndB <> "" 
               F-PRESOLC    WHEN F-PRESOLC <> 0
               F-PREUSSC    WHEN F-PREUSSC <> 0
               Almmmatg.UndC    WHEN Almmmatg.UndC <> ""
               F-PRESOLD    WHEN F-PRESOLD <> 0
               F-PREUSSD    WHEN F-PREUSSD <> 0
               Almmmatg.Chr__01 WHEN Almmmatg.Chr__01 <> ""
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.
       
  END.
  HIDE FRAME F-PROCESO.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-33 W-Win 
PROCEDURE Formato-33 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
               Tempo.codmat  FORMAT "X(6)"
               Tempo.DesMat  FORMAT "X(40)"
               Tempo.DesMar  FORMAT "X(10)"
               Tempo.UndBas  FORMAT "X(8)"
               Tempo.MonVta  FORMAT "9"
               F-PRESOLA        FORMAT ">>>,>>9.9999"
               F-PREUSSA        FORMAT ">>>,>>9.9999"
               Tempo.UndA    FORMAT "X(8)"
               F-PRESOLB        FORMAT ">>>,>>9.9999"
               F-PREUSSB        FORMAT ">>>,>>9.9999"
               Tempo.UndB    FORMAT "X(8)"
               F-PRESOLC        FORMAT ">>>,>>9.9999"
               F-PREUSSC        FORMAT ">>>,>>9.9999"
               Tempo.UndC    FORMAT "X(8)"
               F-PRESOLD        FORMAT ">>>,>>9.9999"
               F-PREUSSD        FORMAT ">>>,>>9.9999"
               Tempo.UndD FORMAT "X(8)"
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
        "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                               PRECIO DE VTA. (A)                PRECIO DE VTA. (B)                 PRECIO DE VTA. (C)                 PRECIO DE VTA. (D)    " SKIP
        "Codigo D  E  S  C  R  I  P  C  I  O  N          MARCA      U.B.  MONEDA        S/.        USS$. UM.              S/.         USS$. UM.              S/.         USS$.  UM.             S/.          USS$.  UM." SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
      WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Tempo BREAK BY Tempo.Codfam
                      BY Tempo.Subfam
                      BY Tempo.CodMar
                      BY Tempo.CodMat:

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(Tempo.CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = Tempo.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT "FAMILIA : " Almtfami.codfam '    ' Almtfami.desfam SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
      IF FIRST-OF(Tempo.SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = s-CodCia 
                        AND  Almsfami.codfam = Tempo.CodFam 
                        AND  Almsfami.subfam = Tempo.Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT "SUB-FAMILIA : " Almsfami.subfam '   ' AlmSFami.dessub SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.

         
      DISPLAY STREAM REPORT 
               Tempo.codmat
               Tempo.DesMat
               Tempo.DesMar
               Tempo.UndBas
               Tempo.MonVta
               F-PRESOLA    WHEN F-PRESOLA <> 0
               F-PREUSSA    WHEN F-PREUSSA <> 0
               Tempo.UndA    WHEN Tempo.UndA <> ""
               F-PRESOLB    WHEN F-PRESOLB <> 0
               F-PREUSSB    WHEN F-PREUSSB <> 0
               Tempo.UndB    WHEN Tempo.UndB <> "" 
               F-PRESOLC    WHEN F-PRESOLC <> 0
               F-PREUSSC    WHEN F-PREUSSC <> 0
               Tempo.UndC    WHEN Tempo.UndC <> ""
               F-PRESOLD    WHEN F-PRESOLD <> 0
               F-PREUSSD    WHEN F-PREUSSD <> 0
               Tempo.UndD   WHEN Tempo.UndD <> ""
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.
       
  END.
  /*
  HIDE FRAME F-PROCESO.
  */

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

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN Carga-Temporal.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    CASE nCodMon:
        WHEN 1 THEN mensaje = "EXPRESADO EN SOLES".
        WHEN 2 THEN mensaje = "EXPRESADO EN DOLARES".
        WHEN 3 THEN mensaje = "EXPRESADO EN SOLES/DOLARES".
    END CASE.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        CASE nCodMon:
            WHEN 1 THEN RUN Formato-11.
            WHEN 2 THEN RUN Formato-22.
            WHEN 3 THEN RUN Formato-33.
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
  ASSIGN DesdeC F-CodFam F-DesFam HastaC nCodMon R-Tipo
         f-cate1 f-cate2 f-cate3 f-cate4 
         f-condi1 f-condi2 f-condi3 f-condi4
         c-tipo1 c-tipo2 c-tipo3 c-tipo4
         c-mos1 c-mos2 c-mos3 c-mos4 .
  
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
     f-cate1:SENSITIVE = FALSE .
     f-cate2:SENSITIVE = FALSE .
     f-cate3:SENSITIVE = FALSE .
     f-cate4:SENSITIVE = FALSE .
     f-condi1:SENSITIVE = FALSE .
     f-condi2:SENSITIVE = FALSE .
     f-condi3:SENSITIVE = FALSE .
     f-condi4:SENSITIVE = FALSE .

    
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

