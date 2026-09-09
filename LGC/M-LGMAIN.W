&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-MENU
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-MENU 
CREATE WIDGET-POOL.



/* Local Variable Definitions ---                                       */
{bin\s-global.i}

DEFINE NEW  SHARED VARIABLE S-PERIODO  AS INTEGER FORMAT "9999" INIT 1996.
DEFINE NEW  SHARED VARIABLE S-NROMES   AS INTEGER FORMAT "9999" .
DEFINE NEW SHARED VARIABLE  s-CodFam     AS CHAR.
DEFINE NEW SHARED VARIABLE  CB-codcia    AS INTEGER INIT 0.
DEFINE NEW SHARED VARIABLE  PV-codcia    AS INTEGER INIT 0.
DEFINE NEW SHARED VARIABLE  CL-codcia    AS INTEGER INIT 0.
DEFINE NEW SHARED VARIABLE  CB-MaxNivel  AS INTEGER.
DEFINE NEW SHARED VARIABLE  CB-Niveles   AS CHAR.
DEFINE NEW SHARED VARIABLE  xterm as char.

s-periodo = 1996.
FIND EMPRESAS WHERE EMPRESAS.CODCIA  = S-CodCia NO-LOCK NO-ERROR.
IF NOT AVAIL EMPRESAS THEN DO:
   MESSAGE "La empresa " S-CodCia SKIP
           "no se encuentra registrada en " SKIP
           "EMPRESAS" SKIP (2)
           "Se recomienda no hacer ninguna" skip
           "actualizaci¢n Contable"
           VIEW-AS ALERT-BOX WARNING.
END.
ASSIGN 
   CB-CODCIA = 0
   PV-CODCIA = 0
   CL-CODCIA = 0.
   
IF NOT EMPRESAS.CAMPO-CODCBD THEN CB-CODCIA = S-CODCIA.
IF NOT EMPRESAS.CAMPO-CODPRO THEN PV-CODCIA = S-CODCIA.
IF NOT EMPRESAS.CAMPO-CODCLI THEN CL-CODCIA = S-CODCIA.

RUN ADM/CB-NIVEL.P (S-CODCIA ,
                    OUTPUT CB-Niveles ,
                    OUTPUT CB-MaxNivel ).
IF CB-NIVELES = ? OR CB-MAXNIVEL = ? THEN DO:
   MESSAGE "La empresa " S-CodCia SKIP
           "tiene mal configurado el plan de cuentas" SKIP
           "CB-CFGA" SKIP (2)
           "Se recomienda no hacer ninguna" skip
           "actualizaci¢n Contable"
           VIEW-AS ALERT-BOX WARNING.
END.                   


DEFINE VARIABLE No-Tareas    AS INTEGER INITIAL 0  NO-UNDO.
DEFINE VARIABLE WAIT-STATUS  AS LOGICAL        NO-UNDO.
DEFINE VARIABLE proc-act     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE mainmenu     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE salir        AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE linea        AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE OpcMnu       AS WIDGET-HANDLE EXTENT 100 NO-UNDO.
DEFINE VARIABLE NumOpc       AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE NumBtn       AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE LenOpc       AS INTEGER   NO-UNDO.
DEFINE VARIABLE UltMnu1      AS CHARACTER NO-UNDO.
DEFINE VARIABLE UltOpc1      AS INTEGER   NO-UNDO.
DEFINE VARIABLE UltMnu2      AS CHARACTER NO-UNDO.
DEFINE VARIABLE UltOpc2      AS INTEGER   NO-UNDO.
DEFINE VARIABLE fullname     AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-Etiqueta   AS CHARACTER NO-UNDO.
DEFINE VARIABLE i            AS INTEGER   NO-UNDO.
DEFINE VARIABLE xhelp        AS CHARACTER NO-UNDO.
DEFINE VARIABLE xOk          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Ok           AS LOGICAL   NO-UNDO.
DEFINE VARIABLE x            AS INTEGER.


&GLOBAL-DEFINE BOTONES No-Tareas = No-Tareas + 1. ~
SELF:SENSITIVE = NO. ~
RUN EJECUTA ( SELF:PRIVATE-DATA ). ~
SELF:SENSITIVE = YES. ~
No-Tareas = No-Tareas - 1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-MENU

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-6 RECT-7 RECT-8 FILL-PERIODO-1 ~
RECT-9 B-fin1 B-fin2 B-ayuda 
&Scoped-Define DISPLAYED-OBJECTS FILL-NomCia FILL-PERIODO-1 FILL-USUARIO 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-MENU AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-ayuda 
     IMAGE-UP FILE "img/ayuda":U
     LABEL "" 
     SIZE 6 BY 1.5.

DEFINE BUTTON B-fin1 AUTO-END-KEY 
     IMAGE-UP FILE "img/exit":U
     LABEL "" 
     SIZE 6 BY 1.5.

DEFINE BUTTON B-fin2 
     IMAGE-UP FILE "img/fin":U
     LABEL "" 
     SIZE 6 BY 1.5.

DEFINE BUTTON BUTTON-1 
     IMAGE-INSENSITIVE FILE "img/seguro":U
     LABEL "&1" 
     SIZE 6 BY 1.5.

DEFINE BUTTON BUTTON-10 
     IMAGE-INSENSITIVE FILE "img/seguro":U
     LABEL "&A" 
     SIZE 6 BY 1.5.

DEFINE BUTTON BUTTON-11 
     IMAGE-INSENSITIVE FILE "img/seguro":U
     LABEL "&B" 
     SIZE 6 BY 1.5.

DEFINE BUTTON BUTTON-2 
     IMAGE-INSENSITIVE FILE "img/seguro":U
     LABEL "&2" 
     SIZE 6 BY 1.5.

DEFINE BUTTON BUTTON-3 
     IMAGE-INSENSITIVE FILE "img/seguro":U
     LABEL "&3" 
     SIZE 6 BY 1.5.

DEFINE BUTTON BUTTON-4 
     IMAGE-INSENSITIVE FILE "img/seguro":U
     LABEL "&4" 
     SIZE 6 BY 1.5.

DEFINE BUTTON BUTTON-5 
     IMAGE-INSENSITIVE FILE "img/seguro":U
     LABEL "&5" 
     SIZE 6 BY 1.5.

DEFINE BUTTON BUTTON-6 
     IMAGE-INSENSITIVE FILE "img/seguro":U
     LABEL "&6" 
     SIZE 6 BY 1.5.

DEFINE BUTTON BUTTON-7 
     IMAGE-INSENSITIVE FILE "img/seguro":U
     LABEL "&7" 
     SIZE 6 BY 1.5.

DEFINE BUTTON BUTTON-8 
     IMAGE-INSENSITIVE FILE "img/seguro":U
     LABEL "&8" 
     SIZE 6 BY 1.5.

DEFINE BUTTON BUTTON-9 
     IMAGE-INSENSITIVE FILE "img/seguro":U
     LABEL "&9" 
     SIZE 6 BY 1.5.

DEFINE VARIABLE FILL-PERIODO-1 AS DECIMAL FORMAT "9999":U INITIAL ? 
     LABEL "Per¡odo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     SIZE 10.43 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-NomCia AS CHARACTER FORMAT "X(256)":U 
     LABEL "Compa¤ia" 
     VIEW-AS FILL-IN 
     SIZE 55.86 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-USUARIO AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 3 GRAPHIC-EDGE  
     SIZE 90.14 BY 1.85
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90.14 BY 1.42.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 18.14 BY 1.5
     BGCOLOR 1 .

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 33.72 BY 1.5.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38.29 BY 1.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-MENU
     BUTTON-1 AT ROW 1.19 COL 2
     BUTTON-2 AT ROW 1.19 COL 8.29
     FILL-NomCia AT ROW 3.23 COL 7.57 COLON-ALIGNED
     BUTTON-3 AT ROW 1.19 COL 14.57
     BUTTON-4 AT ROW 1.19 COL 20.86
     BUTTON-5 AT ROW 1.19 COL 27.14 HELP
          "Diccionario de Datos"
     BUTTON-6 AT ROW 1.19 COL 33.57
     FILL-PERIODO-1 AT ROW 4.69 COL 31.57 COLON-ALIGNED
     BUTTON-7 AT ROW 1.19 COL 39.86
     BUTTON-8 AT ROW 1.19 COL 46.14
     BUTTON-9 AT ROW 1.19 COL 52.43
     BUTTON-10 AT ROW 1.19 COL 58.72
     BUTTON-11 AT ROW 1.19 COL 65
     B-fin1 AT ROW 1.19 COL 71.29 HELP
          "Regresar"
     FILL-USUARIO AT ROW 3.23 COL 73 COLON-ALIGNED
     B-fin2 AT ROW 1.19 COL 77.57 HELP
          "Salir"
     B-ayuda AT ROW 1.19 COL 83.86 HELP
          "Ayuda"
     RECT-1 AT ROW 1 COL 1
     RECT-6 AT ROW 2.92 COL 1
     RECT-7 AT ROW 4.38 COL 1
     RECT-8 AT ROW 4.38 COL 19.29
     RECT-9 AT ROW 4.38 COL 52.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 5
         BGCOLOR 8 FGCOLOR 0 FONT 4.

 

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
  CREATE WINDOW W-MENU ASSIGN
         HIDDEN             = YES
         TITLE              = "Sistema de Contabilidad"
         COLUMN             = 8.29
         ROW                = 7.38
         HEIGHT             = 5.08
         WIDTH              = 90.14
         MAX-HEIGHT         = 16.77
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 16.77
         VIRTUAL-WIDTH      = 91.43
         RESIZE             = yes
         SCROLL-BARS        = yes
         STATUS-AREA        = yes
         BGCOLOR            = 8
         FGCOLOR            = 0
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-MENU:LOAD-ICON("img/registro":U) THEN
    MESSAGE "Unable to load icon: img/registro"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-MENU
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-MENU
   Default                                                              */
/* SETTINGS FOR BUTTON BUTTON-1 IN FRAME F-MENU
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-1:HIDDEN IN FRAME F-MENU           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-10 IN FRAME F-MENU
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-10:HIDDEN IN FRAME F-MENU           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-11 IN FRAME F-MENU
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-11:HIDDEN IN FRAME F-MENU           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-MENU
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-2:HIDDEN IN FRAME F-MENU           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-3 IN FRAME F-MENU
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-3:HIDDEN IN FRAME F-MENU           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-4 IN FRAME F-MENU
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-4:HIDDEN IN FRAME F-MENU           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-5 IN FRAME F-MENU
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-5:HIDDEN IN FRAME F-MENU           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-6 IN FRAME F-MENU
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-6:HIDDEN IN FRAME F-MENU           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-7 IN FRAME F-MENU
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-7:HIDDEN IN FRAME F-MENU           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-8 IN FRAME F-MENU
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-8:HIDDEN IN FRAME F-MENU           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-9 IN FRAME F-MENU
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-9:HIDDEN IN FRAME F-MENU           = TRUE.

/* SETTINGS FOR FILL-IN FILL-NomCia IN FRAME F-MENU
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-USUARIO IN FRAME F-MENU
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-MENU)
THEN W-MENU:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-MENU
/* Query rebuild information for FRAME F-MENU
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-MENU */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-fin2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-fin2 W-MENU
ON CHOOSE OF B-fin2 IN FRAME F-MENU
DO:
    QUIT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-MENU
ON CHOOSE OF BUTTON-1 IN FRAME F-MENU /* 1 */
DO:
  {&BOTONES}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 W-MENU
ON CHOOSE OF BUTTON-10 IN FRAME F-MENU /* A */
DO:
    {&BOTONES}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 W-MENU
ON CHOOSE OF BUTTON-11 IN FRAME F-MENU /* B */
DO:
    {&BOTONES}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-MENU
ON CHOOSE OF BUTTON-2 IN FRAME F-MENU /* 2 */
DO:
    {&BOTONES}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-MENU
ON CHOOSE OF BUTTON-3 IN FRAME F-MENU /* 3 */
DO:
    {&BOTONES}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-MENU
ON CHOOSE OF BUTTON-4 IN FRAME F-MENU /* 4 */
DO:
    {&BOTONES}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-MENU
ON CHOOSE OF BUTTON-5 IN FRAME F-MENU /* 5 */
DO:
    {&BOTONES}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-MENU
ON CHOOSE OF BUTTON-6 IN FRAME F-MENU /* 6 */
DO:
    {&BOTONES}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-MENU
ON CHOOSE OF BUTTON-7 IN FRAME F-MENU /* 7 */
DO:
    {&BOTONES}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-MENU
ON CHOOSE OF BUTTON-8 IN FRAME F-MENU /* 8 */
DO:
    {&BOTONES}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 W-MENU
ON CHOOSE OF BUTTON-9 IN FRAME F-MENU /* 9 */
DO:
    {&BOTONES}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-PERIODO-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-PERIODO-1 W-MENU
ON VALUE-CHANGED OF FILL-PERIODO-1 IN FRAME F-MENU /* Per¡odo */
DO:
   DEF VAR OLD-PERIODO AS INTEGER INIT 0.
   
   OLD-PERIODO = FILL-PERIODO-1.
   
   ASSIGN S-PERIODO      = INPUT FILL-PERIODO-1.
  
     
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-MENU 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.
Ok = FRAME F-MENU:LOAD-MOUSE-POINTER("GLOVE").

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   DO:
      IF No-Tareas = 0
      THEN RUN disable_UI.
      ELSE DO:
        MESSAGE "Existen procedimiento activos" SKIP
               "No se puede salir aun del sistema" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
      END.
   END.

/* These events will close the window and terminate the procedure.      */
/* (NOTE: this will override any user-defined triggers previously       */
/*  defined on the window.)                                             */
ON WINDOW-CLOSE OF {&WINDOW-NAME} 
  APPLY "CLOSE":U TO THIS-PROCEDURE.

ON ENDKEY, END-ERROR OF {&WINDOW-NAME} ANYWHERE 
  APPLY "CLOSE":U TO THIS-PROCEDURE.
 
/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.
/*  Creando las opciones de men£ */
    CREATE MENU mainmenu.
    FOR EACH integral.PF-G002 WHERE integral.PF-G002.Aplic-Id = s-aplic-id:
        ok = NO.
        IF s-seguridad = " " OR integral.PF-G002.Seguridad = ""  THEN Ok = YES.
        ELSE DO:
            LAZO-1:
            DO x = 1 TO NUM-ENTRIES( s-seguridad ):
                IF LOOKUP( ENTRY(x, s-seguridad) , integral.PF-G002.seguridad ) <> 0
                THEN DO:
                    ok = Yes.
                    LEAVE LAZO-1.
                END.
            END.
        END.
        IF oK THEN DO: 
            LenOpc = LENGTH( integral.PF-G002.CodMnu ).
            xOK    = NO.
            CASE LenOpc:
                WHEN 2 THEN DO:
                    UltMnu1 = ?.
                    UltMnu2 = ?.
                    IF integral.PF-G002.Tipo = "SUB-MENU"
                    THEN DO:
                        CREATE SUB-MENU OpcMnu[ NumOpc ]
                        ASSIGN PARENT = mainmenu
                               LABEL  = integral.PF-G002.Etiqueta.
                        UltMnu1 = integral.PF-G002.CodMnu.
                        UltOpc1 = NumOpc.
                        UltMnu2 = ?.
                        xOK     = YES.
                    END.
                    IF integral.PF-G002.Tipo = "PROCESO" 
                    THEN DO:
                        CREATE MENU-ITEM OpcMnu[ NumOpc ]
                        ASSIGN PARENT = mainmenu
                               LABEL  = integral.PF-G002.Etiqueta
                               PRIVATE-DATA = integral.PF-G002.Programa
                               TRIGGERS:
                                   ON CHOOSE
                                       DO: 
                                           No-Tareas = No-Tareas + 1.
                                           SELF:SENSITIVE = NO.
                                           RUN EJECUTA ( SELF:PRIVATE-DATA ).
                                           SELF:SENSITIVE = YES.
                                           No-Tareas = No-Tareas - 1.
                                       END.
                               END TRIGGERS. 
                        xOK     = YES.
                    END.
                END.       
                WHEN 4 THEN DO:
                    IF integral.PF-G002.Tipo = "SUB-MENU" AND
                       integral.PF-G002.CodMnu BEGINS UltMnu1
                    THEN DO:
                        CREATE SUB-MENU OpcMnu[ NumOpc ]
                        ASSIGN PARENT = OpcMnu[ UltOpc1 ]
                               LABEL  = integral.PF-G002.Etiqueta.
                        UltMnu2 = integral.PF-G002.CodMnu.
                        UltOpc2 = NumOpc.
                        xOK     = YES.
                    END.
                    IF integral.PF-G002.Tipo = "PROCESO" AND
                       integral.PF-G002.CodMnu BEGINS UltMnu1
                    THEN DO:
                        CREATE MENU-ITEM OpcMnu[ NumOpc ]
                        ASSIGN PARENT = OpcMnu[ UltOpc1 ]
                               LABEL  = integral.PF-G002.Etiqueta
                               PRIVATE-DATA = integral.PF-G002.Programa
                                   TRIGGERS:
                                       ON CHOOSE
                                           DO: 
                                               No-Tareas = No-Tareas + 1.
                                               SELF:SENSITIVE = NO.
                                               RUN EJECUTA ( SELF:PRIVATE-DATA ).
                                               SELF:SENSITIVE = YES.
                                               No-Tareas = No-Tareas - 1.
                                           END.
                                   END TRIGGERS. 
                            UltMnu2 = ?.
                            xOK     = YES.
                        END.
                        IF integral.PF-G002.Tipo = "LINEA" AND 
                           integral.PF-G002.CodMnu BEGINS UltMnu1
                        THEN DO:
                            CREATE MENU-ITEM OpcMnu[ NumOpc ]
                            ASSIGN PARENT = OpcMnu[ UltOpc1 ]
                                   SUBTYPE = "RULE".
                            xOK     = YES.     
                    END.    
                END.     
                WHEN 6 THEN DO:
                    IF integral.PF-G002.Tipo = "PROCESO" AND
                       integral.PF-G002.CodMnu BEGINS UltMnu2
                    THEN DO:
                        CREATE MENU-ITEM OpcMnu[ NumOpc ]
                        ASSIGN PARENT = OpcMnu[ UltOpc2 ]
                               LABEL  = integral.PF-G002.Etiqueta
                               PRIVATE-DATA = integral.PF-G002.Programa
                               TRIGGERS:
                                   ON CHOOSE
                                       DO: 
                                           No-Tareas = No-Tareas + 1.
                                           SELF:SENSITIVE = NO.
                                           RUN EJECUTA ( SELF:PRIVATE-DATA ).
                                           SELF:SENSITIVE = YES.
                                           No-Tareas = No-Tareas - 1.
                                       END.
                               END TRIGGERS.
                        xOK     = YES.     
                    END.    
                    IF integral.PF-G002.Tipo = "LINEA" AND
                       integral.PF-G002.CodMnu BEGINS UltMnu2
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

WAIT-STATUS = SESSION:SET-WAIT-STATE("").
WAIT-STATUS = CURRENT-WINDOW:LOAD-MOUSE-POINTER("ARROW").

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
IF NumOpc > 1
THEN DO:
    CREATE MENU-ITEM linea
        ASSIGN SUBTYPE = "RULE"
               PARENT  = Opcmnu[1].
    CREATE MENU-ITEM salir
        ASSIGN PARENT = OpcMnu[1]
                LABEL = "&Salir".
    RUN Botones.
    FIND integral.PF-G003 WHERE integral.PF-G003.Aplic-Id = s-aplic-id
        no-lock.
        
     ASSIGN CURRENT-WINDOW:MENUBAR = mainmenu
            CURRENT-WINDOW:TITLE   = integral.PF-G003.Detalle.
     
     RUN Captura.
            
    /* Now enable the interface and wait for the exit condition.            */
    /* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
    MAIN-BLOCK:
    DO:
      RUN enable_UI.
      IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CHOOSE OF salir  OR CLOSE OF THIS-PROCEDURE.
    END.
END.
ELSE MESSAGE "No tiene Opciones a Ejecutar" VIEW-AS ALERT-BOX ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Botones W-MENU 
PROCEDURE Botones :
/*------------------------------------------------------------------------------
  Purpose: Activa los botones que requieren acceso directo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Botones asociados por usuario */
    NumBtn = 1.
    FOR EACH integral.PF-G002 
        WHERE integral.PF-G002.Aplic-Id = s-aplic-id AND
              integral.PF-G002.Acceso-directo        AND
              integral.PF-G002.Tipo = "PROCESO":
        ok = NO.
        IF s-seguridad = " " OR integral.PF-G002.Seguridad = ""  THEN Ok = YES.
        ELSE DO:
            LAZO-2:
            DO x = 1 TO NUM-ENTRIES( s-seguridad ):
                IF LOOKUP( ENTRY(x, s-seguridad) , integral.PF-G002.seguridad ) <> 0
                THEN DO:
                    ok = Yes.
                    LEAVE LAZO-2.
                END.
            END.
        END.
        x-Etiqueta = "".
        DO i = 1 TO LENGTH( integral.PF-G002.Etiqueta ):
            IF SUBSTR( integral.PF-G002.Etiqueta, I, 1) <> "&"
            THEN x-Etiqueta = x-Etiqueta + SUBSTR( integral.PF-G002.Etiqueta, I, 1).
        END.
        IF oK THEN DO: 
            CASE NumBtn:
            WHEN 1 THEN ASSIGN BUTTON-1:PRIVATE-DATA IN FRAME {&FRAME-NAME} = 
                                    integral.PF-G002.Programa
                               BUTTON-1:HIDDEN IN FRAME {&FRAME-NAME} = NO
                               BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                               BUTTON-1:HELP IN FRAME {&FRAME-NAME} = x-Etiqueta
                               WAIT-STATUS = 
                               BUTTON-1:LOAD-IMAGE-UP(integral.PF-G002.Icon).
            WHEN 2 THEN ASSIGN BUTTON-2:PRIVATE-DATA IN FRAME {&FRAME-NAME} = 
                                    integral.PF-G002.Programa
                               BUTTON-2:HIDDEN IN FRAME {&FRAME-NAME} = NO
                               BUTTON-2:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                               BUTTON-2:HELP IN FRAME {&FRAME-NAME} = x-Etiqueta
                               WAIT-STATUS = 
                               BUTTON-2:LOAD-IMAGE-UP(integral.PF-G002.Icon).
            WHEN 3 THEN ASSIGN BUTTON-3:PRIVATE-DATA IN FRAME {&FRAME-NAME} = 
                                    integral.PF-G002.Programa
                               BUTTON-3:HIDDEN IN FRAME {&FRAME-NAME} = NO
                               BUTTON-3:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                               BUTTON-3:HELP IN FRAME {&FRAME-NAME} = x-Etiqueta
                               WAIT-STATUS = 
                               BUTTON-3:LOAD-IMAGE-UP(integral.PF-G002.Icon).
            WHEN 4 THEN ASSIGN BUTTON-4:PRIVATE-DATA IN FRAME {&FRAME-NAME} = 
                                    integral.PF-G002.Programa
                               BUTTON-4:HIDDEN IN FRAME {&FRAME-NAME} = NO
                               BUTTON-4:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                               BUTTON-4:HELP IN FRAME {&FRAME-NAME} = x-Etiqueta
                               WAIT-STATUS = 
                               BUTTON-4:LOAD-IMAGE-UP(integral.PF-G002.Icon).
            WHEN 5 THEN ASSIGN BUTTON-5:PRIVATE-DATA IN FRAME {&FRAME-NAME} = 
                                    integral.PF-G002.Programa
                               BUTTON-5:HIDDEN IN FRAME {&FRAME-NAME} = NO
                               BUTTON-5:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                               BUTTON-5:HELP IN FRAME {&FRAME-NAME} = x-Etiqueta
                               WAIT-STATUS = 
                               BUTTON-5:LOAD-IMAGE-UP(integral.PF-G002.Icon).
            WHEN 6 THEN ASSIGN BUTTON-6:PRIVATE-DATA IN FRAME {&FRAME-NAME} = 
                                    integral.PF-G002.Programa
                               BUTTON-6:HIDDEN IN FRAME {&FRAME-NAME} = NO
                               BUTTON-6:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                               BUTTON-6:HELP IN FRAME {&FRAME-NAME} = x-Etiqueta
                               WAIT-STATUS = 
                               BUTTON-6:LOAD-IMAGE-UP(integral.PF-G002.Icon).
            WHEN 7 THEN ASSIGN BUTTON-7:PRIVATE-DATA IN FRAME {&FRAME-NAME} = 
                                    integral.PF-G002.Programa
                               BUTTON-7:HIDDEN IN FRAME {&FRAME-NAME} = NO
                               BUTTON-7:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                               BUTTON-7:HELP IN FRAME {&FRAME-NAME} = x-Etiqueta
                               WAIT-STATUS = 
                               BUTTON-7:LOAD-IMAGE-UP(integral.PF-G002.Icon).
            WHEN 8 THEN ASSIGN BUTTON-8:PRIVATE-DATA IN FRAME {&FRAME-NAME} = 
                                    integral.PF-G002.Programa
                               BUTTON-8:HIDDEN IN FRAME {&FRAME-NAME} = NO
                               BUTTON-8:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                               BUTTON-8:HELP IN FRAME {&FRAME-NAME} = x-Etiqueta
                               WAIT-STATUS = 
                               BUTTON-8:LOAD-IMAGE-UP(integral.PF-G002.Icon).
            WHEN 9 THEN ASSIGN BUTTON-9:PRIVATE-DATA IN FRAME {&FRAME-NAME} = 
                                    integral.PF-G002.Programa
                               BUTTON-9:HIDDEN IN FRAME {&FRAME-NAME} = NO
                               BUTTON-9:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                               BUTTON-9:HELP IN FRAME {&FRAME-NAME} = x-Etiqueta
                               WAIT-STATUS = 
                               BUTTON-9:LOAD-IMAGE-UP(integral.PF-G002.Icon).
           WHEN 10 THEN ASSIGN BUTTON-10:PRIVATE-DATA IN FRAME {&FRAME-NAME} = 
                                    integral.PF-G002.Programa
                               BUTTON-10:HIDDEN IN FRAME {&FRAME-NAME} = NO
                               BUTTON-10:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                               BUTTON-10:HELP IN FRAME {&FRAME-NAME} = x-Etiqueta
                               WAIT-STATUS = 
                               BUTTON-10:LOAD-IMAGE-UP(integral.PF-G002.Icon).
           WHEN 11 THEN ASSIGN BUTTON-11:PRIVATE-DATA IN FRAME {&FRAME-NAME} = 
                                    integral.PF-G002.Programa
                               BUTTON-11:HIDDEN IN FRAME {&FRAME-NAME} = NO
                               BUTTON-11:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                               BUTTON-11:HELP IN FRAME {&FRAME-NAME} = x-Etiqueta
                               WAIT-STATUS = 
                               BUTTON-11:LOAD-IMAGE-UP(integral.PF-G002.Icon).
            END CASE.
            NumBtn = NumBtn + 1.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE captura W-MENU 
PROCEDURE captura :
DEF VAR P-LIST AS CHAR.
P-LIST = "".
FILL-PERIODO-1 = ?.

FOR EACH  CB-PERI NO-LOCK 
                  WHERE CB-PERI.CODCIA   = S-CODCIA AND
                        CB-PERI.PERIODO <> 0
          BREAK BY CB-PERI.PERIODO :
   P-LIST = P-LIST + STRING(CB-PERI.PERIODO, "9999" ) + ",".       
   IF LAST-OF (CB-PERI.PERIODO ) THEN  DO:
       FILL-PERIODO-1 = CB-PERI.PERIODO.      
   END.    
END.          
IF FILL-PERIODO-1 = ? THEN DO:
   MESSAGE "No existen periodos asignados para " skip
            "la empresa" s-codcia
            VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.         
END.
P-LIST = SUBSTRING ( P-LIST , 1, LENGTH(P-LIST) - 1 ).
DO WITH FRAME {&FRAME-NAME} :
   FILL-PERIODO-1:LIST-ITEMS = P-LIST.
   FILL-PERIODO-1:SCREEN-VALUE = ENTRY(1 , P-LIST).
END.

FILL-NomCia  = s-NomCia.
S-Periodo    = FILL-PERIODO-1.
FILL-Usuario = S-User-Id.                      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-MENU _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-MENU)
  THEN DELETE WIDGET W-MENU.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ejecuta W-MENU 
PROCEDURE Ejecuta :
DEFINE INPUT PARAMETER x-prog AS CHARACTER.
Def var i as integer.
Def var j as integer.
Def var p as character.

    WAIT-STATUS = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
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
    WAIT-STATUS = SESSION:SET-WAIT-STATE("").
    WAIT-STATUS = CURRENT-WINDOW:LOAD-MOUSE-POINTER("ARROW").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-MENU _DEFAULT-ENABLE
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
  DISPLAY FILL-NomCia FILL-PERIODO-1 FILL-USUARIO 
      WITH FRAME F-MENU IN WINDOW W-MENU.
  ENABLE RECT-1 RECT-6 RECT-7 RECT-8 FILL-PERIODO-1 RECT-9 B-fin1 B-fin2 
         B-ayuda 
      WITH FRAME F-MENU IN WINDOW W-MENU.
  {&OPEN-BROWSERS-IN-QUERY-F-MENU}
  VIEW W-MENU.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


