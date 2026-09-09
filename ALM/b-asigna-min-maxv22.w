&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-GENER NO-UNDO LIKE TabGener.
DEFINE SHARED TEMP-TABLE t-report NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE T-ZONA NO-UNDO LIKE Almmmate
       INDEX Llave01 AS PRIMARY codalm codubi codmat.



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
DEF SHARED VAR s-user-id AS CHAR.

DEFINE SHARED VAR s-acceso-total  AS LOG.

DEF VAR x-StockTransito AS DEC NO-UNDO.
DEF VAR x-StockCompras  AS DEC NO-UNDO.
DEF VAR x-StockDisponible AS DEC NO-UNDO.
DEF VAR x-Saldo         AS DEC NO-UNDO.

DEFINE TEMP-TABLE tmp-tabla
    FIELD t-CodAlm LIKE Almacen.codalm  FORMAT 'x(3)'
    FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
    FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
    FIELD t-CodDiv LIKE FacCPedi.CodDiv FORMAT 'x(5)'
    FIELD t-FchPed LIKE FacDPedi.FchPed
    FIELD t-NomCli LIKE FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
    FIELD t-CodMat LIKE FacDPedi.codmat
    FIELD t-Canped LIKE FacDPedi.CanPed.

DEFINE SHARED VAR lh_handle AS HANDLE.

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES Almmmatg
&Scoped-define FIRST-EXTERNAL-TABLE Almmmatg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almmmatg.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almmmate T-GENER

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ~
(IF T-GENER.Libre_l01 = YES THEN '*' ELSE '') @ T-GENER.Libre_c05 ~
T-GENER.Codigo Almmmate.CodAlm T-GENER.Libre_c02 Almmmate.VInMn1 ~
Almmmate.VInMn2 Almmmate.StkMin Almmmate.VCtMn1 Almmmate.VCtMn2 ~
Almmmate.StkMax T-GENER.Libre_d01 T-GENER.Libre_d02 T-GENER.Libre_d03 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table Almmmate.VCtMn1 ~
Almmmate.VCtMn2 Almmmate.StkMax 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table Almmmate
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table Almmmate
&Scoped-define QUERY-STRING-br_table FOR EACH Almmmate OF Almmmatg WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST T-GENER WHERE T-GENER.CodCia = Almmmate.CodCia ~
  AND T-GENER.Libre_c01 = Almmmate.CodAlm ~
  AND T-GENER.Libre_c03 = Almmmate.codmat ~
      AND T-GENER.Clave = "ZG" NO-LOCK ~
    BY T-GENER.Codigo ~
       BY T-GENER.Libre_c01
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almmmate OF Almmmatg WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST T-GENER WHERE T-GENER.CodCia = Almmmate.CodCia ~
  AND T-GENER.Libre_c01 = Almmmate.CodAlm ~
  AND T-GENER.Libre_c03 = Almmmate.codmat ~
      AND T-GENER.Clave = "ZG" NO-LOCK ~
    BY T-GENER.Codigo ~
       BY T-GENER.Libre_c01.
&Scoped-define TABLES-IN-QUERY-br_table Almmmate T-GENER
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almmmate
&Scoped-define SECOND-TABLE-IN-QUERY-br_table T-GENER


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSaldo B-table-Win 
FUNCTION fSaldo RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStockCompras B-table-Win 
FUNCTION fStockCompras RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStockDisponible B-table-Win 
FUNCTION fStockDisponible RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStockTransito B-table-Win 
FUNCTION fStockTransito RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Almmmate, 
      T-GENER SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      (IF T-GENER.Libre_l01 = YES THEN '*' ELSE '') @ T-GENER.Libre_c05 COLUMN-LABEL "T" FORMAT "X":U
      T-GENER.Codigo COLUMN-LABEL "Zona!Geografica" FORMAT "x(8)":U
      Almmmate.CodAlm FORMAT "x(3)":U WIDTH 6
      T-GENER.Libre_c02 COLUMN-LABEL "Descripción" FORMAT "x(40)":U
            WIDTH 41.43
      Almmmate.VInMn1 COLUMN-LABEL "Máximo" FORMAT "ZZZ,ZZ9.99":U
            WIDTH 6.43
      Almmmate.VInMn2 COLUMN-LABEL "Seguridad" FORMAT "ZZZ,ZZ9.99":U
            WIDTH 7.43
      Almmmate.StkMin COLUMN-LABEL "Máximo +!Seguridad" FORMAT "ZZZ,ZZ9.99":U
            WIDTH 7.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      Almmmate.VCtMn1 COLUMN-LABEL "Campaña." FORMAT "ZZZ,ZZ9.99":U
            WIDTH 9.43
      Almmmate.VCtMn2 COLUMN-LABEL "No Campaña" FORMAT "ZZZ,ZZ9.99":U
            WIDTH 9.43
      Almmmate.StkMax COLUMN-LABEL "Empaque" FORMAT "Z,ZZZ,ZZZ,ZZ9.99":U
            WIDTH 7.43
      T-GENER.Libre_d01 COLUMN-LABEL "Stock!Disponible" FORMAT "-ZZZ,ZZZ,ZZ9.99":U
            WIDTH 7.43
      T-GENER.Libre_d02 COLUMN-LABEL "Stock en!Tránsito" FORMAT "ZZZ,ZZ9.99":U
      T-GENER.Libre_d03 COLUMN-LABEL "Faltante!Sobrante" FORMAT "-ZZZ,ZZ9.99":U
            WIDTH 7.57
  ENABLE
      Almmmate.VCtMn1
      Almmmate.VCtMn2
      Almmmate.StkMax
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 141 BY 11.73
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
   External Tables: INTEGRAL.Almmmatg
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-GENER T "SHARED" NO-UNDO INTEGRAL TabGener
      TABLE: t-report T "SHARED" NO-UNDO INTEGRAL w-report
      TABLE: T-ZONA T "?" NO-UNDO INTEGRAL Almmmate
      ADDITIONAL-FIELDS:
          INDEX Llave01 AS PRIMARY codalm codubi codmat
      END-FIELDS.
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
         HEIGHT             = 14.81
         WIDTH              = 146.86.
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
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 3.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.Almmmate OF INTEGRAL.Almmmatg,Temp-Tables.T-GENER WHERE INTEGRAL.Almmmate ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _OrdList          = "Temp-Tables.T-GENER.Codigo|yes,Temp-Tables.T-GENER.Libre_c01|yes"
     _JoinCode[2]      = "Temp-Tables.T-GENER.CodCia = INTEGRAL.Almmmate.CodCia
  AND Temp-Tables.T-GENER.Libre_c01 = INTEGRAL.Almmmate.CodAlm
  AND Temp-Tables.T-GENER.Libre_c03 = INTEGRAL.Almmmate.codmat"
     _Where[2]         = "Temp-Tables.T-GENER.Clave = ""ZG"""
     _FldNameList[1]   > "_<CALC>"
"(IF T-GENER.Libre_l01 = YES THEN '*' ELSE '') @ T-GENER.Libre_c05" "T" "X" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-GENER.Codigo
"T-GENER.Codigo" "Zona!Geografica" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmate.CodAlm
"Almmmate.CodAlm" ? ? "character" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-GENER.Libre_c02
"T-GENER.Libre_c02" "Descripción" "x(40)" "character" ? ? ? ? ? ? no ? no no "41.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmate.VInMn1
"Almmmate.VInMn1" "Máximo" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.Almmmate.VInMn2
"Almmmate.VInMn2" "Seguridad" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.Almmmate.StkMin
"Almmmate.StkMin" "Máximo +!Seguridad" "ZZZ,ZZ9.99" "decimal" 14 0 ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.Almmmate.VCtMn1
"Almmmate.VCtMn1" "Campaña." "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? yes ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.Almmmate.VCtMn2
"Almmmate.VCtMn2" "No Campaña" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? yes ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.Almmmate.StkMax
"Almmmate.StkMax" "Empaque" ? "decimal" ? ? ? ? ? ? yes ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-GENER.Libre_d01
"T-GENER.Libre_d01" "Stock!Disponible" "-ZZZ,ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-GENER.Libre_d02
"T-GENER.Libre_d02" "Stock en!Tránsito" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.T-GENER.Libre_d03
"T-GENER.Libre_d03" "Faltante!Sobrante" "-ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no "7.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

ON 'RETURN':U OF   Almmmate.StkMax, Almmmate.VCtMn1, Almmmate.VCtMn2
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "Almmmatg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almmmatg"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Resumen B-table-Win 
PROCEDURE Carga-Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER B-MATE     FOR Almmmate.
DEF BUFFER B-Almacen  FOR Almacen.
DEF BUFFER B-TabGener FOR TabGener.
DEF BUFFER B-AlmTabla FOR AlmTabla.

DEF VAR x-Ok                AS LOG NO-UNDO INIT NO.
DEF VAR x-StockComprometido AS DEC NO-UNDO.
DEF VAR x-StockDisponible   AS DEC NO-UNDO.
DEF VAR x-StockTransito     AS DEC NO-UNDO.
DEF VAR x-StockCompras      AS DEC NO-UNDO.

EMPTY TEMP-TABLE t-report.
GET FIRST {&BROWSE-NAME}.
REPEAT WHILE AVAILABLE Almmmate:
    FIND FIRST B-AlmTabla WHERE B-AlmTabla.Tabla = T-GENER.Clave
        AND B-AlmTabla.Codigo = T-GENER.Codigo
        NO-LOCK NO-ERROR.
    IF AVAILABLE B-AlmTabla THEN DO:
        FIND t-report WHERE t-report.Llave-C = B-AlmTabla.Codigo NO-ERROR.
        IF NOT AVAILABLE t-report THEN CREATE t-report.
        ASSIGN
            t-report.Llave-C    = B-AlmTabla.Codigo
            t-report.Campo-C[1] = CAPS(B-AlmTabla.Nombre)
            t-report.Campo-F[1] = t-report.Campo-F[1] + T-GENER.libre_d03.
/*         ASSIGN                                                                                                     */
/*             t-report.Campo-F[1] = t-report.Campo-F[1] + (T-GENER.libre_d01 + T-GENER.libre_d02 - Almmmate.StkMin). */
    END.
    GET NEXT {&BROWSE-NAME}.
END.
/*
FOR EACH B-MATE OF Almmmatg NO-LOCK,
        FIRST B-Almacen OF B-MATE NO-LOCK,
        EACH B-TabGener WHERE B-TabGener.CodCia = B-MATE.CodCia
        AND B-TabGener.Libre_c01 = B-MATE.CodAlm
        AND B-TabGener.Clave = "ZG" NO-LOCK,
        FIRST B-AlmTabla WHERE B-AlmTabla.Tabla = B-TabGener.Clave
        AND B-AlmTabla.Codigo = B-TabGener.Codigo NO-LOCK:
    FIND t-report WHERE t-report.Llave-C = B-AlmTabla.Codigo NO-ERROR.
    IF NOT AVAILABLE t-report THEN CREATE t-report.
    ASSIGN
        t-report.Llave-C    = B-AlmTabla.Codigo
        t-report.Campo-C[1] = CAPS(B-AlmTabla.Nombre)
        t-report.Campo-F[1] = t-report.Campo-F[1] + fSaldo().

    RUN vta2/stock-comprometido-v2 (B-MATE.CodMat, B-MATE.CodAlm, OUTPUT x-StockComprometido).
    x-StockDisponible = ( B-MATE.StkAct - x-StockComprometido ).

    RUN alm\p-articulo-en-transito (
        B-MATE.CodCia,
        B-MATE.CodAlm,
        B-MATE.CodMat,
        INPUT-OUTPUT TABLE tmp-tabla,
        OUTPUT x-StockTransito).

    ASSIGN
        t-report.Campo-F[1] = t-report.Campo-F[1] + (x-StockDisponible + x-StockTransito + x-StockCompras - B-MATE.StkMin).
END.
*/
FOR EACH t-report WHERE t-report.Llave-C = '':
    DELETE t-report.
END.
 RUN dispatch IN THIS-PROCEDURE ('open-query':U).
RUN Procesa-Handle IN lh_handle ('Pinta-Resumen').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
        Almmmate.Libre_c05 = s-user-id
        Almmmate.Libre_f02 = TODAY.

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
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "Almmmate"}
  {src/adm/template/snd-list.i "T-GENER"}

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
IF s-acceso-total = NO THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSaldo B-table-Win 
FUNCTION fSaldo RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

/*
    x-StockTransito = fStockTransito().
    x-StockCompras = fStockCompras().
    */
    x-StockDisponible = fStockDisponible().

    RETURN (x-StockDisponible + x-StockTransito + x-StockCompras - Almmmate.StkMin).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStockCompras B-table-Win 
FUNCTION fStockCompras RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    /* En Tránsito */
    DEF VAR x-Total AS DEC NO-UNDO.
    /*
    RUN alm\ordencompraentransito (
        Almmmate.CodMat,
        Almmmate.CodAlm,
        OUTPUT x-Total).
    */
    RETURN x-Total.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStockDisponible B-table-Win 
FUNCTION fStockDisponible RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR x-StockComprometido AS DEC.

/* RUN vta2/stock-comprometido (Almmmate.CodMat, Almmmate.CodAlm, OUTPUT x-StockComprometido). */
RUN vta2/stock-comprometido-v2 (Almmmate.CodMat, Almmmate.CodAlm, OUTPUT x-StockComprometido).

RETURN ( Almmmate.StkAct - x-StockComprometido ).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStockTransito B-table-Win 
FUNCTION fStockTransito RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    /* En Tránsito */
    DEF VAR x-Total AS DEC NO-UNDO.
    RUN alm\p-articulo-en-transito (
        Almmmate.CodCia,
        Almmmate.CodAlm,
        Almmmate.CodMat,
        INPUT-OUTPUT TABLE tmp-tabla,
        OUTPUT x-Total).

    RETURN x-Total.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

