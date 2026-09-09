&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-periodo AS INT.
DEF SHARED VAR s-nromes AS INT.

DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6 SKIP
    Fi-Mensaje NO-LABEL FONT 6 SKIP     
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 
        TITLE "Procesando ..." FONT 7.

DEF STREAM REPORTE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-Periodo Btn_OK x-NroMes Btn_Cancel ~
x-Estado x-Tipo Btn_Excel 
&Scoped-Define DISPLAYED-OBJECTS x-Periodo x-NroMes x-Estado x-Tipo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 11 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 11 BY 1.5 TOOLTIP "Genera archivo texto"
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Aceptar" 
     SIZE 11 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE x-NroMes AS CHARACTER FORMAT "X(2)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE x-Periodo AS CHARACTER FORMAT "x(4)":U INITIAL "          0" 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "1900" 
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE x-Estado AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Activos", 1,
"Anulados", 2,
"Todos", 3
     SIZE 12 BY 3 NO-UNDO.

DEFINE VARIABLE x-Tipo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Resumido", 1,
"Detallado", 2
     SIZE 12 BY 1.62 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     x-Periodo AT ROW 1.58 COL 15 COLON-ALIGNED
     Btn_OK AT ROW 1.77 COL 52
     x-NroMes AT ROW 2.54 COL 15 COLON-ALIGNED
     Btn_Cancel AT ROW 2.92 COL 52
     x-Estado AT ROW 3.5 COL 17 NO-LABEL
     x-Tipo AT ROW 3.69 COL 32 NO-LABEL WIDGET-ID 2
     Btn_Excel AT ROW 4.85 COL 52
     "Estado:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 3.5 COL 11
     SPACE(48.13) SKIP(3.57)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "REPORTE DE VOUCHERS DE BANCO EGRESOS"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* REPORTE DE VOUCHERS DE BANCO EGRESOS */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel D-Dialog
ON CHOOSE OF Btn_Excel IN FRAME D-Dialog /* Excel */
DO:

    ASSIGN x-Estado x-NroMes x-Periodo x-Tipo.

    CASE x-Tipo:
        WHEN 1 THEN RUN Excel.
        WHEN 2 THEN RUN Excel-2.
    END CASE.
    


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN
    x-Estado x-NroMes x-Periodo.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY x-Periodo x-NroMes x-Estado x-Tipo 
      WITH FRAME D-Dialog.
  ENABLE x-Periodo Btn_OK x-NroMes Btn_Cancel x-Estado x-Tipo Btn_Excel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel D-Dialog 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1.
    DEFINE VARIABLE cColumn            AS CHARACTER.
    DEFINE VARIABLE cRange             AS CHARACTER.

    DEF VAR pPeriodo LIKE Cb-cmov.Periodo NO-UNDO.
    DEF VAR pNroMes  LIKE Cb-cmov.NroMes  NO-UNDO.
    DEF VAR pFlgEst  LIKE Cb-cmov.FlgEst  NO-UNDO.
   
    pPeriodo = INTEGER(x-Periodo).
    pNroMes = INTEGER(x-NroMes).

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* set the column names for the Worksheet */
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "VOUCHERS DE BANCO EGRESOS".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value =
        "PERIODO: " + STRING(pPeriodo,"9999") + 
        " MES: " + STRING(pNroMes,"99").
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "ASIENTO".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "FECHA".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "NOTA".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "ESTADO".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "MONEDA".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "IMPORTE".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "USUARIO".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "CTA CAJA".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "NRO".

    chWorkSheet:Columns("A"):NumberFormat = "@".
    chWorkSheet:Columns("C"):ColumnWidth = 70.
    chWorkSheet:Columns("H"):NumberFormat = "@".
    chWorkSheet:Columns("I"):NumberFormat = "@".
    chWorkSheet:Columns("J"):NumberFormat = "@".
    chWorkSheet:Range("A1:J3"):Font:Bold = TRUE.

    FOR EACH cb-cmov WHERE
        cb-cmov.codcia = s-codcia AND
        cb-cmov.periodo = pPeriodo AND
        cb-cmov.nromes = pNroMes AND
        cb-cmov.codope = '002' AND
        (x-Estado = 3 OR (x-Estado = 1 AND cb-cmov.flgest <> 'A') OR
        (x-Estado = 2 AND cb-cmov.flgest = 'A')) NO-LOCK:

        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = cb-cmov.nroast.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = cb-cmov.fchast.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = cb-cmov.notast.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value =
            IF cb-cmov.flgest = "A" THEN "ANULADO" ELSE "".
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value =
            IF cb-cmov.codmon = 1 THEN "S/." ELSE "US$".
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = cb-cmov.impchq.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = cb-cmov.usuario.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = cb-cmov.ctacja.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = cb-cmov.coddoc.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = cb-cmov.Nrochq.

        DISPLAY
            "   Asiento: " + cb-cmov.nroast @ FI-MENSAJE
            WITH FRAME F-PROCESO.

    END.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    HIDE FRAME F-PROCESO.
    MESSAGE
        "Proceso Terminado con suceso"
        VIEW-AS ALERT-BOX INFORMA.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-2 D-Dialog 
PROCEDURE Excel-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-Llave AS CHAR FORMAT 'x(1000)' NO-UNDO.
    DEF VAR x-Titulo AS CHAR FORMAT 'x(1000)' NO-UNDO.
    DEF VAR x-Archivo AS CHAR NO-UNDO.
    DEF VAR pPeriodo LIKE Cb-cmov.Periodo NO-UNDO.
    DEF VAR pNroMes  LIKE Cb-cmov.NroMes  NO-UNDO.
    DEF VAR pFlgEst  LIKE Cb-cmov.FlgEst  NO-UNDO.
   
    x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

    ASSIGN
        pPeriodo = INTEGER(x-Periodo)
        pNroMes = INTEGER(x-NroMes)
        x-Llave = ''
        x-Titulo = 'Voucher|Fecha|Nota|Estado|Moneda|Total|Usuario|Cuenta Caja|Doc|Numero|' +
                    'Cuenta|Auxiliar|Cod Doc|NUm Doc|Detalle|Mov|Imp Soles|Imp Dolares|Comp Retencion|' +
                    'Tpo Cambio|Division|'.
    x-Titulo = REPLACE(x-Titulo, '|', CHR(9)).
    OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
    PUT STREAM REPORTE x-Titulo SKIP.
    FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.codcia = s-codcia 
        AND cb-cmov.periodo = pPeriodo 
        AND cb-cmov.nromes = pNroMes 
        AND cb-cmov.codope = '002' 
        AND (x-Estado = 3 OR (x-Estado = 1 AND cb-cmov.flgest <> 'A') OR
             (x-Estado = 2 AND cb-cmov.flgest = 'A')),
        EACH cb-dmov OF cb-cmov NO-LOCK:
        x-Llave = cb-cmov.nroast + '|'.
        x-Llave = x-Llave + STRING (cb-cmov.fchast, '99/99/9999') + '|'.
        x-Llave = x-Llave + cb-cmov.notast + '|'.
        x-Llave = x-Llave + ( IF cb-cmov.flgest = "A" THEN "ANULADO" ELSE "") + '|'.
        x-Llave = x-Llave + ( IF cb-cmov.codmon = 1 THEN "S/." ELSE "US$") + '|'.
        x-Llave = x-Llave + STRING (cb-cmov.impchq, '>>>,>>>,>>9.99') + '|'.
        x-Llave = x-Llave + cb-cmov.usuario + '|'.
        x-Llave = x-Llave + cb-cmov.ctacja + '|'.
        x-Llave = x-Llave + cb-cmov.coddoc + '|'.
        x-Llave = x-Llave + cb-cmov.Nrochq + '|'.
        x-Llave = x-Llave + cb-dmov.codcta + '|'.
        x-Llave = x-Llave + cb-dmov.codaux + '|'.
        x-Llave = x-Llave + cb-dmov.coddoc + '|'.
        x-Llave = x-Llave + cb-dmov.nrodoc + '|'.
        x-Llave = x-Llave + cb-dmov.glodoc + '|'.
        x-Llave = x-Llave + ( IF cb-dmov.tpomov = YES THEN 'Haber' ELSE 'Debe') + '|'.
        x-Llave = x-Llave + STRING (cb-dmov.impmn1, '>>>,>>>,>>9.99') + '|'.
        x-Llave = x-Llave + STRING (cb-dmov.impmn2, '>>>,>>>,>>9.99') + '|'.
        x-Llave = x-Llave + cb-dmov.CHR_01 + '|'.
        x-Llave = x-Llave + STRING (cb-dmov.tpocmb, '>>>,>>>,>>9.99') + '|'.
        x-Llave = x-Llave + cb-dmov.coddiv + '|'.
        x-Llave = REPLACE(x-Llave, '|', CHR(9)).
        PUT STREAM REPORTE x-LLave SKIP.
    END.
    OUTPUT STREAM REPORTE CLOSE.
    /* CARGAMOS EL EXCEL */
    RUN lib/filetext-to-excel(x-Archivo, 'Detallado', YES).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir D-Dialog 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR pPeriodo LIKE Cb-cmov.Periodo NO-UNDO.
  DEF VAR pNroMes  LIKE Cb-cmov.NroMes  NO-UNDO.
  DEF VAR pFlgEst  LIKE Cb-cmov.FlgEst  NO-UNDO.
   
  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */
  
  pPeriodo = INTEGER(x-Periodo).
  pNroMes = INTEGER(x-NroMes).

  GET-KEY-VALUE SECTION 'Startup' KEY 'Base' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'cbd/rbcbd.prl'.
  RB-REPORT-NAME = 'Vouchers Banco Egresos'.
  RB-INCLUDE-RECORDS = "O".
  RB-FILTER = "cb-cmov.codcia = " + STRING(s-codcia) +
                " AND cb-cmov.periodo = " + STRING(pPeriodo) +
                " AND cb-cmov.nromes = " + STRING(pNroMes) +
                " AND cb-cmov.codope = '002'".
  CASE x-Estado:
    WHEN 1 THEN RB-FILTER = RB-FILTER + " AND cb-cmov.flgest <> 'A'".
    WHEN 2 THEN RB-FILTER = RB-FILTER + " AND cb-cmov.flgest = 'A'".
  END CASE.
  
  RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia.

  RUN lib/_Imprime2 (RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-OTHER-PARAMETERS).
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Cb-Peri NO-LOCK WHERE Cb-Peri.codcia = s-codcia:
        x-Periodo:ADD-LAST(STRING(Cb-Peri.Periodo, '9999')).
    END.
    ASSIGN
        x-Periodo:SCREEN-VALUE = STRING(s-Periodo, '9999')
        x-NroMes:SCREEN-VALUE = STRING(s-NroMes, '99').
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

