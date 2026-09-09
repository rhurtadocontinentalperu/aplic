&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
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

DEF SHARED VAR s-codcia AS INT.

DEF VAR s-coddoc AS CHAR INIT 'FAI' NO-UNDO.
DEF VAR s-flgest AS CHAR INIT 'P' NO-UNDO.

&SCOPED-DEFINE Condicion (Ccbcdocu.codcia = s-codcia ~
AND Ccbcdocu.coddoc = s-coddoc ~
AND Ccbcdocu.flgest = s-flgest )

DEF TEMP-TABLE Detalle
    FIELD FchDoc LIKE Ccbcdocu.fchdoc
    FIELD CodDoc LIKE Ccbcdocu.coddoc
    FIELD NroDoc LIKE Ccbcdocu.nrodoc
    FIELD CodCli LIKE Ccbcdocu.codcli
    FIELD NomCli LIKE Ccbcdocu.nomcli
    FIELD ImpTot LIKE Ccbcdocu.imptot
    FIELD SdoAct LIKE Ccbcdocu.sdoact   COLUMN-LABEL 'Saldo Actual'
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-FAI

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu FacTabla

/* Definitions for BROWSE BROWSE-FAI                                    */
&Scoped-define FIELDS-IN-QUERY-BROWSE-FAI CcbCDocu.FchDoc CcbCDocu.CodDoc ~
CcbCDocu.NroDoc CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.ImpTot ~
CcbCDocu.SdoAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-FAI 
&Scoped-define QUERY-STRING-BROWSE-FAI FOR EACH CcbCDocu ~
      WHERE {&Condicion} NO-LOCK, ~
      EACH FacTabla WHERE FacTabla.CodCia = CcbCDocu.CodCia ~
  AND FacTabla.Codigo = CcbCDocu.CodCli ~
      AND FacTabla.Tabla = "CVUTILEX" NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-FAI OPEN QUERY BROWSE-FAI FOR EACH CcbCDocu ~
      WHERE {&Condicion} NO-LOCK, ~
      EACH FacTabla WHERE FacTabla.CodCia = CcbCDocu.CodCia ~
  AND FacTabla.Codigo = CcbCDocu.CodCli ~
      AND FacTabla.Tabla = "CVUTILEX" NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-FAI CcbCDocu FacTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-FAI CcbCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-FAI FacTabla


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-FAI}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-FAI BUTTON-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 6 BY 1.62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-FAI FOR 
      CcbCDocu, 
      FacTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-FAI
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-FAI W-Win _STRUCTURED
  QUERY BROWSE-FAI NO-LOCK DISPLAY
      CcbCDocu.FchDoc FORMAT "99/99/9999":U
      CcbCDocu.CodDoc FORMAT "x(3)":U
      CcbCDocu.NroDoc FORMAT "X(12)":U
      CcbCDocu.CodCli FORMAT "x(11)":U WIDTH 10.14
      CcbCDocu.NomCli FORMAT "x(60)":U WIDTH 59.43
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U
      CcbCDocu.SdoAct COLUMN-LABEL "Saldo Actual" FORMAT "->>,>>>,>>9.99":U
            WIDTH 9.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 118 BY 14.54
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-FAI AT ROW 1.27 COL 2 WIDGET-ID 200
     BUTTON-1 AT ROW 16.08 COL 2 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 121.57 BY 17
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "FAI PENDIENTES POR VALES UTILEX"
         HEIGHT             = 17
         WIDTH              = 121.57
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 121.57
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 121.57
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
/* BROWSE-TAB BROWSE-FAI 1 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-FAI
/* Query rebuild information for BROWSE BROWSE-FAI
     _TblList          = "INTEGRAL.CcbCDocu,INTEGRAL.FacTabla WHERE INTEGRAL.CcbCDocu ..."
     _Options          = "NO-LOCK"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "FacTabla.CodCia = CcbCDocu.CodCia
  AND FacTabla.Codigo = CcbCDocu.CodCli"
     _Where[2]         = "FacTabla.Tabla = ""CVUTILEX"""
     _FldNameList[1]   = INTEGRAL.CcbCDocu.FchDoc
     _FldNameList[2]   = INTEGRAL.CcbCDocu.CodDoc
     _FldNameList[3]   = INTEGRAL.CcbCDocu.NroDoc
     _FldNameList[4]   > INTEGRAL.CcbCDocu.CodCli
"CcbCDocu.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbCDocu.NomCli
"CcbCDocu.NomCli" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "59.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.CcbCDocu.ImpTot
     _FldNameList[7]   > INTEGRAL.CcbCDocu.SdoAct
"CcbCDocu.SdoAct" "Saldo Actual" ? "decimal" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-FAI */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* FAI PENDIENTES POR VALES UTILEX */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* FAI PENDIENTES POR VALES UTILEX */
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
    /* Archivo de Salida */
    DEF VAR c-csv-file AS CHAR NO-UNDO.
    DEF VAR c-xls-file AS CHAR INIT 'Archivo_Excel' NO-UNDO.
    DEF VAR rpta AS LOG INIT NO NO-UNDO.
    
    SYSTEM-DIALOG GET-FILE c-xls-file
        FILTERS 'Libro de Excel' '*.xlsx'
        INITIAL-FILTER 1
        ASK-OVERWRITE
        CREATE-TEST-FILE
        DEFAULT-EXTENSION ".xlsx"
        SAVE-AS
        TITLE "Guardar como"
        USE-FILENAME
        UPDATE rpta.
    IF rpta = NO THEN RETURN.
    
    SESSION:SET-WAIT-STATE('GENERAL').
    /* Variable de memoria */
    DEFINE VAR hProc AS HANDLE NO-UNDO.
    /* Levantamos la libreria a memoria */
    RUN lib\Tools-to-excel PERSISTENT SET hProc.
    
    /* Cargamos la informacion al temporal */
    EMPTY TEMP-TABLE Detalle.
    /*
    rutinas para cargar la información ...
    */
    GET FIRST BROWSE-FAI.
    REPEAT WHILE AVAILABLE Ccbcdocu:
        CREATE Detalle.
        BUFFER-COPY Ccbcdocu TO Detalle.
        GET NEXT BROWSE-FAI.
    END.
    
    /* Programas que generan el Excel */
    RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                      INPUT c-xls-file,
                                      OUTPUT c-csv-file) .
    
    RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:handle,
                                      INPUT  c-csv-file,
                                      OUTPUT c-xls-file) .
    
    /* Borramos librerias de la memoria */
    DELETE PROCEDURE hProc.
    SESSION:SET-WAIT-STATE('').
    MESSAGE 'Proceso Terminado'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-FAI
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
  ENABLE BROWSE-FAI BUTTON-1 
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
  {src/adm/template/snd-list.i "CcbCDocu"}
  {src/adm/template/snd-list.i "FacTabla"}

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

