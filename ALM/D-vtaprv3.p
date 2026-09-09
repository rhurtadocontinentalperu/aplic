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

DEFINE VARIABLE pto AS LOGICAL.

DEFINE VARIABLE tot_uca AS DECIMAL.
DEFINE VARIABLE tot_and AS DECIMAL.
DEFINE VARIABLE tot_par AS DECIMAL.

DEFINE BUFFER b-almmmate FOR almmmate.


DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codfam  LIKE Almmmatg.codfam 
    FIELD t-subfam  LIKE Almmmatg.subfam
    FIELD t-prove   LIKE Almmmatg.CodPr1
    FIELD t-codmat  LIKE Almdmov.codmat
    FIELD t-desmat  LIKE Almmmatg.DesMat    FORMAT "X(40)"
    FIELD t-desmar  LIKE Almmmatg.DesMar    FORMAT "X(8)"
    FIELD t-undbas  LIKE Almmmatg.UndBas    FORMAT "X(8)"
    FIELD t-tot_uca AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-tot_and AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-tot_par AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-tot_lau AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-tot_vta AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-stkact  LIKE Almmmate.StkAct    FORMAT "->>>>>,>>9.99"
    FIELD t-nro_per AS DEC           FORMAT ">>>>9.99"
    FIELD t-nro_dia AS INT           FORMAT ">>>>9"
    FIELD t-totals  AS DEC           FORMAT ">>>9.9999"
    FIELD t-totald  AS DEC           FORMAT ">>>>,>>9.99".

  DEFINE VARIABLE S-CODMOV AS CHAR INIT "02" NO-UNDO. 
  DEFINE VARIABLE x-stkact AS DECIMAL.
  DEFINE VARIABLE x-dia AS INTEGER.

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
&Scoped-Define ENABLED-OBJECTS F-CodFam F-SubFam F-prov1 F-prov2 DesdeC ~
HastaC DesdeF HastaF nCodMon R-Tipo Btn_OK Btn_Cancel Btn_Help RECT-57 
&Scoped-Define DISPLAYED-OBJECTS F-CodFam F-SubFam F-prov1 F-prov2 DesdeC ~
HastaC DesdeF HastaF nCodMon R-Tipo F-DesFam F-DesSub 

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

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

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

DEFINE VARIABLE F-prov1 AS CHARACTER FORMAT "X(8)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-prov2 AS CHARACTER FORMAT "X(8)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

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


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodFam AT ROW 1.85 COL 18 COLON-ALIGNED
     F-SubFam AT ROW 2.62 COL 18 COLON-ALIGNED
     F-prov1 AT ROW 3.38 COL 18 COLON-ALIGNED
     F-prov2 AT ROW 3.38 COL 47 COLON-ALIGNED
     DesdeC AT ROW 4.12 COL 18 COLON-ALIGNED
     HastaC AT ROW 4.12 COL 47 COLON-ALIGNED
     DesdeF AT ROW 4.81 COL 18 COLON-ALIGNED
     HastaF AT ROW 4.81 COL 47 COLON-ALIGNED
     nCodMon AT ROW 6.04 COL 49.72 NO-LABEL
     R-Tipo AT ROW 5.58 COL 20 NO-LABEL
     F-DesFam AT ROW 1.85 COL 24.29 COLON-ALIGNED NO-LABEL
     F-DesSub AT ROW 2.62 COL 24.29 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 10.35 COL 46.29
     Btn_Cancel AT ROW 10.35 COL 57.57
     Btn_Help AT ROW 10.35 COL 69
     "Criterio de Seleccion" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     "Moneda" VIEW-AS TEXT
          SIZE 6.86 BY .58 AT ROW 6.04 COL 42.29
          FONT 6
     "Estado" VIEW-AS TEXT
          SIZE 6.86 BY .69 AT ROW 5.69 COL 12.57
          FONT 1
     RECT-46 AT ROW 10.23 COL 1
     RECT-57 AT ROW 1.27 COL 1
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
         TITLE              = "Ventas Totales"
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
   FRAME-NAME Custom                                                    */
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
ON END-ERROR OF W-Win /* Ventas Totales */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ventas Totales */
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


&Scoped-define SELF-NAME F-prov2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-prov2 W-Win
ON LEAVE OF F-prov2 IN FRAME F-Main /* A */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia 
                AND  GN-PROV.CODPRO = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE GN-PROV THEN DO:
    MESSAGE "Codigo de proveedor no existe" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO F-prov2.
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
  ASSIGN F-prov1 F-prov2 DesdeC DesdeF F-CodFam F-SubFam F-DesFam HastaC HastaF nCodMon R-Tipo.

  IF HastaC <> "" THEN 
    S-SUBTIT = "Materiales del " + DesdeC + " al " + HastaC .
  ELSE 
    S-SUBTIT = "".

  IF HastaC = "" THEN HastaC = "999999999".
    
  S-SUBTIT = "Periodo del " + STRING(DesdeF) + " al " + STRING(HastaF).


  IF HastaC = "" THEN HastaC = "999999".
  IF F-prov2 = "" THEN F-prov2 = "ZZZZZZZZZZZZZ".
  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE back W-Win 
PROCEDURE back :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*  FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA 
 *                              AND  LOOKUP(TRIM(Almmmate.CodAlm),"03,04,05") > 0 /* BEGINS "" /* S-CODALM */*/
 *                              AND  (Almmmate.CodMat >= DesdeC  
 *                              AND   Almmmate.CodMat <= HastaC), 
 *       EACH Almmmatg OF Almmmate NO-LOCK WHERE Almmmatg.codcia = Almmmate.CodCia
 *                                          AND  Almmmatg.codfam BEGINS F-CodFam 
 *                                          AND  Almmmatg.subfam BEGINS F-Subfam 
 *                                          AND  Almmmatg.codmat = Almmmate.CodMat
 *                                          AND  (Almmmatg.CodPr1 >= F-prov1
 *                                          AND   Almmmatg.CodPr1 <= F-prov2)
 *                                          AND  Almmmatg.TpoArt BEGINS R-Tipo ,
 *       EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = Almmmatg.codcia 
 *                             AND  Almdmov.CodAlm = Almmmate.CodAlm 
 *                             AND  Almdmov.codmat = Almmmatg.codmat
 *                             AND  (Almdmov.FchDoc >= DesdeF
 *                             AND   Almdmov.FchDoc <= HastaF)
 *                             AND  Almdmov.TipMov = "S" 
 *                             AND  Almdmov.CodMov = 02
 *                            BREAK BY Almmmate.CodCia 
 *                                  BY Almmmatg.CodFam
 *                                  BY Almmmatg.SubFam
 *                                  BY Almmmatg.CodPr1
 *                                  BY Almmmate.CodMat
 *                                  BY Almdmov.FchDoc
 *                                  BY Almdmov.TipMov
 *                                  BY Almdmov.CodMov
 *                                  BY Almdmov.NroDoc:
 * 
 *       DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
 *               FORMAT "X(11)" WITH FRAME F-Proceso.
 * 
 *       VIEW STREAM REPORT FRAME F-HEADER.
 * 
 *       IF FIRST-OF(Almmmatg.CodFam) THEN DO:
 *          FIND Almtfami WHERE Almtfami.CodCia = Almmmatg.CodCia 
 *                         AND  Almtfami.codfam = Almmmatg.CodFam 
 *                        NO-LOCK NO-ERROR.
 *          IF AVAILABLE Almtfami THEN DO:
 *              PUT STREAM REPORT "FAMILIA : " Almtfami.codfam '    ' Almtfami.desfam SKIP.
 *              PUT STREAM REPORT '      ------------------------------------------' SKIP.
 *          END.
 *       END.
 *       IF FIRST-OF(Almmmatg.SubFam) THEN DO:
 *          FIND Almsfami WHERE Almsfami.CodCia = Almmmatg.CodCia 
 *                         AND  Almsfami.codfam = Almmmatg.CodFam 
 *                         AND  Almsfami.subfam = Almmmatg.Subfam 
 *                        NO-LOCK NO-ERROR.
 *          IF AVAILABLE Almsfami THEN DO:
 *              PUT STREAM REPORT "SUB-FAMILIA : " Almsfami.subfam '   ' AlmSFami.dessub SKIP.
 *          END.
 *       END.
 *       IF FIRST-OF(Almmmatg.CodPr1) THEN DO:
 *          FIND GN-PROV WHERE GN-PROV.CODCIA = 0 
 *                        AND  GN-PROV.CODPRO = Almmmatg.CodPr1 
 *                       NO-LOCK NO-ERROR.
 *          IF AVAILABLE GN-PROV THEN DO:
 *              PUT STREAM REPORT "PROVEEDOR : " Almmmatg.CodPr1 '    ' gn-prov.NomPro SKIP.
 *              PUT STREAM REPORT '      ------------------------------------------' SKIP.
 *          END.  
 *       END.
 *               
 *       IF FIRST-OF(Almmmate.CodMat) THEN DO:
 *          FIND LAST DMOV WHERE DMOV.CodCia = S-CODCIA 
 *                          AND  DMOV.CodAlm = Almmmate.CodAlm 
 *                          AND  DMOV.CodMat = Almmmate.CodMat 
 *                          AND  DMOV.FchDoc < DesdeF 
 *                         USE-INDEX Almd03 NO-LOCK NO-ERROR.
 *          IF AVAILABLE DMOV THEN F-Saldo = DMOV.StkSub.
 *          ELSE F-Saldo = 0.
 *          
 *          tot_uca = 0.
 *          tot_and = 0.
 *          tot_par = 0.
 *          
 *       END.
 *       x-codpro = "".
 *       x-codcli = "".
 *       x-nrorf1 = "".
 *       x-nrorf2 = "".
 * /*      FIND Almcmov WHERE Almcmov.CodCia = Almdmov.codcia 
 *  *                     AND  Almcmov.CodAlm = Almdmov.codalm 
 *  *                     AND  Almcmov.TipMov = Almdmov.tipmov 
 *  *                     AND  Almcmov.CodMov = Almdmov.codmov 
 *  *                     AND  Almcmov.NroDoc = Almdmov.nrodoc 
 *  *                    NO-LOCK NO-ERROR.
 *  *       IF NOT AVAILABLE Almcmov THEN DO:
 *  *          IF Almdmov.CodMov = x-codmov THEN DO:
 *  *             FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia 
 *  *                            AND  CcbCDocu.CodDoc = 'G/R' 
 *  *                            AND  CcbCDocu.NroDoc = STRING(Almdmov.nroser,'999') + STRING(Almdmov.Nrodoc,'999999') 
 *  *                           NO-LOCK NO-ERROR.
 *  *             IF AVAILABLE CcbCDocu THEN 
 *  *                ASSIGN
 *  *                   x-codcli = CcbCDocu.codcli
 *  *                   x-nrorf1 = CcbCDocu.Nroped.
 *  *             END.
 *  *          END.
 *  *       ELSE 
 *  *          ASSIGN
 *  *             x-codpro = Almcmov.codpro
 *  *             x-codcli = Almcmov.codcli
 *  *             x-nrorf1 = Almcmov.nrorf1
 *  *             x-nrorf2 = Almcmov.nrorf2.*/
 *          
 *       S-CODMOV  = Almdmov.TipMov + STRING(Almdmov.CodMov,"99"). 
 *       F-Ingreso = IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
 *       F-Salida  = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
 *       F-Saldo   = F-Saldo + F-Ingreso - F-Salida.
 *       ACCUMULATE F-Ingreso (TOTAL BY Almmmate.CodMat).
 *       ACCUMULATE F-Salida  (TOTAL BY Almmmate.CodMat).
 * 
 *       tot_uca = tot_uca + IF Almdmov.CodAlm = "03" THEN F-Salida ELSE 0.
 *       tot_and = tot_and + IF Almdmov.CodAlm = "04" THEN F-Salida ELSE 0.
 *       tot_par = tot_par + IF Almdmov.CodAlm = "05" THEN F-Salida ELSE 0.
 *       
 * /*      DISPLAY STREAM REPORT 
 *  *                Almdmov.codmat
 *  *                Almmmatg.DesMat
 *  *                Almmmatg.UndBas
 *  *                F-Salida
 *  *                WITH FRAME F-REPORTE.
 *  *       DOWN STREAM REPORT WITH FRAME F-REPORTE.*/
 * 
 *       IF LAST-OF(Almmmate.CodMat) THEN DO:
 *         x-stkact = 0.
 *         FIND b-almmmate WHERE B-Almmmate.CodCia = Almmmate.CodCia
 *                          AND  B-Almmmate.CodAlm = "03"
 *                          AND  B-Almmmate.codmat = Almmmate.CodMat
 *                         NO-LOCK NO-ERROR.
 *         IF AVAIL b-almmmate THEN x-stkact = x-stkact + b-Almmmate.StkAct.
 *         FIND b-almmmate WHERE B-Almmmate.CodCia = Almmmate.CodCia
 *                          AND  B-Almmmate.CodAlm = "04"
 *                          AND  B-Almmmate.codmat = Almmmate.CodMat
 *                         NO-LOCK NO-ERROR.
 *         IF AVAIL b-almmmate THEN x-stkact = x-stkact + b-Almmmate.StkAct.
 *         FIND b-almmmate WHERE B-Almmmate.CodCia = Almmmate.CodCia
 *                          AND  B-Almmmate.CodAlm = "05"
 *                          AND  B-Almmmate.codmat = Almmmate.CodMat
 *                         NO-LOCK NO-ERROR.
 *         IF AVAIL b-almmmate THEN x-stkact = x-stkact + b-Almmmate.StkAct.
 *         
 *         tot_vta = tot_uca + tot_and + tot_par.
 *         nro_per = x-stkact / tot_vta.
 *         nro_dia = nro_per * x-dia.
 *         DISPLAY STREAM REPORT 
 *                  Almdmov.codmat
 *                  Almmmatg.DesMat
 *                  Almmmatg.DesMar
 *                  Almmmatg.UndBas
 *                  tot_uca
 *                  tot_and
 *                  tot_par
 *                  tot_vta
 *                  x-stkact @ Almmmate.StkAct
 *                  nro_per
 *                  nro_dia
 * /*                 imp_tots
 *  *                  imp_totd */
 *                  WITH FRAME F-REPORTE.
 *          DOWN STREAM REPORT WITH FRAME F-REPORTE.
 *       END.
 *   END.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal W-Win 
PROCEDURE carga-temporal :
/*
------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  define var t-totals as deci init 0.
  x-dia = HastaF - DesdeF + 1.
  FOR EACH tmp-tempo :
    DELETE tmp-tempo.
  END.
  /*
message DesdeC HastaC F-prov1 F-prov2 R-Tipo view-as alert-box.
*/
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
                           AND  Almmmatg.codfam BEGINS F-CodFam
                           AND  Almmmatg.subfam BEGINS F-Subfam
                           AND  (Almmmatg.codmat >= DesdeC
                           AND   Almmmatg.CodMat <= HastaC)
                           AND  (Almmmatg.CodPr1 >= F-prov1
                           AND   Almmmatg.CodPr1 <= F-prov2)
                           AND  Almmmatg.TpoArt BEGINS R-Tipo
                          USE-INDEX matg09,
   EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = Almmmatg.codcia 
                         AND  LOOKUP(trim(Almdmov.CodAlm), "03,04,05,89") > 0
                         AND  Almdmov.codmat = Almmmatg.codmat
                         AND  (Almdmov.FchDoc >= DesdeF
                         AND   Almdmov.FchDoc <= HastaF)
                         AND  Almdmov.TipMov = "S" 
                         AND  Almdmov.CodMov = 02
                        BREAK BY Almmmatg.codcia
                              BY Almmmatg.codmat:
                         
/*
DISPLAY Almdmov.CodCia 
        Almdmov.CodAlm
        Almdmov.codmat
        Almdmov.FchDoc
        Almdmov.TipMov
        Almdmov.CodMov
        Almmmatg.codfam
        Almmmatg.subfam
        Almmmatg.CodPr1
        Almmmatg.TpoArt.
*/

      DISPLAY Almdmov.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      S-CODMOV  = Almdmov.TipMov + STRING(Almdmov.CodMov,"99"). 
      F-Ingreso = IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
      F-Salida  = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
      
      FIND tmp-tempo WHERE t-codfam  = Almmmatg.codfam 
                      AND  t-subfam  = Almmmatg.subfam
                      AND  t-prove   = Almmmatg.CodPr1
                      AND  t-codmat  = Almdmov.codmat
                     NO-ERROR.
      IF NOT AVAIL tmp-tempo THEN DO:
        IF Almmmatg.Monvta = 1 THEN DO:
         t-totals = Almmmatg.Ctotot / ( IF ncodmon = 1 THEN 1 ELSE Almmmatg.Tpocmb ).
        END.
        ELSE DO:
         t-totals = Almmmatg.Ctotot * ( IF ncodmon = 2 THEN 1 ELSE Almmmatg.Tpocmb ).
        END.
       
        CREATE tmp-tempo.
        ASSIGN t-codfam  = Almmmatg.codfam 
               t-subfam  = Almmmatg.subfam
               t-prove   = Almmmatg.CodPr1
               t-codmat  = Almdmov.codmat
               t-desmat  = Almmmatg.DesMat
               t-desmar  = Almmmatg.DesMar
               t-undbas  = Almmmatg.UndBas.
               
      END.
      ASSIGN t-tot_uca = t-tot_uca + IF Almdmov.CodAlm = "03" THEN F-Salida ELSE 0
             t-tot_and = t-tot_and + IF Almdmov.CodAlm = "04" THEN F-Salida ELSE 0
             t-tot_par = t-tot_par + IF Almdmov.CodAlm = "05" THEN F-Salida ELSE 0
             t-tot_lau = t-tot_lau + IF Almdmov.CodAlm = "89" THEN F-Salida ELSE 0
             t-tot_vta = t-tot_vta + F-Salida.

      IF LAST-OF(Almmmatg.codmat) THEN DO:
        x-stkact = 0.
        FIND b-almmmate WHERE B-Almmmate.CodCia = Almmmatg.CodCia
                         AND  B-Almmmate.CodAlm = "03"
                         AND  B-Almmmate.codmat = Almmmatg.CodMat
                        NO-LOCK NO-ERROR.
        IF AVAIL b-almmmate THEN x-stkact = x-stkact + b-Almmmate.StkAct.
        FIND b-almmmate WHERE B-Almmmate.CodCia = Almmmatg.CodCia
                         AND  B-Almmmate.CodAlm = "04"
                         AND  B-Almmmate.codmat = Almmmatg.CodMat
                        NO-LOCK NO-ERROR.
        IF AVAIL b-almmmate THEN x-stkact = x-stkact + b-Almmmate.StkAct.
        FIND b-almmmate WHERE B-Almmmate.CodCia = Almmmatg.CodCia
                         AND  B-Almmmate.CodAlm = "05"
                         AND  B-Almmmate.codmat = Almmmatg.CodMat
                        NO-LOCK NO-ERROR.
        IF AVAIL b-almmmate THEN x-stkact = x-stkact + b-Almmmate.StkAct.
        FIND b-almmmate WHERE B-Almmmate.CodCia = Almmmatg.CodCia
                         AND  B-Almmmate.CodAlm = "83"
                         AND  B-Almmmate.codmat = Almmmatg.CodMat
                        NO-LOCK NO-ERROR.
        IF AVAIL b-almmmate THEN x-stkact = x-stkact + b-Almmmate.StkAct.
        FIND b-almmmate WHERE B-Almmmate.CodCia = Almmmatg.CodCia
                         AND  B-Almmmate.CodAlm = "89"
                         AND  B-Almmmate.codmat = Almmmatg.CodMat
                        NO-LOCK NO-ERROR.
        IF AVAIL b-almmmate THEN x-stkact = x-stkact + b-Almmmate.StkAct.

        t-stkact = x-stkact.
        
        t-nro_per = t-stkact / t-tot_vta.
        t-nro_dia = t-nro_per * x-dia.
        t-totald  = t-totals * t-tot_vta.
      END.
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
  DISPLAY F-CodFam F-SubFam F-prov1 F-prov2 DesdeC HastaC DesdeF HastaF nCodMon 
          R-Tipo F-DesFam F-DesSub 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE F-CodFam F-SubFam F-prov1 F-prov2 DesdeC HastaC DesdeF HastaF nCodMon 
         R-Tipo Btn_OK Btn_Cancel Btn_Help RECT-57 
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
  DEFINE VARIABLE x-codpro LIKE Almcmov.codpro NO-UNDO.
  DEFINE VARIABLE x-codcli LIKE Almcmov.codcli NO-UNDO.
  DEFINE VARIABLE x-nrorf1 LIKE Almcmov.nrorf1 NO-UNDO.
  DEFINE VARIABLE x-nrorf2 LIKE Almcmov.nrorf2 NO-UNDO.
  DEFINE VARIABLE x-codmov LIKE Almcmov.codmov NO-UNDO.
  DEFINE VARIABLE x-codmon LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-tpocmb LIKE Almdmov.candes NO-UNDO.

  DEFINE VARIABLE tot_vta AS DECIMAL.
  DEFINE VARIABLE nro_per AS DECIMAL.
  DEFINE VARIABLE nro_dia AS DECIMAL.
  DEFINE VARIABLE imp_tots AS DECIMAL.
  DEFINE VARIABLE imp_totd AS DECIMAL.
  imp_totd = 0.
  /* Tipo de movimiento de la salida por G/R */
  FIND FacDocum WHERE FacDocum.CodCia = s-codcia 
                 AND  FacDocum.CodDoc = 'G/R' 
                NO-LOCK NO-ERROR.
  IF AVAILABLE FacDocum THEN x-codmov = FacDocum.CodMov.
  
  RUN carga-temporal.

  DEFINE FRAME F-REPORTE
         t-codmat
         t-DesMat    FORMAT "X(35)"
         t-DesMar    FORMAT "X(5)" 
         t-UndBas    FORMAT "X(4)"
         t-tot_uca            FORMAT "->>>>,>>9.99"
         t-tot_and            FORMAT "->>>>,>>9.99"
         t-tot_par            FORMAT "->>>>,>>9.99"
         t-tot_lau            FORMAT "->>>>,>>9.99"
         t-tot_vta            FORMAT "->>>>,>>9.99"
         t-StkAct    FORMAT "->>>>>,>>9.99"
      /* t-nro_per            FORMAT "->>>>9.99"  */
         t-nro_dia            FORMAT "->>>>9"    
         t-totald             FORMAT ">>>>,>>9.99"

 
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn3}*/ FORMAT "X(50)" AT 1 SKIP
         "REPORTE DE VENTAS" AT 62
         "Pagina :" TO 135 PAGE-NUMBER(REPORT) TO 147 FORMAT "ZZZZZ9" 
         SKIP
        /* S-DESALM  FORMAT "X(30)" AT 56*/
         "Fecha  :" TO 135 TODAY TO 147 FORMAT "99/99/9999" 
         SKIP
         "PERIODO DE VENTA : " AT 61 FORMAT "X(19)" STRING(x-dia, ">9") " DIAS" FORMAT "X(5)"
         "Hora   :" TO 135 STRING(TIME,"HH:MM:SS") TO 147  
         SKIP
         S-SUBTIT AT 1 SKIP
         "COSTOS EXPRESADOS EN " + IF NCODMON = 1 THEN "NUEVOS SOLES INCLUIDO IGV" ELSE "DOLARES AMERICANOS INCLUIDO IGV" AT 1 FORMAT "X(100)"  
          SKIP(1) 
        "-----------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                               V    E    N    T    A    S                                  STOCK   NRO        COSTO  " SKIP
        "CODIGO DESCRIPCION                         MARCA U.B       UCAYALI   ANDAHUAYLA       PARURO      LAUCHUN     TOTAL        TOTAL   DIAS       TOTAL  " SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo BREAK BY t-codfam 
                           BY t-subfam 
                           BY t-prove
                           BY t-codmat:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = t-CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT "FAMILIA : " Almtfami.codfam '    ' Almtfami.desfam SKIP.
/*             PUT STREAM REPORT '      ------------------------------------------' SKIP.*/
             PUT STREAM REPORT ' ' SKIP.
         END.
      END.
      IF FIRST-OF(t-SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = s-CodCia 
                        AND  Almsfami.codfam = t-CodFam 
                        AND  Almsfami.subfam = t-Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT  "SUB-FAMILIA : " Almsfami.subfam '   ' AlmSFami.dessub SKIP.
/*             PUT STREAM REPORT '      ------------------------------------------' SKIP.*/
             PUT STREAM REPORT ' ' SKIP.
         END.
      END.
      IF FIRST-OF(t-prove) THEN DO:
         FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia 
                       AND  GN-PROV.CODPRO = t-prove 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE GN-PROV THEN DO:
             PUT STREAM REPORT  "PROVEEDOR : " t-prove '    ' gn-prov.NomPro  SKIP.
/*             PUT STREAM REPORT '      ------------------------------------------' SKIP.*/
             PUT STREAM REPORT ' ' SKIP.
         END.  
      END.
      imp_totd = imp_totd + t-totald   .
      DISPLAY STREAM REPORT 
               t-codmat
               t-DesMat
               t-DesMar
               t-UndBas
               t-tot_uca
               t-tot_and
               t-tot_par
               t-tot_lau
               t-tot_vta
               t-StkAct
           /*  t-nro_per */
               t-nro_dia   
               t-totald
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.
  END.
  
  HIDE FRAME F-PROCESO.
  PUT STREAM REPORT " " SKIP(2).
  PUT STREAM REPORT "T O T A L   G E N E R A L     : " AT 50 
  IMP_TOTD AT 100 FORMAT ">>>,>>>,>>9.99".
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
  
   
  RUN Formato.
  
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
  ASSIGN F-prov1 F-prov2 DesdeC DesdeF F-CodFam F-DesFam HastaC HastaF nCodMon R-Tipo.
  
  IF F-prov2 <> "" THEN F-prov2 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE xxx W-Win 
PROCEDURE xxx :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*  FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA 
 *                              AND  Almmmate.CodAlm = S-CODALM 
 *                              AND  Almmmate.CodMat >= DesdeC  
 *                              AND  Almmmate.CodMat <= HastaC , 
 *       EACH Almmmatg OF Almmmate NO-LOCK WHERE Almmmatg.codfam BEGINS F-CodFam 
 *                                          AND  Almmmatg.subfam BEGINS F-SubFam
 *                                         BREAK BY Almmmate.CodCia 
 *                                               BY Almmmatg.CodFam
 *                                               BY Almmmatg.subfam
 *                                               BY Almmmate.Codmat:
 *       IF Almmmatg.FchCes <> ? THEN NEXT.
 *       DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
 *               FORMAT "X(11)" WITH FRAME F-Proceso.
 *               
 *       VIEW STREAM REPORT FRAME F-HEADER.
 *       
 * /*      IF FIRST-OF(Almmmate.CodMat) THEN DO:
 *  *          /* BUSCAMOS SI TIENE MOVIMEINTOS ANTERIORES A DesdeF */
 *  *          FIND LAST DMOV WHERE DMOV.CodCia = S-CODCIA 
 *  *                          AND  DMOV.CodAlm = Almmmate.CodAlm 
 *  *                          AND  DMOV.CodMat = Almmmate.CodMat 
 *  *                          AND  DMOV.FchDoc < DesdeF 
 *  *                         USE-INDEX Almd03 NO-LOCK NO-ERROR.
 *  *          F-STKGEN = 0.
 *  *          F-Saldo = 0.
 *  *          IF AVAILABLE DMOV THEN DO:
 *  *             F-Saldo  = DMOV.StkSub.
 *  *             F-STKGEN = DMOV.StkAct.
 *  *             F-VALCTO = IF nCodMon = 1 THEN DMOV.VctoMn1 ELSE DMOV.VctoMn2.
 *  *          END.
 *  *          F-VALCTO = IF F-STKGEN = 0 THEN 0 ELSE F-VALCTO.
 *  *          F-PRECIO = IF F-STKGEN = 0 THEN 0 ELSE ROUND(F-VALCTO / F-STKGEN,2).
 *  * /*         F-VALCTO = F-PRECIO * F-Saldo.*/
 *  *          PUT STREAM REPORT Almmmate.CodMat AT 2 FORMAT "X(9)"
 *  *                            Almmmatg.DesMat AT 14 FORMAT "X(50)"
 *  *                            Almmmatg.UndStk AT 66 FORMAT "X(4)" 
 *  *                            F-Saldo         AT 86
 *  *                            F-PRECIO        AT 106
 *  *                            F-VALCTO        AT 118.
 *  *          DOWN STREAM REPORT WITH FRAME F-REPORTE.
 *  *       END.*/
 *       x-codpro = "".
 *       x-codcli = "".
 *       x-nrorf1 = "".
 *       x-nrorf2 = "".
 * 
 *      FOR EACH Almdmov WHERE Almdmov.CodCia = Almmmate.CodCia 
 *                        AND  Almdmov.CodAlm = Almmmate.CodAlm 
 *                        AND  Almdmov.codmat = Almmmate.CodMat
 *                        AND  STRING(Almdmov.CodMov,"99") = S-CodMov 
 *                        AND  Almdmov.FchDoc >= DesdeF
 *                        AND  Almdmov.FchDoc <= HastaF
 *                       NO-LOCK 
 *                       BREAK BY Almdmov.Codcia
 *                             BY Almdmov.Codmat
 *                             BY Almdmov.FchDoc
 *                             BY Almdmov.CodMov
 *                             BY Almdmov.NroDoc :
 *         FIND Almcmov WHERE Almcmov.CodCia = Almdmov.codcia 
 *                       AND  Almcmov.CodAlm = Almdmov.codalm 
 *                       AND  Almcmov.TipMov = Almdmov.tipmov 
 *                       AND  Almcmov.CodMov = Almdmov.codmov 
 *                       AND  Almcmov.NroDoc = Almdmov.nrodoc 
 *                      NO-LOCK NO-ERROR.
 *         IF NOT AVAILABLE Almcmov THEN DO:
 * /*           IF Almdmov.CodMov = x-codmov THEN DO:
 *  *               FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia 
 *  *                              AND  CcbCDocu.CodDoc = 'G/R' 
 *  *                              AND  CcbCDocu.NroDoc = STRING(Almdmov.nroser,'999') + STRING(Almdmov.Nrodoc,'999999') 
 *  *                             NO-LOCK NO-ERROR.
 *  *               IF AVAILABLE CcbCDocu THEN 
 *  *                  ASSIGN
 *  *                     x-codcli = CcbCDocu.codcli
 *  *                     x-nrorf1 = CcbCDocu.Nroped.
 *  *            END.
 *  *            x-codmon = 1.
 *  *            x-tpocmb = 1.*/
 *         END.
 * /*        ELSE
 *  *            ASSIGN
 *  *               x-codpro = Almcmov.codpro
 *  *               x-codcli = Almcmov.codcli
 *  *               x-nrorf1 = Almcmov.nrorf1
 *  *               x-nrorf2 = Almcmov.nrorf2
 *  *               x-codmon = Almcmov.codmon
 *  *               x-tpocmb = Almcmov.tpocmb.*/
 *         
 *         F-Saldo   = F-Saldo + (Almdmov.CanDes * Almdmov.Factor).
 *         F-STKGEN = Almdmov.StkAct.
 * 
 *         ACCUMULATE F-Ingreso (TOTAL BY Almmmate.CodMat).
 *         ACCUMULATE F-Salida  (TOTAL BY Almmmate.CodMat).
 * 
 *         DISPLAY STREAM REPORT 
 *                  Almdmov.codmat
 *                  Almmmatg.DesMat
 *                  Almmmatg.UndBas
 *                  F-Saldo
 *                  WITH FRAME F-REPORTE.
 *          DOWN STREAM REPORT WITH FRAME F-REPORTE.
 *       END.
 * /*      IF LAST-OF(Almmmate.CodMat) THEN DO:
 *  *          UNDERLINE STREAM REPORT F-Ingreso F-Salida F-Saldo F-PRECIO F-VALCTO WITH FRAME F-REPORTE.
 *  *          DISPLAY STREAM  REPORT 
 *  *                  ACCUM TOTAL BY Almmmate.CodMat F-Ingreso @ F-Ingreso 
 *  *                  ACCUM TOTAL BY Almmmate.CodMat F-Salida  @ F-Salida  
 *  *                  F-Saldo F-PRECIO F-VALCTO WITH FRAME F-REPORTE.
 *  *          UNDERLINE STREAM REPORT F-Ingreso F-Salida F-Saldo F-PRECIO F-VALCTO WITH FRAME F-REPORTE.
 *  *          DOWN STREAM REPORT WITH FRAME F-REPORTE.
 *  *       END.*/
 *   END.
 *   HIDE FRAME F-PROCESO.*/

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

