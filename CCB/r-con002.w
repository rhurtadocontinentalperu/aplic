&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE DETALLE NO-UNDO LIKE CcbCDocu
       INDEX Llave01 CodCli
       INDEX Llave02 NomCli.
DEFINE SHARED TEMP-TABLE DOCU LIKE CcbCDocu.



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

/* Local Variable Definitions ---                                       */

DEF INPUT PARAMETER s-CodCia AS INT.
DEF INPUT PARAMETER s-CodDiv AS CHAR.
DEF INPUT PARAMETER s-FlgEst AS CHAR.
DEF INPUT PARAMETER s-NroOrd AS CHAR.

DEF VARIABLE x-fchcob AS DATE.

DEF VAR x-Moneda AS CHAR FORMAT 'x(3)' NO-UNDO.

DEF VAR x-CodCli LIKE Ccbcdocu.codcli NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES DETALLE DOCU

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 DETALLE.CodCli DETALLE.NomCli ~
DETALLE.ImpTot DETALLE.imptot2 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH DETALLE NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH DETALLE NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 DETALLE
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 DETALLE


/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 DOCU.CodDiv DOCU.CodDoc DOCU.NroDoc ~
DOCU.FchDoc DOCU.FchVto DOCU.FchCobranza _Moneda(DOCU.CodMon) @ x-Moneda ~
DOCU.ImpTot DOCU.SdoAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH DOCU ~
      WHERE DOCU.CodCia = s-codcia ~
 AND DOCU.CodDiv BEGINS s-CodDiv ~
 AND DOCU.FlgEst = s-FlgEst ~
 AND DOCU.NroOrd = s-NroOrd ~
 AND DOCU.CodCli = x-CodCli NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH DOCU ~
      WHERE DOCU.CodCia = s-codcia ~
 AND DOCU.CodDiv BEGINS s-CodDiv ~
 AND DOCU.FlgEst = s-FlgEst ~
 AND DOCU.NroOrd = s-NroOrd ~
 AND DOCU.CodCli = x-CodCli NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 DOCU
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 DOCU


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-3 BROWSE-4 b-ingfch Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS x-ImpMn x-ImpMe 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _Moneda D-Dialog 
FUNCTION _Moneda RETURNS CHARACTER
  ( INPUT pCodMon AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-ingfch 
     LABEL "Fecha Cobranza" 
     SIZE 15 BY 1.12.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Aceptar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE x-ImpMe AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "Saldo US$" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 1 NO-UNDO.

DEFINE VARIABLE x-ImpMn AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "Saldo S/." 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      DETALLE SCROLLING.

DEFINE QUERY BROWSE-4 FOR 
      DOCU SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 D-Dialog _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      DETALLE.CodCli COLUMN-LABEL "<<<Cliente>>>" FORMAT "x(11)":U
      DETALLE.NomCli FORMAT "x(50)":U
      DETALLE.ImpTot COLUMN-LABEL "Saldo Actual S/." FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
      DETALLE.imptot2 COLUMN-LABEL "Saldo Actual US$" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 75 BY 8.46
         FONT 4.

DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 D-Dialog _STRUCTURED
  QUERY BROWSE-4 DISPLAY
      DOCU.CodDiv COLUMN-LABEL "Division" FORMAT "x(5)":U
      DOCU.CodDoc COLUMN-LABEL "Doc." FORMAT "x(3)":U
      DOCU.NroDoc COLUMN-LABEL "<<Numero>>" FORMAT "X(12)":U
      DOCU.FchDoc COLUMN-LABEL "<<Emision>>" FORMAT "99/99/9999":U
      DOCU.FchVto COLUMN-LABEL "Vencimiento" FORMAT "99/99/9999":U
      DOCU.FchCobranza COLUMN-LABEL "Cobranza" FORMAT "99/99/9999":U
      _Moneda(DOCU.CodMon) @ x-Moneda COLUMN-LABEL "Mon." FORMAT "x(3)":U
      DOCU.ImpTot FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
      DOCU.SdoAct COLUMN-LABEL "Saldo Actual" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS MULTIPLE SIZE 77 BY 4.5
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-3 AT ROW 1.38 COL 2.86
     x-ImpMn AT ROW 10.04 COL 56 COLON-ALIGNED
     x-ImpMe AT ROW 11 COL 56 COLON-ALIGNED
     BROWSE-4 AT ROW 12.85 COL 2
     b-ingfch AT ROW 18.23 COL 58 WIDGET-ID 2
     Btn_OK AT ROW 18.31 COL 6
     Btn_Cancel AT ROW 19.5 COL 6
     SPACE(61.99) SKIP(1.83)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "<insert SmartDialog title>"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: DETALLE T "?" NO-UNDO INTEGRAL CcbCDocu
      ADDITIONAL-FIELDS:
          INDEX Llave01 CodCli
          INDEX Llave02 NomCli
      END-FIELDS.
      TABLE: DOCU T "SHARED" ? INTEGRAL CcbCDocu
   END-TABLES.
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
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-3 1 D-Dialog */
/* BROWSE-TAB BROWSE-4 x-ImpMe D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN x-ImpMe IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-ImpMn IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.DETALLE"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.DETALLE.CodCli
"DETALLE.CodCli" "<<<Cliente>>>" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.DETALLE.NomCli
     _FldNameList[3]   > Temp-Tables.DETALLE.ImpTot
"DETALLE.ImpTot" "Saldo Actual S/." "(ZZZ,ZZZ,ZZ9.99)" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.DETALLE.imptot2
"DETALLE.imptot2" "Saldo Actual US$" "(ZZZ,ZZZ,ZZ9.99)" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.DOCU"
     _Where[1]         = "Temp-Tables.DOCU.CodCia = s-codcia
 AND Temp-Tables.DOCU.CodDiv BEGINS s-CodDiv
 AND Temp-Tables.DOCU.FlgEst = s-FlgEst
 AND Temp-Tables.DOCU.NroOrd = s-NroOrd
 AND Temp-Tables.DOCU.CodCli = x-CodCli"
     _FldNameList[1]   > Temp-Tables.DOCU.CodDiv
"DOCU.CodDiv" "Division" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.DOCU.CodDoc
"DOCU.CodDoc" "Doc." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.DOCU.NroDoc
"DOCU.NroDoc" "<<Numero>>" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.DOCU.FchDoc
"DOCU.FchDoc" "<<Emision>>" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.DOCU.FchVto
"DOCU.FchVto" "Vencimiento" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.DOCU.FchCobranza
"DOCU.FchCobranza" "Cobranza" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"_Moneda(DOCU.CodMon) @ x-Moneda" "Mon." "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.DOCU.ImpTot
"DOCU.ImpTot" ? "(ZZZ,ZZZ,ZZ9.99)" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.DOCU.SdoAct
"DOCU.SdoAct" "Saldo Actual" "(ZZZ,ZZZ,ZZ9.99)" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* <insert SmartDialog title> */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-ingfch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-ingfch D-Dialog
ON CHOOSE OF b-ingfch IN FRAME D-Dialog /* Fecha Cobranza */
DO:
    DEFINE VARIABLE iInt AS INT NO-UNDO.

    RUN ccb/r-fchcob2 (OUTPUT x-fchcob).  

    DO iInt = 1 TO BROWSE-4:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF BROWSE-4:FETCH-SELECTED-ROW(iInt) IN FRAME {&FRAME-NAME}
        THEN DO:            
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia
                AND ccbcdocu.coddiv = docu.coddiv
                AND ccbcdocu.coddoc = docu.coddoc
                AND ccbcdocu.nrodoc = docu.nrodoc NO-ERROR.
            IF AVAIL ccbcdocu AND ccbcdocu.fchvto <= x-fchcob                      
                THEN DO: 
                ASSIGN 
                    ccbcdocu.fchcobranza = x-fchcob
                    docu.fchcob = x-fchcob.
            END.
            ELSE DO:
                MESSAGE "Fecha ingresada es menor a la fecha de vencimiento" SKIP
                    "Error en documento: " + docu.coddoc + "-" + docu.nrodoc
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.                
            END.
        END.
    END.
    {&OPEN-QUERY-BROWSE-4}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 D-Dialog
ON VALUE-CHANGED OF BROWSE-3 IN FRAME D-Dialog
DO:
  x-CodCli = DETALLE.CodCli.
  {&OPEN-QUERY-BROWSE-4}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */
DEF VAR Titulo AS CHAR NO-UNDO.

CASE s-FlgEst:
    WHEN 'VI' THEN Titulo = 'CARTERA VIGENTE'.
    WHEN 'VE' THEN Titulo = 'CARTERA VENCIDA'.
END CASE.
Titulo = Titulo + ' ' + s-NroOrd.

IF titulo <> "" THEN ASSIGN FRAME {&FRAME-NAME}:TITLE = titulo.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Saldos D-Dialog 
PROCEDURE Calcula-Saldos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF BUFFER B-DOCU FOR DETALLE.
  
  ASSIGN
    x-ImpMe = 0
    x-ImpMn = 0.
  FOR EACH B-DOCU NO-LOCK:
    ASSIGN
        x-ImpMn = x-ImpMn + B-DOCU.ImpTot
        x-ImpMe = x-ImpMe + B-DOCU.IMpTot2.
  END.
  DISPLAY
    x-ImpMe
    x-ImpMn
    WITH FRAME {&FRAME-NAME}.
  
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

  FOR EACH DOCU NO-LOCK WHERE DOCU.CodCia = s-codcia
        AND DOCU.CodDiv BEGINS s-coddiv
        AND DOCU.FlgEst = s-flgest
        AND DOCU.NroOrd = s-nroord:
    FIND DETALLE WHERE DETALLE.codcli = DOCU.codcli
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE DETALLE THEN CREATE DETALLE.
    ASSIGN
        DETALLE.CodCli = DOCU.CodCli
        DETALLE.NomCli = DOCU.NomCli.
    IF DOCU.CodMon = 1
    THEN DETALLE.ImpTot = DETALLE.ImpTot + DOCU.SdoAct.
    ELSE DETALLE.imptot2 = DETALLE.ImpTot2 + DOCU.SdoAct.
  END.
 
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
  DISPLAY x-ImpMn x-ImpMe 
      WITH FRAME D-Dialog.
  ENABLE BROWSE-3 BROWSE-4 b-ingfch Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
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
  RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Calcula-Saldos.

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
  {src/adm/template/snd-list.i "DOCU"}
  {src/adm/template/snd-list.i "DETALLE"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _Moneda D-Dialog 
FUNCTION _Moneda RETURNS CHARACTER
  ( INPUT pCodMon AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE pCodMon:
    WHEN 1 THEN RETURN 'S/.'.
    WHEN 2 THEN RETURN 'US$'.
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

