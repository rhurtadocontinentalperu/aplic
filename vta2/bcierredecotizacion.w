&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE COTIZACION NO-UNDO LIKE FacCPedi.
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.



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
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

&SCOPED-DEFINE Condicion Faccpedi.codcia = s-codcia ~
AND Faccpedi.coddiv = s-coddiv ~
AND Faccpedi.coddoc = "COT" ~
AND Faccpedi.flgest = "P" ~
AND Faccpedi.fchped >=  FILL-IN-FchPed-1 ~
AND Faccpedi.fchped <=  FILL-IN-FchPed-2 ~
AND Faccpedi.usuario = s-user-id ~
AND NOT CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate <> 0 NO-LOCK)

/* Vartiables para poder actualizar el detalle de la cotizacion */
DEF SHARED VAR pCodDiv  AS CHAR.
DEF SHARED VAR s-CodAlm AS CHAR.
DEF SHARED VAR s-DiasVtoCot     LIKE GN-DIVI.DiasVtoCot.
DEF SHARED VAR s-DiasAmpCot     LIKE GN-DIVI.DiasAmpCot.
DEF SHARED VAR s-FlgEmpaque     LIKE GN-DIVI.FlgEmpaque.
DEF SHARED VAR s-FlgMinVenta    LIKE GN-DIVI.FlgMinVenta.
DEF SHARED VAR s-FlgRotacion    LIKE GN-DIVI.FlgRotacion.
DEF SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEF SHARED VAR s-FlgTipoVenta   LIKE GN-DIVI.FlgPreVta.
DEF SHARED VAR s-MinimoPesoDia AS DEC.
DEF SHARED VAR s-MaximaVarPeso AS DEC.
DEF SHARED VAR s-MinimoDiasDespacho AS DEC.

DEF SHARED VAR s-TpoPed   AS CHAR.
DEF SHARED VAR S-CODCLI  AS CHAR.
DEF SHARED VAR S-CODMON  AS INTEGER.
DEF SHARED VAR S-FMAPGO  AS CHAR.
DEF SHARED VAR S-TPOCMB  AS DEC.
DEF SHARED VAR s-PorIgv LIKE Ccbcdocu.PorIgv.
DEF SHARED VAR s-nrodec AS INT.
DEF SHARED VAR S-CMPBNTE  AS CHAR.
DEF SHARED VAR S-TPOMARCO AS CHAR.      /* CASO DE CLIENTES EXCEPCIONALES */
DEF SHARED VAR s-cndvta-validos AS CHAR.

DEF SHARED VAR lh_Handle AS HANDLE.

DEF VAR s-import-ibc AS LOG.
DEF VAR s-import-cissac AS LOG.

DEF TEMP-TABLE ResumenxLinea
    FIELD codmat LIKE almmmatg.codmat
    FIELD codfam LIKE almmmatg.codfam
    FIELD subfam LIKE almmmatg.subfam
    FIELD canped LIKE facdpedi.canped
    INDEX Llave01 AS PRIMARY /*UNIQUE*/ codmat codfam subfam.

DEF TEMP-TABLE ErroresxLinea LIKE ResumenxLinea.

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
&Scoped-define INTERNAL-TABLES COTIZACION FacCPedi

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.usuario FacCPedi.FchPed ~
FacCPedi.fchven FacCPedi.CodDoc FacCPedi.NroPed FacCPedi.CodCli ~
FacCPedi.NomCli 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH COTIZACION WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH FacCPedi OF COTIZACION NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH COTIZACION WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH FacCPedi OF COTIZACION NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table COTIZACION FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-br_table COTIZACION
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-Filtrar FILL-IN-FchPed-1 ~
FILL-IN-FchPed-2 br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchPed-1 FILL-IN-FchPed-2 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCanAtendida B-table-Win 
FUNCTION fCanAtendida RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNoAtendido B-table-Win 
FUNCTION fNoAtendido RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Filtrar 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "FILTRAR" 
     SIZE 6 BY 1.35 TOOLTIP "Filtrar Información".

DEFINE VARIABLE FILL-IN-FchPed-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      COTIZACION, 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.usuario COLUMN-LABEL "Usuario" FORMAT "x(10)":U
      FacCPedi.FchPed COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
      FacCPedi.fchven COLUMN-LABEL "Vencimiento" FORMAT "99/99/9999":U
      FacCPedi.CodDoc FORMAT "x(3)":U
      FacCPedi.NroPed COLUMN-LABEL "Número" FORMAT "X(12)":U WIDTH 10.14
      FacCPedi.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 11.43
      FacCPedi.NomCli FORMAT "x(50)":U WIDTH 49.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 114 BY 8.65
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Filtrar AT ROW 1 COL 61 WIDGET-ID 2
     FILL-IN-FchPed-1 AT ROW 1.19 COL 16 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-FchPed-2 AT ROW 1.19 COL 42 COLON-ALIGNED WIDGET-ID 6
     br_table AT ROW 2.35 COL 1
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
      TABLE: COTIZACION T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: ITEM T "SHARED" ? INTEGRAL FacDPedi
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
         HEIGHT             = 10.35
         WIDTH              = 116.14.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
/* BROWSE-TAB br_table FILL-IN-FchPed-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.COTIZACION,INTEGRAL.FacCPedi OF Temp-Tables.COTIZACION"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > INTEGRAL.FacCPedi.usuario
"FacCPedi.usuario" "Usuario" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.fchven
"FacCPedi.fchven" "Vencimiento" "99/99/9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.FacCPedi.CodDoc
     _FldNameList[5]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Número" ? "character" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "49.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME BUTTON-Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Filtrar B-table-Win
ON CHOOSE OF BUTTON-Filtrar IN FRAME F-Main /* FILTRAR */
DO:
   ASSIGN FILL-IN-FchPed-1 FILL-IN-FchPed-2.
   RUN Carga-Temporal.
   RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Pedido B-table-Win 
PROCEDURE Actualiza-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

IF NOT AVAILABLE Faccpedi THEN RETURN ERROR.
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN RETURN ERROR.
    RUN Borra-Pedido.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN ERROR.
    FOR EACH ITEM WHERE ITEM.ImpLin > 0,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = ITEM.codmat
        BY ITEM.NroItm:
        I-NITEM = I-NITEM + 1.
      CREATE FacDPedi.
      BUFFER-COPY ITEM 
          TO FacDPedi
          ASSIGN
              FacDPedi.CodCia = FacCPedi.CodCia
              FacDPedi.CodDiv = FacCPedi.CodDiv
              FacDPedi.coddoc = FacCPedi.coddoc
              FacDPedi.NroPed = FacCPedi.NroPed
              FacDPedi.FchPed = FacCPedi.FchPed
              FacDPedi.Hora   = FacCPedi.Hora 
              FacDPedi.FlgEst = FacCPedi.FlgEst
              FacDPedi.NroItm = I-NITEM.
  END.
  RUN Descuentos-Finales-01.
  RUN Descuentos-Finales-02.

  /* RHC DESCUENTOS ESPECIALES SOLO CAMPAÑA */
  RUN Descuentos-solo-campana.

  /*RUN Descuentos-Finales-03.*/

  /* **************************************************************** */
  /* RHC 18/11/2015 RUTINA ESPECIAL PARA LISTA DE PRECIOS DE TERCEROS */
  /* **************************************************************** */
  RUN Lista-Terceros NO-ERROR.
  IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
  /* **************************************************************** */

  {vta2/graba-totales-cotizacion-cred.i}

  FIND CURRENT FacCPedi NO-LOCK NO-ERROR.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Pedido B-table-Win 
PROCEDURE Borra-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH FacDPedi OF FacCPedi TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' 
      ON STOP UNDO, RETURN 'ADM-ERROR':
      DELETE FacDPedi.
  END.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Parametros B-table-Win 
PROCEDURE Carga-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Faccpedi THEN RETURN ERROR.

pCodDiv = FacCPedi.Libre_c01.

/* NO Almacenes de Remate */
FOR EACH VtaAlmDiv NO-LOCK WHERE Vtaalmdiv.codcia = s-codcia
    AND Vtaalmdiv.coddiv = s-coddiv,
    FIRST Almacen OF Vtaalmdiv NO-LOCK WHERE Almacen.Campo-C[3] <> 'Si'
    BY VtaAlmDiv.Orden:
    IF s-CodAlm = "" THEN s-CodAlm = TRIM(VtaAlmDiv.CodAlm).
    ELSE s-CodAlm = s-CodAlm + "," + TRIM(VtaAlmDiv.CodAlm).
END.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = pCodDiv
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi THEN DO:
    ASSIGN
        s-DiasVtoCot = GN-DIVI.DiasVtoCot
        s-DiasAmpCot = GN-DIVI.DiasAmpCot
        s-FlgEmpaque = GN-DIVI.FlgEmpaque
        s-FlgMinVenta = GN-DIVI.FlgMinVenta
        s-FlgRotacion = GN-DIVI.FlgRotacion
        s-VentaMayorista = GN-DIVI.VentaMayorista
        s-FlgTipoVenta = GN-DIVI.FlgPreVta
        s-MinimoPesoDia = GN-DIVI.Campo-Dec[1]
        s-MaximaVarPeso = GN-DIVI.Campo-Dec[2]
        s-MinimoDiasDespacho = GN-DIVI.Campo-Dec[3].
END.
/* Datos de la cabecera */
ASSIGN
    s-TpoPed = FacCPedi.TpoPed
    S-CODMON = FacCPedi.CodMon
    S-CODCLI = FacCPedi.CodCli
    S-TPOCMB = FacCPedi.TpoCmb
    S-FmaPgo = FacCPedi.FmaPgo
    s-PorIgv = Faccpedi.porigv
    s-NroDec = (IF Faccpedi.Libre_d01 <= 0 THEN 4 ELSE Faccpedi.Libre_d01)
    S-CMPBNTE = Faccpedi.Cmpbnte
    S-TPOMARCO = Faccpedi.Libre_C04.    /* CASO DE CLIENTES EXCEPCIONALES */

/* Cargamos las condiciones de venta válidas */
FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
    AND gn-clie.codcli = s-codcli
    NO-LOCK.
RUN vta2/p-fmapgo (s-codcli, s-tpoped, OUTPUT s-cndvta-validos).

EMPTY TEMP-TABLE ITEM.
FOR EACH Facdpedi OF Faccpedi NO-LOCK:
    CREATE ITEM.
    BUFFER-COPY Facdpedi TO ITEM.
END.


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

EMPTY TEMP-TABLE COTIZACION.
FOR EACH Faccpedi NO-LOCK WHERE {&Condicion}:
    CREATE COTIZACION.
    BUFFER-COPY Faccpedi TO COTIZACION.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cerrar B-table-Win 
PROCEDURE Cerrar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR i AS INT NO-UNDO.
  
  FIND FIRST facdpedi OF faccpedi WHERE CanAte > 0 NO-LOCK NO-ERROR.
  IF AVAILABLE facdpedi 
  THEN DO:
      MESSAGE "La Cotización tiene atenciones parciales" SKIP
          "No se puede cerrar la cotización" SKIP
          VIEW-AS ALERT-BOX ERROR.
      RETURN.
  END.
  DEF VAR pCodigo AS CHAR NO-UNDO.
  DEF VAR pObservaciones AS CHAR NO-UNDO.
  DEF VAR pStatus AS CHAR NO-UNDO.

  RUN vtagn\d-factabla ("CIECOT","MOTIVO DE CIERRE DE COTIZACIÓN",OUTPUT pCodigo,OUTPUT pObservaciones,OUTPUT pStatus).
  IF pStatus = "ADM-ERROR" THEN RETURN.

  FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCPedi THEN RETURN.
  ASSIGN
      FacCPedi.FlgEst = 'X'         /* Cerrada */
      FacCPedi.UsrSac = s-user-id
      FacCPedi.FecSac = TODAY
      FacCPedi.Libre_c05 = pCodigo
      FacCPedi.Glosa = pObservaciones.
  FIND CURRENT FacCPedi NO-LOCK NO-ERROR.
  APPLY 'CHOOSE':U TO BUTTON-Filtrar IN FRAME {&FRAME-NAME}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Finales-01 B-table-Win 
PROCEDURE Descuentos-Finales-01 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/descuentoxvolumenxlinearesumida.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Finales-02 B-table-Win 
PROCEDURE Descuentos-Finales-02 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/descuentoxvolumenxsaldosresumidav2.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-solo-campana B-table-Win 
PROCEDURE Descuentos-solo-campana :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/descuento-solo-campana.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Lista-Terceros B-table-Win 
PROCEDURE Lista-Terceros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEFINE VARIABLE f-FleteUnitario AS DEC DECIMALS 6 NO-UNDO.
DEFINE VARIABLE S-UNDVTA AS CHAR NO-UNDO.
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.

/* 1er Filtro: La lista de precios NO debe ser precios de FERIA */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK.
IF GN-DIVI.CanalVenta = 'FER' THEN RETURN.
/* 2do Filtro: La venta debe ser una venta Normal o Provincias */
IF LOOKUP(s-TpoPed, 'P,N') = 0 THEN RETURN.
/* Verificamos el cliente de acuerdo a la división de origen */
/*IF LOOKUP(s-CodDiv, '00018,00019') = 0 THEN DO:     /* NI PROVINCIAS NI MESA REDONDA */*/
/* RHC 29/02/2016 Quitamos */
IF LOOKUP(s-CodDiv, '00018') = 0 THEN DO:     /* NO PROVINCIAS  */
    /* Buscamos clientes VIP */
    FIND FacTabla WHERE FacTabla.CodCia = s-codcia
        AND FacTabla.Tabla = "VIP3ROS"
        AND FacTabla.Codigo = Faccpedi.CodCli
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacTabla THEN RETURN.
END.
/* ************************************************************* */
/* SE VA A DAR HASTA DOS VUELTAS PARA DETERMINAR LA LISTA A USAR */
/* ************************************************************* */
/* Actualizamos datos del temporal */
EMPTY TEMP-TABLE ITEM.
FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> "OF":
    CREATE ITEM.
    BUFFER-COPY Facdpedi TO ITEM.
END.
/* ******************************* */
DEF VAR x-Ciclos AS INT NO-UNDO.
DEF VAR x-ImpTot AS DEC NO-UNDO.
DEF VAR x-ListaTerceros AS INT INIT 0 NO-UNDO.  /* Lista por defecto */
DEF VAR x-ListaAnterior AS INT NO-UNDO.
DEF VAR F-PREBAS AS DEC NO-UNDO.
DEF VAR S-TPOCMB AS DEC NO-UNDO.
FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = Faccpedi.codcli
    NO-LOCK.
x-ListaAnterior = gn-clie.Libre_d01.
/* *********** */
IF x-ListaAnterior > 3 THEN x-ListaAnterior = 3.    /* Valor Máximo */
/* RHC 14/12/2015 Tomamos el valor por defecto en el cliente, puede ser de 0 a 3 */
x-ListaTerceros = x-ListaAnterior.
/* ***************************************************************************** */
FIND FIRST FacTabla WHERE FacTabla.CodCia = s-codcia
    AND FacTabla.Tabla = 'RLP3ROS' NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacTabla THEN RETURN.
DO x-Ciclos = 1 TO 2:
    /* Tomamos el importe final */
    x-ImpTot = 0.
    FOR EACH ITEM:
        x-ImpTot = x-ImpTot + ITEM.ImpLin.
    END.
    IF Faccpedi.codmon = 2 THEN x-ImpTot = x-ImpTot * Faccpedi.TpoCmb.
    /* Decidimos cual lista tomar */
    DEF VAR k AS INT NO-UNDO.
    DO k = 1 TO 3:
        IF k < 3 AND x-ImpTot >= FacTabla.Valor[k] AND x-ImpTot < FacTabla.Valor[k + 1] THEN DO:
            x-ListaTerceros = k.
            LEAVE.
        END.
        IF k = 3 AND x-ImpTot >= FacTabla.Valor[k] THEN x-ListaTerceros = k.
    END.
    /* Tomamos el mejor */
    x-ListaTerceros = MAXIMUM(x-ListaAnterior,x-ListaTerceros).
    IF x-ListaTerceros = 0 THEN RETURN. /* El importe de venta NO llega al mínimo necesario */
    IF x-ListaTerceros > 3 THEN x-ListaTerceros = 3.    /* Valor Máximo */
    /* Actualizamos Precios de Venta */
    FOR EACH ITEM WHERE ITEM.Libre_c05 <> "OF", 
        FIRST Almmmatg OF ITEM NO-LOCK,
        FIRST ListaTerceros OF ITEM NO-LOCK:
        IF ListaTerceros.PreOfi[x-ListaTerceros] = 0 THEN NEXT.
        F-PREBAS = ListaTerceros.PreOfi[x-ListaTerceros].
        S-TPOCMB = Almmmatg.TpoCmb.
        IF Faccpedi.CodMon = 1 THEN DO:
            IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
            ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB /** F-FACTOR*/.
        END.
        IF Faccpedi.CodMon = 2 THEN DO:
            IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
            ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) /** F-FACTOR*/.
        END.
        ASSIGN
            ITEM.Por_Dsctos[1] = 0
            ITEM.Por_Dsctos[2] = 0
            ITEM.Por_Dsctos[3] = 0
            ITEM.PreBas = F-PREBAS
            ITEM.PreUni = F-PREBAS
            ITEM.Libre_c04 = "LP3ROS"
            ITEM.Libre_d01 = x-ListaTerceros.
        /* Recalculamos registro */
        ASSIGN
            ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                          ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                          ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                          ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
        /* ****************************************** */
        /* RHC 15/12/2015 AGREGAMOS EL FLETE UNITARIO */
        /* ****************************************** */
        ASSIGN
            ITEM.ImpDto = 0
            ITEM.Libre_d02 = 0
            f-FleteUnitario = 0.
        RUN vta2/PrecioMayorista-Cred-v2 (
            Faccpedi.TpoPed,
            pCodDiv,
            Faccpedi.CodCli,
            Faccpedi.CodMon,
            INPUT-OUTPUT s-UndVta,
            OUTPUT f-Factor,
            ITEM.CodMat,
            Faccpedi.FmaPgo,
            ITEM.CanPed,
            Faccpedi.Libre_d01,
            OUTPUT f-PreBas,
            OUTPUT f-PreVta,
            OUTPUT f-Dsctos,
            OUTPUT y-Dsctos,
            OUTPUT z-Dsctos,
            OUTPUT x-TipDto,
            OUTPUT f-FleteUnitario,
            ITEM.TipVta,
            NO
            ).
        IF RETURN-VALUE <> 'ADM-ERROR' AND f-FleteUnitario > 0 THEN DO:
            ASSIGN
                ITEM.Libre_d02 = f-FleteUnitario.
            /* El flete afecta el monto final */
            IF ITEM.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
                ASSIGN
                    ITEM.PreUni = ROUND(ITEM.PreUni + ITEM.Libre_d02, s-NroDec)  /* Incrementamos el PreUni */
                    ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni.
            END.
            ELSE DO:      /* CON descuento promocional o volumen */
                ASSIGN
                    ITEM.ImpLin = ITEM.ImpLin + (ITEM.CanPed * f-FleteUnitario)
                    ITEM.PreUni = ROUND( (ITEM.ImpLin + ITEM.ImpDto) / ITEM.CanPed, s-NroDec).
            END.
        END.
        /* ****************************************** */
        /* ****************************************** */
        ASSIGN
            ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
            ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
        IF ITEM.AftIsc 
        THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
        ELSE ITEM.ImpIsc = 0.
        IF ITEM.AftIgv 
        THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
        ELSE ITEM.ImpIgv = 0.
    END.
END.
IF x-ListaTerceros = 0 THEN RETURN.
/* Ahora sí grabamos la información */
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FOR EACH ITEM WHERE ITEM.Libre_c04 = "LP3ROS", FIRST Almmmatg OF ITEM NO-LOCK,
        FIRST Almsfami OF Almmmatg NO-LOCK:
        FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = ITEM.codmat
            AND Facdpedi.Libre_c05 <> "OF" EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi THEN DO:
            MESSAGE 'NO se pudo bloquear el registro del código:' ITEM.codmat
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN ERROR.
        END.
        BUFFER-COPY ITEM TO Facdpedi.
        /* RHC 07/11/2013 CALCULO DE PERCEPCION */
        DEF VAR s-PorPercepcion AS DEC INIT 0 NO-UNDO.
        ASSIGN
            Facdpedi.CanSol = 0
            Facdpedi.CanApr = 0.
        FIND FIRST Vtatabla WHERE Vtatabla.codcia = s-codcia
            AND Vtatabla.tabla = 'CLNOPER'
            AND VtaTabla.Llave_c1 = s-CodCli
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Vtatabla THEN DO:
            IF gn-clie.Libre_L01 = YES AND gn-clie.RucOld <> "SI" THEN s-Porpercepcion = 0.5.
            IF gn-clie.Libre_L01 = NO AND gn-clie.RucOld <> "SI" THEN s-Porpercepcion = 2.
            /* Ic 04 Julio 2013 
                gn-clie.Libre_L01   : PERCEPCTOR
                gn-clie.RucOld      : RETENEDOR
            */
            IF s-Cmpbnte = "BOL" THEN s-Porpercepcion = 2.
            IF Almsfami.Libre_c05 = "SI" THEN
                ASSIGN
                Facdpedi.CanSol = s-PorPercepcion
                Facdpedi.CanApr = ROUND(Facdpedi.implin * s-PorPercepcion / 100, 2).
        END.
    END.
    ASSIGN
        FacCPedi.TipBon[10] = x-ListaTerceros.      /* Control de Lista de Terceros */
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
  ASSIGN
      FILL-IN-FchPed-1 = TODAY - DAY(TODAY) + 1
      FILL-IN-FchPed-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios B-table-Win 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /* ARTIFICIO */
IF S-TPOMARCO = "SI" THEN RUN Recalcular-Precio-TpoPed ("M").
ELSE RUN Recalcular-Precio-TpoPed (s-TpoPed).

/*
{vta2/recalcularcreditomay-v2.i}
*/

RUN Procesa-Handle IN lh_handle ('Browse').

END PROCEDURE.

PROCEDURE Recalcular-Precio-TpoPed:
/* ***************************** */

    DEF INPUT PARAMETER pTpoPed AS CHAR.

    IF pTpoPed = "LF" THEN RETURN.  /* No Lista Express */

    {vta2/recalcularcreditomay-v2.i &pTpoPed=pTpoPed}


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
  {src/adm/template/snd-list.i "COTIZACION"}
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCanAtendida B-table-Win 
FUNCTION fCanAtendida RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR x-CanAten AS DEC NO-UNDO.
FOR EACH Facdpedi OF Faccpedi NO-LOCK:
    x-CanAten = x-CanAten + Facdpedi.canate.
END.
  RETURN x-CanAten.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNoAtendido B-table-Win 
FUNCTION fNoAtendido RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
MESSAGE faccpedi.nroped.
RETURN NOT CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate <> 0 NO-LOCK).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

