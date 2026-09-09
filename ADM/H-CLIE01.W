&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME H-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS H-Dialog 
CREATE WIDGET-POOL.

/* Parameters Definitions ---                                           */


&IF "{&NEW}" = "" &THEN 
    DEFINE INPUT  PARAMETER    s-codcia    AS INTEGER.
    DEFINE OUTPUT PARAMETER   ROWID-RETURN AS ROWID.
&ELSE
    DEFINE VARIABLE  s-codcia AS INTEGER INIT 1.
    DEFINE VARIABLE  ROWID-RETURN AS ROWID .
&ENDIF


/* Local Variable Definitions ---                                       */
DEFINE VARIABLE ROWID-BROWSE-1 AS ROWID NO-UNDO.
DEFINE VARIABLE WAIT-STATE     AS LOGICAL NO-UNDO.
DEFINE VARIABLE cb-niveles AS CHAR.
DEFINE VARIABLE cb-codcia AS INTEGER INIT 0.

FIND EMPRESAS WHERE EMPRESAS.CODCIA = s-codcia NO-LOCK NO-ERROR.
IF NOT EMPRESAS.CAMPO-CODPRO THEN cb-codcia = s-codcia.

WAIT-STATE = SESSION:SET-WAIT-STATE("").

/* Preprocesadores de configuraci¢n */
&GLOBAL-DEFINE CONDICION gn-clie.CODCIA = cb-codcia 


&GLOBAL-DEFINE CODIGO  gn-clie.CODCLI

&GLOBAL-DEFINE NOMBRE gn-clie.NOMCLI

&GLOBAL-DEFINE SORTEO-CODIGO 

&GLOBAL-DEFINE SORTEO-NOMBRE BY gn-clie.nomCLI

&GLOBAL-DEFINE WORK-INDEX SI

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME H-Dialog
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.gn-clie

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 integral.gn-clie.CodCli ~
integral.gn-clie.NomCli integral.gn-clie.Codpos integral.gn-clie.DirCli ~
integral.gn-clie.Ruc integral.gn-clie.Fching 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH integral.gn-clie NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 integral.gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 integral.gn-clie


/* Definitions for DIALOG-BOX H-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-H-Dialog ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-6 COMBO-BOX-2 BROWSE-1 ~
FILL-IN-CODIGO Btn_OK FILL-IN-NOMBRE Btn_Cancel COMBO-BOX-1 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-2 FILL-IN-CODIGO FILL-IN-NOMBRE ~
COMBO-BOX-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 11.57 BY 1.35
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Aceptar" 
     SIZE 11.57 BY 1.35
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "C¢digos" 
     LABEL "Mostrar ordenado por" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "C¢digos","Nombres" 
     SIZE 16 BY 1
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE COMBO-BOX-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Nombres que inicie con" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "Nombres que inicie con","Nombres que contenga" 
     SIZE 26 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-CODIGO AS CHARACTER FORMAT "X(256)":U 
     LABEL "Clientes" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-NOMBRE AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.29 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59 BY 2.62.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59 BY 1.96.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      integral.gn-clie SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 H-Dialog _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      integral.gn-clie.CodCli FORMAT "x(13)"
      integral.gn-clie.NomCli
      integral.gn-clie.Codpos COLUMN-LABEL "CodPos"
      integral.gn-clie.DirCli
      integral.gn-clie.Ruc
      integral.gn-clie.Fching
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 59 BY 9.27
         BGCOLOR 15 FGCOLOR 4 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME H-Dialog
     COMBO-BOX-2 AT ROW 2.35 COL 2 NO-LABEL
     BROWSE-1 AT ROW 3.77 COL 1
     FILL-IN-CODIGO AT ROW 1.27 COL 6.14 COLON-ALIGNED
     Btn_OK AT ROW 13.35 COL 15.14
     FILL-IN-NOMBRE AT ROW 2.35 COL 28.72 NO-LABEL
     Btn_Cancel AT ROW 13.35 COL 34.43
     COMBO-BOX-1 AT ROW 1.27 COL 27.57
     RECT-4 AT ROW 1 COL 1
     RECT-6 AT ROW 13.12 COL 1
     SPACE(0.01) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Clientes".


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
/* SETTINGS FOR DIALOG-BOX H-Dialog
                                                                        */
/* BROWSE-TAB BROWSE-1 COMBO-BOX-2 H-Dialog */
ASSIGN 
       FRAME H-Dialog:SCROLLABLE       = FALSE
       FRAME H-Dialog:HIDDEN           = TRUE.

ASSIGN 
       BROWSE-1:NUM-LOCKED-COLUMNS IN FRAME H-Dialog = 1.

/* SETTINGS FOR COMBO-BOX COMBO-BOX-1 IN FRAME H-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-2 IN FRAME H-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-NOMBRE IN FRAME H-Dialog
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "integral.gn-clie"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > integral.gn-clie.CodCli
"CodCli" ? "x(13)" "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   = integral.gn-clie.NomCli
     _FldNameList[3]   > integral.gn-clie.Codpos
"Codpos" "CodPos" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   = integral.gn-clie.DirCli
     _FldNameList[5]   = integral.gn-clie.Ruc
     _FldNameList[6]   = integral.gn-clie.Fching
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX H-Dialog
/* Query rebuild information for DIALOG-BOX H-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX H-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB H-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME H-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL H-Dialog H-Dialog
ON GO OF FRAME H-Dialog /* Clientes */
DO:
  
  &IF "{&TABLES-IN-QUERY-{&BROWSE-NAME}}" <> ""
  &THEN
  ROWID-RETURN = ROWID( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} ).
  &ENDIF
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL H-Dialog H-Dialog
ON WINDOW-CLOSE OF FRAME H-Dialog /* Clientes */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 H-Dialog
ON MOUSE-SELECT-DBLCLICK OF BROWSE-1 IN FRAME H-Dialog
OR RETURN OF BROWSE-1
DO:
  APPLY "CHOOSE":U TO Btn_OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-1 H-Dialog
ON VALUE-CHANGED OF COMBO-BOX-1 IN FRAME H-Dialog /* Mostrar ordenado por */
DO:
  IF INPUT COMBO-BOX-1 <> COMBO-BOX-1
  THEN RUN OPEN-QUERY.
  ASSIGN COMBO-BOX-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-2 H-Dialog
ON VALUE-CHANGED OF COMBO-BOX-2 IN FRAME H-Dialog
DO:
  IF INPUT COMBO-BOX-2 <> COMBO-BOX-2
  THEN IF FILL-IN-NOMBRE:SCREEN-VALUE <> "" THEN RUN OPEN-QUERY.
  ASSIGN COMBO-BOX-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CODIGO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CODIGO H-Dialog
ON LEAVE OF FILL-IN-CODIGO IN FRAME H-Dialog /* Clientes */
DO:
  IF SELF:SCREEN-VALUE = ""
  THEN RETURN.
  
  &IF "{&TABLES-IN-QUERY-{&BROWSE-NAME}}" <> "" AND "{&CODIGO}" <> ""
  &THEN
      IF SELF:SCREEN-VALUE <> ""
      THEN DO:
        FIND FIRST {&TABLES-IN-QUERY-{&BROWSE-NAME}} WHERE
              ( {&CODIGO} = INPUT FILL-IN-CODIGO )
             &IF "{&CONDICION}" <> ""
             &THEN AND {&CONDICION}
             &ENDIF
              NO-LOCK NO-ERROR.
        IF NOT AVAILABLE {&TABLES-IN-QUERY-{&BROWSE-NAME}} 
        THEN DO:
            MESSAGE "REGISTRO NO ENCONTRADO" VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = "".
            RETURN.
        END.
      END.
      ROWID-BROWSE-1 = ROWID( {&TABLES-IN-QUERY-{&BROWSE-NAME}} ).
      REPOSITION {&BROWSE-NAME} TO ROWID ROWID-BROWSE-1 NO-ERROR.
      IF ERROR-STATUS:ERROR
      THEN DO:
        MESSAGE "Registro no se encuentra en la actual selecci¢n" SKIP
                "       ¨ Deshacer la actual selecci¢n ?        " 
                VIEW-AS ALERT-BOX QUESTION 
                BUTTONS YES-NO TITLE "Interrogante"
                UPDATE answ AS LOGICAL.
        IF answ
        THEN DO:
            FILL-IN-NOMBRE:SCREEN-VALUE = "".
            RUN OPEN-QUERY.
            REPOSITION {&BROWSE-NAME} TO ROWID ROWID-BROWSE-1 NO-ERROR.
        END.        
      END.
      SELF:SCREEN-VALUE = "".
  &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NOMBRE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NOMBRE H-Dialog
ON LEAVE OF FILL-IN-NOMBRE IN FRAME H-Dialog
DO:
  IF INPUT FILL-IN-NOMBRE <> FILL-IN-NOMBRE
  THEN RUN OPEN-QUERY.
  ASSIGN FILL-IN-NOMBRE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK H-Dialog 


/* ***************************  Main Block  *************************** */

&IF "{&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}" <> ""
&THEN &UNDEFINE OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}
&ENDIF

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects H-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available H-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI H-Dialog _DEFAULT-DISABLE
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
  HIDE FRAME H-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI H-Dialog _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-2 FILL-IN-CODIGO FILL-IN-NOMBRE COMBO-BOX-1 
      WITH FRAME H-Dialog.
  ENABLE RECT-4 RECT-6 COMBO-BOX-2 BROWSE-1 FILL-IN-CODIGO Btn_OK 
         FILL-IN-NOMBRE Btn_Cancel COMBO-BOX-1 
      WITH FRAME H-Dialog.
  VIEW FRAME H-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-H-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize H-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     COMBO-BOX-1:SCREEN-VALUE = ENTRY(1,COMBO-BOX-1:LIST-ITEMS).
  END.
  RUN OPEN-QUERY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OPEN-QUERY H-Dialog 
PROCEDURE OPEN-QUERY :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:    
    CASE COMBO-BOX-1:SCREEN-VALUE:
        WHEN COMBO-BOX-1:ENTRY(1) THEN RUN OPEN-QUERY-CODIGO.
        WHEN COMBO-BOX-1:ENTRY(2) THEN RUN OPEN-QUERY-NOMBRE.
    END CASE.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OPEN-QUERY-CODIGO H-Dialog 
PROCEDURE OPEN-QUERY-CODIGO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    &IF "{&TABLES-IN-QUERY-{&BROWSE-NAME}}" <> ""
    &THEN
        &IF "{&NOMBRE}" <> ""
        &THEN
            IF FILL-IN-NOMBRE:SCREEN-VALUE = "" 
            THEN
        &ENDIF
            OPEN QUERY {&BROWSE-NAME} FOR EACH {&TABLES-IN-QUERY-{&BROWSE-NAME}}
            &IF "{&CONDICION}" <> ""
            &THEN WHERE ( {&CONDICION } ) 
             &ENDIF        ~
             NO-LOCK
             {&SORTEO-CODIGO}.
        &IF "{&NOMBRE}" <> ""
        &THEN
          ELSE
            IF COMBO-BOX-2:SCREEN-VALUE = COMBO-BOX-2:ENTRY(1)
            THEN
                OPEN QUERY {&BROWSE-NAME} FOR EACH {&TABLES-IN-QUERY-{&BROWSE-NAME}} ~
                 WHERE 
                 &IF "{&CONDICION}" <> ""
                 &THEN ( {&CONDICION } ) AND
                 &ENDIF
                 {&NOMBRE} BEGINS FILL-IN-NOMBRE:SCREEN-VALUE
                 NO-LOCK
                 {&SORTEO-CODIGO}.
              ELSE
                OPEN QUERY {&BROWSE-NAME} FOR EACH {&TABLES-IN-QUERY-{&BROWSE-NAME}} ~
                 WHERE 
                 &IF "{&CONDICION}" <> ""
                 &THEN ( {&CONDICION } ) AND
                 &ENDIF
                 &IF "{&WORK-INDEX}" = "SI"
                 &THEN {&NOMBRE} CONTAINS FILL-IN-NOMBRE:SCREEN-VALUE
                 &ELSE INDEX( {&NOMBRE}, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0
                 &ENDIF
                 NO-LOCK
                 {&SORTEO-CODIGO}.
        &ENDIF
    &ENDIF
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OPEN-QUERY-NOMBRE H-Dialog 
PROCEDURE OPEN-QUERY-NOMBRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    &IF "{&TABLES-IN-QUERY-{&BROWSE-NAME}}" <> ""
    &THEN
        &IF "{&NOMBRE}" <> ""
        &THEN
            IF FILL-IN-NOMBRE:SCREEN-VALUE = "" 
            THEN
        &ENDIF
            OPEN QUERY {&BROWSE-NAME} FOR EACH {&TABLES-IN-QUERY-{&BROWSE-NAME}}
            &IF "{&CONDICION}" <> ""
            &THEN WHERE ( {&CONDICION } ) 
             &ENDIF        ~
             NO-LOCK
             {&SORTEO-NOMBRE}.
        &IF "{&NOMBRE}" <> ""
        &THEN
          ELSE
            IF COMBO-BOX-2:SCREEN-VALUE = COMBO-BOX-2:ENTRY(1)
            THEN
                OPEN QUERY {&BROWSE-NAME} FOR EACH {&TABLES-IN-QUERY-{&BROWSE-NAME}} ~
                 WHERE 
                 &IF "{&CONDICION}" <> ""
                 &THEN ( {&CONDICION } ) AND
                 &ENDIF
                 {&NOMBRE} BEGINS FILL-IN-NOMBRE:SCREEN-VALUE
                 NO-LOCK
                 {&SORTEO-CODIGO}.
              ELSE
                OPEN QUERY {&BROWSE-NAME} FOR EACH {&TABLES-IN-QUERY-{&BROWSE-NAME}} ~
                 WHERE 
                 &IF "{&CONDICION}" <> ""
                 &THEN ( {&CONDICION } ) AND
                 &ENDIF
                 &IF "{&WORK-INDEX}" = "SI"
                 &THEN {&NOMBRE} CONTAINS FILL-IN-NOMBRE:SCREEN-VALUE
                 &ELSE INDEX( {&NOMBRE}, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0
                 &ENDIF
                 NO-LOCK
                 {&SORTEO-NOMBRE}.
        &ENDIF
    &ENDIF
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records H-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.gn-clie"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed H-Dialog 
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


