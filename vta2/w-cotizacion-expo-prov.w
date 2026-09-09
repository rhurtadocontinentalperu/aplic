&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE ITEM LIKE FacDPedi.



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

  History: 
          
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
DEF INPUT PARAMETER pCodDoc AS CHAR.

DEF NEW SHARED VAR s-NroSer AS INT.
DEF NEW SHARED VAR s-CodDoc AS CHAR.
DEF NEW SHARED VAR s-tpoped AS CHAR.
DEF NEW SHARED VAR s-CodMon AS INT.
DEF NEW SHARED VAR s-CodCli AS CHAR.
DEF NEW SHARED VAR s-cndvta AS CHAR.
DEF NEW SHARED VAR s-tpocmb AS DEC.
DEF NEW SHARED VAR lh_handle AS HANDLE.
DEF NEW SHARED VAR s-porigv AS DEC.
DEF NEW SHARED VAR s-nrodec AS INT.
DEF NEW SHARED VAR s-flgigv AS LOG.
DEF NEW SHARED VAR s-import-ibc AS LOG INIT NO.
DEF NEW SHARED VAR s-import-cissac AS LOG INIT NO.
DEF NEW SHARED VAR s-adm-new-record AS CHAR.
DEF NEW SHARED VARIABLE S-NROPED AS CHAR.


DEF NEW SHARED TEMP-TABLE T-DPEDI LIKE FacDPedi.

DEF SHARED VAR s-codcia AS INT.
/*DEF SHARED VAR s-coddiv AS CHAR.*/
DEF SHARED VAR s-codven AS CHAR.

s-CodDoc = ENTRY(1, pCodDoc).
IF NUM-ENTRIES(pCodDoc) > 1 THEN s-TpoPed = ENTRY(2, pCodDoc).
/* Posible valores para s-CodDoc:
COT: Cotizaciones
PED: Pedidos
*/
/* Posibles valores para s-TpoPed:
N: Venta normal
M: Contrato Marco
S: Supermercados
R: Remates
*/
/* RHC 31/10/2012 LA DIVISION VA A SER UN PARAMETRO */
DEF NEW SHARED VAR s-coddiv AS CHAR.
IF NUM-ENTRIES(pCodDoc) > 2 THEN s-CodDiv = ENTRY(3, pCodDoc).

/* CONTROL DE ALMACENES DE DESCARGA */
DEF NEW SHARED VAR s-CodAlm AS CHAR.

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
DEF NEW SHARED VAR s-DiasVtoCot LIKE GN-DIVI.DiasVtoCot.
DEF NEW SHARED VAR s-DiasAmpCot LIKE GN-DIVI.DiasAmpCot.
DEF NEW SHARED VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEF NEW SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEF NEW SHARED VAR s-FlgRotacion LIKE GN-DIVI.FlgRotacion.
DEF NEW SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEF NEW SHARED VAR s-FlgTipoVenta LIKE GN-DIVI.FlgPreVta.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' s-coddiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.
ASSIGN
    s-DiasVtoCot = GN-DIVI.DiasVtoCot
    s-DiasAmpCot = GN-DIVI.DiasAmpCot
    s-FlgEmpaque = GN-DIVI.FlgEmpaque
    s-FlgMinVenta = GN-DIVI.FlgMinVenta
    s-FlgRotacion = GN-DIVI.FlgRotacion
    s-VentaMayorista = GN-DIVI.VentaMayorista
    s-FlgTipoVenta = GN-DIVI.FlgPreVta.

/* EL VENDEDOR MANDA */
/* FIND gn-ven WHERE gn-ven.codcia = s-codcia                                            */
/*     AND gn-ven.codven = s-codven                                                      */
/*     NO-LOCK NO-ERROR.                                                                 */
/* IF AVAILABLE gn-ven AND gn-ven.Libre_c01 <> '' THEN s-FlgRotacion = gn-ven.Libre_c01. */
/* ***************** */

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
&Scoped-Define ENABLED-OBJECTS RECT-24 COMBO-NroSer BTN-Excel BUTTON-EDI ~
BUTTON-FROM-EXCEL 
&Scoped-Define DISPLAYED-OBJECTS COMBO-NroSer 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-cotizacion-cred AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-pedido AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-cotizacion-cred AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-cotizacion-cred AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-CCTE 
     LABEL "CUENTA CORRIENTE" 
     SIZE 22 BY 1.08.

DEFINE BUTTON B-CLI 
     LABEL "ACTUALIZA DATOS CLIENTE" 
     SIZE 23 BY 1.12.

DEFINE BUTTON BTN-Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Button 1" 
     SIZE 10 BY 1.35.

DEFINE BUTTON Btn-Grupos 
     LABEL "CODIGOS AGRUPADOS" 
     SIZE 20 BY .96.

DEFINE BUTTON BUTTON-CISSAC 
     LABEL "IMPORTAR O/C CISSAC" 
     SIZE 19 BY .96.

DEFINE BUTTON BUTTON-COT 
     LABEL "HISTORIAL COTIZACIONES" 
     SIZE 22 BY 1.08.

DEFINE BUTTON BUTTON-EDI 
     LABEL "EDI COMPARATIVO" 
     SIZE 17 BY 1.35 TOOLTIP "Cotización Supermercados Precios EDI vs CONTI".

DEFINE BUTTON BUTTON-FROM-EXCEL 
     LABEL "Desde Cotizacion de Provincia" 
     SIZE 27 BY .96
     FGCOLOR 9 FONT 1.

DEFINE BUTTON BUTTON-Migrar-Provi 
     LABEL "MIGRAR A PROVINCIAS" 
     SIZE 22 BY .96.

DEFINE BUTTON BUTTON-SUPERMERCADOS 
     LABEL "IMPORTAR SUPERMERCADOS" 
     SIZE 28 BY .96.

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U INITIAL "0" 
     LABEL "Serie" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 117 BY 8.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-NroSer AT ROW 1.27 COL 79.71 WIDGET-ID 4
     BTN-Excel AT ROW 2.35 COL 120 WIDGET-ID 16
     BUTTON-EDI AT ROW 3.69 COL 120 WIDGET-ID 24
     BUTTON-Migrar-Provi AT ROW 5.04 COL 120 WIDGET-ID 26
     B-CCTE AT ROW 7.46 COL 119 WIDGET-ID 12
     BUTTON-COT AT ROW 8.54 COL 119 WIDGET-ID 14
     B-CLI AT ROW 9.62 COL 119 WIDGET-ID 22
     Btn-Grupos AT ROW 23.35 COL 37 WIDGET-ID 10
     BUTTON-SUPERMERCADOS AT ROW 23.35 COL 57 WIDGET-ID 18
     BUTTON-CISSAC AT ROW 23.35 COL 85 WIDGET-ID 20
     BUTTON-FROM-EXCEL AT ROW 23.35 COL 106.86 WIDGET-ID 28
     "Buscar el número:" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 1.54 COL 92 WIDGET-ID 6
     RECT-24 AT ROW 2.35 COL 2 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 143.43 BY 23.5
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
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "COTIZACIONES AL CREDITO"
         HEIGHT             = 23.5
         WIDTH              = 143.43
         MAX-HEIGHT         = 25.46
         MAX-WIDTH          = 164.43
         VIRTUAL-HEIGHT     = 25.46
         VIRTUAL-WIDTH      = 164.43
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
/* SETTINGS FOR BUTTON Btn-Grupos IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       Btn-Grupos:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-CISSAC IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-CISSAC:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-COT IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-FROM-EXCEL:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-Migrar-Provi IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-Migrar-Provi:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-SUPERMERCADOS IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-SUPERMERCADOS:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME F-Main
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* COTIZACIONES AL CREDITO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* COTIZACIONES AL CREDITO */
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
   RUN Actualiza-datos-cliente IN h_v-cotizacion-cred.
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
    CASE s-coddiv :
        WHEN '00023' OR WHEN '00024' THEN RUN Excel_Utilex IN h_v-cotizacion-cred (INPUT lchoice) .
        OTHERWISE RUN Genera-Excel2 IN h_v-cotizacion-cred (INPUT lchoice) .
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Grupos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Grupos W-Win
ON CHOOSE OF Btn-Grupos IN FRAME F-Main /* CODIGOS AGRUPADOS */
DO:
    IF s-Import-IBC = YES THEN RETURN NO-APPLY.
    RUN vta2/d-codagrupado-cred.
    RUN dispatch IN h_t-cotizacion-cred ('open-query').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-CISSAC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-CISSAC W-Win
ON CHOOSE OF BUTTON-CISSAC IN FRAME F-Main /* IMPORTAR O/C CISSAC */
DO:
  RUN Importar-entre-companias IN h_v-cotizacion-cred.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN NO-APPLY.
  RUN dispatch IN h_t-cotizacion-cred ('open-query':U).
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


&Scoped-define SELF-NAME BUTTON-EDI
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-EDI W-Win
ON CHOOSE OF BUTTON-EDI IN FRAME F-Main /* EDI COMPARATIVO */
DO:
  RUN Edi-Comparativo IN h_v-cotizacion-cred.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-FROM-EXCEL
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-FROM-EXCEL W-Win
ON CHOOSE OF BUTTON-FROM-EXCEL IN FRAME F-Main /* Desde Cotizacion de Provincia */
DO:
  RUN desde_cotiz_Excel IN h_v-cotizacion-cred.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN NO-APPLY.
  /*RUN recalcular-precioas IN h_t-cotizacion-cred.*/
  RUN dispatch IN h_t-cotizacion-cred ('open-query':U).
    RUN Recalcular-Precios IN h_t-cotizacion-cred.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Migrar-Provi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Migrar-Provi W-Win
ON CHOOSE OF BUTTON-Migrar-Provi IN FRAME F-Main /* MIGRAR A PROVINCIAS */
DO:
  RUN Migrar-a-Provincias IN h_v-cotizacion-cred.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-SUPERMERCADOS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-SUPERMERCADOS W-Win
ON CHOOSE OF BUTTON-SUPERMERCADOS IN FRAME F-Main /* IMPORTAR SUPERMERCADOS */
DO:
    RUN Importar-Supermercados IN h_v-cotizacion-cred.
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN NO-APPLY.
    RUN dispatch IN h_t-cotizacion-cred ('open-query':U).
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
    WHEN "NXTL" THEN W-Win:TITLE = W-Win:TITLE + "- NEXTEL".
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
       RUN set-size IN h_p-updv01 ( 1.42 , 73.57 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico-2 ).
       RUN set-position IN h_p-navico-2 ( 1.00 , 115.00 ) NO-ERROR.
       RUN set-size IN h_p-navico-2 ( 1.35 , 20.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/v-cotizacion-cred.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-cotizacion-cred ).
       RUN set-position IN h_v-cotizacion-cred ( 2.62 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 8.35 , 115.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/q-pedido.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-pedido ).
       RUN set-position IN h_q-pedido ( 1.00 , 105.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.35 , 9.00 ) */

       /* Links to SmartViewer h_v-cotizacion-cred. */
       RUN add-link IN adm-broker-hdl ( h_p-updv01 , 'TableIO':U , h_v-cotizacion-cred ).
       RUN add-link IN adm-broker-hdl ( h_q-pedido , 'Record':U , h_v-cotizacion-cred ).

       /* Links to SmartQuery h_q-pedido. */
       RUN add-link IN adm-broker-hdl ( h_p-navico-2 , 'Navigation':U , h_q-pedido ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv01 ,
             COMBO-NroSer:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico-2 ,
             h_p-updv01 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-cotizacion-cred ,
             BTN-Excel:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-pedido ,
             BUTTON-FROM-EXCEL:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/b-cotizacion-cred.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cotizacion-cred ).
       RUN set-position IN h_b-cotizacion-cred ( 11.19 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-cotizacion-cred ( 12.92 , 141.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-cotizacion-cred. */
       RUN add-link IN adm-broker-hdl ( h_q-pedido , 'Record':U , h_b-cotizacion-cred ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-cotizacion-cred ,
             B-CLI:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta2/t-cotizacion-cred.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-cotizacion-cred ).
       RUN set-position IN h_t-cotizacion-cred ( 11.50 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-cotizacion-cred ( 11.85 , 141.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 22.54 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 1.42 , 34.14 ) NO-ERROR.

       /* Links to SmartBrowser h_t-cotizacion-cred. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_t-cotizacion-cred ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-cotizacion-cred ,
             B-CLI:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_t-cotizacion-cred , 'AFTER':U ).
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
  ENABLE RECT-24 COMBO-NroSer BTN-Excel BUTTON-EDI BUTTON-FROM-EXCEL 
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
             Btn-Grupos:SENSITIVE = NO
             Btn-Grupos:VISIBLE = NO
             B-CCTE:SENSITIVE = NO
             BUTTON-COT:SENSITIVE = NO
             BUTTON-SUPERMERCADOS:SENSITIVE = NO
             BUTTON-SUPERMERCADOS:VISIBLE = NO
             BUTTON-CISSAC:SENSITIVE = NO
             BUTTON-CISSAC:VISIBLE = NO
             Btn-Excel:SENSITIVE = YES
             B-CLI:SENSITIVE = NO
             BUTTON-EDI:SENSITIVE = NO
             BUTTON-Migrar-Provi:SENSITIVE = NO
             BUTTON-Migrar-Provi:VISIBLE = NO.
            BUTTON-from-excel:SENSITIVE = NO.
            BUTTON-from-excel:VISIBLE = NO.
         IF s-coddiv = '10018' THEN
             ASSIGN
                BUTTON-Migrar-Provi:SENSITIVE = YES
                BUTTON-Migrar-Provi:VISIBLE = YES.
         CASE s-TpoPed:
             WHEN "M" OR WHEN "R" OR WHEN "NXTL" THEN DO:
             END.
             WHEN "S" THEN DO:  /* Supermercados */
                 BUTTON-EDI:SENSITIVE = YES.
             END.
             OTHERWISE DO:
             END.
         END CASE.
         RUN dispatch IN h_q-pedido ('enable':U).
      END.
    WHEN "Pagina2"  THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(2).
         ASSIGN
             COMBO-NroSer:SENSITIVE = NO
             Btn-Grupos:SENSITIVE = YES
             Btn-Grupos:VISIBLE = YES
             B-CCTE:SENSITIVE = YES
             BUTTON-COT:SENSITIVE = YES
             Btn-Excel:SENSITIVE    = NO
             B-CLI:SENSITIVE = YES
             BUTTON-EDI:SENSITIVE = NO
             BUTTON-Migrar-Provi:SENSITIVE = NO
             BUTTON-Migrar-Provi:VISIBLE = NO.
         BUTTON-from-excel:SENSITIVE = YES.
         BUTTON-from-excel:VISIBLE = YES.

         CASE s-TpoPed:
             WHEN "M" OR WHEN "R" OR WHEN "NXTL" THEN DO:
             END.
             WHEN "S" THEN DO:  /* Supermercados */
                 BUTTON-SUPERMERCADOS:SENSITIVE = YES.
                 BUTTON-SUPERMERCADOS:VISIBLE = YES.
             END.
             OTHERWISE DO:
                 BUTTON-CISSAC:SENSITIVE = YES.
                 BUTTON-CISSAC:VISIBLE = YES.
             END.
         END CASE.
         RUN dispatch IN h_q-pedido ('disable':U).
         RUN dispatch IN h_t-cotizacion-cred ('open-query':U).
      END.
    WHEN "Disable-Head" THEN DO:
        RUN dispatch IN h_p-updv01 ('disable':U).
      END.
    WHEN "Enable-Head" THEN DO:
        RUN dispatch IN h_p-updv01 ('enable':U).
      END.
    WHEN "Disable-Button-IBC" THEN BUTTON-SUPERMERCADOS:SENSITIVE = NO.
    WHEN "Disable-Button-CISSAC" THEN BUTTON-CISSAC:SENSITIVE = NO.
    WHEN "Add-Record" THEN DO:
        RUN dispatch IN h_t-cotizacion-cred ('add-record':U).
      END.
    WHEN "browse" THEN DO:
          IF h_b-cotizacion-cred <> ? THEN RUN dispatch IN h_b-cotizacion-cred ('open-query':U).
          IF h_t-cotizacion-cred <> ? THEN RUN dispatch IN h_t-cotizacion-cred ('open-query':U). 
      END.
    WHEN "Recalculo" THEN DO WITH FRAME {&FRAME-NAME}:
         RUN Recalcular-Precios IN h_t-cotizacion-cred.
      END.
    WHEN 'IBC' THEN DO:
        RUN IBC-Diferencias IN h_t-cotizacion-cred.
    END.
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

