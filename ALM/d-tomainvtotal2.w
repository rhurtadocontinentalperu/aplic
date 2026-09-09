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
DEFINE SHARED VAR s-CodAlm  LIKE integral.Almacen.CodAlm.

DEFINE VARIABLE cAlmacen LIKE integral.almacen.codalm   NO-UNDO.
DEFINE VARIABLE cConfi   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-Almacenes AS CHAR NO-UNDO.

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
    FIELDS tt-codcia    LIKE integral.AlmDInv.Codcia 
    FIELDS tt-almacen   LIKE integral.AlmDInv.CodAlm 
    FIELDS tt-nomcia    AS CHARACTER
    FIELDS tt-codmat    LIKE integral.AlmDInv.codmat 
    FIELDS tt-codubi    LIKE integral.AlmDInv.CodUbi     
    FIELDS tt-nropag    AS INTEGER
    FIELDS tt-nrosec    AS INTEGER     
    FIELDS tt-canfis    LIKE integral.AlmDInv.QtyFisico 
    FIELDS tt-codusr    LIKE integral.AlmDInv.CodUserCon 
    FIELDS tt-fchcon    LIKE integral.AlmDInv.FecCon.

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
&Scoped-Define ENABLED-OBJECTS RECT-57 RECT-64 txt-date cb-almacen b-busca ~
Btn_OK Btn_Cancel x-almcissac rs-inv btn-ok-2 
&Scoped-Define DISPLAYED-OBJECTS txt-date cb-almacen x-almcissac rs-inv ~
x-mensaje txt-confi 

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
     SIZE 3 BY .81.

DEFINE BUTTON btn-ok 
     IMAGE-UP FILE "IMG/b-ok.bmp":U
     LABEL "Button 15" 
     SIZE 11 BY 1.5.

DEFINE BUTTON btn-ok-2 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "btn ok 2" 
     SIZE 11 BY 1.5.

DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img/db.ico":U
     LABEL "Aceptar" 
     SIZE 6 BY 1.5 TOOLTIP "Procesar"
     BGCOLOR 8 .

DEFINE VARIABLE cb-almacen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE txt-confi AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE txt-date AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-almcissac AS CHARACTER FORMAT "X(256)":U INITIAL "85,22,11" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE rs-inv AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Total", "T",
"Parcial", "P"
     SIZE 27 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 96.86 BY 5.77.

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 97 BY 2.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-date AT ROW 2.08 COL 10 COLON-ALIGNED WIDGET-ID 26
     cb-almacen AT ROW 3.15 COL 21.86 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     b-busca AT ROW 3.15 COL 68.14 WIDGET-ID 28
     Btn_OK AT ROW 3.15 COL 74
     Btn_Cancel AT ROW 3.15 COL 81 WIDGET-ID 6
     x-almcissac AT ROW 4.23 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     rs-inv AT ROW 5.58 COL 24 NO-LABEL WIDGET-ID 30
     btn-ok AT ROW 7.73 COL 23 WIDGET-ID 18
     btn-ok-2 AT ROW 7.73 COL 34 WIDGET-ID 36
     x-mensaje AT ROW 8 COL 46 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     txt-confi AT ROW 8.27 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     "Almacenes Standford" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 4.5 COL 4 WIDGET-ID 42
          FONT 6
     "Almacenes Continental" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 3.42 COL 4 WIDGET-ID 38
          FONT 6
     "Confirmar Inventario" VIEW-AS TEXT
          SIZE 16.57 BY .77 AT ROW 7.19 COL 3 WIDGET-ID 22
          FONT 6
     RECT-57 AT ROW 1.15 COL 1.72
     RECT-64 AT ROW 6.96 COL 1.72 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 98.72 BY 9.19
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
         TITLE              = "Registro de Inventario CONTI-CISSAC (Planta)"
         HEIGHT             = 9.19
         WIDTH              = 98.72
         MAX-HEIGHT         = 9.19
         MAX-WIDTH          = 98.72
         VIRTUAL-HEIGHT     = 9.19
         VIRTUAL-WIDTH      = 98.72
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
/* SETTINGS FOR BUTTON btn-ok IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-confi IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Registro de Inventario CONTI-CISSAC (Planta) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Registro de Inventario CONTI-CISSAC (Planta) */
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


&Scoped-define SELF-NAME btn-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-ok W-Win
ON CHOOSE OF btn-ok IN FRAME F-Main /* Button 15 */
DO:
    
    ASSIGN txt-confi txt-date rs-inv cb-almacen x-almcissac.
    cAlmacen = cb-almacen.

    cConfi = CAPS(txt-confi).
    IF cConfi = "CONFIRMAR" THEN DO:
        RUN Borra-Temporal.
        RUN Procesa-Datos.
        RUN Crea-Tabla.
    END.
    ELSE DO:
        MESSAGE "Palabra Incorrecta"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN 'ADM-ERROR'.
        APPLY 'ENTRY' TO txt-confi.
    END.

    MESSAGE 'Proceso Terminado'
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    ASSIGN txt-confi = ''.
    DISPLAY '' @ txt-confi WITH FRAME {&FRAME-NAME}.
    DISABLE txt-confi.
    DISABLE Btn-ok.
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


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  FOR EACH tmp-tempo:
      DELETE tmp-tempo.
  END.
  txt-confi = ''.
  DISABLE txt-confi.
  DISABLE txt-confi WITH FRAME {&FRAME-NAME}.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN txt-date rs-inv cb-almacen x-almcissac.
    cAlmacen = cb-almacen.
    txt-confi = ''.
    DISABLE txt-confi.    
    
    MESSAGE
        "   Este proceso se realiza solo una vez."     SKIP
        "Si la información ingresada es la correcta"  SKIP
        "ingrese la palabra CONFIRMAR en la casilla"  SKIP
        "             y de Aceptar                 "
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE choice AS LOGICAL.
    CASE choice:
        WHEN TRUE  THEN DO:
            ENABLE txt-confi WITH FRAME {&FRAME-NAME}.
            ENABLE Btn-OK  WITH FRAME {&FRAME-NAME}.
            APPLY 'ENTRY' TO txt-confi.
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

    /*Borra Cabecera de integral.almdinv*/
    FOR EACH integral.almdinv WHERE integral.almdinv.CodCia = s-CodCia 
        AND integral.almdinv.CodAlm = "12x"        
        AND integral.almdinv.nomcia = "CONTISTAND" EXCLUSIVE-LOCK:
        DELETE integral.almdinv.
    END.
    
    /*Borra Cabecera de integral.almcinv*/
    FOR EACH integral.almcinv WHERE integral.almcinv.CodCia = s-CodCia 
        AND integral.almcinv.CodAlm = "12x" 
        AND integral.almcinv.nomcia = "CONTISTAND" EXCLUSIVE-LOCK:
        DELETE integral.almcinv.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal W-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FOR EACH tmp-tempo:
        DELETE tmp-tempo.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Data-Cissac W-Win 
PROCEDURE Carga-Data-Cissac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cAlmacen AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE x-task-no AS INTEGER     NO-UNDO.

    cAlmacen = x-almcissac:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    
    /*Utilizar el Carga-Cissac-a*/
    RUN alm\p-carga-cissac.p (cAlmacen, txt-date, OUTPUT x-task-no).                    
        
    /*Cargando al temporal*/
    FOR EACH integral.w-report WHERE integral.w-report.task-no = x-task-no NO-LOCK:
        FIND FIRST tmp-tempo WHERE tmp-tempo.tt-codcia  = s-codcia 
            AND tmp-tempo.tt-almacen = "12x"
            AND tmp-tempo.tt-nomcia  = "CONTISTAND"
            /*AND tmp-tempo.tt-codubi  = integral.w-report.Ccamp-C[2]*/
            AND tmp-tempo.tt-codmat  = integral.w-report.Campo-C[3] NO-LOCK NO-ERROR.
        IF NOT AVAILABLE tmp-tempo THEN DO:
            CREATE tmp-tempo.
            ASSIGN
                tmp-tempo.tt-codcia  = s-codcia       
                tmp-tempo.tt-almacen = "12x"
                tmp-tempo.tt-nomcia  = "CONTISTAND"    
                tmp-tempo.tt-codubi  = integral.w-report.Campo-C[2]
                tmp-tempo.tt-codmat  = integral.w-report.Campo-C[3]
                tmp-tempo.tt-codusr  = s-user-id
                tmp-tempo.tt-fchcon  = txt-date.
        END.
        ASSIGN tmp-tempo.tt-canfis  = tmp-tempo.tt-canfis + integral.w-report.Campo-F[1].
    END.

    /*Borrando integral.w-report*/
    FOR EACH integral.w-report WHERE integral.w-report.task-no = x-task-no:
        DELETE integral.w-report.
    END.

    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

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
            BY SUBSTRING(tt-codubi,1,2) 
            BY tt-codubi
            BY tt-codmat: 
        /*********Creando Cabecera**********/
        FIND FIRST integral.almcinv WHERE 
            integral.almcinv.CodCia    = s-codcia AND
            integral.almcinv.CodAlm    = tt-almacen AND
            integral.almcinv.NroPagina = iNroPag AND
            integral.almcinv.NomCia    = tt-nomcia NO-LOCK NO-ERROR.
        IF NOT AVAILABLE integral.almcinv THEN DO:
            CREATE integral.almcinv.
            ASSIGN
                integral.almcinv.CodCia    = s-CodCia
                integral.almcinv.CodAlm    = tt-almacen
                integral.almcinv.NroPagina = iNroPag
                integral.almcinv.NomCia    = tt-nomcia
                /*
                integral.almcinv.FecUpdate = NOW + (24 * iHour).
                */
                integral.almcinv.FecUpdate = txt-date.
        END.
        /****************************************/

        /********Creando Detalle Tabla***********/
        FIND FIRST integral.almdinv WHERE integral.almdinv.CodCia = s-CodCia
            AND integral.almdinv.CodAlm       = tt-almacen
            AND integral.almdinv.CodUbi       = tt-CodUbi
            AND integral.almdinv.NroPagina    = iNroPag
            AND integral.almdinv.NroSecuencia = iNroSec
            AND integral.almdinv.NomCia       = tt-nomcia   
            AND integral.almdinv.CodMat       = tt-CodMat EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE integral.almdinv THEN DO:
            CREATE integral.almdinv.
            ASSIGN
                integral.almdinv.CodCia       = s-codcia
                integral.almdinv.CodAlm       = tt-almacen
                integral.almdinv.CodUbi       = tt-CodUbi
                integral.almdinv.NroPagina    = iNroPag
                integral.almdinv.NroSecuencia = iNroSec
                integral.almdinv.NomCia       = tt-nomcia
                integral.almdinv.CodMat       = tt-CodMat
                integral.almdinv.libre_f01     = txt-date.
            iNroSec = iNroSec + 1.
        END.   
        ASSIGN integral.almdinv.QtyFisico = tt-CanFis. 
    
        IF (iNroSec - 1) MOD 25 = 0 THEN DO: 
            iNroPag = iNroPag + 1.       
            iNroSec = 1.
        END.

        IF LAST-OF(SUBSTRING(tt-codubi,1,2)) THEN 
            ASSIGN
                iNroPag = iNroPag + 1
                iNroSec = 1.

        IF LAST-OF(tt-almacen) THEN 
            ASSIGN
                iNroPag = 1
                iNroSec = 1.
    END.

    /*Actualiza tabla integral.InvConfig*/
    FIND integral.InvConfig WHERE integral.InvConfig.CodCia = s-CodCia
        AND integral.InvConfig.CodAlm = "12x"
        AND integral.InvConfig.FchInv = txt-date NO-LOCK NO-ERROR.
    IF NOT AVAIL integral.InvConfig THEN DO:
        CREATE integral.InvConfig.
        ASSIGN
            integral.InvConfig.CodCia  =  s-CodCia
            integral.InvConfig.CodAlm  =  "12x"
            integral.InvConfig.FchInv  =  txt-date
            integral.InvConfig.TipInv  =  rs-inv
            integral.InvConfig.Usuario =  s-user-id.
    END.

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
  DISPLAY txt-date cb-almacen x-almcissac rs-inv x-mensaje txt-confi 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 RECT-64 txt-date cb-almacen b-busca Btn_OK Btn_Cancel 
         x-almcissac rs-inv btn-ok-2 
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
      FIND LAST InvConfig WHERE InvConfig.CodCia = S-CODCIA 
          AND  InvConfig.CodAlm = S-CODALM NO-LOCK NO-ERROR.
      IF NOT AVAILABLE InvConfig THEN  
          ASSIGN 
            rs-inv   = "T"
            txt-date = TODAY.
      ELSE 
         ASSIGN 
             rs-Inv   = InvConfig.TipInv
             txt-date = InvConfig.FchInv.
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
    DEFINE VARIABLE iInt AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cAlm AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lAlm AS LOGICAL     NO-UNDO INIT YES.
    
    cAlm = cb-almacen:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    /*Comprueba si la informacion ha sido cargada para los almacenes ingresados*/
    DO iInt = 1 TO NUM-ENTRIES(cAlm):
        FIND LAST integral.almcinv WHERE integral.almcinv.codcia = s-codcia
            AND integral.almcinv.codalm = ENTRY(iInt,cAlm,",")
            AND DATE(integral.almcinv.fecupdate) = txt-date
            /*AND integral.almcinv.swconteo = NO*/ NO-LOCK NO-ERROR.
        IF NOT AVAIL integral.almcinv THEN DO:
            MESSAGE "CONTINENTAL: " SKIP
                "Debe cargar previamente el almacen " + ENTRY(iInt,cAlm,",")
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "ADM-ERROR".
            lAlm = NO.
            LEAVE.
        END.
    END.

    /*Carga Materiales por División*/
    IF lAlm THEN
    DO iInt = 1 TO NUM-ENTRIES(cAlm):
        FOR EACH integral.almcinv WHERE integral.almcinv.codcia = s-codcia
            AND integral.almcinv.codalm = ENTRY(iInt,cAlm,",")
            AND DATE(integral.almcinv.fecupdate) = txt-date
            /*
            AND integral.almcinv.swconteo = NO
            */,
            EACH integral.almdinv OF integral.almcinv NO-LOCK:
            FIND FIRST tmp-tempo WHERE tt-codcia  = s-codcia 
                AND tt-almacen = "12x"
                AND tt-nomcia  = "CONTISTAND" 
                AND tt-codmat  = integral.almdinv.codmat NO-LOCK NO-ERROR.
            IF NOT AVAILABLE tmp-tempo THEN DO:
                CREATE tmp-tempo.
                ASSIGN
                    tt-codcia  = s-codcia       
                    tt-almacen = "12x"
                    tt-nomcia  = "CONTISTAND"
                    tt-codubi  = integral.almdinv.codubi
                    tt-codmat  = integral.almdinv.codmat.
            END.
            ASSIGN
                tt-canfis  = tt-canfis + integral.almdinv.qtyfisico
                tt-codusr  = s-user-id
                tt-fchcon  = txt-date.
            DISPLAY "PROCESANDO: " + integral.almdinv.codmat @ x-mensaje
                WITH FRAME {&FRAME-NAME}.
            PAUSE 0.
            /*END.*/
        END.
    END.

    
    /*
    FOR EACH integral.almmmatg WHERE integral.almmmatg.codcia = s-codcia NO-LOCK,
        EACH integral.almmmate OF integral.almmmatg 
        WHERE LOOKUP(TRIM(integral.almmmate.codalm),cb-almacen) > 0 
        AND integral.almmmate.stkact <> 0 NO-LOCK:
        
        IF integral.almmmatg.tpoart <> "A" AND integral.almmmate.stkact = 0 THEN NEXT.
        FIND FIRST tmp-tempo WHERE tt-codcia  = s-codcia 
            AND tt-almacen = integral.almmmate.codalm 
            AND tt-nomcia  = "CONTISTAND" 
            AND tt-codubi  = integral.almmmate.codubi 
            AND tt-codmat  = integral.almmmatg.codmat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE tmp-tempo THEN DO:
            CREATE tmp-tempo.
            ASSIGN
                tt-codcia  = s-codcia       
                tt-almacen = integral.almmmate.codAlm
                tt-nomcia  = "CONTISTAND"
                tt-codubi  = integral.almmmate.codubi
                tt-codmat  = integral.almmmatg.codmat.
        END.
        ASSIGN
            tt-canfis  = integral.almmmate.stkact
            tt-codusr  = s-user-id
            tt-fchcon  = txt-date.
        DISPLAY "Cargando.. " + integral.almmmatg.CodMat @ x-mensaje
            WITH FRAME {&FRAME-NAME}.
        PAUSE 0.
    END.            
    */

    /*Carga Cissac*/
    RUN Carga-Data-Cissac.    

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

