&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

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

def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE T-TITULO AS CHAR INIT "".
DEFINE VARIABLE T-TITUL1 AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

&SCOPED-DEFINE CONDICX ( TRUE ) 
&SCOPED-DEFINE CONDICY ( gn-clie.CodDept = "15" )   
&SCOPED-DEFINE CONDICION ( gn-clie.CodDept <> "15" )


/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS F-GIRO RECT-48 RECT-5 RECT-53 F-DEPTO ~
F-DISTRITO F-PROVI f-filtro r-sortea RADIO-SET-1 B-imprime B-cancela ~
BUTTON-3 B-impresoras RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS D-DEPTO F-GIRO D-DISTR D-GIRO D-PROVI ~
F-DEPTO F-DISTRITO F-PROVI f-filtro r-sortea FILL-IN-3 RADIO-SET-1 ~
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

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "Button 3" 
     SIZE 13 BY 1.5.

DEFINE VARIABLE f-filtro AS CHARACTER FORMAT "X(256)":U INITIAL "General" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "General","Lima","Provincia" 
     SIZE 16 BY 1
     FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE D-DEPTO AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE D-DISTR AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE D-GIRO AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 16.86 BY .81 NO-UNDO.

DEFINE VARIABLE D-PROVI AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE F-DEPTO AS CHARACTER FORMAT "X(3)":U 
     LABEL "Departamento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE F-DISTRITO AS CHARACTER FORMAT "X(3)":U 
     LABEL "Distrito" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE F-GIRO AS CHARACTER FORMAT "X(3)":U 
     LABEL "Giro" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE F-PROVI AS CHARACTER FORMAT "X(3)":U 
     LABEL "Provincia" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .69
     FONT 6 NO-UNDO.

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
     SIZE 27.72 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 12 NO-UNDO.

DEFINE VARIABLE r-sortea AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Codigo", 1,
"Nombre", 2
     SIZE 24.43 BY .77
     FONT 6 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3.69
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 67.86 BY 4.65.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL 
     SIZE 50.72 BY 5.85.

DEFINE RECTANGLE RECT-53
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 16.29 BY 6.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     D-DEPTO AT ROW 2.77 COL 16 COLON-ALIGNED NO-LABEL
     F-GIRO AT ROW 2.77 COL 42 COLON-ALIGNED
     D-DISTR AT ROW 4.38 COL 16 COLON-ALIGNED NO-LABEL
     D-GIRO AT ROW 2.77 COL 48.43 COLON-ALIGNED NO-LABEL
     D-PROVI AT ROW 3.58 COL 16 COLON-ALIGNED NO-LABEL
     F-DEPTO AT ROW 2.73 COL 2.29
     F-DISTRITO AT ROW 4.35 COL 10.72 COLON-ALIGNED
     F-PROVI AT ROW 3.54 COL 10.72 COLON-ALIGNED
     f-filtro AT ROW 4.08 COL 48.72 COLON-ALIGNED NO-LABEL
     r-sortea AT ROW 1.5 COL 32.14 NO-LABEL
     FILL-IN-3 AT ROW 1.54 COL 2.43
     RADIO-SET-1 AT ROW 7.08 COL 3.14 NO-LABEL
     B-imprime AT ROW 6.5 COL 54.43
     B-cancela AT ROW 8.5 COL 54.57
     BUTTON-3 AT ROW 10.46 COL 54.43
     B-impresoras AT ROW 8.38 COL 16.29
     b-archivo AT ROW 9.62 COL 16.43
     RB-OUTPUT-FILE AT ROW 9.81 COL 20.29 COLON-ALIGNED NO-LABEL
     RB-NUMBER-COPIES AT ROW 11.31 COL 12.86 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 11.31 COL 26.43 COLON-ALIGNED
     RB-END-PAGE AT ROW 11.31 COL 39.72 COLON-ALIGNED
     RECT-48 AT ROW 1.12 COL 1.14
     RECT-5 AT ROW 6.65 COL 1.57
     RECT-53 AT ROW 6 COL 52.86
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 50.72 BY .62 AT ROW 6 COL 1.57
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "Páginas" VIEW-AS TEXT
          SIZE 8.14 BY .58 AT ROW 10.65 COL 35.14
          FONT 6
     "Ordenado x" VIEW-AS TEXT
          SIZE 10 BY .69 AT ROW 1.62 COL 21.57
          FONT 6
     "Tipo :" VIEW-AS TEXT
          SIZE 4.43 BY .65 AT ROW 4.23 COL 44.72
     SPACE(20.70) SKIP(7.80)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Catalogos de Clientes".

 

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

/* SETTINGS FOR FILL-IN D-DEPTO IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN D-DISTR IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN D-GIRO IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN D-PROVI IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DEPTO IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Catalogos de Clientes */
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
  ASSIGN r-sortea f-filtro f-depto f-distrito f-provi f-giro.
 
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


&Scoped-define SELF-NAME F-DEPTO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DEPTO D-Dialog
ON LEAVE OF F-DEPTO IN FRAME D-Dialog /* Departamento */
DO:
    IF F-DEPTO:screen-value <> "" THEN DO:
    FIND  TabDepto WHERE TabDepto.CodDepto = F-DEPTO:screen-value NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto THEN
       D-DEPTO:screen-value = TabDepto.NomDepto.
    ELSE 
       D-DEPTO:screen-value = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DISTRITO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DISTRITO D-Dialog
ON LEAVE OF F-DISTRITO IN FRAME D-Dialog /* Distrito */
DO:
  IF F-DISTRITO:screen-value <> "" THEN DO:
  FIND Tabdistr WHERE Tabdistr.CodDepto = F-DEPTO:screen-value AND
                      Tabdistr.Codprovi = F-PROVI:screen-value AND
                      Tabdistr.Coddistr = F-DISTRITO:screen-value NO-LOCK NO-ERROR.
    IF AVAILABLE Tabdistr THEN 
        D-DISTR:screen-value = Tabdistr.Nomdistr .
    ELSE
        D-DISTR:screen-value = "".
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-GIRO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-GIRO D-Dialog
ON LEAVE OF F-GIRO IN FRAME D-Dialog /* Giro */
DO:
    IF F-GIRO:screen-value <> "" THEN DO:
     FIND almtabla WHERE almtabla.Tabla = 'GN' AND almtabla.Codigo = F-GIRO:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE almtabla THEN 
        D-Giro:screen-value = almtabla.nombre.
     ELSE 
        D-Giro:screen-value = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PROVI
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PROVI D-Dialog
ON LEAVE OF F-PROVI IN FRAME D-Dialog /* Provincia */
DO:
    IF F-PROVI:screen-value <> "" THEN DO:
    FIND  Tabprovi WHERE Tabprovi.CodDepto = F-DEPTO:screen-value AND
    Tabprovi.Codprovi = F-PROVI:screen-value NO-LOCK NO-ERROR.
    IF AVAILABLE Tabprovi THEN 
        D-PROVI:screen-value = Tabprovi.Nomprovi.
    ELSE
        D-PROVI:screen-value = "".
   
   END.
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
       FILL-IN-3 = S-CODDIV.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Catge1 D-Dialog 
PROCEDURE Catge1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR D-Distrito AS CHAR.
 DEFINE FRAME f-cab 
        gn-clie.ruc        AT 1   FORMAT "X(8)"
        gn-clie.nomcli     AT 10  FORMAT "X(40)"
        gn-clie.Dircli     AT 52  FORMAT "X(30)"
        D-Distrito         AT 84  FORMAT "X(15)"
        gn-clie.Telfnos[1] AT 100 FORMAT "X(13)"
        gn-clie.faxcli     AT 114 FORMAT "X(10)"
        gn-clie.E-mail     AT 125 FORMAT "X(20)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 107 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + " )" + {&PRN6B} + {&PRN3} AT 3 FORMAT "X(20)"  
        {&PRN2} + {&PRN6A} + T-TITULO + {&PRN6B} + {&PRN3} AT 54 FORMAT "X(45)" 
        {&PRN3} + "Fecha : " AT 121 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" SKIP
        "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "  R.U.C.             C L I E N T E                 DIRECCION                       DISTRITO        TELEFONO      F A X       E - M A I L      " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.


 FOR EACH gn-clie NO-LOCK WHERE gn-clie.coddiv = S-CODDIV 
                  AND {&CONDICX} 
          BY gn-clie.nomcli:

     {&NEW-PAGE}.           

     FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept
                         AND Tabdistr.Codprovi =gn-clie.codprov
                         AND Tabdistr.Coddistr = gn-clie.coddist NO-LOCK NO-ERROR.
     IF AVAILABLE Tabdistr THEN 
        D-Distrito = Tabdistr.Nomdistr .
     ELSE
        D-Distrito = "".     
     
     DISPLAY STREAM REPORT 
        gn-clie.ruc
        gn-clie.nomcli
        gn-clie.Dircli
        gn-clie.Telfnos[1]
        gn-clie.faxcli
        gn-clie.E-mail
        D-Distrito
        WITH FRAME F-Cab.
        
 END.
 OUTPUT STREAM REPORT CLOSE.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CatGen D-Dialog 
PROCEDURE CatGen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR D-Distrito AS CHAR.
 DEFINE FRAME f-cab
        gn-clie.ruc        AT 1   FORMAT "X(8)"
        gn-clie.nomcli     AT 10  FORMAT "X(40)"
        gn-clie.Dircli     AT 52  FORMAT "X(30)"
        D-Distrito         AT 84  FORMAT "X(15)"
        gn-clie.Telfnos[1] AT 100 FORMAT "X(13)"
        gn-clie.faxcli     AT 114 FORMAT "X(10)"
        gn-clie.E-mail     AT 125 FORMAT "X(20)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 107 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + " )" + {&PRN6B} + {&PRN3} AT 3 FORMAT "X(20)"
        {&PRN2} + {&PRN6A} + T-TITULO + {&PRN6B} + {&PRN3} AT 54 FORMAT "X(45)"
        {&PRN3} + "Fecha : " AT 121 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" SKIP
        "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "  R.U.C.             C L I E N T E                 DIRECCION                       DISTRITO        TELEFONO      F A X       E - M A I L      " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

 
 FOR EACH gn-clie NO-LOCK WHERE gn-clie.coddiv = S-CODDIV 
                  AND gn-clie.GirCli  BEGINS F-GIRO
                  AND gn-clie.CodDept BEGINS F-DEPTO 
                  AND gn-clie.CodProv BEGINS F-PROVI
                  AND gn-clie.CodDist BEGINS F-DISTRITO
          BY gn-clie.ruc:

     {&NEW-PAGE}.           

     FIND Tabdistr WHERE Tabdistr.CodDepto     = gn-clie.CodDept
                         AND Tabdistr.Codprovi = gn-clie.codprov
                         AND Tabdistr.Coddistr = gn-clie.coddist NO-LOCK NO-ERROR.
     IF AVAILABLE Tabdistr THEN 
        D-Distrito = Tabdistr.Nomdistr .
     ELSE
        D-Distrito = "".     
     
     DISPLAY STREAM REPORT 
        gn-clie.ruc
        gn-clie.nomcli
        gn-clie.Dircli
        gn-clie.Telfnos[1]
        gn-clie.faxcli
        gn-clie.E-mail
        D-Distrito
        WITH FRAME F-Cab.
        
 END.
 OUTPUT STREAM REPORT CLOSE.

END PROCEDURE.



/*
DO:
  IF gn-clie.coddept:screen-value <> "" THEN DO:
    FIND  TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept:screen-value NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto THEN
        Fill-in-dep:screen-value = TabDepto.NomDepto.
    ELSE 
        Fill-in-dep:screen-value = "".
  END.
END.

  IF gn-clie.coddist:screen-value <> "" THEN DO:
  FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept:screen-value AND
                       Tabdistr.Codprovi = gn-clie.codprov:screen-value AND
                       Tabdistr.Coddistr = gn-clie.coddist:screen-value NO-LOCK NO-ERROR.
    IF AVAILABLE Tabdistr THEN 
        Fill-in-dis:screen-value = Tabdistr.Nomdistr .
    ELSE
        Fill-in-dis:screen-value = "".
  END.  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CatLi1 D-Dialog 
PROCEDURE CatLi1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR D-Distrito AS CHAR.
 DEFINE FRAME f-cab 
        gn-clie.ruc        AT 1   FORMAT "X(8)"
        gn-clie.nomcli     AT 10  FORMAT "X(40)"
        gn-clie.Dircli     AT 52  FORMAT "X(30)"
        D-Distrito         AT 84  FORMAT "X(15)"
        gn-clie.Telfnos[1] AT 100 FORMAT "X(13)"
        gn-clie.faxcli     AT 114 FORMAT "X(10)"
        gn-clie.E-mail     AT 125 FORMAT "X(20)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 107 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + " )" + {&PRN6B} + {&PRN3} AT 3 FORMAT "X(20)"  
        {&PRN2} + {&PRN6A} + T-TITULO + {&PRN6B} + {&PRN3} AT 54 FORMAT "X(45)" 
        {&PRN3} + "Fecha : " AT 121 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" SKIP
        "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "  R.U.C.             C L I E N T E                 DIRECCION                       DISTRITO        TELEFONO      F A X       E - M A I L      " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.


 FOR EACH gn-clie NO-LOCK WHERE gn-clie.coddiv = S-CODDIV 
                  AND {&CONDICY} 
          BY gn-clie.nomcli:

     {&NEW-PAGE}.           

     FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept 
                         AND Tabdistr.Codprovi = gn-clie.codprov
                         AND Tabdistr.Coddistr = gn-clie.coddist NO-LOCK NO-ERROR.
     IF AVAILABLE Tabdistr THEN 
        D-Distrito = Tabdistr.Nomdistr.
     ELSE
        D-Distrito = "".     
     
     DISPLAY STREAM REPORT 
        gn-clie.ruc
        gn-clie.nomcli
        gn-clie.Dircli
        gn-clie.Telfnos[1]
        gn-clie.faxcli
        gn-clie.E-mail
        D-Distrito
        WITH FRAME F-Cab.
        
 END.
 OUTPUT STREAM REPORT CLOSE.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CatLim D-Dialog 
PROCEDURE CatLim :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR D-Distrito AS CHAR.
 DEFINE FRAME f-cab 
        gn-clie.ruc        AT 1   FORMAT "X(8)"
        gn-clie.nomcli     AT 10  FORMAT "X(40)"
        gn-clie.Dircli     AT 52  FORMAT "X(30)"
        D-Distrito         AT 84  FORMAT "X(15)"
        gn-clie.Telfnos[1] AT 100 FORMAT "X(13)"
        gn-clie.faxcli     AT 114 FORMAT "X(10)"
        gn-clie.E-mail     AT 125 FORMAT "X(20)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 107 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + " )" + {&PRN6B} + {&PRN3} AT 3 FORMAT "X(20)"  
        {&PRN2} + {&PRN6A} + T-TITULO + {&PRN6B} + {&PRN3} AT 54 FORMAT "X(45)" 
        {&PRN3} + "Fecha : " AT 121 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" SKIP
        "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "  R.U.C.             C L I E N T E                 DIRECCION                       DISTRITO        TELEFONO      F A X       E - M A I L      " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.


 FOR EACH gn-clie NO-LOCK WHERE gn-clie.coddiv = S-CODDIV 
                  AND {&CONDICY} 
          BY gn-clie.ruc:

     {&NEW-PAGE}.           

     FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept 
                         AND Tabdistr.Codprovi = gn-clie.codprov
                         AND Tabdistr.Coddistr = gn-clie.coddist NO-LOCK NO-ERROR.
     IF AVAILABLE Tabdistr THEN 
        D-Distrito = Tabdistr.Nomdistr.
     ELSE
        D-Distrito = "".     
     
     DISPLAY STREAM REPORT 
        gn-clie.ruc
        gn-clie.nomcli
        gn-clie.Dircli
        gn-clie.Telfnos[1]
        gn-clie.faxcli
        gn-clie.E-mail
        D-Distrito
        WITH FRAME F-Cab.
        
 END.
 OUTPUT STREAM REPORT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CatPr1 D-Dialog 
PROCEDURE CatPr1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR D-Distrito AS CHAR.
 DEFINE FRAME f-cab 
        gn-clie.ruc        AT 1   FORMAT "X(8)"
        gn-clie.nomcli     AT 10  FORMAT "X(40)"
        gn-clie.Dircli     AT 52  FORMAT "X(30)"
        D-Distrito         AT 84  FORMAT "X(15)"
        gn-clie.Telfnos[1] AT 100 FORMAT "X(13)"
        gn-clie.faxcli     AT 114 FORMAT "X(10)"
        gn-clie.E-mail     AT 125 FORMAT "X(20)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 107 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + " )" + {&PRN6B} + {&PRN3} AT 3 FORMAT "X(20)"  
        {&PRN2} + {&PRN6A} + T-TITULO + {&PRN6B} + {&PRN3} AT 54 FORMAT "X(45)" 
        {&PRN3} + "Fecha : " AT 121 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" SKIP
        "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "  R.U.C.             C L I E N T E                 DIRECCION                       DISTRITO        TELEFONO      F A X       E - M A I L      " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.


 FOR EACH gn-clie NO-LOCK WHERE gn-clie.coddiv = S-CODDIV 
                  AND {&CONDICION} 
                  
          BY gn-clie.nomcli:

     {&NEW-PAGE}.           

     FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept 
                         AND Tabdistr.Codprovi = gn-clie.codprov
                         AND Tabdistr.Coddistr = gn-clie.coddist NO-LOCK NO-ERROR.
     IF AVAILABLE Tabdistr THEN 
        D-Distrito = Tabdistr.Nomdistr .
     ELSE
        D-Distrito = "".     
     
     DISPLAY STREAM REPORT 
        gn-clie.ruc
        gn-clie.nomcli
        gn-clie.Dircli
        gn-clie.Telfnos[1]
        gn-clie.faxcli
        gn-clie.E-mail
        D-Distrito
        WITH FRAME F-Cab.
        
 END.
 OUTPUT STREAM REPORT CLOSE.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CatPrv D-Dialog 
PROCEDURE CatPrv :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR D-Distrito AS CHAR.
 DEFINE FRAME f-cab 
        gn-clie.ruc        AT 1   FORMAT "X(8)"
        gn-clie.nomcli     AT 10  FORMAT "X(40)"
        gn-clie.Dircli     AT 52  FORMAT "X(30)"
        D-Distrito         AT 84  FORMAT "X(15)"
        gn-clie.Telfnos[1] AT 100 FORMAT "X(13)"
        gn-clie.faxcli     AT 114 FORMAT "X(10)"
        gn-clie.E-mail     AT 125 FORMAT "X(20)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 107 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + " )" + {&PRN6B} + {&PRN3} AT 3 FORMAT "X(20)"  
        {&PRN2} + {&PRN6A} + T-TITULO + {&PRN6B} + {&PRN3} AT 54 FORMAT "X(45)" 
        {&PRN3} + "Fecha : " AT 121 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" SKIP
        "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "  R.U.C.             C L I E N T E                 DIRECCION                       DISTRITO        TELEFONO      F A X       E - M A I L      " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

 FOR EACH gn-clie NO-LOCK WHERE gn-clie.coddiv = S-CODDIV 
                  AND {&CONDICION} 
                  
          BY gn-clie.ruc :

     {&NEW-PAGE}.           

     FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept 
                         AND Tabdistr.Codprovi = gn-clie.codprov
                         AND Tabdistr.Coddistr = gn-clie.coddist NO-LOCK NO-ERROR.
     IF AVAILABLE Tabdistr THEN 
        D-Distrito = Tabdistr.Nomdistr .
     ELSE
        D-Distrito = "".     
     
     DISPLAY STREAM REPORT 
        gn-clie.ruc
        gn-clie.nomcli
        gn-clie.Dircli
        gn-clie.Telfnos[1]
        gn-clie.faxcli
        gn-clie.E-mail
        D-Distrito
        WITH FRAME F-Cab.
        
 END.
 OUTPUT STREAM REPORT CLOSE.

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
  DISPLAY D-DEPTO F-GIRO D-DISTR D-GIRO D-PROVI F-DEPTO F-DISTRITO F-PROVI 
          f-filtro r-sortea FILL-IN-3 RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE 
          RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE F-GIRO RECT-48 RECT-5 RECT-53 F-DEPTO F-DISTRITO F-PROVI f-filtro 
         r-sortea RADIO-SET-1 B-imprime B-cancela BUTTON-3 B-impresoras 
         RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
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

    CASE R-SORTEA :

         WHEN 1 THEN DO:    
                RUN CatGen.

/***          IF F-FILTRO = "General" THEN DO:            
                 T-TITULO = "  CATALOGO GENERAL DE CLIENTES   ".

              END.  
              IF F-FILTRO = "Lima" THEN DO:            
                 T-TITULO = "  CATALOGO DE CLIENTES DE LIMA   ".
                 RUN CatLim. 
              END.                    
              IF F-FILTRO = "Provincia" THEN DO:            
                 T-TITULO = "CATALOGO DE CLIENTES DE PROVINCIA".
                 RUN CatPrv.
              END. ****/
         END.  
         
         WHEN 2 THEN DO:    
              RUN CatGe1.                 
/****         IF F-FILTRO = "General" THEN DO:                       
                 T-TITULO = "  CATALOGO GENERAL DE CLIENTES   ".
                 RUN CatGe1.                 
              END.  
              IF F-FILTRO = "Lima" THEN DO:            
                 T-TITULO = "  CATALOGO DE CLIENTES DE LIMA   ".
                 RUN CatLi1. 
              END.                    
              IF F-FILTRO = "Provincia" THEN DO:            
                 T-TITULO = "CATALOGO DE CLIENTES DE PROVINCIA".
                 RUN CatPr1.
              END.  ***/
         END.         
    END CASE.     
     
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
PROCEDURE recoge-parametros :
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
    DO with frame {&FRAME-NAME} :        
    CASE HANDLE-CAMPO:name:
         WHEN "F-GIRO"  THEN ASSIGN input-var-1 = "GN".
         WHEN "F-PROVI" THEN ASSIGN input-var-1 = F-DEPTO:screen-value.
         WHEN "F-DISTRITO" THEN DO:
               input-var-1 = F-DEPTO:screen-value.
               input-var-2 = F-PROVI:screen-value.
          END.


    END CASE.
    END.

END PROCEDURE.



/****

    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

     CASE HANDLE-CAMPO:name:
     END CASE.
    END.
****/

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


