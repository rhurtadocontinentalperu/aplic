&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
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

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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
DEF SHARED VAR s-user-id AS CHAR.

DEF SHARED VAR pv-codcia AS INT.

DEF SHARED VAR s-coddiv AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES VtaVales
&Scoped-define FIRST-EXTERNAL-TABLE VtaVales


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaVales.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS VtaVales.NroDoc VtaVales.Benef01 ~
VtaVales.DNIBnf01 VtaVales.Benef02 VtaVales.DNIBnf02 VtaVales.ImpVal ~
VtaVales.CodMon VtaVales.Libre_c01 
&Scoped-define ENABLED-TABLES VtaVales
&Scoped-define FIRST-ENABLED-TABLE VtaVales
&Scoped-Define DISPLAYED-FIELDS VtaVales.NroDoc VtaVales.Benef01 ~
VtaVales.DNIBnf01 VtaVales.Benef02 VtaVales.DNIBnf02 VtaVales.ImpVal ~
VtaVales.CodMon VtaVales.ImpApl VtaVales.Libre_c01 
&Scoped-define DISPLAYED-TABLES VtaVales
&Scoped-define FIRST-DISPLAYED-TABLE VtaVales
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado FILL-IN-NomPro 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 12 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     VtaVales.NroDoc AT ROW 1 COL 19 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 16.43 BY 1
     FILL-IN-Estado AT ROW 1 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     VtaVales.Benef01 AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 51.43 BY 1
     VtaVales.DNIBnf01 AT ROW 3.15 COL 19 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 12.43 BY 1
     VtaVales.Benef02 AT ROW 4.23 COL 19 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 51.43 BY 1
     VtaVales.DNIBnf02 AT ROW 5.31 COL 19 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 12.43 BY 1
     VtaVales.ImpVal AT ROW 6.38 COL 19 COLON-ALIGNED WIDGET-ID 10
          LABEL "Importe del vale"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY 1
     VtaVales.CodMon AT ROW 6.38 COL 52 NO-LABEL WIDGET-ID 14
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dolares", 2
          SIZE 12 BY 2.15
     VtaVales.ImpApl AT ROW 7.46 COL 19 COLON-ALIGNED WIDGET-ID 22
          LABEL "Aplicado"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY 1
     VtaVales.Libre_c01 AT ROW 8.54 COL 19 COLON-ALIGNED WIDGET-ID 24
          LABEL "Proveedor" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 15 BY 1
     FILL-IN-NomPro AT ROW 8.54 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     "Moneda:" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 6.65 COL 41 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.VtaVales
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 9.38
         WIDTH              = 101.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaVales.ImpApl IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN VtaVales.ImpVal IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaVales.Libre_c01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "VtaVales"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaVales"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exportar-Excel V-table-Win 
PROCEDURE Exportar-Excel :
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

DEFINE VARIABLE cCodMon AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cEstado AS CHARACTER   NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:COLUMNS("A"):ColumnWidth = 4.
chWorkSheet:COLUMNS("B"):ColumnWidth = 10.
chWorkSheet:COLUMNS("C"):ColumnWidth = 40.
chWorkSheet:COLUMNS("D"):ColumnWidth = 11.
chWorkSheet:COLUMNS("E"):ColumnWidth = 40.
chWorkSheet:COLUMNS("F"):ColumnWidth = 11.
chWorkSheet:COLUMNS("G"):ColumnWidth = 10.
chWorkSheet:COLUMNS("H"):ColumnWidth = 11.
chWorkSheet:COLUMNS("I"):ColumnWidth = 11.

chWorkSheet:Range("A1: N2"):FONT:Bold = TRUE.
chWorkSheet:Range("A2"):VALUE = 'NRO DOC'.
chWorkSheet:Range("B2"):VALUE = "DNI BENEF 01".
chWorkSheet:Range("C2"):VALUE = "BENEFICIARIO 01".
chWorkSheet:Range("D2"):VALUE = "DNI BENEF 02".
chWorkSheet:Range("E2"):VALUE = "BENEFICIARIO 02".
chWorkSheet:Range("F2"):VALUE = "MONEDA".
chWorkSheet:Range("G2"):VALUE = 'IMPORTE VAL'.
chWorkSheet:Range("H2"):VALUE = "IMPORTE APL".
chWorkSheet:Range("I2"):VALUE = "ESTADO".
chWorkSheet:Range("J2"):VALUE = "FECHA APL".
chWorkSheet:Range("K2"):VALUE = "USUARIO APL".
chWorkSheet:Range("L2"):VALUE = "DOC APLIC".
chWorkSheet:Range("M2"):VALUE = "PROVEEDOR".



chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:COLUMNS("D"):NumberFormat = "@".

chWorkSheet = chExcelApplication:Sheets:Item(1).


FOR EACH vtavales WHERE vtavale.codcia = s-codcia 
    /*
    AND VtaVales.CodDiv = s-coddiv
    */ NO-LOCK:
    IF vtavale.codmon = 2 THEN cCodMon = '$'.
    ELSE cCodMon = 'S/.'.

    CASE VtaVales.FlgEst:
        WHEN 'P' THEN cEstado = 'EMITIDO'.
        WHEN 'A' THEN cEstado = 'ANULADO'.
        WHEN 'C' THEN cEstado = 'APLICADO'.
        OTHERWISE cEstado = '¿?'.
    END CASE.
    
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaVales.NroDoc.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaVales.DNIBnf01.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaVales.Benef01.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaVales.DNIBnf02.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaVales.Benef02.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = cCodMon .
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaVales.ImpVal.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaVales.ImpApl.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = cEstado .
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value =  VtaVales.FchApl .
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaVales.UsrApli .
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaVales.CodRef + '-' + VtaVales.NroRef.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaVales.libre_c01.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel V-table-Win 
PROCEDURE Importar-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHARACTER FORMAT "X(40)" NO-UNDO.
    DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
        SKIP
    Fi-Mensaje NO-LABEL FONT 6
    SKIP     
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

    DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.
    DEFINE VARIABLE FILL-IN-File AS CHAR NO-UNDO.

    SYSTEM-DIALOG GET-FILE FILL-IN-file
        FILTERS
            "Archivos Excel (*.xls)" "*.xls",
            "Todos (*.*)" "*.*"
        TITLE
            "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.

    IF OKpressed = NO THEN RETURN.

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet AS COM-HANDLE.

    DEFINE VARIABLE cCellArrary AS CHARACTER NO-UNDO
        EXTENT 26 INITIAL [
        "A","B","C","D","E","F","G","H",
        "I","J","K","L","M","N","O","P","Q",
        "R","S","T","U","V","W","X","Y","Z"
        ].
    DEFINE VARIABLE cCell AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iCountCell AS INTEGER NO-UNDO.
    DEFINE VARIABLE iCountArray AS INTEGER NO-UNDO.
    DEFINE VARIABLE iCountLine AS INTEGER NO-UNDO.
    DEFINE VARIABLE iTotalColumn AS INTEGER NO-UNDO.
    DEFINE VARIABLE iCountColumn AS INTEGER NO-UNDO.
    DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCodArtCli AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCodMat AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDesMat AS CHARACTER NO-UNDO.

    CREATE "Excel.Application" chExcelApplication.

    chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-file).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    PRINCIPAL:
    DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        VALES:
        REPEAT:     /* BARREMOS FILA POR FILA */
            iCountCell = 0.
            iCountArray = 0.
            cCell = "".
            iCountColumn = 0.
            iCountLine = iCountLine + 1.
            cRange = cCellArrary[1] + TRIM(STRING(iCountLine)).
            cValue = chWorkSheet:Range(cRange):VALUE.
            
            IF cValue = "" OR cValue = ? THEN LEAVE.

            DISPLAY
                iCountLine @ FI-MENSAJE LABEL "  Leyendo línea" FORMAT "X(12)"
                WITH FRAME F-PROCESO.
            COLUMNAS:
            REPEAT:     /* BARREMOS COLUMNA POR COLUMNA */
                IF iCountCell >= 26 THEN DO:
                    iCountCell = 0.
                    iCountArray = iCountArray + 1.
                    cCell = cCellArrary[iCountArray].
                END.
                iCountCell = iCountCell + 1.
                cRange = cCell + cCellArrary[iCountCell] + TRIM(STRING(iCountLine)).
                cValue = chWorkSheet:Range(cRange):VALUE.
                /* Primera Fila - Encabezados */
                IF iCountLine = 1 THEN DO:
                    IF cValue = "" OR cValue = ? THEN LEAVE.
                    /* Máximo de columnas */
                    IF iTotalColumn + 1 > 256 THEN LEAVE.
                    iTotalColumn = iTotalColumn + 1.
                END.
                ELSE DO:    /* A partir de la segunda Fila... */
                    iCountColumn = iCountColumn + 1.
                    IF iCountColumn > iTotalColumn THEN LEAVE.
                    IF cValue = "" OR cValue = ? THEN cValue = "".
                    /* Primera Columna - Número del Vale */
                    IF iCountColumn = 1 THEN DO:
                        cValue = TRIM(STRING(INTEGER(cValue))).
                        FIND VtaVales WHERE VtaVales.codcia = s-codcia
                            AND VtaVales.nrodoc = cValue
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE VtaVales THEN NEXT VALES.
                        CREATE VtaVales.
                        ASSIGN
                            VtaVales.CodCia = s-codcia
                            VtaVales.CodMon = 1
                            VtaVales.FchCre = DATETIME(TODAY, MTIME)
                            VtaVales.FlgEst = 'P'
                            VtaVales.UsrCre = s-user-id
                            VtaVales.NroDoc = cValue.
                    END.
                    ELSE DO:
                        CASE iCountColumn:
                            WHEN 2 THEN VtaVales.Benef01 = cValue.
                            WHEN 3 THEN VtaVales.DNIBnf01 = cValue.
                            WHEN 4 THEN VtaVales.Benef02 = cValue.
                            WHEN 5 THEN VtaVales.DNIBnf02 = cValue.
                            WHEN 6 THEN DO:
                                ASSIGN
                                    VtaVales.ImpVal = DECIMAL (cValue)
                                    NO-ERROR.
                                IF ERROR-STATUS:ERROR THEN DO:
                                    MESSAGE 'Error en el importe del vale' vtavales.nrodoc SKIP
                                        VIEW-AS ALERT-BOX ERROR.
                                    DELETE VtaVales.
                                    LEAVE COLUMNAS.
                                END.
                            END.
                        END CASE.
                    END.
                END.
            END.    /* FIN DE BARRIDO DE COLUMNAS */
        END.    /* FIN DE BARRIDO DE FILAS */
    END.    /* FIN DE TRANSACCION */

    /* liberar com-handles */
    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 

    HIDE FRAME F-PROCESO.
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      Vtavales.codcia = s-codcia.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' 
  THEN ASSIGN
            VtaVales.FlgEst = 'P'
            VtaVales.UsrCre = s-user-id
            VtaVales.FchCre = DATETIME(TODAY, MTIME).
  ELSE ASSIGN
            VtaVales.UsrAct = s-user-id
            VtaVales.FchAct = DATETIME(TODAY, MTIME).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Valida-Update.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

/*
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
*/
  /* Code placed here will execute AFTER standard behavior.    */
  FIND CURRENT VtaVales EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE VtaVales THEN RETURN 'ADM-ERROR'.
  ASSIGN
      VtaVales.FlgEst = 'A'
      VtaVales.FchAnu = DATETIME(TODAY, MTIME)
      VtaVales.UsrAnu = s-user-id.
  FIND CURRENT VtaVales NO-LOCK NO-ERROR.
  RUN dispatch IN THIS-PROCEDURE ('display-fields').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE VtaVales THEN DO WITH FRAME {&FRAME-NAME}:
      CASE VtaVales.FlgEst:
          WHEN 'P' THEN FILL-IN-Estado:SCREEN-VALUE = 'EMITIDO'.
          WHEN 'A' THEN FILL-IN-Estado:SCREEN-VALUE = 'ANULADO'.
          WHEN 'C' THEN FILL-IN-Estado:SCREEN-VALUE = 'APLICADO'.
          OTHERWISE FILL-IN-Estado:SCREEN-VALUE = '¿?'.
      END CASE.
      FIND gn-prov WHERE gn-prov.codcia = pv-codcia
          AND gn-prov.codpro = VtaVales.Libre_c01
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-prov THEN FILL-IN-NomPro:SCREEN-VALUE = gn-prov.nompro.
      ELSE FILL-IN-NomPro:SCREEN-VALUE = ''.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE VtaVales THEN DO WITH FRAME {&FRAME-NAME}:
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'NO' THEN VtaVales.NroDoc:SENSITIVE = NO.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "VtaVales"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.
  
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME} :
    IF Vtavales.nrodoc:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'Ingrese el número del vale' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO Vtavales.nrodoc.
        RETURN 'ADM-ERROR'.
    END.
    IF DECIMAL (Vtavales.impval:SCREEN-VALUE) <= 0 THEN DO:
        MESSAGE 'Ingrese el importe del vale' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO Vtavales.impval.
        RETURN 'ADM-ERROR'.
    END.
    IF VtaVales.Libre_c01:SCREEN-VALUE <> '' THEN DO:
        FIND gn-prov WHERE gn-prov.codcia = pv-codcia
            AND gn-prov.codpro = VtaVales.Libre_c01:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-prov THEN DO:
            MESSAGE 'Proveedor NO registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'entry' TO VtaVales.Libre_c01.
            RETURN 'ADM-ERROR'.
        END.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE VtaVales THEN RETURN 'ADM-ERROR'.
IF VtaVales.FlgEst <> 'P' THEN DO:
    MESSAGE 'Proceso abortado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

