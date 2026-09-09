&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
/* Procedure Description
"Visualiza un archivo en Pantalla"
*/
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

&Scoped-define PROCEDURE-TYPE SmartConsulta

&Scoped-define ADM-SUPPORTED-LINKS    Record-Source,Record-Target,Navigation-Source,Navigation-Target,TableIO-Source,TableIO-Target,Page-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 Btn-abrir Btn-grabar Btn-impdoc ~
Btn-imptex Btn-copiar Btn-cortar Btn-pegar Btn-max Btn-min Btn-buscar ~
Btn-top Btn-bot Btn-salir Btn-ayuda EDITOR-1 FILL-IN-1 FILL-IN-2 FILL-IN-3 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-1 FILL-IN-1 FILL-IN-2 FILL-IN-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Imprimir 
       MENU-ITEM m_Documento_Completo LABEL "&Documento Completo"
       MENU-ITEM m_Texto_Seleccionado LABEL "&Texto Seleccionado".

DEFINE SUB-MENU m_Archivo 
       MENU-ITEM m_Abrir        LABEL "&Abrir"        
       MENU-ITEM m_Cerrar       LABEL "&Cerrar"       
       MENU-ITEM m_Guardar      LABEL "&Guardar"      
       MENU-ITEM m_Guardar_Como LABEL "Guardar &Como" 
       SUB-MENU  m_Imprimir     LABEL "&Imprimir"     
       RULE
       MENU-ITEM m_Salir        LABEL "&Salir"        .

DEFINE SUB-MENU m_Edicion 
       MENU-ITEM m_Copiar       LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM m_Cortar       LABEL "Cor&tar"        ACCELERATOR "CTRL-X"
       MENU-ITEM m_Pegar        LABEL "&Pegar"         ACCELERATOR "CTRL-V"
       RULE
       MENU-ITEM m_Solo_Lectura LABEL "&Solo Lectura" 
              TOGGLE-BOX.

DEFINE SUB-MENU m_Buscar 
       MENU-ITEM m_Buscar2      LABEL "&Buscar..."     ACCELERATOR "CTRL-F"
       MENU-ITEM m_Buscar_Siguiente LABEL "Buscar &Siguiente" ACCELERATOR "F9"
       MENU-ITEM m_Buscar_Previo LABEL "Buscar &Previo" ACCELERATOR "SHIFT-F9".

DEFINE SUB-MENU m_Visualizar 
       MENU-ITEM m_Mximo        LABEL "&Máximo"       
       MENU-ITEM m_Minimo       LABEL "M&ínimo"       .

DEFINE SUB-MENU m_Ayuda 
       MENU-ITEM m_Contenido    LABEL "&Contenido"    
       MENU-ITEM m_Acerca_del_Autor LABEL "&Acerca del Autor".

DEFINE MENU MENU-BAR-W-Win MENUBAR
       SUB-MENU  m_Archivo      LABEL "&Archivo"      
       SUB-MENU  m_Edicion      LABEL "&Edición"      
       SUB-MENU  m_Buscar       LABEL "&Buscar"       
       SUB-MENU  m_Visualizar   LABEL "&Visualizar"   
       SUB-MENU  m_Ayuda        LABEL "&Ayuda"        .


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

DEFINE BUTTON Btn-salir 
     IMAGE-UP FILE "img\pvsalir":U
     LABEL "" 
     SIZE 3.86 BY .96.

DEFINE BUTTON Btn-top 
     IMAGE-UP FILE "img/pvprimer":U
     LABEL "" 
     SIZE 3.86 BY .96.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 80 BY 10.65
     FONT 2 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP
     SIZE 48 BY .81
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
     SIZE 79.86 BY 1.35
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn-abrir AT ROW 1.19 COL 2
     Btn-grabar AT ROW 1.19 COL 6
     Btn-impdoc AT ROW 1.19 COL 10
     Btn-imptex AT ROW 1.19 COL 14
     Btn-copiar AT ROW 1.19 COL 18
     Btn-cortar AT ROW 1.19 COL 22
     Btn-pegar AT ROW 1.19 COL 26
     Btn-max AT ROW 1.19 COL 30
     Btn-min AT ROW 1.19 COL 34
     Btn-buscar AT ROW 1.19 COL 38
     Btn-top AT ROW 1.19 COL 42
     Btn-bot AT ROW 1.19 COL 46
     Btn-salir AT ROW 1.19 COL 72
     Btn-ayuda AT ROW 1.19 COL 76
     EDITOR-1 AT ROW 2.5 COL 1.43 NO-LABEL
     FILL-IN-1 AT ROW 13 COL 1 NO-LABEL
     FILL-IN-2 AT ROW 13 COL 50 NO-LABEL
     FILL-IN-3 AT ROW 13 COL 66 NO-LABEL
     RECT-1 AT ROW 1.04 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         PAGE-TOP SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.43 BY 15.92
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartConsulta
   Allow: Basic,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "SmartConsulta"
         HEIGHT             = 12.85
         WIDTH              = 80.86
         MAX-HEIGHT         = 22.85
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.85
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-W-Win:HANDLE.

IF NOT W-Win:LOAD-ICON("img/vcat":U) THEN
    MESSAGE "Unable to load icon: img/vcat"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR FRAME F-Main
   Custom                                                               */
ASSIGN 
       EDITOR-1:READ-ONLY IN FRAME F-Main        = TRUE.

ASSIGN 
       FILL-IN-1:READ-ONLY IN FRAME F-Main        = TRUE.

ASSIGN 
       FILL-IN-2:READ-ONLY IN FRAME F-Main        = TRUE.

ASSIGN 
       FILL-IN-3:READ-ONLY IN FRAME F-Main        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* SmartConsulta */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* SmartConsulta */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-RESIZED OF W-Win /* SmartConsulta */
DO:
  IF W-Win:WIDTH < Ancho-Min
  THEN W-Win:WIDTH = Ancho-Min.
  IF W-Win:HEIGHT < Alto-Min
  THEN W-Win:HEIGHT = Alto-Min.
  Ancho-Act = MINIMUM( W-Win:WIDTH  , FRAME F-MAIN:WIDTH  ) - .2.
  Alto-Act  = MINIMUM( W-Win:HEIGHT , FRAME F-MAIN:HEIGHT ) - 
                              RECT-1:HEIGHT - .02.
  
  ASSIGN RECT-1:WIDTH    = Ancho-Act
         EDITOR-1:WIDTH  = Ancho-Act
         Btn-salir:COL   = Ancho-Act - 7.86
         Btn-ayuda:COL   = Ancho-Act - 3.86
         EDITOR-1:HEIGHT = Alto-Act - .81
         FILL-IN-1:ROW   = W-Win:HEIGHT + .19
         FILL-IN-2:ROW   = W-Win:HEIGHT + .19
         FILL-IN-3:ROW   = W-Win:HEIGHT + .19
         FILL-IN-1:WIDTH = Ancho-Act - 32
         FILL-IN-2:COL   = Ancho-Act - 30
         FILL-IN-3:COL   = Ancho-Act - 14.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-abrir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-abrir W-Win
ON CHOOSE OF Btn-abrir IN FRAME F-Main
DO:
    APPLY "CHOOSE" TO MENU-ITEM m_Abrir IN MENU m_archivo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-bot
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-bot W-Win
ON CHOOSE OF Btn-bot IN FRAME F-Main
DO:
    OK = EDITOR-1:MOVE-TO-EOF().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-buscar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-buscar W-Win
ON CHOOSE OF Btn-buscar IN FRAME F-Main
DO:
    APPLY "CHOOSE" TO MENU-ITEM m_Buscar2 IN MENU m_buscar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-copiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-copiar W-Win
ON CHOOSE OF Btn-copiar IN FRAME F-Main
DO:
    APPLY "CHOOSE" TO MENU-ITEM m_Copiar IN MENU m_edicion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-cortar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-cortar W-Win
ON CHOOSE OF Btn-cortar IN FRAME F-Main
DO:
    APPLY "CHOOSE" TO MENU-ITEM m_Cortar IN MENU m_edicion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-grabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-grabar W-Win
ON CHOOSE OF Btn-grabar IN FRAME F-Main
DO:
    APPLY "CHOOSE" TO MENU-ITEM m_Guardar IN MENU m_archivo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-impdoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-impdoc W-Win
ON CHOOSE OF Btn-impdoc IN FRAME F-Main
DO:
    APPLY "CHOOSE" TO MENU-ITEM m_Documento_Completo IN MENU m_archivo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-imptex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-imptex W-Win
ON CHOOSE OF Btn-imptex IN FRAME F-Main
DO:
    APPLY "CHOOSE" TO MENU-ITEM m_Texto_Seleccionado IN MENU m_archivo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-max
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-max W-Win
ON CHOOSE OF Btn-max IN FRAME F-Main
DO:
    IF EDITOR-1:FONT IN FRAME F-Main = 2 THEN ASSIGN EDITOR-1:FONT = 0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-min
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-min W-Win
ON CHOOSE OF Btn-min IN FRAME F-Main
DO:
    IF EDITOR-1:FONT IN FRAME F-Main <> 2 THEN ASSIGN EDITOR-1:FONT = 2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-pegar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-pegar W-Win
ON CHOOSE OF Btn-pegar IN FRAME F-Main
DO:
    APPLY "CHOOSE" TO MENU-ITEM m_Pegar IN MENU m_edicion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-salir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-salir W-Win
ON CHOOSE OF Btn-salir IN FRAME F-Main
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-top
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-top W-Win
ON CHOOSE OF Btn-top IN FRAME F-Main
DO:
    EDITOR-1:CURSOR-LINE = 1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME EDITOR-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EDITOR-1 W-Win
ON ENTRY OF EDITOR-1 IN FRAME F-Main
DO:
    ASSIGN FILL-IN-3:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EDITOR-1 W-Win
ON LEAVE OF EDITOR-1 IN FRAME F-Main
DO:
    ASSIGN FILL-IN-3:SCREEN-VALUE = "Línea: " + STRING(EDITOR-1:CURSOR-LINE, ">>>>>>9").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-1 W-Win
ON ENTRY OF FILL-IN-1 IN FRAME F-Main
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-2 W-Win
ON ENTRY OF FILL-IN-2 IN FRAME F-Main
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-3 W-Win
ON ENTRY OF FILL-IN-3 IN FRAME F-Main
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Abrir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Abrir W-Win
ON CHOOSE OF MENU-ITEM m_Abrir /* Abrir */
DO:
    IF EDITOR-1:MODIFIED IN FRAME F-Main = TRUE THEN DO:
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


&Scoped-define SELF-NAME m_Acerca_del_Autor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Acerca_del_Autor W-Win
ON CHOOSE OF MENU-ITEM m_Acerca_del_Autor /* Acerca del Autor */
DO:
    MESSAGE 
        "Visualizador en Pantalla" SKIP
        "Versi¢n 2.0" SKIP
        "Copyright 1996-1997 VALMIESA & Asociados"
        VIEW-AS ALERT-BOX INFORMATION TITLE "Acerca del autor".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Buscar2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Buscar2 W-Win
ON CHOOSE OF MENU-ITEM m_Buscar2 /* Buscar... */
DO:
    RUN busca-dato.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Buscar_Previo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Buscar_Previo W-Win
ON CHOOSE OF MENU-ITEM m_Buscar_Previo /* Buscar Previo */
DO:
    RUN ejecutar-busqueda(flagfind + 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Buscar_Siguiente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Buscar_Siguiente W-Win
ON CHOOSE OF MENU-ITEM m_Buscar_Siguiente /* Buscar Siguiente */
DO:
    RUN ejecutar-busqueda(flagfind).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Cerrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Cerrar W-Win
ON CHOOSE OF MENU-ITEM m_Cerrar /* Cerrar */
DO:
    IF EDITOR-1:MODIFIED IN FRAME F-Main = TRUE THEN DO:
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
    APPLY "CHOOSE" TO Btn-Salir IN FRAME F-Main.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Copiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Copiar W-Win
ON CHOOSE OF MENU-ITEM m_Copiar /* Copiar */
DO:

    CLIPBOARD:VALUE = EDITOR-1:SELECTION-TEXT IN FRAME F-Main NO-ERROR.
    IF ( ERROR-STATUS:NUM-MESSAGES > 0 ) THEN DO:
        BELL.
        MESSAGE "Texto muy grande para copiar" SKIP(1)
            ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX ERROR.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Cortar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Cortar W-Win
ON CHOOSE OF MENU-ITEM m_Cortar /* Cortar */
DO:
    IF EDITOR-1:READ-ONLY IN FRAME F-Main = TRUE THEN RETURN.
    
    CLIPBOARD:VALUE = EDITOR-1:SELECTION-TEXT IN FRAME F-Main NO-ERROR.
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


&Scoped-define SELF-NAME m_Documento_Completo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Documento_Completo W-Win
ON CHOOSE OF MENU-ITEM m_Documento_Completo /* Documento Completo */
DO:
    IF EDITOR-1:MODIFIED IN FRAME F-Main = TRUE THEN DO:
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


&Scoped-define SELF-NAME m_Edicion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Edicion W-Win
ON MENU-DROP OF MENU m_Edicion /* Edición */
DO:
    ASSIGN
        MENU-ITEM m_Cortar:SENSITIVE IN MENU m_edicion =
        ( NOT EDITOR-1:READ-ONLY IN FRAME F-Main ) AND ( EDITOR-1:TEXT-SELECTED )
        MENU-ITEM m_Copiar:SENSITIVE IN MENU m_edicion =
        ( EDITOR-1:TEXT-SELECTED )
        MENU-ITEM m_pegar:SENSITIVE IN MENU m_edicion =
        ( CLIPBOARD:NUM-FORMATS > 0 ) AND ( NOT EDITOR-1:READ-ONLY ) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Guardar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Guardar W-Win
ON CHOOSE OF MENU-ITEM m_Guardar /* Guardar */
DO:
    RUN guardar-cambios.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Guardar_Como
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Guardar_Como W-Win
ON CHOOSE OF MENU-ITEM m_Guardar_Como /* Guardar Como */
DO:
    RUN guardar-como.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Minimo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Minimo W-Win
ON CHOOSE OF MENU-ITEM m_Minimo /* Mínimo */
DO:
    IF EDITOR-1:FONT IN FRAME F-Main <> 2 THEN ASSIGN EDITOR-1:FONT = 2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Mximo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Mximo W-Win
ON CHOOSE OF MENU-ITEM m_Mximo /* Máximo */
DO:
    IF EDITOR-1:FONT IN FRAME F-Main = 2 THEN ASSIGN EDITOR-1:FONT = 0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Pegar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Pegar W-Win
ON CHOOSE OF MENU-ITEM m_Pegar /* Pegar */
DO:
    DEFINE VARIABLE Paste_Text    AS CHAR    NO-UNDO.
    DEFINE VARIABLE Clip_Multiple AS LOGICAL NO-UNDO INIT FALSE.
  
    DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE WITH FRAME F-Main:
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


&Scoped-define SELF-NAME m_Salir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Salir W-Win
ON CHOOSE OF MENU-ITEM m_Salir /* Salir */
DO:
    IF EDITOR-1:MODIFIED IN FRAME F-Main = TRUE THEN DO:
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
    APPLY "CHOOSE" TO Btn-salir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Solo_Lectura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Solo_Lectura W-Win
ON VALUE-CHANGED OF MENU-ITEM m_Solo_Lectura /* Solo Lectura */
DO:
    IF EDITOR-1:READ-ONLY IN FRAME F-Main = TRUE THEN DO:
        ASSIGN EDITOR-1:READ-ONLY = FALSE.
        FILL-IN-2:SCREEN-VALUE = "".
    END.
    ELSE DO:
        ASSIGN EDITOR-1:READ-ONLY IN FRAME F-Main = TRUE.
        FILL-IN-2:SCREEN-VALUE = "Solo lectura".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Texto_Seleccionado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Texto_Seleccionado W-Win
ON CHOOSE OF MENU-ITEM m_Texto_Seleccionado /* Texto Seleccionado */
DO:
    IF EDITOR-1:SELECTION-TEXT IN FRAME F-Main = "" THEN RETURN.

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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

ASSIGN
    ANCHO-MIN = W-Win:WIDTH.
    ALTO-MIN  = W-Win:HEIGHT.
    Ancho-Act = MINIMUM( W-Win:WIDTH  , FRAME F-MAIN:WIDTH  ) - .2.
    Alto-Act  = MINIMUM( W-Win:HEIGHT , FRAME F-MAIN:HEIGHT ) - RECT-1:HEIGHT - .02.
  
ASSIGN
    RECT-1:WIDTH    = Ancho-Act
    EDITOR-1:WIDTH  = Ancho-Act
    EDITOR-1:HEIGHT = Alto-Act - .81
    FILL-IN-1:ROW   = W-Win:HEIGHT + .19
    FILL-IN-2:ROW   = W-Win:HEIGHT + .19
    FILL-IN-3:ROW   = W-Win:HEIGHT + .19
    FILL-IN-1:WIDTH = Ancho-Act - 32
    FILL-IN-2:COL   = Ancho-Act - 30
    FILL-IN-3:COL   = Ancho-Act - 14.

{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE abrir-archivo W-Win 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca-dato W-Win 
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
    APPLY "ENTRY" TO EDITOR-1 IN FRAME F-Main.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-archivo W-Win 
PROCEDURE carga-archivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OK-WAIT-STATE = EDITOR-1:READ-FILE( File-name ) IN FRAME F-MAIN.
    OK-WAIT-STATE = EDITOR-1:LOAD-MOUSE-POINTER( "IBEAM" ) IN FRAME F-MAIN.
    OK-WAIT-STATE = FRAME F-MAIN:LOAD-MOUSE-POINTER( "GLOVE" ).
    FILL-IN-1:SCREEN-VALUE = File-name.
    /*
    FILL-IN-2:SCREEN-VALUE = "Fecha : " + STRING(TODAY).
    FILL-IN-3:SCREEN-VALUE = "Hora : " + STRING(TIME, "hh:mm").
    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DLL W-Win 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ejecutar-busqueda W-Win 
PROCEDURE ejecutar-busqueda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF FILL-IN-busca = "" THEN RETURN.

DEFINE INPUT PARAMETER flag AS INTEGER.

DEFINE VARIABLE x-Ok AS LOGICAL.

x-Ok = EDITOR-1:SEARCH( FILL-IN-busca, flag ) IN FRAME F-Main.
IF NOT x-Ok THEN DO:
    BELL.
    MESSAGE "Texto no encontrado" VIEW-AS ALERT-BOX ERROR.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 Btn-abrir Btn-grabar Btn-impdoc Btn-imptex Btn-copiar 
         Btn-cortar Btn-pegar Btn-max Btn-min Btn-buscar Btn-top Btn-bot 
         Btn-salir Btn-ayuda EDITOR-1 FILL-IN-1 FILL-IN-2 FILL-IN-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE guardar-cambios W-Win 
PROCEDURE guardar-cambios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE x-Ok AS LOGICAL.

ASSIGN x-Ok = EDITOR-1:SAVE-FILE( file-name ) IN FRAME F-Main NO-ERROR.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE guardar-como W-Win 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-documento W-Win 
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
  RUN carga-archivo.

  ASSIGN
    MENU-ITEM m_Solo_Lectura:CHECKED IN MENU m_edicion = TRUE
    FILL-IN-2:SCREEN-VALUE IN FRAME F-Main = "Solo lectura".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartConsulta, and there are no
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


