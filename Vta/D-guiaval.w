&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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
DEFINE VARIABLE X-DIVI     AS CHAR INIT "00000".
DEFINE VARIABLE X-CODALM   AS CHAR INIT "".
DEFINE VARIABLE X-CODDIV   AS CHAR INIT "".
DEFINE VARIABLE X-CODDOC   AS CHAR INIT "G/R".
DEFINE VARIABLE X-GUIA1    AS CHAR INIT "".
DEFINE VARIABLE X-GUIA2    AS CHAR INIT "".
DEFINE VARIABLE X-DEPTO    AS CHAR INIT "" FORMAT "X(20)".
DEFINE VARIABLE X-PROVI    AS CHAR INIT "" FORMAT "X(20)".
DEFINE VARIABLE X-DISTR    AS CHAR INIT "" FORMAT "X(20)".
DEFINE VARIABLE W-ESTADO   AS CHAR.
DEFINE VAR X-TITU    AS CHAR.
DEFINE VAR X-SOLES   AS DECI INIT 0.
DEFINE VAR X-DOLARES AS DECI INIT 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCCob

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH CcbCCob SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog CcbCCob
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog CcbCCob


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-59 RECT-66 RECT-54 RADIO-SET-1 F-CodCob ~
F-cndvta RB-NUMBER-COPIES f-desde f-hasta B-impresoras B-imprime ~
RB-BEGIN-PAGE C-estado F-hora1 F-hora2 B-cancela RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 RADIO-SET-1 F-CodCob F-cndvta ~
RB-NUMBER-COPIES f-desde f-hasta RB-BEGIN-PAGE C-estado F-hora1 F-hora2 ~
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

DEFINE VARIABLE C-estado AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Estado" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Pendiente","Enviado ","Recepcionado" 
     SIZE 12 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE F-cndvta AS CHARACTER FORMAT "XXX":U 
     LABEL "Cond.Vta" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodCob AS CHARACTER FORMAT "X(8)" 
     LABEL "Cobrador" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .81.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-hora1 AS CHARACTER FORMAT "99:99":U 
     LABEL "Hora" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69 NO-UNDO.

DEFINE VARIABLE F-hora2 AS CHARACTER FORMAT "99:99":U 
     LABEL "Hora" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69 NO-UNDO.

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

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-54
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 49 BY 11.96.

DEFINE RECTANGLE RECT-59
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.29 BY 2.42.

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.14 BY 2.31.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      CcbCCob SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-1 AT ROW 6.12 COL 2.86 NO-LABEL
     RADIO-SET-1 AT ROW 8.04 COL 4.29 NO-LABEL
     F-CodCob AT ROW 3.96 COL 10.43 COLON-ALIGNED
     F-cndvta AT ROW 4.81 COL 10.43 COLON-ALIGNED
     RB-NUMBER-COPIES AT ROW 11.77 COL 10.86 COLON-ALIGNED
     f-desde AT ROW 1.65 COL 17.72 COLON-ALIGNED
     f-hasta AT ROW 2.54 COL 17.57 COLON-ALIGNED
     B-impresoras AT ROW 9.15 COL 16.72
     b-archivo AT ROW 10.15 COL 16.86
     RB-OUTPUT-FILE AT ROW 10.27 COL 20.57 COLON-ALIGNED NO-LABEL
     B-imprime AT ROW 7.92 COL 27.72
     RB-BEGIN-PAGE AT ROW 11.77 COL 24.86 COLON-ALIGNED
     C-estado AT ROW 4.85 COL 31.43 COLON-ALIGNED
     F-hora1 AT ROW 1.69 COL 34.86 COLON-ALIGNED
     F-hora2 AT ROW 2.58 COL 34.86 COLON-ALIGNED
     B-cancela AT ROW 7.92 COL 38.86
     RB-END-PAGE AT ROW 11.77 COL 40 COLON-ALIGNED
     RECT-59 AT ROW 1.23 COL 2.86
     RECT-66 AT ROW 3.73 COL 3
     " Configuracion de Impresion" VIEW-AS TEXT
          SIZE 47 BY .62 AT ROW 6.88 COL 2.86
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "Paginas" VIEW-AS TEXT
          SIZE 8.14 BY .58 AT ROW 11.08 COL 33.43
          FONT 6
     "Inicio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.88 COL 5.86
          FONT 0
     "Fin" VIEW-AS TEXT
          SIZE 5.86 BY .5 AT ROW 2.69 COL 7.43
          FONT 0
     RECT-54 AT ROW 1 COL 1.72
     SPACE(0.99) SKIP(0.57)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte Guias X Ubicacion".


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
                                                                        */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b-archivo IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       b-archivo:HIDDEN IN FRAME D-Dialog           = TRUE.

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
     _TblList          = "INTEGRAL.CcbCCob"
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte Guias X Ubicacion */
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

  ASSIGN f-hora1 f-hora2  f-desde f-hasta F-CNDVTA C-ESTADO.
  

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


&Scoped-define SELF-NAME C-estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-estado D-Dialog
ON VALUE-CHANGED OF C-estado IN FRAME D-Dialog /* Estado */
DO:
  assign c-estado.
  CASE c-estado:screen-value :
       WHEN "Todos" THEN DO:
            w-estado = "".
       END.     
       WHEN "Pendiente"  THEN DO: 
            w-estado = "P". 
       END.            
       WHEN "Enviado" THEN DO: 
            w-estado = "E".
       END.     
       WHEN "Recepcionado"      THEN DO: 
            w-estado = "R".
       END.     
           
  END.          
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-cndvta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-cndvta D-Dialog
ON LEAVE OF F-cndvta IN FRAME D-Dialog /* Cond.Vta */
DO:

  Assign F-cndvta.
  IF F-CNDVTA = "" THEN RETURN.
  FIND Gn-Convt WHERE Gn-Convt.Codig = F-CNDVTA  NO-LOCK NO-ERROR.
  IF NOT AVAIL Gn-Convt THEN DO:
    MESSAGE "CONDICION DE VENTA NO EXISTE ..VERIFIQUE"  VIEW-AS ALERT-BOX ERROR. 
    RETURN NO-APPLY .   
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-cndvta D-Dialog
ON MOUSE-SELECT-DBLCLICK OF F-cndvta IN FRAME D-Dialog /* Cond.Vta */
DO:
  RUN lkup\c-condvt.r("CONDICIONES DE VENTA").
  IF output-var-2 = ? THEN output-var-2 = "".
  f-cndvta:SCREEN-VALUE = output-var-2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodCob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodCob D-Dialog
ON LEAVE OF F-CodCob IN FRAME D-Dialog /* Cobrador */
DO:
  assign F-CODCOB.
  IF F-CODCOB = "" THEN RETURN.
  FIND gn-cob WHERE gn-cob.codcia = S-CODCIA AND
                    gn-cob.codcob = F-CODCOB NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-cob
  THEN DO:
    MESSAGE "Cobrador no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-hora1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-hora1 D-Dialog
ON LEAVE OF F-hora1 IN FRAME D-Dialog /* Hora */
DO:
  ASSIGN F-HORA1 F-HASTA F-DESDE.
  DO WITH FRAME {&FRAME-NAME}:
        IF SUBSTRING(F-HORA1,1,2) >= "24" THEN DO:
            MESSAGE "Hora Incorrecta " SKIP
                    "Verifique por favor ....." 
                     VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY":U TO F-HORA1.
            RETURN NO-APPLY.  
        END.
        IF SUBSTRING(F-HORA1,3,2) >= "60" THEN DO:
            MESSAGE "Minutos Incorrecto " SKIP
                    "Verifique por favor ....." 
                     VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY":U TO F-HORA1.
            RETURN NO-APPLY.  
        END.
        
        IF F-DESDE = F-HASTA THEN DO:
           IF F-HORA1 > F-HORA2  THEN DO:   
            MESSAGE "Rango de Hora Incorrecto " SKIP
                    "Verifique por favor ....." 
                     VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY":U TO F-HORA1.
            RETURN NO-APPLY.
          END.
        END.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-hora2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-hora2 D-Dialog
ON LEAVE OF F-hora2 IN FRAME D-Dialog /* Hora */
DO:
   
   ASSIGN F-HORA2 F-HASTA F-DESDE.
   
   DO WITH FRAME {&FRAME-NAME}:
        IF SUBSTRING(F-HORA2,1,2) >= "24" THEN DO:
            MESSAGE "Hora Incorrecta " SKIP
                    "Verifique por favor ....." 
                     VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY":U TO F-HORA2.
            RETURN NO-APPLY.  
        END.
        IF SUBSTRING(F-HORA2,3,2) >= "60" THEN DO:
            MESSAGE "Minutos Incorrecto " SKIP
                    "Verifique por favor ....." 
                     VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY":U TO F-HORA2.
            RETURN NO-APPLY.  
        END.

        
        
        IF F-DESDE = F-HASTA THEN DO:
           IF F-HORA1 > F-HORA2 THEN DO:   
            MESSAGE "Rango de Hora Incorrecto " SKIP
                    "Verifique por favor ....." SKIP
                     VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY":U TO F-HORA2.
            RETURN NO-APPLY.
          END.
        END.
    END.
 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 D-Dialog
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME D-Dialog
DO:
    IF SELF:SCREEN-VALUE = "4"
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
   f-punto = S-CODDIV.

  DO WITH FRAME {&FRAME-NAME}:
     f-desde = TODAY - DAY(TODAY) + 1.
     f-hasta = TODAY.
     F-HORA1 = SUBSTRING(STRING(TIME,"HH:MM"),1,2) + SUBSTRING(STRING(TIME,"HH:MM"),4,2).
     F-HORA2 = SUBSTRING(STRING(TIME,"HH:MM"),1,2) + SUBSTRING(STRING(TIME,"HH:MM"),4,2).
     DISPLAY f-desde f-hasta f-hora1 f-hora2.
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
  DISPLAY FILL-IN-1 RADIO-SET-1 F-CodCob F-cndvta RB-NUMBER-COPIES f-desde 
          f-hasta RB-BEGIN-PAGE C-estado F-hora1 F-hora2 RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE RECT-59 RECT-66 RECT-54 RADIO-SET-1 F-CodCob F-cndvta RB-NUMBER-COPIES 
         f-desde f-hasta B-impresoras B-imprime RB-BEGIN-PAGE C-estado F-hora1 
         F-hora2 B-cancela RB-END-PAGE 
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
    
  
  DO WITH FRAME {&FRAME-NAME}:
        ASSIGN F-HORA1 F-HORA2 F-HASTA F-DESDE.
        IF F-DESDE = F-HASTA THEN DO:
           IF F-HORA1 > F-HORA2 THEN DO:   
            MESSAGE "Rango de Hora Incorrecto " SKIP
                    "Verifique por favor ....." SKIP
                     VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY":U TO F-HORA1.
            RETURN NO-APPLY.
          END.
        END.
   END.
   RUN Reporte.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reporte D-Dialog 
PROCEDURE Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 X-TITU = "REPORTE DE GUIAS - CONDICION VENTA " .
 DEFINE FRAME f-cab
        CcbCdocu.Nrodoc 
        CcbCdocu.Fchdoc
        CcbCdocu.Nomcli FORMAT "X(40)"
        CcbCdocu.Fmapgo FORMAT "X(5)"
        ccbCDocu.Flgsit FORMAT "X"
        X-SOLES         FORMAT "->>>,>>>,>>9.99"
        X-DOLARES       FORMAT "->>>,>>>,>>9.99"
        CcbCDocu.Glosa  FORMAT "X(40)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
        {&PRN4} + {&PRN6A} + "DIVISION : " + f-punto AT 1 FORMAT "X(20)" F-DIRDIV AT 25 FORMAT "X(30)"  
        {&PRN4} + {&PRN6B} + "Pagina: " AT 100 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN4} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN4} + {&PRN6B} + "Fecha : " AT 100 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        {&PRN4} + {&PRN6A} + "GUIAS    : " + X-GUIA1  + " HASTA :" + X-GUIA2  FORMAT "X(60)"
        {&PRN4} + {&PRN6B} + "Hora  : " AT 100 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND}  SKIP
        
        "-----------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " Documento   Fecha      Nombre o Razon Social                Cond.Vta Estado     Importe S/.  Importe US$.             Observaciones                 " SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***      999  12345678901234567890123456789012345  999999  12345678901234567890123456789012345678901234567890 1234 99,999,999.99  999,999,999.99 ***/
         WITH WIDTH 600 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

 FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR AND
          CcbCdocu.CodCia = S-CODCIA AND
          CcbCdocu.CodDiv = S-CODDIV AND
          CCbCdocu.FchDoc >= f-desde AND 
          CcbCdocu.FchDoc <= f-hasta AND
          CcbCdocu.CodDoc = X-CODDOC AND
          CcbCDocu.FlgEst <> "A"     AND
          CcbCDocu.FlgSit BEGINS w-estado AND
          CcbCdocu.FmaPgo BEGINS F-cndvta AND
          CcbCdocu.CodCob BEGINS F-CODCOB USE-INDEX LLAVE10
          BREAK BY CodCia
                BY CodDiv
                BY Codcob
                BY FmaPgo  
                BY Codcli:
                                 
     {&NEW-PAGE}.
     
     DISPLAY STREAM REPORT WITH FRAME F-Cab.
 
     IF FIRST-OF( CcbCdocu.CodCob) THEN DO:
       FIND Gn-Cob WHERE Gn-Cob.Codcia = S-CODCIA AND
                   TRIM(Gn-Cob.Codcob) = TRIM(CcbCdocu.Codcob) NO-LOCK NO-ERROR.
          PUT STREAM REPORT  " " SKIP.
          PUT STREAM REPORT "COBRADOR : "    FORMAT "X(10)"  AT 1.
          PUT STREAM REPORT CcbCDocu.Codcob  FORMAT "X(10)"  AT 14.
       IF AVAILABLE Gn-Cob THEN DO:
          PUT STREAM REPORT Gn-Cob.Nomcob  FORMAT "X(40)"  AT 25 SKIP.
       END.
       PUT STREAM REPORT '------------------------------------------' FORMAT "X(50)" SKIP(2).
     END.
      
     IF FIRST-OF( CcbCdocu.FmaPgo) THEN DO:
       FIND Gn-Convt WHERE TRIM(Gn-Convt.Codig) = TRIM(CcbCdocu.FmaPgo) NO-LOCK NO-ERROR.
       IF AVAILABLE Gn-convt THEN DO:
          PUT STREAM REPORT  " " SKIP.
          PUT STREAM REPORT CcbCDocu.FmaPgo FORMAT "X(4)"  AT 11.
          PUT STREAM REPORT Gn-Convt.Nombr  FORMAT "X(40)" AT 17 SKIP.
       END.
     END.

     X-SOLES = 0.
     X-DOLARES = 0.
     
     IF CcbCDocu.Codmon = 1 THEN DO:
      X-SOLES = CcbCDocu.Imptot.
      ACCUM  X-SOLES (SUB-TOTAL BY CcbCdocu.Codcob) .
      ACCUM  X-SOLES (SUB-TOTAL BY CcbCdocu.FmaPgo) .
      ACCUM  X-SOLES (SUB-TOTAL BY CcbCdocu.Codcli) .
      ACCUM  X-SOLES (TOTAL BY CcbCdocu.Codcia) .
     END.
     IF CcbCDocu.Codmon = 2 THEN DO:
      X-DOLARES = CcbCDocu.Imptot.
      ACCUM  X-DOLARES (SUB-TOTAL BY CcbCdocu.Codcob) .
      ACCUM  X-DOLARES (SUB-TOTAL BY CcbCdocu.FmaPgo) .
      ACCUM  X-DOLARES (SUB-TOTAL BY CcbCdocu.Codcli) .
      ACCUM  X-DOLARES ( TOTAL BY CcbCdocu.Codcia) .
     END.
     
     DISPLAY STREAM REPORT 
        CcbCDocu.Nrodoc
        CcbCDocu.Fchdoc
        CcbCDocu.Nomcli
        CcbCDocu.FmaPgo
        CcbCDocu.Flgsit
        X-SOLES
        X-DOLARES
        CcbCDocu.Glosa
        WITH FRAME F-Cab.
       
      IF LAST-OF(CcbCDocu.Codcli) THEN DO:
        UNDERLINE STREAM REPORT 
           X-SOLES X-DOLARES
        WITH FRAME F-CAB.
        DISPLAY STREAM REPORT 
            (ACCUM SUB-TOTAL BY  CcbCdocu.Codcli X-SOLES   ) @ X-SOLES 
            (ACCUM SUB-TOTAL BY  CcbCdocu.Codcli X-DOLARES ) @ X-DOLARES
        WITH FRAME F-CAB.
        DOWN STREAM REPORT 1 WITH FRAME F-CAB.        

      END.

      IF LAST-OF(CcbCDocu.Fmapgo) THEN DO:
        UNDERLINE STREAM REPORT 
           X-SOLES X-DOLARES
        WITH FRAME F-CAB.
        DISPLAY STREAM REPORT 
            ("SUB-TOTAL  : " + CcbCDocu.FmaPgo) @ CcbCDocu.Nomcli
            (ACCUM SUB-TOTAL BY  CcbCdocu.FmaPgo X-SOLES   ) @ X-SOLES 
            (ACCUM SUB-TOTAL BY  CcbCdocu.FmaPgo X-DOLARES ) @ X-DOLARES
        WITH FRAME F-CAB.
        DOWN STREAM REPORT 1 WITH FRAME F-CAB.        
        
      END.
      
      IF LAST-OF(CcbCDocu.Codcob) THEN DO:
        UNDERLINE STREAM REPORT 
           X-SOLES X-DOLARES
        WITH FRAME F-CAB.
        DISPLAY STREAM REPORT 
            ("SUB-TOTAL COBRADOR : " + CcbCDocu.Codcob) @ CcbCDocu.Nomcli
            (ACCUM SUB-TOTAL BY  CcbCdocu.Codcob X-SOLES   ) @ X-SOLES 
            (ACCUM SUB-TOTAL BY  CcbCdocu.Codcob X-DOLARES ) @ X-DOLARES
        WITH FRAME F-CAB.
        DOWN STREAM REPORT 1 WITH FRAME F-CAB.        
        
      END.
      
      
      
      IF LAST-OF(CcbCDocu.Codcia) THEN DO:
        UNDERLINE STREAM REPORT 
           X-SOLES X-DOLARES
        WITH FRAME F-CAB.
        DISPLAY STREAM REPORT 
            ("TOTAL  : " + STRING(CcbCDocu.Codcia,"999")) @ CcbCDocu.Nomcli
            (ACCUM TOTAL BY  CcbCdocu.Codcia X-SOLES   ) @ X-SOLES 
            (ACCUM TOTAL BY  CcbCdocu.Codcia X-DOLARES ) @ X-DOLARES
        WITH FRAME F-CAB.
      END.

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CcbCCob"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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


