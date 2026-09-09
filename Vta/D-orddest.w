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
DEFINE VARIABLE X-DIVI     AS CHAR INIT "00000".
DEFINE VARIABLE X-CODALM   AS CHAR INIT "".
DEFINE VARIABLE X-CODDIV   AS CHAR INIT "".
DEFINE VARIABLE X-CODDOC   AS CHAR INIT "O/D".
define var x-hora1 as char init "".
define var x-hora2 as char init "".
define var x-zona as char init "".
define var f-factor as integer init 1.
define var x-orden1 as char init "".
define var x-orden2 as char init "".

DEFINE TEMP-TABLE T-Detalle
       FIELD CODCIA    LIKE FacCPedi.Codcia
       FIELD CODALM    LIKE Almmmate.Codalm
       FIELD NROPED    LIKE FacCPedi.Nroped
       FIELD CODCLI    LIKE FacCPedi.Codcli
       FIELD NOMCLI    LIKE FacCPedi.Nomcli
       FIELD ESTADO    AS CHAR FORMAT "X(20)"
       FIELD FCHPED    LIKE FacCPedi.Fchped
       FIELD HORA      LIKE FacCPedi.Hora
       INDEX LLAVE01   CODCIA CODALM NROPED.



DEFINE TEMP-TABLE Temporal 
       FIELD CODCIA    LIKE FacCPedi.Codcia
       FIELD CODALM    LIKE Almmmate.Codalm
       FIELD CODMAT    LIKE Almmmatg.Codmat
       FIELD DESMAT    LIKE Almmmatg.DesMat
       FIELD DESMAR    LIKE Almmmatg.DesMar
       FIELD UNIDAD    LIKE Almmmatg.UndStk
       FIELD CANATE    LIKE FacDPedi.CanAte
       FIELD CODUBI    LIKE Almmmate.Codubi
       FIELD STKACT    LIKE Almmmate.Stkact
       INDEX LLAVE01   CODCIA CODALM CODUBI CODMAT .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-54 RECT-59 RECT-60 f-desde F-hora1 ~
f-hasta F-hora2 R-Orden B-imprime B-cancela RADIO-SET-1 RB-NUMBER-COPIES ~
B-impresoras RB-BEGIN-PAGE RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS f-desde F-hora1 f-hasta F-hora2 R-Orden ~
FILL-IN-1 RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

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

DEFINE VARIABLE R-Orden AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ubicacion", 1,
"Articulo", 2,
"Descripcion", 3
     SIZE 10.86 BY 1.69 NO-UNDO.

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
     SIZE 47.29 BY 2.35.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47 BY 2.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     f-desde AT ROW 1.69 COL 17.57 COLON-ALIGNED
     F-hora1 AT ROW 1.73 COL 34.72 COLON-ALIGNED
     f-hasta AT ROW 2.58 COL 17.43 COLON-ALIGNED
     F-hora2 AT ROW 2.62 COL 34.72 COLON-ALIGNED
     R-Orden AT ROW 4.15 COL 13.57 NO-LABEL
     B-imprime AT ROW 7.92 COL 27.72
     B-cancela AT ROW 7.92 COL 38.86
     FILL-IN-1 AT ROW 6.12 COL 2.86 NO-LABEL
     RADIO-SET-1 AT ROW 8.04 COL 4.29 NO-LABEL
     RB-NUMBER-COPIES AT ROW 11.77 COL 10.86 COLON-ALIGNED
     B-impresoras AT ROW 9.15 COL 16.72
     b-archivo AT ROW 10.15 COL 16.86
     RB-OUTPUT-FILE AT ROW 10.27 COL 20.57 COLON-ALIGNED NO-LABEL
     RB-BEGIN-PAGE AT ROW 11.77 COL 24.86 COLON-ALIGNED
     RB-END-PAGE AT ROW 11.77 COL 40 COLON-ALIGNED
     RECT-54 AT ROW 1 COL 1.72
     RECT-59 AT ROW 1.35 COL 2.86
     RECT-60 AT ROW 3.88 COL 3.14
     " Configuracion de Impresion" VIEW-AS TEXT
          SIZE 47 BY .62 AT ROW 6.88 COL 2.86
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "Paginas" VIEW-AS TEXT
          SIZE 8.14 BY .58 AT ROW 11.08 COL 33.43
          FONT 6
     "Inicio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.92 COL 5.72
          FONT 0
     "Fin" VIEW-AS TEXT
          SIZE 5.86 BY .5 AT ROW 2.73 COL 7.29
          FONT 0
     "Orden" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 5 COL 5.14
          FONT 1
     SPACE(38.57) SKIP(8.03)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte Global Orden de Despacho".


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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte Global Orden de Despacho */
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

  ASSIGN f-hora1 f-hora2  f-desde f-hasta R-orden.
  

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tabla D-Dialog 
PROCEDURE Carga-Tabla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
x-hora1 = SUBSTRING(F-HORA1,1,2) + ":" + SUBSTRING(F-HORA1,3,2).
x-hora2 = SUBSTRING(F-HORA2,1,2) + ":" + SUBSTRING(F-HORA2,3,2).
x-orden1 = "".
x-orden2 = "".


 
FOR EACH FacCPedi NO-LOCK WHERE NOT L-SALIR AND
          FacCPedi.CodCia = S-CODCIA AND
          FacCPedi.CodDiv = S-CODDIV AND
          FacCPedi.CodDoc = X-CODDOC AND
          FacCPedi.FchPed >= f-desde AND 
          FacCPedi.FchPed <= f-hasta AND
          FacCPedi.FlgEst =  "P" AND
          FacCPedi.CodAlm = S-CODALM
          USE-INDEX LLAVE03 ,
          EACH FacDPedi OF FacCPedi NO-LOCK ,
          FIRST Almmmatg OF FacDPedi NO-LOCK :
          
          IF NOT AVAILABLE Almmmatg THEN NEXT .

          IF FacDPedi.CanPed - FacDPedi.Canate = 0 THEN NEXT .

          IF FacCPedi.FchPed = f-desde AND  FacCPedi.Hora < x-hora1 THEN NEXT .
          IF FacCPedi.FchPed = f-hasta AND  FacCPedi.Hora > x-hora2 THEN NEXT .
          
          IF X-ORDEN1 = "" THEN X-ORDEN1 = FacCPedi.NroPed.
          X-ORDEN2 = FacCPedi.NroPed.
          
          
          FIND T-detalle WHERE T-detalle.Codcia = S-CODCIA AND
                               T-detalle.Codalm = FacCPedi.Codalm AND
                               T-Detalle.Nroped = FacCPedi.Nroped NO-LOCK NO-ERROR.
          
          IF NOT AVAILABLE T-Detalle THEN DO:                     
              CREATE  T-detalle.
              ASSIGN  T-Detalle.Codcia = S-CODCIA 
                      T-Detalle.Codalm = FacCPedi.Codalm 
                      T-Detalle.Nroped = FacCPedi.Nroped 
                      T-Detalle.Codcli = FacCPedi.Codcli
                      T-Detalle.Nomcli = FacCPedi.Nomcli
                      T-Detalle.FchPed = FacCPedi.Fchped 
                      T-Detalle.Hora   = FacCPedi.Hora
                      T-Detalle.Estado = IF NOT FacCPedi.Tpolic THEN "NO CONSIDERADO" ELSE "".
          END.
          IF NOT FacCPedi.Tpolic  THEN NEXT .
                                           
          FIND Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                              Almmmate.Codalm = FacCPedi.CodAlm AND
                              Almmmate.Codmat = FacDPedi.Codmat NO-LOCK NO-ERROR.

          x-zona = "".
          f-factor = 1.
          
          IF AVAILABLE Almmmate THEN x-zona = Almmmate.Codubi  .

          FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                              Almtconv.Codalter = FacDPedi.UndVta
                              NO-LOCK NO-ERROR.
                
          IF AVAILABLE Almtconv THEN DO:
           F-FACTOR = Almtconv.Equival.
           IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
          END.

          FIND Temporal WHERE 
               Temporal.Codcia  = S-CODCIA AND
               Temporal.Codalm  = FacCPedi.Codalm AND
               Temporal.Codubi  = x-zona AND
               Temporal.Codmat  = FacDPedi.CodMat NO-ERROR .
                                         
          IF NOT AVAILABLE Temporal THEN DO:
             CREATE Temporal.
                 ASSIGN 
                 Temporal.Codcia   = S-CODCIA
                 Temporal.Codalm   = FacCPedi.Codalm
                 Temporal.CodUbi   = x-zona
                 Temporal.Codmat   = FacDPedi.Codmat
                 Temporal.Desmat   = Almmmatg.Desmat
                 Temporal.Desmar   = Almmmatg.Desmar
                 Temporal.Unidad   = Almmmatg.UndStk
                 Temporal.Stkact   = almmmate.Stkact.
          END.
          ASSIGN 
          Temporal.Canate = Temporal.Canate + ( (FacDPedi.CanPed - FacDPedi.Canate )* F-FACTOR). 
          PROCESS EVENT.
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
  DISPLAY f-desde F-hora1 f-hasta F-hora2 R-Orden FILL-IN-1 RADIO-SET-1 
          RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE RECT-54 RECT-59 RECT-60 f-desde F-hora1 f-hasta F-hora2 R-Orden 
         B-imprime B-cancela RADIO-SET-1 RB-NUMBER-COPIES B-impresoras 
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

   RUN Carga-Tabla.
   IF R-ORDEN = 1 THEN RUN Reporte.
   IF R-ORDEN = 2 THEN RUN Reporte2.
   IF R-ORDEN = 3 THEN RUN Reporte3.

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
 DEFINE VAR L-SW AS LOGICAL INIT NO.
 DEFINE VAR X-TITU AS CHAR.
 X-TITU = "REPORTE GLOBAL DE ORDENES DE DESPACHO " .
 DEFINE FRAME f-cab
        Temporal.Codalm  FORMAT "x(3)"
        Temporal.Codubi  FORMAT "x(10)"
        Temporal.CodMat  FORMAT "x(8)"
        Temporal.DesMat  FORMAT "x(45)"   
        Temporal.DesMar  FORMAT "x(10)"   
        Temporal.Unidad  FORMAT "x(8)"   
        Temporal.Canate  FORMAT ">>>>>>>,>>9.99"
        Temporal.StkAct  FORMAT ">>>,>>9.99"
               
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
       /* {&PRN2} + {&PRN6A} + "DIVISION : " + f-punto AT 1 FORMAT "X(20)" F-DIRDIV AT 25 FORMAT "X(30)"  */
        {&PRN4} + {&PRN6B} + "Pagina: " AT 90 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN4} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN4} + {&PRN6B} + "Fecha : " AT 100 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        {&PRN4} + {&PRN6A} + "HORA     : " + X-HORA1 + " HASTA : " + X-HORA2 FORMAT "X(50)" 
        {&PRN4} + {&PRN6B} + "Hora  : " AT 100 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        {&PRN4} + {&PRN6A} + "ORDEN    : " + X-ORDEN1 + " HASTA : " + X-ORDEN2 + {&PRN6B} FORMAT "X(50)"  SKIP
        "------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                                        " SKIP              
        " Alm  Ubic   Articulo             Descripcion                         Marca     U.M            Cantidad        Stock    " SKIP
        "------------------------------------------------------------------------------------------------------------------------" SKIP
/***      999  12345678901234567890123456789012345  999999  12345678901234567890123456789012345678901234567890 1234 99,999,999.99  999,999,999.99 ***/
         WITH WIDTH 600 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH Temporal NO-LOCK
          BREAK BY Temporal.Codcia
                BY Temporal.CodAlm
                BY Temporal.Codubi
                BY Temporal.Codmat:
                                 
     {&NEW-PAGE}.
     
     DISPLAY STREAM REPORT WITH FRAME F-CAB.

     IF FIRST-OF ( Temporal.Codalm) THEN DO:
        DISPLAY STREAM REPORT.
         put stream report  "ALMACEN : "   AT 1.
         put stream report  Temporal.Codalm AT 15 skip(2).  

     END.

     
     IF FIRST-OF ( Temporal.Codubi) THEN DO:
       DISPLAY STREAM REPORT.
       put stream report   "Ubicacion : " AT 5.
       put stream report  Temporal.Codubi AT 30 SKIP.                    

     END.
      
      
      
      DISPLAY STREAM REPORT 
        Temporal.CodMat
        Temporal.DesMat
        Temporal.DesMar
        Temporal.Unidad
        Temporal.Canate
        Temporal.Stkact
        WITH FRAME F-Cab.

      IF LAST-OF ( Temporal.Codcia) THEN DO:
       
       PUT STREAM REPORT "  " SKIP(3).
       PUT STREAM REPORT "  ORDENES DE DESPACHO CONSIDERADAS    " AT 5 FORMAT "X(50)" SKIP.
       PUT STREAM REPORT "--------------------------------------" AT 5 FORMAT "X(50)" SKIP.
       FOR EACH T-Detalle BREAK BY T-Detalle.Codcia
                                BY T-Detalle.Codalm
                                BY T-Detalle.Nroped:
        PUT STREAM REPORT T-Detalle.Codalm AT 5 .
        PUT STREAM REPORT T-Detalle.Nroped AT 10.
        PUT STREAM REPORT T-Detalle.Codcli AT 25.
        PUT STREAM REPORT T-Detalle.Nomcli AT 40.
        PUT STREAM REPORT T-Detalle.Estado AT 90.
        PUT STREAM REPORT T-Detalle.Fchped AT 112.
        PUT STREAM REPORT T-Detalle.Hora   AT 125 SKIP.
       END.                          

     END.
  
        
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reporte2 D-Dialog 
PROCEDURE Reporte2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR L-SW AS LOGICAL INIT NO.
 DEFINE VAR X-TITU AS CHAR.
 X-TITU = "REPORTE GLOBAL DE ORDENES DE DESPACHO " .
 DEFINE FRAME f-cab
        Temporal.Codalm  FORMAT "x(3)"
        Temporal.Codubi  FORMAT "x(10)"
        Temporal.CodMat  FORMAT "x(8)"
        Temporal.DesMat  FORMAT "x(45)"   
        Temporal.DesMar  FORMAT "x(10)"   
        Temporal.Unidad  FORMAT "x(8)"   
        Temporal.Canate  FORMAT ">>>>>>>,>>9.99"
        Temporal.StkAct  FORMAT ">>>,>>9.99"
               
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
       /* {&PRN2} + {&PRN6A} + "DIVISION : " + f-punto AT 1 FORMAT "X(20)" F-DIRDIV AT 25 FORMAT "X(30)"  */
        {&PRN4} + {&PRN6B} + "Pagina: " AT 90 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN4} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN4} + {&PRN6B} + "Fecha : " AT 100 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        {&PRN4} + {&PRN6A} + "HORA     : " + X-HORA1 + " HASTA : " + X-HORA2 FORMAT "X(50)" 
        {&PRN4} + {&PRN6B} + "Hora  : " AT 100 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        {&PRN4} + {&PRN6A} + "ORDEN    : " + X-ORDEN1 + " HASTA : " + X-ORDEN2 + {&PRN6B} FORMAT "X(50)"  SKIP
        "------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                                        " SKIP              
        " Alm  Ubic   Articulo             Descripcion                         Marca     U.M            Cantidad        Stock    " SKIP
        "------------------------------------------------------------------------------------------------------------------------" SKIP
/***      999  12345678901234567890123456789012345  999999  12345678901234567890123456789012345678901234567890 1234 99,999,999.99  999,999,999.99 ***/
         WITH WIDTH 600 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH Temporal NO-LOCK
          BREAK BY Temporal.Codcia
                BY Temporal.CodAlm
                BY Temporal.Codmat:
                                 
     {&NEW-PAGE}.
     
     DISPLAY STREAM REPORT WITH FRAME F-CAB.

     IF FIRST-OF ( Temporal.Codalm) THEN DO:
        DISPLAY STREAM REPORT.
         put stream report  "ALMACEN : "   AT 1.
         put stream report  Temporal.Codalm AT 15 skip(2).  

     END.

      
      DISPLAY STREAM REPORT 
        Temporal.Codubi
        Temporal.CodMat
        Temporal.DesMat
        Temporal.DesMar
        Temporal.Unidad
        Temporal.Canate
        Temporal.Stkact
        WITH FRAME F-Cab.
        
      IF LAST-OF ( Temporal.Codcia) THEN DO:
       PUT STREAM REPORT "  " SKIP(3).
       PUT STREAM REPORT "  ORDENES DE DESPACHO CONSIDERADAS    " AT 5 FORMAT "X(50)" SKIP.
       PUT STREAM REPORT "--------------------------------------" AT 5 FORMAT "X(50)" SKIP.
       FOR EACH T-Detalle BREAK BY T-Detalle.Codcia
                                BY T-Detalle.Codalm
                                BY T-Detalle.Nroped:
        PUT STREAM REPORT T-Detalle.Codalm AT 5 .
        PUT STREAM REPORT T-Detalle.Nroped AT 10.
        PUT STREAM REPORT T-Detalle.Codcli AT 25.
        PUT STREAM REPORT T-Detalle.Nomcli AT 40. 
        PUT STREAM REPORT T-Detalle.Estado AT 90.
        PUT STREAM REPORT T-Detalle.Fchped AT 112 .
        PUT STREAM REPORT T-Detalle.Hora   AT 125 SKIP.


       END.                   
      END.       
   
        
        
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reporte3 D-Dialog 
PROCEDURE Reporte3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR L-SW AS LOGICAL INIT NO.
 DEFINE VAR X-TITU AS CHAR.
 X-TITU = "REPORTE GLOBAL DE ORDENES DE DESPACHO " .
 DEFINE FRAME f-cab
        Temporal.Codalm  FORMAT "x(3)"
        Temporal.Codubi  FORMAT "x(10)"
        Temporal.CodMat  FORMAT "x(8)"
        Temporal.DesMat  FORMAT "x(45)"   
        Temporal.DesMar  FORMAT "x(10)"   
        Temporal.Unidad  FORMAT "x(8)"   
        Temporal.Canate  FORMAT ">>>>>>>,>>9.99"
        Temporal.StkAct  FORMAT ">>>,>>9.99"
               
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
       /* {&PRN2} + {&PRN6A} + "DIVISION : " + f-punto AT 1 FORMAT "X(20)" F-DIRDIV AT 25 FORMAT "X(30)"  */
        {&PRN4} + {&PRN6B} + "Pagina: " AT 90 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN4} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN4} + {&PRN6B} + "Fecha : " AT 100 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        {&PRN4} + {&PRN6A} + "HORA     : " + X-HORA1 + " HASTA : " + X-HORA2 FORMAT "X(50)" 
        {&PRN4} + {&PRN6B} + "Hora  : " AT 100 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        {&PRN4} + {&PRN6A} + "ORDEN    : " + X-ORDEN1 + " HASTA : " + X-ORDEN2 + {&PRN6B} FORMAT "X(50)"  SKIP
        "------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                                        " SKIP              
        " Alm  Ubic   Articulo             Descripcion                         Marca     U.M            Cantidad        Stock    " SKIP
        "------------------------------------------------------------------------------------------------------------------------" SKIP
/***      999  12345678901234567890123456789012345  999999  12345678901234567890123456789012345678901234567890 1234 99,999,999.99  999,999,999.99 ***/
         WITH WIDTH 600 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH Temporal NO-LOCK
          BREAK BY Temporal.Codcia
                BY Temporal.CodAlm
                BY Temporal.Desmat:
                                 
     {&NEW-PAGE}.
     
     DISPLAY STREAM REPORT WITH FRAME F-CAB.

     IF FIRST-OF ( Temporal.Codalm) THEN DO:
        DISPLAY STREAM REPORT.
         put stream report  "ALMACEN : "   AT 1.
         put stream report  Temporal.Codalm AT 15 skip(2).  

     END.

      
      DISPLAY STREAM REPORT 
        Temporal.Codubi
        Temporal.CodMat
        Temporal.DesMat
        Temporal.DesMar
        Temporal.Unidad
        Temporal.Canate
        Temporal.Stkact
        WITH FRAME F-Cab.

      IF LAST-OF ( Temporal.Codcia) THEN DO:
       
       PUT STREAM REPORT "  " SKIP(3).
       PUT STREAM REPORT "  ORDENES DE DESPACHO CONSIDERADAS    " AT 5 FORMAT "X(50)" SKIP.
       PUT STREAM REPORT "--------------------------------------" AT 5 FORMAT "X(50)" SKIP.
       FOR EACH T-Detalle BREAK BY T-Detalle.Codcia
                                BY T-Detalle.Codalm
                                BY T-Detalle.Nroped:
        PUT STREAM REPORT T-Detalle.Codalm AT 5 .
        PUT STREAM REPORT T-Detalle.Nroped AT 10.
        PUT STREAM REPORT T-Detalle.Codcli AT 25.
        PUT STREAM REPORT T-Detalle.Nomcli AT 40.
        PUT STREAM REPORT T-Detalle.Estado AT 90.
        PUT STREAM REPORT T-Detalle.Fchped AT 112.
        PUT STREAM REPORT T-Detalle.Hora   AT 125 SKIP.

       END.                   
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


