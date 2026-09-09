&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE TEMP-TABLE Cabecera-FAC NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE Cabecera-FAI NO-UNDO LIKE CcbCDocu.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE TEMP-TABLE Detalle NO-UNDO LIKE CcbDDocu
       FIELD CodMon LIKE Ccbcdocu.CodMon
       FIELD TpoCmb LIKE Ccbcdocu.TpoCmb.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE T-CDOCU NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.



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

&SCOPED-DEFINE ARITMETICA-SUNAT YES

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR x-Moneda AS CHAR NO-UNDO.
DEF VAR x-CodCli AS CHAR NO-UNDO.
DEF VAR x-NroSer AS INTE NO-UNDO.
DEF VAR x-InvoiceCustomerGroup LIKE Faccpedi.InvoiceCustomerGroup NO-UNDO.


DEFINE VAR x-articulo-ICBPER AS CHAR.
x-articulo-ICBPER = "099268".

DEFINE VAR x-Grupo AS CHAR NO-UNDO.

DEF TEMP-TABLE Reporte
    FIELD Puntos AS INTE FORMAT '>>>9' LABEL 'Item'
    FIELD CodDoc AS CHAR FORMAT 'x(3)' LABEL 'Codigo'
    FIELD NroDoc AS CHAR FORMAT 'x(12)' LABEL 'Numero'
    FIELD FchDoc AS DATE FORMAT '99/99/9999' LABEL 'Fecha de Emision' 
    FIELD FchVto AS DATE FORMAT '99/99/9999' LABEL 'Fecha de salida'
    FIELD Moneda AS CHAR FORMAT 'x(10)' LABEL 'Moneda'
    FIELD ImpTot AS DECI FORMAT '>>>,>>>,>>9.99' LABEL 'Importe Total'
    FIELD InvoiceCustomerGroup AS CHAR FORMAT 'x(20)' LABEL 'Grupo de Factura de Cliente'
    FIELD CustomerPurchaseOrder AS CHAR FORMAT 'x(20)' LABEL 'Pedido Compra'
    FIELD CustomerRequest AS CHAR FORMAT 'x(20)' LABEL 'Solicitud Pedido'
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
&Scoped-define INTERNAL-TABLES T-CDOCU CcbCDocu PEDIDO COTIZACION

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-CDOCU.puntos CcbCDocu.CodDoc ~
CcbCDocu.NroDoc CcbCDocu.FchDoc T-CDOCU.FchVto ~
(IF CcbCDocu.CodMon = 1 THEN 'S/' ELSE 'US$') @ x-Moneda CcbCDocu.ImpTot ~
fCentrar()  @ x-Grupo COTIZACION.CustomerPurchaseOrder ~
COTIZACION.CustomerRequest 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH T-CDOCU WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST CcbCDocu OF T-CDOCU  NO-LOCK, ~
      FIRST PEDIDO WHERE PEDIDO.CodCia = CcbCDocu.CodCia ~
  AND PEDIDO.CodDoc = CcbCDocu.CodPed ~
  AND PEDIDO.NroPed = CcbCDocu.NroPed NO-LOCK, ~
      FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia ~
  AND COTIZACION.CodDoc = PEDIDO.CodRef ~
  AND COTIZACION.NroPed = PEDIDO.NroRef NO-LOCK ~
    BY T-CDOCU.puntos
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-CDOCU WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST CcbCDocu OF T-CDOCU  NO-LOCK, ~
      FIRST PEDIDO WHERE PEDIDO.CodCia = CcbCDocu.CodCia ~
  AND PEDIDO.CodDoc = CcbCDocu.CodPed ~
  AND PEDIDO.NroPed = CcbCDocu.NroPed NO-LOCK, ~
      FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia ~
  AND COTIZACION.CodDoc = PEDIDO.CodRef ~
  AND COTIZACION.NroPed = PEDIDO.NroRef NO-LOCK ~
    BY T-CDOCU.puntos.
&Scoped-define TABLES-IN-QUERY-br_table T-CDOCU CcbCDocu PEDIDO COTIZACION
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-CDOCU
&Scoped-define SECOND-TABLE-IN-QUERY-br_table CcbCDocu
&Scoped-define THIRD-TABLE-IN-QUERY-br_table PEDIDO
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table COTIZACION


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Total 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCentrar B-table-Win 
FUNCTION fCentrar RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-Total AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "TOTAL" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 14 FGCOLOR 0 FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-CDOCU, 
      CcbCDocu, 
      PEDIDO, 
      COTIZACION SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-CDOCU.puntos COLUMN-LABEL "Item" FORMAT ">>>9":U
      CcbCDocu.CodDoc FORMAT "x(3)":U
      CcbCDocu.NroDoc FORMAT "X(12)":U
      CcbCDocu.FchDoc COLUMN-LABEL "Fecha de!Emisión" FORMAT "99/99/9999":U
      T-CDOCU.FchVto COLUMN-LABEL "Fecha de!Salida" FORMAT "99/99/9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      (IF CcbCDocu.CodMon = 1 THEN 'S/' ELSE 'US$') @ x-Moneda COLUMN-LABEL "Moneda"
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U
      fCentrar()  @ x-Grupo COLUMN-LABEL "Grupo de Factura!de Cliente" FORMAT "x(20)":U
            WIDTH 12 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      COTIZACION.CustomerPurchaseOrder FORMAT "x(20)":U
      COTIZACION.CustomerRequest FORMAT "x(20)":U WIDTH 4.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 105 BY 18.58
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-Total AT ROW 19.85 COL 41 COLON-ALIGNED WIDGET-ID 2
     "Doble ~"clic~" para mostrar las G/R" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 19.85 COL 1 WIDGET-ID 4
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
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: Cabecera-FAC T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: Cabecera-FAI T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: Detalle T "?" NO-UNDO INTEGRAL CcbDDocu
      ADDITIONAL-FIELDS:
          FIELD CodMon LIKE Ccbcdocu.CodMon
          FIELD TpoCmb LIKE Ccbcdocu.TpoCmb
      END-FIELDS.
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: T-CDOCU T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
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
         HEIGHT             = 19.85
         WIDTH              = 106.
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

/* SETTINGS FOR FILL-IN FILL-IN-Total IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-CDOCU,INTEGRAL.CcbCDocu OF Temp-Tables.T-CDOCU ,PEDIDO WHERE INTEGRAL.CcbCDocu ...,COTIZACION WHERE PEDIDO ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST, FIRST, FIRST"
     _OrdList          = "Temp-Tables.T-CDOCU.puntos|yes"
     _JoinCode[3]      = "PEDIDO.CodCia = INTEGRAL.CcbCDocu.CodCia
  AND PEDIDO.CodDoc = INTEGRAL.CcbCDocu.CodPed
  AND PEDIDO.NroPed = INTEGRAL.CcbCDocu.NroPed"
     _JoinCode[4]      = "COTIZACION.CodCia = PEDIDO.CodCia
  AND COTIZACION.CodDoc = PEDIDO.CodRef
  AND COTIZACION.NroPed = PEDIDO.NroRef"
     _FldNameList[1]   > Temp-Tables.T-CDOCU.puntos
"T-CDOCU.puntos" "Item" ">>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.CcbCDocu.CodDoc
     _FldNameList[3]   = INTEGRAL.CcbCDocu.NroDoc
     _FldNameList[4]   > INTEGRAL.CcbCDocu.FchDoc
"CcbCDocu.FchDoc" "Fecha de!Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-CDOCU.FchVto
"T-CDOCU.FchVto" "Fecha de!Salida" ? "date" 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"(IF CcbCDocu.CodMon = 1 THEN 'S/' ELSE 'US$') @ x-Moneda" "Moneda" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.CcbCDocu.ImpTot
     _FldNameList[8]   > "_<CALC>"
"fCentrar()  @ x-Grupo" "Grupo de Factura!de Cliente" "x(20)" ? 14 0 ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   = Temp-Tables.COTIZACION.CustomerPurchaseOrder
     _FldNameList[10]   > Temp-Tables.COTIZACION.CustomerRequest
"COTIZACION.CustomerRequest" ? ? "character" ? ? ? ? ? ? no ? no no "4.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON LEFT-MOUSE-DBLCLICK OF br_table IN FRAME F-Main
DO:
  IF AVAILABLE T-CDOCU THEN
      RUN vtagn/d-gr-por-fais (INPUT CcbCDocu.CodDoc, INPUT CcbCDocu.NroDoc).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Cancelacion B-table-Win 
PROCEDURE Carga-Cancelacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-ImpTot AS DEC NO-UNDO.
FOR EACH Cabecera-FAI:
    Cabecera-FAI.SdoAct = Cabecera-FAI.ImpTot.
END.

FOR EACH Cabecera-FAC NO-LOCK:
    x-ImpTot = Cabecera-FAC.ImpTot.
    FOR EACH Cabecera-FAI EXCLUSIVE-LOCK WHERE Cabecera-FAI.SdoAct > 0:
        CREATE Ccbdcaja.
        ASSIGN
            CcbDCaja.CodCia = s-codcia
            CcbDCaja.CodDiv = s-coddiv
            CcbDCaja.CodDoc = Cabecera-FAC.coddoc
            CcbDCaja.NroDoc = Cabecera-FAC.nrodoc
            CcbDCaja.CodRef = Cabecera-FAI.coddoc
            CcbDCaja.NroRef = Cabecera-FAI.nrodoc
            CcbDCaja.CodCli = Cabecera-FAI.CodCli
            CcbDCaja.CodMon = Cabecera-FAI.codmon
            CcbDCaja.FchDoc = Cabecera-FAC.fchdoc
            CcbDCaja.ImpTot = MINIMUM(x-ImpTot, Cabecera-FAI.sdoact)
            CcbDCaja.TpoCmb = Cabecera-FAI.tpocmb.
        ASSIGN
            Cabecera-FAI.sdoact = Cabecera-FAI.sdoact - Ccbdcaja.imptot
            x-ImpTot = x-ImpTot - Ccbdcaja.imptot.
        IF x-ImpTot <= 0 THEN LEAVE.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Comprobantes B-table-Win 
PROCEDURE Carga-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT-OUTPUT PARAMETER iCountGuide AS INT NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR lCreaHeader AS LOG NO-UNDO.
DEF VAR lItemOk AS LOG NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR s-CodDoc AS CHAR INIT 'FAC' NO-UNDO.
DEF VAR x-FormatoFAC  AS CHAR INIT '999-99999999' NO-UNDO.
DEF VAR x-FormatoGUIA AS CHAR INIT '999-999999' NO-UNDO.
DEF VAR iCountItem AS INT NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-FormatoFAC).
RUN sunat\p-formato-doc (INPUT "G/R", OUTPUT x-FormatoGUIA).

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /*iCountGuide = 0.*/
    lCreaHeader = TRUE.
    lItemOk = FALSE.
    iCountItem = 1.
    /* Correlativo */
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = s-CodCia AND ~
        FacCorre.CodDoc = s-CodDoc AND ~
        FacCorre.CodDiv = s-CodDiv AND ~
        FacCorre.NroSer = x-NroSer" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje= "pMensaje" ~
        &TipoError="UNDO TRLOOP, RETURN 'ADM-ERROR'"}
    FOR EACH Detalle , FIRST Almmmatg OF Detalle NO-LOCK BREAK BY Detalle.CodCia:
        /* Crea Cabecera */
        IF lCreaHeader THEN DO:
            /* Cabecera de Guía */
            FIND FIRST Cabecera-FAI.    /* Se toma el primero como plantilla */
            CREATE CcbCDocu.
            BUFFER-COPY Cabecera-FAI TO Ccbcdocu
                ASSIGN
                CcbCDocu.CodCia = s-codcia
                CcbCDocu.CodDiv = s-coddiv
                CcbCDocu.CodDoc = s-CodDoc
                CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,ENTRY(1,x-FormatoFAC,'-')) + 
                            STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoFAC,'-')) 
                CcbCDocu.FchDoc = TODAY
                CcbCDocu.FchVto = TODAY
                CcbCDocu.FlgEst = "P"
                CcbCDocu.Tipo   = "CREDITO"
                CcbCDocu.usuario = S-USER-ID
                CcbCDocu.HorCie = STRING(TIME,'hh:mm')
                CcbCDocu.CodMon = Detalle.CodMon
                CcbCDocu.TpoCmb = Detalle.TpoCmb
                NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                UNDO TRLOOP, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                CcbCDocu.TpoFac = "F"       /* POR FAI */
                Ccbcdocu.CodRef = "FAI"
                Ccbcdocu.NroRef = "".
            /* RHC 18/06/2020 NO va la referencia porque supera la capacidad del campo */
/*             FOR EACH Cabecera-FAI:                                                                                                */
/*                 Ccbcdocu.NroRef = Ccbcdocu.NroRef + (IF (TRUE <> (Ccbcdocu.NroRef > '')) THEN '' ELSE '|') + Cabecera-FAI.NroDoc. */
/*             END.                                                                                                                  */
            /* SOLO UNA GUIA */
            ASSIGN
                FacCorre.Correlativo = FacCorre.Correlativo + 1.
            /*RDP*/    
            FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
            IF AVAILABLE gn-convt THEN DO:
                CcbCDocu.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
                CcbCDocu.FchVto = CcbCDocu.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).
            END.
            /* **************** */
            ASSIGN
                iCountGuide = iCountGuide + 1
                lCreaHeader = FALSE.
            
            DEFINE BUFFER b-controlOD FOR controlOD.
            DEFINE VAR lRowId AS ROWID.

            /* Ic - 16Set2016, Actualizar el ControlOD del LPN de Plaza Vea */
            FOR EACH controlOD WHERE controlOD.codcia = s-codcia AND 
                controlOD.codcli = ccbcdocu.codcli AND 
                controlOD.OrdCmp = ccbcdocu.nroord NO-LOCK :
                lRowId = ROWID(controlOD).
                FIND FIRST b-controlOD WHERE ROWID(b-controlOD) = lRowId EXCLUSIVE NO-ERROR.
                IF AVAILABLE b-controlOD THEN DO:
                    ASSIGN
                        b-controlOD.nrofac = ccbcdocu.nrodoc
                        b-controlOD.fchfac = CcbCDocu.FchDoc
                        b-controlOD.usrfac = CcbCDocu.usuario.
                END.
            END.
            RELEASE b-controlOD.
        END.
        /* Crea Detalle */
        CREATE CcbDDocu.
        BUFFER-COPY Detalle 
            TO CcbDDocu
            ASSIGN
            CcbDDocu.NroItm = iCountItem
            CcbDDocu.CodCia = CcbCDocu.CodCia
            CcbDDocu.CodDiv = CcbcDocu.CodDiv
            CcbDDocu.Coddoc = CcbCDocu.Coddoc
            CcbDDocu.NroDoc = CcbCDocu.NroDoc 
            CcbDDocu.FchDoc = CcbCDocu.FchDoc.
        /* CORREGIMOS IMPORTES */
        ASSIGN
            Ccbddocu.ImpLin = ROUND ( Ccbddocu.CanDes * Ccbddocu.PreUni * 
                                      ( 1 - Ccbddocu.Por_Dsctos[1] / 100 ) *
                                      ( 1 - Ccbddocu.Por_Dsctos[2] / 100 ) *
                                      ( 1 - Ccbddocu.Por_Dsctos[3] / 100 ), 2 ).
        IF Ccbddocu.Por_Dsctos[1] = 0 AND Ccbddocu.Por_Dsctos[2] = 0 AND Ccbddocu.Por_Dsctos[3] = 0 
            THEN Ccbddocu.ImpDto = 0.
        ELSE Ccbddocu.ImpDto = Ccbddocu.CanDes * Ccbddocu.PreUni - Ccbddocu.ImpLin.
        ASSIGN
            Ccbddocu.ImpLin = ROUND(Ccbddocu.ImpLin, 2)
            Ccbddocu.ImpDto = ROUND(Ccbddocu.ImpDto, 2).
        IF Ccbddocu.AftIsc 
            THEN Ccbddocu.ImpIsc = ROUND(Ccbddocu.PreBas * Ccbddocu.CanDes * (Almmmatg.PorIsc / 100),4).
        ELSE Ccbddocu.ImpIsc = 0.
        IF Ccbddocu.AftIgv 
            THEN Ccbddocu.ImpIgv = Ccbddocu.ImpLin - ROUND( Ccbddocu.ImpLin  / ( 1 + (Ccbcdocu.PorIgv / 100) ), 4 ).
        ELSE Ccbddocu.ImpIgv = 0.
        lItemOk = TRUE.
        iCountItem = iCountItem + 1.
        IF LAST-OF(Detalle.CodCia) THEN DO:
            RUN proc_GrabaTotales (OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO TRLOOP, RETURN 'ADM-ERROR'.
            /* GENERACION DE CONTROL DE PERCEPCIONES */
            RUN vta2/control-percepcion-cargos (ROWID(Ccbcdocu)) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN 'ADM-ERROR'.
            /* ************************************* */
            /* RHC 30-11-2006 Transferencia Gratuita */
            IF Ccbcdocu.FmaPgo = '900' THEN Ccbcdocu.sdoact = 0.
            IF Ccbcdocu.sdoact <= 0 
            THEN ASSIGN
                    Ccbcdocu.fchcan = TODAY
                    Ccbcdocu.flgest = 'C'.
            /* *********************** */
            /* OJO: NO DESCARGA ALMACENES, YA LO HIZO EL FAI */
            /* *********************** */
            /* REGISTRO DE CONTROL */
            CREATE Cabecera-FAC.
            BUFFER-COPY Ccbcdocu TO Cabecera-FAC.
        END.
    END. /* FOR EACH Detalle */
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-FAI-ResumidoCM B-table-Win 
PROCEDURE Carga-FAI-ResumidoCM :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH T-CDOCU NO-LOCK, FIRST B-CDOCU OF T-CDOCU NO-LOCK:
        /* BLOQUEAMOS REGISTRO */
        {lib/lock-genericov3.i ~
            &Tabla="Ccbcdocu" ~
            &Condicion="ROWID(Ccbcdocu) = ROWID(B-CDOCU)" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TipoError="UNDO PRINCIPAL, RETURN 'ADM-ERROR'"}
        /* REGISTRO DE CONTROL */
        CREATE Cabecera-FAI.
        BUFFER-COPY Ccbcdocu TO Cabecera-FAI.
        /* ********************************************************************* */
        /* Marcamos los FAI como cancelados */
        /* ********************************************************************* */
        ASSIGN
            Ccbcdocu.FlgEst = "C"       /* <<<<<<<<< OJO <<<<<<<<< */
            Ccbcdocu.SdoAct = 0
            CcbCDocu.FchCan = TODAY
            CcbCDocu.UsrCobranza = s-user-id.
        /* ******************* */
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
            FIND Detalle WHERE Detalle.codmat = Ccbddocu.codmat NO-ERROR.
            IF NOT AVAILABLE Detalle THEN CREATE Detalle.
            ASSIGN
                Detalle.CodCia = Ccbcdocu.codcia
                Detalle.CodDiv = Ccbcdocu.coddiv
                Detalle.CodCli = Ccbcdocu.codcli
                Detalle.codmat = Ccbddocu.codmat
                Detalle.UndVta = Ccbddocu.undvta
                Detalle.AlmDes = Ccbddocu.almdes
                Detalle.AftIgv = Ccbddocu.aftigv
                Detalle.AftIsc = Ccbddocu.aftisc
                Detalle.CanDes = Detalle.CanDes + Ccbddocu.candes   /* OJO */
                Detalle.Factor = Ccbddocu.factor
                Detalle.ImpLin = Detalle.implin + Ccbddocu.implin   /* OJO */
                Detalle.PesMat = Detalle.PesMat + Ccbddocu.PesMat   /* OJO */
                Detalle.CodMon = Ccbcdocu.CodMon
                Detalle.TpoCmb = Ccbcdocu.TpoCmb.
            /* Recalculamos */
            ASSIGN
                Detalle.PreUni = Detalle.ImpLin / Detalle.CanDes
                Detalle.PreBas = Detalle.ImpLin / Detalle.CanDes.
            IF Detalle.AftIsc 
            THEN Detalle.ImpIsc = ROUND(Detalle.PreBas * Detalle.CanDes * (Almmmatg.PorIsc / 100),4).
            ELSE Detalle.ImpIsc = 0.
            IF Detalle.AftIgv 
            THEN Detalle.ImpIgv = Detalle.ImpLin - ROUND( Detalle.ImpLin  / ( 1 + (Ccbcdocu.PorIgv / 100) ), 4 ).
            ELSE Detalle.ImpIgv = 0.
        END.
    END.
END.
RETURN "OK".

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

DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pFchSal-1 AS DATE.
DEF INPUT PARAMETER pFchSal-2 AS DATE.

DEF VAR x-Orden AS INT NO-UNDO.

EMPTY TEMP-TABLE T-CDOCU.
/* Barremos todas las H/R cerradas y ese rango de fecha de salida */
SESSION:SET-WAIT-STATE('GENERAL').
x-Orden = 0.
FOR EACH DI-RutaC NO-LOCK WHERE DI-RutaC.CodCia = s-CodCia AND 
    DI-RutaC.CodDoc = "H/R" AND 
    DI-RutaC.FchSal >= pFchSal-1 AND
    DI-RutaC.FchSal <= pFchSal-2 AND
    DI-RutaC.FlgEst = "C",      /* Solo Cerradas */
    EACH DI-RutaD OF DI-RutaC NO-LOCK WHERE Di-RutaD.flgest = 'C',  /* Entregado */
    FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.CodCia = s-CodCia AND    
    B-CDOCU.CodDoc = DI-RutaD.CodRef AND                        /* G/R */ 
    B-CDOCU.NroDoc = DI-RutaD.NroRef AND
    B-CDOCU.CodRef = "FAI":                                     /* Solo G/R por FAI */
    /* Buscamos las FAIs */
    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-CodCia AND
        Ccbcdocu.CodDoc = B-CDOCU.CodRef AND                    /* FAIs */
        Ccbcdocu.NroDoc = B-CDOCU.NroRef AND
        Ccbcdocu.CodCli = pCodCli AND                           /* Cliente  */
        LOOKUP(Ccbcdocu.FlgEst, "C,A") = 0:                     /* ni CANCELADOS ni ANULADOS */
        CREATE T-CDOCU.
        BUFFER-COPY Ccbcdocu TO T-CDOCU
            ASSIGN
            T-CDOCU.FchVto = DI-RutaC.FchSal
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DELETE T-CDOCU.
        x-Orden = x-Orden + 1.
        ASSIGN
            T-CDOCU.Puntos = x-Orden.
    END.
END.
SESSION:SET-WAIT-STATE('').
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION B-table-Win 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR.
DEF INPUT-OUTPUT PARAMETER iCountGuide AS INT NO-UNDO.

TRLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    EMPTY TEMP-TABLE Cabecera-FAI.
    EMPTY TEMP-TABLE Cabecera-FAC.
    EMPTY TEMP-TABLE Detalle.
    /* ****************** 1ro. RESUMIMOS LOS FAI ******************* */
    /* Carga tabla Detalle */
    /* También CANCELA las FAIs */
    /* ************************************************************* */
    RUN Carga-FAI-ResumidoCM (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO TRLOOP, RETURN 'ADM-ERROR'.
    /* ************************************************************* */
    /* *********** 2do. GENERAMOS LOS COMPROBANTES ***************** */
    RUN Carga-Comprobantes (INPUT-OUTPUT iCountGuide, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
    /* ************************************************************* */
    /* ************** 3ro. REFERENCIA CRUZADA ********************** */
    RUN Referencia-Cruzada (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
    /* ************************************************************* */
    /* ************** 4to. CANCELAMOS LOS FAI ********************** */
    RUN Carga-Cancelacion.
    /* ************************************************************* */
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generacion-de-Factura B-table-Win 
PROCEDURE Generacion-de-Factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pNroSer AS INT.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER iCountGuide AS INT NO-UNDO.

ASSIGN
    x-NroSer = pNroSer
    iCountGuide = 0.
/* LOOP Principal */
LOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FIRST T-CDOCU NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-CDOCU THEN DO:
        pMensaje = "Fin de Archivo".
        UNDO LOOP, RETURN 'ADM-ERROR'.
    END.
    /* *************************************************************************** */
    /* Archivo de control */
    /* *************************************************************************** */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
    /* ************************************************************************************** */
    /* Generación de los comprobantes y del ingreso a caja con sus anexos */
    /* ************************************************************************************** */
    RUN FIRST-TRANSACTION (OUTPUT pMensaje, INPUT-OUTPUT iCountGuide).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
        UNDO LOOP, LEAVE LOOP.
    END.
    /* ************************************************************************************** */
    RUN SECOND-TRANSACTION (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo actualizar los datos en SUNAT" .
        UNDO LOOP, LEAVE LOOP.
    END.
    IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
        /* NO se detiene la grabación */
        pMensaje = ''.
    END.
END.
RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
IF pMensaje > '' THEN RETURN 'ADM-ERROR'.
ELSE RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temp-FeLogErrores B-table-Win 
PROCEDURE Graba-Temp-FeLogErrores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-FeLogErrores:
    CREATE FeLogErrores.
    BUFFER-COPY T-FeLogErrores TO FeLogErrores NO-ERROR.
    DELETE T-FeLogErrores.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Totales.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_GrabaTotales B-table-Win 
PROCEDURE proc_GrabaTotales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

{vtagn/i-total-factura.i &Cabecera="Ccbcdocu" &Detalle="Ccbddocu"}

/* ****************************************************************************************** */
/* Importes SUNAT */
/* ****************************************************************************************** */
&IF {&ARITMETICA-SUNAT} &THEN
    DEF VAR hProc AS HANDLE NO-UNDO.
    
    RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
    RUN tabla-ccbcdocu IN hProc (INPUT Ccbcdocu.CodDiv,
                                 INPUT Ccbcdocu.CodDoc,
                                 INPUT Ccbcdocu.NroDoc,
                                 OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
    DELETE PROCEDURE hProc.
&ENDIF
/* ****************************************************************************************** */
/* ****************************************************************************************** */
RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Referencia-Cruzada B-table-Win 
PROCEDURE Referencia-Cruzada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

TRLOOP:
FOR EACH Cabecera-FAC NO-LOCK:
    FOR EACH Cabecera-FAI NO-LOCK:
        {lib/lock-genericov3.i ~
            &Tabla="Ccbcdocu" ~
            &Condicion="Ccbcdocu.codcia = Cabecera-FAI.codcia AND ~
            Ccbcdocu.coddiv = Cabecera-FAI.coddiv AND ~
            Ccbcdocu.coddoc = Cabecera-FAI.coddoc AND ~
            Ccbcdocu.nrodoc = Cabecera-FAI.nrodoc" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje= "pMensaje" ~
            &TipoError="UNDO TRLOOP, RETURN 'ADM-ERROR'"}
         ASSIGN
            CcbCDocu.Libre_c03 = Cabecera-FAC.CodDoc
            CcbCDocu.Libre_c04 = Cabecera-FAC.NroDoc.
        RELEASE CcbCDocu.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SECOND-TRANSACTION B-table-Win 
PROCEDURE SECOND-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Segundo Generamos los comprobantes que faltan */
DEFINE VAR x-retval AS CHAR.

pMensaje = "".
EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
FOR EACH Cabecera-FAC NO-LOCK, FIRST Ccbcdocu OF Cabecera-FAC NO-LOCK:
    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
    RUN sunat\progress-to-ppll-v3 ( INPUT Ccbcdocu.CodDiv,
                                    INPUT Ccbcdocu.CodDoc,
                                    INPUT Ccbcdocu.NroDoc,
                                    INPUT-OUTPUT TABLE T-FELogErrores,
                                    OUTPUT pMensaje ).
    /* 2 tipos de errores:
        ADM-ERROR: Rechazo de BizzLinks
        ERROR-EPOS: No se pudo grabar en control de comprobante FELOgComprobantes */
    IF RETURN-VALUE <> "OK" THEN DO:
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR de ePos".
            RETURN "ADM-ERROR".
        END.
        IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
            IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR log de comprobantes".
            RETURN "ERROR-EPOS".
        END.
    END.
END.
RETURN 'OK'.

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
  {src/adm/template/snd-list.i "T-CDOCU"}
  {src/adm/template/snd-list.i "CcbCDocu"}
  {src/adm/template/snd-list.i "PEDIDO"}
  {src/adm/template/snd-list.i "COTIZACION"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto B-table-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR pOptions AS CHAR NO-UNDO.
    DEF VAR pArchivo AS CHAR NO-UNDO.

    DEF VAR OKpressed AS LOG.

    SYSTEM-DIALOG GET-FILE pArchivo
        FILTERS "Archivo txt" "*.txt"
        ASK-OVERWRITE
        CREATE-TEST-FILE
        DEFAULT-EXTENSION ".txt"
        SAVE-AS
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN NO-APPLY.

    ASSIGN
        pOptions = "FileType:TXT" + CHR(1) + ~
              "Grid:ver" + CHR(1) + ~
              "ExcelAlert:false" + CHR(1) + ~
              "ExcelVisible:false" + CHR(1) + ~
              "Labels:yes".


    /* Capturamos información de la cabecera y el detalle */
    EMPTY TEMP-TABLE Reporte.
    SESSION:SET-WAIT-STATE('').
    GET FIRST {&browse-name}.
    DO WHILE NOT QUERY-OFF-END('{&browse-name}'):
        CREATE Reporte.
        ASSIGN
            Reporte.Puntos = T-CDOCU.Puntos
            Reporte.CodDoc = Ccbcdocu.CodDoc
            Reporte.NroDoc = Ccbcdocu.NroDoc
            Reporte.FchDoc = Ccbcdocu.FchDoc
            Reporte.FchVto = T-CDOCU.FchVto
            Reporte.Moneda = (IF CcbCDocu.CodMon = 1 THEN 'S/' ELSE 'US$')
            Reporte.ImpTot = Ccbcdocu.ImpTot
            Reporte.InvoiceCustomerGroup = COTIZACION.InvoiceCustomerGroup
            Reporte.CustomerPurchaseOrder = COTIZACION.CustomerPurchaseOrder
            Reporte.CustomerRequest = COTIZACION.CustomerRequest
            .
        GET NEXT {&browse-name}.
    END.
    SESSION:SET-WAIT-STATE('').

    FIND FIRST Reporte NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Reporte THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    DEF VAR cArchivo AS CHAR NO-UNDO.
    /* El archivo se va a generar en un archivo temporal de trabajo antes
    de enviarlo a su directorio destino */
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN lib/tt-filev2 (TEMP-TABLE Reporte:HANDLE, cArchivo, pOptions).
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales B-table-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FILL-IN-Total = 0.
FOR EACH T-CDOCU NO-LOCK:
    FILL-IN-Total = FILL-IN-Total + T-CDOCU.ImpTot.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCentrar B-table-Win 
FUNCTION fCentrar RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR x-Var AS CHAR NO-UNDO.
RUN src/bin/_centrar (COTIZACION.InvoiceCustomerGroup, 20, OUTPUT x-Var).

  RETURN x-Var.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

