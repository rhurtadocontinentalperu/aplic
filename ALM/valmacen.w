&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject NO-UNDO
       {"aplic/alm/dalmacen.i"}.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*------------------------------------------------------------------------

  File:

  Description: from viewer.w - Template for SmartDataViewer objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

DEF SHARED VAR s-codcia AS INTE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "aplic/alm/dalmacen.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.Campo-C1 RowObject.AlmCsg ~
RowObject.TpoCsg RowObject.CodCli RowObject.Campo-C10 RowObject.DirAlm ~
RowObject.EncAlm RowObject.Campo-C5 RowObject.CodDiv RowObject.TelAlm ~
RowObject.HorRec RowObject.Campo-C7 RowObject.Campo-C2 RowObject.Campo-C3 ~
RowObject.Campo-C6 RowObject.Campo-Log1 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject.Campo-C1 RowObject.AlmCsg ~
RowObject.TpoCsg RowObject.CodCli RowObject.Campo-C10 RowObject.DirAlm ~
RowObject.EncAlm RowObject.Campo-C5 RowObject.CodDiv RowObject.TelAlm ~
RowObject.HorRec RowObject.Campo-C7 RowObject.Campo-C2 RowObject.Campo-C3 ~
RowObject.Campo-C6 RowObject.Campo-Log1 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-TpoSvc F-NomDiv 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-NomDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .85 NO-UNDO.

DEFINE VARIABLE FILL-IN-TpoSvc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RowObject.Campo-C1 AT ROW 1 COL 11 COLON-ALIGNED WIDGET-ID 44
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "ALMACEN","ALMACEN"
          DROP-DOWN-LIST
          SIZE 16 BY 1
     RowObject.AlmCsg AT ROW 1 COL 31 WIDGET-ID 46
          LABEL "Almacén de Consignación"
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .77
     RowObject.TpoCsg AT ROW 1 COL 59 COLON-ALIGNED WIDGET-ID 48
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "C","P" 
          DROP-DOWN-LIST
          SIZE 6 BY 1
     RowObject.CodCli AT ROW 1 COL 72 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .81
     RowObject.Campo-C10 AT ROW 2.08 COL 11 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     FILL-IN-TpoSvc AT ROW 2.08 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 82
     RowObject.DirAlm AT ROW 3.15 COL 11 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 61.43 BY .81
     RowObject.EncAlm AT ROW 4.23 COL 11 COLON-ALIGNED WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .81
     RowObject.Campo-C5 AT ROW 4.23 COL 72 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     RowObject.CodDiv AT ROW 5.31 COL 11 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .81
     F-NomDiv AT ROW 5.31 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     RowObject.TelAlm AT ROW 5.31 COL 72 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     RowObject.HorRec AT ROW 6.38 COL 11 COLON-ALIGNED NO-LABEL WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .81
     RowObject.Campo-C7 AT ROW 7.19 COL 74 NO-LABEL WIDGET-ID 74
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Por Rotación", "",
"Por Reposición en Unidades de Stock", "REU":U,
"Por Reposición en Unidades de Empaque", "REE":U,
"UTILEX", "RUT":U
          SIZE 31 BY 3
     RowObject.Campo-C2 AT ROW 7.46 COL 19 NO-LABEL WIDGET-ID 54
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Ambos", "",
"Mayorista", "1":U,
"Minorista", "2":U
          SIZE 12 BY 1.88
     RowObject.Campo-C3 AT ROW 9.62 COL 18 NO-LABEL WIDGET-ID 60
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "No", "",
"Si", "Si":U
          SIZE 12 BY .81
     RowObject.Campo-C6 AT ROW 10.69 COL 18 NO-LABEL WIDGET-ID 66
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "No", "No":U,
"Si", "Si":U
          SIZE 12 BY .81
     RowObject.Campo-Log1 AT ROW 11.77 COL 18 WIDGET-ID 72
          LABEL "NO controlar STOCK"
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .77
     "Recepción" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6.92 COL 3 WIDGET-ID 52
     "Tipo de Almacén:" VIEW-AS TEXT
          SIZE 13 BY .77 AT ROW 7.46 COL 6 WIDGET-ID 58
     "Almacén de Remate?:" VIEW-AS TEXT
          SIZE 15 BY .77 AT ROW 9.62 COL 2 WIDGET-ID 64
     "Almacén Comercial?:" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 10.69 COL 2 WIDGET-ID 70
     "TIPO DE REPOSICION:" VIEW-AS TEXT
          SIZE 17 BY .5 AT ROW 7.46 COL 57 WIDGET-ID 80
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Horario de" VIEW-AS TEXT
          SIZE 7.43 BY .5 AT ROW 6.38 COL 4 WIDGET-ID 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "aplic\alm\dalmacen.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" NO-UNDO  
      ADDITIONAL-FIELDS:
          {aplic/alm/dalmacen.i}
      END-FIELDS.
   END-TABLES.
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
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 19.35
         WIDTH              = 123.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX RowObject.AlmCsg IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR RADIO-SET RowObject.Campo-C2 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR RADIO-SET RowObject.Campo-C3 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR RADIO-SET RowObject.Campo-C6 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR RADIO-SET RowObject.Campo-C7 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.Campo-Log1 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-NomDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TpoSvc IN FRAME F-Main
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

&Scoped-define SELF-NAME RowObject.Campo-C10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.Campo-C10 vTableWin
ON LEAVE OF RowObject.Campo-C10 IN FRAME F-Main /* Tpo Servicio */
DO:
  FIND almtabla WHERE almtabla.Tabla = "SV"
      AND almtabla.Codigo = RowObject.Campo-c10:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtabla THEN FILL-IN-TpoSvc:SCREEN-VALUE = Almtabla.Nombre.
  ELSE FILL-IN-TpoSvc:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.Campo-C10 vTableWin
ON LEFT-MOUSE-DBLCLICK OF RowObject.Campo-C10 IN FRAME F-Main /* Tpo Servicio */
OR F8 OF RowObject.Campo-C10
DO:
    ASSIGN
        input-var-1 = "SV"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?.
    RUN lkup/C-ALMTAB ("TIPO DE SERVICIO").
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.CodDiv vTableWin
ON LEAVE OF RowObject.CodDiv IN FRAME F-Main /* Local */
DO:
  IF RowObject.CodDiv:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-divi WHERE gn-divi.CodCia = S-CODCIA AND
       gn-divi.CodDiv = RowObject.CodDiv:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-divi THEN F-NomDiv:SCREEN-VALUE = gn-divi.DesDiv.
  ELSE DO:
     MESSAGE "Codigo del local no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields vTableWin 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcColValues).

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     FIND gn-divi WHERE gn-divi.CodCia = S-CODCIA AND
          gn-divi.CodDiv = RowObject.CodDiv:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-divi THEN F-NomDiv:SCREEN-VALUE = gn-divi.DesDiv.
     ELSE F-NomDiv:SCREEN-VALUE = "".
     FIND almtabla WHERE almtabla.Tabla = "SV"
         AND almtabla.Codigo = RowObject.Campo-C10:SCREEN-VALUE
         NO-LOCK NO-ERROR.
     IF AVAILABLE Almtabla THEN FILL-IN-TpoSvc:SCREEN-VALUE =  Almtabla.Nombre.
     ELSE FILL-IN-TpoSvc:SCREEN-VALUE = "".
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros vTableWin 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros vTableWin 
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
MESSAGE HANDLE-CAMPO:name.
    CASE HANDLE-CAMPO:name:
        WHEN "Campo-C" THEN 
            ASSIGN
            input-var-1 = "SV"
            input-var-2 = ""
            input-var-3 = "".
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

