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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR cl-codcia AS INT NO-UNDO.

DEF VAR cDesDiv AS CHAR NO-UNDO.
DEF VAR lOpt    AS LOG NO-UNDO.

FIND FIRST Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.

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
&Scoped-define EXTERNAL-TABLES VtaCRecl
&Scoped-define FIRST-EXTERNAL-TABLE VtaCRecl


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaCRecl.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS VtaCRecl.NroDoc VtaCRecl.FchRcl ~
VtaCRecl.CodDiv VtaCRecl.UsrRcl VtaCRecl.Libre_f05 VtaCRecl.CodCli ~
VtaCRecl.NomCli VtaCRecl.Libre_c01 VtaCRecl.codref VtaCRecl.NroRef ~
VtaCRecl.TipRcl VtaCRecl.DesRcl VtaCRecl.GloRcl 
&Scoped-define ENABLED-TABLES VtaCRecl
&Scoped-define FIRST-ENABLED-TABLE VtaCRecl
&Scoped-Define DISPLAYED-FIELDS VtaCRecl.NroDoc VtaCRecl.FchRcl ~
VtaCRecl.CodDiv VtaCRecl.UsrRcl VtaCRecl.Libre_f05 VtaCRecl.CodCli ~
VtaCRecl.NomCli VtaCRecl.Libre_c01 VtaCRecl.codref VtaCRecl.NroRef ~
VtaCRecl.TipRcl VtaCRecl.DesRcl VtaCRecl.GloRcl 
&Scoped-define DISPLAYED-TABLES VtaCRecl
&Scoped-define FIRST-DISPLAYED-TABLE VtaCRecl
&Scoped-Define DISPLAYED-OBJECTS x-division 

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
DEFINE VARIABLE x-division AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .81
     BGCOLOR 15 FONT 6 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     VtaCRecl.NroDoc AT ROW 1.19 COL 8.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaCRecl.FchRcl AT ROW 1.19 COL 81 COLON-ALIGNED
          LABEL "Fch Reclamo"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     VtaCRecl.CodDiv AT ROW 2.08 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     x-division AT ROW 2.08 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     VtaCRecl.UsrRcl AT ROW 2.12 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaCRecl.Libre_f05 AT ROW 3.04 COL 81 COLON-ALIGNED WIDGET-ID 6
          LABEL "Fch Modifica"
          VIEW-AS FILL-IN 
          SIZE 17.86 BY .81
     VtaCRecl.CodCli AT ROW 3.15 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaCRecl.NomCli AT ROW 3.15 COL 23 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 41 BY .81
     VtaCRecl.Libre_c01 AT ROW 3.96 COL 81 COLON-ALIGNED WIDGET-ID 4
          LABEL "Usuario Modifica" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaCRecl.codref AT ROW 4.15 COL 9 COLON-ALIGNED
          LABEL "Documento"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "FAC","BOL","N/D","N/C" 
          DROP-DOWN-LIST
          SIZE 7 BY 1
     VtaCRecl.NroRef AT ROW 4.15 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     VtaCRecl.TipRcl AT ROW 5.12 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     VtaCRecl.DesRcl AT ROW 5.12 COL 23 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 29 BY .81
     VtaCRecl.GloRcl AT ROW 6.31 COL 11.29 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 56 BY 6.54
     "Detalle:" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 5.27 COL 5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.VtaCRecl
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
         HEIGHT             = 13.38
         WIDTH              = 102.72.
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
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX VtaCRecl.codref IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCRecl.FchRcl IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCRecl.Libre_c01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN VtaCRecl.Libre_f05 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN x-division IN FRAME F-Main
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

&Scoped-define SELF-NAME VtaCRecl.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCRecl.CodCli V-table-Win
ON LEAVE OF VtaCRecl.CodCli IN FRAME F-Main /* Cliente */
DO:
  VtaCRecl.NomCli:SCREEN-VALUE = ''.
  FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
    AND Gn-clie.codcli = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-clie THEN VtaCRecl.NomCli:SCREEN-VALUE = Gn-clie.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCRecl.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCRecl.CodDiv V-table-Win
ON LEAVE OF VtaCRecl.CodDiv IN FRAME F-Main /* Division */
DO:
  FIND gn-divi WHERE gn-divi.codcia = s-codcia
      AND gn-divi.coddiv = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-divi THEN x-division:SCREEN-VALUE = gn-divi.desdiv.
  ELSE x-division:SCREEN-VALUE = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCRecl.TipRcl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCRecl.TipRcl V-table-Win
ON LEAVE OF VtaCRecl.TipRcl IN FRAME F-Main /* Tipo */
DO:
  FIND FacTabla WHERE FacTabla.codcia = s-codcia
    AND FacTabla.tabla = 'RC'
    AND FacTabla.codigo = SELF:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF AVAILABLE FacTabla THEN DO:
    VtaCRecl.DesRcl:SCREEN-VALUE = FacTabla.Nombre.
    IF SELF:SCREEN-VALUE = 'Otros'
    THEN VtaCRecl.DesRcl:SENSITIVE = YES.
    ELSE VtaCRecl.DesRcl:SENSITIVE = NO.
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
  {src/adm/template/row-list.i "VtaCRecl"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaCRecl"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FIRST FacCorre WHERE FacCorre.codcia = s-codcia
    AND FacCorre.coddoc = s-coddoc
      AND FacCorre.flgest = YES
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'Correlativo no configurado para el documento' s-coddoc
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
    IF AVAIL gn-divi THEN cDesDiv = gn-divi.desdiv. 
    DISPLAY
        TODAY @ VtaCRecl.FchRcl 
        STRING(FacCorre.nroser, '999') + STRING(FacCorre.correlativo, '999999') @ VtaCRecl.NroDoc 
        s-coddiv @ VtaCRecl.CodDiv
        cDesDiv @ x-division
        s-user-id @ VtaCRecl.UsrRcl.
    lOpt = NO.
  END.

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

  IF lOpt = YES THEN DO:
      ASSIGN 
          VtaCRecl.libre_f05 = DATETIME(TODAY,MTIME)
          VtaCRecl.libre_c01 = s-user-id.
      DISPLAY 
          DATETIME(TODAY,MTIME) @ VtaCRecl.libre_f05
          s-user-id @ VtaCRecl.libre_c01 
          WITH FRAME {&FRAME-NAME}.
  END.

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
  FIND FIRST FacCorre WHERE FacCorre.codcia = s-codcia
    AND FacCorre.coddoc = s-coddoc
      AND FacCorre.flgest = YES
    EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'No se pudo bloquera el Correlativo'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    VtaCRecl.codcia = s-codcia
    VtaCRecl.CodDiv = s-coddiv
    VtaCRecl.CodDoc = s-coddoc
    VtaCRecl.NroDoc = STRING(FacCorre.nroser, '999') + STRING(FacCorre.correlativo, '999999')
    VtaCRecl.HorRcl = STRING(TIME, 'HH:MM').
  ASSIGN
    FacCorre.correlativo = FacCorre.correlativo + 1.
  RELEASE FacCorre.

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
      FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
          AND gn-divi.coddiv = VtaCRecl.CodDiv NO-LOCK NO-ERROR.
      IF AVAIL gn-divi THEN cDesDiv = gn-divi.desdiv. 
      DISPLAY cDesDiv @ x-division.          
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
    ASSIGN
        VtaCRecl.NroDoc:SENSITIVE = NO
        /*VtaCRecl.CodDiv:SENSITIVE = NO*/
        VtaCRecl.FchRcl:SENSITIVE = NO        
        VtaCRecl.NomCli:SENSITIVE = NO
        VtaCRecl.UsrRcl:SENSITIVE = NO
        VtaCRecl.DesRcl:SENSITIVE = NO
        VtaCRecl.Libre_c01:SENSITIVE = NO
        VtaCRecl.Libre_f05:SENSITIVE = NO.
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
        WHEN "TipRcl" THEN 
            ASSIGN
                input-var-1 = "RC"
                input-var-2 = ""
                input-var-3 = "".
        WHEN "nroref" THEN 
            ASSIGN
                input-var-1 = VtaCRecl.codref:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                input-var-2 = VtaCRecl.codcli:SCREEN-VALUE IN FRAME {&FRAME-NAME}
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
  {src/adm/template/snd-list.i "VtaCRecl"}

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
    FIND gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = INPUT VtaCRecl.CodDiv
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-divi THEN DO:
        MESSAGE 'División no registrada' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
        AND Gn-clie.codcli = INPUT VtaCRecl.CodCli
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-clie THEN DO:
        MESSAGE 'Cliente no registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF gn-clie.FlgSit = "I" THEN DO:
       MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".   
    END.
    IF gn-clie.FlgSit = "C" THEN DO:
       MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".   
    END.
    FIND FacTabla WHERE FacTabla.codcia = s-codcia
        AND FacTabla.tabla = 'RC'
        AND FacTabla.codigo = INPUT VtaCRecl.TipRcl
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacTabla THEN DO:
        MESSAGE 'Tipo de Reclamo errado' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = VtaCRecl.codref:SCREEN-VALUE
        AND Ccbcdocu.nrodoc = VtaCRecl.nroref:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN DO:
        MESSAGE 'Documento de referencia no registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF Ccbcdocu.codcli <> VtaCRecl.CodCli:SCREEN-VALUE THEN DO:
        MESSAGE 'Documento de referencia no corresponde al cliente' VIEW-AS ALERT-BOX ERROR.
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
  IF AVAILABLE Vtacrecl AND Vtacrecl.flgrcl <> 'R' THEN DO:
    MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  lOpt = YES.
  RETURN "OK".  
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

