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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE        VAR F-PESALM AS DECIMAL NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE SHARED VAR S-USER-ID AS CHAR.
DEFINE VARIABLE cAlmacen AS CHARACTER   NO-UNDO.

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
    FIELDS tt-nropag    AS INTEGER
    FIELDS tt-nrosec    AS INTEGER 
    FIELDS tt-codmat    LIKE AlmDInv.codmat 
    FIELDS tt-canfis    LIKE AlmDInv.QtyFisico 
    FIELDS tt-codusr    LIKE AlmDInv.CodUserCon 
    FIELDS tt-fchcon    LIKE AlmDInv.FecCon.

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
&Scoped-Define ENABLED-OBJECTS RECT-57 cb-almacen Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS cb-almacen txt-alm 

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
     SIZE 11 BY 1.5 TOOLTIP "Imprimir"
     BGCOLOR 8 .

DEFINE VARIABLE cb-almacen AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Almacen" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE txt-alm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69.86 BY 5.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-almacen AT ROW 2.35 COL 10 COLON-ALIGNED WIDGET-ID 2
     txt-alm AT ROW 2.35 COL 20.86 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     Btn_OK AT ROW 4.77 COL 42.86
     Btn_Cancel AT ROW 4.77 COL 54 WIDGET-ID 6
     RECT-57 AT ROW 1.27 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72.14 BY 6.62
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
         TITLE              = "Registro de Inventario"
         HEIGHT             = 6.62
         WIDTH              = 72.14
         MAX-HEIGHT         = 6.62
         MAX-WIDTH          = 72.14
         VIRTUAL-HEIGHT     = 6.62
         VIRTUAL-WIDTH      = 72.14
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
/* SETTINGS FOR FILL-IN txt-alm IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Registro de Inventario */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Registro de Inventario */
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
    ASSIGN cb-almacen.
    IF cb-almacen = "Todos" THEN DO:
        FOR EACH Almacen WHERE Almacen.CodCia = s-codcia NO-LOCK
            BREAK BY Almacen.CodAlm:
            IF FIRST(Almacen.CodAlm) THEN cAlmacen = Almacen.CodAlm.
            ELSE cAlmacen = cAlmacen + "," + Almacen.CodAlm.
        END.
    END.
    RUN Procesa-Datos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-almacen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-almacen W-Win
ON VALUE-CHANGED OF cb-almacen IN FRAME F-Main /* Almacen */
DO:
    ASSIGN
        cb-almacen.
    DO WITH FRAME {&FRAME-NAME}:
        FIND FIRST Almacen WHERE Almacen.CodCia = s-codcia
            AND Almacen.CodAlm = INPUT cb-almacen NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen THEN DO: 
            DISPLAY
                Almacen.Descripcion @ txt-alm.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Completa-Tabla W-Win 
PROCEDURE Completa-Tabla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE iNroPag AS INTEGER INIT 1  NO-UNDO.
DEFINE VARIABLE iNroSec AS INTEGER INIT 1  NO-UNDO.
MESSAGE "Completa-tabla"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
FOR EACH tmp-tempo BREAK BY tt-almacen BY tt-codubi:
    /*Creando Cabecera*/
    FIND FIRST AlmCInv WHERE 
        AlmCInv.CodCia    = s-codcia AND
        AlmCInv.CodAlm    = tt-almacen AND
        AlmCInv.NroPagina = iNroPag NO-LOCK NO-ERROR.
    IF NOT AVAILABLE AlmCInv THEN DO:
        CREATE AlmCInv.
        ASSIGN
            AlmCInv.CodCia    = s-CodCia
            AlmCInv.CodAlm    = tt-almacen
            AlmCInv.NroPagina = iNroPag.
    END.

    FIND FIRST almdinv WHERE AlmDInv.CodCia = s-CodCia
        AND AlmDInv.CodAlm = tt-Almacen
        AND AlmDInv.CodUbi = tt-CodUbi
        AND AlmDInv.NroPagina = iNroPag
        AND AlmDInv.NroSecuencia = iNroSec
        AND AlmDInv.CodMat = tt-CodMat EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE AlmDInv THEN DO:
        CREATE AlmDInv.
        ASSIGN
            AlmDInv.CodCia       = s-codcia
            AlmDInv.CodAlm       = tt-almacen
            AlmDInv.CodUbi       = tt-CodUbi
            AlmDInv.NroPagina    = iNroPag
            AlmDInv.NroSecuencia = iNroSec
            AlmDInv.CodMat       = tt-CodMat /*
            AlmDInv.QtyFisico    = tt-CanFis
            AlmDInv.CodUserCon   = tt-codusr
            AlmDInv.FecCon       = tt-fchcon. */ .
        iNroSec = iNroSec + 1.
    END.
    ELSE DO:
        iNroSec = iNroSec + 1.
    END.
    ASSIGN
        AlmDInv.QtyFisico    = tt-CanFis
        AlmDInv.CodUserCon   = tt-codusr
        AlmDInv.FecCon       = tt-fchcon.


    IF (iNroSec - 1) MOD 40 = 0 THEN DO: 
        iNroPag = iNroPag + 1.       
    END.
    IF LAST-OF(tt-almacen) THEN 
        ASSIGN
            iNroPag = 1
            iNroSec = 1.
END.
MESSAGE "Termino"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
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
  DISPLAY cb-almacen txt-alm 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 cb-almacen Btn_OK Btn_Cancel 
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
      FOR EACH Almacen WHERE Almacen.CodCia = s-CodCia NO-LOCK:
          cb-almacen:ADD-LAST(Almacen.CodAlm).
      END.
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
MESSAGE cb-almacen
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
/*Carga Articulos Activos*/
    FOR EACH almmmatg WHERE almmmatg.codcia = 1
        AND almmmatg.codmat >= "000001"
        AND almmmatg.codmat <= "000060"
        AND almmmatg.tpoart = "A" NO-LOCK,
        FIRST almmmate OF Almmmatg 
        WHERE almmmate.codalm = cAlmacen NO-LOCK:
        FIND FIRST tmp-tempo WHERE tt-codcia  = s-codcia 
            AND tt-almacen = cAlmacen
            AND tt-codubi  = almmmate.codubi 
            AND tt-codmat  = almmmatg.codmat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE tmp-tempo THEN DO:
            CREATE tmp-tempo.
            ASSIGN
                tt-codcia  = s-codcia       
                tt-almacen = cAlmacen     
                tt-codubi  = almmmate.codubi
                tt-codmat  = almmmatg.codmat.
        END.
        ASSIGN
            tt-canfis  = almmmate.stkact
            tt-codusr  = s-user-id
            tt-fchcon  = TODAY.
        PAUSE 0.
    END.
/*Carga Articulos Desactivados con stock > 0*/
    FOR EACH almmmatg WHERE almmmatg.codcia = 1        
        AND almmmatg.tpoart <> "A" NO-LOCK,
        FIRST almmmate OF Almmmatg 
        WHERE almmmate.codalm = cAlmacen 
        AND Almmmate.stkact <> 0 NO-LOCK:
        FIND FIRST tmp-tempo WHERE tt-codcia  = s-codcia 
            AND tt-almacen = cAlmacen
            AND tt-codubi  = almmmate.codubi 
            AND tt-codmat  = almmmatg.codmat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE tmp-tempo THEN DO:
            CREATE tmp-tempo.
            ASSIGN
                tt-codcia  = s-codcia       
                tt-almacen = cAlmacen     
                tt-codubi  = almmmate.codubi
                tt-codmat  = almmmatg.codmat.
        END.
        ASSIGN
            tt-canfis  = almmmate.stkact
            tt-codusr  = s-user-id
            tt-fchcon  = TODAY.
        PAUSE 0.
    END.
    MESSAGE
        "Esta seguro de seguir con la operacion"        
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE choice AS LOGICAL.
    CASE choice:
        WHEN TRUE  THEN RUN Completa-Tabla.
        WHEN FALSE THEN RETURN.
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

