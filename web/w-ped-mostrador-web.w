&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM-3 LIKE FacDPedi.
DEFINE TEMP-TABLE PEDI-3 NO-UNDO LIKE FacDPedi.



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
&SCOPED-DEFINE Promocion web/promocion-general-flash.p

&SCOPED-DEFINE ARITMETICA-SUNAT YES

/* Parameters Definitions ---                                           */
DEF INPUT PARAMETER pEvento AS CHAR NO-UNDO.


/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-CodCia AS INTE.
DEF SHARED VAR s-CodDiv AS CHAR.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

DEF NEW SHARED VAR s-NroSer AS INT.
DEF NEW SHARED VAR s-CodDoc AS CHAR.
DEF NEW SHARED VAR s-tpoped AS CHAR.
DEF NEW SHARED VAR s-CodMon AS INT INIT 1.
DEF NEW SHARED VAR s-CodCli AS CHAR.
DEF NEW SHARED VAR s-cndvta AS CHAR INIT '000'.
DEF NEW SHARED VAR s-tpocmb AS DEC.
DEF NEW SHARED VAR lh_handle AS HANDLE.
DEF NEW SHARED VAR s-porigv AS DECI.
DEF NEW SHARED VAR s-nrodec AS INTE INIT 4.
DEF NEW SHARED VAR s-flgigv AS LOG INIT YES.
DEF NEW SHARED VAR S-FLGSIT AS CHAR INIT "T".
DEF NEW SHARED VAR s-adm-new-record AS CHAR.
DEF NEW SHARED VAR s-nroped AS CHAR.
DEF NEW SHARED VAR s-FmaPgo AS CHAR INIT "000".
DEF NEW SHARED VAR s-Cmpbnte AS CHAR INIT 'BOL'.
DEF NEW SHARED VAR s-CodVen AS CHAR.


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
        /* TODOS los Almacenes, menos los de remate */
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
DEF NEW SHARED VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEF NEW SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEF NEW SHARED VAR s-FlgRotacion LIKE GN-DIVI.FlgRotacion.
DEF NEW SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEF NEW SHARED VAR s-FlgTipoVenta LIKE GN-DIVI.FlgPreVta.
DEF NEW SHARED VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' s-coddiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.
ASSIGN
    s-FlgEmpaque = GN-DIVI.FlgEmpaque
    s-FlgMinVenta = GN-DIVI.FlgMinVenta
    s-FlgRotacion = GN-DIVI.FlgRotacion
    s-VentaMayorista = GN-DIVI.VentaMayorista
    s-FlgTipoVenta = GN-DIVI.FlgPreVta.

DEF NEW SHARED VAR s-Sunat-Activo AS LOG INIT NO.
s-Sunat-Activo = gn-divi.campo-log[10].

DEF VAR x-ClientesVarios AS CHAR NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK.
ASSIGN
    s-PorIgv          = FacCfgGn.PorIgv
    s-TpoCmb          = FacCfgGn.TpoCmb[1]
    x-ClientesVarios  = FacCfgGn.CliVar.

DEF VAR ImpMinPercep AS DEC INIT 1500 NO-UNDO.
DEF VAR ImpMinDNI    AS DEC INIT 700 NO-UNDO.
DEF VAR s-FlgEnv    AS LOG INIT YES NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = '099268'.

/* RHC 11.08.2014 TC Caja Compra */
FIND LAST gn-tccja WHERE gn-tccja.fecha <= TODAY AND gn-tccja.fecha <> ? NO-LOCK NO-ERROR.
IF AVAILABLE gn-tccja THEN s-TpoCmb = Gn-TCCja.Compra.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacCPedi

/* Definitions for FRAME F-Main                                         */
&Scoped-define QUERY-STRING-F-Main FOR EACH FacCPedi SHARE-LOCK
&Scoped-define OPEN-QUERY-F-Main OPEN QUERY F-Main FOR EACH FacCPedi SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-Main FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-F-Main FacCPedi


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-2 IMAGE-3 RECT-3 RECT-4 ~
RADIO-SET_FlgSit BUTTON-1 FILL-IN_CodCli FILL-IN_NomCli FILL-IN_DirCli ~
FILL-IN_LugEnt FILL-IN_Glosa RADIO-SET_Cmpbte 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET_FlgSit FILL-IN_CodCli ~
FILL-IN_RucCli FILL-IN_Atencion FILL-IN_NomCli FILL-IN_DirCli ~
FILL-IN_LugEnt FILL-IN_Glosa RADIO-SET_Cmpbte 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEsAlfabetico W-Win 
FUNCTION getEsAlfabetico RETURNS LOGICAL
  ( INPUT pCaracter AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSoloLetras W-Win 
FUNCTION getSoloLetras RETURNS LOGICAL
  ( INPUT pTexto AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-ped-mostrador-web-1-2 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "pda/shopping_cart.bmp":U
     LABEL "Button 1" 
     SIZE 15 BY 3.5 TOOLTIP "Revisar Carrito de Compras".

DEFINE VARIABLE FILL-IN_Atencion AS CHARACTER FORMAT "X(15)" 
     LABEL "DNI" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .81.

DEFINE VARIABLE FILL-IN_CodCli AS CHARACTER FORMAT "X(15)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_DirCli AS CHARACTER FORMAT "x(100)" 
     LABEL "Direcci¢n" 
     VIEW-AS FILL-IN 
     SIZE 72.86 BY .81.

DEFINE VARIABLE FILL-IN_Glosa AS CHARACTER FORMAT "x(80)" 
     LABEL "Glosa" 
     VIEW-AS FILL-IN 
     SIZE 73 BY .81.

DEFINE VARIABLE FILL-IN_LugEnt AS CHARACTER FORMAT "x(80)" 
     LABEL "Lugar de entrega" 
     VIEW-AS FILL-IN 
     SIZE 73 BY .81.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "x(100)" 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 72.86 BY .81.

DEFINE VARIABLE FILL-IN_RucCli AS CHARACTER FORMAT "x(15)" 
     LABEL "Ruc" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .81.

DEFINE IMAGE IMAGE-2
     FILENAME "aplic/pda/shopping_cart.bmp":U
     STRETCH-TO-FIT
     SIZE 13 BY 3.23 TOOLTIP "Revisar Carrito de Compras".

DEFINE IMAGE IMAGE-3
     FILENAME "aplic/pda/shopping_cart_accept.bmp":U
     STRETCH-TO-FIT
     SIZE 13 BY 3.23 TOOLTIP "Grabar Carrito de Compras".

DEFINE VARIABLE RADIO-SET_Cmpbte AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Factura", "FAC":U,
"Boleta", "BOL":U
     SIZE 18 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET_FlgSit AS CHARACTER INITIAL "T" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Efectivo", "",
"Tarjeta", "T"
     SIZE 20 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 185 BY 19.92.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 185 BY 6.19.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY F-Main FOR 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET_FlgSit AT ROW 1.27 COL 17 NO-LABEL WIDGET-ID 126
     BUTTON-1 AT ROW 1.54 COL 121 WIDGET-ID 134
     FILL-IN_CodCli AT ROW 2.08 COL 15 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_RucCli AT ROW 2.08 COL 35 COLON-ALIGNED HELP
          "Registro Unico de Contribuyente (Cliente)" WIDGET-ID 20
     FILL-IN_Atencion AT ROW 2.08 COL 55 COLON-ALIGNED WIDGET-ID 18
     FILL-IN_NomCli AT ROW 2.88 COL 15 COLON-ALIGNED HELP
          "Nombre del Cliente" WIDGET-ID 6
     FILL-IN_DirCli AT ROW 3.69 COL 15 COLON-ALIGNED HELP
          "Direcci¢n del Cliente" WIDGET-ID 4
     FILL-IN_LugEnt AT ROW 4.5 COL 15 COLON-ALIGNED WIDGET-ID 14
     FILL-IN_Glosa AT ROW 5.31 COL 15 COLON-ALIGNED WIDGET-ID 16
     RADIO-SET_Cmpbte AT ROW 6.12 COL 17 NO-LABEL WIDGET-ID 22
     "Cancela con:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 1.54 COL 6 WIDGET-ID 124
     "Comprobante:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 6.38 COL 7 WIDGET-ID 106
     IMAGE-2 AT ROW 1.54 COL 142 WIDGET-ID 8
     IMAGE-3 AT ROW 1.54 COL 161 WIDGET-ID 10
     RECT-3 AT ROW 7.19 COL 2 WIDGET-ID 130
     RECT-4 AT ROW 1 COL 2 WIDGET-ID 132
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 189.29 BY 26.15
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
      TABLE: ITEM-3 T "?" ? INTEGRAL FacDPedi
      TABLE: PEDI-3 T "?" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 26.15
         WIDTH              = 189.29
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN FILL-IN_Atencion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_RucCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _TblList          = "INTEGRAL.FacCPedi"
     _Query            is OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    RUN Devuelve-Temp-Table IN h_b-ped-mostrador-web-1-2 ( OUTPUT TABLE ITEM).
    RUN web/d-ped-mostrador-web-car.w (INPUT-OUTPUT TABLE ITEM).
    RUN Import-Temp-Table IN h_b-ped-mostrador-web-1-2 ( INPUT TABLE ITEM).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodCli W-Win
ON LEAVE OF FILL-IN_CodCli IN FRAME F-Main /* Cliente */
DO:
  FILL-IN_CodCli:SCREEN-VALUE = REPLACE(FILL-IN_CodCli:SCREEN-VALUE,".","").
  FILL-IN_CodCli:SCREEN-VALUE = REPLACE(FILL-IN_CodCli:SCREEN-VALUE,",","").

  IF FILL-IN_CodCli:SCREEN-VALUE = "" THEN RETURN.

  /* Verificar la Longuitud */
  DEFINE VAR x-data AS CHAR.
  x-data = TRIM(FILL-IN_CodCli:SCREEN-VALUE).
  IF LENGTH(x-data) < 11 THEN DO:
      x-data = FILL("0", 11 - LENGTH(x-data)) + x-data.
  END.

  FILL-IN_CodCli:SCREEN-VALUE = x-data.
  /**/

  S-CODCLI = SELF:SCREEN-VALUE.

  FIND FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA
      AND  gn-clie.CodCli = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:      /* CREA EL CLIENTE NUEVO */
      S-CODCLI = SELF:SCREEN-VALUE.
      RUN vtamay/d-regcli (INPUT-OUTPUT S-CODCLI).
      IF TRUE <> (S-CODCLI > "") THEN DO:
          APPLY "ENTRY" TO FILL-IN_CodCli.
          RETURN NO-APPLY.
      END.
      FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
          AND  gn-clie.CodCli = S-CODCLI 
          NO-LOCK NO-ERROR.
      SELF:SCREEN-VALUE = s-codcli.
  END.
  /* **************************************** */
  /* RHC 22/07/2020 Nuevo bloqueo de clientes */
  /* **************************************** */
  RUN pri/p-verifica-cliente (INPUT gn-clie.codcli,
                              INPUT s-CodDoc,
                              INPUT s-CodDiv).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  /* **************************************** */
  /* 13/05/2022: Verificar configuración del cliente */
  FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia
      AND VtaTabla.Tabla = 'CN-GN'
      AND VtaTabla.Llave_c1 =  Gn-Clie.Canal
      AND VtaTabla.Llave_c2 =  Gn-Clie.GirCli
      NO-LOCK NO-ERROR.
  IF AVAILABLE VtaTabla AND VtaTabla.Libre_c01 = "SI" THEN DO:
      MESSAGE 'El cliente pertenece a una institucion PUBLICA' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN_CodCli.
      RETURN NO-APPLY.
  END.
  s-CodCli = SELF:SCREEN-VALUE.
  /* *********************************************** */
  DISPLAY 
      gn-clie.NomCli  WHEN s-codcli <> x-ClientesVarios @ FILL-IN_NomCli
      gn-clie.Ruc     WHEN s-codcli <> x-ClientesVarios @ FILL-IN_RucCli
      gn-clie.Dni     WHEN s-codcli <> x-ClientesVarios @ FILL-IN_atencion
      gn-clie.DirCli  WHEN s-codcli <> x-ClientesVarios @ FILL-IN_DirCli
      WITH FRAME {&FRAME-NAME}.

  IF x-ClientesVarios = SELF:SCREEN-VALUE THEN DO:
      FILL-IN_NomCli:SCREEN-VALUE = gn-clie.NomCli.
  END.
      
  /* Si tiene RUC o Cliente Varios, Blanquear el DNI */
  CASE TRUE:
    WHEN TRIM(FILL-IN_CodCli:SCREEN-VALUE) = x-ClientesVarios THEN DO:
        FILL-IN_RucCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" .
        FILL-IN_atencion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
        FILL-IN_NomCli:SENSITIVE = YES.
        FILL-IN_DirCli:SENSITIVE = YES.
        FILL-IN_atencion:SENSITIVE = YES.
    END.
    WHEN gn-clie.Libre_C01 = "J" THEN DO:
        FILL-IN_atencion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
        FILL-IN_NomCli:SENSITIVE = NO.
        FILL-IN_DirCli:SENSITIVE = NO.
        FILL-IN_RucCli:SENSITIVE = NO.
        FILL-IN_atencion:SENSITIVE = NO.
    END.
    OTHERWISE DO:
        FILL-IN_RucCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" .
        FILL-IN_RucCli:SENSITIVE = NO.
        FILL-IN_atencion:SENSITIVE = NO.
        FILL-IN_NomCli:SENSITIVE = NO.
        FILL-IN_DirCli:SENSITIVE = NO.
    END.
  END CASE.

  /* Determina si es boleta o factura */
  IF TRUE <> (FILL-IN_RucCli:SCREEN-VALUE > '') THEN RADIO-SET_Cmpbte:SCREEN-VALUE = 'BOL'.
  ELSE RADIO-SET_Cmpbte:SCREEN-VALUE = 'FAC'.

  /* En caso NO tenga su dirección */
  IF TRUE <> (FILL-IN_DirCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} > '') THEN DO:
      FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Sede = "@@@" NO-LOCK NO-ERROR.
      IF AVAILABLE gn-clied THEN DISPLAY Gn-ClieD.DirCli @ FILL-IN_DirCli WITH FRAME {&FRAME-NAME}.
  END.

  APPLY 'VALUE-CHANGED' TO RADIO-SET_Cmpbte.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME IMAGE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL IMAGE-2 W-Win
ON MOUSE-SELECT-CLICK OF IMAGE-2 IN FRAME F-Main
DO:
  RUN Devuelve-Temp-Table IN h_b-ped-mostrador-web-1-2 ( OUTPUT TABLE ITEM).
  RUN web/d-ped-mostrador-web-car.w (INPUT-OUTPUT TABLE ITEM).
  RUN Import-Temp-Table IN h_b-ped-mostrador-web-1-2 ( INPUT TABLE ITEM).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME IMAGE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL IMAGE-3 W-Win
ON MOUSE-SELECT-CLICK OF IMAGE-3 IN FRAME F-Main
DO:
  RUN Devuelve-Temp-Table IN h_b-ped-mostrador-web-1-2 ( OUTPUT TABLE ITEM).
  RUN web/d-ped-mostrador-web-car.w (INPUT-OUTPUT TABLE ITEM).
  RUN Import-Temp-Table IN h_b-ped-mostrador-web-1-2 ( INPUT TABLE ITEM).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET_Cmpbte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET_Cmpbte W-Win
ON VALUE-CHANGED OF RADIO-SET_Cmpbte IN FRAME F-Main
DO:
  s-Cmpbnte = SELF:SCREEN-VALUE.
 /* Ic - 13Ago2020 */
  IF TRIM(FILL-IN_CodCli:SCREEN-VALUE) = x-ClientesVarios  THEN DO:
      FILL-IN_NomCli:SENSITIVE = YES.
      FILL-IN_DirCli:SENSITIVE = YES.
  END.
  ELSE DO:
      FILL-IN_NomCli:SENSITIVE = NO.
      FILL-IN_DirCli:SENSITIVE = NO.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET_FlgSit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET_FlgSit W-Win
ON VALUE-CHANGED OF RADIO-SET_FlgSit IN FRAME F-Main
DO:
  s-FlgSit = SELF:SCREEN-VALUE.
  RUN Recalcular-Precios IN h_b-ped-mostrador-web-1-2.
  RUN Pinta-Total IN h_b-ped-mostrador-web-1-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actualiza-prepedido W-Win 
PROCEDURE actualiza-prepedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ACTUALIZA LA COTIZACION EN BASE AL PEDIDO AL CREDITO */

  DEFINE INPUT PARAMETER pRowid AS ROWID.
  DEFINE INPUT PARAMETER pFactor AS INT.    /* +1 actualiza    -1 desactualiza */
  DEFINE OUTPUT PARAMETER pError AS CHAR NO-UNDO.

  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.

  DEFINE BUFFER B-DPEDI FOR FacDPedi.
  DEFINE BUFFER B-CPEDI FOR FacCPedi.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND B-CPedi WHERE B-CPedi.CodCia = FacCPedi.CodCia
          AND  B-CPedi.CodDiv = FacCPedi.CodDiv
          AND  B-CPedi.CodDoc = FacCPedi.CodRef
          AND  B-CPedi.NroPed = FacCPedi.NroRef
          EXCLUSIVE-LOCK NO-ERROR.
      IF pFactor = +1 THEN ASSIGN B-CPedi.FlgEst = "C".
      ELSE B-CPedi.FlgEst = "P".
  END.
  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/web/b-ped-mostrador-web-1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-ped-mostrador-web-1-2 ).
       RUN set-position IN h_b-ped-mostrador-web-1-2 ( 7.46 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-ped-mostrador-web-1-2 ( 19.38 , 182.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-ped-mostrador-web-1-2 ,
             RADIO-SET_Cmpbte:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 1 */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CREATE-TRANSACION W-Win 
PROCEDURE CREATE-TRANSACION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR i-Cuenta AS INTE NO-UNDO.

PRINCIPAL:                                                                                  
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}
    ASSIGN 
        FacCPedi.CodCia = S-CODCIA
        FacCPedi.CodDiv = S-CODDIV
        FacCPedi.CodDoc = s-coddoc 
        FacCPedi.CodAlm = s-CodAlm    /* Lista de Almacenes Válidos de Venta */
        FacCPedi.FchPed = TODAY 
        FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCPedi.TpoPed = s-TpoPed
        FacCPedi.FlgEst = (IF Faccpedi.CodCli BEGINS "SYS" THEN "I" ELSE "P")     /* PENDIENTE */
        FacCPedi.Libre_c01        = s-CodDiv      /* OJO */
        FacCPedi.Lista_de_Precios = s-CodDiv      /* OJO */
        NO-ERROR
        .
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="i-Cuenta"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RELEASE FacCorre.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DESCUENTOS-FINALES W-Win 
PROCEDURE DESCUENTOS-FINALES :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* ************************************************************************************** */
  /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
  /* ************************************************************************************** */
  DEF VAR hProc AS HANDLE NO-UNDO.
  RUN vtagn/ventas-library PERSISTENT SET hProc.
  RUN DCTO_VOL_LINEA IN hProc (INPUT ROWID(Faccpedi),
                               INPUT s-TpoPed,
                               INPUT s-CodDiv,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_VOL_SALDO IN hProc (INPUT ROWID(Faccpedi),
                               INPUT s-TpoPed,
                               INPUT s-CodDiv,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_IMP_ACUM IN hProc (INPUT ROWID(Faccpedi),
                              INPUT s-CodDiv,
                              OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  DELETE PROCEDURE hProc.

  RETURN 'OK'.

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

  {&OPEN-QUERY-F-Main}
  GET FIRST F-Main.
  DISPLAY RADIO-SET_FlgSit FILL-IN_CodCli FILL-IN_RucCli FILL-IN_Atencion 
          FILL-IN_NomCli FILL-IN_DirCli FILL-IN_LugEnt FILL-IN_Glosa 
          RADIO-SET_Cmpbte 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE IMAGE-2 IMAGE-3 RECT-3 RECT-4 RADIO-SET_FlgSit BUTTON-1 FILL-IN_CodCli 
         FILL-IN_NomCli FILL-IN_DirCli FILL-IN_LugEnt FILL-IN_Glosa 
         RADIO-SET_Cmpbte 
      WITH FRAME F-Main IN WINDOW W-Win.
  VIEW FRAME F-Main IN WINDOW W-Win.
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
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          s-CodCli = x-ClientesVarios
          FILL-IN_CodCli = s-CodCli.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION W-Win 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN Valida.
IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

DEF VAR LocalAdmNewRecord AS CHAR NO-UNDO.

CASE pEvento:
    WHEN "CREATE" THEN LocalAdmNewRecord = "YES".
    WHEN "UPDATE" THEN LocalAdmNewRecord = "NO".
    OTHERWISE RETURN "ADM-ERROR".
END CASE.
pMensaje = ''.

/* ********************************************************* */
/* RUTINA PRINCIPAL */
/* ********************************************************* */
RUN PRINCIPAL-TRANSACTION.
IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    /*RUN Procesa-handle IN lh_handle ('browse').*/
    RETURN 'ADM-ERROR'.
END.
/* ********************************************************* */
/* GRABACIONES DATOS ADICIONALES A LA COTIZACION */
/* ********************************************************* */
RUN WRITE-HEADER (LocalAdmNewRecord).
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    IF pMensaje > '' THEN MESSAGE pMensaje SKIP(2) 'REPITA EL PROCESO DE GRABACION'
        VIEW-AS ALERT-BOX ERROR.
    /*RUN Procesa-handle IN lh_handle ('browse').*/
    RETURN 'ADM-ERROR'.
END.
FIND CURRENT FacCPedi NO-LOCK NO-ERROR.
/* ********************************************************* */

/* Code placed here will execute AFTER standard behavior.    */
RUN Venta-Corregida.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRINCIPAL-TRANSACTION W-Win 
PROCEDURE PRINCIPAL-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
DEFINE VARIABLE i-Cuenta AS INTEGER NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR' WITH FRAME {&FRAME-NAME}:
    ASSIGN 
        FILL-IN_Atencion FILL-IN_CodCli FILL-IN_DirCli 
        FILL-IN_Glosa FILL-IN_LugEnt FILL-IN_NomCli 
        FILL-IN_RucCli RADIO-SET_Cmpbte
        RADIO-SET_FlgSit
        .
    /* Dos formas: CREATE y UPDATE */
    CASE pEvento:
        WHEN "CREATE" THEN DO:
            CREATE Faccpedi.
            /* Datos que solo se pueden registrar al momento de crear un nuevo pedido */
            ASSIGN
                FacCPedi.CodVen = s-codven
                .
        END.
        WHEN "UPDATE" THEN DO:
            /* MODIFICAR PEDIDO */
            FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                pMensaje = "Registro en uso por otro usuario".
                RETURN "ADM-ERROR".
            END.
        END.
    END CASE.
    ASSIGN
        FacCPedi.FlgSit = RADIO-SET_FlgSit
        FacCPedi.CodMon = s-codmon
        FacCPedi.TpoCmb = s-tpocmb
        FacCPedi.FlgIgv = s-flgigv
        FacCPedi.Libre_d01 = s-nrodec
        FacCPedi.FmaPgo = s-FmaPgo
        .
    ASSIGN
        FacCPedi.CodCli = FILL-IN_CodCli
        FacCPedi.NomCli = FILL-IN_NomCli
        FacCPedi.DirCli = FILL-IN_DirCli
        FacCPedi.RucCli = FILL-IN_RucCli
        FacCPedi.Atencion = FILL-IN_Atencion
        FacCPedi.Glosa = FILL-IN_Glosa
        FacCPedi.LugEnt = FILL-IN_LugEnt
        FacCPedi.Cmpbnte = RADIO-SET_Cmpbte
        .
    CASE pEvento:
        WHEN "CREATE" THEN DO:
            /* NUEVO PEDIDO */
            RUN CREATE-TRANSACION.
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar los pedidos'.
                UNDO, RETURN 'ADM-ERROR'.
            END.
        END.
        WHEN "UPDATE" THEN DO:
            /* MODIFICAR PEDIDO */
            RUN UPDATE-TRANSACION.
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar los pedidos'.
                UNDO, RETURN 'ADM-ERROR'.
            END.
        END.
    END CASE.
    ASSIGN 
        FacCPedi.PorIgv = s-PorIgv
        FacCPedi.Hora = STRING(TIME,"HH:MM")
        FacCPedi.Usuario = S-USER-ID
        FacCPedi.FlgEnv = s-FlgEnv.


    /* ********************************************************************************************** */
    /* Grabamos en Detalle del Pedido */
    /* ********************************************************************************************** */
    RUN WRITE-DETAIL.       /* Detalle del pedido */
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar el pedido' + CHR(10) + 'NO hay stock suficiente en los almacenes'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ************************************************************************ */
    /* 21/11/2023: Log de descuentos básicos */
    /* ************************************************************************ */
    FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c04 > '':
        CREATE logdsctosped.
        BUFFER-COPY Facdpedi TO logdsctosped
            ASSIGN
            logdsctosped.CodPed = Facdpedi.coddoc
            logdsctosped.NroPed = Facdpedi.nroped
            logdsctosped.CodCli = Faccpedi.CodCli
            logdsctosped.CodMon = Faccpedi.CodMon
            logdsctosped.Fecha = TODAY
            logdsctosped.Hora = STRING(TIME,'HH:MM:SS')
            logdsctosped.TipDto = Facdpedi.Libre_c04
            logdsctosped.PorDto = Facdpedi.Por_Dsctos[3]
            logdsctosped.Usuario = s-user-id.
    END.
    IF AVAILABLE(LogDsctosPed) THEN RELEASE LogDsctosPed.
END.
RETURN "OK".

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

DEF INPUT PARAMETER pParam AS CHAR.

CASE pParam:
    WHEN "Save-Customer" THEN DO:
        DEF VAR pMensaje AS CHAR NO-UNDO.
        RUN Valida.
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.
        /* Si todo va bien => devuelve el ITEM + PROMOCIONES */
        RUN Devuelve-Temp-Table IN h_b-ped-mostrador-web-1-2 ( OUTPUT TABLE ITEM).
        RUN MASTER-TRANSACTION.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "FacCPedi"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida W-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE F-TOT AS DECIMAL INIT 0 NO-UNDO.
  DEFINE VARIABLE F-BOL AS DECIMAL INIT 0 NO-UNDO.

  DO WITH FRAME {&FRAME-NAME} :
      /* VALIDACION DEL CLIENTE */
      IF FILL-IN_CodCli:SCREEN-VALUE = "" THEN DO:
          MESSAGE "Codigo de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO FILL-IN_CodCli.
          RETURN "ADM-ERROR".   
      END.
      /* **************************************** */
      /* RHC 22/07/2020 Nuevo bloqueo de clientes */
      /* **************************************** */
      RUN pri/p-verifica-cliente (INPUT FILL-IN_CodCli:SCREEN-VALUE,
                                  INPUT s-CodDoc,
                                  INPUT s-CodDiv).
      IF RETURN-VALUE = "ADM-ERROR" THEN DO:
          APPLY "ENTRY" TO FILL-IN_CodCli.
          RETURN "ADM-ERROR".   
      END.
      /* **************************************** */
      FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
          AND  gn-clie.CodCli = FILL-IN_CodCli:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clie THEN DO:
         MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO FILL-IN_CodCli.
         RETURN "ADM-ERROR".
      END.
      IF gn-clie.canal = '006' THEN DO:
          MESSAGE 'Cliente no permitido en este canal de venta de venta'
              VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO FILL-IN_CodCli.
          RETURN "ADM-ERROR".   
      END.
      IF RADIO-SET_Cmpbte:SCREEN-VALUE = "FAC" AND FILL-IN_RucCli:SCREEN-VALUE = '' THEN DO:
          MESSAGE "El Cliente NO tiene R.U.C." VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO FILL-IN_CodCli.
          RETURN "ADM-ERROR".   
      END.
      IF RADIO-SET_Cmpbte:SCREEN-VALUE = "FAC" THEN DO:
         IF LENGTH(FILL-IN_RucCli:SCREEN-VALUE) < 11 THEN DO:
             MESSAGE 'El RUC debe tener 11 dígitos' VIEW-AS ALERT-BOX ERROR.
             APPLY 'ENTRY':U TO FILL-IN_CodCli.
             RETURN 'ADM-ERROR'.
         END.
         IF LOOKUP(SUBSTRING(FILL-IN_RucCli:SCREEN-VALUE,1,2), '20,15,17,10') = 0 THEN DO:
             MESSAGE 'El RUC debe comenzar con 10,15,17 ó 20' VIEW-AS ALERT-BOX ERROR.
             APPLY 'ENTRY':U TO FILL-IN_CodCli.
             RETURN 'ADM-ERROR'.
         END.
          /* dígito verificador */
          DEF VAR pResultado AS CHAR NO-UNDO.
          RUN lib/_ValRuc (FILL-IN_RucCli:SCREEN-VALUE, OUTPUT pResultado).
          IF pResultado = 'ERROR' THEN DO:
              MESSAGE 'Código RUC MAL registrado' VIEW-AS ALERT-BOX WARNING.
              APPLY 'ENTRY':U TO FILL-IN_CodCli.
              RETURN 'ADM-ERROR'.
          END.
      END.
     /**/
     IF RADIO-SET_Cmpbte:SCREEN-VALUE = "BOL" AND 
         NOT (TRUE <> (FILL-IN_RucCli:SCREEN-VALUE > "")) THEN DO:
            MESSAGE 'Se va a generar una BOLETA DE VENTA con R.U.C.' SKIP 
                '¿ Esta seguro de Genar el Comprobante ?' VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta AS LOG.
                IF rpta = NO THEN RETURN "ADM-ERROR".
     END.
     /* VALIDACION DE ITEMS */
     FOR EACH ITEM NO-LOCK:
         F-Tot = F-Tot + ITEM.ImpLin.
     END.
     IF F-Tot = 0 THEN DO:
        MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN_CodCli.
        RETURN "ADM-ERROR".   
     END.
    /* *********************************************************** */
    /* VALIDACION DE MONTO MINIMO POR BOLETA */
    /* Si es es BOL y no llega al monto mínimo blanqueamos el DNI */
    /* *********************************************************** */
    F-BOL = F-TOT.
    /*
    
    Ic - 16Mar2022, Se detecto que cuando se grababa el registro blanqueaba el DNI, se coordino
            com Daniel Llican y Mayra padilla y se quito dicha validacion
    
    IF ( RADIO-SET_Cmpbte:SCREEN-VALUE = 'BOL' OR RADIO-SET_Cmpbte:SCREEN-VALUE = 'TCK' )
        AND F-BOL <= ImpMinDNI THEN FILL-IN_Atencion:SCREEN-VALUE = ''.
    */

    DEF VAR cNroDni AS CHAR NO-UNDO.
    DEF VAR iLargo  AS INT NO-UNDO.
    DEF VAR cError  AS CHAR NO-UNDO.
    cNroDni = FILL-IN_Atencion:SCREEN-VALUE.
    IF RADIO-SET_Cmpbte:SCREEN-VALUE = 'BOL' AND F-BOL > ImpMinDNI THEN DO:
        /* 03/07/2023: Carnet de extranjeria actualmente tiene 9 dígitos Gianella Chirinos S.Leon */
        RUN lib/_valid_number (INPUT-OUTPUT cNroDni, OUTPUT iLargo, OUTPUT cError).
        IF cError > '' OR iLargo < 8 THEN DO:
            cError = cError + (IF cError > '' THEN CHR(10) ELSE '') +
                       "El DNI debe tener al menos 8 dígitos".
            MESSAGE cError VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FILL-IN_Atencion.
            RETURN "ADM-ERROR".   
        END.
        IF iLargo <> 8 AND gn-clie.Libre_c01 = "N" THEN DO:
            MESSAGE 'El DNI debete tener 8 dígitos' VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FILL-IN_Atencion.
            RETURN "ADM-ERROR".   
        END.

        IF TRUE <> (FILL-IN_NomCli:SCREEN-VALUE > '') THEN DO:
            MESSAGE "Venta Mayor a" ImpMinDNI SKIP
                "Debe ingresar el Nombre del Cliente"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FILL-IN_NomCli.
            RETURN "ADM-ERROR".   
        END.
        IF TRUE <> (FILL-IN_DirCli:SCREEN-VALUE > '') THEN DO:
            MESSAGE "Venta Mayor a" ImpMinDNI SKIP
                "Debe ingresar la Dirección del Cliente"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FILL-IN_DirCli.
            RETURN "ADM-ERROR".   
        END.
    END.
    /* VALIDACION DE IMPORTE MINIMO POR COTIZACION */
    IF s-FlgEnv = YES THEN DO:
        DEF VAR pImpMin AS DEC NO-UNDO.
        RUN gn/pMinCotPed (s-CodCia,
                           s-CodDiv,
                           s-CodDoc,
                           OUTPUT pImpMin).
        IF pImpMin > 0 AND f-Bol < pImpMin THEN DO:
            MESSAGE 'El importe mínimo para el envío es de S/.' pImpMin
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
    END.
    /* VALIDAMOS CLIENTES VARIOS */
    IF FILL-IN_CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-ClientesVarios THEN DO:
        IF NOT getSoloLetras(SUBSTRING(FILL-IN_NomCli:SCREEN-VALUE,1,2)) THEN DO:
            MESSAGE 'Nombre no pasa la validación para SUNAT' VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.                                   
        END.
    END.
  END.
/* *************************************************************************************** */
/* 19/01/2023 Nuevos Controles */
/* *************************************************************************************** */
DO WITH FRAME {&FRAME-NAME}:
    /* *************************************************************************************** */
    /* Verificamos PEDI y lo actualizamos con el stock disponible */
    /* *************************************************************************************** */
    EMPTY TEMP-TABLE PEDI-3.
    FOR EACH ITEM:
        CREATE PEDI-3.
        BUFFER-COPY ITEM TO PEDI-3.
    END.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN VALIDATE-DETAIL (INPUT RETURN-VALUE, OUTPUT pMensaje).
    SESSION:SET-WAIT-STATE('').
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        /* Regresamos todo como si no hubiera pasado nada */
        EMPTY TEMP-TABLE ITEM.
        FOR EACH PEDI-3:
            CREATE ITEM.
            BUFFER-COPY PEDI-3 TO ITEM.
        END.
        RUN dispatch IN h_b-ped-mostrador-web-1-2 ('open-query':U).
        RETURN 'ADM-ERROR'.
    END.
    /* Pintamos nuevos datos */
    RUN dispatch IN h_b-ped-mostrador-web-1-2 ('open-query':U).
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VALIDATE-DETAIL W-Win 
PROCEDURE VALIDATE-DETAIL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER pEvento AS CHAR.
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* ********************* */
  DEF VAR f-Factor AS DECI NO-UNDO.
  DEF VAR s-StkComprometido AS DECI NO-UNDO.
  DEF VAR x-StkAct AS DECI NO-UNDO.
  DEF VAR s-StkDis AS DECI NO-UNDO.
  DEF VAR x-CanPed AS DECI NO-UNDO.

  /* Borramos data sobrante */
  FOR EACH ITEM EXCLUSIVE-LOCK WHERE ITEM.CanPed <= 0:
      DELETE ITEM.
  END.
  
  EMPTY TEMP-TABLE ITEM-3.

  DETALLE:
  FOR EACH ITEM EXCLUSIVE-LOCK WHERE ITEM.codmat <> x-articulo-ICBPER, 
      FIRST Almmmatg OF ITEM NO-LOCK  
      BY ITEM.NroItm : 
      ASSIGN
          ITEM.Libre_d01 = ITEM.CanPed.
      /* RUTINA QUE VERIFICA NUEVAMENTE EL STOCK DISPONIBLE Y AJUSTA LA CANTIDAD EN CASO NECESARIO */
      x-StkAct = 0.
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = ITEM.AlmDes
          AND Almmmate.codmat = ITEM.CodMat
          NO-LOCK NO-ERROR .
      IF NOT AVAILABLE Almmmate THEN DO:
          pMensaje = "Código " + ITEM.CodMat + " No registrado en el almacén " + ITEM.almdes  + CHR(10) + ~
              "Proceso abortado".
          UNDO, RETURN "ADM-ERROR".
      END.
      x-StkAct = Almmmate.StkAct.
      f-Factor = ITEM.Factor.
      /* **************************************************************** */
      /* Solo verifica comprometido si hay stock */
      /* **************************************************************** */
      IF x-StkAct > 0 THEN DO:
          RUN gn/Stock-Comprometido-v2 (ITEM.CodMat, ITEM.AlmDes, YES, OUTPUT s-StkComprometido).
          /* **************************************************************** */
          /* OJO: Cuando se modifica hay que actualizar el STOCK COMPROMETIDO */
          /* **************************************************************** */
          IF pEvento = "NO" THEN DO:
              FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = ITEM.codmat NO-LOCK NO-ERROR.
              IF AVAILABLE Facdpedi THEN s-StkComprometido = s-StkComprometido - (Facdpedi.CanPed * Facdpedi.Factor).
          END.
      END.
      /* **************************************************************** */
      s-StkDis = x-StkAct - s-StkComprometido.

      IF s-StkDis < 0 THEN s-StkDis = 0.    /* *** OJO *** */
      x-CanPed = ITEM.CanPed * f-Factor.

      IF s-coddiv = '00506' THEN DO:
          IF s-StkDis < x-CanPed THEN DO:
              pMensaje = "Código " + ITEM.CodMat + " No hay stock disponible en el almacén " + ITEM.almdes  + CHR(10) + ~
                  "Proceso abortado".
              UNDO, RETURN "ADM-ERROR".
          END.
      END.
      IF s-StkDis < x-CanPed THEN DO:
          /* CONTROL DE AJUTES */
          CREATE ITEM-3.
          BUFFER-COPY ITEM TO ITEM-3
              ASSIGN ITEM-3.CanAte = 0.     /* Valor por defecto */    
          /* AJUSTAMOS Y RECALCULAMOS IMPORTES */
          ASSIGN
              ITEM.CanPed = s-StkDis / f-Factor
              ITEM.Libre_c01 = '*'.
          FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
              AND Almtconv.Codalter = ITEM.UndVta
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almtconv AND Almtconv.Multiplos <> 0 THEN DO:
              IF (ITEM.CanPed / Almtconv.Multiplos) <> INTEGER(ITEM.CanPed / Almtconv.Multiplos) THEN DO:
                  ITEM.CanPed = TRUNCATE(ITEM.CanPed / Almtconv.Multiplos, 0) * Almtconv.Multiplos.
              END.
          END.
          IF s-FlgEmpaque = YES AND Almmmatg.CanEmp > 0 THEN DO:
              ITEM.CanPed = (TRUNCATE((ITEM.CanPed * ITEM.Factor / Almmmatg.CanEmp),0) * Almmmatg.CanEmp) / ITEM.Factor.
          END.
          ASSIGN ITEM-3.CanAte = ITEM.CanPed.       /* CANTIDAD AJUSTADA */

          RUN Recalcular-Item.
      END.
  END.

  /* POR CADA ITEM VOLVEMOS A VERIFICAR EL STOCK DISPONIBLE
    SI NO HAY STOCK RECALCULAMOS EL PRECIO DE VENTA */
  /* Borramos data sobrante */
  FOR EACH ITEM EXCLUSIVE-LOCK WHERE ITEM.CanPed <= 0:
      DELETE ITEM.
  END.

  /* 26/07/2023: Nueva libreria de promociones C.Camus
    Dos parámetros nuevos:
    pCodAlm: código de almacén de despacho
    pEvento: CREATE o UPDATE
  */                
  RUN {&Promocion} (s-CodDiv, 
                    s-CodCli, 
                    ENTRY(1,s-codalm), 
                    (IF pEvento = "YES" THEN "CREATE" ELSE "UDPATE"),
                    INPUT-OUTPUT TABLE ITEM, 
                    OUTPUT pMensaje).
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".


  FOR EACH ITEM NO-LOCK WHERE ITEM.Libre_c05 = "OF", 
      FIRST Almmmatg OF ITEM NO-LOCK, FIRST Almtfami OF Almmmatg NO-LOCK:
      /* **************************************************************************************** */
      /* VERIFICAMOS STOCK DISPONIBLE DE ALMACEN */
      /* **************************************************************************************** */
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = ITEM.AlmDes
          AND Almmmate.codmat = ITEM.CodMat
          NO-LOCK NO-ERROR.
      x-StkAct = 0.
      IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
      RUN gn/stock-comprometido-v2.p (ITEM.CodMat, ITEM.AlmDes, YES, OUTPUT s-StkComprometido).
      /* **************************************************************** */
      /* OJO: Cuando se modifica hay que actualizar el STOCK COMPROMETIDO */
      /* **************************************************************** */
      IF pEvento = "NO" THEN DO:
          FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = ITEM.codmat NO-LOCK NO-ERROR.
          IF AVAILABLE Facdpedi THEN s-StkComprometido = s-StkComprometido - (Facdpedi.CanPed * Facdpedi.Factor).
      END.
      /* **************************************************************** */
      s-StkDis = x-StkAct - s-StkComprometido.
      IF s-StkDis <= 0 THEN DO:
          pMensaje = 'El STOCK DISPONIBLE está en CERO para el producto ' + ITEM.codmat + 
              'en el almacén ' + ITEM.AlmDes + CHR(10).
          RETURN "ADM-ERROR".
      END.
      f-Factor = ITEM.Factor.
      x-CanPed = ITEM.CanPed * f-Factor.
      IF s-StkDis < x-CanPed THEN DO:
          pMensaje = 'Producto ' + ITEM.codmat + ' NO tiene Stock Disponible suficiente en el almacén ' + ITEM.AlmDes + CHR(10) +
              'Se va a abortar la generación del Pedido'.
          RETURN "ADM-ERROR".
      END.
  END.
  /* ********************************************************************************************** */
  /* ********************************************************************************************** */
  /* 16/11/2022: NINGUN producto (así sea promocional) debe estar con PRECIO CERO */
  /* ********************************************************************************************** */
  FOR EACH ITEM NO-LOCK:
      IF ITEM.PreUni <= 0 THEN DO:
          pMensaje = 'Producto ' + ITEM.codmat + ' NO tiene Precio Unitario ' + CHR(10) +
              'Se va a abortar la generación del Pedido'.
          RETURN "ADM-ERROR".
      END.
  END.
  IF NOT CAN-FIND(FIRST ITEM NO-LOCK) THEN DO:
      pMensaje = "NO hay stock suficiente para cubrir el pedido".
      RETURN 'ADM-ERROR'.
  END.

  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Venta-Corregida W-Win 
PROCEDURE Venta-Corregida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST ITEM-3 NO-LOCK NO-ERROR.
IF NOT AVAILABLE ITEM-3 THEN RETURN 'OK'.
RUN vta2/d-vtacorr-cont.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WRITE-DETAIL W-Win 
PROCEDURE WRITE-DETAIL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* ********************* */
  DEF VAR I-NITEM AS INTE NO-UNDO.

  DETALLE:
  FOR EACH ITEM EXCLUSIVE-LOCK WHERE ITEM.codmat <> x-articulo-ICBPER:
      ASSIGN ITEM.Libre_d01 = ITEM.CanPed.
  END.

  /* GRABAMOS INFORMACION FINAL */
  FOR EACH ITEM WHERE ITEM.CanPed > 0 BY ITEM.NroItm:
      I-NITEM = I-NITEM + 1.
      CREATE Facdpedi.
      BUFFER-COPY ITEM TO Facdpedi
          ASSIGN
            Facdpedi.CodCia = Faccpedi.CodCia
            Facdpedi.CodDiv = Faccpedi.CodDiv
            Facdpedi.coddoc = Faccpedi.coddoc
            Facdpedi.NroPed = Faccpedi.NroPed
            Facdpedi.FchPed = Faccpedi.FchPed
            Facdpedi.Hora   = Faccpedi.Hora 
            Facdpedi.FlgEst = Faccpedi.FlgEst
            Facdpedi.NroItm = I-NITEM
            Facdpedi.CanPick = Facdpedi.CanPed.   /* OJO */
  END.

  /* verificamos que al menos exista 1 item grabado */
  FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi 
  THEN RETURN 'ADM-ERROR'.
  ELSE RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WRITE-HEADER W-Win 
PROCEDURE WRITE-HEADER :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pAdmNewRecord AS CHAR.

DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* BLOQUEAMOS CABECERA NUEVAMENTE: Se supone que solo un vendedor está manipulando la cotización */
    FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES  THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.

    /* ************************************************************************** */
    /* NOTA: Descuento por Encarte y Descuento por Vol. x Linea SON EXCLUYENTES,
            es decir, NO pueden darse a la vez, o es uno o es el otro */
    /* ************************************************************************** */
    RUN DESCUENTOS-FINALES (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'ERROR al aplicar los descuentos totales a la cotización'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ****************************************************************************************** */
    /* Grabamos Totales */
    /* ****************************************************************************************** */
    DEF VAR hProc AS HANDLE NO-UNDO.
    &IF {&ARITMETICA-SUNAT} &THEN
        {vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
        /* ****************************************************************************************** */
        /* Importes SUNAT */
        /* ****************************************************************************************** */
        RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
        RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                     INPUT Faccpedi.CodDoc,
                                     INPUT Faccpedi.NroPed,
                                     OUTPUT pMensaje).
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
        DELETE PROCEDURE hProc.
    &ELSE
        {vta2/graba-totales-cotizacion-cred.i}
        /* ****************************************************************************************** */
        /* Importes SUNAT */
        /* NO actualiza valores Progress */
        /* ****************************************************************************************** */
        RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
        RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                     INPUT Faccpedi.CodDoc,
                                     INPUT Faccpedi.NroPed,
                                     OUTPUT pMensaje).
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
        DELETE PROCEDURE hProc.
    &ENDIF
    /* ****************************************************************************************** */
    /* Actualizamos la cotizacion */
    IF Faccpedi.CodRef = "C/M" THEN DO:
        RUN vta2/actualiza-cotizacion-01 ( ROWID(Faccpedi), +1, OUTPUT pMensaje ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
    IF Faccpedi.CodRef = "PPV" THEN DO:
        RUN actualiza-prepedido ( ROWID(Faccpedi), +1, OUTPUT pMensaje ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEsAlfabetico W-Win 
FUNCTION getEsAlfabetico RETURNS LOGICAL
  ( INPUT pCaracter AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-alfabetico AS CHAR.
    DEFINE VAR x-retval AS LOG INIT NO.

    x-alfabetico = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyz".
    IF INDEX(x-alfabetico,pCaracter) > 0 THEN x-retval = YES.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSoloLetras W-Win 
FUNCTION getSoloLetras RETURNS LOGICAL
  ( INPUT pTexto AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-caracter AS CHAR.
    DEFINE VAR x-retval AS LOG INIT YES.
    DEFINE VAR x-sec AS INT.

    VALIDACION:
    REPEAT x-sec = 1 TO LENGTH(pTexto):
        x-caracter = SUBSTRING(pTexto,x-sec,1).
        x-retval = getEsAlfabetico(x-caracter).
        IF x-retval = NO THEN DO:
            LEAVE VALIDACION.
        END.
    END.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

