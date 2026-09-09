&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ALMACEN FOR Almacen.



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
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEFINE SHARED VAR ltxtDesde AS DATE.
DEFINE SHARED VAR ltxtHasta AS DATE.
DEFINE SHARED VAR lChequeados AS LOG.

/*DEF VAR s-coddoc AS CHAR INIT 'O/D,O/M'.*/
DEF VAR s-coddoc AS CHAR INIT 'O/D'.
DEF VAR x-nroitm AS INT.

&SCOPED-DEFINE CONDICION INTEGRAL.Almcmov.TipMov = "S" AND INTEGRAL.Almcmov.CodMov = 03 ~
        AND ((lChequeados = NO ) OR (INTEGRAL.Almcmov.Libre_c02 = "T" AND INTEGRAL.Almcmov.FlgSit = "T"))  ~
        AND ( integral.almcmov.fchdoc >= lTxtDesde AND integral.almcmov.fchdoc <= lTxtHasta )  ~
        AND INTEGRAL.Almcmov.FlgEst <> "A"

DEFINE TEMP-TABLE Reporte
    FIELD CodDoc    LIKE FacCPedi.CodDoc
    FIELDS NroPed   LIKE FacCPedi.NroPed
    FIELD  CodRef    LIKE FacCPedi.CodRef
    FIELDS NroRef   LIKE FacCPedi.NroRef
    FIELDS CodAlm   LIKE Facdpedi.almdes
    FIELDS AlmDes   LIKE Facdpedi.almdes
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
    FIELDS X-NomCli LIKE FACCPEDI.NomCli.

DEF VAR x-Direccion AS CHAR.
DEF VAR x-Comprobante AS CHAR.

DEF VAR x-UsrImpresion AS CHAR NO-UNDO.
DEF VAR x-FchImpresion AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES Almacen Almcmov B-ALMACEN

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almcmov.NroSer Almcmov.NroDoc ~
Almcmov.FchDoc Almcmov.HorSal B-ALMACEN.Descripcion ~
fUsrImpresion() @ x-UsrImpresion fFchImpresion() @ x-FchImpresion ~
fAlmacen() @ Almcmov.libre_c01 fDistribucion() @ Almcmov.libre_c04 ~
fNroItm() @ x-NroItm Almcmov.Observ 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH Almacen WHERE ~{&KEY-PHRASE} ~
      AND Almacen.CodCia = s-codcia ~
 AND Almacen.CodDiv = s-coddiv ~
 NO-LOCK, ~
      EACH Almcmov OF Almacen ~
      WHERE {&CONDICION} NO-LOCK, ~
      FIRST B-ALMACEN WHERE B-ALMACEN.CodCia = Almcmov.CodCia ~
  AND B-ALMACEN.CodAlm = Almcmov.AlmDes NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almacen WHERE ~{&KEY-PHRASE} ~
      AND Almacen.CodCia = s-codcia ~
 AND Almacen.CodDiv = s-coddiv ~
 NO-LOCK, ~
      EACH Almcmov OF Almacen ~
      WHERE {&CONDICION} NO-LOCK, ~
      FIRST B-ALMACEN WHERE B-ALMACEN.CodCia = Almcmov.CodCia ~
  AND B-ALMACEN.CodAlm = Almcmov.AlmDes NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table Almacen Almcmov B-ALMACEN
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almacen
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almcmov
&Scoped-define THIRD-TABLE-IN-QUERY-br_table B-ALMACEN


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
FchDoc|y||INTEGRAL.Almcmov.FchDoc|yes,B-Almacen.Descripcion|yes
Descripcion|||B-Almacen.Descripcion|yes,INTEGRAL.Almcmov.FchDoc|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'FchDoc,Descripcion' + '",
     SortBy-Case = ':U + 'FchDoc').

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/* This SmartObject is a valid SortBy-Target. */
&IF '{&user-supported-links}':U ne '':U &THEN
  &Scoped-define user-supported-links {&user-supported-links},SortBy-Target
&ELSE
  &Scoped-define user-supported-links SortBy-Target
&ENDIF

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fAlmacen B-table-Win 
FUNCTION fAlmacen RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDestino B-table-Win 
FUNCTION fDestino RETURNS CHARACTER
  ( INPUT pCodAlm AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDistribucion B-table-Win 
FUNCTION fDistribucion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fFchImpresion B-table-Win 
FUNCTION fFchImpresion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNroItm B-table-Win 
FUNCTION fNroItm RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPersonal B-table-Win 
FUNCTION fPersonal RETURNS CHARACTER
     (INPUT cCodPer AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fUsrImpresion B-table-Win 
FUNCTION fUsrImpresion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Almacen, 
      Almcmov, 
      B-ALMACEN SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almcmov.NroSer COLUMN-LABEL "Serie" FORMAT "999":U
      Almcmov.NroDoc COLUMN-LABEL "Número" FORMAT "9999999":U WIDTH 7.29
      Almcmov.FchDoc COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
            WIDTH 9.72
      Almcmov.HorSal COLUMN-LABEL "Hora" FORMAT "X(5)":U WIDTH 5.43
      B-ALMACEN.Descripcion COLUMN-LABEL "Destino" FORMAT "X(50)":U
      fUsrImpresion() @ x-UsrImpresion COLUMN-LABEL "Impreso por" FORMAT "x(8)":U
      fFchImpresion() @ x-FchImpresion COLUMN-LABEL "Fecha y!hora de impresión" FORMAT "x(16)":U
            WIDTH 12.72
      fAlmacen() @ Almcmov.libre_c01 COLUMN-LABEL "ALMACEN" FORMAT "x(20)":U
      fDistribucion() @ Almcmov.libre_c04 COLUMN-LABEL "DISTRIBUCION" FORMAT "x(20)":U
      fNroItm() @ x-NroItm COLUMN-LABEL "Items" FORMAT ">>9":U
            WIDTH 3.72
      Almcmov.Observ FORMAT "X(50)":U WIDTH 11.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 123 BY 7.5
         FONT 4 FIT-LAST-COLUMN.


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
      TABLE: B-ALMACEN B "?" ? INTEGRAL Almacen
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
         HEIGHT             = 7.92
         WIDTH              = 124.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
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

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2
       br_table:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.Almacen,INTEGRAL.Almcmov OF INTEGRAL.Almacen,B-ALMACEN WHERE INTEGRAL.Almcmov ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ",, FIRST"
     _Where[1]         = "INTEGRAL.Almacen.CodCia = s-codcia
 AND INTEGRAL.Almacen.CodDiv = s-coddiv
"
     _Where[2]         = "{&CONDICION}"
     _JoinCode[3]      = "B-ALMACEN.CodCia = Almcmov.CodCia
  AND B-ALMACEN.CodAlm = Almcmov.AlmDes"
     _FldNameList[1]   > INTEGRAL.Almcmov.NroSer
"Almcmov.NroSer" "Serie" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almcmov.NroDoc
"Almcmov.NroDoc" "Número" "9999999" "integer" ? ? ? ? ? ? no ? no no "7.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almcmov.FchDoc
"Almcmov.FchDoc" "Emisión" ? "date" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almcmov.HorSal
"Almcmov.HorSal" "Hora" "X(5)" "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.B-ALMACEN.Descripcion
"B-ALMACEN.Descripcion" "Destino" "X(50)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fUsrImpresion() @ x-UsrImpresion" "Impreso por" "x(8)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fFchImpresion() @ x-FchImpresion" "Fecha y!hora de impresión" "x(16)" ? ? ? ? ? ? ? no ? no no "12.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fAlmacen() @ Almcmov.libre_c01" "ALMACEN" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fDistribucion() @ Almcmov.libre_c04" "DISTRIBUCION" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"fNroItm() @ x-NroItm" "Items" ">>9" ? ? ? ? ? ? ? no ? no no "3.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.Almcmov.Observ
"Almcmov.Observ" ? ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON START-SEARCH OF br_table IN FRAME F-Main
DO:
    DEFINE VARIABLE hSortColumn  AS WIDGET-HANDLE.
    DEFINE VARIABLE hQueryHandle AS HANDLE     NO-UNDO.

    hSortColumn = BROWSE {&BROWSE-NAME}:CURRENT-COLUMN.
    CASE hSortColumn:NAME:
        WHEN "FchDoc" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'FchDoc').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "Descripcion" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'Descripcion').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
    END CASE.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

  RUN get-attribute ('SortBy-Case':U).
  CASE RETURN-VALUE:
    WHEN 'FchDoc':U THEN DO:
      &Scope SORTBY-PHRASE BY Almcmov.FchDoc BY B-Almacen.Descripcion
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Descripcion':U THEN DO:
      &Scope SORTBY-PHRASE BY B-Almacen.Descripcion BY Almcmov.FchDoc
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    OTHERWISE DO:
      &Undefine SORTBY-PHRASE
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* OTHERWISE...*/
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Rb B-table-Win 
PROCEDURE Carga-Temporal-Rb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Reporte.
/* NO KITS */
FOR EACH Almdmov OF Almcmov NO-LOCK,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = Almcmov.CodCia
    AND Almmmatg.CodMat = Almdmov.CodMat:
    FIND FIRST Almckits OF Almdmov NO-LOCK NO-ERROR.
    IF AVAILABLE Almckits THEN NEXT.
    CREATE Reporte.
    ASSIGN 
        Reporte.CodDoc = "G/R"
        Reporte.NroPed = STRING(Almcmov.NroSer,'999') + STRING(Almcmov.NroDoc, '9999999')
        Reporte.CodRef = Almcmov.CodRef
        Reporte.NroRef = Almcmov.NroRef
        Reporte.CodMat = Almdmov.CodMat
        Reporte.DesMat = Almmmatg.DesMat
        Reporte.DesMar = Almmmatg.DesMar
        Reporte.UndBas = Almmmatg.UndBas
        Reporte.CanPed = Almdmov.CanDes * Almdmov.Factor
        Reporte.CodAlm = Almcmov.CodAlm
        Reporte.AlmDes = Almcmov.AlmDes
        Reporte.CodUbi = "G-0"
        Reporte.CodZona = "G-0".
    FIND FIRST Almmmate WHERE Almmmate.CodCia = Almcmov.CodCia
        AND Almmmate.CodAlm = Almdmov.CodAlm
        AND Almmmate.CodMat = Almdmov.CodMat
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
FOR EACH Almdmov OF Almcmov NO-LOCK,
    FIRST Almckits OF Almdmov NO-LOCK,
    EACH Almdkits OF Almckits NO-LOCK,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = Almcmov.CodCia
    AND Almmmatg.CodMat = AlmDKits.codmat2:
    CREATE Reporte.
    ASSIGN 
        Reporte.CodDoc = "G/R"
        Reporte.NroPed = STRING(Almcmov.NroSer,'999') + STRING(Almcmov.NroDoc, '9999999')
        Reporte.CodRef = Almcmov.CodRef
        Reporte.NroRef = Almcmov.NroRef
        Reporte.CodMat = Almmmatg.CodMat
        Reporte.DesMat = TRIM(Almmmatg.DesMat) + ' (KIT ' + TRIM(Almdmov.codmat) + ')'
        Reporte.DesMar = Almmmatg.DesMar
        Reporte.UndBas = Almmmatg.UndBas
        Reporte.CanPed = Almdmov.CanDes * Almdmov.Factor *  AlmDKits.Cantidad
        Reporte.CodAlm = Almcmov.CodAlm
        Reporte.CodUbi = "G-0"
        Reporte.CodZona = "G-0".
    FIND FIRST Almmmate WHERE Almmmate.CodCia = Almcmov.CodCia
        AND Almmmate.CodAlm = Almdmov.CodAlm
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb B-table-Win 
PROCEDURE Formato-Rb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items        AS INTEGER  NO-UNDO.
DEFINE VARIABLE npage          AS INTEGER  NO-UNDO.

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
conta = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.

x-Direccion = Almacen.DirAlm.
DEFINE FRAME f-cab
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 80 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + STRING(npage) AT 104 FORMAT "X(15)" SKIP      /*SKIP(1)*/
        {&PRN4} + {&PRN6A} + "      Fecha: " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "        N° G/R: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6B} + "       Hora: " STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        {&PRN4} + {&PRN6B} + "  Dirección: " + x-Direccion FORMAT "X(120)" SKIP
        {&PRN4} + {&PRN6B} + "Observación: " + Almcmov.observ  FORMAT "X(80)" SKIP
        {&PRN4} + {&PRN6B} + "Alm.  Origen: " + fDestino(Reporte.codalm)  FORMAT "X(80)" SKIP
        {&PRN4} + {&PRN6B} + "Alm. Destino: " + fDestino(Reporte.almdes)  FORMAT "X(80)" SKIP

        /*"-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP*/
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

conta = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    DISPLAY STREAM Report 
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        Reporte.CodUbi
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        PAGE STREAM Report.
        conta = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb2 B-table-Win 
PROCEDURE Formato-Rb2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items        AS INTEGER  NO-UNDO.
DEFINE VARIABLE npage          AS INTEGER  NO-UNDO.

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
conta = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.

x-Direccion = Almacen.DirAlm.
x-Comprobante = ''.
DEFINE FRAME f-cab
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 80 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + STRING(npage) AT 104 FORMAT "X(15)" SKIP(1)
        {&PRN4} + {&PRN6A} + "      Fecha: " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "       N° GUIA: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6B} + "       Hora: " STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        {&PRN4} + {&PRN6B} + "  Dirección: " + x-Direccion FORMAT "X(120)" SKIP
        {&PRN4} + {&PRN6B} + "Observación: " + Almcmov.observ  FORMAT "X(80)" SKIP
        {&PRN4} + {&PRN6B} + "Alm.  Origen: " + fDestino(Reporte.codalm)  FORMAT "X(80)" SKIP
        {&PRN4} + {&PRN6B} + "Alm. Destino: " + fDestino(Reporte.almdes)  FORMAT "X(80)" SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

conta = 1.
FOR EACH Reporte BY Reporte.DesMat:
    DISPLAY STREAM Report 
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        Reporte.CodUbi
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    IF conta > c-items THEN DO:
        PAGE STREAM Report.
        conta = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-Formato B-table-Win 
PROCEDURE Imprimir-Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pOrden AS CHAR.
/*
ZONA: por zona
ALFABETICO: por descripción
*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Impresión por Zonas y Ubicaciones */
  DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

  RUN lib/Imprimir2.
  IF s-salida-impresion = 0 THEN RETURN.

  RUN Carga-Temporal-Rb.

  IF Almcmov.Libre_L01 = NO THEN DO:
      FIND CURRENT Almcmov EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Almcmov THEN DO:
          MESSAGE 'No se pudo bloquear la Orden' VIEW-AS ALERT-BOX ERROR.
          RETURN.
      END.
  END.

  IF s-salida-impresion = 1 THEN 
      s-print-file = SESSION:TEMP-DIRECTORY +
      STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

  DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
      CASE s-salida-impresion:
          WHEN 1 OR WHEN 3 THEN
              OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 30.
          WHEN 2 THEN
              OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 30. /* Impresora */
      END CASE.
      PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4} .
      CASE pOrden:
          WHEN "ZONA" THEN RUN Formato-Rb.
          WHEN "ALFABETICO" THEN RUN Formato-Rb2.
      END CASE.
      
      PAGE STREAM REPORT.
      OUTPUT STREAM REPORT CLOSE.
  END.
  OUTPUT CLOSE.

  CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN DO:
          RUN LIB/W-README.R(s-print-file).
          IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
      END.
  END CASE.


  IF Almcmov.Libre_L01 = NO 
      THEN ASSIGN
            Almcmov.Libre_L01 = YES
            Almcmov.Libre_C01 = s-user-id + '|' + STRING(DATETIME(TODAY, MTIME)).
  FIND CURRENT Almcmov NO-LOCK NO-ERROR.

  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF Faccpedi.FlgImpOD = NO THEN DO:
      FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccpedi THEN DO:
          RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
          RETURN.
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* Impresión por Zonas y Ubicaciones */
  DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

  RUN lib/Imprimir2.
  IF s-salida-impresion = 0 THEN RETURN.

  RUN Carga-Temporal-Rb.

  FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN RETURN.

  IF s-salida-impresion = 1 THEN 
      s-print-file = SESSION:TEMP-DIRECTORY +
      STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

  DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
      CASE s-salida-impresion:
          WHEN 1 OR WHEN 3 THEN
              OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 30.
          WHEN 2 THEN
              OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 30. /* Impresora */
      END CASE.
      PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4} .
      RUN Formato-Rb.
      PAGE STREAM REPORT.
      OUTPUT STREAM REPORT CLOSE.
  END.
  OUTPUT CLOSE.

  CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN DO:
          RUN LIB/W-README.R(s-print-file).
          IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
      END.
  END CASE.


  IF FacCPedi.FlgImpOD = NO 
      THEN ASSIGN
            FacCPedi.FlgImpOD = YES
            FacCPedi.UsrImpOD = s-user-id
            FacCPedi.FchImpOD = DATETIME(TODAY, MTIME).
  FIND CURRENT Faccpedi NO-LOCK NO-ERROR.

  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
  {src/adm/template/snd-list.i "Almacen"}
  {src/adm/template/snd-list.i "Almcmov"}
  {src/adm/template/snd-list.i "B-ALMACEN"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel B-table-Win 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-signo                 AS DECI.

DEFINE VARIABLE lsFechaEmision          AS CHARACTER.
DEFINE VARIABLE lsHoraEmision           AS CHARACTER.

DEFINE VARIABLE ldtFechaEmision         AS DATETIME.
DEFINE VARIABLE ldtFechaDistribucion    AS DATETIME.
DEFINE VARIABLE ldtFechaImpresion       AS DATETIME.
DEFINE VARIABLE lsDifTempo_VtaAlm       AS CHARACTER.
DEFINE VARIABLE lsDifTempo_AlmDist      AS CHARACTER.
DEFINE VARIABLE lsDifTempo_VtaDist      AS CHARACTER.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = FALSE.

/* Para crear a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

chWorkSheet:Range("A1:R1"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Value = "Serie".
chWorkSheet:Range("B1"):Value = "Numero".
chWorkSheet:Range("C1"):Value = "Emision".
chWorkSheet:Range("D1"):Value = "Hora".
chWorkSheet:Range("E1"):Value = "Destino".
chWorkSheet:Range("F1"):Value = "Impreso por".
chWorkSheet:Range("G1"):Value = "Fecha y hora impresion".
chWorkSheet:Range("H1"):Value = "Almacen".
chWorkSheet:Range("I1"):Value = "Distribucion".
chWorkSheet:Range("J1"):Value = "Items".
chWorkSheet:Range("K1"):Value = "Observacion".
chWorkSheet:Range("L1"):Value = "Venta a Impresion".
chWorkSheet:Range("M1"):Value = "Impresion a Distribucion".
chWorkSheet:Range("N1"):Value = "Venta a Distribucion".
chWorkSheet:Range("O1"):Value = "Usuario a Distribucion".
chWorkSheet:Range("P1"):Value = "Nombre Usuario".

DEF VAR x-Column AS INT INIT 74 NO-UNDO.
DEF VAR x-Range  AS CHAR NO-UNDO.
DEFINE VAR lUser2Distr AS CHAR.

DEFINE VAR lNomUser AS CHAR.

iColumn = 1.
GET FIRST {&BROWSE-NAME}.
DO  WHILE AVAILABLE almcmov:
     iColumn = iColumn + 1.
     cColumn = STRING(iColumn).

     lUser2Distr = IF (NUM-ENTRIES(Almcmov.Libre_c01,'|') > 2) THEN  ENTRY(3,Almcmov.Libre_c01,'|') ELSE "".

     cRange = "A" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + string(almcmov.nroser,"999").
     cRange = "B" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + string(almcmov.nrodoc,"999999").
     cRange = "C" + cColumn.
     chWorkSheet:Range(cRange):Value =  almcmov.fchdoc.
     cRange = "D" + cColumn.
     chWorkSheet:Range(cRange):Value =  almcmov.horsal.
     cRange = "E" + cColumn.
     chWorkSheet:Range(cRange):Value =  fDestino(Almcmov.AlmDes).
     cRange = "F" + cColumn.
     chWorkSheet:Range(cRange):Value =  fUsrImpresion().
     cRange = "G" + cColumn.
     chWorkSheet:Range(cRange):Value =  fFchImpresion().
     cRange = "H" + cColumn.
     chWorkSheet:Range(cRange):Value =  fAlmacen().
     cRange = "I" + cColumn.
     chWorkSheet:Range(cRange):Value =  fDistribucion().
     cRange = "J" + cColumn.
     chWorkSheet:Range(cRange):Value =  fNroItm().
     cRange = "K" + cColumn.
     chWorkSheet:Range(cRange):Value =  fNroItm().

     lsFechaEmision = STRING(almcmov.fchdoc, '99-99-9999').
     lsHoraEmision  = almcmov.horsal.

     ldtFechaEmision      = DATETIME(lsFechaEmision + ' ' + lsHoraEmision).
     ldtFechaDistribucion = DATETIME(fDistribucion()) /*DATETIME(IF(NUM-ENTRIES(almcmov.Libre_c04,'|') > 1) THEN ENTRY(2,almcmov.Libre_c04,'|') ELSE "")*/.
     ldtFechaImpresion    = DATETIME(fFchImpresion()) /*DATETIME(IF(NUM-ENTRIES(almcmov.Libre_c01,'|') > 1) THEN ENTRY(2,almcmov.Libre_c01,'|') ELSE "")*/.

     RUN lib\_time-passed.p (ldtFechaEmision, ldtFechaImpresion, OUTPUT lsDifTempo_VtaAlm).
     RUN lib\_time-passed.p (ldtFechaImpresion, ldtFechaDistribucion, OUTPUT lsDifTempo_AlmDist).
     RUN lib\_time-passed.p (ldtFechaEmision, ldtFechaDistribucion, OUTPUT lsDifTempo_VtaDist).

     chWorkSheet:Range("L" + cColumn):Value = lsDifTempo_VtaAlm.
     chWorkSheet:Range("M" + cColumn):Value = lsDifTempo_AlmDist.
     chWorkSheet:Range("N" + cColumn):Value = lsDifTempo_VtaDist.
     chWorkSheet:Range("O" + cColumn):Value = "'" + lUser2Distr.

     lNomUser = fPersonal(lUser2Distr).
     cRange = "P" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + lNomUser.     

    GET NEXT {&BROWSE-NAME}.
END.



/* release com-handles */
chExcelApplication:Visible = TRUE.

RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fAlmacen B-table-Win 
FUNCTION fAlmacen RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NUM-ENTRIES(Almcmov.Libre_c01,'|') > 1 
      THEN RETURN ENTRY(2,Almcmov.Libre_c01,'|').
  ELSE RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDestino B-table-Win 
FUNCTION fDestino RETURNS CHARACTER
  ( INPUT pCodAlm AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND Almacen WHERE codcia = s-codcia
      AND codalm = pCodAlm
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN RETURN  Almacen.Descripcion.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDistribucion B-table-Win 
FUNCTION fDistribucion RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NUM-ENTRIES(Almcmov.Libre_c04,'|') > 1 
      THEN RETURN ENTRY(2,Almcmov.Libre_c04,'|').
  ELSE RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fFchImpresion B-table-Win 
FUNCTION fFchImpresion RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NUM-ENTRIES(Almcmov.Libre_c01, '|') > 1 THEN RETURN ENTRY(2, Almcmov.Libre_c01, '|').
      ELSE RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNroItm B-table-Win 
FUNCTION fNroItm RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR i AS INT.
FOR EACH almdmov OF almcmov NO-LOCK:
    i = i + 1.
END.
RETURN i.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPersonal B-table-Win 
FUNCTION fPersonal RETURNS CHARACTER
     (INPUT cCodPer AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lPersonal AS CHAR.

    lPersonal = "".
    FIND FIRST pl-pers WHERE pl-pers.codper = cCodPer NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN DO:
        lPersonal = pl-pers.patper + ' ' + pl-pers.matper + ' ' + pl-pers.nomper.
    END.

  RETURN lPersonal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fUsrImpresion B-table-Win 
FUNCTION fUsrImpresion RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ENTRY(1, Almcmov.Libre_c01, '|').

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

