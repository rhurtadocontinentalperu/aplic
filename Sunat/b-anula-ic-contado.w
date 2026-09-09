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
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VARIABLE S-FLGCIE  AS CHAR.

DEF VAR x-FchDoc-1 AS DATE NO-UNDO.       /* Fecha Límite */
DEF VAR x-FchDoc-2 AS DATE NO-UNDO.       /* Fecha Límite */
DEF VAR x-NomCli AS CHAR NO-UNDO.
DEF VAR x-CodRef AS CHAR NO-UNDO.
DEF VAR x-NroRef AS CHAR NO-UNDO.

x-FchDoc-1 = ADD-INTERVAL(TODAY, -1, 'months').
x-FchDoc-2 = TODAY.

&SCOPED-DEFINE Condicion (CcbCCaja.CodDoc = "I/C" AND ~
CcbCCaja.Tipo = "MOSTRADOR" AND ~
(CcbCCaja.FchDoc >= x-FchDoc-1) AND ~
(CcbCCaja.FchDoc <= x-FchDoc-2) AND ~
CcbCCaja.FlgEst = "C" AND ~
(TRUE <> (x-NomCli > '') OR INDEX(CcbCCaja.NomCli, x-NomCli) > 0) AND ~
CcbCCaja.FlgCie = s-FlgCie)

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
&Scoped-define INTERNAL-TABLES CcbCCaja

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCCaja.CodDoc CcbCCaja.NroDoc ~
CcbCCaja.FchDoc CcbCCaja.CodCaja CcbCCaja.usuario CcbCCaja.FchCie ~
CcbCCaja.HorCie 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH CcbCCaja OF GN-DIVI WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK ~
    BY CcbCCaja.NroDoc DESCENDING
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbCCaja OF GN-DIVI WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK ~
    BY CcbCCaja.NroDoc DESCENDING.
&Scoped-define TABLES-IN-QUERY-br_table CcbCCaja
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCCaja


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
      CcbCCaja SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbCCaja.CodDoc FORMAT "x(3)":U
      CcbCCaja.NroDoc FORMAT "X(12)":U
      CcbCCaja.FchDoc FORMAT "99/99/9999":U
      CcbCCaja.CodCaja FORMAT "X(12)":U
      CcbCCaja.usuario FORMAT "x(10)":U
      CcbCCaja.FchCie FORMAT "99/99/9999":U
      CcbCCaja.HorCie FORMAT "x(5)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 66 BY 12.38
         FONT 4
         TITLE "INGRESOS A CAJA".


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
         HEIGHT             = 13.46
         WIDTH              = 66.
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
     _TblList          = "INTEGRAL.CcbCCaja OF INTEGRAL.GN-DIVI"
     _Options          = "NO-LOCK KEY-PHRASE"
     _OrdList          = "INTEGRAL.CcbCCaja.NroDoc|no"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   = INTEGRAL.CcbCCaja.CodDoc
     _FldNameList[2]   = INTEGRAL.CcbCCaja.NroDoc
     _FldNameList[3]   = INTEGRAL.CcbCCaja.FchDoc
     _FldNameList[4]   > INTEGRAL.CcbCCaja.CodCaja
"CcbCCaja.CodCaja" ? "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.CcbCCaja.usuario
     _FldNameList[6]   = INTEGRAL.CcbCCaja.FchCie
     _FldNameList[7]   = INTEGRAL.CcbCCaja.HorCie
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* INGRESOS A CAJA */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* INGRESOS A CAJA */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* INGRESOS A CAJA */
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

ON FIND OF Ccbccaja DO:
    IF x-NroRef > '' AND 
        NOT CAN-FIND(FIRST Ccbdcaja OF Ccbccaja WHERE Ccbdcaja.codref = x-CodRef 
                     AND Ccbdcaja.nroref = x-NroRef NO-LOCK)
        THEN RETURN ERROR.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anular B-table-Win 
PROCEDURE Anular :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Ccbccaja THEN RETURN 'ADM-ERROR'.
DEF VAR x-Rowid AS ROWID NO-UNDO.

/* ********************************************************************************** */
/* Preguntas de Verificación */
/* RHC 27/02/2020 Sí y solo sí tenga un comprobante generado */
/* ********************************************************************************** */
DEF VAR pCodDoc AS CHAR NO-UNDO.
DEF VAR pNroDoc AS CHAR NO-UNDO.
DEF VAR pImpTot AS DEC NO-UNDO.
DEF VAR pStatus AS CHAR NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

IF NOT CAN-FIND(FIRST Ccbdcaja OF Ccbccaja NO-LOCK) THEN DO:
    MESSAGE 'Se ha detectado que NO se ha generado el comprobante' SKIP
        'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN 'ADM-ERROR'.
END.
ELSE DO:
    RUN ccb/dpidedatos (OUTPUT pCodDoc, OUTPUT pNroDoc, OUTPUT pImpTot, OUTPUT pStatus).
    IF pStatus = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    IF NOT CAN-FIND(FIRST Ccbdcaja OF Ccbccaja WHERE Ccbdcaja.codref = pCodDoc
                    AND Ccbdcaja.nroref = pNroDoc
                    AND Ccbdcaja.imptot = pImpTot NO-LOCK) THEN DO:
        MESSAGE 'Documento no encontrado' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
END.
/* ********************************************************************************** */
/* Verificacion de Comprobantes Relacionados */
/* ********************************************************************************** */
DEF VAR X_nrodoc AS CHAR NO-UNDO.
IF ((CcbCCaja.Voucher[2] <> "" ) AND
    (CcbCCaja.ImpNac[2] + CcbCCaja.ImpUsa[2]) > 0 ) OR
    ((CcbCCaja.Voucher[3] <> "" ) AND
    (CcbCCaja.ImpNac[3] + CcbCCaja.ImpUsa[3]) > 0) THEN DO:
    IF CcbCCaja.Voucher[2] <> "" THEN x_nrodoc = CcbCCaja.Voucher[2].
    IF CcbCCaja.Voucher[3] <> "" THEN x_nrodoc = CcbCCaja.Voucher[3].
    FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = S-CodCia AND
        CcbCDocu.CodDoc = "CHC" AND
        CcbCDocu.NroDoc = x_nrodoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE CcbCDocu AND CcbCDocu.FlgEst = "C" THEN DO:
        MESSAGE "El Cheque" X_NroDoc "está Aceptado,"
            "No es posible Anular la Operacion"
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
END.
/* ********************************************************************************** */
DEF VAR cReturnValue AS CHAR NO-UNDO.
RUN ccb/d-motanu-2 (OUTPUT cReturnValue).
IF cReturnValue = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
/* ********************************************************************************** */
x-Rowid = ROWID(Ccbccaja).
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="Ccbccaja" ~
        &Alcance="FIRST" ~
        &Condicion="ROWID(Ccbccaja) = x-Rowid" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje"
        &TipoError="UNDO, LEAVE"}
    IF NOT {&Condicion} THEN DO:
        MESSAGE 'El I/C YA NO cumple las condiciones para ser anulado'
            VIEW-AS ALERT-BOX WARNING.
        UNDO, RETURN 'OK'.      /* REPINTAR LA PANTALLA */
    END.
    ASSIGN
        Ccbccaja.FlgEst = "A"
        CcbCCaja.FchAnu = TODAY
        CcbCCaja.HorAnu = STRING(TIME, 'HH:MM:SS')
        CcbCCaja.UsrAnu = s-user-id.
    FOR EACH Ccbdcaja OF Ccbccaja NO-LOCK,
        FIRST Ccbcdocu WHERE CcbCDocu.CodCia = Ccbdcaja.codcia AND
        CcbCDocu.CodDoc = Ccbdcaja.codref AND
        CcbCDocu.NroDoc = Ccbdcaja.nroref EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
        ASSIGN
            CcbCDocu.FlgEst = "A"
            CcbCDocu.UsuAnu = s-user-id
            CcbCDocu.FchAnu = TODAY
            CcbCDocu.HorCie = STRING(TIME,'HH:MM:SS').
        /* ********************************************************************************** */
        /* Extorna Salida de Almacen */
        /* ********************************************************************************** */
        RUN vta2/des_alm (ROWID(CcbCDocu)).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = "NO se pudo extornar los movimientos de almacén".
            UNDO RLOOP, LEAVE RLOOP.
        END.
        /* ********************************************************************************** */
        /* Extorno Ordenes de Despacho */
        /* ********************************************************************************** */
        FOR EACH Faccpedi WHERE Faccpedi.codcia = Ccbcdocu.codcia
            AND Faccpedi.coddiv = Ccbcdocu.coddiv
            AND Faccpedi.coddoc = Ccbcdocu.libre_c01
            AND Faccpedi.nroped = Ccbcdocu.libre_c02
            EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
            ASSIGN
                Faccpedi.FlgEst = "A".
            /* TRACKING */
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
        END.
        /* ********************************************************************************** */
        /* MOTIVO DE ANULACION */
        /* ********************************************************************************** */
        CREATE Ccbaudit.
        ASSIGN
            CcbAudit.CodCia = ccbcdocu.codcia
            CcbAudit.CodCli = ccbcdocu.codcli
            CcbAudit.CodDiv = ccbcdocu.coddiv
            CcbAudit.CodDoc = ccbcdocu.coddoc
            CcbAudit.CodMon = ccbcdocu.codmon
            CcbAudit.CodRef = cReturnValue
            CcbAudit.Evento = 'DELETE'
            CcbAudit.Fecha  = TODAY
            CcbAudit.Hora   = STRING(TIME, 'HH:MM')
            CcbAudit.ImpTot = ccbcdocu.sdoact
            CcbAudit.NomCli = ccbcdocu.nomcli
            CcbAudit.NroDoc = ccbcdocu.nrodoc
            CcbAudit.Usuario = s-user-id.
        /* ********************************************************************************** */
        /*DELETE Ccbdcaja.*/
    END.
    /* DOCUMENTOS ANEXOS */
    FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = Ccbccaja.codcia AND
        CcbCDocu.CodDiv = Ccbccaja.coddiv AND
        CcbCDocu.CodDoc = "CHC" AND 
        CcbCDocu.NroDoc = Ccbccaja.voucher[2]
        EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
        DELETE Ccbcdocu.
    END.
    FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = Ccbccaja.codcia AND
        CcbCDocu.CodDiv = Ccbccaja.coddiv AND
        CcbCDocu.CodDoc = "CHC" AND 
        CcbCDocu.NroDoc = Ccbccaja.voucher[3]
        EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
        DELETE Ccbcdocu.
    END.
    FOR EACH CCBDMOV WHERE CCBDMOV.CodCia = Ccbccaja.codcia AND
        CCBDMOV.CodDiv = Ccbccaja.coddiv AND
        CCBDMOV.CodRef = Ccbccaja.coddoc AND
        CCBDMOV.NroRef = Ccbccaja.nrodoc EXCLUSIVE-LOCK,
        FIRST CcbCDocu WHERE CcbCDocu.CodCia = CCBDMOV.CodCia AND 
        CcbCDocu.CodDoc = CCBDMOV.CodDoc AND
        CcbCDocu.NroDoc = CCBDMOV.NroDoc EXCLUSIVE-LOCK,
        FIRST FacDocum WHERE FacDocum.CodCia = Ccbccaja.CodCia AND
        FacDocum.CodDoc = CcbCDocu.CodDoc NO-LOCK 
        ON ERROR UNDO, THROW:
        IF FacDocum.TpoDoc THEN
            ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct - CCBDMOV.ImpTot.
        ELSE
            ASSIGN CcbCDocu.SdoAct = CcbCDocu.SdoAct + CCBDMOV.ImpTot.
        IF CcbCDocu.SdoAct = 0 THEN
            ASSIGN 
                CcbCDocu.FlgEst = "C"
                CcbCDocu.FchCan = TODAY.
        ELSE
            ASSIGN
                CcbCDocu.FlgEst = "P"
                CcbCDocu.FchCan = ?.
        DELETE CCBDMOV.
    END.
END.
IF pMensaje > '' THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Filtrar B-table-Win 
PROCEDURE Filtrar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pFchDoc-1 AS DATE.
DEF INPUT PARAMETER pFchDoc-2 AS DATE.
DEF INPUT PARAMETER pNomCli AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.

ASSIGN
    x-FchDoc-1 = (IF pFchDoc-1 = ? THEN x-FchDoc-1 ELSE pFchDoc-1)
    x-FchDoc-2 = (IF pFchDoc-2 = ? THEN x-FchDoc-2 ELSE pFchDoc-2)
    x-NomCli  = pNomCli
    x-CodRef = pCodDoc
    x-NroRef = pNroDoc.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpiar-Filtro B-table-Win 
PROCEDURE Limpiar-Filtro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

x-FchDoc-1 = ADD-INTERVAL(TODAY, -1, 'months').
x-FchDoc-2 = TODAY.
x-NomCli = ''.
x-CodRef = ''.
x-NroRef = ''.

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
  {src/adm/template/snd-list.i "CcbCCaja"}

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

