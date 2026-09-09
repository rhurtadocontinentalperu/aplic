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
DEF INPUT PARAMETER pParametro AS CHAR.
/* YES o NO
    YES: modificar la división
    NO:  solo la división por defecto
*/    
/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

/*
    @PRINTER2.W    VERSION 1.0
*/
{lib/def-prn.i}    
DEFINE STREAM report.
/*DEFINE VARIABLE x-Raya     AS CHARACTER FORMAT "X(145)".
DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id  LIKE _user._userid.*/

DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.

DEF BUFFER B-CDOCU FOR Ccbcdocu.
DEFINE TEMP-TABLE T-CDOC LIKE Ccbcdocu.

  
def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE f-tipos  AS CHAR FORMAT "X(3)".
DEFINE VARIABLE T-CMPBTE AS CHAR INIT "".
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE T-CLIEN  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-TIP    AS CHAR FORMAT "X(2)".
DEFINE VAR C AS INTEGER.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.

 DEFINE VAR W-TotBru AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotDsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotExo AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotVal AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotIsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotIgv AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotVen AS DECIMAL EXTENT 6 INIT 0.

 DEFINE VAR W-ConBru AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConDsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConExo AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConVal AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConIsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConIgv AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConVen AS DECIMAL EXTENT 6 INIT 0.
 
 DEFINE VAR W-CreBru AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreDsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreExo AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreVal AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreIsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreIgv AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreVen AS DECIMAL EXTENT 6 INIT 0.
 
 DEFINE VAR W-NCBru AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCDsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCExo AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCVal AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCIsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCIgv AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCVen AS DECIMAL EXTENT 6 INIT 0.

 DEFINE VAR W-NDBru AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDDsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDExo AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDVal AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDIsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDIgv AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDVen AS DECIMAL EXTENT 6 INIT 0.

 DEFINE VAR F-ImpBrt AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpDto AS DECIMAL FORMAT "(>,>>9.99)".
 DEFINE VAR F-ImpVta AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpExo AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpIgv AS DECIMAL FORMAT "(>>>,>>9.99)".
 DEFINE VAR F-ImpTot AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpIsc AS DECIMAL FORMAT "(>,>>9.99)".
 DEFINE VAR JJ       AS INTEGER NO-UNDO.
 DEFINE VAR F-TOTCON AS DECIMAL EXTENT 6 INITIAL 0.
 DEFINE VAR F-TOTCRE AS DECIMAL EXTENT 6 INITIAL 0.
 C = 1.

/*   MESSAGE "Este reporte es para uso exclusivo de contabilidad" SKIP */
/*           "El area de Informatica no se responsabiliza por el" SKIP */
/*           "uso indebido en otras areas"                             */
/*           VIEW-AS ALERT-BOX INFORMATION.                            */

DEFINE FRAME F-Mensajes
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16
          FONT 8
     "por favor..." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19
          FONT 8
     "F10 = Cancela Reporte" VIEW-AS TEXT
          SIZE 21 BY 1 AT ROW 3.5 COL 12
          FONT 8          
    SPACE(10.28) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 TITLE "Cargando...".

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
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-49 RECT-48 FILL-IN-CodDiv ~
f-desde f-hasta RADIO-SET-1 RB-NUMBER-COPIES B-impresoras RB-BEGIN-PAGE ~
RB-END-PAGE BUTTON-2 B-cancela 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodDiv R-S-TipImp f-vende f-desde ~
f-hasta f-nomven RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

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

DEFINE BUTTON B-cancela AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 13 BY 1.5.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\excel":U
     LABEL "" 
     SIZE 5.57 BY 1.42 TOOLTIP "Exportar a Excel - más simple, rápido e innovador - SISTEMAS siempre contigo".

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

DEFINE VARIABLE f-nomven AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 21.86 BY .69 NO-UNDO.

DEFINE VARIABLE f-vende AS CHARACTER FORMAT "XXX":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .69
     BGCOLOR 15 FGCOLOR 1 FONT 6 NO-UNDO.

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

DEFINE VARIABLE R-S-TipImp AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Detalle y Resumen", 1,
"Solo Detalle", 2,
"Solo Resumen", 3
     SIZE 17.14 BY 1.77 NO-UNDO.

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
     SIZE 83.86 BY 2.77.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 1.69.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 3.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-CodDiv AT ROW 1.19 COL 2.15
     R-S-TipImp AT ROW 1.65 COL 26.29 NO-LABEL
     f-vende AT ROW 2 COL 9 COLON-ALIGNED
     f-desde AT ROW 2.19 COL 49.29 COLON-ALIGNED
     f-hasta AT ROW 2.19 COL 66.57 COLON-ALIGNED
     f-nomven AT ROW 2.77 COL 3.29 NO-LABEL
     RADIO-SET-1 AT ROW 5.04 COL 2.57 NO-LABEL
     RB-NUMBER-COPIES AT ROW 5.19 COL 70 COLON-ALIGNED
     B-impresoras AT ROW 6.04 COL 15.57
     RB-BEGIN-PAGE AT ROW 6.19 COL 70 COLON-ALIGNED
     b-archivo AT ROW 7.04 COL 15.57
     RB-END-PAGE AT ROW 7.19 COL 70 COLON-ALIGNED
     RB-OUTPUT-FILE AT ROW 7.27 COL 19.86 COLON-ALIGNED NO-LABEL
     BUTTON-2 AT ROW 8.69 COL 25
     B-cancela AT ROW 8.77 COL 34.86
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 83.43 BY .62 AT ROW 3.88 COL 1.29
          BGCOLOR 1 FGCOLOR 15 FONT 6
     " Rango de Fechas" VIEW-AS TEXT
          SIZE 16 BY .62 AT ROW 1.31 COL 54.86
          BGCOLOR 8 FONT 6
     RECT-5 AT ROW 4.62 COL 1
     RECT-49 AT ROW 1.65 COL 45
     RECT-48 AT ROW 1 COL 1
     SPACE(0.14) SKIP(6.84)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Registro de Ventas Gestion".


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
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b-archivo IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       b-archivo:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN f-nomven IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN f-vende IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       f-vende:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-CodDiv IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR RADIO-SET R-S-TipImp IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       R-S-TipImp:HIDDEN IN FRAME D-Dialog           = TRUE.

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Registro de Ventas Gestion */
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


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 D-Dialog
ON CHOOSE OF BUTTON-2 IN FRAME D-Dialog
DO:
  assign f-desde f-hasta FILL-IN-CodDiv.
  RUN GRAFICO-1.
  
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

ASSIGN 
    FILL-IN-Coddiv = S-CODDIV
    F-DESDE   = TODAY
    F-HASTA   = TODAY
    FILL-IN-Coddiv:SENSITIVE = (IF pParametro = 'YES' THEN YES ELSE NO).


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
  FILL-IN-Coddiv:SENSITIVE = (IF pParametro = 'YES' THEN YES ELSE NO).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.
DEF VAR x-Factor AS DEC NO-UNDO.
DEFINE VAR x-Comprobantes AS CHAR NO-UNDO.

FOR EACH T-CDOC:
    DELETE T-CDOC.
END.

x-Comprobantes = 'FAC,BOL,TCK,N/D,N/C'.

loopdivi:
FOR EACH GN-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
    AND Gn-Divi.CodDiv BEGINS FILL-IN-CodDiv:
    DO k = 1 TO NUM-ENTRIES(x-Comprobantes):
        FOR EACH CcbcDocu NO-LOCK WHERE CcbcDocu.CodCia = S-CODCIA 
            AND  CcbcDocu.CodDiv = Gn-Divi.CodDiv  
            AND  CcbcDocu.FchDoc >= F-desde 
            AND  CcbcDocu.FchDoc <= F-hasta 
            AND Ccbcdocu.coddoc = ENTRY(k, x-Comprobantes)
            USE-INDEX LLAVE10 :
            CREATE T-CDOC.
            BUFFER-COPY Ccbcdocu 
                TO T-CDOC
                ASSIGN 
                T-CDOC.ImpDto = T-CDOC.ImpDto + (IF LOOKUP(Ccbcdocu.coddoc, 'N/C,N/D') > 0 THEN 0 ELSE Ccbcdocu.Libre_d01)
                T-CDOC.ImpTot = Ccbcdocu.ImpTot - Ccbcdocu.AcuBon[5] - Ccbcdocu.AcuBon[10].    /* SIN PERCEP */
            /* CASO DE FACTURAS CON APLICACION DE ADELANTOS */
            IF LOOKUP (Ccbcdocu.coddoc, 'FAC,BOL') > 0
                AND Ccbcdocu.FlgEst <> 'A' 
                AND Ccbcdocu.ImpTot2 > 0
                THEN DO:
                /* Recalculamos Importes */
                ASSIGN
                    T-CDOC.ImpTot2 = Ccbcdocu.ImpTot2
                    T-CDOC.ImpTot = T-CDOC.ImpTot - T-CDOC.ImpTot2
                    T-CDOC.Libre_d01 = Ccbcdocu.ImpTot.
                IF T-CDOC.ImpTot <= 0 THEN DO:
                    ASSIGN
                        T-CDOC.ImpTot = 0
                        T-CDOC.ImpBrt = 0
                        T-CDOC.ImpExo = 0
                        T-CDOC.ImpDto = 0
                        T-CDOC.ImpVta = 0
                        T-CDOC.ImpIgv = 0.
                END.
                ELSE DO:
                    x-Factor = T-CDOC.ImpTot / (Ccbcdocu.ImpTot - Ccbcdocu.AcuBon[5]).
                    ASSIGN
                        T-CDOC.ImpVta = ROUND (Ccbcdocu.ImpVta * x-Factor, 2)
                        T-CDOC.ImpIgv = T-CDOC.ImpTot - T-CDOC.ImpVta.
                    ASSIGN
                        T-CDOC.ImpBrt = T-CDOC.ImpVta + T-CDOC.ImpIsc + T-CDOC.ImpDto /*+ T-CDOC.ImpExo*/.
                END.
            END.

            /* Ic - 11Ene2017, no valido para Transferencias Gratuitas */
            IF t-cdoc.fmapgo <> '899' THEN
            ASSIGN
                T-CDOC.ImpBrt = T-CDOC.ImpVta + T-CDOC.ImpIsc + T-CDOC.ImpDto /*+ T-CDOC.ImpExo*/.
            /* ******************************************** */
            /* CASO DE DOCUMENTOS DE UTILEX */
/*             IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,TCK') > 0 AND Ccbcdocu.ImpDto2 > 0 THEN DO:          */
/*                 T-CDOC.ImpDto = /*T-CDOC.ImpDto +*/ Ccbcdocu.ImpDto2 / ( 1 + Ccbcdocu.PorIgv / 100). */
/*                 T-CDOC.ImpBrt = T-CDOC.ImpVta + T-CDOC.ImpIsc + T-CDOC.ImpDto /*+ T-CDOC.ImpExo*/.   */
/*             END.                                                                                     */
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
  DISPLAY FILL-IN-CodDiv R-S-TipImp f-vende f-desde f-hasta f-nomven RADIO-SET-1 
          RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE RECT-5 RECT-49 RECT-48 FILL-IN-CodDiv f-desde f-hasta RADIO-SET-1 
         RB-NUMBER-COPIES B-impresoras RB-BEGIN-PAGE RB-END-PAGE BUTTON-2 
         B-cancela 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grafico D-Dialog 
PROCEDURE Grafico :
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
DEFINE VARIABLE t-Column                AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE f-Column                AS char INITIAL "".
DEFINE VARIABLE x-valor                 AS DECIMAL init 0.
DEFINE VARIABLE f-estado                AS char init "".
DEFINE BUFFER b-faccpedi for faccpedi.

DEFINE VAR x-tpocmb AS DEC NO-UNDO.
DEFINE VAR x-impbrt AS DEC NO-UNDO.
DEFINE VAR x-impdto AS DEC NO-UNDO.
DEFINE VAR x-impexo AS DEC NO-UNDO.
DEFINE VAR x-impvta AS DEC NO-UNDO.
DEFINE VAR x-impigv AS DEC NO-UNDO.
DEFINE VAR x-imptot AS DEC NO-UNDO.
DEFINE VAR x-Comprobantes AS CHAR NO-UNDO.


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 5.
chWorkSheet:Columns("B"):ColumnWidth = 5.
chWorkSheet:Columns("C"):ColumnWidth = 12.
chWorkSheet:Columns("D"):ColumnWidth = 12.
chWorkSheet:Columns("E"):ColumnWidth = 40.
chWorkSheet:Columns("F"):ColumnWidth = 15.
chWorkSheet:Columns("G"):ColumnWidth = 6.
chWorkSheet:Columns("H"):ColumnWidth = 15.
chWorkSheet:Columns("I"):ColumnWidth = 15.
chWorkSheet:Columns("J"):ColumnWidth = 15.
chWorkSheet:Columns("K"):ColumnWidth = 15.
chWorkSheet:Columns("L"):ColumnWidth = 15.
chWorkSheet:Columns("M"):ColumnWidth = 15.
chWorkSheet:Columns("N"):ColumnWidth = 6.
chWorkSheet:Columns("O"):ColumnWidth = 6.

chWorkSheet:Range("A1: N1"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Value = "Codigo".
chWorkSheet:Range("B1"):Value = "Serie".
chWorkSheet:Range("C1"):Value = "Numero".
chWorkSheet:Range("D1"):Value = "Fecha".
chWorkSheet:Range("E1"):Value = "Nombre o Razon Social".
chWorkSheet:Range("F1"):Value = "R.U.C.".
chWorkSheet:Range("G1"):Value = "Moneda".
chWorkSheet:Range("H1"):Value = "Imp Bruto".
chWorkSheet:Range("I1"):Value = "Imp Dscto".
chWorkSheet:Range("J1"):Value = "Imp Exonerado".
chWorkSheet:Range("K1"):Value = "Imp Venta".
chWorkSheet:Range("L1"):Value = "Imp I.G.V".
chWorkSheet:Range("M1"):Value = "Imp Total".
chWorkSheet:Range("N1"):Value = "Estado".
chWorkSheet:Range("O1"):Value = "Division".


/* cambia de hoja  */

chWorkSheet = chExcelApplication:Sheets:Item(1).

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */

x-Comprobantes = 'FAC,BOL,TCK,N/D,N/C'.

DEF VAR k AS INT NO-UNDO.
DEF VAR x-Factor AS DEC NO-UNDO.

loopdivi:
FOR EACH GN-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                       Gn-Divi.CodDiv BEGINS FILL-IN-CodDiv:
  DO k = 1 TO NUM-ENTRIES(x-Comprobantes):
    FOR EACH CcbcDocu NO-LOCK WHERE CcbcDocu.CodCia = S-CODCIA 
                              AND  CcbcDocu.CodDiv = Gn-Divi.CodDiv  
                              AND  CcbcDocu.FchDoc >= F-desde 
                              AND  CcbcDocu.FchDoc <= F-hasta 
                              AND Ccbcdocu.coddoc = ENTRY(k, x-Comprobantes)
                               USE-INDEX LLAVE10 :
        x-Factor = IF Ccbcdocu.coddoc = 'N/C' THEN -1 ELSE 1.
       IF CcbcDocu.Codmon = 1 
       THEN X-MON = "S/.".
       ELSE X-MON = "US$.".
       
       /* OJO : TODO EN SOLES */
       X-MON = 'S/.'.
       ASSIGN
           x-impbrt = impbrt
           x-impdto = impdto
           x-impexo = impexo
           x-impvta = impvta
           x-impigv = impigv
           x-imptot = imptot.
       /* RHC 11.02.2011 ACUMULADOS APLICACION DE ANTICIPOS DE CAMPAÑA */
       DEF VAR x-ImpAde AS DEC NO-UNDO.
       DEF VAR x-FacAde AS DEC DECIMALS 8 NO-UNDO.
       x-ImpAde = 0.
       FOR EACH Ccbdcaja NO-LOCK WHERE Ccbdcaja.codcia = s-codcia
           AND Ccbdcaja.coddoc = "A/C"
           AND Ccbdcaja.codref = Ccbcdocu.coddoc
           AND Ccbdcaja.nroref = Ccbcdocu.nrodoc:
           IF Ccbcdocu.codmon = Ccbdcaja.codmon 
           THEN x-ImpAde = x-ImpAde + Ccbdcaja.ImpTot.
           ELSE x-ImpAde = x-ImpAde + ( IF Ccbdcaja.codmon = 1 THEN Ccbdcaja.ImpTot / Ccbdcaja.TpoCmb
                                        ELSE Ccbdcaja.ImpTot * Ccbdcaja.TpoCmb).
       END.
       IF x-ImpAde > 0 THEN DO:
           IF x-ImpAde >= x-ImpTot THEN x-ImpAde = x-ImpTot.
           x-FacAde = x-ImpAde / x-ImpTot.
           ASSIGN
               x-ImpVta = x-ImpVta * (1 - x-FacAde)
               x-ImpIgv = x-ImpIgv * (1 - x-FacAde)
               x-ImpTot = x-ImpTot * (1 - x-FacAde).
           ASSIGN
               x-ImpBrt = x-ImpVta + x-ImpDto.
       END.
        FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= ccbcdocu.fchdoc NO-LOCK NO-ERROR.
        IF AVAILABLE gn-tcmb 
        THEN x-tpocmb = gn-tcmb.venta.
        ELSE x-tpocmb = Ccbcdocu.tpocmb.
        IF Ccbcdocu.coddoc = 'N/C' THEN DO:
            FIND B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
                AND B-CDOCU.coddoc = Ccbcdocu.codref
                AND B-CDOCU.nrodoc = Ccbcdocu.nroref 
                NO-LOCK NO-ERROR.
            IF AVAILABLE B-CDOCU THEN DO:
                FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= B-CDOCU.FchDoc NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-Tcmb THEN x-tpocmb = gn-tcmb.venta.
            END.
        END.
        IF Ccbcdocu.codmon = 2
        THEN ASSIGN
               x-impbrt = ROUND(ccbcdocu.impbrt * x-tpocmb, 2)
               x-impdto = ROUND(ccbcdocu.impdto * x-tpocmb, 2)
               x-impexo = ROUND(ccbcdocu.impexo * x-tpocmb, 2)
               x-impvta = ROUND(ccbcdocu.impvta * x-tpocmb, 2)
               x-impigv = ROUND(ccbcdocu.impigv * x-tpocmb, 2)
               x-imptot = ROUND(ccbcdocu.imptot * x-tpocmb, 2).
   
       CASE CcbcDocu.FlgEst :
             WHEN "P" THEN ASSIGN X-EST = "PEN"
                                  JJ = CcbcDocu.Codmon.
             WHEN "C" THEN ASSIGN X-EST = "CAN"
                                  JJ = CcbcDocu.Codmon + 2.
             WHEN "A" THEN ASSIGN X-EST = "ANU"
                                  JJ = CcbcDocu.Codmon + 4.
       END CASE.
       iCount = iCount + 1.
       chWorkSheet = chExcelApplication:Sheets:Item(1).
       cColumn = STRING(iCount).
    IF CcbcDocu.FlgEst <> 'A' THEN DO:
       cRange = "A" + cColumn.
       chWorkSheet:Range(cRange):Value = ccbcdocu.coddoc.
       cRange = "B" + cColumn.
       chWorkSheet:Range(cRange):Value = "'" + SUBSTRING(Ccbcdocu.nrodoc,1,3).
       cRange = "C" + cColumn.
       chWorkSheet:Range(cRange):Value = "'" + SUBSTRING(ccbcdocu.nrodoc,4).
       cRange = "D" + cColumn.
       chWorkSheet:Range(cRange):Value = ccbcdocu.fchdoc.
       cRange = "E" + cColumn.
       chWorkSheet:Range(cRange):Value = ccbcdocu.nomcli.
       cRange = "F" + cColumn.
       chWorkSheet:Range(cRange):Value = ccbcdocu.ruccli.
       cRange = "G" + cColumn.
       chWorkSheet:Range(cRange):Value = x-mon.
       cRange = "H" + cColumn.
       chWorkSheet:Range(cRange):Value = x-impbrt * x-Factor.
       cRange = "I" + cColumn.
       chWorkSheet:Range(cRange):Value = x-impdto * x-Factor.
       cRange = "J" + cColumn.
       chWorkSheet:Range(cRange):Value = x-impexo * x-Factor.
       cRange = "K" + cColumn.
       chWorkSheet:Range(cRange):Value = x-impvta * x-Factor.                
       cRange = "L" + cColumn.
       chWorkSheet:Range(cRange):Value = x-impigv * x-Factor.                
       cRange = "M" + cColumn.
       chWorkSheet:Range(cRange):Value = x-imptot * x-Factor.                
       cRange = "N" + cColumn.
       chWorkSheet:Range(cRange):Value = X-EST.                
       cRange = "O" + cColumn.
       chWorkSheet:Range(cRange):Value = "'" + ccbcdocu.coddiv.
    END.
    ELSE DO:
       cRange = "A" + cColumn.
       chWorkSheet:Range(cRange):Value = ccbcdocu.coddoc.
       cRange = "B" + cColumn.
       chWorkSheet:Range(cRange):Value = "'" + SUBSTRING(Ccbcdocu.nrodoc,1,3).
       cRange = "C" + cColumn.
       chWorkSheet:Range(cRange):Value = "'" + SUBSTRING(ccbcdocu.nrodoc,4).
       cRange = "D" + cColumn.
       chWorkSheet:Range(cRange):Value = "".
       cRange = "E" + cColumn.
       chWorkSheet:Range(cRange):Value = "*** ANULADO ***".
    END.
    DISPLAY
        CcbCDocu.coddoc + " " + CcbCDocu.nrodoc
        FORMAT "X(15)" LABEL "   Procesando documento"
        WITH FRAME f-mensajes.
    READKEY PAUSE 0.
    IF LASTKEY = KEYCODE("F10") THEN LEAVE loopdivi.
    END.
  END.
END.

HIDE FRAME f-mensajes NO-PAUSE.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grafico-1 D-Dialog 
PROCEDURE Grafico-1 :
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
DEFINE VARIABLE t-Column                AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE f-Column                AS char INITIAL "".
DEFINE VARIABLE x-valor                 AS DECIMAL init 0.
DEFINE VARIABLE f-estado                AS char init "".
DEFINE BUFFER b-faccpedi for faccpedi.

DEFINE VAR x-tpocmb AS DEC NO-UNDO.
DEFINE VAR x-impbrt AS DEC NO-UNDO.
DEFINE VAR x-impdto AS DEC NO-UNDO.
DEFINE VAR x-impexo AS DEC NO-UNDO.
DEFINE VAR x-impvta AS DEC NO-UNDO.
DEFINE VAR x-impigv AS DEC NO-UNDO.
DEFINE VAR x-imptot AS DEC NO-UNDO.

DEFINE VAR lDocSunat AS CHAR.

RUN Carga-Temporal.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 5.
chWorkSheet:Columns("B"):ColumnWidth = 5.
chWorkSheet:Columns("C"):ColumnWidth = 12.
chWorkSheet:Columns("D"):ColumnWidth = 12.
chWorkSheet:Columns("E"):ColumnWidth = 40.
chWorkSheet:Columns("F"):ColumnWidth = 15.
chWorkSheet:Columns("G"):ColumnWidth = 6.
chWorkSheet:Columns("H"):ColumnWidth = 15.
chWorkSheet:Columns("I"):ColumnWidth = 15.
chWorkSheet:Columns("J"):ColumnWidth = 15.
chWorkSheet:Columns("K"):ColumnWidth = 15.
chWorkSheet:Columns("L"):ColumnWidth = 15.
chWorkSheet:Columns("M"):ColumnWidth = 15.
chWorkSheet:Columns("N"):ColumnWidth = 6.
chWorkSheet:Columns("O"):ColumnWidth = 6.

chWorkSheet:Range("A1: N1"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Value = "Codigo".
chWorkSheet:Range("B1"):Value = "Serie".
chWorkSheet:Range("C1"):Value = "Numero".
chWorkSheet:Range("D1"):Value = "Fecha".
chWorkSheet:Range("E1"):Value = "Nombre o Razon Social".
chWorkSheet:Range("F1"):Value = "R.U.C.".
chWorkSheet:Range("G1"):Value = "Moneda".
chWorkSheet:Range("H1"):Value = "Imp Bruto".
chWorkSheet:Range("I1"):Value = "Imp Dscto".
chWorkSheet:Range("J1"):Value = "Imp Exonerado".
chWorkSheet:Range("K1"):Value = "Imp Venta".
chWorkSheet:Range("L1"):Value = "Imp I.G.V".
chWorkSheet:Range("M1"):Value = "Sin Percepcion".
chWorkSheet:Range("N1"):Value = "Percepcion".
chWorkSheet:Range("O1"):Value = "Imp Total".
chWorkSheet:Range("P1"):Value = "Estado".
chWorkSheet:Range("Q1"):Value = "Division".
chWorkSheet:Range("R1"):Value = "Cond.Vta".
chWorkSheet:Range("S1"):Value = "Vencimiento".
/* Ic 29Abr2016 - Correo (28Abr2016) de Ronald Liñan, add referencias para casos de N/Cy N/D */
chWorkSheet:Range("T1"):Value = "T.D.".
chWorkSheet:Range("U1"):Value = "Fecha".
chWorkSheet:Range("V1"):Value = "Doc".
chWorkSheet:Range("W1"):Value = "Serie".
chWorkSheet:Range("X1"):Value = "Numero".
chWorkSheet:Range("Y1"):Value = "Asiento".
/* Ic 29Abr2016 */

chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:COLUMNS("C"):NumberFormat = "@".
chWorkSheet:COLUMNS("D"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:COLUMNS("F"):NumberFormat = "@".
chWorkSheet:COLUMNS("Q"):NumberFormat = "@".
chWorkSheet:COLUMNS("R"):NumberFormat = "@".
chWorkSheet:COLUMNS("S"):NumberFormat = "dd/mm/yyyy".

/* cambia de hoja  */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */

DEFINE BUFFER i-ccbcdocu FOR ccbcdocu.

DEF VAR x-Factor AS DEC NO-UNDO.

FOR EACH T-CDOC USE-INDEX LLAVE10 :
    x-Factor = IF T-CDOC.coddoc = 'N/C' THEN -1 ELSE 1.
    IF T-CDOC.Codmon = 1 
        THEN X-MON = "S/.".
    ELSE X-MON = "US$.".

    /* OJO : TODO EN SOLES */
    X-MON = 'S/.'.
    ASSIGN
        x-impbrt = T-CDOC.impbrt
        x-impdto = T-CDOC.impdto
        x-impexo = T-CDOC.impexo
        x-impvta = T-CDOC.impvta
        x-impigv = T-CDOC.impigv
        x-imptot = T-CDOC.imptot.
    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= T-CDOC.fchdoc NO-LOCK NO-ERROR.
    IF AVAILABLE gn-tcmb THEN x-tpocmb = gn-tcmb.venta.
    ELSE x-tpocmb = T-CDOC.tpocmb.
    IF T-CDOC.codmon = 2
        THEN ASSIGN
                x-impbrt = ROUND(T-CDOC.impbrt * x-tpocmb, 2)
                x-impdto = ROUND(T-CDOC.impdto * x-tpocmb, 2)
                x-impexo = ROUND(T-CDOC.impexo * x-tpocmb, 2)
                x-impvta = ROUND(T-CDOC.impvta * x-tpocmb, 2)
                x-impigv = ROUND(T-CDOC.impigv * x-tpocmb, 2)
                x-imptot = ROUND(T-CDOC.imptot * x-tpocmb, 2)
                T-CDOC.AcuBon[5] = ROUND(T-CDOC.AcuBon[5] * x-tpocmb, 2).

    CASE T-CDOC.FlgEst :
        WHEN "P" THEN ASSIGN X-EST = "PEN" JJ = T-CDOC.Codmon.
        WHEN "C" THEN ASSIGN X-EST = "CAN" JJ = T-CDOC.Codmon + 2.
        WHEN "A" THEN ASSIGN X-EST = "ANU" JJ = T-CDOC.Codmon + 4.
    END CASE.
    iCount = iCount + 1.
    chWorkSheet = chExcelApplication:Sheets:Item(1).
    cColumn = STRING(iCount).
    IF T-CDOC.FlgEst <> 'A' THEN DO:
       cRange = "A" + cColumn.
       chWorkSheet:Range(cRange):Value = T-CDOC.coddoc.
       cRange = "B" + cColumn.
       chWorkSheet:Range(cRange):Value = SUBSTRING(T-CDOC.nrodoc,1,3).
       cRange = "C" + cColumn.
       chWorkSheet:Range(cRange):Value = SUBSTRING(T-CDOC.nrodoc,4).
       cRange = "D" + cColumn.
       chWorkSheet:Range(cRange):Value = T-CDOC.fchdoc.
       cRange = "E" + cColumn.
       chWorkSheet:Range(cRange):Value = T-CDOC.nomcli.
       cRange = "F" + cColumn.
       chWorkSheet:Range(cRange):Value = T-CDOC.ruccli.
       cRange = "G" + cColumn.
       chWorkSheet:Range(cRange):Value = x-mon.
       cRange = "H" + cColumn.
       chWorkSheet:Range(cRange):Value = x-impbrt * x-Factor.
       cRange = "I" + cColumn.
       chWorkSheet:Range(cRange):Value = x-impdto * x-Factor.
       cRange = "J" + cColumn.
       chWorkSheet:Range(cRange):Value = x-impexo * x-Factor.
       cRange = "K" + cColumn.
       chWorkSheet:Range(cRange):Value = x-impvta * x-Factor.                
       cRange = "L" + cColumn.
       chWorkSheet:Range(cRange):Value = x-impigv * x-Factor.       
       cRange = "M" + cColumn.
       chWorkSheet:Range(cRange):Value = x-imptot * x-Factor.
       cRange = "N" + cColumn.
       chWorkSheet:Range(cRange):Value = (T-CDOC.AcuBon[5] * x-Factor ) + T-CDOC.AcuBon[10].
       cRange = "O" + cColumn.
       chWorkSheet:Range(cRange):Value = (x-imptot + T-CDOC.AcuBon[5] + T-CDOC.AcuBon[10]) * x-Factor.       /* Aqui no suma x que el AcuBon[10] ya esta incluido en el total */         
       cRange = "P" + cColumn.
       chWorkSheet:Range(cRange):Value = X-EST.                
       cRange = "Q" + cColumn.
       chWorkSheet:Range(cRange):Value = T-CDOC.coddiv.
    END.
    ELSE DO:
       cRange = "A" + cColumn.
       chWorkSheet:Range(cRange):Value = T-CDOC.coddoc.
       cRange = "B" + cColumn.
       chWorkSheet:Range(cRange):Value = SUBSTRING(T-CDOC.nrodoc,1,3).
       cRange = "C" + cColumn.
       chWorkSheet:Range(cRange):Value = SUBSTRING(T-CDOC.nrodoc,4).
       cRange = "D" + cColumn.
       chWorkSheet:Range(cRange):Value = "".
       cRange = "E" + cColumn.
       chWorkSheet:Range(cRange):Value = "*** ANULADO ***".
    END.
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = T-CDOC.fmapgo.
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = T-CDOC.fchvto.
    /* Ic - 29Abr2016 */
    lDocSunat = "".
    IF T-CDOC.coddoc = 'N/C' OR T-CDOC.coddoc = 'N/D' THEN DO:
         FIND FIRST FacDocum WHERE facdocum.codcia = s-codcia AND 
                                 facdocum.coddoc = t-cdoc.codref NO-LOCK.
         cRange = "T" + cColumn.
         chWorkSheet:Range(cRange):Value = IF (AVAILABLE facdocum) THEN "'" + facdocum.codcbd ELSE "".
         cRange = "U" + cColumn.
         chWorkSheet:Range(cRange):Value = t-cdoc.fchdoc.
         cRange = "V" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + t-cdoc.codref.
         cRange = "W" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + substring(t-cdoc.nroref,1,3).
         cRange = "X" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + substring(t-cdoc.nroref,4).
    END.

    FIND FIRST FacDocum WHERE facdocum.codcia = s-codcia AND 
                            facdocum.coddoc = t-cdoc.coddoc NO-LOCK.
    
    lDocSunat = IF( AVAILABLE facdocum) THEN facdocum.codcbd ELSE "**".

    /* nro asto */

    FIND FIRST cb-dmov USE-INDEX dmov03 WHERE cb-dmov.codcia = s-codcia AND 
                                                cb-dmov.periodo = YEAR(t-cdoc.fchdoc) AND 
                                                cb-dmov.nromes = MONTH(t-cdoc.fchdoc) AND
                                                cb-dmov.codcta BEGINS '12' AND
                                                cb-dmov.codaux = t-cdoc.codcli AND 
                                                cb-dmov.coddoc = lDocSunat AND
                                                cb-dmov.nrodoc = t-cdoc.nrodoc NO-LOCK NO-ERROR.
    IF AVAILABLE cb-dmov THEN DO:
        cRange = "Y" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + cb-dmov.nroast.
    END.
                            

    DISPLAY
        T-CDOC.coddoc + " " + T-CDOC.nrodoc
        FORMAT "X(15)" LABEL "   Procesando documento"
        WITH FRAME f-mensajes.
END.

HIDE FRAME f-mensajes NO-PAUSE.

RELEASE i-ccbcdocu.

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
  DEFINE VAR x-tpocmb AS DECIMAL NO-UNDO.
  
  DEFINE FRAME f-cab
        CcbcDocu.CodDoc FORMAT "XXX"
        CcbcDocu.NroDoc FORMAT "XXX-XXXXXX"
        CcbcDocu.FchDoc 
        CcbcDocu.NomCli FORMAT "X(26)"
        CcbcDocu.RucCli FORMAT "X(8)"
        CcbcDocu.Codven FORMAT "X(4)"
        X-MON           FORMAT "X(4)"
        F-ImpBrt 
        F-ImpDto 
        F-ImpVta 
        F-ImpIgv 
        F-ImpTot 
        X-TIP           FORMAT "X(2)"
        X-EST           FORMAT "X(3)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " REGISTRO DE VENTAS "  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                                     T O T A L      TOTAL         VALOR              P R E C I O        " SKIP
        "DOC  DOCUMENTO  EMISION   C L I E N T E               R.U.C.  VEND MON.      BRUTO        DSCTO.        VENTA     I.G.V.    V E N T A   ESTADO" SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH CcbcDocu NO-LOCK WHERE CcbcDocu.CodCia = S-CODCIA 
                             AND  CcbcDocu.CodDiv = FILL-IN-CodDiv
                             AND  CcbcDocu.FchDoc >= F-desde 
                             AND  CcbcDocu.FchDoc <= F-hasta 
                             AND  CcbcDocu.CodDoc BEGINS "" /*LOOKUP(CcbcDocu.CodDoc,"BOL,FAC,N/C,N/D") > 0 */
                             AND  CcbcDocu.CodDoc <> "G/R" 
                             AND  CcbcDocu.CodVen BEGINS f-vende
                            USE-INDEX LLAVE10
                            BREAK BY CcbCDocu.codcia 
                                  BY CcbCDocu.Fchdoc 
                                  BY CcbCDocu.Coddoc 
                                  BY CcbCDocu.NroDoc:
                                  
     IF FIRST-OF(CcbCDocu.Fchdoc) THEN DO:
        ASSIGN F-TOTCON = 0 F-TOTCRE = 0.
        FIND gn-tcmb WHERE gn-tcmb.fecha = CcbCDocu.fchdoc NO-LOCK NO-ERROR.
        IF AVAILABLE gn-tcmb THEN x-tpocmb = gn-tcmb.venta. 
     END.

     IF R-S-TipImp <> 3 THEN  {&NEW-PAGE}.
     IF CcbcDocu.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".
     F-Impbrt = 0.
     F-Impdto = 0.
     F-Impexo = 0.
     F-Impvta = 0.
     F-Impigv = 0.
     F-Imptot = 0.


        F-ImpBrt = (IF X-MON = 'S/.' THEN Impbrt ELSE Impbrt * x-tpocmb).
        F-ImpDto = (IF X-MON = 'S/.' THEN ImpDto ELSE ImpDto * x-tpocmb).
        F-ImpExo = (IF X-MON = 'S/.' THEN ImpExo ELSE ImpExo * x-tpocmb).
        F-ImpVta = (IF X-MON = 'S/.' THEN ImpVta ELSE ImpVta * x-tpocmb).
        F-ImpIgv = (IF X-MON = 'S/.' THEN ImpIgv ELSE ImpIgv * x-tpocmb).
        F-Imptot = (IF X-MON = 'S/.' THEN ImpTot ELSE ImpTot * x-tpocmb).


     IF CcbCDocu.Coddoc = 'N/C' THEN
        ASSIGN F-ImpBrt = F-ImpBrt * -1 
               F-ImpDto = F-ImpDto * -1
               F-ImpExo = F-ImpExo * -1
               F-ImpVta = F-ImpVta * -1
               F-ImpIgv = F-ImpIgv * -1
               F-ImpTot = F-ImpTot * -1.
               
if CcbcDocu.Flgest ne "a" then do:
     IF CcbcDocu.Fmapgo = "000"  THEN DO:
        F-TOTCON[1] = F-TOTCON[1] + F-Impbrt.
        F-TOTCON[2] = F-TOTCON[2] + F-ImpDto.
        F-TOTCON[4] = F-TOTCON[4] + F-ImpVta.
        F-TOTCON[5] = F-TOTCON[5] + F-ImpIgv.
        F-TOTCON[6] = F-TOTCON[6] + F-ImpTot.
        X-TIP = "CT".
        END.
     ELSE DO:
        F-TOTCRE[1] = F-TOTCRE[1] + F-Impbrt.
        F-TOTCRE[2] = F-TOTCRE[2] + F-ImpDto.
        F-TOTCRE[4] = F-TOTCRE[4] + F-ImpVta.
        F-TOTCRE[5] = F-TOTCRE[5] + F-ImpIgv.
        F-TOTCRE[6] = F-TOTCRE[6] + F-ImpTot.
        X-TIP = "CR".
     END.
     
        ACCUMULATE F-ImpBrt (SUB-TOTAL BY CcbCDocu.fchdoc).
        ACCUMULATE F-ImpDto (SUB-TOTAL BY CcbCDocu.fchdoc).
        ACCUMULATE F-ImpVta (SUB-TOTAL BY CcbCDocu.fchdoc).
        ACCUMULATE F-ImpIgv (SUB-TOTAL BY CcbCDocu.fchdoc).
        ACCUMULATE F-ImpTot (SUB-TOTAL BY CcbCDocu.fchdoc).
    
     end.
                                                                                         
     
     
     
     
     
     CASE CcbcDocu.FlgEst :
          WHEN "P" THEN ASSIGN X-EST = "PEN"
                               JJ = CcbcDocu.Codmon.
          WHEN "C" THEN ASSIGN X-EST = "CAN"
                               JJ = CcbcDocu.Codmon + 2.
          WHEN "A" THEN ASSIGN X-EST = "ANU"
                               JJ = CcbcDocu.Codmon + 4.
     END CASE.
     W-TotBru [JJ] = W-TotBru [JJ] + F-ImpBrt.
     W-TotDsc [JJ] = W-TotDsc [JJ] + F-ImpDto.
     W-TotExo [JJ] = W-TotExo [JJ] + F-ImpExo.
     W-TotVal [JJ] = W-TotVal [JJ] + F-ImpVta.
     W-TotIsc [JJ] = W-TotIsc [JJ] + F-ImpIsc.
     W-TotIgv [JJ] = W-TotIgv [JJ] + F-ImpIgv.
     W-TotVen [JJ] = W-TotVen [JJ] + F-ImpTot.
     CASE CcbcDocu.CodDoc:
          WHEN "N/C" THEN DO:
               W-NCBru [JJ] = W-NCBru [JJ] + F-ImpBrt. 
               W-NCDsc [JJ] = W-NCDsc [JJ] + F-ImpDto.
               W-NCExo [JJ] = W-NCExo [JJ] + F-ImpExo.
               W-NCVal [JJ] = W-NCVal [JJ] + F-ImpVta.
               W-NCIsc [JJ] = W-NCIsc [JJ] + F-ImpIsc.
               W-NCIgv [JJ] = W-NCIgv [JJ] + F-ImpIgv.
               W-NCVen [JJ] = W-NCVen [JJ] + F-ImpTot.
          END.
          WHEN "N/D" THEN DO:
               W-NDBru [JJ] = W-NDBru [JJ] + F-ImpBrt.   
               W-NDDsc [JJ] = W-NDDsc [JJ] + F-ImpDto.
               W-NDExo [JJ] = W-NDExo [JJ] + F-ImpExo.
               W-NDVal [JJ] = W-NDVal [JJ] + F-ImpVta.
               W-NDIsc [JJ] = W-NDIsc [JJ] + F-ImpIsc.
               W-NDIgv [JJ] = W-NDIgv [JJ] + F-ImpIgv.
               W-NDVen [JJ] = W-NDVen [JJ] + F-ImpTot.
          END.
          OTHERWISE DO:
               IF CcbcDocu.Fmapgo = "000"  THEN DO:
                  W-ConBru [JJ] = W-ConBru [JJ] + F-ImpBrt.   
                  W-ConDsc [JJ] = W-ConDsc [JJ] + F-ImpDto.
                  W-ConExo [JJ] = W-ConExo [JJ] + F-ImpExo.
                  W-ConVal [JJ] = W-ConVal [JJ] + F-ImpVta.
                  W-ConIsc [JJ] = W-ConIsc [JJ] + F-ImpIsc.
                  W-ConIgv [JJ] = W-ConIgv [JJ] + F-ImpIgv.
                  W-ConVen [JJ] = W-ConVen [JJ] + F-ImpTot.
                  END.
               ELSE DO:
                  W-CreBru [JJ] = W-CreBru [JJ] + F-ImpBrt.   
                  W-CreDsc [JJ] = W-CreDsc [JJ] + F-ImpDto.
                  W-CreExo [JJ] = W-CreExo [JJ] + F-ImpExo.
                  W-CreVal [JJ] = W-CreVal [JJ] + F-ImpVta.
                  W-CreIsc [JJ] = W-CreIsc [JJ] + F-ImpIsc.
                  W-CreIgv [JJ] = W-CreIgv [JJ] + F-ImpIgv.
                  W-CreVen [JJ] = W-CreVen [JJ] + F-ImpTot.
               END.
          END.
     END CASE.
     IF R-S-TipImp <> 3 THEN DO:
        C = C + 1.
        DISPLAY STREAM REPORT 
              CcbcDocu.CodDoc 
              CcbcDocu.NroDoc 
              CcbcDocu.FchDoc 
              CcbcDocu.NomCli 
              CcbcDocu.RucCli 
              CcbcDocu.Codven
              X-MON           
              F-ImpVta WHEN F-ImpVta <> 0
              F-ImpDto WHEN F-ImpDto <> 0
              F-ImpBrt WHEN F-ImpBrt <> 0
              F-ImpIgv WHEN F-ImpIgv <> 0
              F-ImpTot WHEN F-ImpTot <> 0
              X-EST 
              X-TIP WITH FRAME F-Cab.
              
/*        ACCUMULATE F-ImpBrt (SUB-TOTAL BY CcbCDocu.fchdoc).
 *         ACCUMULATE F-ImpDto (SUB-TOTAL BY CcbCDocu.fchdoc).
 *         ACCUMULATE F-ImpVta (SUB-TOTAL BY CcbCDocu.fchdoc).
 *         ACCUMULATE F-ImpIgv (SUB-TOTAL BY CcbCDocu.fchdoc).
 *         ACCUMULATE F-ImpTot (SUB-TOTAL BY CcbCDocu.fchdoc).*/
        
        IF LAST-OF(CcbCDocu.Fchdoc) THEN DO:
           UNDERLINE STREAM REPORT F-ImpVta F-Impdto F-Impbrt F-Impigv F-Imptot WITH FRAME F-Cab.
           DISPLAY STREAM REPORT
              'CONTADO'   @ CcbCDocu.Ruccli
              F-TOTCON[1] @ F-Impbrt
              F-TOTCON[2] @ F-Impdto
              F-TOTCON[4] @ F-Impvta
              F-TOTCON[5] @ F-Impigv
              F-TOTCON[6] @ F-Imptot WITH FRAME F-Cab.
           DOWN(1) STREAM REPORT WITH FRAME F-Cab.
           DISPLAY STREAM REPORT
              'CREDITO'   @ CcbCDocu.Ruccli
              F-TOTCRE[1] @ F-Impbrt
              F-TOTCRE[2] @ F-Impdto
              F-TOTCRE[4] @ F-Impvta
              F-TOTCRE[5] @ F-Impigv
              F-TOTCRE[6] @ F-Imptot WITH FRAME F-Cab.
           DOWN(1) STREAM REPORT WITH FRAME F-Cab.
         
         
           DISPLAY STREAM REPORT
              'TOTAL DE DIA   ==>' @ CcbCDocu.Nomcli
              ACCUM SUB-TOTAL BY CcBCDocu.fchdoc F-ImpBrt @ F-Impbrt
              ACCUM SUB-TOTAL BY CcBCDocu.fchdoc F-ImpDto @ F-ImpDto
              ACCUM SUB-TOTAL BY CcBCDocu.fchdoc F-ImpVta @ F-ImpVta
              ACCUM SUB-TOTAL BY CcBCDocu.fchdoc F-ImpIgv @ F-ImpIgv
              ACCUM SUB-TOTAL BY CcBCDocu.fchdoc F-ImpTot @ F-ImpTot WITH FRAME F-Cab.
          DOWN(2) STREAM REPORT WITH FRAME F-Cab.
        END.
     END.
 END.
 RUN Imprimir-2.
END PROCEDURE.



/*     x-tpocmb = CcbCDocu.Tpocmb.*/

/*     IF CcbCDocu.Flgest <> 'A' THEN DO:*/
/*     END.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-2 D-Dialog 
PROCEDURE imprimir-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-RESU
         HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " RESUMEN DE VENTAS "  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Vendedor : " f-vende f-nomven
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        WITH PAGE-TOP NO-LABEL NO-UNDERLINE NO-BOX WIDTH 165 STREAM-IO DOWN.         

 IF R-S-TipImp <> 2 THEN DO:
    IF C = 0 THEN {&NEW-PAGE}.
    IF C = 1 THEN PAGE STREAM REPORT.
    VIEW STREAM REPORT FRAME F-RESU.
    PUT STREAM REPORT {&PRN6A} + " T O T A L    C O N T A D O" + {&PRN6B} FORMAT "X(50)" SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "Total Bruto     :" AT 1 W-ConBru[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConBru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Total Bruto     :"      W-ConBru[1] AT 69  FORMAT "->>,>>9.99"    W-ConBru[2] AT 82  FORMAT "->>,>>9.99"  SPACE(4) 
                      "Total Bruto     :"      W-ConBru[5] AT 116 FORMAT "->>,>>9.99"    W-ConBru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
                      
    PUT STREAM REPORT "Descuento       :" AT 1 W-ConDsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConDsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-ConDsc[1] AT 69  FORMAT "->>,>>9.99"    W-ConDsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-ConDsc[5] AT 116 FORMAT "->>,>>9.99"    W-ConDsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Exonerado       :" AT 1 W-ConExo[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConExo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-ConExo[1] AT 69  FORMAT "->>,>>9.99"    W-ConExo[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-ConExo[5] AT 116 FORMAT "->>,>>9.99"    W-ConExo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Valor de Venta  :" AT 1 W-ConVal[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConVal[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-ConVal[1] AT 69  FORMAT "->>,>>9.99"    W-ConVal[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-ConVal[5] AT 116 FORMAT "->>,>>9.99"    W-ConVal[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.S.C.          :" AT 1 W-ConIsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConIsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-ConIsc[1] AT 69  FORMAT "->>,>>9.99"    W-ConIsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-ConIsc[5] AT 116 FORMAT "->>,>>9.99"    W-ConIsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.G.V.          :" AT 1 W-ConIgv[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConIgv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-ConIgv[1] AT 69  FORMAT "->>,>>9.99"    W-ConIgv[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-ConIgv[5] AT 116 FORMAT "->>,>>9.99"    W-ConIgv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Precio de Venta :" AT 1 W-ConVen[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConVen[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-ConVen[1] AT 69  FORMAT "->>,>>9.99"    W-ConVen[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-ConVen[5] AT 116 FORMAT "->>,>>9.99"    W-ConVen[6] AT 128 FORMAT "->>,>>9.99" SKIP(1).
        
    PUT STREAM REPORT {&PRN6A} + " T O T A L    C R E D I T O" + {&PRN6B} FORMAT "X(50)" SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "Total Bruto     :" AT 1 W-CreBru[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreBru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Total Bruto     :"      W-CreBru[1] AT 69  FORMAT "->>,>>9.99"    W-CreBru[2] AT 82  FORMAT "->>,>>9.99"  SPACE(4) 
                      "Total Bruto     :"      W-CreBru[5] AT 116 FORMAT "->>,>>9.99"    W-CreBru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
    PUT STREAM REPORT "Descuento       :" AT 1 W-CreDsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreDsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-CreDsc[1] AT 69  FORMAT "->>,>>9.99"    W-CreDsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-CreDsc[5] AT 116 FORMAT "->>,>>9.99"    W-CreDsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Exonerado       :" AT 1 W-CreExo[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreExo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-CreExo[1] AT 69  FORMAT "->>,>>9.99"    W-CreExo[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-CreExo[5] AT 116 FORMAT "->>,>>9.99"    W-CreExo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Valor de Venta  :" AT 1 W-CreVal[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreVal[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-CreVal[1] AT 69  FORMAT "->>,>>9.99"    W-CreVal[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-CreVal[5] AT 116 FORMAT "->>,>>9.99"    W-CreVal[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.S.C.          :" AT 1 W-CreIsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreIsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-CreIsc[1] AT 69  FORMAT "->>,>>9.99"    W-CreIsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-CreIsc[5] AT 116 FORMAT "->>,>>9.99"    W-CreIsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.G.V.          :" AT 1 W-CreIgv[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreIgv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-CreIgv[1] AT 69  FORMAT "->>,>>9.99"    W-CreIgv[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-CreIgv[5] AT 116 FORMAT "->>,>>9.99"    W-CreIgv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Precio de Venta :" AT 1 W-CreVen[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreVen[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-CreVen[1] AT 69  FORMAT "->>,>>9.99"    W-CreVen[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-CreVen[5] AT 116 FORMAT "->>,>>9.99"    W-CreVen[6] AT 128 FORMAT "->>,>>9.99" SKIP(1).
    PUT STREAM REPORT {&PRN6A} + " T O T A L    N O T A S    D E    D E B I T O" + {&PRN6B} FORMAT "X(50)" SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "Total Bruto     :" AT 1 W-NDBru[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDBru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Total Bruto     :"      W-NDBru[1] AT 69  FORMAT "->>,>>9.99"    W-NDBru[2] AT 82  FORMAT "->>,>>9.99"  SPACE(4) 
                      "Total Bruto     :"      W-NDBru[5] AT 116 FORMAT "->>,>>9.99"    W-NDBru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
    PUT STREAM REPORT "Descuento       :" AT 1 W-NDDsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDDsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-NDDsc[1] AT 69  FORMAT "->>,>>9.99"    W-NDDsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-NDDsc[5] AT 116 FORMAT "->>,>>9.99"    W-NDDsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Exonerado       :" AT 1 W-NDExo[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDExo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-NDExo[1] AT 69  FORMAT "->>,>>9.99"    W-NDExo[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-NDExo[5] AT 116 FORMAT "->>,>>9.99"    W-NDExo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Valor de Venta  :" AT 1 W-NDVal[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDVal[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-NDVal[1] AT 69  FORMAT "->>,>>9.99"    W-NDVal[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-NDVal[5] AT 116 FORMAT "->>,>>9.99"    W-NDVal[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.S.C.          :" AT 1 W-NDIsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDIsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-NDIsc[1] AT 69  FORMAT "->>,>>9.99"    W-NDIsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-NDIsc[5] AT 116 FORMAT "->>,>>9.99"    W-NDIsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.G.V.          :" AT 1 W-NDIgv[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDIgv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-NDIgv[1] AT 69  FORMAT "->>,>>9.99"    W-NDIgv[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-NDIgv[5] AT 116 FORMAT "->>,>>9.99"    W-NDIgv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Precio de Venta :" AT 1 W-NDVen[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDVen[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-NDVen[1] AT 69  FORMAT "->>,>>9.99"    W-NDVen[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-NDVen[5] AT 116 FORMAT "->>,>>9.99"    W-NDVen[6] AT 128 FORMAT "->>,>>9.99" SKIP(1).
    PUT STREAM REPORT {&PRN6A} + " T O T A L    N O T A S    D E    C R E D I T O" + {&PRN6B} FORMAT "X(50)" SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "Total Bruto     :" AT 1 W-NCBru[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCBru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Total Bruto     :"      W-NCBru[1] AT 69  FORMAT "->>,>>9.99"    W-NCBru[2] AT 82  FORMAT "->>,>>9.99"  SPACE(4) 
                      "Total Bruto     :"      W-NCBru[5] AT 116 FORMAT "->>,>>9.99"    W-NCBru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
    PUT STREAM REPORT "Descuento       :" AT 1 W-NCDsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCDsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-NCDsc[1] AT 69  FORMAT "->>,>>9.99"    W-NCDsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-NCDsc[5] AT 116 FORMAT "->>,>>9.99"    W-NCDsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Exonerado       :" AT 1 W-NCExo[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCExo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-NCExo[1] AT 69  FORMAT "->>,>>9.99"    W-NCExo[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-NCExo[5] AT 116 FORMAT "->>,>>9.99"    W-NCExo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Valor de Venta  :" AT 1 W-NCVal[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCVal[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-NCVal[1] AT 69  FORMAT "->>,>>9.99"    W-NCVal[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-NCVal[5] AT 116 FORMAT "->>,>>9.99"    W-NCVal[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.S.C.          :" AT 1 W-NCIsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCIsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-NCIsc[1] AT 69  FORMAT "->>,>>9.99"    W-NCIsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-NCIsc[5] AT 116 FORMAT "->>,>>9.99"    W-NCIsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.G.V.          :" AT 1 W-NCIgv[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCIgv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-NCIgv[1] AT 69  FORMAT "->>,>>9.99"    W-NCIgv[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-NCIgv[5] AT 116 FORMAT "->>,>>9.99"    W-NCIgv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Precio de Venta :" AT 1 W-NCVen[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCVen[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-NCVen[1] AT 69  FORMAT "->>,>>9.99"    W-NCVen[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-NCVen[5] AT 116 FORMAT "->>,>>9.99"    W-NCVen[6] AT 128 FORMAT "->>,>>9.99" SKIP(1).

    PUT STREAM REPORT {&PRN6A} + " T O T A L    G E N E R A L" + {&PRN6B} FORMAT "X(50)" SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
    PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
    PUT STREAM REPORT "Total Bruto     :" AT 1 W-TotBru[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotBru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Total Bruto     :"      W-TotBru[1] AT 69  FORMAT "->>,>>9.99"    W-TotBru[2] AT 82  FORMAT "->>,>>9.99"  SPACE(4) 
                      "Total Bruto     :"      W-TotBru[5] AT 116 FORMAT "->>,>>9.99"    W-TotBru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
    PUT STREAM REPORT "Descuento       :" AT 1 W-TotDsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotDsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-TotDsc[1] AT 69  FORMAT "->>,>>9.99"    W-TotDsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Descuento       :"      W-TotDsc[5] AT 116 FORMAT "->>,>>9.99"    W-TotDsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Exonerado       :" AT 1 W-TotExo[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotExo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-TotExo[1] AT 69  FORMAT "->>,>>9.99"    W-TotExo[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Exonerado       :"      W-TotExo[5] AT 116 FORMAT "->>,>>9.99"    W-TotExo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Valor de Venta  :" AT 1 W-TotVal[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotVal[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-TotVal[1] AT 69  FORMAT "->>,>>9.99"    W-TotVal[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Valor de Venta  :"      W-TotVal[5] AT 116 FORMAT "->>,>>9.99"    W-TotVal[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.S.C.          :" AT 1 W-TotIsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotIsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-TotIsc[1] AT 69  FORMAT "->>,>>9.99"    W-TotIsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "I.S.C.          :"      W-TotIsc[5] AT 116 FORMAT "->>,>>9.99"    W-TotIsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "I.G.V.          :" AT 1 W-TotIgv[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotIgv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-TotIgv[1] AT 69  FORMAT "->>,>>9.99"    W-TotIgv[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "I.G.V.          :"      W-TotIgv[5] AT 116 FORMAT "->>,>>9.99"    W-TotIgv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
    PUT STREAM REPORT "Precio de Venta :" AT 1 W-TotVen[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotVen[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-TotVen[1] AT 69  FORMAT "->>,>>9.99"    W-TotVen[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
                      "Precio de Venta :"      W-TotVen[5] AT 116 FORMAT "->>,>>9.99"    W-TotVen[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 END.

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

