&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w

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

DEFINE SHARED VAR s-CodCia  AS INTEGER.
DEFINE SHARED VAR Cb-CodCia AS INTEGER.
DEFINE SHARED VAR pv-codcia AS INTEGER.
DEFINE SHARED VAR s-NroMes  AS INTEGER.
DEFINE SHARED VAR s-NomCia  AS CHARACTER.
DEFINE SHARED VAR s-Periodo  AS INTEGER.

/* Definimos Variables de impresoras */


/* Local Variable Definitions ---                                       */

DEFINE VARIABLE C-FLGEST AS CHAR NO-UNDO.
DEFINE STREAM REPORT.

DEFINE VAR C-BIMP AS CHAR.
DEFINE VAR C-ISC  AS CHAR.
DEFINE VAR C-IGV  AS CHAR.
DEFINE VAR C-TOT  AS CHAR.

/* BUSCANDO LAS CONFIGURACIONES DEL LIBRO DE VENTAS */


DEFINE VAR x-CodDiv AS CHAR.
DEFINE VAR x-NroAst AS CHAR.
DEFINE VAR x-FchDoc AS DATE.
DEFINE VAR x-FchVto AS DATE.
DEFINE VAR x-CodDoc AS CHAR.
DEFINE VAR x-NroDoc AS CHAR.
DEFINE VAR x-Ruc    AS CHAR.
DEFINE VAR x-NomCli AS CHAR.
DEFINE VAR x-Import AS DECIMAL EXTENT 10.
DEFINE VAR x-CodRef AS CHAR.
DEFINE VAR x-NroRef AS CHAR.
DEFINE VAR x-CodMon AS CHAR.
DEFINE VAR x-CodOpe AS CHAR.
DEFINE VAR x-TpoCmb AS DECIMAL.

DEFINE VAR OK AS LOGICAL.

/* OTRAS VARIABLES */

DEFINE VAR x-DesMes AS CHAR.

DEFINE TEMP-TABLE Registro NO-UNDO
   FIELD CodDiv AS CHAR
   FIELD CodOpe AS CHAR
   FIELD NroAst AS CHAR
   FIELD FchDoc AS DATE
   FIELD FchVto AS DATE
   FIELD CodDoc AS CHAR
   FIELD NroDoc AS CHAR
   FIELD TpoCmb AS DECIMAL 
   FIELD CodRef AS CHAR
   FIELD NroRef AS CHAR
   FIELD Ruc    AS CHAR
   FIELD NomCli AS CHAR
   FIELD CodMon AS CHAR
   FIELD NroTra AS CHAR
   FIELD FchMod AS DATE
   FIELD Implin AS DECIMAL EXTENT 10.

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
&Scoped-Define ENABLED-OBJECTS RECT-20 RECT-12 x-Div C-CodMon s-CodOpe ~
x-Lineas Btn_OK Btn_Cancel BUTTON-2 BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS x-Div C-CodMon s-CodOpe x-Lineas 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Button 1" 
     SIZE 12 BY 1.5.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 12 BY 1.5.

DEFINE VARIABLE s-CodOpe AS CHARACTER FORMAT "X(256)":U 
     LABEL "Operación" 
     VIEW-AS FILL-IN 
     SIZE 22.29 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-Div AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-CodMon AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dólares", 2
     SIZE 8.57 BY 1.62 NO-UNDO.

DEFINE VARIABLE x-Lineas AS INTEGER INITIAL 66 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "66 lineas", 66,
"88 lineas", 88
     SIZE 19 BY .96 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33.72 BY 3.38
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13 BY 2.35
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     x-Div AT ROW 1.96 COL 23 COLON-ALIGNED
     C-CodMon AT ROW 2.23 COL 2.43 NO-LABEL
     s-CodOpe AT ROW 2.73 COL 17.14
     x-Lineas AT ROW 3.69 COL 24 NO-LABEL
     Btn_OK AT ROW 5.58 COL 2
     Btn_Cancel AT ROW 5.58 COL 14
     BUTTON-2 AT ROW 5.58 COL 26 WIDGET-ID 2
     BUTTON-1 AT ROW 5.58 COL 38
     " Moneda" VIEW-AS TEXT
          SIZE 7.14 BY .65 AT ROW 1.42 COL 2.86
     RECT-20 AT ROW 1.65 COL 1.72
     RECT-12 AT ROW 1.65 COL 15.72
     SPACE(1.12) SKIP(2.58)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Registro de Compras".


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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN s-CodOpe IN FRAME D-Dialog
   ALIGN-L                                                              */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Registro de Compras */
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
  ASSIGN C-CodMon s-CodOpe x-Div x-Lineas.
  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 D-Dialog
ON CHOOSE OF BUTTON-1 IN FRAME D-Dialog /* Button 1 */
DO:
  ASSIGN C-CodMon s-CodOpe x-Div x-Lineas.
  RUN Texto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 D-Dialog
ON CHOOSE OF BUTTON-2 IN FRAME D-Dialog /* Button 2 */
DO:
    ASSIGN C-CodMon s-CodOpe x-Div x-Lineas.
    RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */     

{lib/def-prn2.i}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CAPTURA D-Dialog 
PROCEDURE CAPTURA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR i        AS INTEGER NO-UNDO.
  DEFINE VAR x-Debe   AS DECIMAL NO-UNDO.
  DEFINE VAR x-Haber  AS DECIMAL NO-UNDO.
  OK = SESSION:SET-WAIT-STATE("GENERAL").
  DO i = 1 TO NUM-ENTRIES(s-CodOpe) :
      x-codope = ENTRY(i, s-CodOpe).
      FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.CodCia  = s-CodCia  AND
                                     cb-cmov.Periodo = s-Periodo AND
                                     cb-cmov.NroMes  = s-NroMes  AND
                                     cb-cmov.CodOpe  = x-CodOpe
                                     BREAK BY cb-cmov.NroAst :
/*MLR* 28/11/2007 ***/
        IF cb-cmov.flgest = "A" THEN DO:
            CREATE Registro.
            ASSIGN
                Registro.CodDiv = cb-cmov.CodDiv
                Registro.NroAst = cb-cmov.NroAst
                Registro.CodOpe = x-codope
                Registro.NomCli = "*** ANULADO ***".
            NEXT.
        END.

          x-NroAst = cb-cmov.NroAst.
          FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.CodCia  = cb-cmov.CodCia  AND
                                         cb-dmov.Periodo = cb-cmov.Periodo AND
                                         cb-dmov.NroMes  = cb-cmov.NroMes  AND
                                         cb-dmov.CodOpe  = cb-cmov.CodOpe  AND
                                         cb-dmov.NroAst  = cb-cmov.NroAst  AND
                                         cb-dmov.CodDiv  BEGINS x-Div 
                                         BREAK /* Coyote me dijo que deshabilite ***
                                               BY cb-dmov.CodDiv */ 
                                               by cb-dmov.NroAst :
              /* Coyote me dijo que deshabilite ***
              IF FIRST-OF (cb-dmov.CodDiv) THEN DO :
              */
              IF FIRST-OF (cb-dmov.NroAst) THEN DO:
                 x-FchDoc = ?.
                 x-FchVto = ?.
                 x-CodDoc = "".
                 x-NroDoc = "".
                 x-CodMon = "".
                 x-NomCli = "".
                 x-Ruc    = "".
                 x-NroRef = "".
                 x-CodRef = "".
                 x-TpoCmb = 0.

                 x-Import[1] = 0.
                 x-Import[2] = 0.
                 x-Import[3] = 0.
                 x-Import[4] = 0.
                 x-Import[5] = 0.
                 x-Import[6] = 0.
                 x-Import[7] = 0.
                 x-Import[8] = 0.
                 x-Import[9] = 0.
                 x-Import[10] = 0.                 
                 x-CodDiv = cb-dmov.CodDiv.
              END.
              IF NOT tpomov THEN DO:
                 CASE c-codmon:
                 WHEN 1 THEN DO:
                      x-debe  = ImpMn1.
                      x-haber = 0.
                 END.
                 WHEN 2 THEN DO:
                      x-debe  = ImpMn2.
                      x-haber = 0.
                 END.
                 END CASE.
              END.
              ELSE DO:      
                  CASE c-codmon:
                  WHEN 1 THEN DO:
                      x-debe  = 0.
                      x-haber = ImpMn1.
                  END.
                  WHEN 2 THEN DO:
                      x-debe  = 0.
                      x-haber = ImpMn2.
                  END.
                  END CASE.            
              END.

              CASE cb-dmov.TM :
                   WHEN 3 THEN x-Import[1] = x-Import[1] + (x-Debe - x-Haber).
                   WHEN 5 THEN x-Import[3] = x-Import[3] + (x-Debe - x-Haber).
                   WHEN 4 THEN x-Import[4] = x-Import[4] + (x-Debe - x-Haber).
                   WHEN 6 THEN x-Import[5] = x-Import[5] + (x-Debe - x-Haber).                   
                   WHEN 10 THEN x-Import[7] = x-Import[7] + (x-Debe - x-Haber).
                   WHEN 7 THEN x-Import[8] = x-Import[8] + (x-Debe - x-Haber).                   
                   WHEN 8 OR WHEN 11 THEN DO :                          
                          x-Import[10] = x-Import[10] + (x-Haber - x-Debe).
                          IF x-Import[10] < 0 THEN DO:
                             IF cb-dmov.CodMon = 2 THEN 
                                ASSIGN x-Import[9] = x-Import[9] + cb-dmov.ImpMn2 * -1
                                          x-TpoCmb = cb-dmov.TpoCmb.                        
                           END.
                          ELSE DO:
                             IF cb-dmov.CodMon = 2 THEN 
                                ASSIGN x-Import[9] = x-Import[9] + cb-dmov.ImpMn2 
                                          x-TpoCmb = cb-dmov.TpoCmb.                                  
                           END.
                          x-FchDoc = cb-dmov.FchDoc.
                          x-CodDoc = cb-dmov.CodDoc.
                          x-NroDoc = cb-dmov.NroDoc.
                          x-FchVto = IF x-CodDoc = '14' THEN cb-dmov.FchVto ELSE ?.
                          x-CodMon = IF cb-dmov.CodMon = 1 THEN "S/." ELSE "US$".                         
                          x-Ruc    = cb-dmov.NroRuc.
                          x-NroRef = cb-dmov.Nroref.
                          x-CodRef = cb-dmov.CodRef.

                          FIND GN-PROV WHERE GN-PROV.CodCia = pv-codcia AND
                                             GN-PROV.codPro = cb-dmov.CodAux NO-LOCK NO-ERROR.
                          IF AVAILABLE GN-PROV THEN x-NomCli = GN-PROV.NomPro.
                             ELSE x-NomCli = cb-dmov.GloDoc.                   
                   END.

              END CASE.
              /* Coyote me dijo que deshabilite ***
              IF LAST-OF (cb-dmov.CodDiv) THEN DO :
              */
              IF LAST-OF (cb-dmov.NroAst) THEN DO :
                 CREATE Registro.
                 Registro.CodDiv = x-CodDiv.
                 Registro.NroAst = x-NroAst.
                 Registro.CodOpe = x-codope.
                 Registro.FchDoc = x-FchDoc.
                 Registro.FchVto = x-FchVto.
                 Registro.CodDoc = x-CodDoc.
                 Registro.NroDoc = x-NroDoc.
                 Registro.CodRef = x-CodRef.
                 Registro.NroRef = x-NroRef.
                 Registro.Ruc    = x-Ruc.
                 Registro.NomCli = x-NomCli.
                 Registro.CodMon = x-CodMon.
                 Registro.TpoCmb = x-TpoCmb.
                 Registro.ImpLin[1] = x-Import[1].
                 Registro.ImpLin[2] = x-Import[2].
                 Registro.ImpLin[3] = x-Import[3].
                 Registro.ImpLin[4] = x-Import[4].
                 Registro.ImpLin[5] = x-Import[5].
                 Registro.ImpLin[6] = x-Import[6].
                 Registro.ImpLin[7] = x-Import[7].
                 Registro.ImpLin[8] = x-Import[8].
                 Registro.ImpLin[9] = x-Import[9].
                 Registro.ImpLin[10] = x-Import[10].
                 registro.NroTra     = cb-cmov.Nrotra.
                 Registro.FchMod     = cb-cmov.fchmod.
              END.

          END. /* FIN DEL FOR cb-dmov */        

      END. /* FIN DEL FOR cb-cmov */

   END. /* FIN DEL DO */

   OK = SESSION:SET-WAIT-STATE("").
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
  DISPLAY x-Div C-CodMon s-CodOpe x-Lineas 
      WITH FRAME D-Dialog.
  ENABLE RECT-20 RECT-12 x-Div C-CodMon s-CodOpe x-Lineas Btn_OK Btn_Cancel 
         BUTTON-2 BUTTON-1 
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
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* IMPRESION */
    DEFINE VAR Titulo1 AS CHAR FORMAT "X(50)".
    DEFINE VAR Titulo2 AS CHAR FORMAT "X(230)".
    DEFINE VAR Titulo3 AS CHAR FORMAT "X(230)".
    DEFINE VAR X-LLAVE AS LOGICAL . 
    DEFINE VAR x-NroSer AS CHAR.
    DEFINE VAR x-NroDoc AS CHAR.
    DEFINE VAR x-SerRef AS CHAR.
    DEFINE VAR x-NroRef AS CHAR.

   /*MLR* 03/12/07 */
   DEFINE VARIABLE Cmpb_SUNAT AS CHARACTER NO-UNDO.
   DEFINE VARIABLE Cmpb_nodomi AS CHARACTER NO-UNDO.

    FOR EACH Registro:
       DELETE Registro.
    END.

    RUN CAPTURA.

    RUN bin/_mes.p ( INPUT s-NroMes  , 1, OUTPUT x-DesMes ).     

    Titulo1 = "R E G I S T R O   D E   C O M P R A S".
    Titulo2 = "DEL MES DE " + TRIM(x-DesMes) + " DEL " + STRING(S-PERIODO,"9999").
    Titulo3 = "EXPRESADO EN " + IF C-CodMon = 1 THEN "NUEVOS SOLES" ELSE "DOLARES AMERICANOS".

    /* titulos */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = Titulo1.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = Titulo2.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = Titulo3.
    iCount = iCount + 2.
    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "BASE IMPONIBLE".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "BASE IMPONIBLE".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "BASE IMPONIBLE".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "DESTINADA A OPERACIONES".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "DESTINADA A OPERACIONES".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "POR OPERACIONES".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "GRAVADAS Y EXPORTACIONES".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "GRAVADAS Y EXPORTACIONES".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "QUE NO DAN DERECHO".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "ADQUISICIONES".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "O NO GRAVADAS".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "A CREDITO".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "NO GRAVADAS".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "IGV".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "IGV".
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = "IGV".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha de Emision".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha de Vencto.".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod. Doc.".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Serie".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Doc.".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod. Ref.".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Ser. Ref.".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Ref.".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Ast.".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. RUC".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Proveedores".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "(A)".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "(B)".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "(C)".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "(A)".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "(B)".
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = "(C)".
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL".
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe en dólares".
    cRange = "U" + cColumn.
    chWorkSheet:Range(cRange):Value = "Tpo. Cmbo. usado".
    cRange = "V" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. constacia depósito".
    iCount = iCount + 1.

FOR EACH Registro NO-LOCK BREAK BY Registro.CodOpe BY Registro.NroAst:
    ASSIGN
       x-NroSer = ''
       x-NroDoc = ''
       x-SerRef = ''
       x-NroRef = ''.
    ASSIGN
       x-NroDoc = Registro.NroDoc
       x-NroRef = Registro.NroRef.
    IF INDEX(x-NroDoc, '-') > 0 THEN DO:
       x-NroSer = SUBSTRING(x-NroDoc, 1 , INDEX(x-NroDoc, '-') - 1).
       x-NroDoc = SUBSTRING(x-NroDoc, INDEX(x-NroDoc, '-') + 1).
    END.         
    IF INDEX(x-NroRef, '-') > 0 THEN DO:
       x-SerRef = SUBSTRING(x-NroRef, 1 , INDEX(x-NroRef, '-') - 1).
       x-NroRef = SUBSTRING(x-NroRef, INDEX(x-NroRef, '-') + 1).
    END.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = (IF registro.fchdoc <> ? THEN STRING(registro.fchdoc) ELSE '').
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = (IF registro.fchvto <> ? THEN STRING(registro.fchvto) ELSE '').
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = registro.coddoc.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = x-nroser.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = x-nrodoc.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = registro.codref.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = x-serref.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = x-nroref.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = registro.nroast.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = registro.ruc.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = registro.nomcli.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = registro.implin[1].
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = registro.implin[2].
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = registro.implin[3].
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = registro.implin[4].
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = registro.implin[5].
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = registro.implin[6].
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = registro.implin[7].
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = registro.implin[10].
    IF registro.implin[9] <> 0 THEN DO:
        cRange = "T" + cColumn.
        chWorkSheet:Range(cRange):Value = registro.implin[9].
    END.
    IF registro.tpocmb <> 0 THEN DO:
        cRange = "U" + cColumn.
        chWorkSheet:Range(cRange):Value = registro.tpocmb.
    END.
    cRange = "V" + cColumn.
    chWorkSheet:Range(cRange):Value = registro.nrotra.

    ACCUMULATE Registro.ImpLin[1] ( TOTAL ).
    ACCUMULATE Registro.ImpLin[2] ( TOTAL ).
    ACCUMULATE Registro.ImpLin[3] ( TOTAL ).
    ACCUMULATE Registro.ImpLin[4] ( TOTAL ).
    ACCUMULATE Registro.ImpLin[5] ( TOTAL ).
    ACCUMULATE Registro.ImpLin[6] ( TOTAL ).
    ACCUMULATE Registro.ImpLin[7] ( TOTAL ).
    ACCUMULATE Registro.ImpLin[9] ( TOTAL ).
    ACCUMULATE Registro.ImpLin[10] ( TOTAL ).

    ACCUMULATE Registro.ImpLin[1] ( SUB-TOTAL BY Registro.CodOpe ).
    ACCUMULATE Registro.ImpLin[2] ( SUB-TOTAL BY Registro.CodOpe ).
    ACCUMULATE Registro.ImpLin[3] ( SUB-TOTAL BY Registro.CodOpe ).
    ACCUMULATE Registro.ImpLin[4] ( SUB-TOTAL BY Registro.CodOpe ).
    ACCUMULATE Registro.ImpLin[5] ( SUB-TOTAL BY Registro.CodOpe ).
    ACCUMULATE Registro.ImpLin[6] ( SUB-TOTAL BY Registro.CodOpe ).
    ACCUMULATE Registro.ImpLin[7] ( SUB-TOTAL BY Registro.CodOpe ).
    ACCUMULATE Registro.ImpLin[9] ( SUB-TOTAL BY Registro.CodOpe ).
    ACCUMULATE Registro.ImpLin[10] ( SUB-TOTAL BY Registro.CodOpe ).
     
    IF LAST-OF (Registro.CodOpe) THEN DO:
       iCount = iCount + 1.
       cColumn = STRING(iCount).
       cRange = "K" + cColumn.
       chWorkSheet:Range(cRange):Value = "TOTAL POR OPERACION " + Registro.CodOpe.
       cRange = "L" + cColumn.
       chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[1]).
       cRange = "M" + cColumn.
       chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[2]).
       cRange = "N" + cColumn.
       chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[3]).
       cRange = "O" + cColumn.
       chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[4]).
       cRange = "P" + cColumn.
       chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[5]).
       cRange = "Q" + cColumn.
       chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[6]).
       cRange = "R" + cColumn.
       chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[7]).
       cRange = "S" + cColumn.
       chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[10]).
       cRange = "T" + cColumn.
       chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[9]).
       iCount = iCount + 1.
    END.
    IF LAST (Registro.CodOpe) THEN DO:
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = "TOTAL GENERAL".
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL Registro.ImpLin[1]).
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL Registro.ImpLin[2]).
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL Registro.ImpLin[3]).
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL Registro.ImpLin[4]).
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL Registro.ImpLin[5]).
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL Registro.ImpLin[6]).
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL Registro.ImpLin[7]).
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL Registro.ImpLin[10]).
        cRange = "T" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL Registro.ImpLin[9]).
        iCount = iCount + 1.
    END.
END.

 /* launch Excel so it is visible to the user */
 chExcelApplication:Visible = TRUE.

 /* release com-handles */
 RELEASE OBJECT chExcelApplication.      
 RELEASE OBJECT chWorkbook.
 RELEASE OBJECT chWorksheet.

 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FORMATO D-Dialog 
PROCEDURE FORMATO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE VAR Titulo1 AS CHAR FORMAT "X(50)".
 DEFINE VAR Titulo2 AS CHAR FORMAT "X(230)".
 DEFINE VAR Titulo3 AS CHAR FORMAT "X(230)".
 DEFINE VAR Van     AS DECI EXTENT 10.
 DEFINE VAR X-LLAVE AS LOGICAL . 
 DEFINE VAR x-NroSer AS CHAR.
 DEFINE VAR x-NroDoc AS CHAR.
 DEFINE VAR x-SerRef AS CHAR.
 DEFINE VAR x-NroRef AS CHAR.

/*MLR* 03/12/07 */
DEFINE VARIABLE Cmpb_SUNAT AS CHARACTER NO-UNDO.
DEFINE VARIABLE Cmpb_nodomi AS CHARACTER NO-UNDO.
 
 FOR EACH Registro:
    DELETE Registro.
 END.
 
 RUN CAPTURA.
 
 RUN bin/_mes.p ( INPUT s-NroMes  , 1, OUTPUT x-DesMes ).     
 
 Titulo1 = "R E G I S T R O   D E   C O M P R A S".
 Titulo2 = "DEL MES DE " + TRIM(x-DesMes) + " DEL " + STRING(S-PERIODO,"9999").
 Titulo3 = "EXPRESADO EN " + IF C-CodMon = 1 THEN "NUEVOS SOLES" ELSE "DOLARES AMERICANOS".
 
 RUN BIN/_centrar.p ( INPUT Titulo1, 50, OUTPUT Titulo1).
 RUN BIN/_centrar.p ( INPUT Titulo2, 230, OUTPUT Titulo2).
 RUN BIN/_centrar.p ( INPUT Titulo3, 230, OUTPUT Titulo3).

 DEFINE FRAME f-cab
       Registro.FchDoc    COLUMN-LABEL "Fecha de!Emisión" FORMAT "99/99/9999"
       Registro.FchVto    COLUMN-LABEL "Fecha de!Vencto." FORMAT "99/99/9999"
       Registro.CodDoc    COLUMN-LABEL "Cod!Doc" FORMAT "X(3)"
       x-NroSer           FORMAT 'X(5)'
       x-NroDoc           FORMAT 'x(8)'
       Registro.CodRef    COLUMN-LABEL "Cod!Ref" FORMAT "X(3)"
       x-SerRef           FORMAT 'X(5)'
       x-NroRef           FORMAT 'X(8)'
       Registro.NroAst    COLUMN-LABEL "Nro.Ast"
       Registro.Ruc       COLUMN-LABEL "Nro.!R.U.C." FORMAT "X(11)"
       Registro.NomCli    COLUMN-LABEL "Proveedores" FORMAT "X(27)"
       Registro.ImpLin[1] COLUMN-LABEL "Bse.Imp.!Destin. a!Operaci.!Gravadas!exporta." FORMAT "(>>,>>>,>>9.99)"
       Registro.ImpLin[2] COLUMN-LABEL "Bse. Imp.!destin. a!operaci.!gravadas!export.o!nogravad" FORMAT "(>,>>>,>>9.99)"
       Registro.ImpLin[3] COLUMN-LABEL "Base Imp.!por Oper.!q'no dan!derecho a!credito" FORMAT "(>,>>>,>>9.99)"
       Registro.ImpLin[4] COLUMN-LABEL "Aquisi'!ciones no!gravadas" FORMAT "(>,>>>,>>9.99)"
       Registro.ImpLin[5] COLUMN-LABEL "I.G.V." FORMAT "(>,>>>,>>9.99)"
       Registro.ImpLin[6] COLUMN-LABEL " O T R O S" FORMAT "(>>>,>>9.99)"
       Registro.ImpLin[7] COLUMN-LABEL "Reten.!Cuarta!categ." FORMAT "(>>>,>>9.99)"
       Registro.ImpLin[10] COLUMN-LABEL "T O T A L " FORMAT "(>>,>>>,>>9.99)"
       Registro.ImpLin[9] COLUMN-LABEL "Importe en!Dolares" FORMAT "(>,>>>,>>9.99)"
       Registro.TpoCmb FORMAT ">>9.999"
       Registro.NroTra FORMAT "X(10)"
/*MLR* ***
       Registro.FchMod FORMAT "99/99/99"
*MLR* ***/
       HEADER
       S-NOMCIA FORMAT "X(60)" AT 1 
       SKIP
       /*
       Titulo1 AT 1 "PAGINA : " TO 213 PAGE-NUMBER(REPORT) FORMAT "ZZZ9" SKIP
       */
       Titulo1 AT 91 "PAGINA : " TO 255 c-Pagina FORMAT ">>>9" SKIP
       Titulo2 SKIP 
       Titulo3 SKIP(1)                
/*MLR* ***
       "---------- ---------- --- -------------- --- ------------- -------- ----------- ---------------------------- --------------- -------------- -------------- -------------- -------------- ------------ ------------ --------------- -------------- ------- -------------------"    
       "Fecha de   Fecha de   Cod Nro.           Cod Nro.                    Nro.                                     BASE IMPONIBLE BASE IMPONIBLE BASE IMPONIBLE                    I.G.V.        I.G.V.       I.G.V.                                           Constancia de      "   
       "Emisión    Vencto.    Doc Documento      Ref Referencia     Nro.Ast  Documento   Proveedores                  DESTINA.A OPE- DESTINA.A OPE- POR OPERACIONE ADQUISICIONES                                                             Importe en   Tipo de    Deposito        " 
       "                                                                     Proveedor                                RACIONES  GRA- RACIONES GRAB. QUE NO DAN DE-  NO GRAVADAS         A             B            C          T O T A L       Dólares     Cambio       SPOT          " 
       "                                                                                                             VADAS Y EXPOR- EXPORT, O  NO  RECHO A CREDIT                                                                                        Usado                      "
       "                          Serie Numero       Serie Numero                                                      TACION (A)     GRABADAS (B)         (C)                                                                                                    No                 "
       "---------- ---------- --- ----- -------- --- ----- -------- -------- ----------- --------------------------- --------------- -------------- -------------- -------------- -------------- ------------ ------------ --------------- -------------- ------- -------------------"    
*MLR* ***/
       "---------- ---------- --- -------------- --- ------------- -------- ----------- ---------------------------- --------------- -------------- -------------- -------------- -------------- ------------ ------------ --------------- -------------- ------- ----------"
       "Fecha de   Fecha de   Cod Nro.           Cod Nro.                    Nro.                                     BASE IMPONIBLE BASE IMPONIBLE BASE IMPONIBLE                    I.G.V.        I.G.V.       I.G.V.                                          "   
       "Emision    Vencto.    Doc Documento      Ref Referencia     Nro.Ast  Documento   Proveedores                  DESTINA.A OPE- DESTINA.A OPE- POR OPERACIONE ADQUISICIONES                                                             Importe en   Tipo de    Nro" 
       "                                                                     Proveedor                                RACIONES  GRA- RACIONES GRAB. QUE NO DAN DE-  NO GRAVADAS         A             B            C          T O T A L       Dolares     Cambio  Contancia" 
       "                                                                                                              VADAS Y EXPOR- EXPORT, O  NO  RECHO A CREDIT                                                                                        Usado    Deposito"
       "                          Serie Numero       Serie Numero                                                     TACION (A)     GRABADAS (B)         (C)                                                                                                   "
       "---------- ---------- --- ----- -------- --- ----- -------- -------- ----------- --------------------------- --------------- -------------- -------------- -------------- -------------- ------------ ------------ --------------- -------------- ------- ----------"
/*
        99/99/9999 99/99/9999 123 12345 12345678 1234 12345 12345678 12345678 12345678901 123456789012345678901234567890 (>>,>>>,>>9.99) (>,>>>,>>9.99) (>,>>>,>>9.99) (>,>>>,>>9.99) (>,>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>,>>>,>>9.99) (>,>>>,>>9.99) 1234567890 99/99/99
*/
       WITH WIDTH 300 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

 FOR EACH Registro NO-LOCK BREAK BY Registro.CodOpe BY Registro.NroAst
     ON ERROR UNDO, RETURN ERROR:
     IF c-Pagina > 1 AND X-LLAVE = TRUE THEN DO:
        {&NEW-PAGE}.
        DOWN STREAM REPORT 1 WITH FRAME F-cab.
        DISPLAY STREAM REPORT  
                 "V I E N E N  . . . . . . . "  @ Registro.NomCli
                 Van[1]  @ Registro.ImpLin[1] 
                 Van[2]  @ Registro.ImpLin[2] 
                 Van[3]  @ Registro.ImpLin[3] 
                 Van[4]  @ Registro.ImpLin[4] 
                 Van[5]  @ Registro.ImpLin[5] 
                 Van[6]  @ Registro.ImpLin[6] 
                 Van[7]  @ Registro.ImpLin[7] 
                 Van[9]  @ Registro.ImpLin[9] 
                 Van[10] @ Registro.ImpLin[10]
                 WITH FRAME F-cab.
        DOWN STREAM REPORT 2 WITH FRAME F-cab.
        X-LLAVE = FALSE.
     END.
     ASSIGN
        x-NroSer = ''
        x-NroDoc = ''
        x-SerRef = ''
        x-NroRef = ''.
     ASSIGN
        x-NroDoc = Registro.NroDoc
        x-NroRef = Registro.NroRef.
     IF INDEX(x-NroDoc, '-') > 0 THEN DO:
        x-NroSer = SUBSTRING(x-NroDoc, 1 , INDEX(x-NroDoc, '-') - 1).
        x-NroDoc = SUBSTRING(x-NroDoc, INDEX(x-NroDoc, '-') + 1).
     END.         
     IF INDEX(x-NroRef, '-') > 0 THEN DO:
        x-SerRef = SUBSTRING(x-NroRef, 1 , INDEX(x-NroRef, '-') - 1).
        x-NroRef = SUBSTRING(x-NroRef, INDEX(x-NroRef, '-') + 1).
     END.

     {&NEW-PAGE}.
     DISPLAY STREAM REPORT  
             Registro.FchDoc    
             Registro.FchVto
             Registro.CodDoc    
             x-NroSer
             x-NroDoc
             Registro.CodRef
             x-SerRef
             x-NroRef
             Registro.NroAst    
             Registro.Ruc       
             Registro.NomCli    
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] 
             Registro.ImpLin[7] 
             Registro.ImpLin[10] 
             Registro.ImpLin[9] WHEN Registro.ImpLin[9] <> 0
             Registro.TpoCmb WHEN Registro.TpoCmb <> 0
/*MLR* ***
             Registro.FchMod
*MLR* ***/
             Registro.NroTra
             WITH FRAME F-CAB. 

     ACCUMULATE Registro.ImpLin[1] ( TOTAL ).
     ACCUMULATE Registro.ImpLin[2] ( TOTAL ).
     ACCUMULATE Registro.ImpLin[3] ( TOTAL ).
     ACCUMULATE Registro.ImpLin[4] ( TOTAL ).
     ACCUMULATE Registro.ImpLin[5] ( TOTAL ).
     ACCUMULATE Registro.ImpLin[6] ( TOTAL ).
     ACCUMULATE Registro.ImpLin[7] ( TOTAL ).
     ACCUMULATE Registro.ImpLin[9] ( TOTAL ).
     ACCUMULATE Registro.ImpLin[10] ( TOTAL ).

     ACCUMULATE Registro.ImpLin[1] ( SUB-TOTAL BY Registro.CodOpe ).
     ACCUMULATE Registro.ImpLin[2] ( SUB-TOTAL BY Registro.CodOpe ).
     ACCUMULATE Registro.ImpLin[3] ( SUB-TOTAL BY Registro.CodOpe ).
     ACCUMULATE Registro.ImpLin[4] ( SUB-TOTAL BY Registro.CodOpe ).
     ACCUMULATE Registro.ImpLin[5] ( SUB-TOTAL BY Registro.CodOpe ).
     ACCUMULATE Registro.ImpLin[6] ( SUB-TOTAL BY Registro.CodOpe ).
     ACCUMULATE Registro.ImpLin[7] ( SUB-TOTAL BY Registro.CodOpe ).
     ACCUMULATE Registro.ImpLin[9] ( SUB-TOTAL BY Registro.CodOpe ).
     ACCUMULATE Registro.ImpLin[10] ( SUB-TOTAL BY Registro.CodOpe ).

     Van[1] = Van[1] + Registro.ImpLin[1].
     Van[2] = Van[2] + Registro.ImpLin[2].
     Van[3] = Van[3] + Registro.ImpLin[3].
     Van[4] = Van[4] + Registro.ImpLin[4].
     Van[5] = Van[5] + Registro.ImpLin[5].
     Van[6] = Van[6] + Registro.ImpLin[6].
     Van[7] = Van[7] + Registro.ImpLin[7].
     Van[9] = Van[9] + Registro.ImpLin[9].
     Van[10] = Van[10] + Registro.ImpLin[10].

     IF LINE-COUNTER(Report) > (P-Largo - 9) THEN DO:
        X-LLAVE = TRUE.
        DO WHILE LINE-COUNTER(Report) < P-Largo - 8:
           PUT STREAM Report "" skip.
        END.
        {&NEW-PAGE}.
        UNDERLINE STREAM REPORT 
             Registro.NomCli 
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] 
             Registro.ImpLin[7] 
             Registro.ImpLin[9] 
             Registro.ImpLin[10] WITH FRAME F-CAB. 

        DISPLAY STREAM REPORT  
                 "V A N  . . . . . . . . "  @ Registro.NomCli    
                 Van[1]  @ Registro.ImpLin[1] 
                 Van[2]  @ Registro.ImpLin[2] 
                 Van[3]  @ Registro.ImpLin[3] 
                 Van[4]  @ Registro.ImpLin[4] 
                 Van[5]  @ Registro.ImpLin[5] 
                 Van[6]  @ Registro.ImpLin[6] 
                 Van[7]  @ Registro.ImpLin[7] 
                 Van[9]  @ Registro.ImpLin[9] 
                 Van[10] @ Registro.ImpLin[10]
                 WITH FRAME F-cab.
        DOWN STREAM REPORT 2 WITH FRAME F-cab.
        RUN NEW-PAGE.
     END.
     
     IF LAST-OF (Registro.CodOpe) THEN DO:
        {&NEW-PAGE}.
        UNDERLINE STREAM REPORT 
             Registro.NomCli 
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] 
             Registro.ImpLin[7] 
             Registro.ImpLin[9] 
             Registro.ImpLin[10] WITH FRAME F-CAB. 
        {&NEW-PAGE}.
        DISPLAY STREAM REPORT  
                 "TOTAL POR OPERACION " + Registro.CodOpe @ Registro.NomCli    
                 ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[1]  @ Registro.ImpLin[1] 
                 ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[2]  @ Registro.ImpLin[2] 
                 ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[3]  @ Registro.ImpLin[3] 
                 ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[4]  @ Registro.ImpLin[4] 
                 ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[5]  @ Registro.ImpLin[5] 
                 ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[6]  @ Registro.ImpLin[6] 
                 ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[7]  @ Registro.ImpLin[7] 
                 ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[9]  @ Registro.ImpLin[9] 
                 ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[10] @ Registro.ImpLin[10]
                 WITH FRAME F-CAB.
        DOWN STREAM REPORT 2 WITH FRAME F-CAB.
     END.
     IF LAST (Registro.CodOpe) THEN DO:
        {&NEW-PAGE}.
        UNDERLINE STREAM REPORT               
             Registro.NomCli                 
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] 
             Registro.ImpLin[7] 
             Registro.ImpLin[9] 
             Registro.ImpLin[10] WITH FRAME F-CAB. 
        {&NEW-PAGE}.
        DISPLAY STREAM REPORT  
                 "TOTAL GENERAL " @ Registro.NomCli    
                 ACCUM TOTAL Registro.ImpLin[1] @ Registro.ImpLin[1] 
                 ACCUM TOTAL Registro.ImpLin[2] @ Registro.ImpLin[2] 
                 ACCUM TOTAL Registro.ImpLin[3] @ Registro.ImpLin[3] 
                 ACCUM TOTAL Registro.ImpLin[4] @ Registro.ImpLin[4] 
                 ACCUM TOTAL Registro.ImpLin[5] @ Registro.ImpLin[5] 
                 ACCUM TOTAL Registro.ImpLin[6] @ Registro.ImpLin[6] 
                 ACCUM TOTAL Registro.ImpLin[7] @ Registro.ImpLin[7] 
                 ACCUM TOTAL Registro.ImpLin[9] @ Registro.ImpLin[9]
                 ACCUM TOTAL Registro.ImpLin[10] @ Registro.ImpLin[10]
                 WITH FRAME F-CAB.        
        {&NEW-PAGE}.
        UNDERLINE STREAM REPORT               
             Registro.NomCli                 
             Registro.ImpLin[1] 
             Registro.ImpLin[2] 
             Registro.ImpLin[3] 
             Registro.ImpLin[4] 
             Registro.ImpLin[5] 
             Registro.ImpLin[6] 
             Registro.ImpLin[7] 
             Registro.ImpLin[9] 
             Registro.ImpLin[10] WITH FRAME F-CAB. 
     END.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR D-Dialog 
PROCEDURE IMPRIMIR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    CASE x-Lineas:
        WHEN 88 THEN P-Largo = 88.
        WHEN 66 THEN P-Largo = 66.
    END CASE.

    ASSIGN
        P-reset = {&Prn0}
        P-flen = {&Prn5A} + CHR(66)
        P-config = {&Prn4} + {&PrnD}.

    IF x-Lineas = 88 THEN P-config = P-config + CHR(27) + "0".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        OUTPUT STREAM report TO NUL PAGED PAGE-SIZE 1000.
        c-Pagina = 0.
        RUN Formato.
        OUTPUT STREAM report CLOSE.        
    END.
    OUTPUT STREAM report CLOSE.        

    HIDE FRAME F-Mensaje.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME D-Dialog:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME D-Dialog:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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

  FIND cb-cfgg WHERE cb-cfgg.CODCIA = S-codcia AND cb-cfgg.CODCFG = "R01"
       NO-LOCK NO-ERROR.
  IF AVAIL cb-cfgg THEN DO:    
     s-CodOpe:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cb-cfgg.codope.
  END.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto D-Dialog 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Rpta    AS LOG  NO-UNDO.
  DEF VAR x-CodDoc  AS CHAR NO-UNDO.

  DEFINE VAR Titulo1 AS CHAR FORMAT "X(230)".
  DEFINE VAR Titulo2 AS CHAR FORMAT "X(230)".
  DEFINE VAR Titulo3 AS CHAR FORMAT "X(230)".
  DEFINE VAR VAN     AS DECI EXTENT 10.
  DEFINE VAR X-LLAVE AS LOGICAL.
  DEFINE VAR x-NroSer AS CHAR.
  DEFINE VAR x-NroDoc AS CHAR.
  DEFINE VAR x-SerRef AS CHAR.
  DEFINE VAR x-NroRef AS CHAR.
 
  x-Archivo = 'Compras' + STRING(s-Periodo, '9999') + STRING(s-NroMes, '99') + 's.txt'.
  SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Texto' '*.txt'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.txt'
    INITIAL-DIR 'c:\tmp'
    RETURN-TO-START-DIR 
    USE-FILENAME
    SAVE-AS
    UPDATE x-rpta.
  IF x-rpta = NO THEN RETURN.

  RUN CAPTURA.

 DEFINE FRAME f-cab
     s-Periodo          COLUMN-LABEL 'Periodo' FORMAT '9999'
     s-Nromes           COLUMN-LABEL 'NroMes' FORMAT '99'
     Registro.CodOpe    COLUMN-LABEL 'Codope' FORMAT 'x(3)'
     Registro.FchDoc    COLUMN-LABEL "FchDoc" FORMAT "99/99/9999"
     Registro.FchVto    COLUMN-LABEL "FchVto" FORMAT "99/99/9999"
     Registro.CodDoc    COLUMN-LABEL "CodDoc" FORMAT "X(3)"
     x-NroSer           COLUMN-LABEL 'NroSer' FORMAT 'X(5)'
     x-NroDoc           COLUMN-LABEL 'NroDoc' FORMAT 'x(8)'
     Registro.CodRef    COLUMN-LABEL "CodRef" FORMAT "X(3)"
     x-SerRef           COLUMN-LABEL 'NroRef' FORMAT 'X(5)'
     x-NroRef           COLUMN-LABEL 'NroRef' FORMAT 'X(8)'
     Registro.NroAst    COLUMN-LABEL "NroAst" FORMAT 'x(6)'
     Registro.Ruc       COLUMN-LABEL "NroRuc" FORMAT "X(11)"
     Registro.NomCli    COLUMN-LABEL "NomPro" FORMAT "X(27)"
     Registro.ImpLin[1] COLUMN-LABEL "ImpLin1" FORMAT "->>>>>>>9.99"
     Registro.ImpLin[2] COLUMN-LABEL "ImpLin2" FORMAT "->>>>>>9.99"
     Registro.ImpLin[3] COLUMN-LABEL "ImpLin3" FORMAT "->>>>>>9.99"
     Registro.ImpLin[4] COLUMN-LABEL "ImpLin4" FORMAT "->>>>>>9.99"
     Registro.ImpLin[5] COLUMN-LABEL "ImpIgv" FORMAT "->>>>>>9.99"
     Registro.ImpLin[6] COLUMN-LABEL "ImpLin6" FORMAT "->>>>>9.99"
     Registro.ImpLin[7] COLUMN-LABEL "ImpLin7" FORMAT "->>>>>9.99"
     Registro.ImpLin[10] COLUMN-LABEL "ImpTot" FORMAT "->>>>>>>9.99"
     Registro.ImpLin[9] COLUMN-LABEL "ImpDol" FORMAT "->>>>>>9.99"
     Registro.TpoCmb    COLUMN-LABEL 'TpoCmb' FORMAT ">>9.999"
     Registro.NroTra    COLUMN-LABEL 'NroTra' FORMAT "X(10)"
     WITH WIDTH 300 NO-BOX STREAM-IO DOWN.
    
 OUTPUT STREAM REPORT TO VALUE(x-Archivo).
 FOR EACH Registro NO-LOCK BREAK BY Registro.CodOpe BY Registro.NroAst:
     ASSIGN
        x-NroSer = ''
        x-NroDoc = ''
        x-SerRef = ''
        x-NroRef = ''.
     ASSIGN
        x-NroDoc = Registro.NroDoc
        x-NroRef = Registro.NroRef.
     IF INDEX(x-NroDoc, '-') > 0 THEN DO:
        x-NroSer = SUBSTRING(x-NroDoc, 1 , INDEX(x-NroDoc, '-') - 1).
        x-NroDoc = SUBSTRING(x-NroDoc, INDEX(x-NroDoc, '-') + 1).
     END.         
     IF INDEX(x-NroRef, '-') > 0 THEN DO:
        x-SerRef = SUBSTRING(x-NroRef, 1 , INDEX(x-NroRef, '-') - 1).
        x-NroRef = SUBSTRING(x-NroRef, INDEX(x-NroRef, '-') + 1).
     END.
     PUT STREAM REPORT
         s-Periodo          FORMAT '9999'
         s-Nromes           FORMAT '99'
         Registro.CodOpe    FORMAT 'x(3)'
         Registro.FchDoc    FORMAT "99/99/9999"
         Registro.FchVto    FORMAT "99/99/9999"
         Registro.CodDoc    FORMAT "X(3)"
         x-NroSer           FORMAT 'X(5)'
         x-NroDoc           FORMAT 'x(8)'
         Registro.CodRef    FORMAT "X(3)"
         x-SerRef           FORMAT 'X(5)'
         x-NroRef           FORMAT 'X(8)'
         Registro.NroAst    FORMAT 'x(6)'
         Registro.Ruc       FORMAT "X(11)"
         Registro.NomCli    FORMAT "X(27)"
         Registro.ImpLin[1] FORMAT  "->>>>>>>>9.99"
         Registro.ImpLin[2] FORMAT  "->>>>>>>>9.99"
         Registro.ImpLin[3] FORMAT  "->>>>>>>>9.99"
         Registro.ImpLin[4] FORMAT  "->>>>>>>>9.99"
         Registro.ImpLin[5] FORMAT  "->>>>>>>>9.99"
         Registro.ImpLin[6] FORMAT  "->>>>>>>>9.99"
         Registro.ImpLin[7] FORMAT  "->>>>>>>>9.99"
         Registro.ImpLin[10] FORMAT "->>>>>>>>9.99"
         Registro.ImpLin[9] FORMAT  "->>>>>>>>9.99"
         Registro.TpoCmb    FORMAT  ">>9.999"
         Registro.NroTra    FORMAT "X(10)"
         SKIP.
 END.
 OUTPUT STREAM REPORT CLOSE.

  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

