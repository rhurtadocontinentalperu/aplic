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

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR pv-codcia AS INT.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHAR.

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

/*******/

/* Local Variable Definitions ---                                       */
DEFINE VAR C-DESMOV      AS CHAR NO-UNDO.
DEFINE VAR C-OP          AS CHAR NO-UNDO.
DEFINE VAR X-PROCEDENCIA AS CHAR NO-UNDO.
DEFINE VAR x-codmov      AS CHAR NO-UNDO.
DEFINE VAR X-CODPRO      AS CHAR NO-UNDO.

DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
DEFINE VAR x-titulo2 AS CHAR NO-UNDO.
DEFINE VAR x-tipmov  AS CHAR NO-UNDO.
DEFINE VAR x-desmat  AS CHAR NO-UNDO.
DEFINE VAR x-desmar  AS CHAR NO-UNDO.
DEFINE VAR x-flgest  AS CHAR NO-UNDO.
DEFINE VAR X-Movi    AS CHAR NO-UNDO.

DEFINE TEMP-TABLE Detalle LIKE Almcmov.

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
&Scoped-Define ENABLED-OBJECTS RECT-60 RECT-62 COMBO-BOX-Almacen desdeF ~
hastaF I-CodMov C-Tipmov F-AlmDes FILL-IN-Usuario Btn_OK Btn_OK-2 ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Almacen desdeF hastaF I-CodMov ~
N-MOVI C-Tipmov x-Codig x-Nombr F-AlmDes F-NomDes FILL-IN-Usuario 

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

DEFINE BUTTON Btn_OK-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE C-Tipmov AS CHARACTER FORMAT "X(256)":U INITIAL "Ingreso" 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Ingreso","Salida" 
     DROP-DOWN-LIST
     SIZE 9.43 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Almacen AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Almacén" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE desdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE F-AlmDes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proc/Dest" 
     VIEW-AS FILL-IN 
     SIZE 6.14 BY .88 NO-UNDO.

DEFINE VARIABLE F-NomDes AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-Usuario AS CHARACTER FORMAT "x(10)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE hastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE I-CodMov AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88 NO-UNDO.

DEFINE VARIABLE N-MOVI AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.57 BY .88 NO-UNDO.

DEFINE VARIABLE x-Codig AS CHARACTER FORMAT "X(3)":U 
     LABEL "Cnd. Compra" 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .88 NO-UNDO.

DEFINE VARIABLE x-Nombr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60.43 BY 1.77.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60.43 BY 6.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Almacen AT ROW 1.27 COL 11 COLON-ALIGNED WIDGET-ID 6
     desdeF AT ROW 2.23 COL 11 COLON-ALIGNED
     hastaF AT ROW 2.23 COL 29 COLON-ALIGNED
     I-CodMov AT ROW 3.19 COL 20.72 COLON-ALIGNED NO-LABEL
     N-MOVI AT ROW 3.19 COL 24.86 COLON-ALIGNED NO-LABEL
     C-Tipmov AT ROW 3.23 COL 11 COLON-ALIGNED
     x-Codig AT ROW 4.12 COL 11 COLON-ALIGNED
     x-Nombr AT ROW 4.12 COL 17.72 COLON-ALIGNED NO-LABEL
     F-AlmDes AT ROW 5.12 COL 11 COLON-ALIGNED
     F-NomDes AT ROW 5.15 COL 17.57 COLON-ALIGNED NO-LABEL
     FILL-IN-Usuario AT ROW 6.12 COL 11 COLON-ALIGNED WIDGET-ID 4
     Btn_OK AT ROW 7.77 COL 28.14
     Btn_OK-2 AT ROW 7.81 COL 39.29 WIDGET-ID 2
     Btn_Cancel AT ROW 7.81 COL 50.57
     RECT-60 AT ROW 7.73 COL 2
     RECT-62 AT ROW 1 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62.29 BY 8.58
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
         TITLE              = "Analisis de Documentos"
         HEIGHT             = 8.58
         WIDTH              = 62.29
         MAX-HEIGHT         = 10.88
         MAX-WIDTH          = 81.43
         VIRTUAL-HEIGHT     = 10.88
         VIRTUAL-WIDTH      = 81.43
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
/* SETTINGS FOR FILL-IN F-NomDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN N-MOVI IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Codig IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Nombr IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Analisis de Documentos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Analisis de Documentos */
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
  ASSIGN C-TipMov DesdeF HastaF I-CodMov .
  CASE C-tipmov:
       WHEN "Ingreso" THEN X-Tipmov = "I".
       WHEN "Salida"  THEN X-Tipmov = "S".
  END.

  IF I-CODMOV <> '' 
  THEN DO:
        FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
                            Almtmovm.tipmov = X-TIPMOV AND
                            Almtmovm.codmov = integer(I-CodMov:screen-value)  NO-LOCK NO-ERROR.
        IF AVAILABLE Almtmovm THEN
        assign N-MOVI:screen-value = Almtmovm.Desmov.
        ELSE DO:
            MESSAGE "Movimiento No Existe ....." VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO I-Codmov.
            RETURN "ADM-ERROR".   
        END.
  END.
  ELSE  X-CODMOV = "".
  
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK-2 W-Win
ON CHOOSE OF Btn_OK-2 IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN C-TipMov DesdeF HastaF I-CodMov .
  CASE C-tipmov:
       WHEN "Ingreso" THEN X-Tipmov = "I".
       WHEN "Salida"  THEN X-Tipmov = "S".
  END.

  IF I-CODMOV <> '' 
  THEN DO:
        FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
                            Almtmovm.tipmov = X-TIPMOV AND
                            Almtmovm.codmov = integer(I-CodMov:screen-value)  NO-LOCK NO-ERROR.
        IF AVAILABLE Almtmovm THEN
        assign N-MOVI:screen-value = Almtmovm.Desmov.
        ELSE DO:
            MESSAGE "Movimiento No Existe ....." VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO I-Codmov.
            RETURN "ADM-ERROR".   
        END.
  END.
  ELSE  X-CODMOV = "".
  
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Excel.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-Tipmov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Tipmov W-Win
ON LEAVE OF C-Tipmov IN FRAME F-Main /* Tipo */
DO:
  FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
                      Almtmovm.tipmov = X-TIPMOV AND
                      Almtmovm.codmov = integer(I-CodMov:screen-value)  NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN
  assign
    N-MOVI:screen-value = Almtmovm.Desmov.
  ELSE DO:
      MESSAGE "Movimiento No Existe ....." VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  
  IF Almtmovm.MovTrf THEN DO:
      F-AlmDes:SENSITIVE = YES.
     
  END.
  ELSE DO:
      F-AlmDes:SENSITIVE = NO.
      F-NomDes:SCREEN-VALUE = "".
      F-AlmDes:SCREEN-VALUE = "".
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Tipmov W-Win
ON VALUE-CHANGED OF C-Tipmov IN FRAME F-Main /* Tipo */
DO:
  ASSIGN C-TIPMOV.
  
  CASE C-tipmov:
     WHEN "Ingreso" THEN X-Tipmov = "I".
     WHEN "Salida"  THEN X-Tipmov = "S".
  END.
  
  /* RHC 08.08.2006 */
  IF x-TipMov = 'I' AND I-CodMov:SCREEN-VALUE = '02'
  THEN ASSIGN
            x-Codig:SENSITIVE = YES.
  ELSE ASSIGN
            x-Codig:SCREEN-VALUE = ''
            x-Nombr:SCREEN-VALUE = ''
            x-Codig:SENSITIVE = NO.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-AlmDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-AlmDes W-Win
ON LEAVE OF F-AlmDes IN FRAME F-Main /* Proc/Dest */
DO:
  
  ASSIGN F-Almdes.
  IF F-Almdes = "" THEN DO:
     F-NomDes:SCREEN-VALUE = "". 
     RETURN.
  END.
  IF F-Almdes = S-CODALM THEN DO:
     MESSAGE "Almacen " S-CODALM " No puede transferir a si mismo" VIEW-AS ALERT-BOX.
     RETURN NO-APPLY.
  END.
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND  
                     Almacen.CodAlm = F-AlmDes
                     NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almacen THEN DO:
     MESSAGE "Almacen no existe......." VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  F-NomDes:SCREEN-VALUE = Almacen.Descripcion.
 
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Usuario W-Win
ON LEAVE OF FILL-IN-Usuario IN FRAME F-Main /* Usuario */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-CodMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-CodMov W-Win
ON F8 OF I-CodMov IN FRAME F-Main
DO:
  ASSIGN  input-var-1 = X-tipmov
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?.

  RUN lkup\C-TMovm ("Movimientos de Ingreso").
  IF output-var-2 = ? THEN output-var-2 = "". 
  /*
  I-Codmov = INTEGER(output-var-2).
  */
  I-CodMov = output-var-2.
  DO WITH FRAME {&FRAME-NAME}:
     Display I-Codmov .
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-CodMov W-Win
ON LEAVE OF I-CodMov IN FRAME F-Main
DO:
  /*
  FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
                      Almtmovm.tipmov = X-TIPMOV AND
                      Almtmovm.codmov = integer(I-CodMov:screen-value)  NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN
  assign
    N-MOVI:screen-value = Almtmovm.Desmov.
  ELSE DO:
      MESSAGE "Movimiento No Existe ....." VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  
  IF Almtmovm.MovTrf THEN DO:
      F-AlmDes:SENSITIVE = YES.
     
  END.
  ELSE DO:
      F-AlmDes:SENSITIVE = NO.
      F-NomDes:SCREEN-VALUE = "".
      F-AlmDes:SCREEN-VALUE = "".
  END.
  */
  /* RHC 27-03-04 acepte I-CodMov en blanco */
  IF SELF:SCREEN-VALUE = ''
  THEN DO:
    N-MOVI:screen-value = "Todos".
    F-AlmDes:SENSITIVE = NO.
    F-NomDes:SCREEN-VALUE = "".
    F-AlmDes:SCREEN-VALUE = "".
  END.
  ELSE DO:
    FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA 
        AND Almtmovm.tipmov = X-TIPMOV 
        AND Almtmovm.codmov = integer(I-CodMov:screen-value)  
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtmovm 
    THEN N-MOVI:screen-value = Almtmovm.Desmov.
    ELSE DO:
        MESSAGE "Movimiento No Existe ....." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF Almtmovm.MovTrf 
    THEN F-AlmDes:SENSITIVE = YES.
    ELSE DO:
        F-AlmDes:SENSITIVE = NO.
        F-NomDes:SCREEN-VALUE = "".
        F-AlmDes:SCREEN-VALUE = "".
    END.
  END.
  /* RHC 08.08.2006 */
  IF x-TipMov = 'I' AND I-CodMov:SCREEN-VALUE = '02'
  THEN ASSIGN
            x-Codig:SENSITIVE = YES.
  ELSE ASSIGN
            x-Codig:SCREEN-VALUE = ''
            x-Nombr:SCREEN-VALUE = ''
            x-Codig:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-CodMov W-Win
ON MOUSE-SELECT-DBLCLICK OF I-CodMov IN FRAME F-Main
DO:
  ASSIGN  input-var-1 = X-tipmov
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?.

  RUN lkup\C-TMovm ("Movimientos de " + C-tipmov).
  IF output-var-2 = ? THEN output-var-2 = "". 
  /*
  I-Codmov = INTEGER(output-var-2).
  */
  I-CodMov = output-var-2.
  DO WITH FRAME {&FRAME-NAME}:
     Display I-Codmov .
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Codig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Codig W-Win
ON LEAVE OF x-Codig IN FRAME F-Main /* Cnd. Compra */
DO:
  x-Nombr:SCREEN-VALUE = ''.
  FIND Gn-concp WHERE Gn-ConCp.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-concp THEN x-Nombr:SCREEN-VALUE = Gn-ConCp.Nombr.
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
  ASSIGN DesdeF HastaF C-tipmov I-Codmov F-Almdes COMBO-BOX-Almacen  x-Codig x-Nombr FILL-IN-Usuario.

  x-titulo2 = 'Del ' + STRING(DesdeF, '99/99/9999') + ' Al ' + STRING(HastaF, '99/99/9999').
  CASE C-TipMov:
     WHEN 'Ingreso' THEN ASSIGN
           x-titulo1 = 'ANALISIS DE DOCUMENTOS - INGRESOS'
           X-Tipmov = "I".
     WHEN 'Salida'  THEN ASSIGN
           x-titulo1 = 'ANALISIS DE DOCUMENTOS - SALIDAS'
           X-Tipmov = "S".
  END CASE.

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

DEF VAR x-CodAlm AS CHAR.

x-CodAlm = ENTRY(1, COMBO-BOX-Almacen, ' - ').
EMPTY TEMP-TABLE Detalle.

FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
    AND (COMBO-BOX-Almacen = 'Todos' OR Almacen.codalm = x-CodAlm):
    FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = S-CODCIA 
        AND Almcmov.codalm = Almacen.codalm
        AND (F-AlmDes = '' OR Almcmov.AlmDes = F-AlmDes)
        AND Almcmov.TipMov = X-TipMov 
        AND (I-CodMov = '' OR Almcmov.CodMov = INTEGER(I-CodMov)) 
        AND Almcmov.FchDoc >= DesdeF  
        AND Almcmov.FchDoc <= HastaF  
        AND Almcmov.FlgEst <> "A"     
        AND (FILL-IN-Usuario = '' OR Almcmov.usuario = FILL-IN-Usuario ):
        DISPLAY STRING (Almcmov.NroDoc) @ Fi-Mensaje LABEL "Numero de Movimiento"
                FORMAT "X(11)" 
                WITH FRAME F-Proceso.
        CREATE Detalle.
        BUFFER-COPY Almcmov TO Detalle.
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
  DISPLAY COMBO-BOX-Almacen desdeF hastaF I-CodMov N-MOVI C-Tipmov x-Codig 
          x-Nombr F-AlmDes F-NomDes FILL-IN-Usuario 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-60 RECT-62 COMBO-BOX-Almacen desdeF hastaF I-CodMov C-Tipmov 
         F-AlmDes FILL-IN-Usuario Btn_OK Btn_OK-2 Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
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
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE cFila1 AS CHAR FORMAT 'X' INIT ''.
DEFINE VARIABLE cFila2 AS CHAR FORMAT 'X' INIT ''.

/* VARIABLES DEL REPORTE */
DEF VAR x-CodAlm AS CHAR NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.

    RUN Carga-Temporal.
    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay registros que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("B"):NumberFormat = "@".
chWorkSheet:Columns("C"):NumberFormat = "@".
chWorkSheet:Columns("G"):NumberFormat = "@".
chWorkSheet:Columns("H"):NumberFormat = "@".
chWorkSheet:Columns("I"):NumberFormat = "@".
chWorkSheet:Columns("K"):NumberFormat = "@".
chWorkSheet:Columns("P"):NumberFormat = "@".

cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "ANALISIS DE DOCUMENTOS" .
t-column = t-column + 1. 
cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "ALMACEN ORIGEN" .
cRange = "B" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "NRO".                           
cRange = "C" + cColumn.                                                                                                                                                             
chWorkSheet:Range(cRange):Value = "ALMACEN DESTINO".                        
cRange = "D" + cColumn.                                                                                                                                                             
chWorkSheet:Range(cRange):Value = "FECHA".                          
cRange = "E" + cColumn.                                                                                                                                                             
chWorkSheet:Range(cRange):Value = "DESTINO".                        
cRange = "F" + cColumn.                                                                                                                                                             
chWorkSheet:Range(cRange):Value = "RESPONSABLE".                    

cRange = "G" + cColumn.                                                                                                                                                             
chWorkSheet:Range(cRange):Value = "COD REF".                   

cRange = "H" + cColumn.                                                                                                                                                             
chWorkSheet:Range(cRange):Value = "REFERENCIA 1".                   
cRange = "I" + cColumn.                                                                                                                                                             
chWorkSheet:Range(cRange):Value = "REFERENCIA 2".                   
cRange = "J" + cColumn.                                                                                                                                                             
chWorkSheet:Range(cRange):Value = "MOVIMIENTO".                     
cRange = "K" + cColumn.                                                                                                                                                             
chWorkSheet:Range(cRange):Value = "ESTADO".                         
cRange = "L" + cColumn. 
chWorkSheet:Range(cRange):Value = "ARTICULO".
cRange = "M" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "DESCRIPCION".
cRange = "N" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "MARCA".
cRange = "O" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "UND".
cRange = "P" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "CANTIDAD".
/* cRange = "Q" + cColumn.                                   */
/* chWorkSheet:Range(cRange):Value = "COSTO REPOSICION S/.". */
cRange = "Q" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "P.UNITARIO S/.".
cRange = "R" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "IMPORTE DEVOLUCION".
cRange = "S" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "PESO".
cRange = "T" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "PROPIO / TERCEROS".
cRange = "U" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "LINEA".
cRange = "V" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "SUBLINEA".
cRange = "W" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "PROVEEDOR".

/* cRange = "P" + cColumn.                            */
/* chWorkSheet:Range(cRange):Value = "P.UNITARIO S/". */
/* cRange = "Q" + cColumn.                            */
/* chWorkSheet:Range(cRange):Value = "COO".           */


FOR EACH Detalle NO-LOCK BREAK BY Detalle.CodAlm BY Detalle.NroDoc :
    /* RHC 08.08.2006 */
    IF x-TipMov = 'I' AND I-CodMov = '02' AND x-Codig <> '' THEN DO:
        /* Buscamos la Orden de Compra */
        FIND Lg-cocmp WHERE Lg-cocmp.codcia = s-codcia
            AND Lg-cocmp.coddiv = s-coddiv
            AND Lg-cocmp.nrodoc = INTEGER(Detalle.nrorf1) NO-LOCK NO-ERROR.
        IF NOT (AVAILABLE Lg-cocmp AND LG-COCmp.CndCmp BEGINS x-Codig) THEN NEXT.
    END.
          
    ASSIGN 
        x-flgest = IF Detalle.flgest = 'A' THEN "ANULADO" ELSE "RECIBIDO"
        X-Movi = Detalle.TipMov + STRING(Detalle.CodMov, '99') + '-'.
    
    FIND Almtmovm WHERE Almtmovm.CodCia = Detalle.CodCia 
        AND  Almtmovm.tipmov = Detalle.tipmov 
        AND  Almtmovm.codmov = Detalle.CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE Almtmovm THEN X-Movi = X-Movi + Almtmovm.Desmov.
    IF Detalle.TipMov = 'S' THEN DO :
        IF trim(Detalle.FlgEst)  = "A" THEN assign X-Flgest = "ANULADO".
        IF trim(Detalle.FlgEst)  ne "A" and Detalle.FlgSit  = "T" THEN assign X-Flgest = "TRANSFERID".
        IF trim(Detalle.FlgEst)  ne "A" and Detalle.FlgSit  = "R" THEN assign X-Flgest = "RECEPCIONA".
    END.
    IF Detalle.TipMov = 'I' THEN DO :   
        IF trim(Detalle.FlgEst)  = "A" THEN assign X-Flgest = "  ANULADO  ".  
        IF trim(Detalle.FlgEst)  = ""  THEN assign X-Flgest = "   ACTIVO  ".  
        IF trim(Detalle.FlgEst)  = "C"  THEN assign X-Flgest = "   ACTIVO  ".  
        IF trim(Detalle.FlgEst)  = "P"  THEN assign X-Flgest = " PENDIENTE ".  
    END.            

    FOR EACH Almdmov OF Detalle,
        FIRST Almmmatg OF Almdmov NO-LOCK,
        FIRST Almtfami OF Almmmatg NO-LOCK,
        FIRST Almsfami OF Almmmatg NO-LOCK:
        ASSIGN
            x-desmat = Almmmatg.DesMat
            x-desmar = Almmmatg.Desmar.
        t-column = t-column + 1.                                                                                                                               
        cColumn = STRING(t-Column).                                                                                        
        cRange = "A" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = Detalle.codalm.
        cRange = "B" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = STRING(Detalle.NroDoc).
        cRange = "C" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = Detalle.AlmDes.
        cRange = "D" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = Detalle.FchDoc .
        cRange = "E" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = Detalle.NomRef  .
        cRange = "F" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = Detalle.Usuario .

        cRange = "G" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = Detalle.CodRef.

        cRange = "H" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = Detalle.Nrorf1  .
        cRange = "I" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = Detalle.Nrorf2  .
        cRange = "J" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = X-Movi   .
        cRange = "K" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = x-flgest   .

        cRange = "L" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = "'" + Almdmov.codmat .
        cRange = "M" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = x-desmat .
        cRange = "N" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = x-desmar .
        cRange = "O" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = Almdmov.CodUnd  .
        cRange = "P" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = Almdmov.CanDes .
/*         cRange = "P" + cColumn.                             */
/*         chWorkSheet:Range(cRange):Value = Almdmov.VctoMn1 . */
/*         cRange = "Q" + cColumn.                             */
/*         chWorkSheet:Range(cRange):Value = Detalle.Cco .     */

        /* 07/07/2022 : JPL-00 */
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = Almdmov.VctoMn1 .
/*         cRange = "Q" + cColumn.                                                                                                      */
/*         chWorkSheet:Range(cRange):Value = Almdmov.CanDes * (Almmmatg.CtoLis * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1)). */
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = almdmov.implin /* * (IF almdmov.codmon = 2 THEN almdmov.TpoCmb ELSE 1)*/.
        cRange = "S" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = Almdmov.CanDes * Almmmatg.Pesmat.
        cRange = "T" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = Almmmatg.Chr__02.
        cRange = "U" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = Almmmatg.CodFam + ' ' + Almtfami.desfam .
        cRange = "V" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = almmmatg.subfam + ' ' + AlmSFami.dessub .
        cRange = "W" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = Almmmatg.CodPr1.
        FIND gn-prov WHERE gn-prov.codcia = pv-codcia
            AND gn-prov.codpro = Almmmatg.CodPr1 NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN chWorkSheet:Range(cRange):VALUE = gn-prov.CodPro + ' ' + gn-prov.NomPro.
    END.        
END.  

HIDE FRAME F-PROCESO.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.



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
  DEFINE FRAME FC-REP
         Detalle.Nrodoc  AT 1  FORMAT '9999999'
         Detalle.AlmDes  AT 10
         Detalle.FchDoc  AT 16 FORMAT "99/99/9999"
         Detalle.NomRef  AT 28 FORMAT 'X(35)'
         Detalle.Usuario AT 65 FORMAT 'x(9)'
         Detalle.NroRf1  AT 75 FORMAT 'X(12)'
         Detalle.NroRf2  AT 86 FORMAT 'X(12)'
         X-Movi          AT 97 FORMAT 'X(22)' 
         x-flgest              FORMAT 'X(10)'
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-REP
         Almdmov.codmat  AT 16 FORMAT "X(8)"
         X-Desmat        AT 28 FORMAT "X(40)"
         X-Desmar        AT 75 FORMAT "X(10)"
         Almdmov.CodUnd  AT 90 FORMAT 'x(7)'
         Almdmov.CanDes  FORMAT "(>,>>>,>>9.99)" 
         Almdmov.VCtoMn1 FORMAT "(>,>>>,>>9.9999)" 
         Detalle.Cco
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME H-REP
         HEADER
         S-NOMCIA FORMAT "X(45)" SKIP
         "( " + Detalle.CODALM + ")"  FORMAT "X(15)"
         x-titulo1 AT 45 FORMAT "X(35)"
         "Pag.  : " AT 115 PAGE-NUMBER(REPORT) FORMAT "ZZZZ9" SKIP
         "Desde : " AT 045 STRING(DESDEF,"99/99/9999") FORMAT "X(10)" "Al" STRING(HASTAF,"99/99/9999") FORMAT "X(12)"
         "Fecha : " AT 115 STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
         "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
         " Nro.  Almacen Fecha               D e s t i n o                Respons.  Refer.1      Refer.2    M o v i m i e n t o     Estado        " SKIP
         "               Articulo       Descripcion                                 Marca            Unid       Cantidad    P.Unitario S/.  CCO   " SKIP
         "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*                 1         2         3         4         5         6         7         8         9        10        11        12        13
          1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
          123456   123   99/99/9999  12345678901234567890123456789012345  123456789 123456789012 123456789012 123456789012345678901231234567890 123  
                         12345678    1234567890123456789012345678901234567890       1234567890     123456 (>,>>>,>>9.99) (>,>>>,>>9.99)
*/          
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 


  FOR EACH Detalle NO-LOCK BREAK BY Detalle.CodAlm BY Detalle.NroDoc :
      /* RHC 08.08.2006 */
      IF x-TipMov = 'I' AND I-CodMov = '02' AND x-Codig <> '' THEN DO:
          /* Buscamos la Orden de Compra */
          FIND Lg-cocmp WHERE Lg-cocmp.codcia = s-codcia
              AND Lg-cocmp.coddiv = s-coddiv
              AND Lg-cocmp.nrodoc = INTEGER(Detalle.nrorf1)
              NO-LOCK NO-ERROR.
          IF NOT (AVAILABLE Lg-cocmp AND LG-COCmp.CndCmp BEGINS x-Codig) THEN NEXT.
       END.
       x-flgest = IF Detalle.flgest = 'A' THEN "ANULADO" ELSE "RECIBIDO".          
       X-Movi = Detalle.TipMov + STRING(Detalle.CodMov, '99') + '-'.
       FIND Almtmovm WHERE Almtmovm.CodCia = Detalle.CodCia 
           AND  Almtmovm.tipmov = Detalle.tipmov 
           AND  Almtmovm.codmov = Detalle.CodMov 
           NO-LOCK NO-ERROR.
       IF AVAILABLE Almtmovm THEN X-Movi = X-Movi + Almtmovm.Desmov.
       IF Detalle.TipMov = 'S' THEN DO :
           IF trim(Detalle.FlgEst)  = "A" THEN assign X-Flgest = "ANULADO".
           IF trim(Detalle.FlgEst)  ne "A" and Detalle.FlgSit  = "T" THEN assign X-Flgest = "TRANSFERID".
           IF trim(Detalle.FlgEst)  ne "A" and Detalle.FlgSit  = "R" THEN assign X-Flgest = "RECEPCIONA".
       END.
       IF Detalle.TipMov = 'I' THEN DO :   
           IF trim(Detalle.FlgEst)  = "A" THEN assign X-Flgest = "  ANULADO  ".  
           IF trim(Detalle.FlgEst)  = ""  THEN assign X-Flgest = "   ACTIVO  ".  
           IF trim(Detalle.FlgEst)  = "C"  THEN assign X-Flgest = "   ACTIVO  ".  
           IF trim(Detalle.FlgEst)  = "P"  THEN assign X-Flgest = " PENDIENTE ".  
       END.            
       VIEW STREAM REPORT FRAME H-REP.
       DISPLAY STREAM REPORT
           Detalle.NroDoc 
           Detalle.AlmDes 
           Detalle.FchDoc 
           Detalle.NomRef  
           Detalle.Usuario 
           Detalle.Nrorf1  
           Detalle.Nrorf2
           X-Movi 
           x-flgest 
           WITH FRAME FC-REP.
       FOR EACH Almdmov OF Detalle NO-LOCK:                     
           x-desmat = "".
           x-desmar = "".
           FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                          AND  Almmmatg.codmat = Almdmov.codmat 
                          NO-LOCK NO-ERROR.
           IF AVAILABLE Almmmatg THEN DO:
              ASSIGN
              x-desmat = Almmmatg.DesMat
              x-desmar = Almmmatg.Desmar.
           END.
           DISPLAY STREAM REPORT 
                   Almdmov.codmat 
                   x-desmat 
                   x-desmar
                   Almdmov.CodUnd 
                   Almdmov.CanDes 
                   Almdmov.VCtoMn1
                   Detalle.Cco
                    WITH FRAME F-REP.
       END.        
       DOWN STREAM REPORT 1 WITH FRAME FC-REP.
       IF LAST-OF(Detalle.codalm) THEN PAGE STREAM REPORT.
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
    ENABLE ALL EXCEPT N-MOVI /*F-ALMACEN*/ F-NomDes.
   FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
                      Almtmovm.tipmov = X-TIPMOV AND
                      Almtmovm.codmov = integer(I-CodMov:screen-value)  NO-LOCK NO-ERROR.
 
   IF AVAILABLE Almtmovm AND Almtmovm.MovTrf THEN DO:
      F-AlmDes:SENSITIVE = YES.
     
   END.
   ELSE DO:
      F-AlmDes:SENSITIVE = NO.
      F-NomDes:SCREEN-VALUE = "".
      F-AlmDes:SCREEN-VALUE = "".
   END.
    
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

    RUN Carga-Temporal.
    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay registros que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

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
  ASSIGN DesdeF HastaF C-tipmov I-Codmov F-Almdes.

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
     ASSIGN DesdeF = TODAY
            HastaF = TODAY
            F-Almdes = ""
            F-Nomdes = ""
            I-CodMov = ''
            C-tipmov.
    CASE C-tipmov:
         WHEN "Ingreso" THEN X-Tipmov = "I".
         WHEN "Salida"  THEN X-Tipmov = "S".
    END.
    FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
                        Almtmovm.tipmov = X-TIPMOV AND
                        Almtmovm.codmov = INTEGER(I-CodMov) NO-LOCK NO-ERROR.
    IF AVAILABLE Almtmovm THEN N-MOVI = Almtmovm.Desmov.
    DISPLAY 
        DesdeF HastaF I-Codmov C-tipmov N-movi /*S-CODALM @ F-Almacen*/.    
    /*F-AlmDes:SENSITIVE = NO.*/
    FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia:
        COMBO-BOX-Almacen:ADD-LAST(Almacen.codalm + ' - ' + Almacen.Descripcion).
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

