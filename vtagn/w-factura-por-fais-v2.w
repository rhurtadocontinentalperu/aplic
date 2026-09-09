&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-CodDoc AS CHAR INIT 'FAC' NO-UNDO.
DEF VAR s-CodMov LIKE Facdocum.codmov NO-UNDO.
DEF VAR x-Moneda AS CHAR NO-UNDO.
DEF VAR iCountGuide AS INTEGER NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

FIND FacDocum WHERE FacDocum.CodCia = s-CodCia 
    AND FacDocum.CodDoc = s-CodDoc 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum OR FacDocum.CodMov = 0 THEN DO:
    MESSAGE
        "Codigo de Documento" s-CodDoc "no configurado" SKIP
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
s-CodMov = FacDocum.CodMov.

DEF VAR cOk AS LOG NO-UNDO.
cOk = NO.
FOR EACH FacCorre NO-LOCK WHERE 
    FacCorre.CodCia = s-CodCia AND
    FacCorre.CodDiv = s-CodDiv AND 
    FacCorre.CodDoc = s-CodDoc AND
    FacCorre.FlgEst = YES:
    /* SOLO ACEPTA LOS QUE NO ESTEN ASIGNADOS A UNA CAJA COBRANZA */
    FIND CcbDTerm WHERE CcbDTerm.CodCia = s-codcia
        AND CcbDTerm.CodDiv = s-coddiv
        AND CcbDTerm.CodDoc = s-CodDoc
        AND CcbDTerm.NroSer = FacCorre.NroSer
        NO-LOCK NO-ERROR.
    IF AVAILABLE CcbDTerm THEN DO:
        /* Verificamos la cabecera */
        FIND FIRST CcbCTerm OF CcbDTerm NO-LOCK NO-ERROR.
        IF AVAILABLE CcbCTerm THEN NEXT.
    END.
    cOk = YES.
END.
IF cOk = NO THEN DO:
    MESSAGE "Codigo de Documento" s-CodDoc "no configurado"
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

/* Control de InvoiceCustomerGroup */
DEF TEMP-TABLE T-INVOICE
    FIELD InvoiceCustomerGroup LIKE Faccpedi.InvoiceCustomerGroup
    FIELD CodCli LIKE Faccpedi.CodCli.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-FormatoFAC  AS CHAR INIT '999-99999999' NO-UNDO.
DEF VAR x-FormatoGUIA AS CHAR INIT '999-999999' NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-FormatoFAC).
RUN sunat\p-formato-doc (INPUT "G/R", OUTPUT x-FormatoGUIA).

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Clientes FILL-IN-FchSal-1 ~
FILL-IN-FchSal-2 COMBO-NroSer BUTTON-Filtrar BUTTON-Exportar Btn_OK BtnDone ~
RECT-2 RECT-3 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Clientes FILL-IN-FchSal-1 ~
FILL-IN-FchSal-2 COMBO-NroSer FILL-IN-NroDoc FILL-IN-Division 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-factura-por-fais-v2 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "&Done" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "&Aceptar" 
     SIZE 12 BY 1.54.

DEFINE BUTTON BUTTON-Exportar 
     LABEL "EXPORTAR A TEXTO" 
     SIZE 20 BY 1.12.

DEFINE BUTTON BUTTON-Filtrar 
     LABEL "APLICAR FILTROS" 
     SIZE 20 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Clientes AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione un cliente" 
     LABEL "Cliente" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Seleccione un cliente","Seleccione un cliente"
     DROP-DOWN-LIST
     SIZE 69 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U 
     LABEL "Serie FAC" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Division AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 69 BY 1
     BGCOLOR 11 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchSal-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Salida Desde (H/R cerrada y G/R entregada)" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchSal-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "XXX-XXXXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 13.57 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 105 BY 1.92
     BGCOLOR 11 FGCOLOR 0 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 105 BY 3.5
     BGCOLOR 15 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Clientes AT ROW 3.15 COL 19 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-FchSal-1 AT ROW 4.23 COL 40 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-FchSal-2 AT ROW 4.23 COL 59 COLON-ALIGNED WIDGET-ID 44
     COMBO-NroSer AT ROW 5.31 COL 13.43 WIDGET-ID 28
     FILL-IN-NroDoc AT ROW 5.38 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     FILL-IN-Division AT ROW 1.54 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BUTTON-Filtrar AT ROW 3.96 COL 80 WIDGET-ID 38
     BUTTON-Exportar AT ROW 5.04 COL 80 WIDGET-ID 48
     Btn_OK AT ROW 7.46 COL 107 WIDGET-ID 32
     BtnDone AT ROW 9.08 COL 107 WIDGET-ID 34
     RECT-2 AT ROW 1 COL 1 WIDGET-ID 10
     RECT-3 AT ROW 2.88 COL 1 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 119.72 BY 25.38
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION DE COMPROBANTES POR FAI's"
         HEIGHT             = 25.38
         WIDTH              = 119.72
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION DE COMPROBANTES POR FAI's */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION DE COMPROBANTES POR FAI's */
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


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN
         COMBO-NroSer FILL-IN-Division FILL-IN-NroDoc COMBO-BOX-Clientes.
    IF FILL-IN-Division BEGINS 'Seleccione' THEN RETURN NO-APPLY.

    MESSAGE "¿Todos los datos son correctos?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE rpta AS LOGICAL.
    IF rpta <> TRUE THEN RETURN NO-APPLY.

    /* UN SOLO PROCESO */
    pMensaje = "".
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Generacion-de-Factura IN h_b-factura-por-fais-v2 ( INPUT COMBO-NroSer,
                                                           OUTPUT pMensaje,
                                                           OUTPUT iCountGuide).
    SESSION:SET-WAIT-STATE('').
    IF RETURN-VALUE = 'ADM-ERROR' THEN
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    ELSE DO:
        MESSAGE "Se ha(n) generado" iCountGuide "Factura(s)"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    COMBO-BOX-Clientes = "Seleccione un cliente".
    DISPLAY COMBO-BOX-Clientes WITH FRAME {&FRAME-NAME}.
    APPLY 'VALUE-CHANGED':U TO COMBO-BOX-Clientes.
    APPLY 'CHOOSE':U TO BUTTON-Filtrar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Exportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Exportar W-Win
ON CHOOSE OF BUTTON-Exportar IN FRAME F-Main /* EXPORTAR A TEXTO */
DO:
  RUN Texto IN h_b-factura-por-fais-v2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Filtrar W-Win
ON CHOOSE OF BUTTON-Filtrar IN FRAME F-Main /* APLICAR FILTROS */
DO:
    ASSIGN COMBO-BOX-Clientes COMBO-NroSer
        FILL-IN-FchSal-1 FILL-IN-FchSal-2.
    IF FILL-IN-FchSal-1 = ? OR FILL-IN-FchSal-2 = ? THEN DO:
        MESSAGE 'No ha ingresado todos los rangos de fecha' SKIP
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    RUN Carga-Temporal IN h_b-factura-por-fais-v2
    ( INPUT COMBO-BOX-Clientes /* CHARACTER */,
      INPUT FILL-IN-FchSal-1 /* DATE */,
      INPUT FILL-IN-FchSal-2 /* DATE */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Clientes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Clientes W-Win
ON VALUE-CHANGED OF COMBO-BOX-Clientes IN FRAME F-Main /* Cliente */
DO:
    ASSIGN COMBO-BOX-Clientes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer W-Win
ON RETURN OF COMBO-NroSer IN FRAME F-Main /* Serie FAC */
DO:
    APPLY 'Tab':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer W-Win
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME F-Main /* Serie FAC */
DO:
    /* Correlativo */
    FIND FacCorre WHERE FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = s-CodDoc AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN 
        FILL-IN-NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-FormatoFAC,'-')) + 
                        STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoFAC,'-')).
    ELSE FILL-IN-NroDoc = "".
    DISPLAY FILL-IN-NroDoc WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

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
             INPUT  'vtagn/b-factura-por-fais-v2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-factura-por-fais-v2 ).
       RUN set-position IN h_b-factura-por-fais-v2 ( 6.38 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-factura-por-fais-v2 ( 19.85 , 105.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-factura-por-fais-v2 ,
             BUTTON-Exportar:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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
  DISPLAY COMBO-BOX-Clientes FILL-IN-FchSal-1 FILL-IN-FchSal-2 COMBO-NroSer 
          FILL-IN-NroDoc FILL-IN-Division 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Clientes FILL-IN-FchSal-1 FILL-IN-FchSal-2 COMBO-NroSer 
         BUTTON-Filtrar BUTTON-Exportar Btn_OK BtnDone RECT-2 RECT-3 
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

  DO WITH FRAME {&FRAME-NAME}:
      RUN src/bin/_dateif(INPUT MONTH(TODAY),
                          INPUT YEAR(TODAY),
                          OUTPUT FILL-IN-FchSal-1,
                          OUTPUT FILL-IN-FchSal-2).
      ASSIGN
          COMBO-NroSer:FORMAT = TRIM(ENTRY(1,x-FormatoFAC,'-'))
          FILL-IN-NroDoc:FORMAT = x-FormatoFAC.
      /* CORRELATIVO DE FAC */
      cListItems = "".
      FOR EACH FacCorre NO-LOCK WHERE 
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDiv = s-CodDiv AND 
          FacCorre.CodDoc = s-CodDoc AND
          FacCorre.FlgEst = YES:
          IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
          ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
      END.
      ASSIGN
          COMBO-NroSer:LIST-ITEMS = cListItems
          COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS).
      FIND FacCorre WHERE FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDoc = s-CodDoc AND
          FacCorre.CodDiv = s-CodDiv AND
          FacCorre.NroSer = INTEGER(COMBO-NroSer)
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN
          FILL-IN-NroDoc = STRING(FacCorre.NroSer,"999") +
          STRING(FacCorre.Correlativo,"999999").
      FIND gn-divi WHERE gn-divi.codcia = s-codcia
          AND gn-divi.coddiv = s-coddiv
          NO-LOCK.
      FILL-IN-Division = "DIVISIÓN: " + gn-divi.coddiv + " " + GN-DIVI.DesDiv.
      COMBO-BOX-Clientes:DELIMITER = '|'.
      EMPTY TEMP-TABLE T-INVOICE.
      FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
          /*AND ccbcdocu.coddiv = s-coddiv*/
          AND ccbcdocu.coddoc = "FAI"
          AND ccbcdocu.flgest = "P",
          FIRST PEDIDO WHERE PEDIDO.CodCia = CcbCDocu.CodCia
          AND PEDIDO.CodDoc = CcbCDocu.CodPed
          AND PEDIDO.NroPed = CcbCDocu.NroPed NO-LOCK,
          FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia
          AND COTIZACION.CodDoc = PEDIDO.CodRef
          AND COTIZACION.NroPed = PEDIDO.NroRef 
          AND COTIZACION.InvoiceCustomerGroup > '' NO-LOCK
          BREAK BY COTIZACION.codcli BY COTIZACION.InvoiceCustomerGroup:
          IF FIRST-OF(COTIZACION.codcli) THEN DO:
              COMBO-BOX-Clientes:ADD-LAST( ccbcdocu.codcli + ' ' + ccbcdocu.nomcli , ccbcdocu.codcli ).
          END.
          IF FIRST-OF(COTIZACION.codcli) OR FIRST-OF(COTIZACION.InvoiceCustomerGroup)
              THEN DO:
              CREATE T-INVOICE.
              ASSIGN
                  T-INVOICE.InvoiceCustomerGroup = COTIZACION.InvoiceCustomerGroup
                  T-INVOICE.CodCli = COTIZACION.CodCli.
          END.
      END.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY 'VALUE-CHANGED':U TO COMBO-NroSer IN FRAME {&FRAME-NAME}.

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

