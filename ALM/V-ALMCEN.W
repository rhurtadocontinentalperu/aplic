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

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR S-CODCIA AS INTEGER.

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
&Scoped-define EXTERNAL-TABLES Almacen
&Scoped-define FIRST-EXTERNAL-TABLE Almacen


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almacen.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almacen.Campo-C[1] Almacen.AlmCsg ~
Almacen.TpoCsg Almacen.CodCli Almacen.Campo-C[10] Almacen.DirAlm ~
Almacen.EncAlm Almacen.Campo-C[5] Almacen.CodDiv Almacen.TelAlm ~
Almacen.HorRec Almacen.Campo-C[2] Almacen.Campo-C[7] Almacen.Campo-C[3] ~
Almacen.Campo-C[6] Almacen.Campo-Log[1] 
&Scoped-define ENABLED-TABLES Almacen
&Scoped-define FIRST-ENABLED-TABLE Almacen
&Scoped-Define DISPLAYED-FIELDS Almacen.Campo-C[1] Almacen.AlmCsg ~
Almacen.TpoCsg Almacen.CodCli Almacen.Campo-C[10] Almacen.DirAlm ~
Almacen.EncAlm Almacen.Campo-C[5] Almacen.CodDiv Almacen.TelAlm ~
Almacen.HorRec Almacen.Campo-C[2] Almacen.Campo-C[7] Almacen.Campo-C[3] ~
Almacen.Campo-C[6] Almacen.Campo-Log[1] 
&Scoped-define DISPLAYED-TABLES Almacen
&Scoped-define FIRST-DISPLAYED-TABLE Almacen
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-TpoSvc F-NomDiv 

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
DEFINE VARIABLE F-NomDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .85 NO-UNDO.

DEFINE VARIABLE FILL-IN-TpoSvc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almacen.Campo-C[1] AT ROW 1.19 COL 9 COLON-ALIGNED
          LABEL "Clasificación"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "ALMACEN","ALMACEN"
          DROP-DOWN-LIST
          SIZE 16 BY 1
     Almacen.AlmCsg AT ROW 1.19 COL 30
          LABEL "Almacen de Consignacion"
          VIEW-AS TOGGLE-BOX
          SIZE 21.29 BY .77
     Almacen.TpoCsg AT ROW 1.19 COL 57 COLON-ALIGNED
          LABEL "Tipo Csg."
          VIEW-AS COMBO-BOX INNER-LINES 3
          LIST-ITEMS "C","P" 
          DROP-DOWN-LIST
          SIZE 5.86 BY 1
     Almacen.CodCli AT ROW 1.19 COL 72 COLON-ALIGNED
          LABEL "Ruc" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .85
     Almacen.Campo-C[10] AT ROW 2.15 COL 9 COLON-ALIGNED WIDGET-ID 44
          LABEL "Tpo Servicio" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FILL-IN-TpoSvc AT ROW 2.15 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     Almacen.DirAlm AT ROW 3.12 COL 9 COLON-ALIGNED FORMAT "X(120)"
          VIEW-AS FILL-IN 
          SIZE 62 BY .85
     Almacen.EncAlm AT ROW 4.08 COL 9 COLON-ALIGNED
          LABEL "Encargado"
          VIEW-AS FILL-IN 
          SIZE 30 BY .85
     Almacen.Campo-C[5] AT ROW 4.08 COL 72 COLON-ALIGNED WIDGET-ID 28
          LABEL "Localizacion" FORMAT "X(13)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     Almacen.CodDiv AT ROW 5.04 COL 9 COLON-ALIGNED
          LABEL "Local" FORMAT "XXXXX"
          VIEW-AS FILL-IN 
          SIZE 6.43 BY .85
     F-NomDiv AT ROW 5.04 COL 16 COLON-ALIGNED NO-LABEL
     Almacen.TelAlm AT ROW 5.04 COL 72 COLON-ALIGNED
          LABEL "Telefono"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .85
     Almacen.HorRec AT ROW 6 COL 9 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 62 BY .85
     Almacen.Campo-C[2] AT ROW 7.15 COL 21 NO-LABEL WIDGET-ID 2
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Ambos", "",
"Mayorista", "1":U,
"Minorista", "2":U
          SIZE 12 BY 1.85
          BGCOLOR 15 FGCOLOR 0 
     Almacen.Campo-C[7] AT ROW 7.15 COL 54 NO-LABEL WIDGET-ID 38
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Por Rotación", "",
"Por Reposición en Unidades de Stock", "REU":U,
"Por Reposición en Unidades de Empaque", "REE":U,
"UTILEX", "RUT":U
          SIZE 32 BY 3.46
     Almacen.Campo-C[3] AT ROW 9.08 COL 21 NO-LABEL WIDGET-ID 20
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "No", "",
"Si", "Si":U
          SIZE 12 BY .81
     Almacen.Campo-C[6] AT ROW 10.04 COL 21 NO-LABEL WIDGET-ID 30
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "No", "No":U,
"Si", "Si":U
          SIZE 12 BY .73
     Almacen.Campo-Log[1] AT ROW 10.96 COL 20.72 WIDGET-ID 52
          LABEL "NO controlar STOCK"
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .77
     "Horario de" VIEW-AS TEXT
          SIZE 7.43 BY .5 AT ROW 6.58 COL 2
     "Recepcion" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6 COL 2
     "Tipo de Almacén:" VIEW-AS TEXT
          SIZE 13 BY .77 AT ROW 7.15 COL 8 WIDGET-ID 16
          BGCOLOR 15 FGCOLOR 0 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Almacén de Remate?:" VIEW-AS TEXT
          SIZE 15 BY .77 AT ROW 9.08 COL 5 WIDGET-ID 24
     "Almacén Comercial?:" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 10.04 COL 6 WIDGET-ID 34
     "TIPO DE REPOSICION:" VIEW-AS TEXT
          SIZE 17 BY .5 AT ROW 7.35 COL 36 WIDGET-ID 42
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Almacen
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
         HEIGHT             = 12.77
         WIDTH              = 98.72.
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

/* SETTINGS FOR TOGGLE-BOX Almacen.AlmCsg IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almacen.Campo-C[10] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR COMBO-BOX Almacen.Campo-C[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almacen.Campo-C[5] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR TOGGLE-BOX Almacen.Campo-Log[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almacen.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almacen.CodDiv IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almacen.DirAlm IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almacen.EncAlm IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-NomDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TpoSvc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almacen.HorRec IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almacen.TelAlm IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX Almacen.TpoCsg IN FRAME F-Main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME Almacen.AlmCsg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almacen.AlmCsg V-table-Win
ON VALUE-CHANGED OF Almacen.AlmCsg IN FRAME F-Main /* Almacen de Consignacion */
DO:
  Almacen.TpoCsg:SENSITIVE = INPUT Almacen.AlmCsg.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almacen.Campo-C[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almacen.Campo-C[10] V-table-Win
ON LEAVE OF Almacen.Campo-C[10] IN FRAME F-Main /* Tpo Servicio */
DO:
  FIND almtabla WHERE almtabla.Tabla = "SV"
      AND almtabla.Codigo = Almacen.Campo-c[10]:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtabla THEN FILL-IN-TpoSvc:SCREEN-VALUE = almtabla.Nombre.
  ELSE FILL-IN-TpoSvc:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almacen.Campo-C[10] V-table-Win
ON LEFT-MOUSE-DBLCLICK OF Almacen.Campo-C[10] IN FRAME F-Main /* Tpo Servicio */
OR F8 OF Almacen.Campo-C[10]
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


&Scoped-define SELF-NAME Almacen.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almacen.CodDiv V-table-Win
ON LEAVE OF Almacen.CodDiv IN FRAME F-Main /* Local */
DO:
  IF Almacen.CodDiv:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-divi WHERE gn-divi.CodCia = S-CODCIA AND
       gn-divi.CodDiv = Almacen.CodDiv:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-divi THEN F-NomDiv:SCREEN-VALUE = gn-divi.DesDiv.
  ELSE DO:
     MESSAGE "Codigo del local no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
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
  {src/adm/template/row-list.i "Almacen"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almacen"}

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
  DEF VAR pEvento AS CHAR NO-UNDO.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN pEvento = 'CREATE'.
  ELSE pEvento = 'UPDATE'.

  RUN lib/logtabla (
      INPUT 'Almacen',
      INPUT ( 'Almacen=' + Almacen.CodAlm + '|' +
              'Consignacion=' + STRING(Almacen.AlmCsg) + '|' +
              'Local=' + Almacen.CodDiv + '|' +
              'Tipo=' + Almacen.Campo-C[2] + '|' +
              'Remate=' + Almacen.Campo-C[3] + '|' +
              'Comercial=' + Almacen.Campo-C[7]
              ),
      INPUT pEvento).

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
  IF AVAILABLE Almacen THEN DO WITH FRAME {&FRAME-NAME}:
     FIND gn-divi WHERE gn-divi.CodCia = S-CODCIA AND
          gn-divi.CodDiv = Almacen.CodDiv NO-LOCK NO-ERROR.
     IF AVAILABLE gn-divi THEN F-NomDiv:SCREEN-VALUE = gn-divi.DesDiv.
     ELSE F-NomDiv:SCREEN-VALUE = "".
     FIND almtabla WHERE almtabla.Tabla = "SV"
         AND almtabla.Codigo = Almacen.Campo-c[10]
         NO-LOCK NO-ERROR.
     IF AVAILABLE Almtabla THEN FILL-IN-TpoSvc:SCREEN-VALUE =  almtabla.Nombre.
     ELSE FILL-IN-TpoSvc:SCREEN-VALUE = "".
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  Almacen.Campo-C[1]:DELETE(1) IN FRAME {&FRAME-NAME}.
  FOR EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = s-CodCia
      AND FacTabla.Tabla = "CLFALM"
      BREAK BY FacTabla.Codcia:
      Almacen.Campo-C[1]:ADD-LAST(FacTabla.Nombre,FacTabla.Codigo) IN FRAME {&FRAME-NAME}.
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
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  {src/adm/template/snd-list.i "Almacen"}

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
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
     Almacen.TpoCsg:SENSITIVE = Almacen.AlmCsg.
  END.
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

DO WITH FRAME {&FRAME-NAME} :
    IF Almacen.Campo-C[10]:SCREEN-VALUE <> "" THEN DO:
        FIND almtabla WHERE almtabla.Tabla = "SV"
         AND almtabla.Codigo = Almacen.Campo-c[10]:SCREEN-VALUE
         NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtabla THEN DO:
            MESSAGE 'Tipo de Servicio NO registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO Almacen.Campo-c[10].
            RETURN 'ADM-ERROR'.
        END.
    END.
END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

