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
/*DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.*/
  
def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE T-CAJA   AS CHAR INIT "".
DEFINE VARIABLE T-CJRO   AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-CODTER AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR.


/*** DEFINE VARIABLES SUB-TOTALES ***/
DEFINE VAR T-EFESOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
DEFINE VAR T-EFEDOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
DEFINE VAR T-CHDSOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.  
DEFINE VAR T-CHDDOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.
DEFINE VAR T-CHFSOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.
DEFINE VAR T-CHFDOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.
DEFINE VAR T-NCRSOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.
DEFINE VAR T-NCRDOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.  
DEFINE VAR T-DEPSOL AS DECIMAL FORMAT "->>>>>>9.99"  INIT 0.
DEFINE VAR T-DEPDOL AS DECIMAL FORMAT "->>>>>>9.99"  INIT 0.
DEFINE VAR T-MOVTO  AS CHAR INIT "".

/* define variable para subtotales" */
def var x-filename as char init "".
def var x-imptot as deci extent 2.
def var x-sdoact as deci extent 2.
def var x-codmon as char init "".

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
&Scoped-Define ENABLED-OBJECTS RECT-50 RECT-5 RECT-49 BUTTON-1 Btn_OK ~
f-cajero CB-Mvto f-desde f-hasta Btn_Cancel RADIO-SET-1 Btn_Help ~
B-impresoras RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS F-Division f-cajero CB-Mvto f-movto ~
f-desde f-hasta RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

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

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     IMAGE-UP FILE "img\excel":U
     LABEL "Exportar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE VARIABLE CB-Mvto AS CHARACTER FORMAT "X(256)":U INITIAL "TODOS" 
     LABEL "Movimiento" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "TODOS","CANCELACION DE FACTURAS","CANCELACION DE BOLETAS","LIQUIDACION DE COBRANZA" 
     DROP-DOWN-LIST
     SIZE 30.43 BY 1 NO-UNDO.

DEFINE VARIABLE f-cajero AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20.14 BY .69 NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-Division AS CHARACTER FORMAT "X(60)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-movto AS CHARACTER FORMAT "XXXX":U 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .69 NO-UNDO.

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
     SIZE 26.72 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 12 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 57 BY 5.58.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL   
     SIZE 57 BY 6.12.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15.57 BY 11.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-Division AT ROW 1.19 COL 7 COLON-ALIGNED
     BUTTON-1 AT ROW 1.19 COL 53
     Btn_OK AT ROW 1.81 COL 60
     f-cajero AT ROW 2.15 COL 7 COLON-ALIGNED NO-LABEL
     CB-Mvto AT ROW 3 COL 10.14 COLON-ALIGNED
     f-movto AT ROW 3 COL 41 COLON-ALIGNED NO-LABEL
     f-desde AT ROW 4.81 COL 13.72 COLON-ALIGNED
     f-hasta AT ROW 4.88 COL 31.14 COLON-ALIGNED
     Btn_Cancel AT ROW 5.08 COL 60
     RADIO-SET-1 AT ROW 7.73 COL 2.86 NO-LABEL
     Btn_Help AT ROW 7.81 COL 60
     B-impresoras AT ROW 8.77 COL 16
     b-archivo AT ROW 9.77 COL 16
     RB-OUTPUT-FILE AT ROW 9.92 COL 20 COLON-ALIGNED NO-LABEL
     RB-NUMBER-COPIES AT ROW 11.46 COL 10.57 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 11.46 COL 25.29 COLON-ALIGNED
     RB-END-PAGE AT ROW 11.46 COL 39.43 COLON-ALIGNED
     "Rango de Fechas :" VIEW-AS TEXT
          SIZE 17.14 BY .54 AT ROW 4.08 COL 3
          FONT 6
     "Cajero :" VIEW-AS TEXT
          SIZE 6.86 BY .46 AT ROW 2.35 COL 2
          FONT 6
     "Páginas" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 10.85 COL 33.72
          FONT 6
     " Configuracion de Impresion" VIEW-AS TEXT
          SIZE 47.86 BY .62 AT ROW 6.81 COL 1.57
          BGCOLOR 1 FGCOLOR 15 FONT 6
     RECT-50 AT ROW 1 COL 58
     RECT-5 AT ROW 6.58 COL 1
     RECT-49 AT ROW 1 COL 1
     SPACE(16.42) SKIP(6.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Liquidacion de Ingresos".


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

/* SETTINGS FOR FILL-IN F-Division IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-movto IN FRAME D-Dialog
   NO-ENABLE                                                            */
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Liquidacion de Ingresos */
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


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help D-Dialog
ON CHOOSE OF Btn_Help IN FRAME D-Dialog /* Exportar */
DO:
    DEF VAR rpta AS LOG NO-UNDO.
    x-filename = "c:\mis documentos\" + "d-liqing" + substring(string(today,'99999999'),5,4) + substring(string(today,'99999999'),3,2) + substring(string(today,'99999999'),1,2)  + substring(string(time,'HH:MM'),1,2) + substring(string(time,'HH:MM'),4,2) + ".txt".
    x-filename = "d-liqing" + substring(string(today,'99999999'),5,4) + substring(string(today,'99999999'),3,2) + substring(string(today,'99999999'),1,2)  + substring(string(time,'HH:MM'),1,2) + substring(string(time,'HH:MM'),4,2) + ".txt".
    SYSTEM-DIALOG GET-FILE x-filename
        ASK-OVERWRITE
        CREATE-TEST-FILE
        DEFAULT-EXTENSION ".txt"
        SAVE-AS
        TITLE "Archivo de salida"
        USE-FILENAME
        UPDATE rpta.
    IF rpta = NO THEN RETURN NO-APPLY.
    ASSIGN f-Desde f-hasta f-movto f-cajero .
 
  IF f-desde = ? then do:
     MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.   
  END.
  
  IF f-hasta = ? then do:
     MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-hasta.
     RETURN NO-APPLY.   
  END.   

  IF f-desde > f-hasta then do:
     MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.
  END.

  IF f-Division = '' THEN DO:
    FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia NO-LOCK:
        IF f-Division = '' 
        THEN f-Division = TRIM(gn-divi.coddiv).
        ELSE f-Division = f-Division + ',' + TRIM(gn-divi.coddiv).
    END.
  END.
 
DEFINE VAR iabonomn AS DEC.
DEFINE VAR iabonome AS DEC.
DEFINE VAR lSec AS INT.

 output to VALUE(x-filename).
 PUT UNFORMATTED "FchCobranza|UsuaCobranza|NroCobranza|codven|fchdoc|coddoc|nrodoc|DivOri|CodClie|NombClie|moneda|imptot S/.|imptot $|sdoact S/.|sdoact $|Abono S/.|Abono $|estado" SKIP.

   FOR EACH CcbCcaja WHERE 
          CcbcCaja.CodCia  = S-CODCIA AND 
/*          CcbcCaja.CodDiv  = S-CODDIV AND */
          LOOKUP(TRIM(CcbcCaja.coddiv), f-Division) > 0 AND
          CcbcCaja.CodDoc  = "I/C"    AND
          CcbcCaja.FchDoc >= F-desde  AND 
          CcbcCaja.FchDoc <= F-hasta  AND
          CcbcCaja.FlgEst <> "A"
          NO-LOCK USE-INDEX LLAVE07,
          EACH CcbDCaja OF CcbCcaja 
     BREAK BY CcbcCaja.CodCia 
           BY CcbCcaja.Tipo   
           BY Ccbccaja.NroDoc:

           
       iabonomn = 0.
       iabonome = 0.

       find ccbcdocu  where ccbcdocu.codcia = s-codcia
       and ccbcdocu.coddoc = CcbDCaja.CodRef
       and ccbcdocu.nrodoc = CcbDCaja.NroRef 
       no-lock no-error.   

       IF FIRST-OF(CcbCcaja.Tipo) OR FIRST-OF(CcbCcaja.NroDoc) THEN DO:
           IF CcbcCaja.CodMon = 1 THEN DO:
               DO lSec = 1 TO 10:
                   iabonomn = iabonomn + ImpNac[lSec].
               END.
           END.
           ELSE DO:
               DO lSec = 1 TO 10:
                   iabonome = iabonome + ImpUsa[lSec].
               END.
           END.
           export delimiter "|"
                   CcbcCaja.FchDoc
                   CcbcCaja.usuario
                   CcbcCaja.NroDoc
                   0
                   ""
                   CcbCcaja.Tipo
                   CcbcCaja.Nrodoc
                   CcbcCaja.coddiv
                   CcbcCaja.codcli
                   CcbcCaja.nomcli
                   x-codmon
                   0.00
                   0.00
                   0.00
                   0.00
                   iabonomn
                   iabonome
                   CcbcCaja.flgest.
       END.
        
     /*
     x-imptot[1] = if ccbcdocu.codmon = 1 then ccbcdocu.imptot else 0.
     x-imptot[2] = if ccbcdocu.codmon = 2 then ccbcdocu.imptot else 0.
     x-sdoact[1] = if ccbcdocu.codmon = 1 then ccbcdocu.sdoact else 0.
     x-sdoact[2] = if ccbcdocu.codmon = 2 then ccbcdocu.sdoact else 0.
     x-codmon = if ccbcdocu.codmon = 1 then "S/." else "$".
     */
     x-codmon = if CcbDCaja.codmon = 1 then "S/." else "$".
     /* Los iimportes pagados / aplicados */
     x-imptot[1] = if CcbDCaja.codmon = 1 then CcbDCaja.imptot else 0.
     x-imptot[2] = if CcbDCaja.codmon = 2 then CcbDCaja.imptot else 0.
     /* Saldo del documento */
     x-sdoact[1] = if ccbcdocu.codmon = 1 then ccbcdocu.sdoact else 0.
     x-sdoact[2] = if ccbcdocu.codmon = 2 then ccbcdocu.sdoact else 0.

    export delimiter "|"
            CcbcCaja.FchDoc
            CcbcCaja.usuario
            CcbcCaja.NroDoc
            ccbcdocu.codven
            ccbcdocu.fchdoc
            CcbDCaja.CodRef
            CcbDCaja.NroRef
            ccbcdocu.coddiv
            ccbcdocu.codcli
            ccbcdocu.nomcli
            x-codmon
            x-imptot[1]
            x-imptot[2]
            x-sdoact[1]
            x-sdoact[2]        
            0
            0
            ccbcdocu.flgest.
        
    end.
    output close.
/*     x-filename = "DELETE " + x-filename.            */
/*     OS-COMMAND SILENT NO-CONSOLE VALUE(x-filename). */
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  
  ASSIGN f-Desde f-hasta f-movto f-cajero f-Division.
 
  IF f-desde = ? then do:
     MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.   
  END.
   
  IF f-hasta = ? then do:
     MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-hasta.
     RETURN NO-APPLY.   
  END.   

  IF f-desde > f-hasta then do:
     MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.
  END.
 
  T-CAJA = "Caja : " + S-CODTER. 
/*  T-CJRO = "Cajero : " + S-USER-ID.*/
  IF f-cajero = "" THEN T-CJRO = "Cajero : GENERAL " .
  ELSE T-CJRO = "Cajero : " + f-cajero.

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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 D-Dialog
ON CHOOSE OF BUTTON-1 IN FRAME D-Dialog /* ... */
DO:
  DEF VAR x-Divisiones AS CHAR.
  x-Divisiones = f-Division:SCREEN-VALUE.
  RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
  f-Division:SCREEN-VALUE = x-Divisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CB-Mvto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-Mvto D-Dialog
ON VALUE-CHANGED OF CB-Mvto IN FRAME D-Dialog /* Movimiento */
DO:
  ASSIGN CB-Mvto.
  f-movto = ENTRY(LOOKUP(CB-Mvto,CB-Mvto:LIST-ITEMS),",CAFA,CABO,CANC").
  DISPLAY   f-movto WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Division D-Dialog
ON LEAVE OF F-Division IN FRAME D-Dialog /* Division */
DO:
    ASSIGN F-Division.
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

ASSIGN f-Division= S-CODDIV
       F-DESDE   = TODAY
       F-HASTA   = TODAY
       F-CAJERO  = S-USER-ID
       FRAME {&FRAME-NAME}:TITLE  = "Caja : " + S-CODTER + " [ Liquidacion de Ingresos ]".

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
  DISPLAY F-Division f-cajero CB-Mvto f-movto f-desde f-hasta RADIO-SET-1 
          RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE RECT-50 RECT-5 RECT-49 BUTTON-1 Btn_OK f-cajero CB-Mvto f-desde 
         f-hasta Btn_Cancel RADIO-SET-1 Btn_Help B-impresoras RB-NUMBER-COPIES 
         RB-BEGIN-PAGE RB-END-PAGE 
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

/*  RUN lisliq.*/
    RUN Lisliq-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa D-Dialog 
PROCEDURE Inicializa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 T-EFESOL = 0. 
 T-EFEDOL = 0.
 T-CHDSOL = 0.
 T-CHDDOL = 0.
 T-CHFSOL = 0.
 T-CHFDOL = 0.
 T-NCRSOL = 0.
 T-NCRDOL = 0.
 T-DEPSOL = 0.
 T-DEPDOL = 0.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Lisliq D-Dialog 
PROCEDURE Lisliq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/******** B A C K U P ******/
/*
 /*** DEFINE VARIABLES TOTALES GENERALES ***/
 DEFINE VAR G-EFESOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 DEFINE VAR G-EFEDOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 DEFINE VAR G-CHDSOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.  
 DEFINE VAR G-CHDDOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.
 DEFINE VAR G-CHFSOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.
 DEFINE VAR G-CHFDOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.
 DEFINE VAR G-TARSOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.
 DEFINE VAR G-TARDOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.  
 DEFINE VAR G-DEPSOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 DEFINE VAR G-DEPDOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 
 DEFINE VAR F-DIA    AS CHAR FORMAT "X(5)".
 DEFINE VAR F-NUMERO AS CHAR FORMAT "X(6)".
 DEFINE VAR D-IMPORT AS DECIMAL FORMAT "->>>,>>9.99" INIT 0 EXTENT 2.
 DEFINE VAR SW   AS INTEGER INIT 0.
/********DEFINE VAR SW-R AS INTEGER INIT 0.******/
       
 DEFINE FRAME f-cab
        F-NUMERO        FORMAT "XXXXXX"
        F-DIA 
        CcbcCaja.Nomcli FORMAT "X(14)"
        CcbcCaja.ImpNac[1] FORMAT "->>>,>>9.99"
        CcbcCaja.ImpUsa[1] FORMAT "->>>,>>9.99"
        CcbcCaja.ImpNac[2] FORMAT "->>>>9.99"
        CcbcCaja.ImpUsa[2] FORMAT "->>>>9.99"
        CcbcCaja.ImpNac[3] FORMAT "->>>>9.99"
        CcbcCaja.ImpUsa[3] FORMAT "->>>>9.99"
        CcbcCaja.ImpNac[4] FORMAT "->>>>9.99"
        CcbcCaja.ImpUsa[4] FORMAT "->>>>9.99"
        CcbcCaja.ImpNac[5] FORMAT "->>,>>9.99"
        CcbcCaja.ImpUsa[5] FORMAT "->>,>>9.99"
        X-EST    FORMAT "X(3)"        
        CcbDCaja.CodRef    AT 14 FORMAT "XXX"
        CcbDCaja.NroRef    AT 18 FORMAT "XXX-XXXXXX"
        D-IMPORT[1]        AT 29
        D-IMPORT[2]        AT 41        

        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + CcbCCaja.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + "RESUMEN LIQUIDACION DE INGRESOS"  AT 42 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-CAJA AT 1 FORMAT "X(20)" T-CJRO AT 60 FORMAT "X(40)" "Hora  : " AT 118 STRING(TIME,"HH:MM:SS") SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "  No.  FECHA TPO                    EFECTIVO          CHEQUES DEL DIA    CHEQUES DIFERIDOS       TARJETA              DEPOSITOS          " SKIP
        "RECIBO EMIS. DOC DOCUMENTO      SOLES     DOLARES     SOLES   DOLARES     SOLES   DOLARES     SOLES   DOLARES      SOLES    DOLARES   EST" SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*       999999 99.99 12345678901234 ->>>,>>9.99 ->>>,>>9.99 ->>>>9.99 ->>>>9.99 ->>>>9.99 ->>>>9.99 ->>>>9.99 ->>>>9.99 ->>,>>9.99 ->>,>>9.99 999
                      BOL 999-999999  */
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
 FOR EACH CcbCcaja WHERE CcbcCaja.CodCia = S-CODCIA AND CcbcCaja.CodDiv = S-CODDIV AND 
                CcbcCaja.Tipo BEGINS f-movto AND CcbCCaja.CodCaja = S-CODTER AND
                CcbCCaja.usuario BEGINS f-cajero NO-LOCK,
          EACH CcbDCaja OF CcbCcaja WHERE CcbDcaja.CodDoc = Ccbccaja.CodDoc AND CcbDcaja.NroDoc = Ccbccaja.NroDoc
               AND CcbDCaja.FchDoc >= F-desde AND CcbDCaja.FchDoc <= F-hasta NO-LOCK
                          
     BREAK BY CcbCcaja.Tipo
           BY CcbDcaja.NroDoc :
           
     {&new-page}.

     IF FIRST-OF(CcbcCaja.Tipo) THEN DO:
        IF CcbcCaja.Tipo = "CAFA" THEN T-MOVTO = "CANCELACION DE FACTURAS".
        IF CcbcCaja.Tipo = "CABO" THEN T-MOVTO = "CANCELACION DE BOLETAS".
        IF CcbcCaja.Tipo = "CFAC" THEN T-MOVTO = "COBRANZA DE FACTURAS".
        DOWN STREAM REPORT 1 WITH FRAME F-Cab.
        PUT STREAM REPORT {&PRN2} + {&PRN6A} + T-MOVTO + {&PRN6B} + {&PRN3} AT 10 FORMAT "X(40)".  
        DOWN STREAM REPORT 1 WITH FRAME F-Cab.
     END.     

     IF CcbCcaja.FlgEst = "C" THEN ASSIGN X-EST = "CAN".
     IF CcbCcaja.FlgEst = "A" THEN ASSIGN X-EST = "ANU".     
     IF CcbCcaja.FlgEst = "P" THEN ASSIGN X-EST = "PEN".

     IF CcbDCaja.CodMon = 1 THEN DO:
        D-IMPORT[1] = CcbDCaja.ImpTot.
        D-IMPORT[2] = 0.
     END.   
     IF CcbDCaja.CodMon = 2 THEN DO:
        D-IMPORT[2] = CcbDCaja.ImpTot.
        D-IMPORT[1] = 0.
     END.   
     
     SW = SW + 1.     
     IF SW > 1 THEN DO:
        PUT STREAM REPORT CcbDCaja.CodRef    AT 14 FORMAT "XXX"
                          CcbDCaja.NroRef    AT 18 FORMAT "XXX-XXXXXX"
                          D-IMPORT[1]        AT 29 
                          D-IMPORT[2]        AT 41. 
     END.  
     
     F-NUMERO = SUBSTRING(CcbDCaja.NroDoc,4,6).
     F-DIA    = STRING(DAY(CcbDCaja.FchDoc),"99") + "." + STRING(MONTH(CcbDCaja.FchDoc),"99").

     IF SW = 1 THEN DO:

/*******IF CcbcCaja.ImpNac[1] = 0 AND CcbCCaja.VueNac > 0 THEN DO:
           T-EFESOL = T-EFESOL - CcbCCaja.VueNac.
           SW-R = 1.
        END.         *******/

        T-EFESOL = T-EFESOL + ( CcbcCaja.ImpNac[1] - CcbCCaja.VueNac ).
        T-EFEDOL = T-EFEDOL + ( CcbcCaja.ImpUsa[1] - CcbCCaja.VueUsa ).
        T-CHDSOL = T-CHDSOL + CcbcCaja.ImpNac[2].
        T-CHDDOL = T-CHDDOL + CcbcCaja.ImpUsa[2].
        T-CHFSOL = T-CHFSOL + CcbcCaja.ImpNac[3].
        T-CHFDOL = T-CHFDOL + CcbcCaja.ImpUsa[3].
        T-TARSOL = T-TARSOL + CcbcCaja.ImpNac[4].
        T-TARDOL = T-TARDOL + CcbcCaja.ImpUsa[4].
        T-DEPSOL = T-DEPSOL + CcbcCaja.ImpNac[5].
        T-DEPDOL = T-DEPDOL + CcbcCaja.ImpUsa[5].

/*******IF CcbcCaja.ImpNac[1] = 0 AND CcbCCaja.VueNac > 0 THEN DO:
           G-EFESOL = G-EFESOL  - CcbCCaja.VueNac .
           SW-R = 1.
        END.               ***********/
        G-EFESOL = G-EFESOL + ( CcbcCaja.ImpNac[1] - CcbCCaja.VueNac ).
        G-EFEDOL = G-EFEDOL + ( CcbcCaja.ImpUsa[1] - CcbCCaja.VueUsa ).
        G-CHDSOL = G-CHDSOL + CcbcCaja.ImpNac[2].
        G-CHDDOL = G-CHDDOL + CcbcCaja.ImpUsa[2].
        G-CHFSOL = G-CHFSOL + CcbcCaja.ImpNac[3].
        G-CHFDOL = G-CHFDOL + CcbcCaja.ImpUsa[3].
        G-TARSOL = G-TARSOL + CcbcCaja.ImpNac[4].
        G-TARDOL = G-TARDOL + CcbcCaja.ImpUsa[4].
        G-DEPSOL = G-DEPSOL + CcbcCaja.ImpNac[5].
        G-DEPDOL = G-DEPDOL + CcbcCaja.ImpUsa[5].               

        DISPLAY STREAM REPORT 
        F-NUMERO 
        F-DIA 
        CcbCCaja.NomCli 
        CcbcCaja.ImpNac[1] WHEN CcbcCaja.ImpNac[1] > 0  
        CcbcCaja.ImpUsa[1] WHEN CcbcCaja.ImpUsa[1] > 0 
        CcbcCaja.ImpNac[2] WHEN CcbcCaja.ImpNac[2] > 0 
        CcbcCaja.ImpUsa[2] WHEN CcbcCaja.ImpUsa[2] > 0 
        CcbcCaja.ImpNac[3] WHEN CcbcCaja.ImpNac[3] > 0 
        CcbcCaja.ImpUsa[3] WHEN CcbcCaja.ImpUsa[3] > 0 
        CcbcCaja.ImpNac[4] WHEN CcbcCaja.ImpNac[4] > 0 
        CcbcCaja.ImpUsa[4] WHEN CcbcCaja.ImpUsa[4] > 0
        CcbcCaja.ImpNac[5] WHEN CcbcCaja.ImpNac[5] > 0
        CcbcCaja.ImpUsa[5] WHEN CcbcCaja.ImpUsa[5] > 0
        CcbDCaja.CodRef    
        CcbDCaja.NroRef    
        D-IMPORT[1] WHEN D-IMPORT[1] > 0
        D-IMPORT[2] WHEN D-IMPORT[2] > 0       
        X-EST WITH FRAME F-Cab.
/***    SW-R = 0.***/
     END.
   
     IF LAST-OF(CcbcCaja.Tipo) THEN DO:
        DOWN STREAM REPORT WITH FRAME F-Cab.            
        PUT  STREAM REPORT "---------------------------------------------------------------------------------------------------------" AT 29.
        DISPLAY STREAM REPORT "      TOTAL :" @ CcbcCaja.Nomcli WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-EFESOL @ CcbcCaja.ImpNac[1] WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-EFEDOL @ CcbcCaja.ImpUsa[1] WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-CHDSOL @ CcbcCaja.ImpNac[2] WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-CHDDOL @ CcbcCaja.ImpUsa[2] WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-CHFSOL @ CcbcCaja.ImpNac[3] WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-CHFDOL @ CcbcCaja.ImpUsa[3] WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-TARSOL @ CcbcCaja.ImpNac[4] WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-TARDOL @ CcbcCaja.ImpUsa[4] WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-DEPSOL @ CcbcCaja.ImpNac[5] WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-DEPDOL @ CcbcCaja.ImpUsa[5] WITH FRAME F-Cab.
/*      DOWN STREAM REPORT WITH FRAME F-Cab.*/
        RUN Inicializa.
     END.
     
     IF LAST-OF(CcbDCaja.NroDoc) THEN DO:
        SW = 0.
     END.
     
  
 END. 
 PUT STREAM REPORT "---------------------------------------------------------------------------------------------------------" AT 29 SKIP.
 PUT STREAM REPORT "TOTAL GENERAL :" FORMAT "X(16)" AT 12
                   G-EFESOL FORMAT "->>>,>>9.99" AT 29
                   G-EFEDOL FORMAT "->>>,>>9.99" AT 41
                   G-CHDSOL FORMAT "->>>>9.99"   AT 53
                   G-CHDDOL FORMAT "->>>>9.99"   AT 63
                   G-CHFSOL FORMAT "->>>>9.99"   AT 73
                   G-CHFDOL FORMAT "->>>>9.99"   AT 83
                   G-TARSOL FORMAT "->>>>9.99"   AT 93
                   G-TARDOL FORMAT "->>>>9.99"   AT 103
                   G-DEPSOL FORMAT "->>,>>9.99"  AT 113
                   G-DEPDOL FORMAT "->>,>>9.99"  AT 124 SKIP.
 PUT STREAM REPORT "=========================================================================================================" AT 29 SKIP.
 OUTPUT STREAM REPORT CLOSE.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Lisliq-1 D-Dialog 
PROCEDURE Lisliq-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /*** DEFINE VARIABLES TOTALES GENERALES ***/
 DEFINE VAR G-EFESOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 DEFINE VAR G-EFEDOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 DEFINE VAR G-CHDSOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.  
 DEFINE VAR G-CHDDOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.
 DEFINE VAR G-CHFSOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.
 DEFINE VAR G-CHFDOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.
 DEFINE VAR G-NCRSOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.
 DEFINE VAR G-NCRDOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.  
 DEFINE VAR G-DEPSOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 DEFINE VAR G-DEPDOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 
 DEFINE VAR F-DIA    AS CHAR FORMAT "X(5)".
 DEFINE VAR F-NUMERO AS CHAR FORMAT "X(6)".
 DEFINE VAR D-IMPORT AS DECIMAL FORMAT "->>>,>>9.99" INIT 0 EXTENT 2.
 DEFINE VAR SW   AS INTEGER INIT 0.
       
 DEFINE VAR X-FLGEST AS CHAR INIT "".
 
  IF f-Division = '' THEN DO:
    FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia NO-LOCK:
        IF f-Division = '' 
        THEN f-Division = TRIM(gn-divi.coddiv).
        ELSE f-Division = f-Division + ',' + TRIM(gn-divi.coddiv).
    END.
  END.


 DEFINE FRAME f-cab
        F-NUMERO        FORMAT "XXXXXX"
        F-DIA 
        CcbcCaja.Nomcli FORMAT "X(14)"
        CcbcCaja.ImpNac[1] FORMAT "->>>,>>9.99"
        CcbcCaja.ImpUsa[1] FORMAT "->>>,>>9.99"
        CcbcCaja.ImpNac[2] FORMAT "->>>>9.99"
        CcbcCaja.ImpUsa[2] FORMAT "->>>>9.99"
        CcbcCaja.ImpNac[3] FORMAT "->>>>9.99"
        CcbcCaja.ImpUsa[3] FORMAT "->>>>9.99"
/*MLR* 13/12/07 ***
        CcbcCaja.ImpNac[6] FORMAT "->>>>9.99"
        CcbcCaja.ImpUsa[6] FORMAT "->>>>9.99"
* ***/
/*MLR* 13/12/07 ***/
        CcbcCaja.ImpNac[4] FORMAT "->>>>9.99"
        CcbcCaja.ImpUsa[4] FORMAT "->>>>9.99"
/* ***/
        CcbcCaja.ImpNac[5] FORMAT "->>,>>9.99"
        CcbcCaja.ImpUsa[5] FORMAT "->>,>>9.99"
        X-EST    FORMAT "X(3)"
        CcbDCaja.CodRef    AT 14 FORMAT "XXX"
        CcbDCaja.NroRef    AT 18 FORMAT "XXX-XXXXXX"
        D-IMPORT[1]        AT 29
        D-IMPORT[2]        AT 41        

        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + CcbCCaja.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + "RESUMEN LIQUIDACION DE INGRESOS"  AT 42 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-CAJA AT 1 FORMAT "X(20)" T-CJRO AT 60 FORMAT "X(40)" "Hora  : " AT 118 STRING(TIME,"HH:MM:SS") SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "  No.  FECHA TPO                    EFECTIVO          CHEQUES DEL DIA    CHEQUES DIFERIDOS   TARJETAS DE REDITO       DEPOSITOS          " SKIP
        "RECIBO EMIS. DOC DOCUMENTO      SOLES     DOLARES     SOLES   DOLARES     SOLES   DOLARES     SOLES   DOLARES      SOLES    DOLARES   EST" SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*       999999 99.99 12345678901234 ->>>,>>9.99 ->>>,>>9.99 ->>>>9.99 ->>>>9.99 ->>>>9.99 ->>>>9.99 ->>>>9.99 ->>>>9.99 ->>,>>9.99 ->>,>>9.99 999
                      BOL 999-999999  */
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

 FOR EACH CcbCcaja WHERE 
          CcbcCaja.CodCia  = S-CODCIA AND 
/*          CcbcCaja.CodDiv  = S-CODDIV AND */
          LOOKUP(TRIM(CcbcCaja.CodDiv), f-Division) > 0 AND 
          CcbcCaja.CodDoc  = "I/C"    AND
          CcbcCaja.FchDoc >= F-desde  AND 
          CcbcCaja.FchDoc <= F-hasta  AND
          CcbcCaja.Tipo    BEGINS f-movto AND 
          /*CcbCCaja.CodCaja = S-CODTER AND */
          CcbCCaja.FlgEst <> "A" AND
          CcbCCaja.usuario BEGINS f-cajero NO-LOCK USE-INDEX LLAVE07,
          EACH CcbDCaja OF CcbCcaja NO-LOCK
     BREAK BY CcbcCaja.CodCia 
           BY CcbCcaja.Tipo   
           BY CcbDcaja.NroDoc:
           
     {&new-page}.
            
     IF FIRST-OF(CcbcCaja.Tipo) THEN DO:
        IF CcbcCaja.Tipo = "CAFA" THEN T-MOVTO = "CANCELACION DE FACTURAS".
        IF CcbcCaja.Tipo = "CABO" THEN T-MOVTO = "CANCELACION DE BOLETAS".
        IF CcbcCaja.Tipo = "CANCELACION" THEN T-MOVTO = "LIQUIDACION DE COBRANZA".
        DOWN STREAM REPORT 1 WITH FRAME F-Cab.
        PUT STREAM REPORT {&PRN2} + {&PRN6A} + T-MOVTO + {&PRN6B} + {&PRN3} AT 10 FORMAT "X(40)".  
        DOWN STREAM REPORT 1 WITH FRAME F-Cab.
     END.     
            
     IF CcbCcaja.FlgEst = "C" THEN ASSIGN X-EST = "CAN".
     IF CcbCcaja.FlgEst = "A" THEN ASSIGN X-EST = "ANU".     
     IF CcbCcaja.FlgEst = "P" THEN ASSIGN X-EST = "PEN".
              
     IF CcbDCaja.CodMon = 1 THEN DO:
        D-IMPORT[1] = CcbDCaja.ImpTot.
        D-IMPORT[2] = 0.
     END.   
     IF CcbDCaja.CodMon = 2 THEN DO:
        D-IMPORT[2] = CcbDCaja.ImpTot.
        D-IMPORT[1] = 0.
     END.   
             
     SW = SW + 1.     
     IF SW > 1 THEN DO:
        PUT STREAM REPORT 
            CcbDCaja.CodRef    AT 14 FORMAT "XXX"
            CcbDCaja.NroRef    AT 18 FORMAT "XXX-XXXXXX"
            D-IMPORT[1]        AT 29 
            D-IMPORT[2]        AT 41.
/*        find ccbcdocu 
 *             where ccbcdocu.codcia = s-codcia
 *             and ccbcdocu.coddoc = CcbDCaja.CodRef
 *             and ccbcdocu.nrodoc = CcbDCaja.NroRef 
 *             no-lock no-error.   
 *         IF AVAILABLE ccbcdocu THEN DO:  
 *             PUT STREAM REPORT 
 *                           ccbcdocu.codven   AT 1 FORMAT "xxx"
 *                           ccbcdocu.fchdoc AT 5 FORMAT "99/99/99"
 *                           CcbDCaja.CodRef    AT 14 FORMAT "XXX"
 *                           CcbDCaja.NroRef    AT 18 FORMAT "XXX-XXXXXX"
 *                           D-IMPORT[1]        AT 29 
 *                           D-IMPORT[2]        AT 41 
 *                           ccbcdocu.sdoact at 60 format ">>>,>>>,>>>,>>9.99"
 *                           ccbcdocu.flgest  at 80 format "x".
 *         END.*/
     END.  
               
     F-NUMERO = SUBSTRING(CcbDCaja.NroDoc,4,6).
     F-DIA    = STRING(DAY(CcbDCaja.FchDoc),"99") + "." + STRING(MONTH(CcbDCaja.FchDoc),"99").
             
     IF SW = 1 THEN DO:
             
/*******IF CcbcCaja.ImpNac[1] = 0 AND CcbCCaja.VueNac > 0 THEN DO:
           T-EFESOL = T-EFESOL - CcbCCaja.VueNac.
           SW-R = 1.
        END.         *******/
              
        T-EFESOL = T-EFESOL + ( CcbcCaja.ImpNac[1] - CcbCCaja.VueNac ).
        T-EFEDOL = T-EFEDOL + ( CcbcCaja.ImpUsa[1] - CcbCCaja.VueUsa ).
        T-CHDSOL = T-CHDSOL + CcbcCaja.ImpNac[2].
        T-CHDDOL = T-CHDDOL + CcbcCaja.ImpUsa[2].
        T-CHFSOL = T-CHFSOL + CcbcCaja.ImpNac[3].
        T-CHFDOL = T-CHFDOL + CcbcCaja.ImpUsa[3].
/*MLR* 13/12/07 ***
        T-NCRSOL = T-NCRSOL + CcbcCaja.ImpNac[6].
        T-NCRDOL = T-NCRDOL + CcbcCaja.ImpUsa[6].
* ***/
/*MLR* 13/12/07 ***/
        T-NCRSOL = T-NCRSOL + CcbcCaja.ImpNac[4].
        T-NCRDOL = T-NCRDOL + CcbcCaja.ImpUsa[4].
/* ***/
        T-DEPSOL = T-DEPSOL + CcbcCaja.ImpNac[5].
        T-DEPDOL = T-DEPDOL + CcbcCaja.ImpUsa[5].
                 
/*******IF CcbcCaja.ImpNac[1] = 0 AND CcbCCaja.VueNac > 0 THEN DO:
           G-EFESOL = G-EFESOL  - CcbCCaja.VueNac .
           SW-R = 1.
        END.               ***********/
                
        G-EFESOL = G-EFESOL + ( CcbcCaja.ImpNac[1] - CcbCCaja.VueNac ).
        G-EFEDOL = G-EFEDOL + ( CcbcCaja.ImpUsa[1] - CcbCCaja.VueUsa ).
        G-CHDSOL = G-CHDSOL + CcbcCaja.ImpNac[2].
        G-CHDDOL = G-CHDDOL + CcbcCaja.ImpUsa[2].
        G-CHFSOL = G-CHFSOL + CcbcCaja.ImpNac[3].
        G-CHFDOL = G-CHFDOL + CcbcCaja.ImpUsa[3].
/*MLR* 13/12/07 ***
        G-NCRSOL = G-NCRSOL + CcbcCaja.ImpNac[6].
        G-NCRDOL = G-NCRDOL + CcbcCaja.ImpUsa[6].
* ***/
/*MLR* 13/12/07 ***/
        G-NCRSOL = G-NCRSOL + CcbcCaja.ImpNac[4].
        G-NCRDOL = G-NCRDOL + CcbcCaja.ImpUsa[4].
/* ***/
        G-DEPSOL = G-DEPSOL + CcbcCaja.ImpNac[5].
        G-DEPDOL = G-DEPDOL + CcbcCaja.ImpUsa[5].               
                 
        DISPLAY STREAM REPORT 
            F-NUMERO 
            F-DIA 
            CcbCCaja.NomCli 
            CcbcCaja.ImpNac[1] WHEN CcbcCaja.ImpNac[1] > 0  
            CcbcCaja.ImpUsa[1] WHEN CcbcCaja.ImpUsa[1] > 0 
            CcbcCaja.ImpNac[2] WHEN CcbcCaja.ImpNac[2] > 0 
            CcbcCaja.ImpUsa[2] WHEN CcbcCaja.ImpUsa[2] > 0 
            CcbcCaja.ImpNac[3] WHEN CcbcCaja.ImpNac[3] > 0 
            CcbcCaja.ImpUsa[3] WHEN CcbcCaja.ImpUsa[3] > 0 
/*MLR* 13/12/07 ***
            CcbcCaja.ImpNac[6] WHEN CcbcCaja.ImpNac[6] > 0 
            CcbcCaja.ImpUsa[6] WHEN CcbcCaja.ImpUsa[6] > 0
* ***/
/*MLR* 13/12/07 ***/
            CcbcCaja.ImpNac[6] WHEN CcbcCaja.ImpNac[4] > 0 
            CcbcCaja.ImpUsa[6] WHEN CcbcCaja.ImpUsa[4] > 0
/* ***/
            CcbcCaja.ImpNac[5] WHEN CcbcCaja.ImpNac[5] > 0
            CcbcCaja.ImpUsa[5] WHEN CcbcCaja.ImpUsa[5] > 0
            CcbDCaja.CodRef    
            CcbDCaja.NroRef    
            D-IMPORT[1] WHEN D-IMPORT[1] > 0
            D-IMPORT[2] WHEN D-IMPORT[2] > 0       
            X-EST WITH FRAME F-Cab.
/***    SW-R = 0.***/
     END.
                 
     IF LAST-OF(CcbcCaja.Tipo) THEN DO:
        DOWN STREAM REPORT WITH FRAME F-Cab.            
        PUT  STREAM REPORT "---------------------------------------------------------------------------------------------------------" AT 29.
        DISPLAY STREAM REPORT "      TOTAL :" @ CcbcCaja.Nomcli WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-EFESOL @ CcbcCaja.ImpNac[1] WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-EFEDOL @ CcbcCaja.ImpUsa[1] WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-CHDSOL @ CcbcCaja.ImpNac[2] WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-CHDDOL @ CcbcCaja.ImpUsa[2] WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-CHFSOL @ CcbcCaja.ImpNac[3] WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-CHFDOL @ CcbcCaja.ImpUsa[3] WITH FRAME F-Cab.
/*MLR* 13/12/07 ***
        DISPLAY STREAM REPORT T-NCRSOL @ CcbcCaja.ImpNac[6] WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-NCRDOL @ CcbcCaja.ImpUsa[6] WITH FRAME F-Cab.
* ***/
/*MLR* 13/12/07 ***/
        DISPLAY STREAM REPORT T-NCRSOL @ CcbcCaja.ImpNac[4] WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-NCRDOL @ CcbcCaja.ImpUsa[4] WITH FRAME F-Cab.
/* ***/
        DISPLAY STREAM REPORT T-DEPSOL @ CcbcCaja.ImpNac[5] WITH FRAME F-Cab.
        DISPLAY STREAM REPORT T-DEPDOL @ CcbcCaja.ImpUsa[5] WITH FRAME F-Cab.
/*****  DOWN STREAM REPORT WITH FRAME F-Cab.*****/
        RUN Inicializa.
     END.
                 
     IF LAST-OF(CcbDCaja.NroDoc) THEN DO:
        SW = 0.
     END.
           
 END. 
 PUT STREAM REPORT "---------------------------------------------------------------------------------------------------------" AT 29 SKIP.
 PUT STREAM REPORT "TOTAL GENERAL :" FORMAT "X(16)" AT 12
                   G-EFESOL FORMAT "->>>,>>9.99" AT 29
                   G-EFEDOL FORMAT "->>>,>>9.99" AT 41
                   G-CHDSOL FORMAT "->>>>9.99"   AT 53
                   G-CHDDOL FORMAT "->>>>9.99"   AT 63
                   G-CHFSOL FORMAT "->>>>9.99"   AT 73
                   G-CHFDOL FORMAT "->>>>9.99"   AT 83
                   G-NCRSOL FORMAT "->>>>9.99"   AT 93
                   G-NCRDOL FORMAT "->>>>9.99"   AT 103
                   G-DEPSOL FORMAT "->>,>>9.99"  AT 113
                   G-DEPDOL FORMAT "->>,>>9.99"  AT 124 SKIP.
 PUT STREAM REPORT "=========================================================================================================" AT 29 SKIP.
 OUTPUT STREAM REPORT CLOSE.
 
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
                    PAGED PAGE-SIZE 62.
               PUT STREAM report CONTROL P-reset NULL P-flen NULL P-config NULL.
        END.
        ELSE DO:
            OUTPUT STREAM report TO VALUE ( P-archivo ) NO-MAP NO-CONVERT UNBUFFERED
                 PAGED PAGE-SIZE 62.
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

