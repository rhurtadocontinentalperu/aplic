&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-w-report

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-F[1] tt-w-report.Campo-F[2] ~
tt-w-report.Campo-C[3] tt-w-report.Campo-C[4] tt-w-report.Campo-C[5] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH tt-w-report NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH tt-w-report NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BROWSE-4 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS txtExcel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 4.57 BY .96
     FONT 8.

DEFINE BUTTON BUTTON-2 
     LABEL "Cargar pesos y volumenes" 
     SIZE 26 BY 1.12.

DEFINE VARIABLE txtExcel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Excel" 
     VIEW-AS FILL-IN 
     SIZE 114 BY 1
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "Cod.Art" FORMAT "X(8)":U
      tt-w-report.Campo-C[2] COLUMN-LABEL "Descripcion Articulo" FORMAT "X(60)":U
            WIDTH 36.86
      tt-w-report.Campo-F[1] COLUMN-LABEL "Peso Uni Kgr" FORMAT "->,>>>,>>9.9999":U
            WIDTH 11.57
      tt-w-report.Campo-F[2] COLUMN-LABEL "Volumen Uni (cm3)" FORMAT "->,>>>,>>9.9999":U
            WIDTH 16.43
      tt-w-report.Campo-C[3] COLUMN-LABEL "Familia" FORMAT "X(50)":U
            WIDTH 24.57
      tt-w-report.Campo-C[4] COLUMN-LABEL "Sub-Familia" FORMAT "X(50)":U
            WIDTH 24.43
      tt-w-report.Campo-C[5] COLUMN-LABEL "Marca" FORMAT "X(40)":U
            WIDTH .29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 124.14 BY 19.15 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtExcel AT ROW 1.35 COL 2.43 WIDGET-ID 2
     BUTTON-1 AT ROW 1.35 COL 122 WIDGET-ID 4
     BROWSE-4 AT ROW 2.65 COL 1.86 WIDGET-ID 200
     BUTTON-2 AT ROW 22.23 COL 94 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 127.43 BY 22.62 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Carga de pesos y volumenes"
         HEIGHT             = 22.62
         WIDTH              = 127.43
         MAX-HEIGHT         = 22.62
         MAX-WIDTH          = 127.43
         VIRTUAL-HEIGHT     = 22.62
         VIRTUAL-WIDTH      = 127.43
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
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-4 BUTTON-1 F-Main */
/* SETTINGS FOR FILL-IN txtExcel IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"Campo-C[1]" "Cod.Art" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"Campo-C[2]" "Descripcion Articulo" "X(60)" "character" ? ? ? ? ? ? no ? no no "36.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-F[1]
"Campo-F[1]" "Peso Uni Kgr" "->,>>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "11.57" yes no no "U" "" "" "FILL-IN" "," ? ? 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-F[2]
"Campo-F[2]" "Volumen Uni (cm3)" "->,>>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "16.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[3]
"Campo-C[3]" "Familia" "X(50)" "character" ? ? ? ? ? ? no ? no no "24.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-C[4]
"Campo-C[4]" "Sub-Familia" "X(50)" "character" ? ? ? ? ? ? no ? no no "24.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-C[5]
"Campo-C[5]" "Marca" "X(40)" "character" ? ? ? ? ? ? no ? no no ".29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Carga de pesos y volumenes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Carga de pesos y volumenes */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:
    ASSIGN txtExcel.
    /*IF txtExcel = "" THEN RETURN NO-APPLY.*/

    DEFINE VAR x-archivo AS CHAR.
    DEFINE VAR OKpressed AS LOG.

          SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS "Excel (*.xls, *.xlsx)" "*.xls;*.xlsx"
            MUST-EXIST
            TITLE "Seleccione archivo..."
            UPDATE OKpressed.   
          IF OKpressed = NO THEN RETURN.
      
/*
          SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS 'Excel' '*.xlsx'
            ASK-OVERWRITE
            CREATE-TEST-FILE
            DEFAULT-EXTENSION '.xlsx'
            INITIAL-DIR 'c:\tmp'
            RETURN-TO-START-DIR 
            USE-FILENAME
            SAVE-AS
            UPDATE x-rpta.
          IF x-rpta = NO THEN RETURN.
*/

      txtExcel:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-archivo.

      RUN procesar-excel(INPUT x-archivo).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Cargar pesos y volumenes */
DO:
  RUN grabar-pesos-volumenes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

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
  DISPLAY txtExcel 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 BROWSE-4 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-pesos-volumenes W-Win 
PROCEDURE grabar-pesos-volumenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
MESSAGE 'Seguro de GRABAR pesos y volumenes?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

FIND FIRST tt-w-report NO-LOCK NO-ERROR.
IF NOT AVAILABLE tt-w-report THEN DO:
   MESSAGE 'No existen pesos y volumenes a cargar'
       VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
END.

DEFINE VAR cArt AS CHAR.

SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH tt-w-report WHERE tt-w-report.campo-f[3] = 0 NO-LOCK:

    cArt = tt-w-report.campo-c[1].

    FIND FIRST almmmatg WHERE codcia = s-codcia AND codmat = cArt EXCLUSIVE NO-ERROR.
    IF AVAILABLE almmmatg THEN DO:
        ASSIGN almmmatg.pesmat = tt-w-report.campo-f[1]
                almmmatg.libre_d02 = tt-w-report.campo-f[2].
    END.
END.
RELEASE almmmatg.

SESSION:SET-WAIT-STATE('').

MESSAGE 'Proceso Terminado ' VIEW-AS ALERT-BOX INFORMATION.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-excel W-Win 
PROCEDURE procesar-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pFileXls AS CHAR.

DEFINE VAR lFileXls AS CHARACTER.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE lLinea AS INT.
DEFINE VARIABLE cCelda AS CHARACTER.
DEFINE VARIABLE cArt AS CHARACTER.
DEFINE VARIABLE cValor AS CHARACTER.
DEFINE VARIABLE lOk AS CHARACTER.

DEF VAR dPeso AS DECIMAL.
DEF VAR dVolmn AS DECIMAL.

/*"C:\Ciman\Atenciones\Pesos y Volumenes\Plantilla Pesos y Volumenes 050417-27Abr2017.xlsx".*/
ASSIGN lFIleXls = pFileXls.
    
/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = FALSE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:OPEN(lFIleXls).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

SESSION:SET-WAIT-STATE('GENERAL').

DISABLE TRIGGERS FOR LOAD OF ALMMMATG.

EMPTY TEMP-TABLE tt-w-report.

REPEAT lLinea = 2 TO 65000:
    cCelda = "A" + STRING(lLinea).
    cArt = chWorkSheet:Range(cCelda):Value.

    lOk = 'OK'.

    IF cArt = "" OR cArt = ? THEN LEAVE.    /* FIN DE DATOS */

    IF lOk = "OK" THEN DO :        
        CREATE tt-w-report.
            ASSIGN tt-w-report.campo-c[1] = cArt.

        FIND FIRST almmmatg WHERE codcia = s-codcia AND codmat = cArt NO-LOCK NO-ERROR.
        IF AVAILABLE almmmatg THEN DO:
            cCelda = "P" + STRING(lLinea).
            dPeso = ROUND(chWorkSheet:Range(cCelda):Value,4).
            cCelda = "Q" + STRING(lLinea).
            dVolmn = ROUND(chWorkSheet:Range(cCelda):Value,4).

            FIND FIRST almtfam OF almmmatg NO-LOCK NO-ERROR.
            FIND FIRST almsfam OF almmmatg NO-LOCK NO-ERROR.

            ASSIGN tt-w-report.campo-c[2] = almmmatg.desmat
                    tt-w-report.campo-c[3] = IF(AVAILABLE almtfam) THEN almtfam.desfam ELSE " *** ??? ****"
                    tt-w-report.campo-c[4] = IF(AVAILABLE almsfam) THEN almsfam.dessub ELSE "*** ??? ***"
                    tt-w-report.campo-c[5] = almmmatg.desmar
                    tt-w-report.campo-f[1] = dPeso
                    tt-w-report.campo-f[2] = dVolmn
                    tt-w-report.campo-f[3] = 0.
            /*
            ASSIGN almmmatg.pesmat = dPeso
                    almmmatg.libre_d02 = dVolmn.
            */
        END.
        ELSE DO:
            ASSIGN tt-w-report.campo-c[2] = " ***** ERROR NO EXISTE ************"
                    tt-w-report.campo-f[3] = -99.
            
        END.
        PAUSE 0.
    END.

END.

RELEASE almmmatg.

SESSION:SET-WAIT-STATE('').

/*chExcelApplication:Visible = TRUE.*/
chExcelApplication:DisplayAlerts = False.
chExcelApplication:Quit().

/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.

{&OPEN-QUERY-BROWSE-4}

SESSION:SET-WAIT-STATE('').

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
  {src/adm/template/snd-list.i "tt-w-report"}

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

