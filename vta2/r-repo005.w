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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE Detalle
    FIELD nrosec AS INT FORMAT '>>>>>9' LABEL 'Sec'
    FIELD coddoc LIKE ccbcdocu.coddoc LABEL 'Codigo'
    FIELD nrodoc LIKE ccbcdocu.nrodoc LABEL 'Numero'
    FIELD fchdoc LIKE ccbcdocu.fchdoc LABEL 'Fecha'
    FIELD codcli LIKE ccbcdocu.codcli LABEL 'Cliente'
    FIELD nomcli LIKE ccbcdocu.nomcli LABEL 'Nombre'
    FIELD cuenta AS INT FORMAT '>>9' LABEL 'Cuenta'
    FIELD imptot    LIKE ccbcdocu.imptot COLUMN-LABEL 'Importe'
    FIELD descuento LIKE ccbcdocu.imptot COLUMN-LABEL 'Descuento'
    FIELD flete     LIKE ccbcdocu.imptot COLUMN-LABEL 'Flete'
    FIELD cbocobranza AS CHAR LABEL 'Canal de Pago'
    FIELD cboformapago AS CHAR LABEL 'Forma de Pago'
    .

DEF TEMP-TABLE Detalle2 LIKE Detalle
    FIELD codmat LIKE ccbddocu.codmat
    FIELD desmat LIKE almmmatg.desmat
    FIELD candes LIKE ccbddocu.candes
    FIELD undvta LIKE ccbddocu.undvta
    FIELD implin LIKE ccbddocu.implin
    FIELD codfam AS CHAR FORMAT 'x(30)' COLUMN-LABEL 'Familia'
    FIELD subfam AS CHAR FORMAT 'x(30)' COLUMN-LABEL 'Sub-Familia'
    FIELD pesounit  AS DEC DECIMALS 4   FORMAT '>>>,>>9.9999' COLUMN-LABEL 'Peso Unitario (kg)'
    FIELD pesototal AS DEC DECIMALS 4   FORMAT '>>>,>>9.9999' COLUMN-LABEL 'Peso Total (kg)'
    FIELD tasa      AS DEC COLUMN-LABEL 'Tasa (%)'
    FIELD comision  AS DEC DECIMALS 4  FORMAT '>>>,>>9.9999' COLUMN-LABEL 'Comisión'
    .

    DEF VAR c-csv-file AS CHAR NO-UNDO.
    DEF VAR c-xls-file AS CHAR INIT 'Lista_Express' NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 RADIO-SET-1 ~
BUTTON-1 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
RADIO-SET-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/error.ico":U
     LABEL "&Done" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/ok.ico":U
     LABEL "Button 1" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cabecera", 1,
"Cabecera + Detalle", 2
     SIZE 34 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Fecha-1 AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-Fecha-2 AT ROW 3.15 COL 19 COLON-ALIGNED WIDGET-ID 4
     RADIO-SET-1 AT ROW 4.23 COL 21 NO-LABEL WIDGET-ID 10
     BUTTON-1 AT ROW 6.65 COL 8 WIDGET-ID 6
     BtnDone AT ROW 6.65 COL 23 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 7.96 WIDGET-ID 100.


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
         TITLE              = "LIQUIDACION LISTA EXPRESS"
         HEIGHT             = 7.96
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
ON END-ERROR OF W-Win /* LIQUIDACION LISTA EXPRESS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* LIQUIDACION LISTA EXPRESS */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    DEF VAR rpta AS LOG INIT NO NO-UNDO.

    SYSTEM-DIALOG GET-FILE c-xls-file
        FILTERS 'Libro de Excel' '*.xlsx'
        INITIAL-FILTER 1
        ASK-OVERWRITE
        CREATE-TEST-FILE
        DEFAULT-EXTENSION ".xlsx"
        SAVE-AS
        TITLE "Guardar como"
        USE-FILENAME
        UPDATE rpta.
    IF rpta = NO THEN RETURN.

    CASE RADIO-SET-1:
        WHEN 1 THEN DO:
            SESSION:SET-WAIT-STATE('GENERAL').
            RUN Excel-Cabecera.
            SESSION:SET-WAIT-STATE('').
            MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
        END.
        WHEN 2 THEN DO:
            /* Cargamos la informacion al temporal */
            SESSION:SET-WAIT-STATE('GENERAL').
            EMPTY TEMP-TABLE Detalle.
            RUN Carga-Temporal.
            RUN Excel-Detalle.
            SESSION:SET-WAIT-STATE('').
            MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
        END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Fecha-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Fecha-1 W-Win
ON LEAVE OF FILL-IN-Fecha-1 IN FRAME F-Main /* Desde */
DO:
  ASSIGN {&SELF-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Fecha-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Fecha-2 W-Win
ON LEAVE OF FILL-IN-Fecha-2 IN FRAME F-Main /* Hasta */
DO:
  ASSIGN {&SELF-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 W-Win
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME F-Main
DO:
  ASSIGN {&SELF-NAME}.
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
DEF VAR x-NroSec LIKE Detalle.nrosec NO-UNDO.
DEF VAR x-Cuenta LIKE Detalle.cuenta NO-UNDO.
DEF VAR x-PrimerRegistro AS LOG NO-UNDO.

x-NroSec = 1.
x-Cuenta = 1.
FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.coddiv = '00506'       /*s-coddiv*/
    AND LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,N/C') > 0
    AND Ccbcdocu.fchdoc >= FILL-IN-Fecha-1
    AND Ccbcdocu.fchdoc <= FILL-IN-Fecha-2
    AND Ccbcdocu.flgest <> 'A':
    CREATE Detalle.
    BUFFER-COPY Ccbcdocu TO Detalle.
    IF NUM-ENTRIES(Ccbcdocu.codage,'|') >= 2 THEN
        ASSIGN
        Detalle.cuenta       = x-Cuenta
        Detalle.cbocobranza  = ENTRY(1,Ccbcdocu.codage,'|')
        Detalle.cboformapago = ENTRY(3,Ccbcdocu.codage,'|').
    IF Ccbcdocu.coddoc = 'N/C' THEN Detalle.imptot = -1 * Ccbcdocu.imptot.
    /* Flete */
    ASSIGN 
        Detalle.flete = 0
        Detalle.descuento = Ccbcdocu.impdto2.
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK WHERE Ccbddocu.codmat = '044939':
        ASSIGN Detalle.flete = Detalle.flete + Ccbddocu.implin.
    END.
    /* Importe Total */
    IF RADIO-SET-1 = 2 THEN DO:
        x-PrimerRegistro = YES.
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK WHERE Ccbddocu.codmat <> '044939',
            FIRST Almmmatg OF Ccbddocu NO-LOCK,
            FIRST Almtfami OF Almmmatg NO-LOCK,
            FIRST Almsfami OF Almmmatg NO-LOCK:
            CREATE Detalle2.
            IF x-PrimerRegistro = YES 
                THEN BUFFER-COPY Detalle TO Detalle2.
            ELSE BUFFER-COPY Detalle 
                USING Detalle.coddoc 
                      Detalle.nrodoc 
                      Detalle.fchdoc 
                      Detalle.codcli 
                      Detalle.nomcli
                      Detalle.cbocobranza 
                      Detalle.cboformapago
                TO Detalle2.
            ASSIGN
                Detalle2.nrosec = x-NroSec 
                Detalle2.codmat = ccbddocu.codmat
                Detalle2.desmat = almmmatg.desmat
                Detalle2.candes = ccbddocu.candes
                Detalle2.undvta = ccbddocu.undvta
                Detalle2.implin = ccbddocu.implin
                Detalle2.codfam = Almtfami.codfam + ' ' + Almtfami.desfam
                Detalle2.subfam = AlmSFami.subfam + ' ' + AlmSFami.dessub
                Detalle2.pesounit = almmmatg.pesmat.
            ASSIGN
                Detalle2.pesototal = (ccbddocu.candes * ccbddocu.factor) * Detalle2.pesounit.
            CASE Detalle.cboformapago:
                WHEN 'Tarjeta' THEN DO:
                    IF LOOKUP(almmmatg.codfam,'001,012,014') > 0 THEN Detalle2.tasa = 7.00.
                    ELSE Detalle2.tasa = 4.00.
                END.
                OTHERWISE DO:
                    IF LOOKUP(almmmatg.codfam,'001,012,014') > 0 THEN Detalle2.tasa = 3.50.
                    ELSE Detalle2.tasa = 0.50.
                END.
            END CASE.
            ASSIGN
                Detalle2.comision = Detalle2.implin * Detalle2.tasa / 100.
            x-NroSec = x-NroSec + 1.
            x-PrimerRegistro = NO.
        END.
    END.
    x-Cuenta = x-Cuenta + 1.
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
  DISPLAY FILL-IN-Fecha-1 FILL-IN-Fecha-2 RADIO-SET-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-Fecha-1 FILL-IN-Fecha-2 RADIO-SET-1 BUTTON-1 BtnDone 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-Cabecera W-Win 
PROCEDURE Excel-Cabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Variable de memoria */
    DEFINE VAR hProc AS HANDLE NO-UNDO.
    /* Levantamos la libreria a memoria */
    RUN lib\Tools-to-excel PERSISTENT SET hProc.

    /* Cargamos la informacion al temporal */
    EMPTY TEMP-TABLE Detalle.
    RUN Carga-Temporal.

    /* Programas que generan el Excel */
    CASE RADIO-SET-1:
        WHEN 1 THEN DO:
            RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                              INPUT c-xls-file,
                                              OUTPUT c-csv-file) .

            RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:handle,
                                              INPUT  c-csv-file,
                                              OUTPUT c-xls-file) .
        END.
        WHEN 2 THEN DO:
            RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle2:HANDLE,
                                              INPUT c-xls-file,
                                              OUTPUT c-csv-file) .

            RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle2:handle,
                                              INPUT  c-csv-file,
                                              OUTPUT c-xls-file) .
        END.
    END CASE.

    /* Borramos librerias de la memoria */
    DELETE PROCEDURE hProc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-Detalle W-Win 
PROCEDURE Excel-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.

DEFINE VARIABLE lCerrarAlTerminar        AS LOG.
DEFINE VARIABLE lMensajeAlTerminar      AS LOG.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = FALSE.

DEF var x-Plantilla AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta' VALUE x-Plantilla .
x-Plantilla = x-Plantilla + "lista_express.xltx".

chWorkbook = chExcelApplication:Workbooks:Add(x-Plantilla).

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(4).        /* Hoja "DATA" */
/* Carga de Excel */
iColumn = 1.
FOR EACH Detalle2 NO-LOCK:
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    chWorkSheet:Range("A" + cColumn):Value = Detalle2.nrosec.
    chWorkSheet:Range("B" + cColumn):Value = Detalle2.coddoc.
    chWorkSheet:Range("C" + cColumn):Value = Detalle2.nrodoc.
    chWorkSheet:Range("D" + cColumn):Value = Detalle2.fchdoc.
    chWorkSheet:Range("E" + cColumn):Value = Detalle2.codcli.
    chWorkSheet:Range("F" + cColumn):Value = Detalle2.nomcli.
    chWorkSheet:Range("G" + cColumn):Value = Detalle2.cuenta.
    chWorkSheet:Range("H" + cColumn):Value = Detalle2.imptot.
    chWorkSheet:Range("I" + cColumn):Value = Detalle2.descuento.
    chWorkSheet:Range("J" + cColumn):Value = Detalle2.flete.
    chWorkSheet:Range("K" + cColumn):Value = Detalle2.cbocobranza.
    chWorkSheet:Range("L" + cColumn):Value = Detalle2.cboformapago.
    chWorkSheet:Range("M" + cColumn):Value = Detalle2.codmat.
    chWorkSheet:Range("N" + cColumn):Value = Detalle2.desmat.
    chWorkSheet:Range("O" + cColumn):Value = Detalle2.candes.
    chWorkSheet:Range("P" + cColumn):Value = Detalle2.undvta.
    chWorkSheet:Range("Q" + cColumn):Value = Detalle2.implin.
    chWorkSheet:Range("R" + cColumn):Value = Detalle2.codfam.
    chWorkSheet:Range("S" + cColumn):Value = Detalle2.subfam.
    chWorkSheet:Range("T" + cColumn):Value = Detalle2.pesounit.
    chWorkSheet:Range("U" + cColumn):Value = Detalle2.pesototal.
    chWorkSheet:Range("V" + cColumn):Value = Detalle2.tasa.
    chWorkSheet:Range("W" + cColumn):Value = Detalle2.comision.
END.

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(5).        /* Hoja "FLETE" */
/* Carga de Excel */
iColumn = 1.
DEF VAR x-PesoTotal AS DEC INIT 0 NO-UNDO.
DEF VAR x-CostoFlete AS DEC INIT 0 NO-UNDO.

FOR EACH Detalle NO-LOCK BREAK BY Detalle.fchdoc BY Detalle.coddoc BY Detalle.nrodoc:
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    IF FIRST-OF(Detalle.fchdoc) THEN chWorkSheet:Range("A" + cColumn):Value = Detalle.fchdoc.
    IF FIRST-OF(Detalle.coddoc) THEN chWorkSheet:Range("B" + cColumn):Value = Detalle.coddoc.
    chWorkSheet:Range("C" + cColumn):Value = Detalle.nrodoc.
    chWorkSheet:Range("D" + cColumn):Value = Detalle.nomcli.
    chWorkSheet:Range("E" + cColumn):Value = Detalle.imptot.
    x-PesoTotal = 0.
    x-CostoFlete = 0.
    FOR EACH Detalle2 NO-LOCK WHERE Detalle2.coddoc = Detalle.coddoc
        AND Detalle2.nrodoc = Detalle.nrodoc:
        x-PesoTotal = x-PesoTotal + Detalle2.pesototal.
    END.
    chWorkSheet:Range("F" + cColumn):Value = x-PesoTotal.
    chWorkSheet:Range("G" + cColumn):Value = Detalle.flete.
    IF x-PesoTotal > 1 THEN x-CostoFlete = 4.5 + (x-PesoTotal - 1) * 0.5.
    ELSE x-CostoFlete = 4.5.
    chWorkSheet:Range("H" + cColumn):Value = x-CostoFlete.
    chWorkSheet:Range("I" + cColumn):Value = x-CostoFlete - Detalle.flete.
END.
chExcelApplication:DisplayAlerts = False.
chWorkSheet:SaveAs(c-xls-file).
chExcelApplication:Visible = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 


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
  ASSIGN
      FILL-IN-Fecha-1 = ADD-INTERVAL (TODAY, -1, 'months')
      FILL-IN-Fecha-2 = TODAY.

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

