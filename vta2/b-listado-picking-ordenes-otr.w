&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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

DEF SHARED VAR s-coddoc AS CHAR.
DEF VAR x-nroitm AS INT.

DEFINE SHARED VAR ltxtDesde AS DATE.
DEFINE SHARED VAR ltxtHasta AS DATE.
DEFINE SHARED VAR lChequeados AS LOGICAL.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE lMsgRetorno AS CHAR.

&SCOPED-DEFINE CONDICION faccpedi.codcia = s-codcia ~
AND faccpedi.coddoc = s-coddoc ~
AND faccpedi.divdes = s-coddiv ~
AND ((lChequeados = NO AND faccpedi.flgest <> 'A') OR (faccpedi.flgest = 'P' AND faccpedi.flgsit = 'P')) ~
AND (faccpedi.fchped >= ltxtDesde AND faccpedi.fchped <= ltxtHasta)

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
        FIELDS X-peso   AS DEC INIT 0.

DEF VAR x-Direccion AS CHAR.
DEF VAR x-Comprobante AS CHAR.

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
&Scoped-define INTERNAL-TABLES FacCPedi GN-DIVI

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.CodDoc FacCPedi.NroPed ~
FacCPedi.FchPed FacCPedi.Hora FacCPedi.FchEnt fPeso() @ x-peso ~
FacCPedi.CodCli FacCPedi.NomCli FacCPedi.UsrImpOD FacCPedi.FchImpOD ~
fAlmacen() @ Faccpedi.Libre_c02 fDistribucion() @ Faccpedi.Libre_c03 ~
fNroItm() @ x-NroItm FacCPedi.Glosa FacCPedi.CodRef FacCPedi.NroRef 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} USE-INDEX Llave09 NO-LOCK, ~
      FIRST GN-DIVI OF FacCPedi NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} USE-INDEX Llave09 NO-LOCK, ~
      FIRST GN-DIVI OF FacCPedi NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table FacCPedi GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table GN-DIVI


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
NroPed|y||INTEGRAL.FacCPedi.NroPed|yes
FchPed|||INTEGRAL.FacCPedi.FchPed|yes
NomCli|||INTEGRAL.FacCPedi.NomCli|yes
CodCli|||INTEGRAL.FacCPedi.CodCli|yes
CodRef|||INTEGRAL.FacCPedi.CodRef|yes
NroRef|||INTEGRAL.FacCPedi.NroRef|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'NroPed,FchPed,NomCli,CodCli,CodRef,NroRef' + '",
     SortBy-Case = ':U + 'NroPed').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDistribucion B-table-Win 
FUNCTION fDistribucion RETURNS CHARACTER
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      FacCPedi, 
      GN-DIVI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.CodDoc FORMAT "x(3)":U WIDTH 4.43
      FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(9)":U WIDTH 8.57
      FacCPedi.FchPed COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
      FacCPedi.Hora FORMAT "X(5)":U WIDTH 6
      FacCPedi.FchEnt COLUMN-LABEL "Entrega" FORMAT "99/99/9999":U
      fPeso() @ x-peso COLUMN-LABEL "Peso (KG)" FORMAT ">>,>>>,>>9.99":U
            WIDTH 9.14
      FacCPedi.CodCli COLUMN-LABEL "Solicitante" FORMAT "x(8)":U
      FacCPedi.NomCli FORMAT "x(50)":U WIDTH 32.14
      FacCPedi.UsrImpOD COLUMN-LABEL "Impreso por" FORMAT "x(8)":U
            WIDTH 8.43
      FacCPedi.FchImpOD COLUMN-LABEL "Fecha y!hora de impresión" FORMAT "99/99/9999 HH:MM":U
            WIDTH 12.43
      fAlmacen() @ Faccpedi.Libre_c02 COLUMN-LABEL "ALMACEN" FORMAT "x(20)":U
      fDistribucion() @ Faccpedi.Libre_c03 COLUMN-LABEL "DISTRIBUCION" FORMAT "x(20)":U
      fNroItm() @ x-NroItm COLUMN-LABEL "Items" FORMAT ">>9":U
            WIDTH 3.72
      FacCPedi.Glosa FORMAT "X(50)":U WIDTH 23.29
      FacCPedi.CodRef COLUMN-LABEL "Cod!Ref" FORMAT "x(3)":U WIDTH 5.14
      FacCPedi.NroRef FORMAT "X(9)":U WIDTH 11.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 144 BY 7.5
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
         WIDTH              = 146.29.
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
     _TblList          = "INTEGRAL.FacCPedi,INTEGRAL.GN-DIVI OF INTEGRAL.FacCPedi"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _OrdList          = "INTEGRAL.FacCPedi.FchPed|no,INTEGRAL.FacCPedi.Hora|no"
     _Where[1]         = "{&Condicion} USE-INDEX Llave09"
     _FldNameList[1]   > INTEGRAL.FacCPedi.CodDoc
"FacCPedi.CodDoc" ? ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.Hora
"FacCPedi.Hora" ? ? "character" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.FchEnt
"FacCPedi.FchEnt" "Entrega" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fPeso() @ x-peso" "Peso (KG)" ">>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" "Solicitante" "x(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "32.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacCPedi.UsrImpOD
"FacCPedi.UsrImpOD" "Impreso por" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.FacCPedi.FchImpOD
"FacCPedi.FchImpOD" "Fecha y!hora de impresión" "99/99/9999 HH:MM" "datetime" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"fAlmacen() @ Faccpedi.Libre_c02" "ALMACEN" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"fDistribucion() @ Faccpedi.Libre_c03" "DISTRIBUCION" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"fNroItm() @ x-NroItm" "Items" ">>9" ? ? ? ? ? ? ? no ? no no "3.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.FacCPedi.Glosa
"FacCPedi.Glosa" ? ? "character" ? ? ? ? ? ? no ? no no "23.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > INTEGRAL.FacCPedi.CodRef
"FacCPedi.CodRef" "Cod!Ref" ? "character" ? ? ? ? ? ? no ? no no "5.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > INTEGRAL.FacCPedi.NroRef
"FacCPedi.NroRef" ? ? "character" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
        WHEN "NroPed" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'NroPed').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "FchPed" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'FchPed').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "NomCli" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'NomCli').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "CodCli" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'CodCli').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "CodRef" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'CodRef').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "NroRef" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'NroRef').
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

    DEFINE VAR lxpeso AS DEC.
    lMsgretorno = ''.

    lxPeso = fpeso().

    IF {&browse-name}:NUM-SELECTED-ROWS > 1 THEN DO:
        RUN Procesa-Handle IN lh_handle ('Disable-Buttons').
    END.
    ELSE RUN Procesa-Handle IN lh_handle ('Enable-Buttons').

    RUN ue-pinta-referencia IN lh_handle (INPUT faccpedi.codref, INPUT faccpedi.nroref).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE A-Distribucion B-table-Win 
PROCEDURE A-Distribucion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF Faccpedi.Libre_c02 = '' OR Faccpedi.Libre_c03 <> '' THEN RETURN.

  /* Ic - 20mar2015 - Felix Perez 
  MESSAGE 'Enviamos la Orden de Despacho a Distribución?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN.
  */

  DEF VAR x-UsrChq LIKE Faccpedi.usrchq NO-UNDO.
  RUN vtamay/d-chqped (OUTPUT x-UsrChq).
  IF x-UsrChq = '' THEN RETURN 'ADM-ERROR'.

  FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN DO:
      MESSAGE 'No se pudo bloquear la Orden' VIEW-AS ALERT-BOX ERROR.
      RETURN.
  END.  

  ASSIGN
      FacCPedi.Libre_c03 = s-user-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS') + '|' + x-UsrChq
      FacCpedi.ubigeo[4] = x-UsrChq.

  FIND CURRENT Faccpedi NO-LOCK NO-ERROR.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
    WHEN 'NroPed':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.NroPed
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'FchPed':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.FchPed
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'NomCli':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.NomCli
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'CodCli':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.CodCli
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'CodRef':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.CodRef
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'NroRef':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.NroRef
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
FOR EACH FacDPedi OF FacCPedi NO-LOCK,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = FacCPedi.CodCia
    AND Almmmatg.CodMat = FacDPedi.CodMat:
    FIND FIRST Almckits OF Facdpedi NO-LOCK NO-ERROR.
    IF AVAILABLE Almckits THEN NEXT.
    CREATE Reporte.
    ASSIGN 
        Reporte.CodDoc = FacCPedi.CodDoc
        Reporte.NroPed = FacCPedi.NroPed
        Reporte.CodRef = FacCPedi.CodRef
        Reporte.NroRef = FacCPedi.NroRef
        Reporte.CodMat = FacDPedi.CodMat
        Reporte.DesMat = Almmmatg.DesMat
        Reporte.DesMar = Almmmatg.DesMar
        Reporte.UndBas = Almmmatg.UndBas
        Reporte.CanPed = FacDPedi.CanPed * FacDPedi.Factor
        Reporte.CodAlm = FacCPedi.CodAlm
        Reporte.CodUbi = "G-0"
        Reporte.CodZona = "G-0"
        reporte.X-peso = almmmatg.pesmat.
    FIND FIRST Almmmate WHERE Almmmate.CodCia = FacCPedi.CodCia
        AND Almmmate.CodAlm = FacDPedi.AlmDes
        AND Almmmate.CodMat = FacDPedi.CodMat
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
FOR EACH FacDPedi OF FacCPedi NO-LOCK,
    FIRST Almckits OF Facdpedi NO-LOCK,
    EACH Almdkits OF Almckits NO-LOCK,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = FacCPedi.CodCia
    AND Almmmatg.CodMat = AlmDKits.codmat2:
    CREATE Reporte.
    ASSIGN 
        Reporte.CodDoc = FacCPedi.CodDoc
        Reporte.NroPed = FacCPedi.NroPed
        Reporte.CodRef = FacCPedi.CodRef
        Reporte.NroRef = FacCPedi.NroRef
        Reporte.CodMat = Almmmatg.CodMat
        Reporte.DesMat = TRIM(Almmmatg.DesMat) + ' (KIT ' + TRIM(Facdpedi.codmat) + ')'
        Reporte.DesMar = Almmmatg.DesMar
        Reporte.UndBas = Almmmatg.UndBas
        Reporte.CanPed = FacDPedi.CanPed * FacDPedi.Factor *  AlmDKits.Cantidad
        Reporte.CodAlm = FacCPedi.CodAlm
        Reporte.CodUbi = "G-0"
        Reporte.CodZona = "G-0"
        reporte.X-peso = almmmatg.pesmat.
    FIND FIRST Almmmate WHERE Almmmate.CodCia = FacCPedi.CodCia
        AND Almmmate.CodAlm = FacDPedi.AlmDes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE envia-excel B-table-Win 
PROCEDURE envia-excel :
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
DEFINE VARIABLE lsDifTempo_VtaAlm       AS CHARACTER.
DEFINE VARIABLE lsDifTempo_AlmDist      AS CHARACTER.
DEFINE VARIABLE lsDifTempo_VtaDist      AS CHARACTER.

DEFINE VAR lNomUser AS CHAR.
DEFINE VAR lCodUser AS CHAR.

SESSION:SET-WAIT-STATE('GENERAL').

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
        chWorkSheet:Range("A1"):Value = "Codigo".
        chWorkSheet:Range("B1"):Value = "Numero".
        chWorkSheet:Range("C1"):Value = "Emision".
        chWorkSheet:Range("D1"):Value = "Hora".
        chWorkSheet:Range("E1"):Value = "Origen".
        chWorkSheet:Range("F1"):Value = "Cliente".
        chWorkSheet:Range("G1"):Value = "Impreso por".
        chWorkSheet:Range("H1"):Value = "Fecha/Hora Impresion".
        chWorkSheet:Range("I1"):Value = "Fecha/Hora Distribucion".      /* Nueva columna */
        chWorkSheet:Range("J1"):Value = "Items".
        chWorkSheet:Range("K1"):Value = "Glosa".
        chWorkSheet:Range("L1"):Value = "De Venta a Almacén".      /* Nueva columna */
        chWorkSheet:Range("M1"):Value = "De Almacén a Distribución".      /* Nueva columna */
        chWorkSheet:Range("N1"):Value = "De Venta a Distribución".      /* Nueva columna */
        chWorkSheet:Range("O1"):Value = "Usuario a Distribucion".      /* Nueva columna */
        chWorkSheet:Range("P1"):Value = "Nombre Usuario".      /* Nueva columna */

        iColumn = 1.

    GET FIRST {&BROWSE-NAME}.
    DO  WHILE AVAILABLE faccpedi:
             iColumn = iColumn + 1.
             cColumn = STRING(iColumn).

             chWorkSheet:Range("A" + cColumn):Value = "'" + faccpedi.coddoc.
             chWorkSheet:Range("B" + cColumn):Value = "'" + faccpedi.nroped.             
             chWorkSheet:Range("C" + cColumn):Value = faccpedi.fchped.             
             chWorkSheet:Range("D" + cColumn):Value = faccpedi.hora.
             cRange = "E" + cColumn.
             chWorkSheet:Range(cRange):Value = gn-divi.desdiv.
             cRange = "F" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.nomcli.
             cRange = "G" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.usrimpod.
             cRange = "H" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.fchimpod.

             cRange = "I" + cColumn.
             chWorkSheet:Range(cRange):Value = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "".

         iCount = 0.
         FOR EACH facdpedi OF faccpedi NO-LOCK:
            iCount = iCount + 1.
         END.
             cRange = "J" + cColumn.
             chWorkSheet:Range(cRange):Value = iCount.
        
             cRange = "K" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.glosa.


         lsFechaEmision = STRING(faccpedi.fchped, '99-99-9999').
         lsHoraEmision  = faccpedi.hora.
         
         ldtFechaEmision      = DATETIME(lsFechaEmision + ' ' + lsHoraEmision).
         ldtFechaDistribucion = DATETIME(IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "").

         RUN lib\_time-passed.p (ldtFechaEmision, faccpedi.fchimpod, OUTPUT lsDifTempo_VtaAlm).
         RUN lib\_time-passed.p (faccpedi.fchimpod, ldtFechaDistribucion, OUTPUT lsDifTempo_AlmDist).
         RUN lib\_time-passed.p (ldtFechaEmision, ldtFechaDistribucion, OUTPUT lsDifTempo_VtaDist).
         
         chWorkSheet:Range("L" + cColumn):Value = lsDifTempo_VtaAlm.
         chWorkSheet:Range("M" + cColumn):Value = lsDifTempo_AlmDist.
         chWorkSheet:Range("N" + cColumn):Value = lsDifTempo_VtaDist.

         cRange = "O" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".

         lCodUser = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".
         lNomUser = fPersonal(lCodUser).
         cRange = "P" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + lNomUser.

         
         GET NEXT {&BROWSE-NAME}.
    END.

    SESSION:SET-WAIT-STATE('').
        
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication NO-ERROR.      
    RELEASE OBJECT chWorkbook NO-ERROR.
    RELEASE OBJECT chWorksheet NO-ERROR.
    RELEASE OBJECT chWorksheetRange NO-ERROR. 

    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE envia-excel-detalle B-table-Win 
PROCEDURE envia-excel-detalle :
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
DEFINE VARIABLE lsDifTempo_VtaAlm       AS CHARACTER.
DEFINE VARIABLE lsDifTempo_AlmDist      AS CHARACTER.
DEFINE VARIABLE lsDifTempo_VtaDist      AS CHARACTER.

SESSION:SET-WAIT-STATE('GENERAL').

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
chWorkSheet:Range("A1"):Value = "Codigo".
chWorkSheet:Range("B1"):Value = "Numero".
chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:Range("C1"):Value = "Emision".
chWorkSheet:COLUMNS("C"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("D1"):Value = "Hora".
chWorkSheet:Range("E1"):Value = "Origen".
chWorkSheet:COLUMNS("E"):NumberFormat = "@".
chWorkSheet:Range("F1"):Value = "Cliente".
chWorkSheet:COLUMNS("F"):NumberFormat = "@".
chWorkSheet:Range("G1"):Value = "Impreso por".
chWorkSheet:Range("H1"):Value = "Fecha/Hora Impresion".
chWorkSheet:Range("I1"):Value = "Fecha/Hora Distribucion".      /* Nueva columna */
chWorkSheet:Range("J1"):Value = "Items".
chWorkSheet:Range("K1"):Value = "Glosa".
chWorkSheet:Range("L1"):Value = "De Venta a Almacén".      /* Nueva columna */
chWorkSheet:Range("M1"):Value = "De Almacén a Distribución".      /* Nueva columna */
chWorkSheet:Range("N1"):Value = "De Venta a Distribución".      /* Nueva columna */
chWorkSheet:Range("O1"):Value = "Articulo".
chWorkSheet:COLUMNS("O"):NumberFormat = "@".
chWorkSheet:Range("P1"):Value = "Descripcion".
chWorkSheet:Range("Q1"):Value = "Peso Unit".
chWorkSheet:Range("R1"):Value = "Marca".
chWorkSheet:Range("S1"):Value = "Cantidad".
chWorkSheet:Range("T1"):Value = "Unidad".
chWorkSheet:Range("U1"):Value = "Almacen".
chWorkSheet:COLUMNS("U"):NumberFormat = "@".
chWorkSheet:Range("V1"):Value = "Zona".
chWorkSheet:Range("W1"):Value = "Ubicacion".
chWorkSheet:Range("X1"):Value = "Peso Tot".
chWorkSheet:Range("Y1"):Value = "Usuario a Distribucion".
chWorkSheet:Range("Z1"):Value = "Nombre Usuario".

DEFINE VAR lNomUser AS CHAR.
DEFINE VAR lCodUser AS CHAR.

iColumn = 1.

GET FIRST {&BROWSE-NAME}.
DO WHILE AVAILABLE faccpedi:
    FOR EACH facdpedi OF faccpedi NO-LOCK, FIRST almmmatg OF facdpedi NO-LOCK:
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        chWorkSheet:Range("A" + cColumn):Value = faccpedi.coddoc.
        chWorkSheet:Range("B" + cColumn):Value = faccpedi.nroped.             
        chWorkSheet:Range("C" + cColumn):Value = faccpedi.fchped.             
        chWorkSheet:Range("D" + cColumn):Value = faccpedi.hora.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = gn-divi.desdiv.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.nomcli.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.usrimpod.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.fchimpod.

        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "".
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = iCount.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.glosa.
        lsFechaEmision = STRING(faccpedi.fchped, '99-99-9999').
        lsHoraEmision  = faccpedi.hora.
        ldtFechaEmision      = DATETIME(lsFechaEmision + ' ' + lsHoraEmision).
        ldtFechaDistribucion = DATETIME(IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "").
        RUN lib\_time-passed.p (ldtFechaEmision, faccpedi.fchimpod, OUTPUT lsDifTempo_VtaAlm).
        RUN lib\_time-passed.p (faccpedi.fchimpod, ldtFechaDistribucion, OUTPUT lsDifTempo_AlmDist).
        RUN lib\_time-passed.p (ldtFechaEmision, ldtFechaDistribucion, OUTPUT lsDifTempo_VtaDist).
        chWorkSheet:Range("L" + cColumn):Value = lsDifTempo_VtaAlm.
        chWorkSheet:Range("M" + cColumn):Value = lsDifTempo_AlmDist.
        chWorkSheet:Range("N" + cColumn):Value = lsDifTempo_VtaDist.
        /* Detalle */
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = facdpedi.codmat.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = almmmatg.desmat.
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = almmmatg.pesmat.
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = almmmatg.desmar.
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = facdpedi.canped.
        cRange = "T" + cColumn.
        chWorkSheet:Range(cRange):Value = facdpedi.undvta.
        cRange = "U" + cColumn.
        chWorkSheet:Range(cRange):Value = facdpedi.almdes.
        FIND FIRST Almmmate WHERE Almmmate.CodCia = FacDPedi.CodCia
            AND Almmmate.CodAlm = FacDPedi.AlmDes
            AND Almmmate.codmat = FacDPedi.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            FIND FIRST almtubic OF Almmmate NO-LOCK NO-ERROR.
            IF AVAILABLE almtubic THEN
                ASSIGN
                cRange = "V" + cColumn
                chWorkSheet:Range(cRange):Value = almtubic.CodZona.
            cRange = "W" + cColumn.
            chWorkSheet:Range(cRange):Value = Almmmate.CodUbi.
        END.
        cRange = "X" + cColumn.
        chWorkSheet:Range(cRange):Value = (FacDPedi.CanPed * Almmmatg.Pesmat ).
        cRange = "Y" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".

         lCodUser = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".
         lNomUser = fPersonal(lCodUser).
         cRange = "Z" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + lNomUser.

    END.
    GET NEXT {&BROWSE-NAME}.
END.

SESSION:SET-WAIT-STATE('').
    
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

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
DEFINE VARIABLE c-items AS INTEGER NO-UNDO.
DEFINE VARIABLE npage   AS INTEGER NO-UNDO.
DEFINE VARIABLE n-Item  AS INTEGER NO-UNDO.
DEFINE VARIABLE t-Items AS INTEGER NO-UNDO.

DEFINE VAR x-pesotot AS DEC.

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
conta = 1.
t-Items = 0.
x-pesotot = 0.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    t-Items = t-Items + 1.
    x-pesotot = x-pesotot + (Reporte.canped * reporte.X-peso).
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.

DEFINE FRAME f-cab
        n-Item         FORMAT '>9'
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " + STRING(PAGE-NUMBER(REPORT), "Z9") + "/" + STRING(npage, "Z9") FORMAT 'x(20)' AT 75 SKIP
        {&PRN4} + {&PRN6A} + "      Fecha: " AT 1 FORMAT "X(17)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "      N° ORDEN: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "  N° SOLICITUD: " + Reporte.CodRef + ' ' + Reporte.NroRef + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "   N° DE ITEMS: " + STRING(t-Items, '>>>9') + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "          PESO: " + STRING(x-pesotot, '>>>,>>9.99') + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        /*{&PRN4} + {&PRN6A} + "    Destino: " + Faccpedi.codcli + ' ' + Faccpedi.nomcli + {&PRN6B} + {&PRN3} FORMAT "X(50)" SKIP*/       
        {&PRN3} + {&PRN7A} + {&PRN6B} + " F. Entrega: " + STRING(faccpedi.fchent,"99/99/9999") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(40)" SKIP        
        {&PRN4} + {&PRN6A} + "    Destino: " + Faccpedi.codcli + ' ' + trim(Faccpedi.nomcli) + {&PRN6B} + {&PRN3} FORMAT "X(60)" SKIP    
        {&PRN4} + {&PRN6B} + "       Hora: " STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        {&PRN4} + {&PRN6B} + "Observación: " + Faccpedi.glosa  FORMAT "X(80)" SKIP
        "It Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     12 999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

conta = 1.
n-Item = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    DISPLAY STREAM Report 
        n-Item
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        Reporte.CodUbi
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    n-Item = n-Item + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        PAGE STREAM Report.
        conta = 1.
        n-Item = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb-500 B-table-Win 
PROCEDURE Formato-Rb-500 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items        AS INTEGER  NO-UNDO.
DEFINE VARIABLE npage          AS INTEGER  NO-UNDO.

DEFINE VAR x-pesotot AS DEC.

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
conta = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    x-pesotot = x-pesotot + (reporte.canped * reporte.X-peso).
    conta = conta + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.

x-Direccion = gn-clie.dircli.
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
x-Comprobante = ''.
FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.codped = Faccpedi.codref
    AND Ccbcdocu.nroped = Faccpedi.nroref
    AND Ccbcdocu.flgest <> 'A'
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcdocu THEN x-Comprobante = Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc.
    

DEFINE FRAME f-cab
        Reporte.CodUbi FORMAT "x(10)"
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NomCia + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN4} + {&PRN7A} + {&PRN6B} + "        Pagina: " + STRING(PAGE-NUMBER(REPORT), "ZZ9") + "/" + STRING(npage, "ZZ9") + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(40)" AT 80 SKIP
        {&PRN4} + {&PRN6A} + "      Fecha: " + STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(27)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "      N° ORDEN: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "     Origen: " + GN-DIVI.DesDiv + {&PRN6B} + {&PRN3} FORMAT "X(50)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "     N° PEDIDO: " + Reporte.CodRef + ' ' + Reporte.NroRef + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "   Vendedor: " + gn-ven.NomVen + {&PRN6B} + {&PRN3} FORMAT "X(50)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° COMPROBANTE: " + x-Comprobante + {&PRN6B} + {&PRN7B} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "    Cliente: " + Faccpedi.nomcli + {&PRN6B} FORMAT "X(50)" SKIP
        {&PRN4} + {&PRN6A} + "       Hora: " + STRING(TIME,"HH:MM") + {&PRN6B} FORMAT "X(22)" SKIP
        {&PRN4} + {&PRN6A} + "  Dirección: " + x-Direccion + {&PRN6B} FORMAT "X(120)" SKIP
        "Ubicación  Código  Descripción                                                    Marca                  Unidad      Cantidad Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     1234567890 9999999 123456789012345678901234567890123456789012345678901234567890 123456789012345678901234 1234 >>,>>>,>>9.9999 ________________________ */
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

conta = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY SUBSTRING(Reporte.CodUbi,1,2) BY Reporte.CodUbi BY Reporte.CodMat:
    DISPLAY STREAM Report 
        Reporte.CodUbi
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    IF LAST-OF(SUBSTRING(Reporte.CodUbi,1,2)) THEN DO:
        DOWN STREAM Report 1 WITH FRAME f-cab.
    END.
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

DEFINE VAR x-pesotot AS DEC.

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
x-pesotot = 0.
conta = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    x-pesotot = x-pesotot + (Reporte.canped * reporte.X-peso).
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.

DEFINE FRAME f-cab
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " + STRING(PAGE-NUMBER(REPORT), "Z9") + "/" + STRING(npage, "Z9") FORMAT 'x(20)' AT 75 SKIP
        /*
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 80 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
         {&PRN3} + {&PRN7A} + {&PRN6B} + "/" + STRING(npage) {&PRN6B} + {&PRN7B} + {&PRN3} AT 104 FORMAT "X(15)" SKIP /*(1)*/
         */
        /*
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + STRING(npage) AT 104 FORMAT "X(15)" SKIP(1)
        */
        {&PRN4} + {&PRN6A} + "      Fecha: " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "      N° ORDEN: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "  N° SOLICITUD: " + Reporte.CodRef + ' ' + Reporte.NroRef + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "          PESO: " + STRING(x-pesotot,">>>,>>9.99")  + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + " F. Entrega: " + STRING(faccpedi.fchent,"99/99/9999") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "    Destino: " + Faccpedi.codcli + ' ' + trim(Faccpedi.nomcli) + {&PRN6B} + {&PRN3} FORMAT "X(60)" SKIP        
        {&PRN4} + {&PRN6B} + "       Hora: " STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        {&PRN4} + {&PRN6B} + "Observación: " + Faccpedi.glosa  FORMAT "X(80)" SKIP
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

  IF Faccpedi.FlgImpOD = NO THEN DO:
      FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccpedi THEN DO:
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
      CASE TRUE:
          WHEN s-CodDiv = '00500' AND pOrden = "ZONA" THEN RUN Formato-Rb-500.
          WHEN pOrden = "ZONA" THEN RUN Formato-Rb.
          WHEN pOrden = "ALFABETICO" THEN RUN Formato-Rb2.
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

  /* SE ENVIA AL ALMACEN */
  IF FacCPedi.FlgImpOD = NO 
      THEN ASSIGN
      FacCPedi.FlgImpOD = YES
      FacCPedi.UsrImpOD = s-user-id
      FacCPedi.FchImpOD = DATETIME(TODAY, MTIME).
      /*FacCPedi.Libre_c02 = s-user-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS').*/
        
  FIND CURRENT Faccpedi NO-LOCK NO-ERROR.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-edit-attribute-list B-table-Win 
PROCEDURE local-edit-attribute-list :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'edit-attribute-list':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
/*
IF lChequeados = YES THEN DO:    
    &SCOPED-DEFINE CONDICION faccpedi.codcia = s-codcia ~
        AND faccpedi.coddoc = s-coddoc ~
        AND faccpedi.divdes = s-coddiv ~
        AND (faccpedi.fchped >= ltxtDesde AND faccpedi.fchped <= ltxtHasta)  
END.
ELSE DO:
    &SCOPED-DEFINE CONDICION faccpedi.codcia = s-codcia ~
        AND faccpedi.coddoc = s-coddoc ~
        AND faccpedi.divdes = s-coddiv ~
        AND faccpedi.flgest = 'P' ~
        AND faccpedi.flgsit = 'P' ~
        AND (faccpedi.fchped >= ltxtDesde AND faccpedi.fchped <= ltxtHasta)  
END.
*/
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
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "GN-DIVI"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fAlmacen B-table-Win 
FUNCTION fAlmacen RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NUM-ENTRIES(Faccpedi.Libre_c02,'|') > 1 
      THEN RETURN ENTRY(2,Faccpedi.Libre_c02,'|').
  ELSE RETURN "".   /* Function return value. */

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

  IF NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1 
      THEN RETURN ENTRY(2,Faccpedi.Libre_c03,'|').
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
FOR EACH facdpedi OF faccpedi NO-LOCK:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR lPeso AS DEC.

    DEFINE BUFFER b-facdpedi FOR facdpedi.

    lPeso = 0.
    lMsgRetorno = ''.

    FOR EACH b-facdpedi OF faccpedi NO-LOCK,
        FIRST almmmatg OF b-facdpedi NO-LOCK :
        IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN DO:
            lPeso = lPeso + (b-facdpedi.canped * almmmatg.pesmat).
        END.       
        ELSE DO:
            IF lMsgRetorno = '' THEN DO:
                lMsgRetorno = almmmatg.codmat.
            END.
            ELSE DO:
                lMsgRetorno = lMsgRetorno + ", " + almmmatg.codmat.
            END.
        END.
    END.
    RELEASE b-facdpedi.


  RETURN lPeso.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

