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
DEFINE VAR F-STKALM  AS DECIMAL.
DEFINE VAR F-STKGEN  AS DECIMAL.
DEFINE VAR F-VALCTO  AS DECIMAL.
DEFINE VAR I-NROITM  AS INTEGER.
DEFINE VAR X-TASK-NO AS INTEGER.
DEFINE VAR C-TPOINV  AS CHAR.
DEFINE VAR C-TipoCosto  AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
/*****************/

DEFINE TEMP-TABLE tmp-temporal
    FIELD t-codcia LIKE Almmmate.Codcia
    FIELD t-codigo LIKE Almmmate.CodMat
    FIELD t-desmat LIKE Almmmatg.DesMat
    FIELD t-desmar LIKE Almmmatg.DesMar
    FIELD t-undstk LIKE Almmmatg.UndStk
    FIELD t-linea  LIKE Almmmatg.codfam
    FIELD t-subfam LIKE Almmmatg.subfam
    FIELD t-codubi LIKE Almmmate.CodUbi
    FIELD t-codpr1 LIKE Almmmatg.codpr1    
    FIELD t-stkgen AS DECIMAL   FORMAT "(>>>,>>9.99)"
    FIELD t-valcto AS DECIMAL   FORMAT "(>>>,>>9.9999)"
    FIELD t-stkalm AS DECIMAL   FORMAT "(>>>,>>9.99)"
    FIELD t-costo AS DECIMAL    FORMAT "(>>>,>>9.9999)"
    FIELD t-stkact AS DECIMAL   FORMAT "(>>>,>>9.9999)"
    FIELD t-stkcon AS DECIMAL   FORMAT "(>>>,>>9.9999)"
    FIELD t-stkrec AS DECIMAL   FORMAT "(>>>,>>9.9999)"
    FIELD t-stkdifp AS DECIMAL   FORMAT "(>>>,>>9.9999)"
    FIELD t-stkdifn AS DECIMAL   FORMAT "(>>>,>>9.9999)"
    FIELD t-stkdifpm AS DECIMAL   FORMAT "(>>>,>>9.9999)"
    FIELD t-stkdifnm AS DECIMAL   FORMAT "(>>>,>>9.9999)"
    FIELD t-imptot AS DECIMAL   FORMAT "(>>,>>>,>>9.99)"
    FIELD t-sw AS LOGICAL INITIAL FALSE
    FIELD t-catconta as char init ""
    FIELD t-tipart LIKE Almmmatg.TipArt 
    INDEX idx01 IS PRIMARY t-codigo
    INDEX idx02 t-linea t-subfam t-codigo
    .

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
&Scoped-Define ENABLED-OBJECTS RECT-57 DesdeC HastaC F-provee1 D-FchInv ~
ICodMon COMBO-BOX-1 x-CatConta x-Resumen B-expor Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS DesdeC F-DesMatD HastaC F-DesMatH ~
F-provee1 D-FchInv ICodMon COMBO-BOX-1 x-CatConta x-Resumen 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-expor 
     IMAGE-UP FILE "img\excel":U
     LABEL "Exportar" 
     SIZE 11 BY 1.5.

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

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Codigo" 
     LABEL "Ordenado Por" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Codigo","Descripcion","Sub-linea","Proveedor" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE D-FchInv AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha del Inventario" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .81 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesMatD AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 23.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesMatH AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 23 BY .81 NO-UNDO.

DEFINE VARIABLE F-provee1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-CatConta AS CHARACTER FORMAT "X(2)":U 
     LABEL "Cat. Conta." 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE ICodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 13.72 BY .54 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 68 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 10.77.

DEFINE VARIABLE x-Resumen AS LOGICAL INITIAL no 
     LABEL "Resumen por Familia" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     DesdeC AT ROW 1.77 COL 17.14 COLON-ALIGNED
     F-DesMatD AT ROW 1.77 COL 28.14 COLON-ALIGNED NO-LABEL
     HastaC AT ROW 2.73 COL 17.14 COLON-ALIGNED
     F-DesMatH AT ROW 2.73 COL 28.14 COLON-ALIGNED NO-LABEL
     F-provee1 AT ROW 3.65 COL 17 COLON-ALIGNED
     D-FchInv AT ROW 4.58 COL 17 COLON-ALIGNED
     ICodMon AT ROW 5.58 COL 19 NO-LABEL
     COMBO-BOX-1 AT ROW 6.27 COL 17 COLON-ALIGNED
     x-CatConta AT ROW 7.15 COL 17 COLON-ALIGNED
     x-Resumen AT ROW 8.12 COL 19
     B-expor AT ROW 12.04 COL 31.43
     Btn_OK AT ROW 12.04 COL 43.86
     Btn_Cancel AT ROW 12.04 COL 56.29
     "Valorizado" VIEW-AS TEXT
          SIZE 7.72 BY .5 AT ROW 6.46 COL 10.57
     "Tipo de Costo" VIEW-AS TEXT
          SIZE 10.14 BY .5 AT ROW 5.62 COL 9
     "Criterio de Selección" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     RECT-46 AT ROW 11.96 COL 1
     RECT-57 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 68.29 BY 12.96
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
         TITLE              = "Inventario Valorizado"
         HEIGHT             = 12.96
         WIDTH              = 68.29
         MAX-HEIGHT         = 21.38
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.38
         VIRTUAL-WIDTH      = 114.29
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
/* SETTINGS FOR FILL-IN F-DesMatD IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesMatH IN FRAME F-Main
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
ON END-ERROR OF W-Win /* Inventario Valorizado */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Inventario Valorizado */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-expor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-expor W-Win
ON CHOOSE OF B-expor IN FRAME F-Main /* Exportar */
DO:
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Carga-Tempo.
  RUN Exporta.
  RUN Habilita.
  RUN Inicializa-Variables.

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


&Scoped-define SELF-NAME D-FchInv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-FchInv W-Win
ON LEAVE OF D-FchInv IN FRAME F-Main /* Fecha del Inventario */
DO:
    ASSIGN D-FchInv.
    
    IF D-FchInv = ? THEN RETURN.
    
     FIND InvConfig WHERE InvConfig.CodCia = S-CODCIA 
                     AND  InvConfig.CodAlm = S-CODALM 
                     AND  InvConfig.FchInv = D-FchInv
                    NO-LOCK NO-ERROR.
     IF NOT AVAILABLE InvConfig THEN DO:
        MESSAGE "Fecha de Inventario no existe"
                VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
     END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Desde */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
                      Almmmatg.CodMat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  DISPLAY Almmmatg.DesMat @ F-DesMatD WITH FRAME {&FRAME-NAME}.
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


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC W-Win
ON LEAVE OF HastaC IN FRAME F-Main /* Hasta */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
                      Almmmatg.CodMat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.  
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  DISPLAY Almmmatg.DesMat @ F-DesMatH WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Resumen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Resumen W-Win
ON VALUE-CHANGED OF x-Resumen IN FRAME F-Main /* Resumen por Familia */
DO:
  ASSIGN x-Resumen.
  IF x-Resumen
  THEN COMBO-BOX-1:SENSITIVE = NO.
  ELSE COMBO-BOX-1:SENSITIVE = YES.
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
    ASSIGN DesdeC HastaC D-FchInv ICodMon COMBO-BOX-1 
        F-Provee1 x-Resumen x-CatConta.
        
    IF HastaC = "" THEN HastaC = "999999".
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tempo W-Win 
PROCEDURE Carga-Tempo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR f-Costo AS DEC NO-UNDO.

define var f-prcprm as decimal format ">>,>>9.9999".

IF HastaC = "" THEN HastaC = "999999".

    FOR EACH tmp-temporal:
        DELETE tmp-temporal.
    END.

FOR EACH InvConteo WHERE InvConteo.CodCia = S-CODCIA         AND
                         InvConteo.CodAlm = S-CODALM         AND 
                         InvConteo.FchInv = InvConfig.FchInv AND
                         InvConteo.CodMat >= DesdeC          AND
                         InvConteo.CodMat <= HastaC 
                         NO-LOCK USE-INDEX Invcn02,
                         FIRST Almmmatg OF InvConteo NO-LOCK WHERE Almmmatg.catconta[1] BEGINS x-CatConta:
                         
    DISPLAY InvConteo.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
            FORMAT "X(8)" WITH FRAME F-Proceso.
      
    FIND Almmmate WHERE Almmmate.CodCia = InvConteo.CodCia AND 
                        Almmmate.CodAlm = InvConteo.CodAlm AND 
                        Almmmate.CodMat = InvConteo.CodMat 
                        NO-LOCK NO-ERROR.

    /* UBICAMOS EL STOCK GENERAL */
    F-StkGen = 0.
    FIND LAST AlmStkAl WHERE almstkal.codcia = s-codcia
        AND almstkal.codmat = almmmatg.codmat
        AND almstkal.fecha <= InvConfig.FchInv
        NO-LOCK NO-ERROR.
    IF AVAILABLE AlmStkAl
    THEN ASSIGN
            F-StkGen = almstkal.stkact.

    F-ValCto = 0.
 
    IF F-Provee1 <> "" THEN DO:
       IF Almmmatg.CodPr1 <> F-Provee1 THEN NEXT.
    END.
    CREATE tmp-temporal.
    ASSIGN t-codcia = InvConteo.Codcia
           t-codigo = InvConteo.CodMat
           t-desmat = Almmmatg.DesMat
           t-desmar = Almmmatg.DesMar
           t-undstk = Almmmatg.UndStk
           t-linea  = Almmmatg.codfam
           t-codpr1 = Almmmatg.codpr1
           t-subfam = Almmmatg.subfam
           t-codubi = Almmmate.CodUbi
           t-stkgen = F-STKGEN
           t-valcto = F-VALCTO
           t-stkalm = F-STKALM
           t-stkcon = InvConteo.CanInv
           t-sw = TRUE
           t-catconta = almmmatg.catconta[1]
           t-tipart = Almmmatg.TipArt.
    t-stkdifp  = 0.
    t-stkdifpm = 0.
    t-stkdifn  = 0.
    t-stkdifnm = 0. 
    IF t-stkcon - t-stkalm > 0 THEN t-stkdifp  = t-stkcon - t-stkalm .
    IF t-stkcon - t-stkalm < 0 THEN t-stkdifn  = t-stkcon - t-stkalm .
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
  DISPLAY DesdeC F-DesMatD HastaC F-DesMatH F-provee1 D-FchInv ICodMon 
          COMBO-BOX-1 x-CatConta x-Resumen 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 DesdeC HastaC F-provee1 D-FchInv ICodMon COMBO-BOX-1 
         x-CatConta x-Resumen B-expor Btn_OK Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta W-Win 
PROCEDURE Exporta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iTotalNumberOfOrders    AS INTEGER.
DEFINE VARIABLE iMonth                  AS INTEGER.
DEFINE VARIABLE dAnnualQuota            AS DECIMAL.
DEFINE VARIABLE dTotalSalesAmount       AS DECIMAL.
DEFINE VARIABLE t-Column                AS INTEGER INITIAL 2.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE f-Column                AS char INITIAL "".
DEFINE VARIABLE x-valor                 AS DECIMAL init 0.
DEFINE VARIABLE f-estado                AS char init "".


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 6.
chWorkSheet:Columns("B"):ColumnWidth = 45.
chWorkSheet:Columns("C"):ColumnWidth = 15.
chWorkSheet:Columns("D"):ColumnWidth = 8.
chWorkSheet:Columns("E"):ColumnWidth = 10.
chWorkSheet:Columns("F"):ColumnWidth = 20.
chWorkSheet:Columns("G"):ColumnWidth = 20.
chWorkSheet:Columns("H"):ColumnWidth = 20.
chWorkSheet:Columns("I"):ColumnWidth = 20.
chWorkSheet:Columns("J"):ColumnWidth = 10.

chWorkSheet:Columns("E"):NumberFormat = "@".
chWorkSheet:Columns("A"):NumberFormat = "@".

chWorkSheet:Range("A1:J2"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Value = "Almacen " + S-CODALM .
chWorkSheet:Range("A2"):Value = "Codigo".
chWorkSheet:Range("B2"):Value = "Descripcion".
chWorkSheet:Range("C2"):Value = "Marca".
chWorkSheet:Range("D2"):Value = "U.M".
chWorkSheet:Range("E2"):Value = "Zona".
chWorkSheet:Range("F2"):Value = "Costo".
chWorkSheet:Range("G2"):Value = "Total Inventario".
chWorkSheet:Range("H2"):Value = "Total Importe".
chWorkSheet:Range("I2"):Value = "Cat_Conta".
chWorkSheet:Range("J2"):Value = "Tip. Rot.".

chWorkSheet = chExcelApplication:Sheets:Item(1).

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */


for each tmp-temporal:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = t-codigo.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = t-Desmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = t-desmar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = t-undstk.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = t-codubi.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = t-costo.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = t-stkcon.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = t-imptot.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = t-catconta.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = t-tipart.
END.
/*
f-Column = "H" + string(t-Column).
chWorkSheet:Range("A1:" + f-column):Select().
*/
/*chExcelApplication:Selection:Style = "Currency".*/


/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
/*RELEASE OBJECT chWorksheetRange. */

FOR EACH tmp-temporal:
 DELETE tmp-temporal.
END.
HIDE FRAME F-PROCESO.

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
  
FIND InvConfig WHERE InvConfig.CodCia = S-CODCIA 
                AND  InvConfig.CodAlm = S-CODALM 
                AND  InvConfig.FchInv = D-FchInv
               NO-LOCK NO-ERROR.
IF NOT AVAILABLE InvConfig THEN DO:
   MESSAGE "No existe la configuracion de inventario" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.

C-TpoInv = InvConfig.TipInv.

RUN Carga-Tempo.

IF x-Resumen = NO THEN DO:
    CASE COMBO-BOX-1 :
         WHEN "Descripcion" THEN RUN Formato-Des.
         WHEN "Codigo"      THEN RUN Formato-Cod.
         WHEN "Sub-linea"   THEN RUN Formato-Sub.
         WHEN "Proveedor"   THEN RUN Formato-Pro.
    END. 
END.
ELSE RUN Formato-Res-Fam.
    
HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Cod W-Win 
PROCEDURE Formato-Cod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
  DEFINE VAR F-STKGEN AS DECIMAL NO-UNDO.
  DEFINE VAR F-TOTAL  AS DECIMAL NO-UNDO.
  DEFINE VAR s-Titulo AS CHAR NO-UNDO.
  
  s-Titulo = "REPORTE DE INVENTARIO FISICO".

  DEFINE FRAME F-REPORTE
  WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
   DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(30)" AT 1 SKIP
         "( " + S-CODALM + ")" AT 1 FORMAT "x(10)" s-Titulo AT 50 FORMAT 'X(40)'
         "Pagina :" TO 110 PAGE-NUMBER(REPORT) TO 122 FORMAT "ZZZZZ9" SKIP
         "Al " AT 55 D-FchInv FORMAT '99/99/9999' 
         "Fecha  :" TO 110 TODAY TO 122 FORMAT "99/99/9999" SKIP
         "TIPO DE COSTO "  C-TipoCosto
         "VALORIZADO EN : " + (IF ICodMon = 1 THEN "S/." ELSE "USS") AT 53 FORMAT "X(22)"
         "Hora   :" TO 110 STRING(TIME,"HH:MM") TO 122 SKIP 
    "-------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "                                                                          UND  COD                      STOCK      T O T A L TIPO DE " SKIP
    "CC  CODIGO    D E S C R I P C I O N                          MARCA        STK  ZON           COSTO      FISICO       IMPORTE ROTACION" SKIP  
    "-------------------------------------------------------------------------------------------------------------------------------------" SKIP

  
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  FOR EACH tmp-temporal NO-LOCK 
                        WHERE t-sw
                        BREAK BY t-codcia 
                              BY t-catconta
                              BY t-codigo:
      VIEW STREAM REPORT FRAME F-HEADER.
      ACCUMULATE t-imptot (TOTAL).
     
        DISPLAY STREAM REPORT 
            t-catconta  FORMAT 'x(3)' 
            t-codigo
            t-desmat
            t-desmar    FORMAT "X(16)"
            t-undstk
            t-codubi
            t-costo
            t-stkcon format "->>>,>>9.99"
            t-imptot format "->>>,>>9.99"
            t-tipart
            WITH FRAME F-REPORTE.
        DOWN STREAM REPORT WITH FRAME F-REPORTE.
        IF LAST-OF(t-codcia) THEN DO:
           UNDERLINE STREAM REPORT
             t-desmat
             t-imptot
            WITH FRAME F-REPORTE.
           DOWN STREAM REPORT WITH FRAME F-REPORTE.             
           DISPLAY STREAM REPORT 
             "TOTAL INVENTARIO" @ t-desmat
             (ACCUM TOTAL t-imptot) @ t-imptot
           WITH FRAME F-REPORTE.
           DOWN STREAM REPORT WITH FRAME F-REPORTE.             
        END.     

  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Des W-Win 
PROCEDURE Formato-Des :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR F-STKGEN AS DECIMAL NO-UNDO.
  DEFINE VAR F-TOTAL  AS DECIMAL NO-UNDO.
  DEFINE VAR s-Titulo AS CHAR NO-UNDO.
  
  s-Titulo = "REPORTE DE INVENTARIO FISICO".

  DEFINE FRAME F-REPORTE
  WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
   DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(30)" AT 1 SKIP
         "( " + S-CODALM + ")" AT 1 FORMAT "x(10)" s-Titulo AT 50 FORMAT 'X(40)'
         "Pagina :" TO 110 PAGE-NUMBER(REPORT) TO 122 FORMAT "ZZZZZ9" SKIP
         "Al " AT 55 D-FchInv FORMAT '99/99/9999' 
         "Fecha  :" TO 110 TODAY TO 122 FORMAT "99/99/9999" SKIP
         "TIPO DE COSTO "  C-TipoCosto
         "VALORIZADO EN : " + (IF ICodMon = 1 THEN "S/." ELSE "USS") AT 53 FORMAT "X(22)"
         "Hora   :" TO 110 STRING(TIME,"HH:MM") TO 122 SKIP 
    "---------------------------------------------------------------------------------------------------------------------------------" SKIP
    "                                                                      UND  COD                      STOCK      T O T A L TIPO DE " SKIP
    "CODIGO    D E S C R I P C I O N                          MARCA        STK  ZON           COSTO      FISICO       IMPORTE ROTACION" SKIP  
    "---------------------------------------------------------------------------------------------------------------------------------" SKIP

  
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  FOR EACH tmp-temporal NO-LOCK 
                        WHERE t-sw
                        BREAK BY t-codcia
                              BY t-desmat:
      VIEW STREAM REPORT FRAME F-HEADER.
      ACCUMULATE t-imptot (TOTAL).
     
        DISPLAY STREAM REPORT 
            t-codigo
            t-desmat
            t-desmar    FORMAT "X(16)"
            t-undstk
            t-codubi
            t-costo
            t-stkcon format "->>>,>>9.99"
            t-imptot format "->>>,>>9.99"
            t-tipart
            WITH FRAME F-REPORTE.
        DOWN STREAM REPORT WITH FRAME F-REPORTE.     
        IF LAST-OF(t-codcia) THEN DO:
           UNDERLINE STREAM REPORT
             t-desmat
             t-imptot
            WITH FRAME F-REPORTE.
           DOWN STREAM REPORT WITH FRAME F-REPORTE.             
           DISPLAY STREAM REPORT 
             "TOTAL INVENTARIO" @ t-desmat
             (ACCUM TOTAL t-imptot) @ t-imptot
           WITH FRAME F-REPORTE.
           DOWN STREAM REPORT WITH FRAME F-REPORTE.             
        END.     
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Pro W-Win 
PROCEDURE Formato-Pro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR F-STKGEN AS DECIMAL NO-UNDO.
  DEFINE VAR F-TOTAL  AS DECIMAL NO-UNDO.
  DEFINE VAR x-nompro as char.
  DEFINE VAR s-Titulo AS CHAR NO-UNDO.
  
  s-Titulo = "REPORTE DE INVENTARIO FISICO".
  
  DEFINE FRAME F-REPORTE
/*         Almmmate.codmat AT 3
         Almmmatg.desmat AT 12
         Almmmatg.undstk AT 65 
         Almmmate.codalm AT 72 
         AlmmmatE.stkact AT 80 FORMAT '->>>,>>>,>>9.999'
         F-PESALM        FORMAT ">>>>,>>>,>>9.99"
         F-TOTAL         FORMAT '>>>>>>9.999'*/
  WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 /*

 DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP
         "REPORTE DE INVENTARIO FISICO" AT 60 FORMAT 'X(40)'
         "Pagina :" TO 135 PAGE-NUMBER(REPORT) TO 147 FORMAT "ZZZZZ9" SKIP
         "Al " AT 65 D-FchInv FORMAT '99/99/9999' 
         "Fecha  :" TO 135 TODAY TO 147 FORMAT "99/99/9999" SKIP
         "TIPO DE COSTO " C-TipoCosto
         "VALORIZADO EN : " + (IF ICodMon = 1 THEN "S/." ELSE "USS") AT 63 FORMAT "X(22)"
         "Hora   :" TO 135 STRING(TIME,"HH:MM") TO 147 SKIP 
    "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "                                                                      UND  COD                STOCK    T O T A L                                                " SKIP
    "CODIGO    D E S C R I P C I O N                          MARCA        STK  ZON    COSTO      FISICO    IMPORTE                                                  " SKIP  
    "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*   12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 */
/*            1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7 */
  */

   DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(30)" AT 1 SKIP
         "( " + S-CODALM + ")" AT 1 FORMAT "x(10)" s-Titulo AT 50 FORMAT 'X(40)'
         "Pagina :" TO 105 PAGE-NUMBER(REPORT) TO 117 FORMAT "ZZZZZ9" SKIP
         "Al " AT 55 D-FchInv FORMAT '99/99/9999' 
         "Fecha  :" TO 105 TODAY TO 117 FORMAT "99/99/9999" SKIP
         "TIPO DE COSTO "  C-TipoCosto
         "VALORIZADO EN : " + (IF ICodMon = 1 THEN "S/." ELSE "USS") AT 53 FORMAT "X(22)"
         "Hora   :" TO 105 STRING(TIME,"HH:MM") TO 117 SKIP 
    "----------------------------------------------------------------------------------------------------------------------------------" SKIP
    "                                                                      UND  COD                      STOCK      T O T A L  TIPO DE " SKIP
    "CODIGO    D E S C R I P C I O N                          MARCA        STK  ZON           COSTO      FISICO       IMPORTE  ROTACION" SKIP  
    "----------------------------------------------------------------------------------------------------------------------------------" SKIP

  
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  FOR EACH tmp-temporal NO-LOCK 
                        WHERE t-sw
                        BREAK BY t-codcia
                              BY t-codpr1:
      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-codpr1) THEN DO:
        x-nompro = "".
        FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA 
                      AND  gn-prov.CodPro = t-codpr1 
                     NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-prov THEN do:
            FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
                          AND  gn-prov.CodPro = t-codpr1
                         NO-LOCK NO-ERROR.
        END.

        IF AVAILABLE gn-prov THEN x-nompro = gn-prov.nompro. 

        DISPLAY STREAM REPORT 
            t-codpr1 @ t-codigo
            x-nompro @ t-desmat
            WITH FRAME F-REPORTE.
        UNDERLINE STREAM REPORT 
            t-codigo
            t-desmat
            WITH FRAME F-REPORTE.
      END.
      
      ACCUMULATE t-imptot (SUB-TOTAL BY t-codpr1).
     
      ACCUMULATE t-imptot (TOTAL).

        DISPLAY STREAM REPORT 
            t-codigo
            t-desmat
            t-desmar    FORMAT "X(16)"
            t-undstk
            t-codubi
            t-costo
            t-stkcon
            t-imptot
            t-tipart
            WITH FRAME F-REPORTE.
        DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-codpr1) THEN DO:
        UNDERLINE STREAM REPORT 
            t-imptot
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL PROVEEDOR : " + t-codpr1) @ t-desmat
            (ACCUM SUB-TOTAL BY t-codpr1 t-imptot ) @ t-imptot
            WITH FRAME F-REPORTE.
      END.

      
      IF LAST-OF(t-codcia) THEN DO:
       UNDERLINE STREAM REPORT
         t-desmat
         t-imptot
        WITH FRAME F-REPORTE.
       DOWN STREAM REPORT WITH FRAME F-REPORTE.             
       DISPLAY STREAM REPORT 
         "TOTAL INVENTARIO" @ t-desmat
         (ACCUM TOTAL t-imptot) @ t-imptot
       WITH FRAME F-REPORTE.
       DOWN STREAM REPORT WITH FRAME F-REPORTE.             
      END.     

     
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Res-Fam W-Win 
PROCEDURE Formato-Res-Fam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
  DEFINE VAR F-STKGEN AS DECIMAL NO-UNDO.
  DEFINE VAR F-TOTAL  AS DECIMAL NO-UNDO.
  DEFINE VAR s-Titulo AS CHAR NO-UNDO.
  
  s-Titulo = "REPORTE DE INVENTARIO FISICO".

  DEFINE FRAME F-REPORTE
    t-linea         FORMAT 'x(7)'
    Almtfami.desfam FORMAT 'x(50)'
    t-imptot
  WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
   DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(30)" AT 1 SKIP
         "( " + S-CODALM + ")" AT 1 FORMAT "x(10)" s-Titulo AT 50 FORMAT 'X(40)'
         "Pagina :" TO 105 PAGE-NUMBER(REPORT) TO 117 FORMAT "ZZZZZ9" SKIP
         "Al " AT 55 D-FchInv FORMAT '99/99/9999' 
         "Fecha  :" TO 105 TODAY TO 117 FORMAT "99/99/9999" SKIP
         "TIPO DE COSTO "  C-TipoCosto
         "VALORIZADO EN : " + (IF ICodMon = 1 THEN "S/." ELSE "USS") AT 53 FORMAT "X(22)"
         "Hora   :" TO 105 STRING(TIME,"HH:MM") TO 117 SKIP 
    "-------------------------------------------------------------------------" SKIP
    "FAMILIA D E S C R I P C I O N                                     IMPORTE" SKIP  
    "-------------------------------------------------------------------------" SKIP
/*   12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 */
/*            1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7 */
/*   123     12345678901234567890123456789012345678901234567890 (>>,>>>,>>9.99) */

  
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  FOR EACH tmp-temporal NO-LOCK WHERE t-sw,
        FIRST Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
            AND Almtfami.codfam = t-linea
        BREAK BY t-codcia BY t-linea:
      VIEW STREAM REPORT FRAME F-HEADER.
      ACCUMULATE t-imptot (SUB-TOTAL BY t-linea).
      ACCUMULATE t-imptot (TOTAL).
      IF LAST-OF(t-linea) THEN DO:
        DISPLAY STREAM REPORT 
            t-linea         
            Almtfami.desfam 
            (ACCUM SUB-TOTAL BY t-line t-imptot ) @ t-imptot
            WITH FRAME F-REPORTE.
      END.
      
      IF LAST-OF(t-codcia) THEN DO:
       UNDERLINE STREAM REPORT
         t-imptot
        WITH FRAME F-REPORTE.
       DOWN STREAM REPORT WITH FRAME F-REPORTE.             
       DISPLAY STREAM REPORT 
         "TOTAL INVENTARIO" @ Almtfami.desfam
         (ACCUM TOTAL t-imptot) @ t-imptot
       WITH FRAME F-REPORTE.
       DOWN STREAM REPORT WITH FRAME F-REPORTE.             
      END.     
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Sub W-Win 
PROCEDURE Formato-Sub :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
  DEFINE VAR F-STKGEN AS DECIMAL NO-UNDO.
  DEFINE VAR F-TOTAL  AS DECIMAL NO-UNDO.
  DEFINE VAR s-Titulo AS CHAR NO-UNDO.
  
  s-Titulo = "REPORTE DE INVENTARIO FISICO".

  DEFINE FRAME F-REPORTE
/*         Almmmate.codmat AT 3
         Almmmatg.desmat AT 12
         Almmmatg.undstk AT 65 
         Almmmate.codalm AT 72 
         AlmmmatE.stkact AT 80 FORMAT '->>>,>>>,>>9.999'
         F-PESALM        FORMAT ">>>>,>>>,>>9.99"
         F-TOTAL         FORMAT '>>>>>>9.999'*/
  WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 /*

 DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP
         "REPORTE DE INVENTARIO FISICO" AT 60 FORMAT 'X(40)'
         "Pagina :" TO 135 PAGE-NUMBER(REPORT) TO 147 FORMAT "ZZZZZ9" SKIP
         "Al " AT 65 D-FchInv FORMAT '99/99/9999' 
         "Fecha  :" TO 135 TODAY TO 147 FORMAT "99/99/9999" SKIP
         "TIPO DE COSTO " C-TipoCosto
         "VALORIZADO EN : " + (IF ICodMon = 1 THEN "S/." ELSE "USS") AT 63 FORMAT "X(22)"
         "Hora   :" TO 135 STRING(TIME,"HH:MM") TO 147 SKIP 
    "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "                                                                      UND  COD                STOCK    T O T A L                                                " SKIP
    "CODIGO    D E S C R I P C I O N                          MARCA        STK  ZON    COSTO      FISICO    IMPORTE                                                  " SKIP  
    "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*   12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 */
/*            1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7 */
  */

   DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(30)" AT 1 SKIP
         "( " + S-CODALM + ")" AT 1 FORMAT "x(10)" s-Titulo AT 50 FORMAT 'X(40)'
         "Pagina :" TO 105 PAGE-NUMBER(REPORT) TO 117 FORMAT "ZZZZZ9" SKIP
         "Al " AT 55 D-FchInv FORMAT '99/99/9999' 
         "Fecha  :" TO 105 TODAY TO 117 FORMAT "99/99/9999" SKIP
         "TIPO DE COSTO "  C-TipoCosto
         "VALORIZADO EN : " + (IF ICodMon = 1 THEN "S/." ELSE "USS") AT 53 FORMAT "X(22)"
         "Hora   :" TO 105 STRING(TIME,"HH:MM") TO 117 SKIP 
    "----------------------------------------------------------------------------------------------------------------------------------" SKIP
    "                                                                      UND  COD                      STOCK      T O T A L  TIPO DE " SKIP
    "CODIGO    D E S C R I P C I O N                          MARCA        STK  ZON           COSTO      FISICO       IMPORTE  ROTACION" SKIP  
    "----------------------------------------------------------------------------------------------------------------------------------" SKIP

  
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  FOR EACH tmp-temporal NO-LOCK 
                        WHERE t-sw,
                        FIRST Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
                            AND Almtfami.codfam = t-linea,
                        FIRST Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia
                            AND almsfami.codfam = t-linea
                            AND Almsfami.subfam = t-subfam
                        BREAK BY t-codcia
                              BY t-linea
                              BY t-subfam
                              BY t-codigo:
      VIEW STREAM REPORT FRAME F-HEADER.
      IF FIRST-OF(t-linea) THEN DO:
/*        FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA 
 *                        AND  Almtfami.codfam = t-linea 
 *                       NO-LOCK NO-ERROR.*/
        DISPLAY STREAM REPORT 
            t-linea @ t-codigo
            Almtfami.desfam @ t-desmat
            WITH FRAME F-REPORTE.
        UNDERLINE STREAM REPORT 
            t-codigo
            t-desmat
            WITH FRAME F-REPORTE.
      END.
      IF FIRST-OF(t-subfam) THEN DO:
/*        FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA 
 *                        AND  AlmSFami.codfam = t-linea 
 *                        AND  AlmSFami.subfam = t-subfam
 *                       NO-LOCK NO-ERROR.*/
        DISPLAY STREAM REPORT 
            t-subfam @ t-codigo
            AlmSFami.dessub @ t-desmat
            WITH FRAME F-REPORTE.
        UNDERLINE STREAM REPORT 
            t-codigo
            t-desmat
            WITH FRAME F-REPORTE.
      END.
      
      ACCUMULATE t-imptot (SUB-TOTAL BY t-linea).
      ACCUMULATE t-imptot (SUB-TOTAL BY t-subfam).
     
      ACCUMULATE t-imptot (TOTAL).

        DISPLAY STREAM REPORT 
            t-codigo
            t-desmat
            t-desmar    FORMAT "X(16)"
            t-undstk
            t-codubi
            t-costo
            t-stkcon
            t-imptot
            t-tipart
            WITH FRAME F-REPORTE.
        DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-subfam) THEN DO:
        UNDERLINE STREAM REPORT 
            t-imptot
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL SUB-LINEA : " + t-subfam) @ t-desmat
            (ACCUM SUB-TOTAL BY t-subfam t-imptot ) @ t-imptot
            WITH FRAME F-REPORTE.
      END.

      IF LAST-OF(t-linea) THEN DO:
        UNDERLINE STREAM REPORT 
            t-imptot
            WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL LINEA : " + t-linea) @ t-desmat
            (ACCUM SUB-TOTAL BY t-line t-imptot ) @ t-imptot
            WITH FRAME F-REPORTE.
      END.
      
      IF LAST-OF(t-codcia) THEN DO:
       UNDERLINE STREAM REPORT
         t-desmat
         t-imptot
        WITH FRAME F-REPORTE.
       DOWN STREAM REPORT WITH FRAME F-REPORTE.             
       DISPLAY STREAM REPORT 
         "TOTAL INVENTARIO" @ t-desmat
         (ACCUM TOTAL t-imptot) @ t-imptot
       WITH FRAME F-REPORTE.
       DOWN STREAM REPORT WITH FRAME F-REPORTE.             
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
    ENABLE ALL EXCEPT F-DesMatD F-DesMatH .
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
  ASSIGN DesdeC HastaC ICodMon COMBO-BOX-1.
  
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
     FIND LAST InvConfig WHERE InvConfig.CodCia = S-CODCIA 
                          AND  InvConfig.CodAlm = S-CODALM 
                         NO-LOCK NO-ERROR.
     IF AVAILABLE InvConfig THEN D-FchInv = InvConfig.FchInv.
     DISPLAY D-FchInv.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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
/*        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.*/
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

