&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

/* Parameters Definitions ---                                           */


DEFINE INPUT PARAMETER C-NRODOC AS CHAR.
DEFINE INPUT PARAMETER C-CODDOC AS CHAR.


/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE     SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE     SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE     SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE NEW SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE     SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE NEW SHARED VARIABLE S-CODALM   AS CHAR.
DEFINE NEW SHARED VARIABLE S-NROSER   AS INTEGER.
DEFINE NEW SHARED VARIABLE S-CODMOV   AS INTEGER.
DEFINE NEW SHARED TEMP-TABLE DMOV LIKE AlmDMov.
DEFINE NEW GLOBAL  SHARED VARIABLE S-NRODOC   AS CHAR.
DEFINE NEW SHARED VARIABLE input-var-1 AS CHARACTER.
DEFINE NEW SHARED VARIABLE output-var-2 AS CHARACTER.

S-CODDOC = C-CODDOC.
S-NRODOC = C-NRODOC.
DEFINE NEW SHARED TEMP-TABLE DETA LIKE CcbDDocu.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-22 RECT-24 F-CodAge F-CodCob F-FlgSit ~
BUTTON-4 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS F-CodAge F-CodCob F-FlgSit F-NomTra ~
F-NomCob 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 AUTO-END-KEY DEFAULT 
     LABEL "Salir" 
     SIZE 13 BY .96.

DEFINE BUTTON BUTTON-4 AUTO-END-KEY DEFAULT 
     LABEL "Aceptar" 
     SIZE 13 BY .96.

DEFINE VARIABLE F-CodAge AS CHARACTER FORMAT "X(11)" 
     LABEL "Transportista" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69.

DEFINE VARIABLE F-CodCob AS CHARACTER FORMAT "X(10)" 
     LABEL "Cobrador" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69.

DEFINE VARIABLE F-FlgSit AS CHARACTER FORMAT "X" 
     LABEL "Situacion" 
     VIEW-AS FILL-IN 
     SIZE 3.29 BY .69.

DEFINE VARIABLE F-NomCob AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .69 NO-UNDO.

DEFINE VARIABLE F-NomTra AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 66.29 BY 4.73.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 66.43 BY 1.15.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-CodAge AT ROW 3.08 COL 9 COLON-ALIGNED
     F-CodCob AT ROW 3.96 COL 9 COLON-ALIGNED
     F-FlgSit AT ROW 4.85 COL 9 COLON-ALIGNED
     BUTTON-4 AT ROW 6.04 COL 17.72
     F-NomTra AT ROW 3.12 COL 20.14 COLON-ALIGNED NO-LABEL
     F-NomCob AT ROW 3.96 COL 20.14 COLON-ALIGNED NO-LABEL
     BUTTON-2 AT ROW 6 COL 35.43
     RECT-22 AT ROW 1.15 COL 1.86
     RECT-24 AT ROW 5.88 COL 1.86
     "Distribucion" VIEW-AS TEXT
          SIZE 12.86 BY .77 AT ROW 1.73 COL 28.72
          FONT 1
     SPACE(26.98) SKIP(4.68)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Guías Pendientes".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
                                                                        */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-NomCob IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomTra IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Guías Pendientes */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 D-Dialog
ON CHOOSE OF BUTTON-4 IN FRAME D-Dialog /* Aceptar */
DO:

  RUN Graba-Datos .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodAge
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodAge D-Dialog
ON LEAVE OF F-CodAge IN FRAME D-Dialog /* Transportista */
DO:
  F-NomTra = "".
  ASSIGN F-CodAge .
  IF F-CodAge <> "" THEN DO: 
     FIND admrutas WHERE admrutas.CodPro = F-CodAge NO-LOCK NO-ERROR.
     IF AVAILABLE admrutas THEN F-NomTra = admrutas.NomTra.
  END.
  DISPLAY F-NomTra WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodAge D-Dialog
ON MOUSE-SELECT-DBLCLICK OF F-CodAge IN FRAME D-Dialog /* Transportista */
DO:
    DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-transp.r("Transportistas").
    IF output-var-2 <> ? THEN DO:
        F-CODAGE = output-var-2.
        DISPLAY F-CODAGE.
        APPLY "ENTRY" TO F-CODAGE .
        RETURN NO-APPLY.

    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodCob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodCob D-Dialog
ON LEAVE OF F-CodCob IN FRAME D-Dialog /* Cobrador */
DO:
  F-NomCob = "".
  ASSIGN F-CodCob .
  IF F-CodCob <> "" THEN DO: 
   FIND Gn-Cob WHERE Gn-Cob.Codcia = S-CODCIA AND
                     Gn-Cob.Codcob = F-Codcob NO-LOCK NO-ERROR.
   IF AVAILABLE Gn-Cob THEN F-NomCob = Gn-Cob.Nomcob.
  END.
  DISPLAY F-NomCob WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodCob D-Dialog
ON MOUSE-SELECT-DBLCLICK OF F-CodCob IN FRAME D-Dialog /* Cobrador */
DO:
    DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-cobra.r("Cobradores").
    IF output-var-2 <> ? THEN DO:
        F-CODCOB = output-var-2.
        DISPLAY F-CODCOB.
        APPLY "ENTRY" TO F-CODCOB .
        RETURN NO-APPLY.

    END.
  END.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY F-CodAge F-CodCob F-FlgSit F-NomTra F-NomCob 
      WITH FRAME D-Dialog.
  ENABLE RECT-22 RECT-24 F-CodAge F-CodCob F-FlgSit BUTTON-4 BUTTON-2 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-DAtos D-Dialog 
PROCEDURE Graba-DAtos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN Valida.

IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.

DEFINE VAR I AS INTEGER .
DO I = 1 TO NUM-ENTRIES(S-NRODOC):
  FIND CcbCDocu WHERE CcbCDocu.Codcia = S-CODCIA AND
                      CcbCDocu.CodDoc = S-CODDOC AND
                      CcbCDocu.NroDoc = ENTRY(I,S-NRODOC) /*NO-LOCK*/ NO-ERROR.
  IF NOT AVAILABLE CcbCDocu THEN DO:
    MESSAGE "Documento " + ENTRY(I,S-NRODOC) + " No Existe " SKIP
            "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
  /*  APPLY "ENTRY" TO F-CODAGE IN FRAME {&FRAME-NAME}.
    RETURN "ADM-ERROR".
  */
  END.
  ELSE DO:
    ASSIGN CcbCDocu.CodAge = F-CodAge
           CcbCDocu.CodCob = F-COdCob
           CcbCDocu.FlgSit = F-FlgSit.
  
  END.
                         
        
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida D-Dialog 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE X-ITEMS AS INTEGER INIT 0.
DEFINE VARIABLE I-ITEMS AS DECIMAL NO-UNDO.
DO WITH FRAME {&FRAME-NAME} :
 ASSIGN F-FlgSit F-CodAge F-CodCob.

 IF F-Codcob <> "" THEN DO:
   FIND Gn-Cob WHERE Gn-Cob.Codcia = S-CODCIA AND
                     Gn-Cob.Codcob = F-Codcob NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Gn-Cob THEN DO:
      MESSAGE "Codigo de Cobrador no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-CodCob.
      RETURN "ADM-ERROR".   
   END.  
 END.  
   IF LOOKUP(F-FlgSit,"P,E,R") = 0 THEN DO:
      MESSAGE "Estados de Guia solo pueden ser:" SKIP
              "P:Pendiente" SKIP
              "E:Enviado" SKIP
              "R:Recepcionado" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-FlgSit.
      RETURN "ADM-ERROR".   
   END.
   CASE F-FlgSit :
        WHEN "P" THEN DO:
                IF LOOKUP(F-FlgSit,"E,P") = 0 THEN DO:
                      MESSAGE "Estados de Guia solo pueden ser:" SKIP
                              "E:Enviado" SKIP
                              "P:Pendiente" VIEW-AS ALERT-BOX ERROR.
                      APPLY "ENTRY" TO F-FlgSit.
                      RETURN "ADM-ERROR".   
                 END.

        END.
        WHEN "E" THEN DO:
                IF LOOKUP(F-FlgSit,"E,R") = 0 THEN DO:
                      MESSAGE "Estados de Guia solo pueden ser:" SKIP
                              "E:Enviado" SKIP
                              "R:Recepcionado" VIEW-AS ALERT-BOX ERROR.
                      APPLY "ENTRY" TO F-FlgSit.
                      RETURN "ADM-ERROR".   
                 END.

        END.
        WHEN "R" THEN DO:
                IF LOOKUP(F-FlgSit,"R") = 0 THEN DO:
                      MESSAGE "Estados de Guia solo pueden ser:" SKIP
                              "R:Recepcionado" VIEW-AS ALERT-BOX ERROR.
                      APPLY "ENTRY" TO F-FlgSit.
                      RETURN "ADM-ERROR".   
                 END.

        END.

   END CASE. 
   
   
   FIND admrutas WHERE admrutas.CodPro = F-CodAge NO-LOCK NO-ERROR.
   IF NOT AVAILABLE admrutas THEN DO:
      MESSAGE "Codigo de transportista no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-CodAge.
      RETURN "ADM-ERROR".   
   END.

   FIND AlmCieAl WHERE 
        AlmCieAl.CodCia = S-CODCIA AND 
        AlmCieAl.CodAlm = Ccbcdocu.codalm AND 
        AlmCieAl.FchCie = CcbCDocu.FchDoc 
        NO-LOCK NO-ERROR.
   IF AVAILABLE AlmCieAl AND
      AlmCieAl.FlgCie THEN DO:
      MESSAGE "Este dia " AlmCieAl.FchCie " se encuentra cerrado" SKIP 
              "Consulte con sistemas " VIEW-AS ALERT-BOX INFORMATION.
      RETURN "ADM-ERROR".
   END.

END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


