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

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR x-Moneda AS CHAR NO-UNDO.
DEF VAR x-CodCli AS CHAR NO-UNDO.
DEF VAR x-NroSer AS INTE NO-UNDO.
DEF VAR x-InvoiceCustomerGroup LIKE Faccpedi.InvoiceCustomerGroup NO-UNDO.
/*DEF VAR pMensaje AS CHAR NO-UNDO.*/

&SCOPED-DEFINE Condicion ( CcbCDocu.CodCia = s-CodCia AND ~
    CcbCDocu.CodDoc = "FAI" AND ~
    CcbCDocu.CodCli = x-CodCli AND ~
    CcbCDocu.FlgEst = 'P' )

/*DEF VAR iCountGuide AS INTEGER NO-UNDO.*/
DEFINE VAR x-articulo-ICBPER AS CHAR.
x-articulo-ICBPER = "099268".

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
&Scoped-define INTERNAL-TABLES CcbCDocu PEDIDO COTIZACION

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.FchDoc (IF CcbCDocu.CodMon = 1 THEN 'S/' ELSE 'US$') @ x-Moneda ~
CcbCDocu.ImpTot COTIZACION.CustomerPurchaseOrder COTIZACION.CustomerRequest 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH CcbCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST PEDIDO WHERE PEDIDO.CodCia = CcbCDocu.CodCia ~
  AND PEDIDO.CodDoc = CcbCDocu.CodPed ~
  AND PEDIDO.NroPed = CcbCDocu.NroPed NO-LOCK, ~
      FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia ~
  AND COTIZACION.CodDoc = PEDIDO.CodRef ~
  AND COTIZACION.NroPed = PEDIDO.NroRef ~
      AND COTIZACION.InvoiceCustomerGroup = x-InvoiceCustomerGroup NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST PEDIDO WHERE PEDIDO.CodCia = CcbCDocu.CodCia ~
  AND PEDIDO.CodDoc = CcbCDocu.CodPed ~
  AND PEDIDO.NroPed = CcbCDocu.NroPed NO-LOCK, ~
      FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia ~
  AND COTIZACION.CodDoc = PEDIDO.CodRef ~
  AND COTIZACION.NroPed = PEDIDO.NroRef ~
      AND COTIZACION.InvoiceCustomerGroup = x-InvoiceCustomerGroup NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table CcbCDocu PEDIDO COTIZACION
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-br_table PEDIDO
&Scoped-define THIRD-TABLE-IN-QUERY-br_table COTIZACION


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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-Total AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "TOTAL:" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 14 FGCOLOR 0 FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCDocu, 
      PEDIDO, 
      COTIZACION SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbCDocu.CodDoc FORMAT "x(3)":U
      CcbCDocu.NroDoc FORMAT "X(12)":U
      CcbCDocu.FchDoc FORMAT "99/99/9999":U
      (IF CcbCDocu.CodMon = 1 THEN 'S/' ELSE 'US$') @ x-Moneda COLUMN-LABEL "Moneda"
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U
      COTIZACION.CustomerPurchaseOrder FORMAT "x(20)":U
      COTIZACION.CustomerRequest FORMAT "x(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 76 BY 18.58
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-Total AT ROW 19.85 COL 27 COLON-ALIGNED WIDGET-ID 2
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
         WIDTH              = 76.
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
     _TblList          = "INTEGRAL.CcbCDocu,PEDIDO WHERE INTEGRAL.CcbCDocu ...,COTIZACION WHERE PEDIDO ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "PEDIDO.CodCia = CcbCDocu.CodCia
  AND PEDIDO.CodDoc = CcbCDocu.CodPed
  AND PEDIDO.NroPed = CcbCDocu.NroPed"
     _JoinCode[3]      = "COTIZACION.CodCia = PEDIDO.CodCia
  AND COTIZACION.CodDoc = PEDIDO.CodRef
  AND COTIZACION.NroPed = PEDIDO.NroRef"
     _Where[3]         = "COTIZACION.InvoiceCustomerGroup = x-InvoiceCustomerGroup"
     _FldNameList[1]   = INTEGRAL.CcbCDocu.CodDoc
     _FldNameList[2]   = INTEGRAL.CcbCDocu.NroDoc
     _FldNameList[3]   = INTEGRAL.CcbCDocu.FchDoc
     _FldNameList[4]   > "_<CALC>"
"(IF CcbCDocu.CodMon = 1 THEN 'S/' ELSE 'US$') @ x-Moneda" "Moneda" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.CcbCDocu.ImpTot
     _FldNameList[6]   = Temp-Tables.COTIZACION.CustomerPurchaseOrder
     _FldNameList[7]   = Temp-Tables.COTIZACION.CustomerRequest
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
FOR EACH Cabecera-FAC:
    x-ImpTot = Cabecera-FAC.ImpTot.
    FOR EACH Cabecera-FAI WHERE Cabecera-FAI.SdoAct > 0:
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
            FIND FIRST Cabecera-FAI.
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
                Ccbcdocu.NroRef = ""
                Ccbcdocu.Libre_c05 = "".
            FOR EACH Cabecera-FAI:
                Ccbcdocu.Libre_c05 = Ccbcdocu.Libre_c01 + (IF Ccbcdocu.NroRef = '' THEN '' ELSE '|') + Cabecera-FAI.NroDoc. 
            END.
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
            RUN proc_GrabaTotales.
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
        /* Marcamos los FAI como cancelados */
        ASSIGN
            Ccbcdocu.FlgEst = "C"
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Filtros B-table-Win 
PROCEDURE Carga-Filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pInvoiceCustomerGroup AS CHAR.
DEF INPUT PARAMETER pNroSer AS INTE.

ASSIGN
    x-CodCli = pCodCli
    x-NroSer = pNroSer
    x-InvoiceCustomerGroup = pInvoiceCustomerGroup.

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
    /* *************************************************************************** */
    /* Cargamos el temporal de control */
    /* *************************************************************************** */
    EMPTY TEMP-TABLE T-CDOCU.
    GET FIRST {&browse-name}.
    REPEAT WHILE AVAILABLE Ccbcdocu:
        IF NOT {&Condicion} THEN NEXT.
        CREATE T-CDOCU.
        BUFFER-COPY Ccbcdocu TO T-CDOCU.
        GET NEXT {&browse-name}.
    END.
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
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
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

  /* RHC 01/08/2019 Rutina General */
  {vtagn/i-total-factura.i &Cabecera="Ccbcdocu" &Detalle="Ccbddocu"}
  /*{vta2/graba-totales-factura-cred.i}*/

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

