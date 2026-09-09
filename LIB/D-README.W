&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
&IF "{&NEW}" = "" &THEN
    DEFINE INPUT PARAMETER file-name AS CHARACTER.
&ELSE
    DEFINE VARIABLE file-name AS CHARACTER INITIAL "C:\WINDOWS\SYSTEM.INI".
&ENDIF

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE OK            AS LOGICAL NO-UNDO.
DEFINE VARIABLE OKpressed     AS LOGICAL NO-UNDO.
DEFINE VARIABLE x-status      AS LOGICAL NO-UNDO.
/* DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.*/

DEFINE VARIABLE ANCHO-MIN AS DECIMAL NO-UNDO.
DEFINE VARIABLE ALTO-MIN  AS DECIMAL NO-UNDO.

DEFINE VARIABLE ANCHO-ACT AS DECIMAL NO-UNDO.
DEFINE VARIABLE ALTO-ACT  AS DECIMAL NO-UNDO.

DEFINE VARIABLE hStatus   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE iCount    AS INTEGER.
DEFINE VARIABLE flagfind  AS INTEGER.

DEFINE BUTTON Btn_ayuda AUTO-END-KEY 
     LABEL "A&yuda" 
     SIZE 12 BY .88
     BGCOLOR 8 .

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 12 BY .88
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "&Aceptar" 
     SIZE 12 BY .88
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-busca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Que Buscar" 
     VIEW-AS FILL-IN 
     SIZE 42.43 BY .81 NO-UNDO.

DEFINE VARIABLE R-direccion AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Abajo", 1,
"Arriba", 2
     SIZE 16.14 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 51.57 BY 1.58.

DEFINE VARIABLE TGL-ciclico AS LOGICAL INITIAL TRUE
     LABEL "Búsqueda Cíclica" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.43 BY .77 NO-UNDO.

DEFINE VARIABLE TGL-sensitivo AS LOGICAL INITIAL no 
     LABEL "Diferencia Mayúsculas/Minúsculas" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.72 BY .77 NO-UNDO.

DEFINE FRAME F-busca
     TGL-sensitivo AT ROW 2.58 COL 3.86
     TGL-ciclico AT ROW 3.5 COL 3.86
     Btn_OK AT ROW 4.65 COL 4.29
     FILL-IN-busca AT ROW 1.42 COL 9.57 COLON-ALIGNED
     Btn_Cancel AT ROW 4.65 COL 17.29
     R-direccion AT ROW 3.23 COL 38.29 NO-LABEL
     Btn_ayuda AT ROW 4.65 COL 41.14
     RECT-2 AT ROW 4.35 COL 2.86
     "Dirección:" VIEW-AS TEXT
          SIZE 8.29 BY .5 AT ROW 2.58 COL 38.14
     SPACE(9.99) SKIP(3.26)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4 TITLE "Buscar" CENTERED.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn-abrir EDITOR-1 FILL-IN-1 Btn-grabar ~
FILL-IN-2 Btn-impdoc FILL-IN-3 Btn-imptex Btn-copiar Btn-cortar Btn-pegar ~
Btn-max Btn-min Btn-buscar Btn-top Btn-bot Btn-salir Btn-ayuda RECT-1 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-1 FILL-IN-1 FILL-IN-2 FILL-IN-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-abrir 
     IMAGE-UP FILE "img\pvabrir":U
     LABEL "" 
     SIZE 3.86 BY .96.

DEFINE BUTTON Btn-ayuda 
     IMAGE-UP FILE "img\pvayuda":U
     LABEL "" 
     SIZE 3.86 BY .96.

DEFINE BUTTON Btn-bot 
     IMAGE-UP FILE "img/pvultimo":U
     LABEL "" 
     SIZE 3.86 BY .96.

DEFINE BUTTON Btn-buscar 
     IMAGE-UP FILE "img/pvbuscar":U
     LABEL "" 
     SIZE 3.86 BY .96.

DEFINE BUTTON Btn-copiar 
     IMAGE-UP FILE "img\pvcopiar":U
     LABEL "" 
     SIZE 3.86 BY .96.

DEFINE BUTTON Btn-cortar 
     IMAGE-UP FILE "img\pvcortar":U
     LABEL "" 
     SIZE 3.86 BY .96.

DEFINE BUTTON Btn-grabar 
     IMAGE-UP FILE "img\pvgrabar":U
     LABEL "" 
     SIZE 3.86 BY .96.

DEFINE BUTTON Btn-impdoc 
     IMAGE-UP FILE "img/pvprint1":U
     LABEL "" 
     SIZE 3.86 BY .96.

DEFINE BUTTON Btn-imptex 
     IMAGE-UP FILE "img/pvprint2":U
     LABEL "" 
     SIZE 3.86 BY .96.

DEFINE BUTTON Btn-max 
     IMAGE-UP FILE "img\pvlupa1":U
     LABEL "" 
     SIZE 3.86 BY .96.

DEFINE BUTTON Btn-min 
     IMAGE-UP FILE "img\pvlupa2":U
     LABEL "" 
     SIZE 3.86 BY .96.

DEFINE BUTTON Btn-pegar 
     IMAGE-UP FILE "img\pvpegar":U
     LABEL "" 
     SIZE 3.86 BY .96.

DEFINE BUTTON Btn-salir AUTO-END-KEY 
     IMAGE-UP FILE "img\pvsalir":U
     LABEL "" 
     SIZE 3.86 BY .96.

DEFINE BUTTON Btn-top 
     IMAGE-UP FILE "img/pvprimer":U
     LABEL "" 
     SIZE 3.86 BY .96.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 85.72 BY 14.5
     FONT 2 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP
     SIZE 54.29 BY .81
     BGCOLOR 8 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP
     SIZE 15 BY .81
     BGCOLOR 8 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP
     SIZE 15 BY .81
     BGCOLOR 8 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 85.86 BY 1.35
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn-abrir AT ROW 1.19 COL 2
     EDITOR-1 AT ROW 2.38 COL 1.43 NO-LABEL
     FILL-IN-1 AT ROW 16.96 COL 1 NO-LABEL
     Btn-grabar AT ROW 1.19 COL 6
     FILL-IN-2 AT ROW 16.96 COL 56.14 NO-LABEL
     Btn-impdoc AT ROW 1.19 COL 10
     FILL-IN-3 AT ROW 16.96 COL 72.14 NO-LABEL
     Btn-imptex AT ROW 1.19 COL 14
     Btn-copiar AT ROW 1.19 COL 18
     Btn-cortar AT ROW 1.19 COL 22
     Btn-pegar AT ROW 1.19 COL 26
     Btn-max AT ROW 1.19 COL 30
     Btn-min AT ROW 1.19 COL 34
     Btn-buscar AT ROW 1.19 COL 38
     Btn-top AT ROW 1.19 COL 42
     Btn-bot AT ROW 1.19 COL 46
     Btn-salir AT ROW 1.19 COL 78.14
     Btn-ayuda AT ROW 1.19 COL 82.14
     RECT-1 AT ROW 1 COL 1.29
     SPACE(0.00) SKIP(15.42)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Consulta por pantalla".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

ASSIGN 
       EDITOR-1:READ-ONLY IN FRAME D-Dialog        = TRUE.

ASSIGN 
       FILL-IN-1:READ-ONLY IN FRAME D-Dialog        = TRUE.

ASSIGN 
       FILL-IN-2:READ-ONLY IN FRAME D-Dialog        = TRUE.

ASSIGN 
       FILL-IN-3:READ-ONLY IN FRAME D-Dialog        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Consulta por pantalla */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-abrir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-abrir D-Dialog
ON CHOOSE OF Btn-abrir IN FRAME D-Dialog
DO:
      IF EDITOR-1:MODIFIED IN FRAME {&FRAME-NAME} = TRUE THEN DO:
        BELL.
        MESSAGE "El archivo" FILL-IN-1:SCREEN-VALUE "ha sido modificado." SKIP
            "Desea guardar los cambios?" VIEW-AS ALERT-BOX WARNING
            BUTTONS YES-NO-CANCEL UPDATE p_salvar_cambios AS LOGICAL.
        CASE p_salvar_cambios:
            WHEN ? THEN DO:
                APPLY "ENTRY" TO EDITOR-1.
                RETURN NO-APPLY.
            END.
            WHEN TRUE THEN RUN guardar-cambios.
        END.
    END.
    RUN abrir-archivo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-bot
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-bot D-Dialog
ON CHOOSE OF Btn-bot IN FRAME D-Dialog
DO:
    OK = EDITOR-1:MOVE-TO-EOF().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-buscar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-buscar D-Dialog
ON CHOOSE OF Btn-buscar IN FRAME D-Dialog
DO:
    RUN busca-dato.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-copiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-copiar D-Dialog
ON CHOOSE OF Btn-copiar IN FRAME D-Dialog
DO:
  
    CLIPBOARD:VALUE = EDITOR-1:SELECTION-TEXT IN FRAME {&FRAME-NAME} NO-ERROR.
    IF ( ERROR-STATUS:NUM-MESSAGES > 0 ) THEN DO:
        BELL.
        MESSAGE "Texto muy grande para copiar" SKIP(1)
            ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX ERROR.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-cortar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-cortar D-Dialog
ON CHOOSE OF Btn-cortar IN FRAME D-Dialog
DO:
      IF EDITOR-1:READ-ONLY IN FRAME {&FRAME-NAME} = TRUE THEN RETURN.
    
    CLIPBOARD:VALUE = EDITOR-1:SELECTION-TEXT IN FRAME {&FRAME-NAME} NO-ERROR.
    IF ( ERROR-STATUS:NUM-MESSAGES > 0 ) THEN DO:
        BELL.
        MESSAGE "Texto muy grande para copiar." SKIP(1)
            ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX ERROR.
    END.
    ELSE DO:
        ASSIGN x-Status = EDITOR-1:REPLACE-SELECTION-TEXT("").
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-grabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-grabar D-Dialog
ON CHOOSE OF Btn-grabar IN FRAME D-Dialog
DO:
    RUN guardar-cambios.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-impdoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-impdoc D-Dialog
ON CHOOSE OF Btn-impdoc IN FRAME D-Dialog
DO:
    IF EDITOR-1:MODIFIED IN FRAME {&FRAME-NAME} = TRUE THEN DO:
        BELL.
        MESSAGE "El archivo" FILL-IN-1:SCREEN-VALUE "ha sido modificado." SKIP
            "Desea guardar los cambios antes de salir?" VIEW-AS ALERT-BOX WARNING
            BUTTONS YES-NO-CANCEL UPDATE p_salvar_cambios AS LOGICAL.
        CASE p_salvar_cambios:
            WHEN ? THEN DO:
                APPLY "ENTRY" TO EDITOR-1.
                RETURN NO-APPLY.
            END.
            WHEN TRUE THEN RUN guardar-cambios.
        END.
    END.
    RUN imprime-documento(FILL-IN-1:SCREEN-VALUE).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-imptex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-imptex D-Dialog
ON CHOOSE OF Btn-imptex IN FRAME D-Dialog
DO:
      IF EDITOR-1:SELECTION-TEXT IN FRAME {&FRAME-NAME} = "" THEN RETURN.

    DEFINE VARIABLE x-archivo AS CHARACTER.
    DEFINE VARIABLE x-texto   AS CHARACTER.

    ASSIGN
        /*x-archivo = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(temp_file, integral), "99999999") + ".tmp".*/
        x-archivo = SESSION:TEMP-DIRECTORY + "prueba.tmp".
    x-texto = REPLACE(EDITOR-1:SELECTION-TEXT, CHR(13), "").

    OUTPUT TO VALUE(x-archivo).
    PUT UNFORMATTED x-texto.
    OUTPUT CLOSE.

    RUN imprime-documento(x-archivo).

    OS-DELETE VALUE(x-archivo).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-max
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-max D-Dialog
ON CHOOSE OF Btn-max IN FRAME D-Dialog
DO:
    IF EDITOR-1:FONT IN FRAME {&FRAME-NAME} = 2 THEN ASSIGN EDITOR-1:FONT = 0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-min
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-min D-Dialog
ON CHOOSE OF Btn-min IN FRAME D-Dialog
DO:
    IF EDITOR-1:FONT IN FRAME {&FRAME-NAME} <> 2 THEN ASSIGN EDITOR-1:FONT = 2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-pegar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-pegar D-Dialog
ON CHOOSE OF Btn-pegar IN FRAME D-Dialog
DO:
      DEFINE VARIABLE Paste_Text    AS CHAR    NO-UNDO.
    DEFINE VARIABLE Clip_Multiple AS LOGICAL NO-UNDO INIT FALSE.
  
    DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE WITH FRAME {&FRAME-NAME}:
        IF EDITOR-1:READ-ONLY THEN LEAVE.
        ASSIGN
            Clip_Multiple      = CLIPBOARD:MULTIPLE
            CLIPBOARD:MULTIPLE = FALSE.
  
        IF CLIPBOARD:NUM-FORMATS > 0 THEN DO:
            ASSIGN Paste_Text = CLIPBOARD:VALUE NO-ERROR.
            IF ( ERROR-STATUS:NUM-MESSAGES > 0 ) THEN DO:
                BELL.
                MESSAGE "Texto muy grande para pegar" SKIP(1)
                    ERROR-STATUS:GET-MESSAGE(1)
                    VIEW-AS ALERT-BOX ERROR.
            END.
            ELSE DO:
                IF EDITOR-1:TEXT-SELECTED THEN
                    ASSIGN x-status = EDITOR-1:REPLACE-SELECTION-TEXT( CLIPBOARD:VALUE ) .
                ELSE
                    ASSIGN x-status = EDITOR-1:INSERT-STRING( CLIPBOARD:VALUE ) .
                IF ( x-status = FALSE ) THEN DO:
                    BELL.
                    MESSAGE "No puede pegar, editor lleno"
                        VIEW-AS ALERT-BOX ERROR.
                END.
            END.
        END .
    END.

    ASSIGN CLIPBOARD:MULTIPLE = Clip_Multiple. 
    APPLY "ENTRY" TO EDITOR-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-salir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-salir D-Dialog
ON CHOOSE OF Btn-salir IN FRAME D-Dialog
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-top
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-top D-Dialog
ON CHOOSE OF Btn-top IN FRAME D-Dialog
DO:
    EDITOR-1:CURSOR-LINE = 1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME EDITOR-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EDITOR-1 D-Dialog
ON ENTRY OF EDITOR-1 IN FRAME D-Dialog
DO:
    ASSIGN FILL-IN-3:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EDITOR-1 D-Dialog
ON LEAVE OF EDITOR-1 IN FRAME D-Dialog
DO:
    ASSIGN FILL-IN-3:SCREEN-VALUE = "Línea: " + STRING(EDITOR-1:CURSOR-LINE, ">>>>>>9").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-1 D-Dialog
ON ENTRY OF FILL-IN-1 IN FRAME D-Dialog
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-2 D-Dialog
ON ENTRY OF FILL-IN-2 IN FRAME D-Dialog
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-3 D-Dialog
ON ENTRY OF FILL-IN-3 IN FRAME D-Dialog
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

/*ASSIGN
    ANCHO-MIN = {&FRAME-NAME}:WIDTH.
    ALTO-MIN  = {&FRAME-NAME}:HEIGHT.
    Ancho-Act = MINIMUM( {&FRAME-NAME}:WIDTH  , FRAME {&FRAME-NAME}:WIDTH  ) - .2.
    Alto-Act  = MINIMUM( {&FRAME-NAME}:HEIGHT , FRAME {&FRAME-NAME}:HEIGHT ) - RECT-1:HEIGHT - .02.
  
ASSIGN
    RECT-1:WIDTH    = Ancho-Act
    EDITOR-1:WIDTH  = Ancho-Act
    EDITOR-1:HEIGHT = Alto-Act - .81
    FILL-IN-1:ROW   = {&FRAME-NAME}:HEIGHT + .19
    FILL-IN-2:ROW   = {&FRAME-NAME}:HEIGHT + .19
    FILL-IN-3:ROW   = {&FRAME-NAME}:HEIGHT + .19
    FILL-IN-1:WIDTH = Ancho-Act - 32
    FILL-IN-2:COL   = Ancho-Act - 30
    FILL-IN-3:COL   = Ancho-Act - 14.
*/
{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE abrir-archivo D-Dialog 
PROCEDURE abrir-archivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SYSTEM-DIALOG GET-FILE file-name
    TITLE   "Archivo(s) de Impresión..."
    FILTERS
        "Archivo Impresión (*.txt)" "*.txt",
        "Todos (*.*)"               "*.*"
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.

IF OKpressed = TRUE THEN RUN carga-archivo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca-dato D-Dialog 
PROCEDURE busca-dato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE:
    UPDATE
        FILL-IN-busca
        TGL-sensitivo
        TGL-ciclico
        R-direccion
        Btn_OK
        Btn_Cancel
        Btn_Ayuda
        WITH FRAME F-busca.

    IF FILL-IN-busca = "" THEN RETURN.
    IF R-direccion = 1 THEN ASSIGN flagfind = 1.
    ELSE ASSIGN flagfind = 2.

    IF TGL-ciclico   = TRUE THEN ASSIGN flagfind = flagfind + 16.
    IF TGL-sensitivo = TRUE THEN ASSIGN flagfind = flagfind + 4.

    ASSIGN flagfind = flagfind + 32.

    RUN ejecutar-busqueda(flagfind).
    APPLY "ENTRY" TO EDITOR-1 IN FRAME {&FRAME-NAME}.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-archivo D-Dialog 
PROCEDURE carga-archivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EDITOR-1:READ-FILE( File-name ) IN FRAME {&FRAME-NAME}.
    EDITOR-1:LOAD-MOUSE-POINTER( "IBEAM" ) IN FRAME {&FRAME-NAME}.
    FRAME {&FRAME-NAME}:LOAD-MOUSE-POINTER( "GLOVE" ).
    FILL-IN-1:SCREEN-VALUE = File-name.
    /*
    FILL-IN-2:SCREEN-VALUE = "Fecha : " + STRING(TODAY).
    FILL-IN-3:SCREEN-VALUE = "Hora : " + STRING(TIME, "hh:mm").
    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DLL D-Dialog 
PROCEDURE DLL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

PROCEDURE GetFreeSpace EXTERNAL "KERNEL.exe":
    DEFINE RETURN PARAMETER mem     AS LONG.
    DEFINE INPUT  PARAMETER flag    AS SHORT.
END.

PROCEDURE GetFreeSystemResources EXTERNAL "USER.exe":
    /*
        flag = 0    SYSTEM RESOURCES
             = 1    USER RESOURCES
             = 2    GDI RESOURCES
    */
    DEFINE RETURN PARAMETER recurso AS SHORT.
    DEFINE INPUT  PARAMETER flag    AS SHORT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ejecutar-busqueda D-Dialog 
PROCEDURE ejecutar-busqueda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF FILL-IN-busca = "" THEN RETURN.

DEFINE INPUT PARAMETER flag AS INTEGER.

DEFINE VARIABLE x-Ok AS LOGICAL.

x-Ok = EDITOR-1:SEARCH( FILL-IN-busca, flag ) IN FRAME {&FRAME-NAME}.
IF NOT x-Ok THEN DO:
    BELL.
    MESSAGE "Texto no encontrado" VIEW-AS ALERT-BOX ERROR.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY EDITOR-1 FILL-IN-1 FILL-IN-2 FILL-IN-3 
      WITH FRAME D-Dialog.
  ENABLE Btn-abrir EDITOR-1 FILL-IN-1 Btn-grabar FILL-IN-2 Btn-impdoc FILL-IN-3 
         Btn-imptex Btn-copiar Btn-cortar Btn-pegar Btn-max Btn-min Btn-buscar 
         Btn-top Btn-bot Btn-salir Btn-ayuda RECT-1 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE guardar-cambios D-Dialog 
PROCEDURE guardar-cambios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE x-Ok AS LOGICAL.

ASSIGN x-Ok = EDITOR-1:SAVE-FILE( file-name ) IN FRAME {&FRAME-NAME} NO-ERROR.

IF x-Ok <> TRUE THEN DO:
    BELL.
    MESSAGE file-name SKIP
        "No puede salvar a este archivo." SKIP(1)
        "Archivo sólo de lectura o trayectoria especificada no válida." SKIP
        "Use un nombre de archivo diferente."
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
END.
ELSE ASSIGN FILL-IN-1:SCREEN-VALUE = file-name.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE guardar-como D-Dialog 
PROCEDURE guardar-como :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SYSTEM-DIALOG GET-FILE file-name
    TITLE   file-name
    FILTERS
        "Archivo Impresión (*.txt)" "*.txt",
        "Todos (*.*)"               "*.*"
    SAVE-AS
    USE-FILENAME
    ASK-OVERWRITE
    CREATE-TEST-FILE
    UPDATE OKpressed.

RUN guardar-cambios.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-documento D-Dialog 
PROCEDURE imprime-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER printer-file AS CHARACTER.

RUN adecomm/_osprint.p(
    INPUT ?, /* Ventana actual */
    INPUT printer-file, /* Nombre del archivo */
    INPUT 2, /* Font */
    INPUT 1, /* Configuración de impresión */
    INPUT 0, /* Tamaño de página por defecto */
    INPUT 1, /* Pide rango de página */
    OUTPUT x-status ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit D-Dialog 
PROCEDURE local-exit :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  RUN carga-archivo.

/*  ASSIGN
    MENU-ITEM m_Solo_Lectura:CHECKED IN MENU m_edicion = TRUE*/
    FILL-IN-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Solo lectura".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

