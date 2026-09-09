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

DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE pv-CODCIA AS INTEGER.

DEFINE VARIABLE S-CODMON   AS INTEGER INIT 1.

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
&Scoped-define EXTERNAL-TABLES PR-PRESER
&Scoped-define FIRST-EXTERNAL-TABLE PR-PRESER


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR PR-PRESER.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS PR-PRESER.CodPro PR-PRESER.CodGas ~
PR-PRESER.codmat PR-PRESER.CanDes[1] PR-PRESER.PreLis[1] PR-PRESER.CodMon 
&Scoped-define ENABLED-TABLES PR-PRESER
&Scoped-define FIRST-ENABLED-TABLE PR-PRESER
&Scoped-Define ENABLED-OBJECTS RECT-64 
&Scoped-Define DISPLAYED-FIELDS PR-PRESER.CodPro PR-PRESER.CodGas ~
PR-PRESER.codmat PR-PRESER.UndA PR-PRESER.CanDes[1] PR-PRESER.PreLis[1] ~
PR-PRESER.CodMon 
&Scoped-define DISPLAYED-TABLES PR-PRESER
&Scoped-define FIRST-DISPLAYED-TABLE PR-PRESER
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 FILL-IN-2 FILL-IN-3 

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
DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.72 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.72 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.72 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 6.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     PR-PRESER.CodPro AT ROW 1.62 COL 11 COLON-ALIGNED
          LABEL "Proveedor" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     FILL-IN-1 AT ROW 1.62 COL 23.14 COLON-ALIGNED NO-LABEL
     PR-PRESER.CodGas AT ROW 2.5 COL 11 COLON-ALIGNED
          LABEL "Concepto" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     FILL-IN-2 AT ROW 2.5 COL 23.14 COLON-ALIGNED NO-LABEL
     PR-PRESER.codmat AT ROW 3.38 COL 11 COLON-ALIGNED
          LABEL "Articulo" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     FILL-IN-3 AT ROW 3.38 COL 23.14 COLON-ALIGNED NO-LABEL
     PR-PRESER.UndA AT ROW 4.27 COL 11 COLON-ALIGNED
          LABEL "UM"
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .69
     PR-PRESER.CanDes[1] AT ROW 5.19 COL 11 COLON-ALIGNED
          LABEL "Cantidad"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     PR-PRESER.PreLis[1] AT ROW 6.12 COL 11 COLON-ALIGNED
          LABEL "Precio" FORMAT ">>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .69
     PR-PRESER.CodMon AT ROW 6.12 COL 29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dolares", 2
          SIZE 20.57 BY .69
     RECT-64 AT ROW 1.08 COL 1.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.PR-PRESER
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
         HEIGHT             = 6.92
         WIDTH              = 66.86.
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

/* SETTINGS FOR FILL-IN PR-PRESER.CanDes[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PR-PRESER.CodGas IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN PR-PRESER.codmat IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN PR-PRESER.CodPro IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PR-PRESER.PreLis[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN PR-PRESER.UndA IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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

&Scoped-define SELF-NAME PR-PRESER.CanDes[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PR-PRESER.CanDes[1] V-table-Win
ON LEAVE OF PR-PRESER.CanDes[1] IN FRAME F-Main /* Cantidad */
DO:
   IF DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN .

   /* Valida Maestro Proveedores */
   IF DECI(SELF:SCREEN-VALUE) = 0 THEN DO:
      MESSAGE "Cantidad debe ser mayor que Cero" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PR-PRESER.CodGas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PR-PRESER.CodGas V-table-Win
ON LEAVE OF PR-PRESER.CodGas IN FRAME F-Main /* Concepto */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN .
   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").

   /* Valida Maestro Proveedores */
   FIND PR-Gastos WHERE 
        PR-Gastos.Codcia = S-CODCIA AND  
        PR-Gastos.CodGas = SELF:SCREEN-VALUE         
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE PR-Gastos THEN DO:
      MESSAGE "Codigo de Gastos no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   DISPLAY PR-Gastos.DesGas @ FILL-IN-2   
           WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PR-PRESER.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PR-PRESER.codmat V-table-Win
ON LEAVE OF PR-PRESER.codmat IN FRAME F-Main /* Articulo */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN NO-APPLY.

   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
   /* Valida Maestro Productos */
   FIND Almmmatg WHERE 
        Almmmatg.CodCia = S-CODCIA AND  
        Almmmatg.codmat = SELF:SCREEN-VALUE 
        use-index matg01
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   IF Almmmatg.TpoArt <> "A" THEN DO:
      MESSAGE "Articulo no Activo" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   IF Almmmatg.UndBas = "" THEN DO:
      MESSAGE "Articulo no tiene unidad Base" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.

   DISPLAY Almmmatg.DesMat @ FILL-IN-3
           Almmmatg.UndBas @ PR-PRESER.UndA
           WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PR-PRESER.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PR-PRESER.CodMon V-table-Win
ON VALUE-CHANGED OF PR-PRESER.CodMon IN FRAME F-Main /* Moneda */
DO:
  S-CODMON = INTEGER(PR-PRESER.CodMon:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PR-PRESER.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PR-PRESER.CodPro V-table-Win
ON LEAVE OF PR-PRESER.CodPro IN FRAME F-Main /* Proveedor */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND Gn-Prov WHERE 
        Gn-Prov.Codcia = pv-codcia AND  
        Gn-Prov.CodPro = SELF:SCREEN-VALUE         
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Gn-Prov THEN DO:
      MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   DISPLAY Gn-Prov.NomPro @ FILL-IN-1 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PR-PRESER.PreLis[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PR-PRESER.PreLis[1] V-table-Win
ON LEAVE OF PR-PRESER.PreLis[1] IN FRAME F-Main /* Precio */
DO:
   IF DECI(SELF:SCREEN-VALUE) = 0 THEN DO:
      MESSAGE "Precio debe ser mayor que Cero" VIEW-AS ALERT-BOX ERROR.
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
  {src/adm/template/row-list.i "PR-PRESER"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "PR-PRESER"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     PR-PRESER.Codcia = S-CODCIA.
     PR-PRESER.UndA   = Almmmatg.UndBas.
  END.

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

  IF AVAILABLE PR-PRESER THEN DO WITH FRAME {&FRAME-NAME}:
    FIND Gn-Prov WHERE 
         Gn-Prov.Codcia = pv-codcia AND  
         Gn-Prov.CodPro = PR-PRESER.CodPro:SCREEN-VALUE         
         NO-LOCK NO-ERROR.

    FIND PR-Gastos WHERE 
         PR-Gastos.Codcia = S-CODCIA AND  
         PR-Gastos.CodGas = PR-PRESER.Codgas:SCREEN-VALUE         
         NO-LOCK NO-ERROR.

    FIND Almmmatg WHERE 
         Almmmatg.CodCia = S-CODCIA AND  
         Almmmatg.codmat = PR-PRESER.Codmat:SCREEN-VALUE 
         use-index matg01
         NO-LOCK NO-ERROR.



    DISPLAY Gn-Prov.NomPro @ FILL-IN-1 
            PR-Gastos.DesGas @ FILL-IN-2   
            Almmmatg.DesMat @ FILL-IN-3 .
  
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
    DO WITH FRAME {&FRAME-NAME}:
        CASE HANDLE-CAMPO:name:
            WHEN "" THEN ASSIGN input-var-1 = "".
            WHEN "" THEN ASSIGN input-var-2 = "".
            WHEN "" THEN ASSIGN input-var-3 = "".
        END CASE.
    END.


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
  {src/adm/template/snd-list.i "PR-PRESER"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida V-table-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:

   IF PR-PRESER.Codpro:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Registre Codigo de Proveedor" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO PR-PRESER.Codpro.
      RETURN "ADM-ERROR".   

   END.

   FIND Gn-Prov WHERE 
        Gn-Prov.Codcia = pv-codcia AND  
        Gn-Prov.CodPro = PR-PRESER.Codpro:SCREEN-VALUE         
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Gn-Prov THEN DO:
      MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO PR-PRESER.Codpro.
      RETURN "ADM-ERROR".   
   END.

   IF PR-PRESER.Codgas:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Registre Concepto de Servicio" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO PR-PRESER.Codgas.
      RETURN "ADM-ERROR".   

   END.

   FIND PR-Gastos WHERE 
        PR-Gastos.Codcia = S-CODCIA AND  
        PR-Gastos.CodGas = PR-PRESER.Codgas:SCREEN-VALUE
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE PR-Gastos THEN DO:
      MESSAGE "Codigo de Servicio no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.

   IF PR-PRESER.Codmat:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Registre Codigo de Articulo" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO PR-PRESER.Codmat.
      RETURN "ADM-ERROR".   

   END.

   FIND Almmmatg WHERE 
        Almmmatg.CodCia = S-CODCIA AND  
        Almmmatg.codmat = PR-PRESER.Codmat:SCREEN-VALUE 
        use-index matg01
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO PR-PRESER.Codmat.
      RETURN "ADM-ERROR".   
   END.
   IF Almmmatg.TpoArt <> "A" THEN DO:
      MESSAGE "Articulo no Activo" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO PR-PRESER.Codmat.
      RETURN "ADM-ERROR".   
   END.
   IF Almmmatg.UndBas = "" THEN DO:
      MESSAGE "Articulo no tiene unidad Base" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO PR-PRESER.Codmat.
      RETURN "ADM-ERROR".   
   END.


   IF DECI(PR-PRESER.CanDes[1]:SCREEN-VALUE) = 0 THEN DO:
      MESSAGE "Cantidad debe ser mayor que Cero" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO PR-PRESER.CanDes[1].
      RETURN "ADM-ERROR".   
   END.

   IF DECI(PR-PRESER.PreLis[1]:SCREEN-VALUE) = 0 THEN DO:
      MESSAGE "Precio debe ser mayor que Cero" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO PR-PRESER.PreLis[1].
      RETURN "ADM-ERROR".   
   END.

END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

