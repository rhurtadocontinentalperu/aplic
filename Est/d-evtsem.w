&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          estavtas         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-EvtSemanas NO-UNDO LIKE dwh_Semanas.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
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

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-EvtSemanas

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-EvtSemanas.NroMes ~
T-EvtSemanas.Dim_Week T-EvtSemanas.FecIni T-EvtSemanas.FecFin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH T-EvtSemanas NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-EvtSemanas NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-EvtSemanas
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-EvtSemanas


/* Definitions for DIALOG-BOX gDialog                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-gDialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-Periodo FILL-IN-FchIni BUTTON-2 ~
BROWSE-2 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Periodo FILL-IN-FchIni 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.62.

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-2 
     LABEL "GENERAR" 
     SIZE 15 BY 1.38.

DEFINE VARIABLE FILL-IN-FchIni AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Partida" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      T-EvtSemanas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 gDialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      T-EvtSemanas.NroMes FORMAT "99":U
      T-EvtSemanas.Dim_Week COLUMN-LABEL "Semana" FORMAT ">>>>>9":U
      T-EvtSemanas.FecIni FORMAT "99/99/9999":U
      T-EvtSemanas.FecFin FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 38 BY 12.65 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     FILL-IN-Periodo AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-FchIni AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 4
     BUTTON-2 AT ROW 3.15 COL 36 WIDGET-ID 14
     BROWSE-2 AT ROW 5.31 COL 5 WIDGET-ID 200
     Btn_OK AT ROW 14.73 COL 45
     Btn_Cancel AT ROW 16.35 COL 45
     SPACE(2.71) SKIP(1.02)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "GENERACION DE SEMANAS"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: T-EvtSemanas T "?" NO-UNDO estavtas dwh_Semanas
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 BUTTON-2 gDialog */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.T-EvtSemanas"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.T-EvtSemanas.NroMes
     _FldNameList[2]   > Temp-Tables.T-EvtSemanas.Dim_Week
"T-EvtSemanas.Dim_Week" "Semana" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.T-EvtSemanas.FecIni
     _FldNameList[4]   = Temp-Tables.T-EvtSemanas.FecFin
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* GENERACION DE SEMANAS */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
  MESSAGE 'Se va a proceder a actualizar la tabla de semanas' SKIP
      '¿Procedemos?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO
      UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  FOR EACH dwh_Semanas WHERE dwh_Semanas.CodCia = s-codcia
      AND dwh_Semanas.Periodo = Fill-in-Periodo:
      DELETE dwh_Semanas.
  END.
  FOR EACH T-Evtsemanas:
      CREATE dwh_Semanas.
      BUFFER-COPY T-Evtsemanas TO dwh_Semanas.
      ASSIGN
          dwh_Semanas.codcia = s-codcia
          dwh_Semanas.periodo = FILL-IN-Periodo
          NO-ERROR.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 gDialog
ON CHOOSE OF BUTTON-2 IN FRAME gDialog /* GENERAR */
DO:
  ASSIGN
      FILL-IN-FchIni FILL-IN-Periodo.
  IF FILL-IN-Periodo = 0 OR FILL-IN-FchIni = ? THEN DO:
      MESSAGE 'Ingrese la información completa' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  RUN Llena-Semanas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-Periodo FILL-IN-FchIni 
      WITH FRAME gDialog.
  ENABLE FILL-IN-Periodo FILL-IN-FchIni BUTTON-2 BROWSE-2 Btn_OK Btn_Cancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
      FILL-IN-Periodo = YEAR(TODAY).

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Llena-Semanas gDialog 
PROCEDURE Llena-Semanas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR i AS INT.

EMPTY TEMP-TABLE T-EvtSemanas.

DO i = 1 TO 53:
    CREATE T-EvtSemanas.
    ASSIGN
        T-EvtSemanas.CodCia  = s-CodCia
        T-EvtSemanas.Periodo = FILL-IN-Periodo
        T-EvtSemanas.Dim_Week  = FILL-IN-Periodo * 100 + i
        T-EvtSemanas.FecIni  = FILL-IN-FchIni
        T-EvtSemanas.FecFin  = FILL-IN-FchIni + 6
        T-EvtSemanas.NroMes  = MONTH(T-EvtSemanas.FecFin)
        FILL-IN-FchIni       = FILL-IN-FchIni + 7.
    IF DAY(T-EvtSemanas.FecFin) < 4 
        THEN ASSIGN T-EvtSemanas.NroMes = MONTH(T-EvtSemanas.FecIni).
    IF T-EvtSemanas.Dim_Week = 1 AND YEAR(T-EvtSemanas.FecIni) < FILL-IN-Periodo 
        THEN T-EvtSemanas.NroMes = 1.
END.
FIND LAST T-EvtSemanas WHERE
    T-EvtSemanas.CodCia = s-CodCia AND
    T-EvtSemanas.Periodo = FILL-IN-Periodo NO-ERROR.
IF AVAILABLE T-EvtSemanas AND T-EvtSemanas.NroMes = 1 THEN DELETE T-EvtSemanas.
{&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

