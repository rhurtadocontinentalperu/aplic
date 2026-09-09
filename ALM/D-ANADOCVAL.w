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
DEFINE VAR dTotal    AS DECIMAL FORMAT "(>,>>>,>>9.99)" .
DEFINE VAR x-totales AS DECIMAL FORMAT "(>,>>>,>>9.99)" .
DEFINE VAR x-canti AS DECIMAL FORMAT "(>,>>>,>>9.99)" NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-60 RECT-62 txt-nrodoc desdeF hastaF ~
C-Tipmov I-CodMov Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-Almacen txt-nrodoc desdeF hastaF ~
C-Tipmov I-CodMov N-MOVI x-Codig x-Nombr F-AlmDes F-NomDes txt-msj 

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

DEFINE VARIABLE C-Tipmov AS CHARACTER FORMAT "X(256)":U INITIAL "Ingreso" 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Ingreso","Salida" 
     DROP-DOWN-LIST
     SIZE 9.43 BY 1 NO-UNDO.

DEFINE VARIABLE desdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-Almacen AS CHARACTER FORMAT "X(3)":U 
     LABEL "Almacén" 
     VIEW-AS FILL-IN 
     SIZE 6.14 BY .69
     FONT 6 NO-UNDO.

DEFINE VARIABLE F-AlmDes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proc/Dest" 
     VIEW-AS FILL-IN 
     SIZE 6.14 BY .69 NO-UNDO.

DEFINE VARIABLE F-NomDes AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .69 NO-UNDO.

DEFINE VARIABLE hastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE I-CodMov AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .69 NO-UNDO.

DEFINE VARIABLE N-MOVI AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.57 BY .69 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 30 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE txt-nrodoc AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .69 NO-UNDO.

DEFINE VARIABLE x-Codig AS CHARACTER FORMAT "X(3)":U 
     LABEL "Cnd. Compra" 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .69 NO-UNDO.

DEFINE VARIABLE x-Nombr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 1.77.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55.43 BY 5.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Almacen AT ROW 1.38 COL 6.14
     txt-nrodoc AT ROW 2.15 COL 4.14 WIDGET-ID 2
     desdeF AT ROW 2.96 COL 10.86 COLON-ALIGNED
     hastaF AT ROW 2.96 COL 29.57 COLON-ALIGNED
     C-Tipmov AT ROW 3.77 COL 10.86 COLON-ALIGNED
     I-CodMov AT ROW 3.81 COL 20.72 COLON-ALIGNED NO-LABEL
     N-MOVI AT ROW 3.81 COL 24.86 COLON-ALIGNED NO-LABEL
     x-Codig AT ROW 4.69 COL 10.86 COLON-ALIGNED
     x-Nombr AT ROW 4.69 COL 18.29 COLON-ALIGNED NO-LABEL
     F-AlmDes AT ROW 5.54 COL 10.86 COLON-ALIGNED
     F-NomDes AT ROW 5.54 COL 18 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 6.92 COL 34.43
     Btn_Cancel AT ROW 6.92 COL 46
     txt-msj AT ROW 7.19 COL 3 NO-LABEL WIDGET-ID 4
     RECT-60 AT ROW 6.77 COL 2
     RECT-62 AT ROW 1.08 COL 2.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 58.86 BY 8.27
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
         HEIGHT             = 8.27
         WIDTH              = 58.57
         MAX-HEIGHT         = 8.27
         MAX-WIDTH          = 58.86
         VIRTUAL-HEIGHT     = 8.27
         VIRTUAL-WIDTH      = 58.86
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
/* SETTINGS FOR FILL-IN F-Almacen IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-AlmDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN N-MOVI IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       txt-msj:HIDDEN IN FRAME F-Main           = TRUE
       txt-msj:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN txt-nrodoc IN FRAME F-Main
   ALIGN-L                                                              */
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
  ASSIGN C-TipMov DesdeF HastaF I-CodMov txt-nrodoc .
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
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
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
  ASSIGN DesdeF HastaF C-tipmov I-Codmov F-Almdes x-Codig x-Nombr txt-nrodoc.

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
  DISPLAY F-Almacen txt-nrodoc desdeF hastaF C-Tipmov I-CodMov N-MOVI x-Codig 
          x-Nombr F-AlmDes F-NomDes txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-60 RECT-62 txt-nrodoc desdeF hastaF C-Tipmov I-CodMov Btn_OK 
         Btn_Cancel 
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
  DEFINE VARIABLE x-total   AS DECIMAL FORMAT "(>,>>>,>>9.99)" NO-UNDO.
  DEFINE VARIABLE x-totcant AS DECIMAL FORMAT "(>,>>>,>>9.99)" .

  DEFINE FRAME FC-REP
         Almcmov.Nrodoc  AT 1
         /*Almcmov.AlmDes  AT 10*/
         Almcmov.FchDoc  AT 10 /*16*/ FORMAT "99/99/9999"
         Almcmov.NomRef  AT 22 /*28*/ FORMAT 'X(35)'
         Almcmov.Usuario AT 59 /*65*/ FORMAT 'x(9)'
         Almcmov.NroRf1  AT 69 /*75*/ FORMAT 'X(10)'
         Almcmov.NroRf2  AT 80 /*86*/ FORMAT 'X(10)'
         /*X-Movi          AT 97 FORMAT 'X(22)' 
         x-flgest              FORMAT 'X(10)'*/ 
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-REP
         Almdmov.codmat  AT 10 /*16*/ FORMAT "X(8)"
         X-Desmat        AT 22 /*28*/ FORMAT "X(40)"
         X-Desmar        AT 69 /*75*/ FORMAT "X(10)"
         Almdmov.CodUnd  AT 84 /*90*/ FORMAT 'x(7)'
         Almdmov.CanDes  FORMAT "(>,>>>,>>9.99)" 
         Almdmov.VCtoMn1 FORMAT "(>,>>>,>>9.99)" 
         dTotal          FORMAT "(>,>>>,>>9.99)" 
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME H-REP
         HEADER
         S-NOMCIA FORMAT "X(45)" SKIP
         "( " + S-CODALM + ")"  FORMAT "X(15)"
         x-titulo1  AT 051 FORMAT "X(35)"
         "Pag.  : " AT 121 PAGE-NUMBER(REPORT) FORMAT "ZZZZ9" SKIP
         "Desde : " AT 051 STRING(DESDEF,"99/99/9999") FORMAT "X(10)" "Al" STRING(HASTAF,"99/99/9999") FORMAT "X(12)"
         "Fecha : " AT 121 STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
         "---------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         " Nro.  Fecha               D e s t i n o                      Respons.  Refer.1    Refer.2  "                                                  SKIP
/*       " Nro.  Almacen Fecha               D e s t i n o                Respons.  Refer.1    Refer.2  "  M o v i m i e n t o     Estado        " SKIP */
         "       Articulo       Descripcion                                   Marca          Unid             Cantidad      Costo Unit S/.      TOTAL  " SKIP
         "---------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*                 1         2         3         4         5         6         7         8         9        10        11        12        13
          1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
          123456   123   99/99/9999  12345678901234567890123456789012345  123456789 1234567890 1234567890 123456789012345678901231234567890 123  
                         12345678    1234567890123456789012345678901234567890       1234567890     123456 (>,>>>,>>9.99) (>,>>>,>>9.99)
*/          
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

       FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = S-CODCIA AND  
                                      Almcmov.CodAlm = S-CODALM AND  
                                      Almcmov.TipMov = X-TipMov AND  
                                      (I-CodMov = '' OR Almcmov.CodMov = INTEGER(I-CodMov)) AND  
                                      Almcmov.FchDoc >= DesdeF  AND  
                                      Almcmov.FchDoc <= HastaF  AND
                                      Almcmov.FlgEst <> "A"     AND
                                      ( Almcmov.NroDoc = txt-nrodoc OR
                                        txt-nrodoc = 0) AND
                                      Almcmov.AlmDes BEGINS F-AlmDes
                                      BREAK BY Almcmov.NroDoc :
       
          /* RHC 08.08.2006 */
          IF x-TipMov = 'I' AND I-CodMov = '02' AND x-Codig <> '' THEN DO:
            /* Buscamos la Orden de Compra */
            FIND Lg-cocmp WHERE Lg-cocmp.codcia = s-codcia
                AND Lg-cocmp.coddiv = s-coddiv
                AND Lg-cocmp.nrodoc = INTEGER(Almcmov.nrorf1)
                NO-LOCK NO-ERROR.
            IF NOT (AVAILABLE Lg-cocmp AND LG-COCmp.CndCmp BEGINS x-Codig) THEN NEXT.
          END.
          
          x-flgest = IF Almcmov.flgest = 'A' THEN "ANULADO" ELSE "RECIBIDO".          

          X-Movi = Almcmov.TipMov + STRING(Almcmov.CodMov, '99') + '-'.
          FIND Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia 
                         AND  Almtmovm.tipmov = Almcmov.tipmov 
                         AND  Almtmovm.codmov = Almcmov.CodMov 
                        NO-LOCK NO-ERROR.
          IF AVAILABLE Almtmovm THEN X-Movi = X-Movi + Almtmovm.Desmov.
  
          IF Almcmov.TipMov = 'S' THEN DO :
            IF trim(Almcmov.FlgEst)  = "A" THEN assign X-Flgest = "ANULADO".
            IF trim(Almcmov.FlgEst)  ne "A" and Almcmov.FlgSit  = "T" THEN assign X-Flgest = "TRANSFERID".
            IF trim(Almcmov.FlgEst)  ne "A" and Almcmov.FlgSit  = "R" THEN assign X-Flgest = "RECEPCIONA".
          END.
          IF Almcmov.TipMov = 'I' THEN DO :   
            IF trim(Almcmov.FlgEst)  = "A" THEN assign X-Flgest = "  ANULADO  ".  
            IF trim(Almcmov.FlgEst)  = ""  THEN assign X-Flgest = "   ACTIVO  ".  
            IF trim(Almcmov.FlgEst)  = "C"  THEN assign X-Flgest = "   ACTIVO  ".  
            IF trim(Almcmov.FlgEst)  = "P"  THEN assign X-Flgest = " PENDIENTE ".  
          END.            
          /*
          DISPLAY Almcmov.NroDoc @ Fi-Mensaje LABEL "Numero de Movimiento"
                  FORMAT "X(11)" 
                  WITH FRAME F-Proceso.
          */
          VIEW STREAM REPORT FRAME H-REP.
          DISPLAY STREAM REPORT
                Almcmov.NroDoc 
                Almcmov.AlmDes 
                Almcmov.FchDoc 
                Almcmov.NomRef  
                Almcmov.Usuario 
                Almcmov.Nrorf1  
                Almcmov.Nrorf2
                X-Movi 
                x-flgest 
                WITH FRAME FC-REP.
         x-totales = 0.
         x-canti   = 0.
          FOR EACH Almdmov OF Almcmov:                     
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
                /*Costo Total*/
                dTotal = (Almdmov.VCtoMn1 * Almdmov.CanDes).

                DISPLAY STREAM REPORT 
                        Almdmov.codmat 
                        x-desmat 
                        x-desmar
                        Almdmov.CodUnd 
                        Almdmov.CanDes 
                /*Campo de Costo Unit */
                        Almdmov.VCtoMn1
                        dTotal
                        WITH FRAME F-REP.
                x-totales = x-totales + dTotal.
                x-canti   = x-canti + Almdmov.CanDes.
          END.        
            

          IF LAST-OF(Almcmov.nrodoc) THEN DO:
              PUT STREAM REPORT 'Total:'   AT 84.
              PUT STREAM REPORT x-canti    AT 95.
              PUT STREAM REPORT x-Totales  AT 125.
              x-total = x-total + x-totales.
              x-totcant = x-totcant + x-canti.
          END.

          IF LAST(Almcmov.nrodoc) THEN DO:
              PUT STREAM REPORT 'TOTALES'   AT 84.
              PUT STREAM REPORT  x-totcant  AT 95.
              PUT STREAM REPORT  x-Total    AT 125.
          END.
          
          DOWN STREAM REPORT 1 WITH FRAME FC-REP.          
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
    ENABLE ALL EXCEPT N-MOVI F-ALMACEN F-NomDes.
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

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.
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
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
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
    DISPLAY DesdeF HastaF I-Codmov C-tipmov N-movi
            S-CODALM @ F-Almacen.    

    F-AlmDes:SENSITIVE = NO.
            
  
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

