&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER DETALLE FOR FacDPedi.
DEFINE BUFFER ORDENES FOR FacCPedi.
DEFINE BUFFER PEDIDOS FOR FacCPedi.



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

DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-codcia AS INT.

DEF VAR x-Articulo-ICBPer AS CHAR.
x-articulo-ICBPER = '099268'.

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
&Scoped-define EXTERNAL-TABLES FacCPedi
&Scoped-define FIRST-EXTERNAL-TABLE FacCPedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCPedi.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacDPedi Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacDPedi.NroItm FacDPedi.codmat ~
Almmmatg.DesMat FacDPedi.CanPed FacDPedi.canate FacDPedi.UndVta ~
FacDPedi.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH FacDPedi OF FacCPedi WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF FacDPedi NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacDPedi OF FacCPedi WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF FacDPedi NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table FacDPedi Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacDPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


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
      FacDPedi, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacDPedi.NroItm FORMAT ">>9":U
      FacDPedi.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U WIDTH 9.29
      Almmmatg.DesMat FORMAT "X(60)":U
      FacDPedi.CanPed COLUMN-LABEL "Pedida" FORMAT ">,>>>,>>9.9999":U
      FacDPedi.canate COLUMN-LABEL "Atendida" FORMAT ">,>>>,>>9.9999":U
      FacDPedi.UndVta FORMAT "x(8)":U
      FacDPedi.ImpLin FORMAT "->>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 103 BY 11.31
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
   External Tables: INTEGRAL.FacCPedi
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: DETALLE B "?" ? INTEGRAL FacDPedi
      TABLE: ORDENES B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDOS B "?" ? INTEGRAL FacCPedi
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
         HEIGHT             = 11.65
         WIDTH              = 105.86.
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
     _TblList          = "INTEGRAL.FacDPedi OF INTEGRAL.FacCPedi,INTEGRAL.Almmmatg OF INTEGRAL.FacDPedi"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   = INTEGRAL.FacDPedi.NroItm
     _FldNameList[2]   > INTEGRAL.FacDPedi.codmat
"FacDPedi.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacDPedi.CanPed
"FacDPedi.CanPed" "Pedida" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacDPedi.canate
"FacDPedi.canate" "Atendida" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.FacDPedi.UndVta
     _FldNameList[7]   = INTEGRAL.FacDPedi.ImpLin
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Cot-Item B-table-Win 
PROCEDURE Actualiza-Cot-Item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.     /* PED */
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCanPed AS DEC.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

/* ACTUALIZA LA COTIZACION EN BASE AL PEDIDO AL CREDITO */
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER B-CPEDI FOR FacCPedi.

/* El pedido */
FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.  /* PED */
IF NOT AVAILABLE Faccpedi THEN DO:
    /*pError = "Error de puntero " + STRING(pRowid).*/
    RETURN 'ADM-ERROR'.
END.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos la cotizacion */
    {lib/lock-genericov3.i ~
        &Tabla="B-CPEDI" ~
        &Alcance="FIRST" ~
        &Condicion="B-CPedi.CodCia=FacCPedi.CodCia ~
                AND B-CPedi.CodDiv=FacCPedi.CodDiv ~
                AND B-CPedi.CodDoc=FacCPedi.CodRef ~        /* COT */
                AND B-CPedi.NroPed=FacCPedi.NroRef" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pError" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    /* SOLO ACTUALIZAMOS EL ARTICULO */
    /* BARREMOS EL PED*/
    FOR EACH B-DPedi OF B-CPedi WHERE B-DPedi.CodMat = pCodMat EXCLUSIVE-LOCK:
        B-DPedi.CanAte = B-DPedi.CanAte - pCanPed.
        IF B-DPEDI.CanAte < 0 THEN DO:
            pError = 'Se ha detectado un error al extornar el producto ' + B-DPEDI.codmat + CHR(10) +
                'Los despachos superan a lo cotizado' + CHR(10) +
                'Cant. cotizada: ' + STRING(B-DPEDI.CanPed, '->>>,>>9.99') + CHR(10) +
                'Total atendido: ' + STRING(B-DPEDI.CanAte, '->>>,>>9.99') + CHR(10) +
                'FIN DEL PROCESO'.
            UNDO PRINCIPAL, RETURN "ADM-ERROR".
        END.
    END.
END.
IF AVAILABLE B-CPEDI THEN RELEASE B-CPEDI.
IF AVAILABLE B-DPEDI THEN RELEASE B-DPEDI.

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "FacCPedi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacCPedi"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anular-Item B-table-Win 
PROCEDURE Anular-Item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

IF NOT AVAILABLE Faccpedi THEN RETURN 'OK'.

MESSAGE 'Confirmar la anulación del ITEM del PEDIDO' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN 'OK'.

DEFINE VAR pRowid AS ROWID NO-UNDO.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="PEDIDOS" ~
        &Alcance="FIRST" ~
        &Condicion="PEDIDOS.CodCia = Faccpedi.CodCia AND ~
        PEDIDOS.CodDiv = Faccpedi.CodDiv AND ~
        PEDIDOS.CodDoc = Faccpedi.CodDoc AND ~
        PEDIDOS.NroPed = Faccpedi.NroPed" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    ASSIGN
        pRowid = ROWID(PEDIDOS).
    /* Volvemos a verificar */    
    IF LOOKUP(PEDIDOS.FlgEst, 'G,P,C') = 0 THEN DO:
        pMensaje = 'Pedido NO válido' + CHR(10) + 'Proceso Abortado'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* No se puede anular si solo tiene un item */
    DEF VAR x-Items AS INT NO-UNDO.
    x-Items = 0.
    FOR EACH DETALLE OF PEDIDOS NO-LOCK:
        x-Items = x-Items + 1.
    END.
    IF x-Items < 2 THEN DO:
        pMensaje = "NO se puede anular el item porque es el único que tiene el pedido".
        UNDO, RETURN 'ADM-ERROR'.
    END.

    IF PEDIDOS.FlgEst = "C" THEN DO:
        /* Verificamos la O/D vs el Item */
        FOR EACH ORDENES NO-LOCK WHERE ORDENES.CodCia = PEDIDOS.CodCia AND
            ORDENES.CodDiv = PEDIDOS.CodDiv AND
            ORDENES.CodDoc = "O/D" AND
            ORDENES.CodRef = PEDIDOS.CodDoc AND
            ORDENES.NroRef = PEDIDOS.NroPed AND
            ORDENES.FlgEst <> "A",
            FIRST DETALLE OF ORDENES WHERE DETALLE.CodMat = Facdpedi.CodMat:
            IF NOT (ORDENES.FlgEst = 'P' AND ORDENES.FlgSit = 'T') THEN DO:
                pMensaje = 'Pedido NO válido' + CHR(10) + 
                    'La ' + ORDENES.CodDoc + ' ' + ORDENES.NroPed + ' ya está en proceso' + CHR(10) + 
                    'Proceso Abortado'.
                UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            END.
        END.
    END.

    /* Bloqueamos el Registro */
    FIND CURRENT Facdpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError= "pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    

    /* SI TIENE ORDEN DE DESPACHO ENTONCES ANULAMOS PRIMERO EL ITEM DE LA ORDEN */
    FOR EACH ORDENES NO-LOCK WHERE ORDENES.CodCia = PEDIDOS.CodCia AND
        ORDENES.CodDiv = PEDIDOS.CodDiv AND
        ORDENES.CodDoc = "O/D" AND
        ORDENES.CodRef = PEDIDOS.CodDoc AND     /* PED */
        ORDENES.NroRef = PEDIDOS.NroPed AND
        ORDENES.FlgEst <> 'A',
        FIRST DETALLE OF ORDENES WHERE DETALLE.CodMat = Facdpedi.CodMat:
        RUN Anular-Orden-Item (INPUT ROWID(ORDENES), INPUT DETALLE.CodMat, OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    
    
    /* Actualizamos Cotizacion */
    RUN Actualiza-Cot-Item (INPUT pRowid, 
                            INPUT Facdpedi.CodMat, 
                            INPUT Facdpedi.CanPed,
                            OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo extornar la Cotización".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    

    /* Borramos Registro */
    DELETE Facdpedi.

    

    /* TOTALES */
    {vtagn/graba-tot-cot-ped-od.i &Cabecera="PEDIDOS" &Detalle="Facdpedi"}

    
END.
IF AVAILABLE PEDIDOS THEN RELEASE PEDIDOS.
IF AVAILABLE ORDENES THEN RELEASE ORDENES.
IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anular-Orden-Item B-table-Win 
PROCEDURE Anular-Orden-Item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Solo se elimina el item
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pRowid AS ROWID NO-UNDO.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR pCuenta AS INT NO-UNDO.

pMensaje = ''.

DEF BUFFER B-CPEDI FOR Faccpedi.    /* la O/D*/
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

    FIND FIRST B-DPEDI OF B-CPEDI WHERE B-DPEDI.CodMat = pCodMat EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    DELETE B-DPEDI. /* Eliminamos el registro */

    {vtagn/graba-tot-cot-ped-od.i &Cabecera="B-CPEDI" &Detalle="B-DPEDI"}

END.
IF AVAILABLE(B-CPEDI) THEN RELEASE B-CPEDI.
IF AVAILABLE(B-DPEDI) THEN RELEASE B-DPEDI.

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
  {src/adm/template/snd-list.i "FacDPedi"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

