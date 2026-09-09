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
DEFINE SHARED VAR S-CODDIV AS CHARACTER.

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

DEFINE TEMP-TABLE tmp-tabla LIKE CcbDDocu.

DEFINE STREAM STEXTO.
DEFINE VARIABLE FILE-TEXTO AS CHARACTER.

DEFINE VARIABLE mens1 AS CHARACTER.

DEFINE TEMP-TABLE tmp-tabla1 
    FIELD codcia LIKE CcbCDocu.CodCia
    FIELD t-coddoc LIKE CcbCDocu.CodDoc
    FIELD t-fmapgo LIKE CcbCDocu.FmaPgo
    FIELD t-codfam LIKE Almmmatg.CodFam
    FIELD t-subfam LIKE Almmmatg.SubFam
    FIELD codmat LIKE CcbDDocu.CodMat
    FIELD t-desmat LIKE Almmmatg.DesMat
    FIELD t-undstk LIKE Almmmatg.UndStk
    FIELD t-implin LIKE CcbDDocu.ImpLin
    FIELD t-candes LIKE CcbDDocu.CanDes
    FIELD t-undvta LIKE CcbDDocu.UndVta
    FIELD t-ctotot LIKE Almmmatg.CtoTot 
    FIELD t-tpocmb LIKE Almmmatg.TpoCmb
    FIELD t-tpocmb1 LIKE CcbCDocu.Tpocmb
    FIELD t-codmon LIKE CcbcDocu.Codmon
    INDEX idx01 codcia codmat.

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
&Scoped-Define ENABLED-OBJECTS F-CodDiv F-CodFam F-SubFam DesdeC HastaC ~
DesdeF HastaF T-txt Btn_OK Btn_Cancel Btn_Help RECT-57 
&Scoped-Define DISPLAYED-OBJECTS x-mensaje F-CodDiv F-CodFam F-SubFam ~
DesdeC HastaC DesdeF HastaF T-txt F-desdiv F-DesFam F-DesSub F-NomArch 

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

DEFINE VARIABLE F-CodDiv AS CHARACTER FORMAT "XX-XXX":U 
     LABEL "Pto. de Venta" 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .69
     BGCOLOR 15 FGCOLOR 1 FONT 6 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-desdiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.86 BY .69
     FONT 6 NO-UNDO.

DEFINE VARIABLE F-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .69 NO-UNDO.

DEFINE VARIABLE F-NomArch AS CHARACTER FORMAT "X(256)":U 
     LABEL "C:/TEMP/" 
     VIEW-AS FILL-IN 
     SIZE 39.86 BY .81 NO-UNDO.

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

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 69.14 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.86 BY 8.96.

DEFINE VARIABLE T-txt AS LOGICAL INITIAL no 
     LABEL "Archivo Txt." 
     VIEW-AS TOGGLE-BOX
     SIZE 11.43 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-mensaje AT ROW 8.81 COL 2.86 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     F-CodDiv AT ROW 1.58 COL 9.86
     F-CodFam AT ROW 2.35 COL 18 COLON-ALIGNED
     F-SubFam AT ROW 3.12 COL 18 COLON-ALIGNED
     DesdeC AT ROW 4.12 COL 18 COLON-ALIGNED
     HastaC AT ROW 4.12 COL 47 COLON-ALIGNED
     DesdeF AT ROW 4.81 COL 18 COLON-ALIGNED
     HastaF AT ROW 4.81 COL 47 COLON-ALIGNED
     T-txt AT ROW 6.65 COL 20
     Btn_OK AT ROW 10.35 COL 46.29
     Btn_Cancel AT ROW 10.35 COL 57.57
     F-desdiv AT ROW 1.58 COL 27.14 COLON-ALIGNED NO-LABEL
     F-DesFam AT ROW 2.35 COL 24.29 COLON-ALIGNED NO-LABEL
     F-DesSub AT ROW 3.12 COL 24.29 COLON-ALIGNED NO-LABEL
     F-NomArch AT ROW 6.62 COL 38 COLON-ALIGNED
     Btn_Help AT ROW 10.35 COL 69
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     RECT-46 AT ROW 10.23 COL 1
     RECT-57 AT ROW 1.27 COL 1.14
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
         TITLE              = "Ventas por Punto de Venta"
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
/* SETTINGS FOR FILL-IN F-CodDiv IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN F-desdiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomArch IN FRAME F-Main
   NO-ENABLE                                                            */
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
ON END-ERROR OF W-Win /* Ventas por Punto de Venta */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ventas por Punto de Venta */
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


&Scoped-define SELF-NAME F-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodDiv W-Win
ON LEAVE OF F-CodDiv IN FRAME F-Main /* Pto. de Venta */
DO:
    ASSIGN
        F-CodDiv.
        
     FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA
                   AND  GN-DIVI.CodDiv = F-CodDiv
                  NO-LOCK NO-ERROR.
     IF AVAIL GN-DIVI THEN 
        F-desdiv:SCREEN-VALUE = GN-DIVI.DesDiv.
     ELSE 
        F-desdiv:SCREEN-VALUE = "NO-EXISTE".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodDiv W-Win
ON MOUSE-SELECT-DBLCLICK OF F-CodDiv IN FRAME F-Main /* Pto. de Venta */
DO:
  {CBD/H-DIVI01.I NO SELF}

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


&Scoped-define SELF-NAME T-txt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-txt W-Win
ON VALUE-CHANGED OF T-txt IN FRAME F-Main /* Archivo Txt. */
DO:
  ASSIGN T-txt.

  F-NomArch:SENSITIVE = T-txt.

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
  ASSIGN DesdeC DesdeF F-CodFam F-DesFam HastaC HastaF F-CodDiv T-txt
         F-NomArch.

  IF HastaC <> "" THEN 
    S-SUBTIT = "Materiales del " + DesdeC + " al " + HastaC .
  ELSE 
    S-SUBTIT = "".

  IF HastaC = "" THEN HastaC = "999999999".
    
  S-SUBTIT = "Periodo del " + STRING(DesdeF) + " al " + STRING(HastaF).
  MENS1 = F-CodDiv + " : " + F-desdiv.


  IF HastaC = "" THEN HastaC = "999999".
  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-temporal W-Win 
PROCEDURE Crea-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-codvar AS CHARACTER.
  
  FOR EACH tmp-tabla :
    DELETE tmp-tabla.
  END.

  FOR EACH tmp-tabla1 :
    DELETE tmp-tabla1.
  END.
  
  FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = S-CODCIA
                     AND  CcbCDocu.CodDiv = F-CodDiv /*S-CODDIV*/
                     AND  (CcbCDocu.FchDoc >= DesdeF
                     AND   CcbCDocu.FchDoc <= HastaF)
                     AND  LOOKUP(CcbCDocu.CodDoc, "FAC,BOL") > 0
                    NO-LOCK USE-INDEX LLAVE10,
      EACH CcbDDocu OF CcbCDocu WHERE CcbDDocu.CodCia = CcbCDocu.CodCia 
                                 AND  CcbDDocu.CodCli BEGINS "" 
                                 AND  (CcbDDocu.CodMat >= DesdeC
                                 AND   CcbDDocu.CodMat <= HastaC)
                                NO-LOCK:
      FIND Almmmatg WHERE Almmmatg.CodCia = CcbDDocu.CodCia
                     AND  Almmmatg.CodMat = CcbDDocu.CodMat
                    NO-LOCK NO-ERROR.
      IF NOT AVAIL Almmmatg THEN NEXT.
      IF F-CodFam <> "" THEN DO:
          IF NOT (Almmmatg.CodFam = F-CodFam) THEN NEXT.
      END.
      IF F-SubFam <> "" THEN DO: 
          IF NOT (Almmmatg.SubFam = F-SubFam) THEN NEXT.
      END.

      /*
       DISPLAY ccbddocu.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
               FORMAT "X(11)" WITH FRAME F-Proceso.
      */
      DISPLAY "Codigo de Articulo: " + ccbddocu.CodMat @ x-mensaje 
          WITH FRAME {&FRAME-NAME}.

      CREATE tmp-tabla.
      RAW-TRANSFER CcbDDocu TO tmp-tabla.  
      
      x-codvar = IF LOOKUP(CcbCDocu.FmaPgo,"000,001,002") > 0 THEN "CON" ELSE "CRE".
      FIND tmp-tabla1 WHERE t-fmapgo = x-codvar
                       AND  tmp-tabla1.CodCia = CcbDDocu.CodCia
                       AND  tmp-tabla1.t-codfam = Almmmatg.CodFam
                       AND  tmp-tabla1.t-subfam = Almmmatg.SubFam
                       AND  tmp-tabla1.codmat = CcbDDocu.CodMat
                      NO-ERROR.
      IF NOT AVAIL tmp-tabla1 THEN DO:
        CREATE tmp-tabla1.
        ASSIGN tmp-tabla1.t-fmapgo = x-codvar
               tmp-tabla1.CodCia = CcbDDocu.CodCia
               tmp-tabla1.t-codfam = Almmmatg.CodFam
               tmp-tabla1.t-subfam = Almmmatg.SubFam
               tmp-tabla1.codmat = CcbDDocu.CodMat
               tmp-tabla1.t-desmat = Almmmatg.DesMat
               tmp-tabla1.t-undstk = Almmmatg.UndStk
               tmp-tabla1.t-undvta = CcbDDocu.UndVta
               tmp-tabla1.t-ctotot = IF Almmmatg.AftIgv THEN 
                                        Almmmatg.CtoTot / (1 + CcbCDocu.PorIgv / 100) 
                                     ELSE
                                        Almmmatg.CtoTot
               tmp-tabla1.t-tpocmb = Almmmatg.TpoCmb
               tmp-tabla1.t-tpocmb1 = CcbCDocu.Tpocmb
               tmp-tabla1.t-codmon = CcbcDocu.Codmon
               tmp-tabla1.t-coddoc = CcbCDocu.CodDoc.
      END.
/*
   X-CTOTOT = Almmmatg.CtoTot.
   IF Almmmatg.AftIgv THEN X-CTOTOT = X-CTOTOT / (1 + FacCfgGn.PorIgv / 100).

        F-ImpBrt = (IF X-MON = 'S/.' THEN Impbrt ELSE Impbrt * x-tpocmb).
        F-ImpDto = (IF X-MON = 'S/.' THEN ImpDto ELSE ImpDto * x-tpocmb).
*/
      IF x-codvar = "CON" THEN DO:
        IF CcbCDocu.CodMon = 1 THEN 
            ASSIGN
              tmp-tabla1.t-implin = tmp-tabla1.t-implin + (IF CcbDDocu.AftIgv THEN
                                                              CcbDDocu.ImpLin - CcbDDocu.ImpIgv
                                                           ELSE
                                                              CcbDDocu.ImpLin).
         ELSE 
            ASSIGN
              tmp-tabla1.t-implin = tmp-tabla1.t-implin + (IF CcbDDocu.AftIgv THEN
                                                              CcbCDocu.TpoCmb * (CcbDDocu.ImpLin - CcbDDocu.ImpIgv)
                                                           ELSE
                                                              CcbCDocu.TpoCmb * CcbDDocu.ImpLin).
      END.
      ELSE
        ASSIGN
          tmp-tabla1.t-implin = tmp-tabla1.t-implin + (IF CcbDDocu.AftIgv THEN
                                                          CcbDDocu.ImpLin - CcbDDocu.ImpIgv
                                                       ELSE
                                                          CcbDDocu.ImpLin).
      tmp-tabla1.t-candes = tmp-tabla1.t-candes + (CcbDDocu.CanDes * CcbDDocu.Factor).
      
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
  DISPLAY x-mensaje F-CodDiv F-CodFam F-SubFam DesdeC HastaC DesdeF HastaF T-txt 
          F-desdiv F-DesFam F-DesSub F-NomArch 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE F-CodDiv F-CodFam F-SubFam DesdeC HastaC DesdeF HastaF T-txt Btn_OK 
         Btn_Cancel Btn_Help RECT-57 
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
  DEFINE VARIABLE S-CODMOV AS CHAR NO-UNDO.
  DEFINE VARIABLE x-codpro LIKE Almcmov.codpro NO-UNDO.
  DEFINE VARIABLE x-codcli LIKE Almcmov.codcli NO-UNDO.
  DEFINE VARIABLE x-nrorf1 LIKE Almcmov.nrorf1 NO-UNDO.
  DEFINE VARIABLE x-nrorf2 LIKE Almcmov.nrorf2 NO-UNDO.
  DEFINE VARIABLE x-codmov LIKE Almcmov.codmov NO-UNDO.
  DEFINE VARIABLE x-codmon LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-tpocmb LIKE Almdmov.candes NO-UNDO.

  RUN Crea-temporal.
  
  DEFINE FRAME F-REPORTE
/*        tmp-tabla1.t-coddoc
 *         tmp-tabla1.t-fmapgo*/
        tmp-tabla1.t-codfam
        tmp-tabla1.t-subfam
        tmp-tabla1.codmat
        tmp-tabla1.t-desmat
        tmp-tabla1.t-undstk
        tmp-tabla1.t-implin
        tmp-tabla1.t-candes
        tmp-tabla1.t-ctotot
        tmp-tabla1.t-tpocmb
        
        WITH WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} + {&Prn3} FORMAT "X(50)" AT 1 SKIP
         "VENTAS POR PUNTO DE VENTA" AT 62
         "Pagina :" TO 125 PAGE-NUMBER(REPORT) TO 137 FORMAT "ZZZZZ9" SKIP
         
         "Fecha  :" TO 125 TODAY TO 137 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 125 STRING(TIME,"HH:MM") TO 137 SKIP
         S-SUBTIT AT 1 SKIP
         MENS1 AT 1 FORMAT "X(25)" SKIP
         "-------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "LIN SUB CODIGO  DESCRIPCION                                  UM.       PRECIO DE    CANTIDAD    COSTO DE REP.                        " SKIP
         "EA  LIN                                                      STK       VENTA        DE VENTA    SIN I.G.V.      T.C.                 " SKIP
         "-------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH PAGE-TOP WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  IF T-txt THEN DO:
    IF F-NomArch = "" THEN 
        FILE-TEXTO = "C:/TEMP/" + "Prueba.txt".
    ELSE 
        FILE-TEXTO = "C:/TEMP/" + TRIM(F-NomArch) + ".txt".
        
    OUTPUT STREAM STEXTO TO VALUE(FILE-TEXTO) /*PAGE-SIZE 62 /*PAGED*/*/.
  END.

  IF T-txt THEN DO:
    PUT STREAM STEXTO "'';".
    PUT STREAM STEXTO "'';".
    PUT STREAM STEXTO "'';".
    PUT STREAM STEXTO "'" TRIM("PUNTO DE VENTA " + MENS1) FORMAT "X(40)" "'".
    PUT STREAM STEXTO SKIP(2).

    PUT STREAM STEXTO "'LINEA';".
    PUT STREAM STEXTO "'SUBLINEA';".
    PUT STREAM STEXTO "'CODIGO';".
    PUT STREAM STEXTO "'DESCRIPCION';".
    PUT STREAM STEXTO "'U.M.';".
    PUT STREAM STEXTO "'PRECIO DE';".
    PUT STREAM STEXTO "'CANTIDAD';".
    PUT STREAM STEXTO "'COSTO DE REP.';".
    PUT STREAM STEXTO "'TIPO DE'".
    PUT STREAM STEXTO SKIP.

    PUT STREAM STEXTO "'';".
    PUT STREAM STEXTO "'';".
    PUT STREAM STEXTO "'';".
    PUT STREAM STEXTO "'';".
    PUT STREAM STEXTO "'STOCK';".
    PUT STREAM STEXTO "'VENTA';".
    PUT STREAM STEXTO "'DE VENTA';".
    PUT STREAM STEXTO "'SIN I.G.V.';".
    PUT STREAM STEXTO "'CAMBIO'".
    PUT STREAM STEXTO SKIP(2).

  END.

  FOR EACH tmp-tabla1 NO-LOCK,
      EACH Almmmatg OF tmp-tabla1 WHERE Almmmatg.CodCia = tmp-tabla1.CodCia
                                   AND  Almmmatg.CodMat = tmp-tabla1.CodMat
                                  NO-LOCK
                                  BREAK BY t-fmapgo
                                        BY Almmmatg.CodCia
                                        BY Almmmatg.CodFam
                                        BY Almmmatg.SubFam 
                                        BY Almmmatg.CodMat
                                        :
       /* 
       DISPLAY tmp-tabla1.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
               FORMAT "X(11)" WITH FRAME F-Proceso.
       */
       DISPLAY "Codigo de Articulo: " + tmp-tabla1.CodMat @ x-mensaje
           WITH FRAME {&FRAME-NAME}.
       VIEW STREAM REPORT FRAME F-HEADER.
       
       IF FIRST-OF(t-fmapgo) THEN DO:
            DISPLAY STREAM REPORT
                (IF t-fmapgo = "CON" THEN "*** VENTAS CONTADO (S/.) ***" ELSE "*** VENTAS CREDITO (USS.) ***") @ t-desmat
                WITH FRAME F-REPORTE.
            DOWN STREAM REPORT 2 WITH FRAME F-REPORTE.

             IF T-txt THEN DO:
                PUT STREAM STEXTO "'';".
                PUT STREAM STEXTO "'';".
                PUT STREAM STEXTO "'';".
                PUT STREAM STEXTO "'" TRIM((IF t-fmapgo = "CON" THEN "*** VENTAS CONTADO (S/.) ***" ELSE "*** VENTAS CREDITO (USS.) ***")) FORMAT "X(30)" "'".
                PUT STREAM STEXTO SKIP(1).
             END.
       END.

         ACCUMULATE tmp-tabla1.t-ImpLin (TOTAL BY Almmmatg.SubFam).
         ACCUMULATE tmp-tabla1.t-ImpLin (TOTAL BY Almmmatg.CodFam).
         ACCUMULATE tmp-tabla1.t-ImpLin (TOTAL BY t-fmapgo).

        DISPLAY STREAM REPORT 
                 tmp-tabla1.t-codfam     WHEN FIRST-OF(Almmmatg.CodFam)
                 tmp-tabla1.t-subfam     WHEN FIRST-OF(Almmmatg.SubFam)
                 tmp-tabla1.codmat
                 tmp-tabla1.t-desmat
                 tmp-tabla1.t-undstk
                 tmp-tabla1.t-implin
                 tmp-tabla1.t-candes
                 tmp-tabla1.t-ctotot
                 tmp-tabla1.t-tpocmb
                 WITH FRAME F-REPORTE.
         DOWN STREAM REPORT WITH FRAME F-REPORTE.

/************
        F-ImpBrt = (IF X-MON = 'S/.' THEN Impbrt ELSE Impbrt * x-tpocmb).
        F-ImpDto = (IF X-MON = 'S/.' THEN ImpDto ELSE ImpDto * x-tpocmb).
*************/

         IF T-txt THEN DO:
            PUT STREAM STEXTO "'" TRIM(tmp-tabla1.t-CodFam) "';".
            PUT STREAM STEXTO "'" TRIM(tmp-tabla1.t-SubFam) "';".
            PUT STREAM STEXTO "'" TRIM(tmp-tabla1.CodMat) "';".
            PUT STREAM STEXTO "'" TRIM(tmp-tabla1.t-DesMat) FORMAT "X(40)" "';".
            PUT STREAM STEXTO "'" TRIM(tmp-tabla1.t-UndStk) "';".
            PUT STREAM STEXTO tmp-tabla1.t-ImpLin FORMAT "->>>>>>9.99" ";".
            PUT STREAM STEXTO tmp-tabla1.t-candes FORMAT "->>>>>>9.9999" ";".
            PUT STREAM STEXTO tmp-tabla1.t-CtoTot FORMAT "->>>>>>9.99" ";".
            PUT STREAM STEXTO tmp-tabla1.t-TpoCmb FORMAT "->>>9.9999" SKIP.
         END.
         
         IF LAST-OF(Almmmatg.SubFam) THEN DO:
            FIND Almsfami WHERE Almsfami.CodCia = s-CodCia 
                           AND  Almsfami.codfam = Almmmatg.CodFam 
                           AND  Almsfami.subfam = Almmmatg.SubFam 
                          NO-LOCK NO-ERROR.
            UNDERLINE STREAM REPORT
                tmp-tabla1.t-desmat
                tmp-tabla1.t-implin
                WITH FRAME F-REPORTE.
             DISPLAY STREAM REPORT
                ("SUB-LINEA : " + TRIM(tmp-tabla1.t-SubFam) + " : " + (IF AVAIL AlmSFami THEN TRIM(AlmSFami.dessub) ELSE "NO EXISTE")) @ tmp-tabla1.t-desmat
                ACCUM TOTAL BY Almmmatg.SubFam tmp-tabla1.t-ImpLin @ tmp-tabla1.t-ImpLin
                WITH FRAME F-REPORTE.
                 
             IF T-txt THEN DO:
                PUT STREAM STEXTO "'';".
                PUT STREAM STEXTO "'';".
                PUT STREAM STEXTO "'';".
                PUT STREAM STEXTO "'" TRIM("SUB-LINEA : " + TRIM(tmp-tabla1.t-SubFam) + " : " + (IF AVAIL AlmSFami THEN TRIM(AlmSFami.dessub) ELSE "NO EXISTE")) FORMAT "X(60)" "';".
                PUT STREAM STEXTO "'';".
                PUT STREAM STEXTO (ACCUM TOTAL BY Almmmatg.SubFam tmp-tabla1.t-ImpLin) FORMAT "->>>>>>9.99".
                PUT STREAM STEXTO SKIP.
             END.
         END.
         
         IF LAST-OF(Almmmatg.CodFam) THEN DO:
            FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                           AND  Almtfami.codfam = t-CodFam 
                          NO-LOCK NO-ERROR.
            UNDERLINE STREAM REPORT
                tmp-tabla1.t-desmat
                tmp-tabla1.t-implin
                WITH FRAME F-REPORTE.
             DISPLAY STREAM REPORT
                ("LINEA : " + TRIM(tmp-tabla1.t-CodFam) + " : " + TRIM(Almtfami.desfam)) @ tmp-tabla1.t-desmat
                ACCUM TOTAL BY Almmmatg.CodFam tmp-tabla1.t-ImpLin @ tmp-tabla1.t-ImpLin
                WITH FRAME F-REPORTE.
             DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.

             IF T-txt THEN DO:
                PUT STREAM STEXTO "'';".
                PUT STREAM STEXTO "'';".
                PUT STREAM STEXTO "'';".
                PUT STREAM STEXTO "'" TRIM("LINEA : " + TRIM(tmp-tabla1.t-CodFam) + " : " + TRIM(Almtfami.desfam)) FORMAT "X(60)" "';".
                PUT STREAM STEXTO "'';".
                PUT STREAM STEXTO (ACCUM TOTAL BY Almmmatg.CodFam tmp-tabla1.t-ImpLin) FORMAT "->>>>>>9.99".
                PUT STREAM STEXTO SKIP(1).
             END.
         END.

         IF LAST-OF(t-fmapgo) THEN DO:
            UNDERLINE STREAM REPORT
                tmp-tabla1.t-desmat
                tmp-tabla1.t-implin
                WITH FRAME F-REPORTE.
             DISPLAY STREAM REPORT
                ("TOTAL " + TRIM((IF t-fmapgo = "CON" THEN "VENTAS CONTADO" ELSE "VENTAS CREDITO"))) @ tmp-tabla1.t-desmat
                ACCUM TOTAL BY t-fmapgo tmp-tabla1.t-ImpLin @ tmp-tabla1.t-ImpLin
                WITH FRAME F-REPORTE.
             DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.

             IF T-txt THEN DO:
                PUT STREAM STEXTO "'';".
                PUT STREAM STEXTO "'';".
                PUT STREAM STEXTO "'';". 
                PUT STREAM STEXTO "'" TRIM("TOTAL " + TRIM((IF t-fmapgo = "CON" THEN "VENTAS CONTADO" ELSE "VENTAS CREDITO"))) FORMAT "X(25)" "';".
                PUT STREAM STEXTO "'';".
                PUT STREAM STEXTO (ACCUM TOTAL BY t-fmapgo tmp-tabla1.t-ImpLin) FORMAT "->>>>>>9.99".
                PUT STREAM STEXTO SKIP(1).
             END.
         END.
  END.
  /*
  HIDE FRAME F-PROCESO.
  */
  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
  IF T-txt THEN
      OUTPUT STREAM STEXTO CLOSE.

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
    ENABLE ALL EXCEPT F-DesFam F-DesSub F-desdiv x-mensaje.
    
    F-NomArch:SENSITIVE = T-txt.
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
        RUN Formato.
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
  ASSIGN DesdeC DesdeF F-CodFam F-DesFam HastaC HastaF .
  
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
     ASSIGN DesdeF = TODAY  + 1 - DAY(TODAY)
            HastaF = TODAY
            F-CodDiv = S-CODDIV.
            
     FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA
                   AND  GN-DIVI.CodDiv = F-CodDiv
                  NO-LOCK NO-ERROR.
     F-desdiv = GN-DIVI.DesDiv.
     DISPLAY DesdeF HastaF F-CodDiv F-desdiv.
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

