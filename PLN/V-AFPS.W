&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

DEF VAR s-Tabla AS CHAR INIT "11" NO-UNDO.      /* Régimen pensionario SUNAT */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES PL-AFPS
&Scoped-define FIRST-EXTERNAL-TABLE PL-AFPS


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR PL-AFPS.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS PL-AFPS.codafp PL-AFPS.desafp ~
PL-AFPS.Comision-Porcentual-AFP PL-AFPS.Seguro-Invalidez-AFP ~
PL-AFPS.Comision-Fija-AFP PL-AFPS.Fondo-AFP PL-AFPS.banco ~
PL-AFPS.nroctacte-afp PL-AFPS.nroctacte-fondo PL-AFPS.Sunat_Codigo 
&Scoped-define ENABLED-TABLES PL-AFPS
&Scoped-define FIRST-ENABLED-TABLE PL-AFPS
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-4 RECT-5 
&Scoped-Define DISPLAYED-FIELDS PL-AFPS.codafp PL-AFPS.desafp ~
PL-AFPS.Comision-Porcentual-AFP PL-AFPS.Seguro-Invalidez-AFP ~
PL-AFPS.Comision-Fija-AFP PL-AFPS.Fondo-AFP PL-AFPS.banco ~
PL-AFPS.nroctacte-afp PL-AFPS.nroctacte-fondo PL-AFPS.Sunat_Codigo 
&Scoped-define DISPLAYED-TABLES PL-AFPS
&Scoped-define FIRST-DISPLAYED-TABLE PL-AFPS
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_RegPensionario 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN_RegPensionario AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 2.15.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 2.15.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 4.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     PL-AFPS.codafp AT ROW 1.31 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.29 BY .81
     PL-AFPS.desafp AT ROW 2.12 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.72 BY .81
     PL-AFPS.Comision-Porcentual-AFP AT ROW 3.31 COL 20 COLON-ALIGNED
          LABEL "%Comisión PORCENTUAL"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     PL-AFPS.Seguro-Invalidez-AFP AT ROW 3.31 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     PL-AFPS.Comision-Fija-AFP AT ROW 4.08 COL 20 COLON-ALIGNED
          LABEL "%Comisión MIXTA" FORMAT "ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     PL-AFPS.Fondo-AFP AT ROW 4.12 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     PL-AFPS.banco AT ROW 5.35 COL 14.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 40 BY .81
     PL-AFPS.nroctacte-afp AT ROW 6.15 COL 14.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
     PL-AFPS.nroctacte-fondo AT ROW 6.15 COL 42.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
     PL-AFPS.Sunat_Codigo AT ROW 8 COL 19 COLON-ALIGNED WIDGET-ID 2
          LABEL "Régimen Pensionario" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     FILL-IN_RegPensionario AT ROW 8 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     "Equivalente SUNAT" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 7.19 COL 2 WIDGET-ID 4
          BGCOLOR 9 FGCOLOR 15 
     RECT-1 AT ROW 1 COL 1
     RECT-4 AT ROW 7.46 COL 1 WIDGET-ID 6
     RECT-5 AT ROW 3.15 COL 1 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.PL-AFPS
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 9.04
         WIDTH              = 80.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN PL-AFPS.Comision-Fija-AFP IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN PL-AFPS.Comision-Porcentual-AFP IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_RegPensionario IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PL-AFPS.Sunat_Codigo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME PL-AFPS.Sunat_Codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PL-AFPS.Sunat_Codigo V-table-Win
ON LEAVE OF PL-AFPS.Sunat_Codigo IN FRAME F-Main /* Régimen Pensionario */
DO:
  FILL-IN_RegPensionario:SCREEN-VALUE = ''.
  FIND pl-tabla WHERE pl-tabla.codcia = 000 AND
      pl-tabla.tabla = s-tabla AND
      pl-tabla.codigo = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE pl-tabla THEN FILL-IN_RegPensionario:SCREEN-VALUE = pl-tabla.nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PL-AFPS.Sunat_Codigo V-table-Win
ON LEFT-MOUSE-DBLCLICK OF PL-AFPS.Sunat_Codigo IN FRAME F-Main /* Régimen Pensionario */
DO:
  input-var-1 = s-Tabla.
  input-var-2 = ''.
  input-var-3 = ''.
  output-var-1 = ?.
  RUN lkup/c-pltabla.w('Regimen Pensionario SUNAT').
  IF output-var-1 <> ? THEN 
      ASSIGN
      PL-AFPS.Sunat_Codigo:SCREEN-VALUE = output-var-2
      FILL-IN_RegPensionario:SCREEN-VALUE = output-var-3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "PL-AFPS"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "PL-AFPS"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      PL-AFPS.Sunat_Tabla = s-Tabla.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      IF PL-AFPS.Sunat_Codigo > '' THEN DO:
          FILL-IN_RegPensionario:SCREEN-VALUE = "".
          FIND pl-tabla WHERE pl-tabla.codcia = 000 AND
              pl-tabla.tabla = s-Tabla AND
              pl-tabla.codigo = PL-AFPS.Sunat_Codigo
              NO-LOCK NO-ERROR.
          IF AVAILABLE pl-tabla THEN FILL-IN_RegPensionario:SCREEN-VALUE = pl-tabla.nombre.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "PL-AFPS"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    IF PL-AFPS.Sunat_Codigo:SCREEN-VALUE > '' THEN DO:
        FIND pl-tabla WHERE pl-tabla.codcia = 000 AND
            pl-tabla.tabla = s-Tabla AND
            pl-tabla.codigo = PL-AFPS.Sunat_Codigo:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE pl-tabla THEN DO:
            MESSAGE 'Régimen pensionario no válido' VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO PL-AFPS.Sunat_Codigo.
            RETURN 'ADM-ERROR'.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

