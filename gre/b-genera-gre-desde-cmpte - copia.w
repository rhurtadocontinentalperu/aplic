&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tgre_cmpte NO-UNDO LIKE gre_cmpte.



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

DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR lh_handle AS HANDLE.

DEFINE BUFFER b-gre_cmpte FOR gre_cmpte.
DEFINE BUFFER b-gre_header FOR gre_header.
DEFINE BUFFER b-gre_detail FOR gre_detail.
DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-ccbddocu FOR ccbddocu.

define var x-sort-column-current as char.

DEFINE VAR iRowsSelecteds AS INT.

DEFINE SHARED VARIABLE s-numero     AS INTEGER.

DEFINE VAR lGRE_ONLINE AS LOG.

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
&Scoped-define INTERNAL-TABLES gre_cmpte CcbCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table gre_cmpte.coddoc gre_cmpte.nrodoc ~
gre_cmpte.fechahorareg gre_cmpte.estado_sunat CcbCDocu.CodCli ~
CcbCDocu.NomCli gre_cmpte.coddivvta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH gre_cmpte WHERE ~{&KEY-PHRASE} ~
      AND gre_cmpte.estado = 'CMPTE GENERADO' and ~
gre_cmpte.coddivdesp = s-coddiv NO-LOCK, ~
      FIRST CcbCDocu WHERE ccbcdocu.codcia = s-codcia and ~
ccbcdocu.coddoc = gre_cmpte.coddoc and ~
ccbcdocu.nrodoc = gre_cmpte.nrodoc NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH gre_cmpte WHERE ~{&KEY-PHRASE} ~
      AND gre_cmpte.estado = 'CMPTE GENERADO' and ~
gre_cmpte.coddivdesp = s-coddiv NO-LOCK, ~
      FIRST CcbCDocu WHERE ccbcdocu.codcia = s-codcia and ~
ccbcdocu.coddoc = gre_cmpte.coddoc and ~
ccbcdocu.nrodoc = gre_cmpte.nrodoc NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table gre_cmpte CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table gre_cmpte
&Scoped-define SECOND-TABLE-IN-QUERY-br_table CcbCDocu


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-get-utf8 B-table-Win 
FUNCTION f-get-utf8 RETURNS CHARACTER
  ( INPUT pString AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      gre_cmpte, 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      gre_cmpte.coddoc COLUMN-LABEL "Cod!Docto" FORMAT "x(5)":U
            WIDTH 5.43
      gre_cmpte.nrodoc COLUMN-LABEL "Numero!Docto" FORMAT "x(15)":U
            WIDTH 11.43
      gre_cmpte.fechahorareg COLUMN-LABEL "Fecha/Hora!Emision" FORMAT "99/99/9999 HH:MM:SS.SSS":U
            WIDTH 15.14
      gre_cmpte.estado_sunat COLUMN-LABEL "Estado!Sunat" FORMAT "x(50)":U
            WIDTH 20.43
      CcbCDocu.CodCli COLUMN-LABEL "Codigo!Cliente" FORMAT "x(11)":U
            WIDTH 12.72
      CcbCDocu.NomCli COLUMN-LABEL "Nombre!Cliente" FORMAT "x(60)":U
            WIDTH 30.57
      gre_cmpte.coddivvta COLUMN-LABEL "Punto!Venta" FORMAT "x(6)":U
            WIDTH 9.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 111.72 BY 18.62
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.04 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 3 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: tgre_cmpte T "?" NO-UNDO INTEGRAL gre_cmpte
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
         HEIGHT             = 18.85
         WIDTH              = 112.43.
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

ASSIGN 
       br_table:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.gre_cmpte,INTEGRAL.CcbCDocu WHERE INTEGRAL.gre_cmpte ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _Where[1]         = "gre_cmpte.estado = 'CMPTE GENERADO' and
gre_cmpte.coddivdesp = s-coddiv"
     _JoinCode[2]      = "ccbcdocu.codcia = s-codcia and
ccbcdocu.coddoc = gre_cmpte.coddoc and
ccbcdocu.nrodoc = gre_cmpte.nrodoc"
     _FldNameList[1]   > INTEGRAL.gre_cmpte.coddoc
"gre_cmpte.coddoc" "Cod!Docto" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.gre_cmpte.nrodoc
"gre_cmpte.nrodoc" "Numero!Docto" ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.gre_cmpte.fechahorareg
"gre_cmpte.fechahorareg" "Fecha/Hora!Emision" ? "datetime" ? ? ? ? ? ? no ? no no "15.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.gre_cmpte.estado_sunat
"gre_cmpte.estado_sunat" "Estado!Sunat" ? "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbCDocu.CodCli
"CcbCDocu.CodCli" "Codigo!Cliente" ? "character" ? ? ? ? ? ? no ? no no "12.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CcbCDocu.NomCli
"CcbCDocu.NomCli" "Nombre!Cliente" "x(60)" "character" ? ? ? ? ? ? no ? no no "30.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.gre_cmpte.coddivvta
"gre_cmpte.coddivvta" "Punto!Venta" ? "character" ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
    DEFINE VAR x-sql AS CHAR.

    x-sql = "FOR EACH TORDENES WHERE TORDENES.campo-c[30] = '' NO-LOCK ".

    x-SQL = "FOR EACH gre_cmpte WHERE gre_cmpte.estado = 'CMPTE GENERADO' and " +
            "gre_cmpte.coddivdesp = '" + s-coddiv + "' NO-LOCK, " + 
            "FIRST INTEGRAL.CcbCDocu WHERE ccbcdocu.codcia = " + string(s-codcia) + " and " +
            "ccbcdocu.coddoc = gre_cmpte.coddoc AND ccbcdocu.nrodoc = gre_cmpte.nrodoc NO-LOCK ".

    {gn/sort-browse.i &ThisBrowse="br_table" &ThisSQL = x-SQL}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}

    DEFINE VAR cEstado AS CHAR.

    iRowsSelecteds = br_table:NUM-SELECTED-ROWS.
    IF iRowsSelecteds > s-numero THEN DO:
        br_table:DESELECT-FOCUSED-ROW().        
    END.
    ELSE DO:
        /*
        /*cEstado = gre_cmpte.estado_sunat:SCREEN-VALUE IN FRAME {&FRAME-NAME}.*/
        IF gre_cmpte.estado_sunat <> "Aceptado por sunat" THEN DO:
            MESSAGE "Comprobante " gre_cmpte.coddoc " " gre_cmpte.nrodoc SKIP
                "Aun NO esta  ACEPTADO por SUNAT"
                VIEW-AS ALERT-BOX INFORMATION.
            br_table:DESELECT-FOCUSED-ROW().
        END.
        */
    END.
    iRowsSelecteds = br_table:NUM-SELECTED-ROWS.

    RUN mostrar-registros-seleccionados IN lh_handle(iRowsSelecteds).
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actualizar-estado-sunat B-table-Win 
PROCEDURE actualizar-estado-sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR cEstadoBizLinks AS CHAR.  
DEFINE VAR cEstadoSUNAT AS CHAR.
DEFINE VAR cEstadoDocumento AS CHAR.

DEFINE VAR iRow AS INT.
DEFINE VAR iRowsSelected AS INT.

DEFINE VAR cCoddoc AS CHAR.
DEFINE VAR cNrodoc AS CHAR.
DEFINE VAR cCoddiv AS CHAR.

DEFINE VAR rRowId AS ROWID.

DO WITH FRAME {&FRAME-NAME}:
    iRowsSelected = br_table:NUM-SELECTED-ROWS.

    IF iRowsSelected > 0 THEN DO:
        SESSION:SET-WAIT-STA("GENERAL").
        DO iRow = 1 TO iRowsSelected :
            IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(iRow) THEN DO:
                cCoddiv = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddivdesp.
                cCoddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Coddoc.
                cNrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc.

                cEstadoSUNAT = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Estado_sunat.

                IF TRUE <> (cEstadoSUNAT > "") OR  
                    LOOKUP(cEstadoSUNAT,"Aceptado por sunat,Rechazado por sunat") = 0 THEN DO:
                    RUN gn/p-estado-documento-electronico(cCoddoc, cNrodoc, cCoddiv,
                                                          OUTPUT cEstadoBizLinks, OUTPUT cEstadoSunat, OUTPUT cEstadoDocumento).
                    rRowId = ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                    FIND FIRST b-gre_cmpte WHERE ROWID(b-gre_cmpte) = rRowid EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAILABLE b-gre_cmpte THEN DO:
                        ASSIGN b-gre_cmpte.estado_sunat = CAPS(cEstadoDocumento).
                        RELEASE b-gre_cmpte.
                        br_table:REFRESH().
                    END.
                    
                END.
            END.
        END.
        SESSION:SET-WAIT-STA("").
    END.
END.




  /*
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pEstadoBizLinks AS CHAR INIT "|" NO-UNDO.  
DEFINE OUTPUT PARAMETER pEstadoSUNAT AS CHAR INIT "|" NO-UNDO.
DEFINE OUTPUT PARAMETER pEstadoDocumento AS CHAR INIT "" NO-UNDO.
*/



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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extraeDataFromDB B-table-Win 
PROCEDURE extraeDataFromDB :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-pgre B-table-Win 
PROCEDURE generar-pgre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR iRow AS INT.
DEFINE VAR iRowsSelected AS INT.
DEFINE VAR iRowsOk AS INT.

DEFINE VAR cCoddoc AS CHAR.
DEFINE VAR cNrodoc AS CHAR.
DEFINE VAR cCoddiv AS CHAR.
DEFINE VAR cEstadoSUNAT AS CHAR.

DEFINE VAR rRowId AS ROWID.

RUN gn/gre-online.r(OUTPUT lGRE_ONLINE).

IF lGRE_ONLINE = NO THEN DO:
    MESSAGE 'Proceso de GRE no esta ACTIVO' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

DO WITH FRAME {&FRAME-NAME}:
    iRowsSelected = br_table:NUM-SELECTED-ROWS.

    IF iRowsSelected > 0 THEN DO:
        /*
        VERIFICA:
        DO iRow = 1 TO iRowsSelected :
            IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(iRow) THEN DO:
                cCoddiv = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddivdesp.
                cCoddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Coddoc.
                cNrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc.

                cEstadoSUNAT = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Estado_sunat.

                IF cEstadoSUNAT <> "Aceptado por sunat" THEN DO:                
                    MESSAGE "Ha seleccionado comprobantes que NO ESTAN ACEPTADOS por SUNAT"
                        VIEW-AS ALERT-BOX INFORMATION.
                    iRowsSelected = -99.
                    LEAVE VERIFICA.
                END.
            END.
        END.
        IF iRowsSelected = -99 THEN RETURN "ADM-ERROR".
        */
        /**/
        MESSAGE 'Seguro de procesar los ' + STRING(iRowsSelected) + ' comprobantes' VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta AS LOG.
            IF rpta = YES THEN DO:
            SESSION:SET-WAIT-STA("GENERAL").        
            DO iRow = 1 TO iRowsSelected :
                IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(iRow) THEN DO:
                    cCoddiv = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddivdesp.
                    cCoddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Coddoc.
                    cNrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc.
    
                    cEstadoSUNAT = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Estado_sunat.
                    /*
                    IF cEstadoSUNAT = "Aceptado por sunat" THEN DO:                
                        RUN grabar-pre-gre(cCoddiv, cCoddoc, cNroDoc).
                        IF RETURN-VALUE = "OK" THEN DO:
                            iRowsOk = iRowsOk + 1.
                        END.
                    END.
                    */
                    RUN grabar-pre-gre(cCoddiv, cCoddoc, cNroDoc).
                    IF RETURN-VALUE = "OK" THEN DO:
                        iRowsOk = iRowsOk + 1.
                    END.
                END.
            END.
            IF iRowsSelected <> -99 THEN DO:
                {&open-query-br_table}
            END.        
            SESSION:SET-WAIT-STA("").
    
            MESSAGE "Se generaron " + STRING(iRowsOk) + " pre-guia(s) de remision, de " + STRING(iRowsSelected) + " seleccionado(s)"
                VIEW-AS ALERT-BOX INFORMATION.

        END.

    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-pre-gre B-table-Win 
PROCEDURE grabar-pre-gre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcCoddiv AS CHAR.    /* Division de despacho */
DEFINE INPUT PARAMETER pcCoddoc AS CHAR.
DEFINE INPUT PARAMETER pcNroDoc AS CHAR.

DEFINE VAR pcOtros AS CHAR.
DEFINE VAR pcRetVal AS CHAR.
DEFINE VAR rRowId AS ROWID.

RUN gre/p-graba-pre_gre-desde-cmpte.r(pcCoddiv, pcCoddoc, pcNroDoc, INPUT-OUTPUT pcOtros, OUTPUT pcRetVal).

IF pcRetVal = "OK" THEN DO:
    /* Cambio el estado de la tabla de control */
    DO WITH FRAME {&FRAME-NAME}:
        rRowId = ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
        FIND FIRST b-gre_cmpte WHERE ROWID(b-gre_cmpte) = rRowid EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE b-gre_cmpte THEN DO:
            ASSIGN b-gre_cmpte.estado = "PGRE GENERADA".
            RELEASE b-gre_cmpte.
        END.
    END.
END.
ELSE DO:
    pcRetVal = "ERROR".
    RETURN "ADM-ERROR".
END.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

/*RUN extraeDataFromDB.*/

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
  iRowsSelecteds = br_table:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}.

  RUN mostrar-registros-seleccionados IN lh_handle(iRowsSelecteds).


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NO-generan-pgre B-table-Win 
PROCEDURE NO-generan-pgre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR iRow AS INT.
DEFINE VAR iRowsSelected AS INT.
DEFINE VAR iRowsOk AS INT.

DEFINE VAR cCoddoc AS CHAR.
DEFINE VAR cNrodoc AS CHAR.
DEFINE VAR cCoddiv AS CHAR.
DEFINE VAR cEstadoSUNAT AS CHAR.

DEFINE VAR rRowId AS ROWID.

RUN gn/gre-online.r(OUTPUT lGRE_ONLINE).

IF lGRE_ONLINE = NO THEN DO:
    MESSAGE 'Proceso de GRE no esta ACTIVO' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

DO WITH FRAME {&FRAME-NAME}:
    iRowsSelected = br_table:NUM-SELECTED-ROWS.

    IF iRowsSelected > 0 THEN DO:        
        /*
        VERIFICA:
        DO iRow = 1 TO iRowsSelected :
            IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(iRow) THEN DO:
                cCoddiv = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddivdesp.
                cCoddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Coddoc.
                cNrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc.

                cEstadoSUNAT = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Estado_sunat.

                IF cEstadoSUNAT <> "Aceptado por sunat" THEN DO:                
                    MESSAGE "Ha seleccionado comprobantes que NO ESTAN ACEPTADOS por SUNAT"
                        VIEW-AS ALERT-BOX INFORMATION.
                    iRowsSelected = -99.
                    LEAVE VERIFICA.
                END.
            END.
        END.
        IF iRowsSelected = -99 THEN RETURN "ADM-ERROR".
        */
        /**/
        MESSAGE 'Seguro de NO Generar PGRE a los ' + STRING(iRowsSelected) + ' comprobantes seleccionados?' VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta AS LOG.

        IF rpta = YES THEN DO:
        SESSION:SET-WAIT-STA("GENERAL").        
        DO iRow = 1 TO iRowsSelected :
            IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(iRow) THEN DO:
                cCoddiv = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddivdesp.
                cCoddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Coddoc.
                cNrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc.

                rRowId = ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).

                FIND FIRST b-gre_cmpte WHERE ROWID(b-gre_cmpte) = rRowid EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE b-gre_cmpte THEN DO:
                    ASSIGN b-gre_cmpte.estado = "EXCLUIDO MANUAL"
                            b-gre_cmpte.USER_exclusion = USERID("dictdb")
                            b-gre_cmpte.fechahora_exclusion = NOW
                        .
                    iRowsOk = iRowsOk + 1.
                END.
                RELEASE b-gre_header.
            END.
        END.
        IF iRowsSelected <> -99 THEN DO:
            {&open-query-br_table}
        END.        
        SESSION:SET-WAIT-STA("").

        MESSAGE "Se EXCLUYEON " + STRING(iRowsOk) + " comprobante(s), de " + STRING(iRowsSelected) + " seleccionado(s)"
            VIEW-AS ALERT-BOX INFORMATION.

        END.
    END.
END.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-pre-gre B-table-Win 
PROCEDURE procesar-pre-gre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR cEstadoBizLinks AS CHAR.  
DEFINE VAR cEstadoSUNAT AS CHAR.
DEFINE VAR cEstadoDocumento AS CHAR.

DEFINE VAR iRow AS INT.
DEFINE VAR iRows AS INT.
DEFINE VAR iRowsSelected AS INT.

DEFINE VAR cCoddoc AS CHAR.
DEFINE VAR cNrodoc AS CHAR.
DEFINE VAR cCoddiv AS CHAR.

DEFINE VAR rRowId AS ROWID.

DO WITH FRAME {&FRAME-NAME}:
    iRowsSelected = br_table:NUM-SELECTED-ROWS.

    IF iRowsSelected > 0 THEN DO:
        SESSION:SET-WAIT-STA("GENERAL").
        DO iRow = 1 TO iRowsSelected :
            IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(iRow) THEN DO:
                cEstadoSUNAT = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Estado_sunat.
                IF cEstadoSUNAT = 'Aceptado por sunat' THEN DO:
                    iRows = iRows + 1.
                END.
            END.
        END.
        IF iRows <= 0 THEN DO:
            MESSAGE "De los documentos seleccionados" SKIP
                    "ninguno de ellos esta aceptado por sunat" SKIP
                    "verifique correctamente la seleccion de registros"
                    VIEW-AS ALERT-BOX INFORMATION.
            RETURN "ADM-ERROR".
        END.
            MESSAGE 'Se proceder a generar ' + STRING(iRows) + ' pre-guias de remision (PGRE)' SKIP
                '¿Seguro de procesar?' VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta AS LOG.
            IF rpta = NO THEN RETURN NO-APPLY.

        /**/
        DO iRow = 1 TO iRowsSelected :
            IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(iRow) THEN DO:
                cCoddiv = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddivdesp.
                cCoddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Coddoc.
                cNrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc.

                cEstadoSUNAT = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Estado_sunat.
                IF cEstadoSUNAT = 'Aceptado por sunat' THEN DO:
                    RUN grabar-pre-gre(cCoddiv, cCoddoc, cNroDoc).
                END.
                /*
                IF TRUE <> (cEstadoSUNAT > "") OR  
                    LOOKUP(cEstadoSUNAT,"Aceptado por sunat, Rechazado por sunat") = 0 THEN DO:
                    RUN gn/p-estado-documento-electronico(cCoddoc, cNrodoc, cCoddiv,
                                                          OUTPUT cEstadoBizLinks, OUTPUT cEstadoSunat, OUTPUT cEstadoDocumento).
                    rRowId = ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                    FIND FIRST b-gre_cmpte WHERE ROWID(b-gre_cmpte) = rRowid EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAILABLE b-gre_cmpte THEN DO:
                        ASSIGN b-gre_cmpte.estado_sunat = cEstadoDocumento.
                        RELEASE b-gre_cmpte.
                        br_table:REFRESH().
                    END.
                    
                END.
                */
            END.
        END.
        SESSION:SET-WAIT-STA("").
    END.
END.


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
  {src/adm/template/snd-list.i "gre_cmpte"}
  {src/adm/template/snd-list.i "CcbCDocu"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-get-utf8 B-table-Win 
FUNCTION f-get-utf8 RETURNS CHARACTER
  ( INPUT pString AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VAR lRetVal AS CHAR.
DEF VAR x-dice AS CHAR NO-UNDO.
DEF VAR x-debedecir AS CHAR NO-UNDO.

/* UTF-8 */
x-dice = TRIM(pString).
RUN lib\limpiar-texto(x-dice,'',OUTPUT x-debedecir).
lRetVal = CODEPAGE-CONVERT(x-debedecir, "utf-8", SESSION:CHARSET).
lRetVal = REPLACE(x-debedecir,"´","'").
lRetVal = REPLACE(x-debedecir,"á","a").
lRetVal = REPLACE(x-debedecir,"é","e").
lRetVal = REPLACE(x-debedecir,"í","i").
lRetVal = REPLACE(x-debedecir,"ó","o").
lRetVal = REPLACE(x-debedecir,"ú","u").
lRetVal = REPLACE(x-debedecir,"Á","A").
lRetVal = REPLACE(x-debedecir,"É","E").
lRetVal = REPLACE(x-debedecir,"Í","I").
lRetVal = REPLACE(x-debedecir,"Ó","O").
lRetVal = REPLACE(x-debedecir,"Ú","U").
lRetVal = REPLACE(x-debedecir,"ü","u").
lRetVal = REPLACE(x-debedecir,"Ü","U").
lRetVal = REPLACE(x-debedecir,"ü","u").
lRetVal = REPLACE(x-debedecir,"º"," ").
lRetVal = REPLACE(x-debedecir,"´","'").
lRetVal = REPLACE(x-debedecir,"Ø"," ").
lRetVal = REPLACE(x-debedecir,"º"," ").
lRetVal = REPLACE(x-debedecir,"ª"," ").
lRetVal = REPLACE(x-debedecir,"º"," ").
lRetVal = REPLACE(x-debedecir,"º"," ").

RETURN lRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

