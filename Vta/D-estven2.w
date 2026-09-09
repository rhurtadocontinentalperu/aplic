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
/* DEFINE VARIABLE cl-codcia AS INTEGER INITIAL 0. */
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
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.
DEFINE SHARED VAR S-CODALM  AS CHAR.
DEFINE VARIABLE F-DIRDIV    AS CHAR.
DEFINE VARIABLE F-PUNTO     AS CHAR.
DEFINE VARIABLE X-PUNTO     AS CHAR.

DEFINE TEMP-TABLE t-vendedor 
       FIELD CODCIA   LIKE CcbcDocu.Codcia
       FIELD CODCLI   LIKE Ccbcdocu.Codcli
       FIELD DESCLI   LIKE Ccbcdocu.Nomcli
/*ML01*/ FIELDS DIRCLI LIKE gn-clie.DirCli
       FIELD TOTVTA    LIKE CcbDdocu.ImpLin
       FIELD TOTIGV    LIKE CcbDdocu.ImpLin
       FIELD TOTAL     LIKE CcbDdocu.ImpLin
       INDEX LLAVE01 CODCLI.

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
&Scoped-Define ENABLED-OBJECTS RADIO-SET-Tipo f-desde f-hasta RADIO-SET-1 ~
B-imprime B-cancela B-impresoras RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE ~
RECT-54 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-Tipo FILL-IN-1 f-desde f-hasta ~
RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

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

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

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

DEFINE VARIABLE RADIO-SET-Tipo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Resumen", 1
     SIZE 12 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-54
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 9.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     RADIO-SET-Tipo AT ROW 2.62 COL 3.72 NO-LABEL
     FILL-IN-1 AT ROW 3.92 COL 3.57 NO-LABEL
     f-desde AT ROW 2.81 COL 21.29 COLON-ALIGNED
     f-hasta AT ROW 2.85 COL 38.29 COLON-ALIGNED
     RADIO-SET-1 AT ROW 5.85 COL 5 NO-LABEL
     B-imprime AT ROW 5.73 COL 28.43
     B-cancela AT ROW 5.73 COL 39.57
     B-impresoras AT ROW 6.96 COL 17.43
     b-archivo AT ROW 7.96 COL 17.57
     RB-OUTPUT-FILE AT ROW 8.08 COL 21.29 COLON-ALIGNED NO-LABEL
     RB-NUMBER-COPIES AT ROW 9.58 COL 11.57 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 9.58 COL 25.57 COLON-ALIGNED
     RB-END-PAGE AT ROW 9.58 COL 40.72 COLON-ALIGNED
     " Configuracion de Impresion" VIEW-AS TEXT
          SIZE 47 BY .62 AT ROW 4.69 COL 3.57
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "Paginas" VIEW-AS TEXT
          SIZE 8.14 BY .58 AT ROW 8.88 COL 34.14
          FONT 6
     "Rango de Fechas :" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 1.77 COL 28
          FONT 6
     RECT-54 AT ROW 1.19 COL 2.43
     SPACE(0.42) SKIP(0.26)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte de Ventas".


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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte de Ventas */
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

/*  ASSIGN f-vendedor f-punto f-marca f-articulo f-desde f-hasta RADIO-SET-Tipo.*/
  ASSIGN  f-desde f-hasta RADIO-SET-Tipo.

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
   f-punto = S-CODDIV.

  DO WITH FRAME {&FRAME-NAME}:
     f-desde = TODAY - DAY(TODAY) + 1.
     f-hasta = TODAY.
     DISPLAY f-desde f-hasta.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tabla-Divi D-Dialog 
PROCEDURE Carga-Tabla-Divi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR F-CODI AS CHAR.
DEFINE VAR F-FACTOR AS INTEGER .
DEFINE VAR F-PORIGV AS INTEGER .
DEFINE VAR F-FMAPGO AS CHAR.
DEFINE VAR X-NOMBRE AS CHAR.
DEFINE VAR X-SIGNO AS INTEGER INIT 1.
DEFINE VAR x-TpoCmbCmp AS DEC.
DEFINE VAR x-TpoCmbVta AS DEC.
/*ML01*/ DEFINE VARIABLE cDirCli AS CHARACTER NO-UNDO.

/*
F-CODI = "001228,001229,001230,001231,001232,001233,001237,001238,001239,001240,001241,001242,
014260,014261,014262,011096,011095,011116,011120,011097,011098,011099,011105,011106,011108,
011109,011093,011094,003430,003431,003432,003433,003434,003441,003442,003438,003439,003440,
003435,003436,003437,007866,001722,001723,001726,001727,010374,010387,010383".
*/

FIND FaccfgGn WHERE FaccfgGn.Codcia = S-CODCIA NO-LOCK NO-ERROR.

 FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR AND
          CcbCdocu.CodCia = S-CODCIA AND
          CcbCdocu.CodDiv = f-punto AND
          CCbCdocu.FchDoc >= f-desde AND 
          CcbCdocu.FchDoc <= f-hasta AND
          ( CcbCdocu.CodDoc = "FAC" OR CcbCdocu.CodDoc = "BOL" OR CcbCdocu.CodDoc = "N/C" ) AND
          CcbCDocu.FlgEst <> "A"   
          USE-INDEX LLAVE10 :
           
        FIND T-VENDEDOR WHERE 
             t-vendedor.codcli = CcbCDocu.CodCli NO-ERROR .
        IF NOT AVAILABLE T-VENDEDOR then do:
           x-nombre = Ccbcdocu.Nomcli.
           FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
               AND  gn-clie.CodCli = Ccbcdocu.Codcli
               NO-LOCK NO-ERROR.
/*ML01* ***
           IF AVAILABLE gn-clie THEN x-nombre = gn-clie.Nomcli.
*ML01* ***/
/*ML01*/    IF AVAILABLE gn-clie THEN ASSIGN cDirCli = gn-clie.DirCli x-nombre = gn-clie.Nomcli.
/*ML01*/    ELSE ASSIGN cDirCli = "" x-nombre = "".

           CREATE T-VENDEDOR.
               ASSIGN 
               T-VENDEDOR.CODCLI   = CcbCdocu.Codcli
/*ML01*/       T-VENDEDOR.DIRCLI   = cDirCli
               T-VENDEDOR.DESCLI   = X-NOMBRE. 
        END.        
        X-SIGNO = IF Ccbcdocu.Coddoc = "N/C" THEN -1 ELSE 1.
        ASSIGN
            x-TpoCmbCmp = CcbCDocu.TpoCmb
            x-TpoCmbVta = CcbCDocu.TpoCmb.
        FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF NOT AVAIL Gn-Tcmb 
        THEN FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
                    USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF AVAIL Gn-Tcmb 
        THEN ASSIGN
                x-TpoCmbCmp = Gn-Tcmb.Compra
                x-TpoCmbVta = Gn-Tcmb.Venta.
/*        T-VENDEDOR.TOTVTA = T-VENDEDOR.TOTVTA + X-SIGNO * Ccbcdocu.Impvta / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
 *         T-VENDEDOR.TOTIGV = T-VENDEDOR.TOTIGV + X-SIGNO * Ccbcdocu.ImpIgv / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
 *         T-VENDEDOR.TOTAL  = T-VENDEDOR.TOTAL  + X-SIGNO * Ccbcdocu.ImpTot / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).*/
        IF CcbCDocu.CodMon = 2
        THEN ASSIGN
                T-VENDEDOR.TOTVTA = T-VENDEDOR.TOTVTA + X-SIGNO * Ccbcdocu.Impvta 
                T-VENDEDOR.TOTIGV = T-VENDEDOR.TOTIGV + X-SIGNO * Ccbcdocu.ImpIgv
                T-VENDEDOR.TOTAL  = T-VENDEDOR.TOTAL  + X-SIGNO * Ccbcdocu.ImpTot.
        IF CcbCDocu.CodMon = 1
        THEN ASSIGN
                T-VENDEDOR.TOTVTA = T-VENDEDOR.TOTVTA + X-SIGNO * Ccbcdocu.Impvta / x-TpoCmbCmp
                T-VENDEDOR.TOTIGV = T-VENDEDOR.TOTIGV + X-SIGNO * Ccbcdocu.ImpIgv / x-TpoCmbCmp
                T-VENDEDOR.TOTAL  = T-VENDEDOR.TOTAL  + X-SIGNO * Ccbcdocu.ImpTot / x-TpoCmbCmp.
        PROCESS EVENTS.
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
  DISPLAY RADIO-SET-Tipo FILL-IN-1 f-desde f-hasta RADIO-SET-1 RB-NUMBER-COPIES 
          RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE RADIO-SET-Tipo f-desde f-hasta RADIO-SET-1 B-imprime B-cancela 
         B-impresoras RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE RECT-54 
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

    FIND FIRST gn-divi where GN-DIVI.CodCia = S-CODCIA AND
                             GN-DIVI.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi then F-DIRDIV = GN-DIVI.DesDiv.
    DEFINE VAR F-Codigos AS CHAR EXTENT 49.
    Define VAR x AS INTEGER INIT 0.
    
    
       FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA AND
                      GN-DIVI.CodDiv = S-CODDIV
                      NO-LOCK NO-ERROR.
       X-PUNTO = GN-DIVI.Desdiv.
       RUN CARGA-TABLA-DIVI.
                        
    
    CASE RADIO-SET-Tipo:
         WHEN 1 THEN RUN Resumen-Vendedor.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen-Vendedor D-Dialog 
PROCEDURE Resumen-Vendedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-TITU AS CHAR.
X-TITU = "RESUMEN DE VENTAS - " + X-PUNTO.
 DEFINE FRAME f-cab
        T-VENDEDOR.CodCli FORMAT "x(11)"    
        T-VENDEDOR.Descli FORMAT "x(35)"
        T-VENDEDOR.TOTVTA FORMAT "->>>,>>>,>>>.99"
        T-VENDEDOR.TOTIGV FORMAT "->>>,>>>,>>>.99"
        T-VENDEDOR.TOTAL  FORMAT "->>>,>>>,>>>.99"
/*ML01*/ T-VENDEDOR.DIRCLI
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU  + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
        {&PRN3} + {&PRN6B} + "Pagina: " AT 100 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN3} + {&PRN6B} + "Fecha : " AT 80 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN2} + {&PRN6A} + "MONEDA   : DOLARES AMERICANOS" At 1 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 80 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
/*ML01* ***
        "------------------------------------------------------------------------------------------------" SKIP
        " Codigo.        RAZON    SOCIAL                    VALOR VENTA       VALOR IGV     VALOR TOTAL                                             " SKIP
        "------------------------------------------------------------------------------------------------" SKIP
*ML01* ***/
/*ML01* Inicio de Bloque */
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " Codigo.        RAZON    SOCIAL                    VALOR VENTA       VALOR IGV     VALOR TOTAL   DIRECCION                                          " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*ML01* Fin de Bloque */
/***     99999999999 12345678901234567890123456789012345 -999,999,999.99 -999,999,999.99 -999,999,999.99***/
  
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH t-vendedor NO-LOCK
          BREAK BY T-VENDEDOR.CODCIA BY T-VENDEDOR.TOTAl DESCENDING :
                                 
        ACCUMULATE T-VENDEDOR.TOTVTA ( TOTAL BY T-VENDEDOR.CODCIA ).
        ACCUMULATE T-VENDEDOR.TOTIGV ( TOTAL BY T-VENDEDOR.CODCIA ).
        ACCUMULATE T-VENDEDOR.TOTAL  ( TOTAL BY T-VENDEDOR.CODCIA ).

        {&NEW-PAGE}.
         DISPLAY STREAM REPORT 
                   T-VENDEDOR.codcli 
                   T-VENDEDOR.descli
/*ML01*/           T-VENDEDOR.DIRCLI
                   T-VENDEDOR.Totvta
                   T-VENDEDOR.Totigv
                   T-VENDEDOR.Total 
                   WITH FRAME F-Cab.
        DOWN STREAM REPORT WITH FRAME F-CAB.        
        IF LAST-OF (T-VENDEDOR.CODCIA) THEN DO:
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
           UNDERLINE STREAM REPORT T-VENDEDOR.TOTVTA
                                   T-VENDEDOR.TOTIGV
                                   T-VENDEDOR.TOTAL   WITH FRAME F-CAB. 
           DISPLAY STREAM REPORT
              "T  O  T  A  L  :  " @ T-VENDEDOR.Descli
              ACCUM TOTAL BY T-VENDEDOR.CODCIA T-VENDEDOR.TOTVTA @ T-VENDEDOR.TOTVTA 
              ACCUM TOTAL BY T-VENDEDOR.CODCIA T-VENDEDOR.TOTIGV @ T-VENDEDOR.TOTIGV 
              ACCUM TOTAL BY T-VENDEDOR.CODCIA T-VENDEDOR.TOTAL  @ T-VENDEDOR.TOTAL  
           WITH FRAME F-CAB.
        END.
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

