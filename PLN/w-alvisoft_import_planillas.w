&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-PL-FLG-MES LIKE PL-FLG-MES.
DEFINE TEMP-TABLE t-PL-MOV-MES LIKE PL-MOV-MES.



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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR S-PERIODO AS INTE NO-UNDO.
DEF VAR S-NROMES AS INTE NO-UNDO.
DEF VAR S-CODPLN AS INTE INIT 01 NO-UNDO.       /* Empleados */
DEF VAR S-CODCAL AS INTE INIT 001 NO-UNDO.

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
&Scoped-define INTERNAL-TABLES t-PL-MOV-MES PL-PERS PL-CONC

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 t-PL-MOV-MES.codpln ~
t-PL-MOV-MES.codcal t-PL-MOV-MES.Periodo t-PL-MOV-MES.NroMes ~
t-PL-MOV-MES.codper PL-PERS.lmilit PL-PERS.nomper PL-PERS.patper ~
PL-PERS.matper t-PL-MOV-MES.CodMov PL-CONC.DesMov t-PL-MOV-MES.valcal-mes 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH t-PL-MOV-MES ~
      WHERE t-PL-MOV-MES.CodCia = s-codcia ~
 AND t-PL-MOV-MES.Periodo = s-periodo ~
 AND t-PL-MOV-MES.NroMes = s-nromes ~
 AND t-PL-MOV-MES.codcal = s-codcal ~
 AND t-PL-MOV-MES.codpln = s-codpln NO-LOCK, ~
      FIRST PL-PERS WHERE PL-PERS.CodCia = t-PL-MOV-MES.CodCia ~
  AND PL-PERS.codper = t-PL-MOV-MES.codper NO-LOCK, ~
      FIRST PL-CONC OF t-PL-MOV-MES NO-LOCK ~
    BY t-PL-MOV-MES.codper ~
       BY t-PL-MOV-MES.CodMov INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH t-PL-MOV-MES ~
      WHERE t-PL-MOV-MES.CodCia = s-codcia ~
 AND t-PL-MOV-MES.Periodo = s-periodo ~
 AND t-PL-MOV-MES.NroMes = s-nromes ~
 AND t-PL-MOV-MES.codcal = s-codcal ~
 AND t-PL-MOV-MES.codpln = s-codpln NO-LOCK, ~
      FIRST PL-PERS WHERE PL-PERS.CodCia = t-PL-MOV-MES.CodCia ~
  AND PL-PERS.codper = t-PL-MOV-MES.codper NO-LOCK, ~
      FIRST PL-CONC OF t-PL-MOV-MES NO-LOCK ~
    BY t-PL-MOV-MES.codper ~
       BY t-PL-MOV-MES.CodMov INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 t-PL-MOV-MES PL-PERS PL-CONC
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 t-PL-MOV-MES
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 PL-PERS
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 PL-CONC


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX_Periodo BUTTON_Import ~
COMBO-BOX_NroMes COMBO-BOX_Planilla BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_Periodo COMBO-BOX_NroMes ~
COMBO-BOX_Planilla 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON_Export 
     LABEL "EXPORTAR A PROGRESS" 
     SIZE 26 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON_Import 
     LABEL "IMPORTAR EXCEL" 
     SIZE 26 BY 1.12
     FONT 6.

DEFINE VARIABLE COMBO-BOX_NroMes AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEM-PAIRS "Enero",1,
                     "Febrero",2,
                     "Marzo",3,
                     "Abril",4,
                     "Mayo",5,
                     "Junio",6,
                     "Julio",7,
                     "Agosto",8,
                     "Setiembre",9,
                     "Octubre",10,
                     "Noviembre",11,
                     "Diciembre",12
     DROP-DOWN-LIST
     SIZE 19 BY 1
     FONT 6 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_Periodo AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "0000" 
     DROP-DOWN-LIST
     SIZE 8 BY 1
     FONT 6 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_Planilla AS INTEGER FORMAT "999":U INITIAL 1 
     LABEL "Planilla de" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Sueldos",001,
                     "Gratificaciones",004,
                     "Liquidaciones",005,
                     "Liquidaciones de eventuales",008
     DROP-DOWN-LIST
     SIZE 30 BY 1
     FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      t-PL-MOV-MES, 
      PL-PERS, 
      PL-CONC SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      t-PL-MOV-MES.codpln FORMAT "99":U
      t-PL-MOV-MES.codcal FORMAT "999":U
      t-PL-MOV-MES.Periodo FORMAT "9999":U
      t-PL-MOV-MES.NroMes FORMAT "99":U
      t-PL-MOV-MES.codper COLUMN-LABEL "Código PROGRESS" FORMAT "X(6)":U
      PL-PERS.lmilit COLUMN-LABEL "Código ALVISOFT" FORMAT "X(10)":U
      PL-PERS.nomper FORMAT "X(40)":U WIDTH 20
      PL-PERS.patper FORMAT "X(40)":U WIDTH 20
      PL-PERS.matper FORMAT "X(40)":U WIDTH 20
      t-PL-MOV-MES.CodMov FORMAT "999":U
      PL-CONC.DesMov COLUMN-LABEL "Descripción Concepto" FORMAT "X(40)":U
            WIDTH 20
      t-PL-MOV-MES.valcal-mes FORMAT "ZZZZ,ZZ9.99":U WIDTH 10.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 149 BY 19.12
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX_Periodo AT ROW 1.54 COL 13 COLON-ALIGNED WIDGET-ID 4
     BUTTON_Import AT ROW 1.81 COL 61 WIDGET-ID 10
     COMBO-BOX_NroMes AT ROW 2.62 COL 13 COLON-ALIGNED WIDGET-ID 6
     BUTTON_Export AT ROW 3.15 COL 61 WIDGET-ID 14
     COMBO-BOX_Planilla AT ROW 3.69 COL 13 COLON-ALIGNED WIDGET-ID 8
     BROWSE-2 AT ROW 5.31 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 155.72 BY 24.23
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-PL-FLG-MES T "?" ? INTEGRAL PL-FLG-MES
      TABLE: t-PL-MOV-MES T "?" ? INTEGRAL PL-MOV-MES
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "IMPORTAR PLANILLA DE EMPLEADOS"
         HEIGHT             = 24.23
         WIDTH              = 155.72
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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
/* BROWSE-TAB BROWSE-2 COMBO-BOX_Planilla F-Main */
/* SETTINGS FOR BUTTON BUTTON_Export IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.t-PL-MOV-MES,INTEGRAL.PL-PERS WHERE Temp-Tables.t-PL-MOV-MES ...,INTEGRAL.PL-CONC OF Temp-Tables.t-PL-MOV-MES"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, FIRST"
     _OrdList          = "Temp-Tables.t-PL-MOV-MES.codper|yes,Temp-Tables.t-PL-MOV-MES.CodMov|yes"
     _Where[1]         = "Temp-Tables.t-PL-MOV-MES.CodCia = s-codcia
 AND Temp-Tables.t-PL-MOV-MES.Periodo = s-periodo
 AND Temp-Tables.t-PL-MOV-MES.NroMes = s-nromes
 AND Temp-Tables.t-PL-MOV-MES.codcal = s-codcal
 AND Temp-Tables.t-PL-MOV-MES.codpln = s-codpln"
     _JoinCode[2]      = "INTEGRAL.PL-PERS.CodCia = Temp-Tables.t-PL-MOV-MES.CodCia
  AND INTEGRAL.PL-PERS.codper = Temp-Tables.t-PL-MOV-MES.codper"
     _FldNameList[1]   = Temp-Tables.t-PL-MOV-MES.codpln
     _FldNameList[2]   = Temp-Tables.t-PL-MOV-MES.codcal
     _FldNameList[3]   = Temp-Tables.t-PL-MOV-MES.Periodo
     _FldNameList[4]   = Temp-Tables.t-PL-MOV-MES.NroMes
     _FldNameList[5]   > Temp-Tables.t-PL-MOV-MES.codper
"t-PL-MOV-MES.codper" "Código PROGRESS" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.PL-PERS.lmilit
"PL-PERS.lmilit" "Código ALVISOFT" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.PL-PERS.nomper
"PL-PERS.nomper" ? ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.PL-PERS.patper
"PL-PERS.patper" ? ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.PL-PERS.matper
"PL-PERS.matper" ? ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   = Temp-Tables.t-PL-MOV-MES.CodMov
     _FldNameList[11]   > INTEGRAL.PL-CONC.DesMov
"PL-CONC.DesMov" "Descripción Concepto" ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.t-PL-MOV-MES.valcal-mes
"t-PL-MOV-MES.valcal-mes" ? ? "decimal" ? ? ? ? ? ? no ? no no "10.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* IMPORTAR PLANILLA DE EMPLEADOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPORTAR PLANILLA DE EMPLEADOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Export
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Export W-Win
ON CHOOSE OF BUTTON_Export IN FRAME F-Main /* EXPORTAR A PROGRESS */
DO:
  MESSAGE 'Procedemos con la exportación?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  ASSIGN COMBO-BOX_NroMes COMBO-BOX_Periodo COMBO-BOX_Planilla.
  S-NROMES = COMBO-BOX_NroMes.
  S-PERIODO = COMBO-BOX_Periodo.
  S-CODCAL = COMBO-BOX_Planilla.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Grabar_Planilla.
  CASE S-CODCAL:
      WHEN 001 THEN RUN Grabar_PL-FLG-MES.
      WHEN 005 THEN RUN Grabar_PL-FLG-MES_Update.
  END CASE.
  SESSION:SET-WAIT-STATE('').

  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  BUTTON_Export:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Import W-Win
ON CHOOSE OF BUTTON_Import IN FRAME F-Main /* IMPORTAR EXCEL */
DO:
  MESSAGE 'Procedemos con la importación?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  ASSIGN COMBO-BOX_NroMes COMBO-BOX_Periodo COMBO-BOX_Planilla.
  S-NROMES = COMBO-BOX_NroMes.
  S-PERIODO = COMBO-BOX_Periodo.
  S-CODCAL = COMBO-BOX_Planilla.

  SESSION:SET-WAIT-STATE('GENERAL').
  CASE S-CODCAL:
      WHEN 001 THEN RUN Importar_Sueldos.
      WHEN 004 THEN RUN Importar_Gratificaciones.
      WHEN 005 THEN RUN Importar_Liquidaciones.
  END CASE.
  SESSION:SET-WAIT-STATE('').

  {&OPEN-QUERY-{&BROWSE-NAME}}
  BUTTON_Export:SENSITIVE = YES.
  BUTTON_Import:SENSITIVE = NO.
  COMBO-BOX_NroMes:SENSITIVE = NO.
  COMBO-BOX_Periodo:SENSITIVE = NO.
  COMBO-BOX_Planilla:SENSITIVE = NO.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Columnas_Sueldos W-Win 
PROCEDURE Columnas_Sueldos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
  DISPLAY COMBO-BOX_Periodo COMBO-BOX_NroMes COMBO-BOX_Planilla 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX_Periodo BUTTON_Import COMBO-BOX_NroMes COMBO-BOX_Planilla 
         BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar_PL-FLG-MES W-Win 
PROCEDURE Grabar_PL-FLG-MES :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Borramos la planilla actual */               
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH PL-FLG-MES EXCLUSIVE-LOCK WHERE PL-FLG-MES.CodCia = s-codcia AND
        PL-FLG-MES.Periodo = S-PERIODO AND 
        PL-FLG-MES.NroMes = S-NROMES AND
        PL-FLG-MES.codpln = S-CODPLN 
        ON ERROR UNDO, THROW:
        DELETE PL-FLG-MES.
    END.
END.
/* Actualizamos la planilla */                      
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH t-PL-FLG-MES NO-LOCK ON ERROR UNDO, THROW:
        CREATE PL-FLG-MES.
        BUFFER-COPY t-PL-FLG-MES TO PL-FLG-MES.
    END.
    IF AVAILABLE(PL-FLG-MES) THEN RELEASE PL-FLG-MES.
    EMPTY TEMP-TABLE t-PL-FLG-MES.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar_PL-FLG-MES_Update W-Win 
PROCEDURE Grabar_PL-FLG-MES_Update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Actualizamos la planilla */                      
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH t-PL-FLG-MES NO-LOCK ON ERROR UNDO, THROW:
        FIND PL-FLG-MES OF t-PL-FLG-MES NO-LOCK NO-ERROR.
        IF NOT AVAILABLE PL-FLG-MES THEN DO:
            CREATE PL-FLG-MES.
            BUFFER-COPY t-PL-FLG-MES TO PL-FLG-MES.
        END.
        ELSE DO:
            FIND CURRENT PL-FLG-MES EXCLUSIVE-LOCK.
            PL-FLG-MES.vcontr = t-PL-FLG-MES.vcontr.
        END.
    END.
    IF AVAILABLE(PL-FLG-MES) THEN RELEASE PL-FLG-MES.
    EMPTY TEMP-TABLE t-PL-FLG-MES.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar_Planilla W-Win 
PROCEDURE Grabar_Planilla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Borramos la planilla actual */               
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH PL-MOV-MES EXCLUSIVE-LOCK WHERE PL-MOV-MES.CodCia = s-codcia AND
        PL-MOV-MES.Periodo = S-PERIODO AND 
        PL-MOV-MES.NroMes = S-NROMES AND
        PL-MOV-MES.codpln = S-CODPLN AND
        PL-MOV-MES.codcal = S-CODCAL ON ERROR UNDO, THROW:
        DELETE PL-MOV-MES.
    END.
    /* También la planilla base */
    IF S-CODCAL = 001 THEN DO:
        FOR EACH PL-MOV-MES EXCLUSIVE-LOCK WHERE PL-MOV-MES.CodCia = s-codcia AND
            PL-MOV-MES.Periodo = S-PERIODO AND 
            PL-MOV-MES.NroMes = S-NROMES AND
            PL-MOV-MES.codpln = S-CODPLN AND
            PL-MOV-MES.codcal = 000 ON ERROR UNDO, THROW:
            DELETE PL-MOV-MES.
        END.
    END.
END.
/* Actualizamos la planilla */                      
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH t-PL-MOV-MES NO-LOCK ON ERROR UNDO, THROW:
        CREATE PL-MOV-MES.
        BUFFER-COPY t-PL-MOV-MES TO PL-MOV-MES.
    END.
    IF AVAILABLE(PL-MOV-MES) THEN RELEASE PL-MOV-MES.
    EMPTY TEMP-TABLE t-PL-MOV-MES.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar_Gratificaciones W-Win 
PROCEDURE Importar_Gratificaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Se van a cargar dos tablas:
  PL-MOV-MES: conceptos pagados por la planilla
------------------------------------------------------------------------------*/

DEFINE VAR p-lfilexls           AS CHAR INIT "" NO-UNDO.
DEFINE VAR p-lFileXlsProcesado  AS CHAR INIT "" NO-UNDO.

DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed       AS LOG NO-UNDO.
DEFINE VARIABLE pMensaje        AS CHAR NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.

SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
    FILTERS "Archivos Excel (*.xls,*.xlsx,*.xlsm)" "*.xls,*.xlsx,*.xlsm", "Todos (*.*)" "*.*"
    TITLE "IMPORTAR EXCEL"
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN 'ADM-ERROR'.

DEFINE VARIABLE lFileXlsUsado            AS CHAR    NO-UNDO.
DEFINE VARIABLE lFileXls                 AS CHAR    NO-UNDO.
DEFINE VARIABLE lNuevoFile               AS LOG     NO-UNDO.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = NO.        /* YES : Si va crear un nuevo archivo o abrir */

lFileXls = FILL-IN-Archivo.

{lib\excel-open-file.i}
chExcelApplication:Visible = FALSE.

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */

/*chWorkSheet = chExcelApplication:Sheets("NotaPedido").*/
DEF VAR cNroDocId AS CHAR NO-UNDO.
DEF VAR cCodPer AS CHAR NO-UNDO.
DEF VAR dFchIng AS DATE NO-UNDO.
DEF VAR dFchCes AS DATE NO-UNDO.
DEF VAR c144 AS DECI NO-UNDO.       /* Bonificación Extraordinaria L.29714*/
DEF VAR c204 AS DECI NO-UNDO.       /* Cuenta corriente */
DEF VAR c212 AS DECI NO-UNDO.       /* Gratificación */
DEF VAR c403 AS DECI NO-UNDO.       /* Total a pagar */
DEF VAR c220 AS DECI NO-UNDO.       /* Mandato judicial */

/* Veamos los conceptos que vienen en la hoja Excel */
DEF VAR cConcepto AS LONGCHAR NO-UNDO.
DEF VAR cColumna AS LONGCHAR NO-UNDO.

iColumn = 10.
iRow = 3.
REPEAT:
    cValue = chWorkSheet:Cells(iRow,iColumn):VALUE.
    IF TRUE <> (cValue > '') THEN LEAVE.
    CASE TRUE:
        WHEN cValue BEGINS '0544' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "212".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0545' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "144".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0599' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "403".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0547' OR cValue BEGINS '0548' OR cValue BEGINS '0549' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "204".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0587' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "220".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
    END CASE.
    iColumn = iColumn + 1.
END.
/*MESSAGE string(cconcepto) SKIP string(ccolumna). RETURN.*/

pMensaje = ''.
iRow = 3.                       /* OJO */
        
EMPTY TEMP-TABLE t-PL-MOV-MES.
EMPTY TEMP-TABLE t-PL-FLG-MES.
DEF VAR iItem AS INTE NO-UNDO.

RLOOP:
REPEAT:
    /* Registro por registro del Excel */
    ASSIGN
        iColumn = 0             /* OJO */
        iRow    = iRow + 1.
    cCodPer = ''.
    cNroDocId = ''.
    dFchIng = ?.
    dFchCes = ?.
    c144 = 0.
    c212 = 0.
    c403 = 0.
    c204 = 0.
    c220 = 0.

    cValue = chWorkSheet:Cells(iRow,1):VALUE.
    IF TRUE <> (cValue > '') THEN LEAVE RLOOP.

    cCodPer = chWorkSheet:Cells(iRow, 1):VALUE.
    cNroDocId = chWorkSheet:Cells(iRow, 2):VALUE.
    dFchIng = DATE(chWorkSheet:Cells(iRow, 7):VALUE) NO-ERROR.
    dFchCes = DATE(chWorkSheet:Cells(iRow, 8):VALUE) NO-ERROR.
    DO iItem = 1 TO NUM-ENTRIES(cConcepto,':'):
        cValue = chWorkSheet:Cells(iRow, INTEGER(ENTRY(iItem,cColumna,':'))):VALUE.
        IF ENTRY(iItem,cConcepto,':') = '144' THEN c144 = c144 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '212' THEN c212 = c212 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '403' THEN c403 = c403 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '204' THEN c204 = c204 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '220' THEN c220 = c220 + DECIMAL(cValue).
    END.
    FIND FIRST PL-PERS WHERE PL-PERS.codcia = s-codcia 
        AND PL-PERS.NroDocID = cNroDocId NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-PERS THEN NEXT.

    /* PLANILLA DE GRATIFICACIONES */
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c144 &CodMov=144}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c212 &CodMov=212}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c403 &CodMov=403}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c204 &CodMov=204}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c220 &CodMov=220}
END.

{lib\excel-close-file.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar_Liquidaciones W-Win 
PROCEDURE Importar_Liquidaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Se van a cargar dos tablas:
  PL-MOV-MES: conceptos pagados por laplanilla
  PL-FLG-MES: personal activo
------------------------------------------------------------------------------*/

DEFINE VAR p-lfilexls           AS CHAR INIT "" NO-UNDO.
DEFINE VAR p-lFileXlsProcesado  AS CHAR INIT "" NO-UNDO.

DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed       AS LOG NO-UNDO.
DEFINE VARIABLE pMensaje        AS CHAR NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.

SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
    FILTERS "Archivos Excel (*.xls,*.xlsx,*.xlsm)" "*.xls,*.xlsx,*.xlsm", "Todos (*.*)" "*.*"
    TITLE "IMPORTAR EXCEL"
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN 'ADM-ERROR'.

DEFINE VARIABLE lFileXlsUsado            AS CHAR    NO-UNDO.
DEFINE VARIABLE lFileXls                 AS CHAR    NO-UNDO.
DEFINE VARIABLE lNuevoFile               AS LOG     NO-UNDO.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = NO.        /* YES : Si va crear un nuevo archivo o abrir */

lFileXls = FILL-IN-Archivo.

{lib\excel-open-file.i}
chExcelApplication:Visible = FALSE.

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */

/*chWorkSheet = chExcelApplication:Sheets("NotaPedido").*/
DEF VAR cNroDocId AS CHAR NO-UNDO.
DEF VAR cCodPer AS CHAR NO-UNDO.
DEF VAR dFchIng AS DATE NO-UNDO.
DEF VAR dFchCes AS DATE NO-UNDO.
DEF VAR c139 AS DECI NO-UNDO.       /* Gratificación Trunca */
DEF VAR c431 AS DECI NO-UNDO.       /* Liq Acumulada Vacaciones */

/* Veamos los conceptos que vienen en la hoja Excel */
DEF VAR cConcepto AS LONGCHAR NO-UNDO.
DEF VAR cColumna AS LONGCHAR NO-UNDO.

iColumn = 10.
iRow = 3.
REPEAT:
    cValue = chWorkSheet:Cells(iRow,iColumn):VALUE.
    IF TRUE <> (cValue > '') THEN LEAVE.
    CASE TRUE:
        WHEN cValue BEGINS '0712' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "431".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0769' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "139".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
    END CASE.
    iColumn = iColumn + 1.
END.
/*MESSAGE string(cconcepto) SKIP string(ccolumna). RETURN.*/
pMensaje = ''.
iRow = 3.                       /* OJO */
        
EMPTY TEMP-TABLE t-PL-MOV-MES.
EMPTY TEMP-TABLE t-PL-FLG-MES.
DEF VAR iItem AS INTE NO-UNDO.

RLOOP:
REPEAT:
    /* Registro por registro del Excel */
    ASSIGN
        iColumn = 0             /* OJO */
        iRow    = iRow + 1.
    cCodPer = ''.
    cNroDocId = ''.
    dFchIng = ?.
    dFchCes = ?.
    c139 = 0.
    c431 = 0.

    cValue = chWorkSheet:Cells(iRow,1):VALUE.
    IF TRUE <> (cValue > '') THEN LEAVE RLOOP.

    cCodPer = chWorkSheet:Cells(iRow, 1):VALUE.
    cNroDocId = chWorkSheet:Cells(iRow, 2):VALUE.
    dFchIng = DATE(chWorkSheet:Cells(iRow, 7):VALUE) NO-ERROR.
    dFchCes = DATE(chWorkSheet:Cells(iRow, 8):VALUE) NO-ERROR.
    DO iItem = 1 TO NUM-ENTRIES(cConcepto,':'):
        cValue = chWorkSheet:Cells(iRow, INTEGER(ENTRY(iItem,cColumna,':'))):VALUE.
        IF ENTRY(iItem,cConcepto,':') = '139' THEN c139 = c139 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '431' THEN c431 = c431 + DECIMAL(cValue).
    END.
    FIND FIRST PL-PERS WHERE PL-PERS.codcia = s-codcia 
        AND PL-PERS.NroDocID = cNroDocId NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-PERS THEN NEXT.

    /* PLANILLA DE SUELDOS */
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c139 &CodMov=139}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c431 &CodMov=431}
        
    CREATE t-PL-FLG-MES.
    ASSIGN
        t-PL-FLG-MES.CodCia = s-codcia
        t-PL-FLG-MES.codper = PL-PERS.codper
        t-PL-FLG-MES.Periodo = S-PERIODO
        t-PL-FLG-MES.NroMes = S-NROMES
        t-PL-FLG-MES.codpln = S-CODPLN
        t-PL-FLG-MES.vcontr = (IF dFchCes <> ? AND dFchCes <> DATE(01,01,1900) THEN dFchCes ELSE ?)
        t-PL-FLG-MES.fecing = dFchIng
        .
END.

{lib\excel-close-file.i}




/* *

pMensaje = ''.
iRow = 3.                       /* OJO */
        
EMPTY TEMP-TABLE t-PL-MOV-MES.
EMPTY TEMP-TABLE t-PL-FLG-MES.
RLOOP:
REPEAT:
    ASSIGN
        iColumn = 0             /* OJO */
        iRow    = iRow + 1.
    cNroDocId = ''.
    c139 = 0.
    c431 = 0.
    cValue = chWorkSheet:Cells(iRow,1):VALUE.
    IF TRUE <> (cValue > '') THEN LEAVE RLOOP.
    REPEAT:
        iColumn = iColumn + 1.
        cValue = chWorkSheet:Cells(iRow, iColumn):VALUE.
        CASE iColumn:
            WHEN 1 THEN cCodPer = cValue.
            WHEN 2 THEN cNroDocId = cValue.
            WHEN 7 THEN dFchIng = DATE(cValue) NO-ERROR.
            WHEN 8 THEN dFchCes = DATE(cValue) NO-ERROR.
            WHEN 11 THEN c431 = c431 + DECIMAL(cValue) NO-ERROR.
            WHEN 13 THEN c139 = c139 + DECIMAL(cValue) NO-ERROR.
        END CASE.
        IF iColumn > 25 THEN LEAVE.
    END.
    FIND FIRST PL-PERS WHERE PL-PERS.codcia = s-codcia 
        AND PL-PERS.NroDocID = cNroDocId NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-PERS THEN NEXT.

    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c139 &CodMov=139}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c431 &CodMov=431}
    CREATE t-PL-FLG-MES.
    ASSIGN
        t-PL-FLG-MES.CodCia = s-codcia
        t-PL-FLG-MES.codper = PL-PERS.codper
        t-PL-FLG-MES.Periodo = S-PERIODO
        t-PL-FLG-MES.NroMes = S-NROMES
        t-PL-FLG-MES.codpln = S-CODPLN
        t-PL-FLG-MES.vcontr = (IF dFchCes <> ? AND dFchCes <> DATE(01,01,1900) THEN dFchCes ELSE ?)
        t-PL-FLG-MES.fecing = dFchIng
        .
END.
{lib\excel-close-file.i}
* */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar_Sueldos W-Win 
PROCEDURE Importar_Sueldos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Se van a cargar dos tablas:
  PL-MOV-MES: conceptos pagados por laplanilla
  PL-FLG-MES: personal activo
------------------------------------------------------------------------------*/

DEFINE VAR p-lfilexls           AS CHAR INIT "" NO-UNDO.
DEFINE VAR p-lFileXlsProcesado  AS CHAR INIT "" NO-UNDO.

DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed       AS LOG NO-UNDO.
DEFINE VARIABLE pMensaje        AS CHAR NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.

SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
    FILTERS "Archivos Excel (*.xls,*.xlsx,*.xlsm)" "*.xls,*.xlsx,*.xlsm", "Todos (*.*)" "*.*"
    TITLE "IMPORTAR EXCEL DE PEDIDOS"
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN 'ADM-ERROR'.

DEFINE VARIABLE lFileXlsUsado            AS CHAR    NO-UNDO.
DEFINE VARIABLE lFileXls                 AS CHAR    NO-UNDO.
DEFINE VARIABLE lNuevoFile               AS LOG     NO-UNDO.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = NO.        /* YES : Si va crear un nuevo archivo o abrir */

lFileXls = FILL-IN-Archivo.

{lib\excel-open-file.i}
chExcelApplication:Visible = FALSE.

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */

/*chWorkSheet = chExcelApplication:Sheets("NotaPedido").*/
DEF VAR cNroDocId AS CHAR NO-UNDO.
DEF VAR cCodPer AS CHAR NO-UNDO.
DEF VAR dFchIng AS DATE NO-UNDO.
DEF VAR dFchCes AS DATE NO-UNDO.
DEF VAR c100 AS DECI NO-UNDO.       /* Días Trabajados */
DEF VAR c101 AS DECI NO-UNDO.       /* Sueldo Básico */
DEF VAR c103 AS DECI NO-UNDO.       /* Asignación Familiar */
DEF VAR c104 AS DECI NO-UNDO.       /* Condición de Trabajo - Movilidad */
DEF VAR c106 AS DECI NO-UNDO.       /* Remuneración Vacacional */
DEF VAR c107 AS DECI NO-UNDO.       /* Remuneración Vacaciones Trabajadas */
DEF VAR c111 AS DECI NO-UNDO.       /* Prestaciones alimentarias */
DEF VAR c125 AS DECI NO-UNDO.       /* Horas Extras 25% */
DEF VAR c126 AS DECI NO-UNDO.       /* Trabajo en Feriado */
DEF VAR c127 AS DECI NO-UNDO.       /* Horas Extras 35% */
DEF VAR c131 AS DECI NO-UNDO.       /* Bonificación por Incentivo */
DEF VAR c136 AS DECI NO-UNDO.       /* Reintegro */
DEF VAR c138 AS DECI NO-UNDO.       /* Asignación Extraordinaria */
DEF VAR c139 AS DECI NO-UNDO.       /* Gratificación Trunca */
DEF VAR c146 AS DECI NO-UNDO.       /* Riesgo de Caja */
DEF VAR c209 AS DECI NO-UNDO.       /* Comisiones */
DEF VAR c612 AS DECI NO-UNDO.       /* Gratificaciones Extraordinarias */
DEF VAR c803 AS DECI NO-UNDO.       /* Subsidio Pre-Natal y Post-Natal */
DEF VAR c401 AS DECI NO-UNDO.
DEF VAR c402 AS DECI NO-UNDO.
DEF VAR c405 AS DECI NO-UNDO.       /* Total Afecto a 5ta. Categoría */
DEF VAR x-ValCal-Mes AS DECI NO-UNDO.
DEF VAR x-Cuenta-Totales AS INTE NO-UNDO.
/* Veamos los conceptos que vienen en la hoja Excel: Fila 3 */
DEF VAR cConcepto AS LONGCHAR NO-UNDO.
DEF VAR cColumna AS LONGCHAR NO-UNDO.
iColumn = 10.
iRow = 3.
x-Cuenta-Totales = 0.
REPEAT:
    cValue = chWorkSheet:Cells(iRow,iColumn):VALUE.
    IF TRUE <> (cValue > '') THEN LEAVE.
    CASE TRUE:
        WHEN cValue BEGINS '0015' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "100".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0022' OR cValue BEGINS '0023' OR cValue BEGINS '0024'
            THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "101".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0046' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "803".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0055' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "103".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0065' OR cValue BEGINS '0067' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "125".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0066' OR cValue BEGINS '0068' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "127".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0072' OR cValue BEGINS '0075' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "126".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0077' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "209".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0079' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "131".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0086' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "136".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0087' OR cValue BEGINS '0089' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "104".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0088' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "111".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0094' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "146".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0107' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "106".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0115' OR cValue BEGINS '0117' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "136".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0118' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "139".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS '0119' THEN DO:
            cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "612".
            cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
        END.
        WHEN cValue BEGINS 'Total' THEN DO:
            x-Cuenta-Totales = x-Cuenta-Totales + 1.
            IF x-Cuenta-Totales = 1 THEN DO:
                cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "401".
                cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
            END.
            IF x-Cuenta-Totales = 2 THEN DO:
                cConcepto = cConcepto + (IF TRUE <> (cConcepto > '') THEN '' ELSE ':') + "402".
                cColumna = cColumna + (IF TRUE <> (cColumna > '') THEN '' ELSE ':') + STRING(iColumn).
            END.
        END.
    END CASE.
    iColumn = iColumn + 1.
END.
/*MESSAGE string(cConcepto) SKIP string(cColumna).*/
pMensaje = ''.
iRow = 3.                       /* OJO */
EMPTY TEMP-TABLE t-PL-MOV-MES.
EMPTY TEMP-TABLE t-PL-FLG-MES.
DEF VAR iItem AS INTE NO-UNDO.
RLOOP:
REPEAT:
    /* Registro por registro del Excel */
    ASSIGN
        iColumn = 0             /* OJO */
        iRow    = iRow + 1.
    cNroDocId = ''.
    c100 = 0.
    c101 = 0.
    c103 = 0.
    c104 = 0.
    c106 = 0.
    c107 = 0.
    c111 = 0.
    c125 = 0.
    c126 = 0.
    c127 = 0.
    c131 = 0.
    c136 = 0.
    c138 = 0.
    c139 = 0.
    c146 = 0.
    c209 = 0.
    c612 = 0.
    c803 = 0.
    c401 = 0.
    c402 = 0.
    c405 = 0.
    cValue = chWorkSheet:Cells(iRow,1):VALUE.
    IF TRUE <> (cValue > '') THEN LEAVE RLOOP.
    cCodPer = chWorkSheet:Cells(iRow, 1):VALUE.
    cNroDocId = chWorkSheet:Cells(iRow, 2):VALUE.
    dFchIng = DATE(chWorkSheet:Cells(iRow, 7):VALUE) NO-ERROR.
    dFchCes = DATE(chWorkSheet:Cells(iRow, 8):VALUE) NO-ERROR.
    DO iItem = 1 TO NUM-ENTRIES(cConcepto,':'):
        cValue = chWorkSheet:Cells(iRow, INTEGER(ENTRY(iItem,cColumna,':'))):VALUE.
        IF ENTRY(iItem,cConcepto,':') = '100' THEN c100 = c100 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '101' THEN c101 = c101 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '103' THEN c103 = c103 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '104' THEN c104 = c104 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '106' THEN c106 = c106 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '111' THEN c111 = c111 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '125' THEN c125 = c125 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '126' THEN c126 = c126 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '127' THEN c127 = c127 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '131' THEN c131 = c131 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '136' THEN c136 = c136 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '139' THEN c139 = c139 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '146' THEN c146 = c146 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '209' THEN c209 = c209 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '612' THEN c612 = c612 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '803' THEN c803 = c803 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '401' THEN c401 = c401 + DECIMAL(cValue).
        IF ENTRY(iItem,cConcepto,':') = '402' THEN c402 = c402 + DECIMAL(cValue).
    END.
    FIND FIRST PL-PERS WHERE PL-PERS.codcia = s-codcia 
        AND PL-PERS.NroDocID = cNroDocId NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-PERS THEN NEXT.
    /* PLANILLA DE SUELDOS */
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c100 &CodMov=100}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c101 &CodMov=101}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c103 &CodMov=103}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c104 &CodMov=104}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c106 &CodMov=106}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c125 &CodMov=125}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c126 &CodMov=126}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c127 &CodMov=127}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c131 &CodMov=131}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c136 &CodMov=136}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c139 &CodMov=139}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c146 &CodMov=146}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c209 &CodMov=209}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c612 &CodMov=612}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c803 &CodMov=803}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c401 &CodMov=401}
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c402 &CodMov=402}
    /* ***************************** */
    /* TOTAL AFECTO A 5ta. CATEGORIA */
    /* ***************************** */
    c405 = c101 + c103 + c106 + c107 + c125 + c126 + c127 + c131 + c136 + c138 + c139 + c146 + c209 + c612.
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=S-CODCAL &ValCal-Mes=c405 &CodMov=405}
    /* ******************** */
    /* ARMAMOS PLANILA BASE */
    /* ******************** */
    /* Sueldo básico */
    x-ValCal-Mes = (c101 / c100 * 30).      
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=000 &ValCal-Mes=x-ValCal-Mes &CodMov=101}
    /* Asignación familiar */
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=000 &ValCal-Mes=c103 &CodMov=103}
    /* Condición de trabajo - movilidad */
    x-ValCal-Mes = (c104 / c100 * 30).
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=000 &ValCal-Mes=x-ValCal-Mes &CodMov=104}
    /* Prestaciones alimentarias */
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=000 &ValCal-Mes=x-ValCal-Mes &CodMov=111}
    /* SUbsidio pre-natal y post-natal */
    {pln/i-importar_sueldos.i &Tabla=t-PL-MOV-MES &Periodo=S-PERIODO &NroMes=S-NROMES &CodPln=S-CODPLN ~
        &CodCal=000 &ValCal-Mes=c803 &CodMov=803}
    CREATE t-PL-FLG-MES.
    ASSIGN
        t-PL-FLG-MES.CodCia = s-codcia
        t-PL-FLG-MES.codper = PL-PERS.codper
        t-PL-FLG-MES.Periodo = S-PERIODO
        t-PL-FLG-MES.NroMes = S-NROMES
        t-PL-FLG-MES.codpln = S-CODPLN
        t-PL-FLG-MES.vcontr = (IF dFchCes <> ? AND dFchCes <> DATE(01,01,1900) THEN dFchCes ELSE ?)
        t-PL-FLG-MES.fecing = dFchIng
        .
END.
{lib\excel-close-file.i}

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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX_Periodo:DELETE(1).
      FOR EACH CB-PERI NO-LOCK WHERE CB-PERI.CodCia  = s-codcia 
          AND CB-PERI.Periodo > 0 BY CB-PERI.Periodo:
          S-PERIODO = CB-PERI.Periodo.
          s-NroMes  = CB-PERI.pl-NroMes.
          COMBO-BOX_Periodo:ADD-LAST(STRING(CB-PERI.Periodo,'9999')).
          COMBO-BOX_Periodo = CB-PERI.Periodo.
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "t-PL-MOV-MES"}
  {src/adm/template/snd-list.i "PL-PERS"}
  {src/adm/template/snd-list.i "PL-CONC"}

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

