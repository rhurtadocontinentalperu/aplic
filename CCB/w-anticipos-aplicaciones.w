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
&Scoped-Define ENABLED-OBJECTS txtDesde txtHasta txtCliente btnProcesar 
&Scoped-Define DISPLAYED-OBJECTS txtDesde txtHasta txtCliente txtDesCliente 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnProcesar 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtCliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesCliente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtDesde AT ROW 3.69 COL 16 COLON-ALIGNED WIDGET-ID 2
     txtHasta AT ROW 3.69 COL 41 COLON-ALIGNED WIDGET-ID 4
     txtCliente AT ROW 5.42 COL 16 COLON-ALIGNED WIDGET-ID 6
     txtDesCliente AT ROW 5.46 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     btnProcesar AT ROW 7.92 COL 43 WIDGET-ID 10
     "  Movimientos de anticipos y documentos aplicados" VIEW-AS TEXT
          SIZE 50 BY .96 AT ROW 1.38 COL 14 WIDGET-ID 12
          BGCOLOR 1 FGCOLOR 15 FONT 19
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.29 BY 9.04 WIDGET-ID 100.


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
         TITLE              = "Anticipos recibidos y aplicaciones"
         HEIGHT             = 9.04
         WIDTH              = 77.29
         MAX-HEIGHT         = 27.38
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.38
         VIRTUAL-WIDTH      = 146.29
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

{src/adm-vm/method/vmviewer.i}
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Anticipos recibidos y aplicaciones */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Anticipos recibidos y aplicaciones */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnProcesar W-Win
ON CHOOSE OF btnProcesar IN FRAME F-Main /* Procesar */
DO:
  ASSIGN txtDesde txtHasta txtCliente txtDesCliente.

  IF txtDesde > txtHasta THEN DO:
    MESSAGE "Fechas incorrectas..." VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.

  RUN ue-procesar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCliente W-Win
ON LEAVE OF txtCliente IN FRAME F-Main /* Cliente */
DO:

  txtDesCliente:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

  IF txtCliente:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO:
      FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND 
          gn-clie.codcli = txtCliente:SCREEN-VALUE IN FRAME {&FRAME-NAME}
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-clie THEN DO:
        txtDesCliente:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-clie.nomcli.
      END.
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
  DISPLAY txtDesde txtHasta txtCliente txtDesCliente 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txtDesde txtHasta txtCliente btnProcesar 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  txtdesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 15) .
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY) .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-procesar W-Win 
PROCEDURE ue-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lSuma AS DEC.
DEFINE VAR liAC_DocxAnticipo AS INTEGER INIT 0.  /* Acumulador de notas de crédito o débito por el anticipo */
DEFINE VAR lSumaInicial AS DEC.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-signo                 AS DECI.
DEFINE VAR lImpOrg AS DEC.
DEFINE VAR lImpTot AS DEC.

SESSION:SET-WAIT-STATE('GENERAL').

/* Crea el objeto de la aplicación de Excel, y activa la primera hoja */
CREATE "Excel.Application" chExcelApplication.
chExcelApplication:Visible = FALSE.
chWorkbook = chExcelApplication:Workbooks:Add().
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* Escribe la cabecera del reporte */
chWorkSheet:Range("A1"):Value = "Tipo Dcto".
chWorkSheet:Range("B1"):Value = "Nro.Dcto Anticipo".
chWorkSheet:Range("C1"):Value = "Fec.Anticipo/Fec.Pago".
chWorkSheet:Range("D1"):Value = "Cod.Clie".
chWorkSheet:Range("E1"):Value = "NombreClie".
chWorkSheet:Range("F1"):Value = "Dcto Emitido/Aplicado".   
chWorkSheet:Range("G1"):Value = "NroDcto Emitido/Aplicado".
chWorkSheet:Range("H1"):Value = "Moneda".
chWorkSheet:Range("I1"):Value = "Impte Orig.".
chWorkSheet:Range("J1"):Value = "Importe Soles".
chWorkSheet:Range("K1"):Value = "x Aplicar".
chWorkSheet:Range("L1"):Value = "Division".

DEF BUFFER B-ccbcdocu FOR ccbcdocu.
DEF BUFFER T-ccbcdocu FOR ccbcdocu.

FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                        ccbcdocu.coddoc = 'A/C' AND
                        (ccbcdocu.fchdoc >= txtDesde AND ccbcdocu.fchdoc <= txtHasta) AND
                        (txtDesCliente = "" OR ccbcdocu.codcli = txtCliente) AND
                        ccbcdocu.flgest <> 'A' NO-LOCK BY ccbcdocu.codcli:
     
     iColumn = iColumn + 1.
     cColumn = STRING(iColumn).

     /* Saco el Importe de la Factura */
     FIND FIRST T-ccbcdocu WHERE T-ccbcdocu.codcia = s-codcia AND 
         T-ccbcdocu.coddoc = ccbcdocu.codref AND T-ccbcdocu.nrodoc = ccbcdocu.nroref NO-LOCK NO-ERROR.

     IF AVAILABLE t-ccbcdocu THEN DO:
         lImpTot = t-ccbcdocu.imptot * IF (t-ccbcdocu.codmon = 1) THEN 1 ELSE t-ccbcdocu.tpocmb.
         lImpOrg = t-ccbcdocu.imptot.
     END.
     ELSE DO:
        lImpTot = ccbcdocu.imptot * IF (ccbcdocu.codmon = 1) THEN 1 ELSE ccbcdocu.tpocmb.
        lImpOrg = ccbcdocu.imptot.
     END.

     chWorkSheet:Range("A" + cColumn):Value = ccbcdocu.coddoc.
     chWorkSheet:Range("B" + cColumn):Value = "'" + ccbcdocu.nrodoc.
     chWorkSheet:Range("C" + cColumn):Value = ccbcdocu.fchdoc.
     chWorkSheet:Range("D" + cColumn):Value = "'" + ccbcdocu.codcli.
     chWorkSheet:Range("E" + cColumn):Value = ccbcdocu.nomcli.
     chWorkSheet:Range("F" + cColumn):Value = ccbcdocu.codref.
     chWorkSheet:Range("G" + cColumn):Value = "'" + ccbcdocu.nroref.
     chWorkSheet:Range("H" + cColumn):Value = ccbcdocu.codmon.
     chWorkSheet:Range("I" + cColumn):Value = lImpOrg.
     chWorkSheet:Range("J" + cColumn):Value = lImpTot.
     chWorkSheet:Range("L" + cColumn):Value = "'" + ccbcdocu.coddiv.

     /* La N/C y N/D del anticipo */
     liAC_DocxAnticipo = 0.
     lSumaInicial = lImpTot. /* ccbcdocu.imptot * IF (ccbcdocu.codmon = 1) THEN 1 ELSE ccbcdocu.tpocmb.*/
     lSuma = lSumaInicial.                                                                           

     FOR EACH T-ccbcdocu WHERE T-ccbcdocu.codcia = ccbcdocu.codcia AND
                               T-ccbcdocu.codref = ccbcdocu.codref AND
                               T-ccbcdocu.nroref = ccbcdocu.nroref AND
                               (T-ccbcdocu.coddoc = 'N/C' OR T-ccbcdocu.coddoc = 'N/D') AND
                               T-ccbcdocu.flgest <> 'A'
                               USE-INDEX llave07 NO-LOCK :
        
          iColumn = iColumn + 1.
          cColumn = STRING(iColumn).

          x-signo = IF(T-ccbcdocu.coddoc = 'N/C') THEN -1 ELSE 1.

          chWorkSheet:Range("C" + cColumn):Value = T-ccbcdocu.fchdoc.

          chWorkSheet:Range("F" + cColumn):Value = T-ccbcdocu.coddoc.
          chWorkSheet:Range("G" + cColumn):Value = "'" + T-ccbcdocu.nrodoc.
          chWorkSheet:Range("H" + cColumn):Value = T-ccbcdocu.codmon.
          chWorkSheet:Range("I" + cColumn):Value = T-ccbcdocu.imptot.
          chWorkSheet:Range("J" + cColumn):Value = ((T-ccbcdocu.imptot * IF (T-ccbcdocu.codmon = 1) THEN 1 ELSE T-ccbcdocu.tpocmb) * X-signo).
          chWorkSheet:Range("L" + cColumn):Value = "'" + T-ccbcdocu.coddiv.
          
          lSuma = lSuma + ((T-ccbcdocu.imptot * IF (T-ccbcdocu.codmon = 1) THEN 1 ELSE T-ccbcdocu.tpocmb) * X-signo).
          lSumaInicial = lSumaInicial + ((T-ccbcdocu.imptot * IF (T-ccbcdocu.codmon = 1) THEN 1 ELSE T-ccbcdocu.tpocmb) * X-signo).

          liAC_DocxAnticipo = (liAC_DocxAnticipo + 1).
     END.

     IF (liAC_DocxAnticipo > 0) THEN DO:
         iColumn = iColumn + 1.
         cColumn = STRING(iColumn).

         chWorkSheet:Range("H" + cColumn):Value = "TOTAL Anticipos".
         chWorkSheet:Range("J" + cColumn):Value = lSuma.
         chWorkSheet:Range("K" + cColumn):Value = lSumaInicial.
     END.
     ELSE iColumn = iColumn + 1.

     lSuma = 0.

    /* Documentos que involucran el anticipos */
    FOR EACH ccbdcaja WHERE ccbdcaja.codcia = ccbcdocu.codcia AND
                            ccbdcaja.coddoc = ccbcdocu.coddoc AND
                            ccbdcaja.nrodoc = ccbcdocu.nrodoc NO-LOCK :
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).

        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbdcaja.fchdoc.

        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbdcaja.codref.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + ccbdcaja.nroref.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbdcaja.codmon.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbdcaja.imptot * -1.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = (ccbdcaja.imptot * IF (ccbdcaja.codmon = 1) THEN 1 ELSE ccbdcaja.tpocmb) * -1.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + ccbdcaja.coddiv.

        lSuma = lSuma + (ccbdcaja.imptot * IF (ccbdcaja.codmon = 1) THEN 1 ELSE ccbdcaja.tpocmb).

        /* ND/NC de los depaschos */
        FOR EACH b-ccbcdocu WHERE b-ccbcdocu.codcia = ccbdcaja.codcia AND
                        b-ccbcdocu.codref = ccbdcaja.codref AND
                        b-ccbcdocu.nroref = ccbdcaja.nroref AND
                        ((b-ccbcdocu.coddoc = 'N/C' AND b-ccbcdocu.tpofac <> 'REBATE') OR (b-ccbcdocu.coddoc = 'N/D')) AND                        
                        b-ccbcdocu.flgest <> 'A'
                        USE-INDEX llave07 NO-LOCK :
            
            x-signo = IF(b-ccbcdocu.coddoc = 'N/C') THEN -1 ELSE 1.
            iColumn = iColumn + 1.
            cColumn = STRING(iColumn).

            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = b-ccbcdocu.fchdoc.

            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = b-ccbcdocu.coddoc.
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + b-ccbcdocu.nrodoc.
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = b-ccbcdocu.codmon.
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = b-ccbcdocu.imptot * -1.
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = ((b-ccbcdocu.imptot * IF (b-ccbcdocu.codmon = 1) THEN 1 ELSE b-ccbcdocu.tpocmb) * X-signo).
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + b-ccbcdocu.coddiv.
            
            /*lSuma = lSuma + ((b-ccbcdocu.imptot * IF (b-ccbcdocu.codmon = 1) THEN 1 ELSE b-ccbcdocu.tpocmb) * X-signo).*/
            lSuma = lSuma + ((b-ccbcdocu.imptot * IF (b-ccbcdocu.codmon = 1) THEN 1 ELSE b-ccbcdocu.tpocmb)).
        END.

    END.

    /* Total del anticipo */
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    chWorkSheet:Range("H" + cColumn):Value = "TOTAL Despachos".
    chWorkSheet:Range("J" + cColumn):Value = lSuma * -1.
    chWorkSheet:Range("K" + cColumn):Value = lSumaInicial - lSuma.

    iColumn = iColumn + 1.
END.


SESSION:SET-WAIT-STATE('').
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-procesar_old W-Win 
PROCEDURE ue-procesar_old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lSuma AS DEC.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-signo                 AS DECI.

SESSION:SET-WAIT-STATE('GENERAL').

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = FALSE.

/* Para crear a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

iColumn = 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Tipo Dcto".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Nro.Dcto Anticipo".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Fec.Anticipo/Fec.Pago".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Cod.Clie".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "NombreClie".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Dcto Emitido/Aplicado".   
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "NroDcto Emitido/Aplicado".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Moneda".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Impte Orig.".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Importe Soles".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "x Aplicar".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "Division".

DEF BUFFER B-ccbcdocu FOR ccbcdocu.

FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                    ccbcdocu.coddoc = 'A/C' AND
                    (ccbcdocu.fchdoc >= txtDesde AND ccbcdocu.fchdoc <= txtHasta) AND
                    (txtDesCliente = "" OR ccbcdocu.codcli = txtCliente) AND
                    ccbcdocu.flgest <> 'A' NO-LOCK BY ccbcdocu.codcli:
     iColumn = iColumn + 1.
     cColumn = STRING(iColumn).

     cRange = "A" + cColumn.
     chWorkSheet:Range(cRange):Value = ccbcdocu.coddoc.
     cRange = "B" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + ccbcdocu.nrodoc.
     cRange = "C" + cColumn.
     chWorkSheet:Range(cRange):Value = ccbcdocu.fchdoc.
     cRange = "D" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + ccbcdocu.codcli.
     cRange = "E" + cColumn.
     chWorkSheet:Range(cRange):Value = ccbcdocu.nomcli.
     cRange = "F" + cColumn.
     chWorkSheet:Range(cRange):Value = ccbcdocu.codref.
     cRange = "G" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + ccbcdocu.nroref.
     cRange = "H" + cColumn.
     chWorkSheet:Range(cRange):Value = ccbcdocu.codmon.
     cRange = "I" + cColumn.
     chWorkSheet:Range(cRange):Value = ccbcdocu.imptot.
     cRange = "J" + cColumn.
     chWorkSheet:Range(cRange):Value = ccbcdocu.imptot * IF (ccbcdocu.codmon = 1) THEN 1 ELSE ccbcdocu.tpocmb.
     cRange = "L" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + ccbcdocu.coddiv.
    
    /* Documentos que involucran el anticipos */
    lSuma = 0.
    FOR EACH ccbdcaja WHERE ccbdcaja.codcia = ccbcdocu.codcia AND
                    ccbdcaja.coddoc = ccbcdocu.coddoc AND
                    ccbdcaja.nrodoc = ccbcdocu.nrodoc NO-LOCK :
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).

        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbdcaja.fchdoc.

        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbdcaja.codref.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + ccbdcaja.nroref.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbdcaja.codmon.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbdcaja.imptot.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbdcaja.imptot * IF (ccbdcaja.codmon = 1) THEN 1 ELSE ccbdcaja.tpocmb.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + ccbdcaja.coddiv.
        lSuma = lSuma + (ccbdcaja.imptot * IF (ccbdcaja.codmon = 1) THEN 1 ELSE ccbdcaja.tpocmb).

        /* La N/C y N/D que puedan estar afectos */
        FOR EACH b-ccbcdocu WHERE b-ccbcdocu.codcia = ccbdcaja.codcia AND
                        b-ccbcdocu.codref = ccbdcaja.codref AND
                        b-ccbcdocu.nroref = ccbdcaja.nroref AND
                        (b-ccbcdocu.coddoc = 'N/C' OR b-ccbcdocu.coddoc = 'N/D') AND
                        b-ccbcdocu.flgest <> 'A'
                        USE-INDEX llave07 NO-LOCK :
            x-signo = IF(b-ccbcdocu.coddoc = 'N/C') THEN -1 ELSE 1.
            iColumn = iColumn + 1.
            cColumn = STRING(iColumn).

            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = b-ccbcdocu.fchdoc.

            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = b-ccbcdocu.coddoc.
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + b-ccbcdocu.nrodoc.
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = b-ccbcdocu.codmon.
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = b-ccbcdocu.imptot.
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = ((b-ccbcdocu.imptot * 
                    IF (b-ccbcdocu.codmon = 1) THEN 1 ELSE b-ccbcdocu.tpocmb) * X-signo).
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + b-ccbcdocu.coddiv.
            lSuma = lSuma + 
                ((b-ccbcdocu.imptot * IF (b-ccbcdocu.codmon = 1) THEN 1 ELSE b-ccbcdocu.tpocmb) * X-signo).

        END.

    END.

    /* Total del anticipo */
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "SUB-TOTAL".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = lSuma.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = (ccbcdocu.imptot * IF (ccbcdocu.codmon = 1) THEN 1 ELSE ccbcdocu.tpocmb) - lSuma.

END.


SESSION:SET-WAIT-STATE('').
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

