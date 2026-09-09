&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.



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
&SCOPED-DEFINE precio-venta-general web/PrecioFinalContadoMayorista.p

&SCOPED-DEFINE ARITMETICA-SUNAT YES

/* Parameters Definitions ---                                           */
DEFINE SHARED VARIABLE s-codcia AS INTE.
DEFINE SHARED VARIABLE s-user-id AS CHAR.

DEFINE NEW SHARED VARIABLE S-CODDIV  AS CHAR.

FIND FacUsers WHERE FacUsers.CodCia = s-codcia AND
    FacUsers.Usuario = s-user-id
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacUsers THEN QUIT.
s-coddiv = FacUsers.CodDiv.

/* Solicitamos el vendedor */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' s-coddiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    QUIT.
END.

DEFINE NEW SHARED VARIABLE s-codven AS CHAR init '021'.

RUN pda/d-select-seller (INPUT GN-DIVI.Centro_Costo, OUTPUT s-CodVen).
IF TRUE <> (s-codven > '') THEN QUIT.

/* ICBPER */
DEFINE VAR x-articulo-ICBPER AS CHAR.
x-articulo-ICBPER = '099268'.

DEFINE VAR pNroPed AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE lh_handle AS HANDLE.
DEFINE NEW SHARED VARIABLE s-nrodec AS INTE INIT 4.
DEFINE NEW SHARED VARIABLE s-PorIgv LIKE Ccbcdocu.PorIgv.
DEFINE NEW SHARED VARIABLE S-CODALM  AS CHAR.

DEFINE NEW SHARED VARIABLE S-CODMON  AS INTEGER INIT 1.
DEFINE NEW SHARED VARIABLE S-TPOCMB  AS DEC.
DEFINE NEW SHARED VARIABLE s-FlgSit AS CHAR INIT "T".                /* T: tarjeta de crédito,  "": efectivo */
DEFINE NEW SHARED VARIABLE s-adm-new-record AS CHAR INIT "YES".     /* Siempre es NUEVO */
DEFINE NEW SHARED VARIABLE S-CODDOC  AS CHAR INIT "P/M".
DEFINE NEW SHARED VARIABLE s-NroPed AS CHAR.
DEFINE NEW SHARED VARIABLE s-TpoPed   AS CHAR INIT "CO".            /* COntado */
DEFINE NEW SHARED VARIABLE S-CNDVTA  AS CHAR INIT '000'.            /* Contado */
DEFINE NEW SHARED VARIABLE s-fmapgo  AS CHAR INIT '000'.            /* Contado */
DEFINE NEW SHARED VARIABLE s-NroSer AS INT.
DEFINE NEW SHARED VARIABLE s-flgigv AS LOG INIT YES.
DEFINE NEW SHARED VARIABLE s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.

DEFINE NEW SHARED VARIABLE S-CODCLI AS CHAR.
DEFINE NEW SHARED VARIABLE s-RucCli AS CHAR.
DEFINE NEW SHARED VARIABLE s-Atencion AS CHAR.
DEFINE NEW SHARED VARIABLE s-NomCli AS CHAR.
DEFINE NEW SHARED VARIABLE s-DirCli AS CHAR.
DEFINE NEW SHARED VARIABLE s-Cmpbnte AS CHAR.

/* Nro. de Serie */
FOR EACH FacCorre NO-LOCK WHERE 
    FacCorre.CodCia = s-CodCia AND
    FacCorre.CodDoc = s-CodDoc AND
    FacCorre.CodDiv = s-CodDiv AND
    FacCorre.FlgEst = YES:
    s-NroSer = FacCorre.NroSer.
END.
/* Tipo de Cambio */
FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
s-CodCli = FacCfgGn.CliVar.     /* 11 digitos */
s-TpoCmb = FacCfgGn.TpoCmb[1].
s-PorIgv = FacCfgGn.PorIgv.

/* RHC 11.08.2014 TC Caja Compra */
FIND LAST gn-tccja WHERE gn-tccja.fecha <= TODAY AND gn-tccja.fecha <> ? NO-LOCK NO-ERROR.
IF AVAILABLE gn-tccja THEN s-TpoCmb = Gn-TCCja.Compra.
/* Código de Almacenes */
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
IF TRUE <> (s-CodAlm > "") THEN DO:
    MESSAGE 'NO se han definido los almacenes de ventas para la división' s-coddiv VIEW-AS ALERT-BOX WARNING.
    QUIT.
END.
/* PARAMETROS DE COTIZACION PARA LA DIVISION */
DEF NEW SHARED VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEF NEW SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEF NEW SHARED VAR s-FlgRotacion LIKE GN-DIVI.FlgRotacion.
DEF NEW SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEF NEW SHARED VAR s-FlgTipoVenta LIKE GN-DIVI.FlgPreVta.

ASSIGN
    s-FlgEmpaque = GN-DIVI.FlgEmpaque
    s-FlgMinVenta = GN-DIVI.FlgMinVenta
    s-FlgRotacion = GN-DIVI.FlgRotacion
    s-VentaMayorista = GN-DIVI.VentaMayorista
    s-FlgTipoVenta = GN-DIVI.FlgPreVta.

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
&Scoped-Define ENABLED-OBJECTS BtnDone RECT-2 IMAGE-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-ped-mostrador-may-sku AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cancel-cust AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cancel-new-cust AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cancel-sku AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cart-add AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cart-clean AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cart-delete AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-cart-save AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-new-customer AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-ped-mostrador-may-cust AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-ped-mostrador-may-end AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-ped-mostrador-may-sku AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-return-end-message AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-save-cust AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-save-new-cust AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-save-sku AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "aplic/pda/shut_down.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "&Done" 
     SIZE 7.86 BY 1.81 TOOLTIP "Cerrar aplicación"
     BGCOLOR 15 FGCOLOR 0 .

DEFINE IMAGE IMAGE-1
     FILENAME "img/conti.bmp":U
     SIZE 36 BY 1.62.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 64.72 BY 2.15
     BGCOLOR 15 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnDone AT ROW 1.27 COL 57 WIDGET-ID 12
     RECT-2 AT ROW 1 COL 1 WIDGET-ID 10
     IMAGE-1 AT ROW 1.27 COL 2 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 64.72 BY 24.23
         BGCOLOR 15 FGCOLOR 0 FONT 11 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 3
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PEDIDO MAYORISTA MOSTRADOR"
         HEIGHT             = 24.23
         WIDTH              = 64.72
         MAX-HEIGHT         = 24.23
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 24.23
         VIRTUAL-WIDTH      = 80
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
   FRAME-NAME Custom                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PEDIDO MAYORISTA MOSTRADOR */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PEDIDO MAYORISTA MOSTRADOR */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
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
             INPUT  'aplic/pda/b-ped-mostrador-may-sku.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-ped-mostrador-may-sku ).
       RUN set-position IN h_b-ped-mostrador-may-sku ( 3.15 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-ped-mostrador-may-sku ( 18.04 , 64.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pda/f-cart-add.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cart-add ).
       RUN set-position IN h_f-cart-add ( 21.19 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.54 , 15.14 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pda/f-cart-delete.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cart-delete ).
       RUN set-position IN h_f-cart-delete ( 21.19 , 17.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.54 , 14.14 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pda/f-cart-clean.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cart-clean ).
       RUN set-position IN h_f-cart-clean ( 21.19 , 32.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.54 , 14.14 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pda/f-cart-save.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cart-save ).
       RUN set-position IN h_f-cart-save ( 21.19 , 50.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.54 , 14.14 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cart-add ,
             h_b-ped-mostrador-may-sku , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cart-delete ,
             h_f-cart-add , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cart-clean ,
             h_f-cart-delete , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cart-save ,
             h_f-cart-clean , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pda/f-ped-mostrador-may-sku.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-ped-mostrador-may-sku ).
       RUN set-position IN h_f-ped-mostrador-may-sku ( 3.15 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 18.15 , 63.43 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pda/f-save-sku.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-save-sku ).
       RUN set-position IN h_f-save-sku ( 21.46 , 52.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.27 , 13.14 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pda/f-cancel-sku.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cancel-sku ).
       RUN set-position IN h_f-cancel-sku ( 21.46 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.27 , 13.14 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-save-sku ,
             h_f-ped-mostrador-may-sku , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cancel-sku ,
             h_f-save-sku , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pda/f-ped-mostrador-may-cust.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-ped-mostrador-may-cust ).
       RUN set-position IN h_f-ped-mostrador-may-cust ( 3.15 , 1.29 ) NO-ERROR.
       /* Size in UIB:  ( 16.00 , 63.72 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pda/f-save-cust.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-save-cust ).
       RUN set-position IN h_f-save-cust ( 20.92 , 50.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.54 , 14.14 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pda/f-cancel-cust.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cancel-cust ).
       RUN set-position IN h_f-cancel-cust ( 20.92 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.54 , 14.14 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-save-cust ,
             h_f-ped-mostrador-may-cust , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cancel-cust ,
             h_f-save-cust , 'AFTER':U ).
    END. /* Page 3 */
    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pda/f-ped-mostrador-may-end.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-ped-mostrador-may-end ).
       RUN set-position IN h_f-ped-mostrador-may-end ( 3.15 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 15.23 , 62.86 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pda/f-return-end-message.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-return-end-message ).
       RUN set-position IN h_f-return-end-message ( 20.38 , 12.00 ) NO-ERROR.
       /* Size in UIB:  ( 2.19 , 40.14 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-return-end-message ,
             h_f-ped-mostrador-may-end , 'AFTER':U ).
    END. /* Page 4 */
    WHEN 5 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pda/f-new-customer.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-new-customer ).
       RUN set-position IN h_f-new-customer ( 3.15 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 18.31 , 62.72 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pda/f-cancel-new-cust.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-cancel-new-cust ).
       RUN set-position IN h_f-cancel-new-cust ( 21.42 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.54 , 14.14 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pda/f-save-new-cust.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-save-new-cust ).
       RUN set-position IN h_f-save-new-cust ( 21.46 , 51.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.54 , 13.29 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-cancel-new-cust ,
             h_f-new-customer , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-save-new-cust ,
             h_f-cancel-new-cust , 'AFTER':U ).
    END. /* Page 5 */

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

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

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
        FacCPedi.FlgEst = "P"
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
  ENABLE BtnDone RECT-2 IMAGE-1 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION W-Win 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR pMensaje AS CHAR NO-UNDO.
                                                        
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CREATE Faccpedi.
    ASSIGN
        FacCPedi.CodCli = s-CodCli
        FacCPedi.CodMon = s-CodMon
        FacCPedi.Atencion = s-Atencion
        FacCPedi.Cmpbnte = s-Cmpbnte
        FacCPedi.CodVen = s-CodVen
        FacCPedi.DirCli = s-DirCli
        FacCPedi.DNICli = s-Atencion
        FacCPedi.fchven = TODAY
        FacCPedi.FlgIgv = s-FlgIgv
        FacCPedi.FlgSit = s-FlgSit
        FacCPedi.FmaPgo = s-FmaPgo
        FacCPedi.NomCli = s-NomCli
        FacCPedi.RucCli = s-RucCli
        FacCPedi.TpoCmb = s-TpoCmb
        FacCPedi.Libre_d01 = s-NroDec
        FacCPedi.TipVta = "PDA"     /* Campo de Control */
        .

    RUN CREATE-TRANSACION (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar los pedidos'.
        UNDO, RETURN 'ADM-ERROR'.
    END.

    ASSIGN 
        FacCPedi.PorIgv = s-PorIgv
        FacCPedi.Hora = STRING(TIME,"HH:MM")
        FacCPedi.Usuario = S-USER-ID
        FacCPedi.FlgEnv = YES.

    /* ********************************************************************************************** */
    /* Grabamos Detalle del Pedido */
    /* ********************************************************************************************** */
    RUN WRITE-DETAIL.       /* Detalle del pedido */
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar el pedido' + CHR(10) + 'NO hay stock suficiente en los almacenes'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ********************************************************************************************** */
    /* Grabamos Otros datos de Cabecera */
    /* ********************************************************************************************** */
    RUN WRITE-HEADER ("YES", OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        pNroPed = Faccpedi.NroPed.
    RELEASE FacCPedi.
END.
RETURN 'OK'.

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

DEF VAR pOpcion AS CHAR NO-UNDO.
DEF VAR pCodMat AS CHAR NO-UNDO.

DEF VAR pRpta AS LOG NO-UNDO.

pOpcion = ENTRY(1, pParam, '&').
CASE pOpcion:
    WHEN "Cart-Add" THEN DO:
        RUN select-page('2').
        RUN Devuelve-Temporal IN h_b-ped-mostrador-may-sku ( OUTPUT TABLE ITEM).
        RUN Captura-Temporal IN h_f-ped-mostrador-may-sku ( INPUT TABLE ITEM).
    END.
    WHEN "Cart-Delete" THEN DO:
        RUN Cart-Delete IN h_b-ped-mostrador-may-sku.
        IF RETURN-VALUE <> 'ADM-ERROR' 
            THEN RUN Devuelve-Temporal IN h_b-ped-mostrador-may-sku ( OUTPUT TABLE ITEM).
    END.
    WHEN "Cart-Clean" THEN DO:
        RUN pda/d-message ("Limpiamos todos los artículos registrados?",
                           "QUESTION",
                           "Pregunta",
                           OUTPUT pRpta).
        IF pRpta = NO THEN RETURN.
        RUN Cart-Clean IN h_b-ped-mostrador-may-sku.
        RUN Devuelve-Temporal IN h_b-ped-mostrador-may-sku ( OUTPUT TABLE ITEM).
        IF h_f-ped-mostrador-may-cust <> ? THEN RUN Limpia-Variables IN h_f-ped-mostrador-may-cust.
    END.
    WHEN "Cart-Save" THEN DO:
        DEF VAR pImpTot AS DEC NO-UNDO.
        RUN Devuelve-Temporal IN h_b-ped-mostrador-may-sku ( OUTPUT TABLE ITEM).
        FOR EACH ITEM NO-LOCK:
            pImpTot = pImpTot + ITEM.ImpLin.
        END.
        IF pImpTot <= 0 THEN RETURN.
        RUN select-page('3').
        RUN Recibe-Parametros IN h_f-ped-mostrador-may-cust ( INPUT pImpTot, INPUT TABLE ITEM).
    END.
    WHEN "Save-SKU" THEN DO:
        RUN Graba-Registro IN h_f-ped-mostrador-may-sku.
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.
/*         RUN select-page('1').                                                    */
/*         RUN Devuelve-Temporal IN h_f-ped-mostrador-may-sku ( OUTPUT TABLE ITEM). */
/*         RUN Captura-Temporal IN h_b-ped-mostrador-may-sku ( INPUT TABLE ITEM).   */
/*         RUN dispatch IN h_b-ped-mostrador-may-sku ('open-query':U).              */
    END.
    WHEN "Cancel-SKU" THEN DO:
        RUN select-page('1').
        RUN Devuelve-Temporal IN h_f-ped-mostrador-may-sku ( OUTPUT TABLE ITEM).
        RUN Captura-Temporal IN h_b-ped-mostrador-may-sku ( INPUT TABLE ITEM).
        RUN dispatch IN h_b-ped-mostrador-may-sku ('open-query':U).
    END.
    WHEN "Save-Customer" THEN DO:
        DEF VAR pMensaje AS CHAR NO-UNDO.
        RUN Valida IN h_f-ped-mostrador-may-cust.
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.
        /* Si todo va bien => devuelve el ITEM + PROMOCIONES */
        RUN Devuelve-Temporal IN h_f-ped-mostrador-may-cust ( OUTPUT TABLE ITEM).
        RUN MASTER-TRANSACTION.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        /* Mensaje final */
        RUN select-page('4').
        RUN Recibe-pedido IN h_f-ped-mostrador-may-end ( INPUT pNroPed /* CHARACTER */).
    END.
    WHEN "Cancel-Customer" THEN DO:
        /* 14/11/2023: OJO verificar si regresa correcta la variables s-codcli */
        IF TRUE <> (s-codcli > '') THEN s-codcli = FacCfgGn.CliVar.
        RUN select-page('1').
    END.
    WHEN "Return-end-message" THEN DO:
        /* Limpiamos todo y vamos a la página 1 */
        RUN select-page('1').
        RUN Cart-Clean IN h_b-ped-mostrador-may-sku.
        RUN Devuelve-Temporal IN h_b-ped-mostrador-may-sku ( OUTPUT TABLE ITEM).
        IF h_f-ped-mostrador-may-cust <> ? THEN RUN Limpia-Variables IN h_f-ped-mostrador-may-cust.
    END.
    WHEN "Save-new-cust" THEN DO:
        RUN Valida IN h_f-new-customer.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
        RUN Crea-Cliente IN h_f-new-customer.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
        /* Pasamos cliente nuevo a la transacción */
        RUN select-page('3').
        RUN Cliente-Nuevo IN h_f-ped-mostrador-may-cust.
    END.
    WHEN "Cancel-new-cust" THEN DO:
        /* Pasamos cliente nuevo a la transacción */
        RUN select-page('3').
    END.
    WHEN "Select-Page-5" THEN DO:
        RUN select-page('5').
    END.
    WHEN "Update-SKU" THEN DO:
        pCodMat = ENTRY(2, pParam, '&').
        RUN select-page('2').
        RUN Devuelve-Temporal IN h_b-ped-mostrador-may-sku ( OUTPUT TABLE ITEM).
        RUN Captura-Temporal IN h_f-ped-mostrador-may-sku ( INPUT TABLE ITEM).
        RUN Update-SKU IN h_f-ped-mostrador-may-sku ( INPUT pCodMat /* CHARACTER */).
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

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

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
               
/* ARTIFICIO */
Fi-Mensaje = "RECALCULANDO PRECIOS".
DISPLAY Fi-Mensaje WITH FRAME F-Proceso.

DEF VAR F-FACTOR AS DECI NO-UNDO.
DEF VAR f-PreVta AS DECI NO-UNDO.
DEF VAR f-PreBas AS DECI NO-UNDO.
DEF VAR f-Dsctos AS DECI NO-UNDO.
DEF VAR z-Dsctos AS DECI NO-UNDO.
DEF VAR y-Dsctos AS DECI NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.
DEF VAR f-FleteUnitario AS DECI NO-UNDO.


FOR EACH ITEM WHERE ITEM.Libre_c05 <> "OF",     /* NO promociones */
    FIRST Almmmatg OF ITEM NO-LOCK:
    ASSIGN
        F-FACTOR = ITEM.Factor
        f-PreVta = ITEM.PreUni
        f-PreBas = ITEM.PreBas
        f-Dsctos = ITEM.PorDto
        z-Dsctos = ITEM.Por_Dsctos[2]
        y-Dsctos = ITEM.Por_Dsctos[3].
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
                                 ITEM.almdes,   /* Necesario para REMATES */
                                 OUTPUT f-PreBas,
                                 OUTPUT f-PreVta,
                                 OUTPUT f-Dsctos,
                                 OUTPUT y-Dsctos,
                                 OUTPUT x-TipDto,
                                 OUTPUT f-FleteUnitario,
                                 OUTPUT pMensaje
                                 ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    ASSIGN 
        ITEM.Factor = f-Factor
        ITEM.PreUni = F-PREVTA
        ITEM.PreBas = F-PreBas 
        ITEM.PreVta[1] = F-PreVta     /* CONTROL DE PRECIO DE LISTA */
        ITEM.PorDto = F-DSCTOS  /* Ambos descuentos afectan */
        ITEM.PorDto2 = 0        /* el precio unitario */
        ITEM.Por_Dsctos[2] = z-Dsctos
        ITEM.Por_Dsctos[3] = Y-DSCTOS 
        ITEM.AftIgv = Almmmatg.AftIgv
        ITEM.AftIsc = Almmmatg.AftIsc
        ITEM.ImpIsc = 0
        ITEM.ImpIgv = 0.
    ASSIGN
        ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                    ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
    IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
        THEN ITEM.ImpDto = 0.
    ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.

    ASSIGN 
        ITEM.Libre_d02 = f-FleteUnitario. 
    IF f-FleteUnitario > 0 THEN DO:
        /* El flete afecta el monto final */
        IF ITEM.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
            ASSIGN
                ITEM.PreUni = ROUND(f-PreVta + f-FleteUnitario, s-NroDec)  /* Incrementamos el PreUni */
                ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni.
        END.
        ELSE DO:      /* CON descuento promocional o volumen */
          /* El flete afecta al precio unitario resultante */
          DEF VAR x-PreUniFin LIKE Facdpedi.PreUni NO-UNDO.
          DEF VAR x-PreUniTeo LIKE Facdpedi.PreUni NO-UNDO.

          x-PreUniFin = ITEM.ImpLin / ITEM.CanPed.          /* Valor resultante */
          x-PreUniFin = x-PreUniFin + f-FleteUnitario.      /* Unitario Afectado al Flete */

          x-PreUniTeo = x-PreUniFin / ( ( 1 - ITEM.Por_Dsctos[1] / 100 ) * ( 1 - ITEM.Por_Dsctos[2] / 100 ) * ( 1 - ITEM.Por_Dsctos[3] / 100 ) ).

          ASSIGN
              ITEM.PreUni = ROUND(x-PreUniTeo, s-NroDec).
        END.
      ASSIGN
          ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                        ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
      IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
          THEN ITEM.ImpDto = 0.
          ELSE ITEM.ImpDto = (ITEM.CanPed * ITEM.PreUni) - ITEM.ImpLin.
    END.
    /* ***************************************************************** */
    ASSIGN
        ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
        ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
    IF ITEM.AftIsc THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE ITEM.ImpIsc = 0.
    IF ITEM.AftIgv THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (s-PorIgv / 100)),4).
    ELSE ITEM.ImpIgv = 0.
END.
HIDE FRAME F-Proceso.
RETURN 'OK'.

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

  /* 14/11/2023: C.Tenazoa Precios Contrato */
  DEF VAR pMensaje AS CHAR NO-UNDO.

  RUN Recalcular-Precios (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
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
DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

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
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

