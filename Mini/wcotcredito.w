&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE NEW SHARED TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM-3 LIKE FacDPedi.



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
DEF INPUT PARAMETER pParametro AS CHAR.
/* Sintaxis : x{,ddddd}
    x: Tipo de Pedido
        N: Venta normal
        S: Canal Moderno
        E: Expolibreria (opcional)
        P: Provincias
        M: Contrato Marco
        R: Remates
        NXTL: Nextel
        VU : Vales Utilex
    ddddd: División (opcional). Se asume la división s-coddiv por defecto
*/

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEFINE NEW SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE NEW SHARED VARIABLE S-CODDOC  AS CHAR.
DEFINE NEW SHARED VARIABLE s-NroPed AS CHAR.
DEFINE NEW SHARED VARIABLE s-nrodec AS INT.
DEFINE NEW SHARED VARIABLE s-flgigv AS LOG.
DEFINE NEW SHARED VARIABLE s-PorIgv LIKE Ccbcdocu.PorIgv.
DEFINE NEW SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE NEW SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE NEW SHARED VARIABLE S-TPOCMB  AS DEC.
DEFINE NEW SHARED VARIABLE s-FlgSit AS CHAR.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE NEW SHARED VARIABLE S-CNDVTA  AS CHAR.
DEFINE NEW SHARED VARIABLE pCodDiv  AS CHAR.
DEFINE NEW SHARED VARIABLE s-fmapgo AS CHAR INIT "000".
DEFINE NEW SHARED VARIABLE s-TpoPed AS CHAR.
s-TpoPed = ENTRY(1, pParametro).
IF NUM-ENTRIES(pParametro) > 1 
    THEN pCodDiv = ENTRY(2, pParametro).
    ELSE pCodDiv = s-CodDiv.

FIND FIRST FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCfgGn THEN DO:
    MESSAGE 'Los parámetros generales NO están configurados' VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.
ASSIGN
    s-FlgIgv = YES
    s-PorIgv = FacCfgGn.PorIgv
    s-adm-new-record = 'YES'
    s-CodCli = FacCfgGn.CliVar
    s-FlgSit = ''
    s-CodMon = 1        /* Soles */
    s-CodDoc = "PPV"    /* PrePedido Vitrina */
    s-NroDec = 4
    s-CndVta = "001".   /* Contado Contraentrega */

DEFINE NEW SHARED VAR s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE NEW SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE NEW SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.


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
    s-VentaMayorista = GN-DIVI.VentaMayorista.
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
        /* TODOS los Almacenes */
        FOR EACH VtaAlmDiv NO-LOCK WHERE Vtaalmdiv.codcia = s-codcia
            AND Vtaalmdiv.coddiv = s-coddiv,
            FIRST Almacen OF Vtaalmdiv NO-LOCK 
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
s-CodAlm = ENTRY(1, s-CodAlm).

/* PARAMETROS NUEVO PEDIDO */
DEF VAR pNroPed AS CHAR NO-UNDO.
DEF VAR s-NroSer AS INT NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR s-FlgEnv AS LOG INIT NO.

FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia
    AND FacCorre.CodDiv = s-coddiv
    AND FacCorre.CodDoc = s-coddoc
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'NO está definido el correlativo para el documento:' s-coddoc
        VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.
s-NroSer = FacCorre.NroSer.

DEF TEMP-TABLE ResumenxLinea
    FIELD codmat LIKE almmmatg.codmat
    FIELD codfam LIKE almmmatg.codfam
    FIELD subfam LIKE almmmatg.subfam
    FIELD canped LIKE facdpedi.canped
    INDEX Llave01 AS PRIMARY /*UNIQUE*/ codmat codfam subfam.

DEF TEMP-TABLE ErroresxLinea LIKE ResumenxLinea.

DEF NEW SHARED VAR s-FlgTipoVenta   LIKE GN-DIVI.FlgPreVta.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    /*AND gn-divi.coddiv = s-coddiv*/
    AND gn-divi.coddiv = pCodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' s-coddiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.
ASSIGN
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
&Scoped-Define ENABLED-OBJECTS BUTTON-NUEVA BUTTON-GRABAR BUTTON-BUSCAR ~
BtnDone FILL-IN-NroPed 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NroPed 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tcotcredito AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 6 BY 1.35
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-BUSCAR 
     LABEL "BUSCAR" 
     SIZE 17 BY 1.35
     FONT 8.

DEFINE BUTTON BUTTON-GRABAR 
     LABEL "GRABAR" 
     SIZE 17 BY 1.35
     FONT 8.

DEFINE BUTTON BUTTON-NUEVA 
     LABEL "NUEVA" 
     SIZE 15 BY 1.35
     FONT 8.

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(256)":U INITIAL "NUEVO" 
     VIEW-AS FILL-IN 
     SIZE 19 BY 1.35
     BGCOLOR 10 FGCOLOR 1 FONT 8 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-NUEVA AT ROW 1 COL 2 WIDGET-ID 2
     BUTTON-GRABAR AT ROW 1 COL 17 WIDGET-ID 6
     BUTTON-BUSCAR AT ROW 1 COL 34 WIDGET-ID 4
     BtnDone AT ROW 1 COL 52 WIDGET-ID 8
     FILL-IN-NroPed AT ROW 19.27 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65.57 BY 19.81
         FONT 6 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: ITEM T "NEW SHARED" ? INTEGRAL FacDPedi
      TABLE: ITEM-3 T "?" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "VENTAS"
         HEIGHT             = 19.81
         WIDTH              = 65.86
         MAX-HEIGHT         = 19.81
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 19.81
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
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* VENTAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* VENTAS */
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


&Scoped-define SELF-NAME BUTTON-BUSCAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-BUSCAR W-Win
ON CHOOSE OF BUTTON-BUSCAR IN FRAME F-Main /* BUSCAR */
DO:
    RUN MINI\dnumdecontrol (s-CodDoc, OUTPUT pNroPed).
    IF pNroPed = '' THEN RETURN NO-APPLY.
    /* Buscamos Pedido */
    FIND FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddiv = s-coddiv
        AND Faccpedi.coddoc = s-coddoc
        AND Faccpedi.nroped = pNroPed
        AND LOOKUP(Faccpedi.flgest, 'I,P') > 0
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN DO:
        MESSAGE 'NO se encontró el Pedido' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    s-NroPed = pNroPed.   /* Actualizamos control de pedidos */
    s-adm-new-record = 'NO'.
    EMPTY TEMP-TABLE ITEM.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.libre_c05 <> "OF":
        CREATE ITEM.
        BUFFER-COPY Facdpedi TO ITEM.
    END.
    RUN dispatch IN h_tcotcredito ('open-query':U).
    DISPLAY s-NroPed @  FILL-IN-NroPed WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-GRABAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-GRABAR W-Win
ON CHOOSE OF BUTTON-GRABAR IN FRAME F-Main /* GRABAR */
DO:
  FIND FIRST ITEM NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ITEM THEN RETURN NO-APPLY.
  /* Solo si es uno nuevo */
  IF s-adm-new-record = 'YES' THEN DO:
      RUN MINI\dnumdecontrol (s-CodDoc, OUTPUT pNroPed).
      IF pNroPed = '' THEN RETURN NO-APPLY.
      s-NroPed = pnroPed.   /* Actualizamos control de pedidos */
  END.
  RUN Grabar.
  RUN dispatch IN h_tcotcredito ('open-query':U).
  DISPLAY s-NroPed @  FILL-IN-NroPed WITH FRAME {&FRAME-NAME}.
  /* Cambia color */
  ASSIGN
      FILL-IN-NroPed:BGCOLOR = 10 
      FILL-IN-NroPed:FGCOLOR = 1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-NUEVA
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-NUEVA W-Win
ON CHOOSE OF BUTTON-NUEVA IN FRAME F-Main /* NUEVA */
DO:
  /* Limpiamos todo */
  RUN select-page ('1').
  EMPTY TEMP-TABLE ITEM.
  RUN dispatch IN h_tcotcredito ('open-query':U).
  s-NroPed = "".    /* Limpiamos Control */
  s-adm-new-record = 'YES'.
  DISPLAY "NUEVO" @  FILL-IN-NroPed WITH FRAME {&FRAME-NAME}.
  /* Cambia color */
  ASSIGN
      FILL-IN-NroPed:BGCOLOR = 10 
      FILL-IN-NroPed:FGCOLOR = 1.

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
             INPUT  'mini/tcotcredito.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_tcotcredito ).
       RUN set-position IN h_tcotcredito ( 2.54 , 1.57 ) NO-ERROR.
       RUN set-size IN h_tcotcredito ( 16.73 , 65.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 19.27 , 1.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 1.42 , 44.00 ) NO-ERROR.

       /* Links to SmartBrowser h_tcotcredito. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_tcotcredito ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_tcotcredito ,
             BtnDone:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_tcotcredito , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Pedido W-Win 
PROCEDURE Borra-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER p-Ok AS LOG.
  
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FOR EACH Facdpedi OF Faccpedi:
          IF p-Ok = YES
          THEN DELETE Facdpedi.
          ELSE Facdpedi.FlgEst = 'A'.   /* <<< OJO <<< */
      END.    
  END.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Finales-01 W-Win 
PROCEDURE Descuentos-Finales-01 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2\descuentos-finales-01.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Finales-02 W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-solo-campana W-Win 
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
  DISPLAY FILL-IN-NroPed 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-NUEVA BUTTON-GRABAR BUTTON-BUSCAR BtnDone FILL-IN-NroPed 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido W-Win 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.

  DEF VAR f-PreBas AS DEC NO-UNDO.
  DEF VAR f-PreVta AS DEC NO-UNDO.
  DEF VAR f-Dsctos AS DEC NO-UNDO.
  DEF VAR y-Dsctos AS DEC NO-UNDO.
  DEF VAR SW-LOG1  AS LOGI NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.

  /* POR CADA ITEM VOLVEMOS A VERIFICAR EL STOCK DISPONIBLE
    SI NO HAY STOCK RECALCULAMOS EL PRECIO DE VENTA */
  /* Borramos data sobrante */
  FOR EACH ITEM WHERE ITEM.CanPed <= 0:
      DELETE ITEM.
  END.
  /* Acumulamos */
  EMPTY TEMP-TABLE ITEM-3.
  FOR EACH ITEM:
      FIND ITEM-3 WHERE ITEM-3.codmat = ITEM.codmat NO-ERROR.
      IF NOT AVAILABLE ITEM-3 THEN DO:
          CREATE ITEM-3.
          BUFFER-COPY ITEM TO ITEM-3.
      END.
      ELSE ASSIGN ITEM-3.canped = ITEM-3.canped + ITEM.canped.
  END.
  EMPTY TEMP-TABLE ITEM.
  FOR EACH ITEM-3:
      CREATE ITEM.
      BUFFER-COPY ITEM-3 TO ITEM.
      DELETE ITEM-3.
  END.

  /* RECALCULAMOS LOS PRECIOS */
  /*RUN Procesa-Handle IN lh_handle ('Recalculo').*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar W-Win 
PROCEDURE Grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

/* Buscamos si no ha sido registrado */
IF s-adm-new-record = 'YES' THEN DO:
    FIND FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddoc = s-coddiv
        AND Faccpedi.nroped = s-NroPed
        NO-LOCK NO-ERROR.
    IF AVAILABLE Faccpedi THEN DO:
        MESSAGE 'YA ha sido registrado anteriormente' VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
END.
pMensaje = ''.

RLOOP:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
  /* Siempre bloqueamos el correlativo como control multiusuario */
  DEF VAR iLocalCounter AS INTEGER INITIAL 0 NO-UNDO.
  GetLock:
  DO ON STOP UNDO GetLock, RETRY GetLock:
      IF RETRY THEN DO:
          iLocalCounter = iLocalCounter + 1.
          IF iLocalCounter = 5 THEN LEAVE GetLock.
      END.
      FIND FacCorre WHERE FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDoc = s-coddoc AND
          FacCorre.NroSer = s-nroser EXCLUSIVE-LOCK NO-ERROR.
  END. 
  IF iLocalCounter = 5 OR NOT AVAILABLE FacCorre THEN DO:
      pMensaje = 'NO se pudo bloquear el control de correlativos'.
      UNDO, LEAVE RLOOP.
  END.
  IF s-adm-new-record = 'YES' THEN DO:
      /* Bloqueamos Correlativo */
      IF FacCorre.FlgCic = NO THEN DO:
          IF FacCorre.NroFin > 0 AND FacCorre.Correlativo > FacCorre.NroFin THEN DO:
              pMensaje = 'Se ha llegado al límite del correlativo: ' + STRING(FacCorre.NroFin) + CHR(10) +
                  'No se puede generar el documento ' + s-CodDoc  + ' serie ' + STRING(s-NroSer).
              UNDO, LEAVE RLOOP.
          END.
      END.
      IF FacCorre.FlgCic = YES THEN DO:
          /* REGRESAMOS AL NUMERO 1 */
          IF FacCorre.NroFin > 0 AND FacCorre.Correlativo > FacCorre.NroFin THEN DO:
              IF FacCorre.NroIni > 0 THEN FacCorre.Correlativo = FacCorre.NroIni.
              ELSE FacCorre.Correlativo = 1.
          END.
      END.
      /* ********************** */
      CREATE FacCPedi.
      ASSIGN 
          FacCPedi.CodCia = S-CODCIA
          FacCPedi.CodDiv = S-CODDIV
          FacCPedi.CodDoc = s-coddoc 
          FacCPedi.CodAlm = s-CodAlm    /* Lista de Almacenes Válidos de Venta */
          FacCPedi.FchPed = TODAY 
          FacCPedi.NroPed = s-NroPed    /* Número de control */
          FacCPedi.NroRef = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
          /*FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")*/
          FacCPedi.TpoPed = s-TpoPed
          FacCPedi.FlgEst = (IF Faccpedi.CodCli BEGINS "SYS" THEN "I" ELSE "P").    /* PENDIENTE */
      ASSIGN
          FacCPedi.CodCli = s-CodCli
          FacCPedi.CodVen = s-User-Id
          FacCPedi.FmaPgo = s-CndVta
          FacCPedi.CodMon = s-CodMon
          FacCPedi.TpoCmb = s-TpoCmb
          FacCPedi.FlgIgv = s-FlgIgv
          FacCPedi.Libre_d01 = s-NroDec.
      ASSIGN
          FacCorre.Correlativo = FacCorre.Correlativo + 1.
      /* TRACKING */
      RUN vtagn/pTracking-04 (s-CodCia,
                        s-CodDiv,
                        Faccpedi.CodDoc,
                        Faccpedi.NroPed,
                        s-User-Id,
                        'GNP',
                        'P',
                        DATETIME(TODAY, MTIME),
                        DATETIME(TODAY, MTIME),
                        Faccpedi.CodDoc,
                        Faccpedi.NroPed,
                        Faccpedi.CodRef,
                        Faccpedi.NroRef).
  END.
  ELSE DO:
      /* Bloqueamos Pedido */
      FIND Faccpedi WHERE FacCPedi.CodCia = S-CODCIA
          AND FacCPedi.CodDiv = S-CODDIV
          AND FacCPedi.CodDoc = s-coddoc 
          AND FacCPedi.NroPed = s-NroPed
          AND LOOKUP(FacCPedi.FlgEst, 'I,P') > 0
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccpedi THEN DO:
          pMensaje = "NO se pudo bloquear el pedido".
          UNDO, LEAVE RLOOP.
      END.
      RUN Borra-Pedido (YES).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          pMensaje = "NO se pudo actualizar el pedido".
          UNDO, LEAVE RLOOP.
      END.
  END.
  ASSIGN 
      FacCPedi.PorIgv = s-PorIgv
      FacCPedi.Hora = STRING(TIME,"HH:MM")
      FacCPedi.Usuario = S-USER-ID
      FacCPedi.FlgEnv = s-FlgEnv.

  /* Detalle del Pedido */
  RUN Genera-Pedido.    /* Detalle del pedido */
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      pMensaje = "NO se pudo generar el pedido." + CHR(10) + "NO hay stock suficiente en los almacenes".
      UNDO, LEAVE RLOOP.
  END.

  /* RHC 11/12/2013 */
  RUN Descuentos-Finales-01.
  RUN Descuentos-Finales-02.

  /* RHC DESCUENTOS ESPECIALES SOLO CAMPAÑA */
  RUN Descuentos-solo-campana.

  /*RUN Descuentos-Finales-03.*/

  /* Grabamos Totales */
  {vta2/graba-totales-cotizacion-cred.i}

END.
IF AVAILABLE (FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE (Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE (Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE (B-CPEDI) THEN RELEASE B-CPEDI.
IF AVAILABLE (B-DPEDI) THEN RELEASE B-DPEDI.
IF pMensaje <> '' THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    /* {lib/_mensaje.i &Matriz="pMensaje" &TipoAviso="ERROR"} */
   RETURN.
END.
s-adm-new-record = 'NO'.    /* OJO */

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
   RUN Cambia-Font IN h_p-updv12
    ( INPUT 10).

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

CASE l-Handle:
    WHEN "Add-Record" THEN DO:
        RUN dispatch IN h_tcotcredito ('add-record':U).
      END.
    WHEN "Disable-Head" THEN DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            BUTTON-BUSCAR:SENSITIVE = NO
            BUTTON-GRABAR:SENSITIVE = NO
            BUTTON-NUEVA:SENSITIVE = NO
            BtnDone:SENSITIVE = NO.
        /* Cambia color */
        ASSIGN
            FILL-IN-NroPed:BGCOLOR = 12 
            FILL-IN-NroPed:FGCOLOR = 1.
      END.
    WHEN "Enable-Head" THEN DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            BUTTON-BUSCAR:SENSITIVE = YES
            BUTTON-GRABAR:SENSITIVE = YES
            BUTTON-NUEVA:SENSITIVE = YES
            BtnDone:SENSITIVE = YES.
        /* Cambia color */
        ASSIGN
            FILL-IN-NroPed:BGCOLOR = 12 
            FILL-IN-NroPed:FGCOLOR = 1.
      END.
    WHEN "Recalculo" THEN DO WITH FRAME {&FRAME-NAME}:
         IF h_tcotcredito <> ? THEN RUN Recalcular-Precios IN h_tcotcredito.
         IF h_tcotcredito <> ? THEN RUN dispatch IN h_tcotcredito ('open-query':U). 
         /* Cambia color */
         ASSIGN
             FILL-IN-NroPed:BGCOLOR = 10 
             FILL-IN-NroPed:FGCOLOR = 1.
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

