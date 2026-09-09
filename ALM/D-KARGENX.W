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
DEFINE VAR F-PreIng  AS DECIMAL FORMAT "(>>,>>>,>>9.9999)" NO-UNDO.
DEFINE VAR F-TotIng  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-Salida  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PreSal  AS DECIMAL FORMAT "(>>,>>>,>>9.9999)" NO-UNDO.
DEFINE VAR F-TotSal  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-Saldo   AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-VALCTO  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-STKGEN  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PRECIO  AS DECIMAL FORMAT "(>,>>>,>>9.9999)" NO-UNDO.
DEFINE VAR S-SUBTIT  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR F-SPeso   AS DECIMAL FORMAT "(>,>>>,>>9.99)" NO-UNDO.

DEFINE BUFFER DMOV FOR Almdmov. 

DEFINE VAR I-NROITM  AS INTEGER.

DEFINE TEMP-TABLE  tmp-report LIKE w-report.

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
&Scoped-Define ENABLED-OBJECTS RECT-57 F-CodFam F-SubFam DesdeC HastaC ~
DesdeF HastaF nCodMon R-Tipo x-CatConta x-PorMarca Btn_OK Btn_Cancel ~
BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS F-CodFam F-DesFam F-SubFam F-DesSub DesdeC ~
HastaC DesdeF HastaF nCodMon R-Tipo x-CatConta x-PorMarca 

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

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Button 1" 
     SIZE 12 BY 1.5.

DEFINE VARIABLE x-CatConta AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Cat. Contable" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

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
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 19.43 BY .46 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Activados", "A",
"Desactivados", "D",
"Ambos", ""
     SIZE 12.72 BY 1.73 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.86 BY 8.96.

DEFINE VARIABLE T-Resumen AS LOGICAL INITIAL no 
     LABEL "Total General Resumido" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.57 BY .69 NO-UNDO.

DEFINE VARIABLE x-PorMarca AS LOGICAL INITIAL no 
     LABEL "Ordenado por Marca" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodFam AT ROW 1.58 COL 18 COLON-ALIGNED
     F-DesFam AT ROW 1.58 COL 24.29 COLON-ALIGNED NO-LABEL
     F-SubFam AT ROW 2.35 COL 18 COLON-ALIGNED
     F-DesSub AT ROW 2.35 COL 24.29 COLON-ALIGNED NO-LABEL
     DesdeC AT ROW 3.12 COL 18 COLON-ALIGNED
     HastaC AT ROW 3.12 COL 47 COLON-ALIGNED
     DesdeF AT ROW 3.81 COL 18 COLON-ALIGNED
     HastaF AT ROW 3.81 COL 47 COLON-ALIGNED
     nCodMon AT ROW 4.69 COL 19.86 NO-LABEL
     R-Tipo AT ROW 5.5 COL 19.86 NO-LABEL
     T-Resumen AT ROW 5.62 COL 49
     x-CatConta AT ROW 7.54 COL 18 COLON-ALIGNED
     x-PorMarca AT ROW 8.69 COL 20
     Btn_OK AT ROW 10.42 COL 2
     Btn_Cancel AT ROW 10.42 COL 14.43
     BUTTON-1 AT ROW 10.42 COL 27 WIDGET-ID 2
     "Moneda" VIEW-AS TEXT
          SIZE 6.86 BY .58 AT ROW 4.65 COL 12
          FONT 6
     "Estado" VIEW-AS TEXT
          SIZE 6.86 BY .69 AT ROW 5.58 COL 12
          FONT 1
     "Criterio de Selección" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     RECT-46 AT ROW 10.23 COL 1
     RECT-57 AT ROW 1.19 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 10.92
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
         TITLE              = "Stock Consolidado - LOGISTICO"
         HEIGHT             = 10.92
         WIDTH              = 80
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN F-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX T-Resumen IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       T-Resumen:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Stock Consolidado - LOGISTICO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Stock Consolidado - LOGISTICO */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Texto.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Artículo */
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
  ASSIGN DesdeC DesdeF F-CodFam F-DesFam HastaC HastaF nCodMon T-Resumen R-Tipo
    x-CatConta x-PorMarca.

  IF HastaC <> "" THEN 
    S-SUBTIT = "Materiales del " + DesdeC + " al " + HastaC .
  ELSE 
    S-SUBTIT = "".

  IF HastaC = "" THEN HastaC = "999999999".
    
  S-SUBTIT = "Periodo del " + STRING(DesdeF) + " al " + STRING(HastaF).


  IF HastaC = "" THEN HastaC = "999999".
  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-tempo W-Win 
PROCEDURE Carga-tempo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*DEFINE VAR L-Ubica  AS LOGICAL NO-UNDO INIT YES.
 * DEFINE VAR F-pesini AS DECIMAL NO-UNDO.
 * 
 * IF HastaC = "" THEN HastaC = "999999".
 * I-NROITM = 0.
 * 
 * FOR EACH tmp-report :
 *     DELETE tmp-report.
 * END.
 *     
 * FOR EACH Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
 *                    AND  (Almmmatg.CodMat >= DesdeC  
 *                    AND   Almmmatg.CodMat <= HastaC)
 *                   NO-LOCK USE-INDEX Matg01:
 *     DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Articulo "
 *             FORMAT "X(11)" WITH FRAME F-Proceso.
 *     /* BUSCAMOS SI TIENE MOVIMEINTOS ANTERIORES A DesdeF */
 *     FIND LAST Almdmov WHERE Almdmov.CodCia = Almmmatg.CodCia 
 *                        AND  Almdmov.CodMat = Almmmatg.CodMat 
 *                        AND  Almdmov.FchDoc < DesdeF 
 *                       USE-INDEX Almd02 NO-LOCK NO-ERROR.
 *     /* BUSCAMOS SI TIENE MOVIMEINTOS POSTERIORES A DesdeF */
 *     FIND FIRST DMOV WHERE DMOV.CodCia = Almmmatg.CodCia 
 *                      AND  DMOV.CodMat = Almmmatg.CodMat 
 *                      AND  (DMOV.FchDoc >= DesdeF 
 *                      AND   DMOV.FchDoc <= HastaF)
 *                     USE-INDEX Almd02 NO-LOCK NO-ERROR.
 *     /* SOLO PASAN LOS MATERIALES QUE HAN TENIDO MOVIMIENTO */
 *     IF AVAILABLE Almdmov OR AVAILABLE DMOV THEN DO:
 *        RUN Peso-Inicial(Almmmatg.codmat, OUTPUT F-PesIni).
 *        I-NROITM = I-NROITM + 1.
 *        F-STKGEN = 0.
 *        IF AVAILABLE Almdmov THEN DO:
 *           F-STKGEN = Almdmov.StkAct.
 *           F-VALCTO = IF nCodMon = 1 THEN Almdmov.VctoMn1 ELSE Almdmov.VctoMn2.
 *        END.
 *        F-VALCTO = IF F-STKGEN = 0 THEN 0 ELSE F-VALCTO.
 *        F-PRECIO = IF F-STKGEN = 0 THEN 0 ELSE ROUND(F-VALCTO / F-STKGEN,2).
 *        /* CREAMOS REGISTRO DE SALDO ANTERIOR */
 *        IF F-STKGEN > 0 THEN DO:
 *           CREATE tmp-report.
 *           ASSIGN tmp-report.Llave-I     = INTEGER(Almmmatg.CodMat)
 *                  tmp-report.Llave-c     = "A"
 *                  tmp-report.Campo-c[1]  = " S.I."
 *                  tmp-report.Campo-c[12] = Almmmatg.DesMat
 *                  tmp-report.Campo-c[11] = Almmmatg.UndStk
 *                  tmp-report.Campo-f[7]  = F-STKGEN
 *                  tmp-report.Campo-f[8]  = F-PRECIO
 *                  tmp-report.Campo-f[9]  = F-VALCTO
 *                  tmp-report.Campo-f[10] = F-PesIni.
 *                  tmp-report.Campo-d[1]  = DesdeF - 1.
 *        END.
 *        FOR EACH DMOV WHERE DMOV.CodCia = Almmmatg.CodCia 
 *                       AND  DMOV.CodMat = Almmmatg.CodMat 
 *                       AND  (DMOV.FchDoc >= DesdeF 
 *                       AND   DMOV.FchDoc <= HastaF)
 *                      USE-INDEX Almd02 NO-LOCK:
 *            FIND Almcmov WHERE Almcmov.CodCia = DMOV.CodCia 
 *                          AND  Almcmov.CodAlm = DMOV.CodAlm 
 *                          AND  Almcmov.TipMov = DMOV.TipMov 
 *                          AND  Almcmov.CodMov = DMOV.CodMov 
 *                          AND  Almcmov.NroDoc = DMOV.NroDoc 
 *                         NO-LOCK NO-ERROR.
 *            /* CREAMOS REGISTRO DE MOVIMIENTO */
 *            F-STKGEN = DMOV.StkAct.
 *            F-VALCTO = IF nCodMon = 1 THEN DMOV.VctoMn1 ELSE DMOV.VctoMn2.
 *            F-VALCTO = IF F-STKGEN = 0 THEN 0 ELSE F-VALCTO.
 *            F-PRECIO = IF F-STKGEN = 0 THEN 0 ELSE ROUND(F-VALCTO / F-STKGEN,2).
 *            CREATE tmp-report.
 *            ASSIGN tmp-report.Llave-I    = INTEGER(Almmmatg.CodMat)
 *                   tmp-report.Llave-c    = DMOV.TipMov
 *                   tmp-report.Campo-c[1] = DMOV.CodAlm
 *                   tmp-report.Campo-c[2] = STRING(DMOV.CodMov,"99")
 *                   tmp-report.Campo-c[3] = STRING(DMOV.NroDoc,"999999")
 *                   tmp-report.Campo-f[7] = F-STKGEN
 *                   tmp-report.Campo-f[8] = F-PRECIO
 *                   tmp-report.Campo-f[9] = F-VALCTO
 *                   tmp-report.Campo-c[12] = Almmmatg.DesMat
 *                   tmp-report.Campo-c[11] = Almmmatg.UndStk
 *                   tmp-report.Campo-d[1]  = DMOV.FchDoc.
 *            IF AVAILABLE Almcmov THEN 
 *               ASSIGN tmp-report.Campo-c[4] = Almcmov.CodPro
 *                      tmp-report.Campo-c[5] = Almcmov.CodCli
 *                      tmp-report.Campo-c[6] = IF Almcmov.NroRf1 <> "" THEN Almcmov.NroRf1 ELSE Almcmov.NroRf2.
 *            IF LOOKUP(DMOV.TipMov,"I,U") > 0 THEN 
 *                     ASSIGN tmp-report.Campo-f[1] = DMOV.CanDes 
 *                            tmp-report.Campo-f[2] = DMOV.PreUni 
 *                            tmp-report.Campo-f[3] = DMOV.ImpCto
 *                            tmp-report.Campo-f[10] = DMOV.Candes * DMOV.Pesmat.
 *            IF LOOKUP(DMOV.TipMov,"S,T") > 0 THEN 
 *                     ASSIGN tmp-report.Campo-f[4] = DMOV.CanDes 
 *                            tmp-report.Campo-f[5] = F-PRECIO 
 *                            tmp-report.Campo-f[6] = ROUND(F-PRECIO * DMOV.CanDes,2)
 *                            tmp-report.Campo-f[10] = (DMOV.Candes * DMOV.Pesmat) * -1.
 *        END.
 *     END.
 * END.
 * HIDE FRAME F-PROCESO.*/

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
  DISPLAY F-CodFam F-DesFam F-SubFam F-DesSub DesdeC HastaC DesdeF HastaF 
          nCodMon R-Tipo x-CatConta x-PorMarca 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 F-CodFam F-SubFam DesdeC HastaC DesdeF HastaF nCodMon R-Tipo 
         x-CatConta x-PorMarca Btn_OK Btn_Cancel BUTTON-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
  DEFINE VARIABLE S-CODMOV AS CHAR NO-UNDO. 
  DEFINE VARIABLE x-codpro LIKE Almcmov.codpro NO-UNDO.
  DEFINE VARIABLE x-codcli LIKE Almcmov.codcli NO-UNDO.
  DEFINE VARIABLE x-nrorf1 LIKE Almcmov.nrorf1 NO-UNDO.
  DEFINE VARIABLE x-nrorf2 LIKE Almcmov.nrorf2 NO-UNDO.
  DEFINE VARIABLE x-codmov LIKE Almcmov.codmov NO-UNDO.

  DEFINE VARIABLE x-inigen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-inggen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-salgen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-totgen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-codmon LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-tpocmb LIKE Almdmov.candes NO-UNDO.

  def var x-total as decimal.
  def var x-codmat as char init "".  

  DEFINE VAR x-Ingreso AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
  DEFINE VAR x-Salida  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
  DEFINE VAR x-Saldo   AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.

  /* Tipo de movimiento de la salida por G/R */
  FIND FacDocum WHERE FacDocum.CodCia = s-codcia 
                 AND  FacDocum.CodDoc = 'G/R' 
                NO-LOCK NO-ERROR.
  IF AVAILABLE FacDocum THEN x-codmov = FacDocum.CodMov.
  
  DEFINE FRAME F-QUIEBRE
    Almmmatg.codmat AT 2 FORMAT 'x(9)'
    Almmmatg.desmat AT 14 FORMAT 'x(50)'
    Almmmatg.desmar AT 65 FORMAT 'x(35)'
    Almmmatg.undstk AT 105 FORMAT 'x(4)'
    f-Saldo AT 110 SKIP(1)
    WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO.

  DEFINE FRAME F-REPORTE
         Almdmov.CodAlm COLUMN-LABEL "Cod!Alm"           FORMAT "X(3)"
         S-CODMOV       COLUMN-LABEL "Cod!Mov"           FORMAT "X(3)"
         Almdmov.NroDoc COLUMN-LABEL "Numero!Docmto"     format ">>>>>>>>9"
         Almdmov.Almori FORMAT "X(3)" 
         x-CodPro       COLUMN-LABEL "Codigo!Proveedor" 
         x-CodCli       COLUMN-LABEL "Codigo!Cliente"   
         x-NroRf1       COLUMN-LABEL "Referencia"       FORMAT 'x(15)'
         x-NroRf2       COLUMN-LABEL "Referencia"       FORMAT 'x(15)'
         Almdmov.FchDoc COLUMN-LABEL "Fecha!Documento"
         F-Ingreso      COLUMN-LABEL "Ingresos" 
         F-Salida       COLUMN-LABEL "Salidas"  
         F-Saldo        COLUMN-LABEL "Saldos"   
    WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-QUIEBRE-2
         x-Ingreso       AT 78
         x-Salida       
         x-Saldo        
    WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
                
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP
         "KARDEX GENERAL" AT 50
         "Pagina :" TO 90 PAGE-NUMBER(REPORT) TO 102 FORMAT "ZZZZZ9" SKIP
         "Fecha  :" TO 90 TODAY TO 102 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 90 STRING(TIME,"HH:MM") TO 102 SKIP
         S-SUBTIT AT 1       SKIP
         "-------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "Cod Cod Numero Alm      Codigo   Codigo                                      Fecha de        -- INGRESOS -   - SALIDAS --   -- SALDOS ---- " SKIP
         "Alm Mov Docmto Ori/Des Proveedor Cliente       Referencia     Referencia     Documento         Cantidad        Cantidad       Cantidad     " SKIP
         "-------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*
                   1         2         3         4         5         6         7         8         9         10       11
          1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
           123456789   12345678901234567890123456789012345678901234567890 12345678901234567890123456789012345     1234 (>>,>>>,>>9.99) 
                                                                                       (>>,>>>,>>9.99) (>>,>>>,>>9.99) (>>,>>>,>>9.99)
*/          
          
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
       
  ASSIGN
     x-inigen = 0
     x-inggen = 0
     x-salgen = 0
     x-totgen = 0.
     x-codmat = "".
     x-total = 0.

  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
        AND  Almmmatg.CodMat >= DesdeC  
        AND  Almmmatg.CodMat <= HastaC  
        AND  Almmmatg.codfam BEGINS F-CodFam 
        AND  Almmmatg.TpoArt BEGINS R-Tipo
        AND (x-CatConta = 'Todos' OR Almmmatg.catconta[1] = x-CatConta)
        BREAK BY Almmmatg.CodCia 
                BY Almmmatg.CodFam
                BY Almmmatg.Ordlis
                BY Almmmatg.CodMat:
    VIEW STREAM REPORT FRAME F-HEADER.
    IF FIRST-OF(Almmmatg.codmat) THEN DO:
        F-STKGEN = 0.
        F-Saldo = 0.

        
        FIND LAST Almstkge WHERE Almstkge.codcia = s-codcia
            AND Almstkge.codmat = Almmmatg.codmat
            AND Almstkge.fecha < DesdeF
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almstkge 
        THEN ASSIGN
                f-StkGen = Almstkge.stkact
                f-ValCto = Almstkge.stkact * AlmStkge.CtoUni.

        /* RHC 20.05.08 ************************************** */
        f-Saldo = 0.
        FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
                AND Almacen.flgrep = Yes
                AND Almacen.almcsg = No:
            FIND LAST Almstkal WHERE Almstkal.codcia = s-codcia
                AND Almstkal.codalm = Almacen.codalm
                AND Almstkal.codmat = Almmmatg.codmat
                AND Almstkal.fecha < DesdeF
                NO-LOCK NO-ERROR.

            /*IF AVAILABLE Almstkal THEN f-Saldo = f-Saldo + Almstkal.stkact.*/
            IF AVAILABLE Almstkal THEN DO:
                IF Almstkal.stkact > 0 THEN f-Saldo = f-Saldo + Almstkal.stkact.
            END.

        END.
        /* **************************************************** */

        F-VALCTO = IF F-STKGEN = 0 THEN 0 ELSE F-VALCTO.
        F-PRECIO = IF F-STKGEN = 0 THEN 0 ELSE ROUND(F-VALCTO / F-STKGEN,4).
        DISPLAY STREAM REPORT
            Almmmatg.CodMat 
            Almmmatg.DesMat 
            Almmmatg.DesMar
            Almmmatg.UndStk 
            F-Saldo         
            WITH FRAME F-QUIEBRE.
        ASSIGN
            x-Ingreso = 0
            x-Salida  = 0
            x-Saldo   = f-Saldo.
    END.
    FOR EACH Almdmov NO-LOCK USE-INDEX ALMD02 WHERE Almdmov.CodCia = Almmmatg.CodCia 
            AND  Almdmov.codmat = Almmmatg.CodMat 
            AND  Almdmov.FchDoc >= DesdeF 
            AND  Almdmov.FchDoc <= HastaF,
            FIRST Almacen OF Almdmov NO-LOCK WHERE Almacen.FlgRep = YES AND Almacen.AlmCsg = NO:
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" 
              WITH FRAME F-Proceso.
      VIEW STREAM REPORT FRAME F-HEADER.
      x-codpro = "".
      x-codcli = "".
      x-nrorf1 = "".
      x-nrorf2 = "".
      FIND Almcmov WHERE Almcmov.CodCia = Almdmov.codcia 
                    AND  Almcmov.CodAlm = Almdmov.codalm 
                    AND  Almcmov.TipMov = Almdmov.tipmov 
                    AND  Almcmov.CodMov = Almdmov.codmov 
                    AND  Almcmov.NroDoc = Almdmov.nrodoc 
                   NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almcmov THEN DO:
         IF Almdmov.CodMov = x-codmov THEN DO:
            FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia 
                           AND  CcbCDocu.CodDoc = 'G/R' 
                           AND  CcbCDocu.NroDoc = STRING(Almdmov.nroser,'999') + STRING(Almdmov.Nrodoc,'999999') 
                          NO-LOCK NO-ERROR.
            IF AVAILABLE CcbCDocu THEN 
               ASSIGN
                  x-codcli = CcbCDocu.codcli
                  x-nrorf1 = CcbCDocu.Nroped.
            END.
            x-codmon = 1.
            x-tpocmb = 1.
         END.
      ELSE 
         ASSIGN
            x-codpro = Almcmov.codpro
            x-codcli = Almcmov.codcli
            x-nrorf1 = Almcmov.nrorf1
            x-nrorf2 = Almcmov.nrorf2
            x-codmon = Almcmov.codmon
            x-tpocmb = Almcmov.tpocmb.
                 
      S-CODMOV  = Almdmov.TipMov + STRING(Almdmov.CodMov,"99"). 
      F-Ingreso = IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 
                    THEN (Almdmov.CanDes * Almdmov.Factor) 
                    ELSE 0.
      F-PreIng  = 0.
      F-TotIng  = 0.
      IF nCodmon = x-Codmon THEN DO:
         IF Almdmov.Tipmov = 'I' THEN DO:
            F-PreIng  = Almdmov.PreUni / Almdmov.Factor.
            F-TotIng  = Almdmov.ImpCto.
         END.
         IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
            F-PreIng  = ROUND(F-VALCTO / F-STKGEN,4).
            F-TotIng  = F-PreIng * F-Ingreso.
         END.
         END.
      ELSE DO:
         IF nCodmon = 1 THEN DO:
            IF Almdmov.Tipmov = 'I' THEN DO:
               F-PreIng  = ROUND(Almdmov.PreUni * x-Tpocmb / Almdmov.Factor, 4).
               F-TotIng  = (Almdmov.ImpCto * x-Tpocmb).
            END.
            IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
               F-PreIng  = ROUND(F-VALCTO / F-STKGEN,4).
               F-TotIng  = F-PreIng * F-Ingreso.
            END.
            END.
         ELSE DO:
            IF Almdmov.Tipmov = 'I' THEN DO:
               F-PreIng  = ROUND(Almdmov.PreUni / x-Tpocmb / Almdmov.Factor, 4).
               F-TotIng  = ROUND(Almdmov.ImpCto / x-Tpocmb, 2).
            END.
            IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
               F-PreIng  = ROUND(F-VALCTO / F-STKGEN,4).
               F-TotIng  = F-PreIng * F-Ingreso.
            END.
         END.
      END.
      F-Salida  = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 
                    THEN (Almdmov.CanDes * Almdmov.Factor) 
                    ELSE 0.
      F-Saldo   = F-Saldo + F-Ingreso - F-Salida.
      F-STKGEN = Almdmov.StkAct.    /* RHC 18.05.04 */
      F-VALCTO = Almdmov.StkAct * Almdmov.VCtoMn1.  /* RHC 18.05.04 */
      F-VALCTO = IF F-STKGEN = 0 THEN 0 ELSE F-VALCTO.
      F-PRECIO = IF F-STKGEN = 0 THEN 0 ELSE ROUND(F-VALCTO / F-STKGEN,4).
      F-PreSal = F-PRECIO.
      F-TotSal = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN ROUND(F-Salida * F-PreSal,2) ELSE 0.
  
        ASSIGN
            x-Ingreso = x-Ingreso + f-Ingreso
            x-Salida  = x-Salida  + f-Salida
            x-Saldo   = f-Saldo.        
      ACCUMULATE F-Ingreso (TOTAL BY Almmmatg.CodMat).
      ACCUMULATE F-Salida  (TOTAL BY Almmmatg.CodMat).
      ACCUMULATE F-TotIng  (TOTAL BY Almmmatg.CodMat).
      ACCUMULATE F-TotSal  (TOTAL BY Almmmatg.CodMat).
      
      DISPLAY STREAM REPORT 
               Almdmov.CodAlm 
               S-CODMOV  
               Almdmov.NroDoc 
               Almdmov.Almori WHEN Almdmov.Codmov = 03
               x-CodPro 
               x-CodCli 
               x-NroRf1 
               x-NroRf2 
               Almdmov.FchDoc 
               F-Ingreso WHEN F-Ingreso > 0 
               F-Salida  WHEN F-Salida > 0
               F-Saldo   WHEN F-Saldo > 0
               WITH FRAME F-REPORTE.
    END.  
    IF LAST-OF(Almmmatg.CodMat) THEN DO:
       UNDERLINE STREAM REPORT 
              x-Ingreso 
              x-Salida 
              x-Saldo 
              WITH FRAME F-QUIEBRE-2.
    
       DISPLAY STREAM  REPORT 
               x-Ingreso 
               x-Salida  
               x-Saldo 
               WITH FRAME F-QUIEBRE-2.
       UNDERLINE STREAM REPORT 
              x-Ingreso 
              x-Salida 
              x-Saldo 
              WITH FRAME F-QUIEBRE-2.
       DOWN STREAM REPORT WITH FRAME F-QUIEBRE-2.
       x-inggen = x-inggen + x-Ingreso.
       x-salgen = x-salgen + x-Salida.
    END.
  END.
  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato3a W-Win 
PROCEDURE Formato3a :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE S-CODMOV AS CHAR NO-UNDO. 
  DEFINE VARIABLE x-codpro LIKE Almcmov.codpro NO-UNDO.
  DEFINE VARIABLE x-codcli LIKE Almcmov.codcli NO-UNDO.
  DEFINE VARIABLE x-nrorf1 LIKE Almcmov.nrorf1 NO-UNDO.
  DEFINE VARIABLE x-nrorf2 LIKE Almcmov.nrorf2 NO-UNDO.
  DEFINE VARIABLE x-codmov LIKE Almcmov.codmov NO-UNDO.

  DEFINE VARIABLE x-inigen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-inggen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-salgen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-totgen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-codmon LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-tpocmb LIKE Almdmov.candes NO-UNDO.

  def var x-total as decimal.
  def var x-codmat as char init "".  

  DEFINE VAR x-Ingreso AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
  DEFINE VAR x-Salida  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
  DEFINE VAR x-Saldo   AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.

  /* Tipo de movimiento de la salida por G/R */
  FIND FacDocum WHERE FacDocum.CodCia = s-codcia 
                 AND  FacDocum.CodDoc = 'G/R' 
                NO-LOCK NO-ERROR.
  IF AVAILABLE FacDocum THEN x-codmov = FacDocum.CodMov.
  
  DEFINE FRAME F-QUIEBRE
    Almmmatg.codmat AT 2 FORMAT 'x(9)'
    Almmmatg.desmat AT 14 FORMAT 'x(50)'
    Almmmatg.desmar AT 65 FORMAT 'x(35)'
    Almmmatg.undstk AT 105 FORMAT 'x(7)'
    f-Saldo AT 110 SKIP(1)
    WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO.

  DEFINE FRAME F-REPORTE
         Almdmov.CodAlm COLUMN-LABEL "Cod!Alm"           FORMAT "X(3)"
         S-CODMOV       COLUMN-LABEL "Cod!Mov"           FORMAT "X(3)"
         Almdmov.NroDoc COLUMN-LABEL "Numero!Docmto"     format ">>>>>>>>9"
         Almdmov.Almori FORMAT "X(3)" 
         x-CodPro       COLUMN-LABEL "Codigo!Proveedor" 
         x-CodCli       COLUMN-LABEL "Codigo!Cliente"   
         x-NroRf1       COLUMN-LABEL "Referencia"       FORMAT 'x(15)'
         x-NroRf2       COLUMN-LABEL "Referencia"       FORMAT 'x(15)'
         Almdmov.FchDoc COLUMN-LABEL "Fecha!Documento"
         F-Ingreso      COLUMN-LABEL "Ingresos" 
         F-Salida       COLUMN-LABEL "Salidas"  
         F-Saldo        COLUMN-LABEL "Saldos"   
    WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-QUIEBRE-2
         x-Ingreso       AT 78
         x-Salida       
         x-Saldo        
    WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
                
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP
         "KARDEX GENERAL" AT 50
         "Pagina :" TO 90 PAGE-NUMBER(REPORT) TO 102 FORMAT "ZZZZZ9" SKIP
         "Fecha  :" TO 90 TODAY TO 102 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 90 STRING(TIME,"HH:MM") TO 102 SKIP
         S-SUBTIT AT 1       SKIP
         "-------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "Cod Cod Numero Alm      Codigo   Codigo                                      Fecha de        -- INGRESOS -   - SALIDAS --   -- SALDOS ---- " SKIP
         "Alm Mov Docmto Ori/Des Proveedor Cliente       Referencia     Referencia     Documento         Cantidad        Cantidad       Cantidad     " SKIP
         "-------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*
                   1         2         3         4         5         6         7         8         9         10       11
          1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
           123456789   12345678901234567890123456789012345678901234567890 12345678901234567890123456789012345     1234 (>>,>>>,>>9.99) 
                                                                                       (>>,>>>,>>9.99) (>>,>>>,>>9.99) (>>,>>>,>>9.99)
*/          
          
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
       
  ASSIGN
     x-inigen = 0
     x-inggen = 0
     x-salgen = 0
     x-totgen = 0.
     x-codmat = "".
     x-total = 0.

  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
        AND  Almmmatg.CodMat >= DesdeC  
        AND  Almmmatg.CodMat <= HastaC  
        AND  Almmmatg.codfam BEGINS F-CodFam 
        AND  Almmmatg.TpoArt BEGINS R-Tipo
        AND (x-CatConta = 'Todos' OR Almmmatg.catconta[1] = x-CatConta)
        BREAK BY Almmmatg.CodCia 
                BY Almmmatg.DesMar
                BY Almmmatg.CodMat:
    VIEW STREAM REPORT FRAME F-HEADER.
    IF FIRST-OF(Almmmatg.codmat) THEN DO:
        /* BUSCAMOS SI TIENE MOVIMIENTOS ANTERIORES A DesdeF */
        FIND LAST DMOV WHERE DMOV.CodCia = Almmmatg.CodCia 
                        AND  DMOV.CodMat = Almmmatg.CodMat 
                        AND  DMOV.FchDoc < DesdeF 
                       USE-INDEX Almd02 NO-LOCK NO-ERROR.
        F-STKGEN = 0.
        F-Saldo = 0.
        IF AVAILABLE DMOV THEN DO:
           x-inigen = x-inigen + DMOV.StkActCbd.
           F-STKGEN = DMOV.StkActCbd.
           F-Saldo  = DMOV.StkActCbd.
           F-VALCTO = IF nCodMon = 1 THEN DMOV.Vctomn1Cbd ELSE DMOV.Vctomn2Cbd.
           /* RHC 18.05.04 */
           F-STKGEN = DMOV.StkAct.
           F-VALCTO = DMOV.StkAct * DMOV.VCtoMn1.
        END.

        /* RHC 18.05.04  ************************************* */
        F-Saldo = 0.
        FIND LAST AlmStkGe WHERE AlmStkge.CodCia = almmmatg.codcia 
            AND AlmStkge.codmat = almmmatg.codmat
            AND AlmStkge.Fecha < DesdeF
            NO-LOCK NO-ERROR.
        IF AVAILABLE AlmStkGe THEN F-Saldo = AlmStkGe.StkAct.
        /* ***************************************************** */
        F-VALCTO = IF F-STKGEN = 0 THEN 0 ELSE F-VALCTO.
        F-PRECIO = IF F-STKGEN = 0 THEN 0 ELSE ROUND(F-VALCTO / F-STKGEN,4).
        DISPLAY STREAM REPORT
            Almmmatg.CodMat 
            Almmmatg.DesMat 
            Almmmatg.DesMar
            Almmmatg.UndStk 
            F-Saldo         
            WITH FRAME F-QUIEBRE.
        ASSIGN
            x-Ingreso = 0
            x-Salida  = 0
            x-Saldo   = f-Saldo.
    END.
    FOR EACH Almdmov NO-LOCK USE-INDEX ALMD02 WHERE Almdmov.CodCia = Almmmatg.CodCia 
            AND  Almdmov.codmat = Almmmatg.CodMat 
            AND  Almdmov.FchDoc >= DesdeF 
            AND  Almdmov.FchDoc <= HastaF,
            FIRST Almacen NO-LOCK WHERE Almacen.Codcia = 1 
                AND Almacen.Codalm = Almdmov.Codalm
                AND Almacen.FlgRep = YES:
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" 
              WITH FRAME F-Proceso.
      VIEW STREAM REPORT FRAME F-HEADER.
      x-codpro = "".
      x-codcli = "".
      x-nrorf1 = "".
      x-nrorf2 = "".
      FIND Almcmov WHERE Almcmov.CodCia = Almdmov.codcia 
                    AND  Almcmov.CodAlm = Almdmov.codalm 
                    AND  Almcmov.TipMov = Almdmov.tipmov 
                    AND  Almcmov.CodMov = Almdmov.codmov 
                    AND  Almcmov.NroDoc = Almdmov.nrodoc 
                   NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almcmov THEN DO:
         IF Almdmov.CodMov = x-codmov THEN DO:
            FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia 
                           AND  CcbCDocu.CodDoc = 'G/R' 
                           AND  CcbCDocu.NroDoc = STRING(Almdmov.nroser,'999') + STRING(Almdmov.Nrodoc,'999999') 
                          NO-LOCK NO-ERROR.
            IF AVAILABLE CcbCDocu THEN 
               ASSIGN
                  x-codcli = CcbCDocu.codcli
                  x-nrorf1 = CcbCDocu.Nroped.
            END.
            x-codmon = 1.
            x-tpocmb = 1.
         END.
      ELSE 
         ASSIGN
            x-codpro = Almcmov.codpro
            x-codcli = Almcmov.codcli
            x-nrorf1 = Almcmov.nrorf1
            x-nrorf2 = Almcmov.nrorf2
            x-codmon = Almcmov.codmon
            x-tpocmb = Almcmov.tpocmb.
                 
      S-CODMOV  = Almdmov.TipMov + STRING(Almdmov.CodMov,"99"). 
      F-Ingreso = IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
      F-PreIng  = 0.
      F-TotIng  = 0.
      IF nCodmon = x-Codmon THEN DO:
         IF Almdmov.Tipmov = 'I' THEN DO:
            F-PreIng  = Almdmov.PreUni / Almdmov.Factor.
            F-TotIng  = Almdmov.ImpCto.
         END.
         IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
            F-PreIng  = ROUND(F-VALCTO / F-STKGEN,4).
            F-TotIng  = F-PreIng * F-Ingreso.
         END.
         END.
      ELSE DO:
         IF nCodmon = 1 THEN DO:
            IF Almdmov.Tipmov = 'I' THEN DO:
               F-PreIng  = ROUND(Almdmov.PreUni * x-Tpocmb / Almdmov.Factor, 4).
               F-TotIng  = (Almdmov.ImpCto * x-Tpocmb).
            END.
            IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
               F-PreIng  = ROUND(F-VALCTO / F-STKGEN,4).
               F-TotIng  = F-PreIng * F-Ingreso.
            END.
            END.
         ELSE DO:
            IF Almdmov.Tipmov = 'I' THEN DO:
               F-PreIng  = ROUND(Almdmov.PreUni / x-Tpocmb / Almdmov.Factor, 4).
               F-TotIng  = ROUND(Almdmov.ImpCto / x-Tpocmb, 2).
            END.
            IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
               F-PreIng  = ROUND(F-VALCTO / F-STKGEN,4).
               F-TotIng  = F-PreIng * F-Ingreso.
            END.
         END.
      END.
      F-Salida  = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
      F-Saldo   = F-Saldo + F-Ingreso - F-Salida.
      F-STKGEN = Almdmov.StkAct.    /* RHC 18.05.04 */
      F-VALCTO = Almdmov.StkAct * Almdmov.VCtoMn1.  /* RHC 18.05.04 */
      F-VALCTO = IF F-STKGEN = 0 THEN 0 ELSE F-VALCTO.
      F-PRECIO = IF F-STKGEN = 0 THEN 0 ELSE ROUND(F-VALCTO / F-STKGEN,4).
      F-PreSal = F-PRECIO.
      F-TotSal = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN ROUND(F-Salida * F-PreSal,2) ELSE 0.
  
        ASSIGN
            x-Ingreso = x-Ingreso + f-Ingreso
            x-Salida  = x-Salida  + f-Salida
            x-Saldo   = f-Saldo.        
      ACCUMULATE F-Ingreso (TOTAL BY Almmmatg.CodMat).
      ACCUMULATE F-Salida  (TOTAL BY Almmmatg.CodMat).
      ACCUMULATE F-TotIng  (TOTAL BY Almmmatg.CodMat).
      ACCUMULATE F-TotSal  (TOTAL BY Almmmatg.CodMat).
      
      DISPLAY STREAM REPORT 
               Almdmov.CodAlm 
               S-CODMOV  
               Almdmov.NroDoc 
               Almdmov.Almori WHEN Almdmov.Codmov = 03
               x-CodPro 
               x-CodCli 
               x-NroRf1 
               x-NroRf2 
               Almdmov.FchDoc 
               F-Ingreso WHEN F-Ingreso > 0 
               F-Salida  WHEN F-Salida > 0
               F-Saldo   WHEN F-Saldo > 0
               WITH FRAME F-REPORTE.
    END.  
    IF LAST-OF(Almmmatg.CodMat) THEN DO:
       UNDERLINE STREAM REPORT 
              x-Ingreso 
              x-Salida 
              x-Saldo 
              WITH FRAME F-QUIEBRE-2.
    
       DISPLAY STREAM  REPORT 
               x-Ingreso 
               x-Salida  
               x-Saldo 
               WITH FRAME F-QUIEBRE-2.
       UNDERLINE STREAM REPORT 
              x-Ingreso 
              x-Salida 
              x-Saldo 
              WITH FRAME F-QUIEBRE-2.
       DOWN STREAM REPORT WITH FRAME F-QUIEBRE-2.
       x-inggen = x-inggen + x-Ingreso.
       x-salgen = x-salgen + x-Salida.
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
        IF x-PorMarca = YES THEN RUN Formato3a.
        ELSE RUN Formato3.
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
  ASSIGN DesdeC DesdeF F-CodFam F-DesFam HastaC HastaF nCodMon T-Resumen R-Tipo.
  
  IF HastaC <> "" THEN HastaC = "".
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN DesdeF = TODAY  + 1 - DAY(TODAY).
            HastaF = TODAY.
            R-Tipo = ''.
     DISPLAY DesdeF HastaF R-Tipo.
    FOR EACH Almtabla WHERE Almtabla.Tabla  = "CC" NO-LOCK:
        x-CatConta:ADD-LAST(Almtabla.Codigo).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE S-CODMOV AS CHAR NO-UNDO. 
  DEFINE VARIABLE x-codpro LIKE Almcmov.codpro NO-UNDO.
  DEFINE VARIABLE x-codcli LIKE Almcmov.codcli NO-UNDO.
  DEFINE VARIABLE x-nrorf1 LIKE Almcmov.nrorf1 NO-UNDO.
  DEFINE VARIABLE x-nrorf2 LIKE Almcmov.nrorf2 NO-UNDO.
  DEFINE VARIABLE x-codmov LIKE Almcmov.codmov NO-UNDO.

  DEFINE VARIABLE x-inigen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-inggen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-salgen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-totgen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-codmon LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-tpocmb LIKE Almdmov.candes NO-UNDO.

  def var x-total as decimal.
  def var x-codmat as char init "".  

  DEFINE VAR x-Ingreso AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
  DEFINE VAR x-Salida  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
  DEFINE VAR x-Saldo   AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.

  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Rpta    AS LOG  NO-UNDO.

  x-Archivo = 'KardexLogistico.txt'.
  SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Texto' '*.txt'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.txt'
    INITIAL-DIR 'c:\tmp'
    RETURN-TO-START-DIR 
    USE-FILENAME
    SAVE-AS
    UPDATE x-rpta.
  IF x-rpta = NO THEN RETURN.

  OUTPUT STREAM REPORT TO VALUE(x-Archivo).

    PUT STREAM REPORT UNFORMATTED
        "CODIGO|"
        "DESCRIPCION|"
        "MARCA|"
        "UM|"
        "ALMACEN|"
        "CODMOV|"
        "NUMERO|"
        "ALM ORIGEN|"
        "PROVEEDOR|"
        "CLIENTE|"
        "REFERENCIA 1|"
        "REFERENCIA 2|"
        "FECHA|"
        "INGRESO|"
        "SALIDA|"
        SKIP.
       
    ASSIGN
       x-inigen = 0
       x-inggen = 0
       x-salgen = 0
       x-totgen = 0.
       x-codmat = "".
       x-total = 0.
 
  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
      AND Almmmatg.codmat >= DesdeC
      AND Almmmatg.codmat <= HastaC
      AND Almmmatg.codfam BEGINS F-CodFam 
      AND  Almmmatg.TpoArt BEGINS R-Tipo
      AND (x-CatConta = 'Todos' OR Almmmatg.catconta[1] = x-CatConta):
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" 
              WITH FRAME F-Proceso.
    FOR EACH Almdmov NO-LOCK USE-INDEX ALMD02 WHERE Almdmov.CodCia = s-CodCia 
            AND  Almdmov.CodMat = Almmmatg.codmat
            AND  Almdmov.FchDoc >= DesdeF 
            AND  Almdmov.FchDoc <= HastaF,
            FIRST Almacen OF Almdmov NO-LOCK WHERE Almacen.FlgRep = YES AND Almacen.AlmCsg = NO:
      x-codpro = "".
      x-codcli = "".
      x-nrorf1 = "".
      x-nrorf2 = "".
      FIND Almcmov WHERE Almcmov.CodCia = Almdmov.codcia 
                    AND  Almcmov.CodAlm = Almdmov.codalm 
                    AND  Almcmov.TipMov = Almdmov.tipmov 
                    AND  Almcmov.CodMov = Almdmov.codmov 
                    AND  Almcmov.NroDoc = Almdmov.nrodoc 
                   NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almcmov THEN DO:
         IF Almdmov.CodMov = x-codmov THEN DO:
            FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia 
                           AND  CcbCDocu.CodDoc = 'G/R' 
                           AND  CcbCDocu.NroDoc = STRING(Almdmov.nroser,'999') + STRING(Almdmov.Nrodoc,'999999') 
                          NO-LOCK NO-ERROR.
            IF AVAILABLE CcbCDocu THEN 
               ASSIGN
                  x-codcli = CcbCDocu.codcli
                  x-nrorf1 = CcbCDocu.Nroped.
            END.
            x-codmon = 1.
            x-tpocmb = 1.
         END.
      ELSE 
         ASSIGN
            x-codpro = Almcmov.codpro
            x-codcli = Almcmov.codcli
            x-nrorf1 = Almcmov.nrorf1
            x-nrorf2 = Almcmov.nrorf2
            x-codmon = Almcmov.codmon
            x-tpocmb = Almcmov.tpocmb.
                 
      F-Ingreso = IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0
                    THEN (Almdmov.CanDes * Almdmov.Factor)
                    ELSE 0.
      F-Salida  = IF LOOKUP(Almdmov.TipMov,"S,T") > 0
                    THEN (Almdmov.CanDes * Almdmov.Factor)
                    ELSE 0.
      
     S-CODMOV  = Almdmov.TipMov + STRING(Almdmov.CodMov,"99"). 
      
     PUT STREAM REPORT UNFORMATTED
         Almmmatg.CodMat "|"
         Almmmatg.DesMat "|"
         Almmmatg.DesMar "|"
         Almmmatg.UndStk "|"
         Almdmov.CodAlm  "|"
         S-CODMOV "|"
         Almdmov.NroDoc "|".
     IF Almdmov.Codmov = 03 THEN PUT STREAM REPORT UNFORMATTED Almdmov.Almori "|".
     ELSE PUT STREAM REPORT UNFORMATTED "|".
     PUT STREAM REPORT UNFORMATTED
         x-CodPro "|"
         x-CodCli "|"
         x-NroRf1 "|"
         x-NroRf2 "|"
         Almdmov.FchDoc "|"
         F-Ingreso "|"
         F-Salida "|"
         SKIP.
    END.  
  END.

  HIDE FRAME F-PROCESO.
  OUTPUT STREAM REPORT CLOSE.
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TextoBackup W-Win 
PROCEDURE TextoBackup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE S-CODMOV AS CHAR NO-UNDO. 
  DEFINE VARIABLE x-codpro LIKE Almcmov.codpro NO-UNDO.
  DEFINE VARIABLE x-codcli LIKE Almcmov.codcli NO-UNDO.
  DEFINE VARIABLE x-nrorf1 LIKE Almcmov.nrorf1 NO-UNDO.
  DEFINE VARIABLE x-nrorf2 LIKE Almcmov.nrorf2 NO-UNDO.
  DEFINE VARIABLE x-codmov LIKE Almcmov.codmov NO-UNDO.

  DEFINE VARIABLE x-inigen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-inggen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-salgen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-totgen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-codmon LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-tpocmb LIKE Almdmov.candes NO-UNDO.

  def var x-total as decimal.
  def var x-codmat as char init "".  

  DEFINE VAR x-Ingreso AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
  DEFINE VAR x-Salida  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
  DEFINE VAR x-Saldo   AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
  
  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
        AND  Almmmatg.CodMat >= DesdeC  
        AND  Almmmatg.CodMat <= HastaC  
        AND  Almmmatg.codfam BEGINS F-CodFam 
        AND  Almmmatg.TpoArt BEGINS R-Tipo
        AND (x-CatConta = 'Todos' OR Almmmatg.catconta[1] = x-CatConta)
        BREAK BY Almmmatg.CodCia 
                BY Almmmatg.CodFam
                BY Almmmatg.Ordlis
                BY Almmmatg.CodMat:
/*     IF FIRST-OF(Almmmatg.codmat) THEN DO:                                    */
/*         F-STKGEN = 0.                                                        */
/*         F-Saldo = 0.                                                         */
/*         FIND LAST Almstkge WHERE Almstkge.codcia = s-codcia                  */
/*             AND Almstkge.codmat = Almmmatg.codmat                            */
/*             AND Almstkge.fecha < DesdeF                                      */
/*             NO-LOCK NO-ERROR.                                                */
/*         IF AVAILABLE Almstkge                                                */
/*         THEN ASSIGN                                                          */
/*                 f-StkGen = Almstkge.stkact                                   */
/*                 f-ValCto = Almstkge.stkact * AlmStkge.CtoUni.                */
/*         f-Saldo = 0.                                                         */
/*         FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia             */
/*                 AND Almacen.flgrep = Yes                                     */
/*                 AND Almacen.almcsg = No:                                     */
/*             FIND LAST Almstkal WHERE Almstkal.codcia = s-codcia              */
/*                 AND Almstkal.codalm = Almacen.codalm                         */
/*                 AND Almstkal.codmat = Almmmatg.codmat                        */
/*                 AND Almstkal.fecha < DesdeF                                  */
/*                 NO-LOCK NO-ERROR.                                            */
/*             IF AVAILABLE Almstkal THEN f-Saldo = f-Saldo + Almstkal.stkact.  */
/*         END.                                                                 */
/*         /* **************************************************** */           */
/*                                                                              */
/*         F-VALCTO = IF F-STKGEN = 0 THEN 0 ELSE F-VALCTO.                     */
/*         F-PRECIO = IF F-STKGEN = 0 THEN 0 ELSE ROUND(F-VALCTO / F-STKGEN,4). */
/*                                                                              */
/*         ASSIGN                                                               */
/*             x-Ingreso = 0                                                    */
/*             x-Salida  = 0                                                    */
/*             x-Saldo   = f-Saldo.                                             */
/*     END.                                                                     */
    FOR EACH Almdmov NO-LOCK USE-INDEX ALMD02 WHERE Almdmov.CodCia = Almmmatg.CodCia 
            AND  Almdmov.codmat = Almmmatg.CodMat 
            AND  Almdmov.FchDoc >= DesdeF 
            AND  Almdmov.FchDoc <= HastaF,
            FIRST Almacen OF Almdmov NO-LOCK WHERE Almacen.FlgRep = YES AND Almacen.AlmCsg = NO:
        DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
                FORMAT "X(11)" 
                WITH FRAME F-Proceso.
      x-codpro = "".
      x-codcli = "".
      x-nrorf1 = "".
      x-nrorf2 = "".
      FIND Almcmov WHERE Almcmov.CodCia = Almdmov.codcia 
                    AND  Almcmov.CodAlm = Almdmov.codalm 
                    AND  Almcmov.TipMov = Almdmov.tipmov 
                    AND  Almcmov.CodMov = Almdmov.codmov 
                    AND  Almcmov.NroDoc = Almdmov.nrodoc 
                   NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almcmov THEN DO:
         IF Almdmov.CodMov = x-codmov THEN DO:
            FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia 
                           AND  CcbCDocu.CodDoc = 'G/R' 
                           AND  CcbCDocu.NroDoc = STRING(Almdmov.nroser,'999') + STRING(Almdmov.Nrodoc,'999999') 
                          NO-LOCK NO-ERROR.
            IF AVAILABLE CcbCDocu THEN 
               ASSIGN
                  x-codcli = CcbCDocu.codcli
                  x-nrorf1 = CcbCDocu.Nroped.
            END.
            x-codmon = 1.
            x-tpocmb = 1.
         END.
      ELSE 
         ASSIGN
            x-codpro = Almcmov.codpro
            x-codcli = Almcmov.codcli
            x-nrorf1 = Almcmov.nrorf1
            x-nrorf2 = Almcmov.nrorf2
            x-codmon = Almcmov.codmon
            x-tpocmb = Almcmov.tpocmb.
                 
      S-CODMOV  = Almdmov.TipMov + STRING(Almdmov.CodMov,"99"). 
/*       F-Ingreso = IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0                                        */
/*                     THEN (Almdmov.CanDes * Almdmov.Factor)                                     */
/*                     ELSE 0.                                                                    */
/*       F-PreIng  = 0.                                                                           */
/*       F-TotIng  = 0.                                                                           */
/*       IF nCodmon = x-Codmon THEN DO:                                                           */
/*          IF Almdmov.Tipmov = 'I' THEN DO:                                                      */
/*             F-PreIng  = Almdmov.PreUni / Almdmov.Factor.                                       */
/*             F-TotIng  = Almdmov.ImpCto.                                                        */
/*          END.                                                                                  */
/*          IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:                                         */
/*             F-PreIng  = ROUND(F-VALCTO / F-STKGEN,4).                                          */
/*             F-TotIng  = F-PreIng * F-Ingreso.                                                  */
/*          END.                                                                                  */
/*          END.                                                                                  */
/*       ELSE DO:                                                                                 */
/*          IF nCodmon = 1 THEN DO:                                                               */
/*             IF Almdmov.Tipmov = 'I' THEN DO:                                                   */
/*                F-PreIng  = ROUND(Almdmov.PreUni * x-Tpocmb / Almdmov.Factor, 4).               */
/*                F-TotIng  = (Almdmov.ImpCto * x-Tpocmb).                                        */
/*             END.                                                                               */
/*             IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:                                      */
/*                F-PreIng  = ROUND(F-VALCTO / F-STKGEN,4).                                       */
/*                F-TotIng  = F-PreIng * F-Ingreso.                                               */
/*             END.                                                                               */
/*             END.                                                                               */
/*          ELSE DO:                                                                              */
/*             IF Almdmov.Tipmov = 'I' THEN DO:                                                   */
/*                F-PreIng  = ROUND(Almdmov.PreUni / x-Tpocmb / Almdmov.Factor, 4).               */
/*                F-TotIng  = ROUND(Almdmov.ImpCto / x-Tpocmb, 2).                                */
/*             END.                                                                               */
/*             IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:                                      */
/*                F-PreIng  = ROUND(F-VALCTO / F-STKGEN,4).                                       */
/*                F-TotIng  = F-PreIng * F-Ingreso.                                               */
/*             END.                                                                               */
/*          END.                                                                                  */
/*       END.                                                                                     */
/*       F-Salida  = IF LOOKUP(Almdmov.TipMov,"S,T") > 0                                          */
/*                     THEN (Almdmov.CanDes * Almdmov.Factor)                                     */
/*                     ELSE 0.                                                                    */
/*       F-Saldo   = F-Saldo + F-Ingreso - F-Salida.                                              */
/*       F-STKGEN = Almdmov.StkAct.    /* RHC 18.05.04 */                                         */
/*       F-VALCTO = Almdmov.StkAct * Almdmov.VCtoMn1.  /* RHC 18.05.04 */                         */
/*       F-VALCTO = IF F-STKGEN = 0 THEN 0 ELSE F-VALCTO.                                         */
/*       F-PRECIO = IF F-STKGEN = 0 THEN 0 ELSE ROUND(F-VALCTO / F-STKGEN,4).                     */
/*       F-PreSal = F-PRECIO.                                                                     */
/*       F-TotSal = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN ROUND(F-Salida * F-PreSal,2) ELSE 0. */
/*                                                                                                */
/*     ASSIGN                                                                                     */
/*             x-Ingreso = x-Ingreso + f-Ingreso                                                  */
/*             x-Salida  = x-Salida  + f-Salida                                                   */
/*             x-Saldo   = f-Saldo.                                                               */
/*       ACCUMULATE F-Ingreso (TOTAL BY Almmmatg.CodMat).                                         */
/*       ACCUMULATE F-Salida  (TOTAL BY Almmmatg.CodMat).                                         */
/*       ACCUMULATE F-TotIng  (TOTAL BY Almmmatg.CodMat).                                         */
/*       ACCUMULATE F-TotSal  (TOTAL BY Almmmatg.CodMat).                                         */
      
     PUT STREAM REPORT
         Almmmatg.CodMat "|"
         Almmmatg.DesMat "|"
         Almmmatg.DesMar "|"
         Almmmatg.UndStk "|"
         Almdmov.CodAlm  "|"
         S-CODMOV "|"
         Almdmov.NroDoc "|".
     IF Almdmov.Codmov = 03 THEN PUT STREAM REPORT Almdmov.Almori "|".
     ELSE PUT STREAM REPORT "|".
     PUT STREAM REPORT
         x-CodPro "|"
         x-CodCli "|"
         x-NroRf1 "|"
         x-NroRf2 "|"
         Almdmov.FchDoc "|"
/*          F-Ingreso "|" */
/*          F-Salida "|". */
/*      PUT STREAM REPORT */
/*          F-SALDO "|"   */
         SKIP.
    END.  
/*     IF LAST-OF(Almmmatg.CodMat) THEN DO: */
/*        x-inggen = x-inggen + x-Ingreso.  */
/*        x-salgen = x-salgen + x-Salida.   */
/*     END.                                 */
  END.

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

