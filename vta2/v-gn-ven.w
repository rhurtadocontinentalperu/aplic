&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
DEF NEW SHARED VAR cb-codcia AS INT INIT 0.

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.

FIND EMPRESAS WHERE EMPRESAS.CODCIA  = S-CodCia NO-LOCK NO-ERROR.
IF AVAIL EMPRESAS THEN DO:
    IF NOT EMPRESAS.CAMPO-CODCBD THEN CB-CODCIA = S-CODCIA.
END.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "".
GET-KEY-VALUE SECTION "Startup" KEY "Base" VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "vta\rbvta.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Vendedores".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "O".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".

DEFINE BUFFER buf-gn-ven FOR gn-ven.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES gn-ven
&Scoped-define FIRST-EXTERNAL-TABLE gn-ven


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-ven.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gn-ven.CodVen gn-ven.Libre_c04 gn-ven.NomVen ~
gn-ven.CCo gn-ven.PtoVta gn-ven.ComPor gn-ven.Libre_c02 gn-ven.flgest ~
gn-ven.Libre_c01 gn-ven.Libre_c03 
&Scoped-define ENABLED-TABLES gn-ven
&Scoped-define FIRST-ENABLED-TABLE gn-ven
&Scoped-Define DISPLAYED-FIELDS gn-ven.CodVen gn-ven.Libre_c04 ~
gn-ven.NomVen gn-ven.CCo gn-ven.PtoVta gn-ven.ComPor gn-ven.Libre_c02 ~
gn-ven.flgest gn-ven.Libre_c01 gn-ven.Libre_c03 
&Scoped-define DISPLAYED-TABLES gn-ven
&Scoped-define FIRST-DISPLAYED-TABLE gn-ven
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Cco FILL-IN-Canal txtNomSup 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-Canal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cco AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE txtNomSup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     gn-ven.CodVen AT ROW 1.19 COL 13 COLON-ALIGNED
          LABEL "Codigo"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     gn-ven.Libre_c04 AT ROW 2.15 COL 13 COLON-ALIGNED WIDGET-ID 32
          LABEL "Código de Planilla" FORMAT "x(6)"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     gn-ven.NomVen AT ROW 3.12 COL 13 COLON-ALIGNED
          LABEL "Nombre"
          VIEW-AS FILL-IN 
          SIZE 49 BY .81
     gn-ven.CCo AT ROW 4.08 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-Cco AT ROW 4.08 COL 19 COLON-ALIGNED NO-LABEL
     gn-ven.PtoVta AT ROW 5.04 COL 13 COLON-ALIGNED
          LABEL "Canal de venta"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-Canal AT ROW 5.04 COL 19 COLON-ALIGNED NO-LABEL
     gn-ven.ComPor AT ROW 6 COL 13 COLON-ALIGNED
          LABEL "% de Comision"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     gn-ven.Libre_c02 AT ROW 6.69 COL 46 NO-LABEL WIDGET-ID 18
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "<Ninguna>", "",
"Norte", "N":U,
"Centro", "C":U,
"Oriente", "O":U,
"Sur", "S":U
          SIZE 16 BY 3.46
     gn-ven.flgest AT ROW 7.08 COL 15 NO-LABEL WIDGET-ID 2
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Activo", "A":U,
"Cesado", "C":U
          SIZE 17 BY 1.08
     gn-ven.Libre_c01 AT ROW 8.42 COL 15 NO-LABEL WIDGET-ID 8
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Todos", "",
"A", "A":U,
"A y B", "B":U
          SIZE 23 BY 1.04
     gn-ven.Libre_c03 AT ROW 10.42 COL 13 COLON-ALIGNED WIDGET-ID 26
          LABEL "Supervisor"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     txtNomSup AT ROW 10.46 COL 21.14 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     "Zona Asignada" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 6.04 COL 45.86 WIDGET-ID 24
          FGCOLOR 4 FONT 6
     "Rotación:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 8.69 COL 8 WIDGET-ID 12
     "Situación:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 7.35 COL 8 WIDGET-ID 6
     "Digite ~"999999~" (sin comillas) para un vendedor genérico" VIEW-AS TEXT
          SIZE 40 BY .5 AT ROW 2.35 COL 24 WIDGET-ID 34
          BGCOLOR 14 FGCOLOR 0 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.gn-ven
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
         HEIGHT             = 11.23
         WIDTH              = 69.14.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN gn-ven.CodVen IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-ven.ComPor IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Canal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Cco IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-ven.Libre_c03 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-ven.Libre_c04 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-ven.NomVen IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-ven.PtoVta IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN txtNomSup IN FRAME F-Main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME gn-ven.CCo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-ven.CCo V-table-Win
ON LEAVE OF gn-ven.CCo IN FRAME F-Main /* Centro de Costo */
DO:
  FILL-IN-Cco:SCREEN-VALUE = ''.
  FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia
    AND cb-auxi.clfaux = 'CCO'
    AND cb-auxi.codaux = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE cb-auxi THEN FILL-IN-Cco:SCREEN-VALUE = cb-auxi.nomaux.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-ven.Libre_c03
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-ven.Libre_c03 V-table-Win
ON LEAVE OF gn-ven.Libre_c03 IN FRAME F-Main /* Supervisor */
DO:
 txtNomSup:SCREEN-VALUE = ''.
  FIND buf-gn-ven WHERE buf-gn-ven.codcia = s-codcia
    AND buf-gn-ven.codven = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE buf-gn-ven THEN txtNomSup:SCREEN-VALUE = buf-gn-ven.nomven.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-ven.Libre_c04
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-ven.Libre_c04 V-table-Win
ON LEAVE OF gn-ven.Libre_c04 IN FRAME F-Main /* Código de Planilla */
DO:
  FIND pl-pers WHERE pl-pers.codper = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers THEN gn-ven.NomVen:SCREEN-VALUE = CAPS( TRIM(pl-pers.patper) + ' ' +
                                                               TRIM(pl-pers.matper) + ', ' +
                                                               pl-pers.nomper  ).
  IF SELF:SCREEN-VALUE = "999999" THEN gn-ven.NomVen:SENSITIVE = YES.
  ELSE gn-ven.NomVen:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-ven.PtoVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-ven.PtoVta V-table-Win
ON LEAVE OF gn-ven.PtoVta IN FRAME F-Main /* Canal de venta */
DO:
  FILL-IN-Canal:SCREEN-VALUE = ''.
  FIND almtabla WHERE almtabla.tabla = 'CV'
    AND almtabla.codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE almtabla THEN FILL-IN-Canal:SCREEN-VALUE = almtabla.Nombre.
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
  {src/adm/template/row-list.i "gn-ven"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gn-ven"}

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
    gn-ven.CodCia = s-codcia.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /*MESSAGE 'NUEVOOOO' VIEW-AS ALERT-BOX ERROR.*/

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
    FILL-IN-Cco:SCREEN-VALUE = ''.
    txtNomSup:SCREEN-VALUE = ''.
    FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia
        AND cb-auxi.clfaux = 'CCO'
        AND cb-auxi.codaux = gn-ven.cco NO-LOCK NO-ERROR.
    IF AVAILABLE cb-auxi THEN FILL-IN-Cco:SCREEN-VALUE = cb-auxi.nomaux.
    FILL-IN-Canal:SCREEN-VALUE = ''.
    FIND almtabla WHERE almtabla.tabla = 'CV'
        AND almtabla.codigo = gn-ven.ptovta NO-LOCK NO-ERROR.
    IF AVAILABLE almtabla THEN FILL-IN-Canal:SCREEN-VALUE = almtabla.Nombre.

    FIND FIRST buf-gn-ven WHERE buf-gn-ven.codcia = s-codcia AND 
        buf-gn-ven.codven = gn-ven.libre_c03 NO-LOCK NO-ERROR.
    IF AVAILABLE buf-gn-ven THEN txtNomSup:SCREEN-VALUE = buf-gn-ven.nomven.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      gn-ven.NomVen:SENSITIVE = NO.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'NO' THEN DO:
          gn-ven.CodVen:SENSITIVE = NO.
          IF gn-ven.Libre_c04 <> "999999" THEN DO:
              /* Buscamos si ya tiene algun movimiento en ventas */
              IF CAN-FIND(FIRST faccpedi WHERE faccpedi.codcia = s-codcia
                          AND faccpedi.coddoc = 'COT'
                          AND faccpedi.codven = gn-ven.codven
                          NO-LOCK)
                  THEN gn-ven.Libre_c04:SENSITIVE = NO.
              IF CAN-FIND(FIRST faccpedi WHERE faccpedi.codcia = s-codcia
                          AND faccpedi.coddoc = 'P/M'
                          AND faccpedi.codven = gn-ven.codven
                          NO-LOCK)
                  THEN gn-ven.Libre_c04:SENSITIVE = NO.
          END.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    RB-FILTER = "Gn-ven.CodCia = " + string(s-codcia).
    RB-OTHER-PARAMETERS = "GsNomCia = " + S-NOMCIA.

    RUN lib\_imprime2.r(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

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
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
PROCEDURE procesa-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
PROCEDURE recoge-parametros :
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
        WHEN "PtoVta" THEN 
            ASSIGN
                input-var-1 = "CV"
                input-var-2 = ""
                input-var-3 = "".
        WHEN "Cco" THEN 
            ASSIGN
                input-var-1 = "CCO"
                input-var-2 = ""
                input-var-3 = "".
    END CASE.

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
  {src/adm/template/snd-list.i "gn-ven"}

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

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

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
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    IF gn-ven.Cco:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'Ingrese el Centro de Costo'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO gn-ven.cco.
        RETURN 'ADM-ERROR'.
    END.
    FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia
        AND cb-auxi.clfaux = 'CCO'
        AND cb-auxi.codaux = gn-ven.Cco:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi THEN DO:
        MESSAGE 'Centro de Costo no registrado'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO gn-ven.cco.
        RETURN 'ADM-ERROR'.
    END.
    IF gn-ven.PtoVta:SCREEN-VALUE <> '' THEN DO:
        FIND almtabla WHERE almtabla.tabla = 'CV'
            AND almtabla.Codigo = gn-ven.PtoVta:SCREEN-VALUE 
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almtabla THEN DO:
            MESSAGE 'Canal de venta no registrado'
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-ven.ptovta.
            RETURN 'ADM-ERROR'.
        END.
    END.

    IF gn-ven.libre_c03:SCREEN-VALUE <> '' THEN DO:
        FIND FIRST buf-gn-ven WHERE buf-gn-ven.codcia = s-codcia AND
            buf-gn-ven.codven = gn-ven.libre_c03:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE buf-gn-ven THEN DO:
            MESSAGE 'Codigo de Supervisor esta ERRADO'
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO gn-ven.libre_c03.
            RETURN 'ADM-ERROR'.
        END.
    END.
  END.
  IF gn-ven.Libre_c04:SCREEN-VALUE <> "999999" THEN DO:
      IF gn-ven.Libre_c04:SCREEN-VALUE = '' THEN DO:
          MESSAGE 'Ingresar el código de planilla' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO gn-ven.Libre_c04.
          RETURN 'ADM-ERROR'.
      END.
      FIND pl-pers WHERE pl-pers.codper = gn-ven.Libre_c04:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF NOT AVAILABLE pl-pers THEN DO:
          MESSAGE 'Código de planilla NO registrado' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO gn-ven.Libre_c04.
          RETURN 'ADM-ERROR'.
      END.
  END.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

