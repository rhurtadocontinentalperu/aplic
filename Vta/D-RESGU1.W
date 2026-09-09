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
/* DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0. */
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE T-CLIEN AS CHAR INIT "" NO-UNDO.
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.
DEFINE SHARED VAR S-CODALM  AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS x-NroSer x-CodDiv f-clien f-vende f-desde ~
f-hasta RADIO-SET-1 B-impresoras RB-NUMBER-COPIES RB-BEGIN-PAGE Btn_OK ~
RB-END-PAGE Btn_Cancel Btn_Help RECT-41 RECT-43 RECT-5 
&Scoped-Define DISPLAYED-OBJECTS x-NroSer x-CodDiv f-clien f-vende f-desde ~
f-hasta RADIO-SET-1 f-nomcli f-nomven RB-NUMBER-COPIES RB-BEGIN-PAGE ~
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
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "A&yuda" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE f-clien AS CHARACTER FORMAT "XXXXXXXXXXX":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32.14 BY .69 NO-UNDO.

DEFINE VARIABLE f-nomven AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 19 BY .69 NO-UNDO.

DEFINE VARIABLE f-vende AS CHARACTER FORMAT "XXX":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .69 NO-UNDO.

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

DEFINE VARIABLE x-NroSer AS CHARACTER FORMAT "X(3)":U 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 3.27.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14.86 BY 6.12.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL   
     SIZE 51.14 BY 6.12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     x-NroSer AT ROW 2.35 COL 8 COLON-ALIGNED WIDGET-ID 2
     x-CodDiv AT ROW 1.38 COL 6 COLON-ALIGNED
     f-clien AT ROW 1.31 COL 21 COLON-ALIGNED
     f-vende AT ROW 3.15 COL 8 COLON-ALIGNED
     f-desde AT ROW 3.15 COL 39.43 COLON-ALIGNED
     f-hasta AT ROW 3.15 COL 56 COLON-ALIGNED
     RADIO-SET-1 AT ROW 5.58 COL 3 NO-LABEL
     B-impresoras AT ROW 6.62 COL 16.14
     f-nomcli AT ROW 1.35 COL 32.43 COLON-ALIGNED NO-LABEL
     b-archivo AT ROW 7.62 COL 16.29
     f-nomven AT ROW 3.19 COL 13.14 COLON-ALIGNED NO-LABEL
     RB-OUTPUT-FILE AT ROW 7.77 COL 20.14 COLON-ALIGNED NO-LABEL
     RB-NUMBER-COPIES AT ROW 9.31 COL 10.72 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 9.31 COL 25.43 COLON-ALIGNED
     Btn_OK AT ROW 4.88 COL 55.43
     RB-END-PAGE AT ROW 9.31 COL 39.57 COLON-ALIGNED
     Btn_Cancel AT ROW 6.73 COL 55.43
     Btn_Help AT ROW 8.58 COL 55.43
     "Rango de Fechas :" VIEW-AS TEXT
          SIZE 17.14 BY .62 AT ROW 2.27 COL 46
          FONT 6
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 49.86 BY .62 AT ROW 4.65 COL 1.72
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "Páginas" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 8.69 COL 33.86
          FONT 6
     RECT-41 AT ROW 1 COL 1
     RECT-43 AT ROW 4.46 COL 54
     RECT-5 AT ROW 4.42 COL 1.14
     SPACE(17.43) SKIP(0.41)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Resumen de Guías".


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

{src/bin/_prns.i}
{src/adm/method/containr.i}
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

/* SETTINGS FOR FILL-IN f-nomcli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-nomven IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Resumen de Guías */
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
  ASSIGN f-Desde f-hasta f-vende f-clien x-coddiv x-nroser.

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
 
  IF f-vende <> "" THEN T-vende = "Vendedor :  " + f-vende + "  " + f-nomven.
  IF f-clien <> "" THEN T-clien = "Cliente :  " + f-clien.

  P-largo   = 62.
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
    FOR EACH Gn-divi NO-LOCK WHERE Gn-divi.codcia = s-codcia:
        x-CodDiv:ADD-LAST(Gn-divi.coddiv).
    END.
  END.


ASSIGN x-CodDiv  = S-CODDIV
       F-DESDE   = TODAY
       F-HASTA   = TODAY.


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
  DISPLAY x-NroSer x-CodDiv f-clien f-vende f-desde f-hasta RADIO-SET-1 f-nomcli 
          f-nomven RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE x-NroSer x-CodDiv f-clien f-vende f-desde f-hasta RADIO-SET-1 
         B-impresoras RB-NUMBER-COPIES RB-BEGIN-PAGE Btn_OK RB-END-PAGE 
         Btn_Cancel Btn_Help RECT-41 RECT-43 RECT-5 
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
 DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
    
 DEFINE FRAME f-cab
        FacCpedi.NroPed FORMAT "XXX-XXXXXX"
        FacCpedi.FchPed 
        FacCpedi.NomCli FORMAT "X(30)"
        FacCpedi.RucCli FORMAT "X(8)"
        FacCpedi.Codven FORMAT "X(4)"
        X-MON           FORMAT "X(4)"
        FacCpedi.ImpBrt FORMAT "->,>>>,>>9.99"
        FacCpedi.ImpDto FORMAT "->>,>>9.99"
        FacCpedi.ImpVta FORMAT "->,>>>,>>9.99"
        FacCpedi.ImpIgv FORMAT "->>,>>9.99"
        FacCpedi.ImpTot FORMAT "->,>>>,>>9.99"
        X-EST           FORMAT "X(3)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + FacCpedi.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + "RESUMEN DE PEDIDOS DE OFICINA"  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 96 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 109 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 124 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "    No.      FECHA                                                       T O T A L      TOTAL       VALOR                  P R E C I O        " SKIP
        "  PEDIDO    EMISION   C L I E N T E                   R.U.C.  VEND MON.    BRUTO        DSCTO.      VENTA       I.G.V.      V E N T A   ESTADO" SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.

 PUT CONTROL {&PRN0} + {&PRN5A} + CHR(62) + {&PRN3}.       

 FOR EACH FacCpedi NO-LOCK WHERE
          FacCpedi.CodCia = S-CODCIA AND
          FacCpedi.CodDiv = S-CODDIV AND
          FacCpedi.CodDoc = "PED"    AND
          FacCpedi.FchPed >= F-desde AND
          FacCpedi.FchPed <= F-hasta AND 
          FacCpedi.Codcli BEGINS f-clien AND
          FacCpedi.CodVen BEGINS f-vende
     BY FacCpedi.NroPed:

     IF FacCpedi.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".

     CASE FacCpedi.FlgEst :
          WHEN "P" THEN DO:
             X-EST = "PEN".
             IF FacCpedi.Codmon = 1 THEN DO:
                w-totbru [1] = w-totbru [1] + FacCpedi.ImpBrt.   
                w-totdsc [1] = w-totdsc [1] + FacCpedi.ImpDto.
                w-totval [1] = w-totval [1] + FacCpedi.ImpVta.
                w-totigv [1] = w-totigv [1] + FacCpedi.ImpIgv.
                w-totven [1] = w-totven [1] + FacCpedi.ImpTot.
                END.   
             ELSE DO:  
                w-totbru [2] = w-totbru [2] + FacCpedi.ImpBrt.   
                w-totdsc [2] = w-totdsc [2] + FacCpedi.ImpDto.
                w-totval [2] = w-totval [2] + FacCpedi.ImpVta.
                w-totigv [2] = w-totigv [2] + FacCpedi.ImpIgv.
                w-totven [2] = w-totven [2] + FacCpedi.ImpTot.                
             END.   
          END.   
          WHEN "C" THEN DO:
             X-EST = "CAN".
             IF FacCpedi.Codmon = 1 THEN DO:
                w-totbru [3] = w-totbru [3] + FacCpedi.ImpBrt.   
                w-totdsc [3] = w-totdsc [3] + FacCpedi.ImpDto.
                w-totval [3] = w-totval [3] + FacCpedi.ImpVta.
                w-totigv [3] = w-totigv [3] + FacCpedi.ImpIgv.
                w-totven [3] = w-totven [3] + FacCpedi.ImpTot.
                END.   
             ELSE DO:  
                w-totbru [4] = w-totbru [4] + FacCpedi.ImpBrt.   
                w-totdsc [4] = w-totdsc [4] + FacCpedi.ImpDto.
                w-totval [4] = w-totval [4] + FacCpedi.ImpVta.
                w-totigv [4] = w-totigv [4] + FacCpedi.ImpIgv.
                w-totven [4] = w-totven [4] + FacCpedi.ImpTot.                
             END.                
          END.   
          WHEN "A" THEN DO:
             X-EST = "ANU".       
             IF FacCpedi.Codmon = 1 THEN DO:
                w-totbru [5] = w-totbru [5] + FacCpedi.ImpBrt.   
                w-totdsc [5] = w-totdsc [5] + FacCpedi.ImpDto.
                w-totval [5] = w-totval [5] + FacCpedi.ImpVta.
                w-totigv [5] = w-totigv [5] + FacCpedi.ImpIgv.
                w-totven [5] = w-totven [5] + FacCpedi.ImpTot.
                END.   
             ELSE DO:  
                w-totbru [6] = w-totbru [6] + FacCpedi.ImpBrt.   
                w-totdsc [6] = w-totdsc [6] + FacCpedi.ImpDto.
                w-totval [6] = w-totval [6] + FacCpedi.ImpVta.
                w-totigv [6] = w-totigv [6] + FacCpedi.ImpIgv.
                w-totven [6] = w-totven [6] + FacCpedi.ImpTot.                
             END.                
          END.   
     END.        
               
     DISPLAY STREAM REPORT 
        FacCpedi.NroPed 
        FacCpedi.FchPed 
        FacCpedi.NomCli 
        FacCpedi.RucCli 
        FacCpedi.Codven
        X-MON           
        FacCpedi.ImpVta 
        FacCpedi.ImpDto 
        FacCpedi.ImpBrt 
        FacCpedi.ImpIgv 
        FacCpedi.ImpTot 
        X-EST WITH FRAME F-Cab.

 END.
 DO WHILE LINE-COUNTER(REPORT) < PAGE-SIZE(REPORT) - 8 :
    PUT STREAM REPORT "" skip. 
 END. 
 PUT STREAM REPORT "----------------------------------------------" SPACE(4) "----------------------------------------------" SPACE(4) "----------------------------------------------" SKIP.
 PUT STREAM REPORT "TOTAL CANCELADAS       SOLES        DOLARES   " SPACE(4) "TOTAL PENDIENTES       SOLES        DOLARES   " SPACE(4) "TOTAL ANULADAS         SOLES        DOLARES   " SKIP.
 PUT STREAM REPORT "----------------------------------------------" SPACE(4) "----------------------------------------------" SPACE(4) "----------------------------------------------" SKIP.
 PUT STREAM REPORT "Total Bruto     :" AT 1 w-totbru[3] AT 19  FORMAT "->,>>>,>>9.99" w-totbru[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[1] AT 69  FORMAT "->,>>>,>>9.99" w-totbru[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[5] AT 119 FORMAT "->,>>>,>>9.99" w-totbru[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Descuento       :" AT 1 w-totdsc[3] AT 19  FORMAT "->,>>>,>>9.99" w-totdsc[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[1] AT 69  FORMAT "->,>>>,>>9.99" w-totdsc[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[5] AT 119 FORMAT "->,>>>,>>9.99" w-totdsc[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Valor de Venta  :" AT 1 w-totval[3] AT 19  FORMAT "->,>>>,>>9.99" w-totval[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[1] AT 69  FORMAT "->,>>>,>>9.99" w-totval[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[5] AT 119 FORMAT "->,>>>,>>9.99" w-totval[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "I.G.V.          :" AT 1 w-totigv[3] AT 19  FORMAT "->,>>>,>>9.99" w-totigv[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[1] AT 69  FORMAT "->,>>>,>>9.99" w-totigv[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[5] AT 119 FORMAT "->,>>>,>>9.99" w-totigv[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Precio de Venta :" AT 1 w-totven[3] AT 19  FORMAT "->,>>>,>>9.99" w-totven[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[1] AT 69  FORMAT "->,>>>,>>9.99" w-totven[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[5] AT 119 FORMAT "->,>>>,>>9.99" w-totven[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.

 CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN RUN LIB/d-README.R(s-print-file). 
 END CASE.                                             
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

  RUN prn-gui.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prn-gui D-Dialog 
PROCEDURE prn-gui :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
    
 DEFINE FRAME f-cab
        CcbcDocu.NroDoc FORMAT "XXX-XXXXXX"
        CcbcDocu.FchDoc 
        CcbcDocu.NomCli FORMAT "X(27)"
        CcbcDocu.RucCli FORMAT "X(11)"
        CcbcDocu.Codven FORMAT "X(4)"
        X-MON           FORMAT "X(4)"
        CcbcDocu.ImpBrt FORMAT "->,>>>,>>9.99"
        CcbcDocu.ImpDto FORMAT "->,>>9.99"
        CcbcDocu.ImpVta FORMAT "->,>>>,>>9.99"
        CcbcDocu.ImpIgv FORMAT "->,>>9.99"
        CcbcDocu.ImpTot FORMAT "->,>>>,>>9.99"
        X-EST           FORMAT "X(3)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + CcbcDocu.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + "RESUMEN DE GUIAS "  AT 48 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 91 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 104 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 117 STRING(TIME,"HH:MM:SS") SKIP
        "DIVISION:" STRING(x-CodDiv, 'x(5)') SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "    No.      FECHA                                                       T O T A L      TOTAL       VALOR                P R E C I O     " SKIP
        "   GUIA     EMISION   C L I E N T E                   R.U.C.  VEND MON.    BRUTO        DSCTO.      VENTA      I.G.V.     V E N T A   EST" SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 

 FOR EACH CcbcDocu NO-LOCK WHERE
          CcbcDocu.CodCia = S-CODCIA AND
          /*CcbcDocu.CodDiv = S-CODDIV AND*/
          CcbcDocu.CodDiv BEGINS x-CodDiv AND
          CcbcDocu.CodDoc = "G/R"    AND
          CcbcDocu.FchDoc >= F-desde AND
          CcbcDocu.FchDoc <= F-hasta AND 
          CcbcDocu.Codcli BEGINS f-clien AND
          CcbcDocu.CodVen BEGINS f-vende AND
          Ccbcdocu.nrodoc BEGINS x-nroser
     BY CcbcDocu.NroDoc:
     {&new-page}.
     IF CcbcDocu.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".

     X-EST = "".
     CASE CcbcDocu.FlgEst :
          WHEN "P" THEN DO:
             X-EST = "PEN".
             IF CcbcDocu.Codmon = 1 THEN DO:
                w-totbru [1] = w-totbru [1] + CcbcDocu.ImpBrt.   
                w-totdsc [1] = w-totdsc [1] + CcbcDocu.ImpDto.
                w-totval [1] = w-totval [1] + CcbcDocu.ImpVta.
                w-totigv [1] = w-totigv [1] + CcbcDocu.ImpIgv.
                w-totven [1] = w-totven [1] + CcbcDocu.ImpTot.
                END.   
             ELSE DO:  
                w-totbru [2] = w-totbru [2] + CcbcDocu.ImpBrt.   
                w-totdsc [2] = w-totdsc [2] + CcbcDocu.ImpDto.
                w-totval [2] = w-totval [2] + CcbcDocu.ImpVta.
                w-totigv [2] = w-totigv [2] + CcbcDocu.ImpIgv.
                w-totven [2] = w-totven [2] + CcbcDocu.ImpTot.                
             END.   
          END.   
          WHEN "C" THEN DO:
             X-EST = "CAN".
             IF CcbcDocu.Codmon = 1 THEN DO:
                w-totbru [3] = w-totbru [3] + CcbcDocu.ImpBrt.   
                w-totdsc [3] = w-totdsc [3] + CcbcDocu.ImpDto.
                w-totval [3] = w-totval [3] + CcbcDocu.ImpVta.
                w-totigv [3] = w-totigv [3] + CcbcDocu.ImpIgv.
                w-totven [3] = w-totven [3] + CcbcDocu.ImpTot.
                END.   
             ELSE DO:  
                w-totbru [4] = w-totbru [4] + CcbcDocu.ImpBrt.   
                w-totdsc [4] = w-totdsc [4] + CcbcDocu.ImpDto.
                w-totval [4] = w-totval [4] + CcbcDocu.ImpVta.
                w-totigv [4] = w-totigv [4] + CcbcDocu.ImpIgv.
                w-totven [4] = w-totven [4] + CcbcDocu.ImpTot.                
             END.                
          END.
          WHEN "F" THEN DO:
             X-EST = "FAC".
             IF CcbcDocu.Codmon = 1 THEN DO:
                w-totbru [3] = w-totbru [3] + CcbcDocu.ImpBrt.   
                w-totdsc [3] = w-totdsc [3] + CcbcDocu.ImpDto.
                w-totval [3] = w-totval [3] + CcbcDocu.ImpVta.
                w-totigv [3] = w-totigv [3] + CcbcDocu.ImpIgv.
                w-totven [3] = w-totven [3] + CcbcDocu.ImpTot.
                END.   
             ELSE DO:  
                w-totbru [4] = w-totbru [4] + CcbcDocu.ImpBrt.   
                w-totdsc [4] = w-totdsc [4] + CcbcDocu.ImpDto.
                w-totval [4] = w-totval [4] + CcbcDocu.ImpVta.
                w-totigv [4] = w-totigv [4] + CcbcDocu.ImpIgv.
                w-totven [4] = w-totven [4] + CcbcDocu.ImpTot.                
             END.                
          END.   
          WHEN "A" THEN DO:
             X-EST = "ANU".       
             IF CcbcDocu.Codmon = 1 THEN DO:
                w-totbru [5] = w-totbru [5] + CcbcDocu.ImpBrt.   
                w-totdsc [5] = w-totdsc [5] + CcbcDocu.ImpDto.
                w-totval [5] = w-totval [5] + CcbcDocu.ImpVta.
                w-totigv [5] = w-totigv [5] + CcbcDocu.ImpIgv.
                w-totven [5] = w-totven [5] + CcbcDocu.ImpTot.
                END.   
             ELSE DO:  
                w-totbru [6] = w-totbru [6] + CcbcDocu.ImpBrt.   
                w-totdsc [6] = w-totdsc [6] + CcbcDocu.ImpDto.
                w-totval [6] = w-totval [6] + CcbcDocu.ImpVta.
                w-totigv [6] = w-totigv [6] + CcbcDocu.ImpIgv.
                w-totven [6] = w-totven [6] + CcbcDocu.ImpTot.                
             END.                
          END.   
     END.        
               
     DISPLAY STREAM REPORT 
        CcbcDocu.NroDoc 
        CcbcDocu.FchDoc 
        CcbcDocu.NomCli 
        CcbcDocu.RucCli 
        CcbcDocu.Codven
        X-MON           
        CcbcDocu.ImpVta 
        CcbcDocu.ImpDto 
        CcbcDocu.ImpBrt 
        CcbcDocu.ImpIgv 
        CcbcDocu.ImpTot 
        X-EST WITH FRAME F-Cab.

 END.
 DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
    PUT STREAM REPORT "" skip. 
 END. 
 PUT STREAM REPORT "-------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "-------------------------------------------" SKIP.
 PUT STREAM REPORT "TOTAL CANCELADAS       SOLES      DOLARES  " SPACE(4) "TOTAL PENDIENTES       SOLES      DOLARES  " SPACE(4) "TOTAL ANULADAS        SOLES       DOLARES  " SKIP.
 PUT STREAM REPORT "-------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "-------------------------------------------" SKIP.
 PUT STREAM REPORT "Total Bruto     :" AT 1 w-totbru[3] AT 19  FORMAT "->>>>,>>9.99" w-totbru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[1] AT 69  FORMAT "->>>>,>>9.99" w-totbru[2] AT 84  FORMAT "->>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[5] AT 119 FORMAT "->>>>,>>9.99" w-totbru[6] AT 134 FORMAT "->>>,>>9.99" SKIP.
 PUT STREAM REPORT "Descuento       :" AT 1 w-totdsc[3] AT 19  FORMAT "->>>>,>>9.99" w-totdsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[1] AT 69  FORMAT "->>>>,>>9.99" w-totdsc[2] AT 84  FORMAT "->>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[5] AT 119 FORMAT "->>>>,>>9.99" w-totdsc[6] AT 134 FORMAT "->>>,>>9.99" SKIP.
 PUT STREAM REPORT "Valor de Venta  :" AT 1 w-totval[3] AT 19  FORMAT "->>>>,>>9.99" w-totval[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[1] AT 69  FORMAT "->>>>,>>9.99" w-totval[2] AT 84  FORMAT "->>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[5] AT 119 FORMAT "->>>>,>>9.99" w-totval[6] AT 134 FORMAT "->>>,>>9.99" SKIP.
 PUT STREAM REPORT "I.G.V.          :" AT 1 w-totigv[3] AT 19  FORMAT "->>>>,>>9.99" w-totigv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[1] AT 69  FORMAT "->>>>,>>9.99" w-totigv[2] AT 84  FORMAT "->>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[5] AT 119 FORMAT "->>>>,>>9.99" w-totigv[6] AT 134 FORMAT "->>>,>>9.99" SKIP.
 PUT STREAM REPORT "Precio de Venta :" AT 1 w-totven[3] AT 19  FORMAT "->>>>,>>9.99" w-totven[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[1] AT 69  FORMAT "->>>>,>>9.99" w-totven[2] AT 84  FORMAT "->>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[5] AT 119 FORMAT "->>>>,>>9.99" w-totven[6] AT 134 FORMAT "->>>,>>9.99" SKIP.

 OUTPUT STREAM REPORT CLOSE. 
 
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

