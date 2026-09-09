&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
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
DEF INPUT PARAMETER x-Rowid AS ROWID.

DEFINE SHARED VAR s-CodCia AS INTEGER.
DEFINE SHARED VAR s-nomCia AS CHAR.

/* Local Variable Definitions ---                                       */

DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */

FIND GN-CLIE WHERE ROWID(GN-CLIE) = x-Rowid NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gn-clie

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog gn-clie.CodCli gn-clie.NomCli 
&Scoped-define QUERY-STRING-D-Dialog FOR EACH gn-clie SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH gn-clie SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog gn-clie


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-62 x-FchDoc-1 x-FchDoc-2 tg-dudosa ~
tg-Letras Btn_OK BUTTON-10 Btn_Cancel 
&Scoped-Define DISPLAYED-FIELDS gn-clie.CodCli gn-clie.NomCli 
&Scoped-define DISPLAYED-TABLES gn-clie
&Scoped-define FIRST-DISPLAYED-TABLE gn-clie
&Scoped-Define DISPLAYED-OBJECTS x-FchDoc-1 x-FchDoc-2 tg-dudosa tg-Letras 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "IMG/b-cancel.bmp":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "IMG/b-ok.bmp":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-10 
     IMAGE-UP FILE "img/email.ico":U
     LABEL "Button 10" 
     SIZE 12 BY 1.62.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66 BY 7.27.

DEFINE VARIABLE tg-dudosa AS LOGICAL INITIAL yes 
     LABEL "Incluir Doc. Cobranza Dudosa" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .77 NO-UNDO.

DEFINE VARIABLE tg-Letras AS LOGICAL INITIAL no 
     LABEL "Solo Letras" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     gn-clie.CodCli AT ROW 1.54 COL 12.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     gn-clie.NomCli AT ROW 2.5 COL 12.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 51 BY .81
     x-FchDoc-1 AT ROW 3.46 COL 12.43 COLON-ALIGNED
     x-FchDoc-2 AT ROW 3.46 COL 28.43 COLON-ALIGNED
     tg-dudosa AT ROW 4.77 COL 14.43 WIDGET-ID 2
     tg-Letras AT ROW 5.62 COL 14.43 WIDGET-ID 6
     Btn_OK AT ROW 6.65 COL 31
     BUTTON-10 AT ROW 6.65 COL 43 WIDGET-ID 8
     Btn_Cancel AT ROW 6.65 COL 55
     RECT-62 AT ROW 1.27 COL 2 WIDGET-ID 4
     SPACE(1.28) SKIP(0.37)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "ESTADO DE CUENTA POR CLIENTE"
         CANCEL-BUTTON Btn_Cancel.


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
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN gn-clie.CodCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.NomCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "INTEGRAL.gn-clie"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* ESTADO DE CUENTA POR CLIENTE */
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
  ASSIGN
    x-FchDoc-1 x-FchDoc-2 tg-dudosa tg-letras.
  RUN dispatch IN THIS-PROCEDURE ('imprime':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 D-Dialog
ON CHOOSE OF BUTTON-10 IN FRAME D-Dialog /* Button 10 */
DO:
    ASSIGN
      x-FchDoc-1 x-FchDoc-2 tg-dudosa tg-letras.
    RUN Correo.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Impresion D-Dialog 
PROCEDURE Carga-Impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-Date-Format AS CHAR.

  GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  ASSIGN
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'ccb/rbccb.prl'
    RB-REPORT-NAME = 'Carta Estado de Cuenta Texto'       
    RB-INCLUDE-RECORDS = 'O'.
  IF tg-dudosa THEN DO:
      IF NOT tg-letras THEN DO:
          ASSIGN
              RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
                          " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
                          " AND (ccbcdocu.flgest = 'P'" +
                          " OR  ccbcdocu.flgest = 'J')" +
                          " AND (ccbcdocu.coddoc = 'FAC'" +
                          " OR ccbcdocu.coddoc = 'BOL'"+
                          " OR ccbcdocu.coddoc = 'DCO'"+
                          " OR ccbcdocu.coddoc = 'LET'" +
                          " OR ccbcdocu.coddoc = 'N/C'" +
                          " OR ccbcdocu.coddoc = 'N/D'" +
                          " OR ccbcdocu.coddoc = 'A/R'" +
                          " OR ccbcdocu.coddoc = 'BD'" +
                          " OR ccbcdocu.coddoc = 'CHQ'" +
                          " OR ccbcdocu.coddoc = 'A/C'" +
                          " OR ccbcdocu.coddoc = 'CHC')".
      END.
      ELSE DO:
          ASSIGN
              RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
                          " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
                          " AND (ccbcdocu.flgest = 'P'" +
                          " OR  ccbcdocu.flgest = 'J')" +                          
                          " AND ccbcdocu.coddoc = 'LET'".
      END.
  END.
  ELSE DO:
      IF NOT tg-Letras THEN DO:
          ASSIGN
              RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
                    " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
                    " AND ccbcdocu.flgest = 'P'" +
                    " AND (ccbcdocu.coddoc = 'FAC'" +
                    " OR ccbcdocu.coddoc = 'BOL'"+
                    " OR ccbcdocu.coddoc = 'DCO'"+
                    " OR ccbcdocu.coddoc = 'LET'" +
                    " OR ccbcdocu.coddoc = 'N/C'" +
                    " OR ccbcdocu.coddoc = 'N/D'" +
                    " OR ccbcdocu.coddoc = 'A/R'" +
                    " OR ccbcdocu.coddoc = 'A/C'" +
                    " OR ccbcdocu.coddoc = 'BD'" +
                    " OR ccbcdocu.coddoc = 'CHQ')".
      END.
      ELSE DO:
          ASSIGN
              RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
                    " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
                    " AND ccbcdocu.flgest = 'P'" +
                    " AND ccbcdocu.coddoc = 'LET'".
      END.
  END.
    RB-OTHER-PARAMETERS = 's-nomcia = ' + s-nomcia.              

  x-Date-Format = SESSION:DATE-FORMAT.
  SESSION:DATE-FORMAT = 'mdy'.
  RB-FILTER = RB-FILTER +
                " AND ccbcdocu.fchdoc >= " + STRING(x-FchDoc-1) +
                " AND ccbcdocu.fchdoc <= " + STRING(x-FChDoc-2).
  SESSION:DATE-FORMAT = x-Date-Format.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Correo D-Dialog 
PROCEDURE Correo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Pasamos la informacion al w-report */
  DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "" NO-UNDO.
  DEF VAR RB-MEMO-FILE AS CHAR INITIAL "" NO-UNDO.
  DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "" NO-UNDO.
  DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "" NO-UNDO.
  DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "" NO-UNDO.
  DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "" NO-UNDO.
  DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1 NO-UNDO.
  DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0 NO-UNDO.
  DEF VAR RB-END-PAGE AS INTEGER INITIAL 0 NO-UNDO.
  DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO NO-UNDO.
  DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "" NO-UNDO.
  DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES NO-UNDO.
  DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES NO-UNDO.
  DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO NO-UNDO.
  DEF VAR RB-STATUS-FILE AS CHAR INITIAL "" NO-UNDO.

  DEFINE VAR s-print-file AS CHAR INIT 'Archivo_texto.txt' NO-UNDO.
  DEFINE VAR rpta AS LOG NO-UNDO.

  SYSTEM-DIALOG GET-FILE s-print-file
      FILTERS "txt" "*.txt"
      ASK-OVERWRITE
      CREATE-TEST-FILE
      DEFAULT-EXTENSION ".txt"
      SAVE-AS
      TITLE "Archivo de salida"
      USE-FILENAME
      UPDATE rpta.
  IF rpta = NO THEN RETURN.
      
  DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.
  
  GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
  GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
  GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
  GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
  GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.
  
  ASSIGN cDelimeter = CHR(32).
  IF NOT (cDatabaseName = ? OR
      cHostName = ? OR
      cNetworkProto = ? OR
      cPortNumber = ?) THEN DO:
      ASSIGN
          cNewConnString =
          "-db" + cDelimeter + cDatabaseName + cDelimeter +
          "-H" + cDelimeter + cHostName + cDelimeter +
          "-N" + cDelimeter + cNetworkProto + cDelimeter +
          "-S" + cDelimeter + cPortNumber + cDelimeter.
      RB-DB-CONNECTION = cNewConnString.
  END.

  RUN Carga-Impresion.
  /************************  PUNTEROS EN POSICION  *******************************/
  ASSIGN
      RB-BEGIN-PAGE = 1
      RB-END-PAGE   = 999999
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = 1.

  RB-PRINT-DESTINATION = "A".   /* Archivo */

  RUN aderb/_prntrb2(
                     RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-DB-CONNECTION,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-MEMO-FILE,
                     RB-PRINT-DESTINATION,
                     RB-PRINTER-NAME,
                     RB-PRINTER-PORT,
                     RB-OUTPUT-FILE,
                     RB-NUMBER-COPIES,
                     RB-BEGIN-PAGE,
                     RB-END-PAGE,
                     RB-TEST-PATTERN,
                     RB-WINDOW-TITLE,
                     RB-DISPLAY-ERRORS,
                     RB-DISPLAY-STATUS,
                     RB-NO-WAIT,
                     RB-OTHER-PARAMETERS,
                     RB-STATUS-FILE
                     ).

  DEF VAR pEmailTo AS CHAR.
  DEF VAR pAttach  AS CHAR.
  DEF VAR pBody    AS CHAR.

  pAttach = s-print-file.
  pBody = s-print-file.
  RUN lib/d-sendmail ( 
      INPUT "",
      INPUT gn-clie.E-Mail, 
      INPUT "Estado de Cuenta",
      INPUT pAttach,
      INPUT pBody
      ).

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
  DISPLAY x-FchDoc-1 x-FchDoc-2 tg-dudosa tg-Letras 
      WITH FRAME D-Dialog.
  IF AVAILABLE gn-clie THEN 
    DISPLAY gn-clie.CodCli gn-clie.NomCli 
      WITH FRAME D-Dialog.
  ENABLE RECT-62 x-FchDoc-1 x-FchDoc-2 tg-dudosa tg-Letras Btn_OK BUTTON-10 
         Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime D-Dialog 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-Date-Format AS CHAR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  ASSIGN
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'ccb/rbccb.prl'
    RB-REPORT-NAME = 'Carta Estado de Cuenta2'       
    RB-INCLUDE-RECORDS = 'O'.
  IF tg-dudosa THEN DO:
      IF NOT tg-letras THEN DO:
          ASSIGN
              RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
                          " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
                          " AND (ccbcdocu.flgest = 'P'" +
                          " OR  ccbcdocu.flgest = 'J')" +
                          " AND (ccbcdocu.coddoc = 'FAC'" +
                          " OR ccbcdocu.coddoc = 'BOL'"+
                          " OR ccbcdocu.coddoc = 'DCO'"+
                          " OR ccbcdocu.coddoc = 'LET'" +
                          " OR ccbcdocu.coddoc = 'N/C'" +
                          " OR ccbcdocu.coddoc = 'N/D'" +
                          " OR ccbcdocu.coddoc = 'A/R'" +
                          " OR ccbcdocu.coddoc = 'BD'" +
                          " OR ccbcdocu.coddoc = 'CHQ'" +
                          " OR ccbcdocu.coddoc = 'A/C'" +
                          " OR ccbcdocu.coddoc = 'CHC')".
      END.
      ELSE DO:
          ASSIGN
              RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
                          " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
                          " AND (ccbcdocu.flgest = 'P'" +
                          " OR  ccbcdocu.flgest = 'J')" +                          
                          " AND ccbcdocu.coddoc = 'LET'".
      END.
  END.
  ELSE DO:
      IF NOT tg-Letras THEN DO:
          ASSIGN
              RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
                    " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
                    " AND ccbcdocu.flgest = 'P'" +
                    " AND (ccbcdocu.coddoc = 'FAC'" +
                    " OR ccbcdocu.coddoc = 'BOL'"+
                    " OR ccbcdocu.coddoc = 'DCO'"+
                    " OR ccbcdocu.coddoc = 'LET'" +
                    " OR ccbcdocu.coddoc = 'N/C'" +
                    " OR ccbcdocu.coddoc = 'N/D'" +
                    " OR ccbcdocu.coddoc = 'A/R'" +
                    " OR ccbcdocu.coddoc = 'A/C'" +
                    " OR ccbcdocu.coddoc = 'BD'" +
                    " OR ccbcdocu.coddoc = 'CHQ')".
      END.
      ELSE DO:
          ASSIGN
              RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) +
                    " AND ccbcdocu.codcli = '" + TRIM(gn-clie.codcli) + "'" +
                    " AND ccbcdocu.flgest = 'P'" +
                    " AND ccbcdocu.coddoc = 'LET'".
      END.
  END.
    RB-OTHER-PARAMETERS = 's-nomcia = ' + s-nomcia.              

  x-Date-Format = SESSION:DATE-FORMAT.
  SESSION:DATE-FORMAT = 'mdy'.
  RB-FILTER = RB-FILTER +
                " AND ccbcdocu.fchdoc >= " + STRING(x-FchDoc-1) +
                " AND ccbcdocu.fchdoc <= " + STRING(x-FChDoc-2).
  SESSION:DATE-FORMAT = x-Date-Format.
  RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-OTHER-PARAMETERS).

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
  ASSIGN
    x-FchDoc-1 = DATE(01,01,YEAR(TODAY))
    x-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
PROCEDURE Recoge-Parametros :
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "gn-clie"}

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

