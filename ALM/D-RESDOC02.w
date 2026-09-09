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
&Scoped-Define ENABLED-OBJECTS RECT-62 RECT-60 RECT-63 R-Estado desdeF ~
hastaF C-Tipmov I-CodMov x-codmaq F-AlmDes Btn_OK-2 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS R-Estado F-Almacen desdeF hastaF C-Tipmov ~
I-CodMov N-MOVI x-codmaq F-AlmDes F-NomDes 

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
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE desdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .85 NO-UNDO.

DEFINE VARIABLE F-Almacen AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén" 
     VIEW-AS FILL-IN 
     SIZE 6.14 BY .85
     FONT 6 NO-UNDO.

DEFINE VARIABLE F-AlmDes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proc/Dest" 
     VIEW-AS FILL-IN 
     SIZE 6.14 BY .85 NO-UNDO.

DEFINE VARIABLE F-NomDes AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .85 NO-UNDO.

DEFINE VARIABLE hastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .85 NO-UNDO.

DEFINE VARIABLE I-CodMov AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .85 NO-UNDO.

DEFINE VARIABLE N-MOVI AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .85 NO-UNDO.

DEFINE VARIABLE x-codmaq AS CHARACTER FORMAT "X(4)":U 
     LABEL "Maquina" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE R-Estado AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Activos", "P",
"Anulados", "A",
"Todos", "T"
     SIZE 9.43 BY 1.88
     FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56.43 BY 1.88.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56.57 BY 6.12.

DEFINE RECTANGLE RECT-63
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 11.57 BY 2.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     R-Estado AT ROW 1.54 COL 45 NO-LABEL
     F-Almacen AT ROW 1.81 COL 4.28
     desdeF AT ROW 2.69 COL 9 COLON-ALIGNED
     hastaF AT ROW 2.69 COL 27 COLON-ALIGNED
     C-Tipmov AT ROW 3.69 COL 9 COLON-ALIGNED
     I-CodMov AT ROW 3.69 COL 19.43 COLON-ALIGNED NO-LABEL
     N-MOVI AT ROW 3.69 COL 23.29 COLON-ALIGNED NO-LABEL
     x-codmaq AT ROW 4.65 COL 9 COLON-ALIGNED WIDGET-ID 2
     F-AlmDes AT ROW 5.58 COL 9 COLON-ALIGNED
     F-NomDes AT ROW 5.58 COL 15.43 COLON-ALIGNED NO-LABEL
     Btn_OK-2 AT ROW 7.31 COL 23.57 WIDGET-ID 4
     Btn_OK AT ROW 7.35 COL 35
     Btn_Cancel AT ROW 7.35 COL 46.29
     RECT-62 AT ROW 1.08 COL 1.43
     RECT-60 AT ROW 7.19 COL 1.57
     RECT-63 AT ROW 1.27 COL 44
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
         TITLE              = "Resumen de Documentos"
         HEIGHT             = 8.23
         WIDTH              = 57.57
         MAX-HEIGHT         = 10.92
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 10.92
         VIRTUAL-WIDTH      = 80
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN F-Almacen IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-NomDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN N-MOVI IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Resumen de Documentos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen de Documentos */
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

  IF I-CODMOV <> '' THEN DO:
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

  IF I-CODMOV <> '' THEN DO:
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
  I-Codmov = output-var-2.
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
  /* RHC 27-03-04 se puede dejar en blanco I-CodMov */
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
  I-Codmov = output-var-2.
  DO WITH FRAME {&FRAME-NAME}:
     Display I-Codmov .
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
  ASSIGN DesdeF HastaF C-tipmov I-Codmov F-Almdes R-Estado x-codmaq.

  x-titulo2 = 'Del ' + STRING(DesdeF, '99/99/9999') + ' Al ' + STRING(HastaF, '99/99/9999').
  CASE C-TipMov:
     WHEN 'Ingreso' THEN ASSIGN
           x-titulo1 = 'RESUMEN DE DOCUMENTOS - INGRESOS'
           X-Tipmov = "I".
     WHEN 'Salida'  THEN ASSIGN
           x-titulo1 = 'RESUMEN DE DOCUMENTOS - SALIDAS'
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
  DISPLAY R-Estado F-Almacen desdeF hastaF C-Tipmov I-CodMov N-MOVI x-codmaq 
          F-AlmDes F-NomDes 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-62 RECT-60 RECT-63 R-Estado desdeF hastaF C-Tipmov I-CodMov 
         x-codmaq F-AlmDes Btn_OK-2 Btn_OK Btn_Cancel 
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
DEFINE VARIABLE cCodMaq                 AS CHARACTER   NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = " ( ALMACEN : " + s-codalm + " ) ".
cRange = "G" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Desde : " + STRING(DESDEF,"99/99/9999").
cRange = "H" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Hasta : " + STRING(HASTAF,"99/99/9999").
t-column = t-column + 1. 
cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "NroDoc".
cRange = "B" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Almacen Despacho".
cRange = "C" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Fecha".
cRange = "D" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Codigo Material".
cRange = "E" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Descripcion".
cRange = "F" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Unidad".
cRange = "G" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Cantidad".
cRange = "H" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Referencia".
cRange = "I" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Maquina".
cRange = "J" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Estado".

Head: 
FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = S-CODCIA AND
    Almcmov.CodAlm = S-CODALM AND  
    Almcmov.TipMov = X-TipMov AND  
    (I-CodMov = '' OR Almcmov.CodMov = INTEGER(I-CodMov)) AND  
    Almcmov.FchDoc >= DesdeF  AND  
    Almcmov.FchDoc <= HastaF  AND
    Almcmov.AlmDes BEGINS F-AlmDes,
    EACH Almdmov OF AlmCMov NO-LOCK,
    FIRST Almmmatg OF Almdmov NO-LOCK
    BREAK BY Almcmov.NroDoc :

    /* *******Busca Maquina******* */
    cCodMaq = ''.
    FIND FIRST pr-odpc WHERE pr-odpc.codcia = s-codcia
        AND pr-odpc.flgest <> 'A'
        AND pr-odpc.numord = SUBSTRING(Almcmov.Nrorf1,3) NO-LOCK NO-ERROR.
    IF x-codmaq <> '' THEN DO:
        IF NOT AVAIL pr-odpc THEN NEXT Head.
        IF pr-odpc.codmaq <> x-codmaq THEN NEXT.
        cCodMaq = pr-odpc.CodMaq.
    END.
    ELSE IF AVAIL pr-odpc THEN cCodMaq = pr-odpc.CodMaq.
    IF cCodMaq <> '' THEN DO:
        FIND FIRST LprMaqui WHERE LprMaqui.CodCia = s-codcia
            AND LprMaqui.CodMaq = cCodMaq NO-LOCK NO-ERROR.
        IF AVAIL LprMaqui THEN cCodMaq = cCodMaq + '-' + LprMaqui.DesPro.
    END.
    /*    **********************  */
    
    IF R-Estado = "A" AND Almcmov.FlgEst <> "A" THEN NEXT .
    IF R-Estado = "P" AND Almcmov.FlgEst =  "A" THEN NEXT .

    ASSIGN 
        x-flgest = IF Almcmov.flgest = 'A' THEN "ANULADO" ELSE "ACTIVO"
        X-Movi = Almcmov.TipMov + STRING(Almcmov.CodMov, '99') + '-'.
    
    FIND Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia 
        AND  Almtmovm.tipmov = Almcmov.tipmov 
        AND  Almtmovm.codmov = Almcmov.CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE Almtmovm THEN X-Movi = X-Movi + Almtmovm.Desmov.

    IF Almcmov.TipMov = 'S' THEN DO :
        IF TRIM(Almcmov.FlgEst) = "A" THEN ASSIGN X-Flgest = "ANULADO".
        IF TRIM(Almcmov.FlgEst) NE "A" AND Almcmov.FlgSit  = "T" 
            THEN ASSIGN X-Flgest = "TRANSFERID".
        IF TRIM(Almcmov.FlgEst) NE "A" AND Almcmov.FlgSit  = "R" 
            THEN ASSIGN X-Flgest = "RECEPCIONA".
    END.
    IF Almcmov.TipMov = 'I' THEN DO :   
        CASE TRIM(Almcmov.FlgEst):
            WHEN "A" THEN ASSIGN X-Flgest = "  ANULADO  ".  
            WHEN ""  THEN ASSIGN X-Flgest = "   ACTIVO  ".  
            WHEN "C" THEN ASSIGN X-Flgest = "   ACTIVO  ".  
            WHEN "P" THEN ASSIGN X-Flgest = " PENDIENTE ".  
        END CASE.
    END.            

    DISPLAY Almcmov.NroDoc @ Fi-Mensaje LABEL "Numero de Movimiento"
        FORMAT "X(11)"  WITH FRAME F-Proceso.

    t-column = t-column + 1.                                                                                                                               
    cColumn = STRING(t-Column).                                                                                        
    cRange = "A" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + STRING(Almcmov.NroDoc,"999999") .
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + Almcmov.AlmDes. 
    cRange = "C" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = Almcmov.FchDoc .
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + Almdmov.CodMat.    
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = Almmmatg.DesMat.
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = Almdmov.CodUnd.
    cRange = "G" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = Almdmov.CanDes.
    cRange = "H" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = Almcmov.Nrorf1.    
    cRange = "I" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = cCodMaq.
    cRange = "J" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = x-flgest.


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
    DEFINE VARIABLE cCodMaq AS CHARACTER   NO-UNDO.
   
    DEFINE FRAME FC-REP
        Almcmov.Nrodoc  AT 1
        Almcmov.AlmDes  AT 10
        Almcmov.FchDoc  AT 16 FORMAT "99/99/9999"
        Almdmov.CodMat  AT 28 FORMAT "X(6)"
        Almmmatg.DesMat AT 35 FORMAT "X(40)"        
        Almdmov.CodUnd  AT 81 FORMAT "X(5)"        
        Almdmov.CanDes  AT 86 FORMAT ">>>,>>9.99"
        /*Almcmov.Usuario AT 105*/
        Almcmov.Nrorf1  AT 102
        cCodMaq         AT 115 FORMAT 'X(18)'
        /*x-flgest        AT 130 FORMAT 'X(10)'*/
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

    DEFINE FRAME H-REP
        HEADER
        S-NOMCIA FORMAT "X(45)" SKIP
        "( " + S-CODALM + ")"  FORMAT "X(15)"
        x-titulo1 AT 45 FORMAT "X(35)"
        "Pag.  : " AT 115 PAGE-NUMBER(REPORT) FORMAT "ZZZZ9" SKIP
        "Desde : " AT 045 STRING(DESDEF,"99/99/9999") FORMAT "X(10)" "Al" STRING(HASTAF,"99/99/9999") FORMAT "X(12)"
        "Fecha : " AT 115 STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        "------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " Nro.  Almacen Fecha      Codigo   D e s c r i p c i o n                     Unidad    Cantidad     Referencia      Maquina         " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

    Head: 
    FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = S-CODCIA AND
        Almcmov.CodAlm = S-CODALM AND  
        Almcmov.TipMov = X-TipMov AND  
        (I-CodMov = '' OR Almcmov.CodMov = INTEGER(I-CodMov)) AND  
        Almcmov.FchDoc >= DesdeF  AND  
        Almcmov.FchDoc <= HastaF  AND
        Almcmov.AlmDes BEGINS F-AlmDes,
        EACH Almdmov OF AlmCMov NO-LOCK,
        FIRST Almmmatg OF Almdmov NO-LOCK
        BREAK BY Almcmov.NroDoc :

        /* *******Busca Maquina******* */
        cCodMaq = ''.
        FIND FIRST pr-odpc WHERE pr-odpc.codcia = s-codcia
            AND pr-odpc.flgest <> 'A'
            AND pr-odpc.numord = SUBSTRING(Almcmov.Nrorf1,3) NO-LOCK NO-ERROR.
        IF x-codmaq <> '' THEN DO:
            IF NOT AVAIL pr-odpc THEN NEXT Head.
            IF pr-odpc.codmaq <> x-codmaq THEN NEXT.
            cCodMaq = pr-odpc.CodMaq.
        END.
        ELSE IF AVAIL pr-odpc THEN cCodMaq = pr-odpc.CodMaq.
        IF cCodMaq <> '' THEN DO:
            FIND FIRST LprMaqui WHERE LprMaqui.CodCia = s-codcia
                AND LprMaqui.CodMaq = cCodMaq NO-LOCK NO-ERROR.
            IF AVAIL LprMaqui THEN cCodMaq = cCodMaq + '-' + LprMaqui.DesPro.
        END.
        /*    **********************  */

        IF R-Estado = "A" AND Almcmov.FlgEst <> "A" THEN NEXT .
        IF R-Estado = "P" AND Almcmov.FlgEst =  "A" THEN NEXT .

        ASSIGN 
            x-flgest = IF Almcmov.flgest = 'A' THEN "ANULADO" ELSE "ACTIVO"
            X-Movi = Almcmov.TipMov + STRING(Almcmov.CodMov, '99') + '-'.

        FIND Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia 
            AND  Almtmovm.tipmov = Almcmov.tipmov 
            AND  Almtmovm.codmov = Almcmov.CodMov NO-LOCK NO-ERROR.

        IF AVAILABLE Almtmovm THEN X-Movi = X-Movi + Almtmovm.Desmov.

        IF Almcmov.TipMov = 'S' THEN DO :
            IF TRIM(Almcmov.FlgEst) = "A" THEN ASSIGN X-Flgest = "ANULADO".
            IF TRIM(Almcmov.FlgEst) NE "A" AND Almcmov.FlgSit  = "T" 
                THEN ASSIGN X-Flgest = "TRANSFERID".
            IF TRIM(Almcmov.FlgEst) NE "A" AND Almcmov.FlgSit  = "R" 
                THEN ASSIGN X-Flgest = "RECEPCIONA".
        END.
        IF Almcmov.TipMov = 'I' THEN DO :   
            CASE TRIM(Almcmov.FlgEst):
                WHEN "A" THEN ASSIGN X-Flgest = "  ANULADO  ".  
                WHEN ""  THEN ASSIGN X-Flgest = "   ACTIVO  ".  
                WHEN "C" THEN ASSIGN X-Flgest = "   ACTIVO  ".  
                WHEN "P" THEN ASSIGN X-Flgest = " PENDIENTE ".  
            END CASE.
            /***
            IF TRIM(Almcmov.FlgEst)  = "A" THEN ASSIGN X-Flgest = "  ANULADO  ".  
            IF TRIM(Almcmov.FlgEst)  = ""  THEN ASSIGN X-Flgest = "   ACTIVO  ".  
            IF TRIM(Almcmov.FlgEst)  = "C"  THEN ASSIGN X-Flgest = "   ACTIVO  ".  
            IF TRIM(Almcmov.FlgEst)  = "P"  THEN ASSIGN X-Flgest = " PENDIENTE ".  
            ***/
        END.            
        
        DISPLAY Almcmov.NroDoc @ Fi-Mensaje LABEL "Numero de Movimiento"
            FORMAT "X(11)" 
            WITH FRAME F-Proceso.

        VIEW STREAM REPORT FRAME H-REP.

        DISPLAY STREAM REPORT
            Almcmov.NroDoc 
            Almcmov.AlmDes 
            Almcmov.FchDoc 
            Almdmov.CodMat
            Almmmatg.DesMat
            Almdmov.CodUnd
            Almdmov.CanDes
            /*Almcmov.NomRef  */
            /*Almcmov.Usuario */
            Almcmov.Nrorf1  
            cCodMaq
            /*X-Movi 
            x-flgest */

            WITH FRAME FC-REP.      
 
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
  ASSIGN DesdeF HastaF C-tipmov I-Codmov F-Almdes R-Estado.

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

