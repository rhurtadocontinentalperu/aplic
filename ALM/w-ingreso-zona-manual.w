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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-codalm AS CHAR.


/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-w-report

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 btnGrabarExcel BUTTON-3 txtZONA ~
txtDesUbi BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS txtCodAlm txtZONA txtDesUbi 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnGrabarExcel 
     LABEL "Grabar registros de Excel" 
     SIZE 45 BY 1.35.

DEFINE BUTTON BUTTON-2 
     LABEL "Grabar" 
     SIZE 15 BY 1.35.

DEFINE BUTTON BUTTON-3 
     LABEL "Desde Excel" 
     SIZE 25 BY 1.12.

DEFINE VARIABLE txtCodAlm AS CHARACTER FORMAT "X(6)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1.35 NO-UNDO.

DEFINE VARIABLE txtDesUbi AS CHARACTER FORMAT "X(30)":U 
     LABEL "Descrip." 
     VIEW-AS FILL-IN 
     SIZE 44 BY 1.35 NO-UNDO.

DEFINE VARIABLE txtZONA AS CHARACTER FORMAT "X(10)":U 
     LABEL "Ubic" 
     VIEW-AS FILL-IN 
     SIZE 18.86 BY 1.35 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "A" FORMAT "X(6)":U WIDTH 16.14
      tt-w-report.Campo-C[2] COLUMN-LABEL "B" FORMAT "X(25)":U
            WIDTH 50.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 70.72 BY 12.46
         FONT 8 ROW-HEIGHT-CHARS .96 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 8.15 COL 2.29 WIDGET-ID 200
     btnGrabarExcel AT ROW 21 COL 27.86 WIDGET-ID 20
     BUTTON-3 AT ROW 21.19 COL 1.57 WIDGET-ID 18
     txtCodAlm AT ROW 1.19 COL 16.14 COLON-ALIGNED WIDGET-ID 6
     txtZONA AT ROW 2.65 COL 16.14 COLON-ALIGNED WIDGET-ID 10
     txtDesUbi AT ROW 4.19 COL 16.14 COLON-ALIGNED WIDGET-ID 14
     BUTTON-2 AT ROW 1.38 COL 48 WIDGET-ID 12
     "Celda A = CodUbic (6 Caracteres)" VIEW-AS TEXT
          SIZE 57.14 BY 1.12 AT ROW 5.81 COL 2.86 WIDGET-ID 22
          FGCOLOR 4 
     "Celda B = Descrip (25 Caracteres)" VIEW-AS TEXT
          SIZE 58.14 BY 1.12 AT ROW 6.92 COL 2.86 WIDGET-ID 24
          FGCOLOR 4 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 74 BY 21.81
         FONT 8 WIDGET-ID 100.


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
         TITLE              = "Ingreso MANUAL de ZONAS"
         HEIGHT             = 21.81
         WIDTH              = 74
         MAX-HEIGHT         = 21.85
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 21.85
         VIRTUAL-WIDTH      = 80
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 1 F-Main */
/* SETTINGS FOR FILL-IN txtCodAlm IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "A" "X(6)" "character" ? ? ? ? ? ? no ? no no "16.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "B" "X(25)" "character" ? ? ? ? ? ? no ? no no "50.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Ingreso MANUAL de ZONAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ingreso MANUAL de ZONAS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnGrabarExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnGrabarExcel W-Win
ON CHOOSE OF btnGrabarExcel IN FRAME F-Main /* Grabar registros de Excel */
DO:
    MESSAGE 'Seguro que Desea GRABAR?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.

    DEFINE VAR lCodubic AS CHAR.
    DEFINE VAR lDescrip AS CHAR.

    FOR EACH tt-w-report :

        lCodUbic = tt-w-report.campo-c[1].
        lDescrip = tt-w-report.campo-c[2].

        FIND FIRST invZonas WHERE invZonas.codcia = s-codcia AND 
                                invZonas.codalm = s-codalm AND 
                                invZonas.CZona = lCodUbic NO-ERROR.
        IF NOT AVAILABLE invZonas THEN DO:
            CREATE invZonas.
                ASSIGN invZonas.codcia = s-codcia
                        invZonas.codalm = s-codalm
                        invZonas.CZona = lCodUbic.
        END.

        RELEASE invZonas.  

        FIND FIRST almtubi WHERE almtubi.codcia = s-codcia AND 
                                almtubi.codalm = s-codalm AND
                                almtubi.codubi = lCodUbic NO-ERROR.

        IF NOT AVAILABLE almtubi THEN DO:
            CREATE almtubi.
            ASSIGN almtubi.codcia = s-codcia
                    almtubi.codalm = s-codalm
                    almtubi.codubi = lCodUbic
                    almtubi.codzona = "G-0"
                    almtubi.libre_f01 = TODAY
                    almtubi.libre_c01 = STRING(TIME,"HH:MM:SS").
        END.
        ASSIGN almtubi.desubi = lDescrip
            almtubi.libre_f02 = TODAY
            almtubi.libre_c02 = STRING(TIME,"HH:MM:SS").

        RELEASE almtubi.

    END.  

    DISABLE btnGrabarExcel WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Grabar */
DO:

    ASSIGN txtCodAlm txtZona txtDesUbi.

    IF txtZona = '' THEN DO:
        APPLY 'ENTRY':U TO txtZona.
        RETURN NO-APPLY.
    END.
    IF txtDesUbi = '' THEN DO:
        APPLY 'ENTRY':U TO txtDesUbi.
        RETURN NO-APPLY.
    END.

    MESSAGE 'Desea GRABAR, la Ubicacion?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.

    FIND FIRST invZonas WHERE invZonas.codcia = s-codcia AND 
                            invZonas.codalm = s-codalm AND 
                            invZonas.CZona = txtZona NO-ERROR.
    IF AVAILABLE invZonas THEN DO:
        RELEASE invZonas.
        MESSAGE "Zona ya esta Registrada".
        APPLY 'ENTRY':U TO txtZona.
        RETURN NO-APPLY.
    END.

    CREATE invZonas.
        ASSIGN invZonas.codcia = s-codcia
                invZonas.codalm = s-codalm
                invZonas.CZona = txtZona.

    RELEASE invZonas.  

    FIND FIRST almtubi WHERE almtubi.codcia = s-codcia AND 
                            almtubi.codalm = s-codalm AND
                            almtubi.codubi = txtZona NO-ERROR.

    IF NOT AVAILABLE almtubi THEN DO:
        CREATE almtubi.
        ASSIGN almtubi.codcia = s-codcia
                almtubi.codalm = s-codalm
                almtubi.codubi = txtZona
                almtubi.codzona = "G-0"
                almtubi.libre_f01 = TODAY
                almtubi.libre_c01 = STRING(TIME,"HH:MM:SS").
    END.
    ASSIGN almtubi.desubi = txtDesUbi
        almtubi.libre_f02 = TODAY
        almtubi.libre_c02 = STRING(TIME,"HH:MM:SS").


    txtZona:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
    APPLY 'ENTRY':U TO txtZona.
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Desde Excel */
DO:
    DEFINE VAR X-archivo AS CHAR.
    DEFINE VAR OkPressed AS LOG.

          SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS "Archivo (*.xlsx)" "*.xlsx"
            MUST-EXIST
            TITLE "Seleccione archivo..."
            UPDATE OKpressed.   
          IF OKpressed = NO THEN RETURN.



        DEFINE VARIABLE lFileXls                 AS CHARACTER.
        DEFINE VARIABLE lNuevoFile               AS LOG.
    DEFINE VAR cValue AS CHAR.

        lFileXls = x-Archivo.           /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
        lNuevoFile = NO.        /* YES : Si va crear un nuevo archivo o abrir */
        
    {lib\excel-open-file.i}

        chExcelApplication:Visible = FALSE.

        lMensajeAlTerminar = NO. /*  */
        lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */

    chWorkSheet = chExcelApplication:Sheets:Item(1).  

        iColumn = 1.

    DEFINE VAR lDescrip AS CHAR.

        REPEAT iColumn = 1 TO 65000:
            cRange = "A" + TRIM(STRING(iColumn)).
            cValue = chWorkSheet:Range(cRange):VALUE.

            IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */

            cRange = "B" + TRIM(STRING(iColumn)).
            lDescrip = chWorkSheet:Range(cRange):VALUE.

        IF lDescrip = "" OR lDescrip = ? THEN lDescrip = cValue.

        CREATE tt-w-report.
            ASSIGN tt-w-report.campo-C[1] = SUBSTRING(cValue + FILL(" ", 6), 1,7)
                tt-w-report.campo-C[2] = lDescrip.

        END.

    {lib\excel-close-file.i} 

    {&OPEN-QUERY-BROWSE-2}
  
    ENABLE btnGrabarExcel WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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
  DISPLAY txtCodAlm txtZONA txtDesUbi 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-2 btnGrabarExcel BUTTON-3 txtZONA txtDesUbi BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  txtCodAlm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s-codalm.

  DISABLE btnGrabarExcel WITH FRAME {&FRAME-NAME}.

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

