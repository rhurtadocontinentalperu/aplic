&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE BUFFER MATG FOR Almmmatg.
DEFINE VAR C-DESMAT LIKE Almmmatg.DesMat NO-UNDO.
DEFINE VAR C-NUEVO  AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES Almmmatg
&Scoped-define FIRST-EXTERNAL-TABLE Almmmatg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almmmatg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almmmatg.UndBas Almmmatg.UndCmp ~
Almmmatg.UndStk Almmmatg.CodAnt Almmmatg.CodBrr Almmmatg.UndA ~
Almmmatg.Chr__01 Almmmatg.FchCes Almmmatg.UndB Almmmatg.UndC ~
Almmmatg.TpoArt Almmmatg.TipArt Almmmatg.FchRea 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}UndBas ~{&FP2}UndBas ~{&FP3}~
 ~{&FP1}UndCmp ~{&FP2}UndCmp ~{&FP3}~
 ~{&FP1}UndStk ~{&FP2}UndStk ~{&FP3}~
 ~{&FP1}CodAnt ~{&FP2}CodAnt ~{&FP3}~
 ~{&FP1}CodBrr ~{&FP2}CodBrr ~{&FP3}~
 ~{&FP1}UndA ~{&FP2}UndA ~{&FP3}~
 ~{&FP1}Chr__01 ~{&FP2}Chr__01 ~{&FP3}~
 ~{&FP1}FchCes ~{&FP2}FchCes ~{&FP3}~
 ~{&FP1}UndB ~{&FP2}UndB ~{&FP3}~
 ~{&FP1}UndC ~{&FP2}UndC ~{&FP3}~
 ~{&FP1}TpoArt ~{&FP2}TpoArt ~{&FP3}~
 ~{&FP1}TipArt ~{&FP2}TipArt ~{&FP3}~
 ~{&FP1}FchRea ~{&FP2}FchRea ~{&FP3}
&Scoped-define ENABLED-TABLES Almmmatg
&Scoped-define FIRST-ENABLED-TABLE Almmmatg
&Scoped-Define ENABLED-OBJECTS RECT-6 RECT-5 RECT-15 
&Scoped-Define DISPLAYED-FIELDS Almmmatg.UndBas Almmmatg.UndCmp ~
Almmmatg.UndStk Almmmatg.CodAnt Almmmatg.ArtPro Almmmatg.CodBrr ~
Almmmatg.FchIng Almmmatg.UndA Almmmatg.Chr__01 Almmmatg.FchCes ~
Almmmatg.UndB Almmmatg.UndC Almmmatg.TpoArt Almmmatg.TipArt Almmmatg.FchRea 

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
DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 74.57 BY 1.73.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 21 BY 3.23.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 40.72 BY 3.23.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almmmatg.UndBas AT ROW 4.04 COL 11.43 COLON-ALIGNED FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
     Almmmatg.UndCmp AT ROW 4.73 COL 11.43 COLON-ALIGNED
          LABEL "U.M. Compra" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
     Almmmatg.UndStk AT ROW 5.42 COL 11.43 COLON-ALIGNED
          LABEL "U.M. Stock" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
     Almmmatg.CodAnt AT ROW 7.04 COL 15.14 COLON-ALIGNED
          LABEL "Codigo Ant."
          VIEW-AS FILL-IN 
          SIZE 13 BY .69
     Almmmatg.ArtPro AT ROW 7.88 COL 15.14 COLON-ALIGNED
          LABEL "Cod.Art.Proveedor"
          VIEW-AS FILL-IN 
          SIZE 13 BY .69
     Almmmatg.CodBrr AT ROW 8.81 COL 14.29 COLON-ALIGNED
          LABEL "Codigo de Barras" FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 19 BY .69
          FONT 0
     Almmmatg.FchIng AT ROW 1.73 COL 20.43 COLON-ALIGNED
          LABEL "Ingreso"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     Almmmatg.UndA AT ROW 4.5 COL 34.43 COLON-ALIGNED
          LABEL "A" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
     Almmmatg.Chr__01 AT ROW 5.42 COL 34.29 COLON-ALIGNED
          LABEL "" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
     Almmmatg.FchCes AT ROW 1.69 COL 41 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     Almmmatg.UndB AT ROW 4.46 COL 43.57 COLON-ALIGNED
          LABEL "B" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
     Almmmatg.UndC AT ROW 4.46 COL 53 COLON-ALIGNED
          LABEL "C" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
     Almmmatg.TpoArt AT ROW 8.5 COL 51.57 COLON-ALIGNED
          LABEL "Estado"
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .69
     Almmmatg.TipArt AT ROW 7.12 COL 54.43 COLON-ALIGNED
          LABEL "Tipo Rotacion"
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .65
     Almmmatg.FchRea AT ROW 1.69 COL 62.14 COLON-ALIGNED
          LABEL "Reactivacion"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     "Unidades Venta" VIEW-AS TEXT
          SIZE 16.14 BY .69 AT ROW 3.5 COL 24.29
          FONT 1
     "Unidades Logística" VIEW-AS TEXT
          SIZE 19.14 BY .69 AT ROW 3.27 COL 2.29
          FONT 1
     RECT-6 AT ROW 3.19 COL 23.29
     RECT-5 AT ROW 3.15 COL 1.43
     "Ingreso/Cese" VIEW-AS TEXT
          SIZE 12.72 BY .69 AT ROW 1.69 COL 2.57
          FONT 1
     RECT-15 AT ROW 1.19 COL 1.57
     "Oficina" VIEW-AS TEXT
          SIZE 10.57 BY .69 AT ROW 5.38 COL 23.86
          FONT 1
     "Mostrador" VIEW-AS TEXT
          SIZE 10.57 BY .69 AT ROW 4.5 COL 23.72
          FONT 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.Almmmatg
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 10.69
         WIDTH              = 78.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Almmmatg.ArtPro IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almmmatg.Chr__01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.CodAnt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.CodBrr IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.FchIng IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almmmatg.FchRea IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.TipArt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.TpoArt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.UndA IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.UndB IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.UndBas IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almmmatg.UndC IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.UndCmp IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.UndStk IN FRAME F-Main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Almmmatg.TpoArt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.TpoArt V-table-Win
ON LEAVE OF Almmmatg.TpoArt IN FRAME F-Main /* Estado */
DO:
/*
       IF Almmmatg.TpoArt:screen-value = "A" THEN 
          DISPLAY "Activado" @ F-destado WITH FRAME {&FRAME-NAME}.
     ELSE
          DISPLAY "Desactivado" @ F-destado WITH FRAME {&FRAME-NAME}.
*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "Almmmatg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almmmatg"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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
  RETURN "ADM-ERROR".
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RETURN "ADM-ERROR".
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "Almmmatg"}

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
DO WITH FRAME {&FRAME-NAME} :
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
         RETURN "ADM-ERROR".   
   
      END.
   */

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


