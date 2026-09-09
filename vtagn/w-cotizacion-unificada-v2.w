&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE NEW SHARED TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE NEW SHARED TEMP-TABLE ITEM-2 LIKE FacDPedi.
DEFINE NEW SHARED TEMP-TABLE ITEM-LE LIKE FacDPedi.
DEFINE TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE NEW SHARED TEMP-TABLE T-DPEDI LIKE FacDPedi.



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
/* Sintaxis : x{,ddddd,{semaforo}}
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
        TBLT : Cotizacion por TABLET, modo prueba aun
    ddddd: División (opcional). Se asume la división s-coddiv por defecto
    semaforo: SI,NO,YES,TRUE,FALSE,Sí
*/
/* ************************************************************************* */
/* Variables Compartidas */
/* ************************************************************************* */
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-codven AS CHAR.

DEF NEW SHARED VAR s-CodDoc AS CHAR INIT "COT".

IF NOT CAN-FIND(FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia AND
                FacCorre.CodDoc = s-CodDoc AND
                FacCorre.CodDiv = s-CodDiv NO-LOCK)
    THEN DO:
    MESSAGE 'NO hay correlativo definido para esta división' VIEW-AS ALERT-BOX  ERROR.
    RETURN ERROR.
END.
/* Nuevas Variables Compartidas */
&SCOPED-DEFINE precio-venta-general pri/PrecioVentaMayorCredito-v2.p

DEF NEW SHARED VAR s-TpoPed AS CHAR.
DEF NEW SHARED VAR pCodDiv  AS CHAR.    /* Lista de Precio */
DEF NEW SHARED VAR s-NroSer AS INT.
DEF NEW SHARED VAR s-CodMon AS INT.
DEF NEW SHARED VAR s-CodCli AS CHAR.
DEF NEW SHARED VAR s-fmapgo AS CHAR.
DEF NEW SHARED VAR s-tpocmb AS DEC.
DEF NEW SHARED VAR lh_handle AS HANDLE.
DEF NEW SHARED VAR s-porigv AS DEC.
DEF NEW SHARED VAR s-nrodec AS INT.
DEF NEW SHARED VAR s-flgigv AS LOG.

DEF NEW SHARED VAR s-adm-new-record AS CHAR.
DEF NEW SHARED VAR S-NROPED AS CHAR.
DEF NEW SHARED VAR S-CMPBNTE  AS CHAR.
DEF NEW SHARED VAR S-TPOMARCO AS CHAR.      /* CASO DE CLIENTES EXCEPCIONALES */

/* CONTROL DE ALMACENES DE DESCARGA */
DEF NEW SHARED VAR s-CodAlm AS CHAR.

/* TIPO DE PEDIDO: Define reglas para el tipo de venta */
s-TpoPed = ENTRY(1, pParametro).
IF TRUE <> (s-TpoPed > '') THEN s-TpoPed = "N".     /* Valor por defecto N: normal */
/* ************************************************************************* */
/* LISTA DE PRECIOS: Define las reglas de la lista de precios
                     Si no se define una las reglas de la división */
/* ************************************************************************* */
IF NUM-ENTRIES(pParametro) > 1 AND ENTRY(2, pParametro) > '' THEN DO:
    pCodDiv = ENTRY(2, pParametro).
END.
ELSE DO: 
    DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */
    DEFINE VAR cRetVal AS CHAR.

    RUN gn\master-library.r PERSISTENT SET hProc.

    /* Procedimientos */
    RUN VTA_lista_precio_segun_div_vta IN hProc (INPUT s-coddiv, INPUT s-TpoPed, OUTPUT cRetVal).       

    DELETE PROCEDURE hProc.                     /* Release Libreria */

    IF TRUE <> (cRetVal > "") THEN pCodDiv = s-CodDiv.
    ELSE pCodDiv = cRetVal.
END.
/* ************************************************************************* */
/* SEMAFOROS: Muestra colores de acuerdo al margen de ganacias */
/* ************************************************************************* */
DEFINE NEW SHARED VARIABLE s-acceso-semaforos AS LOG.
DEFINE VAR x-TpoPed AS CHAR NO-UNDO.
s-acceso-semaforos = NO.
IF NUM-ENTRIES(pParametro) > 2 THEN DO:
    x-TpoPed = ENTRY(3, pParametro).
    IF LOOKUP(x-TpoPed, 'SI,YES,TRUE,Sí') > 0 THEN
        ASSIGN s-acceso-semaforos = YES.
END.
ELSE s-acceso-semaforos = NO.
/* ************************************************************************* */
/* ALMACENES VALIDOS DE DESPACHO POR LISTA DE PRECIOS */
/* ************************************************************************* */
FIND FIRST VtaAlmDiv WHERE Vtaalmdiv.codcia = s-codcia
    AND Vtaalmdiv.coddiv = pCodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaAlmDiv THEN DO:
    MESSAGE 'NO se han definido los almacenes de ventas para:' pCodDiv VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.
/* CONTROL DE ALMACENES VALIDOS: De acuerdo a la lista de precios, salvo remates */
CASE s-TpoPed:
    WHEN "R" THEN DO:
        /* Solo Almacenes de Remate */
        FOR EACH VtaAlmDiv NO-LOCK WHERE Vtaalmdiv.codcia = s-codcia
            AND Vtaalmdiv.coddiv = s-coddiv,    /* OJO: aquí manda la división origen */
            FIRST Almacen OF Vtaalmdiv NO-LOCK WHERE Almacen.Campo-C[3] = 'Si'
            BY VtaAlmDiv.Orden:
            IF s-CodAlm = "" THEN s-CodAlm = TRIM(VtaAlmDiv.CodAlm).
            ELSE s-CodAlm = s-CodAlm + "," + TRIM(VtaAlmDiv.CodAlm).
        END.
    END.
    OTHERWISE DO:
        /* NO Almacenes de Remate */
        FOR EACH VtaAlmDiv NO-LOCK WHERE Vtaalmdiv.codcia = s-codcia
            AND Vtaalmdiv.coddiv = pCodDiv,
            FIRST Almacen OF Vtaalmdiv NO-LOCK WHERE Almacen.Campo-C[3] <> 'Si'
            BY VtaAlmDiv.Orden:
            IF s-CodAlm = "" THEN s-CodAlm = TRIM(VtaAlmDiv.CodAlm).
            ELSE s-CodAlm = s-CodAlm + "," + TRIM(VtaAlmDiv.CodAlm).
        END.
    END.
END CASE.
/* ************************************************************************* */
/* PARAMETROS DE COTIZACION PARA LA DIVISION/LISTA DE PRECIOS */
/* ************************************************************************* */
DEF NEW SHARED VAR s-DiasVtoCot     LIKE GN-DIVI.DiasVtoCot.
DEF NEW SHARED VAR s-DiasVtoPed     LIKE GN-DIVI.DiasVtoPed.
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

/* ************************************************************************* */
/* SOLO PARA EXPOLIBRERIA */
/* ************************************************************************* */
DEFINE NEW SHARED VARIABLE S-CODTER   AS CHAR.

IF s-TpoPed = "E" THEN DO:
    DEFINE VARIABLE S-OK AS CHAR.
    RUN vtaexp/d-exp001 (s-codcia,
                         s-CodDiv,      /* División Primaria */
                         OUTPUT s-codter,
                         OUTPUT s-codven,
                         OUTPUT s-ok).
    IF s-ok = 'ADM-ERROR' THEN RETURN ERROR.
END.
/* ************************************************************************* */
/* CONTROL DE PROGRAMACION DE ALMACENES DESPACHO ABASTECIMIENTOS */
/* ************************************************************************* */
DEFINE NEW SHARED VAR s-nivel-acceso AS INT INIT 1 NO-UNDO.

/* 1: NO ha pasado por ABASTECIMIENTOS => Puede modificar todo */
/* 0: YA pasó por abastecimientos => Puede disminuir las cantidades mas no incrementarlas */

DEF NEW SHARED VAR s-import-b2b AS LOG.
DEF NEW SHARED VAR s-import-ibc AS LOG.

DEF VAR x-articulo-ICBPer AS CHAR INIT '099268'.

/* VARIABLES PARA EL EXCEL */
DEFINE VARIABLE chExcelApplication  AS COM-HANDLE.
DEFINE VARIABLE chWorkbook          AS COM-HANDLE.
DEFINE VARIABLE chWorksheet         AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-Excel-Trabajo COMBO-NroSer 
&Scoped-Define DISPLAYED-OBJECTS COMBO-NroSer 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-cotizacion-general AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cot-gral-cotrecu AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cot-gral-envio-admin AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cot-gral-expo-import AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cot-gral-expo-pag1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cot-gral-exporta-a-excel AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cot-gral-exporta-a-pdf-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cot-gral-imp-excel-provi AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cot-gral-imp-market AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cot-gral-imp-ped-excel AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cot-gral-matriz-de-ventas AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cot-gral-pag2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cot-gral-sede-cliente-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cot-gral-super AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cot-gral-super-pag2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-gen-cot-even AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-imp-excel-plantilla AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv95 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-pedido AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-cotizacion-unif-express AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-cotizacion-unificada AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-cotizacion-unificada AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Excel-Trabajo 
     LABEL "Excel de Trabajo" 
     SIZE 16 BY 1.35.

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U INITIAL "0" 
     LABEL "Serie" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Excel-Trabajo AT ROW 1 COL 120 WIDGET-ID 58
     COMBO-NroSer AT ROW 1.27 COL 71.71 WIDGET-ID 4
     "Buscar:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1.54 COL 83 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 159 BY 25.38
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 2
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: ITEM T "NEW SHARED" ? INTEGRAL FacDPedi
      TABLE: ITEM-2 T "NEW SHARED" ? INTEGRAL FacDPedi
      TABLE: ITEM-LE T "NEW SHARED" ? INTEGRAL FacDPedi
      TABLE: PEDI T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: T-DPEDI T "NEW SHARED" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PEDIDO COMERCIAL"
         HEIGHT             = 25.38
         WIDTH              = 159
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
/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME F-Main
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PEDIDO COMERCIAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PEDIDO COMERCIAL */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Excel-Trabajo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excel-Trabajo W-Win
ON CHOOSE OF BUTTON-Excel-Trabajo IN FRAME F-Main /* Excel de Trabajo */
DO:
  RUN Genera-Excel-Trabajo IN h_v-cotizacion-unificada.
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
FIND FacDocum WHERE FacDocum.CodCia = s-CodCia
    AND FacDocum.CodDoc = s-CodDoc
    NO-LOCK NO-ERROR.
lh_handle = THIS-PROCEDURE.
CASE TRUE:
    WHEN AVAILABLE FacDocum THEN W-Win:TITLE = ">>> " + FacDocum.NomDoc + " - MAYORISTA".
    WHEN s-CodDoc = "COT" THEN W-Win:TITLE = ">>> PEDIDO COMERCIAL - MAYORISTA".
END CASE.
CASE s-TpoPed:
    WHEN "LF" THEN W-Win:TITLE = W-Win:TITLE + "- LISTA EXPRESS".
    WHEN "S" THEN W-Win:TITLE = W-Win:TITLE + "- CANAL MODERNO".
    WHEN "M" THEN W-Win:TITLE = W-Win:TITLE + "- CONTRATO MARCO".
    WHEN "R" THEN W-Win:TITLE = W-Win:TITLE + "- REMATES".
    WHEN "P" THEN W-Win:TITLE = W-Win:TITLE + "- PROVINCIAS".
    WHEN "E" THEN W-Win:TITLE = W-Win:TITLE + "- EVENTOS".
    WHEN "NXTL" THEN W-Win:TITLE = W-Win:TITLE + "- NEXTEL".
    WHEN "VU" THEN W-Win:TITLE = W-Win:TITLE + "- VALES UTILEX".
    WHEN "I" THEN W-Win:TITLE = W-Win:TITLE + "- INSTITUCIONALES".
END CASE.
W-Win:TITLE = W-Win:TITLE + " <<<".

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
       RUN set-size IN h_p-updv01 ( 1.42 , 69.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico-2 ).
       RUN set-position IN h_p-navico-2 ( 1.00 , 99.00 ) NO-ERROR.
       RUN set-size IN h_p-navico-2 ( 1.35 , 20.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vtagn/v-cotizacion-unificada-v2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-cotizacion-unificada ).
       RUN set-position IN h_v-cotizacion-unificada ( 2.35 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 10.77 , 131.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta2/q-pedido.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-pedido ).
       RUN set-position IN h_q-pedido ( 1.00 , 89.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.35 , 9.00 ) */

       /* Links to SmartViewer h_v-cotizacion-unificada. */
       RUN add-link IN adm-broker-hdl ( h_p-updv01 , 'TableIO':U , h_v-cotizacion-unificada ).
       RUN add-link IN adm-broker-hdl ( h_q-pedido , 'Record':U , h_v-cotizacion-unificada ).

       /* Links to SmartQuery h_q-pedido. */
       RUN add-link IN adm-broker-hdl ( h_p-navico-2 , 'Navigation':U , h_q-pedido ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv01 ,
             BUTTON-Excel-Trabajo:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico-2 ,
             h_p-updv01 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-cotizacion-unificada ,
             COMBO-NroSer:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-pedido ,
             h_v-cotizacion-unificada , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/f-cot-gral-exporta-a-excel.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cot-gral-exporta-a-excel ).
       RUN set-position IN h_f-cot-gral-exporta-a-excel ( 1.00 , 137.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.62 , 7.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/f-cot-gral-exporta-a-pdf.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cot-gral-exporta-a-pdf-2 ).
       RUN set-position IN h_f-cot-gral-exporta-a-pdf-2 ( 1.00 , 144.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.62 , 6.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/f-cot-gral-expo-pag1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cot-gral-expo-pag1 ).
       RUN set-position IN h_f-cot-gral-expo-pag1 ( 2.62 , 133.00 ) NO-ERROR.
       /* Size in UIB:  ( 2.19 , 25.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/f-cot-gral-imp-excel-plantilla.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-imp-excel-plantilla ).
       RUN set-position IN h_f-imp-excel-plantilla ( 4.77 , 133.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.08 , 25.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/f-cot-gral-super.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cot-gral-super ).
       RUN set-position IN h_f-cot-gral-super ( 5.85 , 133.00 ) NO-ERROR.
       /* Size in UIB:  ( 2.19 , 25.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/f-cot-gral-imp-market.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cot-gral-imp-market ).
       RUN set-position IN h_f-cot-gral-imp-market ( 8.00 , 133.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.08 , 25.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/f-gen-cot-even.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-gen-cot-even ).
       RUN set-position IN h_f-gen-cot-even ( 9.08 , 133.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 26.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/f-cot-gral-expo-import.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cot-gral-expo-import ).
       RUN set-position IN h_f-cot-gral-expo-import ( 10.42 , 134.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.08 , 25.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/f-cot-gral-envio-admin.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cot-gral-envio-admin ).
       RUN set-position IN h_f-cot-gral-envio-admin ( 11.77 , 134.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.08 , 25.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/b-cotizacion-general-v2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cotizacion-general ).
       RUN set-position IN h_b-cotizacion-general ( 13.08 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-cotizacion-general ( 13.19 , 156.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-cotizacion-general. */
       RUN add-link IN adm-broker-hdl ( h_q-pedido , 'Record':U , h_b-cotizacion-general ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cot-gral-exporta-a-excel ,
             BUTTON-Excel-Trabajo:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cot-gral-exporta-a-pdf-2 ,
             h_f-cot-gral-exporta-a-excel , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cot-gral-expo-pag1 ,
             h_v-cotizacion-unificada , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-imp-excel-plantilla ,
             h_f-cot-gral-expo-pag1 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cot-gral-super ,
             h_f-imp-excel-plantilla , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cot-gral-imp-market ,
             h_f-cot-gral-super , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-gen-cot-even ,
             h_f-cot-gral-imp-market , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cot-gral-expo-import ,
             h_f-gen-cot-even , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cot-gral-envio-admin ,
             h_f-cot-gral-expo-import , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-cotizacion-general ,
             h_f-cot-gral-envio-admin , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/f-cot-gral-pag2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cot-gral-pag2 ).
       RUN set-position IN h_f-cot-gral-pag2 ( 2.35 , 134.00 ) NO-ERROR.
       /* Size in UIB:  ( 2.15 , 25.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/f-cot-gral-imp-ped-excel.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cot-gral-imp-ped-excel ).
       RUN set-position IN h_f-cot-gral-imp-ped-excel ( 4.50 , 134.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 25.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/f-cot-gral-imp-excel-provi.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cot-gral-imp-excel-provi ).
       RUN set-position IN h_f-cot-gral-imp-excel-provi ( 5.58 , 134.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.08 , 25.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/f-cot-gral-super-pag2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cot-gral-super-pag2 ).
       RUN set-position IN h_f-cot-gral-super-pag2 ( 6.65 , 134.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.08 , 25.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/f-cot-gral-cotrecu.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cot-gral-cotrecu ).
       RUN set-position IN h_f-cot-gral-cotrecu ( 7.73 , 134.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 25.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/f-cot-gral-sede-cliente.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cot-gral-sede-cliente-2 ).
       RUN set-position IN h_f-cot-gral-sede-cliente-2 ( 8.81 , 134.00 ) NO-ERROR.
       /* Size in UIB:  ( 2.19 , 26.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/f-cot-gral-matriz-de-ventas.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cot-gral-matriz-de-ventas ).
       RUN set-position IN h_f-cot-gral-matriz-de-ventas ( 10.96 , 134.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.08 , 19.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vtagn/t-cotizacion-unificada-v2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-cotizacion-unificada ).
       RUN set-position IN h_t-cotizacion-unificada ( 13.12 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-cotizacion-unificada ( 13.19 , 156.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 24.96 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 1.42 , 34.14 ) NO-ERROR.

       /* Links to SmartBrowser h_t-cotizacion-unificada. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_t-cotizacion-unificada ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cot-gral-pag2 ,
             h_v-cotizacion-unificada , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cot-gral-imp-ped-excel ,
             h_f-cot-gral-pag2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cot-gral-imp-excel-provi ,
             h_f-cot-gral-imp-ped-excel , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cot-gral-super-pag2 ,
             h_f-cot-gral-imp-excel-provi , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cot-gral-cotrecu ,
             h_f-cot-gral-super-pag2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cot-gral-sede-cliente-2 ,
             h_f-cot-gral-cotrecu , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cot-gral-matriz-de-ventas ,
             h_f-cot-gral-sede-cliente-2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-cotizacion-unificada ,
             h_f-cot-gral-matriz-de-ventas , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_t-cotizacion-unificada , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/t-cotizacion-unif-express.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-cotizacion-unif-express ).
       RUN set-position IN h_t-cotizacion-unif-express ( 13.12 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-cotizacion-unif-express ( 12.65 , 156.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv95 ).
       RUN set-position IN h_p-updv95 ( 24.85 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv95 ( 1.54 , 26.14 ) NO-ERROR.

       /* Links to SmartBrowser h_t-cotizacion-unif-express. */
       RUN add-link IN adm-broker-hdl ( h_p-updv95 , 'TableIO':U , h_t-cotizacion-unif-express ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-cotizacion-unif-express ,
             h_v-cotizacion-unificada , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv95 ,
             h_t-cotizacion-unif-express , 'AFTER':U ).
    END. /* Page 4 */

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
  ENABLE BUTTON-Excel-Trabajo COMBO-NroSer 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Cotizacion-Eventos W-Win 
PROCEDURE Genera-Cotizacion-Eventos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pCodCli AS CHAR NO-UNDO.
DEF VAR pCodVen AS CHAR NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.                                   
DEF VAR pNroPed AS CHAR NO-UNDO.

/* Solicitamos el cliente y el vendedor */
pCodVen = s-CodVen.

RUN vtagn/d-ing-clie-vend (INPUT s-CodDiv,
                           INPUT no,    /*s-ClientesVIP,*/
                           OUTPUT pCodCli,
                           INPUT-OUTPUT pCodVen).
IF TRUE <> (pCodCli > '') THEN RETURN.

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN vtagn/gen-cot-eventos-library PERSISTENT SET hProc.

RUN COT_Genera-COT IN hProc (INPUT pCodDiv,
                             INPUT pCodCli,
                             INPUT pCodVen,
                             OUTPUT pNroPed,
                             OUTPUT pMensaje).
DELETE PROCEDURE hProc.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
END.
ELSE DO:
    FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddiv = s-coddiv
        AND Faccpedi.coddoc = s-coddoc
        AND Faccpedi.nroped = pNroPed
        NO-LOCK NO-ERROR.
    IF AVAILABLE Faccpedi THEN RUN Posiciona-Registro IN h_q-pedido ( INPUT ROWID(Faccpedi) /* ROWID */).

END.
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel-Marco W-Win 
PROCEDURE Importar-Excel-Marco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pRowid AS ROWID NO-UNDO.
RUN Devuelve-Registro IN h_q-pedido ( OUTPUT pRowid /* ROWID */).
IF pRowid = ? THEN RETURN.

FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK.

DEFINE VAR RPTA AS CHAR.
DEFINE VAR cTipoPrecio AS CHAR.

RUN valida-update IN h_v-cotizacion-unificada.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    RUN Procesa-Handle IN lh_Handle ('Pagina1').
    RETURN.
END.
RUN Procesa-Handle IN lh_Handle ('Pagina1').

/* RECALCULAMOS LOS ITEMS ANTES */
EMPTY TEMP-TABLE ITEM-2.
FOR EACH ITEM:
    CREATE ITEM-2.
    BUFFER-COPY ITEM TO ITEM-2.
END.
RUN Procesa-Handle IN lh_handle ("Recalculo").

DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed AS LOG NO-UNDO.
                                          
SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
    FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx"
    TITLE "COTIZACION CONTRATO MARCO"
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

/* CREAMOS LA HOJA EXCEL */
CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

SESSION:SET-WAIT-STATE('GENERAL').

EMPTY TEMP-TABLE PEDI.  /* Limpiamos el temporal */
RUN Importar-Detalle-Excel-Marco (OUTPUT cTipoPrecio) NO-ERROR.
IF ERROR-STATUS:ERROR THEN EMPTY TEMP-TABLE PEDI.

SESSION:SET-WAIT-STATE('').

/* CERRAMOS EL EXCEL */
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

/* Pasamos PEDI a ITEM */
IF NOT CAN-FIND(FIRST PEDI) THEN RETURN.    /* OJO */

/* Consistencia de ida y vuelta */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
FOR EACH PEDI:
    FIND FIRST ITEM WHERE ITEM.codmat = PEDI.codmat NO-ERROR.
    IF NOT AVAILABLE ITEM THEN DO:
        MESSAGE 'Artículo' PEDI.codmat 'no registrado en la cotización'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    IF PEDI.canped <> ITEM.canped THEN DO:
        MESSAGE 'Artículo' PEDI.codmat 'cantidad diferente en la cotización'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    IF PEDI.undvta <> ITEM.undvta THEN DO:
        MESSAGE 'Artículo' PEDI.codmat 'unidad de venta diferente en la cotización'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
END.
FOR EACH ITEM:
    FIND FIRST PEDI WHERE PEDI.codmat = ITEM.codmat NO-ERROR.
    IF NOT AVAILABLE PEDI THEN DO:
        MESSAGE 'Artículo' ITEM.codmat 'no registrado en el Excel'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
END.
/* LIMITES PERMITIDOS */
IF s-TpoPed = "M" THEN DO:
    FOR EACH PEDI, FIRST ITEM WHERE ITEM.codmat = PEDI.codmat:
        CASE TRUE:
            WHEN gn-divi.libre_c02 = 'Porcentaje' AND gn-divi.libre_d01 > 0 THEN DO:
                IF (ABS(PEDI.ImpLin - ITEM.ImpLin) / ITEM.ImpLin) * 100 > gn-divi.libre_d01 
                    THEN DO:
                    MESSAGE 'El artículo' ITEM.codmat 'supera el margen permitido' SKIP
                        'Proceso abortado'
                        VIEW-AS ALERT-BOX ERROR.
                    RETURN.
                END.
            END.
            WHEN gn-divi.libre_c02 = 'Importe' AND gn-divi.libre_d01 > 0 THEN DO:
                IF ABS(PEDI.ImpLin - ITEM.ImpLin) > gn-divi.libre_d01 
                    THEN DO:
                    MESSAGE 'El artículo' ITEM.codmat 'supera el margen permitido' SKIP
                        'Proceso abortado'
                        VIEW-AS ALERT-BOX ERROR.
                    RETURN.
                END.
            END.
        END CASE.
    END.
END.
/* Actualizamos información del ITEM */
FOR EACH PEDI, FIRST ITEM WHERE ITEM.codmat = PEDI.codmat, FIRST Almmmatg OF ITEM NO-LOCK:
    /* Cargamos valores del Excel */
    ASSIGN
        ITEM.PreUni = PEDI.PreUni
        ITEM.ImpLin = PEDI.ImpLin
        ITEM.Por_Dsctos[1] = 0
        ITEM.Por_Dsctos[2] = 0
        ITEM.Por_Dsctos[3] = 0
        ITEM.ImpDto = 0
        ITEM.PreUni = ROUND(ITEM.ImpLin / ITEM.CanPed, 6).  /* Por si acaso */
    /* Recalculamos linea */
    IF ITEM.AftIsc 
    THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE ITEM.ImpIsc = 0.
    IF ITEM.AftIgv 
    THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (Faccpedi.PorIgv / 100) ), 4 ).
    ELSE ITEM.ImpIgv = 0.
    /* CALCULO DE PERCEPCION */
    ASSIGN
        ITEM.CanApr = ROUND(ITEM.implin * ITEM.CanSol / 100, 2).
END.
/* Grabamos Cotizacion */
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN DO:
        MESSAGE 'Cotización en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    FOR EACH FacDPedi OF FacCPedi NO-LOCK:
        {lib/lock-genericov3.i ~
            &Tabla="B-DPEDI" ~
            &Condicion="ROWID(B-DPEDI) = ROWID(FacDPedi)" ~
            &Bloqueo="EXCLUSIVE-LOCK" ~
            &Accion="RETRY" ~
            &Mensaje="YES" ~
            &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'"}
        DELETE B-DPEDI.
    END.
    /* Detalle */
    FOR EACH ITEM WHERE ITEM.ImpLin > 0 BY ITEM.NroItm: 
        CREATE FacDPedi.
        BUFFER-COPY ITEM TO FacDPedi.
    END.
    /* ****************************************************************************************** */
    {vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
    /* ****************************************************************************************** */
    FIND CURRENT Faccpedi NO-LOCK.
END.
RUN Procesa-Handle IN lh_handle ('browse').
MESSAGE 'Importación Exitosa' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* *********************************** */
PROCEDURE Importar-Detalle-Excel-Marco:
/* *********************************** */
DEF OUTPUT PARAMETER cTipoPrecio AS CHAR.
DEF VAR I-NPEDI AS INT NO-UNDO.

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
/* 1ro el Cliente */
cValue = chWorkSheet:Cells(11,1):VALUE.      
ASSIGN
    cValue = SUBSTRING(cValue,12,11)
    NO-ERROR.
IF cValue = "" OR cValue = ? OR ERROR-STATUS:ERROR = YES THEN DO:
    MESSAGE 'No hay datos del cliente:' cValue VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
IF Faccpedi.codcli <> cValue THEN DO:
    MESSAGE 'Cliente errado' SKIP
        'Cliente:' cValue 'errado'
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
/* 2do la Cotización */
cValue = chWorkSheet:Cells(9,7):VALUE.      
ASSIGN
    cValue = REPLACE(cValue,'-','')
    NO-ERROR.
IF cValue = "" OR cValue = ? OR error-status:ERROR = YES THEN DO:
    MESSAGE 'No hay datos del número de cotización:' cValue VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
IF Faccpedi.nroped <> cValue THEN DO:
    MESSAGE 'Formato del archivo Excel errado' SKIP
        'Número de pedido:' cValue 'errado'
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
/* Cargamos detalle */
ASSIGN
    t-Row = 21
    I-NPEDI = 0.
REPEAT:
    ASSIGN
        t-Row  = t-Row + 1
        I-NPEDI = I-NPEDI + 1.

    cValue = chWorkSheet:Cells(t-Row, 2):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 

    /* Artículo */
    ASSIGN
        cValue = STRING(INTEGER(cValue), '999999')
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN NEXT.
    CREATE PEDI.
    ASSIGN
        PEDI.NroItm = I-NPEDI
        PEDI.codcia = s-codcia
        PEDI.codmat = cValue.
    /* Cantidad */
    cValue = chWorkSheet:Cells(t-Row, 3):VALUE.
    ASSIGN
        PEDI.canped = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR PEDI.canPed <= 0 THEN DO:
        MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
            "Cantidad Pedida" VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* Unidad */
    cValue = chWorkSheet:Cells(t-Row, 4):VALUE.
    ASSIGN
        PEDI.UndVta = cValue
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR PEDI.UndVta = "" THEN DO:
        MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
            "Unidad de Venta" VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* Unitario */
    cValue = chWorkSheet:Cells(t-Row, 8):VALUE.
    ASSIGN
        PEDI.PreUni = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR PEDI.PreUni = 0 THEN DO:
        MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
            "Precio Unitario" VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* Total */
    cValue = chWorkSheet:Cells(t-Row, 8):VALUE.
    ASSIGN
        PEDI.ImpLin = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR PEDI.ImpLin = 0 THEN DO:
        MESSAGE "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  SKIP
            "Total" VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
END.
/* Buscamos si están o no con igv */
cValue = chWorkSheet:Cells(t-Row + 4, 1):VALUE.
CASE TRUE:
    WHEN INDEX(cValue, 'NO INCLUYEN') > 0   THEN cTipoPrecio = "SIN IGV".
    WHEN INDEX(cValue, 'INCLUYEN') > 0      THEN cTipoPrecio = "CON IGV".
END CASE.
IF cTipoPrecio = "SIN IGV" THEN DO:
    FOR EACH PEDI:
        ASSIGN
            PEDI.PreUni = PEDI.PreUni * (1 + Faccpedi.PorIgv / 100)
            PEDI.ImpLin = ROUND(PEDI.ImpLin * (1 + Faccpedi.PorIgv / 100), 2).
    END.
END.
/* Borramos cantidades en cero */
I-NPEDI = I-NPEDI - 1.
FOR EACH PEDI WHERE PEDI.CanPed <= 0:
    I-NPEDI = I-NPEDI - 1.
    DELETE PEDI.
END.

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

  /* FRONT-END */

  DEFINE VAR x-tabla AS CHAR INIT "FRONT-END".
  DEFINE VAR x-ventana AS CHAR INIT "COTIZACIONES".
  
  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                            vtatabla.tabla = x-tabla AND 
                            vtatabla.llave_c1 = x-ventana AND 
                            vtatabla.llave_c2 = s-coddiv NO-LOCK NO-ERROR.

  h_f-cot-gral-envio-admin:VISIBLE = YES.
  IF AVAILABLE vtatabla THEN DO:
      h_f-cot-gral-envio-admin:VISIBLE = NO.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Posiciona-Registro W-Win 
PROCEDURE Posiciona-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID NO-UNDO.

RUN Posiciona-Registro IN h_q-pedido
    ( INPUT pRowid /* ROWID */).





END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Botones W-Win 
PROCEDURE Procesa-Botones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER L-Handle AS CHAR.

DEF VAR pRowid AS ROWID NO-UNDO.
DEF VAR pRowidS AS ROWID NO-UNDO.

CASE L-Handle:
    WHEN "Exportar-a-Pdf" THEN DO:
         RUN Exportar-a-Pdf IN h_v-cotizacion-unificada.
    END.
    WHEN "Exportar-a-Excel" THEN DO:
        DEF VAR lChoice AS LOG NO-UNDO.
        IF s-CodDiv <> "00101" THEN DO:
            MESSAGE '¿Desea generar el documento marque?'  SKIP
                '   1. Si = Incluye IGV.      ' SKIP
                '   2. No = No incluye IGV.   ' 
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE lchoice.
            IF lchoice = ? THEN RETURN 'adm-error'.
        END.
        CASE TRUE :
            WHEN INDEX(gn-divi.canalventa, "MIN") > 0
                THEN RUN Excel_Utilex IN h_v-cotizacion-unificada (INPUT lchoice) .
            WHEN s-CodDiv = '00101' THEN 
                RUN Genera-Excel-Delivery IN h_v-cotizacion-unificada (INPUT YES).   /* Siempre con IGV */
            OTHERWISE RUN Genera-Excel2 IN h_v-cotizacion-unificada (INPUT lchoice) .
        END CASE.
    END.
    WHEN "Transferencia-de-Saldos" THEN DO:
        RUN Devuelve-Registro IN h_q-pedido ( OUTPUT pRowid /* ROWID */).
        IF pRowid <> ? THEN DO:
            RUN Transferencia-de-Saldos (INPUT pRowid, OUTPUT pRowidS).
            IF pRowidS <> ? THEN RUN Posiciona-Registro IN h_q-pedido ( INPUT pRowidS /* ROWID */).
        END.
/*         DEF VAR pRowidS AS ROWID.                                                               */
/*         RUN Transferencia-de-Saldos IN h_v-cotizacion-unificada ( OUTPUT pRowidS /* ROWID */).  */
/*         IF pRowidS <> ? THEN RUN Posiciona-Registro IN h_q-pedido ( INPUT pRowidS /* ROWID */). */
    END.
    WHEN "Captura-Historico-Cotizaciones" THEN DO:
        RUN Captura-Historico-Cotizaciones IN h_v-cotizacion-unificada.
    END.
    WHEN "Importar-Excel-2015" THEN DO:
        RUN Importar-Excel-2015 IN h_v-cotizacion-unificada.
    END.
    WHEN "Importar-Excel-Provincias" THEN DO:
        RUN Importar-Excel-Provincias IN h_v-cotizacion-unificada.
    END.
    WHEN "Importar-Excel-Marco" THEN DO:
        RUN Importar-Excel-Marco.
    END.
    WHEN "Importar-listaexpress-iversa" THEN DO:
        /*RUN Importar-listaexpress-iversa IN h_v-cotizacion-unificada.*/
        RUN Importar-listaexpress IN h_v-cotizacion-unificada.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN NO-APPLY.
        MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
    END.
    WHEN "Importar-tiendas-B2B" THEN DO:
        RUN Importar-tiendas-B2B IN h_v-cotizacion-unificada.
    END.
    WHEN "Edi-Comparativo" THEN DO:
        /*RUN Edi-Comparativo IN h_v-cotizacion-unificada.*/
        RUN Devuelve-Registro IN h_q-pedido ( OUTPUT pRowid /* ROWID */).
        IF pRowid <> ? AND CAN-FIND(FIRST Faccpedi WHERE ROWID(Faccpedi) = pRowid 
                                    AND Faccpedi.FlgEst <> "A" NO-LOCK)
            THEN RUN vta2\r-impcot-superm (pRowid).
    END.
    WHEN "Importar-Supermercados" THEN DO:
        RUN Importar-Supermercados IN h_v-cotizacion-unificada.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN NO-APPLY.
        RUN dispatch IN h_t-cotizacion-unificada ('open-query':U).
    END.
    WHEN "Importar-PET" THEN DO:
        RUN Importar-PET IN h_v-cotizacion-unificada.
    END.
    WHEN "Sede-Cliente" THEN DO:
        IF TRUE <> (s-CodCli > '') THEN RETURN.
        RUN logis/d-cliente-sede.w (INPUT s-CodCli).
    END.
    WHEN "Actualiza-datos-cliente" THEN DO:
        RUN Actualiza-datos-cliente IN h_v-cotizacion-unificada.
    END.
    WHEN "Cuenta-Corriente" THEN DO:
        RUN Cuenta-Corriente IN h_v-cotizacion-unificada.
    END.
    WHEN "Enviar-al-Administrador" THEN DO:
        RUN dispatch IN h_v-cotizacion-unificada ('Enviar-al-Administrador').
    END.
    WHEN "Enviar-al-Administrador-Off" THEN DO:
        RUN dispatch IN h_f-cot-gral-envio-admin ('hide':U).
    END.
    WHEN "Enviar-al-Administrador-On" THEN DO:
        RUN dispatch IN h_f-cot-gral-envio-admin ('view':U).
    END.
    WHEN "Importar-MarketPlace" THEN DO:
        RUN Importar-MarketPlace IN h_v-cotizacion-unificada.
        RUN dispatch IN h_q-pedido ('open-query':U).
    END.
    WHEN 'Genera-Cotizacion-Eventos' THEN DO:
        RUN Genera-Cotizacion-Eventos.
    END.
    OTHERWISE DO:
        MESSAGE 'ERROR, Rutina NO definida:' L-Handle VIEW-AS ALERT-BOX WARNING.
    END.
END CASE.

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
            /*Btn-Excel:SENSITIVE = YES*/
            BUTTON-Excel-Trabajo:SENSITIVE = YES
            BUTTON-Excel-Trabajo:VISIBLE = YES
            .
        RUN dispatch IN h_q-pedido ('enable':U).
        IF h_b-cotizacion-general <> ? THEN RUN dispatch IN h_b-cotizacion-general ('open-query':U).
        /* BOTONERAS */
        RUN dispatch IN h_f-cot-gral-expo-pag1 ('hide':U).
        RUN dispatch IN h_f-imp-excel-plantilla ('hide':U).
        /*RUN dispatch IN h_f-imp-le-2016 ('hide':U).*/
        RUN dispatch IN h_f-cot-gral-super ('hide':U).
        RUN dispatch IN h_f-cot-gral-expo-import ('hide':U).
        RUN dispatch IN h_f-cot-gral-envio-admin ('hide':U).
        RUN dispatch IN h_f-cot-gral-imp-market ('hide':U).
        RUN dispatch IN h_f-gen-cot-even ('hide':U).
        CASE s-TpoPed:
            WHEN "S" THEN DO:       /* Supermercados */
                RUN dispatch IN h_f-cot-gral-super ('view':U).
            END.
            WHEN "R" OR WHEN "NXTL" THEN DO:
            END.
            WHEN "E" THEN DO:      /* Eventos */
                RUN dispatch IN h_f-cot-gral-expo-pag1 ('view':U).
                RUN dispatch IN h_f-cot-gral-expo-import ('view':U).
                RUN dispatch IN h_f-gen-cot-even ('view':U).

                RUN dispatch IN h_f-cot-gral-exporta-a-excel ('hide':U).

            END.
            WHEN "M" OR WHEN "I" THEN DO:
                RUN dispatch IN h_f-imp-excel-plantilla ('view':U).
            END.
            WHEN "LF" THEN DO:   /* Lista Express */
                /*RUN dispatch IN h_f-imp-le-2016 ('view':U).*/
                RUN dispatch IN h_f-cot-gral-imp-market ('view':U).
            END.
            OTHERWISE DO:
            END.
        END CASE.
        /* Repintamos pantalla */
        RUN dispatch IN h_v-cotizacion-unificada ('display-fields':U).
    END.
    WHEN "Pagina2"  THEN DO WITH FRAME {&FRAME-NAME}:
        RUN select-page(2).
        ASSIGN
            COMBO-NroSer:SENSITIVE = NO
            /*Btn-Excel:SENSITIVE    = NO*/
            BUTTON-Excel-Trabajo:SENSITIVE = NO
            BUTTON-Excel-Trabajo:VISIBLE = NO
            .
        RUN dispatch IN h_q-pedido ('disable':U).
        RUN dispatch IN h_t-cotizacion-unificada ('open-query':U).
        /* BOTONERAS */
        /* RUN dispatch IN h_f-cot-gral-imp-ped-excel ('hide':U).   13/10/2020 Mayra Padilla: para todos */
        RUN dispatch IN h_f-cot-gral-imp-excel-provi ('hide':U).
        RUN dispatch IN h_f-cot-gral-matriz-de-ventas ('hide':U).
        RUN dispatch IN h_f-cot-gral-super-pag2 ('hide':U).
        RUN dispatch IN h_f-cot-gral-cotrecu ('hide':U).
        RUN dispatch IN h_f-cot-gral-envio-admin ('hide':U).
        CASE s-TpoPed:
            WHEN "S" THEN DO:       /* Supermercados */
                RUN dispatch IN h_f-cot-gral-imp-ped-excel ('view':U).
                RUN dispatch IN h_f-cot-gral-super-pag2 ('view':U).
            END.
            WHEN "E" THEN DO:      /* Eventos */
                RUN dispatch IN h_f-cot-gral-imp-ped-excel ('view':U).
            END.
            WHEN "P" THEN DO:      /* Provincias */
                RUN dispatch IN h_f-cot-gral-imp-ped-excel ('view':U).
                RUN dispatch IN h_f-cot-gral-imp-excel-provi ('view':U).
            END.
            WHEN "I" THEN DO:
                RUN dispatch IN h_f-cot-gral-cotrecu ('view':U).
            END.
            WHEN "M" OR WHEN "R" OR WHEN "NXTL" THEN DO:
            END.
            OTHERWISE DO:
                RUN dispatch IN h_f-cot-gral-matriz-de-ventas ('view':U).
            END.
        END CASE.
    END.
    WHEN "Pagina4"  THEN DO WITH FRAME {&FRAME-NAME}:
        RUN select-page(4).
    END.
    WHEN "Disable-Head" THEN DO:
        RUN dispatch IN h_p-updv01 ('disable':U).
        RUN dispatch IN h_v-cotizacion-unificada ('disable-fields':U).
        RUN dispatch IN h_f-cot-gral-pag2 ('disable':U).
        RUN dispatch IN h_f-cot-gral-imp-ped-excel ('disable':U).
        RUN dispatch IN h_f-imp-excel-plantilla ('disable':U).
        RUN dispatch IN h_f-cot-gral-matriz-de-ventas ('disable':U).
        RUN dispatch IN h_f-cot-gral-sede-cliente-2 ('disable':U).
    END.
    WHEN "Enable-Head" THEN DO:
        RUN dispatch IN h_p-updv01 ('enable':U).
        RUN dispatch IN h_v-cotizacion-unificada ('enable-fields':U).
        RUN dispatch IN h_f-cot-gral-pag2 ('enable':U).
        RUN dispatch IN h_f-cot-gral-imp-ped-excel ('enable':U).
        RUN dispatch IN h_f-imp-excel-plantilla ('enable':U).
        RUN dispatch IN h_f-cot-gral-matriz-de-ventas ('enable':U).
        RUN dispatch IN h_f-cot-gral-sede-cliente-2 ('enable':U).
    END.
    WHEN "browse" THEN DO:
          IF h_b-cotizacion-general <> ? THEN RUN dispatch IN h_b-cotizacion-general ('open-query':U).
          IF h_t-cotizacion-unificada <> ? THEN RUN dispatch IN h_t-cotizacion-unificada ('open-query':U). 
    END.
    /*WHEN "Recalculo" THEN RUN Recalcular-Precios IN h_v-cotizacion-unificada.*/
    WHEN "Recalculo" THEN RUN Recalcular-Precios.
    WHEN "Add-Record"   THEN RUN notify IN h_p-updv12   ('add-record':U).
    WHEN 'Open-Query-Master' THEN RUN dispatch IN h_q-pedido ('open-query':U).
    WHEN "Ultimo-Registro" THEN DO:
        RUN dispatch IN h_q-pedido ('open-query':U).
        RUN dispatch IN h_q-pedido ('get-last':U).
        RUN dispatch IN h_v-cotizacion-unificada ('display-fields':U).
        RUN dispatch IN h_b-cotizacion-general ('open-query':U).
    END.
    OTHERWISE DO:
        MESSAGE 'ERROR, Rutina NO definida:' L-Handle VIEW-AS ALERT-BOX WARNING.
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios W-Win 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ************************************************************************ */
/* RHC 06/11/2017 NO recalcular precios para CANAL MODERNO NI LISTA EXPRESS */
/* ************************************************************************ */
IF s-TpoPed = "LF" THEN RETURN.     /* LISTA EXPRESS */
IF s-TpoPed = "S" AND s-Import-B2B = YES THEN RETURN.   /* SUPERMERCADOS */
IF s-TpoPed = "S" AND s-Import-IBC = YES THEN RETURN.   /* SUPERMERCADOS */
/*IF s-TpoPed = "S" AND s-Import-Cissac = YES THEN RETURN.   /* SUPERMERCADOS */*/

/* ******************************************************* */
/* ******************************************************* */
/* ARTIFICIO */
IF S-TPOMARCO = "SI" THEN RUN Recalcular-Precio-TpoPed ("M").
ELSE RUN Recalcular-Precio-TpoPed (s-TpoPed).

RUN Procesa-Handle ('Browse').

END PROCEDURE.

PROCEDURE Recalcular-Precio-TpoPed:
/* ***************************** */

    DEF INPUT PARAMETER pTpoPed AS CHAR.

    DEF VAR x-articulo-ICBPer AS CHAR INIT '099268'.
    DEF VAR pMensaje AS CHAR NO-UNDO.

    {vtagn/recalcular-cotizacion-unificada-v2.i &pTpoPed=pTpoPed}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Transferencia-de-Saldos W-Win 
PROCEDURE Transferencia-de-Saldos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pRowidS AS ROWID.

DEFINE VAR hProc AS HANDLE NO-UNDO.
RUN vtagn/ventas-library PERSISTENT SET hProc.
RUN COT_Transferir-Saldo IN hProc (INPUT pRowid,
                                   INPUT pCodDiv,
                                   OUTPUT pRowidS).
DELETE PROCEDURE hProc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

