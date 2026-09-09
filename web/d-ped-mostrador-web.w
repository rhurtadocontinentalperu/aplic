&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE NEW SHARED TEMP-TABLE ITEM-3 LIKE FacDPedi.
DEFINE TEMP-TABLE PEDI-3 NO-UNDO LIKE FacDPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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

&SCOPED-DEFINE precio-venta-general web/PrecioFinalContadoMayorista.p

/* Parameters Definitions ---                                           */
DEF INPUT PARAMETER pEvento AS CHAR NO-UNDO.
DEF INPUT PARAMETER pRowid AS ROWID NO-UNDO.

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-CodCia AS INTE.
DEF SHARED VAR s-CodDiv AS CHAR.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

DEF NEW SHARED VAR s-NroSer AS INT.
DEF NEW SHARED VAR s-CodDoc AS CHAR INIT 'P/M'.
DEF NEW SHARED VAR s-tpoped AS CHAR INIT "CO".
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

/*DEF NEW SHARED VAR s-CodVen AS CHAR.*/
DEFINE SHARED VAR s-CodVen AS CHAR.


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

FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia AND
    FacCorre.CodDiv = s-coddiv AND
    FacCorre.CodDoc = s-coddoc AND 
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN s-NroSer = FacCorre.NroSer.



DEFINE IMAGE IMAGE-1 FILENAME "IMG\Coti.ico" SIZE 12 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-4 RADIO-SET_FlgSit ~
BUTTON-Shopping_Cart Btn_OK Btn_Cancel FILL-IN_CodCli FILL-IN_NomCli ~
FILL-IN_DirCli FILL-IN_LugEnt FILL-IN_Glosa RADIO-SET_Cmpbte 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET_FlgSit FILL-IN_CodCli ~
FILL-IN_RucCli FILL-IN_Atencion FILL-IN_NomCli FILL-IN_DirCli ~
FILL-IN_LugEnt FILL-IN_Glosa RADIO-SET_Cmpbte 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEsAlfabetico D-Dialog 
FUNCTION getEsAlfabetico RETURNS LOGICAL
  ( INPUT pCaracter AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSoloLetras D-Dialog 
FUNCTION getSoloLetras RETURNS LOGICAL
  ( INPUT pTexto AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-ped-mostrador-web-1 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "pda/remove_from_shopping_cart.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 3.5 TOOLTIP "NO Grabar Pedido y Regresar"
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "pda/shopping_cart_accept.bmp":U
     LABEL "OK" 
     SIZE 15 BY 3.5 TOOLTIP "Grabar Pedido y Regresar"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-Shopping_Cart 
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


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     RADIO-SET_FlgSit AT ROW 1.27 COL 17 NO-LABEL WIDGET-ID 160
     BUTTON-Shopping_Cart AT ROW 1.27 COL 141 WIDGET-ID 136
     Btn_OK AT ROW 1.27 COL 156
     Btn_Cancel AT ROW 1.27 COL 171
     FILL-IN_CodCli AT ROW 2.08 COL 15 COLON-ALIGNED WIDGET-ID 140
     FILL-IN_RucCli AT ROW 2.08 COL 35 COLON-ALIGNED HELP
          "Registro Unico de Contribuyente (Cliente)" WIDGET-ID 150
     FILL-IN_Atencion AT ROW 2.08 COL 55 COLON-ALIGNED WIDGET-ID 138
     FILL-IN_NomCli AT ROW 2.88 COL 15 COLON-ALIGNED HELP
          "Nombre del Cliente" WIDGET-ID 148
     FILL-IN_DirCli AT ROW 3.69 COL 15 COLON-ALIGNED HELP
          "Direcci¢n del Cliente" WIDGET-ID 142
     FILL-IN_LugEnt AT ROW 4.5 COL 15 COLON-ALIGNED WIDGET-ID 146
     FILL-IN_Glosa AT ROW 5.31 COL 15 COLON-ALIGNED WIDGET-ID 144
     RADIO-SET_Cmpbte AT ROW 6.12 COL 17 NO-LABEL WIDGET-ID 156
     "Comprobante:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 6.38 COL 7 WIDGET-ID 170
     "Cancela con:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 1.54 COL 6 WIDGET-ID 168
     RECT-3 AT ROW 7.19 COL 2 WIDGET-ID 164
     RECT-4 AT ROW 1 COL 2 WIDGET-ID 166
     SPACE(3.28) SKIP(19.95)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "<insert SmartDialog title>"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
      TABLE: ITEM-3 T "NEW SHARED" ? INTEGRAL FacDPedi
      TABLE: PEDI-3 T "?" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE
       FRAME D-Dialog:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN FILL-IN_Atencion IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_RucCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* <insert SmartDialog title> */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancel */
DO:
    MESSAGE 'Salimos sin grabar el pedido?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
    MESSAGE 'Procedemos a grabar el pedido?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
    ASSIGN 
        FILL-IN_Atencion FILL-IN_CodCli FILL-IN_DirCli 
        FILL-IN_Glosa FILL-IN_LugEnt FILL-IN_NomCli 
        FILL-IN_RucCli RADIO-SET_Cmpbte
        RADIO-SET_FlgSit
        .

    RUN Devuelve-Temp-Table IN h_b-ped-mostrador-web-1 ( OUTPUT TABLE ITEM).
    RUN MASTER-TRANSACTION.
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Shopping_Cart
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Shopping_Cart D-Dialog
ON CHOOSE OF BUTTON-Shopping_Cart IN FRAME D-Dialog /* Button 1 */
DO:
    RUN Devuelve-Temp-Table IN h_b-ped-mostrador-web-1 ( OUTPUT TABLE ITEM).
    RUN web/d-ped-mostrador-web-car.w (INPUT-OUTPUT TABLE ITEM).
    RUN Import-Temp-Table IN h_b-ped-mostrador-web-1 ( INPUT TABLE ITEM).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodCli D-Dialog
ON LEAVE OF FILL-IN_CodCli IN FRAME D-Dialog /* Cliente */
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


&Scoped-define SELF-NAME RADIO-SET_Cmpbte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET_Cmpbte D-Dialog
ON VALUE-CHANGED OF RADIO-SET_Cmpbte IN FRAME D-Dialog
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET_FlgSit D-Dialog
ON VALUE-CHANGED OF RADIO-SET_FlgSit IN FRAME D-Dialog
DO:
  s-FlgSit = SELF:SCREEN-VALUE.
  RUN Recalcular-Precios IN h_b-ped-mostrador-web-1.
  RUN Pinta-Total IN h_b-ped-mostrador-web-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actualiza-prepedido D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
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
             INPUT  'aplic/web/b-ped-mostrador-web-1.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-ped-mostrador-web-1 ).
       RUN set-position IN h_b-ped-mostrador-web-1 ( 7.46 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-ped-mostrador-web-1 ( 19.38 , 182.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-ped-mostrador-web-1 ,
             RADIO-SET_Cmpbte:HANDLE , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Pedido D-Dialog 
PROCEDURE Borra-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER p-Ok AS LOG.
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  DEFINE BUFFER DETALLE FOR FacDPedi.
  DEF VAR pCuenta AS INTE NO-UNDO.
  
  RLOOP:
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      /* Borramos detalle */
      FOR EACH Facdpedi OF Faccpedi NO-LOCK:
          FIND DETALLE WHERE ROWID(DETALLE) = ROWID(Facdpedi) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
          IF ERROR-STATUS:ERROR = YES THEN DO:
              {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
              UNDO RLOOP, RETURN 'ADM-ERROR'.
          END.
          /* EXTORNAMOS SALDO EN LAS COTIZACIONES */
          IF Faccpedi.CodRef = "C/M" THEN DO:
              FIND B-DPEDI WHERE B-DPEDI.CodCia = Faccpedi.CodCia 
                  AND  B-DPEDI.CodDiv = Faccpedi.CodDiv
                  AND  B-DPEDI.CodDoc = Faccpedi.CodRef 
                  AND  B-DPEDI.NroPed = Faccpedi.NroRef
                  AND  B-DPEDI.CodMat = Facdpedi.CodMat 
                  EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
              IF AVAILABLE B-DPEDI 
              THEN ASSIGN
                    B-DPEDI.FlgEst = 'P'
                    B-DPEDI.CanAte = B-DPEDI.CanAte - Facdpedi.CanPed.  /* <<<< OJO <<<< */
          END.
          /* */
          IF p-Ok = YES THEN DELETE DETALLE.
          ELSE DETALLE.FlgEst = 'A'.   /* <<< OJO <<< */
      END.
      IF Faccpedi.CodRef > '' AND Faccpedi.NroRef > '' THEN DO:
          FIND B-CPedi WHERE 
               B-CPedi.CodCia = S-CODCIA AND  
               B-CPedi.CodDiv = S-CODDIV AND  
               B-CPedi.CodDoc = Faccpedi.CodRef AND  
               B-CPedi.NroPed = Faccpedi.NroRef
               EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
          IF AVAILABLE B-CPedi THEN B-CPedi.FlgEst = "P".
      END.
  END.
  IF AVAILABLE(DETALLE) THEN RELEASE DETALLE.
  IF AVAILABLE(B-DPEDI) THEN RELEASE B-DPEDI.
  IF AVAILABLE(B-CPEDI) THEN RELEASE B-CPEDI.

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ITEM.

DEF VAR LogRecalcular AS LOG INIT NO NO-UNDO.

/* ARTIFICIO */
FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> 'OF':
    CREATE ITEM.
    BUFFER-COPY Facdpedi TO ITEM.

    LogRecalcular = NO.
    /* 01/08/2022: Limpiamos descuentos finales */
    IF Facdpedi.Libre_c04 > '' THEN DO:
        LogRecalcular = YES.
        ASSIGN
            ITEM.Por_Dsctos[1] = 0
            ITEM.Por_Dsctos[2] = 0
            ITEM.Por_Dsctos[3] = 0
            ITEM.Libre_c04 = "".
    END.
    IF ITEM.Libre_d03 > 0 THEN DO:
        LogRecalcular = YES.
        ASSIGN
            ITEM.Por_Dsctos[1] = 0
            ITEM.Por_Dsctos[2] = 0
            ITEM.Por_Dsctos[3] = 0
            ITEM.CanPed = ITEM.CanPed - ITEM.Libre_d03
            ITEM.Libre_d03 = 0.
    END.
    IF LogRecalcular = YES THEN DO:
        /* ***************************************************************** */
        RUN Recalcular-Item.
        /* ***************************************************************** */
    END.
    IF ITEM.CanPed <= 0 THEN DELETE ITEM.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CREATE-TRANSACION D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Delete-Items-Log D-Dialog 
PROCEDURE Delete-Items-Log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER b-logdsctosped FOR logdsctosped.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Eliminamos Detalle */
    FOR EACH logdsctosped NO-LOCK WHERE logdsctosped.CodCia = Faccpedi.codcia AND
        logdsctosped.CodPed = Faccpedi.coddoc AND
        logdsctosped.NroPed = Faccpedi.nroped:
        {lib/lock-genericov3.i ~
            &Tabla="b-logdsctosped" ~
            &Condicion="ROWID(b-logdsctosped) = ROWID(logdsctosped)" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TippoError="UNDO PRINCIPAL, RETURN 'ADM-ERROR'"}
        DELETE b-logdsctosped.
    END.
END.
IF AVAILABLE(LogDsctosPed) THEN RELEASE LogDsctosPed.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DESCUENTOS-FINALES D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY RADIO-SET_FlgSit FILL-IN_CodCli FILL-IN_RucCli FILL-IN_Atencion 
          FILL-IN_NomCli FILL-IN_DirCli FILL-IN_LugEnt FILL-IN_Glosa 
          RADIO-SET_Cmpbte 
      WITH FRAME D-Dialog.
  ENABLE RECT-3 RECT-4 RADIO-SET_FlgSit BUTTON-Shopping_Cart Btn_OK Btn_Cancel 
         FILL-IN_CodCli FILL-IN_NomCli FILL-IN_DirCli FILL-IN_LugEnt 
         FILL-IN_Glosa RADIO-SET_Cmpbte 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      CASE pEvento:
          WHEN "CREATE" THEN DO:
              ASSIGN
                  s-CodCli = x-ClientesVarios
                  FILL-IN_CodCli = s-CodCli
                  s-adm-new-record = "YES".
          END.
          WHEN "UPDATE" THEN DO:
              Fi-Mensaje = "Importando pedido".
              DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
              RUN valida-update.
/*               HIDE FRAME F-proceso. */
          END.
      END CASE.
  END.
  HIDE FRAME F-proceso.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRINCIPAL-TRANSACTION D-Dialog 
PROCEDURE PRINCIPAL-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
DEFINE VARIABLE i-Cuenta AS INTEGER NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR' WITH FRAME {&FRAME-NAME}:
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
            /* Control en caso se a modificado el original */
            IF FacCPedi.FlgEst <> "P" THEN DO:
                pMensaje = 'El Pedido ya NO está activo' + CHR(10) + 'La grabación ha sido abortada'.
                RETURN 'ADM-ERROR'.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Botones D-Dialog 
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
        RUN Devuelve-Temp-Table IN h_b-ped-mostrador-web-1 ( OUTPUT TABLE ITEM).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
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
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Item D-Dialog 
PROCEDURE Recalcular-Item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR f-factor AS DECI NO-UNDO.
    DEF VAR f-PreBas AS DECI NO-UNDO.
    DEF VAR f-PreVta AS DECI NO-UNDO.
    DEF VAR z-Dsctos AS DECI NO-UNDO.
    DEF VAR y-Dsctos AS DECI NO-UNDO.
    DEF VAR x-TipDto AS CHAR NO-UNDO.
    DEF VAR f-Dsctos AS DECI NO-UNDO.
    DEF VAR f-FleteUnitario AS DECI NO-UNDO.



    RUN {&precio-venta-general} (s-CodCia,
                                 s-CodDiv,
                                 s-CodCli,
                                 s-CodMon,
                                 s-TpoCmb,
                                 OUTPUT f-Factor,
                                 ITEM.codmat,
                                 s-FlgSit,
                                 ITEM.undvta,
                                 ITEM.CanPed,
                                 s-NroDec,
                                 ITEM.almdes,
                                 OUTPUT f-PreBas,
                                 OUTPUT f-PreVta,
                                 OUTPUT f-Dsctos,
                                 OUTPUT y-Dsctos,
                                 OUTPUT x-TipDto,
                                 OUTPUT f-FleteUnitario,
                                 OUTPUT pMensaje
                                 ).
    IF RETURN-VALUE <> 'ADM-ERROR' 
        THEN ASSIGN
            ITEM.PreUni = F-PREVTA
            ITEM.PorDto = f-Dsctos
            ITEM.PreBas = F-PreBas 
            ITEM.PreVta[1] = F-PreVta
            ITEM.Por_Dsctos[2] = z-Dsctos
            ITEM.Por_Dsctos[3] = y-Dsctos
            ITEM.Libre_c04 = x-TipDto
            ITEM.Libre_d02 = f-FleteUnitario
            .
    /* ***************************************************************** */
    ASSIGN
        ITEM.PreUni = ROUND(ITEM.PreBas + ITEM.Libre_d02, s-NroDec)
        ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni * 
                        ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[3] / 100 ).
    IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
        THEN ITEM.ImpDto = 0.
    ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
    ASSIGN
        ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
        ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
    IF ITEM.AftIgv 
        THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UPDATE-TRANSACION D-Dialog 
PROCEDURE UPDATE-TRANSACION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

PRINCIPAL:                                                                                  
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    RUN Borra-Pedido (YES, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo actualizar el pedido".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Eliminamos Log de Descuentos */
    RUN Delete-Items-Log.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida D-Dialog 
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
    RUN VALIDATE-DETAIL (INPUT (IF pEvento = "CREATE" THEN "YES" ELSE "NO"), OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        /* Regresamos todo como si no hubiera pasado nada */
        EMPTY TEMP-TABLE ITEM.
        FOR EACH PEDI-3:
            CREATE ITEM.
            BUFFER-COPY PEDI-3 TO ITEM.
        END.
        RUN dispatch IN h_b-ped-mostrador-web-1 ('open-query':U).
        RETURN 'ADM-ERROR'.
    END.
    /* Pintamos nuevos datos */
    RUN dispatch IN h_b-ped-mostrador-web-1 ('open-query':U).
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update D-Dialog 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.

ASSIGN
    S-CODMON = FacCPedi.CodMon
    S-CODCLI = FacCPedi.CodCli
    S-TPOCMB = FacCPedi.TpoCmb
    S-CNDVTA = FacCPedi.FmaPgo
    s-PorIgv = Faccpedi.porigv
    s-NroDec = Faccpedi.Libre_d01
    s-FlgIgv = Faccpedi.FlgIgv
    s-FlgSit = Faccpedi.FlgSit
    s-NroPed = Faccpedi.NroPed
    s-adm-new-record = "NO"
    s-Cmpbnte = Faccpedi.Cmpbnte
    .
ASSIGN
    FILL-IN_Atencion = FacCPedi.Atencion 
    FILL-IN_CodCli = FacCPedi.CodCli 
    FILL-IN_DirCli = FacCPedi.DirCli 
    FILL-IN_Glosa = FacCPedi.Glosa 
    FILL-IN_LugEnt = FacCPedi.LugEnt 
    FILL-IN_NomCli = FacCPedi.NomCli 
    FILL-IN_RucCli = FacCPedi.RucCli 
    RADIO-SET_Cmpbte = FacCPedi.Cmpbnte 
    RADIO-SET_FlgSit = FacCPedi.FlgSit
    .

RUN Carga-Temporal.

RUN Import-Temp-Table IN h_b-ped-mostrador-web-1
    ( INPUT TABLE ITEM).

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VALIDATE-DETAIL D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Venta-Corregida D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WRITE-DETAIL D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WRITE-HEADER D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEsAlfabetico D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSoloLetras D-Dialog 
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

