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
DEFINE   NEW  GLOBAL SHARED VARIABLE s-NroMes AS INTEGER FORMAT "99".
DEFINE   NEW  GLOBAL SHARED VARIABLE s-periodo AS INTEGER FORMAT "9999".

DEFINE   NEW  GLOBAL SHARED VARIABLE cb-niveles   AS CHARACTER.

RUN cja/cja0001.w.
IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR") <> 0
THEN RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-botones

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 BUTTON-1 BUTTON-2 BUTTON-3 BUTTON-4 ~
BUTTON-6 BUTTON-7 BUTTON-8 b-fin b-salir b-ayuda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-MENUBAR AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-ayuda 
     IMAGE-UP FILE "IMG/horario"
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
     IMAGE-UP FILE "IMG/caja3"
     LABEL "Btn 1" 
     SIZE 5.72 BY 1.58.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "IMG/climnu3"
     LABEL "Btn 2" 
     SIZE 5.72 BY 1.58.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "IMG/caja2"
     LABEL "Btn 3" 
     SIZE 5.72 BY 1.58.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "IMG/cias"
     LABEL "Btn 4" 
     SIZE 5.72 BY 1.58.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "IMG/calendar"
     LABEL "Btn 6" 
     SIZE 5.72 BY 1.58.

DEFINE BUTTON BUTTON-7 
     IMAGE-UP FILE "IMG/climnu5"
     LABEL "Btn 7" 
     SIZE 5.72 BY 1.58.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "IMG/repti"
     LABEL "Btn 8" 
     SIZE 5.72 BY 1.58.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90 BY 3.5.

DEFINE VARIABLE Nombre-mes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "A¤o" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE s-nomcia AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 231 BY 26
     BGCOLOR 8 FGCOLOR 12 .

DEFINE {&NEW} SHARED VARIABLE s-user-id AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 19 BY 1
     BGCOLOR 8 FGCOLOR 12 .

DEFINE {&NEW} SHARED VARIABLE XNSer AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     LABEL "No Serie" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1
     BGCOLOR 8 FGCOLOR 12 .

DEFINE {&NEW} SHARED VARIABLE XTerm AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     LABEL "Terminal" 
     VIEW-AS FILL-IN 
     SIZE 19 BY 1
     BGCOLOR 8 FGCOLOR 12 .

DEFINE IMAGE IMAGE-2
     FILENAME "IMG/cjabco"
     SIZE 19 BY 5.69.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 12 BY 1.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 7 BY 1.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 63 BY 8.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.43 BY 11
     BGCOLOR 15 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 33 BY 1.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 19 BY 1.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 16 BY 1.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 19 BY 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-botones
     BUTTON-1 AT ROW 1.5 COL 2
     BUTTON-2 AT ROW 1.5 COL 11
     BUTTON-3 AT ROW 1.5 COL 19
     BUTTON-4 AT ROW 1.5 COL 28
     BUTTON-6 AT ROW 1.5 COL 44
     BUTTON-7 AT ROW 1.5 COL 52
     BUTTON-8 AT ROW 1.5 COL 60
     b-fin AT ROW 1.5 COL 67.29 HELP
          "Salir a las opciones del WINDOWS"
     b-salir AT ROW 1.5 COL 75.29 HELP
          "Salir a la Opci¢n anterior"
     b-ayuda AT ROW 1.5 COL 83.29 HELP
          "Ayudas sobre el sistema"
     RECT-4 AT ROW 1 COL 1
     "Caja" VIEW-AS TEXT
          SIZE 6 BY .62 AT ROW 3.15 COL 2
          FONT 12
     "Caja" VIEW-AS TEXT
          SIZE 5 BY .62 AT ROW 3.15 COL 11
          FONT 12
     "Giro" VIEW-AS TEXT
          SIZE 3 BY .62 AT ROW 3.15 COL 20
          FONT 12
     "Empresas" VIEW-AS TEXT
          SIZE 6 BY .62 AT ROW 3.15 COL 28
          FONT 12
     "Rol de" VIEW-AS TEXT
          SIZE 6 BY .62 AT ROW 3.15 COL 44
          FONT 12
     "Ingresos" VIEW-AS TEXT
          SIZE 6 BY .62 AT ROW 3.69 COL 2
          FONT 12
     "Consulta" VIEW-AS TEXT
          SIZE 6 BY .62 AT ROW 3.15 COL 52
          FONT 12
     "Cuentas" VIEW-AS TEXT
          SIZE 5 BY .62 AT ROW 3.15 COL 59.57
          FONT 12
     "Egresos" VIEW-AS TEXT
          SIZE 6 BY .62 AT ROW 3.69 COL 11
          FONT 12
     " Finalizar" VIEW-AS TEXT
          SIZE 5.72 BY .62 AT ROW 3.15 COL 67
          FONT 12
     "Autom tico" VIEW-AS TEXT
          SIZE 5 BY .62 AT ROW 3.69 COL 20
          FONT 12
     "     Salir" VIEW-AS TEXT
          SIZE 5.72 BY .62 AT ROW 3.15 COL 75
          FONT 12
     "Mes" VIEW-AS TEXT
          SIZE 3 BY .62 AT ROW 3.15 COL 85
          FONT 12
     "Pagos" VIEW-AS TEXT
          SIZE 5 BY .62 AT ROW 3.62 COL 44
          FONT 12
     "de Caja" VIEW-AS TEXT
          SIZE 6 BY .62 AT ROW 3.69 COL 52
          FONT 12
     "x pagar" VIEW-AS TEXT
          SIZE 6 BY .62 AT ROW 3.69 COL 60
          FONT 12
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         NO-LABELS SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 3.69
         BGCOLOR 15 FGCOLOR 0 .

DEFINE FRAME F-logo
     s-nomcia AT Y 52 X 280 COLON-ALIGNED NO-LABEL
     Nombre-mes AT ROW 4.5 COL 45 COLON-ALIGNED
     Periodo AT ROW 4.5 COL 66 COLON-ALIGNED
     s-user-id AT ROW 6.5 COL 55 COLON-ALIGNED
     XTerm AT ROW 8.5 COL 55 COLON-ALIGNED
     XNSer AT ROW 9 COL 26 COLON-ALIGNED
     RECT-5 AT ROW 1 COL 1
     RECT-2 AT ROW 2.5 COL 17
     IMAGE-2 AT ROW 3 COL 21
     RECT-6 AT ROW 3 COL 43
     RECT-12 AT ROW 4.5 COL 47
     RECT-13 AT ROW 4.5 COL 68
     RECT-7 AT ROW 6.5 COL 57
     RECT-9 AT ROW 8.5 COL 57
     RECT-8 AT ROW 9 COL 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 4.73
         SIZE 90.43 BY 11.12
         BGCOLOR 8 FGCOLOR 12 .

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-MENUBAR ASSIGN
         HIDDEN             = YES
         TITLE              = "Caja y Bancos"
         COLUMN             = 1.43
         ROW                = 1.12
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
/* SETTINGS FOR FILL-IN Nombre-mes IN FRAME F-logo
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Periodo IN FRAME F-logo
   NO-ENABLE                                                            */
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
   /*    RUN EJECUTA ("none.p"). */
   RUN cbd/cbdmes.w.  
   RUN bin/_mes.p ( s-NroMes, 3, OUTPUT Nombre-Mes).
   DISPLAY Periodo Nombre-mes WITH FRAME F-logo.
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
ON CHOOSE OF BUTTON-1 IN FRAME F-botones /* Btn 1 */
DO:
      RUN EJECUTA ("cja/cjaing.w(010,10)").   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-MENUBAR
ON CHOOSE OF BUTTON-2 IN FRAME F-botones /* Btn 2 */
DO:
      RUN EJECUTA ("cja/cjamove.w(020,10)").   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-MENUBAR
ON CHOOSE OF BUTTON-3 IN FRAME F-botones /* Btn 3 */
DO:
      RUN EJECUTA ("cja/cjagchq.w").     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-MENUBAR
ON CHOOSE OF BUTTON-4 IN FRAME F-botones /* Btn 4 */
DO:
      RUN EJECUTA ("Q-CIAS.W").       
      DISPLAY s-nomcia WITH FRAME F-LOGO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-MENUBAR
ON CHOOSE OF BUTTON-6 IN FRAME F-botones /* Btn 6 */
DO:
      RUN EJECUTA ("cja/cjapago.w").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-MENUBAR
ON CHOOSE OF BUTTON-7 IN FRAME F-botones /* Btn 7 */
DO:
    RUN EJECUTA ("cja/cjaconsu.w").
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-MENUBAR
ON CHOOSE OF BUTTON-8 IN FRAME F-botones /* Btn 8 */
DO:
    RUN EJECUTA ("cja/cjaprove.w").
  
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

Periodo = s-periodo.
RUN bin/_mes.p ( s-NroMes, 3, OUTPUT Nombre-Mes).
DISPLAY Periodo Nombre-mes WITH FRAME F-logo.


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
Def var i as integer.
Def var j as integer.
Def var p as character.

pto = SESSION:SET-WAIT-STATE("GENERAL").
DISABLE ALL WITH FRAME F-botones.
mainmenu:SENSITIVE = NO.
DO ON STOP UNDO, LEAVE:
    i = index(x-prog,"(").
    j = index(x-prog,")").  
    if j - i > 1 then DO:
         j = j - i - 1.
         i = i + 1.
         p = substring(x-prog , i , j ).
         RUN VALUE(x-prog)(p).
    END.
    ELSE RUN VALUE( x-prog).
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
  ENABLE RECT-4 BUTTON-1 BUTTON-2 BUTTON-3 BUTTON-4 BUTTON-6 BUTTON-7 BUTTON-8 
         b-fin b-salir b-ayuda 
      WITH FRAME F-botones IN WINDOW W-MENUBAR.
  {&OPEN-BROWSERS-IN-QUERY-F-botones}
  DISPLAY s-nomcia Nombre-mes Periodo s-user-id XTerm XNSer 
      WITH FRAME F-logo IN WINDOW W-MENUBAR.
  ENABLE RECT-5 RECT-2 IMAGE-2 RECT-6 RECT-12 RECT-13 RECT-7 RECT-9 RECT-8 
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


