&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-LogisLogControl NO-UNDO LIKE LogisLogControl.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR x-CodCheq AS CHAR NO-UNDO.
DEF VAR x-NomCheq AS CHAR NO-UNDO.
DEF VAR x-Tiempo  AS CHAR NO-UNDO.


DEF TEMP-TABLE Detalle NO-UNDO
    FIELD CodDoc    AS CHAR     FORMAT 'x(8)'           LABEL 'CODIGO'
    FIELD NroPed    AS CHAR     FORMAT 'x(15)'          LABEL 'NUMERO'
    FIELD NomCli    AS CHAR     FORMAT 'x(100)'         LABEL 'CLIENTE'
    FIELD DirCli    AS CHAR     FORMAT 'x(100)'         LABEL 'DIRECCION'
    FIELD CodChq    AS CHAR     FORMAT 'x(15)'          LABEL 'CHEQUEADOR'
    FIELD NomChq    AS CHAR     FORMAT 'x(80)'          LABEL 'NOMBRE'
    FIELD Fecha     AS CHAR     FORMAT 'x(20)'          LABEL 'FECHA Y HORA'
    FIELD Tiempo    AS CHAR     FORMAT 'x(20)'          LABEL 'TIEMPO (min)'
    FIELD Peso      AS DECI     FORMAT '>>>,>>9.99'     LABEL 'PESO (kg)'
    FIELD Items     AS INTE     FORMAT '>>>9'           LABEL 'ITEMS'
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t-LogisLogControl LogisLogControl FacCPedi

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table LogisLogControl.CodDoc ~
LogisLogControl.NroDoc FacCPedi.NomCli FacCPedi.DirCli ~
fCodCheq() @ x-CodCheq fNomCheq() @ x-NomCheq LogisLogControl.Libre_c01 ~
fTiempo() @ x-Tiempo FacCPedi.Peso FacCPedi.Items 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH t-LogisLogControl WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST LogisLogControl WHERE LogisLogControl.CodCia = t-LogisLogControl.CodCia ~
  AND LogisLogControl.CodDiv = t-LogisLogControl.CodDiv ~
  AND LogisLogControl.CodDoc = t-LogisLogControl.CodDoc ~
  AND LogisLogControl.NroDoc = t-LogisLogControl.NroDoc NO-LOCK, ~
      EACH FacCPedi WHERE FacCPedi.CodCia = LogisLogControl.CodCia ~
  AND FacCPedi.CodDoc = LogisLogControl.CodDoc ~
  AND FacCPedi.NroPed = LogisLogControl.NroDoc NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH t-LogisLogControl WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST LogisLogControl WHERE LogisLogControl.CodCia = t-LogisLogControl.CodCia ~
  AND LogisLogControl.CodDiv = t-LogisLogControl.CodDiv ~
  AND LogisLogControl.CodDoc = t-LogisLogControl.CodDoc ~
  AND LogisLogControl.NroDoc = t-LogisLogControl.NroDoc NO-LOCK, ~
      EACH FacCPedi WHERE FacCPedi.CodCia = LogisLogControl.CodCia ~
  AND FacCPedi.CodDoc = LogisLogControl.CodDoc ~
  AND FacCPedi.NroPed = LogisLogControl.NroDoc NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table t-LogisLogControl LogisLogControl ~
FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-br_table t-LogisLogControl
&Scoped-define SECOND-TABLE-IN-QUERY-br_table LogisLogControl
&Scoped-define THIRD-TABLE-IN-QUERY-br_table FacCPedi


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txtDesde txtHasta btn-excel BUTTON-3 ~
br_table 
&Scoped-Define DISPLAYED-OBJECTS txtDesde txtHasta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCodCheq B-table-Win 
FUNCTION fCodCheq RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNomCheq B-table-Win 
FUNCTION fNomCheq RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTiempo B-table-Win 
FUNCTION fTiempo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-excel 
     LABEL "EXPORTAR A TEXTO" 
     SIZE 20 BY 1.04.

DEFINE BUTTON BUTTON-3 
     LABEL "Refrescar" 
     SIZE 13.72 BY 1.04.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Chequeados desde el día" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta el día" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      t-LogisLogControl, 
      LogisLogControl, 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      LogisLogControl.CodDoc COLUMN-LABEL "Código" FORMAT "x(8)":U
      LogisLogControl.NroDoc COLUMN-LABEL "Número" FORMAT "x(15)":U
            WIDTH 12.86
      FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(100)":U
            WIDTH 38.72
      FacCPedi.DirCli COLUMN-LABEL "Dirección" FORMAT "x(100)":U
            WIDTH 36.43
      fCodCheq() @ x-CodCheq COLUMN-LABEL "Chequeador" FORMAT "x(15)":U
            WIDTH 11.57
      fNomCheq() @ x-NomCheq COLUMN-LABEL "Apellidos y nombres" FORMAT "x(50)":U
            WIDTH 31.43
      LogisLogControl.Libre_c01 COLUMN-LABEL "Fecha y Hora de Chequeo" FORMAT "x(20)":U
            WIDTH 20.43
      fTiempo() @ x-Tiempo COLUMN-LABEL "Tiempo!hh:mm:ss" FORMAT "x(15)":U
            WIDTH 8.29
      FacCPedi.Peso COLUMN-LABEL "Peso (kg)" FORMAT ">>>,>>9.9999":U
      FacCPedi.Items FORMAT ">>>,>>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 180 BY 22.35
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtDesde AT ROW 1.27 COL 29 COLON-ALIGNED WIDGET-ID 38
     txtHasta AT ROW 1.27 COL 51 COLON-ALIGNED WIDGET-ID 40
     btn-excel AT ROW 1.27 COL 73 WIDGET-ID 28
     BUTTON-3 AT ROW 1.27 COL 94 WIDGET-ID 54
     br_table AT ROW 2.62 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: t-LogisLogControl T "?" NO-UNDO INTEGRAL LogisLogControl
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 24.65
         WIDTH              = 184.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table BUTTON-3 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 3.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.t-LogisLogControl,INTEGRAL.LogisLogControl WHERE Temp-Tables.t-LogisLogControl ...,INTEGRAL.FacCPedi WHERE INTEGRAL.LogisLogControl ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST,"
     _JoinCode[2]      = "INTEGRAL.LogisLogControl.CodCia = Temp-Tables.t-LogisLogControl.CodCia
  AND INTEGRAL.LogisLogControl.CodDiv = Temp-Tables.t-LogisLogControl.CodDiv
  AND INTEGRAL.LogisLogControl.CodDoc = Temp-Tables.t-LogisLogControl.CodDoc
  AND INTEGRAL.LogisLogControl.NroDoc = Temp-Tables.t-LogisLogControl.NroDoc"
     _JoinCode[3]      = "INTEGRAL.FacCPedi.CodCia = INTEGRAL.LogisLogControl.CodCia
  AND INTEGRAL.FacCPedi.CodDoc = INTEGRAL.LogisLogControl.CodDoc
  AND INTEGRAL.FacCPedi.NroPed = INTEGRAL.LogisLogControl.NroDoc"
     _FldNameList[1]   > INTEGRAL.LogisLogControl.CodDoc
"INTEGRAL.LogisLogControl.CodDoc" "Código" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.LogisLogControl.NroDoc
"INTEGRAL.LogisLogControl.NroDoc" "Número" ? "character" ? ? ? ? ? ? no ? no no "12.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.NomCli
"INTEGRAL.FacCPedi.NomCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "38.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.DirCli
"INTEGRAL.FacCPedi.DirCli" "Dirección" ? "character" ? ? ? ? ? ? no ? no no "36.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fCodCheq() @ x-CodCheq" "Chequeador" "x(15)" ? ? ? ? ? ? ? no ? no no "11.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fNomCheq() @ x-NomCheq" "Apellidos y nombres" "x(50)" ? ? ? ? ? ? ? no ? no no "31.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.LogisLogControl.Libre_c01
"INTEGRAL.LogisLogControl.Libre_c01" "Fecha y Hora de Chequeo" "x(20)" "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fTiempo() @ x-Tiempo" "Tiempo!hh:mm:ss" "x(15)" ? ? ? ? ? ? ? no ? no no "8.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacCPedi.Peso
"INTEGRAL.FacCPedi.Peso" "Peso (kg)" ">>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.FacCPedi.Items
"INTEGRAL.FacCPedi.Items" ? ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-excel B-table-Win
ON CHOOSE OF btn-excel IN FRAME F-Main /* EXPORTAR A TEXTO */
DO:
  RUN gen-excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 B-table-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Refrescar */
DO:
   RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtDesde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtDesde B-table-Win
ON LEAVE OF txtDesde IN FRAME F-Main /* Chequeados desde el día */
DO:
    ASSIGN {&self-name}.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtHasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtHasta B-table-Win
ON LEAVE OF txtHasta IN FRAME F-Main /* Hasta el día */
DO:
    ASSIGN {&self-name}.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE t-LogisLogControl.

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH LogTabla NO-LOCK WHERE LogTabla.codcia = s-codcia AND
    LogTabla.evento = "CHKDESTINO" AND
    LogTabla.tabla = "FACCPEDI" AND
    LogTabla.dia >= txtDesde AND
    LogTabla.dia <= txtHasta AND
    LogTabla.valorllave BEGINS s-coddiv + "|" + "OTR":
    FOR EACH LogisLogControl NO-LOCK WHERE LogisLogControl.codcia = s-codcia AND
        LogisLogControl.coddiv = s-coddiv AND 
        LogisLogControl.coddoc = ENTRY(2,LogTabla.valorllave,"|") AND
        LogisLogControl.nrodoc = ENTRY(3,LogTabla.valorllave,"|"):
        CREATE t-LogisLogControl.
        BUFFER-COPY LogisLogControl TO t-LogisLogControl.
    END.
END.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen-excel B-table-Win 
PROCEDURE gen-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Pantalla de Impresión */
  DEF VAR pOptions AS CHAR.
  DEF VAR pArchivo AS CHAR.
  DEF VAR cArchivo AS CHAR.

  RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
  IF pOptions = "" THEN RETURN NO-APPLY.

  SESSION:SET-WAIT-STATE('GENERAL').

  EMPTY TEMP-TABLE Detalle.

  GET FIRST {&BROWSE-NAME}.
  DO WHILE NOT QUERY-OFF-END('{&BROWSE-NAME}'):
      CREATE Detalle.
      ASSIGN
          Detalle.CodDoc  = Faccpedi.coddoc
          Detalle.NroPed  = Faccpedi.nroped
          Detalle.NomCli  = Faccpedi.nomcli
          Detalle.DirCli  = Faccpedi.dircli
          Detalle.CodChq  = fCodCheq()
          Detalle.NomChq  = fNomCheq()
          Detalle.Fecha   = LogisLogControl.Libre_c01
          Detalle.Tiempo  = fTiempo().
      ASSIGN
          Detalle.Peso    = FacCPedi.Peso
          Detalle.Items   = FacCPedi.Items.
      GET NEXT {&BROWSE-NAME}.
  END.
  
  SESSION:SET-WAIT-STATE('').

  FIND FIRST Detalle NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Detalle THEN DO:
      MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  cArchivo = LC(pArchivo).
  SESSION:SET-WAIT-STATE('GENERAL').
  IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
  RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
  SESSION:DATE-FORMAT = "dmy".
  SESSION:SET-WAIT-STATE('').
  /* ******************************************************* */
  MESSAGE 'Fin de la exportación' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  txtDesde = TODAY.
  txtHasta = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
PROCEDURE procesa-parametros :
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
PROCEDURE recoge-parametros :
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
        WHEN "" THEN .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "t-LogisLogControl"}
  {src/adm/template/snd-list.i "LogisLogControl"}
  {src/adm/template/snd-list.i "FacCPedi"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCodCheq B-table-Win 
FUNCTION fCodCheq RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND LAST LogTabla WHERE logtabla.codcia = s-codcia AND
      logtabla.Tabla = "FACCPEDI" AND 
      logtabla.Evento = "CHKDESTINO" AND
      logtabla.ValorLlave BEGINS s-coddiv + "|" + faccpedi.coddoc + "|" + faccpedi.nroped
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE LogTabla THEN RETURN "".   /* Function return value. */
  /* Armamos retorno */
  IF NUM-ENTRIES(logtabla.ValorLlave,'|') >= 6 THEN RETURN ENTRY(6,logtabla.ValorLlave,"|").
  RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNomCheq B-table-Win 
FUNCTION fNomCheq RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND LAST LogTabla WHERE logtabla.codcia = s-codcia AND
      logtabla.Tabla = "FACCPEDI" AND 
      logtabla.Evento = "CHKDESTINO" AND
      logtabla.ValorLlave BEGINS s-coddiv + "|" + faccpedi.coddoc + "|" + faccpedi.nroped
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE LogTabla THEN RETURN "".   /* Function return value. */
  /* Armamos retorno */
  IF NUM-ENTRIES(logtabla.ValorLlave,'|') >= 6 THEN DO:
      FIND PL-PERS WHERE PL-PERS.codper = ENTRY(6,logtabla.ValorLlave,"|") NO-LOCK NO-ERROR.
      IF AVAILABLE PL-PERS THEN 
          RETURN PL-PERS.patper + " " + PL-PERS.matper + ", " + PL-PERS.nomper.
  END.
  RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTiempo B-table-Win 
FUNCTION fTiempo RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Intervalo AS INTE NO-UNDO.  /* En segundos */
  DEFINE VAR x-hora AS INT.                
  DEFINE VAR x-minuto AS INT.                
  DEFINE VAR x-segundo AS INT.                

  x-Tiempo = "".
  IF DATETIME(LogisLogControl.Libre_c02) > DATETIME(LogisLogControl.Libre_c01) THEN DO:
      x-Intervalo = (DATETIME(LogisLogControl.Libre_c02) - DATETIME(LogisLogControl.Libre_c01)) / 1000.
      /*x-Tiempo = STRING(x-Intervalo / 3600, '>>>>>9.99').*/
      /*x-Tiempo = STRING(x-Intervalo / 60, '>>>>>9.99').*/     /* Minutos */
      x-hora = TRUNCATE(x-Intervalo / 3600,0).
      x-Intervalo = x-Intervalo - (x-hora * 3600).
      x-minuto = TRUNCATE(x-Intervalo / 60,0).
      x-segundo = x-Intervalo - (x-minuto * 60).

      x-Tiempo = STRING(x-hora,"99") + ":" + STRING(x-minuto,"99") + ":" + STRING(x-segundo,"99").

  END.
  RETURN x-Tiempo.

END FUNCTION.

/*
Libre_c01 = "09/07/2024 14:17:49".
Libre_c02 = "09/07/2024 15:35:35".

x-Intervalo = (DATETIME(Libre_c02) - DATETIME(Libre_c01)) / 1000. /* segundos */
x-hora = TRUNCATE(x-Intervalo / 3600,0).
x-Intervalo = x-Intervalo - (x-hora * 3600).
x-minuto = TRUNCATE(x-Intervalo / 60,0).
x-segundo = x-Intervalo - (x-minuto * 60).
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

