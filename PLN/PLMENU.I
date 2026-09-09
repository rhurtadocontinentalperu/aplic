&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE VARIABLE x-handle    AS WIDGET-HANDLE            NO-UNDO.
DEFINE VARIABLE hStatus     AS WIDGET-HANDLE            NO-UNDO.
DEFINE VARIABLE BStatus     AS CHARACTER                NO-UNDO.
DEFINE VARIABLE localmenu   AS WIDGET-HANDLE            NO-UNDO.
DEFINE variable h-boton     AS WIDGET-HANDLE EXTENT 16.
DEFINE VARIABLE OpcMnu      AS WIDGET-HANDLE EXTENT 150 NO-UNDO.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 4.5
         WIDTH              = 40.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


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

    FOR EACH PF-G002 WHERE
        PF-G002.aplic-id = s-aplic-id
        BY PF-G002.CodMnu:
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
                            PRIVATE-DATA = PF-G002.Programa + "&" + PF-G002.aplic-id + "&" + PF-G002.codmnu
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
                           PRIVATE-DATA = PF-G002.Programa + "&" + PF-G002.aplic-id + "&" + PF-G002.codmnu
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

    /* Salida del Sistema */
    CREATE BUTTON H-Boton[ NumBtn ]
     ASSIGN ROW          = 1.19
            WIDTH        = {&Ancho-Boton}
            HEIGHT       = {&Alto-Boton}
            COL          = s-Col-Boton
            FRAME        = FRAME F-MENU:HANDLE
            SENSITIVE    = YES
            VISIBLE      = YES
            LABEL        = "Salir del &Sistema"
            PRIVATE-DATA = ""
            TRIGGERS:
                ON "HELP":U
                DO:
                    RUN AYUDA( SELF:PRIVATE-DATA, SELF:LABEL ).
                END.
                ON CHOOSE 
                DO: 
                    QUIT.
                END.
            END TRIGGERS. 
    OK = H-Boton[ NumBtn ]:LOAD-IMAGE-UP("img/fin.ico").
    s-Col-Boton = s-Col-Boton + {&Ancho-Boton}.
    NumBtn = NumBtn + 1.

    CREATE MENU-ITEM OpcMnu[ NumOpc ]
     ASSIGN PARENT       = OpcMnu[ 1 ]
            LABEL        = "Salir del &Sistema"
            PRIVATE-DATA = ""
            TRIGGERS:
                ON CHOOSE
                DO: 
                    QUIT.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE log-menus Include 
PROCEDURE log-menus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEF INPUT PARAMETER pPrograma AS CHAR.

 CREATE logtabla.
 ASSIGN logtabla.codcia = s-codcia
     logtabla.Dia = TODAY
     logtabla.Evento = "RUN-PROGRAM"
     logtabla.Hora = STRING(TIME, 'HH:MM:SS')
     logtabla.Tabla = s-aplic-id
     logtabla.Usuario = s-user-id
     logtabla.ValorLlave = pPrograma.

 /*MESSAGE "AQUIIIIIIIIIIIIIIIIIIII" + s-aplic-id + " " + STRING(s-codcia).*/

 RELEASE logtabla.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pico-y-programa Include 
PROCEDURE pico-y-programa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pAplic AS CHAR.
DEFINE INPUT PARAMETER pCodmnu AS CHAR.
DEFINE INPUT PARAMETER pProg AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

DEFINE VAR x-retval AS CHAR INIT "OK".

IF /*USERID("DICTDB") <> "ADMIN" AND*/ USERID("DICTDB") <> "MASTER" THEN DO:
    /* Valida PICO y SESSION */
    DEFINE VAR x-hProc AS HANDLE NO-UNDO.           /* Handle Libreria */       

    RUN adm\pico-session.p PERSISTENT SET x-hProc.

    /* Procedimientos */
    RUN pico-programa IN x-hProc (INPUT pAplic, 
                                  INPUT pCodMnu,
                                 INPUT pProg, 
                                 OUTPUT x-retval).   

    DELETE PROCEDURE x-hProc.                       /* Release Libreria */

END.                

pRetVal = x-retval.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pico-y-session Include 
PROCEDURE pico-y-session :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

DEFINE VAR x-retval AS CHAR INIT "OK".

IF USERID("DICTDB") <> "ADMIN" AND USERID("DICTDB") <> "MASTER" THEN DO:
    /* Valida PICO y SESSION */
    DEFINE VAR x-hProc AS HANDLE NO-UNDO.           /* Handle Libreria */       

    RUN adm\pico-session.p PERSISTENT SET x-hProc.

    /* Procedimientos */
    RUN pico-session IN x-hProc (INPUT "APLICACION", INPUT "PROGRAMA", 
                               INPUT s-user-id, OUTPUT x-retval).   

    DELETE PROCEDURE x-hProc.                       /* Release Libreria */

END.                

pRetVal = x-retval.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESA Include 
PROCEDURE PROCESA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER z-prog     AS CHARACTER.
    DEFINE INPUT PARAMETER p-Persist  AS CHARACTER.

    DEFINE VAR x-persist  AS LOGICAL.
    DEFINE VAR i          AS INTEGER.
    DEFINE VAR j          AS INTEGER.
    DEFINE VAR p          AS CHARACTER.

    DEFINE VAR x-hEquivale AS WIDGET-HANDLE.
    DEFINE VAR x-hWindows  AS WIDGET-HANDLE.

    DEFINE VAR x-pico-session AS CHAR NO-UNDO INIT "OK".

    DEFINE VAR x-prog   AS CHAR.
    DEFINE VAR x-aplic   AS CHAR.
    DEFINE VAR x-codmnu   AS CHAR.
    
    x-prog = ENTRY(1,z-prog,"&").
    IF NUM-ENTRIES(z-prog,"&") >= 2 THEN DO:
        x-aplic = ENTRY(2,z-prog,"&").
        x-codmnu = ENTRY(3,z-prog,"&").
    END.

    
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
    IF x-Persist THEN DO:
        IF VALID-HANDLE( D-MENU.hPrograma ) THEN DO:
             x-hWindows = D-MENU.hPrograma:CURRENT-WINDOW.
            
             MESSAGE "Programa actualmente se esta ejecutando"
                VIEW-AS ALERT-BOX ERROR.

             IF x-hWindows:WINDOW-STATE = 2
             THEN x-hWindows:WINDOW-STATE = 3.
             
             OK = x-hWindows:MOVE-TO-TOP().   
             
        END.
        ELSE DO /*ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE*/:

            /* Ic - 06Dic2019, valida PICO y SESION */            
            x-pico-session = "".
            RUN pico-y-session(OUTPUT x-pico-session).

            IF x-pico-session = "OK" THEN DO:

                x-pico-session = "".
                RUN pico-y-programa (INPUT x-aplic, INPUT x-codmnu, INPUT x-prog, OUTPUT x-pico-session).     

                IF x-pico-session = "OK" THEN DO:

                    /* RHC 09/08/2012 Rutina temporal LOG DE MENUS */
                    RUN LOG-MENUS(x-prog).

                    IF p <> "" THEN RUN VALUE(x-prog) PERSISTENT SET x-handle (p) . 
                    ELSE RUN VALUE(x-prog) PERSISTENT SET x-handle. 

                    IF VALID-HANDLE( x-handle ) THEN DO:
                        x-hWindows = x-handle:CURRENT-WINDOW.

                        IF LOOKUP( "dispatch", x-Handle:INTERNAL-ENTRIES) > 0 THEN DO:
                            RUN dispatch IN x-handle ('initialize':U) NO-ERROR.
                            D-MENU.hPrograma = x-handle.
                            IF x-hEquivale <> ? THEN DO:
                                FIND D-MENU WHERE hOpcion = x-hEquivale NO-ERROR.
                                IF AVAILABLE D-MENU THEN D-MENU.hPrograma = x-handle.
                            END.
                        END.
                    END.
                END.
                ELSE DO:
                    MESSAGE "PICO Y PROGRAMA" SKIP
                            x-pico-session VIEW-AS ALERT-BOX INFORMATION.
                END.
            END.
            ELSE DO:
                MESSAGE "PICO Y SESSION" SKIP
                        x-pico-session VIEW-AS ALERT-BOX INFORMATION.
            END.
        END.
    END.
    ELSE DO:
        /* Ic - 06Dic2019, valida PICO y SESION */            
        x-pico-session = "".
        RUN pico-y-session(OUTPUT x-pico-session).

        IF x-pico-session = "OK" THEN DO:

            x-pico-session = "".
            RUN pico-y-programa (INPUT x-aplic, INPUT x-codmnu, INPUT x-prog, OUTPUT x-pico-session).     

            IF x-pico-session = "OK" THEN DO:

                /* RHC 09/08/2012 Rutina temporal LOG DE MENUS */
                RUN LOG-MENUS(x-prog).

                SELF:SENSITIVE = NO.
                IF x-hEquivale <> ? THEN x-hEquivale:SENSITIVE = NO.
                NumOPc = NumOpc + 1.
            
                DO /*ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE*/:
                    IF p <> "" THEN RUN VALUE(x-prog)(p).
                        ELSE RUN VALUE(x-prog).
                END.
            
                SELF:SENSITIVE = YES.
                IF x-hEquivale <> ? THEN x-hEquivale:SENSITIVE = YES.
                NumOPc = NumOpc - 1.
            END.
            ELSE DO:
                MESSAGE "PICO Y PROGRAMA" SKIP
                        x-pico-session VIEW-AS ALERT-BOX INFORMATION.
            END.
        END.
        ELSE DO:
            MESSAGE "PICO Y SESSION" SKIP
                    x-pico-session VIEW-AS ALERT-BOX INFORMATION.
        END.
        
    END.
    run bin/_mes( s-NroMes , 1 , output f-n-mes ).
    DISPLAY            
        s-NroMes  @ F-Mes
        f-n-mes
        s-NroSem  @ FILL-NroSem
        WITH FRAME {&FRAME-NAME}.
    Wait-Status = SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SALIR Include 
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

