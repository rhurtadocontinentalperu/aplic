&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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
DEF SHARED VAR s-tabla  AS CHAR.


DEF VAR x-Usuarios LIKE emailconfig.Usuarios NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES emailconfig
&Scoped-define FIRST-EXTERNAL-TABLE emailconfig


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR emailconfig.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS emailconfig.Grupo emailconfig.EmailFrom ~
emailconfig.EmailCC emailconfig.EmailCCo emailconfig.SmtpMail ~
emailconfig.EmailUser emailconfig.EmailPassword 
&Scoped-define ENABLED-TABLES emailconfig
&Scoped-define FIRST-ENABLED-TABLE emailconfig
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 SELECTION-LIST_Usuarios 
&Scoped-Define DISPLAYED-FIELDS emailconfig.Grupo emailconfig.EmailFrom ~
emailconfig.EmailCC emailconfig.EmailCCo emailconfig.SmtpMail ~
emailconfig.EmailUser emailconfig.EmailPassword 
&Scoped-define DISPLAYED-TABLES emailconfig
&Scoped-define FIRST-DISPLAYED-TABLE emailconfig
&Scoped-Define DISPLAYED-OBJECTS SELECTION-LIST_Usuarios 

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
DEFINE BUTTON BUTTON-Borrar 
     LABEL "Borra Seleccionado" 
     SIZE 19 BY 1.12.

DEFINE BUTTON BUTTON-Usuarios 
     LABEL "Importar Usuarios" 
     SIZE 19 BY 1.12.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 121 BY 2.96.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 121 BY 3.23.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 121 BY 8.88.

DEFINE VARIABLE SELECTION-LIST_Usuarios AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SORT SCROLLBAR-VERTICAL 
     LIST-ITEM-PAIRS "uno","uno" 
     SIZE 40 BY 7 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     emailconfig.Grupo AT ROW 1.27 COL 18 COLON-ALIGNED WIDGET-ID 20
          LABEL "Grupo"
          VIEW-AS COMBO-BOX INNER-LINES 10
          LIST-ITEMS "CREDITOS","GERENCIA GENERAL" 
          DROP-DOWN-LIST
          SIZE 30 BY 1
          BGCOLOR 15 FGCOLOR 0 
     SELECTION-LIST_Usuarios AT ROW 2.35 COL 20 NO-LABEL WIDGET-ID 30
     BUTTON-Usuarios AT ROW 2.35 COL 60 WIDGET-ID 34
     BUTTON-Borrar AT ROW 3.42 COL 60 WIDGET-ID 38
     emailconfig.EmailFrom AT ROW 10.15 COL 18 COLON-ALIGNED WIDGET-ID 6
          LABEL "De"
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .81
          BGCOLOR 15 FGCOLOR 0 
     emailconfig.EmailCC AT ROW 10.96 COL 17.14 WIDGET-ID 2
          LABEL "CC"
          VIEW-AS FILL-IN 
          SIZE 100 BY .81
          BGCOLOR 15 FGCOLOR 0 
     emailconfig.EmailCCo AT ROW 11.77 COL 16 WIDGET-ID 4
          LABEL "CCO"
          VIEW-AS FILL-IN 
          SIZE 100 BY .81
          BGCOLOR 15 FGCOLOR 0 
     emailconfig.SmtpMail AT ROW 13.12 COL 18 COLON-ALIGNED WIDGET-ID 16
          LABEL "SMTP"
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .81
          BGCOLOR 15 FGCOLOR 0 
     emailconfig.EmailUser AT ROW 13.92 COL 18 COLON-ALIGNED WIDGET-ID 12
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .81
          BGCOLOR 15 FGCOLOR 0 
     emailconfig.EmailPassword AT ROW 14.73 COL 18 COLON-ALIGNED WIDGET-ID 8
          LABEL "Password"
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .81
          BGCOLOR 15 FGCOLOR 0 
     "Usuarios:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 2.35 COL 13 WIDGET-ID 32
     "Datos de envío" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 9.62 COL 2 WIDGET-ID 24
          BGCOLOR 9 FGCOLOR 15 
     "Correo de envío" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 12.58 COL 2 WIDGET-ID 22
          BGCOLOR 9 FGCOLOR 15 
     RECT-1 AT ROW 9.88 COL 1 WIDGET-ID 26
     RECT-2 AT ROW 12.85 COL 1 WIDGET-ID 28
     RECT-3 AT ROW 1 COL 1 WIDGET-ID 36
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.emailconfig
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
         HEIGHT             = 16.5
         WIDTH              = 128.57.
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

/* SETTINGS FOR BUTTON BUTTON-Borrar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-Usuarios IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN emailconfig.EmailCC IN FRAME F-Main
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN emailconfig.EmailCCo IN FRAME F-Main
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN emailconfig.EmailFrom IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN emailconfig.EmailPassword IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN emailconfig.EmailUser IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX emailconfig.Grupo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN emailconfig.SmtpMail IN FRAME F-Main
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

&Scoped-define SELF-NAME BUTTON-Borrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Borrar V-table-Win
ON CHOOSE OF BUTTON-Borrar IN FRAME F-Main /* Borra Seleccionado */
DO:
    DEF VAR k AS INT.
    MESSAGE SELECTION-LIST_Usuarios:NUM-ITEMS.
    DO k = 1 TO SELECTION-LIST_Usuarios:NUM-ITEMS:
        IF SELECTION-LIST_Usuarios:IS-SELECTED(k) THEN DO:
            MESSAGE 'selected'.
            SELECTION-LIST_Usuarios:DELETE(k).
            LEAVE.
        END.
    END.
    DISPLAY SELECTION-LIST_Usuarios WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Usuarios
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Usuarios V-table-Win
ON CHOOSE OF BUTTON-Usuarios IN FRAME F-Main /* Importar Usuarios */
DO:
  DEF VAR pUsuarios AS CHAR NO-UNDO.
  RUN gn/d-users (OUTPUT pUsuarios).
  IF pUsuarios > '' THEN RUN Carga-Usuarios ( pUsuarios ).
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
  {src/adm/template/row-list.i "emailconfig"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "emailconfig"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Usuarios V-table-Win 
PROCEDURE Carga-Usuarios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pUsuarios AS CHAR.

DEF VAR k AS INT NO-UNDO.
DO k = 1 TO NUM-ENTRIES(pUsuarios):
    IF LOOKUP(ENTRY(k,pUsuarios),x-Usuarios) > 0 THEN NEXT.
    x-Usuarios = x-Usuarios + (IF TRUE <> (x-Usuarios > '') THEN '' ELSE ',') + ENTRY(k,pUsuarios).
END.
DEF VAR x-User-Name AS CHAR NO-UNDO.
DO WITH FRAME {&FRAME-NAME}:
    SELECTION-LIST_Usuarios:DELETE(SELECTION-LIST_Usuarios:LIST-ITEM-PAIRS).
    DO k = 1 TO NUM-ENTRIES(x-Usuarios):
        x-User-Name = 'NO DEFINIDO'.
        FIND _User WHERE _User._USERID = ENTRY(k,x-Usuarios)
            NO-LOCK NO-ERROR.
        IF AVAILABLE _User THEN x-User-Name = _User._User-Name.
        SELECTION-LIST_Usuarios:ADD-LAST(_User._UserId + ' ' + _User._User-Name,_User._UserId).
    END.
    DISPLAY SELECTION-LIST_Usuarios.
END.


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
  DO WITH FRAME {&FRAME-NAME}:
      SELECTION-LIST_Usuarios:DELETE(SELECTION-LIST_Usuarios:LIST-ITEM-PAIRS).
      DISPLAY SELECTION-LIST_Usuarios.
  END.
  x-Usuarios = ''.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
      emailconfig.Codcia = s-codcia
      emailconfig.Usuarios = x-Usuarios.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      BUTTON-Usuarios:SENSITIVE = NO.
      BUTTON-Borrar:SENSITIVE = NO.
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
  IF NOT AVAILABLE emailconfig THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DEF VAR k AS INT NO-UNDO.
  DEF VAR x-User-Name AS CHAR NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
      SELECTION-LIST_Usuarios:DELETE(SELECTION-LIST_Usuarios:LIST-ITEM-PAIRS).
      DO k = 1 TO NUM-ENTRIES(emailconfig.Usuarios):
          x-User-Name = 'NO DEFINIDO'.
          FIND _User WHERE _User._USERID = ENTRY(k,emailconfig.Usuarios)
              NO-LOCK NO-ERROR.
          IF AVAILABLE _User THEN x-User-Name = _User._User-Name.
          SELECTION-LIST_Usuarios:ADD-LAST(_User._UserId + ' ' + _User._User-Name,_User._UserId).
      END.
      DISPLAY SELECTION-LIST_Usuarios.
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
      BUTTON-Usuarios:SENSITIVE = YES.
      BUTTON-Borrar:SENSITIVE = YES.
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
  DO WITH FRAME {&FRAME-NAME}:
      SELECTION-LIST_Usuarios:DELIMITER = '|'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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
  {src/adm/template/snd-list.i "emailconfig"}

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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Correo AS CHAR NO-UNDO.
DEF VAR k AS INT NO-UNDO.

DO WITH FRAME {&FRAME-NAME} :
    IF TRUE <> (emailconfig.Grupo:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Seleccione un grupo' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO emailconfig.Grupo.
        RETURN 'ADM-ERROR'.
    END.
    IF emailconfig.EmailFrom:SCREEN-VALUE > '' THEN DO:
        x-Correo = emailconfig.EmailFrom:SCREEN-VALUE.
        IF INDEX(x-Correo, '@') = 0 THEN DO:
            MESSAGE 'Correo mal registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO emailconfig.EmailFrom.
            RETURN 'ADM-ERROR'.
        END.
/*         IF NUM-ENTRIES(ENTRY(2,x-Correo,'@'),'.') <> 2 THEN DO:      */
/*             MESSAGE 'Correo mal registrado' VIEW-AS ALERT-BOX ERROR. */
/*             APPLY 'ENTRY':U TO emailconfig.EmailFrom.                */
/*             RETURN 'ADM-ERROR'.                                      */
/*         END.                                                         */
    END.
    IF emailconfig.EmailCC:SCREEN-VALUE > '' THEN DO:
        DO k = 1 TO NUM-ENTRIES(emailconfig.EmailCC:SCREEN-VALUE):
            x-Correo = ENTRY(k,emailconfig.EmailCC:SCREEN-VALUE).
            IF NUM-ENTRIES(x-Correo, '@') <> 2 THEN DO:
                MESSAGE 'Correo mal registrado' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO emailconfig.EmailCC.
                RETURN 'ADM-ERROR'.
            END.
/*             IF NUM-ENTRIES(ENTRY(2,x-Correo,'@'),'.') <> 2 THEN DO:      */
/*                 MESSAGE 'Correo mal registrado' VIEW-AS ALERT-BOX ERROR. */
/*                 APPLY 'ENTRY':U TO emailconfig.EmailCC.                  */
/*                 RETURN 'ADM-ERROR'.                                      */
/*             END.                                                         */
        END.
    END.
    IF emailconfig.EmailCCo:SCREEN-VALUE > '' THEN DO:
        DO k = 1 TO NUM-ENTRIES(emailconfig.EmailCCo:SCREEN-VALUE):
            x-Correo = ENTRY(k,emailconfig.EmailCCo:SCREEN-VALUE).
            IF NUM-ENTRIES(x-Correo, '@') <> 2 THEN DO:
                MESSAGE 'Correo mal registrado' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO emailconfig.EmailCCo.
                RETURN 'ADM-ERROR'.
            END.
/*             IF NUM-ENTRIES(ENTRY(2,x-Correo,'@'),'.') <> 2 THEN DO:      */
/*                 MESSAGE 'Correo mal registrado' VIEW-AS ALERT-BOX ERROR. */
/*                 APPLY 'ENTRY':U TO emailconfig.EmailCCo.                 */
/*                 RETURN 'ADM-ERROR'.                                      */
/*             END.                                                         */
        END.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

x-Usuarios = emailconfig.Usuarios.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

