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
DEF NEW SHARED VAR s-import-b2b AS LOG INIT NO.
DEF NEW SHARED TEMP-TABLE T-DPEDI LIKE FacDPedi.
DEF NEW SHARED VAR s-adm-new-record AS CHAR.
DEF NEW SHARED VAR S-NROPED AS CHAR.
DEF NEW SHARED VAR S-CMPBNTE  AS CHAR.
DEF NEW SHARED VAR S-TPOMARCO AS CHAR.      /* CASO DE CLIENTES EXCEPCIONALES */

/* CONTROL DE ALMACENES DE DESCARGA */
DEF NEW SHARED VAR s-CodAlm AS CHAR.

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

DEF NEW SHARED VAR s-cndvta-validos AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS RECT-66 BUTTON-CERRAR BUTTON-MODIFICAR 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_bcierredecotizacion AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bcotgralcredmayoristav21 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tcotgralcredmayoristav21 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-CANCELAR 
     LABEL "CANCELAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-CERRAR 
     LABEL "CERRAR COTIZACION" 
     SIZE 22 BY 1.12.

DEFINE BUTTON BUTTON-GRABAR 
     LABEL "GRABAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-MODIFICAR 
     LABEL "MODIFICAR" 
     SIZE 15 BY 1.12.

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 1.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-CERRAR AT ROW 2.92 COL 116 WIDGET-ID 2
     BUTTON-MODIFICAR AT ROW 25.23 COL 99 WIDGET-ID 4
     BUTTON-GRABAR AT ROW 25.23 COL 114 WIDGET-ID 6
     BUTTON-CANCELAR AT ROW 25.23 COL 129 WIDGET-ID 8
     RECT-66 AT ROW 25.04 COL 98 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.43 BY 25.85 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
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
         TITLE              = "CIERRE DE COTIZACIONES"
         HEIGHT             = 25.85
         WIDTH              = 144.43
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 148
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 148
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
/* SETTINGS FOR BUTTON BUTTON-CANCELAR IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-GRABAR IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CIERRE DE COTIZACIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CIERRE DE COTIZACIONES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-CANCELAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-CANCELAR W-Win
ON CHOOSE OF BUTTON-CANCELAR IN FRAME F-Main /* CANCELAR */
DO:
    RUN Procesa-Handle ("Pagina1").
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-CERRAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-CERRAR W-Win
ON CHOOSE OF BUTTON-CERRAR IN FRAME F-Main /* CERRAR COTIZACION */
DO:
   RUN Cerrar IN h_bcierredecotizacion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-GRABAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-GRABAR W-Win
ON CHOOSE OF BUTTON-GRABAR IN FRAME F-Main /* GRABAR */
DO:
    RUN Actualiza-Pedido IN h_bcierredecotizacion NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
    RUN Procesa-Handle ("Pagina1").
    RUN dispatch IN h_bcotgralcredmayoristav21 ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-MODIFICAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-MODIFICAR W-Win
ON CHOOSE OF BUTTON-MODIFICAR IN FRAME F-Main /* MODIFICAR */
DO:
  RUN Carga-Parametros IN h_bcierredecotizacion NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
  RUN Procesa-Handle ("Pagina2").
  RUN dispatch IN h_tcotgralcredmayoristav21 ('open-query':U).
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

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/bcierredecotizacion.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcierredecotizacion ).
       RUN set-position IN h_bcierredecotizacion ( 1.00 , 1.00 ) NO-ERROR.
       RUN set-size IN h_bcierredecotizacion ( 10.00 , 114.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcierredecotizacion ,
             BUTTON-CERRAR:HANDLE IN FRAME F-Main , 'BEFORE':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/bcotgralcredmayoristav21.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcotgralcredmayoristav21 ).
       RUN set-position IN h_bcotgralcredmayoristav21 ( 11.00 , 1.00 ) NO-ERROR.
       RUN set-size IN h_bcotgralcredmayoristav21 ( 13.85 , 144.00 ) NO-ERROR.

       /* Links to SmartBrowser h_bcotgralcredmayoristav21. */
       RUN add-link IN adm-broker-hdl ( h_bcierredecotizacion , 'Record':U , h_bcotgralcredmayoristav21 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcotgralcredmayoristav21 ,
             BUTTON-CERRAR:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/tcotgralcredmayoristav21.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_tcotgralcredmayoristav21 ).
       RUN set-position IN h_tcotgralcredmayoristav21 ( 11.00 , 1.00 ) NO-ERROR.
       RUN set-size IN h_tcotgralcredmayoristav21 ( 13.19 , 144.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 22.73 , 1.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 1.42 , 34.14 ) NO-ERROR.

       /* Links to SmartBrowser h_tcotgralcredmayoristav21. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_tcotgralcredmayoristav21 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_tcotgralcredmayoristav21 ,
             BUTTON-CERRAR:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_tcotgralcredmayoristav21 , 'AFTER':U ).
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
  ENABLE RECT-66 BUTTON-CERRAR BUTTON-MODIFICAR 
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
            BUTTON-CERRAR:SENSITIVE = YES
            BUTTON-MODIFICAR:SENSITIVE = YES
            BUTTON-GRABAR:SENSITIVE = NO
            BUTTON-CANCELAR:SENSITIVE = NO.
        RUN dispatch IN h_bcierredecotizacion ('enable':U).
    END.
    WHEN "Pagina2"  THEN DO WITH FRAME {&FRAME-NAME}:
        RUN select-page(2).
        ASSIGN
            BUTTON-CERRAR:SENSITIVE = NO
            BUTTON-MODIFICAR:SENSITIVE = NO
            BUTTON-GRABAR:SENSITIVE = YES
            BUTTON-CANCELAR:SENSITIVE = YES.
        RUN dispatch IN h_bcierredecotizacion ('disable':U).
    END.
    WHEN "Disable-Head" THEN DO:
        ASSIGN
            BUTTON-CANCELAR:SENSITIVE = NO
            BUTTON-GRABAR:SENSITIVE = NO.
    END.
    WHEN "Enable-Head" THEN DO:
        ASSIGN
            BUTTON-CANCELAR:SENSITIVE = YES
            BUTTON-GRABAR:SENSITIVE = YES.
    END.
    WHEN "Recalculo" THEN RUN Recalcular-Precios IN h_bcierredecotizacion.
    WHEN "Add-Record"   THEN RUN notify IN h_p-updv12   ('add-record':U).
    WHEN "browse" THEN DO:
          IF h_tcotgralcredmayoristav21 <> ? THEN RUN dispatch IN h_tcotgralcredmayoristav21 ('open-query':U). 
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

