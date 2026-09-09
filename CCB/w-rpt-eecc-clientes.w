&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE VAR x-docemitidos AS CHAR.

DEFINE TEMP-TABLE ttReporte
    FIELD   tCodCli     AS CHAR     FORMAT 'x(11)'  COLUMN-LABEL "Cod.Clie"
    FIELD   tNomCli     AS CHAR     FORMAT 'x(80)'  COLUMN-LABEL "Nombre Cliente"
    FIELD   tCoddoc     AS CHAR     FORMAT 'x(3)'   COLUMN-LABEL "CodDoc"
    FIELD   tDesDoc     AS CHAR     FORMAT 'x(50)'  COLUMN-LABEL "Documento"
    FIELD   tNroDoc     AS CHAR     FORMAT 'x(20)'  COLUMN-LABEL "Nro Documento"
    FIELD   tFechEmi    AS DATE     COLUMN-LABEL "Fecha de Emision"
    FIELD   tFechVcto   AS DATE     COLUMN-LABEL "Fecha vencimiento"
    FIELD   tCodDocRef  AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Tipo Docto Ref"
    FIELD   tNroDocRef  AS CHAR     FORMAT 'x(20)'  COLUMN-LABEL "Nro Doc Ref"
    FIELD   tCondVta    AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Condicion de venta"
    FIELD   tCodDiv     AS CHAR     FORMAT 'x(10)'  COLUMN-LABEL "Division"
    FIELD   tGlosa      AS CHAR     FORMAT 'x(80)'  COLUMN-LABEL "Descripcion/Glosa"
    FIELD   tCodMone    AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Moneda"
    FIELD   tTipoCmb    AS DEC      COLUMN-LABEL "Tipo de Cambio"    INIT 0    
    FIELD   tImpTot     AS DEC      COLUMN-LABEL "Importe Total"    INIT 0
    FIELD   tImpSdo     AS DEC      COLUMN-LABEL "Saldo"    INIT 0
    FIELD   tFechAmor   AS DATE     COLUMN-LABEL "Fecha de Amortizacion"
    FIELD   tCdocamor   AS CHAR     COLUMN-LABEL "Documento de Amortizacion"
    FIELD   tImpAmor    AS DEC      COLUMN-LABEL "Importe de amortizacion"
    FIELD   tNroCanje   AS CHAR     FORMAT 'x(25)'  COLUMN-LABEL "Nro. de Canje"
    FIELD   tSituacion  AS CHAR     FORMAT 'x(25)'  COLUMN-LABEL "Situacion"
    FIELD   tUbicacion  AS CHAR     FORMAT 'x(25)'  COLUMN-LABEL "Ubicacion"
    FIELD   tBanco      AS CHAR     FORMAT 'x(25)'  COLUMN-LABEL "Banco"
    FIELD   tNroUnico   AS CHAR     FORMAT 'x(25)'  COLUMN-LABEL "Nro. unico"
    INDEX idx01 tCodCli tCodDoc tNroDoc
    .

DEFINE TEMP-TABLE ttClientes
    FIELD   tCodClie    AS CHAR     FORMAT 'x(15)'
    .

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
&Scoped-Define ENABLED-OBJECTS rdsQueGenerar txtCodClie BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS rdsQueGenerar txtCodClie txtDesCliente ~
txtDesde txtHasta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSituacion W-Win 
FUNCTION fSituacion RETURNS CHARACTER
  ( INPUT pFlgSit AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fUbicacion W-Win 
FUNCTION fUbicacion RETURNS CHARACTER
  ( INPUT pFlgUbi AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtCodClie AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesCliente AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE rdsQueGenerar AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Deuda pendiente", 1,
"Movimientos", 2
     SIZE 54 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     rdsQueGenerar AT ROW 2.35 COL 10 NO-LABEL WIDGET-ID 12
     txtCodClie AT ROW 4.08 COL 10 COLON-ALIGNED WIDGET-ID 2
     txtDesCliente AT ROW 4.08 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     txtDesde AT ROW 5.42 COL 10 COLON-ALIGNED WIDGET-ID 6
     txtHasta AT ROW 5.42 COL 34 COLON-ALIGNED WIDGET-ID 8
     BUTTON-1 AT ROW 7.35 COL 56 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73.86 BY 8.15 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Estado de cuenta CLIENTES"
         HEIGHT             = 8.15
         WIDTH              = 73.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
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
/* SETTINGS FOR FILL-IN txtDesCliente IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDesde IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtHasta IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Estado de cuenta CLIENTES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Estado de cuenta CLIENTES */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Procesar */
DO:
  ASSIGN txtDesde txtHasta txtCodClie.

  RUN doc-x-cancelar.

  RUN gen-excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rdsQueGenerar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rdsQueGenerar W-Win
ON VALUE-CHANGED OF rdsQueGenerar IN FRAME F-Main
DO:
  ASSIGN rdsQueGenerar.

  ENABLE txtDesde WITH FRAME {&FRAME-NAME}.
  ENABLE txtHasta WITH FRAME {&FRAME-NAME}.

  IF rdsQueGenerar = 1 THEN DO:
      DISABLE txtDesde WITH FRAME {&FRAME-NAME}.
      DISABLE txtHasta WITH FRAME {&FRAME-NAME}.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doc-x-cancelar W-Win 
PROCEDURE doc-x-cancelar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-sec AS INT.
DEFINE VAR x-fecha AS DATE.
DEFINE VAR x-coddoc AS CHAR.

SESSION:SET-WAIT-STATE('GENERAL').

CREATE ttClientes.
    ASSIGN ttClientes.tcodcli = '10035793521'.

txtDesde = 01/01/2010.
txtHasta = TODAY.

DEFINE VAR x-imptetot AS DEC.
DEFINE VAR x-impteabonos AS DEC.

/* Documentos CARGOS */
REPEAT x-fecha = txtDesde TO txtHasta:
    FOR EACH ttClientes NO-LOCK:    
        FOR EACH facdocum WHERE facdocum.codcia = s-codcia AND 
                                facdocum.tpodoc = YES NO-LOCK:
        
            x-coddoc = facdocum.coddoc.
            FOR EACH ccbcdocu USE-INDEX llave13 WHERE ccbcdocu.codcia = s-codcia AND
                                            ccbcdocu.fchdoc = x-fecha AND 
                                            ccbcdocu.coddoc = x-coddoc AND 
                                            ccbcdocu.codcli = tCodClie AND
                                            LOOKUP(ccbcdocu.flgest, 'A,X') = 0 
                                            NO-LOCK:

                x-impteabonos = 0.
                /* Actualizamos los saldos a una fecha */
                FOR EACH ccbdcaja NO-LOCK WHERE ccbdcaja.codcia = s-codcia
                    AND ccbdcaja.codref = ccbcdocu.coddoc
                    AND ccbdcaja.nroref = ccbcdocu.nrodoc
                    AND ccbdcaja.fchdoc <= txtHasta
                    BY ccbdcaja.fchdoc:

                    x-impteabonos = ccbdcaja.imptot.

                    /* CASO MUY ESPECIAL */
                    IF ccbdcaja.coddoc = "A/C" AND ccbdcaja.nrodoc BEGINS "*" THEN DO:
                        x-impteabonos = x-impteabonos - ccbdcaja.imptot.
                    END.
                END.

                IF (x-impteabonos - ccbcdocu.imptot) > 0 THEN DO:
                    CREATE ttReporte.
                        ASSIGN  ttReporte.tCodCli     = ccbcdocu.codcli
                                ttReporte.tNomCli     = ccbcdocu.nomcli
                                ttReporte.tCoddoc     = ccbcdocu.coddoc
                                ttReporte.tDesDoc     = facdocum.nomdoc
                                ttReporte.tNroDoc     = ccbcdocu.nrodoc
                                ttReporte.tFechEmi    = ccbcdocu.fchdoc
                                ttReporte.tFechVcto   = ccbcdocu.fchvto
                                ttReporte.tCodDocRef  = ccbcdocu.codref
                                ttReporte.tNroDocRef  = ccbcdocu.nroref
                                ttReporte.tCondVta    = ccbcdocu.fmapgo
                                ttReporte.tCodDiv     = ccbcdocu.coddiv
                                ttReporte.tGlosa      = ccbcdocu.glosa
                                ttReporte.tCodMone    = IF(ccbcdocu.codmon = 2) THEN "$" ELSE "S/."    
                                ttReporte.tTipoCmb    = ccbcdocu.tpocmb
                                ttReporte.tImpTot     = ccbcdocu.imptot
                                ttReporte.tImpSdo     = ccbcdocu.sdoact.
                        IF ccbcdocu.coddoc = 'LET' THEN DO:
                            ASSIGN  ttReporte.tSituacion    = fSituacion(Ccbcdocu.flgsit).
                            ASSIGN  ttReporte.tUbicacion    = fUbicacion(Ccbcdocu.flgubi).
                            ASSIGN  ttReporte.tBanco        = ccbcdocu.codcta
                                    ttReporte.tNroUnico     = ccbcdocu.nrosal.
                        END.

                    IF ccbcdocu.coddoc = 'FAC' AND ccbcdocu.tipo = 'CREDITO' THEN DO:
                        ASSIGN ttReporte.tCodDocRef  = ccbcdocu.codped
                            ttReporte.tNroDocRef  = ccbcdocu.nroped.
                    END.
                END.
    
            END.
        END.
    END.
END.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/*
    FIELD   tCodCli     AS CHAR     FORMAT 'x(11)'  COLUMN-LABEL "Cod.Clie"
    FIELD   tNomCli     AS CHAR     FORMAT 'x(80)'  COLUMN-LABEL "Nombre Cliente"
    FIELD   tCoddoc     AS CHAR     FORMAT 'x(3)'   COLUMN-LABEL "CodDoc"
    FIELD   tDesDoc     AS CHAR     FORMAT 'x(50)'  COLUMN-LABEL "Documento"
    FIELD   tNroDoc     AS CHAR     FORMAT 'x(20)'  COLUMN-LABEL "Nro Documento"
    FIELD   tFechEmi    AS DATE     COLUMN-LABEL "Fecha de Emision"
    FIELD   tFechVcto   AS DATE     COLUMN-LABEL "Fecha vencimiento"
    FIELD   tCodDocRef  AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Tipo Docto Ref"
    FIELD   tNroDocRef  AS CHAR     FORMAT 'x(20)'  COLUMN-LABEL "Nro Doc Ref"
    FIELD   tCondVta    AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Condicion de venta"
    FIELD   tCodDiv     AS CHAR     FORMAT 'x(10)'  COLUMN-LABEL "Division"
    FIELD   tGlosa      AS CHAR     FORMAT 'x(80)'  COLUMN-LABEL "Descripcion/Glosa"
    FIELD   tCodMone    AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "Moneda"
    FIELD   tTipoCmb    AS DEC      COLUMN-LABEL "Tipo de Cambio"    INIT 0    
    FIELD   tImpTot     AS DEC      COLUMN-LABEL "Importe Total"    INIT 0
    FIELD   tImpSdo     AS DEC      COLUMN-LABEL "Saldo"    INIT 0
    FIELD   tFechAmor   AS DATE     COLUMN-LABEL "Fecha de Amortizacion"
    FIELD   tCdocamor   AS CHAR     COLUMN-LABEL "Documento de Amortizacion"
    FIELD   tImpAmor    AS DEC      COLUMN-LABEL "Importe de amortizacion"
    FIELD   tNroCanje   AS CHAR     FORMAT 'x(25)'  COLUMN-LABEL "Nro. de Canje"
    
    FIELD   tSituacion  AS CHAR     FORMAT 'x(25)'  COLUMN-LABEL "Situacion"
    FIELD   tUbicacion  AS CHAR     FORMAT 'x(25)'  COLUMN-LABEL "Ubicacion"
    FIELD   tBanco      AS CHAR     FORMAT 'x(25)'  COLUMN-LABEL "Banco"
    FIELD   tNroUnico   AS CHAR     FORMAT 'x(25)'  COLUMN-LABEL "Nro. unico"

*/

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
  DISPLAY rdsQueGenerar txtCodClie txtDesCliente txtDesde txtHasta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE rdsQueGenerar txtCodClie BUTTON-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen-excel W-Win 
PROCEDURE gen-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = 'c:\ciman\OtrapruebaXWXW.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer ttReporte:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer ttReporte:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.


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
  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 5,"99/99/9999").
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSituacion W-Win 
FUNCTION fSituacion RETURNS CHARACTER
  ( INPUT pFlgSit AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR lRetVal AS CHAR INIT "".

    CASE pFlgsit:
      WHEN 'T' THEN lRetVal =  'Transito'.
      WHEN 'C' THEN lRetVal =  'Cobranza Libre'.
      WHEN 'G' THEN lRetVal =  'Cobranza Garantia'.
      WHEN 'D' THEN lRetVal =  'Descuento'.
      WHEN 'P' THEN lRetVal =  'Protestada'.
    END CASE.

    RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fUbicacion W-Win 
FUNCTION fUbicacion RETURNS CHARACTER
  ( INPUT pFlgUbi AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR lRetVal AS CHAR INIT ''.

    CASE pFlgubi:
      WHEN 'C' THEN lRetVal = 'Cartera'.
      WHEN 'B' THEN lRetVal = 'Banco'.
    END CASE.

    RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

