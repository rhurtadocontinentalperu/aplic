&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE clientes NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE comprobantes NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE tt-DI-RutaC NO-UNDO LIKE DI-RutaC.



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

DEFINE SHARED VAR s-coddiv AS CHAR.

DEFINE VAR dFechaIni AS DATE.
DEFINE VAR cCondVta AS CHAR.

dFechaIni = TODAY - 7.
/*dFechaIni = DATE(01/01/2019).*/
cCondVta = '001'.       /* Contraentrega */

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
&Scoped-Define ENABLED-OBJECTS BUTTON-grabar TOGGLE-cerrar 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-cerrar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-cobranza-contraentrega AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-cobranza-contraentrega-clien AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-cobranza-contraentrega-cmpte AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-grabar 
     LABEL "Grabar" 
     SIZE 13 BY 1.12.

DEFINE VARIABLE TOGGLE-cerrar AS LOGICAL INITIAL no 
     LABEL "Cerrar cobranza" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.72 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-grabar AT ROW 9.69 COL 153 WIDGET-ID 4
     TOGGLE-cerrar AT ROW 10.88 COL 150.72 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 169 BY 22.38
         FONT 3 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: clientes T "?" NO-UNDO INTEGRAL w-report
      TABLE: comprobantes T "?" NO-UNDO INTEGRAL w-report
      TABLE: tt-DI-RutaC T "?" NO-UNDO INTEGRAL DI-RutaC
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Conta entrega - cobranza - distribucion"
         HEIGHT             = 22.38
         WIDTH              = 169
         MAX-HEIGHT         = 22.38
         MAX-WIDTH          = 174
         VIRTUAL-HEIGHT     = 22.38
         VIRTUAL-WIDTH      = 174
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
ON END-ERROR OF W-Win /* Conta entrega - cobranza - distribucion */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Conta entrega - cobranza - distribucion */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-grabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-grabar W-Win
ON CHOOSE OF BUTTON-grabar IN FRAME F-Main /* Grabar */
DO:
  RUN grabar-cobranza.
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
             INPUT  'aplic/logis/b-cobranza-contraentrega.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cobranza-contraentrega ).
       RUN set-position IN h_b-cobranza-contraentrega ( 1.08 , 1.86 ) NO-ERROR.
       RUN set-size IN h_b-cobranza-contraentrega ( 10.77 , 148.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-cobranza-contraentrega-cmptes.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cobranza-contraentrega-cmpte ).
       RUN set-position IN h_b-cobranza-contraentrega-cmpte ( 11.92 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-cobranza-contraentrega-cmpte ( 10.42 , 72.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-cobranza-contraentrega-clientes.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cobranza-contraentrega-clien ).
       RUN set-position IN h_b-cobranza-contraentrega-clien ( 11.92 , 74.14 ) NO-ERROR.
       RUN set-size IN h_b-cobranza-contraentrega-clien ( 11.08 , 94.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-cobranza-contraentrega-cmpte. */
       RUN add-link IN adm-broker-hdl ( h_b-cobranza-contraentrega , 'Record':U , h_b-cobranza-contraentrega-cmpte ).

       /* Links to SmartBrowser h_b-cobranza-contraentrega-clien. */
       RUN add-link IN adm-broker-hdl ( h_b-cobranza-contraentrega , 'Record':U , h_b-cobranza-contraentrega-clien ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-cobranza-contraentrega ,
             BUTTON-grabar:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-cobranza-contraentrega-cmpte ,
             TOGGLE-cerrar:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-cobranza-contraentrega-clien ,
             h_b-cobranza-contraentrega-cmpte , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-info W-Win 
PROCEDURE carga-info :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR dResponsable AS CHAR.
DEFINE VAR iTipoCambio AS DEC.

SESSION:SET-WAIT-STATE("GENERAL").

EMPTY TEMP-TABLE tt-di-rutaC.
EMPTY TEMP-TABLE comprobantes.
EMPTY TEMP-TABLE clientes.

DEFINE VAR xFechaFinal AS DATE.
/* 
dFechaIni = DATE(07/01/2022).
xFechaFinal = DATE(12/31/2023).
*/
FOR EACH di-rutaC WHERE di-rutaC.codcia = 1 AND di-rutaC.coddoc = 'H/R' AND 
                        di-rutaC.fchdoc >= dFechaIni AND
                        di-rutaC.flgest = 'C' AND di-rutaC.coddiv = s-coddiv NO-LOCK,
                        EACH di-rutaD OF di-rutaC NO-LOCK,
                        FIRST ccbcdocu WHERE ccbcdocu.codcia = 1 AND 
                        ccbcdocu.codref = di-rutaD.codref AND 
                        ccbcdocu.nroref = di-rutaD.nroref AND
                        ccbcdocu.fmapgo = cCondVta AND
                        LOOKUP(ccbcdocu.coddoc,"FAC,BOL") > 0 AND
                        ccbcdocu.sdoact > 0
                        NO-LOCK BREAK BY di-rutaC.coddoc BY di-rutaC.nrodoc :

    /* verificamos que aun este pendiente de registrar cobranzas */
    FIND FIRST cobranza_hr WHERE cobranza_hr.nruta = di-rutaC.nrodoc NO-LOCK NO-ERROR.
    IF AVAILABLE cobranza_hr AND cobranza_hr.flgest = 'C'  THEN DO:
        /* Ya esta registrado con cobranzas y este cerrado */
        NEXT.
    END.
    
    IF FIRST-OF(di-rutaC.coddoc) OR FIRST-OF(di-rutaC.nrodoc) THEN DO:
        dResponsable = "".
        FIND FIRST pl-pers WHERE pl-pers.nrodocid = di-rutaC.responsable NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN dResponsable = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.

        CREATE tt-di-rutaC.
        BUFFER-COPY di-rutaC TO tt-di-rutaC.
        ASSIGN tt-di-rutaC.observ = dResponsable.

        iTipoCambio = 1.
        FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= di-rutaC.FchSal NO-LOCK NO-ERROR.
        IF AVAIL Gn-Tcmb THEN iTipoCambio = Gn-Tcmb.Venta.

        ASSIGN tt-di-rutaC.ctoRut = iTipoCambio.
    END.

    /* Los Comprobantes */
    FIND FIRST comprobantes WHERE comprobantes.task-no = INTEGER(di-rutaC.nrodoc) AND
                                comprobantes.llave-c = ccbcdocu.coddoc + "-" + ccbcdocu.nrodoc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE comprobantes THEN DO:
        CREATE comprobantes.
        ASSIGN comprobantes.task-no = INTEGER(di-rutaC.nrodoc)
               comprobantes.llave-c = ccbcdocu.coddoc + "-" + ccbcdocu.nrodoc
               comprobantes.campo-c[1] = ccbcdocu.codcli
               comprobantes.campo-c[2] = ccbcdocu.nomcli
               comprobantes.campo-c[3] = IF (ccbcdocu.codmon = 2) THEN "Dolares" ELSE 'Soles'
               comprobantes.campo-f[1] = ccbcdocu.sdoact * (IF (ccbcdocu.codmon = 2) THEN iTipoCambio ELSE 1)
               comprobantes.campo-f[2] = ccbcdocu.sdoact
               comprobantes.campo-c[9] = ccbcdocu.coddoc
               comprobantes.campo-c[10] = ccbcdocu.nrodoc
                .
    END.
    /* Por cada cliente */    
    FIND FIRST clientes WHERE clientes.task-no = INTEGER(di-rutaC.nrodoc) AND
                              clientes.llave-c = ccbcdocu.codcli NO-LOCK NO-ERROR.
    IF NOT AVAILABLE clientes THEN DO:
        CREATE clientes.
        ASSIGN clientes.task-no = INTEGER(di-rutaC.nrodoc)
             clientes.llave-c = ccbcdocu.codcli
             clientes.campo-c[1] = ccbcdocu.nomcli
             clientes.campo-c[3] = IF (ccbcdocu.codmon = 2) THEN "Dolares" ELSE 'Soles'.             

        /* Verificamos si tiene datos grabados */
        FIND FIRST cobranza_hr_cliente WHERE cobranza_hr_cliente.nruta = di-rutaC.nrodoc AND
                                            cobranza_hr_cliente.ccliente = ccbcdocu.codcli NO-LOCK NO-ERROR.
        IF AVAILABLE cobranza_hr_cliente THEN DO:
            ASSIGN clientes.campo-f[2] = cobranza_hr_cliente.iefectivosoles
                    clientes.campo-f[3] = cobranza_hr_cliente.ibilleteraelectrosoles
                    clientes.campo-f[4] = cobranza_hr_cliente.idepobancariosoles
                    clientes.campo-f[5] = cobranza_hr_cliente.iefectivosoles + cobranza_hr_cliente.ibilleteraelectrosoles + cobranza_hr_cliente.idepobancariosoles.
        END.
    END.
    ASSIGN clientes.campo-f[1] = clientes.campo-f[1] + ccbcdocu.sdoact * (IF (ccbcdocu.codmon = 2) THEN iTipoCambio ELSE 1).    

END.

SESSION:SET-WAIT-STATE("").

RUN carga-info IN h_b-cobranza-contraentrega (INPUT TABLE tt-di-rutaC).
RUN carga-info IN h_b-cobranza-contraentrega-cmpte (INPUT TABLE comprobantes).
RUN carga-info IN h_b-cobranza-contraentrega-clien (INPUT TABLE clientes).

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
  DISPLAY TOGGLE-cerrar 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-grabar TOGGLE-cerrar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabamos-info W-Win 
PROCEDURE grabamos-info :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lGrabadoOK AS LOG.    
DEFINE VAR cMsg AS CHAR.

lGrabadoOK = NO.
    
SESSION:SET-WAIT-STATE("GENERAL").

GRABAR_DATOS:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE :

    RUN grabamos-info IN h_b-cobranza-contraentrega-cmpte( OUTPUT cMsg, INPUT toggle-cerrar).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
    END.

    RUN grabamos-info IN h_b-cobranza-contraentrega-clien
    ( OUTPUT cMsg /* CHARACTER */).

    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
    END.

    lGrabadoOK = YES.
END.

SESSION:SET-WAIT-STATE("").

IF lGrabadoOK = NO THEN DO:
    MESSAGE "Ocurrio un ERROR" SKIP
            cMsg SKIP
        VIEW-AS ALERT-BOX INFORMATION.

    RETURN "ADM-ERROR".
END.
ELSE DO:
    MESSAGE "Proceso de GRABADO OK"
    VIEW-AS ALERT-BOX INFORMATION.

    RETURN "OK".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-cobranza W-Win 
PROCEDURE grabar-cobranza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lProcesoOk AS LOG.                    
DEFINE VAR cNroDoc AS CHAR.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN toggle-cerrar.
END.

IF toggle-cerrar = YES THEN DO:
    MESSAGE 'Seguro de grabar y cerrar los cobros en efectivo?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN DO:
        RETURN.
    END.
END.

RUN grabar-cobranza IN h_b-cobranza-contraentrega-clien
    ( OUTPUT lProcesoOk /* LOGICAL */).

IF lProcesoOk = YES THEN DO:

    RUN get-nrodoc IN h_b-cobranza-contraentrega
    ( OUTPUT cNroDoc).

    /* GRABACIONES */
    RUN grabamos-info.

    IF RETURN-VALUE = "OK" THEN DO:
        IF toggle-cerrar = YES THEN DO:

            toggle-cerrar:SCREEN-VALUE = 'no'.

            FIND FIRST tt-di-rutac WHERE tt-di-rutac.nrodoc = cNroDoc NO-LOCK NO-ERROR.
            IF AVAILABLE tt-di-rutac THEN ASSIGN tt-di-rutaC.flgest = 'X'.

            RUN adm-apply-entry IN h_b-cobranza-contraentrega.
            RUN carga-info IN h_b-cobranza-contraentrega (INPUT TABLE tt-di-rutaC).
        END.
    END.
    
END.

RUN adm-apply-entry IN h_b-cobranza-contraentrega.

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
  /*
 DO WITH FRAME {&FRAME-NAME}:
    button-grabar:VISIBLE = NO.
    button-cancelar:VISIBLE = NO.
 END.
*/
  RUN carga-info.



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

