&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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

DEFINE INPUT  PARAMETER X-NIVEL AS CHAR.
DEFINE INPUT  PARAMETER X-MENS AS CHAR.
DEFINE OUTPUT PARAMETER X-NIV  AS CHAR.
DEFINE OUTPUT PARAMETER X-REP AS CHAR.

/* Parameters Definitions ---                                           */
DEFINE VARIABLE X-CLAVE AS CHAR.
DEFINE VARIABLE S-CLAVE AS CHARACTER NO-UNDO.
/* Local Variable Definitions ---                                       */

DEFINE VARIABLE x-cont AS INTEGER NO-UNDO.

X-REP = "ERROR".

DEFINE BUFFER B-FacUser FOR FacUser.

DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-CodDiv AS CHAR.
DEFINE SHARED VARIABLE S-LisNiv AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-usuario x-password RECT-4 
&Scoped-Define DISPLAYED-OBJECTS x-usuario x-password 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE x-password AS CHARACTER FORMAT "X(10)":U 
     LABEL "Clave" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .81
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE x-usuario AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 8  NO-FILL   
     SIZE 28.43 BY 2.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     x-usuario AT ROW 1.35 COL 8 COLON-ALIGNED
     x-password AT ROW 2.19 COL 8 COLON-ALIGNED
     RECT-4 AT ROW 1 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Clave".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Clave */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-password
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-password D-Dialog
ON ANY-PRINTABLE OF x-password IN FRAME D-Dialog /* Clave */
DO:
  SUBSTR(S-CLAVE, SELF:CURSOR-OFFSET, 1) = CHR(LASTKEY).
  APPLY "*" TO SELF.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-password D-Dialog
ON ENTRY OF x-password IN FRAME D-Dialog /* Clave */
DO:
  x-password:SCREEN-VALUE = "".
  S-CLAVE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-password D-Dialog
ON RETURN OF x-password IN FRAME D-Dialog /* Clave */
DO:

    ASSIGN x-usuario.
    IF NOT SETUSERID(x-usuario, S-CLAVE, "INTEGRAL") 
    THEN DO:
        MESSAGE "Password Incorrecto..." VIEW-AS ALERT-BOX ERROR.
        IF x-cont > 1 THEN APPLY "END-ERROR":U TO SELF.
        x-cont = x-cont + 1.
        APPLY "ENTRY" TO x-password.
        RETURN NO-APPLY.
    END.
    ELSE X-REP = "OK".


/*  x-cont = x-cont + 1.
 *   IF NOT S-CLAVE = X-CLAVE THEN DO:
 *     MESSAGE "Clave errada" VIEW-AS ALERT-BOX ERROR.
 *     IF x-cont = 3 THEN APPLY "END-ERROR":U TO SELF.
 *     APPLY "ENTRY" TO X-password IN FRAME {&FRAME-NAME}.
 *     RETURN NO-APPLY.
 *   END.
 *   ELSE X-REP = "OK".*/

  APPLY "END-ERROR":U TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-usuario D-Dialog
ON LEAVE OF x-usuario IN FRAME D-Dialog /* Usuario */
DO:
  APPLY "RETURN" TO x-usuario.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-usuario D-Dialog
ON RETURN OF x-usuario IN FRAME D-Dialog /* Usuario */
DO:
    ASSIGN x-usuario.
    FIND FIRST FacUsers WHERE FacUsers.CodCia = S-CODCIA 
                         AND  FacUsers.Usuario = x-usuario
                        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacUsers THEN DO:
        MESSAGE "Usuario no esta registrado en la tabla Usuarios" 
                VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO x-usuario IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
/*     IF LOOKUP("D4", FacUsers.Niveles) = 0 THEN             */
/*     IF LOOKUP("D1", FacUsers.Niveles) = 0 THEN             */
/*     IF LOOKUP("D2", FacUsers.Niveles) = 0 THEN             */
/*     IF LOOKUP("D3", FacUsers.Niveles) = 0 THEN DO:         */
/*         MESSAGE "Usuario no Autorizado" SKIP               */
/*                 "a realizar " x-mens                       */
/*                 VIEW-AS ALERT-BOX ERROR.                   */
/*         APPLY "ENTRY" TO x-usuario IN FRAME {&FRAME-NAME}. */
/*         RETURN NO-APPLY.                                   */
/*     END.                                                   */
    
    X-NIV = SUBSTRING(FacUsers.Niveles,1,2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create_user D-Dialog 
PROCEDURE create_user :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF NOT CAN-FIND(DICTDB._USER WHERE DICTDB._USER._UserId = USERID("DICTDB"))
    THEN DO:
        CREATE DICTDB._USER.
        ASSIGN DICTDB._USER._UserId   = USERID("DICTDB")
               DICTDB._USER._Password = ENCODE("").
           
        IF SETUSERID(USERID("DICTDB"), "", "DICTDB") 
        THEN RETURN ERROR.
    END.
    ELSE RETURN ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY x-usuario x-password 
      WITH FRAME D-Dialog.
  ENABLE x-usuario x-password RECT-4 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

