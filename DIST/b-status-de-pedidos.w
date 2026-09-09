&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-CPEDI NO-UNDO LIKE FacCPedi.
DEFINE SHARED TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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

DEF SHARED VAR lh_handle AS HANDLE.

DEF TEMP-TABLE Cabecera
    FIELD Libre_c01     AS CHAR     FORMAT 'x(20)'      COLUMN-LABEL 'Status'
    FIELD CodDoc        AS CHAR     FORMAT 'x(3)'       COLUMN-LABEL 'Tipo Orden'
    FIELD NroPed        AS CHAR     FORMAT 'x(12)'      COLUMN-LABEL 'Nro. Orden'
    FIELD FchPed        AS DATE     FORMAT '99/99/9999' COLUMN-LABEL 'Fecha Emision'
    FIELD Hora          AS CHAR     FORMAT 'x(5)'       COLUMN-LABEL 'Hora Emision'
    FIELD FchEnt        AS DATE     FORMAT '99/99/9999' COLUMN-LABEL 'Fecha Entrega'
    FIELD DesDiv        AS CHAR     FORMAT 'x(40)'      COLUMN-LABEL 'Division'
    FIELD NomCli        AS CHAR     FORMAT 'x(50)'      COLUMN-LABEL 'Nombre'
    FIELD Libre_d02     AS DEC      FORMAT '>>>,>>9.99' COLUMN-LABEL 'Peso en kg'
    FIELD Libre_d01     AS DEC      FORMAT '>>>,>>9'    COLUMN-LABEL 'Items'
    FIELD UsrImpOD      AS CHAR     FORMAT 'x(8)'       COLUMN-LABEL 'Impreso por'
    FIELD FchImpOD      AS CHAR     FORMAT 'x(19)'      COLUMN-LABEL 'Fecha/Hora Impresion'
    FIELD ImpTot        AS DEC      FORMAT '>>,>>>,>>9.99' COLUMN-LABEL 'Importe Total'
    .

DEF TEMP-TABLE Detalle LIKE Cabecera
    FIELD Campo-C1        AS CHAR     FORMAT 'x(3)'        COLUMN-LABEL 'Sec'
    FIELD Campo-C2        AS CHAR     FORMAT 'x(10)'         COLUMN-LABEL 'Pickeador'
    FIELD Campo-C10        AS CHAR     FORMAT 'x(30)'         COLUMN-LABEL 'Nombre Pickeador'
    FIELD Campo-C14        AS CHAR     FORMAT 'x(25)'         COLUMN-LABEL 'Impresion'
    FIELD Campo-C3        AS CHAR     FORMAT 'x(25)'         COLUMN-LABEL 'Fec/Hora Sacado'
    FIELD Campo-C4        AS CHAR     FORMAT 'x(25)'         COLUMN-LABEL 'Fec/Hora Recep.'
    FIELD Campo-C13        AS CHAR     FORMAT 'x(25)'         COLUMN-LABEL 'Tiempo'
    FIELD Campo-C5        AS CHAR     FORMAT 'x(4)'         COLUMN-LABEL 'Zona Pickeo'
    FIELD Campo-C6        AS CHAR     FORMAT 'x(10)'         COLUMN-LABEL 'User Asigna'
    FIELD Campo-C7        AS CHAR     FORMAT 'x(10)'         COLUMN-LABEL 'User Recep.'
    FIELD Campo-I1        AS INT      FORMAT '>,>>9'      COLUMN-LABEL 'Items'
    FIELD Campo-F2        AS DEC      FORMAT '->>>,>>>,>>9.9999' COLUMN-LABEL 'Peso'
    FIELD Campo-F3        AS DEC      FORMAT '->>>,>>>,>>9.9999' COLUMN-LABEL 'Volumen'
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
&Scoped-define INTERNAL-TABLES T-CPEDI FacCPedi GN-DIVI

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-CPEDI.Libre_c01 FacCPedi.CodDoc ~
FacCPedi.NroPed FacCPedi.FchPed T-CPEDI.Hora FacCPedi.FchEnt GN-DIVI.DesDiv ~
FacCPedi.NomCli FacCPedi.Libre_d02 T-CPEDI.Libre_d01 FacCPedi.UsrImpOD ~
FacCPedi.FchImpOD FacCPedi.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH T-CPEDI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi OF T-CPEDI NO-LOCK, ~
      FIRST GN-DIVI OF T-CPEDI NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-CPEDI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi OF T-CPEDI NO-LOCK, ~
      FIRST GN-DIVI OF T-CPEDI NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-CPEDI FacCPedi GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-CPEDI
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define THIRD-TABLE-IN-QUERY-br_table GN-DIVI


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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-CPEDI, 
      FacCPedi
    FIELDS(FacCPedi.CodDoc
      FacCPedi.NroPed
      FacCPedi.FchPed
      FacCPedi.FchEnt
      FacCPedi.NomCli
      FacCPedi.Libre_d02
      FacCPedi.UsrImpOD
      FacCPedi.FchImpOD
      FacCPedi.ImpTot), 
      GN-DIVI
    FIELDS(GN-DIVI.DesDiv) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-CPEDI.Libre_c01 COLUMN-LABEL "Status" FORMAT "x(20)":U
            WIDTH 16.43
      FacCPedi.CodDoc COLUMN-LABEL "Tipo!Orden" FORMAT "x(3)":U
      FacCPedi.NroPed COLUMN-LABEL "Nro. Orden" FORMAT "X(12)":U
      FacCPedi.FchPed COLUMN-LABEL "Fecha!Emisión" FORMAT "99/99/9999":U
      T-CPEDI.Hora COLUMN-LABEL "Hora!Emisión" FORMAT "X(5)":U
      FacCPedi.FchEnt COLUMN-LABEL "Fecha!Entrega" FORMAT "99/99/9999":U
      GN-DIVI.DesDiv COLUMN-LABEL "División" FORMAT "X(40)":U WIDTH 14.14
      FacCPedi.NomCli FORMAT "x(100)":U WIDTH 21.43
      FacCPedi.Libre_d02 COLUMN-LABEL "Peso!en kg" FORMAT ">>>,>>9.99":U
            WIDTH 7
      T-CPEDI.Libre_d01 COLUMN-LABEL "Items" FORMAT ">>>,>>9":U
            WIDTH 4.43
      FacCPedi.UsrImpOD COLUMN-LABEL "Impreso por" FORMAT "x(8)":U
      FacCPedi.FchImpOD COLUMN-LABEL "Fecha/Hora Impresión" FORMAT "99/99/9999 HH:MM:SS":U
      FacCPedi.ImpTot FORMAT ">>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 140 BY 10.5
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
      TABLE: T-CPEDI T "SHARED" NO-UNDO INTEGRAL FacCPedi
      TABLE: tt-w-report T "SHARED" NO-UNDO INTEGRAL w-report
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
         HEIGHT             = 12.19
         WIDTH              = 141.86.
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
     _TblList          = "Temp-Tables.T-CPEDI,INTEGRAL.FacCPedi OF Temp-Tables.T-CPEDI,INTEGRAL.GN-DIVI OF Temp-Tables.T-CPEDI"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST USED, FIRST USED"
     _FldNameList[1]   > Temp-Tables.T-CPEDI.Libre_c01
"T-CPEDI.Libre_c01" "Status" "x(20)" "character" ? ? ? ? ? ? no ? no no "16.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.CodDoc
"FacCPedi.CodDoc" "Tipo!Orden" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Nro. Orden" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Fecha!Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-CPEDI.Hora
"T-CPEDI.Hora" "Hora!Emisión" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.FchEnt
"FacCPedi.FchEnt" "Fecha!Entrega" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" "División" ? "character" ? ? ? ? ? ? no ? no no "14.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "21.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacCPedi.Libre_d02
"FacCPedi.Libre_d02" "Peso!en kg" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-CPEDI.Libre_d01
"T-CPEDI.Libre_d01" "Items" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.FacCPedi.UsrImpOD
"FacCPedi.UsrImpOD" "Impreso por" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.FacCPedi.FchImpOD
"FacCPedi.FchImpOD" "Fecha/Hora Impresión" "99/99/9999 HH:MM:SS" "datetime" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.FacCPedi.ImpTot
"FacCPedi.ImpTot" ? ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
    IF NOT AVAILABLE T-CPEDI THEN RETURN NO-APPLY.
       
    /* SubOrdenes */
    RUN ue-muestra-subordenes IN lh_Handle(INPUT T-CPEDI.coddoc , INPUT T-CPEDI.nroped ).

    /* --------------------------------------- */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pFchEnt-1 AS DATE.
DEF INPUT PARAMETER pFchEnt-2 AS DATE.
DEF INPUT PARAMETER pStatus AS CHAR.

DEF VAR x-CodDoc AS CHAR.
DEF VAR k AS INT NO-UNDO.

/* Cargamos la informacion base */
SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE T-CPEDI.
DO k = 1 TO NUM-ENTRIES(pCodDoc,'|'):
    x-CodDoc = ENTRY(k,pCodDoc,'|').
    FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia AND
        Faccpedi.divdes = s-coddiv AND
        faccpedi.coddoc = x-coddoc AND
        Faccpedi.FlgEst <> "A"  AND
        Faccpedi.fchent >= pFchEnt-1 AND
        Faccpedi.fchent <= pFchEnt-2:
        CREATE T-CPEDI.
        BUFFER-COPY Faccpedi TO T-CPEDI.
        /* Items */
        T-CPEDI.Libre_c01 = 'NO TRACKING'.
        T-CPEDI.Libre_d01 = 0.
        FOR EACH Facdpedi OF Faccpedi NO-LOCK:
            T-CPEDI.Libre_d01 = T-CPEDI.Libre_d01 + 1.
        END.
    END.
END.
DEF VAR x-Status AS CHAR NO-UNDO.
FOR EACH T-CPEDI:
    /* Hora de emisión */
    FIND LAST LogTrkDocs WHERE LogTrkDocs.CodCia = s-CodCia AND
        LogTrkDocs.CodDoc = T-CPEDI.CodDoc AND 
        LogTrkDocs.NroDoc = T-CPEDI.NroPed AND
        LogTrkDocs.Clave  = 'TRCKPED' AND
        LogTrkDocs.Codigo = 'SE_ALM'
        NO-LOCK NO-ERROR.
    IF AVAILABLE LogTrkDocs THEN T-CPEDI.Hora = STRING( INTEGER( TRUNCATE( MTIME( LogTrkDocs.Fecha ) / 1000, 0 ) ), "HH:MM:SS" ).
    /* Cargamos su status */
    RUN gn/p-status-pedido (T-CPEDI.coddoc, T-CPEDI.nroped, OUTPUT x-Status).
    T-CPEDI.FlgEst = x-Status.
    FIND TabTrkDocs WHERE TabTrkDocs.CodCia = s-codcia AND
        TabTrkDocs.Clave = 'TRCKPED' AND
        TabTrkDocs.Codigo = x-Status
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabTrkDocs  THEN T-CPEDI.Libre_c01 = TabTrkDocs.NomCorto.
END.
FOR EACH T-CPEDI:
    IF LOOKUP(T-CPEDI.FlgEst, pStatus) = 0 THEN DO:
        DELETE T-CPEDI.
    END.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Envia-Excel B-table-Win 
PROCEDURE Envia-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


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
EMPTY TEMP-TABLE Cabecera.
GET FIRST {&BROWSE-NAME}.
REPEAT WHILE AVAILABLE T-CPEDI:
    CREATE Cabecera.
    BUFFER-COPY T-CPEDI TO Cabecera
        ASSIGN
            Cabecera.DesDiv = gn-divi.DesDiv
            Cabecera.Libre_d02 = Faccpedi.Libre_d02
            Cabecera.FchImpOD = SUBSTRING(STRING(Faccpedi.FchImpOD),1,19).
    GET NEXT {&BROWSE-NAME}.
END.
IF CAN-FIND(FIRST Cabecera NO-LOCK) THEN DO:
    /* Programas que generan el Excel */
    RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Cabecera:HANDLE,
                                      INPUT c-xls-file,
                                      OUTPUT c-csv-file) .

    RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Cabecera:HANDLE,
                                      INPUT  c-csv-file,
                                      OUTPUT c-xls-file) .
END.
/* Borramos librerias de la memoria */
DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').
MESSAGE 'Proceso Terminado'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Envia-Excel-Detalle B-table-Win 
PROCEDURE Envia-Excel-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
EMPTY TEMP-TABLE Cabecera.
EMPTY TEMP-TABLE Detalle.
GET FIRST {&BROWSE-NAME}.
REPEAT WHILE AVAILABLE T-CPEDI:
    CREATE Cabecera.
    BUFFER-COPY T-CPEDI TO Cabecera
        ASSIGN
            Cabecera.DesDiv = gn-divi.DesDiv
            Cabecera.Libre_d02 = Faccpedi.Libre_d02
            Cabecera.FchImpOD = SUBSTRING(STRING(Faccpedi.FchImpOD),1,19).
    RUN ue-muestra-subordenes IN lh_Handle(INPUT T-CPEDI.coddoc , INPUT T-CPEDI.nroped ).
    FOR EACH tt-w-report:
        CREATE Detalle.
        BUFFER-COPY Cabecera TO Detalle
            ASSIGN
            Detalle.Campo-C1   = tt-w-report.campo-c[1]
            Detalle.Campo-C2   = tt-w-report.campo-c[2]
            Detalle.Campo-C10  = tt-w-report.campo-c[10]
            Detalle.Campo-C14  = tt-w-report.campo-c[14]
            Detalle.Campo-C3   = tt-w-report.campo-c[3]
            Detalle.Campo-C4   = tt-w-report.campo-c[4]
            Detalle.Campo-C13  = tt-w-report.campo-c[13]
            Detalle.Campo-C5   = tt-w-report.campo-c[5]
            Detalle.Campo-C6   = tt-w-report.campo-c[6]
            Detalle.Campo-C7   = tt-w-report.campo-c[7]
            Detalle.Campo-I1   = tt-w-report.campo-i[1]
            Detalle.Campo-F2   = tt-w-report.campo-f[2]
            Detalle.Campo-F3   = tt-w-report.campo-f[3]
            .
    END.
    GET NEXT {&BROWSE-NAME}.
END.
IF CAN-FIND(FIRST Cabecera NO-LOCK) THEN DO:
    /* Programas que generan el Excel */
    RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                      INPUT c-xls-file,
                                      OUTPUT c-csv-file) .

    RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:HANDLE,
                                      INPUT  c-csv-file,
                                      OUTPUT c-xls-file) .
END.
/* Borramos librerias de la memoria */
DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').
MESSAGE 'Proceso Terminado'.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* SubOrdenes */
  IF AVAILABLE T-CPEDI THEN RUN ue-muestra-subordenes IN lh_Handle(INPUT T-CPEDI.coddoc , 
                                                                   INPUT T-CPEDI.nroped ).

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
  {src/adm/template/snd-list.i "T-CPEDI"}
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

