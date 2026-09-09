&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-MOV NO-UNDO LIKE INTEGRAL.PL-FLG-MES.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-periodo AS INT.
DEF SHARED VAR s-nromes AS INT.

/* Local Variable Definitions ---                                       */

DEF FRAME F-Mensaje
    " Procesando informacion " SKIP
    " Un momento por favor " SKIP
    WITH NO-LABELS CENTERED OVERLAY VIEW-AS DIALOG-BOX WIDTH 30 TITLE "Mensaje".

DEF VAR s-Button-1 AS LOGICAL INIT TRUE.
DEF VAR s-Button-2 AS LOGICAL INIT FALSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-MOV INTEGRAL.PL-PERS

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 T-MOV.codper ~
INTEGRAL.PL-PERS.patper INTEGRAL.PL-PERS.matper INTEGRAL.PL-PERS.nomper ~
T-MOV.FchIniCont T-MOV.FchFinCont T-MOV.Campo-C[4] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH T-MOV NO-LOCK, ~
      EACH INTEGRAL.PL-PERS OF T-MOV NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH T-MOV NO-LOCK, ~
      EACH INTEGRAL.PL-PERS OF T-MOV NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 T-MOV INTEGRAL.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 T-MOV
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-1 INTEGRAL.PL-PERS


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BUTTON-3 BROWSE-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\proces":U
     IMAGE-INSENSITIVE FILE "adeicon\stop-u":U
     LABEL "Button 1" 
     SIZE 11 BY 1.73 TOOLTIP "Importar EXCEL".

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "adeicon\rbuild%":U
     IMAGE-INSENSITIVE FILE "adeicon\stop-u":U
     LABEL "Button 2" 
     SIZE 11 BY 1.73 TOOLTIP "Actualizar Planilla".

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "adeicon\exit-au":U
     LABEL "Button 3" 
     SIZE 11 BY 1.73 TOOLTIP "Salir".

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      T-MOV, 
      INTEGRAL.PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      T-MOV.codper FORMAT "X(6)":U WIDTH 7.43
      INTEGRAL.PL-PERS.patper FORMAT "X(40)":U WIDTH 16.43
      INTEGRAL.PL-PERS.matper FORMAT "X(40)":U WIDTH 19.43
      INTEGRAL.PL-PERS.nomper FORMAT "X(40)":U WIDTH 19.43
      T-MOV.FchIniCont FORMAT "99/99/9999":U WIDTH 12.43
      T-MOV.FchFinCont FORMAT "99/99/9999":U WIDTH 10.43
      T-MOV.Campo-C[4] COLUMN-LABEL "Reg. MINTRA" FORMAT "x(8)":U
            WIDTH 10.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 103 BY 12.12
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1 COL 2
     BUTTON-2 AT ROW 1 COL 14
     BUTTON-3 AT ROW 1 COL 26
     BROWSE-1 AT ROW 2.92 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 106.86 BY 14.27
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-MOV T "?" NO-UNDO INTEGRAL PL-FLG-MES
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Importación de Còdigos MINTRA"
         HEIGHT             = 14.27
         WIDTH              = 106.86
         MAX-HEIGHT         = 21.12
         MAX-WIDTH          = 106.86
         VIRTUAL-HEIGHT     = 21.12
         VIRTUAL-WIDTH      = 106.86
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB BROWSE-1 BUTTON-3 F-Main */
ASSIGN 
       BROWSE-1:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 1.

/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.T-MOV,INTEGRAL.PL-PERS OF Temp-Tables.T-MOV"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.T-MOV.codper
"T-MOV.codper" ? ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.PL-PERS.patper
"INTEGRAL.PL-PERS.patper" ? ? "character" ? ? ? ? ? ? no ? no no "16.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.PL-PERS.matper
"INTEGRAL.PL-PERS.matper" ? ? "character" ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.PL-PERS.nomper
"INTEGRAL.PL-PERS.nomper" ? ? "character" ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-MOV.FchIniCont
"T-MOV.FchIniCont" ? ? "date" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-MOV.FchFinCont
"T-MOV.FchFinCont" ? ? "date" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-MOV.Campo-C[4]
"T-MOV.Campo-C[4]" "Reg. MINTRA" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Importación de Còdigos MINTRA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Importación de Còdigos MINTRA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  IF s-Button-1 = YES
  THEN DO:
    RUN Carga-Temporal.
    BUTTON-1:LOAD-IMAGE-UP('adeicon/stop-u').
    ASSIGN
        BUTTON-2:SENSITIVE = YES
        s-Button-1 = NO
        s-Button-2 = YES.

  END.
  ELSE DO:
    BUTTON-1:LOAD-IMAGE-UP('img/proces').
    ASSIGN
        BUTTON-2:SENSITIVE = NO
        s-Button-1 = YES
        s-Button-2 = NO.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN Importa.
  IF RETURN-VALUE = 'ADM-ERROR':U
  THEN RETURN NO-APPLY.
  ASSIGN
    BUTTON-2:SENSITIVE = NO
    s-Button-1 = YES
    s-Button-2 = NO.
  BUTTON-1:LOAD-IMAGE-UP('img/proces').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR x-Cab AS CHAR NO-UNDO.
    DEF VAR x-Linea AS CHAR FORMAT 'x(100)'.
    DEF VAR Rpta AS LOG NO-UNDO.
    DEF VAR DiasTrabajados AS INTEGER NO-UNDO.

    /* SOLICITAMOS ARCHIVO */
    SYSTEM-DIALOG GET-FILE x-Cab 
        FILTERS 'Excel (*.xls)' '*.xls' INITIAL-FILTER 1
        RETURN-TO-START-DIR 
        TITLE 'Archivo de conceptos'
        UPDATE Rpta.
    IF Rpta = NO THEN RETURN.

    VIEW FRAME F-Mensaje.

    EMPTY TEMP-TABLE T-MOV.

    /*  ********************************* EXCEL ***************************** */
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet AS COM-HANDLE.

    DEFINE VARIABLE cRange AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iCountLine AS INTEGER NO-UNDO.
    DEFINE VARIABLE iTotalColumn AS INTEGER NO-UNDO.
    DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.

    CREATE "Excel.Application" chExcelApplication.

    chWorkbook = chExcelApplication:Workbooks:OPEN(x-Cab).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    iCountLine = 1.     /* Saltamos el encabezado de los campos */
    REPEAT:
        iCountLine = iCountLine + 1.
        cRange = "A" + TRIM(STRING(iCountLine)).
        cValue = chWorkSheet:Range(cRange):VALUE.
        IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
        /* CODIGO */
        cRange = "A" + TRIM(STRING(iCountLine)).
        cValue = chWorkSheet:Range(cRange):VALUE.
        ASSIGN
            cValue = STRING(INTEGER (cValue), '999999')
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'Valor no reconocido:' cValue SKIP
                'Campo: Código' VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
        /* REGISTRAMOS EL PERSONAL */
        CREATE T-MOV.
        ASSIGN
            T-MOV.CodPer = cValue.
        /* INICIO */
        cRange = "G" + TRIM(STRING(iCountLine)).
        cValue = chWorkSheet:Range(cRange):VALUE.
        ASSIGN
            T-MOV.FchIniCont = DATE (cValue)
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'Valor no reconocido:' cValue SKIP
                'Campo: Fecha de inicio' VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
        /* FIN */
        cRange = "H" + TRIM(STRING(iCountLine)).
        cValue = chWorkSheet:Range(cRange):VALUE.
        ASSIGN
            T-MOV.FchFinCont = DATE (cValue)
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'Valor no reconocido:' cValue SKIP
                'Campo: Fecha de termino' VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
        /* MINTRA */
        cRange = "I" + TRIM(STRING(iCountLine)).
        cValue = chWorkSheet:Range(cRange):VALUE.
        ASSIGN
            T-MOV.Campo-C[4] = STRING (cValue, '999999')
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'Valor no reconocido:' cValue SKIP
                'Campo: MINTRA' VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
    END.
    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 

    /* ********************************************************************** */
    HIDE FRAME F-Mensaje.           
    FIND FIRST T-MOV NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-MOV THEN DO:
        MESSAGE 'Error en el archivo EXCEL' SKIP
            'Haga una copia del archivo y vuelva a intentarlo'
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    {&OPEN-QUERY-BROWSE-1}
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  ENABLE BUTTON-1 BUTTON-3 BROWSE-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importa W-Win 
PROCEDURE Importa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-Cab AS CHAR NO-UNDO.
  DEF VAR x-Det AS CHAR NO-UNDO.

  FIND FIRST T-MOV NO-ERROR.
  IF NOT AVAILABLE T-MOV THEN RETURN 'ADM-ERROR':U.
  MESSAGE 'Confirme Inicio de la Actualización de la Planilla'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta-1 AS LOGICAL.
  IF rpta-1 = NO THEN RETURN 'ADM-ERROR':U.

  VIEW FRAME F-Mensaje.
  FOR EACH T-MOV:
    FIND integral.PL-FLG-MES WHERE INTEGRAL.PL-FLG-MES.CodCia = s-CodCia
        AND INTEGRAL.PL-FLG-MES.Periodo = s-Periodo
        AND INTEGRAL.PL-FLG-MES.NroMes = s-NroMes
        AND INTEGRAL.PL-FLG-MES.codper = T-MOV.CodPer
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.PL-FLG-MES THEN NEXT.
    ASSIGN
        INTEGRAL.PL-FLG-MES.Campo-C[4] = T-MOV.Campo-C[4] 
        INTEGRAL.PL-FLG-MES.FchFinCont = T-MOV.FchFinCont 
        INTEGRAL.PL-FLG-MES.FchIniCont = T-MOV.FchIniCont.
    RELEASE Pl-Flg-Mes.
  END.

  EMPTY TEMP-TABLE T-MOV.

  HIDE FRAME F-Mensaje.
  MESSAGE "Importación Completa" VIEW-AS ALERT-BOX INFORMATION.
  {&OPEN-QUERY-BROWSE-1}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "T-MOV"}
  {src/adm/template/snd-list.i "INTEGRAL.PL-PERS"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
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

