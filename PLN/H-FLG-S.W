&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

WAIT-STATE = SESSION:SET-WAIT-STATE("").

/* Preprocesadores de configuraci¢n */

&GLOBAL-DEFINE CONDICION PL-FLG-SEM.CodCia = s-CodCia AND PL-FLG-SEM.Periodo = s-Periodo AND PL-FLG-SEM.NroMes = s-NroSem AND PL-FLG-SEM.CodPln = x-CodPln AND PL-FLG-SEM.SitAct <> 'Inactivo'

&GLOBAL-DEFINE CODIGO PL-FLG-SEM.codper

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME H-Dialog
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-FLG-SEM

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 integral.PL-FLG-SEM.codper x-Nombre 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH integral.PL-FLG-SEM ~
      WHERE PL-FLG-SEM.CodCia = s-CodCia ~
 AND PL-FLG-SEM.Periodo = s-Periodo ~
 AND PL-FLG-SEM.NroSem = s-NroSem ~
 AND PL-FLG-SEM.codpln = x-CodPln ~
 AND PL-FLG-SEM.SitAct <> 'Inactivo' NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 integral.PL-FLG-SEM
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 integral.PL-FLG-SEM


/* Definitions for DIALOG-BOX H-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-H-Dialog ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-6 BROWSE-1 Btn_OK FILL-IN-CODIGO ~
FILL-IN-NOMBRE Btn_Cancel Btn_Help 
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
     LABEL "Buscar el c¢digo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NOMBRE AS CHARACTER FORMAT "X(256)":U 
     LABEL "Buscar por Nombre" 
     VIEW-AS FILL-IN 
     SIZE 35.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 56.43 BY 2.08.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL 
     SIZE 56.43 BY 2.58.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      integral.PL-FLG-SEM SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 H-Dialog _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      integral.PL-FLG-SEM.codper
      x-Nombre COLUMN-LABEL "Apellidos y nombres" FORMAT "x(80)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 56.43 BY 10.73
         BGCOLOR 15 FGCOLOR 4 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME H-Dialog
     BROWSE-1 AT ROW 3.12 COL 1
     Btn_OK AT ROW 14.23 COL 5.43
     FILL-IN-CODIGO AT ROW 1.12 COL 16.72 COLON-ALIGNED
     FILL-IN-NOMBRE AT ROW 2 COL 4.86
     Btn_Cancel AT ROW 14.23 COL 23.43
     Btn_Help AT ROW 14.23 COL 40.86
     RECT-4 AT ROW 1 COL 1
     RECT-6 AT ROW 13.88 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Consulta Obreros".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX H-Dialog
                                                                        */
/* BROWSE-TAB BROWSE-1 RECT-6 H-Dialog */
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
     _TblList          = "integral.PL-FLG-SEM"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "PL-FLG-SEM.CodCia = s-CodCia
 AND PL-FLG-SEM.Periodo = s-Periodo
 AND PL-FLG-SEM.NroSem = s-NroSem
 AND PL-FLG-SEM.codpln = x-CodPln
 AND PL-FLG-SEM.SitAct <> 'Inactivo'"
     _FldNameList[1]   = integral.PL-FLG-SEM.codper
     _FldNameList[2]   > "_<CALC>"
"x-Nombre" "Apellidos y nombres" "x(80)" ? ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX H-Dialog
/* Query rebuild information for DIALOG-BOX H-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX H-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB H-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME H-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL H-Dialog H-Dialog
ON GO OF FRAME H-Dialog /* Consulta Obreros */
DO:
    &IF "{&TABLES-IN-QUERY-{&BROWSE-NAME}}" <> "" &THEN
        ROWID-RETURN = ROWID( {&TABLES-IN-QUERY-{&BROWSE-NAME}} ).
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL H-Dialog H-Dialog
ON WINDOW-CLOSE OF FRAME H-Dialog /* Consulta Obreros */
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
ON LEAVE OF FILL-IN-CODIGO IN FRAME H-Dialog /* Buscar el c¢digo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND FIRST integral.PL-FLG-SEM WHERE
               integral.PL-FLG-SEM.Codper  = INPUT FILL-IN-CODIGO 
           AND integral.PL-FLG-SEM.CodCia  = s-CodCia
           AND integral.PL-FLG-SEM.Periodo = s-Periodo
           AND integral.PL-FLG-SEM.NroSem  = s-NroSem
           AND integral.PL-FLG-SEM.codpln  = x-CodPln
           AND integral.PL-FLG-SEM.SitAct  = 'Activo' 
           NO-LOCK NO-ERROR.
     SELF:SCREEN-VALUE = "".
     IF NOT AVAILABLE integral.Pl-Flg-Sem 
     THEN DO:
        MESSAGE "REGISTRO NO ENCONTRADO" VIEW-AS ALERT-BOX ERROR.
        RETURN.
     END.
     ROWID-BROWSE-1 = ROWID( integral.Pl-Flg-Sem ).
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
               integral.PL-PERS.Patper  BEGINS INPUT FILL-IN-NOMBRE
                NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.Pl-PERS
    THEN DO:
        MESSAGE "REGISTRO NO ENCONTRADO" VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = "".
        RETURN.
    END.
     
    REPEAT:
        FIND FIRST integral.PL-FLG-SEM WHERE
                   integral.PL-FLG-SEM.Codper  = integral.PL-PERS.CodPer
               AND integral.PL-FLG-SEM.CodCia  = s-CodCia
               AND integral.PL-FLG-SEM.Periodo = s-Periodo
               AND integral.PL-FLG-SEM.NroSem  = s-NroSem
               AND integral.PL-FLG-SEM.codpln  = x-CodPln
               AND integral.PL-FLG-SEM.SitAct  = 'Activo' 
               NO-LOCK NO-ERROR.
        IF AVAILABLE integral.Pl-Flg-Sem THEN LEAVE.
        
        FIND NEXT integral.PL-PERS WHERE
               integral.PL-PERS.Patper  BEGINS INPUT FILL-IN-NOMBRE
                NO-LOCK.
    END.    
    SELF:SCREEN-VALUE = "".
    IF NOT AVAILABLE integral.Pl-Flg-Sem 
    THEN DO:
        MESSAGE "REGISTRO NO ENCONTRADO" VIEW-AS ALERT-BOX ERROR.
        RETURN.
     END.
     ROWID-BROWSE-1 = ROWID( integral.Pl-Flg-Sem ).
     REPOSITION {&BROWSE-NAME} TO ROWID ROWID-BROWSE-1 NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK H-Dialog 


/* ***************************  Main Block  *************************** */

ON FIND OF PL-FLG-SEM DO:
    FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-SEM.CodPer NO-LOCK NO-ERROR.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available H-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI H-Dialog _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI H-Dialog _DEFAULT-ENABLE
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
  ENABLE RECT-4 RECT-6 BROWSE-1 Btn_OK FILL-IN-CODIGO FILL-IN-NOMBRE Btn_Cancel 
         Btn_Help 
      WITH FRAME H-Dialog.
  VIEW FRAME H-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-H-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records H-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.PL-FLG-SEM"}

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


