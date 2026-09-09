&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME mainmenu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS mainmenu 
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
{BIN/S-GLOBAL.I}

DEFINE SHARED VARIABLE S-CodTer LIKE ccbcterm.codter.
DEFINE SHARED VARIABLE S-CodDiv LIKE gn-divi.coddiv.

DEFINE NEW SHARED VARIABLE S-CodAlm AS CHAR.
DEFINE NEW SHARED VARIABLE S-DesAlm AS CHAR.

FIND FIRST FacUsers WHERE FacUsers.CodCia = S-CODCIA 
                     AND  FacUsers.Usuario = S-USER-ID 
                    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacUsers THEN DO:
   MESSAGE "Usuario no esta registrado en la tabla Usuarios" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
IF FacUsers.CodDiv = "" OR FacUsers.CodAlm = "" THEN DO:
   MESSAGE "Falta definir parametros de Usuarios" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.

ASSIGN 
    S-CodAlm = FacUsers.CodAlm 
    S-DesAlm = FacUsers.CodAlm.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartMenu
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-4 
&Scoped-Define DISPLAYED-OBJECTS X-CodDiv F-PtoVta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR mainmenu AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-PtoVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .81 NO-UNDO.

DEFINE VARIABLE X-CodDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 13    
     SIZE 41 BY 1.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 8    
     SIZE 18.29 BY 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     X-CodDiv AT ROW 1.19 COL 52.86 COLON-ALIGNED NO-LABEL
     F-PtoVta AT ROW 1.27 COL 13.57 COLON-ALIGNED NO-LABEL
     "Division :" VIEW-AS TEXT
          SIZE 7.57 BY .81 AT ROW 1.19 COL 47.43
     "Terminal en uso:" VIEW-AS TEXT
          SIZE 12 BY .81 AT ROW 1.19 COL 3
     RECT-2 AT ROW 1.12 COL 2
     RECT-4 AT ROW 1.12 COL 46.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 84.29 BY 1.19
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartMenu
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW mainmenu ASSIGN
         HIDDEN             = YES
         TITLE              = "Caja Cobranza"
         HEIGHT             = 1.23
         WIDTH              = 84.29
         MAX-HEIGHT         = 2.19
         MAX-WIDTH          = 84.29
         VIRTUAL-HEIGHT     = 2.19
         VIRTUAL-WIDTH      = 84.29
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
IF NOT mainmenu:LOAD-ICON("img\api-cz":U) THEN
    MESSAGE "Unable to load icon: img\api-cz"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB mainmenu 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW mainmenu
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN F-PtoVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN X-CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(mainmenu)
THEN mainmenu:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME mainmenu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mainmenu mainmenu
ON END-ERROR OF mainmenu /* Caja Cobranza */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
    /* This case occurs when the user presses the "Esc" key.
       In a persistently run window, just ignore this.  If we did not, the
       application would exit. */
    IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mainmenu mainmenu
ON WINDOW-CLOSE OF mainmenu /* Caja Cobranza */
DO:
    /* This ADM code must be left here in order for the SmartWindow
       and its descendents to terminate properly on exit. */
    RUN SALIR.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Main
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Main mainmenu
ON END-ERROR OF FRAME F-Main
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK mainmenu 


/* ***************************  Main Block  *************************** */
/* Include custom  Main Block code for SmartWindows. */

/* ***************************  Definitions  ************************** */
DEFINE VARIABLE x-handle    AS WIDGET-HANDLE            NO-UNDO.
DEFINE VARIABLE hStatus     AS WIDGET-HANDLE            NO-UNDO.
DEFINE VARIABLE BStatus     AS CHARACTER                NO-UNDO.
DEFINE VARIABLE localmenu   AS WIDGET-HANDLE            NO-UNDO.
DEFINE variable h-boton     AS WIDGET-HANDLE EXTENT 16.
DEFINE VARIABLE OpcMnu      AS WIDGET-HANDLE EXTENT 300 NO-UNDO.
DEFINE VARIABLE NumBtn      AS INTEGER INITIAL 0        NO-UNDO.
DEFINE VARIABLE NumOpc      AS INTEGER INITIAL 1        NO-UNDO.
DEFINE VARIABLE LenOpc      AS INTEGER                  NO-UNDO.
DEFINE VARIABLE wait-status AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE Ok          AS LOGICAL                  NO-UNDO.

DEFINE VARIABLE H-parent    AS WIDGET-HANDLE EXTENT 4.
DEFINE VARIABLE H-label     AS CHARACTER     EXTENT 4.
DEFINE VARIABLE Nivel-Act   AS INTEGER                  NO-UNDO.
DEFINE VARIABLE Nivel-Ant   AS INTEGER                  NO-UNDO.
DEFINE VARIABLE P-1         AS INTEGER.
DEFINE VARIABLE P-2         AS INTEGER.

ASSIGN
    P-1 = 1
    P-2 = 2.

DEFINE VARIABLE i           AS INTEGER NO-UNDO.
DEFINE VARIABLE s-Col-Boton AS DECIMAL NO-UNDO.

&GLOBAL-DEFINE Ancho-Boton 6
&GLOBAL-DEFINE Alto-Boton  1.5

DEFINE RECTANGLE RECT-MENU
    EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL 
    SIZE 20 BY 1.7.

DEFINE FRAME F-MENU
    RECT-MENU AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
        SIDE-LABELS NO-UNDERLINE THREE-D 
        SCROLLABLE
        FONT 4
        AT COL 1 ROW 1.

DEFINE TEMP-TABLE D-MENU NO-UNDO
    FIELD   hOpcion    AS WIDGET-HANDLE
    FIELD   hEquivale  AS WIDGET-HANDLE
    FIELD   hPrograma  AS WIDGET-HANDLE.

/* *************************  Create Window  ************************** */

/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 1.86
         WIDTH              = 40.72.
*/
/* ***************************  Main Block  *************************** */
IF VALID-HANDLE({&WINDOW-NAME}) 
THEN DO:
    ASSIGN
        CURRENT-WINDOW                    = {&WINDOW-NAME} 
        {&WINDOW-NAME}:KEEP-FRAME-Z-ORDER = YES
        THIS-PROCEDURE:CURRENT-WINDOW     = {&WINDOW-NAME}.

    ON CLOSE OF THIS-PROCEDURE 
    DO:
        RUN dispatch IN THIS-PROCEDURE ('destroy':U).
    END.

    RUN dispatch ('create-objects':U).
    &IF DEFINED(UIB_IS_RUNNING) EQ 0 &THEN
        IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
    &ENDIF

    /* Now enable the interface and wait for the exit condition.            */
    FIND PF-G003 WHERE PF-G003.aplic-id = s-aplic-id NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PF-G003 THEN DO:
        BELL.
        MESSAGE "Aplicación " s-aplic-id " no registrada"
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    ASSIGN {&WINDOW-NAME}:TITLE = PF-G003.detalle.

    ASSIGN
        FRAME F-MENU:WIDTH          = {&WINDOW-NAME}:WIDTH
        FRAME F-MENU:HEIGHT         = {&Alto-Boton} + .38 
        FRAME F-MENU:VIRTUAL-HEIGHT = FRAME F-MENU:HEIGHT
        RECT-MENU:WIDTH             = FRAME F-MENU:WIDTH 
        RECT-MENU:HEIGHT            = FRAME F-MENU:HEIGHT.
   
    ASSIGN    
        {&WINDOW-NAME}:HEIGHT   = {&WINDOW-NAME}:HEIGHT + FRAME F-MENU:HEIGHT + 1.1 
        FRAME {&FRAME-NAME}:ROW = 1 + FRAME F-MENU:HEIGHT.

    ASSIGN
        {&WINDOW-NAME}:VIRTUAL-HEIGHT = {&WINDOW-NAME}:HEIGHT
        {&WINDOW-NAME}:VIRTUAL-WIDTH  = {&WINDOW-NAME}:WIDTH.

    Wait-Status = {&WINDOW-NAME}:LOAD-MOUSE-POINTER("GLOVE").

    CREATE MENU localmenu.
    ASSIGN
        H-parent[1] = localmenu
        H-Label[1]  = "".

    FOR EACH PF-G002 NO-LOCK WHERE PF-G002.aplic-id = s-aplic-id BY PF-G002.CodMnu:
        LenOpc     = LENGTH( PF-G002.CodMnu ).
        Nivel-Ant  = ( LenOpc / 2 ) - 1.
        Nivel-Act  = Nivel-Ant + 1.
        OK = SUBSTR( PF-G002.CodMnu, 1, Nivel-Ant * 2 ) = H-label[ Nivel-Act ]
                AND H-parent[ Nivel-Act ] <> ?.
        /* VERIFICAMOS SU NIVEL DE SEGURIDAD */
        IF PF-G002.Seguridad-Grupos <> "" THEN
        Seguridad:
        DO:
            DO i = 1 TO NUM-ENTRIES( s-seguridad ):
                IF CAN-DO( PF-G002.Seguridad-Grupos, ENTRY( i, s-seguridad ))
                THEN LEAVE Seguridad.
            END.
            OK = NO.
        END.
        
        IF S-USER-ID = "ADMIN" THEN OK = YES.

        IF NOT OK THEN NEXT.

        CASE PF-G002.Tipo:
            WHEN "SUB-MENU" THEN 
                CREATE SUB-MENU OpcMnu[ NumOpc ]
                    ASSIGN PARENT = H-parent[ Nivel-Act ]
                           LABEL  = PF-G002.Etiqueta.
                           
            WHEN "PROCESO" THEN DO: 
                CREATE MENU-ITEM OpcMnu[ NumOpc ]
                     ASSIGN PARENT       = H-parent[ Nivel-Act ]
                            LABEL        = PF-G002.Etiqueta
                            PRIVATE-DATA = PF-G002.Programa
                            ACCELERATOR  = PF-G002.TECLA-ACELERADORA 
                            NAME         = STRING(PF-G002.PERSISTENTE)
                            TRIGGERS:
                                ON CHOOSE
                                DO: 
                                    RUN PROCESA( SELF:PRIVATE-DATA, SELF:NAME ).
                                END.
                            END TRIGGERS. 
                            
                IF PF-G002.Acceso-Directo AND NumBtn < 14 
                THEN DO:
                    NumBtn = NumBtn + 1.
                    CREATE BUTTON H-Boton[ NumBtn ]
                    ASSIGN ROW          = 1.19
                           WIDTH        = {&Ancho-Boton}
                           HEIGHT       = {&Alto-Boton}
                           COL          = 1 + ( NumBtn - 1 ) * {&Ancho-Boton} + .8
                           FRAME        = FRAME F-MENU:HANDLE
                           SENSITIVE    = YES
                           VISIBLE      = YES
                           LABEL        = PF-G002.Etiqueta
                           PRIVATE-DATA = PF-G002.Programa
                           NAME         = STRING(PF-G002.PERSISTENTE)
                           TRIGGERS:
                                ON "HELP":U
                                DO:
                                    RUN AYUDA( SELF:PRIVATE-DATA, SELF:LABEL ).
                                END.
                                ON CHOOSE 
                                DO: 
                                    RUN PROCESA( SELF:PRIVATE-DATA,  SELF:NAME ).
                                END.
                            END TRIGGERS. 
                    OK = H-Boton[ NumBtn ]:LOAD-IMAGE-UP(PF-G002.Icon).
                    OK = H-Boton[ NumBtn ]:LOAD-IMAGE-INSENSITIVE("img/seguro.ico").
                    CREATE D-MENU.
                    ASSIGN hOpcion   = H-Boton[ NumBtn ]
                           hEquivale = OpcMnu[ NumOpc ]
                           hPrograma = ?.
                    CREATE D-MENU.
                    ASSIGN hOpcion   = OpcMnu[ NumOpc ]
                           hEquivale = H-Boton[ NumBtn ]
                           hPrograma = ?.
                END.
            END.
       
            WHEN "LINEA" THEN 
                IF Nivel-act > 1
                THEN CREATE MENU-ITEM OpcMnu[ NumOpc ]
                         ASSIGN PARENT  = H-parent[ Nivel-Act ]
                                SUBTYPE = "RULE".
            WHEN "SEPARADOR" THEN
                IF Nivel-act > 1
                THEN CREATE MENU-ITEM OpcMnu[ NumOpc ]
                         ASSIGN PARENT  = H-parent[ Nivel-Act ]
                                SUBTYPE = "SKIP".
            WHEN "CAJA-MARCADOR" THEN
                IF Nivel-act > 1
                THEN CREATE MENU-ITEM OpcMnu[ NumOpc ]
                         ASSIGN PARENT     = H-parent[ Nivel-Act ]
                                LABEL      = PF-G002.Etiqueta
                                TOGGLE-BOX = YES.
            END CASE.

         ASSIGN H-parent[ Nivel-Act + 1 ] = OpcMnu[ NumOpc ]
                H-label[ Nivel-Act + 1  ] = PF-G002.CodMnu
                NumOpc = NumOpc + 1.
    END.

    /* Agregando Opciones adicionales */
    If NumOpc = 1
    THEN DO:
        CREATE SUB-MENU OpcMnu[ NumOpc ]
                 ASSIGN PARENT = H-parent[ 1 ]
                        LABEL  = "&Archivo".
        NumOpc = NumOpc + 1.
    END.

    /* Asignando Opciones de Salida */
    CREATE MENU-ITEM OpcMnu[ NumOpc ]
         ASSIGN PARENT  = OpcMnu[ 1 ]
                SUBTYPE = "RULE".
           
    /* Salida a Menú de Aplicaciones */

    /* Averigunado la posicion del boton de salir */
    s-Col-Boton = 1 + FRAME F-MENU:WIDTH - {&Ancho-Boton} * 3 - .8.
    IF s-Col-Boton < ( NumBtn * {&Ancho-Boton} + 1 )
    THEN s-Col-Boton = NumBtn * {&Ancho-Boton} + 1.
    ELSE FRAME F-MENU:VIRTUAL-WIDTH = FRAME F-MENU:WIDTH.
    NumBtn = 14.
    CREATE BUTTON H-Boton[ NumBtn ]
     ASSIGN ROW          = 1.19
            WIDTH        = {&Ancho-Boton}
            HEIGHT       = {&Alto-Boton}
            COL          = s-Col-Boton 
            FRAME        = FRAME F-MENU:HANDLE
            SENSITIVE    = YES
            VISIBLE      = YES
            LABEL        = "Salir de la &Aplicación"
            PRIVATE-DATA = ""
            TRIGGERS:
                ON "HELP":U
                DO:
                    RUN AYUDA( SELF:PRIVATE-DATA, SELF:LABEL ).
                END.
                ON CHOOSE 
                DO: 
                    RUN SALIR.
                END.
            END TRIGGERS. 
    OK = H-Boton[ NumBtn ]:LOAD-IMAGE-UP("img/exit.ico").
    s-Col-Boton = s-Col-Boton + {&Ancho-Boton}.
    NumBtn = NumBtn + 1.

    CREATE MENU-ITEM OpcMnu[ NumOpc ]
     ASSIGN PARENT       = OpcMnu[ 1 ]
            LABEL        = "Salir de la &Aplicación"
            PRIVATE-DATA = ""
            TRIGGERS:
                ON CHOOSE
                DO: 
                    RUN SALIR.
                END.
            END TRIGGERS. 
    NumOpc = NumOpc + 1.         

    
    /* Opciones de Ayuda */
    CREATE SUB-MENU OpcMnu[ NumOpc ]
         ASSIGN PARENT = H-parent[ 1 ]
                LABEL  = "&Ayuda".
    H-parent[ 2 ] = OpcMnu[ NumOpc ].
    NumOpc = NumOpc + 1.

    CREATE BUTTON H-Boton[ NumBtn ]
     ASSIGN ROW          = 1.19
            WIDTH        = {&Ancho-Boton}
            HEIGHT       = {&Alto-Boton}
            COL          = s-Col-Boton
            FRAME        = FRAME F-MENU:HANDLE
            SENSITIVE    = YES
            VISIBLE      = YES
            LABEL        = "&Ayuda"
            PRIVATE-DATA = ""
            TRIGGERS:
                ON "HELP":U
                DO:
                    RUN AYUDA( SELF:PRIVATE-DATA, SELF:LABEL ).
                END.
                ON CHOOSE 
                DO: 
                END.
            END TRIGGERS. 
    OK = H-Boton[ NumBtn ]:LOAD-IMAGE-UP("img/ayuda.ico").
    s-Col-Boton = s-Col-Boton + {&Ancho-Boton}.
    NumBtn = NumBtn + 1.

    CREATE MENU-ITEM OpcMnu[ NumOpc ]
     ASSIGN PARENT       = H-parent[ 2 ]
            LABEL        = "&Contenido"
            PRIVATE-DATA = ""
            TRIGGERS:
                ON CHOOSE
                DO: 
                END.
            END TRIGGERS. 
    NumOpc = NumOpc + 1.         


    CREATE MENU-ITEM OpcMnu[ NumOpc ]
     ASSIGN PARENT       = H-parent[ 2 ]
            LABEL        = "&Buscando Temas de Ayuda"
            PRIVATE-DATA = ""
            TRIGGERS:
                ON CHOOSE
                DO: 
                END.
            END TRIGGERS. 
    NumOpc = NumOpc + 1.         

    CREATE MENU-ITEM OpcMnu[ NumOpc ]
         ASSIGN PARENT  = H-parent[ 2 ]
                SUBTYPE = "RULE".
    NumOpc = NumOpc + 1.         
    CREATE MENU-ITEM OpcMnu[ NumOpc ]
     ASSIGN PARENT       = H-parent[ 2 ]
            LABEL        = "&Mensajes de Error"
            PRIVATE-DATA = ""
            TRIGGERS:
                ON CHOOSE
                DO: 
                    RUN  prohelp/_msgs.p.
                END.
            END TRIGGERS. 
    NumOpc = NumOpc + 1.         
    CREATE MENU-ITEM OpcMnu[ NumOpc ]
         ASSIGN PARENT  = H-parent[ 2 ]
                SUBTYPE = "RULE".
    NumOpc = NumOpc + 1.         

    CREATE MENU-ITEM OpcMnu[ NumOpc ]
     ASSIGN PARENT       = H-parent[ 2 ]
            LABEL        = "&Acerca de .."
            PRIVATE-DATA = ""
            TRIGGERS:
                ON CHOOSE
                DO: 
                    RUN PROCESA( "bin/_acerca.w", "no" ).
                END.
            END TRIGGERS. 
    NumOpc = NumOpc + 1.

    ASSIGN {&WINDOW-NAME}:MENUBAR = localmenu.
    
    P-1 = {&WINDOW-NAME}:WIDTH * .7.
    P-2 = {&WINDOW-NAME}:WIDTH - 8 - P-1.

    IF P-2 < 16
    THEN bStatus = STRING({&WINDOW-NAME}:WIDTH - 8 , ">9").
    ELSE bStatus = STRING(P-1) + "," + STRING(P-2).
    
    RUN adecomm/_status.p
        ( {&WINDOW-NAME},
          bStatus,
          YES,
          4,
          OUTPUT hStatus,
          OUTPUT P-1).
    hStatus:VISIBLE = YES.

    RUN adecomm/_statdsp.p ( hStatus, 1, "Compañia : " + s-NomCia ).
    RUN adecomm/_statdsp.p ( hStatus, 2, "Usuario  : " + USERID("integral")).


    /* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
    NumOpc = 0.
    MAIN-BLOCK:
    DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
       ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  
        /* The CLOSE event can be used from inside or outside the procedure to  */
        /* terminate it.                                                        */

        /* Execute this code only if not being run PERSISTENT, i.e., if in test mode
           of one kind or another or if this is a Main Window. Otherwise postpone 
           'initialize' until told to do so. */

        RUN dispatch ('initialize':U). 
        OK = SESSION:SET-WAIT-STATE("").
        
        IF NOT THIS-PROCEDURE:PERSISTENT 
        THEN  WAIT-FOR CLOSE OF THIS-PROCEDURE.
    END.
    
    &IF DEFINED(UIB_IS_RUNNING) EQ 0 &THEN
        END.
    &ENDIF
END.


/* **********************  Internal Procedures  *********************** */

PROCEDURE PROCESA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER x-prog     AS CHARACTER.
    DEFINE INPUT PARAMETER p-Persist  AS CHARACTER.

    DEFINE VAR x-persist  AS LOGICAL.
    DEFINE VAR i          AS INTEGER.
    DEFINE VAR j          AS INTEGER.
    DEFINE VAR p          AS CHARACTER.

    DEFINE VAR x-hEquivale AS WIDGET-HANDLE.
    DEFINE VAR x-hWindows  AS WIDGET-HANDLE.
    
    x-persist = p-persist = "yes".
    i         = INDEX(x-prog,"(").
    j         = INDEX(x-prog,")").
    IF j - i > 1 
    THEN DO:
        j = j - i - 1.
        i = i + 1.
        p = SUBSTRING(x-prog , i , j ).
    END.

    FIND D-MENU WHERE hOpcion = SELF:Handle NO-ERROR.
    
    IF AVAILABLE D-MENU
    THEN x-hEquivale = D-MENU.hEquivale.
    ELSE IF x-Persist 
        THEN DO:
            CREATE D-MENU.
            hOpcion = SELF:Handle.
        END.

    Wait-Status = SESSION:SET-WAIT-STATE("GENERAL").
    IF x-Persist 
    THEN DO:
        IF VALID-HANDLE( D-MENU.hPrograma )
        THEN DO:
             x-hWindows = D-MENU.hPrograma:CURRENT-WINDOW.
            
             MESSAGE "Programa actualmente se esta ejecutando"
                VIEW-AS ALERT-BOX ERROR.

             IF x-hWindows:WINDOW-STATE = 2
             THEN x-hWindows:WINDOW-STATE = 3.
             
             OK = x-hWindows:MOVE-TO-TOP().   
             
        END.
        ELSE DO /*ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE*/:
             IF p <> ""
             THEN RUN VALUE(x-prog) PERSISTENT SET x-handle (p) . 
             ELSE RUN VALUE(x-prog) PERSISTENT SET x-handle. 
             
             IF VALID-HANDLE( x-handle )
             THEN DO:
                x-hWindows = x-handle:CURRENT-WINDOW.
                
                IF LOOKUP( "dispatch", x-Handle:INTERNAL-ENTRIES) > 0
                THEN DO:
                    RUN dispatch IN x-handle ('initialize':U) NO-ERROR.
                    D-MENU.hPrograma = x-handle.
                    IF x-hEquivale <> ?
                    THEN DO:
                        FIND D-MENU WHERE hOpcion = x-hEquivale NO-ERROR.
                        IF AVAILABLE D-MENU
                        THEN D-MENU.hPrograma = x-handle.
                    END.
                END.
             END.
        END.
    END.
    ELSE DO:
        SELF:SENSITIVE = NO.
        IF x-hEquivale <> ?
        THEN x-hEquivale:SENSITIVE = NO.
        NumOPc = NumOpc + 1.
        
        DO /*ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE*/:
            IF p <> ""
            THEN RUN VALUE(x-prog)(p).
            ELSE RUN VALUE(x-prog).
        END.
        
        SELF:SENSITIVE = YES.
        IF x-hEquivale <> ?
        THEN x-hEquivale:SENSITIVE = YES.
        NumOPc = NumOpc - 1.
        
    END.
    Wait-Status = SESSION:SET-WAIT-STATE("").
END PROCEDURE.


PROCEDURE SALIR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR x-hWindows  AS WIDGET-HANDLE.
    DEFINE VAR x-hPrograma AS WIDGET-HANDLE.

    FOR EACH D-MENU WHERE D-MENU.hPrograma <> ? NO-LOCK:
        IF VALID-HANDLE( D-MENU.hPrograma )
        THEN DO:
            MESSAGE "Salida no valida" skip
                "Existen procedimientos persistentes pendientes"
                VIEW-AS ALERT-BOX ERROR.
            x-hWindows  = D-MENU.hPrograma:CURRENT-WINDOW.
            IF VALID-HANDLE( x-hWindows )
            THEN DO:
                IF x-hWindows:WINDOW-STATE = 2
                THEN x-hWindows:WINDOW-STATE = 3.
                OK = x-hWindows:MOVE-TO-TOP().
            END.
            RETURN.
        END.
    END.

    IF NumOpc > 0
    THEN DO:
        MESSAGE "Salida no valida" skip
            "Existen procedimientos pendientes"
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    RUN dispatch IN THIS-PROCEDURE ('exit':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects mainmenu  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available mainmenu  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI mainmenu  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(mainmenu)
  THEN DELETE WIDGET mainmenu.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI mainmenu  _DEFAULT-ENABLE
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
  DISPLAY X-CodDiv F-PtoVta 
      WITH FRAME F-Main IN WINDOW mainmenu.
  ENABLE RECT-2 RECT-4 
      WITH FRAME F-Main IN WINDOW mainmenu.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW mainmenu.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy mainmenu 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO TRANSACTION:
    FIND ccbcterm WHERE CcbCTerm.CodCia = s-codcia AND
        CcbCTerm.CodDiv = s-coddiv AND
        CcbCTerm.CodTer = s-codter EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE ccbcterm
    THEN DO:
        MESSAGE "El terminal no ha podido ser desbloqueado" SKIP
            "Avisar al administrador de red" VIEW-AS ALERT-BOX WARNING.
    END.
    ELSE
        ASSIGN
            CcbCTerm.Fecha = ?
            CcbCTerm.FlgEst = "D"
            CcbCTerm.Hora = ""
            CcbCTerm.Usuario= "".
    RELEASE ccbcterm.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit mainmenu 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize mainmenu 
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
     F-PtoVta = S-CodTer.
     X-CodDiv = s-coddiv.
     DISPLAY F-PtoVta X-CodDiv.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records mainmenu  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartMenu, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed mainmenu 
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

