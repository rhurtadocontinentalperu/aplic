&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
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
DEFINE INPUT PARAMETER X-CODAUX AS CHAR.
/* Local Variable Definitions ---                                       */
{CBD/CBGLOBAL.I}

DEFINE SHARED TEMP-TABLE RMOV LIKE cb-dmov.
DEFINE TEMP-TABLE DMOV LIKE cb-dmov.

DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.

DEFINE BUFFER DETALLE FOR cb-dmov.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(80)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
     WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
          SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
          BGCOLOR 15 FGCOLOR 0 
          TITLE "Procesando ..." FONT 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES DMOV

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table DMOV.Coddoc DMOV.Nrodoc DMOV.Fchvto DMOV.GloDoc DMOV.TpoMov DMOV.ImpMn1 DMOV.ImpMn2   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH DMOV       NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table DMOV
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DMOV


/* Definitions for DIALOG-BOX D-Dialog                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table Btn_OK Btn_Cancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 2
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      DMOV SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table D-Dialog _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      DMOV.Coddoc
      DMOV.Nrodoc FORMAT "x(12)"
      DMOV.Fchvto COLUMN-LABEL "Fecha Vncmto"
      DMOV.GloDoc
      DMOV.TpoMov
      DMOV.ImpMn1
      DMOV.ImpMn2
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 75 BY 9.19
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     br_table AT ROW 1 COL 1
     Btn_OK AT ROW 10.42 COL 35.14
     Btn_Cancel AT ROW 10.42 COL 56.43
     SPACE(7.57) SKIP(0.19)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Documentos  pendientes".

 

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
   NOT-VISIBLE Default                                                  */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH DMOV
      NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Documentos  pendientes */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  RUN Asigna-Documentos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_table
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Documentos D-Dialog 
PROCEDURE Asigna-Documentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE I AS INTEGER NO-UNDO.
IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
   MESSAGE "No existen registros seleccionados" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
DO I = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
   IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(I) THEN DO:
      FIND RMOV WHERE RMOV.CodDoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.CodDoc
           AND RMOV.NroDoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NroDoc
           NO-LOCK NO-ERROR.
      IF NOT AVAILABLE RMOV THEN DO:
         DISPLAY STRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NroDoc,"9999") @ Fi-Mensaje LABEL "Codigo de Documento " FORMAT "X(10)" WITH FRAME F-Proceso.
         CREATE RMOV.
         ASSIGN RMOV.cco    = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.cco   
                RMOV.Clfaux = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Clfaux
                RMOV.CndCmp = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.CndCmp
                RMOV.Codaux = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Codaux
                RMOV.Codcta = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Codcta
                RMOV.CodDiv = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.CodDiv
                RMOV.Coddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Coddoc
                RMOV.Codmon = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Codmon
                RMOV.Codref = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Codref
                RMOV.CtaAut = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.CtaAut
                RMOV.CtrCta = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.CtrCta
                RMOV.DisCCo = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.DisCCo
                RMOV.Fchdoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Fchdoc
                RMOV.Fchvto = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Fchvto
                RMOV.flgact = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.flgact
                RMOV.Glodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Glodoc
                RMOV.ImpMn1 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.ImpMn1
                RMOV.ImpMn2 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.ImpMn2
                RMOV.Nrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Nrodoc
                RMOV.Nroref = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NroRef
                RMOV.Nroruc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Nroruc
                RMOV.OrdCmp = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.OrdCmp
                RMOV.Tpocmb = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Tpocmb
                RMOV.TpoMov = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.TpoMov
                RMOV.TpoItm = "P".
      END.
   END.
END.
HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE X-IMPORT AS DECIMAL EXTENT 2 INIT 0  NO-UNDO.
/* CARGAMOS LOS SALDOS POR DOCUMENTO */
FOR EACH Cp-tpro NO-LOCK  WHERE Cp-tpro.CODCIA = CB-CODCIA AND
         Cp-tpro.CORRELATIVO = YES:
    FOR EACH DETALLE NO-LOCK WHERE 
             DETALLE.CODCIA  = S-CODCIA       AND
             DETALLE.PERIODO = S-PERIODO      AND
             DETALLE.CODOPE  = CP-TPRO.CODOPE AND 
             DETALLE.CODCTA  = CP-TPRO.CODCTA AND
             DETALLE.CodAux BEGINS x-codaux   AND
             DETALLE.CODDOC  = CP-TPRO.CODDOC AND
             DETALLE.NroMes >= 0              AND
             DETALLE.NroMes <= S-NROMES  :     
        FI-MENSAJE = "Proveedor : " + DETALLE.CodAux + " Doc. : " + DETALLE.CodDoc +
                         " No. : " + DETALLE.NroDoc.
        DISPLAY FI-MENSAJE NO-LABEL FORMAT "X(60)" WITH FRAME F-PROCESO.
        X-IMPORT[1] = 0.
        X-IMPORT[2] = 0.
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.CodCia = S-CODCIA AND
                 cb-dmov.Periodo = S-PERIODO      AND
                 cb-dmov.Codcta  = DETALLE.CODCTA AND
                 cb-dmov.Codaux  = DETALLE.codaux AND
                 cb-dmov.CodDoc  = DETALLE.CodDoc AND
                 cb-dmov.NroDoc  = DETALLE.NroDoc:
            IF cb-dmov.TpoMov THEN 
               ASSIGN X-IMPORT[1] = X-IMPORT[1] - cb-dmov.ImpMn1 
                      X-IMPORT[2] = X-IMPORT[2] - cb-dmov.ImpMn2.
            ELSE
               ASSIGN X-IMPORT[1] = X-IMPORT[1] + cb-dmov.ImpMn1 
                      X-IMPORT[2] = X-IMPORT[2] + cb-dmov.ImpMn2.
        END.
        IF (DETALLE.CodMon = 1 AND ABSOLUTE(X-IMPORT[1]) > 0) OR
           (DETALLE.CodMon = 2 AND ABSOLUTE(X-IMPORT[2]) > 0) THEN DO:
           CREATE DMOV.
           ASSIGN DMOV.CODCIA = S-CODCIA
                  DMOV.NroAst = DETALLE.NroAst
                  DMOV.CodOpe = DETALLE.CodOpe
                  DMOV.cco    = DETALLE.cco   
                  DMOV.Clfaux = DETALLE.Clfaux
                  DMOV.CndCmp = DETALLE.CndCmp
                  DMOV.Codaux = DETALLE.Codaux
                  DMOV.Codcta = DETALLE.Codcta
                  DMOV.CodDiv = DETALLE.CodDiv
                  DMOV.Coddoc = DETALLE.Coddoc
                  DMOV.Codmon = DETALLE.Codmon
                  DMOV.Codref = DETALLE.Codref
                  DMOV.DisCCo = DETALLE.DisCCo
                  DMOV.Fchdoc = DETALLE.Fchdoc
                  DMOV.Fchvto = DETALLE.Fchvto
                  DMOV.flgact = DETALLE.flgact
                  DMOV.Glodoc = DETALLE.Glodoc
                  DMOV.ImpMn1 = ABSOLUTE(X-IMPORT[1])
                  DMOV.ImpMn2 = ABSOLUTE(X-IMPORT[2])
                  DMOV.Nrodoc = DETALLE.Nrodoc
                  DMOV.Nroref = (DETALLE.CodOpe + "-" + DETALLE.NroAst)
                  DMOV.Nroruc = DETALLE.Nroruc
                  DMOV.OrdCmp = DETALLE.OrdCmp
                  DMOV.tm     = DETALLE.tm
                  DMOV.Tpocmb = DETALLE.Tpocmb
                  DMOV.TpoMov = NOT DETALLE.TpoMov
                  DMOV.CodBco = DETALLE.CodBco.
        END.
    END.
END.
HIDE FRAME F-PROCESO.

{&OPEN-QUERY-{&BROWSE-NAME}}

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
  ENABLE br_table Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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
   
   RUN Carga-Temporal.
   
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "DMOV"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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


