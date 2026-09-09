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
DEF SHARED VAR s-coddiv AS CHAR.

DEFINE TEMP-TABLE tmp-table NO-UNDO
    FIELDS t-codcli LIKE gn-clie.codcli
    FIELDS t-coddoc LIKE ccbcdocu.coddoc
    FIELDS t-nrodoc LIKE ccbcdocu.nrodoc
    FIELDS t-fchade AS DATE
    FIELDS t-nroope LIKE ccbcdocu.nroref
    FIELDS t-monade AS DECIMAL
    FIELDS t-monto  AS DECIMAL.

DEFINE TEMP-TABLE tmp-datos NO-UNDO
    FIELDS coddoc LIKE ccbcdocu.coddoc
    FIELDS nrodoc LIKE ccbcdocu.nrodoc
    FIELDS fchdoc LIKE ccbcdocu.fchdoc
    FIELDS codcli LIKE ccbcdocu.codcli
    FIELDS imptot LIKE ccbcdocu.imptot
    FIELDS impsdo LIKE ccbcdocu.imptot
    FIELDS codade LIKE ccbcdocu.coddoc
    FIELDS nroade LIKE ccbcdocu.nrodoc
    FIELDS nroope LIKE ccbcdocu.nroref
    FIELDS fchade AS DATE
    FIELDS impade LIKE ccbcdocu.imptot
    FIELDS totade LIKE ccbcdocu.imptot.

DEFINE BUFFER b-tmp FOR tmp-datos.

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
&Scoped-Define ENABLED-OBJECTS txt-codcli1 txt-DesdeA txt-HastaA txt-DesdeF ~
txt-HastaF btn-excel btn-exit RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS txt-codcli1 txt-DesdeA txt-HastaA ~
txt-DesdeF txt-HastaF txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-excel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 10 BY 1.5.

DEFINE BUTTON btn-exit 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 2" 
     SIZE 10 BY 1.5.

DEFINE VARIABLE txt-codcli1 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txt-DesdeA AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txt-DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txt-HastaA AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txt-HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52 BY 6.81.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16 BY 6.81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-codcli1 AT ROW 2.88 COL 20.86 COLON-ALIGNED WIDGET-ID 2
     txt-DesdeA AT ROW 4.31 COL 20.86 COLON-ALIGNED WIDGET-ID 6
     txt-HastaA AT ROW 4.27 COL 39 COLON-ALIGNED WIDGET-ID 8
     txt-DesdeF AT ROW 5.58 COL 20.86 COLON-ALIGNED WIDGET-ID 10
     txt-HastaF AT ROW 5.58 COL 39 COLON-ALIGNED WIDGET-ID 12
     btn-excel AT ROW 2.62 COL 58 WIDGET-ID 18
     btn-exit AT ROW 4.5 COL 58 WIDGET-ID 20
     txt-msj AT ROW 7.15 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     "CRITERIOS DE SELECCION" VIEW-AS TEXT
          SIZE 25 BY .54 AT ROW 1.46 COL 5 WIDGET-ID 26
          BGCOLOR 7 FGCOLOR 15 
     "F. Depósitos" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 4.5 COL 5 WIDGET-ID 14
          FONT 6
     "F. Facturas" VIEW-AS TEXT
          SIZE 12 BY .54 AT ROW 5.73 COL 5 WIDGET-ID 16
          FONT 6
     RECT-1 AT ROW 1.73 COL 3 WIDGET-ID 24
     RECT-2 AT ROW 1.73 COL 55.72 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 74.29 BY 8.81
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
         TITLE              = "Anticipos por Documento"
         HEIGHT             = 8.81
         WIDTH              = 74.29
         MAX-HEIGHT         = 8.81
         MAX-WIDTH          = 74.29
         VIRTUAL-HEIGHT     = 8.81
         VIRTUAL-WIDTH      = 74.29
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Anticipos por Documento */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Anticipos por Documento */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-excel W-Win
ON CHOOSE OF btn-excel IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN txt-codcli1 txt-DesdeA txt-DesdeF txt-HastaA txt-HastaF. 
  RUN Borra-Temporales.
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-exit W-Win
ON CHOOSE OF btn-exit IN FRAME F-Main /* Button 2 */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Adelantos W-Win 
PROCEDURE Asigna-Adelantos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*Graba Documentos*/
    FOR EACH tmp-table NO-LOCK:
        FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia
            AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK") > 0
            AND ccbcdocu.codcli =  t-codcli
            AND ccbcdocu.fchdoc >= txt-desdef
            AND ccbcdocu.fchdoc <= txt-hastaf
            AND ccbcdocu.flgest <> "A" NO-LOCK:
            
            FIND FIRST tmp-datos WHERE tmp-datos.coddoc = ccbcdocu.coddoc
                AND tmp-datos.nrodoc = ccbcdocu.nrodoc
                AND tmp-datos.codcli = ccbcdocu.codcli NO-LOCK NO-ERROR.
            IF NOT AVAIL tmp-datos THEN DO:
                CREATE tmp-datos.
                ASSIGN
                    tmp-datos.coddoc = ccbcdocu.coddoc
                    tmp-datos.nrodoc = ccbcdocu.nrodoc
                    tmp-datos.fchdoc = ccbcdocu.fchdoc
                    tmp-datos.codcli = ccbcdocu.codcli
                    tmp-datos.imptot = ccbcdocu.imptot
                    tmp-datos.impsdo = ccbcdocu.imptot.
                IF ccbcdocu.codmon = 2 THEN 
                    ASSIGN
                    tmp-datos.imptot = ccbcdocu.imptot  * ccbcdocu.tpocmb
                    tmp-datos.impsdo = ccbcdocu.imptot  * ccbcdocu.tpocmb.
            END.
        END.
    END.
    
    Head:
    FOR EACH tmp-datos WHERE impade = 0 NO-LOCK
        BREAK BY tmp-datos.codcli
        BY tmp-datos.fchdoc
        BY tmp-datos.coddoc 
        BY tmp-datos.nrodoc:

        Sec:
        FOR EACH tmp-table WHERE tmp-table.t-codcli = tmp-datos.codcli
            AND tmp-table.t-monto <> 0 NO-LOCK
            BREAK BY tmp-table.t-fchade
            BY tmp-table.t-nroope:     
            IF tmp-table.t-monto >= tmp-datos.impsdo THEN DO:
                ASSIGN 
                    tmp-datos.codade = t-coddoc
                    tmp-datos.nroade = t-nrodoc
                    tmp-datos.fchade = t-fchade
                    tmp-datos.nroope = t-nroope
                    tmp-datos.totade = t-monade
                    tmp-datos.impade = tmp-datos.impsdo
                    tmp-datos.impsdo = (tmp-datos.impsdo - tmp-datos.imptot).
                t-monto = (t-monto - tmp-datos.impade).
                NEXT Head.
            END.
            ELSE DO:
                ASSIGN 
                    tmp-datos.codade = t-coddoc
                    tmp-datos.nroade = t-nrodoc
                    tmp-datos.fchade = t-fchade
                    tmp-datos.nroope = t-nroope
                    tmp-datos.totade = t-monade
                    tmp-datos.impade = t-monto
                    tmp-datos.impsdo = (tmp-datos.impsdo - t-monto).
                t-monto = 0.
                CREATE b-tmp.
                BUFFER-COPY tmp-datos TO b-tmp.
                ASSIGN
                    tmp-datos.codade = ""
                    tmp-datos.nroade = ""
                    tmp-datos.nroope = ""
                    tmp-datos.fchade = ?
                    tmp-datos.impade = 0.
                NEXT Sec.
            END.
        END.
        DISPLAY "Asignando Anticipos " + tmp-datos.coddoc + "-" + tmp-datos.nrodoc @ txt-msj
            WITH FRAME {&FRAME-NAME}.
    END.
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporales W-Win 
PROCEDURE Borra-Temporales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tmp-table :
        DELETE tmp-table.
    END.

    FOR EACH tmp-datos:
        DELETE tmp-datos.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Adelantos W-Win 
PROCEDURE Carga-Adelantos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH CcbCDocu WHERE CcbcDocu.codcia = s-codcia
        AND CcbCDocu.CodDoc = "A/R"
        AND CcbCDocu.CodCli BEGINS txt-CodCli1
        AND CcbCDocu.FchDoc >= txt-DesdeA
        AND CcbCDocu.FchDoc <= txt-HastaA
        AND CcbCDocu.FlgEst <> "A" NO-LOCK:
        FIND FIRST tmp-table WHERE t-codcli = ccbcdocu.codcli
            AND t-coddoc = ccbcdocu.coddoc
            AND t-nrodoc = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
        IF NOT AVAIL tmp-table THEN DO:
            CREATE tmp-table.
            ASSIGN
                t-codcli = ccbcdocu.codcli
                t-coddoc = ccbcdocu.coddoc
                t-nrodoc = ccbcdocu.nrodoc
                t-fchade = ccbcdocu.fchdoc                
                t-monade = ccbcdocu.imptot
                t-monto  = ccbcdocu.imptot.

            IF ccbcdocu.codmon = 2 THEN 
                ASSIGN
                t-monade = ccbcdocu.imptot * ccbcdocu.tpocmb
                t-monto  = ccbcdocu.imptot * ccbcdocu.tpocmb.
        END.
        DISPLAY "Cargando Documentos: " + ccbcdocu.coddoc + "-" + ccbcdocu.nrodoc @ txt-msj
            WITH FRAME {&FRAME-NAME}.
    END.


    /*Buscando Boletas de Depósito*/
    FOR EACH CcbCDocu WHERE CcbcDocu.codcia = s-codcia
        AND CcbCDocu.CodDoc = "BD"
        AND CcbCDocu.CodCli BEGINS txt-CodCli1
        AND CcbCDocu.FchAte >= txt-DesdeA
        AND CcbCDocu.FchAte <= txt-HastaA
        AND CcbCDocu.FlgEst <> "A" NO-LOCK:
        FIND FIRST tmp-table WHERE t-codcli = ccbcdocu.codcli
            AND t-coddoc = ccbcdocu.coddoc
            AND t-nrodoc = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
        IF NOT AVAIL tmp-table THEN DO:
            CREATE tmp-table.
            ASSIGN
                t-codcli = ccbcdocu.codcli
                t-coddoc = ccbcdocu.coddoc
                t-nrodoc = ccbcdocu.nrodoc
                t-fchade = ccbcdocu.fchate
                t-nroope = ccbcdocu.nroref
                t-monade = ccbcdocu.imptot  
                t-monto  = ccbcdocu.imptot.

            IF ccbcdocu.codmon = 2 THEN
                ASSIGN
                t-monade = ccbcdocu.imptot  * ccbcdocu.tpocmb
                t-monto  = ccbcdocu.imptot  * ccbcdocu.tpocmb.            
        END.
        DISPLAY "Cargando Documentos: " + ccbcdocu.coddoc + "-" + ccbcdocu.nrodoc @ txt-msj
            WITH FRAME {&FRAME-NAME}.
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
  DISPLAY txt-codcli1 txt-DesdeA txt-HastaA txt-DesdeF txt-HastaF txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txt-codcli1 txt-DesdeA txt-HastaA txt-DesdeF txt-HastaF btn-excel 
         btn-exit RECT-1 RECT-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 4.
DEFINE VARIABLE t-Letra                 AS INTEGER.
DEFINE VARIABLE iInt                    AS INTEGER     NO-UNDO.

DEFINE VARIABLE cLetra  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLetra2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE t-col   AS INTEGER     NO-UNDO.


RUN Carga-Adelantos.
RUN Asigna-Adelantos.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("B2"):Value = "REPORTE DE ANTICIPOS VS DOCUMENTOS".

chWorkSheet:Range("A3"):Value = "CodCli".
chWorkSheet:Range("B3"):Value = "Nombre".
chWorkSheet:Range("C3"):Value = "Cod Doc".
chWorkSheet:Range("D3"):Value = "Nro Doc".
chWorkSheet:Range("E3"):Value = "Fecha Doc".
chWorkSheet:Range("F3"):Value = "Importe Doc".
chWorkSheet:Range("G3"):Value = "Importe Adelanto".
chWorkSheet:Range("H3"):Value = "Doc Adelanto".
chWorkSheet:Range("I3"):Value = "Nº Doc. Adelanto".
chWorkSheet:Range("J3"):Value = "Nro. Operacion".
chWorkSheet:Range("K3"):Value = "Fecha Depósito".
chWorkSheet:Range("L3"):Value = "Monto Depositado".

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("C"):NumberFormat = "@".
chWorkSheet:Columns("D"):NumberFormat = "@".
chWorkSheet:Columns("H"):NumberFormat = "@".
chWorkSheet:Columns("I"):NumberFormat = "@".
chWorkSheet:Columns("J"):NumberFormat = "@".

t-column = 3.

FOR EACH tmp-datos NO-LOCK
    WHERE tmp-datos.impade <> 0
    BREAK BY tmp-datos.codcli
    BY tmp-datos.fchade
    BY tmp-datos.nroope
    BY tmp-datos.fchdoc
    BY tmp-datos.coddoc
    BY tmp-datos.nrodoc:

    FIND FIRST gn-clie WHERE gn-clie.codcia = 0
        AND gn-clie.codcli = tmp-datos.codcli NO-LOCK NO-ERROR.

    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.Codcli.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = gn-clie.Nomcli.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.CodDoc.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.NroDoc.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.FchDoc.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.ImpTot.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.ImpAde.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.CodAde.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.NroAde.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.NroOpe.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.FchAde.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.TotAde.
    
END.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.


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

