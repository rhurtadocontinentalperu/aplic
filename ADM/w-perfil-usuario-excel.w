&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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

DEFINE TEMP-TABLE tt-menu-seg    
    FIELDS  codgrpo     AS  CHAR    FORMAT 'x(50)'    
    FIELDS  aplicid     AS  CHAR    FORMAT 'x(5)'
    FIELDS  codmnu      AS  CHAR    FORMAT 'x(10)'
    FIELDS  desmnu      AS  CHAR    FORMAT 'x(80)'

    INDEX idx00 IS PRIMARY codgrpo aplicid codmnu.

DEFINE TEMP-TABLE tt-user-opciones
    FIELDS  xUSERID     AS  CHAR    FORMAT 'x(15)'      COLUMN-LABEL "UserId"
    FIELDS  username    AS  CHAR    FORMAT 'x(60)'      COLUMN-LABEL "Nombre del Usuario"
    FIELDS  aplicid     AS  CHAR    FORMAT 'x(5)'       COLUMN-LABEL "Cod.App"
    FIELDS  aplicnom    AS  CHAR    FORMAT 'x(60)'      COLUMN-LABEL "Nombre del App"
    FIELDS  codmnu      AS  CHAR    FORMAT 'x(10)'      COLUMN-LABEL "Cod.Menu"
    FIELDS  etiqueta    AS  CHAR    FORMAT 'x(60)'      COLUMN-LABEL "Nombre del Menu"
    FIELDS  programa    AS  CHAR    FORMAT 'x(80)'      COLUMN-LABEL "Programa"
    FIELDS  Grupo       AS  CHAR    FORMAT 'x(80)'      COLUMN-LABEL "Grupo"
    FIELDS  fcreado   AS  DATETIME      COLUMN-LABEL "Creado"
    FIELDS  fregistro   AS  DATETIME      COLUMN-LABEL "Actualizado"
    FIELDS  fcesado   AS  DATETIME      COLUMN-LABEL "Cesado"
    FIELDS  codper      AS  CHAR    FORMAT 'x(15)'      COLUMN-LABEL "Cod.Planilla"
    FIELDS  inactivo    AS  LOG     COLUMN-LABEL "Inactivo"

    INDEX idx00 IS PRIMARY xuserid aplicid codmnu.

DEFINE VAR x-ruta AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS RADIO-SET-cuales BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-cuales FILL-IN-ruta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE VARIABLE FILL-IN-ruta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 4 NO-UNDO.

DEFINE VARIABLE RADIO-SET-cuales AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ambos", 1,
"Opciones del Menu", 2,
"Perfiles de usuario", 3
     SIZE 20 BY 2.5 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-cuales AT ROW 1.27 COL 2.72 NO-LABEL WIDGET-ID 2
     BUTTON-1 AT ROW 1.38 COL 25 WIDGET-ID 6
     FILL-IN-ruta AT ROW 2.73 COL 22.86 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BUTTON-2 AT ROW 2.81 COL 81 WIDGET-ID 10
     "Elija el directorio donde grabar el Excel" VIEW-AS TEXT
          SIZE 27.72 BY .62 AT ROW 2.12 COL 53.29 WIDGET-ID 12
          FONT 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 84.14 BY 3.73 WIDGET-ID 100.


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
         TITLE              = "Opciones menu / Perfiles de usuarios"
         HEIGHT             = 3.73
         WIDTH              = 84.14
         MAX-HEIGHT         = 18.65
         MAX-WIDTH          = 84.14
         VIRTUAL-HEIGHT     = 18.65
         VIRTUAL-WIDTH      = 84.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-ruta IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Opciones menu / Perfiles de usuarios */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Opciones menu / Perfiles de usuarios */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Procesar */
DO:
  ASSIGN radio-set-cuales fill-in-ruta.

  IF TRUE <> (fill-in-ruta > "") THEN DO:
      MESSAGE "Ingrese la ruta donde dejar el Excel".
      RETURN NO-APPLY.
  END.

  x-ruta = fill-in-ruta + "\".

        MESSAGE 'Seguro de PROCESAR ?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

    RUN procesar.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* ... */
DO:
        DEFINE VAR lDirectorio AS CHAR.

        lDirectorio = "".

        SYSTEM-DIALOG GET-DIR lDirectorio  
           RETURN-TO-START-DIR 
           TITLE 'Directorio Files'.

    IF lDirectorio <> "" THEN fill-in-ruta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lDirectorio.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

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
  DISPLAY RADIO-SET-cuales FILL-IN-ruta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RADIO-SET-cuales BUTTON-1 BUTTON-2 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar W-Win 
PROCEDURE procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-menu-seg.
EMPTY TEMP-TABLE tt-user-opciones.

DEFINE VAR x-tienda AS CHAR.
DEFINE VAR lCodGrpo AS CHAR.
DEFINE VAR lSec AS INT.

x-tienda = "".    /*CONTINENTAL, UTILEX*/

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

SESSION:SET-WAIT-STATE('').

w-win:LOAD-MOUSE-POINTER("WAIT").
/*w-win:SENSITIVE = NO.*/

IF RADIO-SET-cuales = 1 OR RADIO-SET-cuales = 2 THEN DO:
    FOR EACH pf-g002 WHERE NOT (TRUE <> (pf-g002.aplic-id > "")) NO-LOCK:
        /* Grupos */
        REPEAT lSec = 1 TO NUM-ENTRIES(pf-g002.seguridad-grupos,",") :

            PROCESS EVENTS.

            lCodGrpo = ENTRY(lSec,pf-g002.seguridad-grupos,",").

            FIND FIRST tt-menu-seg WHERE tt-menu-seg.codgrpo = lCodGrpo AND 
                                            tt-menu-seg.aplicid = pf-g002.aplic-id AND 
                                            tt-menu-seg.codmnu = pf-g002.codmnu NO-ERROR.
            IF NOT AVAILABLE tt-menu-seg THEN DO:
                CREATE tt-menu-seg.
                ASSIGN  tt-menu-seg.codgrpo     = lCodGrpo
                        tt-menu-seg.aplicid     = pf-g002.aplic-id
                        tt-menu-seg.codmnu      = pf-g002.codmnu
                        tt-menu-seg.desmnu      = pf-g002.etiqueta.
            END.
        END.
    END.

    /*c-xls-file = 'd:\xpciman\Grupos-Opciones-' + x-tienda + '.xlsx'.*/
    c-xls-file = x-ruta + "Grupos-Opciones.xlsx".

    run pi-crea-archivo-csv IN hProc (input  buffer tt-menu-seg:handle,
                            /*input  session:temp-directory + "file"*/ c-xls-file,
                            output c-csv-file) .

    run pi-crea-archivo-xls  IN hProc (input  buffer tt-menu-seg:handle,
                            input  c-csv-file,
                            output c-xls-file) .

END.

IF RADIO-SET-cuales = 1 OR RADIO-SET-cuales = 3 THEN DO:

    /* Opciones Usuarios */

    FOR EACH pf-g004 WHERE pf-g004.codcia = 0 AND NOT (TRUE <> (pf-g004.aplic-id > "")) NO-LOCK:
        FIND FIRST _user WHERE _user._userid = pf-g004.USER-ID NO-LOCK NO-ERROR.
        FIND FIRST gn-users WHERE gn-users.codcia = 1 AND gn-users.USER-ID = pf-g004.USER-ID NO-LOCK NO-ERROR.

        /* ACTIVOS / INACTIVOS ?? */
        IF AVAILABLE _user /*AND _disabled = YES*/ THEN DO:    
            /* Grupos */
            REPEAT lSec = 1 TO NUM-ENTRIES(pf-g004.seguridad,",") :

                lCodGrpo = ENTRY(lSec,pf-g004.seguridad,",").

                FOR EACH tt-menu-seg WHERE tt-menu-seg.codgrpo = lCodGrpo AND 
                                            tt-menu-seg.aplicid = pf-g004.aplic-id NO-LOCK:

                    PROCESS EVENTS.

                    FIND FIRST tt-user-opciones WHERE tt-user-opciones.xuserid = pf-g004.USER-ID AND
                                                    tt-user-opciones.aplicid = pf-g004.aplic-id AND
                                                    tt-user-opciones.codmnu = tt-menu-seg.codmnu NO-ERROR.
                    IF NOT AVAILABLE tt-user-opciones THEN DO:
                        /*  */
                        FIND FIRST pf-g002 WHERE pf-g002.aplic-id = pf-g004.aplic-id AND 
                                                    pf-g002.codmnu = tt-menu-seg.codmnu NO-LOCK NO-ERROR.

                        FIND FIRST pf-g003 WHERE pf-g003.aplic-id = pf-g004.aplic-id NO-LOCK NO-ERROR.                

                        CREATE tt-user-opciones.
                        ASSIGN tt-user-opciones.xUSERID = pf-g004.USER-ID
                                tt-user-opciones.aplicid    = pf-g004.aplic-id
                                tt-user-opciones.codmnu     = tt-menu-seg.codmnu
                                tt-user-opciones.grupo      = lCodGrpo
                                tt-user-opciones.fcreado    = _user._create_date
                                tt-user-opciones.inactivo   = _user._disable
                                tt-user-opciones.fregistro  = _user._last_login
                                tt-user-opciones.fcesado    = _user._account_expires
                                tt-user-opciones.codper     = _user._given_name
                                tt-user-opciones.username   = _user._user-name
                            .
                        
                            ASSIGN tt-user-opciones.aplicnom   = IF(AVAILABLE pf-g003) THEN pf-g003.detalle ELSE ""
                                    tt-user-opciones.etiqueta   = IF(AVAILABLE pf-g002) THEN pf-g002.etiqueta ELSE ""
                                    tt-user-opciones.programa   = IF(AVAILABLE pf-g002) THEN pf-g002.programa ELSE ""
                            .
                            IF tt-user-opciones.fcreado = ? THEN DO:
                                ASSIGN tt-user-opciones.fregistro  = IF(AVAILABLE gn-users) THEN gn-users.CREATE-date ELSE ?.
                            END.
                            IF tt-user-opciones.codper = ? OR TRIM(tt-user-opciones.codper) = "" THEN DO:
                                ASSIGN tt-user-opciones.codper     = IF(AVAILABLE gn-users) THEN gn-users.codper ELSE "".
                            END.
                    END.
                END.
            END.
        END.
    END.
    /*c-xls-file = 'd:\xpciman\Opciones-Usuarios-' + x-tienda + '.xlsx'.*/
    c-xls-file = x-ruta + "Opciones-Usuarios.xlsx".

    run pi-crea-archivo-csv IN hProc (input  buffer tt-user-opciones:handle,
                            /*input  session:temp-directory + "file"*/ c-xls-file,
                            output c-csv-file) .

    run pi-crea-archivo-xls  IN hProc (input  buffer tt-user-opciones:handle,
                            input  c-csv-file,
                            output c-xls-file) .
END.

w-win:LOAD-MOUSE-POINTER("ARROW").
/*w-win:SENSITIVE = YES.*/

DELETE PROCEDURE hProc.

SESSION:SET-WAIT-STATE('').

MESSAGE "Proceso terminado" VIEW-AS ALERT-BOX INFORMATION.


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

