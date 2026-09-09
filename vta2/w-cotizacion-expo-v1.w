&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE NEW SHARED TEMP-TABLE ITEM-2 LIKE FacDPedi.
DEFINE NEW SHARED TEMP-TABLE ITEM-LE LIKE FacDPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 22 Nov 2012 Nuevas especificaciones de listas de precios y descuentos
          
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
/* Local Variable Definitions ---                                       */
DEF INPUT PARAMETER pParametro AS CHAR.
/* Sintaxis : x{,ddddd}
    x: Tipo de Pedido
        N: Venta normal
        S: Canal Moderno
        E: Expolibreria (opcional)
        P: Provincias
        M: Contrato Marco
        MG: Contrato Marco Gerencia
        R: Remates
        NXTL: Nextel
        VU : Vales Utilex
    ddddd: División (opcional). Se asume la división s-coddiv por defecto
*/

/* Variables Compartidas */
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codven AS CHAR.

/* Nuevas Variables Compartidas */
DEF NEW SHARED VAR s-CodDoc AS CHAR INIT "COT".
DEF NEW SHARED VAR s-TpoPed AS CHAR.
DEF NEW SHARED VAR pCodDiv  AS CHAR.
DEF NEW SHARED VAR s-NroSer AS INT.
DEF NEW SHARED VAR s-CodMon AS INT.
DEF NEW SHARED VAR s-CodCli AS CHAR.
DEF NEW SHARED VAR s-fmapgo AS CHAR.
DEF NEW SHARED VAR s-tpocmb AS DEC.
DEF NEW SHARED VAR lh_handle AS HANDLE.
DEF NEW SHARED VAR s-porigv AS DEC.
DEF NEW SHARED VAR s-nrodec AS INT.
DEF NEW SHARED VAR s-flgigv AS LOG.

DEF NEW SHARED VAR s-import-ibc AS LOG INIT NO.
DEF NEW SHARED VAR s-import-cissac AS LOG INIT NO.
DEF NEW SHARED VAR s-import-b2b AS LOG INIT NO. /* RHC 14/08/17 */

DEF NEW SHARED TEMP-TABLE T-DPEDI LIKE FacDPedi.
DEF NEW SHARED VAR s-adm-new-record AS CHAR.
DEF NEW SHARED VAR S-NROPED AS CHAR.
DEF NEW SHARED VAR S-CMPBNTE  AS CHAR.
DEF NEW SHARED VAR S-TPOMARCO AS CHAR.      /* CASO DE CLIENTES EXCEPCIONALES */
/* CONTROL DE ALMACENES DE DESCARGA */
DEF NEW SHARED VAR s-CodAlm AS CHAR.

s-TpoPed = ENTRY(1, pParametro).
IF NUM-ENTRIES(pParametro) > 1 
    THEN pCodDiv = ENTRY(2, pParametro).
    ELSE pCodDiv = s-CodDiv.

FIND FIRST VtaAlmDiv WHERE Vtaalmdiv.codcia = s-codcia
    AND Vtaalmdiv.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaAlmDiv THEN DO:
    MESSAGE 'NO se han definido los almacenes de ventas para la división' s-coddiv VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.

CASE s-TpoPed:
    WHEN "R" THEN DO:
        /* Solo Almacenes de Remate */
        FOR EACH VtaAlmDiv NO-LOCK WHERE Vtaalmdiv.codcia = s-codcia
            AND Vtaalmdiv.coddiv = s-coddiv,
            FIRST Almacen OF Vtaalmdiv NO-LOCK WHERE Almacen.Campo-C[3] = 'Si'
            BY VtaAlmDiv.Orden:
            IF s-CodAlm = "" THEN s-CodAlm = TRIM(VtaAlmDiv.CodAlm).
            ELSE s-CodAlm = s-CodAlm + "," + TRIM(VtaAlmDiv.CodAlm).
        END.
    END.
    OTHERWISE DO:
        /* NO Almacenes de Remate */
        FOR EACH VtaAlmDiv NO-LOCK WHERE Vtaalmdiv.codcia = s-codcia
            AND Vtaalmdiv.coddiv = s-coddiv,
            FIRST Almacen OF Vtaalmdiv NO-LOCK WHERE Almacen.Campo-C[3] <> 'Si'
            BY VtaAlmDiv.Orden:
            IF s-CodAlm = "" THEN s-CodAlm = TRIM(VtaAlmDiv.CodAlm).
            ELSE s-CodAlm = s-CodAlm + "," + TRIM(VtaAlmDiv.CodAlm).
        END.
    END.
END CASE.
IF s-CodAlm = "" THEN DO:
    MESSAGE 'NO se han definido los almacenes de ventas para la división' s-coddiv VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.

/* PARAMETROS DE COTIZACION PARA LA DIVISION */
DEF NEW SHARED VAR s-DiasVtoCot     LIKE GN-DIVI.DiasVtoCot.
DEF NEW SHARED VAR s-DiasAmpCot     LIKE GN-DIVI.DiasAmpCot.
DEF NEW SHARED VAR s-FlgEmpaque     LIKE GN-DIVI.FlgEmpaque.
DEF NEW SHARED VAR s-FlgMinVenta    LIKE GN-DIVI.FlgMinVenta.
DEF NEW SHARED VAR s-FlgRotacion    LIKE GN-DIVI.FlgRotacion.
DEF NEW SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEF NEW SHARED VAR s-FlgTipoVenta   LIKE GN-DIVI.FlgPreVta.
DEF NEW SHARED VAR s-MinimoPesoDia AS DEC.
DEF NEW SHARED VAR s-MaximaVarPeso AS DEC.
DEF NEW SHARED VAR s-MinimoDiasDespacho AS DEC.
DEF NEW SHARED VAR s-ClientesVIP AS LOG.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    /*AND gn-divi.coddiv = s-coddiv*/
    AND gn-divi.coddiv = pCodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' pCodDiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.
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
    s-MinimoDiasDespacho = GN-DIVI.Campo-Dec[3]
    s-ClientesVIP = GN-DIVI.Campo-Log[6]
    .

/* EL VENDEDOR MANDA */
/* FIND gn-ven WHERE gn-ven.codcia = s-codcia                                            */
/*     AND gn-ven.codven = s-codven                                                      */
/*     NO-LOCK NO-ERROR.                                                                 */
/* IF AVAILABLE gn-ven AND gn-ven.Libre_c01 <> '' THEN s-FlgRotacion = gn-ven.Libre_c01. */
/* ***************** */

/* SOLO PARA EXPOLIBRERIA */
DEFINE NEW SHARED VARIABLE S-CODTER   AS CHAR.
IF s-TpoPed = "E" THEN DO:

    DEFINE            VARIABLE S-OK       AS CHAR.

    RUN vtaexp/d-exp001 (s-codcia,
                         s-CodDiv,      /*pCodDiv,*/
                         OUTPUT s-codter,
                         OUTPUT s-codven,
                         OUTPUT s-ok).
    IF s-ok = 'ADM-ERROR' THEN RETURN ERROR.
END.
/* ********************** */

/* CONTROL DE PROGRAMACION DE ALMACENES DESPACHO ABASTECIMIENTOS */
DEFINE NEW SHARED VAR s-nivel-acceso AS INT INIT 1 NO-UNDO.
/* 1: NO ha pasado por ABASTECIMIENTOS => Puede modificar todo */
/* 0: YA pasó por abastecimientos => Puede disminuir las cantidades mas no incrementarlas */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-24 BUTTON-Excel-Trabajo COMBO-NroSer ~
BTN-Excel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-NroSer 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_bcotgralcredmayoristav21 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-pedido AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-cotizacion-expo-v1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vcotgralcredmayoristav23 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-CCTE 
     LABEL "CUENTA CORRIENTE" 
     SIZE 25 BY 1.08.

DEFINE BUTTON B-CLI 
     LABEL "ACTUALIZA DATOS CLIENTE" 
     SIZE 25 BY 1.12.

DEFINE BUTTON BTN-Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Button 1" 
     SIZE 9 BY 1.35.

DEFINE BUTTON BUTTON-COT 
     LABEL "HISTORIAL COTIZACIONES" 
     SIZE 25 BY 1.08.

DEFINE BUTTON BUTTON-Excel-Trabajo 
     LABEL "Excel de Trabajo" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Importar-Pedido 
     LABEL "IMPORTAR PEDIDO EXCEL" 
     SIZE 25 BY 1.12.

DEFINE BUTTON BUTTON-POR-ATENDER 
     LABEL "POR ATENDER" 
     SIZE 17 BY 1.08
     FONT 1.

DEFINE BUTTON BUTTON-PRECOTIZACION 
     LABEL "PRE-COTIZACION" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-TRF-SDO-EXPO 
     LABEL "TRANSFERIR SALDO" 
     SIZE 25 BY 1.12.

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U INITIAL "0" 
     LABEL "Serie" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 121 BY 10.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-POR-ATENDER AT ROW 1.19 COL 114 WIDGET-ID 42
     BUTTON-Excel-Trabajo AT ROW 1.19 COL 131 WIDGET-ID 56
     COMBO-NroSer AT ROW 1.27 COL 66.71 WIDGET-ID 4
     BTN-Excel AT ROW 2.35 COL 124 WIDGET-ID 16
     BUTTON-PRECOTIZACION AT ROW 2.54 COL 133 WIDGET-ID 58
     B-CLI AT ROW 3.69 COL 123 WIDGET-ID 22
     B-CCTE AT ROW 4.85 COL 123 WIDGET-ID 12
     BUTTON-COT AT ROW 6 COL 123 WIDGET-ID 14
     BUTTON-Importar-Pedido AT ROW 8.27 COL 123 WIDGET-ID 48
     BUTTON-TRF-SDO-EXPO AT ROW 9.46 COL 123 WIDGET-ID 46
     "Buscar:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1.54 COL 79 WIDGET-ID 6
     RECT-24 AT ROW 2.35 COL 2 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 148.14 BY 26.77
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 2
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "NEW SHARED" ? INTEGRAL FacDPedi
      TABLE: ITEM-2 T "NEW SHARED" ? INTEGRAL FacDPedi
      TABLE: ITEM-LE T "NEW SHARED" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "COTIZACIONES EVENTOS"
         HEIGHT             = 26.77
         WIDTH              = 148.14
         MAX-HEIGHT         = 27.38
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 27.38
         VIRTUAL-WIDTH      = 182.86
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON B-CCTE IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON B-CLI IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-COT IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-Importar-Pedido IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-POR-ATENDER IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-POR-ATENDER:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-PRECOTIZACION IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-PRECOTIZACION:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-TRF-SDO-EXPO IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-TRF-SDO-EXPO:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME F-Main
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* COTIZACIONES EVENTOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* COTIZACIONES EVENTOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-CCTE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-CCTE W-Win
ON CHOOSE OF B-CCTE IN FRAME F-Main /* CUENTA CORRIENTE */
DO:
  /*RUN vta/d-concli.*/
    RUN vta2/d-ctactepend.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-CLI
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-CLI W-Win
ON CHOOSE OF B-CLI IN FRAME F-Main /* ACTUALIZA DATOS CLIENTE */
DO:
   RUN Actualiza-datos-cliente IN h_vcotgralcredmayoristav23.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BTN-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BTN-Excel W-Win
ON CHOOSE OF BTN-Excel IN FRAME F-Main /* Button 1 */
DO:
    /*RD01 - Excel con o sin IGV***
    RUN Genera-Excel2 IN h_v-cotiza.
    *******/
    
    MESSAGE '¿Desea generar el documento marque?'  SKIP
        '   1. Si = Incluye IGV.      ' SKIP
        '   2. No = No incluye IGV.   ' 
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
      UPDATE lchoice AS LOGICAL.
    IF lchoice = ? THEN RETURN 'adm-error'.
    CASE TRUE :
        WHEN INDEX(gn-divi.canalventa, "MIN") > 0
            THEN RUN Excel_Utilex IN h_vcotgralcredmayoristav23 (INPUT lchoice) .
        OTHERWISE RUN Genera-Excel2 IN h_vcotgralcredmayoristav23 (INPUT lchoice) .
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-COT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-COT W-Win
ON CHOOSE OF BUTTON-COT IN FRAME F-Main /* HISTORIAL COTIZACIONES */
DO:
  RUN vta/wconcotcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Excel-Trabajo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excel-Trabajo W-Win
ON CHOOSE OF BUTTON-Excel-Trabajo IN FRAME F-Main /* Excel de Trabajo */
DO:
  RUN Genera-Excel-Trabajo IN h_vcotgralcredmayoristav23.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Importar-Pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Importar-Pedido W-Win
ON CHOOSE OF BUTTON-Importar-Pedido IN FRAME F-Main /* IMPORTAR PEDIDO EXCEL */
DO:
  RUN Importar-Excel-2015 IN h_vcotgralcredmayoristav23.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-POR-ATENDER
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-POR-ATENDER W-Win
ON CHOOSE OF BUTTON-POR-ATENDER IN FRAME F-Main /* POR ATENDER */
DO:
  /*  */
  RUN vtaexp/d-exp002.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-PRECOTIZACION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-PRECOTIZACION W-Win
ON CHOOSE OF BUTTON-PRECOTIZACION IN FRAME F-Main /* PRE-COTIZACION */
DO:
  RUN Asigna-PrePedido IN h_vcotgralcredmayoristav23.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN NO-APPLY.
  RUN dispatch IN h_t-cotizacion-expo-v1 ('open-query':U).
  {&self-name}:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-TRF-SDO-EXPO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-TRF-SDO-EXPO W-Win
ON CHOOSE OF BUTTON-TRF-SDO-EXPO IN FRAME F-Main /* TRANSFERIR SALDO */
DO:
   DEF VAR pRowidS AS ROWID.
   RUN Transferencia-de-Saldos IN h_vcotgralcredmayoristav23
    ( OUTPUT pRowidS /* ROWID */).
   IF pRowidS <> ? THEN RUN Posiciona-Registro IN h_q-pedido
    ( INPUT pRowidS /* ROWID */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer W-Win
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME F-Main /* Serie */
DO:
    ASSIGN COMBO-NroSer.
    s-NroSer = INTEGER(COMBO-NroSer).
    RUN dispatch IN h_q-pedido ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.
CASE s-CodDoc:
    WHEN "COT" THEN W-Win:TITLE = "COTIZACIONES AL CREDITO - MAYORISTA".
END CASE.
CASE s-TpoPed:
    WHEN "S" THEN W-Win:TITLE = W-Win:TITLE + "- CANAL MODERNO".
    WHEN "M" THEN W-Win:TITLE = W-Win:TITLE + "- CONTRATO MARCO".
    WHEN "R" THEN W-Win:TITLE = W-Win:TITLE + "- REMATES".
    WHEN "P" THEN W-Win:TITLE = W-Win:TITLE + "- PROVINCIAS".
    WHEN "E" THEN W-Win:TITLE = W-Win:TITLE + "- EXPOLIBRERIA".
    WHEN "NXTL" THEN W-Win:TITLE = W-Win:TITLE + "- NEXTEL".
    WHEN "VU" THEN W-Win:TITLE = W-Win:TITLE + "- VALES UTILEX".
END CASE.

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv01.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv01 ).
       RUN set-position IN h_p-updv01 ( 1.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv01 ( 1.42 , 64.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico-2 ).
       RUN set-position IN h_p-navico-2 ( 1.00 , 94.00 ) NO-ERROR.
       RUN set-size IN h_p-navico-2 ( 1.35 , 20.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta2/vcotgralcredmayoristav23.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_vcotgralcredmayoristav23 ).
       RUN set-position IN h_vcotgralcredmayoristav23 ( 2.62 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 10.04 , 119.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta2/q-pedido.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-pedido ).
       RUN set-position IN h_q-pedido ( 1.00 , 85.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.35 , 9.00 ) */

       /* Links to SmartViewer h_vcotgralcredmayoristav23. */
       RUN add-link IN adm-broker-hdl ( h_p-updv01 , 'TableIO':U , h_vcotgralcredmayoristav23 ).
       RUN add-link IN adm-broker-hdl ( h_q-pedido , 'Record':U , h_vcotgralcredmayoristav23 ).

       /* Links to SmartQuery h_q-pedido. */
       RUN add-link IN adm-broker-hdl ( h_p-navico-2 , 'Navigation':U , h_q-pedido ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv01 ,
             BUTTON-POR-ATENDER:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico-2 ,
             h_p-updv01 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_vcotgralcredmayoristav23 ,
             BUTTON-PRECOTIZACION:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-pedido ,
             BUTTON-TRF-SDO-EXPO:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta2/b-cotizacion-expo.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcotgralcredmayoristav21 ).
       RUN set-position IN h_bcotgralcredmayoristav21 ( 12.92 , 2.00 ) NO-ERROR.
       RUN set-size IN h_bcotgralcredmayoristav21 ( 14.81 , 141.00 ) NO-ERROR.

       /* Links to SmartBrowser h_bcotgralcredmayoristav21. */
       RUN add-link IN adm-broker-hdl ( h_q-pedido , 'Record':U , h_bcotgralcredmayoristav21 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcotgralcredmayoristav21 ,
             BUTTON-TRF-SDO-EXPO:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta2/t-cotizacion-expo-v1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-cotizacion-expo-v1 ).
       RUN set-position IN h_t-cotizacion-expo-v1 ( 13.12 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-cotizacion-expo-v1 ( 13.96 , 144.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 25.50 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 1.42 , 34.14 ) NO-ERROR.

       /* Links to SmartBrowser h_t-cotizacion-expo-v1. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_t-cotizacion-expo-v1 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-cotizacion-expo-v1 ,
             BUTTON-TRF-SDO-EXPO:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_t-cotizacion-expo-v1 , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY COMBO-NroSer 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-24 BUTTON-Excel-Trabajo COMBO-NroSer BTN-Excel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.

  FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
  FOR EACH FacCorre NO-LOCK WHERE 
      FacCorre.CodCia = s-CodCia AND
      FacCorre.CodDoc = s-CodDoc AND
      FacCorre.CodDiv = s-CodDiv:
      IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
      ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
  END.
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-NroSer:LIST-ITEMS = cListItems.
      COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS).
      s-NroSer = INTEGER(COMBO-NroSer).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
   RUN Procesa-Handle ('Pagina1').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER L-Handle AS CHAR.
CASE L-Handle:
    WHEN "Pagina1"  THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(1).
         ASSIGN
             COMBO-NroSer:SENSITIVE = YES
             B-CCTE:SENSITIVE = NO
             BUTTON-COT:SENSITIVE = NO
             Btn-Excel:SENSITIVE = YES
             B-CLI:SENSITIVE = NO
             BUTTON-Importar-Pedido:SENSITIVE = NO
             BUTTON-Importar-Pedido:VISIBLE = NO
             BUTTON-POR-ATENDER:VISIBLE = NO
             BUTTON-POR-ATENDER:SENSITIVE = NO
             BUTTON-TRF-SDO-EXPO:VISIBLE = NO
             BUTTON-TRF-SDO-EXPO:SENSITIVE = NO
             BUTTON-Excel-Trabajo:SENSITIVE = YES
             BUTTON-Excel-Trabajo:VISIBLE = YES
             BUTTON-PRECOTIZACION:SENSITIVE = NO
             BUTTON-PRECOTIZACION:VISIBLE = NO
             .
         CASE s-TpoPed:
             WHEN "E" THEN DO:      /* Eventos */
                 ASSIGN
                     BUTTON-TRF-SDO-EXPO:VISIBLE = YES
                     BUTTON-TRF-SDO-EXPO:SENSITIVE = YES
                     BUTTON-POR-ATENDER:VISIBLE = YES.
                     BUTTON-POR-ATENDER:SENSITIVE = YES.
             END.
         END CASE.
         RUN dispatch IN h_q-pedido ('enable':U).
         IF h_bcotgralcredmayoristav21 <> ? THEN RUN dispatch IN h_bcotgralcredmayoristav21 ('open-query':U).
      END.
    WHEN "Pagina2"  THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(2).
         ASSIGN
             COMBO-NroSer:SENSITIVE = NO
             B-CCTE:SENSITIVE = YES
             BUTTON-COT:SENSITIVE = YES
             Btn-Excel:SENSITIVE    = NO
             B-CLI:SENSITIVE = YES
             BUTTON-TRF-SDO-EXPO:SENSITIVE = NO
             BUTTON-POR-ATENDER:SENSITIVE = NO
             BUTTON-Excel-Trabajo:SENSITIVE = NO
             BUTTON-Excel-Trabajo:VISIBLE = NO.
         CASE s-TpoPed:
             WHEN "E" THEN DO:
                 ASSIGN
                     BUTTON-Importar-Pedido:SENSITIVE = YES
                     BUTTON-Importar-Pedido:VISIBLE = YES
                     BUTTON-PRECOTIZACION:SENSITIVE = YES
                     BUTTON-PRECOTIZACION:VISIBLE = YES
                     .
             END.
         END CASE.
         RUN dispatch IN h_q-pedido ('disable':U).
         RUN dispatch IN h_t-cotizacion-expo-v1 ('open-query':U).
      END.
    WHEN "Disable-Head" THEN DO:
        BUTTON-Importar-Pedido:SENSITIVE = NO.
        B-CCTE:SENSITIVE = NO.
        B-CLI:SENSITIVE = NO.
        BUTTON-COT:SENSITIVE = NO.
        RUN dispatch IN h_p-updv01 ('disable':U).
        RUN dispatch IN h_vcotgralcredmayoristav23 ('disable-fields':U).
    END.
    WHEN "Enable-Head" THEN DO:
        BUTTON-Importar-Pedido:SENSITIVE = YES.
        B-CCTE:SENSITIVE = YES.
        B-CLI:SENSITIVE = YES.
        BUTTON-COT:SENSITIVE = YES.
        RUN dispatch IN h_p-updv01 ('enable':U).
        RUN dispatch IN h_vcotgralcredmayoristav23 ('enable-fields':U).
    END.
    WHEN "Disable-btn-prepedido" THEN BUTTON-PRECOTIZACION:SENSITIVE = NO.
    WHEN "browse" THEN DO:
          IF h_bcotgralcredmayoristav21 <> ? THEN RUN dispatch IN h_bcotgralcredmayoristav21 ('open-query':U).
          IF h_t-cotizacion-expo-v1 <> ? THEN RUN dispatch IN h_t-cotizacion-expo-v1 ('open-query':U). 
      END.
    WHEN "Recalculo" THEN DO:
        RUN Recalcular-Precios-Evento IN h_vcotgralcredmayoristav23.
        /* OJO: En otros Windows, caso ventas NORMALES usar:
                RUN Recalcular-Precios IN h_vcotgralcredmayoristav23.
        */
    END.
    WHEN "Add-Record"   THEN RUN notify IN h_p-updv12   ('add-record':U).
    WHEN 'Open-Query-Master' THEN RUN dispatch IN h_q-pedido ('open-query':U).
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

