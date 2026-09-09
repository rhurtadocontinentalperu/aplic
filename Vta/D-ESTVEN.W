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
DEFINE BUFFER B-CDOCU FOR CCBCDOCU.
DEFINE BUFFER B-DDOCU FOR CCBDDOCU.

DEFINE TEMP-TABLE t-vendedor 
       FIELD CODCIA   LIKE CcbcDocu.Codcia
       FIELD FMAPGO   LIKE CcbCdocu.FMAPGO
       FIELD CODVEN   LIKE CcbCdocu.CodVen
       FIELD NOMVEN   LIKE Gn-Ven.NomVen
       FIELD CODMAT   LIKE Almmmatg.Codmat
       FIELD CLASE    AS   CHAR FORMAT "X(1)"
       FIELD DESMAT   LIKE Almmmatg.DesMat
       FIELD UNIDAD   LIKE Almmmatg.UndStk
       FIELD CANTIDAD LIKE CcbDdocu.CanDes
       FIELD TOTAL    LIKE CcbDdocu.ImpLin
       FIELD TOTSOL    LIKE CcbDdocu.ImpLin
       FIELD TOTDOL    LIKE CcbDdocu.ImpLin
       FIELD CODDOC    LIKE Ccbcdocu.Coddoc 
       FIELD NRODOC    LIKE Ccbcdocu.NroDoc
       FIELD Fchdoc    LIKE ccbcdocu.FchDoc
       FIELD CodFam    LIKE Almmmatg.codfam
       FIELD SubFam    LIKE Almmmatg.subfam
       INDEX LLAVE01 CODVEN CODMAT
       INDEX LLAVE02 CODCIA CODMAT
       INDEX LLAVE03 CODVEN CLASE
       INDEX LLAVE04 CODFAM SUBFAM.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

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
&Scoped-Define ENABLED-OBJECTS RECT-54 F-articulo RADIO-SET-Tipo f-vendedor ~
R-TIPO f-desde f-hasta x-CodFam x-SubFam B-imprime B-cancela Btn_Excel ~
RADIO-SET-1 B-impresoras RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS F-articulo RADIO-SET-Tipo f-vendedor ~
R-TIPO f-desde f-hasta x-CodFam x-SubFam FILL-IN-1 RADIO-SET-1 ~
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

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 11 BY 1.5 TOOLTIP "Detallado por material y todos los almacenes"
     BGCOLOR 8 .

DEFINE VARIABLE F-articulo AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 7.29 BY .81 NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-vendedor AS CHARACTER FORMAT "X(3)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 6.29 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .69
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

DEFINE VARIABLE x-CodFam AS CHARACTER FORMAT "x(3)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE x-SubFam AS CHARACTER FORMAT "x(3)":U 
     LABEL "Sub-familia" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE R-TIPO AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Division", 1,
"Compañia", 2
     SIZE 19.72 BY .81 NO-UNDO.

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
"Resumen", 2,
"Categoria", 3,
"Categoria-Detalle", 4,
"Familia", 5
     SIZE 14.29 BY 3.77 NO-UNDO.

DEFINE RECTANGLE RECT-54
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63.29 BY 12.12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-articulo AT ROW 1.27 COL 13 COLON-ALIGNED
     RADIO-SET-Tipo AT ROW 1.27 COL 49 NO-LABEL
     f-vendedor AT ROW 2.08 COL 13 COLON-ALIGNED
     R-TIPO AT ROW 2.88 COL 15 NO-LABEL
     f-desde AT ROW 3.69 COL 13 COLON-ALIGNED
     f-hasta AT ROW 3.69 COL 31 COLON-ALIGNED
     x-CodFam AT ROW 4.5 COL 13 COLON-ALIGNED WIDGET-ID 2
     x-SubFam AT ROW 5.31 COL 13 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-1 AT ROW 6.38 COL 4 NO-LABEL
     B-imprime AT ROW 8.12 COL 25
     B-cancela AT ROW 8.12 COL 36
     Btn_Excel AT ROW 8.12 COL 47
     RADIO-SET-1 AT ROW 8.31 COL 5.43 NO-LABEL
     B-impresoras AT ROW 9.42 COL 17.86
     b-archivo AT ROW 10.42 COL 17.86
     RB-OUTPUT-FILE AT ROW 10.54 COL 21.72 COLON-ALIGNED NO-LABEL
     RB-NUMBER-COPIES AT ROW 12.04 COL 12 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 12.04 COL 26 COLON-ALIGNED
     RB-END-PAGE AT ROW 12.04 COL 41.14 COLON-ALIGNED
     "Paginas" VIEW-AS TEXT
          SIZE 8.14 BY .58 AT ROW 11.35 COL 34.57
          FONT 6
     " Configuracion de Impresion" VIEW-AS TEXT
          SIZE 54 BY .62 AT ROW 7.15 COL 4
          BGCOLOR 1 FGCOLOR 15 FONT 6
     RECT-54 AT ROW 1 COL 1.72
     SPACE(0.55) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte de Ventas x Vendedor".


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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte de Ventas x Vendedor */
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
  ASSIGN f-vendedor R-tipo f-articulo f-desde f-hasta RADIO-SET-Tipo
      x-CodFam x-SubFam.

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


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel D-Dialog
ON CHOOSE OF Btn_Excel IN FRAME D-Dialog /* Excel */
DO:
    RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-articulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-articulo D-Dialog
ON LEAVE OF F-articulo IN FRAME D-Dialog /* Articulo */
DO:
  ASSIGN F-articulo.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tabla D-Dialog 
PROCEDURE Carga-Tabla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR F-CODI   AS CHAR NO-UNDO.
DEFINE VAR F-FACTOR AS DECI NO-UNDO.
DEFINE VAR F-PORIGV AS DECI NO-UNDO.
DEFINE VAR F-FMAPGO AS CHAR NO-UNDO.
DEFINE VAR X-SIGNO  AS DECI NO-UNDO.
DEFINE VAR dMonto   AS DECI NO-UNDO.

/*
F-CODI = "001228,001229,001230,001231,001232,001233,001237,001238,001239,001240,001241,001242,
014260,014261,014262,011096,011095,011116,011120,011097,011098,011099,011105,011106,011108,
011109,011093,011094,003430,003431,003432,003433,003434,003441,003442,003438,003439,003440,
003435,003436,003437,007866,001722,001723,001726,001727,010374,010387,010383".
*/
FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.codcia = S-CODCIA:
 f-punto = GN-DIVI.CodDiv.

FOR EACH t-vendedor: DELETE t-vendedor. END.

 FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR AND
          CcbCdocu.CodCia = S-CODCIA AND
          CcbCdocu.CodDiv = f-punto AND
          CCbCdocu.FchDoc >= f-desde AND 
          CcbCdocu.FchDoc <= f-hasta AND
          CcbCdocu.CodDoc BEGINS ""  AND
          CcbCdocu.CodDoc <> "G/R" AND
          CcbCdocu.TpoFac <> 'A' AND        /* NO facturas adelantadas */
          CcbCDocu.CodVen BEGINS f-vendedor USE-INDEX LLAVE10 ,
          EACH CcbDdocu OF ccbCdocu NO-LOCK WHERE CcbDdocu.CodMat BEGINS F-articulo
                AND CcbDdocu.implin > 0,        /* <<< OJO <<< */
          FIRST Almmmatg OF CcbDdocu NO-LOCK WHERE Almmmatg.codfam BEGINS x-CodFam
                AND Almmmatg.subfam BEGINS x-SubFam:
          /* IF LOOKUP(CcbDdocu.CodMat,F-CODI) = 0 THEN NEXT.*/
          
          X-signo = if ccbcdocu.coddoc = "N/C" then -1 else 1.
          ASSIGN 
              FILL-IN-1 = CcbCdocu.Codven + " " + CcbDdocu.CodMat + " " + Almmmatg.DesMat.
              DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}.
            
          FIND T-VENDEDOR WHERE 
               t-vendedor.codven = CcbCDocu.Codven and
               t-vendedor.codmat = CcbDDocu.CodMat NO-ERROR.
         
          FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                              Almtconv.Codalter = Ccbddocu.UndVta
                              NO-LOCK NO-ERROR.
  
          F-FACTOR  = 1. 
          F-PORIGV  = 1.
          IF Almmmatg.AftIgv THEN F-PORIGV  = ( 1 + (Faccfggn.PorIgv / 100)).
      
          IF AVAILABLE Almtconv THEN DO:
           F-FACTOR = Almtconv.Equival.
           IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
          END.

          F-FMAPGO  = "107".
          
          IF Lookup(Ccbcdocu.Fmapgo,"000,001,002") > 0 THEN F-FMAPGO  = "000".

                                          
          IF NOT AVAILABLE T-VENDEDOR then do:
             CREATE T-VENDEDOR.
                 ASSIGN 
                 T-VENDEDOR.CODVEN   = CcbCdocu.CodVen
                 T-VENDEDOR.FMAPGO   = F-FMAPGO
                 T-VENDEDOR.CLASE    = Almmmatg.Clase 
                 T-VENDEDOR.CODMAT   = Almmmatg.Codmat
                 T-VENDEDOR.DESMAT   = Almmmatg.DesMat
                 T-VENDEDOR.UNIDAD   = Almmmatg.UndStk
                 T-VENDEDOR.CODFAM   = Almmmatg.CodFam
                 T-VENDEDOR.SUBFAM   = Almmmatg.SubFam.
                 
             find first gn-ven where gn-ven.codcia = s-codcia and
                                     gn-ven.codven = CcbcDocu.CodVen NO-LOCK NO-ERROR.
             IF AVAILABLE gn-ven THEN T-VENDEDOR.NOMVEN = gn-ven.NomVen.
          END.           
          T-VENDEDOR.CANTIDAD = T-VENDEDOR.CANTIDAD + x-signo * CcbDdocu.CanDes * F-FACTOR.
          
          ASSIGN T-VENDEDOR.TOTAL  = T-VENDEDOR.TOTAL  + X-SIGNO * ((ccbddocu.implin) / F-PORIGV ) * (If CcbcDocu.codmon = 1 THEN 1 ELSE Ccbcdocu.Tpocmb) * ( 1 - ccbcdocu.Pordto / 100 ).
                 T-VENDEDOR.TOTSOL = T-VENDEDOR.TOTSOL + X-SIGNO * ((ccbddocu.implin) / F-PORIGV ) * (If CcbcDocu.codmon = 1 THEN 1 ELSE Ccbcdocu.Tpocmb) * ( 1 - ccbcdocu.Pordto / 100 ).
                 T-VENDEDOR.TOTDOL = T-VENDEDOR.TOTDOL + X-SIGNO * ((ccbddocu.implin) / F-PORIGV ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb) * ( 1 - ccbcdocu.Pordto / 100 ).
          PROCESS EVENTS.
  END.      
 FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR AND
          CcbCdocu.CodCia = S-CODCIA AND
          CcbCdocu.CodDiv = f-punto AND
          CCbCdocu.FchDoc >= f-desde AND 
          CcbCdocu.FchDoc <= f-hasta AND
          CcbCdocu.CodDoc = "N/C" AND
          CcbCdocu.CndCre = "N" AND
          CcbCDocu.CodVen BEGINS f-vendedor 
          USE-INDEX LLAVE10:
     FIND B-CDOCU WHERE B-CDOCU.CODCIA = CCBCDOCU.CODCIA AND
                        B-CDOCU.CODDOC = CCBCDOCU.CODREF AND
                        B-CDOCU.NRODOC = CCBCDOCU.NROREF AND
                        B-CDOCU.TpoFac <> 'A'       /* NO facturas adelantas */
                        NO-LOCK NO-ERROR.
     IF AVAILABLE B-CDOCU THEN DO:
         FIND FIRST B-DDOCU OF B-CDOCU WHERE B-DDOCU.ImpLin < 0 NO-LOCK NO-ERROR.
         IF AVAILABLE B-DDOCU THEN dMonto = -1 * B-DDOCU.ImpLin.
         ELSE dMonto = 0.
         FOR EACH B-DDOCU OF B-CDOCU NO-LOCK WHERE B-DDOCU.Codmat BEGINS F-articulo
             AND B-DDOCU.implin > 0:     /* <<< OJO <<< */
             FIND ALMMMATG OF B-DDOCU NO-LOCK NO-ERROR.
             IF NOT AVAILABLE almmmatg THEN NEXT.
             FIND T-VENDEDOR WHERE 
                 t-vendedor.codven = B-CDOCU.Codven and
                 t-vendedor.codmat = B-DDOCU.CodMat NO-ERROR.
             FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                 Almtconv.Codalter = B-DDOCU.UndVta NO-LOCK NO-ERROR.
             X-signo = if ccbcdocu.coddoc = "N/C" then -1 else 1.
             F-FACTOR  = 1. 
             F-PORIGV  = 1.
             IF Almmmatg.AftIgv THEN F-PORIGV  = ( 1 + (Faccfggn.PorIgv / 100)).
      
             IF AVAILABLE Almtconv THEN DO:
                F-FACTOR = Almtconv.Equival.
                IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
             END.
             F-FMAPGO  = "107".
             IF Lookup(B-CDOCU.Fmapgo,"000,001,002") > 0 THEN F-FMAPGO  = "000".
             IF NOT AVAILABLE T-VENDEDOR then do:
                 CREATE T-VENDEDOR.
                 ASSIGN 
                     T-VENDEDOR.CODVEN   = B-CDOCU.CodVen
                     T-VENDEDOR.FMAPGO   = F-FMAPGO
                     T-VENDEDOR.CLASE    = Almmmatg.Clase 
                     T-VENDEDOR.CODMAT   = Almmmatg.Codmat
                     T-VENDEDOR.DESMAT   = Almmmatg.DesMat
                     T-VENDEDOR.UNIDAD   = Almmmatg.UndStk
                     T-VENDEDOR.CODFAM   = Almmmatg.CodFam.
                 find first gn-ven where gn-ven.codcia = s-codcia and
                     gn-ven.codven = B-CDOCU.CodVen NO-LOCK NO-ERROR.
                 IF AVAILABLE gn-ven THEN T-VENDEDOR.NOMVEN = gn-ven.NomVen.
             END.
             ASSIGN 
                 T-VENDEDOR.TOTAL  = T-VENDEDOR.TOTAL  + X-SIGNO * ((((B-DDOCU.implin) / F-PORIGV ) * (If B-CDOCU.codmon = 1 THEN 1 ELSE B-CDOCU.Tpocmb) * ( 1 - ccbcdocu.Pordto / 100 )) / B-CDOCU.IMPTOT) * CCBCDOCU.IMPTOT.
                 T-VENDEDOR.TOTSOL = T-VENDEDOR.TOTSOL + X-SIGNO * ((((B-DDOCU.implin) / F-PORIGV ) * (If B-CDOCU.codmon = 1 THEN 1 ELSE B-CDOCU.Tpocmb) * ( 1 - ccbcdocu.Pordto / 100 )) / B-CDOCU.IMPTOT) * CCBCDOCU.IMPTOT.
                 T-VENDEDOR.TOTDOL = T-VENDEDOR.TOTDOL + X-SIGNO * ((((B-DDOCU.implin) / F-PORIGV ) / (If B-CDOCU.codmon = 2 THEN 1 ELSE B-CDOCU.Tpocmb) * ( 1 - ccbcdocu.Pordto / 100 )) / B-CDOCU.IMPTOT) * CCBCDOCU.IMPTOT.
        END.
     END.
  END.
END.
    
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
DEFINE VAR F-CODI   AS CHAR NO-UNDO.
DEFINE VAR F-FACTOR AS DECI NO-UNDO.
DEFINE VAR F-PORIGV AS DECI NO-UNDO.
DEFINE VAR F-FMAPGO AS CHAR NO-UNDO.
DEFINE VAR X-SIGNO  AS DECI NO-UNDO.
DEFINE VAR X-TOT    AS DECI NO-UNDO.
DEFINE VAR dMonto   AS DECI NO-UNDO.

/*
F-CODI = "001228,001229,001230,001231,001232,001233,001237,001238,001239,001240,001241,001242,
014260,014261,014262,011096,011095,011116,011120,011097,011098,011099,011105,011106,011108,
011109,011093,011094,003430,003431,003432,003433,003434,003441,003442,003438,003439,003440,
003435,003436,003437,007866,001722,001723,001726,001727,010374,010387,010383".
*/
FIND FaccfgGn WHERE FaccfgGn.Codcia = S-CODCIA NO-LOCK NO-ERROR.

FOR EACH t-vendedor: DELETE t-vendedor. END.

 FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR AND
          CcbCdocu.CodCia = S-CODCIA AND
          CcbCdocu.CodDiv = S-CODDIV AND
        /*  CcbCdocu.CodDiv BEGINS "" AND*/
          CCbCdocu.FchDoc >= f-desde AND 
          CcbCdocu.FchDoc <= f-hasta AND
          CcbCdocu.CodDoc BEGINS ""  AND
          CcbCdocu.CodDoc <> "G/R" AND
          CcbCdocu.TpoFac <> 'A' AND        /* NO facturas adelantadas */
          CcbCDocu.CodVen BEGINS f-vendedor USE-INDEX LLAVE10 ,
          EACH CcbDdocu OF ccbCdocu NO-LOCK WHERE CcbDdocu.CodMat BEGINS F-articulo  
                AND CcbDdocu.implin > 0,        /* <<< OJO <<< */
          FIRST Almmmatg OF CcbDdocu NO-LOCK WHERE Almmmatg.codfam BEGINS x-CodFam
                AND Almmmatg.subfam BEGINS x-SubFam:
          /* IF LOOKUP(CcbDdocu.CodMat,F-CODI) = 0 THEN NEXT.*/
          
          X-signo = if ccbcdocu.coddoc = "N/C" then -1 else 1.
          ASSIGN 
              FILL-IN-1 = CcbCdocu.Codven + " " + CcbDdocu.CodMat + " " + Almmmatg.DesMat.
              DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}.
            
          FIND T-VENDEDOR WHERE 
               t-vendedor.codven = CcbCDocu.Codven and
               t-vendedor.codmat = CcbDDocu.CodMat NO-ERROR.
         
          FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                              Almtconv.Codalter = Ccbddocu.UndVta
                              NO-LOCK NO-ERROR.
  
          F-FACTOR  = 1. 
          F-PORIGV  = 1.
          IF Almmmatg.AftIgv THEN F-PORIGV  = ( 1 + (Faccfggn.PorIgv / 100)).
      
          IF AVAILABLE Almtconv THEN DO:
           F-FACTOR = Almtconv.Equival.
           IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
          END.

          F-FMAPGO  = "107".
          
          IF Lookup(Ccbcdocu.Fmapgo,"000,001,002") > 0 THEN F-FMAPGO  = "000".
                                         
          IF NOT AVAILABLE T-VENDEDOR then do:
             CREATE T-VENDEDOR.
                 ASSIGN 
                 T-VENDEDOR.CODVEN   = CcbCdocu.CodVen
                 T-VENDEDOR.FMAPGO   = F-FMAPGO
                 T-VENDEDOR.CLASE    = Almmmatg.Clase 
                 T-VENDEDOR.CODMAT   = Almmmatg.Codmat
                 T-VENDEDOR.DESMAT   = Almmmatg.DesMat
                 T-VENDEDOR.UNIDAD   = Almmmatg.UndStk
                 T-VENDEDOR.CODFAM   = Almmmatg.CodFam
                 T-VENDEDOR.SUBFAM   = Almmmatg.SubFam.
             find first gn-ven where gn-ven.codcia = s-codcia and
                                     gn-ven.codven = CcbcDocu.CodVen NO-LOCK NO-ERROR.
             IF AVAILABLE gn-ven THEN T-VENDEDOR.NOMVEN = gn-ven.NomVen.
          END.  
          
          T-VENDEDOR.CANTIDAD = T-VENDEDOR.CANTIDAD + x-signo * CcbDdocu.CanDes * F-FACTOR.
          
          ASSIGN T-VENDEDOR.TOTAL  = T-VENDEDOR.TOTAL  + X-SIGNO * ((ccbddocu.implin) / F-PORIGV ) * (If CcbcDocu.codmon = 1 THEN 1 ELSE Ccbcdocu.Tpocmb) * ( 1 - ccbcdocu.Pordto / 100 ).
                 T-VENDEDOR.TOTSOL = T-VENDEDOR.TOTSOL + X-SIGNO * ((ccbddocu.implin) / F-PORIGV ) * (If CcbcDocu.codmon = 1 THEN 1 ELSE Ccbcdocu.Tpocmb) * ( 1 - ccbcdocu.Pordto / 100 ).
                 T-VENDEDOR.TOTDOL = T-VENDEDOR.TOTDOL + X-SIGNO * ((ccbddocu.implin) / F-PORIGV ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb) * ( 1 - ccbcdocu.Pordto / 100 ).

          PROCESS EVENTS.
  END.      
  
 FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR AND
          CcbCdocu.CodCia = S-CODCIA AND
          CcbCdocu.CodDiv = S-CODDIV AND
          CCbCdocu.FchDoc >= f-desde AND 
          CcbCdocu.FchDoc <= f-hasta AND
          CcbCdocu.CodDoc = "N/C" AND
          CcbCdocu.CndCre = "N" AND
          CcbCDocu.CodVen BEGINS f-vendedor 
          USE-INDEX LLAVE10:

     FIND B-CDOCU WHERE B-CDOCU.CODCIA = CCBCDOCU.CODCIA AND
                        B-CDOCU.CODDOC = CCBCDOCU.CODREF AND
                        B-CDOCU.NRODOC = CCBCDOCU.NROREF
                        NO-LOCK NO-ERROR.
     IF AVAILABLE B-CDOCU THEN DO:
        FIND FIRST B-DDOCU OF B-CDOCU WHERE B-DDOCU.ImpLin < 0 NO-LOCK NO-ERROR.
        IF AVAILABLE B-DDOCU THEN dMonto = -1 * B-DDOCU.ImpLin.
        ELSE dMonto = 0.

        FOR EACH B-DDOCU OF B-CDOCU WHERE B-DDOCU.Codmat BEGINS F-articulo NO-LOCK:
            FIND ALMMMATG OF B-DDOCU NO-LOCK NO-ERROR.            
            IF NOT AVAILABLE almmmatg THEN NEXT.
            FIND T-VENDEDOR WHERE 
                 t-vendedor.codven = B-CDOCU.Codven and
                 t-vendedor.codmat = B-DDOCU.CodMat NO-ERROR.
         
            FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                Almtconv.Codalter = B-DDOCU.UndVta NO-LOCK NO-ERROR.

            X-signo = if ccbcdocu.coddoc = "N/C" then -1 else 1.
            F-FACTOR  = 1. 
            F-PORIGV  = 1.
            IF Almmmatg.AftIgv THEN F-PORIGV  = ( 1 + (Faccfggn.PorIgv / 100)).
            IF AVAILABLE Almtconv THEN DO:
                F-FACTOR = Almtconv.Equival.
                IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
            END.
            F-FMAPGO  = "107".
          
            IF Lookup(B-CDOCU.Fmapgo,"000,001,002") > 0 THEN F-FMAPGO  = "000".
                                         
            IF NOT AVAILABLE T-VENDEDOR then do:
                CREATE T-VENDEDOR.
                ASSIGN 
                    T-VENDEDOR.CODVEN   = B-CDOCU.CodVen
                    T-VENDEDOR.FMAPGO   = F-FMAPGO
                    T-VENDEDOR.CLASE    = Almmmatg.Clase 
                    T-VENDEDOR.CODMAT   = Almmmatg.Codmat
                    T-VENDEDOR.DESMAT   = Almmmatg.DesMat
                    T-VENDEDOR.UNIDAD   = Almmmatg.UndStk
                    T-VENDEDOR.CODFAM   = Almmmatg.CodFam.
                find first gn-ven where gn-ven.codcia = s-codcia and
                    gn-ven.codven = B-CDOCU.CodVen NO-LOCK NO-ERROR.
                IF AVAILABLE gn-ven THEN T-VENDEDOR.NOMVEN = gn-ven.NomVen.
            END.          
            ASSIGN 
                T-VENDEDOR.TOTAL  = T-VENDEDOR.TOTAL  + X-SIGNO * ((((B-DDOCU.implin) / F-PORIGV ) * (If B-CDOCU.codmon = 1 THEN 1 ELSE B-CDOCU.Tpocmb) * ( 1 - ccbcdocu.Pordto / 100 )) / (B-CDOCU.IMPTOT + dMonto)) * CCBCDOCU.IMPTOT.
                T-VENDEDOR.TOTSOL = T-VENDEDOR.TOTSOL + X-SIGNO * ((((B-DDOCU.implin) / F-PORIGV ) * (If B-CDOCU.codmon = 1 THEN 1 ELSE B-CDOCU.Tpocmb) * ( 1 - ccbcdocu.Pordto / 100 )) / B-CDOCU.IMPTOT) * CCBCDOCU.IMPTOT.
                T-VENDEDOR.TOTDOL = T-VENDEDOR.TOTDOL + X-SIGNO * ((((B-DDOCU.implin) / F-PORIGV ) / (If B-CDOCU.codmon = 2 THEN 1 ELSE B-CDOCU.Tpocmb) * ( 1 - ccbcdocu.Pordto / 100 )) / B-CDOCU.IMPTOT) * CCBCDOCU.IMPTOT.
        END.        
     END.
 END.      


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE categoria-vendedor D-Dialog 
PROCEDURE categoria-vendedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR L-SW AS LOGICAL INIT NO.
 DEFINE VAR T-TOTCONS  AS DECIMAL.
 DEFINE VAR T-TOTCRES  AS DECIMAL.
 DEFINE VAR T-TOTCOND  AS DECIMAL.
 DEFINE VAR T-TOTCRED  AS DECIMAL.
 DEFINE VAR TT-TOTCONS AS DECIMAL.
 DEFINE VAR TT-TOTCRES AS DECIMAL.
 DEFINE VAR TT-TOTCOND AS DECIMAL.
 DEFINE VAR TT-TOTCRED AS DECIMAL.
 DEFINE VAR X-PORCOMI  AS DECIMAL.
 DEFINE VAR X-CLASE    AS CHAR. 
 DEFINE VAR X-TITU     AS CHAR.

 X-TITU = "VENTAS POR VENDEDOR - CATEGORIA PRODUCTO - " + X-PUNTO.

 DEFINE FRAME f-cab
        T-VENDEDOR.CodVen   AT 02  FORMAT "x(3)"    
        T-VENDEDOR.nomven   AT 07  FORMAT "x(35)"
        T-VENDEDOR.Clase    AT 44  FORMAT "x(3)"  
        T-TOTCONS  FORMAT "->>,>>>,>>>,>>9.99"
        T-TOTCRES  FORMAT "->>,>>>,>>>,>>9.99"
        X-PORCOMI  FORMAT ">>9.99%"       
        T-TOTCOND  FORMAT "->>>,>>>,>>9.99"
        T-TOTCRED  FORMAT "->>>,>>>,>>9.99"
        
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
/*        {&PRN2} + {&PRN6A} + "DIVISION : " + f-punto AT 1 FORMAT "X(20)" F-DIRDIV AT 25 FORMAT "X(30)"  */
        {&PRN3} + {&PRN6B} + "Pagina: " AT 80 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN3} + {&PRN6B} + "Fecha : " AT 80 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN2} + {&PRN6A} + "MONEDA   : NUEVOS SOLES (SIN IGV)" At 1 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 80 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        "------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                         V     E     N     T     A                  C  O  M  I  S  I  O  N    " SKIP
        " Cod.        V  E  N  D  E  D  O  R       Clase          CONTADO          CREDITO        %         CONTADO          CREDITO   " SKIP
        "------------------------------------------------------------------------------------------------------------------------------" SKIP
/***      999  12345678901234567890123456789012345  999999  12345678901234567890123456789012345678901234567890 1234 99,999,999.99  999,999,999.99 ***/
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH t-vendedor NO-LOCK
          BREAK BY T-VENDEDOR.CODCIA
                BY T-VENDEDOR.CODVEN 
                BY T-VENDEDOR.CLASE :
                                 
     {&NEW-PAGE}.
     IF FIRST-OF ( T-VENDEDOR.CODVEN )   THEN DO:
     
     DISPLAY STREAM REPORT 
          T-VENDEDOR.codven   
          T-VENDEDOR.nomven    
          WITH FRAME F-Cab.
     END.     
        
        IF T-VENDEDOR.FMAPGO = "000" THEN
         ASSIGN T-TOTCONS = T-TOTCONS + T-VENDEDOR.TOTSOL
                /*T-TOTCOND = T-TOTCOND + T-VENDEDOR.TOTDOL*/.

        IF T-VENDEDOR.FMAPGO = "107" THEN
         ASSIGN T-TOTCRES = T-TOTCRES + T-VENDEDOR.TOTSOL
               /* T-TOTCRED = T-TOTCRED + T-VENDEDOR.TOTDOL*/.

        IF LAST-OF (T-VENDEDOR.CLASE) THEN DO:
        
           FIND PORCOMI WHERE PORCOMI.CODCIA = S-CODCIA AND
                              PORCOMI.CATEGO BEGINS T-VENDEDOR.CLASE
                              NO-LOCK NO-ERROR. 
           IF AVAILABLE PORCOMI THEN X-PORCOMI = PORCOMI.PORCOM.

           T-TOTCOND = T-TOTCONS * ( X-PORCOMI / 100 ). 
           T-TOTCRED = T-TOTCRES * ( X-PORCOMI / 100 ).
           
           DISPLAY STREAM REPORT
                   T-VENDEDOR.CLASE
                   T-TOTCONS
                   T-TOTCRES
                   X-PORCOMI
                   T-TOTCOND
                   T-TOTCRED
                   WITH FRAME F-CAB.               
           
           DOWN STREAM REPORT 1 WITH FRAME F-CAB.        
           TT-TOTCONS = TT-TOTCONS + T-TOTCONS.
           TT-TOTCRES = TT-TOTCRES + T-TOTCRES.
           TT-TOTCOND = TT-TOTCOND + T-TOTCOND.
           TT-TOTCRED = TT-TOTCRED + T-TOTCRED.
           T-TOTCONS  = 0.
           T-TOTCOND  = 0.
           T-TOTCRES  = 0.
           T-TOTCRED  = 0.

        END.
        
        IF LAST-OF (T-VENDEDOR.CODVEN) THEN DO:
           UNDERLINE STREAM REPORT T-TOTCONS
                                   T-TOTCRES
                                   T-TOTCOND
                                   T-TOTCRED
                                   WITH FRAME F-CAB. 
           DISPLAY STREAM REPORT
                   "Total x Vendedor : " @ T-VENDEDOR.NOMVEN          
                                   TT-TOTCONS @ T-TOTCONS
                                   TT-TOTCRES @ T-TOTCRES
                                   TT-TOTCOND @ T-TOTCOND
                                   TT-TOTCRED @ T-TOTCRED
                                   WITH FRAME F-CAB. 
               
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.
           TT-TOTCONS  = 0.
           TT-TOTCOND  = 0.
           TT-TOTCRES  = 0.
           TT-TOTCRED  = 0.
                   
        END.
        /*
        IF LAST-OF (T-VENDEDOR.CODCIA) THEN DO:
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
           UNDERLINE STREAM REPORT T-VENDEDOR.TOTAL WITH FRAME F-CAB. 
           DISPLAY STREAM REPORT
                   "T  O  T  A  L  :  " @ T-VENDEDOR.NOMVEN
                   ACCUM TOTAL BY T-VENDEDOR.CODCIA T-VENDEDOR.TOTAL @ T-VENDEDOR.TOTAL 
                   WITH FRAME F-CAB.
        END.
        */
 END.
/* OUTPUT STREAM REPORT CLOSE.*/






END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Detalle-Categoria D-Dialog 
PROCEDURE Detalle-Categoria :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR L-SW AS LOGICAL INIT NO.
 DEFINE VAR T-TOTCONS  AS DECIMAL.
 DEFINE VAR T-TOTCRES  AS DECIMAL.
 DEFINE VAR T-TOTCOND  AS DECIMAL.
 DEFINE VAR T-TOTCRED  AS DECIMAL.
 DEFINE VAR TT-TOTCONS AS DECIMAL.
 DEFINE VAR TT-TOTCRES AS DECIMAL.
 DEFINE VAR TT-TOTCOND AS DECIMAL.
 DEFINE VAR TT-TOTCRED AS DECIMAL.
 DEFINE VAR X-PORCOMI  AS DECIMAL.
 DEFINE VAR X-CLASE    AS CHAR. 
 DEFINE VAR X-TITU     AS CHAR.

 X-TITU = "VENTAS POR VENDEDOR - CATEGORIA PRODUCTO - " + X-PUNTO.

 DEFINE FRAME f-cab
        T-VENDEDOR.CodVen   AT 02  FORMAT "x(3)"    
        T-VENDEDOR.nomven   AT 07  FORMAT "x(35)"
        T-VENDEDOR.Clase    AT 44  FORMAT "x(3)"  
        T-TOTCONS  FORMAT "->>,>>>,>>>,>>9.99"
        T-TOTCRES  FORMAT "->>,>>>,>>>,>>9.99"
        X-PORCOMI  FORMAT ">>9.99%"       
        T-TOTCOND  FORMAT "->>>,>>>,>>9.99"
        T-TOTCRED  FORMAT "->>>,>>>,>>9.99"
        
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
/*        {&PRN2} + {&PRN6A} + "DIVISION : " + f-punto AT 1 FORMAT "X(20)" F-DIRDIV AT 25 FORMAT "X(30)"  */
        {&PRN3} + {&PRN6B} + "Pagina: " AT 80 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN3} + {&PRN6B} + "Fecha : " AT 80 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN2} + {&PRN6A} + "MONEDA   : NUEVOS SOLES (SIN IGV)" At 1 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 80 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        "------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                         V     E     N     T     A                  C  O  M  I  S  I  O  N    " SKIP
        " Cod.        V  E  N  D  E  D  O  R       Clase          CONTADO          CREDITO        %         CONTADO          CREDITO   " SKIP
        "------------------------------------------------------------------------------------------------------------------------------" SKIP
/***      999  12345678901234567890123456789012345  999999  12345678901234567890123456789012345678901234567890 1234 99,999,999.99  999,999,999.99 ***/
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH t-vendedor NO-LOCK
          BREAK BY T-VENDEDOR.CODCIA
                BY T-VENDEDOR.CODVEN 
                BY T-VENDEDOR.CLASE :
                                 
     {&NEW-PAGE}.
     IF FIRST-OF ( T-VENDEDOR.CODVEN )   THEN DO:
     
        DISPLAY STREAM REPORT 
             T-VENDEDOR.codven   
             T-VENDEDOR.nomven    
             WITH FRAME F-Cab.
     END.     
        
/*     IF FIRST-OF (T-VENDEDOR.CLASE) THEN DO:
 *         DISPLAY STREAM REPORT
 *                 T-VENDEDOR.CLASE
 *                 WITH FRAME F-CAB.               
 * 
 *      END.*/
     IF (T-VENDEDOR.CLASE) <> "X" THEN DO:
        PUT STREAM REPORT T-VENDEDOR.Codmat AT 10 FORMAT "X(6)".
        PUT STREAM REPORT T-VENDEDOR.DesMat AT 17 FORMAT "X(45)".
        PUT STREAM REPORT T-VENDEDOR.Unidad AT 62 FORMAT "X(6)".
        PUT STREAM REPORT T-VENDEDOR.Cantidad AT 70 FORMAT "->>>,>>>,>>9.99".
        PUT STREAM REPORT T-VENDEDOR.Totsol   AT 85 FORMAT "->>>,>>>,>>9.99" SKIP.
     END.
        IF T-VENDEDOR.FMAPGO = "000" THEN
         ASSIGN T-TOTCONS = T-TOTCONS + T-VENDEDOR.TOTSOL
                /*T-TOTCOND = T-TOTCOND + T-VENDEDOR.TOTDOL*/.

        IF T-VENDEDOR.FMAPGO = "107" THEN
         ASSIGN T-TOTCRES = T-TOTCRES + T-VENDEDOR.TOTSOL
               /* T-TOTCRED = T-TOTCRED + T-VENDEDOR.TOTDOL*/.

        IF LAST-OF (T-VENDEDOR.CLASE) THEN DO:
        
           FIND PORCOMI WHERE PORCOMI.CODCIA = S-CODCIA AND
                              PORCOMI.CATEGO BEGINS T-VENDEDOR.CLASE
                              NO-LOCK NO-ERROR. 
           IF AVAILABLE PORCOMI THEN X-PORCOMI = PORCOMI.PORCOM.

           T-TOTCOND = T-TOTCONS * ( X-PORCOMI / 100 ). 
           T-TOTCRED = T-TOTCRES * ( X-PORCOMI / 100 ).
           
           DISPLAY STREAM REPORT
                   T-VENDEDOR.CLASE
                   T-TOTCONS
                   T-TOTCRES
                   X-PORCOMI
                   T-TOTCOND
                   T-TOTCRED
                   WITH FRAME F-CAB.               
           
           DOWN STREAM REPORT 1 WITH FRAME F-CAB.        
           TT-TOTCONS = TT-TOTCONS + T-TOTCONS.
           TT-TOTCRES = TT-TOTCRES + T-TOTCRES.
           TT-TOTCOND = TT-TOTCOND + T-TOTCOND.
           TT-TOTCRED = TT-TOTCRED + T-TOTCRED.
           T-TOTCONS  = 0.
           T-TOTCOND  = 0.
           T-TOTCRES  = 0.
           T-TOTCRED  = 0.

        END.
        
        IF LAST-OF (T-VENDEDOR.CODVEN) THEN DO:
           UNDERLINE STREAM REPORT T-TOTCONS
                                   T-TOTCRES
                                   T-TOTCOND
                                   T-TOTCRED
                                   WITH FRAME F-CAB. 
           DISPLAY STREAM REPORT
                   "Total x Vendedor : " @ T-VENDEDOR.NOMVEN          
                                   TT-TOTCONS @ T-TOTCONS
                                   TT-TOTCRES @ T-TOTCRES
                                   TT-TOTCOND @ T-TOTCOND
                                   TT-TOTCRED @ T-TOTCRED
                                   WITH FRAME F-CAB. 
               
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.
           TT-TOTCONS  = 0.
           TT-TOTCOND  = 0.
           TT-TOTCRES  = 0.
           TT-TOTCRED  = 0.
                   
        END.
        /*
        IF LAST-OF (T-VENDEDOR.CODCIA) THEN DO:
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
           UNDERLINE STREAM REPORT T-VENDEDOR.TOTAL WITH FRAME F-CAB. 
           DISPLAY STREAM REPORT
                   "T  O  T  A  L  :  " @ T-VENDEDOR.NOMVEN
                   ACCUM TOTAL BY T-VENDEDOR.CODCIA T-VENDEDOR.TOTAL @ T-VENDEDOR.TOTAL 
                   WITH FRAME F-CAB.
        END.
        */
 END.
/* OUTPUT STREAM REPORT CLOSE.*/






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
  DISPLAY F-articulo RADIO-SET-Tipo f-vendedor R-TIPO f-desde f-hasta x-CodFam 
          x-SubFam FILL-IN-1 RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE 
          RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE RECT-54 F-articulo RADIO-SET-Tipo f-vendedor R-TIPO f-desde f-hasta 
         x-CodFam x-SubFam B-imprime B-cancela Btn_Excel RADIO-SET-1 
         B-impresoras RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
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

DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook         AS COM-HANDLE.
DEFINE VARIABLE chWorksheet        AS COM-HANDLE.
DEFINE VARIABLE iCount             AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn            AS CHARACTER.
DEFINE VARIABLE cRange             AS CHARACTER.

DEFINE VAR T-TOTSCONS AS DECIMAL.
DEFINE VAR T-TOTSCRES AS DECIMAL.
DEFINE VAR T-TOTCONS  AS DECIMAL.
DEFINE VAR T-TOTCRES  AS DECIMAL.
DEFINE VAR T-TOTCOND  AS DECIMAL.
DEFINE VAR T-TOTCRED  AS DECIMAL.
DEFINE VAR X-PORCOMI  AS DECIMAL.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN f-vendedor R-tipo f-articulo f-desde f-hasta RADIO-SET-Tipo
    x-CodFam x-SubFam.
END.

IF R-Tipo = 1 THEN RUN CARGA-TABLA-DIVI.
ELSE RUN CARGA-TABLA.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
cColumn = STRING(iCount).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "CODIGO".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "NOMBRE".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "FAMILIA".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "SUB-FAMILIA".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "CONTADO".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "CREDITO".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "% COMISION".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "CONTADO".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "CREDITO".

chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("C"):NumberFormat = "@".
chWorkSheet:Columns("D"):NumberFormat = "@".
chWorkSheet:Columns("B"):ColumnWidth = 45.
chWorkSheet:Range("A1:I1"):Font:Bold = TRUE.

FOR EACH t-vendedor NO-LOCK
    BREAK BY T-VENDEDOR.CODCIA
    BY T-VENDEDOR.CODVEN
    BY T-VENDEDOR.CODFAM
    BY T-VENDEDOR.SUBFAM:
    IF T-VENDEDOR.FMAPGO = "000" THEN
        ASSIGN
            T-TOTCONS = T-TOTCONS + T-VENDEDOR.TOTSOL
            T-TOTSCONS = T-TOTSCONS + T-VENDEDOR.TOTSOL.
    IF T-VENDEDOR.FMAPGO = "107" THEN
        ASSIGN
            T-TOTCRES = T-TOTCRES + T-VENDEDOR.TOTSOL
            T-TOTSCRES = T-TOTSCRES + T-VENDEDOR.TOTSOL.
    IF LAST-OF (T-VENDEDOR.SUBFAM) THEN DO:
        iCount = iCount + 1.
        FIND PORCOMI WHERE
            PORCOMI.CODCIA = S-CODCIA AND
            PORCOMI.CATEGO BEGINS T-VENDEDOR.CLASE
            NO-LOCK NO-ERROR.
        IF AVAILABLE PORCOMI THEN X-PORCOMI = PORCOMI.PORCOM.
        T-TOTCOND = T-TOTSCONS * ( X-PORCOMI / 100 ).
        T-TOTCRED = T-TOTSCRES * ( X-PORCOMI / 100 ).

        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = T-VENDEDOR.codven.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = T-VENDEDOR.nomven.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = T-VENDEDOR.CODFAM.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = T-VENDEDOR.SUBFAM.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = T-TOTSCONS.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = T-TOTSCRES.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = X-PORCOMI.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = T-TOTCOND.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = T-TOTCRED.

        T-TOTSCONS = 0.
        T-TOTSCRES = 0.
    END.
END.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

MESSAGE 'Reporte Terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Familia-Vendedor D-Dialog 
PROCEDURE Familia-Vendedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR L-SW AS LOGICAL INIT NO.
    DEFINE VAR T-TOTSCONS AS DECIMAL.
    DEFINE VAR T-TOTSCRES AS DECIMAL.
    DEFINE VAR T-TOTCONS  AS DECIMAL.
    DEFINE VAR T-TOTCRES  AS DECIMAL.
    DEFINE VAR T-TOTCOND  AS DECIMAL.
    DEFINE VAR T-TOTCRED  AS DECIMAL.
    DEFINE VAR TT-TOTCONS AS DECIMAL.
    DEFINE VAR TT-TOTCRES AS DECIMAL.
    DEFINE VAR TT-TOTCOND AS DECIMAL.
    DEFINE VAR TT-TOTCRED AS DECIMAL.
    DEFINE VAR X-PORCOMI  AS DECIMAL.
    DEFINE VAR X-CLASE    AS CHAR. 
    DEFINE VAR X-TITU     AS CHAR.

    X-TITU = "VENTAS POR VENDEDOR - FAMILIA DE PRODUCTO - " + X-PUNTO.

    DEFINE FRAME f-cab
        T-VENDEDOR.CodVen   AT 02  FORMAT "x(3)"
        T-VENDEDOR.nomven   AT 07  FORMAT "x(35)"
        T-VENDEDOR.CodFam   AT 44  FORMAT "x(6)"
        T-TOTCONS  FORMAT "->>,>>>,>>>,>>9.99"
        T-TOTCRES  FORMAT "->>,>>>,>>>,>>9.99"
        X-PORCOMI  FORMAT ">>9.99%"
        T-TOTCOND  FORMAT "->>>,>>>,>>9.99"
        T-TOTCRED  FORMAT "->>>,>>>,>>9.99"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
        {&PRN3} + {&PRN6B} + "Pagina: " AT 80 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN3} + {&PRN6B} + "Fecha : " AT 80 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN2} + {&PRN6A} + "MONEDA   : NUEVOS SOLES  (SIN IGV)" At 1 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 80 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        "-------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                              Sub         V     E     N     T     A                  C  O  M  I  S  I  O  N    " SKIP
        " Cod.        V  E  N  D  E  D  O  R        Familia        CONTADO          CREDITO        %         CONTADO          CREDITO   " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------" SKIP
/***      999  12345678901234567890123456789012345  999999  12345678901234567890123456789012345678901234567890 1234 99,999,999.99  999,999,999.99 ***/
        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

    FOR EACH t-vendedor NO-LOCK
        BREAK BY T-VENDEDOR.CODCIA
        BY T-VENDEDOR.CODVEN
        BY T-VENDEDOR.CODFAM
        BY T-VENDEDOR.SUBFAM:
        {&NEW-PAGE}.
        IF FIRST-OF(T-VENDEDOR.CODVEN) THEN DO:
            DISPLAY STREAM REPORT
                T-VENDEDOR.codven
                T-VENDEDOR.nomven
                WITH FRAME F-Cab.
        END.
        IF T-VENDEDOR.FMAPGO = "000" THEN
            ASSIGN
                T-TOTCONS = T-TOTCONS + T-VENDEDOR.TOTSOL
                T-TOTSCONS = T-TOTSCONS + T-VENDEDOR.TOTSOL.
        IF T-VENDEDOR.FMAPGO = "107" THEN
            ASSIGN
                T-TOTCRES = T-TOTCRES + T-VENDEDOR.TOTSOL
                T-TOTSCRES = T-TOTSCRES + T-VENDEDOR.TOTSOL.
        IF LAST-OF (T-VENDEDOR.SUBFAM) THEN DO:
            FIND PORCOMI WHERE
                PORCOMI.CODCIA = S-CODCIA AND
                PORCOMI.CATEGO BEGINS T-VENDEDOR.CLASE
                NO-LOCK NO-ERROR.
            IF AVAILABLE PORCOMI THEN X-PORCOMI = PORCOMI.PORCOM.
            T-TOTCOND = T-TOTSCONS * ( X-PORCOMI / 100 ).
            T-TOTCRED = T-TOTSCRES * ( X-PORCOMI / 100 ).
            DISPLAY STREAM REPORT
                "   " + T-VENDEDOR.SUBFAM @ T-VENDEDOR.CODFAM
                T-TOTSCONS @ T-TOTCONS
                T-TOTSCRES @ T-TOTCRES
                X-PORCOMI
                T-TOTCOND
                T-TOTCRED
                WITH FRAME F-CAB.
            DOWN STREAM REPORT WITH FRAME F-CAB.
            T-TOTSCONS = 0.
            T-TOTSCRES = 0.
        END.
        IF LAST-OF (T-VENDEDOR.CODFAM) THEN DO:
            FIND PORCOMI WHERE
                PORCOMI.CODCIA = S-CODCIA AND
                PORCOMI.CATEGO BEGINS T-VENDEDOR.CLASE
                NO-LOCK NO-ERROR.
            IF AVAILABLE PORCOMI THEN X-PORCOMI = PORCOMI.PORCOM.
            T-TOTCOND = T-TOTCONS * ( X-PORCOMI / 100 ).
            T-TOTCRED = T-TOTCRES * ( X-PORCOMI / 100 ).
            DISPLAY STREAM REPORT
                T-VENDEDOR.CODFAM
                T-TOTCONS
                T-TOTCRES
                X-PORCOMI
                T-TOTCOND
                T-TOTCRED
                WITH FRAME F-CAB.
            DOWN STREAM REPORT 1 WITH FRAME F-CAB.
            TT-TOTCONS = TT-TOTCONS + T-TOTCONS.
            TT-TOTCRES = TT-TOTCRES + T-TOTCRES.
            TT-TOTCOND = TT-TOTCOND + T-TOTCOND.
            TT-TOTCRED = TT-TOTCRED + T-TOTCRED.
            T-TOTCONS  = 0.
            T-TOTCRES  = 0.
        END.
        IF LAST-OF (T-VENDEDOR.CODVEN) THEN DO:
            UNDERLINE STREAM REPORT
                T-TOTCONS
                T-TOTCRES
                T-TOTCOND
                T-TOTCRED
                WITH FRAME F-CAB.
            DISPLAY STREAM REPORT
                "Total x Vendedor : " @ T-VENDEDOR.NOMVEN
                TT-TOTCONS @ T-TOTCONS
                TT-TOTCRES @ T-TOTCRES
                TT-TOTCOND @ T-TOTCOND
                TT-TOTCRED @ T-TOTCRED
                WITH FRAME F-CAB.
            DOWN STREAM REPORT 1 WITH FRAME F-CAB.
            TT-TOTCONS  = 0.
            TT-TOTCOND  = 0.
            TT-TOTCRES  = 0.
            TT-TOTCRED  = 0.
        END.
    END.

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
    
    IF R-Tipo = 1 THEN DO: 
       FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA AND
                      GN-DIVI.CodDiv = S-CODDIV
                      NO-LOCK NO-ERROR.
       X-PUNTO = GN-DIVI.Desdiv.
       RUN CARGA-TABLA-DIVI.
    END.     
    ELSE DO:
       X-PUNTO = 'COMPAÑIA'.      
       RUN CARGA-TABLA.
    END.                                    
    /*
    IF RADIO-SET-Tipo = 1 THEN
       RUN Reporte-Vendedor.    
    ELSE
       RUN Resumen-Vendedor.    
    */
    CASE RADIO-SET-Tipo:
     WHEN 1 THEN RUN Reporte-Vendedor.
     WHEN 2 THEN RUN Resumen-Vendedor.
     WHEN 3 THEN RUN Categoria-Vendedor.
     WHEN 4 THEN RUN Detalle-Categoria.
     WHEN 5 THEN RUN Familia-Vendedor.
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
        WHEN "x-SubFam"  THEN 
            ASSIGN
              input-var-1 = x-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}
              input-var-2 = ""
              input-var-3 = "".
              
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reporte-Vendedor D-Dialog 
PROCEDURE Reporte-Vendedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR L-SW AS LOGICAL INIT NO.
 DEFINE VAR X-TITU AS CHAR.

 X-TITU = "VENTAS POR VENDEDOR - DETALLE PRODUCTO - " + X-PUNTO.

 DEFINE FRAME f-cab
     T-VENDEDOR.CodVen   FORMAT "x(3)"      COLUMN-LABEL 'Cod'
     T-VENDEDOR.nomven   FORMAT "x(35)"     COLUMN-LABEL 'V E N D E D O R'
     T-VENDEDOR.CodMat   FORMAT "x(6)"      COLUMN-LABEL 'Articulo'
     T-VENDEDOR.DesMat   FORMAT "x(50)"     COLUMN-LABEL 'D E S C R I P C I O N'
     T-VENDEDOR.Unidad   FORMAT "x(4)"      COLUMN-LABEL 'Und'
     T-VENDEDOR.CodFam   FORMAT "x(4)"      COLUMN-LABEL 'Familia'
     T-VENDEDOR.SubFam   FORMAT "x(4)"      COLUMN-LABEL 'Sub.Familia'
     T-VENDEDOR.Cantidad FORMAT "->>,>>>,>>9.99"  COLUMN-LABEL 'Cant. Vendida'
     T-VENDEDOR.TOTAL    FORMAT "->>>,>>>,>>>.99" COLUMN-LABEL 'T O T A L'
     HEADER
     {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
     {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
     {&PRN3} + {&PRN6B} + "Pagina: " AT 100 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
     {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
     {&PRN3} + {&PRN6B} + "Fecha : " AT 100 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
     {&PRN2} + {&PRN6A} + "MONEDA   : NUEVOS SOLES (SIN IGV)" At 1 FORMAT "X(35)"
     {&PRN3} + {&PRN6B} + "Hora  : " AT 100 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
     WITH WIDTH 165 NO-BOX STREAM-IO DOWN.

  FOR EACH t-vendedor NO-LOCK BREAK BY T-VENDEDOR.CODCIA BY T-VENDEDOR.CODVEN BY T-VENDEDOR.CodMat :
     {&NEW-PAGE}.
     ACCUMULATE T-VENDEDOR.TOTAL ( SUB-TOTAL BY T-VENDEDOR.CODVEN ).
     ACCUMULATE T-VENDEDOR.TOTAL ( TOTAL     BY T-VENDEDOR.CODCIA ). 
     IF FIRST-OF ( T-VENDEDOR.CODVEN ) THEN DO:
         DISPLAY STREAM REPORT 
             T-VENDEDOR.codven 
             T-VENDEDOR.nomven 
             WITH FRAME F-Cab.
             DOWN STREAM REPORT WITH FRAME F-CAB.        
     END. 
     DISPLAY STREAM REPORT 
       T-VENDEDOR.CodMat
       T-VENDEDOR.DesMat
       T-VENDEDOR.Unidad
       T-VENDEDOR.CodFam
       T-VENDEDOR.SubFam
       T-VENDEDOR.Cantidad 
       T-VENDEDOR.TOTAL   
       WITH FRAME F-Cab.
     IF LAST-OF (T-VENDEDOR.CODVEN) THEN DO:
          UNDERLINE STREAM REPORT T-VENDEDOR.TOTAL WITH FRAME F-CAB. 
          DISPLAY STREAM REPORT
                  "Total x Vendedor : " @ T-VENDEDOR.DESMAT            
                  ACCUM SUB-TOTAL BY T-VENDEDOR.CODVEN T-VENDEDOR.TOTAL @ T-VENDEDOR.TOTAL 
                  WITH FRAME F-CAB.               
          DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
     END.
     IF LAST-OF (T-VENDEDOR.CODCIA) THEN DO:
          DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
          UNDERLINE STREAM REPORT T-VENDEDOR.TOTAL WITH FRAME F-CAB. 
          DISPLAY STREAM REPORT
                  "T  O  T  A  L  :  " @ T-VENDEDOR.DESMAT
                  ACCUM TOTAL BY T-VENDEDOR.CODCIA T-VENDEDOR.TOTAL @ T-VENDEDOR.TOTAL 
                  WITH FRAME F-CAB.
     END.
  END.

END PROCEDURE.

/*
 DEFINE VAR L-SW AS LOGICAL INIT NO.
 DEFINE VAR X-TITU AS CHAR.
 X-TITU = "VENTAS POR VENDEDOR - DETALLE PRODUCTO - " + X-PUNTO.
 DEFINE FRAME f-cab
        T-VENDEDOR.CodVen AT 02  FORMAT "x(3)"    
        T-VENDEDOR.nomven AT 07  FORMAT "x(35)"
        T-VENDEDOR.CodMat AT 44  FORMAT "x(6)"  
        T-VENDEDOR.DesMat AT 53  FORMAT "x(50)"   
        T-VENDEDOR.Unidad AT 103 FORMAT "x(4)"   
        T-VENDEDOR.Cantidad AT 108 FORMAT "->>,>>>,>>9.99"
        T-VENDEDOR.TOTAL    AT 124 FORMAT "->>>,>>>,>>>.99"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
       /* {&PRN2} + {&PRN6A} + "DIVISION : " + f-punto AT 1 FORMAT "X(20)" F-DIRDIV AT 25 FORMAT "X(30)"  */
        {&PRN3} + {&PRN6B} + "Pagina: " AT 100 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN3} + {&PRN6B} + "Fecha : " AT 100 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN2} + {&PRN6A} + "MONEDA   : NUEVOS SOLES" At 1 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 100 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " Cod.        V  E  N  D  E  D  O  R       Articulo          D  E  S  C  R  I  P  C  I  O  N           UND. Cant. Vendida   T O T A L   Cod. Nrodoc FchDoc  " SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***      999  12345678901234567890123456789012345  999999  12345678901234567890123456789012345678901234567890 1234 99,999,999.99  999,999,999.99 ***/
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH t-vendedor NO-LOCK
          BREAK BY T-VENDEDOR.CODCIA
                BY T-VENDEDOR.CODVEN
                BY T-VENDEDOR.CodMat :
                                 
     {&NEW-PAGE}.
     ACCUMULATE T-VENDEDOR.TOTAL ( SUB-TOTAL BY T-VENDEDOR.CODVEN ).
     ACCUMULATE T-VENDEDOR.TOTAL ( TOTAL     BY T-VENDEDOR.CODCIA ). 

     IF FIRST-OF ( T-VENDEDOR.CODVEN ) THEN DO:
      DISPLAY STREAM REPORT 
        T-VENDEDOR.codven 
        T-VENDEDOR.nomven 
        WITH FRAME F-Cab.
        DOWN STREAM REPORT WITH FRAME F-CAB.        
        
      END. 

      DISPLAY STREAM REPORT 
        T-VENDEDOR.CodMat
        T-VENDEDOR.DesMat
        T-VENDEDOR.Unidad
        T-VENDEDOR.Cantidad 
        T-VENDEDOR.TOTAL   
        WITH FRAME F-Cab.
        
      IF LAST-OF (T-VENDEDOR.CODVEN) THEN DO:
           UNDERLINE STREAM REPORT T-VENDEDOR.TOTAL WITH FRAME F-CAB. 
           DISPLAY STREAM REPORT
                   "Total x Vendedor : " @ T-VENDEDOR.DESMAT            
                   ACCUM SUB-TOTAL BY T-VENDEDOR.CODVEN T-VENDEDOR.TOTAL @ T-VENDEDOR.TOTAL 
                   WITH FRAME F-CAB.               
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
      END.
      IF LAST-OF (T-VENDEDOR.CODCIA) THEN DO:
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
           UNDERLINE STREAM REPORT T-VENDEDOR.TOTAL WITH FRAME F-CAB. 
           DISPLAY STREAM REPORT
                   "T  O  T  A  L  :  " @ T-VENDEDOR.DESMAT
                   /*ACCUM TOTAL BY T-VENDEDOR.CODCIA T-VENDEDOR.Cantidad @ T-VENDEDOR.Cantidad */
                   ACCUM TOTAL BY T-VENDEDOR.CODCIA T-VENDEDOR.TOTAL @ T-VENDEDOR.TOTAL 
                   WITH FRAME F-CAB.
      END.
  END.

*/

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
X-TITU = "VENTAS POR VENDEDOR - RESUMEN - " + X-PUNTO.
 DEFINE FRAME f-cab
        T-VENDEDOR.CodVen AT 02 FORMAT "x(3)"    
        T-VENDEDOR.nomven AT 07 FORMAT "x(35)"
        T-VENDEDOR.TOTSOL AT 46 FORMAT "->>>,>>>,>>>.99" COLUMN-LABEL "TOTAL SOLES"
       /* T-VENDEDOR.TOTDOL AT 61 FORMAT "->>>,>>>,>>>.99" COLUMN-LABEL "TOTAL DOLARES"*/
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU  + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
/*        {&PRN2} + {&PRN6A} + "DIVISION : " + f-punto AT 1 FORMAT "X(20)" F-DIRDIV AT 25 FORMAT "X(30)"  */
        {&PRN3} + {&PRN6B} + "Pagina: " AT 80 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN3} + {&PRN6B} + "Fecha : " AT 80 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN2} + {&PRN6A} + "MONEDA   : NUEVOS SOLES (SIN IGV)" At 1 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 80 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        "-------------------------------------------------------------------------------------------------------" SKIP
        " Cod.        V  E  N  D  E  D  O  R              T O T A L                                             " SKIP
        "-------------------------------------------------------------------------------------------------------" SKIP
/***      999  12345678901234567890123456789012345    99,999,999.99     999,999,999.99 ***/
  
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH t-vendedor NO-LOCK
          BREAK BY T-VENDEDOR.CODCIA
                BY T-VENDEDOR.CODVEN :
                                 
        ACCUMULATE T-VENDEDOR.TOTSOL ( SUB-TOTAL BY T-VENDEDOR.CODVEN ).
      /*  ACCUMULATE T-VENDEDOR.TOTDOL ( SUB-TOTAL BY T-VENDEDOR.CODVEN ).*/
        ACCUMULATE T-VENDEDOR.TOTSOL ( TOTAL     BY T-VENDEDOR.CODCIA ). 
/*        ACCUMULATE T-VENDEDOR.TOTDOL ( TOTAL     BY T-VENDEDOR.CODCIA ). */
        
        IF LAST-OF (T-VENDEDOR.CODVEN) THEN DO:
           {&NEW-PAGE}.
           DISPLAY STREAM REPORT 
                   T-VENDEDOR.codven 
                   T-VENDEDOR.nomven 
                   ACCUM SUB-TOTAL BY T-VENDEDOR.CODVEN T-VENDEDOR.TOTSOL @ T-VENDEDOR.TOTSOL 
/*                   ACCUM SUB-TOTAL BY T-VENDEDOR.CODVEN T-VENDEDOR.TOTDOL @ T-VENDEDOR.TOTDOL*/ 
                   WITH FRAME F-Cab.
           DOWN STREAM REPORT 1 WITH FRAME F-CAB.        
        END.
        IF LAST-OF (T-VENDEDOR.CODCIA) THEN DO:
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
           UNDERLINE STREAM REPORT T-VENDEDOR.TOTSOL  WITH FRAME F-CAB. 
           DISPLAY STREAM REPORT
                   "T  O  T  A  L  :  " @ T-VENDEDOR.NomVen
                   ACCUM TOTAL BY T-VENDEDOR.CODCIA T-VENDEDOR.TOTSOL @ T-VENDEDOR.TOTSOL 
                /*   ACCUM TOTAL BY T-VENDEDOR.CODCIA T-VENDEDOR.TOTDOL @ T-VENDEDOR.TOTDOL */
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

