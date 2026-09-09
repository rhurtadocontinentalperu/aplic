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
DEFINE STREAM REPORT.

/*DEFINE VARIABLE x-Raya     AS CHARACTER FORMAT "X(145)".
DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id  LIKE _user._userid.*/

DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
/*DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.*/
  
def var l-immediate-display  AS LOGICAL.
DEFINE SHARED VARIABLE cb-codcia AS INTEGER.
DEFINE SHARED VARIABLE pv-codcia AS INTEGER.
DEFINE SHARED VARIABLE cl-codcia AS INTEGER.
DEFINE        VARIABLE PTO        AS LOGICAL.
DEFINE        VARIABLE L-FIN      AS LOGICAL.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHAR.

/*** DEFINE VARIABLES SUB-TOTALES ***/

DEFINE VAR C-DESMOV      AS CHAR NO-UNDO.
DEFINE VAR C-OP          AS CHAR NO-UNDO.
DEFINE VAR X-PROCEDENCIA AS CHAR NO-UNDO.
DEFINE VAR x-codmov      AS CHAR NO-UNDO.
DEFINE VAR X-CODPRO      AS CHAR NO-UNDO.

DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
DEFINE VAR x-titulo2 AS CHAR NO-UNDO.

/*DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.*/
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.


DEFINE TEMP-TABLE T-MOVI 
   FIELD codcia LIKE Almtmovm.CodCia 
   FIELD codpro LIKE Almcmov.codpro
   FIELD nompro LIKE gn-prov.NomPro FORMAT 'X(20)'
   FIELD Kilos  AS DECIMAL FORMAT '>,>>>,>>9.999' EXTENT 10 
   FIELD Valtot AS DECIMAL FORMAT '>,>>>,>>9.99' EXTENT 10 .

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
&Scoped-Define ENABLED-OBJECTS R-Codmon RADIO-SET-1 B-impresoras desdeF ~
hastaF Btn_OK RB-NUMBER-COPIES Btn_Cancel RB-BEGIN-PAGE Btn_Help ~
RB-END-PAGE RECT-49 RECT-5 
&Scoped-Define DISPLAYED-OBJECTS R-Codmon RADIO-SET-1 desdeF hastaF ~
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
     SIZE 5 BY 1.12.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.08.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "A&yuda" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE desdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE hastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

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

DEFINE VARIABLE R-Codmon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 18.29 BY .77 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 2.73
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 62.57 BY 2.5.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.14 BY 5.77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     R-Codmon AT ROW 2.46 COL 24.72 NO-LABEL
     RADIO-SET-1 AT ROW 4.85 COL 3 NO-LABEL
     B-impresoras AT ROW 5.62 COL 16.14
     b-archivo AT ROW 6.73 COL 16.14
     desdeF AT ROW 1.46 COL 27.86 COLON-ALIGNED
     hastaF AT ROW 1.42 COL 44.57 COLON-ALIGNED
     RB-OUTPUT-FILE AT ROW 6.58 COL 20 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 4.04 COL 50.86
     RB-NUMBER-COPIES AT ROW 8.19 COL 10.72 COLON-ALIGNED
     Btn_Cancel AT ROW 5.88 COL 51
     RB-BEGIN-PAGE AT ROW 8.19 COL 25.43 COLON-ALIGNED
     Btn_Help AT ROW 7.69 COL 51
     RB-END-PAGE AT ROW 8.19 COL 39.57 COLON-ALIGNED
     "Rango de Fechas :" VIEW-AS TEXT
          SIZE 17.14 BY .54 AT ROW 1.58 COL 5.43
          FONT 6
     " Configuracion de Impresion" VIEW-AS TEXT
          SIZE 47.86 BY .62 AT ROW 3.92 COL 1.72
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "Paginas" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 7.46 COL 33.72
          FONT 6
     "Moneda :" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.58 COL 13
          FONT 6
     RECT-49 AT ROW 1.04 COL 1
     RECT-5 AT ROW 3.69 COL 1.14
     SPACE(13.57) SKIP(0.07)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Resumen de Documentos".


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
{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Resumen de Documentos */
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


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancelar */
DO:
  L-FIN = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help D-Dialog
ON CHOOSE OF Btn_Help IN FRAME D-Dialog /* Ayuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN DesdeF HastaF R-Codmon.

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

ASSIGN DESDEF   = TODAY
       HASTAF   = TODAY
       FRAME {&FRAME-NAME}:TITLE  = "[ Estadisticas de Compras ]".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos D-Dialog 
PROCEDURE Carga-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-tipmov AS CHAR    INITIAL 'I' NO-UNDO.
  DEFINE VAR x-codmov AS INTEGER INITIAL 02 NO-UNDO.
  DEFINE VAR x-codfam AS INTEGER NO-UNDO.
    
  FOR EACH Almdmov NO-LOCK WHERE 
           Almdmov.CodCia = S-CODCIA AND
           Almdmov.CodAlm = S-CODALM AND
           Almdmov.TipMov = x-TipMov AND
           Almdmov.CodMov = x-CodMov AND 
           Almdmov.FchDoc >= DesdeF  AND
           Almdmov.FchDoc <= HastaF  ,
           EACH Almmmatg WHERE Almmmatg.codcia = Almdmov.codcia AND
                Almmmatg.codmat = Almdmov.codmat NO-LOCK: 

           DISPLAY Almdmov.Tipmov + STRING(Almdmov.codmov, '99') + '-' + STRING(Almdmov.nrodoc, '999999') @ Fi-Mensaje LABEL "    Movimiento "
                   FORMAT "X(11)" WITH FRAME F-Proceso.
           FIND Almcmov OF Almdmov NO-LOCK NO-ERROR.   
           FIND T-MOVI WHERE T-MOVI.codcia = s-codcia AND
                T-MOVI.codpro = Almcmov.codpro NO-ERROR.
           IF NOT AVAILABLE T-MOVI THEN DO:
              CREATE T-MOVI.
              ASSIGN
                 T-MOVI.codcia = s-codcia
                 T-MOVI.codpro = Almcmov.codpro.
              FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND
                   gn-prov.CodPro = Almcmov.codpro NO-LOCK NO-ERROR.
              IF AVAILABLE gn-prov THEN
                 ASSIGN T-MOVI.nompro = gn-prov.NomPro.
           END.
           
           x-codfam = INTEGER(Almmmatg.codfam).
           x-codfam = IF x-codfam = 0 OR x-codfam > 5 THEN 6 ELSE x-codfam.
           
           CASE Almdmov.CodUnd:
                  WHEN 'KGS' THEN 
                     ASSIGN 
                        T-MOVI.Kilos[x-codfam]  = T-MOVI.Kilos[x-codfam]  + (Almdmov.candes * Almdmov.factor)
                        T-MOVI.Kilos[7]         = T-MOVI.Kilos[7]         + (Almdmov.candes * Almdmov.factor).
                  WHEN 'TNS' THEN 
                     ASSIGN 
                        T-MOVI.Kilos[x-codfam]  = T-MOVI.Kilos[x-codfam]  + (Almdmov.candes * Almdmov.factor / 1000)
                        T-MOVI.Kilos[7]         = T-MOVI.Kilos[7]         + (Almdmov.candes * Almdmov.factor / 1000).
                  OTHERWISE DO:
                     IF SUBSTRING(Almdmov.Codund,3,2) = 'KG' THEN 
                        ASSIGN
                           T-MOVI.Kilos[x-codfam]  = T-MOVI.Kilos[x-codfam]  + (Almdmov.candes * Almdmov.factor)
                           T-MOVI.Kilos[7]         = T-MOVI.Kilos[7]         + (Almdmov.candes * Almdmov.factor).
                     ELSE
                        ASSIGN 
                           T-MOVI.Kilos[x-codfam]  = T-MOVI.Kilos[x-codfam]  + Almdmov.pesmat
                           T-MOVI.Kilos[7]         = T-MOVI.Kilos[7]         + Almdmov.pesmat.
                     END.
           END.
           IF Almdmov.codmon = R-Codmon  THEN 
              ASSIGN 
                 T-MOVI.Valtot[x-codfam] = T-MOVI.Valtot[x-codfam] + Almdmov.ImpCto
                 T-MOVI.Valtot[7]        = T-MOVI.Valtot[7]        + Almdmov.ImpCto.
           ELSE DO: 
              IF R-Codmon = 1 THEN
                 ASSIGN
                    T-MOVI.Valtot[x-codfam] = T-MOVI.Valtot[x-codfam] + (Almdmov.ImpCto * Almdmov.tpocmb)
                    T-MOVI.Valtot[7]        = T-MOVI.Valtot[7]        + (Almdmov.ImpCto * Almdmov.tpocmb).
              ELSE
                 ASSIGN
                    T-MOVI.Valtot[x-codfam] = T-MOVI.Valtot[x-codfam] + (Almdmov.ImpCto / Almdmov.tpocmb)
                    T-MOVI.Valtot[7]        = T-MOVI.Valtot[7]        + (Almdmov.ImpCto / Almdmov.tpocmb).
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
  DISPLAY R-Codmon RADIO-SET-1 desdeF hastaF RB-NUMBER-COPIES RB-BEGIN-PAGE 
          RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE R-Codmon RADIO-SET-1 B-impresoras desdeF hastaF Btn_OK 
         RB-NUMBER-COPIES Btn_Cancel RB-BEGIN-PAGE Btn_Help RB-END-PAGE RECT-49 
         RECT-5 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato D-Dialog 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
  DEFINE VAR x-titulo2 AS CHAR NO-UNDO.
  x-titulo1 = 'ESTADISTICA DE COMPRAS POR PROVEEDOR'.

  DEFINE FRAME F-REP
         T-MOVI.codpro
         T-MOVI.nompro
         T-MOVI.Kilos[1]
         T-MOVI.Valtot[1]
         T-MOVI.Kilos[2]
         T-MOVI.Valtot[2]
         T-MOVI.Kilos[3]
         T-MOVI.Valtot[3]
         T-MOVI.Kilos[4]
         T-MOVI.Valtot[4]
         T-MOVI.Kilos[5]
         T-MOVI.Valtot[5]
         T-MOVI.Kilos[6]
         T-MOVI.Valtot[6]
         T-MOVI.Kilos[7]
         T-MOVI.Valtot[7]
         WITH WIDTH 250 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.
         
  DEFINE FRAME H-REP
     HEADER
         {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
         {&PRN2} + {&PRN6A} + "( " + S-CODALM + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
         {&PRN6A} + x-titulo1 AT 50 FORMAT "X(50)"
         {&PRN3} + {&PRN6B} + "Pag.  : " AT 135 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         {&PRN2} + {&PRN6A} + "Desde : "  FORMAT "X(10)" STRING(DESDEF,"99/99/9999") FORMAT "X(10)" "Al" STRING(HASTAF,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
         {&PRN3} + "Fecha : " AT 158 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
         "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "                                -------- PERFILES -------- -------- PLANCHAS -------- ------- SOLDADURA -------- -------- CORRUGADO ------- ---------- TUBOS --------- ---------- OTROS --------- -------- T O T A L --------" SKIP
         "Cod.    P R O V E E D O R            KILOS       VALORES        KILOS       VALORES        KILOS       VALORES        KILOS       VALORES        KILOS       VALORES        KILOS       VALORES        KILOS       VALORES   " SKIP
         "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH T-MOVI NO-LOCK BREAK BY T-MOVI.Codcia BY T-MOVI.Codpro:
      {&new-page}.        
      VIEW STREAM REPORT FRAME H-REP.
      DISPLAY STREAM REPORT 
         T-MOVI.codpro
         T-MOVI.nompro
         T-MOVI.Kilos[1]
         T-MOVI.Valtot[1]
         T-MOVI.Kilos[2]
         T-MOVI.Valtot[2]
         T-MOVI.Kilos[3]
         T-MOVI.Valtot[3]
         T-MOVI.Kilos[4]
         T-MOVI.Valtot[4]
         T-MOVI.Kilos[5]
         T-MOVI.Valtot[5]
         T-MOVI.Kilos[6]
         T-MOVI.Valtot[6] 
         T-MOVI.Kilos[7]
         T-MOVI.Valtot[7] WITH FRAME F-REP.
      ACCUMULATE T-MOVI.Kilos[1] (TOTAL).
      ACCUMULATE T-MOVI.Valtot[1] (TOTAL).
      ACCUMULATE T-MOVI.Kilos[2] (TOTAL).
      ACCUMULATE T-MOVI.Valtot[2] (TOTAL).
      ACCUMULATE T-MOVI.Kilos[3] (TOTAL).
      ACCUMULATE T-MOVI.Valtot[3] (TOTAL).
      ACCUMULATE T-MOVI.Kilos[4] (TOTAL).
      ACCUMULATE T-MOVI.Valtot[4] (TOTAL).
      ACCUMULATE T-MOVI.Kilos[5] (TOTAL).
      ACCUMULATE T-MOVI.Valtot[5] (TOTAL).
      ACCUMULATE T-MOVI.Kilos[6] (TOTAL).
      ACCUMULATE T-MOVI.Valtot[6] (TOTAL).
      ACCUMULATE T-MOVI.Kilos[7] (TOTAL).
      ACCUMULATE T-MOVI.Valtot[7] (TOTAL).
      IF LAST-OF(T-MOVI.Codcia) THEN DO:
        UNDERLINE STREAM REPORT 
           T-MOVI.Kilos[1]
           T-MOVI.Valtot[1]
           T-MOVI.Kilos[2]
           T-MOVI.Valtot[2]
           T-MOVI.Kilos[3]
           T-MOVI.Valtot[3]
           T-MOVI.Kilos[4]
           T-MOVI.Valtot[4]
           T-MOVI.Kilos[5]
           T-MOVI.Valtot[5]
           T-MOVI.Kilos[6]
           T-MOVI.Valtot[6] 
           T-MOVI.Kilos[7]
           T-MOVI.Valtot[7] WITH FRAME F-REP.
         DISPLAY STREAM REPORT
            ' '  @ T-MOVI.codpro
            '      TOTAL GENERAL : '  @ T-MOVI.nompro
            ACCUM TOTAL T-MOVI.Kilos[1]  @ T-MOVI.Kilos[1]
            ACCUM TOTAL T-MOVI.Valtot[1] @ T-MOVI.Valtot[1]
            ACCUM TOTAL T-MOVI.Kilos[2]  @ T-MOVI.Kilos[2]
            ACCUM TOTAL T-MOVI.Valtot[2] @ T-MOVI.Valtot[2]
            ACCUM TOTAL T-MOVI.Kilos[3]  @ T-MOVI.Kilos[3]
            ACCUM TOTAL T-MOVI.Valtot[3] @ T-MOVI.Valtot[3]
            ACCUM TOTAL T-MOVI.Kilos[4]  @ T-MOVI.Kilos[4]
            ACCUM TOTAL T-MOVI.Valtot[4] @ T-MOVI.Valtot[4]
            ACCUM TOTAL T-MOVI.Kilos[5]  @ T-MOVI.Kilos[5]
            ACCUM TOTAL T-MOVI.Valtot[5] @ T-MOVI.Valtot[5]
            ACCUM TOTAL T-MOVI.Kilos[6]  @ T-MOVI.Kilos[6]
            ACCUM TOTAL T-MOVI.Valtot[6] @ T-MOVI.Valtot[6] 
            ACCUM TOTAL T-MOVI.Kilos[7]  @ T-MOVI.Kilos[7]
            ACCUM TOTAL T-MOVI.Valtot[7] @ T-MOVI.Valtot[7] WITH FRAME F-REP.
        UNDERLINE STREAM REPORT 
           T-MOVI.Kilos[1]
           T-MOVI.Valtot[1]
           T-MOVI.Kilos[2]
           T-MOVI.Valtot[2]
           T-MOVI.Kilos[3]
           T-MOVI.Valtot[3]
           T-MOVI.Kilos[4]
           T-MOVI.Valtot[4]
           T-MOVI.Kilos[5]
           T-MOVI.Valtot[5]
           T-MOVI.Kilos[6]
           T-MOVI.Valtot[6] 
           T-MOVI.Kilos[7]
           T-MOVI.Valtot[7] WITH FRAME F-REP.
      END.
  END.
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.

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
RUN Carga-Datos.

RUN Formato.

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
    IF c-Pagina > P-pagfin  THEN DO:
       RETURN ERROR.
    END.
    DISPLAY c-Pagina WITH FRAME f-mensaje.
    IF c-Pagina > 1 THEN PAGE STREAM report.
    IF P-pagini = c-Pagina  THEN DO:
        OUTPUT STREAM report CLOSE.
        IF P-select = 1  THEN DO:
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

