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
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR S-USER-ID AS CHAR.
DEFINE SHARED VAR s-CodAlm  LIKE Almacen.CodAlm.

DEFINE VARIABLE cAlmacen    LIKE almacen.codalm   NO-UNDO.
DEFINE VARIABLE cConfi      AS CHARACTER          NO-UNDO.
DEFINE VARIABLE x-Almacenes AS CHAR               NO-UNDO.
DEFINE VARIABLE x-clave     AS CHARACTER INIT 'confirmar' NO-UNDO.

/*Frame Proceso*/
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
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEFINE TEMP-TABLE tmp-tempo
    FIELDS tt-codcia    LIKE AlmDInv.Codcia 
    FIELDS tt-almacen   LIKE AlmDInv.CodAlm 
    FIELDS tt-codubi    LIKE AlmDInv.CodUbi 
    FIELDS tt-nomcia    AS CHARACTER
    FIELDS tt-nropag    AS INTEGER
    FIELDS tt-nrosec    AS INTEGER 
    FIELDS tt-codmat    LIKE AlmDInv.codmat 
    FIELDS tt-canfis    LIKE AlmDInv.QtyFisico 
    FIELDS tt-codusr    LIKE AlmDInv.CodUserCon 
    FIELDS tt-fchcon    LIKE AlmDInv.FecCon
    FIELDS tt-orden     AS INTEGER INIT 0. /* 23Oct2014 Ic - Orden en la ubicacion  */

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
&Scoped-Define ENABLED-OBJECTS RECT-57 txt-date b-busca cb-almacen Btn_OK ~
btn-ok-2 
&Scoped-Define DISPLAYED-OBJECTS txt-date cb-almacen rs-inv tg-blanco ~
x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-busca 
     LABEL "..." 
     SIZE 3 BY .88.

DEFINE BUTTON btn-ok-2 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "btn ok 2" 
     SIZE 8 BY 1.77.

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img/db.ico":U
     LABEL "Aceptar" 
     SIZE 8 BY 1.77 TOOLTIP "Procesar"
     BGCOLOR 8 .

DEFINE VARIABLE cb-almacen AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacenes" 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE txt-date AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de la Toma del Inventario :" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 79 BY .85
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE rs-inv AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Total", "T",
"Parcial", "P"
     SIZE 23 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82.43 BY 7.65.

DEFINE VARIABLE tg-blanco AS LOGICAL INITIAL yes 
     LABEL "Incluir Ubicacion en blanco" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-date AT ROW 1.81 COL 28 COLON-ALIGNED WIDGET-ID 26
     b-busca AT ROW 2.81 COL 79.29 WIDGET-ID 28
     cb-almacen AT ROW 2.88 COL 28 COLON-ALIGNED WIDGET-ID 8
     rs-inv AT ROW 4.23 COL 12 NO-LABEL WIDGET-ID 30
     tg-blanco AT ROW 4.23 COL 54 WIDGET-ID 40
     x-mensaje AT ROW 5.58 COL 3 NO-LABEL WIDGET-ID 34
     Btn_OK AT ROW 6.46 COL 61.57
     btn-ok-2 AT ROW 6.46 COL 73 WIDGET-ID 38
     RECT-57 AT ROW 1.27 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.72 BY 8.08
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
         TITLE              = "Registro de Inventario CONTINENTAL (Tiendas)"
         HEIGHT             = 8.08
         WIDTH              = 83.72
         MAX-HEIGHT         = 15.04
         MAX-WIDTH          = 87.14
         VIRTUAL-HEIGHT     = 15.04
         VIRTUAL-WIDTH      = 87.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
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
/* SETTINGS FOR RADIO-SET rs-inv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-blanco IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Registro de Inventario CONTINENTAL (Tiendas) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Registro de Inventario CONTINENTAL (Tiendas) */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-busca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-busca W-Win
ON CHOOSE OF b-busca IN FRAME F-Main /* ... */
DO:
    RUN alm/d-repalm (INPUT-OUTPUT x-Almacenes).
    cAlmacen = x-Almacenes. 
    cb-Almacen = x-Almacenes.
    DISPLAY cAlmacen @ cb-Almacen WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-ok-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-ok-2 W-Win
ON CHOOSE OF btn-ok-2 IN FRAME F-Main /* btn ok 2 */
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

    DEFINE VARIABLE x-rep AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-flg AS CHARACTER   NO-UNDO.

    ASSIGN txt-date rs-inv cb-almacen tg-blanco.

    cAlmacen = cb-almacen.
    IF tg-blanco THEN x-flg = "   incluyendo los de ubicación en blanco.". 
    ELSE x-flg = "  no considera los de ubicacion en blanco.".
    
    MESSAGE
        "      Este proceso se realiza solo una vez,"     SKIP
        "       toma en cuenta todos los artículos "     SKIP
        "                que tengan stock,          "     SKIP
                             x-flg                      SKIP        
        "  Si la información ingresada es la correcta"  SKIP
        "ingrese la palabra CONFIRMAR y de Aceptar "  
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE choice AS LOGICAL.
    CASE choice:
        WHEN TRUE  THEN DO:
            RUN lib/_clave (x-clave, OUTPUT x-rep).
            IF x-rep = 'OK' THEN DO:
                RUN Procesa-Datos.
                RUN Crea-Tabla.
                MESSAGE 'Proceso Terminado'
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
        END.
        WHEN FALSE THEN RETURN.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Tabla W-Win 
PROCEDURE Borra-Tabla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*Borra Cabecera de AlmDInv*/
    FOR EACH AlmDInv WHERE AlmDInv.CodCia = s-CodCia 
        AND LOOKUP(TRIM(AlmDInv.CodAlm),cAlmacen) > 0
        /*AND integral.almdinv.nomcia = "CONTI"*/ EXCLUSIVE-LOCK:
        DELETE AlmDInv.
    END.
    
    /*Borra Cabecera de AlmCInv*/
    FOR EACH AlmCInv WHERE AlmCInv.CodCia = s-CodCia 
        AND LOOKUP(TRIM(AlmCInv.CodAlm),cAlmacen) > 0
        /* AND integral.almcinv.nomcia = "CONTI"*/ EXCLUSIVE-LOCK:
        DELETE AlmCInv.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Tabla W-Win 
PROCEDURE Crea-Tabla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iNroPag AS INTEGER INIT 1  NO-UNDO.
    DEFINE VARIABLE iNroSec AS INTEGER INIT 1  NO-UNDO.
    DEFINE VARIABLE iHour   AS INTEGER INIT 3600000 NO-UNDO.
    
    RUN Borra-Tabla.
    
    FIND FIRST tmp-tempo NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tmp-tempo THEN DO:
        MESSAGE 'No existe Información'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN 'ADM-ERROR'.
        LEAVE.
    END.
    
    FOR EACH tmp-tempo 
        BREAK BY tt-almacen 
            /*BY SUBSTRING(tt-codubi,1,2) */
            BY tt-codubi
            BY tt-orden /* 23Oct2014 Ic - orden de pistoleteo de zonificacion */
            BY tt-codmat:  

        IF FIRST-OF(tt-almacen) THEN DO:
            RUN lib/logtabla ('almcinv',
                              tt-almacen,
                              'CREATE').
        END.

        /*********Creando Cabecera**********/
        FIND FIRST AlmCInv WHERE 
            AlmCInv.CodCia    = s-codcia AND
            AlmCInv.CodAlm    = tt-almacen AND
            AlmCInv.NroPagina = iNroPag AND
            AlmCInv.NomCia    = tt-nomcia NO-LOCK NO-ERROR.
        IF NOT AVAILABLE AlmCInv THEN DO:
            CREATE AlmCInv.
            ASSIGN
                AlmCInv.CodCia    = s-CodCia
                AlmCInv.CodAlm    = tt-almacen
                AlmCInv.NroPagina = iNroPag
                AlmCInv.NomCia    = tt-nomcia
                AlmCInv.FecUpdate = txt-date
                AlmCInv.CodAlma   = tt-codubi.
        END.
        /****************************************/

        /********Creando Detalle Tabla***********/
        FIND FIRST almdinv WHERE AlmDInv.CodCia = s-CodCia
            AND AlmDInv.CodAlm       = tt-Almacen
            AND AlmDInv.CodUbi       = tt-CodUbi
            AND AlmDInv.NroPagina    = iNroPag
            AND AlmDInv.NroSecuencia = iNroSec
            AND AlmDInv.NomCia       = tt-nomcia   
            AND AlmDInv.CodMat       = tt-CodMat EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE AlmDInv THEN DO:
            CREATE AlmDInv.
            ASSIGN
                AlmDInv.CodCia       = s-codcia
                AlmDInv.CodAlm       = tt-almacen
                AlmDInv.CodUbi       = tt-CodUbi
                AlmDInv.NroPagina    = iNroPag
                AlmDInv.NroSecuencia = iNroSec
                AlmDInv.NomCia       = tt-nomcia
                AlmDInv.CodMat       = tt-CodMat
                AlmDInv.Libre_f01    = txt-date.
            iNroSec = iNroSec + 1.
        END.   
        ASSIGN AlmDInv.QtyFisico = tt-CanFis. 
    
        /*Salto por Ubicacion*/
        IF LAST-OF(tt-codubi) THEN
            ASSIGN
                iNroPag = iNroPag + 1       
                iNroSec = 1.
        ELSE DO:
            IF (iNroSec - 1) MOD 25 = 0 THEN DO: 
                iNroPag = iNroPag + 1.       
                iNroSec = 1.
            END.
        END.

        IF LAST-OF(tt-almacen) THEN 
            ASSIGN
                iNroPag = 1
                iNroSec = 1.
    END.

    DEFINE VAR lRowId AS ROWID.
    DEF BUFFER B-Almacen FOR Almacen.

    /*Actualiza tabla InvConfig*/
    FOR EACH Almacen WHERE Almacen.CodCia = s-CodCia
        AND LOOKUP(TRIM(Almacen.CodAlm),cb-almacen) > 0 NO-LOCK:

        /* Bloquea el Almacen para la Zonificacion */
        lRowId = ROWID(Almacen).
        FIND FIRST b-almacen WHERE ROWID(b-almacen)=lRowId EXCLUSIVE NO-ERROR.
        IF AVAILABLE b-almacen THEN ASSIGN b-almacen.campo-c[10]="X".

        FIND InvConfig WHERE InvConfig.CodCia = s-CodCia
            AND InvConfig.CodAlm = Almacen.CodAlm
            AND InvConfig.FchInv = txt-date NO-LOCK NO-ERROR.
        IF NOT AVAIL InvConfig THEN DO:
            CREATE InvConfig.
            ASSIGN
                InvConfig.CodCia  =  s-CodCia
                InvConfig.CodAlm  =  Almacen.CodAlm
                InvConfig.FchInv  =  txt-date
                InvConfig.TipInv  =  rs-inv
                InvConfig.Usuario =  s-user-id.
        END.
    END.
    RELEASE b-almacen.

    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

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
  DISPLAY txt-date cb-almacen rs-inv tg-blanco x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 txt-date b-busca cb-almacen Btn_OK btn-ok-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
      ASSIGN 
              rs-inv   = "T"
              txt-date = TODAY.

      DISPLAY rs-inv txt-date.
  END.
  END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Datos W-Win 
PROCEDURE Procesa-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i AS INTEGER     NO-UNDO.

    cAlmacen = cb-almacen:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    
    EMPTY TEMP-TABLE tmp-tempo.

    /*Carga Materiales por División*/
    FOR EACH almacen WHERE almacen.codcia = s-codcia
        AND LOOKUP(almacen.codalm,cAlmacen) > 0 NO-LOCK,
        EACH almmmate OF almacen, 
            FIRST almmmatg OF almmmate NO-LOCK:

        IF NOT tg-blanco AND almmmate.codubi = '' THEN NEXT.
        /*
        FIND LAST AlmStkAl /*USE-INDEX Llave03 */
            WHERE AlmStkAl.CodCia = s-codcia
            AND AlmStkAl.CodAlm  = TRIM(almmmate.codalm)
            AND almstkal.codmat  = almmmate.codmat
            AND AlmStkal.Fecha  <= txt-date NO-LOCK NO-ERROR.    
        */
        /*IF almmmatg.tpoart <> "A" AND almmmate.stkact = 0 THEN NEXT.*/

        /* Solo con Stocks */
        /*IF NOT AVAILABLE AlmStkAl THEN NEXT.
        IF AlmStkal.StkAct = 0 THEN NEXT.
        */

        /*IF almmmate.StkAct = 0 THEN NEXT.*/
        IF almmmate.StkAct = 0 AND almmmate.codubi = 'G-0' THEN NEXT.

        FIND FIRST tmp-tempo WHERE tt-codcia  = s-codcia 
            AND tt-almacen = almmmate.codalm 
            AND tt-nomcia  = "CONTI" 
            AND tt-codubi  = almmmate.codubi 
            AND tt-codmat  = almmmatg.codmat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE tmp-tempo THEN DO:
            CREATE tmp-tempo.
            ASSIGN
                tt-codcia  = s-codcia       
                tt-almacen = TRIM(almmmate.codAlm)
                tt-nomcia  = "CONTI"
                tt-codubi  = almmmate.codubi
                tt-codmat  = TRIM(almmmatg.codmat)
                tt-orden    = almmmate.libre_d02. /* 23Oct2014 - Ic Orden de pistoleteo de Zonificacion */ 
        END.
        ASSIGN
            tt-canfis  = almmmate.stkact   /*AlmStkal.StkAct*/
            tt-codusr  = s-user-id
            tt-fchcon  = txt-date.
        DISPLAY "PROCESANDO: " + Almmmatg.CodMat + " - " + Almmmatg.DesMat @ x-mensaje
            WITH FRAME {&FRAME-NAME}.

        /*PAUSE 0.*/
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
        WHEN "" THEN .
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

