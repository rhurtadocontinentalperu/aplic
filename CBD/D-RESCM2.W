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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

/* Local Variable Definitions ---                                       */

/*
    @PRINTER2.W    VERSION 1.0
*/
{lib/def-prn.i}    
DEFINE STREAM report.

DEFINE NEW SHARED VARIABLE xTerm    AS CHARACTER INITIAL "".
DEFINE VARIABLE l-immediate-display AS LOGICAL.
DEFINE VARIABLE PTO                 AS LOGICAL.

DEFINE VARIABLE f-tipos  AS CHAR FORMAT "X(3)".
DEFINE VARIABLE T-CMPBTE AS CHAR INIT "".
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE T-CLIEN  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-TIP    AS CHAR FORMAT "X(2)".
DEFINE VAR C AS INTEGER.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR s-Periodo AS INTEGER.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHAR.

 DEFINE VAR ESTADO AS CHARACTER.

DEF TEMP-TABLE Detalle LIKE Ccbcdocu
    INDEX Llave01 AS PRIMARY nomcli.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-Serie FILL-IN-coddiv ~
FILL-IN-coddiv-2 f-clien f-vende FILL-IN-CndVta RADIO-SET-Mon RADIO-SET-Ruc ~
R-Condic f-tipo R-Estado f-desde f-hasta FILL-IN-uit RADIO-SET-1 ~
B-impresoras RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE B-imprime B-cancela ~
B-ayuda B-imprime-2 RECT-48 RECT-5 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Serie FILL-IN-coddiv ~
FILL-IN-coddiv-2 f-clien f-nomcli f-vende f-nomven FILL-IN-CndVta ~
FILL-IN-Descripcion RADIO-SET-Mon RADIO-SET-Ruc R-Condic f-tipo R-Estado ~
f-desde f-hasta FILL-IN-uit RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE ~
RB-END-PAGE 

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

DEFINE VARIABLE f-tipo AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Tipo Cmpbte." 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "Todos","Boleta","Factura","N/C","N/D" 
     DROP-DOWN-LIST
     SIZE 12 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE f-clien AS CHARACTER FORMAT "XXXXXXXXXXX":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .69 NO-UNDO.

DEFINE VARIABLE f-nomven AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .69 NO-UNDO.

DEFINE VARIABLE f-vende AS CHARACTER FORMAT "XXX":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-CndVta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cond. Venta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-coddiv AS CHARACTER FORMAT "X(5)":U INITIAL "00000" 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-coddiv-2 AS CHARACTER FORMAT "X(5)":U INITIAL "00000" 
     LABEL "Hasta División" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Descripcion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Serie AS CHARACTER FORMAT "X(4)":U 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

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

DEFINE VARIABLE R-Condic AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "C/Totales", 1,
"S/Totales", 2
     SIZE 14 BY 1.12
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE R-Estado AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pendientes", "P",
"Anulados", "A",
"Cancelados", "C",
"Todos", ""
     SIZE 14 BY 2.27
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3
     FONT 6 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Mon AS LOGICAL INITIAL yes 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Sí", yes,
"No", no
     SIZE 11 BY .77
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Ruc AS LOGICAL INITIAL yes 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Sí", yes,
"No", no
     SIZE 11 BY .77
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 5.77.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 3.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-Serie AT ROW 2.15 COL 9 COLON-ALIGNED
     FILL-IN-coddiv AT ROW 3.12 COL 9 COLON-ALIGNED
     FILL-IN-coddiv-2 AT ROW 3.12 COL 28 COLON-ALIGNED
     f-clien AT ROW 4.04 COL 9 COLON-ALIGNED
     f-nomcli AT ROW 4.04 COL 20.29 COLON-ALIGNED NO-LABEL
     f-vende AT ROW 4.77 COL 9 COLON-ALIGNED
     f-nomven AT ROW 4.77 COL 20.29 COLON-ALIGNED NO-LABEL
     FILL-IN-CndVta AT ROW 5.62 COL 9 COLON-ALIGNED
     FILL-IN-Descripcion AT ROW 5.62 COL 19 COLON-ALIGNED NO-LABEL
     RADIO-SET-Mon AT ROW 1.38 COL 35 NO-LABEL
     RADIO-SET-Ruc AT ROW 2.15 COL 35 NO-LABEL
     R-Condic AT ROW 1.23 COL 51.29 NO-LABEL
     f-tipo AT ROW 2.69 COL 49.86 COLON-ALIGNED
     R-Estado AT ROW 1.23 COL 67 NO-LABEL
     f-desde AT ROW 4.85 COL 52 COLON-ALIGNED
     f-hasta AT ROW 4.85 COL 70 COLON-ALIGNED
     FILL-IN-uit AT ROW 5.62 COL 70 COLON-ALIGNED
     RADIO-SET-1 AT ROW 7.92 COL 2.57 NO-LABEL
     B-impresoras AT ROW 8.92 COL 15.57
     b-archivo AT ROW 9.92 COL 15.57
     RB-NUMBER-COPIES AT ROW 8.08 COL 70 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 9.08 COL 70 COLON-ALIGNED
     RB-END-PAGE AT ROW 10.08 COL 70 COLON-ALIGNED
     RB-OUTPUT-FILE AT ROW 10.15 COL 19.86 COLON-ALIGNED NO-LABEL
     B-imprime AT ROW 11.96 COL 41
     B-cancela AT ROW 11.96 COL 55
     B-ayuda AT ROW 11.96 COL 69
     B-imprime-2 AT ROW 11.96 COL 27 WIDGET-ID 2
     " Rango de Fechas" VIEW-AS TEXT
          SIZE 16 BY .62 AT ROW 4.08 COL 59
          BGCOLOR 8 FONT 6
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 83.43 BY .62 AT ROW 6.77 COL 1.29
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "Reporte en S/.:" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 1.38 COL 21.43
          FONT 6
     "Con R.U.C..:" VIEW-AS TEXT
          SIZE 10.43 BY .62 AT ROW 2.15 COL 24
          FONT 6
     RECT-48 AT ROW 1 COL 1
     RECT-5 AT ROW 7.5 COL 1
     SPACE(0.00) SKIP(2.61)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte DAOT - Ingresos".


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

/* SETTINGS FOR FILL-IN f-nomcli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-nomven IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Descripcion IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte DAOT - Ingresos */
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
   
  ASSIGN f-Desde f-hasta f-vende f-clien f-tipo R-Estado R-Condic
    FILL-IN-CndVta FILL-IN-Descripcion FILL-IN-Serie
    FILL-IN-coddiv FILL-IN-coddiv-2 RADIO-SET-Mon RADIO-SET-Ruc FILL-IN-uit.
  
  IF f-desde = ? then do: MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.   
  END.
  IF f-hasta = ? then do: MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-hasta.
     RETURN NO-APPLY.   
  END.   
  IF f-desde > f-hasta then do: MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.
  END.
  
  CASE f-tipo:screen-value :
       WHEN "Todos" THEN DO:
            f-tipos  = "FAC,BOL,N/C,N/D".
            T-cmpbte = "  RESUMEN DE COMPROBANTES   ". 
       END.     
       WHEN "Boleta"  THEN DO: 
            f-tipos = "BOL". 
            T-cmpbte = "     RESUMEN DE BOLETAS     ". 
       END.            
       WHEN "Factura" THEN DO: 
            f-tipos = "FAC".
            T-cmpbte = "     RESUMEN DE FACTURAS    ". 
       END.     
       WHEN "N/C"      THEN DO: 
            f-tipos = "N/C".
            T-cmpbte = "RESUMEN DE NOTAS DE CREDITO ". 
       END.     
       WHEN "N/D"      THEN DO: 
            f-tipos = "N/D".
            T-cmpbte = " RESUMEN DE NOTAS DE DEBITO ". 
       END.                          
  END.          
  IF f-vende <> "" THEN T-vende = "Vendedor :  " + f-vende + "  " + f-nomven.
  IF f-clien <> "" THEN T-clien = "Cliente :  " + f-clien.
  
  P-largo   = 66.
  P-Copias  = INPUT FRAME D-DIALOG RB-NUMBER-COPIES.
  P-pagIni  = INPUT FRAME D-DIALOG RB-BEGIN-PAGE.
  P-pagfin  = INPUT FRAME D-DIALOG RB-END-PAGE.
  P-select  = INPUT FRAME D-DIALOG RADIO-SET-1.
  P-archivo = INPUT FRAME D-DIALOG RB-OUTPUT-FILE.
  P-detalle = "Impresora Local (EPSON)".
  P-name    = "Epson E/F/J/RX/LQ".
  P-device  = "PRN".
     
  IF P-select = 2 
     THEN P-archivo = SESSION:TEMP-DIRECTORY + 
          STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
  ELSE RUN setup-print.      
     IF P-select <> 1 
     THEN P-copias = 1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-imprime-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-imprime-2 D-Dialog
ON CHOOSE OF B-imprime-2 IN FRAME D-Dialog /* Imprimir */
DO:
   
  ASSIGN f-Desde f-hasta f-vende f-clien f-tipo R-Estado R-Condic
    FILL-IN-CndVta FILL-IN-Descripcion FILL-IN-Serie
    FILL-IN-coddiv FILL-IN-coddiv-2 RADIO-SET-Mon RADIO-SET-Ruc FILL-IN-uit.
  
  IF f-desde = ? then do: MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.   
  END.
  IF f-hasta = ? then do: MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-hasta.
     RETURN NO-APPLY.   
  END.   
  IF f-desde > f-hasta then do: MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.
  END.
  
  CASE f-tipo:screen-value :
       WHEN "Todos" THEN DO:
            f-tipos  = "FAC,BOL,N/C,N/D".
            T-cmpbte = "  RESUMEN DE COMPROBANTES   ". 
       END.     
       WHEN "Boleta"  THEN DO: 
            f-tipos = "BOL". 
            T-cmpbte = "     RESUMEN DE BOLETAS     ". 
       END.            
       WHEN "Factura" THEN DO: 
            f-tipos = "FAC".
            T-cmpbte = "     RESUMEN DE FACTURAS    ". 
       END.     
       WHEN "N/C"      THEN DO: 
            f-tipos = "N/C".
            T-cmpbte = "RESUMEN DE NOTAS DE CREDITO ". 
       END.     
       WHEN "N/D"      THEN DO: 
            f-tipos = "N/D".
            T-cmpbte = " RESUMEN DE NOTAS DE DEBITO ". 
       END.                          
  END.          
  IF f-vende <> "" THEN T-vende = "Vendedor :  " + f-vende + "  " + f-nomven.
  IF f-clien <> "" THEN T-clien = "Cliente :  " + f-clien.

  RUN Excel.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-clien
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-clien D-Dialog
ON LEAVE OF f-clien IN FRAME D-Dialog /* Cliente */
DO:
  F-clien = "".
  IF F-clien:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
          gn-clie.Codcli = F-clien:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie THEN F-Nomcli = gn-clie.Nomcli.
  END.
  DISPLAY F-NomCli WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-vende
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-vende D-Dialog
ON LEAVE OF f-vende IN FRAME D-Dialog /* Vendedor */
DO:
  F-vende = "".
  IF F-vende:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = F-vende:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
  END.
  DISPLAY F-NomVen WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CndVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CndVta D-Dialog
ON LEAVE OF FILL-IN-CndVta IN FRAME D-Dialog /* Cond. Venta */
DO:
  FILL-IN-Descripcion:SCREEN-VALUE = ''.
  FIND gn-convt WHERE gn-convt.codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt THEN FILL-IN-Descripcion:SCREEN-VALUE = gn-ConVt.Nombr.
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

ASSIGN /*FILL-IN-3 = S-CODDIV*/
       F-DESDE   = DATE(1,1,s-periodo)
       F-HASTA   = DATE(12,31,s-periodo).

IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  PTO                  = SESSION:SET-WAIT-STATE("").    
  l-immediate-display  = SESSION:IMMEDIATE-DISPLAY.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  RUN disable_UI.

  FRAME F-Mensaje:TITLE =  FRAME D-DIALOG:TITLE.
  VIEW FRAME F-Mensaje.  
  PAUSE 0.           
  SESSION:IMMEDIATE-DISPLAY = YES.

  DO c-Copias = 1 to P-copias ON ERROR UNDO, LEAVE
                                ON STOP UNDO, LEAVE:
        OUTPUT STREAM report TO NUL PAGED PAGE-SIZE 1000.
        c-Pagina = 0.
        /*RUN IMPRIMIR.*/
        RUN IMPRIMIR-1.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Factor AS DEC NO-UNDO.

EMPTY TEMP-TABLE Detalle.

FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv >= FILL-IN-coddiv 
    AND gn-divi.coddiv <= FILL-IN-coddiv-2
    NO-LOCK:
    FOR EACH CcbcDocu USE-INDEX llave09 WHERE
        CcbcDocu.CodCia = S-CODCIA AND
        CcbcDocu.CodDiv = gn-divi.coddiv AND 
        CcbcDocu.FchDoc >= F-desde AND
        CcbcDocu.FchDoc <= F-hasta AND 
        CcbcDocu.Codcli BEGINS f-clien AND
        CcbcDocu.CodVen BEGINS f-vende AND
        CcbcDocu.FlgEst BEGINS R-Estado AND
        CcbCDocu.FmaPgo BEGINS FILL-IN-CndVta AND
        CcbCDocu.NroDoc BEGINS FILL-IN-serie AND
        (CcbCDocu.Ruc <> "" OR NOT RADIO-SET-Ruc) AND
        /*
        LOOKUP(CcbCDocu.TpoFac,"S") = 0 AND   /* NO Servicios */
        */
        Ccbcdocu.FlgEst <> "A"      /* NO Anulados */
        NO-LOCK :
        IF LOOKUP(CcbcDocu.CodDoc,f-tipos) = 0 THEN NEXT.
/*         IF LOOKUP (Ccbcdocu.coddoc, 'FAC,BOL') > 0 AND Ccbcdocu.TpoFac = "A" THEN NEXT. */
        CREATE Detalle.
        BUFFER-COPY Ccbcdocu TO Detalle.
        IF Detalle.ImpVta = 0 THEN Detalle.ImpVta = Detalle.ImpTot.
        IF LOOKUP (Ccbcdocu.coddoc, 'FAC,BOL') > 0
            AND Ccbcdocu.FlgEst <> 'A' 
            AND LOOKUP(Ccbcdocu.TpoFac, "S,A") = 0  /* NO Servicios NO Adelantos de Campaña */
            AND Ccbcdocu.ImpTot2 > 0
            THEN DO:
            /* Recalculamos Importes */
            ASSIGN
                Detalle.ImpTot = Ccbcdocu.ImpTot - Ccbcdocu.ImpTot2.
            IF Detalle.ImpTot <= 0 THEN DO:
                ASSIGN
                    Detalle.ImpTot = 0
                    Detalle.ImpBrt = 0
                    Detalle.ImpExo = 0
                    Detalle.ImpDto = 0
                    Detalle.ImpVta = 0
                    Detalle.ImpIgv = 0.
            END.
            ELSE DO:
                x-Factor = Detalle.ImpTot / Ccbcdocu.ImpTot.
                ASSIGN
                    Detalle.ImpVta = ROUND (Ccbcdocu.ImpVta * x-Factor, 2)
                    Detalle.ImpIgv = Detalle.ImpTot - Detalle.ImpVta.
                ASSIGN
                    Detalle.ImpBrt = Detalle.ImpVta + Detalle.ImpIsc + Detalle.ImpDto + Detalle.ImpExo.
            END.
        END.
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
  DISPLAY FILL-IN-Serie FILL-IN-coddiv FILL-IN-coddiv-2 f-clien f-nomcli f-vende 
          f-nomven FILL-IN-CndVta FILL-IN-Descripcion RADIO-SET-Mon 
          RADIO-SET-Ruc R-Condic f-tipo R-Estado f-desde f-hasta FILL-IN-uit 
          RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE FILL-IN-Serie FILL-IN-coddiv FILL-IN-coddiv-2 f-clien f-vende 
         FILL-IN-CndVta RADIO-SET-Mon RADIO-SET-Ruc R-Condic f-tipo R-Estado 
         f-desde f-hasta FILL-IN-uit RADIO-SET-1 B-impresoras RB-NUMBER-COPIES 
         RB-BEGIN-PAGE RB-END-PAGE B-imprime B-cancela B-ayuda B-imprime-2 
         RECT-48 RECT-5 
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

    RUN Carga-Temporal.
    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay registros a imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    
    DEFINE VAR W-TOTBRU     AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTDSC     AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTEXO     AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVAL     AS DECIMAL EXTENT 6 INIT 0.  
    DEFINE VAR W-TOTISC     AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTIGV     AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVEN     AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR Titulo       AS CHAR INIT '' FORMAT 'x(50)'.
    DEFINE VAR dTpoCmb      LIKE gn-tcmb.venta NO-UNDO.
    DEFINE VAR x-ImpBrt     AS DEC.
    DEFINE VAR x-ImpExo     AS DEC.
    DEFINE VAR x-ImpDto     AS DEC.
    DEFINE VAR x-ImpVta     AS DEC.
    DEFINE VAR x-ImpIsc     AS DEC.
    DEFINE VAR x-ImpIgv     AS DEC.
    DEFINE VAR x-ImpTot     AS DEC.
    DEFINE VAR dFactor      AS INT.
    
    IF FILL-IN-Descripcion <> '' THEN Titulo = 'CONDICION DE VENTA: ' + FILL-IN-Descripcion.

    CASE R-Estado:
        WHEN "A" THEN ESTADO = "ANULADOS".
        WHEN "P" THEN ESTADO = "PENDIENTES".
        WHEN "C" THEN ESTADO = "CANCELADOS".
        WHEN "" THEN ESTADO = "TODOS".
    END CASE.

    chWorkSheet:Range("D3"):Value = "REPORTE DAOT INGRESOS".
    chWorkSheet:Range("A4"):Value = "DOC".
    chWorkSheet:Range("B4"):Value = "No. DOCUMENTO".
    chWorkSheet:Range("C4"):Value = "FECHA EMISION".
    chWorkSheet:Range("D4"):Value = "CLIENTE".
    chWorkSheet:Range("E4"):Value = "R.U.C".
    chWorkSheet:Range("F4"):Value = "VEND. MON".
    /**
    chWorkSheet:Range("G4"):Value = "TOTAL BRUTO".
    chWorkSheet:Range("H4"):Value = "TOTAL DSCTO".
    **/
    chWorkSheet:Range("G4"):Value = "VALOR VENTA".
    chWorkSheet:Range("H4"):Value = "I.G.V".
    chWorkSheet:Range("I4"):Value = "PRECIO VENTA".
    chWorkSheet:Range("J4"):Value = "ESTADO".
    chWorkSheet:Range("K4"):Value = "USUARIO ANULAC".

    /*Formato*/
    chWorkSheet:Columns("B"):NumberFormat = "@".
    chWorkSheet:Columns("D"):NumberFormat = "@".
    chWorkSheet:Columns("E"):NumberFormat = "@".
    

    iCount = 4.
    FOR EACH Detalle NO-LOCK BY Detalle.NomCli:
        IF Detalle.Codmon = 1 THEN X-MON = "S/.". ELSE X-MON = "US$.".

        IF Detalle.TipVta = "1" THEN X-TIP = "CT". ELSE X-TIP = "CR".

        dTpoCmb = 1.
        IF RADIO-SET-Mon THEN DO:        
            X-MON = "S/.".
            IF Detalle.Codmon <> 1 THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.fecha = Detalle.fchdoc NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN dTpoCmb = Gn-tcmb.Venta.
            END.
            IF RADIO-SET-Ruc AND
                Detalle.coddoc = "BOL" AND
                Detalle.ImpVta * dTpoCmb < FILL-IN-uit / 2 THEN NEXT.
        END.
        
        ASSIGN
            x-ImpBrt = Detalle.impbrt
            x-ImpDto = Detalle.impdto
            x-ImpExo = Detalle.impexo
            x-ImpVta = Detalle.impvta
            x-ImpIgv = Detalle.impigv
            x-ImpIsc = Detalle.impisc
            x-ImpTot = Detalle.imptot.

        CASE Detalle.FlgEst:
        WHEN "P" THEN DO:
            X-EST = "PEN".
            IF Detalle.Codmon = 1 THEN DO:
                w-totbru [1] = w-totbru [1] + x-ImpBrt * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [1] = w-totdsc [1] + x-ImpDto * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [1] = w-totexo [1] + x-ImpExo * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [1] = w-totval [1] + x-ImpVta * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [1] = w-totisc [1] + x-ImpIsc * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [1] = w-totigv [1] + x-ImpIgv * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [1] = w-totven [1] + x-ImpTot * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
            END.   
            ELSE DO:
                IF NOT RADIO-SET-Mon THEN DO:
                    w-totbru [2] = w-totbru [2] + x-ImpBrt * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [2] = w-totdsc [2] + x-ImpDto * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [2] = w-totexo [2] + x-ImpExo * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [2] = w-totval [2] + x-ImpVta * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [2] = w-totisc [2] + x-ImpIsc * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [2] = w-totigv [2] + x-ImpIgv * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [2] = w-totven [2] + x-ImpTot * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
                ELSE DO:
                    w-totbru [1] = w-totbru [1] + x-ImpBrt * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [1] = w-totdsc [1] + x-ImpDto * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [1] = w-totexo [1] + x-ImpExo * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [1] = w-totval [1] + x-ImpVta * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [1] = w-totisc [1] + x-ImpIsc * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [1] = w-totigv [1] + x-ImpIgv * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [1] = w-totven [1] + x-ImpTot * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
            END.   
        END.   
        WHEN "C" THEN DO:
            X-EST = "CAN".
            IF Detalle.Codmon = 1 THEN DO:
                w-totbru [3] = w-totbru [3] + x-ImpBrt * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [3] = w-totdsc [3] + x-ImpDto * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [3] = w-totexo [3] + x-ImpExo * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [3] = w-totval [3] + x-ImpVta * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [3] = w-totisc [3] + x-ImpIsc * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [3] = w-totigv [3] + x-ImpIgv * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [3] = w-totven [3] + x-ImpTot * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
            END.   
            ELSE DO:
                IF NOT RADIO-SET-Mon THEN DO:
                    w-totbru [4] = w-totbru [4] + x-ImpBrt * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [4] = w-totdsc [4] + x-ImpDto * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [4] = w-totexo [4] + x-ImpExo * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [4] = w-totval [4] + x-ImpVta * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [4] = w-totisc [4] + x-ImpIsc * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [4] = w-totigv [4] + x-ImpIgv * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [4] = w-totven [4] + x-ImpTot * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
                ELSE DO:
                    w-totbru [3] = w-totbru [3] + x-ImpBrt * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [3] = w-totdsc [3] + x-ImpDto * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [3] = w-totexo [3] + x-ImpExo * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [3] = w-totval [3] + x-ImpVta * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [3] = w-totisc [3] + x-ImpIsc * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [3] = w-totigv [3] + x-ImpIgv * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [3] = w-totven [3] + x-ImpTot * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
            END.                
        END.   
        WHEN "A" THEN DO:
            X-EST = "ANU".       
            IF Detalle.Codmon = 1 THEN DO:
                w-totbru [5] = w-totbru [5] + x-ImpBrt * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [5] = w-totdsc [5] + x-ImpDto * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [5] = w-totexo [5] + x-ImpExo * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [5] = w-totval [5] + x-ImpVta * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [5] = w-totisc [5] + x-ImpIsc * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [5] = w-totigv [5] + x-ImpIgv * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [5] = w-totven [5] + x-ImpTot * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
            END.   
            ELSE DO:
                IF NOT RADIO-SET-Mon THEN DO:
                    w-totbru [6] = w-totbru [6] + x-ImpBrt * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [6] = w-totdsc [6] + x-ImpDto * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [6] = w-totexo [6] + x-ImpExo * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [6] = w-totval [6] + x-ImpVta * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [6] = w-totisc [6] + x-ImpIsc * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [6] = w-totigv [6] + x-ImpIgv * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [6] = w-totven [6] + x-ImpTot * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
                ELSE DO:
                    w-totbru [5] = w-totbru [5] + x-ImpBrt * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [5] = w-totdsc [5] + x-ImpDto * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [5] = w-totexo [5] + x-ImpExo * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [5] = w-totval [5] + x-ImpVta * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [5] = w-totisc [5] + x-ImpIsc * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [5] = w-totigv [5] + x-ImpIgv * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [5] = w-totven [5] + x-ImpTot * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
            END.                
        END.
        END CASE.

        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.CodDoc.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.NroDoc.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.FchDoc.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.NomCli.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.RucCli.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.Codven.
        
        IF Detalle.CodDoc = "N/C" THEN dFactor = -1. ELSE dFactor = 1.

        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = (x-ImpVta * dTpoCmb * dFactor).
        /***
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = (x-ImpDto * dTpoCmb * dFactor).
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = (x-ImpBrt * dTpoCmb * dFactor).
        ***/
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = (x-ImpIgv * dTpoCmb * dFactor).
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = (x-ImpTot * dTpoCmb * dFactor).
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = X-EST.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.UsuAnu.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = X-TIP.

    END.

    /*

    DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
        PUT STREAM REPORT "" skip. 
    END.   
 
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "--------------------------------------------" SPACE(4) "--------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL CANCELADAS         SOLES       DOLARES" SPACE(4) "TOTAL PENDIENTES         SOLES       DOLARES" SPACE(4) "TOTAL ANULADAS           SOLES       DOLARES" SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "--------------------------------------------" SPACE(4) "--------------------------------------------" SKIP.
    PUT STREAM REPORT "Total Bruto    :" AT 1
        w-totbru[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totbru[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "Total Bruto    :"
        w-totbru[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totbru[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "Total Bruto    :"
        w-totbru[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totbru[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "Descuento      :" AT 1
        w-totdsc[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totdsc[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "Descuento      :"
        w-totdsc[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totdsc[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "Descuento      :"
        w-totdsc[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totdsc[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "Exonerado      :" AT 1
        w-totexo[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totexo[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "Exonerado      :"
        w-totexo[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totexo[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "Exonerado      :"
        w-totexo[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totexo[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "Valor de Venta :" AT 1
        w-totval[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totval[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "Valor de Venta :"
        w-totval[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totval[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "Valor de Venta :"
        w-totval[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totval[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "I.S.C.         :" AT 1
        w-totisc[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totisc[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "I.S.C.         :"
        w-totisc[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totisc[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "I.S.C.         :"
        w-totisc[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totisc[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "I.G.V.         :" AT 1
        w-totigv[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totigv[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "I.G.V.         :"
        w-totigv[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totigv[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "I.G.V.         :"
        w-totigv[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totigv[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "Precio de Venta:" AT 1
        w-totven[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totven[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "Precio de Venta:"
        w-totven[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totven[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "Precio de Venta:"
        w-totven[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totven[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    OUTPUT STREAM REPORT CLOSE.
    **/

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

    DEFINE VAR W-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
    DEFINE VAR W-TOTISC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVEN AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR Titulo AS CHAR INIT '' FORMAT 'x(50)'.
    DEFINE VAR dTpoCmb LIKE gn-tcmb.venta NO-UNDO.


    DEF VAR x-ImpBrt AS DEC.
    DEF VAR x-ImpExo AS DEC.
    DEF VAR x-ImpDto AS DEC.
    DEF VAR x-ImpVta AS DEC.
    DEF VAR x-ImpIsc AS DEC.
    DEF VAR x-ImpIgv AS DEC.
    DEF VAR x-ImpTot AS DEC.

    IF FILL-IN-Descripcion <> '' THEN
        Titulo = 'CONDICION DE VENTA: ' + FILL-IN-Descripcion.

    CASE R-Estado:
        WHEN "A" THEN ESTADO = "ANULADOS".
        WHEN "P" THEN ESTADO = "PENDIENTES".
        WHEN "C" THEN ESTADO = "CANCELADOS".
        WHEN "" THEN ESTADO = "TODOS".
    END CASE.

    DEFINE FRAME f-cab
        CcbcDocu.CodDoc FORMAT "XXX"
        CcbcDocu.NroDoc FORMAT "XXX-XXXXXX"
        CcbcDocu.FchDoc 
        CcbcDocu.NomCli FORMAT "X(23)"
        CcbcDocu.RucCli FORMAT "X(11)"
        CcbcDocu.Codven FORMAT "X(4)"
        X-MON           FORMAT "X(4)"
        CcbcDocu.ImpBrt FORMAT "->>>>,>>9.99"
        CcbcDocu.ImpDto FORMAT "->,>>9.99"
        CcbcDocu.ImpVta FORMAT "->>>>,>>9.99"
        CcbcDocu.ImpIgv FORMAT "->,>>9.99"
        CcbcDocu.ImpTot FORMAT "->>>>,>>9.99"
        X-TIP           FORMAT "X(2)"
        X-EST           FORMAT "X(3)"
        CcbCDocu.UsuAnu FORMAT "X(8)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + CcbcDocu.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + T-CMPBTE  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN4} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        ESTADO FORMAT "X(25)" SKIP
        Titulo SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                                   T O T A L      TOTAL       VALOR             P R E C I O         USUARIO " SKIP
        "DOC  DOCUMENTO  EMISION   C L I E N T E               R.U.C.  VEND MON.    BRUTO        DSCTO.      VENTA     I.G.V.   V E N T A   ESTADO ANULAC. " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------" SKIP         
        WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.         

    FOR EACH CcbcDocu NO-LOCK WHERE
        CcbcDocu.CodCia = S-CODCIA AND
        CcbcDocu.CodDiv >= FILL-IN-coddiv AND
        CcbcDocu.CodDiv <= FILL-IN-coddiv-2 AND
        CcbcDocu.FchDoc >= F-desde AND
        CcbcDocu.FchDoc <= F-hasta AND 
        LOOKUP(CcbcDocu.CodDoc,f-tipos) > 0 AND
        CcbcDocu.Codcli BEGINS f-clien AND
        CcbcDocu.CodVen BEGINS f-vende AND
        CcbcDocu.FlgEst BEGINS R-Estado AND
        CcbCDocu.FmaPgo BEGINS FILL-IN-CndVta AND
        CcbCDocu.NroDoc BEGINS FILL-IN-serie AND
        (CcbCDocu.Ruc <> "" OR NOT RADIO-SET-Ruc)
        BY CcbCDocu.NomCli:

        {&NEW-PAGE}.
        IF CcbcDocu.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".

        IF CcbcDocu.TipVta = "1" THEN X-TIP = "CT".
        ELSE X-TIP = "CR".

        dTpoCmb = 1.
        IF RADIO-SET-Mon THEN DO:        
            X-MON = "S/.".
            IF CcbcDocu.Codmon <> 1 THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.fecha = Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN dTpoCmb = Gn-tcmb.Venta.
            END.
            IF RADIO-SET-Ruc AND
                ccbcdocu.coddoc = "BOL" AND
                CcbcDocu.ImpVta * dTpoCmb < FILL-IN-uit / 2 THEN NEXT.
        END.


        ASSIGN
            x-ImpBrt = Ccbcdocu.impbrt
            x-ImpDto = Ccbcdocu.impdto
            x-ImpExo = Ccbcdocu.impexo
            x-ImpVta = Ccbcdocu.impvta
            x-ImpIgv = Ccbcdocu.impigv
            x-ImpIsc = Ccbcdocu.impisc
            x-ImpTot = Ccbcdocu.imptot.

        /* RHC 11.02.2011 ACUMULADOS APLICACION DE ANTICIPOS DE CAMPAÑA */
/*         DEF VAR x-ImpAde AS DEC NO-UNDO.                                                               */
/*         DEF VAR x-FacAde AS DEC DECIMALS 8 NO-UNDO.                                                    */
/*         x-ImpAde = 0.                                                                                  */
/*         FOR EACH Ccbdcaja NO-LOCK WHERE Ccbdcaja.codcia = s-codcia                                     */
/*             AND Ccbdcaja.coddoc = "A/C"                                                                */
/*             AND Ccbdcaja.codref = Ccbcdocu.coddoc                                                      */
/*             AND Ccbdcaja.nroref = Ccbcdocu.nrodoc:                                                     */
/*             IF Ccbcdocu.codmon = Ccbdcaja.codmon                                                       */
/*             THEN x-ImpAde = x-ImpAde + Ccbdcaja.ImpTot.                                                */
/*             ELSE x-ImpAde = x-ImpAde + ( IF Ccbdcaja.codmon = 1 THEN Ccbdcaja.ImpTot / Ccbdcaja.TpoCmb */
/*                                          ELSE Ccbdcaja.ImpTot * Ccbdcaja.TpoCmb).                      */
/*         END.                                                                                           */
/*         IF x-ImpAde > 0 THEN DO:                                                                       */
/*             IF x-ImpAde >= x-ImpTot THEN x-ImpAde = x-ImpTot.                                          */
/*             x-FacAde = x-ImpAde / x-ImpTot.                                                            */
/*             ASSIGN                                                                                     */
/*                 x-ImpVta = x-ImpVta * (1 - x-FacAde)                                                   */
/*                 x-ImpIgv = x-ImpIgv * (1 - x-FacAde)                                                   */
/*                 x-ImpTot = x-ImpTot * (1 - x-FacAde).                                                  */
/*             ASSIGN                                                                                     */
/*                 x-ImpBrt = x-ImpVta + x-ImpDto.                                                        */
/*         END.                                                                                           */
        /* *************************************************************** */

        CASE CcbcDocu.FlgEst:
        WHEN "P" THEN DO:
            X-EST = "PEN".
            IF CcbcDocu.Codmon = 1 THEN DO:
                w-totbru [1] = w-totbru [1] + x-ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [1] = w-totdsc [1] + x-ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [1] = w-totexo [1] + x-ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [1] = w-totval [1] + x-ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [1] = w-totisc [1] + x-ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [1] = w-totigv [1] + x-ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [1] = w-totven [1] + x-ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
            END.   
            ELSE DO:
                IF NOT RADIO-SET-Mon THEN DO:
                    w-totbru [2] = w-totbru [2] + x-ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [2] = w-totdsc [2] + x-ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [2] = w-totexo [2] + x-ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [2] = w-totval [2] + x-ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [2] = w-totisc [2] + x-ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [2] = w-totigv [2] + x-ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [2] = w-totven [2] + x-ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
                ELSE DO:
                    w-totbru [1] = w-totbru [1] + x-ImpBrt * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [1] = w-totdsc [1] + x-ImpDto * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [1] = w-totexo [1] + x-ImpExo * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [1] = w-totval [1] + x-ImpVta * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [1] = w-totisc [1] + x-ImpIsc * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [1] = w-totigv [1] + x-ImpIgv * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [1] = w-totven [1] + x-ImpTot * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
            END.   
        END.   
        WHEN "C" THEN DO:
            X-EST = "CAN".
            IF CcbcDocu.Codmon = 1 THEN DO:
                w-totbru [3] = w-totbru [3] + x-ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [3] = w-totdsc [3] + x-ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [3] = w-totexo [3] + x-ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [3] = w-totval [3] + x-ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [3] = w-totisc [3] + x-ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [3] = w-totigv [3] + x-ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [3] = w-totven [3] + x-ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
            END.   
            ELSE DO:
                IF NOT RADIO-SET-Mon THEN DO:
                    w-totbru [4] = w-totbru [4] + x-ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [4] = w-totdsc [4] + x-ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [4] = w-totexo [4] + x-ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [4] = w-totval [4] + x-ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [4] = w-totisc [4] + x-ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [4] = w-totigv [4] + x-ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [4] = w-totven [4] + x-ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
                ELSE DO:
                    w-totbru [3] = w-totbru [3] + x-ImpBrt * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [3] = w-totdsc [3] + x-ImpDto * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [3] = w-totexo [3] + x-ImpExo * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [3] = w-totval [3] + x-ImpVta * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [3] = w-totisc [3] + x-ImpIsc * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [3] = w-totigv [3] + x-ImpIgv * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [3] = w-totven [3] + x-ImpTot * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
            END.                
        END.   
        WHEN "A" THEN DO:
            X-EST = "ANU".       
            IF CcbcDocu.Codmon = 1 THEN DO:
                w-totbru [5] = w-totbru [5] + x-ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [5] = w-totdsc [5] + x-ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [5] = w-totexo [5] + x-ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [5] = w-totval [5] + x-ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [5] = w-totisc [5] + x-ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [5] = w-totigv [5] + x-ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [5] = w-totven [5] + x-ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
            END.   
            ELSE DO:
                IF NOT RADIO-SET-Mon THEN DO:
                    w-totbru [6] = w-totbru [6] + x-ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [6] = w-totdsc [6] + x-ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [6] = w-totexo [6] + x-ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [6] = w-totval [6] + x-ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [6] = w-totisc [6] + x-ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [6] = w-totigv [6] + x-ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [6] = w-totven [6] + x-ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
                ELSE DO:
                    w-totbru [5] = w-totbru [5] + x-ImpBrt * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [5] = w-totdsc [5] + x-ImpDto * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [5] = w-totexo [5] + x-ImpExo * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [5] = w-totval [5] + x-ImpVta * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [5] = w-totisc [5] + x-ImpIsc * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [5] = w-totigv [5] + x-ImpIgv * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [5] = w-totven [5] + x-ImpTot * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
            END.                
        END.
        END CASE.

        DISPLAY STREAM REPORT 
            CcbcDocu.CodDoc 
            CcbcDocu.NroDoc 
            CcbcDocu.FchDoc 
            CcbcDocu.NomCli 
            CcbcDocu.RucCli 
            CcbcDocu.Codven
            X-MON           
            (x-ImpVta * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpVta
            (x-ImpDto * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpDto
            (x-ImpBrt * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpBrt
            (x-ImpIgv * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpIgv
            (x-ImpTot * dTpoCmb * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpTot
            X-EST 
            CcbCDocu.UsuAnu
            X-TIP
            WITH FRAME F-Cab.
    END.
    DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
        PUT STREAM REPORT "" skip. 
    END.   
 
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "--------------------------------------------" SPACE(4) "--------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL CANCELADAS         SOLES       DOLARES" SPACE(4) "TOTAL PENDIENTES         SOLES       DOLARES" SPACE(4) "TOTAL ANULADAS           SOLES       DOLARES" SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "--------------------------------------------" SPACE(4) "--------------------------------------------" SKIP.
    PUT STREAM REPORT "Total Bruto    :" AT 1
        w-totbru[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totbru[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "Total Bruto    :"
        w-totbru[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totbru[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "Total Bruto    :"
        w-totbru[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totbru[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "Descuento      :" AT 1
        w-totdsc[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totdsc[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "Descuento      :"
        w-totdsc[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totdsc[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "Descuento      :"
        w-totdsc[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totdsc[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "Exonerado      :" AT 1
        w-totexo[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totexo[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "Exonerado      :"
        w-totexo[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totexo[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "Exonerado      :"
        w-totexo[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totexo[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "Valor de Venta :" AT 1
        w-totval[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totval[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "Valor de Venta :"
        w-totval[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totval[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "Valor de Venta :"
        w-totval[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totval[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "I.S.C.         :" AT 1
        w-totisc[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totisc[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "I.S.C.         :"
        w-totisc[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totisc[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "I.S.C.         :"
        w-totisc[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totisc[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "I.G.V.         :" AT 1
        w-totigv[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totigv[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "I.G.V.         :"
        w-totigv[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totigv[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "I.G.V.         :"
        w-totigv[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totigv[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "Precio de Venta:" AT 1
        w-totven[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totven[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "Precio de Venta:"
        w-totven[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totven[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "Precio de Venta:"
        w-totven[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totven[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    OUTPUT STREAM REPORT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-1 D-Dialog 
PROCEDURE Imprimir-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF c-Copias = 1 THEN DO:
    RUN Carga-Temporal.
    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay registros a imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
END.

    DEFINE VAR W-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
    DEFINE VAR W-TOTISC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVEN AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR Titulo AS CHAR INIT '' FORMAT 'x(50)'.
    DEFINE VAR dTpoCmb LIKE gn-tcmb.venta NO-UNDO.


    DEF VAR x-ImpBrt AS DEC.
    DEF VAR x-ImpExo AS DEC.
    DEF VAR x-ImpDto AS DEC.
    DEF VAR x-ImpVta AS DEC.
    DEF VAR x-ImpIsc AS DEC.
    DEF VAR x-ImpIgv AS DEC.
    DEF VAR x-ImpTot AS DEC.

    IF FILL-IN-Descripcion <> '' THEN
        Titulo = 'CONDICION DE VENTA: ' + FILL-IN-Descripcion.

    CASE R-Estado:
        WHEN "A" THEN ESTADO = "ANULADOS".
        WHEN "P" THEN ESTADO = "PENDIENTES".
        WHEN "C" THEN ESTADO = "CANCELADOS".
        WHEN "" THEN ESTADO = "TODOS".
    END CASE.

    DEFINE FRAME f-cab
        Detalle.CodDoc FORMAT "XXX"
        Detalle.NroDoc FORMAT "XXX-XXXXXX"
        Detalle.FchDoc 
        Detalle.NomCli FORMAT "X(23)"
        Detalle.RucCli FORMAT "X(11)"
        Detalle.Codven FORMAT "X(4)"
        X-MON           FORMAT "X(4)"
        Detalle.ImpBrt FORMAT "->>>>,>>9.99"
        Detalle.ImpDto FORMAT "->,>>9.99"
        Detalle.ImpVta FORMAT "->>>>,>>9.99"
        Detalle.ImpIgv FORMAT "->,>>9.99"
        Detalle.ImpTot FORMAT "->>>>,>>9.99"
        X-TIP           FORMAT "X(2)"
        X-EST           FORMAT "X(3)"
        Detalle.UsuAnu FORMAT "X(8)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + Detalle.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + T-CMPBTE  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN4} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        ESTADO FORMAT "X(25)" SKIP
        Titulo SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                                   T O T A L      TOTAL       VALOR             P R E C I O         USUARIO " SKIP
        "DOC  DOCUMENTO  EMISION   C L I E N T E               R.U.C.  VEND MON.    BRUTO        DSCTO.      VENTA     I.G.V.   V E N T A   ESTADO ANULAC. " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------" SKIP         
        WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.         

    FOR EACH Detalle NO-LOCK BY Detalle.NomCli:

        {&NEW-PAGE}.
        IF Detalle.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".

        IF Detalle.TipVta = "1" THEN X-TIP = "CT".
        ELSE X-TIP = "CR".

        dTpoCmb = 1.
        IF RADIO-SET-Mon THEN DO:        
            X-MON = "S/.".
            IF Detalle.Codmon <> 1 THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.fecha = Detalle.fchdoc NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN dTpoCmb = Gn-tcmb.Venta.
            END.
            IF RADIO-SET-Ruc AND
                Detalle.coddoc = "BOL" AND
                Detalle.ImpVta * dTpoCmb < FILL-IN-uit / 2 THEN NEXT.
        END.


        ASSIGN
            x-ImpBrt = Detalle.impbrt
            x-ImpDto = Detalle.impdto
            x-ImpExo = Detalle.impexo
            x-ImpVta = Detalle.impvta
            x-ImpIgv = Detalle.impigv
            x-ImpIsc = Detalle.impisc
            x-ImpTot = Detalle.imptot.

        CASE Detalle.FlgEst:
        WHEN "P" THEN DO:
            X-EST = "PEN".
            IF Detalle.Codmon = 1 THEN DO:
                w-totbru [1] = w-totbru [1] + x-ImpBrt * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [1] = w-totdsc [1] + x-ImpDto * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [1] = w-totexo [1] + x-ImpExo * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [1] = w-totval [1] + x-ImpVta * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [1] = w-totisc [1] + x-ImpIsc * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [1] = w-totigv [1] + x-ImpIgv * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [1] = w-totven [1] + x-ImpTot * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
            END.   
            ELSE DO:
                IF NOT RADIO-SET-Mon THEN DO:
                    w-totbru [2] = w-totbru [2] + x-ImpBrt * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [2] = w-totdsc [2] + x-ImpDto * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [2] = w-totexo [2] + x-ImpExo * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [2] = w-totval [2] + x-ImpVta * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [2] = w-totisc [2] + x-ImpIsc * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [2] = w-totigv [2] + x-ImpIgv * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [2] = w-totven [2] + x-ImpTot * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
                ELSE DO:
                    w-totbru [1] = w-totbru [1] + x-ImpBrt * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [1] = w-totdsc [1] + x-ImpDto * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [1] = w-totexo [1] + x-ImpExo * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [1] = w-totval [1] + x-ImpVta * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [1] = w-totisc [1] + x-ImpIsc * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [1] = w-totigv [1] + x-ImpIgv * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [1] = w-totven [1] + x-ImpTot * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
            END.   
        END.   
        WHEN "C" THEN DO:
            X-EST = "CAN".
            IF Detalle.Codmon = 1 THEN DO:
                w-totbru [3] = w-totbru [3] + x-ImpBrt * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [3] = w-totdsc [3] + x-ImpDto * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [3] = w-totexo [3] + x-ImpExo * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [3] = w-totval [3] + x-ImpVta * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [3] = w-totisc [3] + x-ImpIsc * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [3] = w-totigv [3] + x-ImpIgv * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [3] = w-totven [3] + x-ImpTot * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
            END.   
            ELSE DO:
                IF NOT RADIO-SET-Mon THEN DO:
                    w-totbru [4] = w-totbru [4] + x-ImpBrt * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [4] = w-totdsc [4] + x-ImpDto * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [4] = w-totexo [4] + x-ImpExo * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [4] = w-totval [4] + x-ImpVta * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [4] = w-totisc [4] + x-ImpIsc * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [4] = w-totigv [4] + x-ImpIgv * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [4] = w-totven [4] + x-ImpTot * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
                ELSE DO:
                    w-totbru [3] = w-totbru [3] + x-ImpBrt * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [3] = w-totdsc [3] + x-ImpDto * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [3] = w-totexo [3] + x-ImpExo * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [3] = w-totval [3] + x-ImpVta * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [3] = w-totisc [3] + x-ImpIsc * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [3] = w-totigv [3] + x-ImpIgv * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [3] = w-totven [3] + x-ImpTot * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
            END.                
        END.   
        WHEN "A" THEN DO:
            X-EST = "ANU".       
            IF Detalle.Codmon = 1 THEN DO:
                w-totbru [5] = w-totbru [5] + x-ImpBrt * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [5] = w-totdsc [5] + x-ImpDto * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [5] = w-totexo [5] + x-ImpExo * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [5] = w-totval [5] + x-ImpVta * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [5] = w-totisc [5] + x-ImpIsc * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [5] = w-totigv [5] + x-ImpIgv * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [5] = w-totven [5] + x-ImpTot * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
            END.   
            ELSE DO:
                IF NOT RADIO-SET-Mon THEN DO:
                    w-totbru [6] = w-totbru [6] + x-ImpBrt * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [6] = w-totdsc [6] + x-ImpDto * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [6] = w-totexo [6] + x-ImpExo * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [6] = w-totval [6] + x-ImpVta * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [6] = w-totisc [6] + x-ImpIsc * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [6] = w-totigv [6] + x-ImpIgv * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [6] = w-totven [6] + x-ImpTot * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
                ELSE DO:
                    w-totbru [5] = w-totbru [5] + x-ImpBrt * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totdsc [5] = w-totdsc [5] + x-ImpDto * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totexo [5] = w-totexo [5] + x-ImpExo * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totval [5] = w-totval [5] + x-ImpVta * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totisc [5] = w-totisc [5] + x-ImpIsc * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totigv [5] = w-totigv [5] + x-ImpIgv * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                    w-totven [5] = w-totven [5] + x-ImpTot * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1).
                END.
            END.                
        END.
        END CASE.

        DISPLAY STREAM REPORT 
            Detalle.CodDoc 
            Detalle.NroDoc 
            Detalle.FchDoc 
            Detalle.NomCli 
            Detalle.RucCli 
            Detalle.Codven
            X-MON           
            (x-ImpVta * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1)) @ Detalle.ImpVta
            (x-ImpDto * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1)) @ Detalle.ImpDto
            (x-ImpBrt * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1)) @ Detalle.ImpBrt
            (x-ImpIgv * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1)) @ Detalle.ImpIgv
            (x-ImpTot * dTpoCmb * (IF Detalle.CodDoc = "N/C" THEN -1 ELSE 1)) @ Detalle.ImpTot
            X-EST 
            Detalle.UsuAnu
            X-TIP
            WITH FRAME F-Cab.
    END.
    DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
        PUT STREAM REPORT "" skip. 
    END.   
 
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "--------------------------------------------" SPACE(4) "--------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL CANCELADAS         SOLES       DOLARES" SPACE(4) "TOTAL PENDIENTES         SOLES       DOLARES" SPACE(4) "TOTAL ANULADAS           SOLES       DOLARES" SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "--------------------------------------------" SPACE(4) "--------------------------------------------" SKIP.
    PUT STREAM REPORT "Total Bruto    :" AT 1
        w-totbru[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totbru[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "Total Bruto    :"
        w-totbru[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totbru[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "Total Bruto    :"
        w-totbru[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totbru[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "Descuento      :" AT 1
        w-totdsc[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totdsc[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "Descuento      :"
        w-totdsc[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totdsc[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "Descuento      :"
        w-totdsc[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totdsc[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "Exonerado      :" AT 1
        w-totexo[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totexo[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "Exonerado      :"
        w-totexo[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totexo[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "Exonerado      :"
        w-totexo[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totexo[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "Valor de Venta :" AT 1
        w-totval[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totval[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "Valor de Venta :"
        w-totval[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totval[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "Valor de Venta :"
        w-totval[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totval[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "I.S.C.         :" AT 1
        w-totisc[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totisc[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "I.S.C.         :"
        w-totisc[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totisc[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "I.S.C.         :"
        w-totisc[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totisc[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "I.G.V.         :" AT 1
        w-totigv[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totigv[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "I.G.V.         :"
        w-totigv[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totigv[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "I.G.V.         :"
        w-totigv[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totigv[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
    PUT STREAM REPORT "Precio de Venta:" AT 1
        w-totven[3] AT 17  FORMAT "->>,>>>,>>9.99" w-totven[4] AT 31  FORMAT "->>,>>>,>>9.99" SPACE(4) "Precio de Venta:"
        w-totven[1] AT 65  FORMAT "->>,>>>,>>9.99" w-totven[2] AT 79  FORMAT "->>,>>>,>>9.99" SPACE(4) "Precio de Venta:"
        w-totven[5] AT 113 FORMAT "->>,>>>,>>9.99" w-totven[6] AT 127 FORMAT "->>,>>>,>>9.99" SKIP.
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

