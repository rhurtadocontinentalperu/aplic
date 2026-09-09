&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.

DEF VAR s-task-no AS INT INITIAL 0 NO-UNDO.
DEF VAR s-titulo AS CHAR NO-UNDO.
DEF VAR s-subtit AS CHAR NO-UNDO.
DEF VAR s-Estado AS CHAR NO-UNDO.

/* VARIABLES A USAR */
/* Variables compartidas */
DEFINE new SHARED VAR s-pagina-final AS INTEGER.
DEFINE new SHARED VAR s-pagina-inicial AS INTEGER.
DEFINE new SHARED VAR s-salida-impresion AS INTEGER.
DEFINE new SHARED VAR s-printer-name AS CHAR.
DEFINE new SHARED VAR s-print-file AS CHAR.
DEFINE new SHARED VAR s-nro-copias AS INTEGER.
DEFINE new SHARED VAR s-orientacion AS INTEGER.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "vta/rbvta.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Estado-Cuenta-Tarjeta-Conti".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.
RB-REPORT-LIBRARY = s-report-library + "vta\rbvta.prl".

DEF VAR X-FLG AS LOGICAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-26 RECT-27 RECT-28 RECT-3 ~
F-nrocar F-unival RADIO-SET-Formato TOGGLE-1 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-nrocar f-fecini f-fecfin F-unival ~
RADIO-SET-Formato TOGGLE-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Ca&ncelar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "&Aceptar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE f-fecfin AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE f-fecini AS DATE FORMAT "99/99/9999":U 
     LABEL "De" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE F-nrocar AS CHARACTER FORMAT "X(6)":U 
     LABEL "Nro Tarjeta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE F-unival AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Formato AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Papel Blanco", 1,
"Pre-Impreso", 2
     SIZE 25 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35.43 BY 1.38.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35.29 BY 2.42.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35.29 BY 1.62.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35 BY 2.31.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 14.86 BY 9.04.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Mostrar el nombre del cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-nrocar AT ROW 1.58 COL 9 COLON-ALIGNED
     f-fecini AT ROW 3.31 COL 9 COLON-ALIGNED
     f-fecfin AT ROW 4.35 COL 9 COLON-ALIGNED
     F-unival AT ROW 6.27 COL 9 COLON-ALIGNED NO-LABEL
     RADIO-SET-Formato AT ROW 8.31 COL 5 NO-LABEL
     TOGGLE-1 AT ROW 9.27 COL 5
     Btn_OK AT ROW 3.04 COL 40.14
     Btn_Cancel AT ROW 4.23 COL 40.14
     RECT-1 AT ROW 1.19 COL 2
     RECT-26 AT ROW 2.92 COL 2
     RECT-27 AT ROW 5.81 COL 2
     RECT-28 AT ROW 7.92 COL 2
     RECT-3 AT ROW 1.19 COL 38.72
     "Valor Unitario del Vale de Compra" VIEW-AS TEXT
          SIZE 23.57 BY .5 AT ROW 5.54 COL 3
     "* Solo facturas canceladas al 30 de abril" VIEW-AS TEXT
          SIZE 36.14 BY .5 AT ROW 10.62 COL 2
          FONT 6
     "Periodo de Facturacion" VIEW-AS TEXT
          SIZE 20.72 BY .5 AT ROW 2.62 COL 3.14
     "Formato de Impresion" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 7.73 COL 3
     SPACE(35.99) SKIP(3.45)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Estado de Cuenta de Tarjeta Cliente Exclusivo *"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   Custom                                                               */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN f-fecfin IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-fecini IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Estado de Cuenta de Tarjeta Cliente Exclusivo * */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN F-Nrocar f-fecini f-fecfin f-unival RADIO-SET-Formato TOGGLE-1.
  
  IF F-NroCar = "" THEN DO:    
     MESSAGE "Digite numero de tarjeta" 
     VIEW-AS ALERT-BOX WARNING.
     APPLY "ENTRY" TO F-Nrocar.
     RETURN NO-APPLY.
  END.
  IF f-unival = 0
  THEN DO:
    MESSAGE "Ingrese el valor unitario del vale de compra"
        VIEW-AS ALERT-BOX WARNING.
    APPLY "ENTRY":U TO f-unival.
    RETURN NO-APPLY.
  END.
  /*RUN Estado.*/
  
  RUN Imprimir.
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-nrocar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-nrocar D-Dialog
ON LEAVE OF F-nrocar IN FRAME D-Dialog /* Nro Tarjeta */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.

     IF NOT AVAILABLE Gn-Card THEN DO:
        MESSAGE "Numero de Tarjeta No Existe...."
        VIEW-AS ALERT-BOX .
        RETURN NO-APPLY.
  
     END.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-impnac AS DECI.
DEFINE VAR x-impusa AS DECI.
DEFINE VAR x-imptot AS DECI.
DEFINE VAR x-signo  AS DECI.

FOR EACH Gn-Divi NO-LOCK WHERE  
          Gn-Divi.Codcia = S-CODCIA /*AND
          Gn-Divi.CodDiv BEGINS F-Division*/:
          
 FOR EACH CcbCdocu NO-LOCK WHERE 
          CcbCdocu.CodCia = S-CODCIA AND
          CcbCdocu.CodDiv = Gn-Divi.CodDiv AND
          CCbCdocu.FchDoc >= f-fecini AND 
          CcbCdocu.FchDoc <= f-fecfin AND
          LOOKUP(CcbCdocu.CodDoc,"FAC,BOL,N/C,N/D,TCK") > 0 AND 
          CcbCdocu.FlgEst <> "A" AND
          CcbCdocu.NroCard = f-nrocar USE-INDEX LLAVE10:
      
        x-impnac = 0.
        x-impusa = 0.
        x-imptot = 0.
    
        x-signo = if ccbcdocu.coddoc = "N/C" then -1 else 1.
        if ccbcdocu.codmon = 1 then x-impnac = ccbcdocu.imptot * x-signo.
        if ccbcdocu.codmon = 2 then x-impusa = ccbcdocu.imptot * x-signo.
        
        x-imptot = x-impnac + x-impusa * ccbcdocu.tpocmb.

        IF s-task-no = 0
        THEN REPEAT:
            s-task-no = RANDOM(1, 999999).
            IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no 
                                            AND  w-report.Llave-C = s-user-id 
                                           NO-LOCK)
            THEN LEAVE.
        END.
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Campo-I[1] = s-codcia 
            w-report.Campo-F[1] = x-impnac
            w-report.Campo-F[2] = x-impusa
            w-report.Campo-F[3] = x-imptot
            w-report.Campo-D[1] = ccbcdocu.fchdoc
            w-report.Campo-C[1] = ccbcdocu.coddoc
            w-report.Campo-C[2] = ccbcdocu.nrodoc
            w-report.Campo-C[3] = gn-divi.desdiv        
            w-report.Campo-C[4] = ccbcdocu.codcli.

 END.
END.

X-FLG = FALSE.
FOR EACH w-report WHERE w-report.task-no = s-task-no AND  
                        w-report.Llave-C = s-user-id :


       FIND FIRST CcbCdocu WHERE CcbCdocu.Codcia = s-codcia AND
                           CcbCdocu.Codcli = w-report.Campo-C[4] AND
                           Ccbcdocu.FlgEst = "P" AND
                           LOOKUP(CcbCdocu.CodDoc,"FAC,N/D,TCK,LET,CHQ,CHC,CHD") > 0 
                           USE-INDEX LLAVE06 NO-LOCK NO-ERROR.
                           
       IF AVAILABLE CcbCdocu THEN  DO:
          X-FLG = TRUE.   
          LEAVE.         
       END.   
           
END.
IF X-FLG THEN   FOR EACH w-report WHERE w-report.task-no = s-task-no 
                        AND  w-report.Llave-C = s-user-id:
                        DELETE w-report.
                END.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY F-nrocar f-fecini f-fecfin F-unival RADIO-SET-Formato TOGGLE-1 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 RECT-26 RECT-27 RECT-28 RECT-3 F-nrocar F-unival 
         RADIO-SET-Formato TOGGLE-1 Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Estado D-Dialog 
PROCEDURE Estado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  RUN Carga-Temporal.
  
  FIND FIRST w-report WHERE w-report.task-no = s-task-no 
                       AND  w-report.Llave-C = s-user-id 
                      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE w-report
  THEN DO:
      MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
      RETURN.
  END.
    
  RUN Genera-Excel.
    
  FOR EACH w-report WHERE w-report.task-no = s-task-no 
                        AND  w-report.Llave-C = s-user-id:
      DELETE w-report.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel D-Dialog 
PROCEDURE Genera-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO:
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE nom_archivo             AS CHAR.

DEFINE VARIABLE iCount                  AS INTEGER init 15.
DEFINE VARIABLE t-Column                AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.

/*
/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).
*/


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

chWorkbook = chExcelApplication:Workbooks:Open("c:\Mis documentos\estado.xls").

chWorkSheet = chExcelApplication:Sheets:Item(1).

/* Datos de Cabecera */
/*
chWorkSheet:Range("A6"):Font:Bold = TRUE.
chWorkSheet:Range("A6"):Font:Name = "Arial".
chWorkSheet:Range("A6"):Font:Size = 11.

chWorkSheet:Range("A7"):Font:Bold = FALSE.
chWorkSheet:Range("A6"):Font:Name = "Arial".
chWorkSheet:Range("A6"):Font:Size = 11.

chWorkSheet:Range("D5"):Font:Bold = TRUE.
chWorkSheet:Range("D5"):Font:Name = "Arial".
chWorkSheet:Range("D5"):Font:Size = 11.

chWorkSheet:Range("C10"):Font:Bold = FALSE.
chWorkSheet:Range("C10"):Font:Name = "Arial".
chWorkSheet:Range("C10"):Font:Size = 10.
*/

chWorkSheet:Range("A6"):Value = gn-card.NomClie[1] .
chWorkSheet:Range("A8"):Value = gn-card.Dir[1] .
chWorkSheet:Range("D5"):Value = "Nº de Tarjeta : " + f-nrocar .
chWorkSheet:Range("C10"):Value = STRING(F-FECINI,"99/99/9999") + " AL " + STRING(F-FECFIN,"99/99/9999") .



/* Recorriendo el temporal */
FOR EACH w-report WHERE w-report.task-no = s-task-no AND
                        w-report.Llave-C = s-user-id 
                        BREAK BY Campo-D[1] :
                        
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.Campo-D[1].
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.Campo-C[1] + " - "  + w-report.Campo-C[2].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.Campo-C[3].
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.Campo-F[1].
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.Campo-F[1].
  
    
    iCount = iCount + 1.

END.                        
/***************************/


/*Imprimiendo */
/*
chExcelApplication:ActiveWindow:SelectedSheets:PrintOut().
*/

nom_archivo = "estado" + f-nrocar .


chExcelApplication:ActiveWorkbook:SaveAs("C:\Mis documentos\" + nom_archivo,,,,,,).


chExcelApplication:Quit().

RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chChart NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 


END.

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
    
  /* LOGICA PRINCIPAL */
  /* Pantalla general de parametros de impresion */
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.

  /*RUN Carga-Temporal.*/
  
  s-task-no = 2003 * 1000 + s-codcia.
  s-task-no = 999999.
  FIND FIRST w-report WHERE w-report.task-no = s-task-no 
    AND  w-report.Llave-C = f-nrocar 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE w-report
  THEN DO:
      MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
      RETURN.
  END.
  /* ACTUALIZAMOS EL FLGEST */
  FOR EACH w-report WHERE task-no = s-task-no   
        AND llave-c = f-nrocar:
    FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia 
        AND ccbcdocu.coddoc = campo-c[1]
        AND ccbcdocu.nrodoc = campo-c[2] NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu
    THEN w-report.campo-c[5] = ccbcdocu.flgest.
  END.
  /* ¿TIENE ALGUN PENDIENTE? */
  FIND FIRST w-report WHERE task-no = s-task-no
    AND llave-c = f-nrocar
    AND LOOKUP(campo-c[1], 'FAC,BOL,N/D,TCK') > 0
    AND campo-c[5] <> 'C' NO-LOCK NO-ERROR.
  IF AVAILABLE w-report
  THEN s-Estado = "PENDIENTE".
  ELSE s-Estado = "".

  CASE RADIO-SET-Formato:
  WHEN 1 THEN RB-REPORT-NAME = "Estado-Cuenta-Tarjeta-Conti".
  WHEN 2 THEN RB-REPORT-NAME = "Estado-Cuenta-Tarjeta-Conti-2".
  END CASE.
  /* OJO */
  IF TOGGLE-1 = YES THEN RB-REPORT-NAME = "Estado-Cuenta-Tarjeta-Conti-3".
  
  /* test de impresion */
  RB-INCLUDE-RECORDS = "O".
  RB-FILTER = "w-report.task-no = " + STRING(s-task-no) +
              " AND w-report.Llave-C = '" + f-nrocar + "'".  
  RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
                        "~nf-nrocar = " + f-nrocar +
                        "~nx-nomcar = " + gn-card.NomClie[1] +
                        "~nx-dircar = " + gn-card.dir[1] +
                        "~nx-valuni = " + string(f-unival) +
                        "~nf-fecini = " + string(f-fecini,"99/99/9999") +
                        "~nf-fecfin = " + string(f-fecfin,"99/99/9999") +
                        "~ns-estado = " + s-estado.
                        
  /* Captura parametros de impresion */
  ASSIGN
      RB-BEGIN-PAGE = s-pagina-inicial
      RB-END-PAGE = s-pagina-final
      RB-PRINTER-NAME = s-printer-name
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = s-nro-copias.
  CASE s-salida-impresion:
      WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
      WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
      WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
  END CASE.
  
  RUN aderb/_printrb (RB-REPORT-LIBRARY,
                      RB-REPORT-NAME,
                      RB-DB-CONNECTION,
                      RB-INCLUDE-RECORDS,
                      RB-FILTER,
                      RB-MEMO-FILE,
                      RB-PRINT-DESTINATION,
                      RB-PRINTER-NAME,
                      RB-PRINTER-PORT,
                      RB-OUTPUT-FILE,
                      RB-NUMBER-COPIES,
                      RB-BEGIN-PAGE,
                      RB-END-PAGE,
                      RB-TEST-PATTERN,
                      RB-WINDOW-TITLE,
                      RB-DISPLAY-ERRORS,
                      RB-DISPLAY-STATUS,
                      RB-NO-WAIT,
                      RB-OTHER-PARAMETERS).    
    
/* NO SE DEBE BORRAR */
/*  DELETE FROM w-report WHERE w-report.task-no = s-task-no 
    AND  w-report.Llave-C = s-user-id.*/
    
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
  /* RHC 06.05.04 NUEVO RANGO PARA EL AÑO 2004
  ASSIGN 
   f-fecini = 02/01/2003 .
   f-fecfin = 04/30/2003 .
  */
  ASSIGN 
   f-fecini = DATE(01,26,2004)
   f-fecfin = DATE(04,30,2004).
  
   DO WITH FRAME {&FRAME-NAME}:
      DISPLAY F-fecini F-fecfin.
   END.
   
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
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


