&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER BONIFICACION FOR FacCPedi.
DEFINE BUFFER ORDEN FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE t-FacCPedi NO-UNDO LIKE FacCPedi.
DEFINE BUFFER x-vtacdocu FOR VtaCDocu.



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

DEF SHARED VAR s-CodDoc AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEFINE VAR pNroOD AS CHAR INIT ''.

DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR pMensaje2 AS CHAR NO-UNDO.

&SCOPED-DEFINE Condicion ( FacCPedi.CodCia = s-codcia ~
    AND FacCPedi.DivDes = s-coddiv ~
    AND LOOKUP(FacCPedi.CodDoc, s-CodDoc) > 0 ~
    AND FacCPedi.FlgEst = 'P' ~
    AND LOOKUP(FacCPedi.FlgSit, 'T,TG,C') > 0 )

&SCOPED-DEFINE Condicion2 ( ORDEN.CodCia = s-codcia ~
    AND ORDEN.DivDes = s-coddiv ~
    AND LOOKUP(ORDEN.CodDoc, s-CodDoc) > 0 ~
    AND ORDEN.FlgEst = 'P' ~
    AND LOOKUP(ORDEN.FlgSit, 'T,TG,TI,PI,C') > 0 )

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
&Scoped-define INTERNAL-TABLES t-FacCPedi FacCPedi GN-DIVI

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.CodDoc FacCPedi.NroPed ~
FacCPedi.FchPed FacCPedi.NomCli GN-DIVI.DesDiv FacCPedi.Libre_c02 ~
FacCPedi.Libre_c03 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH t-FacCPedi WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi OF t-FacCPedi NO-LOCK, ~
      FIRST GN-DIVI OF FacCPedi NO-LOCK ~
    BY t-FacCPedi.FchPed DESCENDING ~
       BY t-FacCPedi.CodDoc ~
        BY t-FacCPedi.NroPed DESCENDING
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH t-FacCPedi WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi OF t-FacCPedi NO-LOCK, ~
      FIRST GN-DIVI OF FacCPedi NO-LOCK ~
    BY t-FacCPedi.FchPed DESCENDING ~
       BY t-FacCPedi.CodDoc ~
        BY t-FacCPedi.NroPed DESCENDING.
&Scoped-define TABLES-IN-QUERY-br_table t-FacCPedi FacCPedi GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-br_table t-FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define THIRD-TABLE-IN-QUERY-br_table GN-DIVI


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table txtNumero 
&Scoped-Define DISPLAYED-OBJECTS txtNumero 

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
DEFINE VARIABLE txtNumero AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      t-FacCPedi, 
      FacCPedi, 
      GN-DIVI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.CodDoc FORMAT "x(3)":U
      FacCPedi.NroPed COLUMN-LABEL "Número" FORMAT "XXX-XXXXXX":U
            WIDTH 9.57
      FacCPedi.FchPed COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
      FacCPedi.NomCli FORMAT "x(60)":U WIDTH 39.72
      GN-DIVI.DesDiv COLUMN-LABEL "Origen" FORMAT "X(20)":U WIDTH 15.43
      FacCPedi.Libre_c02 COLUMN-LABEL "Refer." FORMAT "x(3)":U
      FacCPedi.Libre_c03 COLUMN-LABEL "Número" FORMAT "x(10)":U
            WIDTH 16
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 108 BY 6.69
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     txtNumero AT ROW 4.27 COL 108 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     "Nro de Orden" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 3.69 COL 110 WIDGET-ID 4
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
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: BONIFICACION B "?" ? INTEGRAL FacCPedi
      TABLE: ORDEN B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: t-FacCPedi T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: x-vtacdocu B "?" ? INTEGRAL VtaCDocu
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
         WIDTH              = 123.72.
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
/* BROWSE-TAB br_table TEXT-1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.t-FacCPedi,INTEGRAL.FacCPedi OF Temp-Tables.t-FacCPedi,INTEGRAL.GN-DIVI OF INTEGRAL.FacCPedi"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST, FIRST"
     _OrdList          = "Temp-Tables.t-FacCPedi.FchPed|no,Temp-Tables.t-FacCPedi.CodDoc|yes,Temp-Tables.t-FacCPedi.NroPed|no"
     _FldNameList[1]   = INTEGRAL.FacCPedi.CodDoc
     _FldNameList[2]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Número" "XXX-XXXXXX" "character" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Fecha" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "39.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" "Origen" "X(20)" "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.Libre_c02
"FacCPedi.Libre_c02" "Refer." "x(3)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacCPedi.Libre_c03
"FacCPedi.Libre_c03" "Número" "x(10)" "character" ? ? ? ? ? ? no ? no no "16" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME txtNumero
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtNumero B-table-Win
ON LEAVE OF txtNumero IN FRAME F-Main
DO:
  ASSIGN txtNumero.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Orden B-table-Win 
PROCEDURE Actualiza-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Pedido B-table-Win 
PROCEDURE Actualiza-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER X-Tipo AS INTEGER.
  DEFINE INPUT PARAMETER pCodRef AS CHAR.
  DEFINE INPUT PARAMETER pNroRef AS CHAR.
  DEFINE INPUT PARAMETER pFlgEst AS CHAR.       /* "G" o "P" */

  IF LOOKUP(pCodRef, 'PED,P/M') = 0 THEN RETURN 'OK'.
  
  PRINCIPAL:
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      {lib/lock-genericov3.i
          &Tabla="B-CPEDI"
          &Alcance="FIRST"
          &Condicion="B-CPedi.CodCia = s-CodCia ~
          AND B-CPedi.CodDoc = pCodRef ~
          AND B-CPedi.NroPed = pNroRef"
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
          &Accion="RETRY"
          &Mensaje="NO"
          &txtMensaje="pMensaje"
          &TipoError="UNDO, RETURN 'ADM-ERROR'"
          }
      FOR EACH FacdPedi OF FaccPedi NO-LOCK:
          FIND FIRST B-DPedi OF B-CPedi WHERE B-DPedi.CodMat = FacDPedi.CodMat
              AND B-DPedi.Libre_c05 = FacDPedi.Libre_c05
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE B-DPEDI THEN NEXT.
          FIND CURRENT B-DPEDI EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
          IF ERROR-STATUS:ERROR = YES THEN DO:
              {lib/mensaje-de-error.i &MensajeError="pMensaje"}
              UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
          END.
          ASSIGN
              B-DPEDI.CanAte = B-DPEDI.CanAte + x-Tipo * (FacDPedi.CanPed - FacDPedi.CanAte).
          RELEASE B-DPEDI.
      END.
      IF x-Tipo = -1 THEN DO:
          FOR EACH B-DPEDI OF B-CPEDI NO-LOCK:
              IF B-DPEDI.CanAte < B-DPEDI.CanPed THEN DO:
                  B-CPEDI.FlgEst = pFlgEst.
                  LEAVE.
              END.
          END.
      END.
      IF x-Tipo = +1 THEN B-CPedi.FlgEst = "C".
      IF AVAILABLE B-CPEDI THEN RELEASE B-CPedi.
  END.
  RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anula-Orden B-table-Win 
PROCEDURE Anula-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Rowid AS ROWID NO-UNDO.
DEF VAR pCuenta AS INT NO-UNDO.

/* Guardamos el puntero */
x-Rowid = ROWID(Faccpedi).
pMensaje = ''.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Primero Bloqueamos, luego consistencias y despues anulamos */
    {lib/lock-genericov3.i
        &Tabla="Faccpedi"
        &Condicion="ROWID(Faccpedi) = x-Rowid"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    /* **************************************************************************** */
    /* Consistencias */
    /* **************************************************************************** */
    IF NOT {&Condicion} THEN DO:
        pMensaje = "La Orden" + Faccpedi.CodDoc + " " + Faccpedi.NroPed + " ya NO es válida para anular".
        UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    /* **************************************************************************** */
    /* RHC 11/12/2019 MRC NO se puede anular si tiene HPK.FlgEst <> 'A' */
    /* **************************************************************************** */
    FIND FIRST x-Vtacdocu WHERE x-vtacdocu.CodCia = s-CodCia AND
        x-vtacdocu.CodPed = "HPK" AND
        x-vtacdocu.CodRef = Faccpedi.CodDoc AND
        x-vtacdocu.NroRef = Faccpedi.NroPed AND
        x-vtacdocu.FlgEst <> 'A' NO-LOCK NO-ERROR.
    IF AVAILABLE x-Vtacdocu THEN DO:
        pMensaje = "La Orden" + Faccpedi.CodDoc + " " + Faccpedi.NroPed + " tiene HPK".
        /*pMensaje = "No se pueden Anular Ordenes con HPK".*/
        UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    /* **************************************************************************** */
    ASSIGN 
        Faccpedi.FlgEst = "A"
        Faccpedi.Glosa = " A N U L A D O".
    /* **************************************************************************** */
    /* Quitar la O/D de la PHR */
    /* **************************************************************************** */
    REPEAT:
        FIND FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-CodCia AND
            DI-RutaD.CodDiv = s-CodDiv AND
            DI-RutaD.CodDoc = "PHR" AND
            DI-RutaD.CodRef = Faccpedi.CodDoc AND 
            DI-RutaD.NroRef = Faccpedi.NroPed
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DI-RutaD THEN LEAVE.
        FIND CURRENT DI-RutaD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        DELETE DI-RutaD.
    END.
    /* **************************************************************************** */
    /* Extornamos la O/D */
    /* **************************************************************************** */
    RUN Actualiza-Pedido (-1, FacCPedi.CodRef, FacCPedi.NroRef, "G").
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef,
                            s-User-Id,
                            'GOD',
                            'A',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef).
    /* **************************************************************************** */
    /* Anulamos la R/A */
    /* **************************************************************************** */
    IF Faccpedi.CodDoc = "OTR" AND Faccpedi.CodRef = "R/A" THEN DO:
        FIND FIRST Almcrepo WHERE almcrepo.CodCia = Faccpedi.CodCia AND
            almcrepo.NroSer = INTEGER(SUBSTRING(Faccpedi.NroRef,1,3)) AND
            almcrepo.NroDoc = INTEGER(SUBSTRING(Faccpedi.NroRef,4))
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            pMensaje = "NO se pudo anular la " + Faccpedi.CodRef + " " + Faccpedi.NroRef.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            almcrepo.flgest = 'A'
            almcrepo.usract = s-user-id
            almcrepo.fecact = TODAY
            almcrepo.horact = STRING(TIME, 'HH:MM:SS').
    END.
END.
IF AVAILABLE(x-Vtacdocu) THEN RELEASE x-Vtacdocu.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(Almcrepo) THEN RELEASE Almcrepo.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anula-Orden-Control B-table-Win 
PROCEDURE Anula-Orden-Control :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Faccpedi THEN RETURN.

MESSAGE 'Continuamos con la anulación del' faccpedi.coddoc faccpedi.nroped 
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN "ADM-ERROR".

DEF VAR x-Rowid AS ROWID NO-UNDO.
DEF VAR pCuenta AS INT NO-UNDO.
DEF VAR x-Bonificacion AS LOG NO-UNDO.

/* Guardamos el puntero */
x-Rowid = ROWID(Faccpedi).
pMensaje = ''.
x-Bonificacion = NO.    /* por defecto */

/* *********************************************************** */
/* RHC 03/01/2020 control de ped por bonificacion relacionados */
/* *********************************************************** */
IF Faccpedi.CodDoc = "O/D" THEN DO:
    FIND FIRST PEDIDO WHERE PEDIDO.codcia = Faccpedi.codcia AND
        PEDIDO.coddoc = Faccpedi.codref AND
        PEDIDO.nroped = Faccpedi.nroref
        NO-LOCK.
    IF PEDIDO.CodOrigen = "PED" THEN DO:
        MESSAGE "Pedido por BONIFICACIONES" SKIP "Acceso Denegado" VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    /* Si no es el BONIFICADO buscamos su BONIFICADO RELACIONADO */
    FIND FIRST BONIFICACION WHERE BONIFICACION.codcia = PEDIDO.codcia AND
        BONIFICACION.coddiv = PEDIDO.coddiv AND
        BONIFICACION.coddoc = PEDIDO.coddoc AND
        BONIFICACION.codorigen = PEDIDO.coddoc AND
        BONIFICACION.nroorigen = PEDIDO.nroped AND
        BONIFICACION.flgest <> 'A' NO-LOCK NO-ERROR.
    /* Como se van a anular juntos => también debe cumplir la condición */
    IF AVAILABLE BONIFICACION THEN DO:
        /* Buscamos la orden de despacho relacionada */
        FIND ORDEN WHERE ORDEN.codcia = BONIFICACION.codcia AND
            ORDEN.coddoc = "O/D" AND
            ORDEN.codref = BONIFICACION.coddoc AND 
            ORDEN.nroref = BONIFICACION.nroped AND
            ORDEN.flgest <> 'A'
            NO-LOCK.
        IF NOT {&Condicion2} THEN DO:
            MESSAGE 'La Orden de Despacho tiene una BONIFICACION' SKIP
                'que NO cumple con las condiciones para anularla' SKIP
                'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
            RETURN 'ADM-ERROR'.
        END.
        x-Bonificacion = YES.
    END.
    /* 02/12/2025: No anular si tiene HPK activa */
    FIND FIRST Vtacdocu WHERE Vtacdocu.codcia = s-codcia
        AND Vtacdocu.codref = Faccpedi.coddoc
        AND Vtacdocu.nroref = Faccpedi.nroped
        AND Vtacdocu.codped = "HPK"
        AND Vtacdocu.coddiv = s-coddiv
        AND Vtacdocu.flgest <> "A"
        NO-LOCK NO-ERROR.
    IF AVAILABLE Vtacdocu THEN DO:
        MESSAGE 'La Orden tiene una HPK activa (' + Vtacdocu.nroped + ')' SKIP
            'Tiene que anular la HPK' SKIP
            'Proceso abortado' VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
END.
/* *********************************************************** */
/* *********************************************************** */
/* RUTINA PRINCIPAL */
pMensaje = "".
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* Puntero a su lugar */
    FIND Faccpedi WHERE ROWID(Faccpedi) = x-Rowid NO-LOCK.
    /* 1ro. por la base */
    RUN Anula-Orden.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        UNDO, LEAVE.
    END.
    /* 2do. por el bonificado si existe */
    IF x-Bonificacion = YES THEN DO:
        /* Puntero a su lugar */
        FIND Faccpedi WHERE ROWID(Faccpedi) = ROWID(ORDEN) NO-LOCK.
        RUN Anula-Orden.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            UNDO, LEAVE.
        END.
    END.
END.
IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anula-Orden-Old B-table-Win 
PROCEDURE Anula-Orden-Old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Faccpedi THEN RETURN.

MESSAGE 'Continuamos con la anulación del' faccpedi.coddoc faccpedi.nroped 
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN "ADM-ERROR".

DEF VAR x-Rowid AS ROWID NO-UNDO.
DEF VAR pCuenta AS INT NO-UNDO.

/* Guardamos el puntero */
x-Rowid = ROWID(Faccpedi).
pMensaje = ''.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* Primero Bloqueamos, luego consistencias y despues anulamos */
    {lib/lock-genericov3.i
        &Tabla="Faccpedi"
        &Condicion="ROWID(Faccpedi) = x-Rowid"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, LEAVE"
        }
    /* **************************************************************************** */
    /* Consistencias */
    /* **************************************************************************** */
    IF NOT {&Condicion} THEN DO:
        pMensaje = "La Orden ya NO es válida para anular".
        UNDO, LEAVE.
    END.
    /* **************************************************************************** */
    /* RHC 11/12/2019 MRC NO se puede anular si tiene HPK.FlgEst <> 'A' */
    /* **************************************************************************** */
    FIND FIRST x-Vtacdocu WHERE x-vtacdocu.CodCia = s-CodCia AND
        x-vtacdocu.CodPed = "HPK" AND
        x-vtacdocu.CodRef = Faccpedi.CodDoc AND
        x-vtacdocu.NroRef = Faccpedi.NroPed AND
        x-vtacdocu.FlgEst <> 'A' NO-LOCK NO-ERROR.
    IF AVAILABLE x-Vtacdocu THEN DO:
        pMensaje = "No se pueden Anular Ordenes con HPK".
        UNDO PRINCIPAL, LEAVE PRINCIPAL.
    END.
    /* **************************************************************************** */
    ASSIGN 
        Faccpedi.FlgEst = "A"
        Faccpedi.Glosa = " A N U L A D O".
    /* **************************************************************************** */
    /* Anulación de HPK */
    /* RHC 11/12/2019 Bloqueado a solicitud de MR */
    /* **************************************************************************** */
/*     REPEAT:                                                                                        */
/*         FIND FIRST x-Vtacdocu WHERE x-vtacdocu.CodCia = s-CodCia AND                               */
/*             x-vtacdocu.CodPed = "HPK" AND                                                          */
/*             x-vtacdocu.CodRef = Faccpedi.CodDoc AND                                                */
/*             x-vtacdocu.NroRef = Faccpedi.NroPed AND                                                */
/*             x-vtacdocu.FlgEst <> 'A' NO-LOCK NO-ERROR.                                             */
/*         IF NOT AVAILABLE x-Vtacdocu THEN LEAVE.                                                    */
/*         FIND CURRENT x-Vtacdocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.                                   */
/*         IF ERROR-STATUS:ERROR = YES THEN DO:                                                       */
/*             {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}               */
/*             UNDO PRINCIPAL, LEAVE PRINCIPAL.                                                       */
/*         END.                                                                                       */
/*         IF NOT (x-Vtacdocu.FlgEst = "P" AND                                                        */
/*                 LOOKUP(x-Vtacdocu.FlgSit, 'TI,TX,P,PT,PO,PC,C') > 0 AND                            */
/*                 CAN-FIND(FIRST Di-RutaC WHERE DI-RutaC.CodCia = s-CodCia AND                       */
/*                          DI-RutaC.CodDiv = s-CodDiv AND                                            */
/*                          DI-RutaC.CodDoc = x-vtacdocu.CodOri AND                                   */
/*                          DI-RutaC.NroDoc = x-vtacdocu.NroOri AND                                   */
/*                          LOOKUP(DI-RutaC.FlgEst, 'PX,PK,P') > 0 NO-LOCK))                          */
/*                 THEN DO:                                                                           */
/*             pMensaje = "La HPK " + x-Vtacdocu.NroPed + " NO cumple las condiciones para anularlo". */
/*             UNDO PRINCIPAL, LEAVE PRINCIPAL.                                                       */
/*         END.                                                                                       */
/*         ASSIGN                                                                                     */
/*             x-Vtacdocu.FlgEst = "A"                                                                */
/*             x-Vtacdocu.UsrAnu = s-user-id                                                          */
/*             x-Vtacdocu.FchAnu = TODAY.                                                             */
/*     END.                                                                                           */
    /* **************************************************************************** */
    /* Quitar la O/D de la PHR */
    /* **************************************************************************** */
    REPEAT:
        FIND FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-CodCia AND
            DI-RutaD.CodDiv = s-CodDiv AND
            DI-RutaD.CodDoc = "PHR" AND
            DI-RutaD.CodRef = Faccpedi.CodDoc AND 
            DI-RutaD.NroRef = Faccpedi.NroPed
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DI-RutaD THEN LEAVE.
        FIND CURRENT DI-RutaD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            UNDO PRINCIPAL, LEAVE PRINCIPAL.
        END.
        DELETE DI-RutaD.
    END.
    /* **************************************************************************** */
    /* Extornamos la O/D */
    /* **************************************************************************** */
    RUN Actualiza-Pedido (-1, FacCPedi.CodRef, FacCPedi.NroRef, "G").
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, LEAVE PRINCIPAL.
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef,
                            s-User-Id,
                            'GOD',
                            'A',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef).
    /* **************************************************************************** */
    /* Anulamos la R/A */
    /* **************************************************************************** */
    IF Faccpedi.CodDoc = "OTR" AND Faccpedi.CodRef = "R/A" THEN DO:
        FIND FIRST Almcrepo WHERE almcrepo.CodCia = Faccpedi.CodCia AND
            almcrepo.NroSer = INTEGER(SUBSTRING(Faccpedi.NroRef,1,3)) AND
            almcrepo.NroDoc = INTEGER(SUBSTRING(Faccpedi.NroRef,4))
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            pMensaje = "NO se pudo anular la " + Faccpedi.CodRef + " " + Faccpedi.NroRef.
            UNDO PRINCIPAL, LEAVE PRINCIPAL.
        END.
        ASSIGN
            almcrepo.flgest = 'A'
            almcrepo.usract = s-user-id
            almcrepo.fecact = TODAY
            almcrepo.horact = STRING(TIME, 'HH:MM:SS').
    END.
END.
IF AVAILABLE(x-Vtacdocu) THEN RELEASE x-Vtacdocu.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(Almcrepo) THEN RELEASE Almcrepo.

IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.

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

EMPTY TEMP-TABLE t-faccpedi.

DEF VAR iItem AS INTE NO-UNDO.
DEF VAR cCodDoc AS CHAR NO-UNDO.

IF TRUE <> (pNroOD > "") THEN DO:
    DO iItem = 1 TO NUM-ENTRIES(s-CodDoc):
        FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
            AND Faccpedi.divdes = s-coddiv
            AND Faccpedi.coddoc = ENTRY(iItem,s-CodDoc)
            AND Faccpedi.flgest = "P":
            IF LOOKUP(FacCPedi.FlgSit, 'T,TG,C') > 0  THEN DO:
                CREATE t-faccpedi.
                BUFFER-COPY Faccpedi TO t-faccpedi.
            END.
        END.
    END.
END.
ELSE DO:
    DO iItem = 1 TO NUM-ENTRIES(s-CodDoc):
        FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
            AND Faccpedi.divdes = s-coddiv
            AND Faccpedi.coddoc = ENTRY(iItem,s-CodDoc)
            AND Faccpedi.flgest = "P"
            AND Faccpedi.nroped = pNroOD:
            IF LOOKUP(FacCPedi.FlgSit, 'T,TG,C') > 0  THEN DO:
                CREATE t-faccpedi.
                BUFFER-COPY Faccpedi TO t-faccpedi.
            END.
        END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-SubOrden B-table-Win 
PROCEDURE Extorna-SubOrden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Borramos si hubiera una anterior */
FOR EACH Vtacdocu WHERE VtaCDocu.CodCia = Faccpedi.codcia
    AND VtaCDocu.CodDiv = Faccpedi.coddiv
    AND VtaCDocu.CodPed = Faccpedi.coddoc
    AND VtaCDocu.NroPed BEGINS Faccpedi.nroped:
    FOR EACH Vtaddocu OF Vtacdocu:
        DELETE Vtaddocu.
    END.
    DELETE Vtacdocu.
END.
RETURN 'OK'.

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
  
  pNroOD = txtNumero.

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
  {src/adm/template/snd-list.i "t-FacCPedi"}
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

