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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

/*
    @PRINTER2.W    VERSION 1.0
*/
{lib/def-prn.i}    
DEFINE STREAM report.
/*DEFINE VARIABLE x-Raya     AS CHARACTER FORMAT "X(145)".
DEFINE {&NEW} SHARED VARIABLE xTerm AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id   LIKE _user._userid.*/

DEFINE NEW SHARED VARIABLE xTerm AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.
 
def var l-immediate-display  AS LOGICAL.
DEFINE VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE PTO       AS LOGICAL.

DEFINE VARIABLE F-TIPO   AS CHAR INIT "0".
DEFINE VARIABLE T-TITULO AS CHAR INIT "".
DEFINE VARIABLE T-TITUL1 AS CHAR INIT "".
DEFINE VARIABLE T-FAMILI AS CHAR INIT "".
DEFINE VARIABLE T-SUBFAM AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE L-SALIR  AS LOGICAL INIT NO.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE VARIABLE F-DIRDIV   AS CHAR.
DEFINE VARIABLE F-PUNTO    AS CHAR.
DEFINE VARIABLE X-PUNTO    AS CHAR.

DEFINE VAR X-TOT1 AS DECI.
DEFINE VAR X-TOT2 AS DECI.
DEFINE VAR X-TOT3 AS DECI.
DEFINE VAR X-TOT4 AS DECI.
DEFINE VAR X-TOTS1 AS DECI.
DEFINE VAR X-TOTS2 AS DECI.


DEFINE VAR X-SIGNO AS DECI.
DEFINE VAR X-NOMBRE AS CHAR.
DEFINE VAR X-TPOCMB AS DECI.
DEFINE VAR X-FLG AS LOGICAL.

DEFINE TEMP-TABLE tempo 
       FIELD CODCIA   LIKE CcbcDocu.Codcia
       FIELD CODDIV   LIKE CcbCdocu.Coddiv
       FIELD CODCLI   LIKE CcbCdocu.Codcli
       FIELD CODDOC   LIKE CcbCdocu.CodDoc
       FIELD NRODOC   LIKE CcbCdocu.NroDoc
       FIELD FCHDOC   LIKE Ccbcdocu.FchDoc
       FIELD NOMCLI   LIKE Ccbcdocu.Nomcli
       FIELD IMPTOT   LIKE Ccbcdocu.ImpTot
       FIELD IMPNAC   LIKE Ccbcdocu.ImpTot
       FIELD IMPUSA   LIKE Ccbcdocu.ImpTot
       FIELD CODMON   LIKE Ccbcdocu.Codmon
       FIELD NROCAR   LIKE Ccbcdocu.NroCar
       INDEX LLAVE01 CODCIA NROCAR FCHDOC CODDIV.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-58 RECT-55 R-reporte F-Division f-desde ~
f-hasta RADIO-SET-Tipo x-NroCard F-unival x-MtoMin f-TpoCmb B-imprime ~
B-cancela RADIO-SET-1 B-impresoras RB-NUMBER-COPIES RB-BEGIN-PAGE ~
RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS R-reporte F-Division f-desde f-hasta ~
RADIO-SET-Tipo x-NroCard F-unival x-MtoMin f-TpoCmb FILL-IN-1 RADIO-SET-1 ~
RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

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
     SIZE 10.57 BY 1.5.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON B-imprime AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Imprimir" 
     SIZE 10.57 BY 1.5.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-Division AS CHARACTER FORMAT "X(6)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .69
     BGCOLOR 15 FGCOLOR 1 FONT 6 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-TpoCmb AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "T.C." 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-unival AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Valor Unitario en S/." 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.57 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-BEGIN-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-END-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 9999 
     LABEL "Hasta" 
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
     SIZE 26.57 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 12 NO-UNDO.

DEFINE VARIABLE x-MtoMin AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Monto Minimo S/." 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE x-NroCard AS CHARACTER FORMAT "X(6)":U 
     LABEL "Tarjeta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE R-reporte AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Listado General", 1,
"Solo Cancelados", 2,
"Solo Cancelados sin deuda", 3
     SIZE 22 BY 1.96 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3
     FONT 6 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Tipo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Detalle", 1,
"Resumen", 2
     SIZE 12 BY 1.38 NO-UNDO.

DEFINE RECTANGLE RECT-55
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 16.86 BY 1.85.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 23 BY 2.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     R-reporte AT ROW 1.5 COL 36.72 NO-LABEL
     F-Division AT ROW 1.58 COL 12.86
     f-desde AT ROW 2.35 COL 17 COLON-ALIGNED
     f-hasta AT ROW 3.12 COL 17 COLON-ALIGNED
     RADIO-SET-Tipo AT ROW 3.85 COL 36.57 NO-LABEL
     x-NroCard AT ROW 3.88 COL 17 COLON-ALIGNED
     F-unival AT ROW 4.65 COL 17 COLON-ALIGNED
     x-MtoMin AT ROW 5.42 COL 17 COLON-ALIGNED
     f-TpoCmb AT ROW 6.19 COL 17 COLON-ALIGNED
     FILL-IN-1 AT ROW 7.15 COL 3 NO-LABEL
     B-imprime AT ROW 8.96 COL 27.86
     B-cancela AT ROW 8.96 COL 39
     RADIO-SET-1 AT ROW 9.08 COL 4.43 NO-LABEL
     B-impresoras AT ROW 10.19 COL 16.86
     b-archivo AT ROW 11.19 COL 17
     RB-OUTPUT-FILE AT ROW 11.31 COL 20.72 COLON-ALIGNED NO-LABEL
     RB-NUMBER-COPIES AT ROW 12.81 COL 11 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 12.81 COL 25 COLON-ALIGNED
     RB-END-PAGE AT ROW 12.81 COL 40.14 COLON-ALIGNED
     " Configuracion de Impresion" VIEW-AS TEXT
          SIZE 47 BY .62 AT ROW 7.92 COL 3
          BGCOLOR 1 FGCOLOR 15 FONT 6
     RECT-58 AT ROW 1.38 COL 36.14
     RECT-55 AT ROW 3.58 COL 36
     "Paginas" VIEW-AS TEXT
          SIZE 8.14 BY .58 AT ROW 12.12 COL 33.57
          FONT 6
     SPACE(18.71) SKIP(1.64)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte de Ventas x Tarjeta".


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
   L-To-R                                                               */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b-archivo IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       b-archivo:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN F-Division IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN RB-OUTPUT-FILE IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RB-OUTPUT-FILE:HIDDEN IN FRAME D-Dialog           = TRUE.

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
{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte de Ventas x Tarjeta */
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


&Scoped-define SELF-NAME B-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-cancela D-Dialog
ON CHOOSE OF B-cancela IN FRAME D-Dialog /* Cancelar */
DO:
  L-SALIR = YES.
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
  ASSIGN R-reporte f-division f-desde f-hasta RADIO-SET-Tipo x-NroCard x-MtoMin
    f-unival f-tpocmb.

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
     IF P-select <> 1 THEN P-copias = 1.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Division D-Dialog
ON LEAVE OF F-Division IN FRAME D-Dialog /* División */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                       Gn-Divi.Coddiv = SELF:SCREEN-VALUE
                       NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Divi THEN DO:
        MESSAGE "Division  No Existe " SKIP
                "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-hasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-hasta D-Dialog
ON LEAVE OF f-hasta IN FRAME D-Dialog /* Hasta */
DO:
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= INPUT {&SELF-NAME} NO-LOCK NO-ERROR.
  IF AVAILABLE GN-TCMB
  THEN DISPLAY gn-tcmb.venta @ f-tpocmb WITH FRAME {&FRAME-NAME}.
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
  DO WITH FRAME {&FRAME-NAME}:
    f-desde = TODAY - DAY(TODAY) + 1.
    f-hasta = TODAY.
    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= f-hasta NO-LOCK NO-ERROR.
    IF AVAILABLE GN-TCMB THEN f-tpocmb = gn-tcmb.venta.
    DISPLAY f-desde f-hasta f-tpocmb.
  END.

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

/*FRAME F-Mensaje:TITLE =  FRAME D-DIALOG:TITLE.
  VIEW FRAME F-Mensaje.  
  PAUSE 0.           
  SESSION:IMMEDIATE-DISPLAY = YES.*/

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle D-Dialog 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


FOR EACH Gn-Divi NO-LOCK WHERE NOT L-SALIR AND
          Gn-Divi.Codcia = S-CODCIA AND
          Gn-Divi.CodDiv BEGINS F-Division:
    FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR AND
          CcbCdocu.CodCia = S-CODCIA AND
          CcbCdocu.CodDiv = Gn-Divi.CodDiv AND
          CCbCdocu.FchDoc >= f-desde AND 
          CcbCdocu.FchDoc <= f-hasta AND
          LOOKUP(TRIM(CcbCdocu.CodDoc),"FAC,BOL,N/C,TCK") > 0 AND 
          CcbCdocu.FlgEst <> "A" AND
          CcbCdocu.NroCard <> '' AND
          (x-NroCard = '' OR CcbCdocu.nrocard = x-nrocard)
          USE-INDEX LLAVE10:
        CREATE Tempo.
        ASSIGN
        Tempo.Codcia = S-CODCIA  
        Tempo.CodDiv = Ccbcdocu.CodDiv
        Tempo.CodDoc = Ccbcdocu.CodDoc
        Tempo.NroDoc = Ccbcdocu.NroDoc
        Tempo.fchDoc = Ccbcdocu.fchDoc
        Tempo.Codmon = Ccbcdocu.Codmon
        Tempo.Nomcli = Ccbcdocu.Nomcli
        Tempo.Codcli = Ccbcdocu.Codcli
        Tempo.NroCar = ccbcdocu.NroCar .
        IF Ccbcdocu.Codmon = 1 THEN Tempo.ImpNac =  Ccbcdocu.ImpTot.
        IF Ccbcdocu.Codmon = 2 THEN Tempo.ImpUsa =  Ccbcdocu.ImpTot.
        IF ccbcdocu.codmon = 1 
        THEN Tempo.ImpTot = Tempo.ImpNac.
        ELSE Tempo.ImpTot = Tempo.ImpUsa * x-tpocmb.
    END.
END.
 
  /* POR EL MONTO MINIMO DE COMPRA */
  DEF VAR x-Anular AS CHAR.
  DEF VAR f-Signo AS INT.
  DEF VAR x-Total AS DECI.
  FOR EACH Tempo WHERE BREAK BY Tempo.NroCar:
    f-Signo = IF Tempo.CodDoc = 'N/C' THEN -1 ELSE 1.
    x-Total = Tempo.ImpTot * f-signo.
    ACCUMULATE x-Total (TOTAL BY Tempo.NroCar).
    IF LAST-OF(Tempo.NroCar)
    THEN DO:
        IF (ACCUM TOTAL BY Tempo.NroCar x-Total) < x-MtoMin
        THEN DO:
            IF x-Anular = '' 
            THEN x-Anular = Tempo.NroCar.
            ELSE x-Anular = x-Anular + ',' + Tempo.NroCar.
        END.
    END.
  END.
  DEF VAR i AS INT NO-UNDO.
  DO i = 1 TO NUM-ENTRIES(x-Anular):
    FOR EACH Tempo WHERE Tempo.NroCar = ENTRY(i, x-Anular):
        DELETE Tempo.
    END.            
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Resumen D-Dialog 
PROCEDURE Carga-Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH Gn-Divi NO-LOCK WHERE NOT L-SALIR AND
          Gn-Divi.Codcia = S-CODCIA AND
          Gn-Divi.CodDiv BEGINS F-Division:
          
 FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR AND
          CcbCdocu.CodCia = S-CODCIA AND
          CcbCdocu.CodDiv = Gn-Divi.CodDiv AND
          CCbCdocu.FchDoc >= f-desde AND 
          CcbCdocu.FchDoc <= f-hasta AND
          LOOKUP(CcbCdocu.CodDoc,"FAC,BOL,N/C,N/D,TCK") > 0 AND 
          CcbCdocu.FlgEst <> "A" AND
          CcbCdocu.NroCard <> "" AND
          (x-NroCard = '' OR CcbCdocu.nrocard = x-nrocard)
          USE-INDEX LLAVE10:
  
          x-signo = IF Ccbcdocu.Coddoc = "N/C" THEN -1 ELSE 1.

          FIND Tempo WHERE Tempo.Codcia = S-CODCIA  AND
                           Tempo.NroCar = Ccbcdocu.NroCar
                           NO-ERROR.
          IF NOT AVAILABLE Tempo THEN DO:                  
 
            FIND Gn-Card WHERE Gn-Card.NroCard = Ccbcdocu.NroCar
                               NO-LOCK NO-ERROR. 
            x-nombre = "".                   
            IF AVAILABLE Gn-Card THEN x-nombre = Gn-card.NomClie[1] .

            CREATE Tempo.
            ASSIGN
            Tempo.Codcia = S-CODCIA  
            Tempo.NroCar = ccbcdocu.NroCar 
            Tempo.Nomcli = x-nombre.            
          END.
          IF Ccbcdocu.Codmon = 1 THEN Tempo.ImpNac = Tempo.ImpNac + x-signo * Ccbcdocu.ImpTot.
          IF Ccbcdocu.Codmon = 2 THEN Tempo.ImpUsa = Tempo.ImpUsa + x-signo * Ccbcdocu.ImpTot.
 END.
END.
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Detalle D-Dialog 
PROCEDURE Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-TITU AS CHAR.
DEFINE VAR x-Total AS DEC.
DEFINE VAR x-Bonos AS DEC.

X-TITU = "VENTAS POR TARJETAS - DETALLE - " .
X-TOT1 = 0.
X-TOT2 = 0.
X-TOT3 = 0.
X-TOT4 = 0.
x-Total = 0.

 DEFINE FRAME f-cab
        Tempo.CodDiv FORMAT 'x(9)'
        Tempo.Coddoc FORMAT 'x(3)'
        Tempo.Nrodoc FORMAT 'x(9)'
        Tempo.fchdoc FORMAT '99/99/99'
        Tempo.codcli format 'x(11)'
        Tempo.nomcli format "x(40)"
        Tempo.impnac FORMAT '->,>>>,>>9.99'
        Tempo.impusa FORMAT '->,>>>,>>9.99'
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU  + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
        {&PRN3} + {&PRN6B} + "Pagina: " AT 80 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN3} + {&PRN6B} + "Fecha : " AT 80 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        {&PRN2} + {&PRN6A} + "DIVISION : " + F-Division FORMAT "X(30)"
        {&PRN2} + {&PRN6A} + "OBS: INCLUYE IGV" At 40 FORMAT "X(20)"  SKIP      
        "T.C.:" f-TpoCmb
        {&PRN3} + {&PRN6B} + "Hora  : " AT 80 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        "-------------------------------------------------------------------------------------------------------------------" SKIP
        " Division Coddoc NroDoc Fecha    Cliente     Nombre o Razon Social                           S/.            US$    " SKIP
        "-------------------------------------------------------------------------------------------------------------------" SKIP
/*
         123456789 123 123456789 99/99/99 12345678901 1234567890123456789012345678901234567890 ->,>>>,>>9.99 ->,>>>,>>9.99
*/
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

          
 FOR EACH Tempo BREAK BY 
          Tempo.Codcia BY
          Tempo.NroCar:

        x-signo = IF Tempo.Coddoc = "N/C" THEN -1 ELSE 1.

        IF Tempo.CodMon = 1 THEN DO:
            x-tot1   = x-tot1 + x-signo * Tempo.ImpNac.
            x-tot3   = x-tot3 + x-signo * Tempo.ImpNac.
        END.

        IF Tempo.CodMon = 2 THEN DO:
            x-tot2   = x-tot2 + x-signo * Tempo.ImpUsa.
            x-tot4   = x-tot4 + x-signo * Tempo.ImpUsa.
        END.
        
        x-Total = x-Total + x-signo * Tempo.ImpTot.

         
        IF FIRST-OF (Tempo.NroCar) THEN DO:
           FIND Gn-Card WHERE Gn-Card.NroCarD = Tempo.NroCar
                              NO-LOCK NO-ERROR. 
           x-nombre = "".                   
           IF AVAILABLE Gn-Card THEN x-nombre = Gn-card.NomClie[1] .

           {&NEW-PAGE}.
           DISPLAY STREAM REPORT 
                   Tempo.NroCar @ Tempo.codcli
                   x-nombre  @ Tempo.nomcli
                   WITH FRAME F-Cab.
           DOWN STREAM REPORT WITH FRAME F-CAB.        
                   
        END.

        DISPLAY STREAM REPORT 
                Tempo.CodDiv
                Tempo.Coddoc 
                Tempo.NroDoc
                Tempo.Fchdoc
                Tempo.CodCli
                Tempo.Nomcli
                Tempo.ImpNac
                Tempo.ImpUsa
                WITH FRAME F-Cab.
        DOWN STREAM REPORT WITH FRAME F-CAB.        

        IF LAST-OF (Tempo.NroCar) THEN DO:
           FIND Gn-Card WHERE Gn-Card.NroCard = Tempo.NroCar
                              NO-LOCK NO-ERROR. 
           x-nombre = "".                   
           IF AVAILABLE Gn-Card THEN x-nombre = Gn-card.NomClie[1] .

           {&NEW-PAGE}.
           DISPLAY STREAM REPORT 
                   "Sub-Total :" @ Tempo.nomcli 
                   x-tot1 @ Tempo.impnac
                   x-tot2 @ Tempo.impUsa
                   WITH FRAME F-Cab.
           DOWN STREAM REPORT WITH FRAME F-Cab.
           DISPLAY STREAM REPORT
                "Total en S/." @ Tempo.nomcli
                x-Total @ Tempo.ImpUsa
                WITH FRAME f-Cab.
           DOWN STREAM REPORT WITH FRAME F-Cab.
           DISPLAY STREAM REPORT
                "Valor Unitario del Vale de Compra" @ Tempo.nomcli
                F-unival @ Tempo.ImpUsa
                WITH FRAME f-Cab.
           DOWN STREAM REPORT WITH FRAME F-Cab.
           x-Bonos = TRUNCATE(x-Total / f-unival / 100 , 0).
           DISPLAY STREAM REPORT
                x-Bonos @ Tempo.ImpUsa
                WITH FRAME f-Cab.
           X-TOT1 = 0.
           X-TOT2 = 0.
           x-Total = 0.
        END.
        IF LAST-OF (Tempo.Codcia) THEN DO:
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
           UNDERLINE STREAM REPORT 
            tempo.ImpNac
            Tempo.ImpUsa
           WITH FRAME F-CAB. 
           DISPLAY STREAM REPORT
                   "T  O  T  A  L  :  " @ Tempo.nomcli
                   x-tot3 @ Tempo.ImpNac
                   x-tot4 @ Tempo.ImpUsa
                   WITH FRAME F-CAB.
        END.
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
  DISPLAY R-reporte F-Division f-desde f-hasta RADIO-SET-Tipo x-NroCard F-unival 
          x-MtoMin f-TpoCmb FILL-IN-1 RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE 
          RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE RECT-58 RECT-55 R-reporte F-Division f-desde f-hasta RADIO-SET-Tipo 
         x-NroCard F-unival x-MtoMin f-TpoCmb B-imprime B-cancela RADIO-SET-1 
         B-impresoras RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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
    P-Config = P-15cpi.
    RUN Carga-Detalle.
    
    CASE R-reporte:
         WHEN 2 THEN RUN Reviza-2.
         WHEN 3 THEN RUN reviza-3.
    END.
    

    CASE RADIO-SET-Tipo:
     WHEN 1 THEN DO:
        RUN Detalle.
     END.   
     WHEN 2 THEN DO:
         RUN Resumen.
     END.    
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
                    PAGED PAGE-SIZE 60.
               PUT STREAM report CONTROL P-reset NULL P-flen NULL P-config NULL.
        END.
        ELSE DO:
            OUTPUT STREAM report TO VALUE ( P-archivo ) NO-MAP NO-CONVERT UNBUFFERED
                 PAGED PAGE-SIZE 60.
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
/*        WHEN "F-SUBFAM" THEN ASSIGN input-var-1 = f-familia.
        WHEN "F-MARCA"  THEN ASSIGN input-var-1 = "MK".*/
        /*    ASSIGN
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen D-Dialog 
PROCEDURE Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR X-TITU AS CHAR.
X-TITU = "VENTAS POR TARJETAS - RESUMEN - " .
X-TOT1 = 0.
X-TOT2 = 0.

X-TOTS1 = 0.
X-TOTS2 = 0.

 DEFINE FRAME f-cab
        Tempo.NroCar FORMAT 'x(09)'
        Tempo.CodCli FORMAT 'x(11)'
        Tempo.Nomcli FORMAT 'x(50)'
        x-tots1 FORMAT '->,>>>,>>9.99'
        x-tots2 FORMAT '->,>>>,>>9.99'
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU  + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
        {&PRN3} + {&PRN6B} + "Pagina: " AT 80 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN3} + {&PRN6B} + "Fecha : " AT 80 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        {&PRN2} + {&PRN6A} + "DIVISION : " + F-Division FORMAT "X(30)"
        {&PRN2} + {&PRN6A} + "OBS: INCLUYE IGV" At 40 FORMAT "X(20)"        
        "T.C.:" f-TpoCmb
        {&PRN3} + {&PRN6B} + "Hora  : " AT 80 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        "----------------------------------------------------------------------------------------------------" SKIP
        " Tarjeta     Cliente      Nombre o Razon Social                                S/.           US$/.  " SKIP
        "----------------------------------------------------------------------------------------------------" SKIP
/*
         123456789 12345678901 12345678901234567890123456789012345678901234567890 >>,>>>,>>9.99 >>,>>>,>>9.99
*/
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.


 FOR EACH Tempo NO-LOCK BREAK BY 
          Tempo.Codcia BY
          Tempo.NroCar:

        IF FIRST-OF(Tempo.NroCar) THEN DO:   
            X-TOTS1 = 0.
            X-TOTS2 = 0.                 
        END.

        x-signo = IF Tempo.Coddoc = "N/C" THEN -1 ELSE 1.
        
        x-tot1   = x-tot1 + x-signo * Tempo.ImpNac .
        x-tot2   = x-tot2 + x-signo * Tempo.ImpUsa .

        x-tots1   = x-tots1 + x-signo * Tempo.ImpNac .
        x-tots2   = x-tots2 + x-signo * Tempo.ImpUsa .
 
        {&NEW-PAGE}.  
        IF LAST-OF(Tempo.NroCar) THEN DO:   
            DISPLAY STREAM REPORT 
                    Tempo.NroCar
                    Tempo.CodCli
                    Tempo.Nomcli
                    x-tots1
                    x-tots2
                    WITH FRAME F-Cab.
            DOWN STREAM REPORT WITH FRAME F-CAB.   
                
        END.
        
        IF LAST-OF (Tempo.Codcia) THEN DO:
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
           UNDERLINE STREAM REPORT 
            x-tots1
            x-tots2
           WITH FRAME F-CAB. 
           DISPLAY STREAM REPORT
                   "T  O  T  A  L  :  " @ Tempo.Nomcli
                   x-tot1 @ x-tots1
                   x-tot2 @ x-tots2
                   WITH FRAME F-CAB.
        END.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reviza-2 D-Dialog 
PROCEDURE Reviza-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH Gn-Divi NO-LOCK WHERE NOT L-SALIR AND
         Gn-Divi.Codcia = S-CODCIA AND
         Gn-Divi.CodDiv BEGINS F-Division:
          
 FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR AND
          CcbCdocu.CodCia = S-CODCIA AND
          CcbCdocu.CodDiv = Gn-Divi.CodDiv AND
          CCbCdocu.FchDoc >= f-desde AND 
          CcbCdocu.FchDoc <= f-hasta AND
          LOOKUP(CcbCdocu.CodDoc,"FAC,BOL,N/C,N/D,TCK") > 0 AND 
          CcbCdocu.FlgEst <> "A" AND
          CcbCdocu.NroCard <> "" AND
          (x-NroCard = '' OR CcbCdocu.nrocard = x-nrocard)
          USE-INDEX LLAVE10:
          
          IF Ccbcdocu.FlgEst <> "C" THEN DO:
             FOR EACH Tempo WHERE Tempo.Codcia = S-CODCIA AND
                                  Tempo.NroCar = CcbCdocu.NroCar:
                 DELETE Tempo.
             END.
          END.
          
 END.

END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reviza-3 D-Dialog 
PROCEDURE Reviza-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH Gn-Divi NO-LOCK WHERE NOT L-SALIR AND
         Gn-Divi.Codcia = S-CODCIA AND
         Gn-Divi.CodDiv BEGINS F-Division:
          
 FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR AND
          CcbCdocu.CodCia = S-CODCIA AND
          CcbCdocu.CodDiv = Gn-Divi.CodDiv AND
          CCbCdocu.FchDoc >= f-desde AND 
          CcbCdocu.FchDoc <= f-hasta AND
          LOOKUP(CcbCdocu.CodDoc,"FAC,BOL,N/C,N/D,TCK") > 0 AND 
          CcbCdocu.FlgEst <> "A" AND
          CcbCdocu.NroCard <> "" AND
          (x-NroCard = '' OR CcbCdocu.nrocard = x-nrocard)
          USE-INDEX LLAVE10:
          
          IF Ccbcdocu.FlgEst <> "C" THEN DO:
             FOR EACH Tempo WHERE Tempo.Codcia = S-CODCIA AND
                                  Tempo.NroCar = CcbCdocu.NroCar:
                 DELETE Tempo.
             END.
          END.
          
 END.

END.

X-FLG = FALSE.

FOR EACH Tempo BREAK BY Tempo.Codcli:
    IF FIRST-OF(Tempo.Codcli) THEN DO:
       X-FLG = FALSE.
       FIND CcbCdocu WHERE CcbCdocu.Codcia = Tempo.Codcia AND
                           CcbCdocu.Codcli = Tempo.Codcli AND
                           Ccbcdocu.FlgEst = "P" AND
                           LOOKUP(CcbCdocu.CodDoc,"FAC,N/D,TCK,LET,CHQ,CHC,CHD") > 0 
                           USE-INDEX LLAVE06 NO-LOCK NO-ERROR.
                           
       IF AVAILABLE CcbCdocu THEN  X-FLG = TRUE.  
       
    END.
    
    IF X-FLG THEN DELETE Tempo.
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


