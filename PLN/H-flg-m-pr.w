&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME H-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS H-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEFINE
&IF "{&NEW}" = "" &THEN INPUT PARAMETER
&ELSE VARIABLE
&ENDIF x-CodPln AS INTEGER.

DEFINE
&IF "{&NEW}" = "" &THEN OUTPUT PARAMETER
&ELSE VARIABLE
&ENDIF ROWID-RETURN AS ROWID.

/* Local Variable Definitions ---                                       */

{bin/s-global.i}
{pln/s-global.i}

DEFINE VARIABLE x-Nombre       AS CHARACTER NO-UNDO.
DEFINE VARIABLE ROWID-BROWSE-1 AS ROWID NO-UNDO.
DEFINE VARIABLE WAIT-STATE     AS LOGICAL NO-UNDO.
/*DEFINE VARIABLE X-SECCION AS CHAR INIT "0010-FABRICA".*/
DEFINE VARIABLE X-SECCION AS CHAR INIT "FABRICA".

WAIT-STATE = SESSION:SET-WAIT-STATE("").

/* Preprocesadores de configuraci¢n */

&GLOBAL-DEFINE CONDICION PL-FLG-MES.CodCia = s-CodCia AND ~
PL-FLG-MES.Periodo = s-Periodo AND PL-FLG-MES.NroMes = s-NroMes AND ~
PL-FLG-MES.CodPln = x-CodPln AND PL-FLG-MES.SitAct <> 'Inactivo'

&GLOBAL-DEFINE CODIGO PL-FLG-MES.codper

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME H-Dialog
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-FLG-MES

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 integral.PL-FLG-MES.codper x-Nombre 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH integral.PL-FLG-MES ~
      WHERE PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.NroMes = s-NroMes ~
 AND PL-FLG-MES.codpln = x-CodPln ~
 AND PL-FLG-MES.SitAct <> 'Inactivo' ~
 AND PL-FLG-MES.Seccion = X-SECCION NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH integral.PL-FLG-MES ~
      WHERE PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.NroMes = s-NroMes ~
 AND PL-FLG-MES.codpln = x-CodPln ~
 AND PL-FLG-MES.SitAct <> 'Inactivo' ~
 AND PL-FLG-MES.Seccion = X-SECCION NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 integral.PL-FLG-MES
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 integral.PL-FLG-MES


/* Definitions for DIALOG-BOX H-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-H-Dialog ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-6 FILL-IN-CODIGO FILL-IN-NOMBRE ~
BROWSE-1 Btn_Cancel Btn_Help Btn_OK 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CODIGO FILL-IN-NOMBRE 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel":U
     LABEL "&Cancelar" 
     SIZE 11.57 BY 1.69
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     IMAGE-UP FILE "img/b-ayuda":U
     LABEL "&Ayuda" 
     SIZE 11.57 BY 1.69
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok":U
     LABEL "&Aceptar" 
     SIZE 11.57 BY 1.69
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-CODIGO AS CHARACTER FORMAT "X(6)":U 
     LABEL "Buscar el código" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NOMBRE AS CHARACTER FORMAT "X(256)":U 
     LABEL "Buscar por Nombre" 
     VIEW-AS FILL-IN 
     SIZE 34.57 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51.57 BY 2.31.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51.57 BY 2.58.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      integral.PL-FLG-MES SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 H-Dialog _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      integral.PL-FLG-MES.codper FORMAT "X(8)":U
      x-Nombre COLUMN-LABEL "Apellidos y nombres" FORMAT "x(60)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 51.57 BY 10.62
         BGCOLOR 15 FGCOLOR 4 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME H-Dialog
     FILL-IN-CODIGO AT ROW 1.27 COL 14.43 COLON-ALIGNED
     FILL-IN-NOMBRE AT ROW 2.19 COL 2.57
     BROWSE-1 AT ROW 3.38 COL 1
     Btn_Cancel AT ROW 14.42 COL 21
     Btn_Help AT ROW 14.42 COL 39
     Btn_OK AT ROW 14.46 COL 3.14
     RECT-4 AT ROW 1 COL 1
     RECT-6 AT ROW 14.08 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Empleados".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB H-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX H-Dialog
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-1 FILL-IN-NOMBRE H-Dialog */
ASSIGN 
       FRAME H-Dialog:SCROLLABLE       = FALSE
       FRAME H-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-NOMBRE IN FRAME H-Dialog
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "integral.PL-FLG-MES"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "PL-FLG-MES.CodCia = s-CodCia
 AND PL-FLG-MES.Periodo = s-Periodo
 AND PL-FLG-MES.NroMes = s-NroMes
 AND PL-FLG-MES.codpln = x-CodPln
 AND PL-FLG-MES.SitAct <> 'Inactivo'
 AND PL-FLG-MES.Seccion = X-SECCION"
     _FldNameList[1]   > integral.PL-FLG-MES.codper
"codper" ? "X(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"x-Nombre" "Apellidos y nombres" "x(60)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX H-Dialog
/* Query rebuild information for DIALOG-BOX H-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX H-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME H-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL H-Dialog H-Dialog
ON GO OF FRAME H-Dialog /* Empleados */
DO:
    &IF "{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}" <> "" &THEN
        ROWID-RETURN = ROWID( {&TABLES-IN-QUERY-{&BROWSE-NAME}} ).
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL H-Dialog H-Dialog
ON WINDOW-CLOSE OF FRAME H-Dialog /* Empleados */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 H-Dialog
ON MOUSE-SELECT-DBLCLICK OF BROWSE-1 IN FRAME H-Dialog
OR RETURN OF BROWSE-1
DO:
    APPLY "CHOOSE":U TO Btn_OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help H-Dialog
ON CHOOSE OF Btn_Help IN FRAME H-Dialog /* Ayuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
    MESSAGE "Ayuda para el Archivo: {&FILE-NAME}" 
        VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CODIGO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CODIGO H-Dialog
ON LEAVE OF FILL-IN-CODIGO IN FRAME H-Dialog /* Buscar el código */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND FIRST integral.PL-FLG-MES WHERE
        integral.PL-FLG-MES.CodCia = s-CodCia AND
        integral.PL-FLG-MES.Periodo = s-Periodo AND
        integral.PL-FLG-MES.NroMes = s-NroMes AND
        integral.PL-FLG-MES.codpln = x-CodPln AND
        integral.PL-FLG-MES.Codper = INPUT FILL-IN-CODIGO AND
        integral.PL-FLG-MES.SitAct = 'Activo' AND
        integral.PL-FLG-MES.Seccion = X-SECCION NO-LOCK NO-ERROR.
     SELF:SCREEN-VALUE = "".
     IF NOT AVAILABLE integral.PL-FLG-MES THEN DO:
        BELL.
        MESSAGE "REGISTRO NO ENCONTRADO" VIEW-AS ALERT-BOX ERROR.
        RETURN.
     END.
     ROWID-BROWSE-1 = ROWID( {&TABLES-IN-QUERY-{&BROWSE-NAME}} ).
     REPOSITION {&BROWSE-NAME} TO ROWID ROWID-BROWSE-1 NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NOMBRE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NOMBRE H-Dialog
ON LEAVE OF FILL-IN-NOMBRE IN FRAME H-Dialog /* Buscar por Nombre */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND FIRST integral.PL-PERS WHERE
        integral.PL-PERS.Patper BEGINS INPUT FILL-IN-NOMBRE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.Pl-PERS THEN DO:
        MESSAGE "REGISTRO NO ENCONTRADO" VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = "".
        RETURN.
    END.
     
    REPEAT:
        FIND FIRST integral.PL-FLG-MES WHERE
            integral.PL-FLG-MES.CodCia = s-CodCia AND
            integral.PL-FLG-MES.Periodo = s-Periodo AND
            integral.PL-FLG-MES.NroMes = s-NroMes AND
            integral.PL-FLG-MES.CodPln = x-CodPln AND
            integral.PL-FLG-MES.CodPer = integral.PL-PERS.CodPer AND
            integral.PL-FLG-MES.SitAct = 'Activo' AND
            integral.Pl-FLG-MES.Seccion = X-SECCION            
            NO-LOCK NO-ERROR.
        IF AVAILABLE integral.Pl-Flg-MES THEN LEAVE.
        FIND NEXT integral.PL-PERS WHERE
            integral.PL-PERS.Patper BEGINS INPUT FILL-IN-NOMBRE NO-LOCK NO-ERROR.
    END.
    SELF:SCREEN-VALUE = "".
    IF NOT AVAILABLE integral.PL-FLG-MES THEN DO:
        BELL.
        MESSAGE "REGISTRO NO ENCONTRADO" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    ROWID-BROWSE-1 = ROWID( integral.Pl-Flg-MES ).
    REPOSITION {&BROWSE-NAME} TO ROWID ROWID-BROWSE-1 NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK H-Dialog 


/* ***************************  Main Block  *************************** */

ON FIND OF PL-FLG-MES DO:
    FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-MES.CodPer NO-LOCK NO-ERROR.
    IF AVAILABLE PL-PERS THEN
        ASSIGN
            x-Nombre = integral.PL-PERS.patper + " " +
            integral.PL-PERS.matper + ", " + integral.PL-PERS.nomper.
    ELSE ASSIGN x-Nombre = "".
END.

&IF "{&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}" <> ""
&THEN &UNDEFINE OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}
&ENDIF

{&OPEN-QUERY-{&BROWSE-NAME}}

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available H-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI H-Dialog  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME H-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI H-Dialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-CODIGO FILL-IN-NOMBRE 
      WITH FRAME H-Dialog.
  ENABLE RECT-4 RECT-6 FILL-IN-CODIGO FILL-IN-NOMBRE BROWSE-1 Btn_Cancel 
         Btn_Help Btn_OK 
      WITH FRAME H-Dialog.
  VIEW FRAME H-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-H-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records H-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.PL-FLG-MES"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed H-Dialog 
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

