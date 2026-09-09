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
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

DEF TEMP-TABLE t-cdoc LIKE ccbcdocu.
DEF TEMP-TABLE t-ddoc LIKE ccbddocu
    FIELD porcomi AS DECIMAL
    FIELD codcomi AS CHAR.
DEF BUFFER b-cdoc FOR ccbcdocu.

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
&Scoped-Define ENABLED-OBJECTS txt-codcli rs-opciones txt-codven txt-desde ~
txt-hasta btn-ok btn-cancel 
&Scoped-Define DISPLAYED-OBJECTS txt-codcli rs-opciones txt-codven ~
txt-desde txt-hasta txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-cancel 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 2" 
     SIZE 7 BY 1.62.

DEFINE BUTTON btn-ok 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 7 BY 1.62.

DEFINE VARIABLE txt-codcli AS CHARACTER FORMAT "X(9)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txt-codven AS CHARACTER FORMAT "X(3)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txt-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txt-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE rs-opciones AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Resumen", 1,
"Detalle", 2
     SIZE 20 BY .85 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-codcli AT ROW 2.35 COL 14 COLON-ALIGNED WIDGET-ID 2
     rs-opciones AT ROW 3.35 COL 58 NO-LABEL WIDGET-ID 16
     txt-codven AT ROW 3.42 COL 14 COLON-ALIGNED WIDGET-ID 4
     txt-desde AT ROW 4.5 COL 14 COLON-ALIGNED WIDGET-ID 6
     txt-hasta AT ROW 4.5 COL 36 COLON-ALIGNED WIDGET-ID 8
     btn-ok AT ROW 6.38 COL 5 WIDGET-ID 10
     btn-cancel AT ROW 6.38 COL 13 WIDGET-ID 12
     txt-msj AT ROW 6.65 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 8.77
         FONT 1 WIDGET-ID 100.


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
         TITLE              = "Comision - Provincia"
         HEIGHT             = 8.77
         WIDTH              = 90.29
         MAX-HEIGHT         = 8.77
         MAX-WIDTH          = 90.29
         VIRTUAL-HEIGHT     = 8.77
         VIRTUAL-WIDTH      = 90.29
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

{src/bin/_prns.i}
{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Comision - Provincia */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Comision - Provincia */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-cancel W-Win
ON CHOOSE OF btn-cancel IN FRAME F-Main /* Button 2 */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-ok W-Win
ON CHOOSE OF btn-ok IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN txt-codven txt-codcli txt-desde txt-hasta rs-opciones.
  IF txt-codven = "" AND txt-codcli = "" THEN DO:
      MESSAGE ' Usted debe ingresar Código Cliente' SKIP
              'o Código de Vendedor obligatoriamente'
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      APPLY 'ENTRY' TO txt-codcli.
      RETURN "ADM-ERROR".     
  END.

  CASE rs-opciones:
    WHEN 1 THEN RUN Exporta.
    WHEN 2 THEN RUN Exporta-Detalle.
  END CASE.

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
  DEF VAR x-FchCan AS DATE NO-UNDO.
  DEF VAR x-ImpTot AS DEC NO-UNDO.

  FOR EACH T-CDOC:
    DELETE T-CDOC.
  END.
  FOR EACH T-DDOC:
    DELETE T-DDOC.
  END.
  
  /* PRIMERO: LOS COMPROBANTES DE VENTAS */
  DISPLAY 'Acumulando comprobantes' @ txt-msj WITH FRAME {&FRAME-NAME}.
  Head:
  FOR EACH ccbcdocu NO-LOCK USE-INDEX Llave13
      WHERE ccbcdocu.codcia = s-codcia
        AND LOOKUP(ccbcdocu.coddoc, 'FAC,BOL,TCK') > 0 
        AND ccbcdocu.fchdoc >= txt-Desde
        AND ccbcdocu.fchdoc <= txt-Hasta:

      IF NOT ccbcdocu.codcli BEGINS txt-codcli THEN NEXT Head.
      IF NOT ccbcdocu.codven BEGINS txt-codven THEN NEXT Head.
      IF NOT ccbcdocu.tpofac <> 'A' THEN NEXT Head.   /* NO Facturas adelantadas */
      IF NOT ccbcdocu.flgest <> 'A' THEN NEXT Head.

      FIND t-cdoc of ccbcdocu no-lock no-error.
      IF NOT AVAILABLE t-cdoc THEN DO:
          CREATE t-cdoc.
          BUFFER-COPY ccbcdocu TO t-cdoc.
          FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK WHERE Ccbddocu.implin > 0:
            CREATE t-ddoc.
            BUFFER-COPY Ccbddocu TO t-ddoc
                ASSIGN t-ddoc.implin = (Ccbddocu.implin - Ccbddocu.impigv) * (1 - Ccbcdocu.pordto / 100).
          END.
      END.        
  END.

  /* SEGUNDO: LAS NOTAS DE ABONO */
  DISPLAY 'Acumulando Notas de Abono' @ txt-msj WITH FRAME {&FRAME-NAME}.

  DEFINE VAR x-Factor AS DEC NO-UNDO.
  DEFINE BUFFER b-cdocu FOR Ccbcdocu.
  DEFINE BUFFER b-ddocu FOR Ccbddocu.
  
  FOR EACH CcbCdocu NO-LOCK USE-INDEX LLAVE13
      WHERE CcbCdocu.CodCia = S-CODCIA 
      /*AND ccbcdocu.coddiv = s-coddiv*/
      AND CCbCdocu.FchDoc >= txt-Desde
      AND CcbCdocu.FchDoc <= txt-Hasta
      AND CcbCdocu.CodDoc = "N/C" 
      AND CcbCDocu.FlgEst <> 'A':

      IF NOT ccbcdocu.codcli BEGINS txt-codcli THEN NEXT.
      IF NOT ccbcdocu.codven BEGINS txt-codven THEN NEXT.

      FIND B-CDOCU WHERE B-CDOCU.CODCIA = CCBCDOCU.CODCIA 
          AND B-CDOCU.CODDOC = CCBCDOCU.CODREF 
          AND B-CDOCU.NRODOC = CCBCDOCU.NROREF
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CDOCU THEN NEXT.
      
      /* caso de factura adelantada */
      x-ImpTot = B-CDOCU.ImpTot.
      FIND FIRST Ccbddocu OF B-CDOCU WHERE Ccbddocu.implin < 0 NO-LOCK NO-ERROR.
      IF AVAILABLE Ccbddocu THEN x-ImpTot = x-ImpTot + ABSOLUTE(Ccbddocu.implin).
      /* ************************** */
      CREATE t-cdoc.
      BUFFER-COPY Ccbcdocu TO t-cdoc
          ASSIGN
          t-cdoc.codven = B-CDOCU.codven
          t-cdoc.fmapgo = B-CDOCU.fmapgo
          t-cdoc.pordto = B-CDOCU.pordto.
      CASE Ccbcdocu.cndcre:
          WHEN 'D' THEN DO:   /* Por devolucion */
              FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
                  CREATE t-ddoc.
                  BUFFER-COPY Ccbddocu TO t-ddoc
                      ASSIGN
                      t-ddoc.implin = (Ccbddocu.implin - Ccbddocu.impigv).
              END.
          END.
          OTHERWISE DO:
              IF B-CDOCU.codmon = Ccbcdocu.codmon 
                  THEN x-Factor = Ccbcdocu.imptot / x-imptot.
              ELSE IF B-CDOCU.codmon = 1
                  THEN x-Factor = (Ccbcdocu.imptot * Ccbcdocu.tpocmb) / x-imptot.
              ELSE x-Factor = (Ccbcdocu.imptot / Ccbcdocu.tpocmb) / x-imptot.
                   ASSIGN
                       t-cdoc.codmon = B-CDOCU.codmon.
              FOR EACH B-DDOCU OF B-CDOCU NO-LOCK WHERE B-DDOCU.implin > 0:
                  CREATE t-ddoc.
                  BUFFER-COPY B-DDOCU TO t-ddoc
                      ASSIGN
                      t-ddoc.coddoc = t-cdoc.coddoc
                      t-ddoc.nrodoc = t-cdoc.nrodoc
                      t-ddoc.implin = (B-DDOCU.implin - B-DDOCU.impigv) * x-Factor * (1 - B-CDOCU.PorDto / 100).
              END.
          END.
      END CASE.
  END.

  DISPLAY 'Calculando Comisiones' @ txt-msj WITH FRAME {&FRAME-NAME}.

  /*Buscando por Articulos*/
  FOR EACH t-ddoc NO-LOCK:
      FIND FIRST Vtacomarti WHERE Vtacomarti.codcia = s-codcia
          AND Vtacomarti.codmat = t-ddoc.codmat NO-LOCK NO-ERROR.
      IF AVAIL Vtacomarti THEN DO:
          /*Vigencia de Comision*/
          FIND FIRST Vtacomvige WHERE Vtacomvige.codcia = Vtacomarti.Codcia
              AND Vtacomvige.codcomi = Vtacomarti.Codcomi
              AND t-ddoc.fchdoc >= Vtacomvige.FchIni
              AND t-ddoc.fchdoc <= Vtacomvige.FchFin NO-LOCK NO-ERROR.
          IF AVAIL Vtacomvige THEN
              ASSIGN
              t-ddoc.porcom = Vtacomvige.PorComis
              t-ddoc.codcom = Vtacomvige.CodComis.
          ELSE DO:
              FIND FIRST Vtacomprov OF Vtacomarti NO-LOCK NO-ERROR.
              IF AVAILABLE Vtacomprov THEN 
                  ASSIGN
                  t-ddoc.porcom = Vtacomprov.PorComis
                  t-ddoc.codcom = Vtacomprov.CodComis.
          END.
      END.
  END.
  
  /*Buscando por cabecera*/
  FOR EACH t-ddoc WHERE t-ddoc.porcom = 0 NO-LOCK:
      FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
          AND almmmatg.codmat = t-ddoc.codmat NO-LOCK NO-ERROR.
      IF AVAILABLE almmmatg THEN DO:          
          FIND FIRST Vtacomprov WHERE Vtacomprov.CodCia = almmmatg.codcia 
              AND Vtacomprov.codfam  = almmmatg.codfam
              AND Vtacomprov.SubFam  = almmmatg.subfam NO-LOCK NO-ERROR.
          IF AVAILABLE Vtacomprov THEN 
              ASSIGN 
              t-ddoc.porcom = Vtacomprov.PorComis
              t-ddoc.codcom = Vtacomprov.CodComis. 
          ELSE DO:
              FIND FIRST Vtacomprov WHERE Vtacomprov.CodCia = almmmatg.codcia 
                  AND Vtacomprov.codfam = almmmatg.codfam
                  AND Vtacomprov.SubFam = "" NO-LOCK NO-ERROR.
              IF AVAILABLE Vtacomprov THEN 
                  ASSIGN 
                  t-ddoc.porcom = Vtacomprov.PorComis
                  t-ddoc.codcom = Vtacomprov.CodComis. 
          END.
      END.
  END.    
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
  DISPLAY txt-codcli rs-opciones txt-codven txt-desde txt-hasta txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txt-codcli rs-opciones txt-codven txt-desde txt-hasta btn-ok 
         btn-cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta W-Win 
PROCEDURE Exporta :
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
DEFINE VARIABLE iTotalNumberOfOrders    AS INTEGER.
DEFINE VARIABLE iMonth                  AS INTEGER.
DEFINE VARIABLE dAnnualQuota            AS DECIMAL.
DEFINE VARIABLE dTotalSalesAmount       AS DECIMAL.
DEFINE VARIABLE t-Column                AS INTEGER INITIAL 5.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE f-Column                AS char INITIAL "".
DEFINE VARIABLE x-valor                 AS DECIMAL init 0.
DEFINE VARIABLE f-estado                AS char init "".

DEFINE VARIABLE dTot AS DECIMAL     NO-UNDO.

RUN Carga-Temporal.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 6.
chWorkSheet:Columns("C"):ColumnWidth = 30.
chWorkSheet:Columns("D"):ColumnWidth = 10.
chWorkSheet:Columns("E"):ColumnWidth = 5.
chWorkSheet:Columns("F"):ColumnWidth = 2.

chWorkSheet:Columns("B"):NumberFormat = "@".
chWorkSheet:Columns("D"):NumberFormat = "@".

chWorkSheet:Range("D3"):Value = "Comisiones por Vendedor Provincia - Resumen".
chWorkSheet:Range("B4"):Value = "Desde: " + string(DATE(txt-Desde)).
chWorkSheet:Range("F4"):Value = "Hasta: " + string(DATE(txt-Hasta)).


chWorkSheet:Range("A3:O5"):Font:Bold = TRUE.

chWorkSheet:Range("A5"):Value = "CodDoc".
chWorkSheet:Range("B5"):Value = "Número".
chWorkSheet:Range("C5"):Value = "Fecha"  .
chWorkSheet:Range("D5"):Value = "Vendedor".
chWorkSheet:Range("E5"):Value = "Importe Total S/.".
chWorkSheet:Range("F5"):Value = "Comsiones Total S/.".


chWorkSheet = chExcelApplication:Sheets:Item(1).

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */

FOR EACH t-cdoc NO-LOCK,EACH t-ddoc OF t-cdoc NO-LOCK      
    BREAK BY t-cdoc.codcia BY t-cdoc.codven 
    BY t-cdoc.coddoc BY t-cdoc.nrodoc:

    DISPLAY 'Calculando Comisiones' @ txt-msj WITH FRAME {&FRAME-NAME}.

    IF FIRST-OF(t-cdoc.codven) THEN DO:
        FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia
            AND gn-ven.codven = t-cdoc.codven NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ven THEN DO:
            t-column = t-column + 1.
            cColumn = STRING(t-Column).
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = t-cdoc.codven + ": " + gn-ven.nomven.
        END.
    END.

    dtot = (t-ddoc.implin * t-ddoc.porcom / 100).
          
    ACCUMULATE t-ddoc.implin (SUB-TOTAL BY t-cdoc.nrodoc).
    ACCUMULATE dTot          (SUB-TOTAL BY t-cdoc.nrodoc).

    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = t-cdoc.coddoc.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = t-cdoc.nrodoc.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = t-cdoc.fchdoc.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = t-cdoc.codven.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY t-cdoc.nrodoc t-ddoc.implin.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY t-cdoc.nrodoc dTot.
END.


/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

DISPLAY '' @ txt-msj WITH FRAME {&FRAME-NAME}.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
/*RELEASE OBJECT chWorksheetRange. */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Detalle W-Win 
PROCEDURE Exporta-Detalle :
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
DEFINE VARIABLE iTotalNumberOfOrders    AS INTEGER.
DEFINE VARIABLE iMonth                  AS INTEGER.
DEFINE VARIABLE dAnnualQuota            AS DECIMAL.
DEFINE VARIABLE dTotalSalesAmount       AS DECIMAL.
DEFINE VARIABLE t-Column                AS INTEGER INITIAL 5.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE f-Column                AS char INITIAL "".
DEFINE VARIABLE x-valor                 AS DECIMAL init 0.
DEFINE VARIABLE f-estado                AS char init "".

DEFINE VARIABLE dTot AS DECIMAL     NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

RUN Carga-Temporal.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 6.
chWorkSheet:Columns("C"):ColumnWidth = 30.
chWorkSheet:Columns("D"):ColumnWidth = 10.
chWorkSheet:Columns("E"):ColumnWidth = 5.
chWorkSheet:Columns("F"):ColumnWidth = 2.

chWorkSheet:Columns("B"):NumberFormat = "@".
chWorkSheet:Columns("D"):NumberFormat = "@".
chWorkSheet:Columns("E"):NumberFormat = "@".
chWorkSheet:Columns("H"):NumberFormat = "@".
chWorkSheet:Columns("I"):NumberFormat = "@".
chWorkSheet:Columns("M"):NumberFormat = "@".


chWorkSheet:Range("F3"):Value = "Comisiones por Vendedor Provincia - Detalle".
chWorkSheet:Range("B4"):Value = "Desde: " + string(DATE(txt-Desde)).
chWorkSheet:Range("H4"):Value = "Hasta: " + string(DATE(txt-Hasta)).

chWorkSheet:Range("A3:O5"):Font:Bold = TRUE.

chWorkSheet:Range("A5"):Value = "CodDoc".
chWorkSheet:Range("B5"):Value = "Número".
chWorkSheet:Range("C5"):Value = "Fecha"  .
chWorkSheet:Range("D5"):Value = "Vendedor".
chWorkSheet:Range("E5"):Value = "Articulo".
chWorkSheet:Range("F5"):Value = "Descripcion".
chWorkSheet:Range("G5"):Value = "Marca".
chWorkSheet:Range("H5"):Value = "Familia".
chWorkSheet:Range("I5"):Value = "SubFam".
chWorkSheet:Range("J5"):Value = "P/T".
chWorkSheet:Range("K5"):Value = "Importe Total S/.".
chWorkSheet:Range("L5"):Value = "% Comision".
chWorkSheet:Range("M5"):Value = "Comision Total S/.".
chWorkSheet:Range("N5"):Value = "Codigo Comision".

chWorkSheet = chExcelApplication:Sheets:Item(1).

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */

FOR EACH t-cdoc NO-LOCK,EACH t-ddoc OF t-cdoc NO-LOCK:
    dtot = (t-ddoc.implin * t-ddoc.porcom / 100).
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.codmat = t-ddoc.codmat NO-LOCK NO-ERROR.
          
    DISPLAY 'Calculando Comisiones' @ txt-msj WITH FRAME {&FRAME-NAME}.

    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = t-cdoc.coddoc.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = t-cdoc.nrodoc.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = t-cdoc.fchdoc.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = t-cdoc.codven.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = t-ddoc.codmat.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.codfam.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.subfam.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.CHR__02.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = t-ddoc.implin.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = t-ddoc.porcom.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = dTot.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = t-ddoc.CodCom.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

DISPLAY '' @ txt-msj WITH FRAME {&FRAME-NAME}.
/*chExcelApplication:Selection:Style = "Currency".*/

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
/*RELEASE OBJECT chWorksheetRange. */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    RUN Carga-Temporal.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        CASE rs-opciones:
            WHEN 1 THEN RUN formatoresumen.
            WHEN 2 THEN RUN formato2.
        END CASE.        
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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

