&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER ORDENES FOR FacCPedi.
DEFINE BUFFER PEDIDOS FOR FacCPedi.
DEFINE TEMP-TABLE T-CPEDI NO-UNDO LIKE FacCPedi.



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
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */
DEF VAR x-FchPed-1 AS DATE NO-UNDO.
DEF VAR x-FchPed-2 AS DATE NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES GN-DIVI
&Scoped-define FIRST-EXTERNAL-TABLE GN-DIVI


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR GN-DIVI.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-CPEDI FacCPedi

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-CPEDI.CodDoc T-CPEDI.NroPed ~
T-CPEDI.FchPed T-CPEDI.CodRef T-CPEDI.NroRef T-CPEDI.CodCli T-CPEDI.NomCli ~
T-CPEDI.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH T-CPEDI OF GN-DIVI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = T-CPEDI.CodCia ~
  AND FacCPedi.CodDiv = T-CPEDI.CodDiv ~
  AND FacCPedi.CodDoc = T-CPEDI.CodDoc ~
  AND FacCPedi.NroPed = T-CPEDI.NroPed NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-CPEDI OF GN-DIVI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = T-CPEDI.CodCia ~
  AND FacCPedi.CodDiv = T-CPEDI.CodDiv ~
  AND FacCPedi.CodDoc = T-CPEDI.CodDoc ~
  AND FacCPedi.NroPed = T-CPEDI.NroPed NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-CPEDI FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-CPEDI
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi


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
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-CPEDI.CodDoc FORMAT "x(3)":U
      T-CPEDI.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U
      T-CPEDI.FchPed FORMAT "99/99/9999":U
      T-CPEDI.CodRef FORMAT "x(3)":U
      T-CPEDI.NroRef COLUMN-LABEL "Número" FORMAT "X(12)":U
      T-CPEDI.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 11.57
      T-CPEDI.NomCli FORMAT "x(100)":U WIDTH 51
      T-CPEDI.ImpTot FORMAT "->>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 118 BY 6.69
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
   External Tables: INTEGRAL.GN-DIVI
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ORDENES B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDOS B "?" ? INTEGRAL FacCPedi
      TABLE: T-CPEDI T "?" NO-UNDO INTEGRAL FacCPedi
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
         HEIGHT             = 6.85
         WIDTH              = 123.57.
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
     _TblList          = "Temp-Tables.T-CPEDI OF INTEGRAL.GN-DIVI,INTEGRAL.FacCPedi WHERE Temp-Tables.T-CPEDI ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _JoinCode[2]      = "INTEGRAL.FacCPedi.CodCia = Temp-Tables.T-CPEDI.CodCia
  AND INTEGRAL.FacCPedi.CodDiv = Temp-Tables.T-CPEDI.CodDiv
  AND INTEGRAL.FacCPedi.CodDoc = Temp-Tables.T-CPEDI.CodDoc
  AND INTEGRAL.FacCPedi.NroPed = Temp-Tables.T-CPEDI.NroPed"
     _FldNameList[1]   = Temp-Tables.T-CPEDI.CodDoc
     _FldNameList[2]   > Temp-Tables.T-CPEDI.NroPed
"T-CPEDI.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.T-CPEDI.FchPed
     _FldNameList[4]   = Temp-Tables.T-CPEDI.CodRef
     _FldNameList[5]   > Temp-Tables.T-CPEDI.NroRef
"T-CPEDI.NroRef" "Número" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-CPEDI.CodCli
"T-CPEDI.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "11.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-CPEDI.NomCli
"T-CPEDI.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "51" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = Temp-Tables.T-CPEDI.ImpTot
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
/* FILTRO */

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "GN-DIVI"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "GN-DIVI"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anular-Orden B-table-Win 
PROCEDURE Anular-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR pCuenta AS INT NO-UNDO.

pMensaje = ''.

DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-DPEDI FOR Facdpedi.
DEF BUFFER x-Vtacdocu FOR Vtacdocu.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Primero Bloqueamos, luego consistencias y despues anulamos */
    {lib/lock-genericov3.i
        &Tabla="B-CPEDI"
        &Condicion="ROWID(B-CPEDI) = pRowid"    /* O/D */
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    /* Consistencias nuevamente por si acaso */
    IF NOT (B-CPEDI.FlgEst = 'P' AND B-CPEDI.FlgSit = 'T') THEN DO:
        pMensaje = 'Pedido NO válido' + CHR(10) + 
            'La ' + B-CPEDI.CodDoc + ' ' + B-CPEDI.NroPed + ' ya inició su ciclo de despacho' + CHR(10) + 
            'Proceso Abortado'.
        UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    /* **************************************************************************** */
    /* RHC 11/12/2019 MRC NO se puede anular si tiene HPK.FlgEst <> 'A' */
    /* **************************************************************************** */
    FIND FIRST x-Vtacdocu WHERE x-vtacdocu.CodCia = s-CodCia AND
        x-vtacdocu.CodPed = "HPK" AND
        x-vtacdocu.CodRef = B-CPEDI.CodDoc AND
        x-vtacdocu.NroRef = B-CPEDI.NroPed AND
        x-vtacdocu.FlgEst <> 'A' NO-LOCK NO-ERROR.
    IF AVAILABLE x-Vtacdocu THEN DO:
        pMensaje = "La Orden" + B-CPEDI.CodDoc + " " + B-CPEDI.NroPed + " tiene HPK".
        UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    /* **************************************************************************** */
    ASSIGN 
        B-CPEDI.FlgEst = "A"
        B-CPEDI.UsrAct = s-User-Id
        B-CPEDI.Glosa = " A N U L A D O".
    /* **************************************************************************** */
    RUN vtagn/pTracking-04 (B-CPEDI.CodCia,
                            B-CPEDI.CodDiv,
                            B-CPEDI.CodRef,
                            B-CPEDI.NroRef,
                            s-User-Id,
                            'GOD',
                            'A',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            B-CPEDI.CodDoc,
                            B-CPEDI.NroPed,
                            B-CPEDI.CodRef,
                            B-CPEDI.NroRef).
END.
IF AVAILABLE(B-CPEDI) THEN RELEASE B-CPEDI.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anular-Pedido B-table-Win 
PROCEDURE Anular-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

IF NOT AVAILABLE T-CPEDI THEN RETURN 'OK'.

/*
Ic - 08Feb2023, correo de harol Segura

Susana / Daniel 
Favor retirar accesos a todas las áreas/usuarios ajenos a Logística y que no corresponda la ejecución de los procesos en referencia 
*/

DEFINE VAR x-tiene-OD AS LOG INIT NO.

ORDENES:
FOR EACH ORDENES NO-LOCK WHERE ORDENES.CodCia = PEDIDOS.CodCia AND
    ORDENES.CodDiv = PEDIDOS.CodDiv AND
    ORDENES.CodDoc = "O/D" AND
    ORDENES.CodRef = PEDIDOS.CodDoc AND
    ORDENES.NroRef = PEDIDOS.NroPed AND
    ORDENES.FlgEst <> 'A':
    x-tiene-OD = YES.
    LEAVE ORDENES.
END.
IF x-tiene-OD = YES THEN DO:
    pMensaje = 'Pedido ' + PEDIDOS.NroPed + ' Tiene Orden(es) de despacho ' + CHR(10) + 'Proceso Abortado'.
    RETURN 'ADM-ERROR'.
END.

MESSAGE 'Confirmar la anulación del PEDIDO' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN 'OK'.

DEFINE VAR pRowid AS ROWID NO-UNDO.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="PEDIDOS" ~
        &Alcance="FIRST" ~
        &Condicion="PEDIDOS.CodCia = T-CPEDI.CodCia AND ~
        PEDIDOS.CodDiv = T-CPEDI.CodDiv AND ~
        PEDIDOS.CodDoc = T-CPEDI.CodDoc AND ~
        PEDIDOS.NroPed = T-CPEDI.NroPed" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    ASSIGN
        pRowid = ROWID(PEDIDOS).
    /* Volvemos a verificar */    
    IF LOOKUP(PEDIDOS.FlgEst, 'G,P') = 0 THEN DO:
        pMensaje = 'Pedido NO esta PENDIENTE' + CHR(10) + 'Proceso Abortado'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /*
    Ic - 08Feb2023, correo de harold Segura
    
    Susana / Daniel 
    Favor retirar accesos a todas las áreas/usuarios ajenos a Logística y que no corresponda la ejecución de los procesos en referencia 
    */

    /*IF PEDIDOS.FlgEst = "C" THEN DO:*/
        /* Verificamos la O/D  */
        FOR EACH ORDENES NO-LOCK WHERE ORDENES.CodCia = PEDIDOS.CodCia AND
            ORDENES.CodDiv = PEDIDOS.CodDiv AND
            ORDENES.CodDoc = "O/D" AND
            ORDENES.CodRef = PEDIDOS.CodDoc AND
            ORDENES.NroRef = PEDIDOS.NroPed AND
            ORDENES.FlgEst <> "A":

            /*IF NOT (ORDENES.FlgEst = 'P' AND ORDENES.FlgSit = 'T') THEN DO:*/
                pMensaje = 'Pedido NO esta pendiente, tiene Ordenes de despacho' + CHR(10) + 
                    'La ' + ORDENES.CodDoc + ' ' + ORDENES.NroPed  + CHR(10) + 
                    'Proceso Abortado'.
                UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            /*END.*/
        END.
    /*END.*/
    
    /*
    /* SI TIENE ORDEN DE DESPACHO ENTONCES ANULAMOS PRIMERO LA ORDEN */
    FOR EACH ORDENES NO-LOCK WHERE ORDENES.CodCia = PEDIDOS.CodCia AND
        ORDENES.CodDiv = PEDIDOS.CodDiv AND
        ORDENES.CodDoc = "O/D" AND
        ORDENES.CodRef = PEDIDOS.CodDoc AND
        ORDENES.NroRef = PEDIDOS.NroPed AND
        ORDENES.FlgEst <> 'A':
        RUN Anular-Orden (INPUT ROWID(ORDENES), OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.    
    */
    /* Actualizamos Cotizacion */
    RUN vta2/pactualizacotizacion ( INPUT pRowid, INPUT "D", OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo extornar la Cotización".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* TRACKING */
    RUN vtagn/pTracking-04 (PEDIDOS.CodCia,
                      PEDIDOS.CodDiv,
                      PEDIDOS.CodDoc,
                      PEDIDOS.NroPed,
                      s-User-Id,
                      'GNP',
                      'A',
                      DATETIME(TODAY, MTIME),
                      DATETIME(TODAY, MTIME),
                      PEDIDOS.CodDoc,
                      PEDIDOS.NroPed,
                      PEDIDOS.CodRef,
                      PEDIDOS.NroRef).
    ASSIGN
        PEDIDOS.Glosa = "ANULADO POR " + s-user-id + " EL DIA " + STRING ( DATETIME(TODAY, MTIME), "99/99/9999 HH:MM" ).
        PEDIDOS.FlgEst = 'A'.
END.
IF AVAILABLE PEDIDOS THEN RELEASE PEDIDOS.
IF AVAILABLE ORDENES THEN RELEASE ORDENES.
IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Filtros B-table-Win 
PROCEDURE Captura-Filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pFchPed-1 AS DATE.
DEF INPUT PARAMETER pFchPed-2 AS DATE.



x-FchPed-1 = pFchPed-1.
x-FchPed-2 = pFchPed-2.


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

EMPTY TEMP-TABLE T-CPEDI.

FOR EACH Faccpedi NO-LOCK WHERE FacCPedi.CodCia = gn-divi.codcia AND
    FacCPedi.CodDiv = gn-divi.coddiv AND
    FacCPedi.CodDoc = 'PED' AND
    FacCPedi.FlgEst = 'P' AND 
    (FacCPedi.FchPed >= x-FchPed-1 AND FacCPedi.FchPed <= x-FchPed-2):
    CREATE T-CPEDI.
    BUFFER-COPY Faccpedi TO T-CPEDI.
END.
FOR EACH Faccpedi NO-LOCK WHERE FacCPedi.CodCia = gn-divi.codcia AND
    FacCPedi.CodDiv = gn-divi.coddiv AND
    FacCPedi.CodDoc = 'PED' AND
    FacCPedi.FlgEst = 'G' AND 
    (FacCPedi.FchPed >= x-FchPed-1 AND FacCPedi.FchPed <= x-FchPed-2):
    CREATE T-CPEDI.
    BUFFER-COPY Faccpedi TO T-CPEDI.
END.

/*
Ic - 08Feb2023, correo de harol Segura

Susana / Daniel 
Favor retirar accesos a todas las áreas/usuarios ajenos a Logística y que no corresponda la ejecución de los procesos en referencia 

FOR EACH ORDENES NO-LOCK WHERE ORDENES.CodCia = gn-divi.codcia AND
    ORDENES.CodDiv = gn-divi.coddiv AND
    ORDENES.CodDoc = 'O/D' AND
    ORDENES.FlgEst = 'P' AND 
    ORDENES.FlgSit = 'T',
    FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = ORDENES.codcia AND
    Faccpedi.coddoc = ORDENES.codref AND
    Faccpedi.nroped = ORDENES.nroref AND
    (Faccpedi.FchPed >= x-FchPed-1 AND Faccpedi.FchPed <= x-FchPed-2)
    BREAK BY ORDENES.CodRef BY ORDENES.NroRef:
    IF FIRST-OF(ORDENES.CodRef) OR FIRST-OF(ORDENES.NroRef) THEN DO:
        FIND FIRST T-CPEDI OF Faccpedi NO-LOCK NO-ERROR.
        IF NOT AVAILABLE T-CPEDI THEN DO:
            CREATE T-CPEDI.
            BUFFER-COPY Faccpedi TO T-CPEDI.
        END.
    END.
END.
*/


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
  {src/adm/template/snd-list.i "GN-DIVI"}
  {src/adm/template/snd-list.i "T-CPEDI"}
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

