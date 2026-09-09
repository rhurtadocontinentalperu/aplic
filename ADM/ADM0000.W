&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-MENUBAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-MENUBAR 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 06/30/94 -  6:53 pm

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

/*
    DEFINIMOS VARIABLES Y PROCEDIMIENTOS DE CARGA PARA LA EJECUCION DEL MENU
*/
DEFINE VARIABLE mainmenu     AS WIDGET-HANDLE.
DEFINE VARIABLE salir        AS WIDGET-HANDLE.
DEFINE VARIABLE linea        AS WIDGET-HANDLE.
DEFINE VARIABLE OpcMnu       AS WIDGET-HANDLE EXTENT 100.
DEFINE VARIABLE NumOpc       AS INTEGER INITIAL 1.
DEFINE VARIABLE LenOpc       AS INTEGER.
DEFINE VARIABLE UltMnu1      AS CHARACTER.
DEFINE VARIABLE UltOpc1      AS INTEGER.
DEFINE VARIABLE UltMnu2      AS CHARACTER.
DEFINE VARIABLE UltOpc2      AS INTEGER.
DEFINE VARIABLE fullname     AS CHARACTER.
DEFINE VARIABLE i            AS INTEGER.
DEFINE VARIABLE xhelp        AS CHARACTER.
DEFINE VARIABLE pto          AS LOGICAL.
DEFINE VARIABLE xOk          AS LOGICAL.
DEFINE VARIABLE Ok           AS LOGICAL.
DEFINE VARIABLE x            AS INTEGER.
DEFINE {&NEW} SHARED VARIABLE x-Grupo     AS CHARACTER      INITIAL " ".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id    LIKE Menus.Modulo INITIAL "ADM".
DEFINE {&NEW} SHARED VARIABLE s-codcia    AS INTEGER        INITIAL 1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-botones

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 BUTTON-1 BUTTON-2 BUTTON-3 BUTTON-4 ~
b-fin b-salir b-ayuda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-MENUBAR AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-ayuda 
     IMAGE-UP FILE "IMG/help"
     LABEL "A&yuda" 
     SIZE 5.72 BY 1.58.

DEFINE BUTTON b-fin 
     IMAGE-UP FILE "IMG/fin"
     LABEL "&Fin" 
     SIZE 5.72 BY 1.58.

DEFINE BUTTON b-salir AUTO-END-KEY 
     IMAGE-UP FILE "IMG/exit"
     LABEL "&Salir" 
     SIZE 5.72 BY 1.58.

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "IMG/cias"
     LABEL "" 
     SIZE 5.72 BY 1.58.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "IMG/menus"
     LABEL "" 
     SIZE 5.72 BY 1.58.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "IMG/compila"
     LABEL "&Compilador" 
     SIZE 5.72 BY 1.58.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "IMG/dict%"
     LABEL "" 
     SIZE 5.72 BY 1.58.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90 BY 3.5.

DEFINE {&NEW} SHARED VARIABLE s-nomcia AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 33 BY 1
     BGCOLOR 8 FGCOLOR 12 .

DEFINE {&NEW} SHARED VARIABLE s-user-id AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 19 BY 1
     BGCOLOR 8 FGCOLOR 12 .

DEFINE {&NEW} SHARED VARIABLE XNSer AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     LABEL "No Serie" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 8 FGCOLOR 12 .

DEFINE {&NEW} SHARED VARIABLE XTerm AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     LABEL "Terminal" 
     VIEW-AS FILL-IN 
     SIZE 19 BY 1
     BGCOLOR 8 FGCOLOR 12 .

DEFINE IMAGE IMAGE-2
     FILENAME "IMG/administ"
     SIZE 19 BY 5.69.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 33 BY 1.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 63 BY 8.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 19 BY 1.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 19 BY 1.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 14 BY 1.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.43 BY 11
     BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-botones
     BUTTON-1 AT ROW 1.5 COL 3.29 HELP
          "Registro de Compa¤ias"
     BUTTON-2 AT ROW 1.5 COL 11.29 HELP
          "Registro de los Menus de los Sistemas"
     BUTTON-3 AT ROW 1.5 COL 19.29
     BUTTON-4 AT ROW 1.5 COL 27.29
     b-fin AT ROW 1.5 COL 67.29 HELP
          "Salir a las opciones del WINDOWS"
     b-salir AT ROW 1.5 COL 75.29 HELP
          "Salir a la Opci¢n anterior"
     b-ayuda AT ROW 1.5 COL 83.29 HELP
          "Ayudas sobre el sistema"
     RECT-4 AT ROW 1 COL 1
     "  Compa-" VIEW-AS TEXT
          SIZE 5.72 BY .62 AT ROW 3.15 COL 3
          FONT 12
     "   Menus" VIEW-AS TEXT
          SIZE 5.72 BY .62 AT ROW 3.15 COL 11
          FONT 12
     "Compi-" VIEW-AS TEXT
          SIZE 5 BY .62 AT ROW 3.15 COL 20
          FONT 12
     "Diccio-" VIEW-AS TEXT
          SIZE 5 BY .62 AT ROW 3.15 COL 28
          FONT 12
     "     ¤ias" VIEW-AS TEXT
          SIZE 5.72 BY .62 AT ROW 3.69 COL 3
          FONT 12
     " Finalizar" VIEW-AS TEXT
          SIZE 5.72 BY .62 AT ROW 3.15 COL 67
          FONT 12
     "lador" VIEW-AS TEXT
          SIZE 4 BY .62 AT ROW 3.69 COL 20.57
          FONT 12
     "     Salir" VIEW-AS TEXT
          SIZE 5.72 BY .62 AT ROW 3.15 COL 75
          FONT 12
     "nario" VIEW-AS TEXT
          SIZE 5 BY .62 AT ROW 3.69 COL 28.57
          FONT 12
     "  Ayuda" VIEW-AS TEXT
          SIZE 5.72 BY .62 AT ROW 3.15 COL 83
          FONT 12
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         NO-LABELS SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 3.69
         BGCOLOR 15 FGCOLOR 0 .

DEFINE FRAME F-logo
     s-nomcia AT ROW 3 COL 41 COLON-ALIGNED NO-LABEL
     s-user-id AT ROW 5.5 COL 55 COLON-ALIGNED
     XTerm AT ROW 8 COL 55 COLON-ALIGNED
     XNSer AT ROW 9 COL 26 COLON-ALIGNED
     RECT-5 AT ROW 1 COL 1
     RECT-2 AT ROW 2.5 COL 17
     IMAGE-2 AT ROW 3 COL 21
     RECT-19 AT ROW 3 COL 43
     RECT-20 AT ROW 5.5 COL 57
     RECT-21 AT ROW 8 COL 57
     RECT-22 AT ROW 9 COL 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 4.73
         SIZE 90.43 BY 11.12
         BGCOLOR 8 FGCOLOR 12 .

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-MENUBAR ASSIGN
         HIDDEN             = YES
         TITLE              = "Administrador del Sistema"
         COLUMN             = 1
         ROW                = 1
         HEIGHT             = 14.81
         WIDTH              = 90.43
         MAX-HEIGHT         = 15.69
         MAX-WIDTH          = 90.43
         VIRTUAL-HEIGHT     = 15.69
         VIRTUAL-WIDTH      = 90.43
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = 15
         FGCOLOR            = 0
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-MENUBAR:LOAD-ICON("IMG/valmiesa") THEN
    MESSAGE "Unable to load icon: IMG/valmiesa"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-MENUBAR
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FILL-IN s-nomcia IN FRAME F-logo
   SHARED NO-ENABLE                                                     */
/* SETTINGS FOR FILL-IN s-user-id IN FRAME F-logo
   SHARED NO-ENABLE                                                     */
/* SETTINGS FOR FILL-IN XNSer IN FRAME F-logo
   SHARED NO-ENABLE                                                     */
/* SETTINGS FOR FILL-IN XTerm IN FRAME F-logo
   SHARED NO-ENABLE                                                     */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-MENUBAR)
THEN W-MENUBAR:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-ayuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-ayuda W-MENUBAR
ON CHOOSE OF b-ayuda IN FRAME F-botones /* Ayuda */
DO:
    RUN EJECUTA ("none.p").  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-fin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-fin W-MENUBAR
ON CHOOSE OF b-fin IN FRAME F-botones /* Fin */
DO:
  QUIT.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-salir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-salir W-MENUBAR
ON CHOOSE OF b-salir IN FRAME F-botones /* Salir */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-MENUBAR
ON CHOOSE OF BUTTON-1 IN FRAME F-botones
DO:
    RUN EJECUTA ("adm/admempr.w").  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-MENUBAR
ON CHOOSE OF BUTTON-2 IN FRAME F-botones
DO:
    RUN EJECUTA ("adm/admmenu.w").    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-MENUBAR
ON CHOOSE OF BUTTON-3 IN FRAME F-botones /* Compilador */
DO:
    RUN EJECUTA ("lib/_procomp.w").   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-MENUBAR
ON CHOOSE OF BUTTON-4 IN FRAME F-botones
DO:
    RUN EJECUTA ("dict.r").     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-logo
&Scoped-define SELF-NAME s-nomcia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s-nomcia W-MENUBAR
ON ENTRY OF s-nomcia IN FRAME F-logo
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME s-user-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s-user-id W-MENUBAR
ON ENTRY OF s-user-id IN FRAME F-logo /* Usuario */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME XNSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL XNSer W-MENUBAR
ON ENTRY OF XNSer IN FRAME F-logo /* No Serie */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME XTerm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL XTerm W-MENUBAR
ON ENTRY OF XTerm IN FRAME F-logo /* Terminal */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-botones
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-MENUBAR 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* These events will close the window and terminate the procedure.      */
/* (NOTE: this will override any user-defined triggers previously       */
/*  defined on the window.)                                             */
ON WINDOW-CLOSE OF {&WINDOW-NAME} DO:
  IF mainmenu:SENSITIVE 
  THEN APPLY "CLOSE":U TO THIS-PROCEDURE.
  ELSE BELL.
  RETURN NO-APPLY.
END.
ON ENDKEY, END-ERROR OF {&WINDOW-NAME} ANYWHERE DO:
  IF mainmenu:SENSITIVE 
  THEN APPLY "CLOSE":U TO THIS-PROCEDURE.
  ELSE BELL.
  RETURN NO-APPLY.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* CREACION DEL MENU DE OPCIONES */
CREATE MENU mainmenu.
FOR EACH Menus WHERE Menus.Modulo = s-aplic-id:
    ok = NO.
    IF x-Grupo = " " OR Menus.Grupos = "" THEN ok = yes.
    ELSE DO:
        Grupo:
        DO x = 1 TO NUM-ENTRIES( x-Grupo ):
            IF LOOKUP( ENTRY(x, x-Grupo) , Menus.Grupos ) <> 0
            THEN DO:
                ok = Yes.
                LEAVE Grupo.
            END.
        END.
    END.
    IF oK THEN DO: 
        LenOpc = LENGTH( Menus.CodMnu ).
        xOK    = NO.
        CASE LenOpc:
            WHEN 2 THEN DO:
                UltMnu1 = ?.
                UltMnu2 = ?.
                IF Menus.Tipo = "S"
                THEN DO:
                    CREATE SUB-MENU OpcMnu[ NumOpc ]
                    ASSIGN PARENT = mainmenu
                           LABEL  = Menus.Etiqueta.
                    UltMnu1 = Menus.CodMnu.
                    UltOpc1 = NumOpc.
                    UltMnu2 = ?.
                    xOK     = YES.
                END.
                IF Menus.Tipo = "P" 
                THEN DO:
                    CREATE MENU-ITEM OpcMnu[ NumOpc ]
                    ASSIGN PARENT = mainmenu
                           LABEL  = Menus.Etiqueta
                           PRIVATE-DATA = Menus.Programa
                           TRIGGERS:
                               ON CHOOSE
                                   DO: 
                                       RUN PROCESA.
                                   END.
                           END TRIGGERS. 
                    xOK     = YES.
                END.
            END.       
            WHEN 4 THEN DO:
                IF Menus.Tipo = "S" AND Menus.CodMnu BEGINS UltMnu1
                THEN DO:
                    CREATE SUB-MENU OpcMnu[ NumOpc ]
                    ASSIGN PARENT = OpcMnu[ UltOpc1 ]
                           LABEL  = Menus.Etiqueta.
                    UltMnu2 = Menus.CodMnu.
                    UltOpc2 = NumOpc.
                    xOK     = YES.
                END.
                IF Menus.Tipo = "P" AND Menus.CodMnu BEGINS UltMnu1
                THEN DO:
                    CREATE MENU-ITEM OpcMnu[ NumOpc ]
                    ASSIGN PARENT = OpcMnu[ UltOpc1 ]
                           LABEL  = Menus.Etiqueta
                           PRIVATE-DATA = Menus.Programa
                           TRIGGERS:
                               ON CHOOSE
                                   DO: 
                                       RUN PROCESA.
                                   END.
                           END TRIGGERS. 
                    UltMnu2 = ?.
                    xOK     = YES.
                END.
                IF Menus.Tipo = "R" AND Menus.CodMnu BEGINS UltMnu1
                THEN DO:
                    CREATE MENU-ITEM OpcMnu[ NumOpc ]
                    ASSIGN PARENT = OpcMnu[ UltOpc1 ]
                           SUBTYPE = "RULE".
                    xOK     = YES.     
                END.    
            END.     
            WHEN 6 THEN DO:
                IF Menus.Tipo = "P" AND Menus.CodMnu BEGINS UltMnu2
                THEN DO:
                    CREATE MENU-ITEM OpcMnu[ NumOpc ]
                    ASSIGN PARENT = OpcMnu[ UltOpc2 ]
                           LABEL  = Menus.Etiqueta
                           PRIVATE-DATA = Menus.Programa
                           TRIGGERS:
                               ON CHOOSE
                                   DO: 
                                       RUN PROCESA.
                                   END.
                           END TRIGGERS.
                    xOK     = YES.     
                END.    
                IF Menus.Tipo = "R" AND Menus.CodMnu BEGINS UltMnu2
                THEN DO:
                    CREATE MENU-ITEM OpcMnu[ NumOpc ]
                    ASSIGN PARENT = OpcMnu[ UltOpc2 ]
                           SUBTYPE = "RULE".
                    xOK     = YES.     
                END.    
            END.        
        END CASE.
        IF xOK THEN NumOpc = NumOpc + 1.
    END.
END.

pto = SESSION:SET-WAIT-STATE("").
pto = CURRENT-WINDOW:LOAD-MOUSE-POINTER("ARROW").


IF NumOpc > 1
THEN DO:
    CREATE MENU-ITEM linea
        ASSIGN SUBTYPE = "RULE"
               PARENT  = Opcmnu[1].
    CREATE MENU-ITEM salir
        ASSIGN PARENT = OpcMnu[1]
                LABEL = "&Salir".
    ASSIGN CURRENT-WINDOW:MENUBAR = mainmenu.
    /* Now enable the interface and wait for the exit condition.            */
    /* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
    MAIN-BLOCK:
    DO:
      RUN enable_UI.
      IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CHOOSE OF salir OR CLOSE OF THIS-PROCEDURE.
    END.
END.
ELSE MESSAGE "No tiene Opciones a Ejecutar" VIEW-AS ALERT-BOX ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-MENUBAR _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-MENUBAR)
  THEN DELETE WIDGET W-MENUBAR.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EJECUTA W-MENUBAR 
PROCEDURE EJECUTA :
/* -----------------------------------------------------------
  Purpose: EJECUTA PROGRAMAS    
  Parameters:  PROGRAMA A EJECUTAR
  Notes:       
-------------------------------------------------------------*/
DEFINE INPUT PARAMETER x-prog AS CHARACTER.
pto = SESSION:SET-WAIT-STATE("GENERAL").
DISABLE ALL WITH FRAME F-botones.
mainmenu:SENSITIVE = NO.
DO ON STOP UNDO, LEAVE:
    RUN VALUE( x-prog).
END.
mainmenu:SENSITIVE = YES.
ENABLE ALL WITH FRAME F-botones.
pto = SESSION:SET-WAIT-STATE("").
pto = CURRENT-WINDOW:LOAD-MOUSE-POINTER("ARROW").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-MENUBAR _DEFAULT-ENABLE
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
  ENABLE RECT-4 BUTTON-1 BUTTON-2 BUTTON-3 BUTTON-4 b-fin b-salir b-ayuda 
      WITH FRAME F-botones IN WINDOW W-MENUBAR.
  {&OPEN-BROWSERS-IN-QUERY-F-botones}
  DISPLAY s-nomcia s-user-id XTerm XNSer 
      WITH FRAME F-logo IN WINDOW W-MENUBAR.
  ENABLE RECT-5 RECT-2 IMAGE-2 RECT-19 RECT-20 RECT-21 RECT-22 
      WITH FRAME F-logo IN WINDOW W-MENUBAR.
  {&OPEN-BROWSERS-IN-QUERY-F-logo}
  VIEW W-MENUBAR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESA W-MENUBAR 
PROCEDURE PROCESA :
RUN EJECUTA ( SELF:PRIVATE-DATA ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


