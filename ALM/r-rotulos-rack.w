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
{src/bin/_prns.i}   /* Para la impresion */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF STREAM REPORTE.
DEFINE VAR x-key2 AS CHAR.
DEFINE VAR s-task-no AS INT.

DEFINE VAR x-formato AS INT.

DEFINE BUFFER b-w-report FOR w-report.
DEFINE TEMP-TABLE xtempo LIKE w-report.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-codmat FILL-IN-cama FILL-IN-lote ~
FILL-IN-vcto FILL-IN-codmat-2 FILL-IN-codmat-3 FILL-IN-fecha btn-print ~
BUTTON-8 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codmat FILL-IN-cama FILL-IN-lote ~
FILL-IN-vcto FILL-IN-codmat-2 FILL-IN-codmat-3 FILL-IN-fecha FILL-IN-desmat ~
FILL-IN-marca FILL-IN-desmat-2 FILL-IN-marca-2 FILL-IN-desmat-3 ~
FILL-IN-marca-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-print 
     IMAGE-UP FILE "IMG/print-2.ico":U
     LABEL "Button 7" 
     SIZE 9 BY 2.15.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "Button 8" 
     SIZE 9 BY 2.15.

DEFINE VARIABLE FILL-IN-cama AS CHARACTER FORMAT "X(3)":U 
     LABEL "Cama:" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-codmat AS CHARACTER FORMAT "X(8)":U 
     LABEL "Articulo #1" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-codmat-2 AS CHARACTER FORMAT "X(8)":U 
     LABEL "Articulo #2" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-codmat-3 AS CHARACTER FORMAT "X(8)":U 
     LABEL "Articulo #3" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-desmat AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 38 BY .62
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-desmat-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 38 BY .62
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-desmat-3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 38 BY .62
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha ingreso almacen" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-lote AS CHARACTER FORMAT "X(8)":U 
     LABEL "Lote" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-marca AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 38 BY .62
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-marca-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 38 BY .62
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-marca-3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 38 BY .62
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-vcto AS DATE FORMAT "99/99/9999":U 
     LABEL "Vencimiento" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-Copias AS INTEGER FORMAT ">>>9":U INITIAL 1 
     LABEL "Copias" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-codmat AT ROW 3.62 COL 12 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-cama AT ROW 5.04 COL 17.72 COLON-ALIGNED WIDGET-ID 54
     FILL-IN-lote AT ROW 5.08 COL 32.57 COLON-ALIGNED WIDGET-ID 50
     FILL-IN-vcto AT ROW 5.12 COL 55.29 COLON-ALIGNED WIDGET-ID 52
     FILL-IN-codmat-2 AT ROW 7.38 COL 12 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-codmat-3 AT ROW 9.85 COL 12 COLON-ALIGNED WIDGET-ID 38
     FILL-IN-fecha AT ROW 11.58 COL 24 COLON-ALIGNED WIDGET-ID 22
     x-Copias AT ROW 11.58 COL 51 COLON-ALIGNED WIDGET-ID 16
     btn-print AT ROW 12.92 COL 47 WIDGET-ID 4
     BUTTON-8 AT ROW 12.92 COL 57 WIDGET-ID 18
     FILL-IN-desmat AT ROW 3.65 COL 23.43 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-marca AT ROW 4.31 COL 23.43 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-desmat-2 AT ROW 7.38 COL 23.29 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     FILL-IN-marca-2 AT ROW 8.04 COL 23.29 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     FILL-IN-desmat-3 AT ROW 9.88 COL 23.29 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     FILL-IN-marca-3 AT ROW 10.54 COL 23.29 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     "Impresión de Rotulos Rack" VIEW-AS TEXT
          SIZE 37 BY .81 AT ROW 1.23 COL 17 WIDGET-ID 12
          FGCOLOR 12 FONT 11
     "#1 : Impresion en una hoja completa" VIEW-AS TEXT
          SIZE 37 BY .77 AT ROW 2.73 COL 6 WIDGET-ID 44
          FGCOLOR 9 FONT 10
     "#2 : Imprime duplicado en una misma hoja" VIEW-AS TEXT
          SIZE 45 BY .77 AT ROW 6.58 COL 6 WIDGET-ID 46
          FGCOLOR 9 FONT 10
     "#3 : Imprime triplicado en una misma hoja" VIEW-AS TEXT
          SIZE 45 BY .77 AT ROW 8.96 COL 6 WIDGET-ID 48
          FGCOLOR 9 FONT 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72.57 BY 14.54
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
         TITLE              = "ROTULOS RACK"
         HEIGHT             = 14.54
         WIDTH              = 72.57
         MAX-HEIGHT         = 14.54
         MAX-WIDTH          = 76.43
         VIRTUAL-HEIGHT     = 14.54
         VIRTUAL-WIDTH      = 76.43
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

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
/* SETTINGS FOR FILL-IN FILL-IN-desmat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-desmat-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-desmat-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-marca IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-marca-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-marca-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Copias IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       x-Copias:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ROTULOS RACK */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ROTULOS RACK */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-print W-Win
ON CHOOSE OF btn-print IN FRAME F-Main /* Button 7 */
DO:
    ASSIGN fill-in-fecha FILL-IN-codmat fill-in-codmat-2 fill-in-codmat-3.
    ASSIGN fill-in-lote fill-in-vcto fill-in-cama.

    FIND FIRST almmmatg WHERE almmmatg.codcia = 1 AND 
                              almmmatg.codmat = fill-in-codmat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almmmatg THEN DO:
        MESSAGE "Codigo de Articulo #1 no existe" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    IF NOT TRUE <> (fill-in-codmat > "") THEN DO:
        IF NOT TRUE <> (fill-in-lote > "") THEN DO:
            IF fill-in-vcto = ? THEN DO:
                MESSAGE "Falta la fecha de vencimiento del Lote" VIEW-AS ALERT-BOX INFORMATION.
                RETURN NO-APPLY.
            END.
        END.
        IF NOT (fill-in-vcto = ?) THEN DO:
            IF TRUE <> (fill-in-lote > "") THEN DO:
                MESSAGE "Debe ingresar el Lote" VIEW-AS ALERT-BOX INFORMATION.
                RETURN NO-APPLY.
            END.
        END.

    END.

    x-formato = 1.

    IF NOT TRUE <> (fill-in-codmat-2 > "") THEN DO:
        FIND FIRST almmmatg WHERE almmmatg.codcia = 1 AND 
                                  almmmatg.codmat = fill-in-codmat-2 NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almmmatg THEN DO:
            MESSAGE "Codigo de Articulo #2 no existe" VIEW-AS ALERT-BOX INFORMATION.
            RETURN NO-APPLY.
        END.
        x-formato = x-formato + 2.
    END.

    IF NOT TRUE <> (fill-in-codmat-3 > "") THEN DO:
        FIND FIRST almmmatg WHERE almmmatg.codcia = 1 AND 
                                  almmmatg.codmat = fill-in-codmat-3 NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almmmatg THEN DO:
            MESSAGE "Codigo de Articulo #3 no existe" VIEW-AS ALERT-BOX INFORMATION.
            RETURN NO-APPLY.
        END.
        x-formato = x-formato + 4.
    END.

    /*IF radio-set-formato <> 3 THEN DO:*/
    IF x-formato = 1 OR x-formato = 3 OR x-formato = 7 THEN DO:
        RUN Imprime-Etiqueta.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Button 8 */
DO:
  RUN local-exit.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codmat W-Win
ON LEAVE OF FILL-IN-codmat IN FRAME F-Main /* Articulo #1 */
DO:

  ASSIGN fill-in-codmat fill-in-desmat fill-in-marca FILL-in-fecha x-copias.  


  DO WITH FRAME {&FRAME-NAME}:
      fill-in-desmat:SCREEN-VALUE = "".
      fill-in-marca:SCREEN-VALUE = "".

      FIND FIRST almmmatg WHERE almmmatg.codcia = 1 AND 
                                almmmatg.codmat = fill-in-codmat NO-LOCK NO-ERROR.
      IF AVAILABLE almmmatg THEN DO:
          fill-in-desmat:SCREEN-VALUE = almmmatg.desmat.
          fill-in-marca:SCREEN-VALUE = almmmatg.desmar.
      END.

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codmat-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codmat-2 W-Win
ON LEAVE OF FILL-IN-codmat-2 IN FRAME F-Main /* Articulo #2 */
DO:

  ASSIGN fill-in-codmat-2 fill-in-desmat-2 fill-in-marca-2 FILL-in-fecha x-copias.  

  DO WITH FRAME {&FRAME-NAME}:
      fill-in-desmat-2:SCREEN-VALUE = "".
      fill-in-marca-2:SCREEN-VALUE = "".

      FIND FIRST almmmatg WHERE almmmatg.codcia = 1 AND 
                                almmmatg.codmat = fill-in-codmat-2 NO-LOCK NO-ERROR.
      IF AVAILABLE almmmatg THEN DO:
          fill-in-desmat-2:SCREEN-VALUE = almmmatg.desmat.
          fill-in-marca-2:SCREEN-VALUE = almmmatg.desmar.
      END.

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codmat-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codmat-3 W-Win
ON LEAVE OF FILL-IN-codmat-3 IN FRAME F-Main /* Articulo #3 */
DO:

  ASSIGN fill-in-codmat-3 fill-in-desmat-3 fill-in-marca-3 FILL-in-fecha x-copias.  

  DO WITH FRAME {&FRAME-NAME}:
      fill-in-desmat-3:SCREEN-VALUE = "".
      fill-in-marca-3:SCREEN-VALUE = "".

      FIND FIRST almmmatg WHERE almmmatg.codcia = 1 AND 
                                almmmatg.codmat = fill-in-codmat-3 NO-LOCK NO-ERROR.
      IF AVAILABLE almmmatg THEN DO:
          fill-in-desmat-3:SCREEN-VALUE = almmmatg.desmat.
          fill-in-marca-3:SCREEN-VALUE = almmmatg.desmar.
      END.

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
  DISPLAY FILL-IN-codmat FILL-IN-cama FILL-IN-lote FILL-IN-vcto FILL-IN-codmat-2 
          FILL-IN-codmat-3 FILL-IN-fecha FILL-IN-desmat FILL-IN-marca 
          FILL-IN-desmat-2 FILL-IN-marca-2 FILL-IN-desmat-3 FILL-IN-marca-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-codmat FILL-IN-cama FILL-IN-lote FILL-IN-vcto FILL-IN-codmat-2 
         FILL-IN-codmat-3 FILL-IN-fecha btn-print BUTTON-8 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Etiqueta W-Win 
PROCEDURE Imprime-Etiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

x-key2 = STRING(TODAY,"99/99/9999") + STRING(TIME,"HH:MM:SS").

/*
REPEAT WHILE L-Ubica:
    s-task-no = RANDOM(900000,999999).
    FIND FIRST b-w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN L-Ubica = NO.
END.
*/

s-task-no = 0.

IF s-task-no = 0 THEN DO:
    CORRELATIVO:
    REPEAT:
        s-task-no = RANDOM(1,999999).
        FIND FIRST b-w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report THEN LEAVE CORRELATIVO.
    END.
END.

FIND FIRST almmmatg WHERE almmmatg.codcia = 1 AND 
                          almmmatg.codmat = fill-in-codmat NO-LOCK NO-ERROR.
CREATE b-w-report.
ASSIGN b-w-report.task-no = s-task-no
        b-w-report.llave-c = fill-in-codmat
        b-w-report.campo-c[1] = fill-in-codmat.
        IF x-formato = 7 THEN DO:
            ASSIGN b-w-report.campo-c[2] = SUBSTRING(almmmatg.desmat,1,25)
                b-w-report.campo-c[6] = SUBSTRING(almmmatg.desmat,26,25).
        END.
        ELSE DO:
            ASSIGN b-w-report.campo-c[2] = SUBSTRING(almmmatg.desmat,1,60).
        END.
        ASSIGN  b-w-report.campo-c[3] = SUBSTRING(almmmatg.desmar,1,25)
            b-w-report.campo-c[4] = STRING(almmmatg.canemp)
            b-w-report.campo-c[5] = fill-in-cama
            b-w-report.campo-c[6] = fill-in-lote
            b-w-report.campo-d[1] = fill-in-fecha
            b-w-report.campo-d[2] = fill-in-vcto.   

IF x-formato = 3 THEN DO:
    ASSIGN b-w-report.llave-c = "ARTICULO".

    FIND FIRST almmmatg WHERE almmmatg.codcia = 1 AND 
                          almmmatg.codmat = fill-in-codmat-2 NO-LOCK NO-ERROR.
    CREATE b-w-report.
    ASSIGN b-w-report.task-no = s-task-no
            b-w-report.llave-c = "ARTICULO"
            b-w-report.campo-c[1] = fill-in-codmat-2
            b-w-report.campo-c[2] = substring(almmmatg.desmat,1,60)
            /*
            b-w-report.campo-c[2] = substring(almmmatg.desmat,1,25)
            b-w-report.campo-c[6] = substring(almmmatg.desmat,26,25)
            */
            b-w-report.campo-c[3] = substring(almmmatg.desmar,1,25)
            b-w-report.campo-c[4] = STRING(almmmatg.canemp)
            b-w-report.campo-c[5] = ""
            b-w-report.campo-d[1] = fill-in-fecha.    
END.
IF x-formato = 7 THEN DO:

    ASSIGN b-w-report.llave-c = "ARTICULO".
    
    FIND FIRST almmmatg WHERE almmmatg.codcia = 1 AND 
                          almmmatg.codmat = fill-in-codmat-2 NO-LOCK NO-ERROR.

    ASSIGN b-w-report.campo-c[11] = fill-in-codmat-2
            b-w-report.campo-c[12] = substring(almmmatg.desmat,1,25)
            b-w-report.campo-c[16] = substring(almmmatg.desmat,26,25)
            b-w-report.campo-c[13] = substring(almmmatg.desmar,1,25)
            b-w-report.campo-c[14] = STRING(almmmatg.canemp)
            b-w-report.campo-c[15] = ""
            b-w-report.campo-d[2] = fill-in-fecha.    

    FIND FIRST almmmatg WHERE almmmatg.codcia = 1 AND 
                          almmmatg.codmat = fill-in-codmat-3 NO-LOCK NO-ERROR.

    ASSIGN b-w-report.campo-c[21] = fill-in-codmat-3
            b-w-report.campo-c[22] = substring(almmmatg.desmat,1,25)
            b-w-report.campo-c[26] = substring(almmmatg.desmat,26,25)
            b-w-report.campo-c[23] = substring(almmmatg.desmar,1,25)
            b-w-report.campo-c[24] = STRING(almmmatg.canemp)
            b-w-report.campo-c[25] = ""
            b-w-report.campo-d[3] = fill-in-fecha.    

    EMPTY TEMP-TABLE xtempo.
    CREATE xtempo.
    BUFFER-COPY b-w-report TO Xtempo. 
    FIND FIRST xtempo.

    CREATE b-w-report.
    BUFFER-COPY xtempo TO b-w-report.

    CREATE b-w-report.
    BUFFER-COPY xtempo TO b-w-report.

    CREATE b-w-report.
    BUFFER-COPY xtempo TO b-w-report.
END.

RELEASE b-w-report.

/* Code placed here will execute PRIOR to standard behavior. */
DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */


GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'logis/rblogis.prl'.
IF x-formato = 1 THEN RB-REPORT-NAME = 'hoja rotulada rack A4'.
IF x-formato = 3 THEN RB-REPORT-NAME = 'hoja rotulada rack A5'.
IF x-formato = 7 THEN RB-REPORT-NAME = 'hoja rotulada rack small'.
RB-INCLUDE-RECORDS = 'O'.

IF x-formato = 1 THEN DO: 
    RB-FILTER = "w-report.task-no = " + STRING(s-task-no) +
                    " and w-report.llave-c = '" + fill-in-codmat + "'".

END.
ELSE DO:
    RB-FILTER = "w-report.task-no = " + STRING(s-task-no)/* +
                    " and w-report.llave-c = '" + fill-in-codmat + "'"*/.

END.

RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                   RB-REPORT-NAME,
                   RB-INCLUDE-RECORDS,
                   RB-FILTER,
                   RB-OTHER-PARAMETERS).

/*DEF BUFFER B-w-report FOR w-report.*/
DEFINE VAR lRowId AS ROWID.

FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK:
    lRowId = ROWID(w-report).
    FIND FIRST b-w-report WHERE ROWID(b-w-report) = lRowid EXCLUSIVE NO-ERROR.
    IF AVAILABLE b-w-report THEN DO:
        DELETE b-w-report.            
    END.    
END.

RELEASE B-w-report.

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
  fill-in-fecha:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(NOW,"99/99/9999").

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

