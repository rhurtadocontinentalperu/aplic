&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-VtaCDocu NO-UNDO LIKE VtaCDocu.



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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

DEF SHARED VAR s-coddoc AS CHAR.
DEF VAR x-nroitm AS INT.

DEFINE SHARED VAR ltxtDesde AS DATE.
DEFINE SHARED VAR ltxtHasta AS DATE.
DEFINE SHARED VAR pOrdenCompra AS CHAR.
DEFINE SHARED VAR lChequeados AS LOGICAL INIT YES.
DEFINE SHARED VAR pSoloImpresos AS LOGICAL INIT NO.

DEFINE TEMP-TABLE Reporte
    FIELD CodDoc    LIKE FacCPedi.CodDoc
    FIELDS NroPed   LIKE FacCPedi.NroPed
    FIELD  CodRef    LIKE FacCPedi.CodRef
    FIELDS NroRef   LIKE FacCPedi.NroRef
    FIELDS CodAlm   LIKE Facdpedi.almdes
    FIELDS CodMat   LIKE FacDPedi.CodMat
    FIELDS DesMat   LIKE Almmmatg.DesMat
    FIELDS DesMar   LIKE Almmmatg.DesMar
    FIELDS UndBas   LIKE Almmmatg.UndBas
    FIELDS CanPed   LIKE FacDPedi.CanPed
    FIELDS CodUbi   LIKE Almmmate.CodUbi
    FIELDS CodZona  LIKE Almtubic.CodZona
    FIELDS X-TRANS  LIKE FacCPedi.Libre_c01
    FIELDS X-DIREC  LIKE FACCPEDI.Libre_c02
    FIELDS X-LUGAR  LIKE FACCPEDI.Libre_c03
    FIELDS X-CONTC  LIKE FACCPEDI.Libre_c04
    FIELDS X-HORA   LIKE FACCPEDI.Libre_c05
    FIELDS X-FECHA  LIKE FACCPEDI.Libre_f01
    FIELDS X-OBSER  LIKE FACCPEDI.Observa
    FIELDS X-Glosa  LIKE FACCPEDI.Glosa
    FIELDS X-codcli LIKE FACCPEDI.CodCli
    FIELDS X-NomCli LIKE FACCPEDI.NomCli
    FIELDS X-fchent LIKE faccpedi.fchent
    FIELDS X-peso   AS DEC INIT 0.


&SCOPED-DEFINE CONDICION vtacdocu.codcia = s-codcia ~
AND vtacdocu.divdes = s-coddiv ~
AND (s-CodDoc = "Todos" OR vtacdocu.codped = s-coddoc) ~
AND LOOKUP(vtacdocu.Codped, 'O/D,O/M,OTR') > 0 ~
AND ((lChequeados = NO AND vtacdocu.flgest <> 'A') OR (vtacdocu.flgest = 'P' AND vtacdocu.flgsit = 'T')) ~
AND (pSoloImpresos = NO OR (vtacdocu.usrimpOD <> ? AND vtacdocu.usrimpOD <> "" ))  ~
AND (vtacdocu.fchped >= ltxtDesde AND vtacdocu.fchped <= ltxtHasta)

/* Reporte */
{src/bin/_prns.i}

DEFINE VAR s-task-no AS INT.
DEFINE VAR x-nrodoc AS CHAR.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "aplic/alm/rbalm.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Hoja Ruta2".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.
RB-REPORT-LIBRARY = s-report-library + "alm\rbalm.prl".

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
&Scoped-define INTERNAL-TABLES t-VtaCDocu VtaCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table t-VtaCDocu.CodPed t-VtaCDocu.NroPed ~
t-VtaCDocu.FchPed t-VtaCDocu.Hora t-VtaCDocu.FchEnt t-VtaCDocu.Libre_c01 ~
t-VtaCDocu.NomCli t-VtaCDocu.UsrImpOD t-VtaCDocu.FchImpOD ~
t-VtaCDocu.Libre_d01 t-VtaCDocu.Libre_c03 t-VtaCDocu.Libre_d02 ~
VtaCDocu.Glosa VtaCDocu.CodRef VtaCDocu.NroRef t-VtaCDocu.ordcmp 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH t-VtaCDocu WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST VtaCDocu OF t-VtaCDocu NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH t-VtaCDocu WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST VtaCDocu OF t-VtaCDocu NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table t-VtaCDocu VtaCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table t-VtaCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-br_table VtaCDocu


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-a-distribucion B-table-Win 
FUNCTION fget-a-distribucion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-ordencompra B-table-Win 
FUNCTION fget-ordencompra RETURNS CHARACTER
  ( INPUT pPedido AS CHAR, INPUT pFiltroOrdenCompra AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      t-VtaCDocu, 
      VtaCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      t-VtaCDocu.CodPed COLUMN-LABEL "Cod" FORMAT "x(3)":U WIDTH 3.43
      t-VtaCDocu.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U
            WIDTH 10.43
      t-VtaCDocu.FchPed COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
            WIDTH 8.43
      t-VtaCDocu.Hora FORMAT "X(5)":U WIDTH 6.43
      t-VtaCDocu.FchEnt COLUMN-LABEL "Fecha!Entrega" FORMAT "99/99/9999":U
            WIDTH 9.43
      t-VtaCDocu.Libre_c01 COLUMN-LABEL "Origen" FORMAT "x(25)":U
            WIDTH 12.43
      t-VtaCDocu.NomCli COLUMN-LABEL "Cliente" FORMAT "x(60)":U
            WIDTH 23.43
      t-VtaCDocu.UsrImpOD COLUMN-LABEL "Usuario!Impresion" FORMAT "x(8)":U
      t-VtaCDocu.FchImpOD COLUMN-LABEL "Fecha/Hora!Impresion" FORMAT "99/99/9999 HH:MM:SS.SSS":U
            WIDTH 18.86
      t-VtaCDocu.Libre_d01 COLUMN-LABEL "Peso!KGR" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 8.43
      t-VtaCDocu.Libre_c03 COLUMN-LABEL "A Distribucion" FORMAT "x(25)":U
            WIDTH 14.43
      t-VtaCDocu.Libre_d02 COLUMN-LABEL "Items" FORMAT "->,>>>,>>9":U
            WIDTH 5.57
      VtaCDocu.Glosa COLUMN-LABEL "Glosa" FORMAT "X(60)":U WIDTH 26
      VtaCDocu.CodRef COLUMN-LABEL "Cod!Ref" FORMAT "x(4)":U
      VtaCDocu.NroRef FORMAT "X(15)":U WIDTH 10.57
      t-VtaCDocu.ordcmp FORMAT "X(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 138 BY 8.85
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: t-VtaCDocu T "?" NO-UNDO INTEGRAL VtaCDocu
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
         HEIGHT             = 9.15
         WIDTH              = 139.
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
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.t-VtaCDocu,INTEGRAL.VtaCDocu OF Temp-Tables.t-VtaCDocu"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _FldNameList[1]   > Temp-Tables.t-VtaCDocu.CodPed
"t-VtaCDocu.CodPed" "Cod" ? "character" ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-VtaCDocu.NroPed
"t-VtaCDocu.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-VtaCDocu.FchPed
"t-VtaCDocu.FchPed" "Emision" "99/99/9999" "date" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-VtaCDocu.Hora
"t-VtaCDocu.Hora" ? ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-VtaCDocu.FchEnt
"t-VtaCDocu.FchEnt" "Fecha!Entrega" "99/99/9999" "date" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-VtaCDocu.Libre_c01
"t-VtaCDocu.Libre_c01" "Origen" "x(25)" "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-VtaCDocu.NomCli
"t-VtaCDocu.NomCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "23.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.t-VtaCDocu.UsrImpOD
"t-VtaCDocu.UsrImpOD" "Usuario!Impresion" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.t-VtaCDocu.FchImpOD
"t-VtaCDocu.FchImpOD" "Fecha/Hora!Impresion" ? "datetime" ? ? ? ? ? ? no ? no no "18.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.t-VtaCDocu.Libre_d01
"t-VtaCDocu.Libre_d01" "Peso!KGR" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.t-VtaCDocu.Libre_c03
"t-VtaCDocu.Libre_c03" "A Distribucion" "x(25)" "character" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.t-VtaCDocu.Libre_d02
"t-VtaCDocu.Libre_d02" "Items" "->,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "5.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.VtaCDocu.Glosa
"VtaCDocu.Glosa" "Glosa" ? "character" ? ? ? ? ? ? no ? no no "26" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.VtaCDocu.CodRef
"VtaCDocu.CodRef" "Cod!Ref" "x(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > INTEGRAL.VtaCDocu.NroRef
"VtaCDocu.NroRef" ? ? "character" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   = Temp-Tables.t-VtaCDocu.ordcmp
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-tempo B-table-Win 
PROCEDURE carga-tempo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR lOrdenCompra AS CHAR.

    DEFINE VAR lPeso AS DEC.
    DEFINE VAR lItems AS INT.

    /*MESSAGE s-CodDoc.*/

    EMPTY TEMP-TABLE t-VtaCDocu.                                                                 
    FOR EACH vtacdocu WHERE {&Condicion} NO-LOCK,
        FIRST GN-DIVI OF vtacdocu NO-LOCK:
        /**/
        lPeso = 0.
        lItems = 0.
        lOrdenCompra = "*".
        IF pOrdenCompra <> '' THEN DO:
            lOrdenCompra = fget-OrdenCompra(INPUT VtaCDocu.NroRef, INPUT pOrdenCompra).
        END.
        IF lOrdenCompra <> ''  THEN DO:
            RUN pget-peso-items(OUTPUT lPeso, OUTPUT lItems).
            BUFFER-COPY vtacdocu TO t-VtaCDocu.
            ASSIGN  t-vtacdocu.libre_c01 = gn-div.desdiv
                    t-vtaCdocu.libre_c03 = fGet-a-distribucion()
                    t-vtacdocu.libre_d01 = lPeso
                    t-vtacdocu.libre_d02 = lItems
                    t-vtacdocu.ordcmp = IF(lOrdenCompra = '*') THEN "" ELSE lOrdenCompra.
        END.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-data-impresion B-table-Win 
PROCEDURE cargar-data-impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE Reporte.

DEF VAR k AS INT NO-UNDO.
SESSION:SET-WAIT-STATE('').

DO k = 1 TO {&browse-name}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF NOT {&browse-name}:FETCH-SELECTED-ROW(k) THEN NEXT.
    /* NO KITS */
    FOR EACH VtaDDocu OF VtaCDocu NO-LOCK,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = VtaDDocu.CodCia
        AND Almmmatg.CodMat = VtaDDocu.CodMat:
        FIND FIRST Almckits OF VtaDDocu NO-LOCK NO-ERROR.
        IF AVAILABLE Almckits THEN NEXT.
        FIND Reporte WHERE Reporte.CodMat = VtaDDocu.codmat NO-ERROR.
        IF NOT AVAILABLE Reporte THEN CREATE Reporte.
        ASSIGN 
            Reporte.CodDoc = VtaCDocu.CodPed
            Reporte.NroPed = VtaCDocu.NroPed
            Reporte.CodRef = VtaCDocu.CodRef
            Reporte.NroRef = VtaCDocu.NroRef
            Reporte.CodMat = VtaDDocu.CodMat
            Reporte.DesMat = Almmmatg.DesMat
            Reporte.DesMar = Almmmatg.DesMar
            Reporte.UndBas = Almmmatg.UndBas
            Reporte.CanPed = Reporte.CanPed + ( VtaDDocu.CanPed * VtaDDocu.Factor )
            Reporte.CodAlm = VtaCDocu.CodAlm
            Reporte.CodUbi = "G-0"
            Reporte.CodZona = "G-0"
            Reporte.x-peso = almmmatg.pesmat.
        FIND FIRST Almmmate WHERE Almmmate.CodCia = VtaCDocu.CodCia
            AND Almmmate.CodAlm = VtaDDocu.AlmDes
            AND Almmmate.CodMat = VtaDDocu.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            ASSIGN 
                Reporte.CodUbi = Almmmate.CodUbi.
            FIND Almtubic WHERE Almtubic.codcia = s-codcia
                AND Almtubic.codubi = Almmmate.codubi
                AND Almtubic.codalm = Almmmate.codalm
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtubic THEN Reporte.CodZona = Almtubic.CodZona.
        END.

    END.
    /* SOLO KITS */
    FOR EACH VtaDDocu OF VtaCDocu NO-LOCK,
        FIRST Almckits OF VtaDDocu NO-LOCK,
        EACH Almdkits OF Almckits NO-LOCK,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = VtaCDocu.CodCia
        AND Almmmatg.CodMat = AlmDKits.codmat2:
        FIND Reporte WHERE Reporte.codmat = VtaDDocu.codmat NO-ERROR.
        IF NOT AVAILABLE Reporte THEN CREATE Reporte.
        ASSIGN 
            Reporte.CodDoc = VtaCDocu.CodPed
            Reporte.NroPed = VtaCDocu.NroPed
            Reporte.CodRef = VtaCDocu.CodRef
            Reporte.NroRef = VtaCDocu.NroRef
            Reporte.CodMat = Almmmatg.CodMat
            Reporte.DesMat = TRIM(Almmmatg.DesMat) + ' (KIT ' + TRIM(Facdpedi.codmat) + ')'
            Reporte.DesMar = Almmmatg.DesMar
            Reporte.UndBas = Almmmatg.UndBas
            Reporte.CanPed = Reporte.CanPed + ( VtaDDocu.CanPed * VtaDDocu.Factor *  AlmDKits.Cantidad )
            Reporte.CodAlm = VtaCDocu.CodAlm
            Reporte.CodUbi = "G-0"
            Reporte.CodZona = "G-0"
            Reporte.x-peso = almmmatg.pesmat.
        FIND FIRST Almmmate WHERE Almmmate.CodCia = VtaCDocu.CodCia
            AND Almmmate.CodAlm = VtaDDocu.AlmDes
            AND Almmmate.CodMat = Almmmatg.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            ASSIGN 
                Reporte.CodUbi = Almmmate.CodUbi.
            FIND Almtubic WHERE Almtubic.codcia = s-codcia
                AND Almtubic.codubi = Almmmate.codubi
                AND Almtubic.codalm = Almmmate.codalm
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtubic THEN Reporte.CodZona = Almtubic.CodZona.
        END.
    END.
END.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-w-report B-table-Win 
PROCEDURE cargar-w-report :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

x-nrodoc = STRING(RANDOM(1, 999999),"9999999999").

REPEAT:
    s-task-no = RANDOM(1, 999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                    AND w-report.llave-c = x-nrodoc NO-LOCK)
        THEN DO:
        /*
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.llave-c = x-nrodoc.
        */
        LEAVE.
    END.
END.

DEFINE VAR lPeso AS DEC.
DEFINE VAR lItems AS INT.
DEFINE VAR lNoItm AS INT.
DEFINE VAR x-direccion AS CHAR INIT "".
DEFINE VAR lxGlosa AS CHAR INIT "".

RUN pget-peso-items(OUTPUT lPeso, OUTPUT lItems).

FIND gn-divi OF VtaCDocu NO-LOCK NO-ERROR.
FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = VtaCDocu.codcli NO-LOCK NO-ERROR.
FIND gn-ven OF VtaCDocu NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN DO:
    x-Direccion = if( AVAILABLE gn-clie) THEN gn-clie.dircli ELSE "". 
    FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto THEN DO:
        x-Direccion = TRIM(x-Direccion) + " - " + TRIM(TabDepto.NomDepto).
        FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept 
            AND TabProvi.CodProvi = gn-clie.CodProv
            NO-LOCK NO-ERROR.
        IF AVAILABLE TabProvi THEN DO:
            x-Direccion = x-Direccion + ' - '+ TRIM(TabProvi.NomProvi).
            FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept
                AND TabDistr.CodProvi = gn-clie.CodProv
                AND TabDistr.CodDistr = gn-clie.CodDist
                NO-LOCK NO-ERROR.
            IF AVAILABLE TabDistr THEN x-Direccion = x-Direccion + ' - ' + TabDistr.NomDistr.
        END.
    END.
END.
lxGlosa = VtaCDocu.glosa.

IF VtaCDocu.codped = 'OTR' THEN DO:
    x-direccion = VtaCDocu.dircli.

    /* Glosa desde las SOLICTUDES DE R/A  */
    DEFINE VAR lxSer AS INT.
    DEFINE VAR lxNroDcto AS INT.

    IF VtaCDocu.glosa = ? OR VtaCDocu.glosa = '' THEN DO:
        IF VtaCDocu.codref = 'R/A' THEN DO:
            lxSer = INT(SUBSTRING(VtaCDocu.nroref,1,3)).
            lxNroDcto = INT(SUBSTRING(VtaCDocu.nroref,4)).
    
            FIND FIRST almcrepo WHERE almcrepo.codcia = s-codcia AND 
                                        almcrepo.codalm = VtaCDocu.codcli AND 
                                        almcrepo.nroser = lxSer AND 
                                        almcrepo.nrodoc = lxNroDcto NO-LOCK NO-ERROR.
            IF AVAILABLE almcrepo THEN DO:
                lxGlosa = almcrepo.glosa.
            END.
        END.
    END.
END.

lNoItm = 0.
FOR EACH Reporte BY Reporte.codubi:
    lNoItm = lNoItm + 1.
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.llave-c = x-nrodoc
        w-report.campo-c[20] = "*" + TRIM(VtaCDocu.Nroped) + "*".

        /* Cabecera */
        ASSIGN  w-report.campo-c[6] = "Nro. " + VtaCDocu.Codped + " " + VtaCDocu.Nroped
                w-report.campo-c[7] = "Nro. " + VtaCDocu.CodRef + " " + VtaCDocu.NroRef
                w-report.campo-c[8] = "ORIGEN   : " + if(AVAILABLE gn-divi) THEN gn-divi.desdiv ELSE ""
                w-report.campo-c[9] = "Nro. DE ITEMS : " + string(lItems,">>>,>>9")
                w-report.campo-c[10] = "F." + IF(VtaCDocu.codped='OTR') THEN "DESPACHO :" ELSE "ENTREGA :"
                w-report.campo-c[10] = w-report.campo-c[10] + STRING(VtaCDocu.Fchent,"99/99/9999")
                w-report.campo-c[11] = IF (AVAILABLE gn-ven) THEN ("VENDEDOR : " + gn-ven.nomven) ELSE ""
                w-report.campo-c[12] = "PESO :" + STRING(lPeso,"-ZZ,ZZZ,ZZ9.99")
                w-report.campo-c[13] = IF(VtaCDocu.Codped = 'OTR') THEN "DESTINO  : " ELSE "CLIENTE   : "
                w-report.campo-c[13] = w-report.campo-c[13] + IF(VtaCDocu.Codped = 'OTR') THEN VtaCDocu.Codcli + " " ELSE ""
                w-report.campo-c[13] = w-report.campo-c[13] + VtaCDocu.nomcli
                w-report.campo-c[14] = "Direccion   : " + x-direccion
                w-report.campo-c[15] = "Observacion : " + lxGlosa.
        /* Detalle */
        ASSIGN  w-report.campo-i[1] = lNoItm
                w-report.campo-c[1] = Reporte.CodMat
                w-report.campo-c[2] = Reporte.DesMat
                w-report.campo-c[3] = Reporte.DesMar
                w-report.campo-c[4] = Reporte.UndBas
                w-report.campo-f[1] = Reporte.CanPed
                w-report.campo-c[5] = Reporte.CodUbi.

END.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviar-a-impresora B-table-Win 
PROCEDURE enviar-a-impresora :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RB-INCLUDE-RECORDS = "O".

RB-FILTER = " w-report.task-no = " + STRING(s-task-no) +  
              " AND w-report.llave-c = '" + x-nrodoc + "'".
/*
RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
                        "~ns-division = " + IF(AVAILABLE gn-divi) THEN gn-divi.desdiv ELSE "".
*/
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

ASSIGN
      RB-REPORT-NAME = "impresion-subordenes"
      RB-BEGIN-PAGE = s-pagina-inicial
      RB-END-PAGE = s-pagina-final
      RB-PRINTER-NAME = s-printer-name
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = s-nro-copias.
  CASE s-salida-impresion:
      WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
      WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
      WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
  END CASE.
  /*
  FIND FIRST DI-RutaD OF DI-RutaC NO-LOCK NO-ERROR.

  IF AVAILABLE DI-RutaD THEN
  */
  RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
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
                      "").

/* Borar el temporal */
DEF BUFFER B-w-report FOR w-report.
DEFINE VAR lRowId AS ROWID.

FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK:
    lRowId = ROWID(w-report).
    FIND FIRST b-w-report WHERE ROWID(b-w-report) = lRowid EXCLUSIVE NO-ERROR.
    IF AVAILABLE b-w-report THEN DO:
        DELETE b-w-report.            
    END.    
END.
RELEASE B-w-report.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-orden B-table-Win 
PROCEDURE imprimir-orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN bin/_prnctr.p.
IF s-salida-impresion = 0 THEN RETURN.

RUN cargar-data-impresion.
RUN cargar-w-report.
RUN enviar-a-impresora.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN carga-tempo.  

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pget-peso-items B-table-Win 
PROCEDURE pget-peso-items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pPeso AS DEC.
DEFINE OUTPUT PARAMETER pItems AS INT.

DEFINE VAR lPeso AS DEC.
DEFINE VAR lItems AS INT.

DEFINE BUFFER b-vtaddocu FOR vtaddocu.

lPeso = 0.
lItems = 0.

FOR EACH b-vtaddocu OF vtacdocu NO-LOCK,
    FIRST almmmatg OF b-vtaddocu NO-LOCK :
    lItems = lItems + 1.
    IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN DO:
        lPeso = lPeso + (b-vtaddocu.canped * almmmatg.pesmat).
    END.       
END.
RELEASE b-vtaddocu.

pPeso = lpeso.
pItems = lItems.

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
  {src/adm/template/snd-list.i "t-VtaCDocu"}
  {src/adm/template/snd-list.i "VtaCDocu"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-a-distribucion B-table-Win 
FUNCTION fget-a-distribucion RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
  IF NUM-ENTRIES(vtacdocu.Libre_c03,'|') > 1 
      THEN RETURN ENTRY(2,vtacdocu.Libre_c03,'|').
  ELSE RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-ordencompra B-table-Win 
FUNCTION fget-ordencompra RETURNS CHARACTER
  ( INPUT pPedido AS CHAR, INPUT pFiltroOrdenCompra AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lOrdenCompra AS CHAR INIT ''.
    DEFINE VAR lCotizacion AS CHAR INIT ''.
    
    DEFINE BUFFER b-faccpedi FOR faccpedi.
    DEFINE BUFFER c-faccpedi FOR faccpedi.
    
    /* Busco el PED */
    FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                                b-faccpedi.coddoc = 'PED' AND
                                b-faccpedi.nroped = pPedido NO-LOCK NO-ERROR.
    IF AVAILABLE b-faccpedi THEN DO:
        lCotizacion = b-faccpedi.nroref.
        /* Busco la COT */
        FIND FIRST c-faccpedi WHERE c-faccpedi.codcia = s-codcia AND 
                                    c-faccpedi.coddoc = 'COT' AND
                                    c-faccpedi.nroped = lCotizacion NO-LOCK NO-ERROR.
        IF AVAILABLE c-faccpedi THEN DO:
            IF (c-faccpedi.ordcmp BEGINS pFiltroOrdenCompra) THEN DO:
                lOrdenCompra = TRIM(c-faccpedi.ordcmp).
            END.
        END.
    END.
    
    RELEASE b-faccpedi.
    RELEASE c-faccpedi.

    RETURN lOrdenCompra.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

