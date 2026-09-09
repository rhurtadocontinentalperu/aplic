&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
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

DEF SHARED VAR s-CodDoc AS CHAR INIT "O/D".
DEF SHARED VAR s-TpoPed AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEFINE VAR pNroOD AS CHAR INIT ''.

DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-DPEDI FOR Facdpedi.


DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR pMensaje2 AS CHAR NO-UNDO.

DEFINE BUFFER x-vtacdocu FOR vtacdocu.

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
FacCPedi.FchPed FacCPedi.NomCli GN-DIVI.DesDiv FacCPedi.Libre_c02 ~
FacCPedi.Libre_c03 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND FacCPedi.CodCia = s-codcia ~
 AND FacCPedi.DivDes = s-coddiv ~
 AND FacCPedi.CodDoc = s-CodDoc ~
 AND FacCPedi.TpoPed = s-TpoPed ~
 and (pNroOD = "" or faccpedi.nroped = pNroOD) ~
 AND FacCPedi.FlgEst = "P" NO-LOCK, ~
      EACH GN-DIVI OF FacCPedi NO-LOCK ~
    BY FacCPedi.NomCli
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND FacCPedi.CodCia = s-codcia ~
 AND FacCPedi.DivDes = s-coddiv ~
 AND FacCPedi.CodDoc = s-CodDoc ~
 AND FacCPedi.TpoPed = s-TpoPed ~
 and (pNroOD = "" or faccpedi.nroped = pNroOD) ~
 AND FacCPedi.FlgEst = "P" NO-LOCK, ~
      EACH GN-DIVI OF FacCPedi NO-LOCK ~
    BY FacCPedi.NomCli.
&Scoped-define TABLES-IN-QUERY-br_table FacCPedi GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table GN-DIVI


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
     "Nro de O/D" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 3.62 COL 111.43 WIDGET-ID 4
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
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.FacCPedi,INTEGRAL.GN-DIVI OF INTEGRAL.FacCPedi"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ","
     _OrdList          = "INTEGRAL.FacCPedi.NomCli|yes"
     _Where[1]         = "INTEGRAL.FacCPedi.CodCia = s-codcia
 AND INTEGRAL.FacCPedi.DivDes = s-coddiv
 AND INTEGRAL.FacCPedi.CodDoc = s-CodDoc
 AND FacCPedi.TpoPed = s-TpoPed
 and (pNroOD = """" or integral.faccpedi.nroped = pNroOD)
 AND INTEGRAL.FacCPedi.FlgEst = ""P"""
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
            AND B-DPedi.Libre_c05 = FacDPedi.Libre_c05:
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
/*           IF NOT CAN-FIND(FIRST B-DPEDI OF B-CPEDI WHERE B-DPEDI.CanAte <> 0 NO-LOCK) */
/*               THEN B-CPedi.FlgEst = pFlgEst.     /* Generado */                       */
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

IF FacCPedi.FlgEst <> "P" THEN DO:
    MESSAGE 'La Orden NO está pendiente' SKIP 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
/* Por indicacion de Max Ramos, si la O/D tiene HPK */
FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                x-vtacdocu.codped = 'HPK' AND
                                x-vtacdocu.codref = Faccpedi.coddoc AND
                                x-vtacdocu.nroref = Faccpedi.nroped AND
                                x-vtacdocu.flgest <> 'A'
                                NO-LOCK NO-ERROR.
IF AVAILABLE x-vtacdocu THEN DO:
    MESSAGE 'La orden tiene HPK : ' + x-vtacdocu.nroped SKIP 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.

IF FacCPedi.FlgSit = "T" THEN DO:   /* En Picking */
    FIND FIRST Vtacdocu WHERE VtaCDocu.CodCia = Faccpedi.codcia
        AND VtaCDocu.CodPed = Faccpedi.coddoc
        AND VtaCDocu.NroPed BEGINS Faccpedi.nroped
        AND VtaCDocu.FlgSit = "P"
        NO-LOCK NO-ERROR.
    IF AVAILABLE Vtacdocu THEN DO:
        MESSAGE 'Picking en Proceso' SKIP 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
END.
FIND FIRST FacDPedi OF FacCPedi WHERE Facdpedi.canate > 0 NO-LOCK NO-ERROR.
IF AVAILABLE Facdpedi THEN DO:
    MESSAGE "No puede anular una orden con atenciones parciales" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia 
    AND Ccbcdocu.coddoc = "G/R"
    AND Ccbcdocu.codcli = Faccpedi.codcli
    AND Ccbcdocu.libre_c01 = Faccpedi.coddoc
    AND Ccbcdocu.libre_c02 = Faccpedi.nroped
    AND Ccbcdocu.flgest <> "A" 
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcdocu THEN DO:
    MESSAGE "La orden de despacho tiene una" Ccbcdocu.coddoc Ccbcdocu.nrodoc "activa"
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
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

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i
        &Tabla="B-CPEDI"
        &Condicion="ROWID(B-CPedi) = ROWID(FacCPedi)"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, LEAVE"
        }
    ASSIGN 
        B-CPedi.FlgEst = "A"
        B-CPedi.Glosa = " A N U L A D O".
    CASE TRUE:
        WHEN x-CrossDocking = YES THEN DO:
            FIND PEDIDO WHERE PEDIDO.codcia = s-codcia
                AND PEDIDO.coddoc = FacCPedi.CodRef
                AND PEDIDO.nroped = FacCPedi.NroRef
                AND PEDIDO.crossdocking = YES
                AND PEDIDO.flgest <> "A"
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE PEDIDO THEN DO:
                pMensaje = 'NO se encontró el documento: ' + FacCPedi.codref + ' ' + FacCPedi.nroref.
                UNDO, LEAVE.
            END.
            FIND CURRENT PEDIDO EXCLUSIVE-LOCK NO-ERROR.     /* BLOQUEAMOS */
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = FacCPedi.CodRef + " " + FacCPedi.NroRef + " en uso por otro usuario".
                UNDO, LEAVE.    
            END.
            /* ACTIVAMOS LA COTIZACION */
            RUN Actualiza-Pedido (-1,
                                  PEDIDO.CodRef,    /* COT */
                                  PEDIDO.NroRef, 
                                  "P").
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
            ASSIGN
                PEDIDO.FlgEst = "A"
                PEDIDO.FecAct = TODAY
                PEDIDO.UsrAct = s-user-id.
        END.
        OTHERWISE DO:
            RUN Actualiza-Pedido (-1, FacCPedi.CodRef, FacCPedi.NroRef, "G").
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE.
            RUN Anula-SubOrden.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE.
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
END.
IF AVAILABLE(PEDIDO) THEN RELEASE PEDIDO.
IF AVAILABLE(B-CPEDI) THEN RELEASE B-CPEDI.
IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
IF pMensaje2 > '' THEN MESSAGE pMensaje2 VIEW-AS ALERT-BOX INFORMATION.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  pNroOD = txtNumero.

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

