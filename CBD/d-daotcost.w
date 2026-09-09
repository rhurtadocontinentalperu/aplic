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

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR s-Periodo AS INTEGER.
DEFINE SHARED VAR S-NROMES AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHAR.

DEFINE NEW SHARED VARIABLE xTerm AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE lh_Handle AS HANDLE.

{lib/def-prn.i}
DEFINE STREAM report.

DEFINE VARIABLE l-immediate-display AS LOGICAL.
DEFINE VARIABLE PTO AS LOGICAL.
DEFINE VARIABLE I-NroMes1 AS INTEGER NO-UNDO.
DEFINE VARIABLE I-NroMes2 AS INTEGER NO-UNDO.

DEFINE TEMP-TABLE CoaCompra
   FIELD Ruc AS CHAR
   FIELD NomPro AS CHAR
   FIELD Implin AS DECIMAL
   FIELD Persona LIKE GN-PROV.Persona
   FIELD CodDoc LIKE cb-dmov.coddoc
   FIELD NroDoc LIKE cb-dmov.nrodoc
   FIELD Fecha AS DATE
   FIELD NroAst LIKE cb-dmov.NroAst
   INDEX llave01 IS PRIMARY Ruc CodDoc NroDoc.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-Periodo FILL-IN-Nrouit FILL-IN-uit ~
COMBO-Mes1 COMBO-Mes2 RADIO-SET-1 B-impresoras RB-NUMBER-COPIES ~
RB-BEGIN-PAGE RB-END-PAGE B-imprime B-cancela B-ayuda RECT-48 RECT-5 ~
B-imprime-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Periodo FILL-IN-Nrouit FILL-IN-uit ~
COMBO-Mes1 COMBO-Mes2 FILL-IN-proceso RADIO-SET-1 RB-NUMBER-COPIES ~
RB-BEGIN-PAGE RB-END-PAGE 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-archivo 
     IMAGE-UP FILE "IMG/pvstop":U
     LABEL "&Archivos.." 
     SIZE 5 BY 1.

DEFINE BUTTON B-ayuda 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "Button 3" 
     SIZE 13 BY 1.5.

DEFINE BUTTON B-cancela AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 13 BY 1.5.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON B-imprime AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Imprimir" 
     SIZE 13 BY 1.5.

DEFINE BUTTON B-imprime-2 AUTO-GO 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "&Imprimir" 
     SIZE 13 BY 1.5.

DEFINE VARIABLE COMBO-Mes1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Desde" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 16.72 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-Mes2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 16.72 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Nrouit AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Nro UIT" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .81
     FONT 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-proceso AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-uit AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "U.I.T." 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE RB-BEGIN-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "Página Desde" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-END-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 9999 
     LABEL "Página Hasta" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-NUMBER-COPIES AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "No. Copias" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-OUTPUT-FILE AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 12 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 3.65.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 3.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-Periodo AT ROW 1.38 COL 13 COLON-ALIGNED
     FILL-IN-Nrouit AT ROW 2.35 COL 13 COLON-ALIGNED
     FILL-IN-uit AT ROW 3.31 COL 13 COLON-ALIGNED
     COMBO-Mes1 AT ROW 1.38 COL 44 COLON-ALIGNED
     COMBO-Mes2 AT ROW 2.35 COL 44 COLON-ALIGNED
     FILL-IN-proceso AT ROW 3.5 COL 44 COLON-ALIGNED NO-LABEL
     RADIO-SET-1 AT ROW 5.81 COL 2.57 NO-LABEL
     B-impresoras AT ROW 6.81 COL 15.57
     b-archivo AT ROW 7.81 COL 15.57
     RB-OUTPUT-FILE AT ROW 8.04 COL 19.86 COLON-ALIGNED NO-LABEL
     RB-NUMBER-COPIES AT ROW 5.96 COL 70 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 6.96 COL 70 COLON-ALIGNED
     RB-END-PAGE AT ROW 7.96 COL 70 COLON-ALIGNED
     B-imprime AT ROW 9.85 COL 41
     B-cancela AT ROW 9.85 COL 55
     B-ayuda AT ROW 9.85 COL 69
     B-imprime-2 AT ROW 9.88 COL 27 WIDGET-ID 2
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 83.43 BY .62 AT ROW 4.65 COL 1.29
          BGCOLOR 1 FGCOLOR 15 FONT 6
     RECT-48 AT ROW 1 COL 1
     RECT-5 AT ROW 5.38 COL 1
     SPACE(0.00) SKIP(2.46)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte DAOT - Costos".


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
{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b-archivo IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       b-archivo:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-proceso IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RB-OUTPUT-FILE IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RB-OUTPUT-FILE:HIDDEN IN FRAME D-Dialog           = TRUE.

ASSIGN 
       RECT-48:HIDDEN IN FRAME D-Dialog           = TRUE.

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte DAOT - Costos */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-archivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-archivo D-Dialog
ON CHOOSE OF b-archivo IN FRAME D-Dialog /* Archivos.. */
DO:
     SYSTEM-DIALOG GET-FILE RB-OUTPUT-FILE
        TITLE      "Archivo de Impresi¢n ..."
        FILTERS    "Archivos Impresi¢n (*.txt)"   "*.txt",
                   "Todos (*.*)"   "*.*"
        INITIAL-DIR "./txt"
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
      
    IF OKpressed = TRUE THEN
        RB-OUTPUT-FILE:SCREEN-VALUE = RB-OUTPUT-FILE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-impresoras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-impresoras D-Dialog
ON CHOOSE OF B-impresoras IN FRAME D-Dialog
DO:
    SYSTEM-DIALOG PRINTER-SETUP.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-imprime D-Dialog
ON CHOOSE OF B-imprime IN FRAME D-Dialog /* Imprimir */
DO:
   
    ASSIGN COMBO-Mes1 COMBO-Mes2 FILL-IN-Nrouit FILL-IN-Periodo FILL-IN-uit.

    I-NroMes1 = LOOKUP(COMBO-MES1,COMBO-MES1:LIST-ITEMS).
    I-NroMes2 = LOOKUP(COMBO-MES2,COMBO-MES1:LIST-ITEMS).

    IF I-NroMes2 < I-NroMes1 then do:
        MESSAGE
            "Rango de meses mal ingresado"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U to COMBO-MES2.
        RETURN NO-APPLY.
    END.
  
    P-largo   = 66.
    P-Copias  = INPUT FRAME D-DIALOG RB-NUMBER-COPIES.
    P-pagIni  = INPUT FRAME D-DIALOG RB-BEGIN-PAGE.
    P-pagfin  = INPUT FRAME D-DIALOG RB-END-PAGE.
    P-select  = INPUT FRAME D-DIALOG RADIO-SET-1.
    P-archivo = INPUT FRAME D-DIALOG RB-OUTPUT-FILE.
    P-detalle = "Impresora Local (EPSON)".
    P-name    = "Epson E/F/J/RX/LQ".
    P-device  = "PRN".

    IF P-select = 2 THEN
        P-archivo = SESSION:TEMP-DIRECTORY + 
            STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
    ELSE RUN setup-print.

    IF P-select <> 1 THEN P-copias = 1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-imprime-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-imprime-2 D-Dialog
ON CHOOSE OF B-imprime-2 IN FRAME D-Dialog /* Imprimir */
DO:
   
    ASSIGN COMBO-Mes1 COMBO-Mes2 FILL-IN-Nrouit FILL-IN-Periodo FILL-IN-uit.

    I-NroMes1 = LOOKUP(COMBO-MES1,COMBO-MES1:LIST-ITEMS).
    I-NroMes2 = LOOKUP(COMBO-MES2,COMBO-MES1:LIST-ITEMS).

    IF I-NroMes2 < I-NroMes1 then do:
        MESSAGE
            "Rango de meses mal ingresado"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U to COMBO-MES2.
        RETURN NO-APPLY.
    END.
  
    RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 D-Dialog
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME D-Dialog
DO:
    IF SELF:SCREEN-VALUE = "3"
    THEN ASSIGN b-archivo:VISIBLE = YES
                RB-OUTPUT-FILE:VISIBLE = YES
                b-archivo:SENSITIVE = YES
                RB-OUTPUT-FILE:SENSITIVE = YES.
    ELSE ASSIGN b-archivo:VISIBLE = NO
                RB-OUTPUT-FILE:VISIBLE = NO
                b-archivo:SENSITIVE = NO
                RB-OUTPUT-FILE:SENSITIVE = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */

IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */

DO WITH FRAME {&FRAME-NAME}:
    COMBO-Mes1:SCREEN-VALUE = ENTRY(S-NroMes,COMBO-Mes1:LIST-ITEMS).
    COMBO-Mes2:SCREEN-VALUE = ENTRY(S-NroMes,COMBO-Mes2:LIST-ITEMS).
    FILL-IN-Periodo = s-periodo.
END.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  PTO                  = SESSION:SET-WAIT-STATE("").    
  l-immediate-display  = SESSION:IMMEDIATE-DISPLAY.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  RUN disable_UI.

  SESSION:IMMEDIATE-DISPLAY = YES.

  DO c-Copias = 1 to P-copias ON ERROR UNDO, LEAVE
                                ON STOP UNDO, LEAVE:
        OUTPUT STREAM report TO NUL PAGED PAGE-SIZE 1000.
        c-Pagina = 0.
        RUN IMPRIMIR.
        OUTPUT STREAM report CLOSE.        
  END.
  OUTPUT STREAM report CLOSE.        
  SESSION:IMMEDIATE-DISPLAY =   l-immediate-display.
  
  IF NOT LASTKEY = KEYCODE("ESC") AND P-select = 2 THEN DO: 
    RUN bin/_vcat.p ( P-archivo ). 
  END.    
  HIDE FRAME F-Mensaje.
  RETURN.
END.

RUN disable_UI.

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
  DISPLAY FILL-IN-Periodo FILL-IN-Nrouit FILL-IN-uit COMBO-Mes1 COMBO-Mes2 
          FILL-IN-proceso RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE FILL-IN-Periodo FILL-IN-Nrouit FILL-IN-uit COMBO-Mes1 COMBO-Mes2 
         RADIO-SET-1 B-impresoras RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
         B-imprime B-cancela B-ayuda RECT-48 RECT-5 B-imprime-2 
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

define var x-mesdesde as CHARACTER NO-UNDO.
define var x-meshasta as CHARACTER NO-UNDO.
define var s-codope as char init "060,081" NO-UNDO.
define var i as integer NO-UNDO.
define var x-ruc as char NO-UNDO.
define var x-nompro as char NO-UNDO.
DEFINE VAR x-Debe AS DECIMAL NO-UNDO.
DEFINE VAR x-Haber AS DECIMAL NO-UNDO.
DEFINE VAR x-Import AS DECIMAL NO-UNDO.
DEFINE VAR x-Persona AS CHAR NO-UNDO.
DEFINE VAR x-CodDoc AS CHAR NO-UNDO.
DEFINE VAR x-NroDoc AS CHAR NO-UNDO.
DEFINE VAR x-Nombre LIKE cb-dmov.GloDoc NO-UNDO.


DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

DEFINE BUFFER b_compra FOR coacompra.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).


DISPLAY "Procesando información..." @ FILL-IN-Proceso WITH FRAME {&FRAME-NAME}.
FOR EACH cb-cmov NO-LOCK WHERE
    cb-cmov.CodCia = s-CodCia AND
    cb-cmov.Periodo = s-Periodo AND
    cb-cmov.NroMes >= I-NroMes1 AND
    cb-cmov.NroMes <= I-NroMes2 AND
    LOOKUP(cb-cmov.CodOpe,s-codope) > 0
    BREAK BY cb-cmov.NroAst:
    FOR EACH cb-dmov NO-LOCK WHERE
        cb-dmov.CodCia = cb-cmov.CodCia AND
        cb-dmov.Periodo = cb-cmov.Periodo AND
        cb-dmov.NroMes = cb-cmov.NroMes AND
        cb-dmov.CodOpe = cb-cmov.CodOpe AND
        cb-dmov.NroAst = cb-cmov.NroAst
        BREAK BY cb-dmov.CodDiv BY cb-dmov.NroAst:
        IF FIRST-OF (cb-dmov.CodDiv) THEN DO:
            x-NomPro = "".
            x-Ruc = "".
            x-Persona = 'J'.
            x-Import = 0.
            x-CodDoc = "".
            x-NroDoc = "".
        END.
        IF NOT tpomov THEN DO:
            x-debe  = ImpMn1.
            x-haber = 0.
        END.
        ELSE DO:
            x-debe  = 0.
            x-haber = ImpMn1.
        END.
        CASE cb-dmov.TM:
            WHEN 3 THEN x-Import = x-Import + (x-Debe - x-Haber).
            WHEN 4 THEN x-Import = x-Import + (x-Debe - x-Haber).
            WHEN 8 THEN DO:
                x-CodDoc = cb-dmov.CodDoc.
                x-NroDoc = cb-dmov.NroDoc.
                FIND GN-PROV WHERE
                    GN-PROV.CodCia = pv-codcia AND
                    GN-PROV.codPro = cb-dmov.CodAux
                    NO-LOCK NO-ERROR.
                IF AVAILABLE GN-PROV THEN
                    ASSIGN
                        x-NomPro = GN-PROV.NomPro
                        x-ruc = GN-PROV.Ruc
                        x-Persona = gn-prov.persona.
                ELSE x-NomPro = cb-dmov.GloDoc.
            END.
        END CASE.
        IF LAST-OF(cb-dmov.CodDiv) AND
            substring(x-ruc,1,1) <> "N" THEN DO:
            CREATE CoaCompra.
            ASSIGN
                CoaCompra.Ruc = x-Ruc
                CoaCompra.NomPro = x-NomPro
                CoaCompra.Persona = x-Persona
                CoaCompra.ImpLin = x-Import
                CoaCompra.Fecha = cb-cmov.FchAst
                CoaCompra.CodDoc = x-CodDoc
                CoaCompra.NroDoc = x-NroDoc
                CoaCompra.NroAst = cb-dmov.NroAst.
        END.
    END. /* FOR EACH cb-dmov... */
END. /* FOR EACH cb-cmov... */

/* Verifica Montos */
FOR EACH coacompra NO-LOCK WHERE
    LENGTH(coacompra.ruc) = 11
    BREAK BY coacompra.ruc DESCENDING
    BY coacompra.CodDoc BY coacompra.NroDoc:
    IF FIRST-OF(coacompra.ruc) THEN DO:
        DISPLAY
            "Procesando R.U.C. " + coacompra.ruc @
            FILL-IN-Proceso WITH FRAME {&FRAME-NAME}.        
        x-Import = 0.
    END.
    x-Import = x-Import + CoaCompra.ImpLin.
    IF LAST-OF(coacompra.ruc) THEN DO:
        IF x-Import < FILL-IN-uit * FILL-IN-nrouit THEN
            /* Depura Proveedor que no supera el tope */
            FOR EACH b_compra WHERE b_compra.ruc = coacompra.ruc:
                DELETE b_compra.
            END.
    END.
END.

x-mesdesde = COMBO-Mes1.
x-meshasta = COMBO-Mes2.

DISPLAY "" @ FILL-IN-Proceso WITH FRAME {&FRAME-NAME}.

chWorkSheet:Range("D3"):Value = "REPORTE DAOT INGRESOS".
chWorkSheet:Range("A4"):Value = "RUC".
chWorkSheet:Range("B4"):Value = "PERSONA".
chWorkSheet:Range("C4"):Value = "NOMBRE".
chWorkSheet:Range("D4"):Value = "FECHA".
chWorkSheet:Range("E4"):Value = "CODIGO".
chWorkSheet:Range("F4"):Value = "NÚMERO".
chWorkSheet:Range("G4"):Value = "IMPORTE".
chWorkSheet:Range("H4"):Value = "NRO AST".

chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("F"):NumberFormat = "@".
chWorkSheet:Columns("H"):NumberFormat = "@".

iCount = 4.
FOR EACH coacompra NO-LOCK WHERE
    LENGTH(coacompra.ruc) = 11
    BREAK BY coacompra.ruc DESCENDING
    BY coacompra.CodDoc BY coacompra.NroDoc:
    
    ACCUMULATE coacompra.Implin (SUB-TOTAL BY coacompra.ruc).
    ACCUMULATE coacompra.Implin (TOTAL).

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = coacompra.Ruc.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = coacompra.Persona.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = coacompra.NomPro.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = coacompra.Fecha.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = coacompra.CodDoc.

    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = coacompra.NroDoc.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = coacompra.Implin.

    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = CoaCompra.NroAst.

    /***

IF LAST-OF(coacompra.ruc) THEN DO:
    UNDERLINE STREAM REPORT
        coacompra.Implin
        WITH FRAME f-cab.
    DISPLAY STREAM REPORT
        "TOTAL R.U.C. " + coacompra.ruc @ coacompra.NomPro
        ACCUM SUB-TOTAL BY coacompra.ruc coacompra.Implin @ coacompra.Implin
        WITH FRAME f-cab.
END.
IF LAST(coacompra.ruc) THEN DO:
    UNDERLINE STREAM REPORT
        coacompra.Implin
        WITH FRAME f-cab.
    DISPLAY STREAM REPORT
        "TOTAL GENERAL" @ coacompra.NomPro
        ACCUM TOTAL coacompra.Implin @ coacompra.Implin
        WITH FRAME f-cab.
END.
    ****/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR D-Dialog 
PROCEDURE IMPRIMIR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define var x-mesdesde as CHARACTER NO-UNDO.
define var x-meshasta as CHARACTER NO-UNDO.
define var s-codope as char init "060,081" NO-UNDO.
define var i as integer NO-UNDO.
define var x-ruc as char NO-UNDO.
define var x-nompro as char NO-UNDO.
DEFINE VAR x-Debe AS DECIMAL NO-UNDO.
DEFINE VAR x-Haber AS DECIMAL NO-UNDO.
DEFINE VAR x-Import AS DECIMAL NO-UNDO.
DEFINE VAR x-Persona AS CHAR NO-UNDO.
DEFINE VAR x-CodDoc AS CHAR NO-UNDO.
DEFINE VAR x-NroDoc AS CHAR NO-UNDO.
DEFINE VAR x-Nombre LIKE cb-dmov.GloDoc NO-UNDO.

DEFINE BUFFER b_compra FOR coacompra.

DISPLAY "Procesando información..." @ FILL-IN-Proceso WITH FRAME {&FRAME-NAME}.
FOR EACH cb-cmov NO-LOCK WHERE
    cb-cmov.CodCia = s-CodCia AND
    cb-cmov.Periodo = s-Periodo AND
    cb-cmov.NroMes >= I-NroMes1 AND
    cb-cmov.NroMes <= I-NroMes2 AND
    LOOKUP(cb-cmov.CodOpe,s-codope) > 0
    BREAK BY cb-cmov.NroAst:
    FOR EACH cb-dmov NO-LOCK WHERE
        cb-dmov.CodCia = cb-cmov.CodCia AND
        cb-dmov.Periodo = cb-cmov.Periodo AND
        cb-dmov.NroMes = cb-cmov.NroMes AND
        cb-dmov.CodOpe = cb-cmov.CodOpe AND
        cb-dmov.NroAst = cb-cmov.NroAst
        BREAK BY cb-dmov.CodDiv BY cb-dmov.NroAst:
        IF FIRST-OF (cb-dmov.CodDiv) THEN DO:
            x-NomPro = "".
            x-Ruc = "".
            x-Persona = 'J'.
            x-Import = 0.
            x-CodDoc = "".
            x-NroDoc = "".
        END.
        IF NOT tpomov THEN DO:
            x-debe  = ImpMn1.
            x-haber = 0.
        END.
        ELSE DO:
            x-debe  = 0.
            x-haber = ImpMn1.
        END.
        CASE cb-dmov.TM:
            WHEN 3 THEN x-Import = x-Import + (x-Debe - x-Haber).
            WHEN 4 THEN x-Import = x-Import + (x-Debe - x-Haber).
            WHEN 8 THEN DO:
                x-CodDoc = cb-dmov.CodDoc.
                x-NroDoc = cb-dmov.NroDoc.
                FIND GN-PROV WHERE
                    GN-PROV.CodCia = pv-codcia AND
                    GN-PROV.codPro = cb-dmov.CodAux
                    NO-LOCK NO-ERROR.
                IF AVAILABLE GN-PROV THEN
                    ASSIGN
                        x-NomPro = GN-PROV.NomPro
                        x-ruc = GN-PROV.Ruc
                        x-Persona = gn-prov.persona.
                ELSE x-NomPro = cb-dmov.GloDoc.
            END.
        END CASE.
        IF LAST-OF(cb-dmov.CodDiv) AND
            substring(x-ruc,1,1) <> "N" THEN DO:
            CREATE CoaCompra.
            ASSIGN
                CoaCompra.Ruc = x-Ruc
                CoaCompra.NomPro = x-NomPro
                CoaCompra.Persona = x-Persona
                CoaCompra.ImpLin = x-Import
                CoaCompra.Fecha = cb-cmov.FchAst
                CoaCompra.CodDoc = x-CodDoc
                CoaCompra.NroDoc = x-NroDoc
                CoaCompra.NroAst = cb-dmov.NroAst.
        END.
    END. /* FOR EACH cb-dmov... */
END. /* FOR EACH cb-cmov... */

/* Verifica Montos */
FOR EACH coacompra NO-LOCK WHERE
    LENGTH(coacompra.ruc) = 11
    BREAK BY coacompra.ruc DESCENDING
    BY coacompra.CodDoc BY coacompra.NroDoc:
    IF FIRST-OF(coacompra.ruc) THEN DO:
        DISPLAY
            "Procesando R.U.C. " + coacompra.ruc @
            FILL-IN-Proceso WITH FRAME {&FRAME-NAME}.
        x-Import = 0.
    END.
    x-Import = x-Import + CoaCompra.ImpLin.
    IF LAST-OF(coacompra.ruc) THEN DO:
        IF x-Import < FILL-IN-uit * FILL-IN-nrouit THEN
            /* Depura Proveedor que no supera el tope */
            FOR EACH b_compra WHERE b_compra.ruc = coacompra.ruc:
                DELETE b_compra.
            END.
    END.
END.

x-mesdesde = COMBO-Mes1.
x-meshasta = COMBO-Mes2.

/* Impresion */
DEFINE FRAME f-cab
    coacompra.Ruc       COLUMN-LABEL "R.U.C." FORMAT "x(11)"
    coacompra.Persona   COLUMN-LABEL "P" FORMAT "x"
    coacompra.NomPro    COLUMN-LABEL "Nombre/Razón Social" FORMAT "x(50)"
    coacompra.Fecha     COLUMN-LABEL "Fecha"
    coacompra.CodDoc    COLUMN-LABEL "Cod"
    coacompra.NroDoc    COLUMN-LABEL "Documento" FORMAT "x(12)"
    coacompra.Implin    COLUMN-LABEL "Importe" FORMAT "->>,>>>,>>>,>>9.99"
    CoaCompra.NroAst
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
    {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
    {&PRN2} + {&PRN6A} + "Desde : " AT 1 FORMAT "X(10)" x-mesdesde FORMAT "X(10)" "A" x-meshasta + {&PRN6B} + {&PRN3} FORMAT "X(12)"
    {&PRN4} + "Fecha : " AT 92 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
    "Hora  : " AT 92 STRING(TIME,"HH:MM:SS") SKIP
    WITH WIDTH 165 STREAM-IO DOWN.

DISPLAY "" @ FILL-IN-Proceso WITH FRAME {&FRAME-NAME}.

FRAME F-Mensaje:TITLE = FRAME D-DIALOG:TITLE.
VIEW FRAME F-Mensaje.  
PAUSE 0.

FOR EACH coacompra NO-LOCK WHERE
    LENGTH(coacompra.ruc) = 11
    BREAK BY coacompra.ruc DESCENDING
    BY coacompra.CodDoc BY coacompra.NroDoc:
    {&NEW-PAGE}.
    ACCUMULATE coacompra.Implin (SUB-TOTAL BY coacompra.ruc).
    ACCUMULATE coacompra.Implin (TOTAL).
    DISPLAY STREAM REPORT
        coacompra.Ruc
        coacompra.Persona
        coacompra.NomPro
        coacompra.Fecha
        coacompra.CodDoc
        coacompra.NroDoc
        coacompra.Implin
        CoaCompra.NroAst
        WITH FRAME f-cab.
    IF LAST-OF(coacompra.ruc) THEN DO:
        UNDERLINE STREAM REPORT
            coacompra.Implin
            WITH FRAME f-cab.
        DISPLAY STREAM REPORT
            "TOTAL R.U.C. " + coacompra.ruc @ coacompra.NomPro
            ACCUM SUB-TOTAL BY coacompra.ruc coacompra.Implin @ coacompra.Implin
            WITH FRAME f-cab.
    END.
    IF LAST(coacompra.ruc) THEN DO:
        UNDERLINE STREAM REPORT
            coacompra.Implin
            WITH FRAME f-cab.
        DISPLAY STREAM REPORT
            "TOTAL GENERAL" @ coacompra.NomPro
            ACCUM TOTAL coacompra.Implin @ coacompra.Implin
            WITH FRAME f-cab.
    END.
END.
OUTPUT STREAM REPORT CLOSE.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NEW-PAGE D-Dialog 
PROCEDURE NEW-PAGE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    c-Pagina = c-Pagina + 1.
    IF c-Pagina > P-pagfin
    THEN RETURN ERROR.
    DISPLAY c-Pagina WITH FRAME f-mensaje.
    IF c-Pagina > 1 THEN PAGE STREAM report.
    IF P-pagini = c-Pagina 
    THEN DO:
        OUTPUT STREAM report CLOSE.
        IF P-select = 1 
        THEN DO:
               OUTPUT STREAM report TO PRINTER NO-MAP NO-CONVERT UNBUFFERED
                    PAGED PAGE-SIZE 1000.
               PUT STREAM report CONTROL P-reset NULL P-flen NULL P-config NULL.
        END.
        ELSE DO:
            OUTPUT STREAM report TO VALUE ( P-archivo ) NO-MAP NO-CONVERT UNBUFFERED
                 PAGED PAGE-SIZE 1000.
            IF P-select = 3 THEN
                PUT STREAM report CONTROL P-reset P-flen P-config.
        END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remvar D-Dialog 
PROCEDURE remvar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER IN-VAR AS CHARACTER.
    DEFINE OUTPUT PARAMETER OU-VAR AS CHARACTER.
    DEFINE VARIABLE P-pos AS INTEGER.
    OU-VAR = IN-VAR.
    IF P-select = 2 THEN DO:
        OU-VAR = "".
        RETURN.
    END.
    P-pos =  INDEX(OU-VAR, "[NULL]" ).
    IF P-pos <> 0
    THEN OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) +
                     CHR(0) + SUBSTR(OU-VAR, P-pos + 6).
    P-pos =  INDEX(OU-VAR, "[#B]" ).
    IF P-pos <> 0
    THEN OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) +
                     CHR(P-Largo) + SUBSTR(OU-VAR, P-pos + 4).
    P-pos =  INDEX(OU-VAR, "[#]" ).
    IF P-pos <> 0
    THEN OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) +
                     STRING(P-Largo, ">>9" ) + SUBSTR(OU-VAR, P-pos + 3).
    RETURN.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Setup-Print D-Dialog 
PROCEDURE Setup-Print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND integral.P-Codes WHERE integral.P-Codes.Name = P-name NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.P-Codes
    THEN DO:
        MESSAGE "Invalido Tabla de Impresora" SKIP
                "configurado al Terminal" XTerm
                VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* Configurando Variables de Impresion */
    RUN RemVar (INPUT integral.P-Codes.Reset,    OUTPUT P-Reset).
    RUN RemVar (INPUT integral.P-Codes.Flen,     OUTPUT P-Flen).
    RUN RemVar (INPUT integral.P-Codes.C6lpi,    OUTPUT P-6lpi).
    RUN RemVar (INPUT integral.P-Codes.C8lpi,    OUTPUT P-8lpi).
    RUN RemVar (INPUT integral.P-Codes.C10cpi,   OUTPUT P-10cpi).
    RUN RemVar (INPUT integral.P-Codes.C12cpi,   OUTPUT P-12cpi).
    RUN RemVar (INPUT integral.P-Codes.C15cpi,   OUTPUT P-15cpi).
    RUN RemVar (INPUT integral.P-Codes.C20cpi,   OUTPUT P-20cpi).
    RUN RemVar (INPUT integral.P-Codes.Landscap, OUTPUT P-Landscap).
    RUN RemVar (INPUT integral.P-Codes.Portrait, OUTPUT P-Portrait).
    RUN RemVar (INPUT integral.P-Codes.DobleOn,  OUTPUT P-DobleOn).
    RUN RemVar (INPUT integral.P-Codes.DobleOff, OUTPUT P-DobleOff).
    RUN RemVar (INPUT integral.P-Codes.BoldOn,   OUTPUT P-BoldOn).
    RUN RemVar (INPUT integral.P-Codes.BoldOff,  OUTPUT P-BoldOff).
    RUN RemVar (INPUT integral.P-Codes.UlineOn,  OUTPUT P-UlineOn).
    RUN RemVar (INPUT integral.P-Codes.UlineOff, OUTPUT P-UlineOff).
    RUN RemVar (INPUT integral.P-Codes.ItalOn,   OUTPUT P-ItalOn).
    RUN RemVar (INPUT integral.P-Codes.ItalOff,  OUTPUT P-ItalOff).
    RUN RemVar (INPUT integral.P-Codes.SuperOn,  OUTPUT P-SuperOn).
    RUN RemVar (INPUT integral.P-Codes.SuperOff, OUTPUT P-SuperOff).
    RUN RemVar (INPUT integral.P-Codes.SubOn,    OUTPUT P-SubOn).
    RUN RemVar (INPUT integral.P-Codes.SubOff,   OUTPUT P-SubOff).
    RUN RemVar (INPUT integral.P-Codes.Proptnal, OUTPUT P-Proptnal).
    RUN RemVar (INPUT integral.P-Codes.Lpi,      OUTPUT P-Lpi).

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

