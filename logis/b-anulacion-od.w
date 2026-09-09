&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



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

DEF VAR s-CodDoc AS CHAR INIT "O/D".
DEF SHARED VAR s-user-id AS CHAR.

&SCOPED-DEFINE Condicion ( FacCPedi.CodCia = s-CodCia AND ~
FacCPedi.DivDes = s-CodDiv AND ~
FacCPedi.FlgEst = "P" AND ~
FacCPedi.CodDoc = s-CodDoc )

DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR pMensaje2 AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES FacCPedi GN-DIVI DI-RutaD

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.CodDoc FacCPedi.NroPed ~
FacCPedi.FchPed FacCPedi.NomCli GN-DIVI.DesDiv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST GN-DIVI OF FacCPedi NO-LOCK, ~
      EACH DI-RutaD WHERE DI-RutaD.CodCia = FacCPedi.CodCia ~
  AND DI-RutaD.CodRef = FacCPedi.CodDoc ~
  AND DI-RutaD.NroRef = FacCPedi.NroPed ~
      AND DI-RutaD.CodDoc = "PHR" ~
  NO-LOCK ~
    BY FacCPedi.NomCli
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST GN-DIVI OF FacCPedi NO-LOCK, ~
      EACH DI-RutaD WHERE DI-RutaD.CodCia = FacCPedi.CodCia ~
  AND DI-RutaD.CodRef = FacCPedi.CodDoc ~
  AND DI-RutaD.NroRef = FacCPedi.NroPed ~
      AND DI-RutaD.CodDoc = "PHR" ~
  NO-LOCK ~
    BY FacCPedi.NomCli.
&Scoped-define TABLES-IN-QUERY-br_table FacCPedi GN-DIVI DI-RutaD
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table GN-DIVI
&Scoped-define THIRD-TABLE-IN-QUERY-br_table DI-RutaD


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
      FacCPedi, 
      GN-DIVI
    FIELDS(GN-DIVI.DesDiv), 
      DI-RutaD
    FIELDS() SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.CodDoc FORMAT "x(3)":U
      FacCPedi.NroPed COLUMN-LABEL "Número" FORMAT "XXX-XXXXXX":U
            WIDTH 9.57
      FacCPedi.FchPed COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
      FacCPedi.NomCli FORMAT "x(60)":U WIDTH 57
      GN-DIVI.DesDiv COLUMN-LABEL "Origen" FORMAT "X(40)":U WIDTH 30.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 118 BY 11.31
         FONT 4 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


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
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
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
         HEIGHT             = 12.12
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
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.FacCPedi,INTEGRAL.GN-DIVI OF INTEGRAL.FacCPedi,INTEGRAL.DI-RutaD WHERE INTEGRAL.FacCPedi ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST USED, USED"
     _OrdList          = "INTEGRAL.FacCPedi.NomCli|yes"
     _Where[1]         = "{&Condicion}"
     _JoinCode[3]      = "DI-RutaD.CodCia = FacCPedi.CodCia
  AND DI-RutaD.CodRef = FacCPedi.CodDoc
  AND DI-RutaD.NroRef = FacCPedi.NroPed"
     _Where[3]         = "DI-RutaD.CodDoc = ""PHR""
 "
     _FldNameList[1]   = INTEGRAL.FacCPedi.CodDoc
     _FldNameList[2]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Número" "XXX-XXXXXX" "character" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Fecha" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" "Origen" ? "character" ? ? ? ? ? ? no ? no no "30.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON FIND OF DI-RutaD DO:
    IF NOT CAN-FIND(FIRST DI-RUTAC OF DI-RUTAD WHERE LOOKUP(DI-RUTAC.FLGEST, 'PX,PC') > 0 NO-LOCK)
        THEN RETURN ERROR.
END.

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
      FOR EACH FacdPedi OF FaccPedi NO-LOCK,
          FIRST B-DPedi OF B-CPedi EXCLUSIVE-LOCK WHERE B-DPedi.CodMat = FacDPedi.CodMat
            AND B-DPedi.Libre_c05 = FacDPedi.Libre_c05 ON ERROR UNDO, THROW:
          ASSIGN
              B-DPEDI.CanAte = B-DPEDI.CanAte + x-Tipo * (FacDPedi.CanPed - FacDPedi.CanAte).
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
      IF AVAILABLE B-DPEDI THEN RELEASE B-DPedi.
  END.

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

IF NOT AVAILABLE Faccpedi THEN RETURN.

MESSAGE 'Continuamos con la anulación del' faccpedi.coddoc faccpedi.nroped 
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN "ADM-ERROR".

/* Si la O/D es del Cross Docking */
DEF VAR x-LocalXD AS LOG INIT NO NO-UNDO.
DEF VAR x-CrossDocking AS LOG INIT NO NO-UNDO.
IF Faccpedi.CodRef = "PED" AND Faccpedi.CrossDocking = NO AND Faccpedi.TpoPed = "XD" THEN DO:
    MESSAGE "Esta Orden ha sido generada automáticamente de un Cross Docking" SKIP
        "Devolvemos la mercadería?" SKIP(1)
        "SI: Se generará una OTR automática al almacén de origen" SKIP
        "NO: La mercadería será transferida al almacén principal" 
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE x-LocalXD.
    IF x-LocalXD = ? THEN RETURN 'ADM-ERROR'.
    x-CrossDocking = YES.
END.

DEF VAR x-Rowid AS ROWID NO-UNDO.
DEF VAR pCuenta AS INT NO-UNDO.

x-Rowid = ROWID(Faccpedi).
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i
        &Tabla="Faccpedi"
        &Condicion="ROWID(Faccpedi) = x-Rowid"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, LEAVE"
        }
    /* Consistencia Final */
    IF NOT (Faccpedi.FlgEst = "P") THEN DO:
        pMensaje = "La O/D ya NO se puede anular".
        UNDO, LEAVE.
    END.
    ASSIGN 
        Faccpedi.FlgEst = "A"
        Faccpedi.Glosa = " A N U L A D O".
    /* Eliminamos la O/D de la PHR */
    FOR EACH DI-RutaD EXCLUSIVE-LOCK WHERE DI-RutaD.CodCia = FacCPedi.CodCia
        AND DI-RutaD.CodRef = FacCPedi.CodDoc   /* O/D */
        AND DI-RutaD.NroRef = FacCPedi.NroPed
        AND DI-RutaD.CodDoc = "PHR",
        FIRST DI-RutaC OF DI-RutaD NO-LOCK ON ERROR UNDO, THROW:
        IF NOT LOOKUP(DI-RUTAC.FLGEST, 'PX,PC') > 0 THEN DO:
            pMensaje = "La PHR " + DI-RutaC.NroDoc + " ha seguido su trámite" + CHR(10) +
                "La O/D ya NO se puede anular".
            UNDO PRINCIPAL, LEAVE PRINCIPAL.
        END.
        DELETE DI-RutaD.
    END.
    /* Eliminamos el PED relacionado y actualizamos saldo en la COT */
    CASE TRUE:
        WHEN x-CrossDocking = YES THEN DO:
            FIND PEDIDO WHERE PEDIDO.codcia = s-codcia
                AND PEDIDO.coddoc = FacCPedi.CodRef
                AND PEDIDO.nroped = FacCPedi.NroRef
                AND PEDIDO.crossdocking = YES
                AND PEDIDO.flgest <> "A"
                EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                {lib/mensaje-de-error.i ~
                    &CuentaError="pCuenta" ~    /* OPCIONAL */
                    &MensajeError="pMensaje" ~
                    }
                UNDO, LEAVE.    
            END.
            /* ACTIVAMOS LA COTIZACION */
            RUN Actualiza-Pedido (-1,
                                  PEDIDO.CodRef,    /* COT */
                                  PEDIDO.NroRef, 
                                  "P").             /* La cotización regresa a Pendiente */
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE.
            /* Genera dos tipos de movimientos 
            Si x-LocalXD = YES entonces genera una nueva OTR por la devolución 
            Si x-LocalXD = NO  entonces genera una salida e ingreso por transferencia
            */
            RUN gn/p-anula-od-xd.p (INPUT ROWID(Faccpedi),
                                    INPUT x-LocalXD,
                                    OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                IF TRUE <> (pMensaje > '') THEN pMensaje = "ERROR en la anulación por Cross Docking".
                UNDO, LEAVE.
            END.
            ELSE DO:
                pMensaje2 = pMensaje.
                pMensaje = "".
            END.
            /* RHC 16/07/2018 ANULAMOS EL PEDIDO */
        END.
        OTHERWISE DO:
            FIND PEDIDO WHERE PEDIDO.codcia = s-codcia
                AND PEDIDO.coddoc = FacCPedi.CodRef
                AND PEDIDO.nroped = FacCPedi.NroRef
                EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                {lib/mensaje-de-error.i ~
                    &CuentaError="pCuenta" ~    /* OPCIONAL */
                    &MensajeError="pMensaje" ~
                    }
                UNDO, LEAVE.    
            END.
            /* ACTIVAMOS LA COTIZACION */
            RUN Actualiza-Pedido (-1,
                                  PEDIDO.CodRef,    /* COT */
                                  PEDIDO.NroRef, 
                                  "P").             /* La cotización regresa a Pendiente */
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE.
            
            /* NO hay suborden, solo HPK */
/*             RUN Anula-SubOrden.                             */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE. */
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
    END CASE.
    ASSIGN
        PEDIDO.FlgEst = "A"
        PEDIDO.FecAct = TODAY
        PEDIDO.UsrAct = s-user-id.
END.
FIND CURRENT Faccpedi NO-LOCK NO-ERROR.
IF AVAILABLE(PEDIDO) THEN RELEASE PEDIDO.
IF AVAILABLE(B-CPEDI) THEN RELEASE B-CPEDI.
IF AVAILABLE(B-DPEDI) THEN RELEASE B-DPEDI.
IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
IF pMensaje2 > '' THEN MESSAGE pMensaje2 VIEW-AS ALERT-BOX INFORMATION.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anula-Orden-Fraccionada B-table-Win 
PROCEDURE Anula-Orden-Fraccionada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
   FOR EACH FacdPedi OF FaccPedi NO-LOCK:
       FIND B-DPedi WHERE B-DPedi.CodCia = faccPedi.CodCia 
           AND B-DPedi.CodDiv = FacCPedi.CodDiv
           AND B-DPedi.CodDoc = FacCPedi.Libre_c02      /* O/D */
           AND B-DPedi.NroPed = FacCPedi.Libre_c03
           AND B-DPedi.CodMat = FacDPedi.CodMat 
           EXCLUSIVE-LOCK NO-ERROR.
       IF NOT AVAILABLE B-DPEDI THEN UNDO, RETURN 'ADM-ERROR'.
       ASSIGN
           B-DPEDI.CanAte = B-DPEDI.CanAte - FacDPedi.CanPed.
   END.
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
   FIND B-CPedi WHERE ROWID(B-CPedi) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAILABLE B-CPEDI THEN UNDO, RETURN 'ADM-ERROR'.
   ASSIGN 
       B-CPedi.FlgEst = "A"
       B-CPedi.Glosa = " A N U L A D O".
   RELEASE B-CPedi.
   RELEASE B-DPedi.
END.
RETURN "OK".    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anula-Orden-Normal B-table-Win 
PROCEDURE Anula-Orden-Normal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
   RUN Actualiza-Pedido (-1).
   IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
   RUN Anula-SubOrden.
   IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
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
RETURN "OK".    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anula-SubOrden B-table-Win 
PROCEDURE Anula-SubOrden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Borramos si hubiera una anterior */
pMensaje = "NO se pudo anular las sub-ordenes relacionadas".
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH Vtacdocu EXCLUSIVE-LOCK WHERE VtaCDocu.CodCia = Faccpedi.codcia
        AND VtaCDocu.CodPed = Faccpedi.coddoc
        AND VtaCDocu.NroPed BEGINS Faccpedi.nroped:
        ASSIGN 
            Vtacdocu.FlgEst = "A".
    END.
END.
pMensaje = "".
IF AVAILABLE(Vtacdocu) THEN RELEASE Vtacdocu.
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
  {src/adm/template/snd-list.i "DI-RutaD"}

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

