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

DEF SHARED VAR s-codcia AS INTEGER.
DEF SHARED VAR cl-codcia AS INTEGER.

/* Local Variable Definitions ---                                       */
DEF TEMP-TABLE t-ddocu LIKE ccbddocu.
DEF TEMP-TABLE t-cdocu LIKE ccbcdocu.
DEF BUFFER b-cdocu FOR ccbcdocu.

DEF VAR x-codven AS CHAR NO-UNDO.
DEF VAR x-coddoc AS CHAR INIT 'FAC,BOL,N/C' NO-UNDO.
DEF VAR x-can AS INT.
DEF VAR x-imptot AS DEC.
DEF VAR x-coe AS DEC.
DEF VAR f-factor AS DEC.
DEF VAR x-NomDepto LIKE TabDepto.NomDepto.
DEF VAR x-NomProvi LIKE TabProvi.NomProvi.
DEF VAR x-NomDistr LIKE TabDistr.NomDistr.
DEF VAR x-Nombr LIKE gn-ConVt.Nombr.

/*Mensaje de Proceso*/
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

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
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 x-FchDoc-1 x-FchDoc-2 Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS x-FchDoc-1 x-FchDoc-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "IMG/b-cancel.bmp":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.4
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "IMG/excel.bmp":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.4
     BGCOLOR 8 .

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 2.69.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 59.14 BY 1.5
     BGCOLOR 7 FGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     x-FchDoc-1 AT ROW 2.35 COL 13 COLON-ALIGNED
     x-FchDoc-2 AT ROW 2.35 COL 29 COLON-ALIGNED
     Btn_OK AT ROW 5.04 COL 34
     Btn_Cancel AT ROW 5.04 COL 47
     "Rango de fechas" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 1.27 COL 7 WIDGET-ID 4
          FONT 6
     RECT-2 AT ROW 1.54 COL 6 WIDGET-ID 2
     RECT-3 AT ROW 5.04 COL 1 WIDGET-ID 6
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Supermercados"
         CANCEL-BUTTON Btn_Cancel.


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

{src/bin/_prns.i}
{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME L-To-R                                                    */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Supermercados */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    x-codven = '151'.   /* Autoservicios */
    /*x-codven = '173,015,042,902,901,308'.  */
    /*&SCOPED-DEFINE archivo c:\tmp\autoservicios2009.txt*/
    
    CARGA:
    FOR EACH ccbcdocu NO-LOCK WHERE codcia = s-CodCia
        AND fchdoc >= x-FchDoc-1
        AND fchdoc <= x-FchDoc-1
        AND flgest <> 'a'
        AND LOOKUP(codven, x-codven) > 0
        AND LOOKUP(coddoc, x-coddoc) > 0:
        CREATE t-cdocu.
        BUFFER-COPY ccbcdocu TO t-cdocu.
        IF CcbCdocu.Coddoc = "N/C" AND CcbCdocu.CndCre = "N" THEN DO:
            RUN PROCESA-NOTA.
            NEXT CARGA.
        END.
        FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
            IF Ccbddocu.implin <= 0 THEN NEXT.       /* <<< OJO <<< */
            CREATE t-ddocu.
            BUFFER-COPY ccbddocu TO t-ddocu.
            IF ccbcdocu.coddoc = 'N/C' 
            THEN ASSIGN
                    t-ddocu.implin = -1 * t-ddocu.implin
                    t-ddocu.candes = -1 * t-ddocu.candes.
        END.
    END.
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
  DISPLAY x-FchDoc-1 x-FchDoc-2 
      WITH FRAME D-Dialog.
  ENABLE RECT-2 RECT-3 x-FchDoc-1 x-FchDoc-2 Btn_OK Btn_Cancel 
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
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 5.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

DEFINE VARIABLE x-DesMat AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-DesMar AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-Und    AS CHARACTER   NO-UNDO.

RUN Carga-Temporal.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Header del Excel */
cRange = "J" + '2'.
chWorkSheet:Range(cRange):Value = "LISTADO DE INVENTARIO".
cRange = "A" + '3'.
chWorkSheet:Range(cRange):Value = 'Desde:'.
cRange = "B" + '3'.
chWorkSheet:Range(cRange):Value = x-FchDoc-1.
cRange = "D" + '3'.
chWorkSheet:Range(cRange):Value = 'Hasta:'.
cRange = "E" + '3'.
chWorkSheet:Range(cRange):Value = x-FchDoc-2.


/*Formato*/
chWorkSheet:Columns("A"):NumberFormat  = "@".
chWorkSheet:Columns("B"):NumberFormat  = "@".
chWorkSheet:Columns("E"):NumberFormat  = "@".
chWorkSheet:Columns("H"):NumberFormat  = "@".
chWorkSheet:Columns("I"):NumberFormat  = "@".
chWorkSheet:Columns("K"):NumberFormat  = "@".
chWorkSheet:Columns("Q"):NumberFormat  = "@".
chWorkSheet:Columns("T"):NumberFormat  = "@".
chWorkSheet:Columns("V"):NumberFormat  = "@".
chWorkSheet:Columns("AC"):NumberFormat = "@".
chWorkSheet:Columns("AE"):NumberFormat = "@".
chWorkSheet:Columns("AG"):NumberFormat = "@".

/* set the column names for the Worksheet */
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = 'Div'.
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = 'CodVen'.
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = 'Vendedor'.
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = 'CodDoc'.
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = 'NroDoc'.
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = 'FchDoc'.
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = 'CodRef'.
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = 'NroRef'.
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = 'CodCli'.
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = 'NomCli'.
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = 'Forma Pago'.
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = 'Descripción'.
cRange = "M" + cColumn.
chWorkSheet:Range(cRange):Value = 'Glosa'.
cRange = "N" + cColumn.
chWorkSheet:Range(cRange):Value = 'Mon'.
cRange = "O" + cColumn.
chWorkSheet:Range(cRange):Value = 'Tpo Cambio'.
cRange = "P" + cColumn.
chWorkSheet:Range(cRange):Value = '% IGV'.
cRange = "Q" + cColumn.
chWorkSheet:Range(cRange):Value = 'CodMat'.
cRange = "R" + cColumn.
chWorkSheet:Range(cRange):Value = 'Descripción'.
cRange = "S" + cColumn.
chWorkSheet:Range(cRange):Value = 'Marca'.
cRange = "T" + cColumn.
chWorkSheet:Range(cRange):Value = 'CodFam'.
cRange = "U" + cColumn.
chWorkSheet:Range(cRange):Value = 'Familia'.
cRange = "V" + cColumn.
chWorkSheet:Range(cRange):Value = 'subFam'.
cRange = "W" + cColumn.
chWorkSheet:Range(cRange):Value = 'SubFamilia'.
cRange = "X" + cColumn.
chWorkSheet:Range(cRange):Value = 'Cant. Despachada'.
cRange = "Y" + cColumn.
chWorkSheet:Range(cRange):Value = 'UndVta'.
cRange = "Z" + cColumn.
chWorkSheet:Range(cRange):Value = 'Precio Unitario'.
cRange = "AA" + cColumn.
chWorkSheet:Range(cRange):Value = 'Afecta IGV'.
cRange = "AB" + cColumn.
chWorkSheet:Range(cRange):Value = 'Imp. Linea'.
cRange = "AC" + cColumn.
chWorkSheet:Range(cRange):Value = 'Cod. Dept.'.
cRange = "AD" + cColumn.
chWorkSheet:Range(cRange):Value = 'Departamento'.
cRange = "AE" + cColumn.
chWorkSheet:Range(cRange):Value = 'CodProv'.
cRange = "AF" + cColumn.
chWorkSheet:Range(cRange):Value = 'Provincia'.
cRange = "AG" + cColumn.
chWorkSheet:Range(cRange):Value = 'CodDist'.
cRange = "AH" + cColumn.
chWorkSheet:Range(cRange):Value = 'Distrito'.

    /*OUTPUT TO {&archivo}.*/
    FOR EACH t-cdocu NO-LOCK,
        EACH t-ddocu OF t-cdocu NO-LOCK,
        FIRST almmmatg OF t-ddocu NO-LOCK,
        FIRST almtfami OF almmmatg NO-LOCK,
        FIRST almsfami OF almmmatg NO-LOCK,
        FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = t-cdocu.codcli,
        FIRST gn-ven OF t-cdocu NO-LOCK:
        ASSIGN
            x-nomdepto = ''
            x-nomprovi = ''
            x-nomdistr = ''
            x-nombr = ''.
        FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.coddept
            NO-LOCK NO-ERROR.
        IF AVAILABLE tabdepto THEN x-nomdepto = tabdepto.nomdepto.
        FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.coddept
            AND TabProvi.CodProvi = gn-clie.CodProv
            NO-LOCK NO-ERROR.
        IF AVAILABLE TabProvi THEN x-nomprovi = tabprovi.nomprovi.
        FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.coddept
            AND TabDistr.CodProvi = gn-clie.codprov
            AND TabDistr.CodDistr = gn-clie.CodDist
            NO-LOCK NO-ERROR.
        IF AVAILABLE TabDistr THEN x-nomdistr = tabdistr.nomdistr.
        FIND gn-convt WHERE gn-convt.codig = t-cdocu.fmapgo NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt THEN x-nombr = gn-convt.nombr.

        t-Column = t-Column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = t-cdocu.coddiv.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = t-cdocu.codven.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = gn-ven.NomVen.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = t-cdocu.coddoc.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = t-cdocu.nrodoc.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = t-cdocu.fchdoc.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = t-cdocu.codref.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = t-cdocu.nroref.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = t-cdocu.codcli.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = t-cdocu.nomcli.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = t-cdocu.fmapgo.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = x-Nombr.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = t-cdocu.glosa.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = t-cdocu.codmon.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = t-cdocu.tpocmb.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = t-cdocu.porigv.
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = t-ddocu.codmat.
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = desmat.
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = desmar.
        cRange = "T" + cColumn.
        chWorkSheet:Range(cRange):Value = almmmatg.codfam.
        cRange = "U" + cColumn.
        chWorkSheet:Range(cRange):Value = Almtfami.desfam.
        cRange = "V" + cColumn.
        chWorkSheet:Range(cRange):Value = almmmatg.subfam.
        cRange = "W" + cColumn.
        chWorkSheet:Range(cRange):Value = AlmSFami.dessub.
        cRange = "X" + cColumn.
        chWorkSheet:Range(cRange):Value = t-ddocu.candes.
        cRange = "Y" + cColumn.
        chWorkSheet:Range(cRange):Value = t-ddocu.undvta.
        cRange = "Z" + cColumn.
        chWorkSheet:Range(cRange):Value = t-ddocu.preuni.
        cRange = "AA" + cColumn.
        chWorkSheet:Range(cRange):Value = t-ddocu.aftigv.
        cRange = "AB" + cColumn.
        chWorkSheet:Range(cRange):Value = t-ddocu.implin.
        cRange = "AC" + cColumn.
        chWorkSheet:Range(cRange):Value = gn-clie.CodDept.
        cRange = "AD" + cColumn.
        chWorkSheet:Range(cRange):Value = x-nomdepto.
        cRange = "AE" + cColumn.
        chWorkSheet:Range(cRange):Value = gn-clie.CodProv.
        cRange = "AF" + cColumn.
        chWorkSheet:Range(cRange):Value = x-nomprovi.
        cRange = "AG" + cColumn.
        chWorkSheet:Range(cRange):Value = gn-clie.CodDist.
        cRange = "AH" + cColumn.
        chWorkSheet:Range(cRange):Value = x-nomdistr.
        DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
    END.
    /*OUTPUT CLOSE.*/

HIDE FRAME F-Proceso.

/* launch Excel so it is visible to the user */
 chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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
  ASSIGN
    x-FchDoc-1 = TODAY - DAY(TODAY) + 1
    x-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Nota D-Dialog 
PROCEDURE Procesa-Nota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    x-can = 1.
    FIND B-CDOCU WHERE B-CDOCU.Codcia = CcbCdocu.Codcia AND
                       B-CDOCU.CodDoc = CcbCdocu.Codref AND
                       B-CDOCU.NroDoc = CcbCdocu.Nroref 
                       NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN RETURN.
    x-ImpTot = B-CDOCU.ImpTot.     /* <<< OJO <<< */
    /* buscamos si hay una aplicación de fact adelantada */
    FIND FIRST Ccbddocu OF B-CDOCU WHERE Ccbddocu.implin < 0 NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbddocu THEN x-ImpTot = x-ImpTot + ABSOLUTE(Ccbddocu.ImpLin).
    x-coe = Ccbcdocu.ImpTot / x-ImpTot.
    FOR EACH CcbDdocu OF B-CDOCU NO-LOCK:
        FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia AND
                            Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN NEXT.
        IF Ccbddocu.implin <= 0 THEN NEXT.       /* <<< OJO <<< */
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                            Almtconv.Codalter = Ccbddocu.UndVta
                            NO-LOCK NO-ERROR.
        F-FACTOR  = 1. 
        IF AVAILABLE Almtconv THEN DO:
           F-FACTOR = Almtconv.Equival.
           IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
        END.
        CREATE t-ddocu.
        BUFFER-COPY ccbddocu TO t-ddocu
            ASSIGN
                t-ddocu.coddiv = ccbcdocu.coddiv
                t-ddocu.coddoc = ccbcdocu.coddoc
                t-ddocu.nrodoc = ccbcdocu.nrodoc
                t-ddocu.implin = CcbDdocu.ImpLin * x-coe
                t-ddocu.candes = CcbDdocu.CanDes * x-can * f-Factor.
        ASSIGN
            t-ddocu.implin = -1 * t-ddocu.implin
            t-ddocu.candes = -1 * t-ddocu.candes.
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

