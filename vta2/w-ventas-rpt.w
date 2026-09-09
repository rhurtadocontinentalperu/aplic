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

DEF SHARED VAR s-codcia AS INT.

DEFINE TEMP-TABLE tt-ventas
    FIELDS  coddiv      AS CHAR FORMAT 'x(6)'   COLUMN-LABEL "Division de origen"
    FIELDS  coddes      AS CHAR FORMAT 'x(6)'   COLUMN-LABEL "Division emision"
    FIELDS  codmone     AS CHAR FORMAT 'x(5)'   COLUMN-LABEL "Moneda"
    FIELDS  ruc         AS CHAR FORMAT 'x(12)'  COLUMN-LABEL "R.U.C."
    FIELDS  Cliente     AS CHAR FORMAT 'x(60)'  COLUMN-LABEL "Cliente"
    FIELDS  coddoc      AS CHAR FORMAT 'x(4)'   COLUMN-LABEL "Tipo Documento"
    FIELDS  nrodoc      AS CHAR FORMAT 'x(12)'  COLUMN-LABEL "Nro de Documento"
    FIELDS  fchdoc      AS DATE                 COLUMN-LABEL "Emision"
    FIELDS  fchvto      AS DATE                 COLUMN-LABEL "Vencimiento"
    FIELDS  fmapgo      AS CHAR FORMAT 'x(5)'   COLUMN-LABEL "Cond.Venta"
    FIELDS  impte       AS DEC  FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Importe".

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
&Scoped-Define ENABLED-OBJECTS BUTTON-Division txtDesde txtHasta BUTTON-19 
&Scoped-Define DISPLAYED-OBJECTS x-CodDiv txtDesde txtHasta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-19 
     LABEL "Aceptar" 
     SIZE 15.14 BY .92.

DEFINE BUTTON BUTTON-Division 
     LABEL "..." 
     SIZE 4 BY .77 TOOLTIP "Selecciona Divisiones".

DEFINE VARIABLE x-CodDiv AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 62 BY 1.92 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .81 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodDiv AT ROW 1.19 COL 8.86 NO-LABEL WIDGET-ID 92
     BUTTON-Division AT ROW 1.19 COL 71.72 WIDGET-ID 78
     txtDesde AT ROW 3.69 COL 15 COLON-ALIGNED WIDGET-ID 98
     txtHasta AT ROW 3.69 COL 33.72 COLON-ALIGNED WIDGET-ID 100
     BUTTON-19 AT ROW 5 COL 30.29 WIDGET-ID 86
     "División:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 1.19 COL 1.72 WIDGET-ID 94
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.29 BY 6.85
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Reporte de Ventas"
         HEIGHT             = 6.81
         WIDTH              = 79.86
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 151.43
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 151.43
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
/* SETTINGS FOR EDITOR x-CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de Ventas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Ventas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-19
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-19 W-Win
ON CHOOSE OF BUTTON-19 IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN  x-CodDiv txtDesde txtHasta.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  SESSION:SET-WAIT-STATE('').
  {&OPEN-QUERY-{&BROWSE-NAME}}
  MESSAGE "Proceso Terminado" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Division W-Win
ON CHOOSE OF BUTTON-Division IN FRAME F-Main /* ... */
DO:
    ASSIGN x-CodDiv.
    RUN gn/d-filtro-divisiones (INPUT-OUTPUT x-CodDiv, "SELECCIONE LAS DIVISIONES").
    DISPLAY x-CodDiv WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualizar-Base W-Win 
PROCEDURE Actualizar-Base :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Cargamos Temporal con la base de datos */
DEF VAR k AS INT NO-UNDO.
DEFINE VAR lFecha AS DATE.
DEFINE VAR rpta AS LOG.
DEFINE VAR x-Archivo AS CHAR.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Excel (*.xlsx)' '*.xlsx'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.xlsx'
    RETURN-TO-START-DIR
    SAVE-AS
    TITLE 'Exportar a XLSX'
    UPDATE rpta.
IF rpta = NO OR x-Archivo = '' THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.

DO lFecha = txtDesde TO txtHasta:
    DO k = 1 TO NUM-ENTRIES(x-CodDiv):
        FIND gn-divi WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = ENTRY(k,x-CodDiv)
            NO-LOCK.
        FOR EACH ccbcdocu NO-LOCK USE-INDEX llave16 WHERE 
            ccbcdocu.codcia = s-codcia
            AND ccbcdocu.divori = ENTRY(k,x-CodDiv)
            AND ccbcdocu.fchdoc = lFecha
            AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK,N/D,N/C") > 0 
            AND ccbcdocu.flgest <> 'A':

            /* Facturas x Adelantos o Servicios no va*/
            IF ccbcdocu.tpofac = 'A' OR ccbcdocu.tpofac = 'S' THEN NEXT.
            IF ccbcdocu.coddoc = 'N/C'  THEN DO:
                /* Si la factura referenciada */
                FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = ccbcdocu.codcia AND
                                        b-ccbcdocu.coddoc = ccbcdocu.codref AND
                                        b-ccbcdocu.nrodoc = ccbcdocu.nroref
                                        NO-LOCK NO-ERROR.
                IF AVAILABLE b-ccbcdocu THEN DO:
                    IF b-ccbcdocu.tpofac = 'A' OR b-ccbcdocu.tpofac = 'S' THEN NEXT.
                END.
                ELSE NEXT.
            END.

            CREATE tt-ventas.
                ASSIGN tt-ventas.coddiv = ccbcdocu.divori
                    tt-ventas.coddes    = ccbcdocu.coddiv
                    tt-ventas.codmone   = IF (ccbcdocu.codmon = 1) THEN "S/" ELSE "USD"
                    tt-ventas.ruc       = ccbcdocu.codcli
                    tt-ventas.Cliente   = ccbcdocu.nomcli
                    tt-ventas.coddoc    = ccbcdocu.coddoc
                    tt-ventas.nrodoc    = ccbcdocu.nrodoc
                    tt-ventas.fchdoc    = ccbcdocu.fchdoc
                    tt-ventas.fchvto    = ccbcdocu.fchvto
                    tt-ventas.fmapgo    = ccbcdocu.fmapgo
                    tt-ventas.impte     = ccbcdocu.imptot.

        END.
    END.
END.

RELEASE b-ccbcdocu.

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */


c-xls-file = x-archivo.

run pi-crea-archivo-csv IN hProc (input  buffer tt-ventas:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-ventas:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.



SESSION:SET-WAIT-STATE('').


/*
/* Cargamos Temporal con la base de datos */
DEF VAR k AS INT NO-UNDO.
DEF VAR Desde AS DATE NO-UNDO.
DEF VAR Hasta AS DATE NO-UNDO.

DEFINE VAR lDocumentos AS CHAR NO-UNDO INIT "".
DEF VAR lSecDoc AS INT NO-UNDO.
DEFINE VAR lCodDocto AS CHAR.
DEFINE VAR lFecha AS DATE.

/*RUN src\bin\_dateif ( COMBO-BOX-NroMes, FILL-IN-Periodo, OUTPUT Desde, OUTPUT Hasta).*/

IF ChkFac = YES THEN lDocumentos = "FAC".

IF ChkBol = YES THEN DO:
    IF lDocumentos <> "" THEN lDocumentos = lDocumentos + ",".
    lDocumentos = lDocumentos + "BOL".
END.
IF Chkn_c = YES THEN DO:
    IF lDocumentos <> "" THEN lDocumentos = lDocumentos + ",".
    lDocumentos = lDocumentos + "N/C".
END.
IF Chkn_d = YES THEN DO:
    IF lDocumentos <> "" THEN lDocumentos = lDocumentos + ",".
    lDocumentos = lDocumentos + "N/D".
END.    

EMPTY TEMP-TABLE T-Comprobantes.

DO lFecha = txtDesde TO txtHasta:
    DO k = 1 TO NUM-ENTRIES(x-CodDiv):
        FIND gn-divi WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = ENTRY(k,x-CodDiv)
            NO-LOCK.

        DO lSecDoc = 1 TO NUM-ENTRIES(lDocumentos):
            lCodDocto = ENTRY(lSecDoc,lDocumentos).
            FOR EACH Ccbcdocu NO-LOCK USE-INDEX llave10 WHERE CcbCDocu.CodCia = s-codcia
                AND CcbCDocu.CodDiv = ENTRY(k,x-CodDiv)
                AND CcbCDocu.FchDoc = lFecha
                AND CcbCDocu.CodDoc = lCodDocto
                AND (txtEmpieze = "" OR CcbCDocu.NroDoc BEGINS txtEmpieze )
                AND CcbCDocu.FlgEst <> "A":
        
                IF Ccbcdocu.FchDoc < GN-DIVI.Libre_f01 THEN NEXT.
        
                FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                    "VERIFICANDO: " + ccbcdocu.coddiv + ' '  +
                    ccbcdocu.coddoc + ' ' + ccbcdocu.nrodoc + ' ' +
                    STRING(ccbcdocu.fchdoc).
        
                FIND FELogComprobantes WHERE FELogComprobantes.CodCia = CcbCDocu.CodCia
                    AND FELogComprobantes.CodDiv = CcbCDocu.Coddiv
                    AND FELogComprobantes.CodDoc = CcbCDocu.CodDoc
                    AND FELogComprobantes.NroDoc = CcbCDocu.NroDoc
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE FELogComprobantes THEN DO:
                    CREATE T-Comprobantes.
                    ASSIGN
                        T-Comprobantes.CodCia = CcbCDocu.CodCia
                        T-Comprobantes.CodDiv = CcbCDocu.CodDiv
                        T-Comprobantes.CodDoc = CcbCDocu.CodDoc
                        T-Comprobantes.NroDoc = CcbCDocu.NroDoc
                        T-Comprobantes.LogEstado = "Comprobante NO registrado en el log de control"
                        t-comprobantes.sactualizar = 'X'
                        t-comprobantes.fchdoc = CcbCDocu.FchDoc.
                END.
                ELSE DO:
                    IF rdFiltro = 1 OR (rdFiltro = 2 AND FELogComprobantes.flagPPLL = 2 ) THEN DO:
                        /* 1:Todos  2:Sin Confirmar */
                        CREATE T-Comprobantes.
                        BUFFER-COPY FELogComprobantes TO T-Comprobantes.
                        ASSIGN t-comprobantes.sactualizar = 'OK'
                                t-comprobantes.fchdoc = CcbCDocu.FchDoc.
                    END.
                END.
            END.
        END.
    END.
END.
*/
  
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
  DISPLAY x-CodDiv txtDesde txtHasta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-Division txtDesde txtHasta BUTTON-19 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE estado-sunat W-Win 
PROCEDURE estado-sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


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

  ASSIGN txtDesde = TODAY - 2
        txtHasta = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-enviar-a-ppl W-Win 
PROCEDURE ue-enviar-a-ppl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/      


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

