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
DEF SHARED VAR pv-codcia AS INT.

DEF TEMP-TABLE Detalle
    FIELD codcia AS INT
    FIELD codmat LIKE Almdmov.codmat
    FIELD codpro LIKE gn-prov.codpro
    FIELD canvta AS DEC
    FIELD impvta AS DEC
    FIELD cancmp AS DEC
    FIELD impcmp AS DEC
    FIELD valini AS DEC
    FIELD valfin AS DEC
    FIELD stkini AS DEC
    FIELD stkfin AS DEC
    FIELD rotacion AS DEC
    FIELD nompro AS CHAR
    INDEX LLave01 AS PRIMARY UNIQUE codcia codmat.

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
&Scoped-Define ENABLED-OBJECTS x-Fecha-1 x-Fecha-2 x-CodPro x-Familia ~
x-CodMon x-Resumen BUTTON-2 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS x-Fecha-1 x-Fecha-2 x-CodPro ~
FILL-IN-nompro x-Familia x-CodMon x-Resumen x-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 7 BY 1.62.

DEFINE VARIABLE x-Familia AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Familia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-nompro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodPro AS CHARACTER FORMAT "X(8)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-Fecha-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-Fecha-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 19 BY .81 NO-UNDO.

DEFINE VARIABLE x-Resumen AS LOGICAL INITIAL no 
     LABEL "Resumido por Proveedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-Fecha-1 AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 4
     x-Fecha-2 AT ROW 2.35 COL 19 COLON-ALIGNED WIDGET-ID 6
     x-CodPro AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-nompro AT ROW 3.42 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     x-Familia AT ROW 4.5 COL 19 COLON-ALIGNED WIDGET-ID 10
     x-CodMon AT ROW 5.85 COL 21 NO-LABEL WIDGET-ID 12
     x-Resumen AT ROW 6.92 COL 21 WIDGET-ID 22
     BUTTON-2 AT ROW 8.54 COL 4 WIDGET-ID 20
     BtnDone AT ROW 8.54 COL 12 WIDGET-ID 18
     x-Mensaje AT ROW 9.08 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 5.85 COL 15 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 9.73
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
         TITLE              = "REPORTE DE COMPRAS VS VENTAS"
         HEIGHT             = 9.73
         WIDTH              = 80
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
/* SETTINGS FOR FILL-IN FILL-IN-nompro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE COMPRAS VS VENTAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE COMPRAS VS VENTAS */
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


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    ASSIGN
        x-CodMon x-CodPro x-Familia x-Fecha-1 x-Fecha-2 x-Resumen.
  RUN Carga-Temporal.
  FIND FIRST Detalle NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Detalle THEN DO:
      MESSAGE ' NO hay información que imprimir'
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  SESSION:SET-WAIT-STATE('GENERAL').
  IF x-Resumen 
  THEN RUN Excel-2.
  ELSE RUN Excel-1.
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPro W-Win
ON LEAVE OF x-CodPro IN FRAME F-Main /* Proveedor */
DO:
  FIND gn-prov WHERE codcia = pv-codcia
      AND codpro = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  FILL-IN-nompro:SCREEN-VALUE = ''.
  IF AVAILABLE gn-prov THEN FILL-IN-nompro:SCREEN-VALUE = gn-prov.nompro.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-codfam LIKE almmmatg.codfam NO-UNDO.
DEF VAR x-Signo AS INT NO-UNDO.
DEF VAR x-TpoCmbCmp AS DEC NO-UNDO.
DEF VAR x-TpoCmbVta AS DEC NO-UNDO.

FOR EACH Detalle:
    DELETE Detalle.
END.

IF x-Familia = 'Todas' 
THEN x-codfam = ''.
ELSE x-codfam = SUBSTRING(x-Familia,1,INDEX (x-Familia, ' - ') - 1).

/* las compras */
FOR EACH almacen NO-LOCK WHERE almacen.codcia = s-codcia,
    EACH almdmov USE-INDEX almd04 NO-LOCK WHERE almdmov.codcia = s-codcia
    AND almdmov.codalm = almacen.codalm
    AND almdmov.fchdoc >= x-fecha-1
    AND almdmov.fchdoc <= x-fecha-2
    AND almdmov.tipmov = "I"
    AND (almdmov.codmov = 02 OR almdmov.codmov = 06),
    FIRST almmmatg OF almdmov NO-LOCK WHERE (x-codfam = '' OR almmmatg.codfam = x-codfam)
    AND (x-codpro = '' OR almmmatg.codpr1 = x-codpro):
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
        '*** COMPRAS: ' + Almmmatg.codmat + ' ' + STRING(almdmov.fchdoc).
    FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= almdmov.FchDoc
        USE-INDEX Cmb01 NO-LOCK NO-ERROR.
    IF NOT AVAIL Gn-Tcmb THEN 
        FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= almdmov.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
    IF AVAIL Gn-Tcmb THEN 
        ASSIGN
            x-TpoCmbCmp = Gn-Tcmb.Compra
            x-TpoCmbVta = Gn-Tcmb.Venta.
    FIND detalle OF almdmov EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE detalle THEN DO:
        CREATE detalle.
        ASSIGN
            detalle.codcia = almdmov.codcia
            detalle.codmat = almdmov.codmat
            detalle.codpro = Almmmatg.codpr1.
    END.
    ASSIGN
        detalle.cancmp = detalle.cancmp + almdmov.candes * almdmov.factor.
    IF almdmov.codmon = x-codmon 
    THEN detalle.impcmp = detalle.impcmp + almdmov.impcto.
    ELSE IF almdmov.codmon = 1 
        THEN detalle.impcmp = detalle.impcmp + almdmov.impcto / x-TpoCmbCmp.
        ELSE detalle.impcmp = detalle.impcmp + almdmov.impcto * x-TpoCmbVta.
END.

/* FOR EACH almmmatg NO-LOCK WHERE almmmatg.codcia = s-codcia                */
/*     AND (x-CodFam = '' OR almmmatg.codfam = x-CodFam)                     */
/*     AND (x-CodPro = '' OR almmmatg.codpr1 = x-CodPro),                    */
/*     EACH almdmov USE-INDEX ALMD02 NO-LOCK WHERE almdmov.codcia = s-codcia */
/*         AND almdmov.tipmov = 'I'                                          */
/*         AND (almdmov.codmov = 02 OR almdmov.codmov = 06 )                 */
/*         AND almdmov.codmat = almmmatg.codmat                              */
/*         AND almdmov.fchdoc >= x-Fecha-1                                   */
/*         AND almdmov.fchdoc <= x-Fecha-2:                                  */
/* END.                                                                      */

/* las ventas */
FOR EACH VentasxProducto NO-LOCK WHERE VentasxProducto.DateKey >= x-Fecha-1
    AND VentasxProducto.DateKey <= x-Fecha-2,
    FIRST DimProducto OF VentasxProducto NO-LOCK WHERE (x-CodFam = '' OR DimProducto.CodFam = x-CodFam)
    AND (x-CodPro = '' OR DimProducto.CodPro[1] = x-CodPro):
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
        '*** VENTAS: ' + STRING(VentasxProducto.DateKey) + ' ' +
        VentasxProducto.CodMat.
    FIND Detalle WHERE Detalle.codcia = s-codcia
        AND Detalle.codmat = VentasxProducto.codmat EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE detalle THEN DO:
        CREATE detalle.
        ASSIGN
            detalle.codcia = s-codcia
            detalle.codmat = VentasxProducto.codmat.
    END.
    ASSIGN
        detalle.codpro = DimProducto.CodPro[1]
        detalle.canvta = detalle.canvta + VentasxProducto.Cantidad.
    IF x-codmon = 1 THEN detalle.impvta = detalle.impvta + VentasxProducto.ImpNacCIGV.
    ELSE detalle.impvta = detalle.impvta + VentasxProducto.ImpExtCIGV.
END.
/*
FOR EACH ccbcdocu USE-INDEX LLAVE13 NO-LOCK WHERE ccbcdocu.codcia = s-codcia
    AND LOOKUP (ccbcdocu.coddoc, 'FAC,BOL,TCK,N/C') > 0
    AND flgest <> 'A'
    AND LOOKUP(CcbCdocu.TpoFac, 'A,S') = 0      /* NO facturas adelantadas NI servicios */
    AND ccbcdocu.fchdoc >= x-Fecha-1
    AND ccbcdocu.fchdoc <= x-Fecha-2:
    IF CcbCdocu.Coddoc = "N/C" AND CcbCdocu.CndCre = "N" THEN NEXT. /* NO por otros conceptos */
    x-Signo = IF ccbcdocu.coddoc = 'N/C' THEN -1 ELSE 1.
    FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
        USE-INDEX Cmb01 NO-LOCK NO-ERROR.
    IF NOT AVAIL Gn-Tcmb THEN 
        FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
        USE-INDEX Cmb01 NO-LOCK NO-ERROR.
    IF AVAIL Gn-Tcmb THEN 
        ASSIGN
            x-TpoCmbCmp = Gn-Tcmb.Compra
            x-TpoCmbVta = Gn-Tcmb.Venta.
    FOR EACH ccbddocu OF ccbcdocu NO-LOCK,
        FIRST Almmmatg OF Ccbddocu NO-LOCK WHERE almmmatg.codfam BEGINS x-CodFam
        AND almmmatg.codpr1 BEGINS x-CodPro:
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
            'ACUMULANDO: ' + ccbcdocu.coddiv + ' ' +
            ccbcdocu.coddoc + ' ' + 
            ccbcdocu.nrodoc + ' ' +
            STRING(ccbcdocu.fchdoc) + ' ' +
            Almmmatg.codmat.
        FIND detalle OF ccbddocu EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE detalle THEN DO:
            CREATE detalle.
            ASSIGN
                detalle.codcia = ccbddocu.codcia
                detalle.codmat = ccbddocu.codmat.
        END.
        ASSIGN
            detalle.codpro = Almmmatg.codpr1
            detalle.canvta = detalle.canvta + Ccbddocu.candes * Ccbddocu.factor * x-Signo.
        IF ccbcdocu.codmon = x-codmon 
        THEN detalle.impvta = detalle.impvta + ( ccbddocu.implin * x-Signo ).
        ELSE IF ccbcdocu.codmon = 1 
            THEN detalle.impvta = detalle.impvta + ( ccbddocu.implin / x-TpoCmbCmp * x-Signo ).
            ELSE detalle.impvta = detalle.impvta + ( ccbddocu.implin * x-TpoCmbVta * x-Signo ).
    END.
END.
*/

/* datos finales */
FOR EACH detalle:
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '*** STOCKS: ' + detalle.codmat.
    /* proveedor */
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = detalle.codpro
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN detalle.nompro = gn-prov.nompro.
    /* saldos valorizados */
    FIND LAST Almstkge WHERE Almstkge.codcia = s-codcia
        AND Almstkge.codmat = detalle.codmat
        AND Almstkge.fecha < x-Fecha-1
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almstkge THEN DO:
        ASSIGN
            detalle.stkini = Almstkge.stkact.
        IF x-CodMon = 1 
        THEN ASSIGN
                detalle.valini = AlmStkge.StkAct * AlmStkge.CtoUni.
        ELSE ASSIGN
                detalle.valini = AlmStkge.StkAct * AlmStkge.CtoUni / x-TpoCmbCmp.
    END.
    FIND LAST Almstkge WHERE Almstkge.codcia = s-codcia
        AND Almstkge.codmat = detalle.codmat
        AND Almstkge.fecha <= x-Fecha-2
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almstkge THEN DO:
        ASSIGN
            detalle.stkfin = Almstkge.stkact.
        IF x-CodMon = 1 
        THEN ASSIGN
                detalle.valfin = AlmStkge.StkAct * AlmStkge.CtoUni.
        ELSE ASSIGN
                detalle.valfin = AlmStkge.StkAct * AlmStkge.CtoUni / x-TpoCmbCmp.
    END.
    /* rotacion */
    IF detalle.canvta <> 0 THEN detalle.rotacion = detalle.cancmp / detalle.canvta.
END.

x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '*** GENERANDO EXCEL ***'.


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
  DISPLAY x-Fecha-1 x-Fecha-2 x-CodPro FILL-IN-nompro x-Familia x-CodMon 
          x-Resumen x-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-Fecha-1 x-Fecha-2 x-CodPro x-Familia x-CodMon x-Resumen BUTTON-2 
         BtnDone 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-1 W-Win 
PROCEDURE Excel-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "REPORTE DE STOCKS VS VENTAS".

t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "DESDE: " + STRING(x-Fecha-1) + ' HASTA: ' + STRING(x-Fecha-2).

t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "IMPORTES EN " + (IF x-CodMon = 1 THEN 'NUEVOS SOLES' ELSE 'DOLARES AMERICANOS').

t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "CODIGO".
cRange = "B" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "DESCRIPCION".
cRange = "C" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "MARCA".
cRange = "D" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "LINEA".
cRange = "E" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "SUB-LINEA".
cRange = "F" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "UND".
cRange = "G" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "CANTIDAD COMPRAS".
cRange = "H" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "VENTAS".
cRange = "I" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "RATIO".
cRange = "J" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "IMPORTE COMPRA".
cRange = "K" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "VENTA".
cRange = "L" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "STOCK CANTIDAD INICIAL".
cRange = "M" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "STOCK CANTIDAD FINAL".
cRange = "N" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "STOCK IMPTE INICIAL".
cRange = "O" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "STOCK IMPTE FINAL".
cRange = "P" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "PROVEEDOR".
cRange = "Q" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "NOMBRE PROVEEDOR".
t-column = t-column + 1.

FOR EACH detalle NO-LOCK,
    FIRST Almmmatg OF detalle NO-LOCK:
    t-column = t-column + 1.                                                                                                                               
    cColumn = STRING(t-Column).                                                                                        
    cRange = "A" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + detalle.codmat.
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    cRange = "C" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + almmmatg.codfam.
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + almmmatg.subfam.
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = almmmatg.undbas.
    cRange = "G" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = detalle.cancmp.
    cRange = "H" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = detalle.canvta.
    cRange = "I" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = detalle.rotacion.
    cRange = "J" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = detalle.impcmp.
    cRange = "K" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = detalle.impvta.
    cRange = "L" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = detalle.stkini.
    cRange = "M" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = detalle.stkfin.
    cRange = "N" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = detalle.valini.
    cRange = "O" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = detalle.valfin.
    cRange = "P" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = "'" + detalle.codpro.
    cRange = "Q" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = detalle.nompro.
END.
HIDE FRAME F-Proceso NO-PAUSE.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-2 W-Win 
PROCEDURE Excel-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "REPORTE DE STOCKS VS VENTAS".

t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "DESDE: " + STRING(x-Fecha-1) + ' HASTA: ' + STRING(x-Fecha-2).

t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "IMPORTES EN " + (IF x-CodMon = 1 THEN 'NUEVOS SOLES' ELSE 'DOLARES AMERICANOS').

t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "PROVEEDOR".
cRange = "B" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "NOMBRE PROVEEDOR".
cRange = "C" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "IMPORTE COMPRA".
cRange = "D" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "VENTAS".
cRange = "E" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "INVENTARIO VALOR INICIAL".
cRange = "F" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "INVENTARIO VALOR FINAL".
t-column = t-column + 1.

FOR EACH detalle NO-LOCK BREAK BY detalle.codpro:
    ACCUMULATE detalle.impcmp (TOTAL BY detalle.codpro).
    ACCUMULATE detalle.impvta (TOTAL BY detalle.codpro).
    ACCUMULATE detalle.valini (TOTAL BY detalle.codpro).
    ACCUMULATE detalle.valfin (TOTAL BY detalle.codpro).
    IF LAST-OF(detalle.codpro) THEN DO:
        t-column = t-column + 1.                                                                                                                               
        cColumn = STRING(t-Column).                                                                                        
        cRange = "A" + cColumn.                                                                                    
        chWorkSheet:Range(cRange):Value = "'" + detalle.codpro.
        cRange = "B" + cColumn.                                                                                    
        chWorkSheet:Range(cRange):Value = detalle.nompro.
        cRange = "C" + cColumn.                                                                                    
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY detalle.codpro detalle.impcmp.
        cRange = "D" + cColumn.                                                                                    
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY detalle.codpro detalle.impvta.
        cRange = "E" + cColumn.                                                                                    
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY detalle.codpro detalle.valini.
        cRange = "F" + cColumn.                                                                                    
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY detalle.codpro detalle.valfin.
    END.
END.
HIDE FRAME F-Proceso NO-PAUSE.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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
  FOR EACH almtfami NO-LOCK WHERE codcia = 1:
      x-Familia:ADD-LAST(almtfami.codfam + ' - ' + Almtfami.desfam) IN FRAME {&FRAME-NAME}.
  END.
  ASSIGN
      x-Fecha-1 = TODAY - DAY(TODAY) + 1
      x-Fecha-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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
        WHEN "" THEN .
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

